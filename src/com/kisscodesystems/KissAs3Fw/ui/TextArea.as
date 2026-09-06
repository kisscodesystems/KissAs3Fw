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
 * TextArea.
 * A TextBox that can be written into as well. It stands in the scroller mode by
 * default, a click on it turns it into an editor and the loss of the focus turns
 * it back, so the very same object both displays and takes a long text.
 *
 * MAIN FEATURES:
 * - a click that is not a drag opens the editor mode and gives the focus to it
 * - the text field and the scroll swap depths between the two modes
 * - the changed event is dispatched when the editing has been finished
 * - in mobile mode the parent content is scrolled up, so that the keyboard that
 *   comes up does not cover the text being written
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextBox;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.FocusEvent;
  import flash.events.MouseEvent;
  import flash.events.TextEvent;
  import flash.text.TextFieldType;
  public class TextArea extends TextBox
  {
    private var eventChanged:Event = null;
    // The position of the mouse at the press: a click only opens the editor when the
    // mouse has not been moved between the press and the release, because a move is
    // the dragging of the text and not the opening of it.
    private var origMouseX:int = 0;
    private var origMouseY:int = 0;
    private var contentSprite:BaseSprite = null;
    private var origContentPos:int = 0;
    private var iniTextChanged:Boolean = false;
    /**
     * Constructs the TextArea object: it is a TextBox that stands in the scroller mode.
     * @param applicationRef the main application reference
     */
    public function TextArea(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " TextArea> called.", 1);
      application.trace("<" + this + " TextArea> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_MID());
      baseScroll.setShapeFrameType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      baseScroll.getMover().addEventListener(MouseEvent.MOUSE_DOWN, moverMouseDown);
      baseScroll.getMover().addEventListener(MouseEvent.CLICK, moverMouseClick);
      baseTextField.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), baseTextFieldChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundColorAlphaChanged);
      backgroundColorAlphaChanged();
      setWordWrap(true);
      setModeScroller();
      application.trace("<" + this + " TextArea> constructed.", 1);
    }
    /**
     * Tells whether the text of this area is at least as long as the minimal length.
     */
    public function getTextIsAtLeastLength():Boolean
    {
      return baseTextField.getTextIsAtLeastLength();
    }
    /**
     * Sets the characters that can be written into this area.
     * @param r the restrict string of the text field
     */
    public function setRestrict(r:String):void
    {
      application.trace("<" + this + " TextArea setRestrict> called.", 1);
      application.trace("<" + this + " TextArea setRestrict> r: " + r, 0);
      baseTextField.restrict = r;
    }
    /**
     * Sets the minimal length the text of this area has to reach.
     * @param m the minimal number of the characters
     */
    public function setMinChars(m:int):void
    {
      application.trace("<" + this + " TextArea setMinChars> called.", 1);
      application.trace("<" + this + " TextArea setMinChars> m: " + m, 0);
      baseTextField.setMinChars(m);
    }
    /**
     * Sets the maximal length the text of this area can reach.
     * @param m the maximal number of the characters
     */
    public function setMaxChars(m:int):void
    {
      application.trace("<" + this + " TextArea setMaxChars> called.", 1);
      application.trace("<" + this + " TextArea setMaxChars> m: " + m, 0);
      baseTextField.maxChars = m;
    }
    /**
     * Opens the editor mode of this area from the outside, without any click on it.
     */
    public function toFocus():void
    {
      application.trace("<" + this + " TextArea toFocus> called.", 1);
      moverMouseClick(null);
    }
    /**
     * Forwards the changed event of the text field of this area.
     * @param e the changed event of the text field
     */
    private function baseTextFieldChanged(e:Event):void
    {
      application.trace("<" + this + " TextArea baseTextFieldChanged> called.", 1);
      application.trace("<" + this + " TextArea baseTextFieldChanged> e: " + e, 0);
      getBaseEventDispatcher().dispatchEvent(e);
    }
    /**
     * Keeps the background of this area readable: it never becomes more transparent than
     * the minimal alpha of the config, however transparent the application itself is.
     * @param e the background color alpha changed event of the application, null on a
     * direct call
     */
    private function backgroundColorAlphaChanged(e:Event = null):void
    {
      application.trace("<" + this + " TextArea backgroundColorAlphaChanged> called.", 1);
      application.trace("<" + this + " TextArea backgroundColorAlphaChanged> e: " + e, 0);
      baseScroll.setShapeFrameBackgroundAlpha(Math.max(application.getDynamicsConfig().getAppBackgroundColorAlpha()
          , application.getComponentsConfig().getMinTextInputAlpha()));
    }
    /**
     * Dispatches the changed event of this area.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " TextArea dispatchEventChanged> called.", 1);
      if (getEnabled())
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Saves the position of the mouse at the press, so that the release can tell whether
     * it closes a click or a drag.
     * @param e the mouse down event of the mover of the scroll
     */
    private function moverMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " TextArea moverMouseDown> called.", 1);
      application.trace("<" + this + " TextArea moverMouseDown> e: " + e, 0);
      origMouseX = int(mouseX);
      origMouseY = int(mouseY);
    }
    /**
     * Opens the editor mode of this area and gives the focus to its text field. A click
     * that has moved the mouse is the dragging of the text, so it opens nothing. A null
     * event is the call coming from the outside, that one always opens the editor.
     * @param e the click event of the mover of the scroll, null on a direct call
     */
    private function moverMouseClick(e:MouseEvent):void
    {
      application.trace("<" + this + " TextArea moverMouseClick> called.", 1);
      application.trace("<" + this + " TextArea moverMouseClick> e: " + e, 0);
      if (getEnabled() && (e == null || (int(mouseX) == origMouseX && int(mouseY) == origMouseY)))
      {
        setModeEditor();
        baseTextField.type = TextFieldType.INPUT;
        baseTextField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
        baseTextField.addEventListener(FocusEvent.FOCUS_IN, focusIn);
        baseTextField.addEventListener(TextEvent.TEXT_INPUT, textInput);
        if (stage != null)
        {
          stage.focus = baseTextField;
          if (application.getDynamicsConfig().weAreInDesktopMode())
          {
            toBeVisible();
          }
        }
      }
    }
    /**
     * Puts the scroll above the text field, so that this area is scrolled and not written.
     */
    private function setModeScroller():void
    {
      application.trace("<" + this + " TextArea setModeScroller> called.", 1);
      setChildIndex(baseTextField, 0);
      setChildIndex(baseScroll, 1);
    }
    /**
     * Puts the text field above the scroll, so that this area is written and not scrolled.
     */
    private function setModeEditor():void
    {
      application.trace("<" + this + " TextArea setModeEditor> called.", 1);
      setChildIndex(baseTextField, 1);
      setChildIndex(baseScroll, 0);
    }
    /**
     * Scrolls the parent content up in mobile mode, so that the keyboard that comes up
     * does not cover this area. The distance is summed up to the first parent content.
     * @param e the focus in event of the text field
     */
    private function focusIn(e:FocusEvent):void
    {
      application.trace("<" + this + " TextArea focusIn> called.", 1);
      application.trace("<" + this + " TextArea focusIn> e: " + e, 0);
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        return;
      }
      var currentObject:DisplayObject = DisplayObject(this);
      if (currentObject == null)
      {
        return;
      }
      var currentParent:DisplayObject = currentObject.parent;
      var dist:int = y;
      while (currentParent != null)
      {
        if (!(currentParent is DisplayObject))
        {
          break;
        }
        dist += DisplayObject(currentParent).y;
        if (currentParent is ContentSingle)
        {
          if (currentParent.parent != null && currentParent.parent is ContentMultiple)
          {
            dist -= ContentMultiple(currentParent.parent).getButtonBarCyAndHeight();
          }
          const contentSingle:ContentSingle = ContentSingle(currentParent);
          contentSprite = contentSingle.getBaseSprite();
          if (contentSingle != null && contentSprite != null)
          {
            origContentPos = contentSprite.y;
            contentSprite.y = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT())
                - dist + contentSingle.getBaseScroll().getCyContent();
          }
          break;
        }
        currentObject = currentParent;
        currentParent = currentObject.parent;
      }
    }
    /**
     * Resizes this area to the text that is being written into it. The very first change
     * takes the typed text over as the label, so that it survives a language change.
     * @param e the text input event of the text field
     */
    private function textInput(e:TextEvent):void
    {
      application.trace("<" + this + " TextArea textInput> called.", 1);
      application.trace("<" + this + " TextArea textInput> e: " + e, 0);
      doDimensionsOrTextChanged();
      if (!iniTextChanged)
      {
        iniTextChanged = true;
        baseTextField.setLabel(baseTextField.text);
      }
    }
    /**
     * Closes the editor mode of this area, lets the parent content back to where it has
     * been scrolled up from and reports that the editing has been finished.
     * @param e the focus out event of the text field
     */
    private function focusOut(e:FocusEvent):void
    {
      application.trace("<" + this + " TextArea focusOut> called.", 1);
      application.trace("<" + this + " TextArea focusOut> e: " + e, 0);
      setModeScroller();
      baseTextField.type = TextFieldType.DYNAMIC;
      baseTextField.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
      baseTextField.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
      baseTextField.removeEventListener(TextEvent.TEXT_INPUT, textInput);
      if (!application.getDynamicsConfig().weAreInDesktopMode() && contentSprite != null)
      {
        contentSprite.y = origContentPos;
      }
      dispatchEventChanged();
    }
    /**
     * Frees all listeners, events and references held by this text area.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " TextArea destroy> called.", 1);
      application.trace("<" + this + " TextArea destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      baseScroll.getMover().removeEventListener(MouseEvent.MOUSE_DOWN, moverMouseDown);
      baseScroll.getMover().removeEventListener(MouseEvent.CLICK, moverMouseClick);
      baseTextField.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), baseTextFieldChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundColorAlphaChanged);
      baseTextField.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
      baseTextField.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
      baseTextField.removeEventListener(TextEvent.TEXT_INPUT, textInput);
      application.trace("<" + this + " TextArea destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " TextArea destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " TextArea destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      eventChanged = null;
      origMouseX = 0;
      origMouseY = 0;
      contentSprite = null;
      origContentPos = 0;
      iniTextChanged = false;
    }
  }
}
