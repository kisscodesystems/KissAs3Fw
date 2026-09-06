package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  public class BaseOpen extends BaseSprite
  {
    protected var baseWorkingButton:BaseWorkingButton = null;
    protected var contentSprite:BaseSprite = null;
    private var mobileModeClickCounter:int = 0;
    private var eventOpened:Event = null;
    private var eventClosed:Event = null;
    /**
     * Constructs the openable component: creates the working button and the content sprite, wires the click listener and prepares the opened and closed events.
     * @param applicationRef the application reference passed to the base sprite
     */
    public function BaseOpen(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseOpen> called.", 1);
      application.trace("<" + this + " BaseOpen> applicationRef: " + applicationRef, 0);
      baseWorkingButton = new BaseWorkingButton(application);
      addChild(baseWorkingButton);
      baseWorkingButton.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), baseWorkingButtonClick);
      contentSprite = new BaseSprite(application);
      addChild(contentSprite);
      contentSprite.visible = false;
      baseWorkingButton.visible = true;
      eventOpened = new Event(EnumEvents.EVENT_OPENED());
      eventClosed = new Event(EnumEvents.EVENT_CLOSED());
      application.trace("<" + this + " BaseOpen> constructed.", 1);
    }
    /**
     * Opens the component: shows the content, hides the button, listens for close triggers and dispatches the opened event.
     */
    public function open():void
    {
      application.trace("<" + this + " BaseOpen open> called.", 1);
      contentSprite.visible = true;
      baseWorkingButton.visible = false;
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, hasToCloseByMouse, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, hasToCloseByKeyboard, false, 0, true);
      }
      toBeVisible();
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventOpened);
      }
    }
    /**
     * Closes the component: removes the close trigger listeners, hides the content, shows the button and dispatches the closed event.
     */
    public function close():void
    {
      application.trace("<" + this + " BaseOpen close> called.", 1);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToCloseByMouse);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, hasToCloseByKeyboard);
      }
      contentSprite.visible = false;
      baseWorkingButton.visible = true;
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventClosed);
      }
    }
    /**
     * Returns whether the content is currently visible (opened).
     */
    public function isOpened():Boolean
    {
      application.trace("<" + this + " BaseOpen isOpened> called.", 1);
      const b:Boolean = contentSprite.visible;
      application.trace("<" + this + " BaseOpen isOpened> isOpened: " + b, 0);
      return b;
    }
    /**
     * Enables or disables the component and its working button.
     * @param b true to enable, false to disable
     */
    override public function setEnabled(b:Boolean):void
    {
      application.trace("<" + this + " BaseOpen setEnabled> called.", 1);
      application.trace("<" + this + " BaseOpen setEnabled> b: " + b, 0);
      super.setEnabled(b);
      baseWorkingButton.setEnabled(b);
    }
    /**
     * Sets the display width and forwards it to the working button.
     * @param newdw the new display width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseOpen setDw> called.", 1);
      application.trace("<" + this + " BaseOpen setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        baseWorkingButton.setDw(getDw());
      }
    }
    /**
     * Sets the display height and forwards it to the working button.
     * @param newdh the new display height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseOpen setDh> called.", 1);
      application.trace("<" + this + " BaseOpen setDh> newdh: " + newdh, 0);
      if (getDh() != newdh)
      {
        super.setDh(newdh);
        baseWorkingButton.setDh(getDh());
      }
    }
    /**
     * Sets the display width and height together and forwards them to the working button.
     * @param newdw the new display width
     * @param newdh the new display height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseOpen setDwh> called.", 1);
      application.trace("<" + this + " BaseOpen setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseOpen setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        baseWorkingButton.setDwh(getDw(), getDh());
      }
    }
    /**
     * Handles a click on the working button by opening the component.
     * @param e the click event
     */
    protected function baseWorkingButtonClick(e:Event):void
    {
      application.trace("<" + this + " BaseOpen baseWorkingButtonClick> called.", 1);
      application.trace("<" + this + " BaseOpen baseWorkingButtonClick> e: " + e, 0);
      open();
    }
    /**
     * Decides on a stage mouse down whether the component has to close, honouring desktop and mobile double tap behaviour.
     * @param e the mouse event
     */
    protected function hasToCloseByMouse(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseOpen hasToCloseByMouse> called.", 1);
      application.trace("<" + this + " BaseOpen hasToCloseByMouse> e: " + e, 0);
      if (!mouseIsOnTheContentSprite())
      {
        if (application.getDynamicsConfig().weAreInDesktopMode())
        {
          mobileModeClickCounter = 0;
          close();
        }
        else
        {
          if (mobileModeClickCounter == 0)
          {
            mobileModeClickCounter = 1;
          }
          else
          {
            mobileModeClickCounter = 0;
            close();
          }
        }
      }
      else
      {
        mobileModeClickCounter = 0;
      }
    }
    /**
     * Returns whether the mouse pointer is currently over the content sprite.
     */
    protected function mouseIsOnTheContentSprite():Boolean
    {
      application.trace("<" + this + " BaseOpen mouseIsOnTheContentSprite> called.", 1);
      if (contentSprite != null)
      {
        return (mouseX >= contentSprite.getCx() && mouseX <= contentSprite.getCx(true) && mouseY >= contentSprite.getCy() && mouseY <= contentSprite.getCy(true));
      }
      else
      {
        return true;
      }
    }
    /**
     * Closes the component when the tab or escape key is pressed.
     * @param e the keyboard event
     */
    private function hasToCloseByKeyboard(e:KeyboardEvent):void
    {
      application.trace("<" + this + " BaseOpen hasToCloseByKeyboard> called.", 1);
      application.trace("<" + this + " BaseOpen hasToCloseByKeyboard> e: " + e, 0);
      if (e.keyCode == Keyboard.TAB || e.keyCode == Keyboard.ESCAPE)
      {
        close();
      }
    }
    /**
     * Frees up the component: removes the stage listeners, stops the event propagation, calls the super destroy and clears every reference.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseOpen destroy> called.", 1);
      application.trace("<" + this + " BaseOpen destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToCloseByMouse);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, hasToCloseByKeyboard);
      }
      application.trace("<" + this + " BaseOpen destroy> remove every child object if there are any (necessary only in BaseOpen).", 0);
      application.trace("<" + this + " BaseOpen destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventOpened.stopImmediatePropagation();
      eventClosed.stopImmediatePropagation();
      application.trace("<" + this + " BaseOpen destroy> calling the super destroy (necessary only not in BaseOpen) and clearing everything.", 0);
      super.destroy();
      baseWorkingButton = null;
      contentSprite = null;
      mobileModeClickCounter = 0;
      eventOpened = null;
      eventClosed = null;
    }
  }
}
