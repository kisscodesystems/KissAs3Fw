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
 * Board.
 * A drawable area that is drawn onto by hand, together with the toolbar that
 * belongs to it. It can be used to sign by hand, for example.
 *
 * MAIN FEATURES:
 * - the color of the background, the color of the line and the thickness of the
 *   line can be specified, both from the toolbar and from the outside
 * - every tool of that toolbar can be switched off on its own, and every one of those
 *   switchings is answered as well
 * - the picker of the color of the background is locked by the very first line drawn and it
 *   is only unlocked by a clearing, and it stands in the very state it has been given from
 *   the outside as soon as it is unlocked
 * - the drawing can be rubbed out, its last movement can be undone, an undone movement can
 *   be redone and the whole content can be cleared
 * - every movement is drawn onto a shape of its own, from the pressing of the mouse to the
 *   releasing of it, so an undo takes the last one of those shapes off and a redo puts it
 *   back, while the movements undone so far are dropped for good as soon as a new one is
 *   started
 * - the content is available as a png byte array
 * - an empty board can be resized, both by its resizer and from the outside
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseAlerter;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ColorPicker;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Fw.ui.Switcher;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.BitmapData;
  import flash.display.PNGEncoderOptions;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;
  import flash.utils.ByteArray;
  public class Board extends BaseAlerter
  {
    private var ableToDraw:Boolean = true;
    private var resizeIsPossible:Boolean = true;
    private var contentIsEmpty:Boolean = true;
    // The picker of the color of the background is locked by the very first line drawn onto
    // the drawable area and it is only unlocked by a clearing: undoing every movement one by
    // one leaves it locked, because the drawing those movements belong to is still there to
    // be redone. The second state below is the one that picker is asked to stand in from the
    // outside, so a picker that has been switched off from the outside stays off after a
    // clearing as well.
    private var backgroundIsLocked:Boolean = false;
    private var backgroundEnabledFromOutside:Boolean = true;
    private var resizingIsInProgress:Boolean = false;
    private var drawingIsInProgress:Boolean = false;
    // The mouse position the resizing has been started from.
    private var prevMouseX:int = 0;
    private var prevMouseY:int = 0;
    // The color and the thickness the next movements of the drawing are drawn by. Every
    // movement is drawn onto a shape of its own, and it takes this style at the moment it
    // is started.
    private var lineStyleColor:Number = 0;
    private var lineStyleThickness:int = 0;
    private var frame:BaseShape = null;
    private var resizer:BaseSprite = null;
    private var drawnFrame:BaseShape = null;
    private var drawnContainer:BaseSprite = null;
    private var drawnSprite:BaseSprite = null;
    // The shape of the movement being drawn at the moment, the shapes of every movement
    // drawn so far and the ones of the movements undone so far: the last element of the
    // first array is the one an undo takes off and the last element of the second one is
    // the one a redo puts back. An undone shape keeps the line drawn onto it and stands off
    // the display list only, so a redo has nothing to draw again. A movement is pure vector
    // content, so such a lightweight shape is enough for it, and it takes no mouse event
    // either: the drawing is always started by the sprite holding those shapes.
    private var drawnStroke:Shape = null;
    private var drawnStrokes:Array = null;
    private var undoneStrokes:Array = null;
    private var drawnMask:BaseSprite = null;
    private var textLabel:TextLabel = null;
    private var elements:BaseSprite = null;
    private var backgroundColorPicker:ColorPicker = null;
    private var lineColorPicker:ColorPicker = null;
    private var lineThicknessPotmeter:Potmeter = null;
    private var drawSwitcher:Switcher = null;
    private var undoButtonLink:ButtonLink = null;
    private var redoButtonLink:ButtonLink = null;
    private var clearButtonLink:ButtonLink = null;
    private var bitmapData:BitmapData = null;
    private var eventChanged:Event = null;
    private var eventCleared:Event = null;
    /**
     * Constructs the Board object: creates the frame, the resizer, the toolbar of the
     * drawing and the drawable area itself.
     * @param applicationRef the main application reference
     */
    public function Board(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Board> called.", 1);
      application.trace("<" + this + " Board> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventCleared = new Event(EnumEvents.EVENT_CLEARED());
      drawnStrokes = new Array();
      undoneStrokes = new Array();
      frame = new BaseShape(application);
      addChild(frame);
      frame.setIsBright(false);
      frame.setIsFilled(false);
      frame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      resizer = new BaseSprite(application);
      addChild(resizer);
      resizer.addEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown, false, 0, true);
      drawnFrame = new BaseShape(application);
      addChild(drawnFrame);
      drawnFrame.setIsBright(false);
      drawnFrame.setIsFilled(true);
      drawnFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      textLabel = new TextLabel(application);
      addChild(textLabel);
      elements = new BaseSprite(application);
      addChild(elements);
      backgroundColorPicker = new ColorPicker(application);
      elements.addChild(backgroundColorPicker);
      // the initial value comes first and the listener of it afterwards: the handlers
      // below reach objects that are built further down in this constructor, and the
      // initial drawing of every one of them is done by clearDrawnSprite and by
      // redrawDrawnFrame, the last one being called when this board gets a stage
      backgroundColorPicker.setRGBColor(application.getComponentsConfig().getBoardBackgroundColor());
      backgroundColorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), backgroundColorPickerChanged);
      lineColorPicker = new ColorPicker(application);
      elements.addChild(lineColorPicker);
      lineColorPicker.setRGBColor(application.getComponentsConfig().getBoardLineColor());
      lineColorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), lineColorPickerChanged);
      lineThicknessPotmeter = new Potmeter(application);
      elements.addChild(lineThicknessPotmeter);
      lineThicknessPotmeter.setMinMaxIncValues(application.getComponentsConfig().getBoardLineMinThickness()
          , application.getComponentsConfig().getBoardLineMaxThickness()
          , application.getComponentsConfig().getBoardLineIncThickness());
      lineThicknessPotmeter.setCurValue(application.getComponentsConfig().getBoardLineThickness());
      lineThicknessPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), lineThicknessPotmeterChanged);
      drawSwitcher = new Switcher(application);
      elements.addChild(drawSwitcher);
      drawSwitcher.setIcons(EnumIcons.drawer(), EnumIcons.rubber());
      drawSwitcher.setOn(true, false);
      drawSwitcher.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), drawSwitcherChanged);
      undoButtonLink = new ButtonLink(application);
      elements.addChild(undoButtonLink);
      undoButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), undoButtonLinkClicked);
      undoButtonLink.setEventDispatcherObjectToThis();
      undoButtonLink.setIcon(EnumIcons.undoer());
      redoButtonLink = new ButtonLink(application);
      elements.addChild(redoButtonLink);
      redoButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), redoButtonLinkClicked);
      redoButtonLink.setEventDispatcherObjectToThis();
      redoButtonLink.setIcon(EnumIcons.redoer());
      clearButtonLink = new ButtonLink(application);
      elements.addChild(clearButtonLink);
      clearButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), clearButtonLinkClicked);
      clearButtonLink.setEventDispatcherObjectToThis();
      clearButtonLink.setIcon(EnumIcons.clearer());
      drawnContainer = new BaseSprite(application);
      addChild(drawnContainer);
      drawnSprite = new BaseSprite(application);
      drawnContainer.addChild(drawnSprite);
      drawnSprite.addEventListener(MouseEvent.MOUSE_DOWN, drawnSpriteMouseDown, false, 0, true);
      drawnMask = new BaseSprite(application);
      drawnContainer.addChild(drawnMask);
      drawnSprite.mask = drawnMask;
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), insideElementsSizesChanged);
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      backgroundColorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      lineColorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      lineThicknessPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      drawSwitcher.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      undoButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      redoButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      clearButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), insideElementsSizesChanged);
      clearDrawnSprite();
      application.trace("<" + this + " Board> constructed.", 1);
    }
    /**
     * Returns the content of the drawable area as a png byte array.
     */
    public function getCanvasByteArray():ByteArray
    {
      application.trace("<" + this + " Board getCanvasByteArray> called.", 1);
      destroyBitmapData();
      bitmapData = new BitmapData(drawnContainer.getDw(), drawnContainer.getDh(), true, 0);
      bitmapData.draw(drawnFrame);
      bitmapData.draw(drawnContainer);
      const byteArray:ByteArray = new ByteArray();
      bitmapData.encode(new Rectangle(0, 0, drawnContainer.getDw(), drawnContainer.getDh()), new PNGEncoderOptions(false), byteArray);
      return byteArray;
    }
    /**
     * Returns the width of the drawable area.
     */
    public function getCanvasWidth():int
    {
      return drawnContainer.getDw();
    }
    /**
     * Returns the height of the drawable area.
     */
    public function getCanvasHeight():int
    {
      return drawnContainer.getDh();
    }
    /**
     * Returns the label that names this board.
     */
    public function getLabel():String
    {
      return textLabel.getLabel();
    }
    /**
     * Sets the label that names this board.
     * @param s the text code of the new label
     */
    public function setLabel(s:String):void
    {
      application.trace("<" + this + " Board setLabel> called.", 1);
      application.trace("<" + this + " Board setLabel> s: " + s, 0);
      if (s != null)
      {
        textLabel.setLabel(s);
      }
    }
    /**
     * Returns the color of the background of the drawable area.
     */
    public function getBackgroundRGBColor():String
    {
      return backgroundColorPicker.getRGBColor();
    }
    /**
     * Sets the color of the background of the drawable area, but only while nothing
     * has been drawn onto it yet.
     * @param c the new color in the rrggbb form
     */
    public function setBackgroundRGBColor(c:String):void
    {
      application.trace("<" + this + " Board setBackgroundRGBColor> called.", 1);
      application.trace("<" + this + " Board setBackgroundRGBColor> c: " + c, 0);
      if (contentIsEmpty)
      {
        backgroundColorPicker.setRGBColor(c);
      }
    }
    /**
     * Tells whether the picker of the color of the background is enabled at the moment.
     */
    public function getBackgroundEnabled():Boolean
    {
      return backgroundColorPicker.getEnabled();
    }
    /**
     * Enables or disables the picker of the color of the background, but only while that
     * picker is not locked by a drawing: it is locked by the very first line drawn onto the
     * drawable area and only a clearing unlocks it. The state given here is kept, so a
     * picker that has been switched off from the outside stays off after that clearing as
     * well.
     * @param e true when that picker has to be enabled
     */
    public function setBackgroundEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setBackgroundEnabled> called.", 1);
      application.trace("<" + this + " Board setBackgroundEnabled> e: " + e, 0);
      if (!backgroundIsLocked)
      {
        backgroundEnabledFromOutside = e;
        applyBackgroundEnabled();
      }
    }
    /**
     * Returns the color of the line the drawing happens by.
     */
    public function getLineRGBColor():String
    {
      return lineColorPicker.getRGBColor();
    }
    /**
     * Sets the color of the line the drawing happens by.
     * @param c the new color in the rrggbb form
     */
    public function setLineRGBColor(c:String):void
    {
      application.trace("<" + this + " Board setLineRGBColor> called.", 1);
      application.trace("<" + this + " Board setLineRGBColor> c: " + c, 0);
      lineColorPicker.setRGBColor(c);
    }
    /**
     * Tells whether the picker of the color of the line is enabled.
     */
    public function getLineEnabled():Boolean
    {
      return lineColorPicker.getEnabled();
    }
    /**
     * Enables or disables the picker of the color of the line.
     * @param e true when that picker has to be enabled
     */
    public function setLineEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setLineEnabled> called.", 1);
      application.trace("<" + this + " Board setLineEnabled> e: " + e, 0);
      lineColorPicker.setEnabled(e);
    }
    /**
     * Returns the thickness of the line the drawing happens by.
     */
    public function getLineThickness():int
    {
      return lineThicknessPotmeter.getCurValue();
    }
    /**
     * Sets the thickness of the line the drawing happens by.
     * @param i the new thickness
     */
    public function setLineThickness(i:int):void
    {
      application.trace("<" + this + " Board setLineThickness> called.", 1);
      application.trace("<" + this + " Board setLineThickness> i: " + i, 0);
      lineThicknessPotmeter.setCurValue(i);
    }
    /**
     * Tells whether the potmeter of the thickness of the line is enabled.
     */
    public function getLineThicknessEnabled():Boolean
    {
      return lineThicknessPotmeter.getEnabled();
    }
    /**
     * Enables or disables the potmeter of the thickness of the line.
     * @param e true when that potmeter has to be enabled
     */
    public function setLineThicknessEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setLineThicknessEnabled> called.", 1);
      application.trace("<" + this + " Board setLineThicknessEnabled> e: " + e, 0);
      lineThicknessPotmeter.setEnabled(e);
    }
    /**
     * Tells whether the board draws at the moment instead of rubbing out.
     */
    public function getDraw():Boolean
    {
      return drawSwitcher.getOn();
    }
    /**
     * Sets whether the board has to draw instead of rubbing out.
     * @param b true when the board has to draw
     */
    public function setDraw(b:Boolean):void
    {
      application.trace("<" + this + " Board setDraw> called.", 1);
      application.trace("<" + this + " Board setDraw> b: " + b, 0);
      drawSwitcher.setOn(b);
    }
    /**
     * Tells whether the switcher between the drawing and the rubbing out is enabled.
     */
    public function getDrawEnabled():Boolean
    {
      return drawSwitcher.getEnabled();
    }
    /**
     * Enables or disables the switcher between the drawing and the rubbing out.
     * @param e true when that switcher has to be enabled
     */
    public function setDrawEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setDrawEnabled> called.", 1);
      application.trace("<" + this + " Board setDrawEnabled> e: " + e, 0);
      drawSwitcher.setEnabled(e);
    }
    /**
     * Tells whether the button that undoes the last movement of the drawing is enabled.
     */
    public function getUndoEnabled():Boolean
    {
      return undoButtonLink.getEnabled();
    }
    /**
     * Enables or disables the button that undoes the last movement of the drawing.
     * @param e true when that button has to be enabled
     */
    public function setUndoEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setUndoEnabled> called.", 1);
      application.trace("<" + this + " Board setUndoEnabled> e: " + e, 0);
      undoButtonLink.setEnabled(e);
    }
    /**
     * Tells whether the button that redoes the last undone movement of the drawing is
     * enabled.
     */
    public function getRedoEnabled():Boolean
    {
      return redoButtonLink.getEnabled();
    }
    /**
     * Enables or disables the button that redoes the last undone movement of the drawing.
     * @param e true when that button has to be enabled
     */
    public function setRedoEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setRedoEnabled> called.", 1);
      application.trace("<" + this + " Board setRedoEnabled> e: " + e, 0);
      redoButtonLink.setEnabled(e);
    }
    /**
     * Tells whether the button that clears the drawable area is enabled.
     */
    public function getClearEnabled():Boolean
    {
      return clearButtonLink.getEnabled();
    }
    /**
     * Enables or disables the button that clears the drawable area.
     * @param e true when that button has to be enabled
     */
    public function setClearEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Board setClearEnabled> called.", 1);
      application.trace("<" + this + " Board setClearEnabled> e: " + e, 0);
      clearButtonLink.setEnabled(e);
    }
    /**
     * Undoes the last movement of the drawing at once, without asking anything. Such a
     * movement is everything that has been drawn between the pressing and the releasing of
     * the mouse, and nothing at all happens when there is no movement to be undone.
     */
    public function undo():void
    {
      application.trace("<" + this + " Board undo> called.", 1);
      theUndo();
    }
    /**
     * Redoes the last undone movement of the drawing at once, without asking anything. Such
     * a movement is put back onto the drawable area exactly the way it has been drawn, and
     * nothing at all happens when there is no undone movement to be redone.
     */
    public function redo():void
    {
      application.trace("<" + this + " Board redo> called.", 1);
      theRedo();
    }
    /**
     * Clears the drawable area at once, without asking anything.
     */
    public function clear():void
    {
      application.trace("<" + this + " Board clear> called.", 1);
      theClear();
    }
    /**
     * Tells whether nothing has been drawn onto the drawable area yet.
     */
    public function isContentEmpty():Boolean
    {
      return contentIsEmpty;
    }
    /**
     * Returns the number of the movements drawn onto the drawable area so far: the very
     * number of the undos that can be done on it.
     */
    public function getMovementsCount():int
    {
      return drawnStrokes.length;
    }
    /**
     * Returns the number of the movements undone on the drawable area so far: the very
     * number of the redos that can be done on it. Such a movement is dropped for good as
     * soon as a new one is started, so this number falls back to zero from the first line
     * drawn after an undo.
     */
    public function getUndoneMovementsCount():int
    {
      return undoneStrokes.length;
    }
    /**
     * Tells whether this board can be resized by its resizer.
     */
    public function getResizeIsPossible():Boolean
    {
      return resizeIsPossible;
    }
    /**
     * Sets whether this board can be resized by its resizer.
     * @param b true when the resizing has to be possible
     */
    public function setResizeIsPossible(b:Boolean):void
    {
      application.trace("<" + this + " Board setResizeIsPossible> called.", 1);
      application.trace("<" + this + " Board setResizeIsPossible> b: " + b, 0);
      resizeIsPossible = b;
    }
    /**
     * Returns the width of the background of the drawable area.
     */
    public function getDwContent():int
    {
      return drawnFrame.getDw();
    }
    /**
     * Returns the height of the background of the drawable area.
     */
    public function getDhContent():int
    {
      return drawnFrame.getDh();
    }
    /**
     * Sets the dimensions of the drawable area itself, but only while nothing has been
     * drawn onto it yet.
     * @param newdw the new width of the drawable area
     * @param newdh the new height of the drawable area
     */
    public function setDwhContent(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Board setDwhContent> called.", 1);
      application.trace("<" + this + " Board setDwhContent> newdw: " + newdw, 0);
      application.trace("<" + this + " Board setDwhContent> newdh: " + newdh, 0);
      if (contentIsEmpty && (getDwContent() != newdw || getDhContent() != newdh))
      {
        drawnFrame.setDwh(newdw, newdh);
        clearDrawnSprite();
        insideElementsSizesChanged();
        dispatchEventChanged();
      }
    }
    /**
     * Enables or disables this board together with every element of its toolbar.
     * @param b true when this board has to be enabled
     */
    override public function setEnabled(b:Boolean):void
    {
      application.trace("<" + this + " Board setEnabled> called.", 1);
      application.trace("<" + this + " Board setEnabled> b: " + b, 0);
      super.setEnabled(b);
      applyBackgroundEnabled();
      setLineEnabled(b);
      setLineThicknessEnabled(b);
      setDrawEnabled(b);
      setUndoEnabled(b);
      setRedoEnabled(b);
      setClearEnabled(b);
      ableToDraw = b;
    }
    /**
     * Sets the width of this board, but only while nothing has been drawn onto it yet.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Board setDw> called.", 1);
      application.trace("<" + this + " Board setDw> newdw: " + newdw, 0);
      if (contentIsEmpty && getDw() != newdw)
      {
        super.setDw(newdw);
        resizeReposAll();
        dispatchEventChanged();
      }
    }
    /**
     * Sets the height of this board, but only while nothing has been drawn onto it yet.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Board setDh> called.", 1);
      application.trace("<" + this + " Board setDh> newdh: " + newdh, 0);
      if (contentIsEmpty && getDh() != newdh)
      {
        super.setDh(newdh);
        resizeReposAll();
        dispatchEventChanged();
      }
    }
    /**
     * Sets the dimensions of this board, but only while nothing has been drawn onto it
     * yet.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Board setDwh> called.", 1);
      application.trace("<" + this + " Board setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Board setDwh> newdh: " + newdh, 0);
      if (contentIsEmpty && (getDw() != newdw || getDh() != newdh))
      {
        super.setDwh(newdw, newdh);
        resizeReposAll();
        dispatchEventChanged();
      }
    }
    /**
     * Starts to listen to the mouse releases of the stage, because the resizing and
     * the drawing have to stop wherever the mouse has been released.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Board addedToStage> called.", 1);
      application.trace("<" + this + " Board addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp, false, 0, true);
      }
      insideElementsSizesChanged();
    }
    /**
     * Stops listening to the mouse releases of the stage when this board gets off it.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Board removedFromStage> called.", 1);
      application.trace("<" + this + " Board removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      super.removedFromStage(e);
    }
    /**
     * Repaints the background of the drawable area in the new color and reports the
     * change to the outside world.
     * @param e the changed event of the picker of the color of the background
     */
    private function backgroundColorPickerChanged(e:Event):void
    {
      application.trace("<" + this + " Board backgroundColorPickerChanged> called.", 1);
      application.trace("<" + this + " Board backgroundColorPickerChanged> e: " + e, 0);
      redrawDrawnFrame();
      dispatchEventChanged();
    }
    /**
     * Takes the new color of the line and switches back to the drawing, because a new
     * line color is only worth anything while the board draws.
     * @param e the changed event of the picker of the color of the line
     */
    private function lineColorPickerChanged(e:Event):void
    {
      application.trace("<" + this + " Board lineColorPickerChanged> called.", 1);
      application.trace("<" + this + " Board lineColorPickerChanged> e: " + e, 0);
      setLineStyle(true);
      setDraw(true);
    }
    /**
     * Takes the new thickness of the line.
     * @param e the changed event of the potmeter of the thickness of the line
     */
    private function lineThicknessPotmeterChanged(e:Event):void
    {
      application.trace("<" + this + " Board lineThicknessPotmeterChanged> called.", 1);
      application.trace("<" + this + " Board lineThicknessPotmeterChanged> e: " + e, 0);
      setLineStyle(drawSwitcher.getOn());
    }
    /**
     * Switches between the drawing and the rubbing out.
     * @param e the changed event of the switcher of the drawing
     */
    private function drawSwitcherChanged(e:Event):void
    {
      application.trace("<" + this + " Board drawSwitcherChanged> called.", 1);
      application.trace("<" + this + " Board drawSwitcherChanged> e: " + e, 0);
      setLineStyle(drawSwitcher.getOn());
    }
    /**
     * Undoes the last movement of the drawing. There is nothing to be asked here: this
     * takes one single movement away and leaves everything drawn before it where it is.
     * @param e the click event of the button that undoes the last movement
     */
    private function undoButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Board undoButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Board undoButtonLinkClicked> e: " + e, 0);
      theUndo();
    }
    /**
     * Takes the shape of the last movement of the drawing off the drawable area and reports
     * the change to the outside world. That shape keeps the line drawn onto it and waits for
     * a redo, so nothing but a new movement drops it for good. The drawable area is empty
     * again as soon as the very first movement of it has been undone, so its background can
     * be repainted and this board can be resized again from that moment. The picker of the
     * color of that background stays locked there, because the drawing every undone movement
     * belongs to is still there to be redone: only a clearing unlocks that picker.
     */
    private function theUndo():void
    {
      application.trace("<" + this + " Board theUndo> called.", 1);
      if (drawnStrokes.length > 0)
      {
        undoneStrokes.push(detachLastDrawnStroke());
        if (drawnStrokes.length == 0)
        {
          contentIsEmpty = true;
        }
        dispatchEventChanged();
      }
    }
    /**
     * Redoes the last undone movement of the drawing.
     * @param e the click event of the button that redoes the last undone movement
     */
    private function redoButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Board redoButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Board redoButtonLinkClicked> e: " + e, 0);
      theRedo();
    }
    /**
     * Puts the shape of the last undone movement back onto the top of the drawing and
     * reports the change to the outside world. There is a drawing on the background again
     * from that moment, so the color of it can not be changed any more. The picker of that
     * color stands locked already, because only a clearing unlocks it and such a clearing
     * leaves no undone movement to be redone at all.
     */
    private function theRedo():void
    {
      application.trace("<" + this + " Board theRedo> called.", 1);
      if (undoneStrokes.length > 0)
      {
        const stroke:Shape = Shape(undoneStrokes.pop());
        drawnSprite.addChild(stroke);
        drawnStrokes.push(stroke);
        contentIsEmpty = false;
        dispatchEventChanged();
      }
    }
    /**
     * Clears the drawable area, asking for a confirmation first. There is nothing to be
     * confirmed while there is nothing to be lost: an empty drawable area is only ever
     * cleared without a word when every movement undone on it has been dropped as well,
     * because the movements waiting for a redo are dropped for good by that clearing.
     * @param e the click event of the button that clears the drawable area
     */
    private function clearButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Board clearButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Board clearButtonLinkClicked> e: " + e, 0);
      if (!contentIsEmpty || undoneStrokes.length > 0)
      {
        confirmOK = function():void
        {
          theClear();
        };
        confirmCancel = function():void
        {
        };
        showConfirm(EnumTextKeys.REALLY_WANT_TO_CLEAR_DRAWN_CONTENT());
      }
    }
    /**
     * Clears the drawable area, switches back to the drawing and reports the clearing to the
     * outside world. This is the one and only thing that unlocks the picker of the color of
     * the background, and that picker takes the very state it has been given from the
     * outside there: a picker that has been switched off from the outside stays off.
     */
    private function theClear():void
    {
      application.trace("<" + this + " Board theClear> called.", 1);
      clearDrawnSprite();
      if (drawSwitcher.getEnabled())
      {
        drawSwitcher.setOn(true);
      }
      backgroundIsLocked = false;
      applyBackgroundEnabled();
      contentIsEmpty = true;
      dispatchEventChanged();
      dispatchEventCleared();
    }
    /**
     * Puts the picker of the color of the background into the state it really has to stand
     * in: the one it has been given from the outside, as long as it is not locked by a
     * drawing and this board is enabled as a whole.
     */
    private function applyBackgroundEnabled():void
    {
      application.trace("<" + this + " Board applyBackgroundEnabled> called.", 1);
      backgroundColorPicker.setEnabled(backgroundEnabledFromOutside && !backgroundIsLocked && getEnabled());
    }
    /**
     * Takes the current color and thickness the next movements of the drawing are drawn by.
     * The rubber is the background color, drawn by a much thicker line. Every movement is
     * drawn onto a shape of its own and takes this style when it is started, so nothing is
     * applied onto any graphics here.
     * @param useLineColor true when the board draws instead of rubbing out
     */
    private function setLineStyle(useLineColor:Boolean):void
    {
      application.trace("<" + this + " Board setLineStyle> called.", 1);
      application.trace("<" + this + " Board setLineStyle> useLineColor: " + useLineColor, 0);
      const thicknessFactor:int = useLineColor ? 1 : application.getComponentsConfig().getBoardRubberThicknessFactor();
      const rgbColor:String = useLineColor ? lineColorPicker.getRGBColor() : backgroundColorPicker.getRGBColor();
      lineStyleThickness = thicknessFactor * lineThicknessPotmeter.getCurValue();
      lineStyleColor = Number(application.getComponentsConfig().getColorHexToNumberString() + rgbColor);
    }
    /**
     * Grabs this board on the area of its resizer, but only while nothing has been
     * drawn onto it yet.
     * @param e the mouse down event of the resizer
     */
    private function resizerMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Board resizerMouseDown> called.", 1);
      application.trace("<" + this + " Board resizerMouseDown> e: " + e, 0);
      if (resizeIsPossible && contentIsEmpty)
      {
        resizingIsInProgress = true;
        prevMouseX = mouseX;
        prevMouseY = mouseY;
        addEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer, false, 0, true);
      }
    }
    /**
     * Draws the frame of the dimensions the current resizing means.
     * @param e the enter frame event of this board
     */
    private function enterFrameUpdateResizer(e:Event):void
    {
      application.trace("<" + this + " Board enterFrameUpdateResizer> called.", 0);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      const resizeMargin:int = application.getComponentsConfig().getResizeMargin();
      resizer.graphics.clear();
      resizer.graphics.lineStyle(lineThickness
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getComponentsConfig().getLineAlpha()
          , application.getComponentsConfig().getPixelHinting());
      resizer.graphics.drawRect(-resizeMargin
          , -resizeMargin
          , getDw() + mouseX - prevMouseX + 2 * resizeMargin - lineThickness
          , getDh() + mouseY - prevMouseY + 2 * resizeMargin - lineThickness);
    }
    /**
     * Draws the transparent area the resizing can be started from.
     */
    private function clearResizer():void
    {
      application.trace("<" + this + " Board clearResizer> called.", 1);
      const resizeMargin:int = application.getComponentsConfig().getResizeMargin();
      resizer.graphics.clear();
      resizer.graphics.beginFill(0, 0);
      resizer.graphics.drawRect(-resizeMargin, -resizeMargin, getDw() + 2 * resizeMargin, getDh() + 2 * resizeMargin);
      resizer.graphics.endFill();
      resizer.setCxy(0, 0);
      resizer.setDwh(getDw(), getDh());
    }
    /**
     * Redraws the frame of this board and the background of the drawable area.
     * @param e the radius, box or background color changed event of the application,
     * null on a direct call
     */
    private function redrawShapes(e:Event = null):void
    {
      application.trace("<" + this + " Board redrawShapes> called.", 1);
      application.trace("<" + this + " Board redrawShapes> e: " + e, 0);
      const colorAlpha:Number = application.getDynamicsConfig().getAppBackgroundColorAlpha();
      frame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , colorAlpha + (1 - colorAlpha) * 3 / 4
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      frame.setRadius(application.getDynamicsConfig().getAppRadius());
      frame.drawRect();
      redrawDrawnFrame();
    }
    /**
     * Redraws the background of the drawable area only, in the color the picker of it
     * holds at the moment.
     */
    private function redrawDrawnFrame():void
    {
      application.trace("<" + this + " Board redrawDrawnFrame> called.", 1);
      const backgroundColor:Number = Number(application.getComponentsConfig().getColorHexToNumberString() + backgroundColorPicker.getRGBColor());
      drawnFrame.setColorsAndAlpha(backgroundColor
          , backgroundColor
          , backgroundColor
          , 1
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      drawnFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      drawnFrame.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
      drawnFrame.drawRect();
    }
    /**
     * Puts every element of the toolbar next to each other, under the label of this
     * board.
     */
    private function reposInsideElements():void
    {
      application.trace("<" + this + " Board reposInsideElements> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setCxy(padding, padding);
      backgroundColorPicker.setCxy(padding, textLabel.getCy(true, false, true));
      lineColorPicker.setCxy(backgroundColorPicker.getCx(true), backgroundColorPicker.getCy());
      lineThicknessPotmeter.setCxy(lineColorPicker.getCx(true), lineColorPicker.getCy());
      drawSwitcher.setCxy(lineThicknessPotmeter.getCx(true), lineThicknessPotmeter.getCy());
      undoButtonLink.setCxy(drawSwitcher.getCx(true), drawSwitcher.getCy());
      redoButtonLink.setCxy(undoButtonLink.getCx(true), undoButtonLink.getCy());
      clearButtonLink.setCxy(redoButtonLink.getCx(true), redoButtonLink.getCy());
    }
    /**
     * Keeps the label of this board inside the width of it, in one single line: that
     * label stands above the toolbar on its own, so it takes the whole width that is
     * left over by the paddings of the two sides of it. This is only ever done at the
     * very end of a layout, because a new width of that label is answered by
     * insideElementsSizesChanged, and that handler can only measure the very same
     * dimensions again when every other element stands in its new size already.
     */
    private function resizeTextLabel():void
    {
      application.trace("<" + this + " Board resizeTextLabel> called.", 1);
      textLabel.setMaxWidth(getDw() - 2 * application.getDynamicsConfig().getAppPadding(), false);
    }
    /**
     * Repositions and resizes everything after this board has been resized from the
     * outside. The drawable area takes the room that is left over, so its dimensions
     * change here as well.
     */
    private function resizeReposAll():void
    {
      application.trace("<" + this + " Board resizeReposAll> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      frame.setDwh(getDw(), getDh());
      frame.x = 0;
      frame.y = 0;
      reposInsideElements();
      drawnFrame.x = padding;
      drawnFrame.y = backgroundColorPicker.getCy(true) + padding;
      drawnFrame.setDwh(getDw() - 2 * drawnFrame.x, getDh() - drawnFrame.y - padding);
      drawnContainer.setCxy(drawnFrame.x, drawnFrame.y);
      clearDrawnSprite();
      clearResizer();
      redrawShapes();
      resizeTextLabel();
    }
    /**
     * Repositions everything after one of the elements of the toolbar or the padding
     * of the application has been changed. The dimensions of the drawable area are
     * kept here, this board takes the room that toolbar and that area need.
     * @param e the dimensions changed event of an element of the toolbar or the
     * padding changed event of the application, null on a direct call
     */
    private function insideElementsSizesChanged(e:Event = null):void
    {
      application.trace("<" + this + " Board insideElementsSizesChanged> called.", 1);
      application.trace("<" + this + " Board insideElementsSizesChanged> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      reposInsideElements();
      var maxh:int = 0;
      maxh = Math.max(maxh, backgroundColorPicker.getCy(true, false, true));
      maxh = Math.max(maxh, lineColorPicker.getCy(true, false, true));
      maxh = Math.max(maxh, lineThicknessPotmeter.getCy(true, false, true));
      maxh = Math.max(maxh, drawSwitcher.getCy(true, false, true));
      maxh = Math.max(maxh, undoButtonLink.getCy(true, false, true));
      maxh = Math.max(maxh, redoButtonLink.getCy(true, false, true));
      maxh = Math.max(maxh, clearButtonLink.getCy(true, false, true));
      drawnFrame.x = padding;
      drawnFrame.y = maxh;
      drawnContainer.setCxy(drawnFrame.x, drawnFrame.y);
      super.setDwh(Math.max(clearButtonLink.getCx(true, false, true), drawnContainer.getCx(true, false, true))
          , drawnContainer.getCy(true, false, true));
      frame.setDwh(getDw(), getDh());
      frame.x = 0;
      frame.y = 0;
      clearResizer();
      redrawShapes();
      resizeTextLabel();
    }
    /**
     * Clears the drawable area and reinitializes the transparent layer the drawing
     * happens onto, together with the mask that keeps that drawing inside. Every movement
     * drawn so far and every one undone so far is taken away here, so there is nothing left
     * to be undone and nothing left to be redone afterwards.
     */
    private function clearDrawnSprite():void
    {
      application.trace("<" + this + " Board clearDrawnSprite> called.", 1);
      const boardPadding:int = application.getComponentsConfig().getBoardPadding();
      removeAllDrawnStrokes();
      removeAllUndoneStrokes();
      drawnContainer.setDwh(drawnFrame.getDw(), drawnFrame.getDh());
      drawnSprite.setDwh(drawnFrame.getDw(), drawnFrame.getDh());
      drawnSprite.graphics.clear();
      drawnSprite.graphics.beginFill(0, 0);
      drawnSprite.graphics.drawRect(0, 0, drawnFrame.getDw(), drawnFrame.getDh());
      drawnSprite.graphics.endFill();
      drawnMask.setDwh(drawnFrame.getDw(), drawnFrame.getDh());
      drawnMask.graphics.clear();
      drawnMask.graphics.beginFill(0, 0);
      drawnMask.graphics.drawRect(boardPadding, boardPadding, drawnFrame.getDw() - 2 * boardPadding, drawnFrame.getDh() - 2 * boardPadding);
      drawnMask.graphics.endFill();
      setLineStyle(true);
    }
    /**
     * Takes the shape of the last movement off the drawable area and answers it. Such a
     * shape keeps the line drawn onto it, so a redo has nothing to draw again: it only
     * stands off the display list until it is put back or dropped for good.
     */
    private function detachLastDrawnStroke():Shape
    {
      application.trace("<" + this + " Board detachLastDrawnStroke> called.", 1);
      const stroke:Shape = Shape(drawnStrokes.pop());
      if (stroke == drawnStroke)
      {
        drawnStroke = null;
      }
      if (drawnSprite.contains(stroke))
      {
        drawnSprite.removeChild(stroke);
      }
      return stroke;
    }
    /**
     * Takes the shape of the last movement away for good, together with the line drawn onto
     * it.
     */
    private function removeLastDrawnStroke():void
    {
      application.trace("<" + this + " Board removeLastDrawnStroke> called.", 1);
      detachLastDrawnStroke().graphics.clear();
    }
    /**
     * Takes the shape of every movement drawn so far away.
     */
    private function removeAllDrawnStrokes():void
    {
      application.trace("<" + this + " Board removeAllDrawnStrokes> called.", 1);
      while (drawnStrokes.length > 0)
      {
        removeLastDrawnStroke();
      }
    }
    /**
     * Takes the shape of every movement undone so far away, together with the line drawn
     * onto every one of them: nothing can be redone after this.
     */
    private function removeAllUndoneStrokes():void
    {
      application.trace("<" + this + " Board removeAllUndoneStrokes> called.", 1);
      while (undoneStrokes.length > 0)
      {
        Shape(undoneStrokes.pop()).graphics.clear();
      }
    }
    /**
     * Starts the drawing when this board is able to draw at the moment.
     * @param e the mouse down event of the drawable area
     */
    private function drawnSpriteMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Board drawnSpriteMouseDown> called.", 1);
      application.trace("<" + this + " Board drawnSpriteMouseDown> e: " + e, 0);
      if (ableToDraw)
      {
        startDraw();
      }
    }
    /**
     * Starts the drawing from the current mouse position, onto a brand new shape standing on
     * top of the movements drawn so far: that very shape is the one an undo takes off
     * afterwards. Every movement undone so far is dropped for good here, because a drawing
     * that goes on cannot be redone into, so this is the very moment such a movement is
     * lost: an undo on its own keeps every one of them. The color of the background can not
     * be changed any more, because there is a drawing on it from now, and the picker of that
     * color is locked here until the next clearing.
     */
    private function startDraw():void
    {
      application.trace("<" + this + " Board startDraw> called.", 1);
      drawingIsInProgress = true;
      removeAllUndoneStrokes();
      backgroundIsLocked = true;
      applyBackgroundEnabled();
      contentIsEmpty = false;
      drawnStroke = new Shape();
      drawnSprite.addChild(drawnStroke);
      drawnStrokes.push(drawnStroke);
      drawnStroke.graphics.lineStyle(lineStyleThickness, lineStyleColor, 1, true);
      drawnStroke.graphics.moveTo(drawnStroke.mouseX, drawnStroke.mouseY);
      addEventListener(Event.ENTER_FRAME, drawing, false, 0, true);
    }
    /**
     * Draws the line of the current movement up to the current mouse position.
     * @param e the enter frame event of this board
     */
    private function drawing(e:Event):void
    {
      application.trace("<" + this + " Board drawing> called.", 0);
      if (drawnStroke != null)
      {
        drawnStroke.graphics.lineTo(drawnStroke.mouseX, drawnStroke.mouseY);
      }
    }
    /**
     * Stops the drawing, closes the movement that has been drawn and reports the new
     * content to the outside world.
     */
    private function stopDraw():void
    {
      application.trace("<" + this + " Board stopDraw> called.", 1);
      removeEventListener(Event.ENTER_FRAME, drawing);
      drawingIsInProgress = false;
      drawnStroke = null;
      dispatchEventChanged();
    }
    /**
     * Closes the resizing and the drawing as soon as the mouse has been released
     * anywhere.
     * @param e the mouse up event of the stage
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      application.trace("<" + this + " Board stageMouseUp> called.", 1);
      application.trace("<" + this + " Board stageMouseUp> e: " + e, 0);
      if (resizingIsInProgress)
      {
        resizingIsInProgress = false;
        removeEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer);
        if (mouseX != prevMouseX || mouseY != prevMouseY)
        {
          setDwh(Math.max(getDw() + mouseX - prevMouseX, clearButtonLink.getCx(true, false, true))
              , Math.max(getDh() + mouseY - prevMouseY, 4 * clearButtonLink.getDh()));
        }
        clearResizer();
        prevMouseX = 0;
        prevMouseY = 0;
      }
      if (drawingIsInProgress)
      {
        stopDraw();
      }
    }
    /**
     * Frees the bitmap data of the previously taken content of the drawable area.
     */
    private function destroyBitmapData():void
    {
      application.trace("<" + this + " Board destroyBitmapData> called.", 1);
      if (bitmapData != null)
      {
        bitmapData.dispose();
        bitmapData = null;
      }
    }
    /**
     * Dispatches the changed event of this board.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " Board dispatchEventChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Dispatches the cleared event of this board.
     */
    private function dispatchEventCleared():void
    {
      application.trace("<" + this + " Board dispatchEventCleared> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventCleared);
      }
    }
    /**
     * Frees all listeners, events and references held by this board.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Board destroy> called.", 1);
      application.trace("<" + this + " Board destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), insideElementsSizesChanged);
      resizer.removeEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
      drawnSprite.removeEventListener(MouseEvent.MOUSE_DOWN, drawnSpriteMouseDown);
      removeEventListener(Event.ENTER_FRAME, enterFrameUpdateResizer);
      removeEventListener(Event.ENTER_FRAME, drawing);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      application.trace("<" + this + " Board destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      eventCleared.stopImmediatePropagation();
      removeAllDrawnStrokes();
      removeAllUndoneStrokes();
      destroyBitmapData();
      drawnSprite.mask = null;
      application.trace("<" + this + " Board destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      ableToDraw = false;
      resizeIsPossible = false;
      contentIsEmpty = false;
      backgroundIsLocked = false;
      backgroundEnabledFromOutside = false;
      resizingIsInProgress = false;
      drawingIsInProgress = false;
      prevMouseX = 0;
      prevMouseY = 0;
      lineStyleColor = 0;
      lineStyleThickness = 0;
      frame = null;
      resizer = null;
      drawnFrame = null;
      drawnContainer = null;
      drawnSprite = null;
      drawnStroke = null;
      drawnStrokes = null;
      undoneStrokes = null;
      drawnMask = null;
      textLabel = null;
      elements = null;
      backgroundColorPicker = null;
      lineColorPicker = null;
      lineThicknessPotmeter = null;
      drawSwitcher = null;
      undoButtonLink = null;
      redoButtonLink = null;
      clearButtonLink = null;
      confirmOK = null;
      confirmCancel = null;
      bitmapData = null;
      eventChanged = null;
      eventCleared = null;
    }
  }
}
