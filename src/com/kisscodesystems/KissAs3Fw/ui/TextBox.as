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
 * TextBox.
 * A scrollable text displayer: a text field of any length inside a scroll that
 * carries it. The TextArea is built of it, that one can be written into as well.
 *
 * MAIN FEATURES:
 * - the text is scrolled by the scroll, the text field itself only follows it
 * - the word wrapping can be switched, a box without it scrolls horizontally too
 * - the looking up of the text keys can be switched off, so a text carrying brackets
 *   of its own, a source code for example, is displayed exactly the way it arrives
 * - the top and the bottom reached events of the scroll are forwarded
 * - the dimensions of the scrolled content come from the size of the text
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.events.Event;
  public class TextBox extends BaseSprite
  {
    protected var baseTextField:BaseTextField = null;
    protected var baseScroll:BaseScroll = null;
    /**
     * Constructs the TextBox object and builds up its text field and its scroll.
     * @param applicationRef the main application reference
     */
    public function TextBox(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " TextBox> called.", 1);
      application.trace("<" + this + " TextBox> applicationRef: " + applicationRef, 0);
      mouseDownForScrollingEnabled = false;
      baseTextField = new BaseTextField(application);
      addChild(baseTextField);
      baseTextField.setAutoSizeNone();
      baseTextField.mouseDownForScrollingEnabled = false;
      baseTextField.multiline = true;
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_BRIGHT());
      baseScroll = new BaseScroll(application);
      addChild(baseScroll);
      baseScroll.getMover().mouseDownForScrollingEnabled = false;
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CX_CHANGED(), reposTextX);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CY_CHANGED(), reposTextY);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TOP_REACHED(), dispatchEventTopReached);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOTTOM_REACHED(), dispatchEventBottomReached);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), scrollDimensionsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), doDimensionsOrTextChanged);
      application.trace("<" + this + " TextBox> constructed.", 1);
    }
    /**
     * Tells whether this box can be resized by the one using it.
     */
    public function getResizable():Boolean
    {
      return baseScroll.getResizable();
    }
    /**
     * Allows or forbids the resizing of this box by the one using it.
     * @param b true when this box has to be resizable
     */
    public function setResizable(b:Boolean):void
    {
      application.trace("<" + this + " TextBox setResizable> called.", 1);
      application.trace("<" + this + " TextBox setResizable> b: " + b, 0);
      baseScroll.setResizable(b);
    }
    /**
     * Tells whether the text of this box is wrapped into the width of it.
     */
    public function getWordWrap():Boolean
    {
      return baseTextField.getWordWrap();
    }
    /**
     * Switches the wrapping of the text. A box that does not wrap its text scrolls
     * horizontally as well, so the scroll follows this setting.
     * @param wordWrap true when the text has to be wrapped
     */
    public function setWordWrap(wordWrap:Boolean):void
    {
      application.trace("<" + this + " TextBox setWordWrap> called.", 1);
      application.trace("<" + this + " TextBox setWordWrap> wordWrap: " + wordWrap, 0);
      if (baseTextField.getWordWrap() != wordWrap)
      {
        baseTextField.setWordWrap(wordWrap);
        doDimensionsOrTextChanged();
        baseScroll.setEnabledHorizontal(!wordWrap);
      }
    }
    /**
     * Returns the text type the text of this box is displayed in.
     */
    public function getType():String
    {
      return baseTextField.getType();
    }
    /**
     * Sets the text type the text of this box is displayed in.
     * @param newType the new text type
     */
    public function setType(newType:String):void
    {
      application.trace("<" + this + " TextBox setType> called.", 1);
      application.trace("<" + this + " TextBox setType> newType: " + newType, 0);
      if (baseTextField.getType() != newType)
      {
        baseTextField.setType(newType);
      }
    }
    /**
     * Returns the text code this box has been written with: the text key of a label when
     * it carries one, and the plain text itself otherwise. The text that is displayed is
     * answered by the getText below, and the two of them differ from each other whenever
     * a key is being looked up or a text has been appended to the end of this box.
     */
    public function getLabel():String
    {
      return baseTextField.getLabel();
    }
    /**
     * Writes the given text code into this box. An empty text is always taken, so that
     * the box can be emptied even when it holds an empty text already.
     * @param newLabel the text code to be displayed
     */
    public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " TextBox setLabel> called.", 1);
      application.trace("<" + this + " TextBox setLabel> newLabel: " + newLabel, 0);
      if (baseTextField.getLabel() != newLabel || newLabel == "")
      {
        baseTextField.setLabel(newLabel);
        doDimensionsOrTextChanged();
      }
    }
    /**
     * Returns the text this box displays at the moment: the label of it in the language
     * that is on, together with every text that has been appended to it. The text field
     * of this box stores every line break of its own as a carriage return, so the lines
     * of the answer below are separated by those and not by the new lines they have been
     * handed over with.
     */
    public function getText():String
    {
      return baseTextField.text;
    }
    /**
     * Appends the given text to the end of the text of this box.
     * @param newText the text to be appended
     */
    public function appendText(newText:String):void
    {
      application.trace("<" + this + " TextBox appendText> called.", 1);
      application.trace("<" + this + " TextBox appendText> newText: " + newText, 0);
      baseTextField.appendText(newText);
      doDimensionsOrTextChanged();
    }
    /**
     * Tells whether the text keys standing in the text of this box are looked up.
     */
    public function getTextKeysEnabled():Boolean
    {
      return baseTextField.getTextKeysEnabled();
    }
    /**
     * Switches the looking up of the text keys of this box on and off: a box that is
     * switched off displays the brackets of its text exactly the way they have arrived,
     * so a source code or any other text of the outside world carrying such brackets is
     * never touched.
     * @param b true when the text keys have to be looked up
     */
    public function setTextKeysEnabled(b:Boolean):void
    {
      application.trace("<" + this + " TextBox setTextKeysEnabled> called.", 1);
      application.trace("<" + this + " TextBox setTextKeysEnabled> b: " + b, 0);
      if (baseTextField.getTextKeysEnabled() != b)
      {
        baseTextField.setTextKeysEnabled(b);
        doDimensionsOrTextChanged();
      }
    }
    /**
     * Tells whether the text of this box is displayed as a html one.
     */
    public function getHtml():Boolean
    {
      return baseTextField.getHtml();
    }
    /**
     * Displays the text of this box as a html one or as a plain one. A box that takes
     * plain text only displays the tags of a html text as they are.
     * @param html true when the text has to be displayed as a html one
     */
    public function setHtml(html:Boolean):void
    {
      application.trace("<" + this + " TextBox setHtml> called.", 1);
      application.trace("<" + this + " TextBox setHtml> html: " + html, 0);
      if (baseTextField.getHtml() != html)
      {
        baseTextField.setHtml(html);
        doDimensionsOrTextChanged();
      }
    }
    /**
     * Tells whether this box is being scrolled by the one using it right now.
     */
    public function getScrolling():Boolean
    {
      return baseScroll.getScrolled();
    }
    /**
     * Tells whether the very bottom of the content of this box is displayed. A content that is
     * a shorter one than this box stands at its bottom as well.
     */
    public function getAtBottom():Boolean
    {
      application.trace("<" + this + " TextBox getAtBottom> called.", 1);
      return baseScroll.getDhContent() <= getDh()
        || baseScroll.getCyContent() <= getDh() - baseScroll.getDhContent();
    }
    /**
     * Scrolls the content of this box down to its very bottom. The coordinate asked for here
     * is clamped by the scroll itself, so any deep enough one reaches the end of the text.
     */
    public function toBottom():void
    {
      application.trace("<" + this + " TextBox toBottom> called.", 1);
      baseScroll.setContentPosition(baseScroll.getCxContent(), getDh() - baseScroll.getDhContent(), true);
    }
    /**
     * Scrolls the text to its very top and forwards the top reached event of the scroll.
     * @param eventTopReached the top reached event of the scroll
     */
    protected function dispatchEventTopReached(eventTopReached:Event):void
    {
      application.trace("<" + this + " TextBox dispatchEventTopReached> called.", 1);
      application.trace("<" + this + " TextBox dispatchEventTopReached> eventTopReached: " + eventTopReached, 0);
      baseTextField.scrollV = 0;
      if (getBaseEventDispatcher() != null && eventTopReached != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventTopReached);
      }
    }
    /**
     * Scrolls the text to its very bottom and forwards the bottom reached event of the scroll.
     * @param eventBottomReached the bottom reached event of the scroll
     */
    protected function dispatchEventBottomReached(eventBottomReached:Event):void
    {
      application.trace("<" + this + " TextBox dispatchEventBottomReached> called.", 1);
      application.trace("<" + this + " TextBox dispatchEventBottomReached> eventBottomReached: " + eventBottomReached, 0);
      baseTextField.scrollV = baseTextField.maxScrollV;
      if (getBaseEventDispatcher() != null && eventBottomReached != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventBottomReached);
      }
    }
    /**
     * Resizes the scroll and the text field to this box, then hands the size of the text
     * over to the scroll as the size of its content.
     * @param e the padding changed event of the application, null on a direct call
     */
    protected function doDimensionsOrTextChanged(e:Event = null):void
    {
      application.trace("<" + this + " TextBox doDimensionsOrTextChanged> called.", 1);
      application.trace("<" + this + " TextBox doDimensionsOrTextChanged> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      baseScroll.setDwh(getDw(), getDh());
      baseTextField.setDwh(getDw() - 2 * padding, getDh() - 2 * padding, true);
      baseTextField.setCxy(padding, padding);
      baseScroll.setDwhContent(baseTextField.textWidth + 4 * baseTextField.getCx(), baseTextField.textHeight);
    }
    /**
     * Rebuilds the content of this box after its own dimensions have been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " TextBox doDimensionsChanged> called.", 1);
      super.doDimensionsChanged();
      doDimensionsOrTextChanged();
    }
    /**
     * Takes the dimensions of the scroll after it has been resized by the one using it.
     * @param e the dimensions changed event of the scroll
     */
    private function scrollDimensionsChanged(e:Event):void
    {
      application.trace("<" + this + " TextBox scrollDimensionsChanged> called.", 1);
      application.trace("<" + this + " TextBox scrollDimensionsChanged> e: " + e, 0);
      setDwh(baseScroll.getDw(), baseScroll.getDh());
    }
    /**
     * Scrolls the text horizontally to the position of the content of the scroll. The scroll
     * works in pixels and the text field in columns, so the position is converted here.
     * @param e the content x changed event of the scroll
     */
    private function reposTextX(e:Event):void
    {
      application.trace("<" + this + " TextBox reposTextX> called.", 1);
      application.trace("<" + this + " TextBox reposTextX> e: " + e, 0);
      const textw:Number = baseTextField.textWidth - 2 * application.getDynamicsConfig().getAppPadding() - baseTextField.width;
      baseTextField.scrollH = Math.min(Math.abs(Math.round(baseScroll.getCxContent() * baseTextField.maxScrollH / textw))
        , baseTextField.maxScrollH);
    }
    /**
     * Scrolls the text vertically to the position of the content of the scroll. The scroll
     * works in pixels and the text field in lines, so the position is converted here.
     * @param e the content y changed event of the scroll
     */
    private function reposTextY(e:Event):void
    {
      application.trace("<" + this + " TextBox reposTextY> called.", 1);
      application.trace("<" + this + " TextBox reposTextY> e: " + e, 0);
      const texth:Number = baseTextField.textHeight - baseTextField.height;
      baseTextField.scrollV = Math.min(Math.abs(Math.round(baseScroll.getCyContent() * baseTextField.maxScrollV / texth))
        , baseTextField.maxScrollV);
    }
    /**
     * Frees all listeners and references held by this box.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " TextBox destroy> called.", 1);
      application.trace("<" + this + " TextBox destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), doDimensionsOrTextChanged);
      application.trace("<" + this + " TextBox destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " TextBox destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " TextBox destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      baseTextField = null;
      baseScroll = null;
    }
  }
}
