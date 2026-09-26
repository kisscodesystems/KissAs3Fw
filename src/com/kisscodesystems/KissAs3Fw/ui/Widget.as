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
 * Widget.
 * One movable, resizable and closable window of the widget layer.
 *
 * MAIN FEATURES:
 * - a header holding the label, the info icon and the navigation buttons
 * - a content multiple object the elements of the widget have to be added into
 * - the widget can be dragged by its header and resized by its bottom right corner
 * - it can be minimized to its header only, and it can show an info text instead of its content
 * - it can be put into fullscreen in desktop mode, where it covers the whole widget
 *   container it stands in and hides every widget standing beside it, and the pointer
 *   coming over it gives that fullscreen back after a navigation to another widget
 * - separate desktop and mobile dimensions, the desktop ones are saved into the widget layer
 * - onCreate() and onClose() are the hooks every extender widget can implement
 * - the parts of the widget live in the internal classes standing below this one: the
 *   submenu of the header, the mover, the resizer and the info label of the empty content
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Widgets;
  import com.kisscodesystems.KissAs3Fw.base.BaseAlerter;
  import com.kisscodesystems.KissAs3Fw.base.BaseEventDispatcher;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.TextBox;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class Widget extends BaseAlerter
  {
    /**
     * The dimensions of the initialized widget, these should be set in every extender widget.
     * These have to be given as the font size would be 16, because the initialization
     * dimensions are recalculated from the actual font size.
     */
    protected var iniSizeWidth:int = 543;
    protected var iniSizeHeight:int = 432;
    protected var widgetMode:String = "";
    protected var loaded:Boolean = false;
    private var contentId:int = 0;
    private var widgetId:int = -1;
    private var widgetHeader:String = null;
    private var widgetType:String = null;
    private var baseShape:BaseShape = null;
    private var backLabel:BaseShape = null;
    private var textLabel:TextLabel = null;
    private var contentMultiple:ContentMultiple = null;
    private var hintTextBox:TextBox = null;
    private var buttonLinkClos:ButtonLink = null;
    private var buttonLinkMore:ButtonLink = null;
    // The parts of this widget: the submenu that drops down from under the more button of
    // the header, the mover of that header, the resizer of the bottom right corner and the
    // label telling that the content of this widget is empty. Every one of them is a child
    // of this widget standing in the corner of it, so the coordinates of what they hold are
    // the coordinates of this widget as well
    private var widgetMenu:WidgetMenu = null;
    private var widgetMover:WidgetMover = null;
    private var widgetResizer:WidgetResizer = null;
    private var widgetInfoLabel:WidgetInfoLabel = null;
    private var menuOpen:Boolean = false;
    // The fullscreen of this widget: the property that is kept and the state it is
    // displayed in at the moment. The two of them are not the same one: a widget that has
    // been put into fullscreen is displayed that way while it is the actual widget of its
    // own container only, and it is displayed the way every other widget is as soon as
    // another widget of that container is gone to, without losing that property
    private var widgetInFullscreen:Boolean = false;
    private var displayedInFullscreen:Boolean = false;
    private var rollOverBringsBackFullscreen:Boolean = true;
    private var contentMultipleWasVisible:Boolean = true;
    private var hintTextBoxWasVisible:Boolean = false;
    private var infoTextLabelWasVisible:Boolean = true;
    private var buttonMoveEventPossible:Boolean = true;
    private var buttonClosEventPossible:Boolean = true;
    private var eventWidgetCloseMe:Event = null;
    private var eventWidgetClosed:Event = null;
    /**
     * Constructs the Widget object and builds up its background, header and content.
     * @param applicationRef the main application reference
     */
    public function Widget(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Widget> called.", 1);
      application.trace("<" + this + " Widget> applicationRef: " + applicationRef, 0);
      if (application.getComponentsConfig().getWidgetEnableManualResize())
      {
        widgetResizer = new WidgetResizer(application, this);
        addChild(widgetResizer);
      }
      baseShape = new BaseShape(application);
      addChild(baseShape);
      baseShape.setIsBright(false);
      baseShape.setType(-1);
      contentMultiple = new ContentMultiple(application);
      addChild(contentMultiple);
      // the submenu of the header, one button per row, on the same background as the header
      widgetMenu = new WidgetMenu(application, this);
      addChild(widgetMenu);
      widgetMenu.visible = false;
      backLabel = new BaseShape(application);
      addChild(backLabel);
      backLabel.setIsBright(true);
      backLabel.setType(1);
      textLabel = new TextLabel(application);
      addChild(textLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      widgetMover = new WidgetMover(application, this);
      addChild(widgetMover);
      refreshPressesOfMoverAndResizer();
      // the pointer is followed on this object and not on one child of it: the fullscreen
      // of a widget is given back by the pointer coming over any part of that widget, and
      // the roll over of this object is the one arriving from every part of it
      addEventListener(MouseEvent.ROLL_OVER, widgetRollOver);
      addEventListener(MouseEvent.ROLL_OUT, widgetRollOut);
      // the close button keeps the corner of the header, the more button stands to its left
      buttonLinkClos = createHeaderButton(EnumIcons.close(), buttonLinkClosClick);
      buttonLinkMore = createHeaderButton(EnumIcons.more(), buttonLinkMoreClick);
      refreshMenu();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawOnStyleChanged);
      // the height of the header label gives the height of the whole header, so everything has
      // to be laid out again when that label grows or shrinks with the font size. The font size
      // of the application is watched here instead of the dimensions of the label itself: the
      // layout writes the width of that label back, so listening to it would never settle
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), redrawOnStyleChanged);
      eventWidgetCloseMe = new Event(EnumEvents.EVENT_WIDGET_CLOSE_ME());
      eventWidgetClosed = new Event(EnumEvents.EVENT_WIDGET_CLOSED());
      setEventDispatcherObjectToThis();
      setDwh(application.getComponentsConfig().getWidgetSizeStandardWidth(), application.getComponentsConfig().getWidgetSizeStandardHeight());
      application.trace("<" + this + " Widget> constructed.", 1);
    }
    /**
     * Returns the index of the widget container this widget belongs to.
     */
    public function getContentId():int
    {
      return contentId;
    }
    /**
     * Sets the index of the widget container this widget belongs to.
     * @param cid the index of the widget container
     */
    public function setContentId(cid:int):void
    {
      application.trace("<" + this + " Widget setContentId> called.", 1);
      application.trace("<" + this + " Widget setContentId> cid: " + cid, 0);
      contentId = cid;
    }
    /**
     * Returns the unique id of this widget.
     */
    public function getWidgetId():int
    {
      return widgetId;
    }
    /**
     * Sets the unique id of this widget, only once, the later calls are ignored.
     * @param id the new widget id
     */
    public function setWidgetId(id:int):void
    {
      application.trace("<" + this + " Widget setWidgetId> called.", 1);
      application.trace("<" + this + " Widget setWidgetId> id: " + id, 0);
      if (widgetId == -1)
      {
        widgetId = id;
      }
    }
    /**
     * Returns the text code of the header of this widget.
     */
    public function getWidgetHeader():String
    {
      return widgetHeader;
    }
    /**
     * Sets the text code of the header of this widget, only once, the later calls are ignored.
     * @param header the text code of the new header
     */
    public function setWidgetHeaderCode(header:String):void
    {
      application.trace("<" + this + " Widget setWidgetHeaderCode> called.", 1);
      application.trace("<" + this + " Widget setWidgetHeaderCode> header: " + header, 0);
      if (widgetHeader == null)
      {
        changeWidgetHeaderCode(header);
      }
    }
    /**
     * Sets the icon displayed before the header of this widget.
     * @param icon the icon type to be displayed
     */
    public function setWidgetHeaderIcon(icon:String):void
    {
      application.trace("<" + this + " Widget setWidgetHeaderIcon> called.", 1);
      application.trace("<" + this + " Widget setWidgetHeaderIcon> icon: " + icon, 0);
      if (textLabel != null)
      {
        textLabel.setIcon(icon);
      }
    }
    /**
     * Sets the emoji displayed before the header of this widget. An emoji and an icon
     * stand in the very same slot of that header, so they are exclusive to each other.
     * @param emoji the emoji type to be displayed
     */
    public function setWidgetHeaderEmoji(emoji:String):void
    {
      application.trace("<" + this + " Widget setWidgetHeaderEmoji> called.", 1);
      application.trace("<" + this + " Widget setWidgetHeaderEmoji> emoji: " + emoji, 0);
      if (textLabel != null)
      {
        textLabel.setEmoji(emoji);
      }
    }
    /**
     * Returns the type of this widget.
     */
    public function getWidgetType():String
    {
      return widgetType;
    }
    /**
     * Sets the type of this widget, only once, the later calls are ignored.
     * @param type the new widget type
     */
    public function setWidgetType(type:String):void
    {
      application.trace("<" + this + " Widget setWidgetType> called.", 1);
      application.trace("<" + this + " Widget setWidgetType> type: " + type, 0);
      if (widgetType == null)
      {
        widgetType = type;
      }
    }
    /**
     * Returns true if this widget is minimized to its header only.
     */
    public function getHidden():Boolean
    {
      return mask != null;
    }
    /**
     * Minimizes this widget to its header only or restores it to its full dimensions.
     * @param hidden true if this widget has to be minimized
     */
    public function setHidden(hidden:Boolean):void
    {
      application.trace("<" + this + " Widget setHidden> called.", 1);
      application.trace("<" + this + " Widget setHidden> hidden: " + hidden, 0);
      if (mask == null)
      {
        if (hidden)
        {
          // the mask of a minimized widget would hide the submenu, so it has to be closed
          setMenuOpen(false);
          mask = backLabel;
          textLabel.setType(EnumTextTypes.TEXT_TYPE_BRIGHT());
          dispatchEventDimensionsChanged();
        }
      }
      else
      {
        if (!hidden)
        {
          mask = null;
          textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
          dispatchEventDimensionsChanged();
        }
      }
    }
    /**
     * Returns true if this widget has been put into fullscreen.
     */
    public function getIsWidgetInFullscreen():Boolean
    {
      return widgetInFullscreen;
    }
    /**
     * Puts this widget into fullscreen or takes it back among the other widgets. A widget
     * standing in fullscreen covers the whole widget container it stands in and it is the
     * only visible widget of that container, exactly the way a mobile mode displays one
     * single widget, but the widget mode of the application is left alone: it stays the
     * desktop one, and every other widget of it keeps its own dimensions.
     * This property is kept: a widget that has been left in fullscreen is displayed in
     * fullscreen again when it is gone back to, and it is displayed the way every other
     * widget is while another widget of its container is the actual one.
     * @param b true if this widget has to be displayed in fullscreen
     */
    public function setIsWidgetInFullscreen(b:Boolean):void
    {
      application.trace("<" + this + " Widget setIsWidgetInFullscreen> called.", 1);
      application.trace("<" + this + " Widget setIsWidgetInFullscreen> b: " + b, 0);
      if (widgetInFullscreen != b)
      {
        widgetInFullscreen = b;
        if (widgetMenu != null)
        {
          widgetMenu.refreshFullRow();
        }
        // the widget layer is the one that lays the widgets of a container out and it is
        // the actual widget of that container that stands in fullscreen, so going to this
        // very widget is what displays this change. A widget that stands in no widget
        // layer at all keeps this property and nothing else happens to it
        const widgets:Widgets = getWidgetsHoldingThisWidget();
        if (widgets != null)
        {
          widgets.goToTheWidget(this);
        }
      }
    }
    /**
     * Returns true if this widget is displayed in fullscreen right now, so it takes the
     * whole room of the widget container it stands in. A widget that has been put into
     * fullscreen is displayed that way while it is the actual widget of its own container
     * only, so this is not the very same thing as the property itself: it is the widget
     * layer that answers this by the sizes it gives to this widget.
     */
    public function getIsWidgetDisplayedInFullscreen():Boolean
    {
      return displayedInFullscreen;
    }
    /**
     * Tells whether this widget takes the whole room of the content it stands in right now.
     * Such a widget can be neither moved, nor resized, nor minimized, and it stands in the
     * corner of that content instead of a cell of the grid of the widgets. Every widget of
     * a mobile mode is displayed this way, and so is the one widget of a desktop mode that
     * has been put into fullscreen.
     */
    public function isFillingTheWholeContent():Boolean
    {
      return displayedInFullscreen || !application.getDynamicsConfig().weAreInDesktopMode();
    }
    /**
     * Returns the index of the active content of this widget.
     */
    public function getActiveIndex():int
    {
      application.trace("<" + this + " Widget getActiveIndex> called.", 1);
      if (contentMultiple != null)
      {
        return contentMultiple.getActiveIndex();
      }
      return 0;
    }
    /**
     * Returns the x coordinate of the content of this widget.
     */
    public function getContentCx():int
    {
      return contentMultiple.getCx();
    }
    /**
     * Returns the y coordinate of the content of this widget.
     */
    public function getContentCy():int
    {
      return contentMultiple.getCy();
    }
    /**
     * Returns the width available for the content of this widget.
     */
    public function getContentDw():int
    {
      return contentMultiple.getContentDw();
    }
    /**
     * Returns the height available for the content of this widget.
     */
    public function getContentDh():int
    {
      return contentMultiple.getContentDh();
    }
    /**
     * Returns the base event dispatcher of the content of this widget.
     */
    public function getContentBaseEventDispatcher():BaseEventDispatcher
    {
      return contentMultiple.getBaseEventDispatcher();
    }
    /**
     * Returns the base scroll of the single content of the given index, null when there is
     * no content of that index. An extender widget switches the scrolling of its own
     * content off by that scroll when it holds the objects that are scrolled themselves.
     * @param index the index of the single content
     */
    public function getBaseScroll(index:int):BaseScroll
    {
      return contentMultiple.getBaseScroll(index);
    }
    /**
     * Returns the height taken by the button bar of the content of this widget.
     */
    public function getButtonBarCyAndHeight():int
    {
      return contentMultiple.getButtonBarCyAndHeight();
    }
    /**
     * Returns the elements fix of the single content of the given index.
     * @param index the index of the single content
     */
    public function getElementsFix(index:int):int
    {
      return contentMultiple.getElementsFix(index);
    }
    /**
     * Sets the elements fix of the single content of the given index.
     * @param index the index of the single content
     * @param es the new number of the elements of the fix row or column
     */
    public function setElementsFix(index:int, es:int):void
    {
      application.trace("<" + this + " Widget setElementsFix> called.", 1);
      application.trace("<" + this + " Widget setElementsFix> index: " + index, 0);
      application.trace("<" + this + " Widget setElementsFix> es: " + es, 0);
      contentMultiple.setElementsFix(index, es);
    }
    /**
     * Returns the cell index of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the cell index is asked of
     */
    public function getCellIndex(index:int, displayObject:DisplayObject):int
    {
      return contentMultiple.getCellIndex(index, displayObject);
    }
    /**
     * Changes the cell index of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the cell index has to be changed of
     * @param cellIndex the new cell index of that element
     */
    public function changeCellIndex(index:int, displayObject:DisplayObject, cellIndex:int):void
    {
      application.trace("<" + this + " Widget changeCellIndex> called.", 1);
      application.trace("<" + this + " Widget changeCellIndex> index: " + index, 0);
      application.trace("<" + this + " Widget changeCellIndex> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget changeCellIndex> cellIndex: " + cellIndex, 0);
      contentMultiple.changeCellIndex(index, displayObject, cellIndex);
    }
    /**
     * Returns the horizontal align of an element of the content of the given index, or
     * null when that element is not in that content.
     * @param index the index of the content
     * @param displayObject the element the horizontal align is asked of
     */
    public function getElementAlignHorizontal(index:int, displayObject:DisplayObject):String
    {
      return contentMultiple.getElementAlignHorizontal(index, displayObject);
    }
    /**
     * Sets the horizontal align of an element of the content of the given index. The cell
     * of an element is as wide as the widest cell of its column, so a narrower element has
     * a free space inside that cell this align places it in.
     * @param index the index of the content
     * @param displayObject the element the horizontal align has to be set of
     * @param align the new horizontal align, a horizontal EnumAligns value
     */
    public function setElementAlignHorizontal(index:int, displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " Widget setElementAlignHorizontal> called.", 1);
      application.trace("<" + this + " Widget setElementAlignHorizontal> index: " + index, 0);
      application.trace("<" + this + " Widget setElementAlignHorizontal> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget setElementAlignHorizontal> align: " + align, 0);
      contentMultiple.setElementAlignHorizontal(index, displayObject, align);
    }
    /**
     * Returns the vertical align of an element of the content of the given index, or null
     * when that element is not in that content.
     * @param index the index of the content
     * @param displayObject the element the vertical align is asked of
     */
    public function getElementAlignVertical(index:int, displayObject:DisplayObject):String
    {
      return contentMultiple.getElementAlignVertical(index, displayObject);
    }
    /**
     * Sets the vertical align of an element of the content of the given index. The cell of
     * an element is as tall as the tallest cell of its row, so a lower element has a free
     * space inside that cell this align places it in.
     * @param index the index of the content
     * @param displayObject the element the vertical align has to be set of
     * @param align the new vertical align, a vertical EnumAligns value
     */
    public function setElementAlignVertical(index:int, displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " Widget setElementAlignVertical> called.", 1);
      application.trace("<" + this + " Widget setElementAlignVertical> index: " + index, 0);
      application.trace("<" + this + " Widget setElementAlignVertical> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget setElementAlignVertical> align: " + align, 0);
      contentMultiple.setElementAlignVertical(index, displayObject, align);
    }
    /**
     * Returns true when an element of the content of the given index has been set to fill
     * its own cell.
     * @param index the index of the content
     * @param displayObject the element the fill is asked of
     */
    public function getElementFill(index:int, displayObject:DisplayObject):Boolean
    {
      return contentMultiple.getElementFill(index, displayObject);
    }
    /**
     * Sets whether an element of the content of the given index fills its own cell. Such
     * an element takes the position and the dimensions of that whole cell. It works on an
     * element added with a false sizeConsider only, on one that does not count in the cell
     * dimensions.
     * @param index the index of the content
     * @param displayObject the element the fill has to be set of
     * @param fill true when that element has to fill its own cell
     */
    public function setElementFill(index:int, displayObject:DisplayObject, fill:Boolean):void
    {
      application.trace("<" + this + " Widget setElementFill> called.", 1);
      application.trace("<" + this + " Widget setElementFill> index: " + index, 0);
      application.trace("<" + this + " Widget setElementFill> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget setElementFill> fill: " + fill, 0);
      contentMultiple.setElementFill(index, displayObject, fill);
    }
    /**
     * Returns the side an element of the content of the given index is docked to, or null
     * when that element is not in that content.
     * @param index the index of the content
     * @param displayObject the element the dock is asked of
     */
    public function getElementDock(index:int, displayObject:DisplayObject):String
    {
      return contentMultiple.getElementDock(index, displayObject);
    }
    /**
     * Sets the side an element of the content of the given index is docked to. It is the
     * docking content that places its elements by this, every one of them taking a strip
     * of the room the elements added before it have left.
     * @param index the index of the content
     * @param displayObject the element the dock has to be set of
     * @param dock the side to dock that element to, an EnumDocks value
     */
    public function setElementDock(index:int, displayObject:DisplayObject, dock:String):void
    {
      application.trace("<" + this + " Widget setElementDock> called.", 1);
      application.trace("<" + this + " Widget setElementDock> index: " + index, 0);
      application.trace("<" + this + " Widget setElementDock> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget setElementDock> dock: " + dock, 0);
      contentMultiple.setElementDock(index, displayObject, dock);
    }
    /**
     * Returns the number of the application margins the content of the given index leaves
     * between its elements and around them.
     * @param index the index of the content
     */
    public function getGapFactor(index:int):int
    {
      return contentMultiple.getGapFactor(index);
    }
    /**
     * Sets the room the content of the given index leaves between its elements and around
     * them, counted in the margins of the application: a factor of zero joins its
     * elements with no room between them at all.
     * @param index the index of the content
     * @param factor the number of the application margins to leave, zero or more
     */
    public function setGapFactor(index:int, factor:int):void
    {
      application.trace("<" + this + " Widget setGapFactor> called.", 1);
      application.trace("<" + this + " Widget setGapFactor> index: " + index, 0);
      application.trace("<" + this + " Widget setGapFactor> factor: " + factor, 0);
      contentMultiple.setGapFactor(index, factor);
    }
    /**
     * Returns the width this widget can take from the single content holding it, or zero
     * when it stands in no content at all. A widget standing in the grid of the widgets
     * leaves the margin of them out of it on both sides, and one filling the whole content
     * takes all of it: that is every widget of a mobile mode and the fullscreen one.
     */
    public function getDwFromParentContent():int
    {
      application.trace("<" + this + " Widget getDwFromParentContent> called.", 1);
      const contentSingle:ContentSingle = getParentContentSingle();
      var dwFromParentContent:int = 0;
      if (contentSingle != null)
      {
        dwFromParentContent = isFillingTheWholeContent()
          ? contentSingle.getDw()
          : contentSingle.getDw() - application.getComponentsConfig().getWidgetsMargin() * 2;
      }
      application.trace("<" + this + " Widget getDwFromParentContent> dwFromParentContent: " + dwFromParentContent, 0);
      return dwFromParentContent;
    }
    /**
     * Returns the height this widget can take from the single content holding it, or zero
     * when it stands in no content at all. A widget standing in the grid of the widgets
     * leaves the margin of them out of it on both sides, and one filling the whole content
     * takes all of it: that is every widget of a mobile mode and the fullscreen one.
     */
    public function getDhFromParentContent():int
    {
      application.trace("<" + this + " Widget getDhFromParentContent> called.", 1);
      const contentSingle:ContentSingle = getParentContentSingle();
      var dhFromParentContent:int = 0;
      if (contentSingle != null)
      {
        dhFromParentContent = isFillingTheWholeContent()
          ? contentSingle.getDh()
          : contentSingle.getDh() - application.getComponentsConfig().getWidgetsMargin() * 2;
      }
      application.trace("<" + this + " Widget getDhFromParentContent> dhFromParentContent: " + dhFromParentContent, 0);
      return dhFromParentContent;
    }
    /**
     * Returns true if the submenu of the header of this widget is open.
     */
    public function getMenuOpen():Boolean
    {
      return menuOpen;
    }
    /**
     * Opens or closes the submenu of the header of this widget. An open submenu covers the
     * content area of this widget, so everything standing there is hidden while it is open
     * and it is given its own visibility back as soon as it is closed.
     * @param o true if the submenu has to be open
     */
    public function setMenuOpen(o:Boolean):void
    {
      application.trace("<" + this + " Widget setMenuOpen> called.", 1);
      application.trace("<" + this + " Widget setMenuOpen> o: " + o, 0);
      if (widgetMenu != null && buttonLinkMore != null && menuOpen != o)
      {
        menuOpen = o;
        buttonLinkMore.setIcon(menuOpen ? EnumIcons.uparrow() : EnumIcons.more());
        if (menuOpen)
        {
          // the info row tells what its click does now, so it has to be refreshed before
          // the submenu is measured: its label decides how wide the rows are. It also has
          // to be asked before the content is hidden, because it reads what is visible
          widgetMenu.refreshInfoRow();
          widgetMenu.resizeRows();
          hideContentBehindMenu();
        }
        else
        {
          showContentBehindMenu();
        }
        widgetMenu.visible = menuOpen;
        if (menuOpen)
        {
          // the info text box is created later than the submenu, so the depth has to be
          // taken, the whole submenu first and its own background below its rows
          setChildIndex(widgetMenu, numChildren - 1);
          widgetMenu.raiseRows();
        }
      }
    }
    /**
     * Shows or hides the previous, next and list navigation buttons of this widget.
     * @param prev true if the previous button has to be visible
     * @param next true if the next button has to be visible
     * @param list true if the list button has to be visible
     */
    public function setButtonsVisible(prev:Boolean, next:Boolean, list:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonsVisible> called.", 1);
      application.trace("<" + this + " Widget setButtonsVisible> prev: " + prev, 0);
      application.trace("<" + this + " Widget setButtonsVisible> next: " + next, 0);
      application.trace("<" + this + " Widget setButtonsVisible> list: " + list, 0);
      if (widgetMenu != null)
      {
        widgetMenu.setNavigationRowsVisible(prev, next, list);
      }
      refreshMenu();
    }
    /**
     * Shows or hides the move button of this widget.
     * @param move true if the move button has to be visible
     */
    public function setButtonMoveVisible(move:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonMoveVisible> called.", 1);
      application.trace("<" + this + " Widget setButtonMoveVisible> move: " + move, 0);
      if (widgetMenu != null)
      {
        if ((move && buttonMoveEventPossible) || !move)
        {
          widgetMenu.setMoveRowVisible(move);
        }
      }
      refreshMenu();
    }
    /**
     * Shows or hides the close button of this widget.
     * @param clos true if the close button has to be visible
     */
    public function setButtonClosVisible(clos:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonClosVisible> called.", 1);
      application.trace("<" + this + " Widget setButtonClosVisible> clos: " + clos, 0);
      if (buttonLinkClos != null)
      {
        if ((clos && buttonClosEventPossible) || !clos)
        {
          buttonLinkClos.setSpriteVisible(clos);
        }
      }
    }
    /**
     * Allows or forbids moving this widget between the widget containers.
     * @param p true if this widget is allowed to be moved
     */
    public function setButtonMoveEventPossible(p:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonMoveEventPossible> called.", 1);
      application.trace("<" + this + " Widget setButtonMoveEventPossible> p: " + p, 0);
      buttonMoveEventPossible = p;
      if (!buttonMoveEventPossible)
      {
        setButtonMoveVisible(p);
      }
    }
    /**
     * Allows or forbids closing this widget.
     * @param p true if this widget is allowed to be closed
     */
    public function setButtonClosEventPossible(p:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonClosEventPossible> called.", 1);
      application.trace("<" + this + " Widget setButtonClosEventPossible> p: " + p, 0);
      buttonClosEventPossible = p;
      if (!buttonClosEventPossible)
      {
        setButtonClosVisible(p);
      }
    }
    /**
     * Sets the x and y coordinates of the scrolled content of the single content of the given
     * index.
     * @param index the index of the single content
     * @param newCxContent the new x coordinate of the content
     * @param newCyContent the new y coordinate of the content
     * @param toDispatchEvents is it necessary to dispatch events to the outside
     */
    public function setContentPosition(index:int, newCxContent:int, newCyContent:int, toDispatchEvents:Boolean):void
    {
      application.trace("<" + this + " Widget setContentPosition> called.", 1);
      application.trace("<" + this + " Widget setContentPosition> index: " + index, 0);
      application.trace("<" + this + " Widget setContentPosition> newCxContent: " + newCxContent, 0);
      application.trace("<" + this + " Widget setContentPosition> newCyContent: " + newCyContent, 0);
      application.trace("<" + this + " Widget setContentPosition> toDispatchEvents: " + toDispatchEvents, 0);
      contentMultiple.setContentPosition(index, newCxContent, newCyContent, toDispatchEvents);
    }
    /**
     * Returns the width of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     */
    public function getDwContent(index:int):int
    {
      return contentMultiple.getDwContent(index);
    }
    /**
     * Returns the height of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     */
    public function getDhContent(index:int):int
    {
      return contentMultiple.getDhContent(index);
    }
    /**
     * Sets the dimensions of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     * @param newdw the new width of the content
     * @param newdh the new height of the content
     */
    public function setDwhContent(index:int, newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Widget setDwhContent> called.", 1);
      application.trace("<" + this + " Widget setDwhContent> index: " + index, 0);
      application.trace("<" + this + " Widget setDwhContent> newdw: " + newdw, 0);
      application.trace("<" + this + " Widget setDwhContent> newdh: " + newdh, 0);
      contentMultiple.setDwhContent(index, newdw, newdh);
    }
    /**
     * Sets the orientation of the single content of the given index.
     * @param index the index of the single content
     * @param o the new orientation, an EnumOrientations value
     */
    public function setOrientation(index:int, o:String):void
    {
      application.trace("<" + this + " Widget setOrientation> called.", 1);
      application.trace("<" + this + " Widget setOrientation> index: " + index, 0);
      application.trace("<" + this + " Widget setOrientation> o: " + o, 0);
      contentMultiple.setOrientation(index, o);
    }
    /**
     * Creates the info text box of this widget and shows its info button.
     * @param tc the text code of the info content
     * @param html true if the info content has to be displayed as html
     */
    public function setInfoContent(tc:String, html:Boolean = false):void
    {
      application.trace("<" + this + " Widget setInfoContent> called.", 1);
      application.trace("<" + this + " Widget setInfoContent> tc: " + tc, 0);
      application.trace("<" + this + " Widget setInfoContent> html: " + html, 0);
      // this sets the visibility of the content, so the submenu has to give it back first
      setMenuOpen(false);
      if (hintTextBox == null)
      {
        hintTextBox = new TextBox(application);
        addChild(hintTextBox);
        hintTextBox.setWordWrap(true);
        resizeHintTextBox();
      }
      hintTextBox.visible = false;
      if (contentMultiple != null)
      {
        contentMultiple.visible = true;
      }
      if (widgetMenu != null)
      {
        widgetMenu.setInfoRowVisible(true);
      }
      hintTextBox.setHtml(html);
      hintTextBox.setLabel(tc);
      refreshMenu();
    }
    /**
     * Returns whether the info text box of this widget is the visible one instead of
     * the content of it.
     */
    public function getInfoContentVisible():Boolean
    {
      return hintTextBox != null && hintTextBox.visible;
    }
    /**
     * Displays the info text box of this widget instead of the content of it, or that
     * content instead of the info text box. The info button of the header does exactly
     * this swap, so a widget that is described by its own info text can be opened with
     * that text already displayed. The info content has to be set before this call:
     * a widget holding none of it has nothing to be swapped at all.
     * @param b true when the info text box has to be the visible one
     */
    public function setInfoContentVisible(b:Boolean):void
    {
      application.trace("<" + this + " Widget setInfoContentVisible> called.", 1);
      application.trace("<" + this + " Widget setInfoContentVisible> b: " + b, 0);
      // this sets the visibility of the content, so the submenu has to give it back first
      setMenuOpen(false);
      if (contentMultiple == null || hintTextBox == null)
      {
        application.trace("<" + this + " Widget setInfoContentVisible> there is no info content to be swapped.", 1);
        return;
      }
      contentMultiple.visible = !b;
      hintTextBox.visible = b;
      // the label of the empty content belongs to that content, so it goes with it
      if (widgetInfoLabel != null)
      {
        widgetInfoLabel.visible = contentMultiple.visible;
      }
      // a minimized widget displays nothing at all, so it is restored to be read
      if (b && getHidden() && widgetMenu != null)
      {
        widgetMenu.toggleHidden();
      }
    }
    /**
     * Destroys the info text box of this widget and hides its info button.
     */
    public function clearInfoContent():void
    {
      application.trace("<" + this + " Widget clearInfoContent> called.", 1);
      // this sets the visibility of the content, so the submenu has to give it back first
      setMenuOpen(false);
      if (hintTextBox != null)
      {
        hintTextBox.destroy();
        if (contains(hintTextBox))
        {
          removeChild(hintTextBox);
        }
        hintTextBox = null;
      }
      if (widgetMenu != null)
      {
        widgetMenu.setInfoRowVisible(false);
      }
      if (contentMultiple != null)
      {
        contentMultiple.visible = true;
      }
      refreshMenu();
    }
    /**
     * Sets the dimensions of this widget to its initialization dimensions,
     * recalculated from the actual font size, and saves them into the widget layer.
     */
    public function setIniSizes():void
    {
      application.trace("<" + this + " Widget setIniSizes> called.", 1);
      const factor:Number = application.getComponentsConfig().getWidgetSizeFromFontSizeFactor();
      const origFontSize:int = 16;
      const currFontSize:int = application.getFontSizeInUse();
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        const iniSizeWidthModified:int = currFontSize / origFontSize * factor * iniSizeWidth;
        const iniSizeHeightModified:int = currFontSize / origFontSize * factor * iniSizeHeight;
        super.setDwh(iniSizeWidthModified, iniSizeHeightModified);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().getWidgets().saveWidgetSizes(this, iniSizeWidthModified, iniSizeHeightModified);
        }
      }
      else
      {
        super.setDwh(iniSizeWidth, iniSizeHeight);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().getWidgets().saveWidgetSizes(this, iniSizeWidth, iniSizeHeight);
        }
      }
    }
    /**
     * Sets the dimensions of this widget to the ones saved for the desktop mode and gives
     * it back everything a widget standing in a grid of its own dimensions can be told.
     */
    public function setDesktopSizes():void
    {
      application.trace("<" + this + " Widget setDesktopSizes> called.", 1);
      if (displayedInFullscreen)
      {
        // the pointer can stand on this widget at the very moment it takes its own
        // dimensions back, and the room under that pointer changes without any movement of
        // it: the roll over arriving from such a change would put this widget right back
        // into the fullscreen it has just left, so a real leaving of the pointer is waited
        // for. That is how a widget left in fullscreen can be navigated away from at all
        rollOverBringsBackFullscreen = false;
      }
      displayedInFullscreen = false;
      refreshPressesOfMoverAndResizer();
      if (application.getMiddleground() != null)
      {
        const widgets:Widgets = application.getMiddleground().getWidgets();
        super.setDwh(widgets.getWidgetSavedWidth(this), widgets.getWidgetSavedHeight(this));
      }
      if (widgetMenu != null)
      {
        if (application.getComponentsConfig().getWidgetEnableManualHide())
        {
          widgetMenu.setMimaRowVisible(true);
        }
        widgetMenu.setFullRowVisible(true);
      }
      refreshMenu();
    }
    /**
     * Sets the dimensions of this widget to the ones the parent content offers in mobile mode.
     */
    public function setMobileSizes():void
    {
      application.trace("<" + this + " Widget setMobileSizes> called.", 1);
      displayedInFullscreen = false;
      // every widget of a mobile mode covers the whole content it stands in already, so
      // there is nothing the fullscreen row could maximize there
      if (widgetMenu != null)
      {
        widgetMenu.setFullRowVisible(false);
      }
      setWholeContentSizes();
    }
    /**
     * Sets the dimensions of this widget to the whole room of the parent content of it,
     * the very same way the mobile mode sizes a widget: this is the fullscreen of a widget
     * standing in desktop mode. It is the widget layer that decides which widget is
     * displayed this way, so this is called by that layer and not by the property setter.
     */
    public function setFullscreenSizes():void
    {
      application.trace("<" + this + " Widget setFullscreenSizes> called.", 1);
      displayedInFullscreen = true;
      if (widgetMenu != null)
      {
        widgetMenu.setFullRowVisible(true);
      }
      setWholeContentSizes();
    }
    /**
     * Creates the one and only default content of this widget.
     */
    public function setDefaultContent():void
    {
      application.trace("<" + this + " Widget setDefaultContent> called.", 1);
      if (contentMultiple != null)
      {
        contentMultiple.setDefaultContent();
      }
    }
    /**
     * Creates a new single content in this widget, returns -1 if the label is already in use.
     * @param label the label of the button of the new content
     * @param it the icon type of the button of the new content
     */
    public function addContent(label:String, it:String = ""):int
    {
      application.trace("<" + this + " Widget addContent> called.", 1);
      application.trace("<" + this + " Widget addContent> label: " + label, 0);
      application.trace("<" + this + " Widget addContent> it: " + it, 0);
      return contentMultiple.addContent(label, it);
    }
    /**
     * Creates a new single content in this widget whose button is hidden from the button
     * bar, returns -1 if the label is already in use. Such a content is reachable by its
     * index and by its label only, never on the button bar.
     * @param label the label of the new content, the name it can be looked up by
     */
    public function addHiddenContent(label:String):int
    {
      application.trace("<" + this + " Widget addHiddenContent> called.", 1);
      application.trace("<" + this + " Widget addHiddenContent> label: " + label, 0);
      return contentMultiple.addHiddenContent(label);
    }
    /**
     * Removes the single content of the given index from this widget.
     * @param index the index of the content to be removed
     */
    public function removeContent(index:int):void
    {
      application.trace("<" + this + " Widget removeContent> called.", 1);
      application.trace("<" + this + " Widget removeContent> index: " + index, 0);
      if (contentMultiple != null)
      {
        contentMultiple.removeContent(index);
      }
    }
    /**
     * Makes the content of the given index the active one in this widget.
     * @param index the index of the content to be activated
     */
    public function setActiveContent(index:int):void
    {
      application.trace("<" + this + " Widget setActiveContent> called.", 1);
      application.trace("<" + this + " Widget setActiveContent> index: " + index, 0);
      if (contentMultiple != null)
      {
        contentMultiple.setActiveIndex(index);
      }
    }
    /**
     * Shows or hides the button bar of the content of this widget.
     * @param v true if the button bar has to be visible
     */
    public function setButtonBarVisible(v:Boolean):void
    {
      application.trace("<" + this + " Widget setButtonBarVisible> called.", 1);
      application.trace("<" + this + " Widget setButtonBarVisible> v: " + v, 0);
      if (contentMultiple != null)
      {
        contentMultiple.setButtonBarVisible(v);
      }
    }
    /**
     * Returns true when the button of the content of the given index is shown on the
     * button bar of this widget.
     * @param index the index of the content
     */
    public function getContentButtonVisible(index:int):Boolean
    {
      return contentMultiple.getContentButtonVisible(index);
    }
    /**
     * Shows or hides the button of the content of the given index. The content itself
     * stays the one that can be activated by its index and found by its label, it only
     * loses its own entry of the button bar.
     * @param index the index of the content
     * @param v true when the button of that content has to be shown on the button bar
     */
    public function setContentButtonVisible(index:int, v:Boolean):void
    {
      application.trace("<" + this + " Widget setContentButtonVisible> called.", 1);
      application.trace("<" + this + " Widget setContentButtonVisible> index: " + index, 0);
      application.trace("<" + this + " Widget setContentButtonVisible> v: " + v, 0);
      if (contentMultiple != null)
      {
        contentMultiple.setContentButtonVisible(index, v);
      }
    }
    /**
     * Frees the leading slot of the content button of the given index up: the icon of it
     * and the emoji of it as well.
     * @param index the index of the content button the leading slot is freed up of
     */
    public function destIcon(index:int):void
    {
      application.trace("<" + this + " Widget destIcon> called.", 1);
      application.trace("<" + this + " Widget destIcon> index: " + index, 0);
      contentMultiple.destIcon(index);
    }
    /**
     * Sets the icon of the content button of the given index.
     * @param index the index of the content button the icon is set of
     * @param it the new icon type
     */
    public function setIcon(index:int, it:String):void
    {
      application.trace("<" + this + " Widget setIcon> called.", 1);
      application.trace("<" + this + " Widget setIcon> index: " + index, 0);
      application.trace("<" + this + " Widget setIcon> it: " + it, 0);
      contentMultiple.setIcon(index, it);
    }
    /**
     * Sets the icon of the content button of the given index if it is not the active one.
     * @param index the index of the content button the icon is set of
     * @param it the new icon type
     */
    public function setIconIfNotActive(index:int, it:String):void
    {
      application.trace("<" + this + " Widget setIconIfNotActive> called.", 1);
      application.trace("<" + this + " Widget setIconIfNotActive> index: " + index, 0);
      application.trace("<" + this + " Widget setIconIfNotActive> it: " + it, 0);
      contentMultiple.setIconIfNotActive(index, it);
    }
    /**
     * Sets the emoji of the content button of the given index. An emoji and an icon stand
     * in the very same slot of a button, so they are exclusive to each other.
     * @param index the index of the content button the emoji is set of
     * @param et the new emoji type
     */
    public function setEmoji(index:int, et:String):void
    {
      application.trace("<" + this + " Widget setEmoji> called.", 1);
      application.trace("<" + this + " Widget setEmoji> index: " + index, 0);
      application.trace("<" + this + " Widget setEmoji> et: " + et, 0);
      contentMultiple.setEmoji(index, et);
    }
    /**
     * Sets the emoji of the content button of the given index if it is not the active one.
     * @param index the index of the content button the emoji is set of
     * @param et the new emoji type
     */
    public function setEmojiIfNotActive(index:int, et:String):void
    {
      application.trace("<" + this + " Widget setEmojiIfNotActive> called.", 1);
      application.trace("<" + this + " Widget setEmojiIfNotActive> index: " + index, 0);
      application.trace("<" + this + " Widget setEmojiIfNotActive> et: " + et, 0);
      contentMultiple.setEmojiIfNotActive(index, et);
    }
    /**
     * Adds a new element into the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element to be added
     * @param cellIndex the cell index of that element
     * @param sizeConsider true if the dimensions of that element count in the cell dimensions
     * @param to0 true if that element has to be added to the lowest depth
     */
    public function addToContent(index:int, displayObject:DisplayObject, cellIndex:int, sizeConsider:Boolean = true, to0:Boolean = false):void
    {
      application.trace("<" + this + " Widget addToContent> called.", 1);
      application.trace("<" + this + " Widget addToContent> index: " + index, 0);
      application.trace("<" + this + " Widget addToContent> displayObject: " + displayObject, 0);
      application.trace("<" + this + " Widget addToContent> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " Widget addToContent> sizeConsider: " + sizeConsider, 0);
      application.trace("<" + this + " Widget addToContent> to0: " + to0, 0);
      contentMultiple.addToContent(index, displayObject, cellIndex, sizeConsider, to0);
    }
    /**
     * Removes an element from the single content of the given index without destroying it.
     * @param index the index of the single content
     * @param displayObject the element to be removed
     */
    public function removeFromContent(index:int, displayObject:DisplayObject):void
    {
      application.trace("<" + this + " Widget removeFromContent> called.", 1);
      application.trace("<" + this + " Widget removeFromContent> index: " + index, 0);
      application.trace("<" + this + " Widget removeFromContent> displayObject: " + displayObject, 0);
      contentMultiple.removeFromContent(index, displayObject);
    }
    /**
     * Moves this widget back into the visible area if it has been dragged out of it. A
     * widget filling the whole content it stands in stands in the very corner of it, so
     * that corner is the safe place of it and the margin of the widgets is not.
     */
    public function safePlace():void
    {
      application.trace("<" + this + " Widget safePlace> called.", 1);
      var safePos:int = 0;
      if (!isFillingTheWholeContent())
      {
        safePos = application.getComponentsConfig().getWidgetsMargin();
      }
      if (getCx() < safePos)
      {
        setCx(safePos);
      }
      if (getCy() < safePos)
      {
        setCy(safePos);
      }
    }
    /**
     * Dispatches the closed event of this widget and tells whether it can be closed.
     * Every extender widget can override this to refuse the closing.
     */
    public function onClose():Boolean
    {
      application.trace("<" + this + " Widget onClose> called.", 1);
      dispatchClosedEvent();
      return true;
    }
    /**
     * Returns the height of this widget, the height of its header only if it is minimized.
     */
    override public function getDh():int
    {
      application.trace("<" + this + " Widget getDh> called.", 1);
      if (getHidden())
      {
        return textLabel.getDh() + application.getDynamicsConfig().getAppMargin() * 4;
      }
      else
      {
        return super.getDh();
      }
    }
    /**
     * Sets the width of this widget, never below the minimal widget width. A widget filling
     * the whole content it stands in takes its width from that content, so it is left alone.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Widget setDw> called.", 1);
      application.trace("<" + this + " Widget setDw> newdw: " + newdw, 0);
      if (!isFillingTheWholeContent())
      {
        super.setDw(Math.max(application.getComponentsConfig().getWidgetSizeMinWidth(), newdw));
      }
    }
    /**
     * Sets the height of this widget, never below the minimal widget height. A widget
     * filling the whole content it stands in takes its height from that content, and a
     * minimized one is as tall as its own header, so both of them are left alone.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Widget setDh> called.", 1);
      application.trace("<" + this + " Widget setDh> newdh: " + newdh, 0);
      if (!getHidden())
      {
        if (!isFillingTheWholeContent())
        {
          super.setDh(Math.max(application.getComponentsConfig().getWidgetSizeMinHeight(), newdh));
        }
      }
    }
    /**
     * Sets the dimensions of this widget, only the width if it is minimized. A widget
     * filling the whole content it stands in takes both of its dimensions from that
     * content, so it is left alone.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Widget setDwh> called.", 1);
      application.trace("<" + this + " Widget setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Widget setDwh> newdh: " + newdh, 0);
      if (isFillingTheWholeContent())
      {
        return;
      }
      if (getHidden())
      {
        super.setDw(Math.max(application.getComponentsConfig().getWidgetSizeMinWidth(), newdw));
      }
      else
      {
        super.setDwh(Math.max(application.getComponentsConfig().getWidgetSizeMinWidth(), newdw), Math.max(application.getComponentsConfig().getWidgetSizeMinHeight(), newdh));
      }
    }
    /**
     * Initializes this widget and registers the stage listeners when it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Widget addedToStage> called.", 1);
      application.trace("<" + this + " Widget addedToStage> e: " + e, 0);
      super.addedToStage(e);
      onCreate();
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp, false, 0, true);
      }
      setIniSizes();
    }
    /**
     * Removes the stage listeners when this widget gets off the stage.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Widget removedFromStage> called.", 1);
      application.trace("<" + this + " Widget removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      super.removedFromStage(e);
    }
    /**
     * Redraws this widget after its dimensions have been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " Widget doDimensionsChanged> called.", 1);
      resizeElements();
      safeResizeInfoTextLabel();
      super.doDimensionsChanged();
    }
    /**
     * Called when this widget has become the part of the display object hierarchy.
     * Every extender widget can override this to build up its own content.
     */
    protected function onCreate():void
    {
      application.trace("<" + this + " Widget onCreate> called.", 1);
    }
    /**
     * Changes the text code of the header of this widget.
     * @param header the text code of the new header
     */
    protected function changeWidgetHeaderCode(header:String):void
    {
      application.trace("<" + this + " Widget changeWidgetHeaderCode> called.", 1);
      application.trace("<" + this + " Widget changeWidgetHeaderCode> header: " + header, 0);
      widgetHeader = header;
      textLabel.setLabel(header);
    }
    /**
     * Creates the info label displayed in the middle of this widget.
     * @param t the text code of the info label
     */
    protected function setInfoTextLabel(t:String):void
    {
      application.trace("<" + this + " Widget setInfoTextLabel> called.", 1);
      application.trace("<" + this + " Widget setInfoTextLabel> t: " + t, 0);
      if (widgetInfoLabel == null)
      {
        widgetInfoLabel = new WidgetInfoLabel(application, this);
        addChild(widgetInfoLabel);
      }
      widgetInfoLabel.setLabel(t);
    }
    /**
     * Destroys the info label of this widget.
     */
    protected function removeInfoTextLabel():void
    {
      application.trace("<" + this + " Widget removeInfoTextLabel> called.", 1);
      if (widgetInfoLabel != null)
      {
        widgetInfoLabel.destroy(); // destroy() first to still have stage property inside
        if (contains(widgetInfoLabel))
        {
          removeChild(widgetInfoLabel);
        }
        widgetInfoLabel = null;
      }
    }
    /**
     * Asks the widget layer to close this widget.
     * @param e the click event of the close button, null if it is called by hand
     */
    protected function buttonLinkClosClick(e:Event = null):void
    {
      application.trace("<" + this + " Widget buttonLinkClosClick> called.", 1);
      application.trace("<" + this + " Widget buttonLinkClosClick> e: " + e, 0);
      if (application.getComponentsConfig().getWidgetEnableManualClose())
      {
        getBaseEventDispatcher().dispatchEvent(eventWidgetCloseMe);
      }
    }
    /**
     * Dispatches the closed event of this widget.
     */
    protected function dispatchClosedEvent():void
    {
      application.trace("<" + this + " Widget dispatchClosedEvent> called.", 1);
      if (getBaseEventDispatcher() != null && eventWidgetClosed != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventWidgetClosed);
      }
    }
    /**
     * Creates one header button of this widget and registers its listeners.
     * @param iconType the icon type of the new button
     * @param clickListener the listener to be called when that button is clicked
     */
    private function createHeaderButton(iconType:String, clickListener:Function):ButtonLink
    {
      application.trace("<" + this + " Widget createHeaderButton> called.", 1);
      application.trace("<" + this + " Widget createHeaderButton> iconType: " + iconType, 0);
      application.trace("<" + this + " Widget createHeaderButton> clickListener: " + clickListener, 0);
      const buttonLink:ButtonLink = new ButtonLink(application);
      addChild(buttonLink);
      buttonLink.setIcon(iconType);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), clickListener);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
      return buttonLink;
    }
    /**
     * Remembers which one of the content, the info text box and the info label is visible
     * and hides all of them, so nothing shows through the rows of the open submenu.
     */
    private function hideContentBehindMenu():void
    {
      application.trace("<" + this + " Widget hideContentBehindMenu> called.", 1);
      contentMultipleWasVisible = contentMultiple != null && contentMultiple.visible;
      hintTextBoxWasVisible = hintTextBox != null && hintTextBox.visible;
      infoTextLabelWasVisible = widgetInfoLabel != null && widgetInfoLabel.visible;
      application.trace("<" + this + " Widget hideContentBehindMenu> contentMultipleWasVisible: " + contentMultipleWasVisible, 0);
      application.trace("<" + this + " Widget hideContentBehindMenu> hintTextBoxWasVisible: " + hintTextBoxWasVisible, 0);
      application.trace("<" + this + " Widget hideContentBehindMenu> infoTextLabelWasVisible: " + infoTextLabelWasVisible, 0);
      if (contentMultiple != null)
      {
        contentMultiple.visible = false;
      }
      if (hintTextBox != null)
      {
        hintTextBox.visible = false;
      }
      if (widgetInfoLabel != null)
      {
        widgetInfoLabel.visible = false;
      }
    }
    /**
     * Gives the content, the info text box and the info label back the visibility they had
     * before the submenu has been opened.
     */
    private function showContentBehindMenu():void
    {
      application.trace("<" + this + " Widget showContentBehindMenu> called.", 1);
      if (contentMultiple != null)
      {
        contentMultiple.visible = contentMultipleWasVisible;
      }
      if (hintTextBox != null)
      {
        hintTextBox.visible = hintTextBoxWasVisible;
      }
      if (widgetInfoLabel != null)
      {
        widgetInfoLabel.visible = infoTextLabelWasVisible;
      }
    }
    /**
     * Rebuilds the rows of the submenu from the buttons that are available at the moment,
     * so a button turned off leaves no empty row behind. Hides the more button and closes
     * the submenu when there is nothing left to show in it.
     */
    private function refreshMenu():void
    {
      application.trace("<" + this + " Widget refreshMenu> called.", 1);
      if (widgetMenu == null || buttonLinkMore == null)
      {
        return;
      }
      widgetMenu.refreshRows();
      const rows:int = widgetMenu.getRowCount();
      application.trace("<" + this + " Widget refreshMenu> rows: " + rows, 0);
      if (rows == 0)
      {
        setMenuOpen(false);
      }
      buttonLinkMore.setSpriteVisible(rows > 0);
      reposHeaderButtons();
      resizeMenuContent();
    }
    /**
     * Opens or closes the submenu of this widget, restoring it first if it is minimized,
     * because the submenu would be masked away by the header of a minimized widget.
     * @param e the click event of the more button
     */
    private function buttonLinkMoreClick(e:Event):void
    {
      application.trace("<" + this + " Widget buttonLinkMoreClick> called.", 1);
      application.trace("<" + this + " Widget buttonLinkMoreClick> e: " + e, 0);
      if (getHidden() && widgetMenu != null)
      {
        widgetMenu.toggleHidden();
      }
      setMenuOpen(!menuOpen);
    }
    /**
     * Redraws this widget after one of its header buttons has been resized.
     * @param e the dimensions changed event of a header button
     */
    private function buttonLinkResized(e:Event):void
    {
      application.trace("<" + this + " Widget buttonLinkResized> called.", 1);
      application.trace("<" + this + " Widget buttonLinkResized> e: " + e, 0);
      resizeElements();
    }
    /**
     * Gives this widget the whole room of the parent content of it and takes away from it
     * everything a widget standing in the grid of the widgets can be told: it is restored
     * from its minimized state, it can be neither minimized, nor moved, nor resized any
     * more, and the presses of its header are handed over to the content it stands in.
     * Both the mobile mode and the fullscreen display a widget exactly this way.
     */
    private function setWholeContentSizes():void
    {
      application.trace("<" + this + " Widget setWholeContentSizes> called.", 1);
      refreshPressesOfMoverAndResizer();
      setHidden(false);
      if (widgetMenu != null && application.getComponentsConfig().getWidgetEnableManualHide())
      {
        widgetMenu.setMimaRowVisible(false);
      }
      refreshMenu();
      super.setDwh(getDwFromParentContent(), getDhFromParentContent());
    }
    /**
     * Tells the mover of the header and the resizer of the corner whether they keep the
     * presses that happen on them.
     * A widget standing in the grid of the widgets keeps those presses: they move and
     * resize it, and the scrolling of the content it stands in would take that moving away,
     * because only one single object can be dragged by the mouse at a time. A widget
     * filling the whole content it stands in has nothing to move and nothing to resize, so
     * both of them hand their presses over: that is how the widgets are scrolled by
     * dragging the header of any one of them.
     * The mover of a widget standing in a mobile mode is the one exception: it keeps its
     * presses and does nothing with them at all. That widget is not moved by its header,
     * and the container it stands in is not scrolled either, so there is nothing that
     * press could be handed over to.
     * This is called by the setting of the dimensions of every mode and not by the widget
     * mode changed event of the application: an automatic widget mode follows the shape of
     * the application, so it changes without that event as well.
     */
    private function refreshPressesOfMoverAndResizer():void
    {
      application.trace("<" + this + " Widget refreshPressesOfMoverAndResizer> called.", 1);
      const handsOver:Boolean = isFillingTheWholeContent();
      const desktopMode:Boolean = application.getDynamicsConfig().weAreInDesktopMode();
      application.trace("<" + this + " Widget refreshPressesOfMoverAndResizer> handsOver: " + handsOver, 0);
      application.trace("<" + this + " Widget refreshPressesOfMoverAndResizer> desktopMode: " + desktopMode, 0);
      if (widgetMover != null)
      {
        widgetMover.mouseDownForScrollingEnabled = handsOver && desktopMode;
      }
      if (widgetResizer != null)
      {
        widgetResizer.mouseDownForScrollingEnabled = handsOver;
      }
    }
    /**
     * Redraws this widget after a margin, padding, radius, font size or background color change.
     * @param e the changed event of the modified application property
     */
    private function redrawOnStyleChanged(e:Event):void
    {
      application.trace("<" + this + " Widget redrawOnStyleChanged> called.", 1);
      application.trace("<" + this + " Widget redrawOnStyleChanged> e: " + e, 0);
      resizeElements();
    }
    /**
     * Limits the width of the info label to the width of this widget and repositions it.
     */
    private function safeResizeInfoTextLabel():void
    {
      application.trace("<" + this + " Widget safeResizeInfoTextLabel> called.", 1);
      if (widgetInfoLabel != null)
      {
        widgetInfoLabel.safeResize();
      }
    }
    /**
     * Returns the widget layer this widget stands in, or null when it stands in none of
     * them: a widget is looked up there by the widget id that very layer has given to it,
     * so a widget that has never been added to it is not laid out by it either.
     */
    private function getWidgetsHoldingThisWidget():Widgets
    {
      application.trace("<" + this + " Widget getWidgetsHoldingThisWidget> called.", 1);
      if (application.getMiddleground() != null)
      {
        const widgets:Widgets = application.getMiddleground().getWidgets();
        if (widgets != null && widgets.getWidgetById(getWidgetId()) == this)
        {
          return widgets;
        }
      }
      return null;
    }
    /**
     * Returns the single content this widget is standing in, or null when it stands in none.
     * A widget is added into the base sprite of that content, and that base sprite stands in
     * the content sprite of the scroll of it. So the content itself is not the parent of the
     * parent of this widget: every parent of it has to be walked through to find that one.
     */
    private function getParentContentSingle():ContentSingle
    {
      application.trace("<" + this + " Widget getParentContentSingle> called.", 1);
      var parentObject:DisplayObject = parent;
      while (parentObject != null && !(parentObject is ContentSingle))
      {
        parentObject = parentObject.parent;
      }
      application.trace("<" + this + " Widget getParentContentSingle> parentObject: " + parentObject, 0);
      return ContentSingle(parentObject);
    }
    /**
     * Puts this widget back into the fullscreen it has been left in as soon as the pointer
     * has come over any part of it. A widget that has been put into fullscreen is displayed
     * among the other widgets of its container while another one of them is the actual
     * widget, and this is what gives that fullscreen back without any click at all: the
     * widget the pointer has been moved onto becomes the actual one and covers its
     * container again. Every other widget is left alone by this.
     * @param e the roll over event of this widget
     */
    private function widgetRollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " Widget widgetRollOver> called.", 1);
      application.trace("<" + this + " Widget widgetRollOver> e: " + e, 0);
      if (!widgetInFullscreen || isFillingTheWholeContent() || !rollOverBringsBackFullscreen)
      {
        application.trace("<" + this + " Widget widgetRollOver> there is no fullscreen to be given back.", 1);
        return;
      }
      const widgets:Widgets = getWidgetsHoldingThisWidget();
      if (widgets != null)
      {
        widgets.goToTheWidget(this);
      }
    }
    /**
     * Lets the roll over of this widget bring the fullscreen of it back: the pointer has
     * really left this widget, so the next arrival of it onto this widget is a movement of
     * that pointer and not this widget shrinking away from under a standing one.
     * @param e the roll out event of this widget
     */
    private function widgetRollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " Widget widgetRollOut> called.", 1);
      application.trace("<" + this + " Widget widgetRollOut> e: " + e, 0);
      rollOverBringsBackFullscreen = true;
    }
    /**
     * Tells whether the mover or the resizer of this widget is the one being pressed right now.
     */
    private function isMoverOrResizerPressed():Boolean
    {
      return (widgetMover != null && widgetMover.getPressed())
          || (widgetResizer != null && widgetResizer.getPressed());
    }
    /**
     * Closes the dragging or the resizing of this widget and the submenu of it.
     * This handler is registered on the stage, so every widget standing there hears every mouse
     * up of the whole application, whatever it happened on. So it does nothing and reports
     * nothing at all unless the mover or the resizer of this very widget was the pressed one:
     * a click somewhere else can neither stop a dragging that was never started nor push this
     * widget out of the stage, and one such click used to cost the safe placing of every widget
     * of the application, every getter of that placing logging on its own.
     * The mover and the resizer are asked one after the other and each of them closes its own
     * press only, so the one that was not pressed does nothing at all.
     * @param e the mouse up event of the stage
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      if (menuOpen && widgetMenu != null)
      {
        widgetMenu.closeIfClickedOutside(buttonLinkMore);
      }
      if (isMoverOrResizerPressed())
      {
        application.trace("<" + this + " Widget stageMouseUp> called.", 1);
        application.trace("<" + this + " Widget stageMouseUp> e: " + e, 0);
        if (!isFillingTheWholeContent())
        {
          if (widgetMover != null)
          {
            widgetMover.finishPress();
          }
          if (widgetResizer != null)
          {
            widgetResizer.finishPress();
          }
          safePlace();
        }
        if (widgetMover != null)
        {
          widgetMover.clearPress();
        }
        if (widgetResizer != null)
        {
          widgetResizer.clearPress();
        }
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Redraws every element of this widget.
     */
    private function resizeElements():void
    {
      application.trace("<" + this + " Widget resizeElements> called.", 1);
      if (application != null)
      {
        resizeBackground();
        refreshResizerArea();
        resizeHeader();
        reposHeaderButtons();
        resizeContentMultiple();
        resizeMenuContent();
        resizeHintTextBox();
      }
    }
    /**
     * Redraws the background shape of this widget.
     */
    private function resizeBackground():void
    {
      application.trace("<" + this + " Widget resizeBackground> called.", 1);
      baseShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorMid(), application.getDynamicsConfig().getAppBackgroundColorAlpha() / 4, application.getDynamicsConfig().getAppBackgroundColorBright());
      baseShape.x = 0;
      baseShape.y = 0;
      baseShape.setRadius(application.getDynamicsConfig().getAppRadius());
      baseShape.setDwh(getDw(), super.getDh());
      baseShape.drawRect();
    }
    /**
     * Redraws the invisible press area of the resizer of this widget over the whole of it.
     * The full height is given to that resizer and not the one a minimized widget reports,
     * so the corner of it stays where it is while this widget is minimized and restored.
     */
    private function refreshResizerArea():void
    {
      application.trace("<" + this + " Widget refreshResizerArea> called.", 1);
      if (widgetResizer != null)
      {
        widgetResizer.refreshArea(getDw(), super.getDh());
      }
    }
    /**
     * Redraws the header of this widget: the label, its background and the mover.
     */
    private function resizeHeader():void
    {
      application.trace("<" + this + " Widget resizeHeader> called.", 1);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const radius:int = application.getDynamicsConfig().getAppRadius();
      // the info button has moved into the submenu, so the label starts at the left edge
      textLabel.setCxy(margin + padding, margin + padding);
      textLabel.setMaxWidth(getDw() - textLabel.getCx() - 2 * padding, false);
      backLabel.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorMid(), application.getDynamicsConfig().getAppBackgroundColorAlpha() / 2, application.getDynamicsConfig().getAppBackgroundColorBright());
      backLabel.x = margin;
      backLabel.y = margin;
      backLabel.setRadius(radius);
      backLabel.setDwh(getDw() - margin * 2, textLabel.getDh() + padding * 2);
      backLabel.drawRect();
      if (widgetMover != null)
      {
        widgetMover.refreshArea(textLabel.getDh());
      }
    }
    /**
     * Repositions the navigation buttons of this widget from the right to the left.
     */
    private function reposHeaderButtons():void
    {
      application.trace("<" + this + " Widget reposHeaderButtons> called.", 1);
      var currx:int = getDw() - textLabel.getDh() - 2 * application.getDynamicsConfig().getAppPadding() - application.getDynamicsConfig().getAppMargin();
      currx = reposHeaderButton(buttonLinkClos, currx);
      currx = reposHeaderButton(buttonLinkMore, currx);
    }
    /**
     * Repositions one navigation button and returns the x coordinate of the next one.
     * @param buttonLink the navigation button to be repositioned
     * @param currx the x coordinate that button has to be positioned to
     */
    private function reposHeaderButton(buttonLink:ButtonLink, currx:int):int
    {
      application.trace("<" + this + " Widget reposHeaderButton> called.", 1);
      application.trace("<" + this + " Widget reposHeaderButton> buttonLink: " + buttonLink, 0);
      application.trace("<" + this + " Widget reposHeaderButton> currx: " + currx, 0);
      if (buttonLink.visible)
      {
        buttonLink.setCxy(currx, application.getDynamicsConfig().getAppMargin());
        textLabel.setMaxWidth(buttonLink.getCx() - textLabel.getCx(), false);
        return currx - buttonLink.getDw();
      }
      return currx;
    }
    /**
     * Repositions and resizes the content of this widget below its header.
     */
    private function resizeContentMultiple():void
    {
      application.trace("<" + this + " Widget resizeContentMultiple> called.", 1);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      contentMultiple.setCxy(margin, textLabel.getDh() + padding * 2 + margin * 2);
      contentMultiple.setDwh(getDw() - 2 * margin, super.getDh() - contentMultiple.getCy() - margin);
    }
    /**
     * Tells the submenu of this widget the content area it may drop down over, so it can
     * size itself to its own rows inside that area. It is the submenu that lays its rows
     * out: this widget only owns the room they are given.
     */
    private function resizeMenuContent():void
    {
      application.trace("<" + this + " Widget resizeMenuContent> called.", 1);
      if (widgetMenu != null && contentMultiple != null)
      {
        widgetMenu.setContentArea(contentMultiple.getCy(), contentMultiple.getDw(), contentMultiple.getDh());
      }
    }
    /**
     * Repositions and resizes the info text box of this widget onto the content area.
     */
    private function resizeHintTextBox():void
    {
      application.trace("<" + this + " Widget resizeHintTextBox> called.", 1);
      if (hintTextBox != null && contentMultiple != null)
      {
        hintTextBox.setCxy(contentMultiple.getCx(), contentMultiple.getCy());
        hintTextBox.setDwh(contentMultiple.getDw(), contentMultiple.getDh());
      }
    }
    /**
     * Frees all listeners, events and references held by this widget.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Widget destroy> called.", 1);
      application.trace("<" + this + " Widget destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(MouseEvent.ROLL_OVER, widgetRollOver);
      removeEventListener(MouseEvent.ROLL_OUT, widgetRollOut);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawOnStyleChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), redrawOnStyleChanged);
      application.trace("<" + this + " Widget destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventWidgetCloseMe.stopImmediatePropagation();
      eventWidgetClosed.stopImmediatePropagation();
      application.trace("<" + this + " Widget destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      iniSizeWidth = 0;
      iniSizeHeight = 0;
      widgetMode = null;
      loaded = false;
      contentId = 0;
      widgetId = 0;
      widgetHeader = null;
      widgetType = null;
      baseShape = null;
      backLabel = null;
      textLabel = null;
      contentMultiple = null;
      hintTextBox = null;
      buttonLinkClos = null;
      buttonLinkMore = null;
      widgetMenu = null;
      widgetMover = null;
      widgetResizer = null;
      widgetInfoLabel = null;
      menuOpen = false;
      widgetInFullscreen = false;
      displayedInFullscreen = false;
      rollOverBringsBackFullscreen = false;
      contentMultipleWasVisible = false;
      hintTextBoxWasVisible = false;
      infoTextLabelWasVisible = false;
      buttonMoveEventPossible = false;
      buttonClosEventPossible = false;
      eventWidgetCloseMe = null;
      eventWidgetClosed = null;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.base.BaseShape;
import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
import com.kisscodesystems.KissAs3Fw.ui.Widget;
import flash.events.Event;
import flash.events.MouseEvent;
/**
 * WidgetPart: base of every part of one widget, it keeps the reference of the widget that
 * part belongs to. Every part is a child of that widget standing in the corner of it and it
 * is never scaled, so the coordinates inside a part are the coordinates of that widget as
 * well: what a part holds can be laid out and hit tested in the numbers of the widget
 * itself. A part reaches its widget through the public API of it only.
 */
