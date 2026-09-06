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
 * Rater.
 * A component that can be used to take or to display a voting.
 * The rate is visualized by a row of stars, drawn as blank, half or full ones.
 *
 * MAIN FEATURES:
 * - one single click is enough to rate
 * - the rate under the mouse is displayed continuously while the mouse is over it
 * - a readonly rater only displays a rate, it can not be clicked at all
 * - the number of the stars comes from the components config
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class Rater extends BaseSprite
  {
    private var readonly:Boolean = true;
    private var background:BaseShape = null;
    private var foreground:BaseSprite = null;
    private var starsArray:Array = null;
    private var starsw:int = 0;
    private var rate:Number = 0;
    private var eventChanged:Event = null;
    /**
     * Constructs the Rater object: creates the background frame, the invisible
     * foreground layer that takes the mouse interactions and the stars themselves.
     * @param applicationRef the main application reference
     */
    public function Rater(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Rater> called.", 1);
      application.trace("<" + this + " Rater> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      background = new BaseShape(application);
      addChild(background);
      foreground = new BaseSprite(application);
      addChild(foreground);
      foreground.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
      foreground.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
      starsArray = new Array();
      updateStarsw();
      createStars();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawBackgroundAndForeground);
      application.trace("<" + this + " Rater> constructed.", 1);
    }
    /**
     * Returns the rate this object displays at the moment.
     */
    public function getRate():Number
    {
      return rate;
    }
    /**
     * Sets the rate to be displayed by this object.
     * @param newRate the new rate, a half is displayed by a half star
     */
    public function setRate(newRate:Number):void
    {
      application.trace("<" + this + " Rater setRate> called.", 1);
      application.trace("<" + this + " Rater setRate> newRate: " + newRate, 0);
      rate = newRate;
      updateRateDisplaying(rate);
    }
    /**
     * Tells whether this object only displays a rate instead of taking one.
     */
    public function getReadonly():Boolean
    {
      return readonly;
    }
    /**
     * Sets whether this object only displays a rate instead of taking one.
     * @param b true when this object must not be clickable
     */
    public function setReadonly(b:Boolean):void
    {
      application.trace("<" + this + " Rater setReadonly> called.", 1);
      application.trace("<" + this + " Rater setReadonly> b: " + b, 0);
      readonly = b;
      if (readonly)
      {
        rollOut();
      }
    }
    /**
     * The dimensions of this object come from the number and the size of its stars,
     * so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Rater setDw> called.", 1);
      application.trace("<" + this + " Rater setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Rater setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the number and the size of its stars,
     * so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Rater setDh> called.", 1);
      application.trace("<" + this + " Rater setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Rater setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the number and the size of its stars,
     * so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Rater setDwh> called.", 1);
      application.trace("<" + this + " Rater setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Rater setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Rater setDwh> do nothing.", 1);
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Rater addedToStage> called.", 1);
      application.trace("<" + this + " Rater addedToStage> e: " + e, 0);
      super.addedToStage(e);
      reposResizeStars();
    }
    /**
     * Starts to follow the mouse while it is over this object, but only when a rate
     * can be taken at all.
     * @param e the roll over event of the foreground layer
     */
    private function rollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " Rater rollOver> called.", 1);
      application.trace("<" + this + " Rater rollOver> e: " + e, 0);
      if (!readonly && getEnabled())
      {
        foreground.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
        foreground.addEventListener(MouseEvent.CLICK, click, false, 0, true);
      }
    }
    /**
     * Stops following the mouse and displays the rate of this object again.
     * @param e the roll out event of the foreground layer, null on a direct call
     */
    private function rollOut(e:MouseEvent = null):void
    {
      application.trace("<" + this + " Rater rollOut> called.", 1);
      application.trace("<" + this + " Rater rollOut> e: " + e, 0);
      foreground.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
      foreground.removeEventListener(MouseEvent.CLICK, click);
      updateRateDisplaying(rate);
    }
    /**
     * Takes the rate the mouse points at and dispatches the changed event of this
     * object. Every further mouse event is ignored until the mouse leaves and comes
     * back again.
     * @param e the click event of the foreground layer
     */
    private function click(e:MouseEvent):void
    {
      application.trace("<" + this + " Rater click> called.", 1);
      application.trace("<" + this + " Rater click> e: " + e, 0);
      rate = getRateValueByMouse();
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
      rollOut();
    }
    /**
     * Displays the rate the mouse points at, without taking it.
     * @param e the mouse move event of the foreground layer
     */
    private function mouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " Rater mouseMove> called.", 0);
      application.trace("<" + this + " Rater mouseMove> e: " + e, 0);
      updateRateDisplaying(getRateValueByMouse());
    }
    /**
     * Returns the rate the current mouse position means, rounded to a half star.
     */
    private function getRateValueByMouse():Number
    {
      application.trace("<" + this + " Rater getRateValueByMouse> called.", 0);
      const rateValue:Number = Math.round((foreground.mouseX - application.getDynamicsConfig().getAppPadding()) / starsw * 2) / 2;
      application.trace("<" + this + " Rater getRateValueByMouse> rateValue: " + rateValue, 0);
      return rateValue;
    }
    /**
     * Creates the stars of this object, dropping the previous ones first.
     */
    private function createStars():void
    {
      application.trace("<" + this + " Rater createStars> called.", 1);
      clearStars();
      for (var i:int = 0; i < application.getComponentsConfig().getRaterNumOfStars(); i++)
      {
        var icon:Icon = new Icon(application);
        addChild(icon);
        starsArray.push(icon);
      }
      reposResizeStars();
      setChildIndex(foreground, numChildren - 1);
    }
    /**
     * Destroys and drops every star of this object.
     */
    private function clearStars():void
    {
      application.trace("<" + this + " Rater clearStars> called.", 1);
      for (var i:int = 0; i < starsArray.length; i++)
      {
        if (starsArray[i] is Icon)
        {
          var icon:Icon = Icon(starsArray[i]);
          icon.destroy();
          if (contains(icon))
          {
            removeChild(icon);
          }
          starsArray[i] = null;
        }
      }
      starsArray.splice(0);
    }
    /**
     * Takes the current width of one single star from the height of a mid text.
     */
    private function updateStarsw():void
    {
      application.trace("<" + this + " Rater updateStarsw> called.", 1);
      starsw = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID());
      application.trace("<" + this + " Rater updateStarsw> starsw: " + starsw, 0);
    }
    /**
     * Displays the given rate on the stars of this object.
     * @param rateToDisplay the rate to be displayed
     */
    private function updateRateDisplaying(rateToDisplay:Number):void
    {
      application.trace("<" + this + " Rater updateRateDisplaying> called.", 1);
      application.trace("<" + this + " Rater updateRateDisplaying> rateToDisplay: " + rateToDisplay, 0);
      for (var i:int = 0; i < starsArray.length; i++)
      {
        if (starsArray[i] is Icon)
        {
          var iconType:String = EnumIcons.starblank();
          if (i + 0.75 < rateToDisplay)
          {
            iconType = EnumIcons.starfull();
          }
          else if (i + 0.25 < rateToDisplay && rateToDisplay < i + 0.75)
          {
            iconType = EnumIcons.starhalf();
          }
          Icon(starsArray[i]).drawBitmapData(iconType, EnumTextTypes.TEXT_TYPE_MID(), starsw);
        }
      }
    }
    /**
     * Repositions the stars next to each other and resizes this object to the room
     * they need.
     */
    private function reposResizeStars():void
    {
      application.trace("<" + this + " Rater reposResizeStars> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      for (var i:int = 0; i < starsArray.length; i++)
      {
        if (starsArray[i] is Icon)
        {
          Icon(starsArray[i]).setCxy(padding + i * starsw, padding);
        }
      }
      super.setDwh(2 * padding + starsArray.length * starsw, 2 * padding + starsw);
      redrawBackgroundAndForeground();
      rollOut();
    }
    /**
     * Repositions and resizes the stars after the padding of the application has
     * been changed.
     * @param e the padding changed event of the application
     */
    private function paddingChanged(e:Event):void
    {
      application.trace("<" + this + " Rater paddingChanged> called.", 1);
      application.trace("<" + this + " Rater paddingChanged> e: " + e, 0);
      reposResizeStars();
    }
    /**
     * Takes the new size of one single star and repositions the stars after the mid
     * text format of the application has been changed.
     * @param e the mid text format changed event of the application
     */
    private function textFormatMidChanged(e:Event):void
    {
      application.trace("<" + this + " Rater textFormatMidChanged> called.", 1);
      application.trace("<" + this + " Rater textFormatMidChanged> e: " + e, 0);
      updateStarsw();
      reposResizeStars();
    }
    /**
     * Redraws the background frame in the current colors, radius, box and dimensions,
     * and the transparent foreground layer that takes the mouse interactions.
     * @param e the radius, box corner, box frame or background color changed event of
     * the application, null on a direct call
     */
    private function redrawBackgroundAndForeground(e:Event = null):void
    {
      application.trace("<" + this + " Rater redrawBackgroundAndForeground> called.", 1);
      application.trace("<" + this + " Rater redrawBackgroundAndForeground> e: " + e, 0);
      background.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorAlpha() / 2
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      background.setRadius(application.getDynamicsConfig().getAppRadius());
      background.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
      background.setDwh(getDw(), getDh());
      background.drawRect();
      foreground.graphics.clear();
      foreground.graphics.beginFill(0, 0);
      foreground.graphics.drawRect(0, 0, getDw(), getDh());
      foreground.graphics.endFill();
    }
    /**
     * Frees all listeners, events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Rater destroy> called.", 1);
      application.trace("<" + this + " Rater destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawBackgroundAndForeground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawBackgroundAndForeground);
      foreground.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
      foreground.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
      foreground.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
      foreground.removeEventListener(MouseEvent.CLICK, click);
      application.trace("<" + this + " Rater destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      starsArray.splice(0);
      application.trace("<" + this + " Rater destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      readonly = false;
      background = null;
      foreground = null;
      starsArray = null;
      starsw = 0;
      rate = 0;
      eventChanged = null;
    }
  }
}
