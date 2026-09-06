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
 * BasePanel.
 * A framed panel that is used as a background and a content holder, for example
 * by the settings and by the menu panel of the application.
 *
 * MAIN FEATURES:
 * - a base shape as the background of the panel and a content above it
 * - the content is a multiple one, so paged content is available by default
 * - closed by default, and a click outside of its area closes it again
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class BasePanel extends BaseSprite
  {
    // the content of this panel, the extenders of this class fill it up
    protected var contentMultiple:ContentMultiple = null;
    // the event dispatched when this panel is closed
    private var eventClosed:Event = null;
    // the background of this panel
    private var baseShape:BaseShape = null;
    /**
     * Constructs the panel with its background shape and its multiple content.
     * @param applicationRef the main application reference
     */
    public function BasePanel(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BasePanel> called.", 1);
      application.trace("<" + this + " BasePanel> applicationRef: " + applicationRef, 0);
      eventClosed = new Event(EnumEvents.EVENT_CLOSED());
      baseShape = new BaseShape(application);
      addChild(baseShape);
      baseShape.setIsBright(true);
      baseShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      contentMultiple = new ContentMultiple(application);
      addChild(contentMultiple);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), stuffsChanged);
      // a panel is closed until the one using the application opens it
      visible = false;
      application.trace("<" + this + " BasePanel> constructed.", 1);
    }
    /**
     * Fills the content of this panel up with the default single content.
     */
    public function setDefaultContent():void
    {
      application.trace("<" + this + " BasePanel setDefaultContent> called.", 1);
      if (contentMultiple != null)
      {
        contentMultiple.setDefaultContent();
      }
    }
    /**
     * Opens this panel and starts to watch for the click that closes it again.
     */
    public function open():void
    {
      application.trace("<" + this + " BasePanel open> called.", 1);
      visible = true;
      addCloseByMouseListener();
    }
    /**
     * Closes this panel, stops watching for the click and notifies everybody about the closing.
     */
    public function close():void
    {
      application.trace("<" + this + " BasePanel close> called.", 1);
      visible = false;
      removeCloseByMouseListener();
      getBaseEventDispatcher().dispatchEvent(eventClosed);
    }
    /**
     * Enables or disables this panel and the content of it as well. The setEnabled of a
     * BaseSprite does not reach the children of it, so the content has to be told: the
     * button bar switching between the pages of it is a clickable object.
     * @param e whether this panel has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " BasePanel setEnabled> called.", 1);
      application.trace("<" + this + " BasePanel setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (contentMultiple != null)
      {
        contentMultiple.setEnabled(getEnabled());
      }
    }
    /**
     * Sets the width of this panel and redraws everything it holds.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BasePanel setDw> called.", 1);
      application.trace("<" + this + " BasePanel setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        stuffsResize();
      }
    }
    /**
     * Sets the height of this panel and redraws everything it holds.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BasePanel setDh> called.", 1);
      application.trace("<" + this + " BasePanel setDh> newdh: " + newdh, 0);
      if (getDh() != newdh)
      {
        super.setDh(newdh);
        stuffsResize();
      }
    }
    /**
     * Sets both dimensions of this panel and redraws everything it holds.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BasePanel setDwh> called.", 1);
      application.trace("<" + this + " BasePanel setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BasePanel setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        stuffsResize();
      }
    }
    /**
     * Handles the added to stage event. An already opened panel gets its closing
     * listener here: the open may have happened before this object reached the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BasePanel addedToStage> called.", 1);
      application.trace("<" + this + " BasePanel addedToStage> e: " + e, 0);
      super.addedToStage(e);
      stuffsResize();
      if (visible)
      {
        addCloseByMouseListener();
      }
    }
    /**
     * Handles the removed from stage event by dropping the closing listener of this panel.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BasePanel removedFromStage> called.", 1);
      application.trace("<" + this + " BasePanel removedFromStage> e: " + e, 0);
      removeCloseByMouseListener();
      super.removedFromStage(e);
    }
    /**
     * Decides whether this panel has to be closed by the click that has just happened.
     * @param e the mouse down event of the stage
     */
    protected function hasToCloseByMouse(e:MouseEvent):void
    {
      application.trace("<" + this + " BasePanel hasToCloseByMouse> called.", 1);
      application.trace("<" + this + " BasePanel hasToCloseByMouse> e: " + e, 0);
      if (!mouseIsOnTheContent())
      {
        close();
      }
    }
    /**
     * Tells whether the mouse pointer is above the area of this panel right now.
     */
    protected function mouseIsOnTheContent():Boolean
    {
      application.trace("<" + this + " BasePanel mouseIsOnTheContent> called.", 1);
      const isOnTheContent:Boolean = mouseX >= 0 && mouseX <= getDw() && mouseY >= 0 && mouseY <= getDh();
      application.trace("<" + this + " BasePanel mouseIsOnTheContent> isOnTheContent: " + isOnTheContent, 0);
      return isOnTheContent;
    }
    /**
     * Starts to watch the stage for the click that closes this panel.
     */
    private function addCloseByMouseListener():void
    {
      application.trace("<" + this + " BasePanel addCloseByMouseListener> called.", 1);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, hasToCloseByMouse, false, 0, true);
      }
    }
    /**
     * Stops watching the stage for the click that closes this panel.
     */
    private function removeCloseByMouseListener():void
    {
      application.trace("<" + this + " BasePanel removeCloseByMouseListener> called.", 1);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToCloseByMouse);
      }
    }
    /**
     * One of the displayed properties of the application has been changed, so the
     * background of this panel and the position of its content have to follow it.
     * @param e the event of the property that has been changed
     */
    private function stuffsChanged(e:Event):void
    {
      application.trace("<" + this + " BasePanel stuffsChanged> called.", 1);
      application.trace("<" + this + " BasePanel stuffsChanged> e: " + e, 0);
      stuffsResize();
    }
    /**
     * Redraws the background shape of this panel and resizes its content into it.
     */
    private function stuffsResize():void
    {
      application.trace("<" + this + " BasePanel stuffsResize> called.", 1);
      if (application == null)
      {
        return;
      }
      const colorAlpha:Number = application.getDynamicsConfig().getAppBackgroundColorAlpha();
      // the background of a panel is a bit more opaque than the one of the application:
      // the elements standing on it have to be readable above whatever is behind it
      baseShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , colorAlpha + (1 - colorAlpha) * 3 / 4
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      baseShape.setRadius(application.getDynamicsConfig().getAppRadius());
      baseShape.setDwh(getDw(), getDh());
      baseShape.drawRect();
      const inset:int = application.getDynamicsConfig().getAppMargin() + application.getDynamicsConfig().getAppLineThickness();
      contentMultiple.setCxy(inset, inset);
      contentMultiple.setDwh(getDw() - 2 * inset, getDh() - 2 * inset);
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BasePanel destroy> called.", 1);
      application.trace("<" + this + " BasePanel destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      removeCloseByMouseListener();
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), stuffsChanged);
      application.trace("<" + this + " BasePanel destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventClosed.stopImmediatePropagation();
      application.trace("<" + this + " BasePanel destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " BasePanel destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      eventClosed = null;
      baseShape = null;
      contentMultiple = null;
    }
  }
}
