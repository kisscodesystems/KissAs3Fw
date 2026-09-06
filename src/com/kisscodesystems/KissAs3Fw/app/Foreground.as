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
 * Foreground.
 * The top layer of the application: it displays the alerts and the lists that
 * have to be answered before anything else can be done.
 *
 * MAIN FEATURES:
 * - displays alerts with an ok, or with an ok and a cancel button
 * - displays the list of the widgets and the list of the widget containers
 * - a newer alert goes to the bottom of the contents, as a multiple content works
 * - invisible by default, and it becomes invisible again when nothing is left on it
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumSounds;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Fw.ui.TextBox;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class Foreground extends BaseSprite
  {
    // the holder of everything this object displays
    protected var contentMultiple:ContentMultiple = null;
    // the elements of the list of the widgets, and the index of the content holding them
    private var widgetsLabel:TextLabel = null;
    private var widgetsList:ListPanel = null;
    private var widgetListIndex:int = -1;
    // the elements of the list of the widget containers to move a widget into,
    // the index of the content holding them and the widget to be moved
    private var contentsLabel:TextLabel = null;
    private var contentsListPicker:ListPicker = null;
    private var widgetMoveIndex:int = -1;
    private var widgetToBeMoved:Widget = null;
    /**
     * Constructs the foreground. It holds nothing and it is invisible until the
     * first alert or list is asked for.
     * @param applicationRef the main application reference
     */
    public function Foreground(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Foreground> called.", 1);
      application.trace("<" + this + " Foreground> applicationRef: " + applicationRef, 0);
      visible = false;
      application.trace("<" + this + " Foreground> constructed.", 1);
    }
    /**
     * Creates a new alert with an ok, and optionally with a cancel button on it.
     * @param messageString the message to be displayed
     * @param uniqueString the unique identifier of this alert, the custom event
     *                     strings of the buttons are built of it
     * @param eventOK whether the ok button is needed, an alert without it displays nothing
     * @param eventCANCEL whether the cancel button is needed as well
     * @param prio whether this alert has to be the active content right away
     * @param fullscreen whether this alert has to fill the whole application
     */
    public function createAlert(messageString:String
        , uniqueString:String
        , eventOK:Boolean
        , eventCANCEL:Boolean
        , prio:Boolean = false
        , fullscreen:Boolean = false):void
    {
      application.trace("<" + this + " Foreground createAlert> called.", 1);
      application.trace("<" + this + " Foreground createAlert> messageString: " + messageString, 0);
      application.trace("<" + this + " Foreground createAlert> uniqueString: " + uniqueString, 0);
      application.trace("<" + this + " Foreground createAlert> eventOK: " + eventOK, 0);
      application.trace("<" + this + " Foreground createAlert> eventCANCEL: " + eventCANCEL, 0);
      application.trace("<" + this + " Foreground createAlert> prio: " + prio, 0);
      application.trace("<" + this + " Foreground createAlert> fullscreen: " + fullscreen, 0);
      if (messageString == null || !eventOK)
      {
        application.trace("<" + this + " Foreground createAlert> an alert without a message or without an ok button displays nothing.", 0);
        return;
      }
      createContentMultiple(fullscreen);
      const index:int = contentMultiple.addContent(uniqueString);
      if (index < 0)
      {
        application.trace("<" + this + " Foreground createAlert> unable to add the content of this alert.", 6);
        return;
      }
      prepareContent(index);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const textBox:TextBox = new TextBox(application);
      contentMultiple.addToContent(index, textBox, 0);
      textBox.setLabel(messageString);
      textBox.setWordWrap(true);
      const buttonOK:ButtonText = createAlertButton(index, uniqueString, EnumOkCancel.OC_OK(), EnumIcons.ok());
      textBox.setCxy(margin, margin);
      textBox.setDwh(contentMultiple.getDw() - 2 * margin
          , contentMultiple.getDh() - 3 * margin - buttonOK.getDh());
      if (eventCANCEL)
      {
        const buttonCANCEL:ButtonText = createAlertButton(index, uniqueString, EnumOkCancel.OC_CANCEL(), EnumIcons.cancel());
        buttonOK.setCxy((contentMultiple.getDw() - buttonOK.getDw() - buttonCANCEL.getDw() - margin) / 2
            , textBox.getCy(true) + margin);
        buttonCANCEL.setCxy(buttonOK.getCx(true) + margin, buttonOK.getCy());
        application.getSoundManager().playSound(EnumSounds.confirm());
      }
      else
      {
        buttonOK.setCxy((contentMultiple.getDw() - buttonOK.getDw()) / 2, textBox.getCy(true) + margin);
        application.getSoundManager().playSound(EnumSounds.message());
      }
      setActiveIndex(prio ? index : 0);
    }
    /**
     * Closes the alert belonging to the unique string given when it has been created.
     * The elements of it are not removed one by one: there is no reference to them
     * anymore, so the content itself frees them up.
     * @param uniqueString the unique identifier of the alert to be closed
     */
    public function closeAlert(uniqueString:String):void
    {
      application.trace("<" + this + " Foreground closeAlert> called.", 1);
      application.trace("<" + this + " Foreground closeAlert> uniqueString: " + uniqueString, 0);
      if (contentMultiple == null)
      {
        application.trace("<" + this + " Foreground closeAlert> there is no alert to be closed.", 0);
        return;
      }
      const index:int = contentMultiple.getContentIndexByLabel(uniqueString);
      if (index != -1)
      {
        contentMultiple.removeContent(index);
      }
      setVisibleFalseIfNoMoreObjects();
    }
    /**
     * Creates the list of the widgets of this application. Picking one of them
     * takes the one using the application to that widget.
     */
    public function createWidgetsList():void
    {
      application.trace("<" + this + " Foreground createWidgetsList> called.", 1);
      if (application.getMiddleground() == null)
      {
        application.trace("<" + this + " Foreground createWidgetsList> there is no middleground to ask the widgets from.", 6);
        return;
      }
      createContentMultiple();
      if (widgetListIndex != -1)
      {
        application.trace("<" + this + " Foreground createWidgetsList> the list of the widgets is already displayed.", 0);
        return;
      }
      const margin:int = application.getDynamicsConfig().getAppMargin();
      widgetListIndex = contentMultiple.addContent(EnumTextKeys.LISTS_OF_THE_WIDGETS());
      prepareContent(widgetListIndex);
      widgetsLabel = new TextLabel(application);
      contentMultiple.addToContent(widgetListIndex, widgetsLabel, 0);
      widgetsLabel.setType(EnumTextTypes.TEXT_TYPE_DARK());
      widgetsLabel.setLabel(EnumTextKeys.LISTS_OF_THE_WIDGETS());
      widgetsLabel.setCxy(margin, margin);
      widgetsList = new ListPanel(application);
      // the row of the cell 1 is left empty on purpose: it keeps this list one margin away
      // from the label above it
      contentMultiple.addToContent(widgetListIndex, widgetsList, 2);
      widgetsList.setDw(contentMultiple.getDw() - 2 * margin);
      widgetsList.setCxy(widgetsLabel.getCx(), widgetsLabel.getCy(true) + margin);
      widgetsList.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), goToTheWidget);
      widgetsList.setMultiple(false);
      widgetsList.setArrays(application.getMiddleground().getWidgets().getWidgetHeaders()
          , application.getMiddleground().getWidgets().getWidgetIds());
      widgetsList.setNumOfElements(calcNumOfElements(widgetsLabel.getCy(true) + 2 * margin
          + 2 * application.getDynamicsConfig().getAppPadding()
          + application.getComponentsConfig().getScrollMargin(), widgetsList.getTextType()));
      setActiveIndex(0);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, cancelWidgetsList, false, 0, true);
      }
    }
    /**
     * Destroys the list of the widgets.
     */
    public function closeWidgetsList():void
    {
      application.trace("<" + this + " Foreground closeWidgetsList> called.", 1);
      if (widgetListIndex != -1)
      {
        if (stage != null)
        {
          stage.removeEventListener(MouseEvent.MOUSE_DOWN, cancelWidgetsList);
        }
        // the elements are removed on demand here, outside of the destroy of this
        // object, so every one of them has to be freed up by hand
        contentMultiple.removeFromContent(widgetListIndex, widgetsLabel);
        widgetsLabel.destroy();
        widgetsLabel = null;
        contentMultiple.removeFromContent(widgetListIndex, widgetsList);
        widgetsList.destroy();
        widgetsList = null;
        contentMultiple.removeContent(widgetListIndex);
        widgetListIndex = -1;
      }
      setVisibleFalseIfNoMoreObjects();
    }
    /**
     * Creates the list of the widget containers the given widget can be moved into.
     * @param widget the widget to be moved into another container
     */
    public function createContentsList(widget:Widget):void
    {
      application.trace("<" + this + " Foreground createContentsList> called.", 1);
      application.trace("<" + this + " Foreground createContentsList> widget: " + widget, 0);
      if (application.getMiddleground() == null || widget == null)
      {
        application.trace("<" + this + " Foreground createContentsList> there is no middleground or no widget to work with.", 6);
        return;
      }
      createContentMultiple();
      if (widgetMoveIndex != -1)
      {
        application.trace("<" + this + " Foreground createContentsList> the list of the contents is already displayed.", 0);
        return;
      }
      const margin:int = application.getDynamicsConfig().getAppMargin();
      widgetToBeMoved = widget;
      widgetMoveIndex = contentMultiple.addContent(EnumTextKeys.LISTS_OF_THE_CONTENTS_TO_MOVE_INTO());
      prepareContent(widgetMoveIndex);
      contentsLabel = new TextLabel(application);
      contentMultiple.addToContent(widgetMoveIndex, contentsLabel, 0);
      contentsLabel.setType(EnumTextTypes.TEXT_TYPE_DARK());
      contentsLabel.setLabel(EnumTextKeys.LISTS_OF_THE_CONTENTS_TO_MOVE_INTO());
      contentsLabel.setCxy(margin, margin);
      contentsListPicker = new ListPicker(application);
      // the row of the cell 1 is left empty on purpose: it keeps this picker one margin
      // away from the label above it
      contentMultiple.addToContent(widgetMoveIndex, contentsListPicker, 2);
      contentsListPicker.setDw(contentsLabel.getDw());
      const array:Array = new Array();
      for (var i:int = 0; i < application.getMiddleground().getWidgets().getNumOfContents(); i++)
      {
        array.push(i + 1);
      }
      contentsListPicker.setArrays(array, array);
      contentsListPicker.setNumOfElements(calcNumOfElements(contentsLabel.getCy(true) + 2 * margin
          + 2 * application.getDynamicsConfig().getAppPadding()
          + application.getComponentsConfig().getScrollMargin(), contentsListPicker.getTextType()));
      contentsListPicker.setSelectedIndex(widget.getContentId());
      contentsListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), moveToTheContent);
      setActiveIndex(0);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, cancelMoveListPicker, false, 0, true);
      }
    }
    /**
     * Destroys the list of the widget containers.
     */
    public function closeContentsList():void
    {
      application.trace("<" + this + " Foreground closeContentsList> called.", 1);
      if (widgetMoveIndex != -1)
      {
        if (stage != null)
        {
          stage.removeEventListener(MouseEvent.MOUSE_DOWN, cancelMoveListPicker);
        }
        // the elements are removed on demand here, outside of the destroy of this
        // object, so every one of them has to be freed up by hand
        contentMultiple.removeFromContent(widgetMoveIndex, contentsLabel);
        contentsLabel.destroy();
        contentsLabel = null;
        contentMultiple.removeFromContent(widgetMoveIndex, contentsListPicker);
        contentsListPicker.destroy();
        contentsListPicker = null;
        contentMultiple.removeContent(widgetMoveIndex);
        widgetMoveIndex = -1;
        widgetToBeMoved = null;
      }
      setVisibleFalseIfNoMoreObjects();
    }
    /**
     * Repaints and repositions everything after the dimensions of this object have
     * been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " Foreground doDimensionsChanged> called.", 1);
      foregroundRedraw();
      reposContentMultiple();
      super.doDimensionsChanged();
    }
    /**
     * Creates the holder of the displayed objects if there is none of it yet.
     * @param fullscreen whether the holder has to fill the whole application
     */
    protected function createContentMultiple(fullscreen:Boolean = false):void
    {
      application.trace("<" + this + " Foreground createContentMultiple> called.", 1);
      application.trace("<" + this + " Foreground createContentMultiple> fullscreen: " + fullscreen, 0);
      if (contentMultiple == null)
      {
        setVisible(true);
        contentMultiple = new ContentMultiple(application);
        addChild(contentMultiple);
        contentMultiple.setButtonBarVisible(false);
      }
      if (fullscreen)
      {
        contentMultiple.setDwh(getDw(), getDh());
      }
      else
      {
        contentMultiple.setDwh(getDw() * (application.getDynamicsConfig().weAreInDesktopMode() ? 1 / 2 : 4 / 5), getDh() * 1 / 2);
      }
      reposContentMultiple();
    }
    /**
     * Displays the content of the given index.
     * @param index the index of the content to be displayed
     */
    protected function setActiveIndex(index:int):void
    {
      application.trace("<" + this + " Foreground setActiveIndex> called.", 1);
      application.trace("<" + this + " Foreground setActiveIndex> index: " + index, 0);
      if (contentMultiple != null)
      {
        contentMultiple.setActiveIndex(index);
      }
    }
    /**
     * Frees up the holder of the displayed objects and hides this object when there
     * is nothing left to be displayed.
     */
    protected function setVisibleFalseIfNoMoreObjects():void
    {
      application.trace("<" + this + " Foreground setVisibleFalseIfNoMoreObjects> called.", 1);
      if (contentMultiple != null && contentMultiple.getNumOfContents() == 0)
      {
        // the holder is removed on demand here, outside of the destroy of this
        // object, so it has to be freed up by hand
        contentMultiple.destroy();
        if (contains(contentMultiple))
        {
          removeChild(contentMultiple);
        }
        contentMultiple = null;
        setVisible(false);
      }
    }
    /**
     * Repaints this object in its current size. It is a fully transparent rectangle:
     * it catches every click that would otherwise reach the layers below it.
     */
    protected function foregroundRedraw():void
    {
      application.trace("<" + this + " Foreground foregroundRedraw> called.", 1);
      graphics.clear();
      graphics.lineStyle(0, 0, 0);
      graphics.beginFill(0, 0);
      graphics.drawRect(0, 0, getDw(), getDh());
      graphics.endFill();
    }
    /**
     * Prepares a content that has just been built on this layer: the elements of it stand in
     * one single column, it is never scrolled and it has no frame around it.
     * Everything this layer displays is built to the room that content has got: the text of
     * an alert is scrolled inside its own text box and a list is scrolled inside its own
     * frame, so the content holding them has nothing to be scrolled. And it must not be
     * scrolled either: an answer that slides away from under the pointer of the one giving
     * it is the last thing an alert needs.
     * The frame is dropped for the very same reason: the elements standing here carry the
     * frames of their own, and this content is as big as the half of the whole application,
     * so a frame around it would draw a big empty box around a short question.
     * @param index the index of the content to be prepared
     */
    private function prepareContent(index:int):void
    {
      application.trace("<" + this + " Foreground prepareContent> called.", 1);
      application.trace("<" + this + " Foreground prepareContent> index: " + index, 0);
      contentMultiple.setElementsFix(index, 0);
      const baseScroll:BaseScroll = contentMultiple.getBaseScroll(index);
      if (baseScroll != null)
      {
        baseScroll.setEnabledHorizontal(false);
        baseScroll.setEnabledVertical(false);
        baseScroll.setShapeFrameVisible(false);
      }
      const contentSingle:ContentSingle = contentMultiple.getContentSingle(index);
      if (contentSingle != null)
      {
        contentSingle.enableScrollingFromOthers = false;
      }
    }
    /**
     * Creates one answer button of an alert.
     * @param index the index of the content of that alert
     * @param uniqueString the unique identifier of that alert
     * @param answer the ok or the cancel answer of that alert
     * @param iconType the icon to be displayed on the button
     */
    private function createAlertButton(index:int, uniqueString:String, answer:String, iconType:String):ButtonText
    {
      application.trace("<" + this + " Foreground createAlertButton> called.", 1);
      application.trace("<" + this + " Foreground createAlertButton> index: " + index, 0);
      application.trace("<" + this + " Foreground createAlertButton> uniqueString: " + uniqueString, 0);
      application.trace("<" + this + " Foreground createAlertButton> answer: " + answer, 0);
      application.trace("<" + this + " Foreground createAlertButton> iconType: " + iconType, 0);
      const buttonText:ButtonText = new ButtonText(application);
      contentMultiple.addToContent(index, buttonText, 1);
      buttonText.setLabel(answer);
      // the one waiting for this answer is listening on the dispatcher of the
      // application for exactly this event string
      buttonText.setCustomEventString(uniqueString + answer);
      buttonText.setIcon(iconType);
      return buttonText;
    }
    /**
     * Calculates how many elements of a list fit into the free height of the holder.
     * @param usedHeight the height taken by everything standing above that list
     * @param textType the text type the elements of that list are displayed with
     */
    private function calcNumOfElements(usedHeight:int, textType:String):int
    {
      application.trace("<" + this + " Foreground calcNumOfElements> called.", 1);
      application.trace("<" + this + " Foreground calcNumOfElements> usedHeight: " + usedHeight, 0);
      application.trace("<" + this + " Foreground calcNumOfElements> textType: " + textType, 0);
      const num:int = Math.max(1, Math.floor((contentMultiple.getDh() - usedHeight)
          / application.getDynamicsConfig().getTextFieldHeight(textType)));
      application.trace("<" + this + " Foreground calcNumOfElements> num: " + num, 0);
      return num;
    }
    /**
     * Tells whether the last click has happened outside of the area of the holder.
     */
    private function clickedElsewhere():Boolean
    {
      application.trace("<" + this + " Foreground clickedElsewhere> called.", 1);
      const elsewhere:Boolean = !(mouseX > contentMultiple.getCx() && mouseX < contentMultiple.getCx(true)
        && mouseY > contentMultiple.getCy() && mouseY < contentMultiple.getCy(true));
      application.trace("<" + this + " Foreground clickedElsewhere> elsewhere: " + elsewhere, 0);
      return elsewhere;
    }
    /**
     * A widget has been picked from the list, so the application goes to that one.
     * @param e the changed event of the list of the widgets
     */
    private function goToTheWidget(e:Event):void
    {
      application.trace("<" + this + " Foreground goToTheWidget> called.", 1);
      application.trace("<" + this + " Foreground goToTheWidget> e: " + e, 0);
      const targetWidget:Widget = application.getMiddleground().getWidgets().getWidgetByHeader(
          widgetsList.getArrayLabels()[widgetsList.getSelectedIndexes()[0]]);
      application.getMiddleground().getWidgets().goToTheWidget(targetWidget);
      if (application.getComponentsConfig().getPanelSettingsEnabled())
      {
        application.getMiddleground().showWidgetContainer(targetWidget.getContentId());
      }
      closeWidgetsList();
      e.stopImmediatePropagation();
    }
    /**
     * Closes the list of the widgets when the click has happened outside of it.
     * @param e the mouse down event of the stage
     */
    private function cancelWidgetsList(e:MouseEvent):void
    {
      application.trace("<" + this + " Foreground cancelWidgetsList> called.", 1);
      application.trace("<" + this + " Foreground cancelWidgetsList> e: " + e, 0);
      if (clickedElsewhere())
      {
        closeWidgetsList();
      }
    }
    /**
     * A widget container has been picked, so the widget moves into that one.
     * @param e the changed event of the list of the widget containers
     */
    private function moveToTheContent(e:Event):void
    {
      application.trace("<" + this + " Foreground moveToTheContent> called.", 1);
      application.trace("<" + this + " Foreground moveToTheContent> e: " + e, 0);
      application.getMiddleground().getWidgets().moveWidgetFromContent(widgetToBeMoved.getContentId()
          , contentsListPicker.getSelectedIndex(), widgetToBeMoved, true);
      closeContentsList();
      e.stopImmediatePropagation();
    }
    /**
     * Closes the list of the widget containers when the click has happened outside of it.
     * @param e the mouse down event of the stage
     */
    private function cancelMoveListPicker(e:MouseEvent):void
    {
      application.trace("<" + this + " Foreground cancelMoveListPicker> called.", 1);
      application.trace("<" + this + " Foreground cancelMoveListPicker> e: " + e, 0);
      if (clickedElsewhere())
      {
        closeContentsList();
      }
    }
    /**
     * Positions the holder of the displayed objects into the middle of this object.
     */
    private function reposContentMultiple():void
    {
      application.trace("<" + this + " Foreground reposContentMultiple> called.", 1);
      if (contentMultiple != null)
      {
        contentMultiple.setCxy((getDw() - contentMultiple.getDw()) / 2, (getDh() - contentMultiple.getDh()) / 2);
      }
    }
    /**
     * Sets whether this object is visible. The layers below it must not be reachable
     * while it is, so the middleground is hidden together with it.
     * @param b whether this object has to be visible
     */
    private function setVisible(b:Boolean):void
    {
      application.trace("<" + this + " Foreground setVisible> called.", 1);
      application.trace("<" + this + " Foreground setVisible> b: " + b, 0);
      visible = b;
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().setVisible(!visible);
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Foreground destroy> called.", 1);
      application.trace("<" + this + " Foreground destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, cancelWidgetsList);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, cancelMoveListPicker);
      }
      application.trace("<" + this + " Foreground destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " Foreground destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " Foreground destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      contentMultiple = null;
      widgetsLabel = null;
      widgetsList = null;
      widgetListIndex = -1;
      contentsLabel = null;
      contentsListPicker = null;
      widgetMoveIndex = -1;
      widgetToBeMoved = null;
    }
  }
}