internal class WidgetPart extends BaseSprite
{
  protected var widget:Widget = null;
  /**
   * Constructs the part and keeps the widget it belongs to.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this part belongs to
   */
  public function WidgetPart(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef);
    application.trace("<" + this + " WidgetPart> called.", 1);
    application.trace("<" + this + " WidgetPart> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetPart> widgetRef: " + widgetRef, 0);
    widget = widgetRef;
    application.trace("<" + this + " WidgetPart> constructed.", 1);
  }
  /**
   * Frees every reference held by this part. The widget itself is not destroyed here: it is
   * the owner of this part and it is the one that destroys it.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetPart destroy> called.", 1);
    application.trace("<" + this + " WidgetPart destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    widget = null;
  }
}
/**
 * WidgetGrabber: base of the mover of the header and the resizer of the corner. Both of them
 * are invisible press areas standing above the widget, and both of them keep the press that
 * has been started on them until the mouse is released anywhere at all: that is why the
 * widget hears the mouse up of the stage and closes the press of both of them by hand.
 */
internal class WidgetGrabber extends WidgetPart
{
  protected var pressed:Boolean = false;
  /**
   * Constructs the grabber and hooks the mouse down listener of its own press area.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this grabber belongs to
   */
  public function WidgetGrabber(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef, widgetRef);
    application.trace("<" + this + " WidgetGrabber> called.", 1);
    application.trace("<" + this + " WidgetGrabber> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetGrabber> widgetRef: " + widgetRef, 0);
    addEventListener(MouseEvent.MOUSE_DOWN, grabberMouseDown);
    application.trace("<" + this + " WidgetGrabber> constructed.", 1);
  }
  /**
   * Tells whether this grabber is the one being pressed right now.
   */
  public function getPressed():Boolean
  {
    return pressed;
  }
  /**
   * Closes the press of this grabber and does what that press was started for.
   * The extenders do the moving and the resizing itself, and every one of them leaves this
   * alone unless it is the pressed one: the widget asks all of them on every mouse up.
   */
  public function finishPress():void
  {
    application.trace("<" + this + " WidgetGrabber finishPress> called.", 1);
  }
  /**
   * Forgets the press of this grabber, so the next mouse up of the stage is left alone.
   */
  public function clearPress():void
  {
    application.trace("<" + this + " WidgetGrabber clearPress> called.", 1);
    pressed = false;
  }
  /**
   * Starts the press of this grabber. The extenders take the press itself, this only reports
   * that the press area has been pressed.
   * @param e the mouse down event of this grabber
   */
  protected function grabberMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " WidgetGrabber grabberMouseDown> called.", 1);
    application.trace("<" + this + " WidgetGrabber grabberMouseDown> e: " + e, 0);
  }
  /**
   * Frees all listeners and values held by this grabber.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetGrabber destroy> called.", 1);
    application.trace("<" + this + " WidgetGrabber destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    removeEventListener(MouseEvent.MOUSE_DOWN, grabberMouseDown);
    application.trace("<" + this + " WidgetGrabber destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    pressed = false;
  }
}
/**
 * WidgetMover: the invisible press area covering the header of one widget, that widget is
 * dragged by it. It reports the dragging of the widget as soon as it has really been moved,
 * so a click on the header of a standing widget is not a dragging of it. A widget filling
 * the whole content it stands in is not moved at all: the press that happens on the header
 * of a widget standing in fullscreen is handed over to the scrolling of that content, and
 * the one that happens on the header of a widget of a mobile mode is dropped, because
 * neither that widget nor the container of it is moved by such a press at all.
 */
