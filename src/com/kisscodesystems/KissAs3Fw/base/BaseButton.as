package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.events.Event;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseButtonStates;
  public class BaseButton extends BaseShape
  {
    private var state:int = -1;
    /**
     * Constructs this base button and registers for the application property change events.
     * @param applicationRef the application reference this button belongs to
     */
    public function BaseButton(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseButton> called.", 1);
      application.trace("<" + this + " BaseButton> applicationRef: " + applicationRef, 0);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundDarkColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundMidColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundBrightColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), fillAlphaChanged);
      reset();
      application.trace("<" + this + " BaseButton> constructed.", 1);
    }
    /**
     * Sets the state of this button and repaints it if the state has changed.
     * @param state the new state (0 default, 1 highlighted, 2 pushed)
     */
    public function setState(state:int):void
    {
      application.trace("<" + this + " BaseButton setState> called.", 1);
      application.trace("<" + this + " BaseButton setState> state: " + state, 0);
      if (this.state == state)
      {
        application.trace("<" + this + " BaseButton setState> same state.", 6);
        return;
      }
      if (!(state == EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT()
         || state == EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED()
         || state == EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED()))
      {
        application.trace("<" + this + " BaseButton setState> valid states: 0, 1, 2.", 6);
        return;
      }
      this.state = state;
      repaint();
    }
    /**
     * Returns the current state of this button.
     */
    public function getState():int
    {
      return state;
    }
    /**
     * Resets the colors, alpha and radius of this button from the dynamics config and repaints it.
     */
    private function reset():void
    {
      application.trace("<" + this + " BaseButton reset> called.", 1);
      setColorsAndAlpha(
        application.getDynamicsConfig().getAppBackgroundColorDark(),
        application.getDynamicsConfig().getAppBackgroundColorDark(),
        application.getDynamicsConfig().getAppBackgroundColorMid(),
        application.getDynamicsConfig().getAppBackgroundColorAlpha(),
        application.getDynamicsConfig().getAppBackgroundColorBright()
      );
      setRadius(application.getDynamicsConfig().getAppRadius());
      repaint();
    }
    /**
     * Repaints this button according to its current state.
     */
    private function repaint():void
    {
      application.trace("<" + this + " BaseButton repaint> called.", 1);
      if (state == EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT())
      {
        setIsBright(false);
        setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
        drawRect();
        application.trace("<" + this + " BaseButton repaint> with state " + state, 0);
      }
      else if (state == EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED())
      {
        setIsBright(true);
        setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
        drawRect();
        application.trace("<" + this + " BaseButton repaint> with state " + state, 0);
      }
      else if (state == EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED())
      {
        setIsBright(false);
        setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
        drawRect();
        application.trace("<" + this + " BaseButton repaint> with state " + state, 0);
      }
    }
    /**
     * Handles the radius changed event by resetting this button.
     * @param e the dispatched event
     */
    private function radiusChanged(e:Event):void
    {
      application.trace("<" + this + " BaseButton radiusChanged> called.", 1);
      application.trace("<" + this + " BaseButton radiusChanged> e: " + e, 0);
      reset();
    }
    /**
     * Handles the background dark color changed event by resetting this button.
     * @param e the dispatched event
     */
    private function backgroundDarkColorChanged(e:Event):void
    {
      application.trace("<" + this + " BaseButton backgroundDarkColorChanged> called.", 1);
      application.trace("<" + this + " BaseButton backgroundDarkColorChanged> e: " + e, 0);
      reset();
    }
    /**
     * Handles the background mid color changed event by resetting this button.
     * @param e the dispatched event
     */
    private function backgroundMidColorChanged(e:Event):void
    {
      application.trace("<" + this + " BaseButton backgroundMidColorChanged> called.", 1);
      application.trace("<" + this + " BaseButton backgroundMidColorChanged> e: " + e, 0);
      reset();
    }
    /**
     * Handles the background bright color changed event by resetting this button.
     * @param e the dispatched event
     */
    private function backgroundBrightColorChanged(e:Event):void
    {
      application.trace("<" + this + " BaseButton backgroundBrightColorChanged> called.", 1);
      application.trace("<" + this + " BaseButton backgroundBrightColorChanged> e: " + e, 0);
      reset();
    }
    /**
     * Handles the background color alpha changed event by resetting this button.
     * @param e the dispatched event
     */
    private function fillAlphaChanged(e:Event):void
    {
      application.trace("<" + this + " BaseButton fillAlphaChanged> called.", 1);
      application.trace("<" + this + " BaseButton fillAlphaChanged> e: " + e, 0);
      reset();
    }
    /**
     * Destroys this button, unregistering its event listeners and freeing everything up.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseButton destroy> called.", 1);
      application.trace("<" + this + " BaseButton destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundDarkColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundMidColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundBrightColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), fillAlphaChanged);
      application.trace("<" + this + " BaseButton destroy> remove every child object if there are any (necessary only in BaseButton).", 0);
      application.trace("<" + this + " BaseButton destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " BaseButton destroy> calling the super destroy (necessary only not in BaseButton) and clearing everything.", 0);
      super.destroy();
      state = 0;
    }
  }
}
