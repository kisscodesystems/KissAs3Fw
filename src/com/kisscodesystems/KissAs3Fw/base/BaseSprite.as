package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.system.System;
  public class BaseSprite extends Sprite
  {
    protected var application:Application = null;
    private var cx:int = 0;
    private var cy:int = 0;
    private var dw:int = 0;
    private var dh:int = 0;
    private var prevdw:int = 0;
    private var prevdh:int = 0;
    private var value:Object = null;
    private var enabled:Boolean = true;
    private var soundTypeMouseDown:String = "";
    private var baseEventDispatcher:BaseEventDispatcher = null;
    private var eventCoordinatesChanged:Event = null;
    private var eventDimensionsChanged:Event = null;
    private var mouseDownForScrollingStartx:int = 0;
    private var mouseDownForScrollingStarty:int = 0;
    public var mouseDownForScrollingEnabled:Boolean = true;
    /**
     * Constructs the BaseSprite object and initializes its base state.
     * @param applicationRef the main application reference
     */
    public function BaseSprite(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " BaseSprite> called.", 1);
      application.trace("<" + this + " BaseSprite> applicationRef: " + applicationRef, 0);
      allReset();
      eventCoordinatesChanged = new Event(EnumEvents.EVENT_COORDINATES_CHANGED());
      eventDimensionsChanged = new Event(EnumEvents.EVENT_DIMENSIONS_CHANGED());
      addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
      baseEventDispatcher = new BaseEventDispatcher();
      application.trace("<" + this + " BaseSprite> constructed.", 1);
    }
    /**
     * Returns the base event dispatcher of this object.
     */
    public function getBaseEventDispatcher():BaseEventDispatcher
    {
      return baseEventDispatcher;
    }
    /**
     * Sets the x coordinate of this object.
     * @param newcx the new x coordinate
     */
    public function setCx(newcx:int):void
    {
      application.trace("<" + this + " BaseSprite setCx> called.", 1);
      application.trace("<" + this + " BaseSprite setCx> newcx: " + newcx, 0);
      if (cx != newcx)
      {
        application.trace("<" + this + " BaseSprite setCx> conditions OK.", 1);
        cx = newcx;
        x = cx;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the y coordinate of this object.
     * @param newcy the new y coordinate
     */
    public function setCy(newcy:int):void
    {
      application.trace("<" + this + " BaseSprite setCy> called.", 1);
      application.trace("<" + this + " BaseSprite setCy> newcy: " + newcy, 0);
      if (cy != newcy)
      {
        application.trace("<" + this + " BaseSprite setCy> conditions OK.", 1);
        cy = newcy;
        y = cy;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the x and y coordinates of this object.
     * @param newcx the new x coordinate
     * @param newcy the new y coordinate
     */
    public function setCxy(newcx:int, newcy:int):void
    {
      application.trace("<" + this + " BaseSprite setCxy> called.", 1);
      application.trace("<" + this + " BaseSprite setCxy> newcx: " + newcx, 0);
      application.trace("<" + this + " BaseSprite setCxy> newcy: " + newcy, 0);
      if (cx != newcx || cy != newcy)
      {
        application.trace("<" + this + " BaseSprite setCxy> conditions OK.", 1);
        cx = newcx;
        cy = newcy;
        x = cx;
        y = cy;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the width dimension of this object.
     * @param newdw the new width dimension
     */
    public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseSprite setDw> called.", 1);
      application.trace("<" + this + " BaseSprite setDw> newdw: " + newdw, 0);
      const w:int = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
      if (dw != w)
      {
        application.trace("<" + this + " BaseSprite setDw> conditions OK.", 1);
        dw = w;
        prevdw = dw;
        // calcFactorStageWidth ( ) ;
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
    }
    /**
     * Sets the height dimension of this object.
     * @param newdh the new height dimension
     */
    public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseSprite setDh> called.", 1);
      application.trace("<" + this + " BaseSprite setDh> newdh: " + newdh, 0);
      const h:int = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
      if (dh != h)
      {
        application.trace("<" + this + " BaseSprite setDh> conditions OK.", 1);
        dh = h;
        prevdh = dh;
        // calcFactorStageHeight ( ) ;
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
    }
    /**
     * Sets the width and height dimensions of this object.
     * @param newdw the new width dimension
     * @param newdh the new height dimension
     */
    public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseSprite setDwh> called.", 1);
      application.trace("<" + this + " BaseSprite setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseSprite setDwh> newdh: " + newdh, 0);
      const w:int = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
      const h:int = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
      if (dw != w || dh != h)
      {
        application.trace("<" + this + " BaseSprite setDwh> conditions OK, dispatching dimensions changed event.", 1);
        dw = w;
        dh = h;
        prevdw = dw;
        prevdh = dh;
        // calcFactorStageWidth ( ) ;
        // calcFactorStageHeight ( ) ;
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
      else
      {
        application.trace("<" + this + " BaseSprite setDwh> NOT dispatching dimensions changed event.", 1);
      }
    }
    /**
     * Updates the stored coordinates from the current x and y values.
     */
    public function updateCxy():void
    {
      application.trace("<" + this + " BaseSprite updateCxy> called.", 1);
      cx = int(x);
      cy = int(y);
      x = cx;
      y = cy;
    }
    /**
     * Returns the x coordinate, optionally extended by width, margin and padding.
     * @param wNeeded whether the width should be added
     * @param mNeeded whether the margin should be added
     * @param pNeeded whether the padding should be added
     */
    public function getCx(wNeeded:Boolean = false, mNeeded:Boolean = false, pNeeded:Boolean = false):int
    {
      application.trace("<" + this + " BaseSprite getCx> called.", 1);
      application.trace("<" + this + " BaseSprite getCx> wNeeded: " + wNeeded, 0);
      application.trace("<" + this + " BaseSprite getCx> mNeeded: " + mNeeded, 0);
      application.trace("<" + this + " BaseSprite getCx> pNeeded: " + pNeeded, 0);
      var val:int = cx;
      if (wNeeded)
      {
        val += dw;
      }
      if (mNeeded)
      {
        val += application.getDynamicsConfig().getAppMargin();
      }
      if (pNeeded)
      {
        val += application.getDynamicsConfig().getAppPadding();
      }
      application.trace("<" + this + " BaseSprite getCx> cx (" + wNeeded + " " + mNeeded + " " + pNeeded + "): " + val, 0);
      return val;
    }
    /**
     * Returns the y coordinate, optionally extended by height, margin and padding.
     * @param hNeeded whether the height should be added
     * @param mNeeded whether the margin should be added
     * @param pNeeded whether the padding should be added
     */
    public function getCy(hNeeded:Boolean = false, mNeeded:Boolean = false, pNeeded:Boolean = false):int
    {
      application.trace("<" + this + " BaseSprite getCy> called.", 1);
      application.trace("<" + this + " BaseSprite getCy> hNeeded: " + hNeeded, 0);
      application.trace("<" + this + " BaseSprite getCy> mNeeded: " + mNeeded, 0);
      application.trace("<" + this + " BaseSprite getCy> pNeeded: " + pNeeded, 0);
      var val:int = cy;
      if (hNeeded)
      {
        val += dh;
      }
      if (mNeeded)
      {
        val += application.getDynamicsConfig().getAppMargin();
      }
      if (pNeeded)
      {
        val += application.getDynamicsConfig().getAppPadding();
      }
      application.trace("<" + this + " BaseSprite getCy> cy (" + hNeeded + " " + mNeeded + " " + pNeeded + "): " + val, 0);
      return val;
    }
    /**
     * Returns the width dimension of this object.
     */
    public function getDw():int
    {
      return dw;
    }
    /**
     * Returns the height dimension of this object.
     */
    public function getDh():int
    {
      return dh;
    }
    /**
     * Sets the value object stored on this object.
     * @param v the new value object
     */
    public function setValue(v:Object):void
    {
      application.trace("<" + this + " BaseSprite setValue> called.", 1);
      application.trace("<" + this + " BaseSprite setValue> v: " + v, 0);
      value = v;
    }
    /**
     * Returns the value object stored on this object.
     */
    public function getValue():Object
    {
      return value;
    }
    /**
     * Enables or disables this object and updates its appearance.
     * @param e whether this object should be enabled
     */
    public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " BaseSprite setEnabled> called.", 1);
      application.trace("<" + this + " BaseSprite setEnabled> e: " + e, 0);
      if (enabled)
      {
        if (!e)
        {
          application.trace("<" + this + " BaseSprite setEnabled> set enabled to false.", 0);
          enabled = false;
          mouseEnabled = false;
          tabChildren = false;
          alpha = application.getComponentsConfig().getDisabledAlpha();
        }
      }
      else
      {
        if (e)
        {
          application.trace("<" + this + " BaseSprite setEnabled> set enabled to true.", 0);
          enabled = true;
          mouseEnabled = true;
          tabChildren = true;
          alpha = 1;
        }
      }
    }
    /**
     * Returns whether this object is enabled.
     */
    public function getEnabled():Boolean
    {
      return enabled;
    }
    /**
     * Moves this object to the highest depth within its parent.
     */
    public function toTheHighestDepth():void
    {
      application.trace("<" + this + " BaseSprite toTheHighestDepth> called.", 1);
      if (parent != null)
      {
        parent.setChildIndex(this, parent.numChildren - 1);
      }
    }
    /**
     * Moves this object to the lowest depth within its parent.
     */
    public function toTheLowestDepth():void
    {
      application.trace("<" + this + " BaseSprite toTheLowestDepth> called.", 1);
      if (parent != null)
      {
        parent.setChildIndex(this, 0);
      }
    }
    /**
     * Sets the visibility of this sprite and updates its dimensions.
     * @param v whether this sprite should be visible
     */
    public function setSpriteVisible(v:Boolean):void
    {
      application.trace("<" + this + " BaseSprite setSpriteVisible> called.", 1);
      application.trace("<" + this + " BaseSprite setSpriteVisible> v: " + v, 0);
      if (v)
      {
        if (!visible)
        {
          application.trace("<" + this + " BaseSprite setSpriteVisible> set sprite visible to true." + v, 0);
          visible = true;
          dw = prevdw;
          dh = prevdh;
          // calcFactorStageWidth ( ) ;
          doDimensionsChanged();
          dispatchEventDimensionsChanged();
        }
      }
      else
      {
        if (visible)
        {
          application.trace("<" + this + " BaseSprite setSpriteVisible> set sprite visible to false." + v, 0);
          visible = false;
          dw = 0;
          dh = 0;
          // calcFactorStageWidth ( ) ;
          doDimensionsChanged();
          dispatchEventDimensionsChanged();
        }
      }
    }
    /**
     * Sets the parent object of the base event dispatcher to this object.
     */
    public function setEventDispatcherObjectToThis():void
    {
      application.trace("<" + this + " BaseSprite setEventDispatcherObjectToThis> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().setParentObject(this);
      }
    }
    /**
     * Scrolls the containing content so that this object becomes visible.
     */
    public function toBeVisible():void
    {
      application.trace("<" + this + " BaseSprite toBeVisible> called.", 1);
      if (parent != null)
      {
        /*
        if ( parent . parent is ContentSingle )
        {
          var baseScroll : BaseScroll = ContentSingle ( parent . parent ) . getBaseScroll ( ) ;
          if ( baseScroll != null )
          {
            if ( - getcy ( ) > baseScroll . getccy ( ) )
            {
              baseScroll . setccy ( application . getPropsApp ( ) . getScrollMargin ( ) - getcy ( ) ) ;
            }
            if ( - getcx ( ) > baseScroll . getccx ( ) )
            {
              baseScroll . setccx ( - getcx ( ) ) ;
            }
            if ( - ( getcy ( ) + getdh ( ) ) < baseScroll . getccy ( ) - baseScroll . getMask ( ) . getdh ( ) )
            {
              baseScroll . setccy ( - ( getcy ( ) + getdh ( ) ) + baseScroll . getMask ( ) . getdh ( ) ) ;
            }
            if ( - ( getcx ( ) + getdw ( ) ) < baseScroll . getccx ( ) - baseScroll . getMask ( ) . getdw ( ) )
            {
              baseScroll . setccx ( - ( getcx ( ) + getdw ( ) ) + baseScroll . getMask ( ) . getdw ( ) ) ;
            }
          }
        }
        */
      }
    }
    /**
     * Sets the sound type played on mouse down and manages the listener.
     * @param s the sound type to play, or empty to remove it
     */
    public function setSoundTypeClick(s:String):void
    {
      application.trace("<" + this + " BaseSprite setSoundTypeClick> called.", 1);
      application.trace("<" + this + " BaseSprite setSoundTypeClick> s: " + s, 0);
      if (s == null || s == "")
      {
        soundTypeMouseDown = "";
        removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownForSoundType);
        application.trace("<" + this + " BaseSprite setSoundTypeClick> removed.", 1);
      }
      else
      {
        soundTypeMouseDown = s;
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownForSoundType, false, 0, true);
        application.trace("<" + this + " BaseSprite setSoundTypeClick> added.", 1);
      }
    }
    /**
     * Handles the added to stage event and recalculates content dimensions.
     * @param e the added to stage event
     */
    protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BaseSprite addedToStage> called.", 1);
      application.trace("<" + this + " BaseSprite addedToStage> e: " + e, 0);
      application.callContentDimensionsRecalculation(this);
      addEventListener(MouseEvent.MOUSE_DOWN, mouseDownForScrolling, false, 0, true);
    }
    /**
     * Handles the removed from stage event and recalculates content dimensions.
     * @param e the removed from stage event
     */
    protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseSprite removedFromStage> called.", 1);
      application.trace("<" + this + " BaseSprite removedFromStage> e: " + e, 0);
      application.callContentDimensionsRecalculation(this);
      removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownForScrolling);
      // stage . removeEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpForScrolling);
      }
    }
    /**
     * Recalculates the content dimensions after a dimension change.
     */
    protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " BaseSprite doDimensionsChanged> called.", 1);
      application.callContentDimensionsRecalculation(this);
    }
    /**
     * Recalculates the content dimensions after a coordinate change.
     */
    protected function doCoordinatesChanged():void
    {
      application.trace("<" + this + " BaseSprite doCoordinatesChanged> called.", 1);
      application.callContentDimensionsRecalculation(this);
    }
    /**
     * Dispatches the dimensions changed event on the base event dispatcher.
     */
    protected function dispatchEventDimensionsChanged():void
    {
      application.trace("<" + this + " BaseSprite dispatchEventDimensionsChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventDimensionsChanged);
      }
    }
    /**
     * Dispatches the coordinates changed event on the base event dispatcher.
     */
    protected function dispatchEventCoordinatesChanged():void
    {
      application.trace("<" + this + " BaseSprite dispatchEventCoordinatesChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventCoordinatesChanged);
      }
    }
    /**
     * Forces the system garbage collector to run several times.
     */
    private function systemGc():void
    {
      application.trace("<" + this + " BaseSprite systemGc> called.", 1);
      for (var i:int = 0; i < 10; i++)
      {
        System.gc();
      }
    }
    /**
     * Resets the coordinates and dimensions to their initial values.
     */
    private function allReset():void
    {
      application.trace("<" + this + " BaseSprite allReset> called.", 1);
      cx = 0;
      cy = 0;
      dw = 0;
      dh = 0;
      x = cx;
      y = cy;
      prevdw = cx;
      prevdh = cy;
    }
    /**
     * Plays the configured sound type when the mouse is pressed down.
     * @param e the mouse down event
     */
    private function mouseDownForSoundType(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseSprite mouseDownForSoundType> called.", 1);
      application.trace("<" + this + " BaseSprite mouseDownForSoundType> e: " + e, 0);
      application.trace("<" + this + " BaseSprite mouseDownForSoundType> current value of soundTypeMouseDown: " + soundTypeMouseDown, 0);
      if (application != null && application.getSoundManager() != null && getEnabled())
      {
        application.trace("<" + this + " BaseSprite mouseDownForSoundType> conditions OK.", 1);
        application.getSoundManager().playSound(soundTypeMouseDown);
      }
    }
    /**
     * Tells whether the object that has really been pressed hands its presses over to the
     * scrolling of the content it stands in.
     * A press bubbles up from the object it happened on through every parent of it, and
     * every one of those parents hears it here. So an object that keeps its own presses,
     * like the mover of a widget, the mover of a potmeter or a text input, has to keep
     * them from its parents as well: a parent that started the scrolling of the content
     * would take the dragging of that object away, because only one single object can be
     * dragged by the mouse at a time.
     * @param e the mouse down event the pressed object is taken from
     */
    private function pressedObjectHandsItsPressesOver(e:MouseEvent):Boolean
    {
      application.trace("<" + this + " BaseSprite pressedObjectHandsItsPressesOver> called.", 1);
      application.trace("<" + this + " BaseSprite pressedObjectHandsItsPressesOver> e: " + e, 0);
      var handsOver:Boolean = true;
      if (e != null && e.target is BaseSprite)
      {
        handsOver = BaseSprite(e.target).mouseDownForScrollingEnabled;
      }
      else if (e != null && e.target is BaseTextField)
      {
        handsOver = BaseTextField(e.target).mouseDownForScrollingEnabled;
      }
      application.trace("<" + this + " BaseSprite pressedObjectHandsItsPressesOver> handsOver: " + handsOver, 0);
      return handsOver;
    }
    /**
     * Starts to follow the mouse when this object hands its presses over to the
     * scrolling of the content it stands in.
     * @param e the mouse down event of this object
     */
    private function mouseDownForScrolling(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseSprite mouseDownForScrolling> called.", 1);
      application.trace("<" + this + " BaseSprite mouseDownForScrolling> e: " + e, 0);
      application.trace("<" + this + " BaseSprite mouseDownForScrolling> e != null: " + (e != null), 0);
      application.trace("<" + this + " BaseSprite mouseDownForScrolling> mouseDownForScrollingEnabled: " + mouseDownForScrollingEnabled, 0);
      application.trace("<" + this + " BaseSprite mouseDownForScrolling> stage != null: " + (stage != null), 0);
      if (mouseDownForScrollingEnabled && stage != null && pressedObjectHandsItsPressesOver(e))
      {
        application.trace("<" + this + " BaseSprite mouseDownForScrolling> conditions OK.", 1);
        mouseDownForScrollingStartx = stage.mouseX;
        mouseDownForScrollingStarty = stage.mouseY;
        addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveForScrolling, false, 0, true);
        if (stage != null)
        {
          stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpForScrolling, false, 0, true);
        }
      }
    }
    /**
     * Stops following the mouse as soon as the button of it has been released.
     * @param e the mouse up event of the stage
     */
    private function mouseUpForScrolling(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseSprite mouseUpForScrolling> called.", 1);
      application.trace("<" + this + " BaseSprite mouseUpForScrolling> e: " + e, 0);
      removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveForScrolling);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpForScrolling);
      }
    }
    /**
     * Hands the dragging over to the first parent content as soon as the mouse has
     * been moved farther than the click gap, so that a drag is not taken as a click.
     * @param e the mouse move event of this object
     */
    private function mouseMoveForScrolling(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> called.", 0);
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> e: " + e, 0);
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> e != null: " + (e != null), 0);
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> stage != null: " + (stage != null), 0);
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> e.buttonDown: " + (e && e.buttonDown), 0);
      application.trace("<" + this + " BaseSprite mouseMoveForScrolling> mouseDownForScrollingEnabled: " + mouseDownForScrollingEnabled, 0);
      if (e != null && stage != null && e.buttonDown && mouseDownForScrollingEnabled)
      {
        application.trace("<" + this + " BaseSprite mouseMoveForScrolling> conditions OK (1).", 1);
        if (Math.abs(mouseDownForScrollingStartx - stage.mouseX) > application.getComponentsConfig().getClickGap()
         || Math.abs(mouseDownForScrollingStarty - stage.mouseY) > application.getComponentsConfig().getClickGap())
        {
          application.trace("<" + this + " BaseSprite mouseMoveForScrolling> conditions OK (2).", 1);
          application.findFirstParentContentSingleAndStartScrolling(this);
          application.findFirstParentButtonAndPerformOnRollOut(this);
          removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveForScrolling);
        }
      }
    }
    /**
     * Destroys this object and frees up every reference and resource.
     */
    public function destroy():void
    {
      application.trace("<" + this + " BaseSprite destroy> called.", 1);
      application.trace("<" + this + " BaseSprite destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
      removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
      removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownForSoundType);
      removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownForScrolling);
      removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveForScrolling);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpForScrolling);
        // stage.removeEventListener(Event.RESIZE, stageResized);
      }
      application.trace("<" + this + " BaseSprite destroy> remove every child object if there are any (necessary only in BaseSprite).", 0);
      var displayObject:DisplayObject = null;
      while (numChildren > 0)
      {
        displayObject = getChildAt(0);
        if (displayObject is BaseSprite)
        {
          BaseSprite(displayObject).destroy();
        }
        else if (displayObject is BaseTextField)
        {
          BaseTextField(displayObject).destroy();
        }
        else if (displayObject is BaseShape)
        {
          BaseShape(displayObject).destroy();
        }
        removeChild(displayObject);
      }
      displayObject = null;
      application.trace("<" + this + " BaseSprite destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventCoordinatesChanged.stopImmediatePropagation();
      eventDimensionsChanged.stopImmediatePropagation();
      baseEventDispatcher.destroy();
      graphics.clear();
      filters = null;
      application.trace("<" + this + " BaseSprite destroy> calling the super destroy (necessary only not in BaseSprite) and clearing everything.", 0);
      systemGc();
      allReset();
      value = null;
      enabled = false;
      baseEventDispatcher = null;
      eventCoordinatesChanged = null;
      eventDimensionsChanged = null;
      soundTypeMouseDown = null;
      mouseDownForScrollingEnabled = false;
      mouseDownForScrollingStartx = 0;
      mouseDownForScrollingStarty = 0;
      /* TODO
      followStageWidth = false;
      followStageHeight = false;
      factorStageWidth = 0;
      factorStageHeight = 0;
      */
      application = null;
    }
  }
}