internal class WidgetMover extends WidgetGrabber
{
  private var prevX:Number = 0;
  private var prevY:Number = 0;
  private var widgetInMove:Boolean = false;
  private var eventWidgetDragStart:Event = null;
  private var eventWidgetDragStop:Event = null;
  /**
   * Constructs the mover and creates the drag events it reports the dragging with.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this mover belongs to
   */
  public function WidgetMover(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef, widgetRef);
    application.trace("<" + this + " WidgetMover> called.", 1);
    application.trace("<" + this + " WidgetMover> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetMover> widgetRef: " + widgetRef, 0);
    eventWidgetDragStart = new Event(EnumEvents.EVENT_WIDGET_DRAG_START());
    eventWidgetDragStop = new Event(EnumEvents.EVENT_WIDGET_DRAG_STOP());
    application.trace("<" + this + " WidgetMover> constructed.", 1);
  }
  /**
   * Redraws the invisible press area of this mover onto the header of the widget.
   * @param labelDh the height of the label of that header
   */
  public function refreshArea(labelDh:int):void
  {
    application.trace("<" + this + " WidgetMover refreshArea> called.", 1);
    application.trace("<" + this + " WidgetMover refreshArea> labelDh: " + labelDh, 0);
    const margin:int = application.getDynamicsConfig().getAppMargin();
    const padding:int = application.getDynamicsConfig().getAppPadding();
    const radius:int = application.getDynamicsConfig().getAppRadius();
    const areaDw:int = widget.getDw() - margin * 2;
    graphics.clear();
    graphics.beginFill(0, 0);
    graphics.drawRoundRect(0, 0, areaDw, labelDh + margin * 2, radius, radius);
    graphics.endFill();
    setCxy(margin, margin);
    setDwh(areaDw, labelDh + padding * 2);
  }
  /**
   * Stops the dragging of the widget, puts it to the place it has been dragged to and
   * reports that the dragging of it is over.
   */
  override public function finishPress():void
  {
    application.trace("<" + this + " WidgetMover finishPress> called.", 1);
    super.finishPress();
    if (pressed)
    {
      widget.stopDrag();
      widget.setCxy(widget.x, widget.y);
      removeEventListener(Event.ENTER_FRAME, enterFrameCheckMovement);
      widget.getBaseEventDispatcher().dispatchEvent(eventWidgetDragStop);
    }
  }
  /**
   * Starts the dragging of the widget, which a widget filling the whole content it stands in
   * is not moved by. The widget is brought to the front right away, so it is dragged above
   * every other widget of its own container.
   * @param e the mouse down event of this mover
   */
  override protected function grabberMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " WidgetMover grabberMouseDown> called.", 1);
    application.trace("<" + this + " WidgetMover grabberMouseDown> e: " + e, 0);
    super.grabberMouseDown(e);
    if (!widget.isFillingTheWholeContent())
    {
      pressed = true;
      widget.startDrag();
      widget.toTheHighestDepth();
      prevX = widget.x;
      prevY = widget.y;
      widgetInMove = false;
      addEventListener(Event.ENTER_FRAME, enterFrameCheckMovement);
    }
  }
  /**
   * Dispatches the drag start event as soon as the widget has really been moved.
   * @param e the enter frame event
   */
  private function enterFrameCheckMovement(e:Event):void
  {
    application.trace("<" + this + " WidgetMover enterFrameCheckMovement> called.", 0);
    application.trace("<" + this + " WidgetMover enterFrameCheckMovement> e: " + e, 0);
    if (prevX != widget.x || prevY != widget.y)
    {
      prevX = widget.x;
      prevY = widget.y;
      if (!widgetInMove)
      {
        widgetInMove = true;
        widget.getBaseEventDispatcher().dispatchEvent(eventWidgetDragStart);
      }
    }
  }
  /**
   * Frees all listeners, events and values held by this mover.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetMover destroy> called.", 1);
    application.trace("<" + this + " WidgetMover destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    removeEventListener(Event.ENTER_FRAME, enterFrameCheckMovement);
    application.trace("<" + this + " WidgetMover destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    eventWidgetDragStart.stopImmediatePropagation();
    eventWidgetDragStop.stopImmediatePropagation();
    application.trace("<" + this + " WidgetMover destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    prevX = 0;
    prevY = 0;
    widgetInMove = false;
    eventWidgetDragStart = null;
    eventWidgetDragStop = null;
  }
}
/**
 * WidgetResizer: the invisible press area covering the whole widget, that widget is resized
 * by the bottom right corner of it. While the corner is being dragged, a rectangle is drawn
 * showing the dimensions the widget is being resized to, and the widget itself takes those
 * dimensions and saves them into the widget layer when the mouse is released. A widget
 * filling the whole content it stands in is not resized at all, so the press that happens on
 * it is handed over to the scrolling of that content instead.
 */
