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
 * BaseResizer.
 * The handle of the bottom right corner of a component the one using the application
 * can resize by hand, in real time.
 *
 * MAIN FEATURES:
 * - the two diagonal lines of the current appearance of the application are drawn onto
 *   it, in the size of one bright text field, so it follows every font, thickness and
 *   color change of that appearance
 * - the owner of it tells it where its own corner stands and what dimensions a drag has
 *   to start from, so a handle can stand at the corner of an object that is smaller than
 *   the dimensions it has been asked for, the way the picture of an Image does
 * - a drag of it moves those dimensions by the very pixels the mouse has covered and
 *   never by the ones the owner has really taken, so an owner that cannot follow the
 *   whole drag does not creep away under the mouse
 * - the changed event tells the owner that there are new dimensions to be taken, both
 *   during the drag and at the end of it, and a press without a single move dispatches
 *   nothing at all
 * - the dimensions never go under the minimal size of the components config: the resizer
 *   of a base scroll keeps that very same minimum, so every resizable component of this
 *   framework has one and the same lowest size
 * - it keeps every press that happens on it: the scrolling of the content it stands in
 *   would take the dragging away, because only one single object can be dragged by the
 *   mouse at a time
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class BaseResizer extends BaseSprite
  {
    // the dimensions the owner of this handle has to take: they are the ones of that
    // owner itself until a drag moves them
    private var dimensionDw:int = 0;
    private var dimensionDh:int = 0;
    // The state of the drag: the dimensions and the position of the mouse it has been
    // started with, and the ones handed over to the owner last. Every new size comes
    // from the two starting values, so the dimensions the owner really takes are never
    // read back here: a press that has not moved the mouse at all hands nothing over.
    private var dragging:Boolean = false;
    private var dragStartDw:int = 0;
    private var dragStartDh:int = 0;
    private var dragStartMouseX:int = 0;
    private var dragStartMouseY:int = 0;
    private var eventChanged:Event = null;
    /**
     * Constructs the BaseResizer object: it takes every press of its own, it draws itself
     * in the current appearance of the application and it starts to follow that appearance.
     * @param applicationRef the main application reference
     */
    public function BaseResizer(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseResizer> called.", 1);
      application.trace("<" + this + " BaseResizer> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      mouseDownForScrollingEnabled = false;
      addEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      resizeAndRepaint();
      application.trace("<" + this + " BaseResizer> constructed.", 1);
    }
    /**
     * Returns the width the owner of this handle has to take.
     */
    public function getDimensionDw():int
    {
      return dimensionDw;
    }
    /**
     * Returns the height the owner of this handle has to take.
     */
    public function getDimensionDh():int
    {
      return dimensionDh;
    }
    /**
     * Takes the dimensions a drag of this handle has to start from: the ones the owner of
     * it has been asked for. A drag that is going on is the one telling those dimensions,
     * so it is never overwritten from the outside: the owner is taking them from here
     * right then.
     * @param newdw the width a drag has to start from
     * @param newdh the height a drag has to start from
     */
    public function setDimensions(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseResizer setDimensions> called.", 1);
      application.trace("<" + this + " BaseResizer setDimensions> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseResizer setDimensions> newdh: " + newdh, 0);
      if (dragging)
      {
        application.trace("<" + this + " BaseResizer setDimensions> the dimensions of a drag come from the mouse.", 1);
        return;
      }
      dimensionDw = Math.max(newdw, getMinDw());
      dimensionDh = Math.max(newdh, getMinDh());
    }
    /**
     * Places this handle into the bottom right corner of its owner. That corner is the
     * one of the owner itself and not the one of the dimensions above: an object that is
     * smaller than the dimensions it has been asked for carries this handle at its own
     * corner, so it is always grabbed where it is seen.
     * @param cornerDw the width the corner of the owner stands at
     * @param cornerDh the height the corner of the owner stands at
     */
    public function setCornerDimensions(cornerDw:int, cornerDh:int):void
    {
      application.trace("<" + this + " BaseResizer setCornerDimensions> called.", 1);
      application.trace("<" + this + " BaseResizer setCornerDimensions> cornerDw: " + cornerDw, 0);
      application.trace("<" + this + " BaseResizer setCornerDimensions> cornerDh: " + cornerDh, 0);
      setCxy(Math.max(0, cornerDw - getDw()), Math.max(0, cornerDh - getDh()));
    }
    /**
     * Tells whether this handle is being dragged at the moment.
     */
    public function getDragging():Boolean
    {
      return dragging;
    }
    /**
     * Renders this handle in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BaseResizer addedToStage> called.", 1);
      application.trace("<" + this + " BaseResizer addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resizeAndRepaint();
    }
    /**
     * Stops the drag of this handle as soon as it leaves the stage, so that the listeners
     * of that drag are unregistered while the stage is still reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseResizer removedFromStage> called.", 1);
      application.trace("<" + this + " BaseResizer removedFromStage> e: " + e, 0);
      dropDragging();
      super.removedFromStage(e);
    }
    /**
     * Returns the narrowest width a drag of this handle can reach.
     */
    private function getMinDw():int
    {
      return application.getComponentsConfig().getScrollSizeMinWidth();
    }
    /**
     * Returns the lowest height a drag of this handle can reach.
     */
    private function getMinDh():int
    {
      return application.getComponentsConfig().getScrollSizeMinHeight();
    }
    /**
     * Takes the size of this handle from the current bright text field height and draws
     * the two diagonal lines of it. The new size is reported by the dimensions changed
     * event of this object, so the owner of it places it into its corner again.
     */
    private function resizeAndRepaint():void
    {
      application.trace("<" + this + " BaseResizer resizeAndRepaint> called.", 1);
      const textFieldHeight:int = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      setDwh(textFieldHeight, textFieldHeight);
      const drawDelta:int = 3 * application.getDynamicsConfig().getAppLineThickness();
      graphics.clear();
      graphics.beginFill(0, 0);
      graphics.drawRect(0, 0, getDw(), getDh());
      graphics.endFill();
      graphics.lineStyle(application.getDynamicsConfig().getAppLineThickness()
          , application.getDynamicsConfig().getAppBackgroundColorDark());
      graphics.moveTo(drawDelta, getDh() - drawDelta);
      graphics.lineTo(getDw() - drawDelta, drawDelta);
      graphics.moveTo(getDw() / 2 + drawDelta, getDh() - drawDelta);
      graphics.lineTo(getDw() - drawDelta, getDh() / 2 + drawDelta);
    }
    /**
     * Draws this handle again after the appearance of the application has been changed:
     * the height of a bright text field, the line thickness and the dark background color
     * of it are the ones this handle is built of.
     * @param e the text format, line thickness or background color changed event of the
     * application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " BaseResizer appearanceChanged> called.", 1);
      application.trace("<" + this + " BaseResizer appearanceChanged> e: " + e, 0);
      resizeAndRepaint();
    }
    /**
     * Starts the drag of this handle: the dimensions and the position of the mouse it has
     * to be counted from are stored, and the mouse of the whole stage is followed from
     * that moment on, so the drag goes on even while the pointer stands outside of this
     * handle.
     * @param e the mouse down event of this handle
     */
    private function resizerMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseResizer resizerMouseDown> called.", 1);
      application.trace("<" + this + " BaseResizer resizerMouseDown> e: " + e, 0);
      if (stage == null)
      {
        application.trace("<" + this + " BaseResizer resizerMouseDown> there is no stage to follow the mouse on.", 1);
        return;
      }
      dragging = true;
      dragStartDw = dimensionDw;
      dragStartDh = dimensionDh;
      dragStartMouseX = int(stage.mouseX);
      dragStartMouseY = int(stage.mouseY);
      stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
    }
    /**
     * Moves the dimensions of the owner of this handle by the pixels the mouse has
     * covered since the beginning of the drag, and tells that owner about them.
     * @param e the mouse move event of the stage
     */
    private function stageMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseResizer stageMouseMove> called.", 0);
      application.trace("<" + this + " BaseResizer stageMouseMove> e: " + e, 0);
      if (!dragging || stage == null)
      {
        application.trace("<" + this + " BaseResizer stageMouseMove> there is no drag going on.", 0);
        return;
      }
      const newdw:int = Math.max(getMinDw(), dragStartDw + int(stage.mouseX) - dragStartMouseX);
      const newdh:int = Math.max(getMinDh(), dragStartDh + int(stage.mouseY) - dragStartMouseY);
      if (dimensionDw == newdw && dimensionDh == newdh)
      {
        application.trace("<" + this + " BaseResizer stageMouseMove> there are no new dimensions.", 0);
        return;
      }
      dimensionDw = newdw;
      dimensionDh = newdh;
      application.trace("<" + this + " BaseResizer stageMouseMove> dimensionDw: " + dimensionDw, 0);
      application.trace("<" + this + " BaseResizer stageMouseMove> dimensionDh: " + dimensionDh, 0);
      getBaseEventDispatcher().dispatchEvent(eventChanged);
    }
    /**
     * Applies the very last position of the mouse and closes the drag of this handle.
     * @param e the mouse up event of the stage
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseResizer stageMouseUp> called.", 1);
      application.trace("<" + this + " BaseResizer stageMouseUp> e: " + e, 0);
      stageMouseMove(e);
      dropDragging();
    }
    /**
     * Closes the drag of this handle and stops following the mouse of the stage.
     */
    private function dropDragging():void
    {
      application.trace("<" + this + " BaseResizer dropDragging> called.", 1);
      dragging = false;
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
    }
    /**
     * Frees up every listener, drawing and reference held by this handle.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseResizer destroy> called.", 1);
      application.trace("<" + this + " BaseResizer destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.trace("<" + this + " BaseResizer destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      dropDragging();
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " BaseResizer destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      dimensionDw = 0;
      dimensionDh = 0;
      dragStartDw = 0;
      dragStartDh = 0;
      dragStartMouseX = 0;
      dragStartMouseY = 0;
      eventChanged = null;
    }
  }
}
