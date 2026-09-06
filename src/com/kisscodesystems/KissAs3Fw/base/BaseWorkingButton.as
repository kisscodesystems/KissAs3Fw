package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseButtonStates;
  public class BaseWorkingButton extends BaseSprite
  {
    private var baseButton:BaseButton = null;
    protected var contentSprite:BaseSprite = null;
    private var foregroundSprite:BaseSprite = null;
    private var eventClick:Event = null;
    private var customEvent:Event = null;
    /**
     * Constructs the base working button with its inner sprites and listeners.
     * @param applicationRef the application reference
     */
    public function BaseWorkingButton(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseWorkingButton> called.", 1);
      eventClick = new Event(EnumEvents.EVENT_CLICK());
      baseButton = new BaseButton(application);
      addChild(baseButton);
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
      contentSprite = new BaseSprite(application);
      addChild(contentSprite);
      foregroundSprite = new BaseSprite(application);
      addChild(foregroundSprite);
      foregroundSprite.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
      foregroundSprite.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
      foregroundSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
      foregroundSprite.addEventListener(MouseEvent.CLICK, click, false, 0, true);
      // the base button redraws its own visible shape on a radius change, but the rounded hit
      // area of the foreground sprite is drawn here, so this class has to follow it as well
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.trace("<" + this + " BaseWorkingButton> constructed.", 1);
    }
    /**
     * Sets the custom event string to be dispatched on click.
     * @param s the custom event string
     */
    public function setCustomEventString(s:String):void
    {
      application.trace("<" + this + " BaseWorkingButton setCustomEventString> called.", 1);
      application.trace("<" + this + " BaseWorkingButton setCustomEventString> s: " + s, 0);
      if (customEvent != null)
      {
        customEvent.stopImmediatePropagation();
        customEvent = null;
      }
      if (s != null)
      {
        customEvent = new Event(s);
      }
    }
    /**
     * Sets the visibility of the base working button.
     * @param v the visibility flag
     */
    public function setBaseWorkingButtonVisible(v:Boolean):void
    {
      application.trace("<" + this + " BaseWorkingButton setBaseWorkingButtonVisible> called.", 1);
      application.trace("<" + this + " BaseWorkingButton setBaseWorkingButtonVisible> v: " + v, 0);
      baseButton.visible = v;
      contentSprite.visible = v;
      foregroundSprite.visible = v;
    }
    /**
     * Returns the content sprite of the button.
     */
    public function getContentSprite():BaseSprite
    {
      return contentSprite;
    }
    /**
     * Forces a roll out on the button.
     */
    public function onRollOut():void
    {
      application.trace("<" + this + " BaseWorkingButton onRollOut> called.", 1);
      if (foregroundSprite != null)
      {
        foregroundSprite.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
      }
    }
    /**
     * Sets the width and resizes the button.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseWorkingButton setDw> called.", 1);
      application.trace("<" + this + " BaseWorkingButton setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        resetSizes();
      }
    }
    /**
     * Sets the height and resizes the button.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseWorkingButton setDh> called.", 1);
      application.trace("<" + this + " BaseWorkingButton setDh> newdh: " + newdh, 0);
      if (getDh() != newdh)
      {
        super.setDh(newdh);
        resetSizes();
      }
    }
    /**
     * Sets the width and height and resizes the button.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseWorkingButton setDwh> called.", 1);
      application.trace("<" + this + " BaseWorkingButton setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseWorkingButton setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        resetSizes();
      }
    }
    /**
     * Handles the roll over event of the button.
     * @param e the mouse event
     */
    protected function rollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseWorkingButton rollOver> called.", 1);
      application.trace("<" + this + " BaseWorkingButton rollOver> e: " + e, 0);
      if (getEnabled())
      {
        baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED());
        contentSprite.setCxy(0, 0);
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Dispatches the click and custom events of the button.
     */
    protected function baseWorkingButtonClick():void
    {
      application.trace("<" + this + " BaseWorkingButton baseWorkingButtonClick> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventClick);
      }
      if (application != null)
      {
        if (customEvent != null)
        {
          application.getBaseEventDispatcher().dispatchEvent(customEvent);
        }
      }
    }
    /**
     * Handles the roll out event of the button.
     * @param e the mouse event
     */
    private function rollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseWorkingButton rollOut> called.", 1);
      application.trace("<" + this + " BaseWorkingButton rollOut> e: " + e, 0);
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
      contentSprite.setCxy(0, 0);
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Handles the mouse down event of the button.
     * @param e the mouse event
     */
    private function mouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseWorkingButton mouseDown> called.", 1);
      application.trace("<" + this + " BaseWorkingButton mouseDown> e: " + e, 0);
      if (getEnabled())
      {
        baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED());
        contentSprite.setCxy(1, 1);
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Handles the click event of the button.
     * @param e the mouse event
     */
    private function click(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseWorkingButton click> called.", 1);
      application.trace("<" + this + " BaseWorkingButton click> e: " + e, 0);
      if (getEnabled())
      {
        if (baseButton.getState() == EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED())
        {
          baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
          contentSprite.setCxy(0, 0);
          try
          {
            baseWorkingButtonClick();
          }
          catch (exception:*)
          {
            application.trace("<" + this + " BaseWorkingButton click> exception: " + exception, 7);
          }
        }
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Redraws the hit area of this button after the radius of the application has changed.
     * @param e the radius changed event
     */
    private function radiusChanged(e:Event):void
    {
      application.trace("<" + this + " BaseWorkingButton radiusChanged> called.", 1);
      application.trace("<" + this + " BaseWorkingButton radiusChanged> e: " + e, 0);
      resetSizes();
    }
    /**
     * Resets the sizes of the inner sprites of the button.
     */
    private function resetSizes():void
    {
      application.trace("<" + this + " BaseWorkingButton resetSizes> called.", 1);
      baseButton.setDwh(getDw(), getDh());
      baseButton.drawRect();
      contentSprite.setDwh(getDw(), getDh());
      foregroundSprite.setDwh(getDw(), getDh());
      foregroundSprite.graphics.clear();
      foregroundSprite.graphics.lineStyle(0, 0, 0);
      foregroundSprite.graphics.beginFill(0, 0);
      foregroundSprite.graphics.drawRoundRect(0, 0, getDw(), getDh(), application.getDynamicsConfig().getAppRadius(), application.getDynamicsConfig().getAppRadius());
      foregroundSprite.graphics.endFill();
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseWorkingButton destroy> called.", 1);
      application.trace("<" + this + " BaseWorkingButton destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      foregroundSprite.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
      foregroundSprite.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
      foregroundSprite.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
      foregroundSprite.removeEventListener(MouseEvent.CLICK, click);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.trace("<" + this + " BaseWorkingButton destroy> remove every child object if there are any (necessary only in BaseWorkingButton).", 0);
      application.trace("<" + this + " BaseWorkingButton destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventClick.stopImmediatePropagation();
      if (customEvent != null)
      {
        customEvent.stopImmediatePropagation();
      }
      application.trace("<" + this + " BaseWorkingButton destroy> calling the super destroy (necessary only not in BaseWorkingButton) and clearing everything.", 0);
      super.destroy();
      foregroundSprite = null;
      contentSprite = null;
      baseButton = null;
      eventClick = null;
      customEvent = null;
    }
  }
}