internal class WidgetResizer extends WidgetGrabber
{
  private var prevMouseX:int = 0;
  private var prevMouseY:int = 0;
  private var areaDw:int = 0;
  private var areaDh:int = 0;
  /**
   * Constructs the resizer of the corner of the widget.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this resizer belongs to
   */
  public function WidgetResizer(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef, widgetRef);
    application.trace("<" + this + " WidgetResizer> called.", 1);
    application.trace("<" + this + " WidgetResizer> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetResizer> widgetRef: " + widgetRef, 0);
    application.trace("<" + this + " WidgetResizer> constructed.", 1);
  }
  /**
   * Redraws the invisible press area of this resizer over the whole widget, so the rectangle
   * showing the dimensions that widget is being resized to disappears. The area reaches one
   * resize margin beyond the widget on every side, so its corner can be grabbed from outside
   * of that widget as well.
   * @param newAreaDw the width of the widget
   * @param newAreaDh the height of the widget, the full one even if it is minimized
   */
  public function refreshArea(newAreaDw:int, newAreaDh:int):void
  {
    application.trace("<" + this + " WidgetResizer refreshArea> called.", 1);
    application.trace("<" + this + " WidgetResizer refreshArea> newAreaDw: " + newAreaDw, 0);
    application.trace("<" + this + " WidgetResizer refreshArea> newAreaDh: " + newAreaDh, 0);
    areaDw = newAreaDw;
    areaDh = newAreaDh;
    const resizeMargin:int = application.getComponentsConfig().getResizeMargin();
    graphics.clear();
    graphics.beginFill(0, 0);
    graphics.drawRect(-resizeMargin, -resizeMargin, areaDw + 2 * resizeMargin, areaDh + 2 * resizeMargin);
    graphics.endFill();
    setCxy(0, 0);
    setDwh(areaDw, areaDh);
    // TODO the scroll of the content this widget stands in has to hear that the
    // pointer is above it: getParentContentSingle().getBaseScroll().doRollOver();
  }
  /**
   * Gives the widget the dimensions it has been resized to, saves them into the widget layer
   * and takes the rectangle showing them away. A corner that has been grabbed and released
   * without any movement at all leaves the widget alone.
   */
  override public function finishPress():void
  {
    application.trace("<" + this + " WidgetResizer finishPress> called.", 1);
    super.finishPress();
    if (pressed)
    {
      removeEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer);
      if (widget.mouseX != prevMouseX || widget.mouseY != prevMouseY)
      {
        widget.setDwh(widget.getDw() + widget.mouseX - prevMouseX, widget.getDh() + widget.mouseY - prevMouseY);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().getWidgets().saveWidgetSizes(widget, widget.getDw(), widget.getDh());
        }
      }
      refreshArea(areaDw, areaDh);
    }
  }
  /**
   * Forgets the press of this resizer and the pointer position it has been started at.
   */
  override public function clearPress():void
  {
    application.trace("<" + this + " WidgetResizer clearPress> called.", 1);
    super.clearPress();
    prevMouseX = 0;
    prevMouseY = 0;
  }
  /**
   * Starts the resizing of the widget, which a widget filling the whole content it stands in
   * is not resized by. A widget that has been pushed out of the content it stands in is put
   * back into that content instead: the corner of a widget has to be reachable before it can
   * be grabbed at all.
   * @param e the mouse down event of this resizer
   */
  override protected function grabberMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " WidgetResizer grabberMouseDown> called.", 1);
    application.trace("<" + this + " WidgetResizer grabberMouseDown> e: " + e, 0);
    super.grabberMouseDown(e);
    if (!widget.isFillingTheWholeContent())
    {
      if (widget.getCx() < 0 || widget.getCy() < 0)
      {
        widget.safePlace();
      }
      else
      {
        pressed = true;
        prevMouseX = widget.mouseX;
        prevMouseY = widget.mouseY;
        addEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer);
      }
    }
  }
  /**
   * Draws the rectangle showing the dimensions the widget is being resized to.
   * @param e the enter frame event
   */
  private function enterFrameUpdateResizer(e:Event):void
  {
    application.trace("<" + this + " WidgetResizer enterFrameUpdateResizer> called.", 0);
    application.trace("<" + this + " WidgetResizer enterFrameUpdateResizer> e: " + e, 0);
    const resizeMargin:int = application.getComponentsConfig().getResizeMargin();
    const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
    graphics.clear();
    graphics.lineStyle(lineThickness, application.getDynamicsConfig().getAppBackgroundColorDark(), application.getComponentsConfig().getLineAlpha(), application.getComponentsConfig().getPixelHinting());
    graphics.drawRect(-resizeMargin, -resizeMargin, widget.getDw() + widget.mouseX - prevMouseX + 2 * resizeMargin - lineThickness, widget.getDh() + widget.mouseY - prevMouseY + 2 * resizeMargin - lineThickness);
  }
  /**
   * Frees all listeners and values held by this resizer.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetResizer destroy> called.", 1);
    application.trace("<" + this + " WidgetResizer destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    removeEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer);
    application.trace("<" + this + " WidgetResizer destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    prevMouseX = 0;
    prevMouseY = 0;
    areaDw = 0;
    areaDh = 0;
  }
}
/**
 * WidgetMenu: the submenu of the header of one widget, one button per row on the same
 * background as that header. Every navigation button of the widget lives in a row of it,
 * with a label beside its icon, and it drops down from under the more button of the header
 * over the content area of that widget.
 * It measures its own rows: every row becomes as wide as the widest one of them, the whole
 * submenu is only as tall as the rows it holds, and it never grows beyond the content area
 * it has been given, because those rows scroll. A row of a button that is not available at
 * the moment is left out, so a button turned off leaves no empty row behind.
 * It is the widget that owns the open state of this submenu: the more button that toggles it
 * stands in the header and it is that widget which hides what an open submenu covers.
 */
