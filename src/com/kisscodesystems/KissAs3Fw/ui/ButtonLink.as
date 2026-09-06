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
 * ButtonLink.
 * A clickable link surrounded with a base shape rect.
 *
 * MAIN FEATURES:
 * - a clickable text label, an icon or an emoji can stand in front of that text
 * - the shape behind the label follows the mouse: it is drawn flat, pressed or not
 *   pressed at all
 * - it goes to a web browser page if one is specified, but it hands the post data
 *   over as get data when we are in an air application
 * - the dimensions come from the label and from the padding of the application
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.navigateToURL;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  public class ButtonLink extends BaseSprite
  {
    private var backgroundBaseShape:BaseShape = null;
    protected var textLabel:TextLabel = null;
    private var foregroundSprite:BaseSprite = null;
    private var eventClick:Event = null;
    private var type:int = EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE();
    private var url:String = null;
    private var data:URLVariables = null;
    /**
     * Constructs the ButtonLink object: creates the background shape, the label and the
     * transparent foreground layer that takes the mouse interactions, then starts to
     * follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function ButtonLink(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ButtonLink> called.", 1);
      application.trace("<" + this + " ButtonLink> applicationRef: " + applicationRef, 0);
      eventClick = new Event(EnumEvents.EVENT_CLICK());
      backgroundBaseShape = new BaseShape(application);
      addChild(backgroundBaseShape);
      backgroundBaseShape.setIsBright(true);
      backgroundBaseShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      textLabel = new TextLabel(application);
      addChild(textLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_DARK());
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resize);
      foregroundSprite = new BaseSprite(application);
      addChild(foregroundSprite);
      foregroundSprite.addEventListener(MouseEvent.ROLL_OVER, rollOver);
      foregroundSprite.addEventListener(MouseEvent.ROLL_OUT, rollOut);
      foregroundSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
      foregroundSprite.addEventListener(MouseEvent.CLICK, click);
      textLabel.setLabel("");
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ButtonLink> constructed.", 1);
    }
    /**
     * Returns the text or the text key this button displays.
     */
    public function getLabel():String
    {
      return textLabel.getLabel();
    }
    /**
     * Sets the text of this button.
     * @param newLabel the new text or text key of this button
     */
    public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " ButtonLink setLabel> called.", 1);
      application.trace("<" + this + " ButtonLink setLabel> newLabel: " + newLabel, 0);
      textLabel.setLabel(newLabel);
    }
    /**
     * Returns the type of the icon of this button, an empty string when there is none.
     */
    public function getIconType():String
    {
      return textLabel.getIconType();
    }
    /**
     * Displays the given icon in front of the label of this button.
     * @param iconType the type of the icon to be displayed, an EnumIcons value
     */
    public function setIcon(iconType:String):void
    {
      application.trace("<" + this + " ButtonLink setIcon> called.", 1);
      application.trace("<" + this + " ButtonLink setIcon> iconType: " + iconType, 0);
      textLabel.setIcon(iconType);
    }
    /**
     * Returns the type of the emoji of this button, an empty string when there is none.
     */
    public function getEmojiType():String
    {
      return textLabel.getEmojiType();
    }
    /**
     * Displays the given emoji in front of the label of this button. An emoji and an
     * icon stand in the very same slot, so they are exclusive to each other.
     * @param emojiType the type of the emoji to be displayed, an EnumEmojis value
     */
    public function setEmoji(emojiType:String):void
    {
      application.trace("<" + this + " ButtonLink setEmoji> called.", 1);
      application.trace("<" + this + " ButtonLink setEmoji> emojiType: " + emojiType, 0);
      textLabel.setEmoji(emojiType);
    }
    /**
     * Frees the leading slot of this button up: the icon and the emoji as well.
     */
    public function destIcon():void
    {
      application.trace("<" + this + " ButtonLink destIcon> called.", 1);
      textLabel.destIcon();
    }
    /**
     * Returns the shape type the background of this button is drawn with, an
     * EnumBaseShapeTypes value.
     */
    public function getType():int
    {
      return type;
    }
    /**
     * Sets the shape type the background of this button is drawn with and draws that
     * background again.
     * @param newType the new shape type, an EnumBaseShapeTypes value
     */
    public function setType(newType:int):void
    {
      application.trace("<" + this + " ButtonLink setType> called.", 1);
      application.trace("<" + this + " ButtonLink setType> newType: " + newType, 0);
      if (newType == EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT()
       || newType == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE()
       || newType == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED()
       || newType == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
      {
        if (type != newType)
        {
          type = newType;
          application.trace("<" + this + " ButtonLink setType> type is now: " + type, 0);
          repaintBackground();
        }
      }
    }
    /**
     * Displays this button as one the mouse has just been moved away from. It is called
     * from the outside when the press of this button has been handed over to a scroll.
     */
    public function onRollOut():void
    {
      application.trace("<" + this + " ButtonLink onRollOut> called.", 1);
      foregroundSprite.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
    }
    /**
     * Sets the web address this button opens in a browser when it is clicked.
     * @param s the url to be opened, it has to start with http:// or https://
     */
    public function setUrl(s:String):void
    {
      application.trace("<" + this + " ButtonLink setUrl> called.", 1);
      application.trace("<" + this + " ButtonLink setUrl> s: " + s, 0);
      url = s;
    }
    /**
     * Sets the data handed over to the web address of this button. The two arrays hold
     * the names and the values of the same data, so they have to be of the same length.
     * @param arrAttrs the names of the data
     * @param arrVals the values of the data
     */
    public function setPostData(arrAttrs:Array, arrVals:Array):void
    {
      application.trace("<" + this + " ButtonLink setPostData> called.", 1);
      application.trace("<" + this + " ButtonLink setPostData> arrAttrs: " + arrAttrs, 0);
      application.trace("<" + this + " ButtonLink setPostData> arrVals: " + arrVals, 0);
      if (arrAttrs == null || arrVals == null)
      {
        application.trace("<" + this + " ButtonLink setPostData> one of the arrays is null: " + arrAttrs + ", " + arrVals, 6);
        return;
      }
      if (arrAttrs.length != arrVals.length)
      {
        application.trace("<" + this + " ButtonLink setPostData> lengths of arrays are not the same!", 6);
        return;
      }
      data = null;
      data = new URLVariables();
      for (var i:int = 0; i < arrAttrs.length; i++)
      {
        data[arrAttrs[i]] = arrVals[i];
      }
    }
    /**
     * Sets the width the label of this button has to be kept inside.
     * @param newWidth the maximum width of the label
     * @param allowMultiline true when that label can be broken into several lines
     */
    public function setMaxWidth(newWidth:int, allowMultiline:Boolean):void
    {
      application.trace("<" + this + " ButtonLink setMaxWidth> called.", 1);
      application.trace("<" + this + " ButtonLink setMaxWidth> newWidth: " + newWidth, 0);
      application.trace("<" + this + " ButtonLink setMaxWidth> allowMultiline: " + allowMultiline, 0);
      textLabel.setMaxWidth(newWidth, allowMultiline);
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ButtonLink setDw> called.", 1);
      application.trace("<" + this + " ButtonLink setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonLink setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ButtonLink setDh> called.", 1);
      application.trace("<" + this + " ButtonLink setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonLink setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ButtonLink setDwh> called.", 1);
      application.trace("<" + this + " ButtonLink setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonLink setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonLink setDwh> do nothing.", 1);
    }
    /**
     * Renders this button in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " ButtonLink addedToStage> called.", 1);
      application.trace("<" + this + " ButtonLink addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resize();
    }
    /**
     * Dispatches the click event of this button.
     */
    protected function baseWorkingButtonClick():void
    {
      application.trace("<" + this + " ButtonLink baseWorkingButtonClick> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventClick);
    }
    /**
     * Takes the dimensions of this button from the label standing on it, then positions
     * and draws everything again.
     * @param e the dimensions changed event of the label or a color, radius, box or
     * padding changed event of the application, null on a direct call
     */
    private function resize(e:Event = null):void
    {
      application.trace("<" + this + " ButtonLink resize> called.", 1);
      application.trace("<" + this + " ButtonLink resize> e: " + e, 0);
      const w:int = textLabel.getDw();
      const h:int = textLabel.getDh();
      const p:int = application.getDynamicsConfig().getAppPadding();
      super.setDwh(w + 2 * p, h + 2 * p);
      backgroundBaseShape.setDwh(getDw(), getDh());
      labelRepos();
      repaintBackground();
      repaintForeground();
    }
    /**
     * Positions the label of this button, leaving the padding of the application around it.
     */
    private function labelRepos():void
    {
      application.trace("<" + this + " ButtonLink labelRepos> called.", 1);
      const p:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setCxy(p, p);
    }
    /**
     * Draws the background shape of this button in the current colors, radius and box
     * of the application. A button of no type at all has no background drawn.
     */
    private function repaintBackground():void
    {
      application.trace("<" + this + " ButtonLink repaintBackground> called.", 1);
      backgroundBaseShape.clear();
      if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED()
       || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT()
       || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
      {
        const d:Number = application.getDynamicsConfig().getAppBackgroundColorDark();
        const m:Number = application.getDynamicsConfig().getAppBackgroundColorMid();
        const b:Number = application.getDynamicsConfig().getAppBackgroundColorBright();
        backgroundBaseShape.setColorsAndAlpha(d, d, m, 0, b);
        backgroundBaseShape.setRadius(application.getDynamicsConfig().getAppRadius());
        backgroundBaseShape.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
        backgroundBaseShape.setType(type);
        backgroundBaseShape.drawRect();
      }
    }
    /**
     * Draws the transparent layer that takes every mouse interaction of this button.
     */
    private function repaintForeground():void
    {
      application.trace("<" + this + " ButtonLink repaintForeground> called.", 1);
      foregroundSprite.graphics.clear();
      foregroundSprite.graphics.lineStyle(0, 0, 0);
      foregroundSprite.graphics.beginFill(0, 0);
      const r:int = application.getDynamicsConfig().getAppRadius();
      foregroundSprite.graphics.drawRoundRect(0, 0, getDw(), getDh(), r, r);
      foregroundSprite.graphics.endFill();
    }
    /**
     * Displays this button as one the mouse stands over.
     * @param e the roll over event of the foreground layer
     */
    private function rollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonLink rollOver> called.", 1);
      application.trace("<" + this + " ButtonLink rollOver> e: " + e, 0);
      if (getEnabled())
      {
        setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      }
    }
    /**
     * Displays this button as one the mouse has been moved away from.
     * @param e the roll out event of the foreground layer
     */
    private function rollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonLink rollOut> called.", 1);
      application.trace("<" + this + " ButtonLink rollOut> e: " + e, 0);
      setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE());
    }
    /**
     * Displays this button as a pressed one.
     * @param e the mouse down event of the foreground layer
     */
    private function mouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonLink mouseDown> called.", 1);
      application.trace("<" + this + " ButtonLink mouseDown> e: " + e, 0);
      if (getEnabled())
      {
        setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      }
    }
    /**
     * Opens the url of this button and dispatches the click event of it, but only when
     * this button has really been pressed down first.
     * @param e the click event of the foreground layer
     */
    private function click(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonLink click> called.", 1);
      application.trace("<" + this + " ButtonLink click> e: " + e, 0);
      if (getEnabled())
      {
        if (getType() == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
          navigateToUrlIfNotEmpty();
          baseWorkingButtonClick();
        }
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Opens the url of this button in a browser window, when there is one set at all.
     */
    private function navigateToUrlIfNotEmpty():void
    {
      application.trace("<" + this + " ButtonLink navigateToUrlIfNotEmpty> called.", 1);
      if (url != null)
      {
        if (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)
        {
          const urlRequest:URLRequest = new URLRequest();
          if (data != null)
          {
            urlRequest.data = data;
          }
          urlRequest.method = URLRequestMethod.POST;
          urlRequest.url = url;
          application.trace("<" + this + " ButtonLink navigateToUrlIfNotEmpty> go to " + url, 0);
          navigateToURL(urlRequest, "_blank");
        }
      }
    }
    /**
     * Frees all listeners, events and references held by this button.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ButtonLink destroy> called.", 1);
      application.trace("<" + this + " ButtonLink destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      foregroundSprite.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
      foregroundSprite.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
      foregroundSprite.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
      foregroundSprite.removeEventListener(MouseEvent.CLICK, click);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ButtonLink destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventClick.stopImmediatePropagation();
      application.trace("<" + this + " ButtonLink destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      backgroundBaseShape = null;
      textLabel = null;
      foregroundSprite = null;
      eventClick = null;
      type = 0;
      data = null;
      url = null;
    }
  }
}
