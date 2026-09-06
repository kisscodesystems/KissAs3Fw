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
 * TextLabel.
 * Not scrollable text. Can be multiline if maxWidth has been set.
 *
 * MAIN FEATURES:
 * - the text code is displayed and will be changed automatically if the lang code is changed
 * - multiline text displaying is enabled
 * - maxWidth can be set (useful for example in base list)
 * - an icon can be set, standing in front of the text
 * - an emoji can be set instead of that icon, they stand in the very same slot
 * - it extends the BaseReact, so emojis can be stuck onto it as soon as the react
 *   feature of it is switched on: the dimensions set here are the dimensions of the
 *   text itself, the react row is placed under it by that base class
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseReact;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import flash.events.Event;
  import flash.text.TextFieldAutoSize;
  public class TextLabel extends BaseReact
  {
    private var maxWidth:int = 0;
    private var baseTextField:BaseTextField = null;
    private var icon:Icon = null;
    private var iconType:String = "";
    private var emojiType:String = "";
    private var margin:int = 0;
    /**
     * Constructs the TextLabel object: creates the text field of it and starts to
     * follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function TextLabel(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " TextLabel> called.", 1);
      application.trace("<" + this + " TextLabel> applicationRef: " + applicationRef, 0);
      baseTextField = new BaseTextField(application);
      addChild(baseTextField);
      baseTextField.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), baseTextFieldResized);
      baseTextField.selectable = false;
      baseTextField.autoSize = TextFieldAutoSize.LEFT;
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_BRIGHT());
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
      application.trace("<" + this + " TextLabel> constructed.", 1);
    }
    /**
     * Returns the icon object standing in front of the text, null when there is none.
     * That very object holds the emoji of this label as well.
     */
    public function getIcon():Icon
    {
      return icon;
    }
    /**
     * Returns the type of the icon of this label, an empty string when there is none.
     */
    public function getIconType():String
    {
      return iconType;
    }
    /**
     * Returns the type of the emoji of this label, an empty string when there is none.
     */
    public function getEmojiType():String
    {
      return emojiType;
    }
    /**
     * Frees up the leading slot of this label: the icon and the emoji as well.
     */
    public function destIcon():void
    {
      application.trace("<" + this + " TextLabel destIcon> called.", 1);
      if (icon != null)
      {
        icon.destroy();
        if (contains(icon))
        {
          removeChild(icon);
        }
        icon = null;
      }
      iconType = "";
      emojiType = "";
      margin = 0;
      repos();
    }
    /**
     * Displays the given icon in the leading slot of this label. An icon and an emoji
     * are exclusive to each other, so the previous content of that slot is dropped.
     * @param it the type of the icon to be displayed, an EnumIcons value
     */
    public function setIcon(it:String):void
    {
      application.trace("<" + this + " TextLabel setIcon> called.", 1);
      application.trace("<" + this + " TextLabel setIcon> it: " + it, 0);
      if (it == "")
      {
        application.trace("<" + this + " TextLabel setIcon> it is empty!", 6);
        return;
      }
      iconType = "" + it;
      emojiType = "";
      createIcon();
      icon.drawBitmapData(iconType, baseTextField.getType(), getIconSizeToDraw());
      repos();
    }
    /**
     * Displays the given emoji in the leading slot of this label. An emoji and an icon
     * are exclusive to each other, so the previous content of that slot is dropped.
     * @param et the type of the emoji to be displayed, an EnumEmojis value
     */
    public function setEmoji(et:String):void
    {
      application.trace("<" + this + " TextLabel setEmoji> called.", 1);
      application.trace("<" + this + " TextLabel setEmoji> et: " + et, 0);
      if (et == "")
      {
        application.trace("<" + this + " TextLabel setEmoji> et is empty!", 6);
        return;
      }
      emojiType = "" + et;
      iconType = "";
      createIcon();
      icon.drawEmojiBitmapData(emojiType, getIconSizeToDraw());
      repos();
    }
    /**
     * Returns the text field object this label displays its text in.
     */
    public function getBaseTextField():BaseTextField
    {
      return baseTextField;
    }
    /**
     * Returns the text or the text key this label displays.
     */
    public function getLabel():String
    {
      return baseTextField.getLabel();
    }
    /**
     * Sets the text of this label. A text key is displayed in the current language of
     * the application and follows every change of it, every other text is displayed
     * as it is.
     * @param t the new text or text key of this label
     */
    public function setLabel(t:String):void
    {
      application.trace("<" + this + " TextLabel setLabel> called.", 1);
      application.trace("<" + this + " TextLabel setLabel> t: " + t, 0);
      baseTextField.setLabel(t);
    }
    /**
     * Returns the text type of this label, an EnumTextTypes value.
     */
    public function getType():String
    {
      return baseTextField.getType();
    }
    /**
     * Sets the text type of this label and draws the leading slot of it in the colors
     * of that new type.
     * @param tt the new text type, an EnumTextTypes value
     */
    public function setType(tt:String):void
    {
      application.trace("<" + this + " TextLabel setType> called.", 1);
      application.trace("<" + this + " TextLabel setType> tt: " + tt, 0);
      baseTextField.setType(tt);
      redrawIconOrEmoji();
    }
    /**
     * Sets the width the text of this label has to be kept inside. A zero width lets
     * that text take the room it needs.
     * @param newWidth the maximum width of this label
     * @param allowMultiline true when the text can be broken into several lines
     */
    public function setMaxWidth(newWidth:int, allowMultiline:Boolean):void
    {
      application.trace("<" + this + " TextLabel setMaxWidth> called.", 1);
      application.trace("<" + this + " TextLabel setMaxWidth> newWidth: " + newWidth, 0);
      application.trace("<" + this + " TextLabel setMaxWidth> allowMultiline: " + allowMultiline, 0);
      if (newWidth >= 0 && newWidth != maxWidth)
      {
        application.trace("<" + this + " TextLabel setMaxWidth> conditions OK.", 1);
        maxWidth = newWidth;
        if (maxWidth > 0)
        {
          if (allowMultiline)
          {
            baseTextField.autoSize = TextFieldAutoSize.LEFT;
            baseTextField.wordWrap = true;
            baseTextField.multiline = true;
            baseTextField.width = maxWidth - (icon == null ? 0 : icon.getDw());
          }
          else
          {
            const tfh:int = application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType());
            baseTextField.autoSize = TextFieldAutoSize.NONE;
            baseTextField.wordWrap = false;
            baseTextField.multiline = false;
            baseTextField.width = maxWidth - (icon == null ? 0 : icon.getDw());
            baseTextField.height = tfh;
          }
        }
        else
        {
          baseTextField.autoSize = TextFieldAutoSize.LEFT;
          baseTextField.wordWrap = false;
          baseTextField.multiline = false;
        }
        baseTextField.setDwh(baseTextField.width, baseTextField.height);
        super.setDwh(baseTextField.getCx() + baseTextField.width, baseTextField.height);
        repos();
      }
    }
    /**
     * The width of this label comes from the text and from the maximum width of it,
     * so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " TextLabel setDw> called.", 1);
      application.trace("<" + this + " TextLabel setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " TextLabel setDw> do nothing.", 1);
    }
    /**
     * The height of this label comes from the text of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " TextLabel setDh> called.", 1);
      application.trace("<" + this + " TextLabel setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " TextLabel setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this label come from the text of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " TextLabel setDwh> called.", 1);
      application.trace("<" + this + " TextLabel setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " TextLabel setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " TextLabel setDwh> do nothing.", 1);
    }
    /**
     * Renders this label in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " TextLabel addedToStage> called.", 1);
      application.trace("<" + this + " TextLabel addedToStage> e: " + e, 0);
      super.addedToStage(e);
      repos();
    }
    /**
     * Returns the margin standing around the leading icon or emoji of this label.
     */
    private function getIconMargin():int
    {
      return Math.max(2, application.getDynamicsConfig().getAppLineThickness(), int(application.getDynamicsConfig().getAppFontSize() / 5));
    }
    /**
     * Returns the size the leading icon or emoji of this label has to be drawn in: the
     * height of the text without the margins standing above and below it.
     */
    private function getIconSizeToDraw():int
    {
      return application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType()) - 2 * getIconMargin();
    }
    /**
     * Creates the leading icon object of this label if it is not there yet and takes
     * the margin standing around it.
     */
    private function createIcon():void
    {
      application.trace("<" + this + " TextLabel createIcon> called.", 1);
      margin = getIconMargin();
      if (icon == null)
      {
        application.trace("<" + this + " TextLabel createIcon> creating new Icon.", 0);
        icon = new Icon(application);
        addChild(icon);
      }
      else
      {
        application.trace("<" + this + " TextLabel createIcon> existing Icon.", 0);
      }
    }
    /**
     * Draws the leading slot of this label again, in the size and in the colors the
     * current appearance of the application means. It does nothing when that slot is
     * empty.
     */
    private function redrawIconOrEmoji():void
    {
      application.trace("<" + this + " TextLabel redrawIconOrEmoji> called.", 1);
      if (emojiType != null && emojiType != "")
      {
        setEmoji(emojiType);
      }
      else if (iconType != null && iconType != "")
      {
        setIcon(iconType);
      }
    }
    /**
     * Draws the leading slot of this label again, but only when it does not stand in
     * the size it has to. The text field of this label follows every text format change
     * of the application on its own, and the height of it drives the size of that slot,
     * so this is the way an icon and an emoji follow a font face, bold or italic change.
     * The size is compared first, so that the redraw can not call itself endlessly
     * through the dimensions changed event of that text field.
     */
    private function redrawIconOrEmojiIfSizeChanged():void
    {
      application.trace("<" + this + " TextLabel redrawIconOrEmojiIfSizeChanged> called.", 1);
      if (icon != null && icon.getIconSize() != getIconSizeToDraw())
      {
        application.trace("<" + this + " TextLabel redrawIconOrEmojiIfSizeChanged> conditions OK.", 1);
        redrawIconOrEmoji();
      }
    }
    /**
     * Positions the leading slot and the text of this label next to each other and
     * takes the dimensions of this label afterwards.
     */
    private function repos():void
    {
      application.trace("<" + this + " TextLabel repos> called.", 1);
      if (icon != null)
      {
        icon.setCx(Math.round(margin));
        icon.setCy(Math.round(margin));
        const tfh:int = application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType());
        baseTextField.setCx(tfh);
      }
      else
      {
        baseTextField.setCx(0);
      }
      baseTextField.setCy(application.getDynamicsConfig().getTextFieldHeightCorrection(baseTextField.getType()));
      updateDwh();
    }
    /**
     * Takes the dimensions of this label from the leading slot, from the text and from
     * the maximum width of it.
     */
    private function updateDwh():void
    {
      application.trace("<" + this + " TextLabel updateDwh> called.", 1);
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(baseTextField.getType());
      if (maxWidth == 0)
      {
        if (baseTextField.getLabel() == "")
        {
          if (icon == null)
          {
            super.setDwh(tfh, 0);
          }
          else
          {
            super.setDwh(tfh, tfh);
          }
        }
        else
        {
          super.setDwh(baseTextField.getCx() + baseTextField.getDw(), Math.max(baseTextField.getDh(), tfh));
        }
      }
      else
      {
        if (icon == null)
        {
          baseTextField.setDw(maxWidth);
        }
        else
        {
          baseTextField.setDw(maxWidth - baseTextField.getCx());
        }
        super.setDwh(maxWidth, Math.max(baseTextField.getDh(), tfh));
      }
    }
    /**
     * Positions everything again after the text field has taken a new size, and draws
     * the leading slot again when that new size means another one for it as well.
     * @param e the dimensions changed event of the text field
     */
    private function baseTextFieldResized(e:Event):void
    {
      application.trace("<" + this + " TextLabel baseTextFieldResized> called.", 1);
      application.trace("<" + this + " TextLabel baseTextFieldResized> e: " + e, 0);
      redrawIconOrEmojiIfSizeChanged();
      repos();
    }
    /**
     * Draws and positions everything again after the line thickness of the application
     * has been changed: the margin around the leading slot is taken from it.
     * @param e the line thickness changed event of the application
     */
    private function lineThicknessChanged(e:Event):void
    {
      application.trace("<" + this + " TextLabel lineThicknessChanged> called.", 1);
      application.trace("<" + this + " TextLabel lineThicknessChanged> e: " + e, 0);
      redrawIconOrEmoji();
      repos();
    }
    /**
     * Draws and positions everything again after the font size of the application has
     * been changed: the whole label is measured by it.
     * @param e the font size changed event of the application
     */
    private function fontSizeChanged(e:Event):void
    {
      application.trace("<" + this + " TextLabel fontSizeChanged> called.", 1);
      application.trace("<" + this + " TextLabel fontSizeChanged> e: " + e, 0);
      redrawIconOrEmoji();
      repos();
    }
    /**
     * Frees all listeners and references held by this label.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " TextLabel destroy> called.", 1);
      application.trace("<" + this + " TextLabel destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
      application.trace("<" + this + " TextLabel destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " TextLabel destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      maxWidth = 0;
      icon = null;
      iconType = null;
      emojiType = null;
      baseTextField = null;
      margin = 0;
    }
  }
}