internal class WidgetMenu extends WidgetPart
{
  private var menuBackLabel:BaseShape = null;
  private var menuContent:ContentSingle = null;
  private var buttonLinkInfo:ButtonLink = null;
  private var buttonLinkMima:ButtonLink = null;
  private var buttonLinkFull:ButtonLink = null;
  private var buttonLinkPrev:ButtonLink = null;
  private var buttonLinkNext:ButtonLink = null;
  private var buttonLinkList:ButtonLink = null;
  private var buttonLinkMove:ButtonLink = null;
  private var rows:int = 0;
  private var contentAreaCy:int = 0;
  private var contentAreaDw:int = 0;
  private var contentAreaDh:int = 0;
  /**
   * Constructs the submenu: builds its background, the content holding its rows and every
   * row button of it, then turns off the rows the application is not configured for.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this submenu belongs to
   */
  public function WidgetMenu(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef, widgetRef);
    application.trace("<" + this + " WidgetMenu> called.", 1);
    application.trace("<" + this + " WidgetMenu> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetMenu> widgetRef: " + widgetRef, 0);
    menuBackLabel = new BaseShape(application);
    addChild(menuBackLabel);
    menuBackLabel.setIsBright(true);
    menuBackLabel.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
    menuContent = new ContentSingle(application);
    addChild(menuContent);
    menuContent.getBaseScroll().setEnabledHorizontal(false);
    menuContent.setOrientation(EnumOrientations.ORIENTATION_VERTICAL());
    menuContent.setElementsFix(0);
    buttonLinkInfo = createRowButton(EnumIcons.info(), EnumTextKeys.WIDGET_MENU_INFO(), rowInfoClick);
    buttonLinkMima = createRowButton(EnumIcons.minimize(), EnumTextKeys.WIDGET_MENU_MINIMIZE(), rowMimaClick);
    buttonLinkFull = createRowButton(EnumIcons.maximize(), EnumTextKeys.WIDGET_MENU_FULLSCREEN(), rowFullClick);
    buttonLinkPrev = createRowButton(EnumIcons.leftarrow(), EnumTextKeys.WIDGET_MENU_PREV(), rowPrevClick);
    buttonLinkNext = createRowButton(EnumIcons.rightarrow(), EnumTextKeys.WIDGET_MENU_NEXT(), rowNextClick);
    buttonLinkList = createRowButton(EnumIcons.settings(), EnumTextKeys.WIDGET_MENU_LIST(), rowListClick);
    buttonLinkMove = createRowButton(EnumIcons.downarrow(), EnumTextKeys.WIDGET_MENU_MOVE(), rowMoveClick);
    if (!application.getComponentsConfig().getWidgetEnableManualHide())
    {
      buttonLinkMima.setSpriteVisible(false);
    }
    buttonLinkInfo.setSpriteVisible(false);
    // the fullscreen belongs to the desktop mode: every widget of a mobile mode covers
    // the whole content it stands in already, so there is nothing to be maximized there
    if (!application.getDynamicsConfig().weAreInDesktopMode())
    {
      buttonLinkFull.setSpriteVisible(false);
    }
    application.trace("<" + this + " WidgetMenu> constructed.", 1);
  }
  /**
   * Returns the number of the rows this submenu holds at the moment.
   */
  public function getRowCount():int
  {
    return rows;
  }
  /**
   * Rebuilds the rows of this submenu from the buttons that are available at the moment, so
   * a button turned off leaves no empty row behind.
   */
  public function refreshRows():void
  {
    application.trace("<" + this + " WidgetMenu refreshRows> called.", 1);
    var cellIndex:int = 0;
    cellIndex = refreshRow(buttonLinkInfo, cellIndex);
    cellIndex = refreshRow(buttonLinkMima, cellIndex);
    cellIndex = refreshRow(buttonLinkFull, cellIndex);
    cellIndex = refreshRow(buttonLinkPrev, cellIndex);
    cellIndex = refreshRow(buttonLinkNext, cellIndex);
    cellIndex = refreshRow(buttonLinkList, cellIndex);
    cellIndex = refreshRow(buttonLinkMove, cellIndex);
    application.trace("<" + this + " WidgetMenu refreshRows> rows: " + cellIndex, 0);
    rows = cellIndex;
  }
  /**
   * Refreshes the label of the info row so that it tells what its click does next: it opens
   * the info text box when the content is shown, and it brings the content back when the
   * info text box is the visible one.
   */
  public function refreshInfoRow():void
  {
    application.trace("<" + this + " WidgetMenu refreshInfoRow> called.", 1);
    if (buttonLinkInfo != null)
    {
      const infoShown:Boolean = widget.getInfoContentVisible();
      application.trace("<" + this + " WidgetMenu refreshInfoRow> infoShown: " + infoShown, 0);
      buttonLinkInfo.setLabel(infoShown ? EnumTextKeys.WIDGET_MENU_CONTENT() : EnumTextKeys.WIDGET_MENU_INFO());
    }
  }
  /**
   * Refreshes the icon and the label of the fullscreen row so that they tell what its click
   * does next: it maximizes the widget while it stands among the other widgets, and it takes
   * that widget back among them while it stands in fullscreen.
   */
  public function refreshFullRow():void
  {
    application.trace("<" + this + " WidgetMenu refreshFullRow> called.", 1);
    if (buttonLinkFull != null)
    {
      const inFullscreen:Boolean = widget.getIsWidgetInFullscreen();
      application.trace("<" + this + " WidgetMenu refreshFullRow> inFullscreen: " + inFullscreen, 0);
      buttonLinkFull.setIcon(inFullscreen ? EnumIcons.minimize() : EnumIcons.maximize());
      buttonLinkFull.setLabel(inFullscreen
        ? EnumTextKeys.WIDGET_MENU_FULLSCREENOFF() : EnumTextKeys.WIDGET_MENU_FULLSCREEN());
    }
  }
  /**
   * Tells this submenu the content area of the widget it may drop down over, and lays its
   * rows out inside that area right away.
   * @param cy the y coordinate of that content area
   * @param dw the width of that content area
   * @param dh the height of that content area
   */
  public function setContentArea(cy:int, dw:int, dh:int):void
  {
    application.trace("<" + this + " WidgetMenu setContentArea> called.", 1);
    application.trace("<" + this + " WidgetMenu setContentArea> cy: " + cy, 0);
    application.trace("<" + this + " WidgetMenu setContentArea> dw: " + dw, 0);
    application.trace("<" + this + " WidgetMenu setContentArea> dh: " + dh, 0);
    contentAreaCy = cy;
    contentAreaDw = dw;
    contentAreaDh = dh;
    resizeRows();
  }
  /**
   * Sizes this submenu to the rows it holds and puts it to the top right corner of the
   * content area of the widget, so it drops down from under the close and more buttons.
   * The background of this submenu is drawn the same way as the one of the header.
   */
  public function resizeRows():void
  {
    application.trace("<" + this + " WidgetMenu resizeRows> called.", 1);
    if (menuContent == null || menuBackLabel == null)
    {
      return;
    }
    const margin:int = application.getDynamicsConfig().getAppMargin();
    const padding:int = application.getDynamicsConfig().getAppPadding();
    // the rows have to be let back to their own widths before the widest one is looked for,
    // otherwise a row that has got a longer label meanwhile would stay cut to the old width
    setRowsMaxWidth(0);
    const maxw:int = rowsMaxDw();
    application.trace("<" + this + " WidgetMenu resizeRows> maxw: " + maxw, 0);
    if (maxw > 2 * padding)
    {
      // a row is its label plus a padding on both sides, so this makes every row as wide
      // as the widest one is, and the label of that widest row still fits exactly
      setRowsMaxWidth(maxw - 2 * padding);
    }
    // the heights are asked for after the widths have been settled, a row that has been
    // widened can become lower because its label does not need more than one line any more
    const sumh:int = rowsSumDh();
    application.trace("<" + this + " WidgetMenu resizeRows> sumh: " + sumh, 0);
    // the content puts a margin before the first row and one between every two rows, so
    // the widest row and the sum of the row heights need one more margin to close them,
    // and that leaves the very same margin around the rows on all of the four sides.
    // The rows scroll, so this submenu never has to grow beyond the area it drops over
    menuContent.setDwh(Math.min(maxw + 2 * margin, contentAreaDw)
      , Math.min(sumh + (rows + 1) * margin, contentAreaDh));
    menuContent.setCxy(Math.max(margin, widget.getDw() - margin - menuContent.getDw()), contentAreaCy);
    menuBackLabel.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorDark(), application.getDynamicsConfig().getAppBackgroundColorMid(), application.getDynamicsConfig().getAppBackgroundColorAlpha() / 2, application.getDynamicsConfig().getAppBackgroundColorBright());
    menuBackLabel.x = menuContent.getCx();
    menuBackLabel.y = menuContent.getCy();
    menuBackLabel.setRadius(application.getDynamicsConfig().getAppRadius());
    menuBackLabel.setDwh(menuContent.getDw(), menuContent.getDh());
    menuBackLabel.drawRect();
  }
  /**
   * Puts the background of this submenu below the rows of it and scrolls those rows back to
   * their top. This is asked for every time the submenu is opened: the background is drawn
   * into this object and the rows are added into it later on, so the depth of the two of
   * them has to be taken again.
   */
  public function raiseRows():void
  {
    application.trace("<" + this + " WidgetMenu raiseRows> called.", 1);
    if (menuBackLabel != null && menuContent != null)
    {
      setChildIndex(menuBackLabel, numChildren - 1);
      menuContent.toTheHighestDepth();
      menuContent.toTop();
    }
  }
  /**
   * Closes this submenu if the mouse has been released outside of the rows of it and outside
   * of the given sprite. That sprite is the more button of the header, which owns its own
   * toggling, so it has to be left alone here.
   * @param exceptSprite the sprite the presses of which are left alone
   */
  public function closeIfClickedOutside(exceptSprite:BaseSprite):void
  {
    application.trace("<" + this + " WidgetMenu closeIfClickedOutside> called.", 1);
    application.trace("<" + this + " WidgetMenu closeIfClickedOutside> exceptSprite: " + exceptSprite, 0);
    const mx:int = mouseX;
    const my:int = mouseY;
    if (!mouseIsOver(exceptSprite, mx, my) && !mouseIsOver(menuContent, mx, my))
    {
      widget.setMenuOpen(false);
    }
  }
  /**
   * Minimizes the widget to its header only or restores it to its full dimensions, and
   * refreshes the icon and the label of the row that does it, so they tell what the next
   * click of that row does.
   */
  public function toggleHidden():void
  {
    application.trace("<" + this + " WidgetMenu toggleHidden> called.", 1);
    if (buttonLinkMima != null && application.getComponentsConfig().getWidgetEnableManualHide())
    {
      widget.setHidden(!widget.getHidden());
      buttonLinkMima.setIcon(widget.getHidden() ? EnumIcons.maximize() : EnumIcons.minimize());
      buttonLinkMima.setLabel(widget.getHidden() ? EnumTextKeys.WIDGET_MENU_MAXIMIZE() : EnumTextKeys.WIDGET_MENU_MINIMIZE());
    }
  }
  /**
   * Shows or hides the info row of this submenu.
   * @param v true if that row has to be available
   */
  public function setInfoRowVisible(v:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setInfoRowVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setInfoRowVisible> v: " + v, 0);
    setRowVisible(buttonLinkInfo, v);
  }
  /**
   * Shows or hides the minimize row of this submenu.
   * @param v true if that row has to be available
   */
  public function setMimaRowVisible(v:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setMimaRowVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setMimaRowVisible> v: " + v, 0);
    setRowVisible(buttonLinkMima, v);
  }
  /**
   * Shows or hides the fullscreen row of this submenu.
   * @param v true if that row has to be available
   */
  public function setFullRowVisible(v:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setFullRowVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setFullRowVisible> v: " + v, 0);
    setRowVisible(buttonLinkFull, v);
  }
  /**
   * Shows or hides the move row of this submenu.
   * @param v true if that row has to be available
   */
  public function setMoveRowVisible(v:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setMoveRowVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setMoveRowVisible> v: " + v, 0);
    setRowVisible(buttonLinkMove, v);
  }
  /**
   * Shows or hides the previous, next and list rows of this submenu.
   * @param prev true if the previous row has to be available
   * @param next true if the next row has to be available
   * @param list true if the list row has to be available
   */
  public function setNavigationRowsVisible(prev:Boolean, next:Boolean, list:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setNavigationRowsVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setNavigationRowsVisible> prev: " + prev, 0);
    application.trace("<" + this + " WidgetMenu setNavigationRowsVisible> next: " + next, 0);
    application.trace("<" + this + " WidgetMenu setNavigationRowsVisible> list: " + list, 0);
    setRowVisible(buttonLinkPrev, prev);
    setRowVisible(buttonLinkNext, next);
    setRowVisible(buttonLinkList, list);
  }
  /**
   * Creates one row button of this submenu and registers its click listener.
   * This submenu positions its rows itself, so no resize listener is needed here, and the
   * button is not added to any display list either: it is the rebuilding of the rows that
   * puts an available button into the content holding them.
   * @param iconType the icon type of the new button
   * @param label the text code displayed beside that icon
   * @param clickListener the listener to be called when that button is clicked
   */
  private function createRowButton(iconType:String, label:String, clickListener:Function):ButtonLink
  {
    application.trace("<" + this + " WidgetMenu createRowButton> called.", 1);
    application.trace("<" + this + " WidgetMenu createRowButton> iconType: " + iconType, 0);
    application.trace("<" + this + " WidgetMenu createRowButton> label: " + label, 0);
    application.trace("<" + this + " WidgetMenu createRowButton> clickListener: " + clickListener, 0);
    const buttonLink:ButtonLink = new ButtonLink(application);
    buttonLink.setIcon(iconType);
    buttonLink.setLabel(label);
    buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), clickListener);
    return buttonLink;
  }
  /**
   * Shows or hides one row of this submenu when that row is there at all.
   * @param buttonLink the button of that row
   * @param v true if that row has to be available
   */
  private function setRowVisible(buttonLink:ButtonLink, v:Boolean):void
  {
    application.trace("<" + this + " WidgetMenu setRowVisible> called.", 1);
    application.trace("<" + this + " WidgetMenu setRowVisible> buttonLink: " + buttonLink, 0);
    application.trace("<" + this + " WidgetMenu setRowVisible> v: " + v, 0);
    if (buttonLink != null)
    {
      buttonLink.setSpriteVisible(v);
    }
  }
  /**
   * Puts one button into the row of the given index if that button is available, takes it
   * out of this submenu otherwise, and returns the index of the next row.
   * @param buttonLink the button of that row
   * @param cellIndex the index of that row
   */
  private function refreshRow(buttonLink:ButtonLink, cellIndex:int):int
  {
    application.trace("<" + this + " WidgetMenu refreshRow> called.", 1);
    application.trace("<" + this + " WidgetMenu refreshRow> buttonLink: " + buttonLink, 0);
    application.trace("<" + this + " WidgetMenu refreshRow> cellIndex: " + cellIndex, 0);
    if (buttonLink == null)
    {
      return cellIndex;
    }
    if (buttonLink.visible)
    {
      menuContent.addToContent(buttonLink, cellIndex);
      menuContent.changeCellIndex(buttonLink, cellIndex);
      return cellIndex + 1;
    }
    menuContent.removeFromContent(buttonLink);
    return cellIndex;
  }
  /**
   * Returns true if the given point is inside the given sprite.
   * @param baseSprite the sprite standing in the coordinates of the widget
   * @param mx the x coordinate of that point, in the coordinates of the widget
   * @param my the y coordinate of that point, in the coordinates of the widget
   */
  private function mouseIsOver(baseSprite:BaseSprite, mx:int, my:int):Boolean
  {
    application.trace("<" + this + " WidgetMenu mouseIsOver> called.", 1);
    if (baseSprite == null)
    {
      return false;
    }
    return mx >= baseSprite.getCx() && mx <= baseSprite.getCx(true)
        && my >= baseSprite.getCy() && my <= baseSprite.getCy(true);
  }
  /**
   * Returns the width of the widest row of this submenu, zero when it holds no row at all.
   */
  private function rowsMaxDw():int
  {
    application.trace("<" + this + " WidgetMenu rowsMaxDw> called.", 1);
    var maxw:int = 0;
    maxw = maxRowDw(buttonLinkInfo, maxw);
    maxw = maxRowDw(buttonLinkMima, maxw);
    maxw = maxRowDw(buttonLinkFull, maxw);
    maxw = maxRowDw(buttonLinkPrev, maxw);
    maxw = maxRowDw(buttonLinkNext, maxw);
    maxw = maxRowDw(buttonLinkList, maxw);
    maxw = maxRowDw(buttonLinkMove, maxw);
    return maxw;
  }
  /**
   * Returns the sum of the heights of the rows of this submenu.
   */
  private function rowsSumDh():int
  {
    application.trace("<" + this + " WidgetMenu rowsSumDh> called.", 1);
    var sumh:int = 0;
    sumh = sumRowDh(buttonLinkInfo, sumh);
    sumh = sumRowDh(buttonLinkMima, sumh);
    sumh = sumRowDh(buttonLinkFull, sumh);
    sumh = sumRowDh(buttonLinkPrev, sumh);
    sumh = sumRowDh(buttonLinkNext, sumh);
    sumh = sumRowDh(buttonLinkList, sumh);
    sumh = sumRowDh(buttonLinkMove, sumh);
    return sumh;
  }
  /**
   * Gives the same maximum width to every row of this submenu, so all of them get the very
   * same width. A zero width lets every row take the width of its own label again.
   * @param w the new maximum width of every row
   */
  private function setRowsMaxWidth(w:int):void
  {
    application.trace("<" + this + " WidgetMenu setRowsMaxWidth> called.", 1);
    application.trace("<" + this + " WidgetMenu setRowsMaxWidth> w: " + w, 0);
    setRowMaxWidth(buttonLinkInfo, w);
    setRowMaxWidth(buttonLinkMima, w);
    setRowMaxWidth(buttonLinkFull, w);
    setRowMaxWidth(buttonLinkPrev, w);
    setRowMaxWidth(buttonLinkNext, w);
    setRowMaxWidth(buttonLinkList, w);
    setRowMaxWidth(buttonLinkMove, w);
  }
  /**
   * Gives the given maximum width to one row of this submenu when that row is available.
   * @param buttonLink the button of that row
   * @param w the new maximum width of that row
   */
  private function setRowMaxWidth(buttonLink:ButtonLink, w:int):void
  {
    application.trace("<" + this + " WidgetMenu setRowMaxWidth> called.", 1);
    if (buttonLink != null && buttonLink.visible)
    {
      buttonLink.setMaxWidth(w, false);
    }
  }
  /**
   * Returns the greater one of the given width and the width of the given row, the given
   * width itself when that row is not available at the moment.
   * @param buttonLink the button of that row
   * @param maxw the greatest row width found so far
   */
  private function maxRowDw(buttonLink:ButtonLink, maxw:int):int
  {
    application.trace("<" + this + " WidgetMenu maxRowDw> called.", 1);
    if (buttonLink != null && buttonLink.visible && maxw < buttonLink.getDw())
    {
      return buttonLink.getDw();
    }
    return maxw;
  }
  /**
   * Returns the given height increased by the height of the given row, the given height
   * itself when that row is not available at the moment.
   * @param buttonLink the button of that row
   * @param sumh the sum of the row heights found so far
   */
  private function sumRowDh(buttonLink:ButtonLink, sumh:int):int
  {
    application.trace("<" + this + " WidgetMenu sumRowDh> called.", 1);
    if (buttonLink != null && buttonLink.visible)
    {
      return sumh + buttonLink.getDh();
    }
    return sumh;
  }
  /**
   * Switches between the content and the info text box of the widget. This submenu is closed
   * before that swap is asked for, because an open submenu hides both of them, so the state
   * this click has to be read from is the one that comes back with that closing: reading the
   * hidden one would answer every click with the info text.
   * @param e the click event of the info row
   */
  private function rowInfoClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowInfoClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowInfoClick> e: " + e, 0);
    widget.setMenuOpen(false);
    widget.setInfoContentVisible(!widget.getInfoContentVisible());
  }
  /**
   * Minimizes the widget or restores it.
   * @param e the click event of the minimize row
   */
  private function rowMimaClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowMimaClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowMimaClick> e: " + e, 0);
    widget.setMenuOpen(false);
    toggleHidden();
  }
  /**
   * Puts the widget into fullscreen or takes it back among the other widgets.
   * @param e the click event of the fullscreen row
   */
  private function rowFullClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowFullClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowFullClick> e: " + e, 0);
    widget.setMenuOpen(false);
    widget.setIsWidgetInFullscreen(!widget.getIsWidgetInFullscreen());
  }
  /**
   * Goes to the widget standing before the one this submenu belongs to.
   * @param e the click event of the previous row
   */
  private function rowPrevClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowPrevClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowPrevClick> e: " + e, 0);
    widget.setMenuOpen(false);
    if (application.getMiddleground() != null)
    {
      application.getMiddleground().getWidgets().goToPrevWidget(widget);
    }
  }
  /**
   * Goes to the widget standing after the one this submenu belongs to.
   * @param e the click event of the next row
   */
  private function rowNextClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowNextClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowNextClick> e: " + e, 0);
    widget.setMenuOpen(false);
    if (application.getMiddleground() != null)
    {
      application.getMiddleground().getWidgets().goToNextWidget(widget);
    }
  }
  /**
   * Opens the list of every widget of the application.
   * @param e the click event of the list row
   */
  private function rowListClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowListClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowListClick> e: " + e, 0);
    widget.setMenuOpen(false);
    if (application.getForeground() != null)
    {
      application.getForeground().createWidgetsList();
    }
  }
  /**
   * Opens the list of the widget containers the widget can be moved into.
   * @param e the click event of the move row
   */
  private function rowMoveClick(e:Event):void
  {
    application.trace("<" + this + " WidgetMenu rowMoveClick> called.", 1);
    application.trace("<" + this + " WidgetMenu rowMoveClick> e: " + e, 0);
    widget.setMenuOpen(false);
    if (application.getForeground() != null)
    {
      application.getForeground().createContentsList(widget);
    }
  }
  /**
   * Takes one row button out of this submenu and destroys it.
   * A button that is not available at the moment stands in no display list at all, so the
   * super destroy would never reach it: every one of them is freed here by hand instead. It
   * is destroyed before it is taken out, so it still has its stage property inside.
   * @param buttonLink the button of that row
   */
  private function destroyRowButton(buttonLink:ButtonLink):void
  {
    application.trace("<" + this + " WidgetMenu destroyRowButton> called.", 1);
    application.trace("<" + this + " WidgetMenu destroyRowButton> buttonLink: " + buttonLink, 0);
    if (buttonLink != null)
    {
      buttonLink.destroy(); // destroy() first to still have stage property inside
      if (menuContent != null)
      {
        menuContent.removeFromContent(buttonLink);
      }
    }
  }
  /**
   * Frees every row button, listener and reference held by this submenu.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetMenu destroy> called.", 1);
    application.trace("<" + this + " WidgetMenu destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    destroyRowButton(buttonLinkInfo);
    destroyRowButton(buttonLinkMima);
    destroyRowButton(buttonLinkFull);
    destroyRowButton(buttonLinkPrev);
    destroyRowButton(buttonLinkNext);
    destroyRowButton(buttonLinkList);
    destroyRowButton(buttonLinkMove);
    application.trace("<" + this + " WidgetMenu destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    menuBackLabel = null;
    menuContent = null;
    buttonLinkInfo = null;
    buttonLinkMima = null;
    buttonLinkFull = null;
    buttonLinkPrev = null;
    buttonLinkNext = null;
    buttonLinkList = null;
    buttonLinkMove = null;
    rows = 0;
    contentAreaCy = 0;
    contentAreaDw = 0;
    contentAreaDh = 0;
  }
}
/**
 * WidgetInfoLabel: the label standing in the middle of one widget, telling that the content
 * of that widget is empty. It never grows wider than the widget it belongs to, it keeps
 * itself in the middle of that widget, and it repositions itself every time it is resized,
 * so the widget only has to tell it what to say.
 */
