/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 *
 * DESCRIPTION:
 * Widgets.
 * The widget layer of the application holding every widget container and widget.
 *
 * MAIN FEATURES:
 * - a content multiple object storing one content per widget container
 * - widgets can be added, closed and moved between the containers
 * - automatic widget positioning driven by the widgets orientation
 * - the widgets are resized to their desktop or to their mobile dimensions
 * - one widget of a container can stand in fullscreen, covering the whole room of it
 * - navigation between the widgets and scrolling the active one into the view
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseEventDispatcher;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import flash.events.Event;
  public class Widgets extends BaseSprite
  {
    private var currentWidgetId:int = -1;
    private var contentMultiple:ContentMultiple = null;
    private var widgetsArray:Array = null;
    private var widgetWidths:Array = null;
    private var widgetHeights:Array = null;
    private var actualWidgets:Array = null;
    private var orientationsArray:Array = null;
    /**
     * Constructs the Widgets object and creates the content multiple holding the containers.
     * @param applicationRef the main application reference
     */
    public function Widgets(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Widgets> called.", 1);
      application.trace("<" + this + " Widgets> applicationRef: " + applicationRef, 0);
      widgetsArray = new Array();
      widgetWidths = new Array();
      widgetHeights = new Array();
      actualWidgets = new Array();
      orientationsArray = new Array();
      contentMultiple = new ContentMultiple(application);
      addChild(contentMultiple);
      contentMultiple.setButtonBarVisible(false);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_ORIENTATION_CHANGED(), widgetsOrientationChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), widgetModeChanged);
      application.trace("<" + this + " Widgets> constructed.", 1);
    }
    /**
     * Creates a new widget container and makes it the active one.
     */
    public function addWidgetContainer():int
    {
      application.trace("<" + this + " Widgets addWidgetContainer> called.", 1);
      const containerId:int = contentMultiple.addContent("" + contentMultiple.getNumOfContents());
      widgetsArray[containerId] = new Array();
      orientationsArray[containerId] = application.getDynamicsConfig().getAppOrientation();
      setActiveWidgetContainer(containerId);
      return containerId;
    }
    /**
     * Removes the last widget container after moving its widgets into the previous one.
     */
    public function removeWidgetContainer():void
    {
      application.trace("<" + this + " Widgets removeWidgetContainer> called.", 1);
      const containerId:int = contentMultiple.getNumOfContents() - 1;
      if (containerId > 0)
      {
        moveAllWidgetsFromContent(containerId);
        contentMultiple.removeContent(containerId);
        widgetsArray.splice(containerId, 1);
        actualWidgets.splice(containerId, 1);
        orientationsArray.splice(containerId, 1);
        setActiveWidgetContainer(containerId - 1);
      }
    }
    /**
     * Makes the given widget container the active one.
     * @param index the index of the widget container to be activated
     */
    public function setActiveWidgetContainer(index:int):void
    {
      application.trace("<" + this + " Widgets setActiveWidgetContainer> called.", 1);
      application.trace("<" + this + " Widgets setActiveWidgetContainer> index: " + index, 0);
      if (index >= 0 && index < orientationsArray.length)
      {
        if (contentMultiple.getActiveIndex() != index)
        {
          contentMultiple.setActiveIndex(index);
          goToTheWidget(actualWidgets[index]);
        }
      }
    }
    /**
     * Returns the widgets orientation of the given widget container.
     * @param index the index of the widget container the orientation is asked of
     */
    public function getWidgetOrientation(index:int):String
    {
      return orientationsArray[index];
    }
    /**
     * Returns the number of the widget containers.
     */
    public function getNumOfContents():int
    {
      return contentMultiple.getNumOfContents();
    }
    /**
     * Returns the number of the widgets of every widget container together.
     */
    public function getNumOfAllWidgets():int
    {
      application.trace("<" + this + " Widgets getNumOfAllWidgets> called.", 1);
      var num:int = 0;
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        num += widgetsArray[i].length;
      }
      return num;
    }
    /**
     * Returns the widget having the given widget id or null if there is no such widget.
     * @param id the widget id the widget is searched by
     */
    public function getWidgetById(id:int):Widget
    {
      application.trace("<" + this + " Widgets getWidgetById> called.", 1);
      application.trace("<" + this + " Widgets getWidgetById> id: " + id, 0);
      var widget:Widget = null;
      all: for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          if (Widget(widgetsArray[i][j]).getWidgetId() == id)
          {
            widget = Widget(widgetsArray[i][j]);
            break all;
          }
        }
      }
      return widget;
    }
    /**
     * Returns the widget having the given header or null if there is no such widget.
     * @param header the widget header the widget is searched by
     */
    public function getWidgetByHeader(header:String):Widget
    {
      application.trace("<" + this + " Widgets getWidgetByHeader> called.", 1);
      application.trace("<" + this + " Widgets getWidgetByHeader> header: " + header, 0);
      var widget:Widget = null;
      all: for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          if (Widget(widgetsArray[i][j]).getWidgetHeader() == header)
          {
            widget = Widget(widgetsArray[i][j]);
            break all;
          }
        }
      }
      return widget;
    }
    /**
     * Returns the widget having the given value or null if there is no such widget.
     * @param val the widget value the widget is searched by
     */
    public function getWidgetByValue(val:String):Widget
    {
      application.trace("<" + this + " Widgets getWidgetByValue> called.", 1);
      application.trace("<" + this + " Widgets getWidgetByValue> val: " + val, 0);
      var widget:Widget = null;
      all: for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          try
          {
            if (Widget(widgetsArray[i][j]).getValue().toString() == val)
            {
              widget = Widget(widgetsArray[i][j]);
              break all;
            }
          }
          catch (e:*)
          {
            application.trace("<" + this + " Widgets getWidgetByValue> the value of the widget could not be read: " + e, 7);
            continue;
          }
        }
      }
      return widget;
    }
    /**
     * Returns the headers of every widget of every widget container.
     */
    public function getWidgetHeaders():Array
    {
      application.trace("<" + this + " Widgets getWidgetHeaders> called.", 1);
      const headers:Array = new Array();
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          headers.push(Widget(widgetsArray[i][j]).getWidgetHeader());
        }
      }
      return headers;
    }
    /**
     * Returns the widget ids of every widget of every widget container.
     */
    public function getWidgetIds():Array
    {
      application.trace("<" + this + " Widgets getWidgetIds> called.", 1);
      const ids:Array = new Array();
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          ids.push(Widget(widgetsArray[i][j]).getWidgetId());
        }
      }
      return ids;
    }
    /**
     * Adds a new widget into the given widget container and goes to it.
     * @param contentId the index of the widget container the widget is added into
     * @param widget the widget to be added
     */
    public function addWidget(contentId:int, widget:Widget):void
    {
      application.trace("<" + this + " Widgets addWidget> called.", 1);
      application.trace("<" + this + " Widgets addWidget> contentId: " + contentId, 0);
      application.trace("<" + this + " Widgets addWidget> widget: " + widget, 0);
      if (widget != null)
      {
        widget.setContentId(contentId);
        contentMultiple.addToContent(contentId, widget, widgetsArray.length);
        widgetsArray[contentId].push(widget);
        widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), widgetResized);
        widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COORDINATES_CHANGED(), widgetRepositioned);
        widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_CLOSE_ME(), widgetCloseMe);
        widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_DRAG_START(), widgetDragStart);
        widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_DRAG_STOP(), widgetDragStop);
        widget.setWidgetId(getNextWidgetId());
        widget.setButtonMoveVisible(getNumOfContents() != 1);
        if (orientationsArray[contentId] == EnumOrientations.ORIENTATION_MANUAL())
        {
          widget.setCxy(application.getComponentsConfig().getWidgetsMargin(), application.getComponentsConfig().getWidgetsMargin());
          reposWidgets(contentId);
        }
        else
        {
          reposWidget(widget);
          widget.updateCxy();
          application.callContentDimensionsRecalculation(widget);
        }
        if (application.getDynamicsConfig().weAreInDesktopMode())
        {
          widget.setDesktopSizes();
        }
        else
        {
          widget.setMobileSizes();
        }
        actualizeButtonsVisible(contentId);
        goToTheWidget(widget);
      }
    }
    /**
     * Closes and destroys the given widget if it allows to be closed.
     * @param widget the widget to be closed
     */
    public function closeWidget(widget:Widget):void
    {
      application.trace("<" + this + " Widgets closeWidget> called.", 1);
      application.trace("<" + this + " Widgets closeWidget> widget: " + widget, 0);
      if (widget != null)
      {
        if (widget.onClose())
        {
          const contentId:int = widget.getContentId();
          const widgetIndex:int = widgetsArray[contentId].indexOf(widget);
          widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), widgetResized);
          widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_COORDINATES_CHANGED(), widgetRepositioned);
          widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_CLOSE_ME(), widgetCloseMe);
          widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_DRAG_START(), widgetDragStart);
          widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_DRAG_STOP(), widgetDragStop);
          contentMultiple.removeFromContent(contentId, widget);
          widget.destroy();
          widgetsArray[contentId].splice(widgetIndex, 1);
          delete widgetWidths[widget];
          delete widgetHeights[widget];
          reposWidgets(contentId);
          if (actualWidgets[contentId] == widget)
          {
            if (widgetIndex > 0)
            {
              actualWidgets[contentId] = widgetsArray[contentId][widgetIndex - 1];
            }
            else
            {
              actualWidgets[contentId] = null;
            }
          }
          goToTheWidget(actualWidgets[contentId]);
        }
      }
    }
    /**
     * Moves a widget from one widget container into another one.
     * @param fromContentId the index of the widget container the widget is moved from
     * @param toContentId the index of the widget container the widget is moved into
     * @param widget the widget to be moved
     * @param repositionRequired true if both widget containers have to be repositioned
     */
    public function moveWidgetFromContent(fromContentId:int, toContentId:int, widget:Widget, repositionRequired:Boolean):void
    {
      application.trace("<" + this + " Widgets moveWidgetFromContent> called.", 1);
      application.trace("<" + this + " Widgets moveWidgetFromContent> fromContentId: " + fromContentId, 0);
      application.trace("<" + this + " Widgets moveWidgetFromContent> toContentId: " + toContentId, 0);
      application.trace("<" + this + " Widgets moveWidgetFromContent> widget: " + widget, 0);
      application.trace("<" + this + " Widgets moveWidgetFromContent> repositionRequired: " + repositionRequired, 0);
      const indexOnFrom:int = widgetsArray[fromContentId].indexOf(widget);
      const countOnFrom:int = widgetsArray[fromContentId].length;
      widgetsArray[fromContentId].splice(indexOnFrom, 1);
      widgetsArray[toContentId].push(widget);
      contentMultiple.removeFromContent(fromContentId, widget);
      contentMultiple.addToContent(toContentId, widget, 0);
      widget.setContentId(toContentId);
      if (repositionRequired)
      {
        reposWidgets(fromContentId);
        reposWidgets(toContentId);
      }
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().setActiveWidgetContainer(toContentId);
      }
      actualWidgets[fromContentId] = countOnFrom > 1 ? Widget(widgetsArray[fromContentId][Math.max(0, indexOnFrom - 1)]) : null;
      actualWidgets[toContentId] = widget;
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        widget.setDesktopSizes();
      }
      else
      {
        widget.setMobileSizes();
      }
      actualizeButtonsVisible(fromContentId);
      actualizeButtonsVisible(toContentId);
      // the widget that has been moved away can be the very one that covered the container
      // it has been taken out of, so the widgets left there are displayed again
      refreshFullscreenOfContent(fromContentId);
      goToTheWidget(actualWidgets[toContentId]);
    }
    /**
     * Goes to the widget being the actual one in the active widget container.
     */
    public function goToTheActualWidget():void
    {
      application.trace("<" + this + " Widgets goToTheActualWidget> called.", 1);
      goToTheWidget(actualWidgets[contentMultiple.getActiveIndex()]);
    }
    /**
     * Makes the given widget the actual one and scrolls it into the view.
     * @param widget the widget to be gone to
     */
    public function goToTheWidget(widget:Widget):void
    {
      application.trace("<" + this + " Widgets goToTheWidget> called.", 1);
      application.trace("<" + this + " Widgets goToTheWidget> widget: " + widget, 0);
      if (widget != null)
      {
        const widgetsMargin:int = application.getComponentsConfig().getWidgetsMargin();
        actualWidgets[widget.getContentId()] = widget;
        setActiveWidgetContainer(widget.getContentId());
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().setActiveWidgetContainer(widget.getContentId());
        }
        // the widget that has just been gone to can be the fullscreen one of its container
        // and it can be the one that takes the room of that fullscreen back as well, so
        // the widgets of the container are laid out before this one is put into the view
        refreshFullscreenOfContent(widget.getContentId());
        if (application.getDynamicsConfig().weAreInDesktopMode()
          && fullscreenWidgetOfContent(widget.getContentId()) == null)
        {
          const baseScroll:BaseScroll = contentMultiple.getBaseScroll(widget.getContentId());
          baseScroll.setContentPosition(widgetsMargin - widget.getCx(), widgetsMargin - widget.getCy(), true);
          // the scroll tells the widgets to follow it only when its own content position
          // really changes, so they are put to that position by hand as well: the mobile
          // mode moves them without that scroll, and this brings them back under it
          contentMultiple.getBaseSprite(widget.getContentId()).setCxy(baseScroll.getCxContent(), baseScroll.getCyContent());
        }
        else
        {
          // the container is not scrolled in mobile mode and it is not scrolled while one
          // widget of it stands in fullscreen either, so the widget that has been gone to
          // is put into the view by moving every widget of that container
          contentMultiple.getBaseSprite(widget.getContentId()).setCxy(-widget.getCx(), -widget.getCy());
        }
      }
    }
    /**
     * Goes to the widget standing before the given one in its widget container.
     * @param widget the widget the previous one is searched of
     */
    public function goToPrevWidget(widget:Widget):void
    {
      application.trace("<" + this + " Widgets goToPrevWidget> called.", 1);
      application.trace("<" + this + " Widgets goToPrevWidget> widget: " + widget, 0);
      const contentId:int = widget.getContentId();
      for (var i:int = 0; i < widgetsArray[contentId].length; i++)
      {
        if (Widget(widgetsArray[contentId][i]) == widget)
        {
          if (i > 0)
          {
            goToTheWidget(Widget(widgetsArray[contentId][i - 1]));
            break;
          }
        }
      }
    }
    /**
     * Goes to the widget standing after the given one in its widget container.
     * @param widget the widget the next one is searched of
     */
    public function goToNextWidget(widget:Widget):void
    {
      application.trace("<" + this + " Widgets goToNextWidget> called.", 1);
      application.trace("<" + this + " Widgets goToNextWidget> widget: " + widget, 0);
      const contentId:int = widget.getContentId();
      for (var i:int = 0; i < widgetsArray[contentId].length; i++)
      {
        if (Widget(widgetsArray[contentId][i]) == widget)
        {
          if (i < widgetsArray[contentId].length - 1)
          {
            goToTheWidget(Widget(widgetsArray[contentId][i + 1]));
            break;
          }
        }
      }
    }
    /**
     * Shows or hides the move button of every widget of every widget container.
     */
    public function changeButtonMoveVisibleOnAllWidgets():void
    {
      application.trace("<" + this + " Widgets changeButtonMoveVisibleOnAllWidgets> called.", 1);
      const visible:Boolean = getNumOfContents() != 1;
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          Widget(widgetsArray[i][j]).setButtonMoveVisible(visible);
        }
      }
    }
    /**
     * Saves the manually set dimensions of the given widget.
     * @param widget the widget the dimensions belong to
     * @param width the width to be saved
     * @param height the height to be saved
     */
    public function saveWidgetSizes(widget:Widget, width:int, height:int):void
    {
      application.trace("<" + this + " Widgets saveWidgetSizes> called.", 1);
      application.trace("<" + this + " Widgets saveWidgetSizes> widget: " + widget, 0);
      application.trace("<" + this + " Widgets saveWidgetSizes> width: " + width, 0);
      application.trace("<" + this + " Widgets saveWidgetSizes> height: " + height, 0);
      if (widget != null)
      {
        widgetWidths[widget] = width;
        widgetHeights[widget] = height;
      }
    }
    /**
     * Returns the saved width of the given widget or the minimal widget width.
     * @param widget the widget the saved width is asked of
     */
    public function getWidgetSavedWidth(widget:Widget):int
    {
      application.trace("<" + this + " Widgets getWidgetSavedWidth> called.", 1);
      application.trace("<" + this + " Widgets getWidgetSavedWidth> widget: " + widget, 0);
      if (widget != null)
      {
        return widgetWidths[widget];
      }
      return application.getComponentsConfig().getWidgetSizeMinWidth();
    }
    /**
     * Returns the saved height of the given widget or the minimal widget height.
     * @param widget the widget the saved height is asked of
     */
    public function getWidgetSavedHeight(widget:Widget):int
    {
      application.trace("<" + this + " Widgets getWidgetSavedHeight> called.", 1);
      application.trace("<" + this + " Widgets getWidgetSavedHeight> widget: " + widget, 0);
      if (widget != null)
      {
        return widgetHeights[widget];
      }
      return application.getComponentsConfig().getWidgetSizeMinHeight();
    }
    /**
     * Repositions and resizes this widget layer and every widget it holds.
     */
    public function widgetsRePosSize():void
    {
      application.trace("<" + this + " Widgets widgetsRePosSize> called.", 1);
      const appMargin:int = application.getDynamicsConfig().getAppMargin();
      if (application.getMiddleground() != null)
      {
        const widgetsDh:int = application.getMiddleground().getWidgetsDh();
        setCxy(0, application.getDh() - widgetsDh);
        super.setDwh(application.getDw(), widgetsDh);
      }
      contentMultiple.setCxy(appMargin, appMargin);
      contentMultiple.setDwh(getDw() - appMargin * 2, getDh() - appMargin * 2);
      resizeAllWidgetsAndGoTo();
    }
    /**
     * The width of this widget layer is driven by the application, so this call does nothing.
     * @param newdw the new width, not used here
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Widgets setDw> called.", 1);
      application.trace("<" + this + " Widgets setDw> newdw: " + newdw, 0);
    }
    /**
     * The height of this widget layer is driven by the application, so this call does nothing.
     * @param newdh the new height, not used here
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Widgets setDh> called.", 1);
      application.trace("<" + this + " Widgets setDh> newdh: " + newdh, 0);
    }
    /**
     * The dimensions of this widget layer are driven by the application, so this call does nothing.
     * @param newdw the new width, not used here
     * @param newdh the new height, not used here
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Widgets setDwh> called.", 1);
      application.trace("<" + this + " Widgets setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Widgets setDwh> newdh: " + newdh, 0);
    }
    /**
     * Returns the widget id to be given to the next widget.
     */
    private function getNextWidgetId():int
    {
      return ++currentWidgetId;
    }
    /**
     * Repositions and resizes everything after the application margin has been changed.
     * @param e the margin changed event
     */
    private function marginChanged(e:Event):void
    {
      application.trace("<" + this + " Widgets marginChanged> called.", 1);
      application.trace("<" + this + " Widgets marginChanged> e: " + e, 0);
      widgetsRePosSize();
    }
    /**
     * Resizes every widget after the widget mode has been changed.
     * @param e the widget mode changed event
     */
    private function widgetModeChanged(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetModeChanged> called.", 1);
      application.trace("<" + this + " Widgets widgetModeChanged> e: " + e, 0);
      resizeAllWidgetsAndGoTo();
    }
    /**
     * Repositions the active widget container after the widgets orientation has been changed.
     * @param e the widgets orientation changed event
     */
    private function widgetsOrientationChanged(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetsOrientationChanged> called.", 1);
      application.trace("<" + this + " Widgets widgetsOrientationChanged> e: " + e, 0);
      const activeIndex:int = contentMultiple.getActiveIndex();
      orientationsArray[activeIndex] = application.getDynamicsConfig().getAppOrientation();
      reposWidgets(activeIndex);
      goToTheWidget(actualWidgets[activeIndex]);
    }
    /**
     * Repositions the widget container of the widget that has just been resized.
     * @param e the dimensions changed event of a widget
     */
    private function widgetResized(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetResized> called.", 1);
      application.trace("<" + this + " Widgets widgetResized> e: " + e, 0);
      const widget:Widget = Widget(BaseEventDispatcher(e.target).getParentObject());
      if (application.getDynamicsConfig().getAppOrientation() != EnumOrientations.ORIENTATION_MANUAL())
      {
        e.stopImmediatePropagation();
      }
      reposWidgets(widget.getContentId());
    }
    /**
     * Swaps the widget that has just been dragged with the one it has been dropped onto.
     * @param e the coordinates changed event of a widget
     */
    private function widgetRepositioned(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetRepositioned> called.", 1);
      application.trace("<" + this + " Widgets widgetRepositioned> e: " + e, 0);
      const widget:Widget = Widget(BaseEventDispatcher(e.target).getParentObject());
      const contentId:int = widget.getContentId();
      if (application.getDynamicsConfig().getAppOrientation() != EnumOrientations.ORIENTATION_MANUAL())
      {
        e.stopImmediatePropagation();
      }
      var hitWidget:Widget = null;
      for (var j:int = 0; j < widgetsArray[contentId].length; j++)
      {
        if (widget != Widget(widgetsArray[contentId][j]) && widget.hitTestObject(Widget(widgetsArray[contentId][j])))
        {
          hitWidget = Widget(widgetsArray[contentId][j]);
          break;
        }
      }
      if (hitWidget != null)
      {
        swapWidgets(widget, hitWidget);
      }
      reposWidgets(contentId);
    }
    /**
     * Closes the widget that has asked to be closed.
     * @param e the widget close me event
     */
    private function widgetCloseMe(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetCloseMe> called.", 1);
      application.trace("<" + this + " Widgets widgetCloseMe> e: " + e, 0);
      const widget:Widget = Widget(BaseEventDispatcher(e.target).getParentObject());
      e.stopImmediatePropagation();
      closeWidget(widget);
    }
    /**
     * Blurs the other widgets when the dragging of a widget has been started.
     * @param e the widget drag start event
     */
    private function widgetDragStart(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetDragStart> called.", 1);
      application.trace("<" + this + " Widgets widgetDragStart> e: " + e, 0);
      const widget:Widget = Widget(BaseEventDispatcher(e.target).getParentObject());
      e.stopImmediatePropagation();
      setOrClearGlow(widget.getContentId(), widget);
    }
    /**
     * Clears the blur of every widget when the dragging of a widget has been stopped.
     * @param e the widget drag stop event
     */
    private function widgetDragStop(e:Event):void
    {
      application.trace("<" + this + " Widgets widgetDragStop> called.", 1);
      application.trace("<" + this + " Widgets widgetDragStop> e: " + e, 0);
      const widget:Widget = Widget(BaseEventDispatcher(e.target).getParentObject());
      e.stopImmediatePropagation();
      setOrClearGlow(widget.getContentId(), null);
    }
    /**
     * Blurs every widget of a widget container except the given one.
     * @param contentId the index of the widget container to be handled
     * @param widget the widget to be kept sharp, null if every blur has to be cleared
     */
    private function setOrClearGlow(contentId:int, widget:Widget):void
    {
      application.trace("<" + this + " Widgets setOrClearGlow> called.", 1);
      application.trace("<" + this + " Widgets setOrClearGlow> contentId: " + contentId, 0);
      application.trace("<" + this + " Widgets setOrClearGlow> widget: " + widget, 0);
      for (var i:int = 0; i < widgetsArray[contentId].length; i++)
      {
        Widget(widgetsArray[contentId][i]).safePlace();
        if (widget != null)
        {
          if (Widget(widgetsArray[contentId][i]) != widget)
          {
            Widget(widgetsArray[contentId][i]).filters = [application.getComponentsConfig().getBlurFilterBackMiddle()];
          }
        }
        else
        {
          Widget(widgetsArray[contentId][i]).filters = null;
        }
      }
    }
    /**
     * Swaps the position of two widgets standing in the same widget container.
     * @param widget the first widget to be swapped
     * @param otherWidget the second widget to be swapped
     */
    private function swapWidgets(widget:Widget, otherWidget:Widget):void
    {
      application.trace("<" + this + " Widgets swapWidgets> called.", 1);
      application.trace("<" + this + " Widgets swapWidgets> widget: " + widget, 0);
      application.trace("<" + this + " Widgets swapWidgets> otherWidget: " + otherWidget, 0);
      const contentId:int = widget.getContentId();
      if (contentId == otherWidget.getContentId())
      {
        const pos:int = widgetsArray[contentId].indexOf(widget);
        const otherPos:int = widgetsArray[contentId].indexOf(otherWidget);
        if (pos != otherPos && pos != -1 && otherPos != -1)
        {
          const tempWidget:Widget = widgetsArray[contentId][pos];
          widgetsArray[contentId][pos] = widgetsArray[contentId][otherPos];
          widgetsArray[contentId][otherPos] = tempWidget;
        }
      }
    }
    /**
     * Refreshes the navigation buttons of every widget of a widget container.
     * @param contentId the index of the widget container to be handled
     */
    private function actualizeButtonsVisible(contentId:int):void
    {
      application.trace("<" + this + " Widgets actualizeButtonsVisible> called.", 1);
      application.trace("<" + this + " Widgets actualizeButtonsVisible> contentId: " + contentId, 0);
      const allWidgets:int = getNumOfAllWidgets();
      for (var i:int = 0; i < widgetsArray[contentId].length; i++)
      {
        if (i == 0)
        {
          Widget(widgetsArray[contentId][i]).setButtonsVisible(false, widgetsArray[contentId].length > 1, allWidgets > 1);
        }
        else if (i == widgetsArray[contentId].length - 1)
        {
          Widget(widgetsArray[contentId][i]).setButtonsVisible(true, false, allWidgets > 1);
        }
        else
        {
          Widget(widgetsArray[contentId][i]).setButtonsVisible(true, true, allWidgets > 1);
        }
      }
    }
    /**
     * Returns the widget of the given widget container that is displayed in fullscreen, or
     * null when there is no such widget there. A widget covers the whole room of its
     * container while it has been put into fullscreen and it is the actual widget of that
     * container as well, and the fullscreen belongs to the desktop mode only: every widget
     * of a mobile mode takes that whole room already.
     * @param contentId the index of the widget container the fullscreen widget is asked of
     */
    private function fullscreenWidgetOfContent(contentId:int):Widget
    {
      application.trace("<" + this + " Widgets fullscreenWidgetOfContent> called.", 1);
      application.trace("<" + this + " Widgets fullscreenWidgetOfContent> contentId: " + contentId, 0);
      const widget:Widget = Widget(actualWidgets[contentId]);
      if (widget != null && widget.getIsWidgetInFullscreen()
        && application.getDynamicsConfig().weAreInDesktopMode())
      {
        return widget;
      }
      return null;
    }
    /**
     * Displays the widgets of a widget container the way the fullscreen of that container
     * asks for: the widget standing in fullscreen takes the whole room of the container and
     * it is the only visible widget of it, and every widget is displayed the usual way
     * again as soon as that fullscreen is over. The container is not scrolled while one
     * widget covers it, because there is nothing beside that widget to be scrolled to.
     * @param contentId the index of the widget container to be refreshed
     */
    private function refreshFullscreenOfContent(contentId:int):void
    {
      application.trace("<" + this + " Widgets refreshFullscreenOfContent> called.", 1);
      application.trace("<" + this + " Widgets refreshFullscreenOfContent> contentId: " + contentId, 0);
      const fullscreenWidget:Widget = fullscreenWidgetOfContent(contentId);
      const desktopMode:Boolean = application.getDynamicsConfig().weAreInDesktopMode();
      var widget:Widget = null;
      for (var i:int = 0; i < widgetsArray[contentId].length; i++)
      {
        widget = Widget(widgetsArray[contentId][i]);
        widget.visible = fullscreenWidget == null || widget == fullscreenWidget;
        if (widget == fullscreenWidget)
        {
          widget.setFullscreenSizes();
        }
        else if (widget.getIsWidgetDisplayedInFullscreen())
        {
          // this widget has been displayed in fullscreen but it is not the fullscreen
          // widget of its container any more, either because another widget of it is the
          // actual one now or because that fullscreen is over, so it is displayed the very
          // same way every other widget of that container is
          if (desktopMode)
          {
            widget.setDesktopSizes();
          }
          else
          {
            widget.setMobileSizes();
          }
        }
      }
      const baseScroll:BaseScroll = contentMultiple.getBaseScroll(contentId);
      if (baseScroll != null)
      {
        baseScroll.setEnabledHorizontal(desktopMode && fullscreenWidget == null);
        baseScroll.setEnabledVertical(desktopMode && fullscreenWidget == null);
      }
      reposWidgets(contentId);
    }
    /**
     * Repositions one widget into its own row or column and refreshes its navigation buttons.
     * @param widget the widget to be repositioned
     */
    private function reposWidget(widget:Widget):void
    {
      application.trace("<" + this + " Widgets reposWidget> called.", 1);
      application.trace("<" + this + " Widgets reposWidget> widget: " + widget, 0);
      const contentId:int = widget.getContentId();
      const widgetIndex:int = widgetsArray[contentId].indexOf(widget);
      if (widgetIndex > -1)
      {
        const elementsFix:int = application.getComponentsConfig().getWidgetsElementsFix();
        // in mobile mode one widget fills the whole content it stands in, so the widgets
        // are laid out right next to each other there: the margin of the desktop grid
        // would push every one of them half out of the view. The safePlace of a widget
        // and the dimensions it takes from its parent content keep this very distance
        const widgetsMargin:int = application.getDynamicsConfig().weAreInDesktopMode()
          ? application.getComponentsConfig().getWidgetsMargin()
          : 0;
        const rowOrCol:int = Math.floor(widgetIndex / elementsFix);
        const intoNewRowOrCol:Boolean = widgetIndex % elementsFix == 0;
        const allWidgets:int = getNumOfAllWidgets();
        const prevWidget:Widget = widgetIndex > 0 ? Widget(widgetsArray[contentId][widgetIndex - 1]) : null;
        var tox:int = widgetsMargin;
        var toy:int = widgetsMargin;
        var maxx:int = widgetsMargin;
        var maxy:int = widgetsMargin;
        var i:int = 0;
        if (widgetIndex == 0)
        {
          widget.setButtonsVisible(false, widgetsArray[contentId].length > 1, allWidgets > 1);
        }
        else if (widgetIndex == widgetsArray[contentId].length - 1)
        {
          widget.setButtonsVisible(true, false, allWidgets > 1);
        }
        else
        {
          widget.setButtonsVisible(true, true, allWidgets > 1);
        }
        if (orientationsArray[contentId] == EnumOrientations.ORIENTATION_HORIZONTAL())
        {
          if (rowOrCol == 0)
          {
            if (prevWidget != null)
            {
              toy = prevWidget.y + prevWidget.getDh() + widgetsMargin;
            }
          }
          else if (intoNewRowOrCol)
          {
            for (i = (rowOrCol - 1) * elementsFix; i < widgetIndex; i++)
            {
              if (maxx < Widget(widgetsArray[contentId][i]).x + Widget(widgetsArray[contentId][i]).getDw() + widgetsMargin)
              {
                maxx = Widget(widgetsArray[contentId][i]).x + Widget(widgetsArray[contentId][i]).getDw() + widgetsMargin;
              }
            }
            tox = maxx;
          }
          else
          {
            tox = prevWidget.x;
            toy = prevWidget.y + prevWidget.getDh() + widgetsMargin;
          }
          if (widget.x != tox || widget.y != toy)
          {
            widget.x = tox;
            widget.y = toy;
          }
        }
        else if (orientationsArray[contentId] == EnumOrientations.ORIENTATION_VERTICAL())
        {
          if (rowOrCol == 0)
          {
            if (prevWidget != null)
            {
              tox = prevWidget.x + prevWidget.getDw() + widgetsMargin;
            }
          }
          else if (intoNewRowOrCol)
          {
            for (i = (rowOrCol - 1) * elementsFix; i < widgetIndex; i++)
            {
              if (maxy < Widget(widgetsArray[contentId][i]).y + Widget(widgetsArray[contentId][i]).getDh() + widgetsMargin)
              {
                maxy = Widget(widgetsArray[contentId][i]).y + Widget(widgetsArray[contentId][i]).getDh() + widgetsMargin;
              }
            }
            toy = maxy;
          }
          else
          {
            toy = prevWidget.y;
            tox = prevWidget.x + prevWidget.getDw() + widgetsMargin;
          }
          if (widget.x != tox || widget.y != toy)
          {
            widget.x = tox;
            widget.y = toy;
          }
        }
      }
    }
    /**
     * Repositions every widget of a widget container and recalculates the content dimensions.
     * @param contentId the index of the widget container to be repositioned
     */
    private function reposWidgets(contentId:int):void
    {
      application.trace("<" + this + " Widgets reposWidgets> called.", 1);
      application.trace("<" + this + " Widgets reposWidgets> contentId: " + contentId, 0);
      if (application != null)
      {
        // a widget standing in fullscreen covers the whole room of its container and the
        // widgets standing beside it are hidden, so there is no grid to be laid out at all:
        // that one widget is put into the corner of the container and it is the only one
        // the dimensions of that container are recalculated from
        const fullscreenWidget:Widget = fullscreenWidgetOfContent(contentId);
        if (fullscreenWidget != null)
        {
          fullscreenWidget.x = 0;
          fullscreenWidget.y = 0;
          fullscreenWidget.updateCxy();
          application.callContentDimensionsRecalculation(fullscreenWidget);
          return;
        }
        for (var i:int = 0; i < widgetsArray[contentId].length; i++)
        {
          reposWidget(Widget(widgetsArray[contentId][i]));
        }
        for (var j:int = 0; j < widgetsArray[contentId].length; j++)
        {
          Widget(widgetsArray[contentId][j]).updateCxy();
        }
        if (widgetsArray[contentId].length > 0)
        {
          application.callContentDimensionsRecalculation(Widget(widgetsArray[contentId][0]));
        }
        else
        {
          application.callContentDimensionsRecalculation(contentMultiple.getContentSingle(contentId));
        }
      }
    }
    /**
     * Moves every widget of a widget container into the previous one.
     * @param contentId the index of the widget container to be emptied
     */
    private function moveAllWidgetsFromContent(contentId:int):void
    {
      application.trace("<" + this + " Widgets moveAllWidgetsFromContent> called.", 1);
      application.trace("<" + this + " Widgets moveAllWidgetsFromContent> contentId: " + contentId, 0);
      if (contentId > 0)
      {
        while (widgetsArray[contentId].length > 0)
        {
          moveWidgetFromContent(contentId, contentId - 1, Widget(widgetsArray[contentId][0]), false);
        }
        reposWidgets(contentId - 1);
      }
    }
    /**
     * Resizes every widget to the dimensions of the current widget mode, lays every one of
     * them out again, gives the widget containers the scrolling of that mode and goes to the
     * actual widget.
     * The widget mode is not only changed by hand: an automatic one follows the shape of the
     * application, so every resizing of it can turn the desktop mode into the mobile one and
     * back. That gives every widget new dimensions, and the rows and the columns they stand
     * in have to be laid out again with those: a widget standing at the place its previous
     * dimensions gave it would cover the one next to it.
     */
    private function resizeAllWidgetsAndGoTo():void
    {
      application.trace("<" + this + " Widgets resizeAllWidgetsAndGoTo> called.", 1);
      const desktopMode:Boolean = application.getDynamicsConfig().weAreInDesktopMode();
      var fullscreenWidget:Widget = null;
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        fullscreenWidget = fullscreenWidgetOfContent(i);
        for (var j:int = 0; j < widgetsArray[i].length; j++)
        {
          if (desktopMode)
          {
            // the widget standing in fullscreen is given the whole room of its container
            // by the going to it at the end of this call, so sizing it to its own saved
            // dimensions here would lay the content of it out twice
            if (Widget(widgetsArray[i][j]) != fullscreenWidget)
            {
              Widget(widgetsArray[i][j]).setDesktopSizes();
            }
          }
          else
          {
            Widget(widgetsArray[i][j]).setMobileSizes();
          }
        }
      }
      for (var k:int = 0; k < widgetsArray.length; k++)
      {
        reposWidgets(k);
      }
      // in mobile mode one single widget fills the whole container it stands in, so that
      // container has nothing to be scrolled: the widget that has been gone to is put into
      // the view by moving every widget of that container, and a scrolling would move them
      // a second time. The scrolling comes back with the desktop mode, where the widgets
      // stand next to each other and the container has to be walked through
      var baseScroll:BaseScroll = null;
      for (var m:int = 0; m < contentMultiple.getNumOfContents(); m++)
      {
        baseScroll = contentMultiple.getBaseScroll(m);
        if (baseScroll != null)
        {
          baseScroll.setEnabledHorizontal(desktopMode);
          baseScroll.setEnabledVertical(desktopMode);
        }
      }
      if (!desktopMode)
      {
        application.getDynamicsConfig().setAppBackgroundLive(false);
      }
      goToTheActualWidget();
    }
    /**
     * Frees all listeners and references held by this widget layer.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Widgets destroy> called.", 1);
      application.trace("<" + this + " Widgets destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_ORIENTATION_CHANGED(), widgetsOrientationChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), widgetModeChanged);
      application.trace("<" + this + " Widgets destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      for (var i:int = 0; i < widgetsArray.length; i++)
      {
        widgetsArray[i].splice(0);
      }
      widgetsArray.splice(0);
      widgetWidths.splice(0);
      widgetHeights.splice(0);
      actualWidgets.splice(0);
      orientationsArray.splice(0);
      application.trace("<" + this + " Widgets destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      currentWidgetId = 0;
      contentMultiple = null;
      widgetsArray = null;
      widgetWidths = null;
      widgetHeights = null;
      actualWidgets = null;
      orientationsArray = null;
    }
  }
}
