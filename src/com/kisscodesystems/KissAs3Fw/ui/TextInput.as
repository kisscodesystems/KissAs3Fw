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
 * TextInput.
 * A single line text input field.
 *
 * MAIN FEATURES:
 * - the typed text can be restricted, maximized, lowered to a minimum length, turned
 *   to upper or to lower case and displayed as a password
 * - a hint is displayed while the field is empty, and a delete icon while it is not,
 *   and that icon takes no click at all while this input is disabled
 * - the auto completion offers the matching elements of a dataset in a list below the
 *   field, and the picked one becomes the element the caret stands in
 * - the text of this input can hold more elements of that dataset, separated from each
 *   other by a comma, a semicolon or a space, and an element typed already is offered
 *   no more by that completion
 * - the height of this object holds that open list as well
 * - on a mobile device the content this input stands on is scrolled up, so that the
 *   keyboard sliding in does not cover the field, and it is let back afterwards
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.FocusEvent;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.TextEvent;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.text.TextFieldType;
  import flash.ui.Keyboard;
  import flash.utils.Timer;
  public class TextInput extends BaseSprite
  {
    private var baseTextField:BaseTextField = null;
    private var baseShape:BaseShape = null;
    private var iniTextChanged:Boolean = false;
    // The characters that separate the elements typed into this input from each other
    // in every case. The separator of the dataset joins them when it is one single
    // character: that one cuts the dataset into elements, so it cuts the text as well.
    private const AUTO_COMPLETE_SEPARATORS:String = " ,;";
    // the character the parts of a search are joined by: a typed element holds no such
    // character at all, so no two different searches give the very same string
    private const AUTO_COMPLETE_SEARCH_SEPARATOR:String = "\n";
    private var autoCompleteThese:Array = null;
    private var autoCompleteList:ListPanel = null;
    private var autoCompleteCurrents:Array = null;
    // the characters the elements of the text are cut apart at, null while the auto
    // completion is turned off
    private var autoCompleteSeparators:String = null;
    // The bounds of the element the caret stood in when the list of the completion has
    // been filled: the picked element of that list replaces exactly this part of the
    // text, and everything standing around it is left alone.
    private var autoCompleteTermBegin:int = 0;
    private var autoCompleteTermEnd:int = 0;
    // The search the list of the completion is displaying the matches of at the moment,
    // in lower case: the element being typed and the elements typed already. The
    // matching ignores the case of the letters, so a search that only differs in that
    // finds the very same elements. A key that leaves both the element being typed and
    // the ones around it as they were needs no new list, and a null means that no
    // matching has happened yet.
    private var autoCompleteLastSearchTerm:String = null;
    private var eventChanged:Event = null;
    // The scrolled content this input has pushed up to stay above the keyboard of a
    // mobile device, and the scrolling of it that has to be put back afterwards. The
    // scroll is null while nothing has been pushed up.
    private var contentScrollToRestore:BaseScroll = null;
    private var contentCyToRestore:int = 0;
    private var focusoutTimer:Timer = null;
    private var focusinTimer:Timer = null;
    private var hintTextLabel:TextLabel = null;
    private var deleteIcon:Icon = null;
    /**
     * Constructs the TextInput object: creates the frame and the text field of it and
     * starts to follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function TextInput(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " TextInput> called.", 1);
      application.trace("<" + this + " TextInput> applicationRef: " + applicationRef, 0);
      mouseDownForScrollingEnabled = false;
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      baseShape = new BaseShape(application);
      addChild(baseShape);
      baseShape.setIsBright(false);
      baseShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      baseTextField = new BaseTextField(application);
      addChild(baseTextField);
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_MID());
      baseTextField.setAutoSizeNone();
      baseTextField.type = TextFieldType.INPUT;
      baseTextField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
      baseTextField.addEventListener(FocusEvent.FOCUS_IN, focusIn);
      baseTextField.addEventListener(TextEvent.TEXT_INPUT, textInput);
      baseTextField.mouseDownForScrollingEnabled = false;
      baseTextFieldRepos();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), resize);
      application.trace("<" + this + " TextInput> constructed.", 1);
    }
    /**
     * Returns the text standing in this input at the moment.
     */
    public function getText():String
    {
      return baseTextField.text;
    }
    /**
     * Sets the text of this input.
     * @param newLabel the new text or text key of this input
     */
    public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " TextInput setLabel> called.", 1);
      application.trace("<" + this + " TextInput setLabel> newLabel: " + newLabel, 0);
      baseTextField.setLabel(newLabel);
      hintTextLabelVisible();
      // a text set from the outside can be an empty one as well, and then the delete
      // icon of this input has to go
      deleteVisible();
    }
    /**
     * Displays the given hint in this input while it stands empty.
     * @param hint the hint to be displayed
     */
    public function setHint(hint:String):void
    {
      application.trace("<" + this + " TextInput setHint> called.", 1);
      application.trace("<" + this + " TextInput setHint> hint: " + hint, 0);
      if (hintTextLabel == null)
      {
        hintTextLabel = new TextLabel(application);
        addChildAt(hintTextLabel, 0);
      }
      hintTextLabelRepos();
      hintTextLabelVisible();
      hintTextLabel.setLabel(hint);
    }
    /**
     * Frees the hint of this input up, so an empty input displays nothing at all.
     */
    public function clearHint():void
    {
      application.trace("<" + this + " TextInput clearHint> called.", 1);
      if (hintTextLabel != null)
      {
        hintTextLabel.destroy();
        if (contains(hintTextLabel))
        {
          removeChild(hintTextLabel);
        }
        hintTextLabel = null;
      }
    }
    /**
     * Displays the text of this input as a password or as a plain text.
     * @param b true when the text has to be hidden
     */
    public function setDisplayAsPassword(b:Boolean):void
    {
      application.trace("<" + this + " TextInput setDisplayAsPassword> called.", 1);
      application.trace("<" + this + " TextInput setDisplayAsPassword> b: " + b, 0);
      baseTextField.setDisplayAsPassword(b);
    }
    /**
     * Turns the text standing in this input to upper case.
     */
    public function setTextToUpperCase():void
    {
      application.trace("<" + this + " TextInput setTextToUpperCase> called.", 1);
      baseTextField.setTextToUpperCase();
    }
    /**
     * Turns the text standing in this input to lower case.
     */
    public function setTextToLowerCase():void
    {
      application.trace("<" + this + " TextInput setTextToLowerCase> called.", 1);
      baseTextField.setTextToLowerCase();
    }
    /**
     * Sets the characters that can be typed into this input.
     * @param r the restriction, a flash text field restrict value
     */
    public function setRestrict(r:String):void
    {
      application.trace("<" + this + " TextInput setRestrict> called.", 1);
      application.trace("<" + this + " TextInput setRestrict> r: " + r, 0);
      baseTextField.restrict = r;
    }
    /**
     * Sets the number of the characters the text of this input has to reach.
     * @param m the minimum number of the characters
     */
    public function setMinChars(m:int):void
    {
      application.trace("<" + this + " TextInput setMinChars> called.", 1);
      application.trace("<" + this + " TextInput setMinChars> m: " + m, 0);
      baseTextField.setMinChars(m);
    }
    /**
     * Sets the number of the characters that can be typed into this input.
     * @param m the maximum number of the characters
     */
    public function setMaxChars(m:int):void
    {
      application.trace("<" + this + " TextInput setMaxChars> called.", 1);
      application.trace("<" + this + " TextInput setMaxChars> m: " + m, 0);
      baseTextField.maxChars = m;
    }
    /**
     * Tells whether the text of this input has reached its minimum length.
     */
    public function getTextIsAtLeastLength():Boolean
    {
      return baseTextField.getTextIsAtLeastLength();
    }
    /**
     * Takes the dataset the auto completion offers the matching elements of. The whole
     * previous dataset is dropped, and a null in either of the two parameters turns
     * this feature off. The text of this input can hold more elements of that dataset,
     * separated from each other by a comma, a semicolon, a space or that very
     * separator, and the completion works on the element the caret stands in.
     * @param elements the elements of the dataset in one single string
     * @param separator the string the elements are separated by
     */
    public function addAutoCompleteElements(elements:String, separator:String):void
    {
      application.trace("<" + this + " TextInput addAutoCompleteElements> called.", 1);
      application.trace("<" + this + " TextInput addAutoCompleteElements> elements: " + elements, 0);
      application.trace("<" + this + " TextInput addAutoCompleteElements> separator: " + separator, 0);
      // the elements that are held at the moment are dropped in every case: this call
      // replaces the whole dataset instead of adding anything to it
      autoCompleteListRemove();
      // the text that stands in the field has never been matched against this dataset
      autoCompleteLastSearchTerm = null;
      autoCompleteTermBegin = 0;
      autoCompleteTermEnd = 0;
      autoCompleteSeparators = null;
      if (autoCompleteThese != null)
      {
        autoCompleteThese.splice(0);
        autoCompleteThese = null;
      }
      // a null in either of the two turns this feature off
      if (elements == null || separator == null || separator == "")
      {
        application.trace("<" + this + " TextInput addAutoCompleteElements> the auto completion is turned off.", 0);
        return;
      }
      // the separator cuts the dataset into the elements of it and it is not needed
      // afterwards: the text of this input is one single element of that dataset
      autoCompleteThese = elements.split(separator);
      // a separator of one single character separates the typed elements from each other
      // as well, and a longer one cannot do that: the text is cut apart character by
      // character. The comma, the semicolon and the space always do it.
      autoCompleteSeparators = AUTO_COMPLETE_SEPARATORS
        + (separator.length == 1 && AUTO_COMPLETE_SEPARATORS.indexOf(separator) < 0 ? separator : "");
      application.trace("<" + this + " TextInput addAutoCompleteElements> number of the elements: " + autoCompleteThese.length, 0);
      application.trace("<" + this + " TextInput addAutoCompleteElements> the separators of the typed elements: " + autoCompleteSeparators, 0);
    }
    /**
     * Moves the focus of the application into this input.
     */
    public function toFocus():void
    {
      application.trace("<" + this + " TextInput toFocus> called.", 1);
      if (stage != null)
      {
        stage.focus = baseTextField;
        if (application.getDynamicsConfig().weAreInDesktopMode())
        {
          toBeVisible();
        }
      }
    }
    /**
     * Tells whether the focus of the application stands in this input at the moment.
     */
    public function isInFocus():Boolean
    {
      application.trace("<" + this + " TextInput isInFocus> called.", 1);
      if (stage != null)
      {
        return stage.focus == baseTextField;
      }
      return false;
    }
    /**
     * Enables or disables this input. A disabled one displays its text but takes no
     * typing at all, and the delete icon of it takes no click either.
     * @param b true when this input has to be enabled
     */
    override public function setEnabled(b:Boolean):void
    {
      application.trace("<" + this + " TextInput setEnabled> called.", 1);
      application.trace("<" + this + " TextInput setEnabled> b: " + b, 0);
      super.setEnabled(b);
      if (getEnabled())
      {
        baseTextField.type = TextFieldType.INPUT;
      }
      else
      {
        baseTextField.type = TextFieldType.DYNAMIC;
      }
      enableDelete();
    }
    /**
     * Sets the width of this input and draws everything again. A text input is never
     * narrower than the minimum size of the texts of the application.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " TextInput setDw> called.", 1);
      application.trace("<" + this + " TextInput setDw> newdw: " + newdw, 0);
      const w:int = Math.max(newdw, application.getComponentsConfig().getTextsMinSize());
      if (getDw() != w)
      {
        super.setDw(w);
        resize();
      }
    }
    /**
     * The height of this input comes from the text field and from the open list of the
     * completion, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " TextInput setDh> called.", 1);
      application.trace("<" + this + " TextInput setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " TextInput setDh> do nothing.", 1);
    }
    /**
     * The height of this input comes from the text field of it, so this does nothing.
     * The width is set by the setDw.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " TextInput setDwh> called.", 1);
      application.trace("<" + this + " TextInput setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " TextInput setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " TextInput setDwh> do nothing.", 1);
    }
    /**
     * Renders this input in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " TextInput addedToStage> called.", 1);
      application.trace("<" + this + " TextInput addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resize();
    }
    /**
     * Stops the timers and lets the scrolled content back as soon as this input leaves
     * the stage: nothing would put that content back afterwards.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " TextInput removedFromStage> called.", 1);
      application.trace("<" + this + " TextInput removedFromStage> e: " + e, 0);
      dropFocusinTimer();
      dropFocusoutTimer();
      restoreTheParentContent();
      super.removedFromStage(e);
    }
    /**
     * Creates the delete icon of this input if it is not there yet.
     */
    private function setDelete():void
    {
      application.trace("<" + this + " TextInput setDelete> called.", 1);
      if (deleteIcon == null)
      {
        deleteIcon = new Icon(application);
        addChild(deleteIcon);
        deleteIcon.tabEnabled = false;
        deleteIcon.addEventListener(MouseEvent.CLICK, deleteIconClicked, false, 0, true);
        repaintDelete();
        reposDelete();
        enableDelete();
      }
    }
    /**
     * Lets the delete icon of this input take the mouse or leave it alone: a disabled input
     * is not emptied by a click on that icon, so it offers no hand cursor over it either.
     * The mouseEnabled of this input itself covers its own surface only and not its
     * children, so the icon has to be told about the state of it.
     */
    private function enableDelete():void
    {
      application.trace("<" + this + " TextInput enableDelete> called.", 1);
      if (deleteIcon != null)
      {
        deleteIcon.mouseEnabled = getEnabled();
        deleteIcon.buttonMode = getEnabled();
        deleteIcon.useHandCursor = getEnabled();
      }
    }
    /**
     * Draws the delete icon of this input in the size of the text of it.
     */
    private function repaintDelete():void
    {
      application.trace("<" + this + " TextInput repaintDelete> called.", 1);
      if (deleteIcon != null)
      {
        deleteIcon.drawBitmapData(EnumIcons.cancel(), baseTextField.getType(), baseTextField.getDh() * 4 / 5);
      }
    }
    /**
     * Positions the delete icon to the right end of the text field of this input.
     */
    private function reposDelete():void
    {
      application.trace("<" + this + " TextInput reposDelete> called.", 1);
      if (deleteIcon != null)
      {
        // the icon stands in the middle of the input field, and the open list of the
        // completion below that field must not push it down
        deleteIcon.setCxy(getDw() - deleteIcon.getDw() * 3 / 4
          , (getDhOfTheFieldOnly() - deleteIcon.getDh()) / 2);
      }
    }
    /**
     * Frees the delete icon of this input up.
     */
    private function clearDelete():void
    {
      application.trace("<" + this + " TextInput clearDelete> called.", 1);
      if (deleteIcon != null)
      {
        deleteIcon.removeEventListener(MouseEvent.CLICK, deleteIconClicked);
        deleteIcon.destroy();
        if (contains(deleteIcon))
        {
          removeChild(deleteIcon);
        }
        deleteIcon = null;
      }
    }
    /**
     * Displays the delete icon of this input while there is a text in it.
     */
    private function deleteVisible():void
    {
      application.trace("<" + this + " TextInput deleteVisible> called.", 1);
      if (baseTextField.text == "")
      {
        clearDelete();
      }
      else
      {
        setDelete();
      }
    }
    /**
     * Clears the text of this input, drops the list of the completion and passes the
     * click on, so that the owner of this input hears about the emptied text as well.
     * A disabled input is left alone: it displays its text and it is not emptied.
     * @param e the click event of the delete icon
     */
    private function deleteIconClicked(e:MouseEvent):void
    {
      application.trace("<" + this + " TextInput deleteIconClicked> called.", 1);
      application.trace("<" + this + " TextInput deleteIconClicked> e: " + e, 0);
      if (!getEnabled())
      {
        application.trace("<" + this + " TextInput deleteIconClicked> this input is disabled.", 1);
        return;
      }
      baseTextField.text = "";
      hintTextLabelVisible();
      if (e != null)
      {
        getBaseEventDispatcher().dispatchEvent(e);
      }
      if (stage != null)
      {
        stage.focus = baseTextField;
      }
      // there is nothing to complete any more, so the list of the completion goes too
      autoCompleteLastSearchTerm = null;
      autoCompleteTermBegin = 0;
      autoCompleteTermEnd = 0;
      autoCompleteListRemove();
      clearDelete();
    }
    /**
     * Positions the hint of this input over the text field of it.
     */
    private function hintTextLabelRepos():void
    {
      application.trace("<" + this + " TextInput hintTextLabelRepos> called.", 1);
      if (hintTextLabel != null)
      {
        hintTextLabel.setMaxWidth(baseTextField.getDw(), false);
        const correction:int = application.getDynamicsConfig().getTextFieldHeightCorrection(baseTextField.getType());
        hintTextLabel.setCxy(baseTextField.getCx(), baseTextField.getCy() - correction);
      }
    }
    /**
     * Displays the hint of this input while it stands empty.
     */
    private function hintTextLabelVisible():void
    {
      application.trace("<" + this + " TextInput hintTextLabelVisible> called.", 1);
      if (hintTextLabel != null)
      {
        hintTextLabel.visible = baseTextField.text == "";
      }
    }
    /**
     * Handles the arrival of the focus: on a mobile device the scrolling waits for the
     * keyboard, on a desktop it happens at once.
     * @param e the focus in event of the text field
     */
    private function focusIn(e:FocusEvent):void
    {
      application.trace("<" + this + " TextInput focusIn> called.", 1);
      application.trace("<" + this + " TextInput focusIn> e: " + e, 0);
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        theFocusIn();
      }
      else
      {
        // the keyboard of a mobile device slides in after the focus has arrived, so the
        // scrolling waits for it: the content is measured once that keyboard is there
        createFocusinTimer();
      }
      hintTextLabelVisible();
      deleteVisible();
      baseTextField.addEventListener(KeyboardEvent.KEY_UP, keyUp);
    }
    /**
     * Handles the leaving of the focus: on a mobile device the list of the completion
     * waits for the tap that may have been aimed at it.
     * @param e the focus out event of the text field
     */
    private function focusOut(e:FocusEvent):void
    {
      application.trace("<" + this + " TextInput focusOut> called.", 1);
      application.trace("<" + this + " TextInput focusOut> e: " + e, 0);
      baseTextField.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        theFocusOut();
      }
      else
      {
        // a tap on the list of the completion takes the focus away from the field
        // before that tap is handled, so the dropping of the list has to wait for it
        createFocusoutTimer();
      }
      hintTextLabelVisible();
    }
    /**
     * Scrolls the content this input stands on, so that the keyboard of a mobile device
     * does not cover this input.
     */
    private function theFocusIn():void
    {
      application.trace("<" + this + " TextInput theFocusIn> called.", 1);
      dropFocusinTimer();
      // the keyboard of a desktop covers nothing, so there is nothing to be scrolled
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        return;
      }
      scrollTheParentContentToThisInput();
    }
    /**
     * Drops the list of the completion and lets the scrolled content back where it was.
     */
    private function theFocusOut():void
    {
      application.trace("<" + this + " TextInput theFocusOut> called.", 1);
      // the list of the completion stays alive while the pointer stands on it: the
      // picking of an element takes the focus away from the field, and that must not
      // drop the very list the element is being picked from
      if (autoCompleteList != null
          && !(mouseX >= autoCompleteList.getCx() && mouseX <= autoCompleteList.getCx(true)
            && mouseY >= autoCompleteList.getCy() && mouseY <= autoCompleteList.getCy(true)))
      {
        autoCompleteListRemove();
      }
      // the content that has been pushed up for the keyboard goes back where it was
      restoreTheParentContent();
      dropFocusoutTimer();
    }
    /**
     * Creates and starts the timer that waits for the keyboard of a mobile device.
     */
    private function createFocusinTimer():void
    {
      application.trace("<" + this + " TextInput createFocusinTimer> called.", 1);
      dropFocusinTimer();
      focusinTimer = new Timer(application.getComponentsConfig().getInputTimerDelay());
      focusinTimer.addEventListener(TimerEvent.TIMER, focusinTimerHandler);
      focusinTimer.start();
    }
    /**
     * Stops and frees up the timer that waits for the keyboard of a mobile device.
     */
    private function dropFocusinTimer():void
    {
      application.trace("<" + this + " TextInput dropFocusinTimer> called.", 1);
      if (focusinTimer != null)
      {
        focusinTimer.stop();
        focusinTimer.removeEventListener(TimerEvent.TIMER, focusinTimerHandler);
        focusinTimer = null;
      }
    }
    /**
     * Handles the arrival of the focus as soon as the keyboard has slid in.
     * @param e the timer event of the focus in timer
     */
    private function focusinTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " TextInput focusinTimerHandler> called.", 1);
      application.trace("<" + this + " TextInput focusinTimerHandler> e: " + e, 0);
      theFocusIn();
    }
    /**
     * Creates and starts the timer that waits for the tap on the list of the completion.
     */
    private function createFocusoutTimer():void
    {
      application.trace("<" + this + " TextInput createFocusoutTimer> called.", 1);
      dropFocusoutTimer();
      focusoutTimer = new Timer(application.getComponentsConfig().getInputTimerDelay());
      focusoutTimer.addEventListener(TimerEvent.TIMER, focusoutTimerHandler);
      focusoutTimer.start();
    }
    /**
     * Stops and frees up the timer that waits for the tap on the list of the completion.
     */
    private function dropFocusoutTimer():void
    {
      application.trace("<" + this + " TextInput dropFocusoutTimer> called.", 1);
      if (focusoutTimer != null)
      {
        focusoutTimer.stop();
        focusoutTimer.removeEventListener(TimerEvent.TIMER, focusoutTimerHandler);
        focusoutTimer = null;
      }
    }
    /**
     * Handles the leaving of the focus as soon as the tap on the list has been handled.
     * @param e the timer event of the focus out timer
     */
    private function focusoutTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " TextInput focusoutTimerHandler> called.", 1);
      application.trace("<" + this + " TextInput focusoutTimerHandler> e: " + e, 0);
      theFocusOut();
    }
    /**
     * Scrolls the first scrolled content above this input, so that this input stands
     * under the top edge of that content.
     */
    private function scrollTheParentContentToThisInput():void
    {
      application.trace("<" + this + " TextInput scrollTheParentContentToThisInput> called.", 1);
      const contentSingle:ContentSingle = findFirstParentContentSingle();
      if (contentSingle == null)
      {
        application.trace("<" + this + " TextInput scrollTheParentContentToThisInput> this input stands on no scrolled content.", 0);
        return;
      }
      const baseScroll:BaseScroll = contentSingle.getBaseScroll();
      if (baseScroll == null)
      {
        return;
      }
      // the distance of this input from the top of that content as it stands on the
      // screen right now. It is measured instead of being summed up along the parents:
      // that sum would miss every scaling and every offset of a parent in between
      const distNow:int = contentSingle.globalToLocal(localToGlobal(new Point(0, 0))).y;
      // this input is brought under the top edge of the content, one text field height
      // plus the margin of the scrolling below it
      const target:int = application.getComponentsConfig().getScrollMargin()
        + application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      contentCyToRestore = baseScroll.getCyContent();
      contentScrollToRestore = baseScroll;
      // the distance above holds the current scrolling of that content, so that very
      // scrolling is added back: the rest of it is the one this input has to be at
      const newCy:int = target - distNow + contentCyToRestore;
      application.trace("<" + this + " TextInput scrollTheParentContentToThisInput> distNow: " + distNow, 0);
      application.trace("<" + this + " TextInput scrollTheParentContentToThisInput> newCy: " + newCy, 0);
      // the true is needed: the content of that scroll follows the new position on the
      // event of it only, and the scroll itself keeps the position inside its bounds
      baseScroll.setContentPosition(baseScroll.getCxContent(), newCy, true);
    }
    /**
     * Lets the scrolled content that has been pushed up back where it was.
     */
    private function restoreTheParentContent():void
    {
      application.trace("<" + this + " TextInput restoreTheParentContent> called.", 1);
      if (contentScrollToRestore == null)
      {
        return;
      }
      contentScrollToRestore.setContentPosition(contentScrollToRestore.getCxContent()
        , contentCyToRestore, true);
      contentScrollToRestore = null;
      contentCyToRestore = 0;
    }
    /**
     * Returns the first scrolled content this input stands on, null when there is none.
     */
    private function findFirstParentContentSingle():ContentSingle
    {
      application.trace("<" + this + " TextInput findFirstParentContentSingle> called.", 1);
      var currentParent:DisplayObject = parent;
      while (currentParent != null)
      {
        if (currentParent is ContentSingle)
        {
          return ContentSingle(currentParent);
        }
        currentParent = currentParent.parent;
      }
      return null;
    }
    /**
     * Handles a typed character: refreshes the list of the completion with the text the
     * field ends up with and hands the event over to the outside.
     * @param e the text input event of the text field
     */
    private function textInput(e:TextEvent):void
    {
      application.trace("<" + this + " TextInput textInput> called.", 1);
      application.trace("<" + this + " TextInput textInput> e: " + e, 0);
      // the label of the field becomes the typed text on the very first key: a label
      // that holds a text key follows every language change, and such a change would
      // overwrite whatever has been typed in here by now
      if (!iniTextChanged)
      {
        iniTextChanged = true;
        baseTextField.setLabel(baseTextField.text);
      }
      if (e != null)
      {
        // the character of this event is not in the field yet, so the text the completion
        // works with is put together by hand. It is inserted at the caret and it replaces
        // whatever is selected, so that a character typed into the middle of the text or
        // over a selected part of it gives the very text the field ends up with. The
        // caret stands right after that character, in the element it belongs to.
        const theText:String = baseTextField.text;
        const beginIndex:int = baseTextField.selectionBeginIndex;
        autoCompleteTheText(theText.substr(0, beginIndex) + e.text
          + theText.substr(baseTextField.selectionEndIndex), beginIndex + e.text.length);
        getBaseEventDispatcher().dispatchEvent(e);
      }
      hintTextLabelVisible();
      deleteVisible();
    }
    /**
     * Handles a released key: the enter dispatches the changed event of this input,
     * every other key refreshes the list of the completion.
     * @param e the key up event of the text field
     */
    private function keyUp(e:KeyboardEvent):void
    {
      application.trace("<" + this + " TextInput keyUp> called.", 1);
      application.trace("<" + this + " TextInput keyUp> e: " + e, 0);
      if (e == null)
      {
        return;
      }
      if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER)
      {
        dispatchEventChanged();
      }
      else
      {
        // the backspace and the delete give no text input event at all, so the list of
        // the completion is refreshed from here as well. The text of the field and the
        // caret in it are the final ones by the time a key is released, so they are
        // taken as they are: an arrow moving the caret into another element completes
        // that element from then on.
        autoCompleteTheText(baseTextField.text, baseTextField.caretIndex);
        getBaseEventDispatcher().dispatchEvent(e);
      }
      hintTextLabelVisible();
      deleteVisible();
    }
    /**
     * Collects the elements of the dataset matching the element being typed and displays
     * them in the list of the completion. The text of this input can hold more elements
     * of that dataset, and the completion works on the one the caret stands in: the
     * elements standing around that one are typed already and they are offered no more.
     * @param text the whole text the elements are read from
     * @param caretIndex the position of the caret inside that text
     */
    private function autoCompleteTheText(text:String, caretIndex:int):void
    {
      application.trace("<" + this + " TextInput autoCompleteTheText> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteTheText> text: " + text, 0);
      application.trace("<" + this + " TextInput autoCompleteTheText> caretIndex: " + caretIndex, 0);
      if (autoCompleteThese == null)
      {
        return;
      }
      const theText:String = text == null ? "" : text;
      // the separators standing around the caret cut the element being typed out of the
      // whole text: a separator written after an element closes that one and starts a
      // new, empty one, and every other character goes on completing the current one
      const beginIndex:int = autoCompleteTermBeginIndex(theText, caretIndex);
      const endIndex:int = autoCompleteTermEndIndex(theText, caretIndex);
      // the matching pays no attention to the case of the letters, so the term is
      // lowered once here and every element is lowered before it is compared to it
      const theTerm:String = theText.substring(beginIndex, endIndex).toLowerCase();
      const theOthers:Array = autoCompleteOtherElements(theText, beginIndex, endIndex);
      const theSearch:String = autoCompleteSearchOf(theTerm, theOthers);
      // an arrow, a shift or any other key that leaves both the element being typed and
      // the elements typed already alone changes nothing for the completion, and a picked
      // element must not open the list of it again. The lowered parts are the ones kept,
      // so the switching of a letter between the upper and the lower case finds the very
      // same elements and needs no new list.
      if (theSearch == autoCompleteLastSearchTerm)
      {
        application.trace("<" + this + " TextInput autoCompleteTheText> the text is the one of the current list.", 0);
        return;
      }
      autoCompleteLastSearchTerm = theSearch;
      // the picked element of the list replaces exactly the element being typed
      autoCompleteTermBegin = beginIndex;
      autoCompleteTermEnd = endIndex;
      // an empty input offers nothing: every element of the dataset would match it, and
      // the list of every one of them helps nobody. An empty element standing after the
      // ones typed already is another matter: there the completion starts again and it
      // offers the whole rest of the dataset.
      if (theTerm == "" && theOthers.length == 0)
      {
        autoCompleteListRemove();
        return;
      }
      if (autoCompleteCurrents != null)
      {
        autoCompleteCurrents.splice(0);
        autoCompleteCurrents = null;
      }
      autoCompleteCurrents = new Array();
      var element:String = null;
      for (var i:int = 0; i < autoCompleteThese.length; i++)
      {
        if (autoCompleteThese[i] == null)
        {
          continue;
        }
        element = String(autoCompleteThese[i]).toLowerCase();
        // an element matches when the typed characters stand anywhere inside it, not
        // only at the beginning of it, and an element that stands in the text already
        // is offered no more. The element itself is pushed with the case it has in the
        // dataset: only the comparison ignores that case.
        if (element.indexOf(theTerm) > -1 && theOthers.indexOf(element) < 0)
        {
          autoCompleteCurrents.push(autoCompleteThese[i]);
        }
      }
      application.trace("<" + this + " TextInput autoCompleteTheText> found elements: " + autoCompleteCurrents.length, 0);
      if (autoCompleteCurrents.length == 0)
      {
        autoCompleteListRemove();
        return;
      }
      autoCompleteListCreate();
      // the number of the displayed elements and the elements themselves are given on
      // every single key: the previous key may have found another number of them
      autoCompleteList.setNumOfElements(Math.min(autoCompleteCurrents.length
        , application.getComponentsConfig().getAutoCompleteMaxElements()));
      autoCompleteList.setArrays(autoCompleteCurrents, autoCompleteCurrents);
      autoCompleteListReposResize();
    }
    /**
     * Returns the position the element being typed starts at: the very beginning of the
     * text or the character right after the last separator standing before the caret.
     * @param text the whole text of this input
     * @param caretIndex the position of the caret inside that text
     */
    private function autoCompleteTermBeginIndex(text:String, caretIndex:int):int
    {
      application.trace("<" + this + " TextInput autoCompleteTermBeginIndex> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteTermBeginIndex> text: " + text, 0);
      application.trace("<" + this + " TextInput autoCompleteTermBeginIndex> caretIndex: " + caretIndex, 0);
      var i:int = autoCompleteCaretIndexInText(text, caretIndex);
      while (i > 0 && autoCompleteSeparators.indexOf(text.charAt(i - 1)) < 0)
      {
        i--;
      }
      return i;
    }
    /**
     * Returns the position the element being typed ends at: the very end of the text or
     * the first separator standing after the caret.
     * @param text the whole text of this input
     * @param caretIndex the position of the caret inside that text
     */
    private function autoCompleteTermEndIndex(text:String, caretIndex:int):int
    {
      application.trace("<" + this + " TextInput autoCompleteTermEndIndex> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteTermEndIndex> text: " + text, 0);
      application.trace("<" + this + " TextInput autoCompleteTermEndIndex> caretIndex: " + caretIndex, 0);
      var i:int = autoCompleteCaretIndexInText(text, caretIndex);
      while (i < text.length && autoCompleteSeparators.indexOf(text.charAt(i)) < 0)
      {
        i++;
      }
      return i;
    }
    /**
     * Returns the given caret position held inside the given text: a field that has
     * never been in focus reports no caret at all, and a text that has just been
     * shortened leaves that position behind its own end.
     * @param text the whole text of this input
     * @param caretIndex the position of the caret inside that text
     */
    private function autoCompleteCaretIndexInText(text:String, caretIndex:int):int
    {
      application.trace("<" + this + " TextInput autoCompleteCaretIndexInText> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteCaretIndexInText> text: " + text, 0);
      application.trace("<" + this + " TextInput autoCompleteCaretIndexInText> caretIndex: " + caretIndex, 0);
      if (caretIndex < 0)
      {
        return 0;
      }
      return caretIndex > text.length ? text.length : caretIndex;
    }
    /**
     * Collects the elements standing in the text of this input already, in lower case,
     * leaving the element being typed out of them.
     * @param text the whole text of this input
     * @param beginIndex the position the element being typed starts at
     * @param endIndex the position that element ends at
     */
    private function autoCompleteOtherElements(text:String, beginIndex:int, endIndex:int):Array
    {
      application.trace("<" + this + " TextInput autoCompleteOtherElements> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteOtherElements> text: " + text, 0);
      application.trace("<" + this + " TextInput autoCompleteOtherElements> beginIndex: " + beginIndex, 0);
      application.trace("<" + this + " TextInput autoCompleteOtherElements> endIndex: " + endIndex, 0);
      const others:Array = new Array();
      var elementBegin:int = 0;
      var element:String = null;
      // the separators cut the whole text into elements, and the end of that text closes
      // the last one of them
      for (var i:int = 0; i <= text.length; i++)
      {
        if (i < text.length && autoCompleteSeparators.indexOf(text.charAt(i)) < 0)
        {
          continue;
        }
        element = text.substring(elementBegin, i).toLowerCase();
        // the element being typed is the one the completion works on, and an empty one
        // comes from two separators standing next to each other: neither of them is an
        // element that has been typed in already
        if (element != "" && !(elementBegin == beginIndex && i == endIndex))
        {
          others.push(element);
        }
        elementBegin = i + 1;
      }
      return others;
    }
    /**
     * Returns the search of the completion as one single string: the element being typed
     * and the elements typed already, all of them in lower case.
     * @param term the element being typed
     * @param others the elements standing in the text of this input already
     */
    private function autoCompleteSearchOf(term:String, others:Array):String
    {
      application.trace("<" + this + " TextInput autoCompleteSearchOf> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteSearchOf> term: " + term, 0);
      application.trace("<" + this + " TextInput autoCompleteSearchOf> others: " + others, 0);
      return term + AUTO_COMPLETE_SEARCH_SEPARATOR + others.join(AUTO_COMPLETE_SEARCH_SEPARATOR);
    }
    /**
     * Creates the list of the completion below the text field if it is not there yet.
     */
    private function autoCompleteListCreate():void
    {
      application.trace("<" + this + " TextInput autoCompleteListCreate> called.", 1);
      if (autoCompleteList != null)
      {
        return;
      }
      autoCompleteList = new ListPanel(application);
      addChild(autoCompleteList);
      // one element of the dataset is picked at a time
      autoCompleteList.setMultiple(false);
      autoCompleteList.getBaseEventDispatcher()
          .addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), autoCompleteListResized);
      autoCompleteList.getBaseEventDispatcher()
          .addEventListener(EnumEvents.EVENT_CHANGED(), autoCompleteListChanged);
    }
    /**
     * Frees the list of the completion up and takes the height of this input back.
     */
    private function autoCompleteListRemove():void
    {
      application.trace("<" + this + " TextInput autoCompleteListRemove> called.", 1);
      if (autoCompleteList == null)
      {
        return;
      }
      autoCompleteList.getBaseEventDispatcher()
          .removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), autoCompleteListResized);
      autoCompleteList.getBaseEventDispatcher()
          .removeEventListener(EnumEvents.EVENT_CHANGED(), autoCompleteListChanged);
      // the destroy comes first to still have the stage property inside of it
      autoCompleteList.destroy();
      if (contains(autoCompleteList))
      {
        removeChild(autoCompleteList);
      }
      autoCompleteList = null;
      // the height of this object holds the list no more
      refreshDhWithAutoCompleteList();
    }
    /**
     * Takes the picked element of the list of the completion as the whole text of this
     * input and drops that list.
     * @param e the changed event of the list of the completion
     */
    private function autoCompleteListChanged(e:Event):void
    {
      application.trace("<" + this + " TextInput autoCompleteListChanged> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteListChanged> e: " + e, 0);
      if (autoCompleteList == null || baseTextField == null)
      {
        return;
      }
      const selectedIndexes:Array = autoCompleteList.getSelectedIndexes();
      // the clearing of the selection reports a change as well, and that one completes
      // nothing: it carries no picked element at all
      if (selectedIndexes == null || selectedIndexes.length == 0)
      {
        application.trace("<" + this + " TextInput autoCompleteListChanged> nothing is picked.", 0);
        return;
      }
      const selectedItem:String = String(autoCompleteList.getArrayValues()[selectedIndexes[0]]);
      application.trace("<" + this + " TextInput autoCompleteListChanged> selectedItem: " + selectedItem, 0);
      // the picked element takes the place of the element being typed and of that one
      // only: the elements standing around it in the text are left where they are, and
      // the caret goes to the end of the picked one, ready for a separator
      const theText:String = baseTextField.text;
      const newText:String = theText.substring(0, autoCompleteTermBegin) + selectedItem
        + theText.substring(autoCompleteTermEnd);
      const caretIndex:int = autoCompleteTermBegin + selectedItem.length;
      baseTextField.text = newText;
      autoCompleteTermEnd = caretIndex;
      // the picked element stands in the text of this input from now on, so a key that
      // leaves that text alone does not open the list of it again. It is lowered here as
      // well: the matching keeps the lowered elements only.
      autoCompleteLastSearchTerm = autoCompleteSearchOf(selectedItem.toLowerCase()
        , autoCompleteOtherElements(newText, autoCompleteTermBegin, caretIndex));
      if (stage != null)
      {
        stage.focus = baseTextField;
      }
      baseTextField.setSelection(caretIndex, caretIndex);
      autoCompleteListRemove();
      hintTextLabelVisible();
      deleteVisible();
    }
    /**
     * Positions and resizes the list of the completion below the text field.
     */
    private function autoCompleteListReposResize():void
    {
      application.trace("<" + this + " TextInput autoCompleteListReposResize> called.", 1);
      if (autoCompleteList != null && baseTextField != null)
      {
        autoCompleteList.setDw(getDw());
        autoCompleteList.setCxy(0, baseTextField.getDh()
          + 2 * application.getDynamicsConfig().getAppPadding());
      }
      refreshDhWithAutoCompleteList();
    }
    /**
     * Takes the height of this input again after the list of the completion has taken a
     * new size.
     * @param e the dimensions changed event of that list
     */
    private function autoCompleteListResized(e:Event):void
    {
      application.trace("<" + this + " TextInput autoCompleteListResized> called.", 1);
      application.trace("<" + this + " TextInput autoCompleteListResized> e: " + e, 0);
      refreshDhWithAutoCompleteList();
    }
    /**
     * Takes the height of this input from the text field and from the open list of the
     * completion.
     */
    private function refreshDhWithAutoCompleteList():void
    {
      application.trace("<" + this + " TextInput refreshDhWithAutoCompleteList> called.", 1);
      if (baseTextField == null)
      {
        return;
      }
      // the setDh of this class does nothing on purpose, so the height is given to the
      // super: this object is as tall as its field plus the open list of the completion
      const dh:int = getDhOfTheFieldOnly();
      super.setDh(autoCompleteList != null ? dh + autoCompleteList.getDh() : dh);
    }
    /**
     * Returns the height of the input field of this object, without the open list of
     * the completion.
     */
    private function getDhOfTheFieldOnly():int
    {
      // the whole height of this object grows with the open list of the completion, so
      // everything that belongs to the input field itself is placed inside this height
      // instead of that one
      return baseTextField != null
        ? baseTextField.getDh() + 2 * application.getDynamicsConfig().getAppPadding()
        : getDh();
    }
    /**
     * Positions the text field of this input, leaving the padding of the application
     * around it.
     */
    private function baseTextFieldRepos():void
    {
      application.trace("<" + this + " TextInput baseTextFieldRepos> called.", 1);
      const p:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType());
      baseTextField.setCxy(p, p + tfh / 10);
    }
    /**
     * Resizes and draws everything standing on this input, in the current appearance of
     * the application.
     * @param e the text format, padding, radius or background color changed event of
     * the application, null on a direct call
     */
    private function resize(e:Event = null):void
    {
      application.trace("<" + this + " TextInput resize> called.", 1);
      application.trace("<" + this + " TextInput resize> e: " + e, 0);
      const p:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType());
      const w:int = getDw() - 2 * p;
      baseTextField.setDwh(w, tfh, true);
      super.setDh(baseTextField.getDh() + 2 * p);
      baseTextFieldRepos();
      hintTextLabelRepos();
      repaintDelete();
      reposDelete();
      baseShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , Math.max(application.getDynamicsConfig().getAppBackgroundColorAlpha()
            , application.getComponentsConfig().getMinTextInputAlpha())
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      baseShape.setRadius(application.getDynamicsConfig().getAppRadius());
      baseShape.setDwh(getDw(), getDh());
      baseShape.drawRect();
      // the super setDh above has dropped the height of the open list of the completion,
      // so that list is placed and this object is grown again by the call below
      autoCompleteListReposResize();
    }
    /**
     * Dispatches the changed event of this input, but only when it is enabled.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " TextInput dispatchEventChanged> called.", 1);
      if (getEnabled())
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Frees all listeners, timers, events and references held by this input.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " TextInput destroy> called.", 1);
      application.trace("<" + this + " TextInput destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      // a running timer keeps this object alive and goes on firing, so both of them are
      // stopped here. The listeners of the list of the completion are not removed one by
      // one: that list is a child of this object, so the super destroy below frees it up
      // together with every listener registered on the dispatcher of it.
      dropFocusinTimer();
      dropFocusoutTimer();
      // a content that is still pushed up for the keyboard has to be let back before
      // this input is gone: nothing would put it back afterwards
      restoreTheParentContent();
      baseTextField.removeEventListener(TextEvent.TEXT_INPUT, textInput);
      baseTextField.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
      baseTextField.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
      baseTextField.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), resize);
      application.trace("<" + this + " TextInput destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      if (autoCompleteCurrents != null)
      {
        autoCompleteCurrents.splice(0);
      }
      if (autoCompleteThese != null)
      {
        autoCompleteThese.splice(0);
      }
      eventChanged.stopImmediatePropagation();
      clearDelete();
      clearHint();
      application.trace("<" + this + " TextInput destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      baseTextField = null;
      baseShape = null;
      iniTextChanged = false;
      autoCompleteThese = null;
      autoCompleteList = null;
      autoCompleteCurrents = null;
      autoCompleteSeparators = null;
      autoCompleteTermBegin = 0;
      autoCompleteTermEnd = 0;
      autoCompleteLastSearchTerm = null;
      eventChanged = null;
      contentScrollToRestore = null;
      contentCyToRestore = 0;
      focusoutTimer = null;
      focusinTimer = null;
      hintTextLabel = null;
      deleteIcon = null;
    }
  }
}