internal class WidgetInfoLabel extends WidgetPart
{
  private var textLabel:TextLabel = null;
  /**
   * Constructs the info label and hooks the listener that keeps it in the middle.
   * @param applicationRef the application reference passed to the base sprite
   * @param widgetRef the widget this info label belongs to
   */
  public function WidgetInfoLabel(applicationRef:Application, widgetRef:Widget):void
  {
    super(applicationRef, widgetRef);
    application.trace("<" + this + " WidgetInfoLabel> called.", 1);
    application.trace("<" + this + " WidgetInfoLabel> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " WidgetInfoLabel> widgetRef: " + widgetRef, 0);
    textLabel = new TextLabel(application);
    addChild(textLabel);
    textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
    textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), textLabelDimensionsChanged);
    application.trace("<" + this + " WidgetInfoLabel> constructed.", 1);
  }
  /**
   * Sets the text of this info label and lays it out again.
   * @param t the text code of this info label
   */
  public function setLabel(t:String):void
  {
    application.trace("<" + this + " WidgetInfoLabel setLabel> called.", 1);
    application.trace("<" + this + " WidgetInfoLabel setLabel> t: " + t, 0);
    textLabel.setLabel(t);
    safeResize();
  }
  /**
   * Limits the width of this info label to the width of the widget and repositions it.
   */
  public function safeResize():void
  {
    application.trace("<" + this + " WidgetInfoLabel safeResize> called.", 1);
    if (textLabel != null)
    {
      const max:int = widget.getDw() - 2 * application.getDynamicsConfig().getAppMargin();
      application.trace("<" + this + " WidgetInfoLabel safeResize> max: " + max, 0);
      textLabel.setMaxWidth(textLabel.getDw() > max ? max : 0, textLabel.getDw() > max);
    }
    repos();
  }
  /**
   * Positions this info label into the middle of the widget.
   */
  private function repos():void
  {
    application.trace("<" + this + " WidgetInfoLabel repos> called.", 1);
    if (textLabel != null)
    {
      textLabel.setCxy((widget.getDw() - textLabel.getDw()) / 2, (widget.getDh() - textLabel.getDh()) / 2);
    }
  }
  /**
   * Repositions this info label after it has been resized.
   * @param e the dimensions changed event of the label of this object
   */
  private function textLabelDimensionsChanged(e:Event):void
  {
    application.trace("<" + this + " WidgetInfoLabel textLabelDimensionsChanged> called.", 1);
    application.trace("<" + this + " WidgetInfoLabel textLabelDimensionsChanged> e: " + e, 0);
    repos();
  }
  /**
   * Frees every reference held by this info label.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " WidgetInfoLabel destroy> called.", 1);
    application.trace("<" + this + " WidgetInfoLabel destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    textLabel = null;
  }
}
