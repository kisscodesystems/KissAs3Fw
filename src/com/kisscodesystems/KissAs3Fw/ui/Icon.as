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
 * Icon.
 * A square object to be created and then filled with any bitmap data.
 *
 * MAIN FEATURES:
 * - an icon of the icon manager is drawn in the colors of a text type, with the drop
 *   shadow of it, and it follows every change of that text format
 * - an emoji of the emoji manager is drawn in the colors of its own, without any
 *   shadow, so it follows no text format at all
 * - the bitmap data is drawn over a transparent square, so the whole object takes the
 *   mouse events and not the drawn pixels only
 * - the dimensions come from the drawing, they can not be set from the outside
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.display.BitmapData;
  import flash.events.Event;
  public class Icon extends BaseSprite
  {
    private var bitmapData:BitmapData = null;
    private var iconType:String = "";
    private var emojiType:String = "";
    private var textType:String = "";
    private var iconSize:int = 0;
    /**
     * Constructs the Icon object. Nothing is drawn into it yet.
     * @param applicationRef the main application reference
     */
    public function Icon(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Icon> called.", 1);
      application.trace("<" + this + " Icon> applicationRef: " + applicationRef, 0);
      application.trace("<" + this + " Icon> constructed.", 1);
    }
    /**
     * Returns the type of the icon drawn into this object, an empty string when there
     * is an emoji in it instead.
     */
    public function getIconType():String
    {
      return iconType;
    }
    /**
     * Returns the type of the emoji drawn into this object, an empty string when there
     * is an icon in it instead.
     */
    public function getEmojiType():String
    {
      return emojiType;
    }
    /**
     * Returns the text type the icon of this object is drawn in, an empty string when
     * there is an emoji in it.
     */
    public function getTextType():String
    {
      return textType;
    }
    /**
     * Returns the width and the height the drawing of this object stands in.
     */
    public function getIconSize():int
    {
      return iconSize;
    }
    /**
     * Frees the bitmap data of this object up and takes the dimensions of it back to
     * zero. The types are kept, so the drawing can be repeated any time.
     */
    public function destBitmapData():void
    {
      application.trace("<" + this + " Icon destBitmapData> called.", 1);
      if (bitmapData != null)
      {
        bitmapData.dispose();
        bitmapData = null;
        application.trace("<" + this + " Icon destBitmapData> bitmapData has been cleared.", 0);
      }
      super.setDwh(0, 0);
    }
    /**
     * Draws the bitmap data of an icon into this object, in the colors and with the drop
     * shadow of the given text type. This object follows every change of that very text
     * format from now on.
     * @param newIconType the type of the icon to be drawn, an EnumIcons value
     * @param newTextType the text type the icon is colored by, an EnumTextTypes value
     * @param newIconSize the width and the height of the icon to be drawn
     */
    public function drawBitmapData(newIconType:String, newTextType:String, newIconSize:int):void
    {
      application.trace("<" + this + " Icon drawBitmapData> called.", 1);
      application.trace("<" + this + " Icon drawBitmapData> newIconType: " + newIconType, 0);
      application.trace("<" + this + " Icon drawBitmapData> newTextType: " + newTextType, 0);
      application.trace("<" + this + " Icon drawBitmapData> newIconSize: " + newIconSize, 0);
      destBitmapData();
      bitmapData = application.getIconManager().getNewBitmapData(newIconType, newTextType, newIconSize);
      repaintBitmapData(newIconSize);
      filters = undefined;
      if (newTextType == EnumTextTypes.TEXT_TYPE_MID())
      {
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorMid());
      }
      else if (newTextType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorDark());
      }
      else
      {
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorBright());
      }
      updateTextFormatListener(newTextType);
      iconType = newIconType;
      emojiType = "";
      textType = newTextType;
      iconSize = newIconSize;
      application.trace("<" + this + " Icon drawBitmapData> the icon and the shadow of it are drawn.", 0);
      super.setDwh(newIconSize, newIconSize);
    }
    /**
     * Draws the bitmap data of an emoji into this object. An emoji comes in its own
     * colors, so it needs neither a text type nor a drop shadow, and it does not follow
     * the text formats of the application either.
     * @param newEmojiType the type of the emoji to be drawn, an EnumEmojis value
     * @param newIconSize the width and the height of the emoji to be drawn
     */
    public function drawEmojiBitmapData(newEmojiType:String, newIconSize:int):void
    {
      application.trace("<" + this + " Icon drawEmojiBitmapData> called.", 1);
      application.trace("<" + this + " Icon drawEmojiBitmapData> newEmojiType: " + newEmojiType, 0);
      application.trace("<" + this + " Icon drawEmojiBitmapData> newIconSize: " + newIconSize, 0);
      destBitmapData();
      bitmapData = application.getEmojiManager().getNewBitmapData(newEmojiType, newIconSize);
      repaintBitmapData(newIconSize);
      filters = undefined;
      removeTextFormatListeners();
      iconType = "";
      emojiType = newEmojiType;
      textType = "";
      iconSize = newIconSize;
      application.trace("<" + this + " Icon drawEmojiBitmapData> the emoji is drawn.", 0);
      super.setDwh(newIconSize, newIconSize);
    }
    /**
     * The dimensions of this object come from the drawing of it, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Icon setDw> called.", 1);
      application.trace("<" + this + " Icon setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Icon setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the drawing of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Icon setDh> called.", 1);
      application.trace("<" + this + " Icon setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Icon setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the drawing of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Icon setDwh> called.", 1);
      application.trace("<" + this + " Icon setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Icon setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Icon setDwh> do nothing.", 1);
    }
    /**
     * Draws the bitmap data of this object over a transparent rectangle, so that the
     * whole square of this object takes the mouse events and not the drawn pixels only.
     * @param size the width and the height of the drawn square
     */
    private function repaintBitmapData(size:int):void
    {
      application.trace("<" + this + " Icon repaintBitmapData> called.", 1);
      application.trace("<" + this + " Icon repaintBitmapData> size: " + size, 0);
      if (bitmapData != null)
      {
        graphics.clear();
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
        graphics.beginBitmapFill(bitmapData, null, false, true);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
        application.trace("<" + this + " Icon repaintBitmapData> bitmap data is drawn.", 0);
      }
    }
    /**
     * Draws the drop shadow of this object in the color that stands out of the given
     * one the best.
     * @param color the color of the drawing the shadow is put under
     */
    private function setDropShadowFilter(color:Number):void
    {
      application.trace("<" + this + " Icon setDropShadowFilter> called.", 1);
      application.trace("<" + this + " Icon setDropShadowFilter> color: " + color, 0);
      if (application.brightShadowToApply(color.toString(16)))
      {
        filters = application.getComponentsConfig().getTextDropShadowArrayBright();
        application.trace("<" + this + " Icon setDropShadowFilter> BRIGHT.", 0);
      }
      else
      {
        filters = application.getComponentsConfig().getTextDropShadowArrayDark();
        application.trace("<" + this + " Icon setDropShadowFilter> DARK.", 0);
      }
    }
    /**
     * Follows the text format of the given text type from now on, and stops following
     * the one this object has followed so far.
     * @param newTextType the text type to be followed, an EnumTextTypes value
     */
    private function updateTextFormatListener(newTextType:String):void
    {
      application.trace("<" + this + " Icon updateTextFormatListener> called.", 1);
      application.trace("<" + this + " Icon updateTextFormatListener> newTextType: " + newTextType, 0);
      if (textType != newTextType)
      {
        removeTextFormatListeners();
        if (newTextType == EnumTextTypes.TEXT_TYPE_MID())
        {
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatChanged);
        }
        else if (newTextType == EnumTextTypes.TEXT_TYPE_DARK())
        {
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatChanged);
        }
        else
        {
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatChanged);
        }
        application.trace("<" + this + " Icon updateTextFormatListener> the new text type is followed.", 0);
      }
    }
    /**
     * Stops following the text formats of the application. An object holding an emoji
     * or an empty one follows none of them, and that is the state of the text type this
     * method is left in on the spot: the dispatcher of the application holds every
     * listener of the whole application, so a removal that has nothing to remove walks
     * that whole store for nothing. A picker builds hundreds of emojis at a time.
     */
    private function removeTextFormatListeners():void
    {
      application.trace("<" + this + " Icon removeTextFormatListeners> called.", 1);
      if (textType == "")
      {
        application.trace("<" + this + " Icon removeTextFormatListeners> no text format is followed.", 1);
        return;
      }
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatChanged);
      textType = "";
    }
    /**
     * Draws the icon of this object again in the colors of the new text format. Only
     * the followed text format reaches this object, and an emoji follows none of them.
     * @param e the text format changed event of the application
     */
    private function textFormatChanged(e:Event):void
    {
      application.trace("<" + this + " Icon textFormatChanged> called.", 1);
      application.trace("<" + this + " Icon textFormatChanged> e: " + e, 0);
      drawBitmapData(iconType, textType, iconSize);
    }
    /**
     * Frees the bitmap data, the listeners and every reference held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Icon destroy> called.", 1);
      application.trace("<" + this + " Icon destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeTextFormatListeners();
      application.trace("<" + this + " Icon destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      destBitmapData();
      application.trace("<" + this + " Icon destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      filters = undefined;
      iconType = null;
      emojiType = null;
      textType = null;
      iconSize = 0;
    }
  }
}
