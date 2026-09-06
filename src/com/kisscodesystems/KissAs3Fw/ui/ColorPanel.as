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
 * ColorPanel.
 * A coloring panel that can be used standalone but usually appears inside a ColorPicker.
 *
 * MAIN FEATURES:
 * - keeps an actual color and a default one, the actual can be committed as the default
 * - the actual color can be set from the outside by setRGBColor, by the rgb text input,
 *   from the prepared color squares, from any pixel of the stage and from the two
 *   gradient strips drawn from the actual and from the complementer color
 * - calculates and displays the complementer of the actual color
 * - the live background of the application is fixed while a pixel is being stolen: the one
 *   using it has to see exactly the snapshot the stolen colors are taken from
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Fw.ui.TextInput;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.BitmapData;
  import flash.display.GradientType;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  import flash.ui.Keyboard;
  public class ColorPanel extends BaseSprite
  {
    private var inputRgb:TextInput = null;
    private var acceptNewColorButton:ButtonText = null;
    private var panelColorDefault:BaseSprite = null;
    private var panelColorActual:BaseSprite = null;
    private var panelColorComplementer:BaseSprite = null;
    private var drawnCustomSprite:BaseSprite = null;
    private var drawnMatrix:Matrix = null;
    private var drawnBitmapData:BitmapData = null;
    private var drawn2CustomSprite:BaseSprite = null;
    private var drawn2Matrix:Matrix = null;
    private var drawn2BitmapData:BitmapData = null;
    private var drawnWidth:int = 0;
    private var drawnHeight:int = 0;
    private var squareArray:Array = null;
    private var stealPixelBitmapData:BitmapData = null;
    private var stealPixelSprite:BaseSprite = null;
    private var stealPixelColorText:TextLabel = null;
    private var colorStealTextCDelta:int = 0;
    private var tempColorNumber:Number = 0;
    private var compColorNumber:Number = 0;
    private var eventChanged:Event = null;
    private var eventColorStealFromStageStart:Event = null;
    private var eventColorStealFromStageStop:Event = null;
    /**
     * Constructs the ColorPanel object and builds up its whole content.
     * @param applicationRef the main application reference
     */
    public function ColorPanel(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ColorPanel> called.", 1);
      application.trace("<" + this + " ColorPanel> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventColorStealFromStageStart = new Event(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_START());
      eventColorStealFromStageStop = new Event(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_STOP());
      setValue(application.getComponentsConfig().getColorRgbInputZeros());
      stealPixelBitmapData = new BitmapData(1, 1);
      createContent();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), contentHasToBeRebuilt);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), contentHasToBeRebuilt);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), contentHasToBeRebuilt);
      application.trace("<" + this + " ColorPanel> constructed.", 1);
    }
    /**
     * Returns the committed default color of this panel as a six character rgb string.
     */
    public function getRGBColor():String
    {
      application.trace("<" + this + " ColorPanel getRGBColor> called.", 1);
      if (inputRgb != null)
      {
        return application.getUtils().colorToString(colorToNumber(inputRgb.getText()));
      }
      else
      {
        return String(getValue());
      }
    }
    /**
     * Commits the given color as the default color of this panel and dispatches the changed
     * event of it in every case, even when that color is the current one already.
     * @param newRgbColor the new color as a six character rgb string
     * @param fireChangedEvent whether the changed event has to be dispatched. A color set
     *                         by the code of the application instead of the one using it
     *                         has to be a silent one: the caller knows the new color
     *                         already, and an event of it would be taken as a user action
     */
    public function setRGBColor(newRgbColor:String, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ColorPanel setRGBColor> called.", 1);
      application.trace("<" + this + " ColorPanel setRGBColor> newRgbColor: " + newRgbColor, 0);
      application.trace("<" + this + " ColorPanel setRGBColor> fireChangedEvent: " + fireChangedEvent, 0);
      const rgbColor:String = application.getUtils().colorToString(colorToNumber(newRgbColor));
      if (getValue() != rgbColor)
      {
        setValue(rgbColor);
        tempColorNumber = colorToNumber(rgbColor);
        displayTempAndCompColor(tempColorNumber);
        displayDefaultColor(tempColorNumber);
        inputRgb.setLabel(rgbColor);
        drawBitmap();
        draw2Bitmap();
        markSquare();
      }
      if (fireChangedEvent)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Sets the enabled state of this panel: every clickable object of it has to follow that.
     * @param e whether this panel is enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " ColorPanel setEnabled> called.", 1);
      application.trace("<" + this + " ColorPanel setEnabled> e: " + e, 0);
      super.setEnabled(e);
      setOrClearAllListeners();
    }
    /**
     * The dimensions of this panel come from the size of its own squares, so this does
     * nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ColorPanel setDw> called.", 1);
      application.trace("<" + this + " ColorPanel setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " ColorPanel setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this panel come from the size of its own squares, so this does
     * nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ColorPanel setDh> called.", 1);
      application.trace("<" + this + " ColorPanel setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ColorPanel setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this panel come from the size of its own squares, so this does
     * nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ColorPanel setDwh> called.", 1);
      application.trace("<" + this + " ColorPanel setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ColorPanel setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ColorPanel setDwh> do nothing.", 1);
    }
    /**
     * Finishes the stealing that is in progress and removes the stage listeners of it when
     * this panel leaves the stage: the background has to be released in every case.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " ColorPanel removedFromStage> called.", 1);
      application.trace("<" + this + " ColorPanel removedFromStage> e: " + e, 0);
      if (stealPixelSprite != null)
      {
        stealPixelStop();
      }
      removeStealPixelStageListeners();
      super.removedFromStage(e);
    }
    /**
     * Builds up the whole content of this panel: the header row of the actual, the default
     * and the complementer color followed by the rgb text input and by the button committing
     * that input, then the prepared color squares and the two gradient strips.
     */
    private function createContent():void
    {
      application.trace("<" + this + " ColorPanel createContent> called.", 1);
      if (application == null)
      {
        return;
      }
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      // every dimension of this panel is a multiple of the size of one single square
      const squareWidth:int = int(application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID()) * 2 / 3);
      super.setDw(19 * squareWidth);
      drawnWidth = 19 * squareWidth;
      drawnHeight = squareWidth;
      drawnMatrix = new Matrix();
      drawnMatrix.createGradientBox(drawnWidth, drawnHeight, Math.PI, 0, 0);
      drawn2Matrix = new Matrix();
      drawn2Matrix.createGradientBox(drawnWidth, drawnHeight, Math.PI, 0, 0);
      colorStealTextCDelta = squareWidth;
      if (acceptNewColorButton == null)
      {
        acceptNewColorButton = new ButtonText(application);
        addChild(acceptNewColorButton);
        acceptNewColorButton.setIcon(EnumIcons.ok1());
        acceptNewColorButton.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), acceptNewColorButtonPressed);
        acceptNewColorButton.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), contentHasToBeRebuilt);
      }
      acceptNewColorButton.setCxy(getDw() - acceptNewColorButton.getDw(), 0);
      super.setDh(14 * squareWidth + acceptNewColorButton.getDh() + 2 * lineThickness);
      // the squares begin one square to the right and below the row of the header objects
      const startSquaresX:int = squareWidth;
      const startSquaresY:int = squareWidth + acceptNewColorButton.getCy(true) + 2 * lineThickness;
      // the three color displayers are equal squares standing next to each other in the
      // header row, in this order: the actual color, the committed default one and the
      // complementer of the actual one
      if (panelColorActual == null)
      {
        panelColorActual = new BaseSprite(application);
        addChild(panelColorActual);
      }
      panelColorActual.setDwh(acceptNewColorButton.getDh() + lineThickness, acceptNewColorButton.getDh() + lineThickness);
      panelColorActual.setCxy(0, acceptNewColorButton.getCy());
      if (panelColorDefault == null)
      {
        panelColorDefault = new BaseSprite(application);
        addChild(panelColorDefault);
      }
      panelColorDefault.setDwh(panelColorActual.getDw(), panelColorActual.getDh());
      panelColorDefault.setCxy(panelColorActual.getCx(true), panelColorActual.getCy());
      if (panelColorComplementer == null)
      {
        panelColorComplementer = new BaseSprite(application);
        addChild(panelColorComplementer);
      }
      panelColorComplementer.setDwh(panelColorActual.getDw(), panelColorActual.getDh());
      panelColorComplementer.setCxy(panelColorDefault.getCx(true), panelColorActual.getCy());
      displayTempAndCompColor(tempColorNumber);
      displayDefaultColor(colorToNumber(String(getValue())));
      if (inputRgb == null)
      {
        inputRgb = new TextInput(application);
        addChild(inputRgb);
        // the change event of the inner text field bubbles up to this text input
        inputRgb.addEventListener(Event.CHANGE, onChangeInputRgbText);
        inputRgb.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), inputRgbChanged);
        inputRgb.setMaxChars(application.getComponentsConfig().getColorMaxCharsRgbInput());
        inputRgb.setRestrict(application.getComponentsConfig().getTextEnabledCharsHex());
      }
      // the text input fills what the three color squares and the button leave of the row
      inputRgb.setCxy(panelColorComplementer.getCx(true) + lineThickness, acceptNewColorButton.getCy());
      inputRgb.setLabel(application.getUtils().colorToString(tempColorNumber));
      inputRgb.setDw(getDw() - panelColorComplementer.getCx(true) - acceptNewColorButton.getDw() - 2 * lineThickness);
      createSquares(squareWidth, startSquaresX, startSquaresY);
      const lastSquareCx:int = BaseSprite(squareArray[squareArray.length - 1]).getCx();
      if (drawn2CustomSprite == null)
      {
        drawn2CustomSprite = new BaseSprite(application);
        addChild(drawn2CustomSprite);
        drawn2CustomSprite.mouseDownForScrollingEnabled = false;
      }
      if (drawn2BitmapData != null)
      {
        drawn2BitmapData.dispose();
      }
      drawn2CustomSprite.setDwh(drawnWidth, drawnHeight);
      drawn2CustomSprite.setCxy(lastSquareCx, startSquaresY - squareWidth);
      drawn2BitmapData = new BitmapData(drawn2CustomSprite.getDw(), drawn2CustomSprite.getDh());
      if (drawnCustomSprite == null)
      {
        drawnCustomSprite = new BaseSprite(application);
        addChild(drawnCustomSprite);
        drawnCustomSprite.doubleClickEnabled = true;
        drawnCustomSprite.mouseDownForScrollingEnabled = false;
      }
      if (drawnBitmapData != null)
      {
        drawnBitmapData.dispose();
      }
      drawnCustomSprite.setDwh(drawnWidth, drawnHeight);
      drawnCustomSprite.setCxy(lastSquareCx, startSquaresY + 12 * squareWidth);
      drawnBitmapData = new BitmapData(drawnCustomSprite.getDw(), drawnCustomSprite.getDh());
      drawBitmap();
      draw2Bitmap();
      markSquare();
      setOrClearAllListeners();
    }
    /**
     * Rebuilds the whole content of this panel after a property it is built from has been
     * changed.
     * @param e the line thickness, radius, text format or dimensions changed event
     */
    private function contentHasToBeRebuilt(e:Event):void
    {
      application.trace("<" + this + " ColorPanel contentHasToBeRebuilt> called.", 1);
      application.trace("<" + this + " ColorPanel contentHasToBeRebuilt> e: " + e, 0);
      createContent();
    }
    /**
     * Creates every prepared color square: the 216 squares of the web safe palette and the
     * twelve ones of the grayscale and of the primary colors standing in the first column.
     * @param squareWidth the width and the height of one single square
     * @param startSquaresX the x coordinate the palette begins at
     * @param startSquaresY the y coordinate the squares begin at
     */
    private function createSquares(squareWidth:int, startSquaresX:int, startSquaresY:int):void
    {
      application.trace("<" + this + " ColorPanel createSquares> called.", 1);
      application.trace("<" + this + " ColorPanel createSquares> squareWidth: " + squareWidth, 0);
      application.trace("<" + this + " ColorPanel createSquares> startSquaresX: " + startSquaresX, 0);
      application.trace("<" + this + " ColorPanel createSquares> startSquaresY: " + startSquaresY, 0);
      removeAllSquares();
      squareArray = new Array();
      // the six values every color component of the web safe palette can take
      const steps:Array = [0, 3, 6, 9, 12, 15];
      for (var ri:int = 0; ri < steps.length; ri++)
      {
        for (var gi:int = 0; gi < steps.length; gi++)
        {
          for (var bi:int = 0; bi < steps.length; bi++)
          {
            // the palette is broken into two halves of six rows: the darker reds stand in
            // the upper one, the brighter ones below them in the very same columns
            addSquare(hexPair(steps[ri]) + hexPair(steps[gi]) + hexPair(steps[bi])
              , startSquaresX + (ri % 3 * steps.length + gi) * squareWidth
              , startSquaresY + (ri >= 3 ? steps.length + bi : bi) * squareWidth
              , squareWidth);
          }
        }
      }
      for (var si:int = 0; si < steps.length; si++)
      {
        addSquare(hexPair(steps[si]) + hexPair(steps[si]) + hexPair(steps[si])
          , 0, startSquaresY + si * squareWidth, squareWidth);
      }
      const primaries:Array = ["FF0000", "00FF00", "0000FF", "FFFF00", "00FFFF", "FF00FF"];
      for (var pi:int = 0; pi < primaries.length; pi++)
      {
        addSquare(String(primaries[pi]), 0
          , startSquaresY + (steps.length + pi) * squareWidth, squareWidth);
      }
    }
    /**
     * Returns the two character hexadecimal code of one single color component of the web
     * safe palette.
     * @param step the value of that component, from zero to fifteen by three
     */
    private function hexPair(step:int):String
    {
      application.trace("<" + this + " ColorPanel hexPair> called.", 1);
      application.trace("<" + this + " ColorPanel hexPair> step: " + step, 0);
      if (step == 12)
      {
        return "CC";
      }
      else if (step == 15)
      {
        return "FF";
      }
      else
      {
        return step + "" + step;
      }
    }
    /**
     * Creates one single prepared color square and adds it to this panel.
     * @param rgbColor the color of that square as a six character rgb string
     * @param cx the x coordinate of that square
     * @param cy the y coordinate of that square
     * @param squareWidth the width and the height of that square
     */
    private function addSquare(rgbColor:String, cx:int, cy:int, squareWidth:int):void
    {
      application.trace("<" + this + " ColorPanel addSquare> called.", 1);
      application.trace("<" + this + " ColorPanel addSquare> rgbColor: " + rgbColor, 0);
      application.trace("<" + this + " ColorPanel addSquare> cx: " + cx, 0);
      application.trace("<" + this + " ColorPanel addSquare> cy: " + cy, 0);
      application.trace("<" + this + " ColorPanel addSquare> squareWidth: " + squareWidth, 0);
      const square:BaseSprite = new BaseSprite(application);
      addChild(square);
      square.setDwh(squareWidth, squareWidth);
      square.setCxy(cx, cy);
      square.setValue(rgbColor);
      square.doubleClickEnabled = true;
      drawSquare(square, application.getComponentsConfig().getColorSquareLineAlphaMouseOut());
      squareArray.push(square);
    }
    /**
     * Draws one single prepared color square with the given alpha on the line of it.
     * @param square the square to be drawn
     * @param lineAlpha the alpha of the line of that square
     */
    private function drawSquare(square:BaseSprite, lineAlpha:Number):void
    {
      application.trace("<" + this + " ColorPanel drawSquare> called.", 1);
      application.trace("<" + this + " ColorPanel drawSquare> square: " + square, 0);
      application.trace("<" + this + " ColorPanel drawSquare> lineAlpha: " + lineAlpha, 0);
      if (square != null)
      {
        const thickness:int = application.getComponentsConfig().getDrawOtherLineThickness();
        square.graphics.clear();
        square.graphics.beginFill(colorToNumber(String(square.getValue()))
          , application.getComponentsConfig().getColorSquareLineAlphaMouseOver());
        square.graphics.drawRect(0, 0, square.getDw(), square.getDh());
        square.graphics.endFill();
        square.graphics.lineStyle(thickness, application.getComponentsConfig().getColorSquareLineColor(), lineAlpha, true);
        square.graphics.drawRect(thickness / 2, thickness / 2, square.getDw() - thickness, square.getDh() - thickness);
      }
    }
    /**
     * Destroys and removes every prepared color square of this panel.
     */
    private function removeAllSquares():void
    {
      application.trace("<" + this + " ColorPanel removeAllSquares> called.", 1);
      if (squareArray != null)
      {
        for (var i:int = 0; i < squareArray.length; i++)
        {
          const square:BaseSprite = BaseSprite(squareArray[i]);
          removeSquareListeners(square);
          square.destroy();
          if (contains(square))
          {
            removeChild(square);
          }
          squareArray[i] = null;
        }
        squareArray.splice(0);
        squareArray = null;
      }
    }
    /**
     * Marks the square of the actual color and unmarks every other one of them.
     */
    private function markSquare():void
    {
      application.trace("<" + this + " ColorPanel markSquare> called.", 1);
      if (squareArray != null)
      {
        var marked:Boolean = false;
        for (var i:int = 0; i < squareArray.length; i++)
        {
          const square:BaseSprite = BaseSprite(squareArray[i]);
          if (!marked && colorToNumber(String(square.getValue())) == tempColorNumber)
          {
            drawSquare(square, application.getComponentsConfig().getColorSquareLineAlphaMouseOver());
            marked = true;
          }
          else
          {
            drawSquare(square, application.getComponentsConfig().getColorSquareLineAlphaMouseOut());
          }
        }
      }
    }
    /**
     * Marks the square the mouse has been moved over.
     * @param e the mouse over event of that square
     */
    private function drawSquareOver(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel drawSquareOver> called.", 1);
      application.trace("<" + this + " ColorPanel drawSquareOver> e: " + e, 0);
      if (e != null && e.currentTarget is BaseSprite)
      {
        drawSquare(BaseSprite(e.currentTarget), application.getComponentsConfig().getColorSquareLineAlphaMouseOver());
      }
    }
    /**
     * Takes the marking of the squares back after the mouse has left one of them.
     * @param e the mouse out event of that square
     */
    private function drawSquareOut(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel drawSquareOut> called.", 1);
      application.trace("<" + this + " ColorPanel drawSquareOut> e: " + e, 0);
      if (e != null && e.currentTarget is BaseSprite)
      {
        markSquare();
      }
    }
    /**
     * Takes the color of the pressed square as the actual color of this panel.
     * @param e the mouse down event of that square
     */
    private function drawSquareMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel drawSquareMouseDown> called.", 1);
      application.trace("<" + this + " ColorPanel drawSquareMouseDown> e: " + e, 0);
      if (e != null && e.currentTarget is BaseSprite)
      {
        applyTempColor(colorToNumber(String(BaseSprite(e.currentTarget).getValue())));
      }
    }
    /**
     * Commits the color of the double clicked square as the default color of this panel.
     * @param e the double click event of that square
     */
    private function drawSquareDoubleClick(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel drawSquareDoubleClick> called.", 1);
      application.trace("<" + this + " ColorPanel drawSquareDoubleClick> e: " + e, 0);
      if (e != null && e.currentTarget is BaseSprite)
      {
        setRGBColor(application.getUtils().colorToString(colorToNumber(String(BaseSprite(e.currentTarget).getValue()))));
      }
    }
    /**
     * Draws the gradient strip standing below the squares: from dark to the actual color and
     * from that to bright.
     */
    private function drawBitmap():void
    {
      application.trace("<" + this + " ColorPanel drawBitmap> called.", 1);
      if (drawnCustomSprite != null && drawnBitmapData != null)
      {
        const radius:int = application.getDynamicsConfig().getAppRadius();
        drawnCustomSprite.graphics.clear();
        drawnCustomSprite.graphics.beginGradientFill(GradientType.LINEAR
          , [application.getComponentsConfig().getColorDrawedColorArrayDark(), tempColorNumber
          , application.getComponentsConfig().getColorDrawedColorArrayBright()]
          , application.getComponentsConfig().getColorDrawedAlphaArray()
          , application.getComponentsConfig().getColorDrawedRatioArray(), drawnMatrix);
        drawnCustomSprite.graphics.moveTo(0, 0);
        drawnCustomSprite.graphics.lineTo(drawnWidth, 0);
        drawnCustomSprite.graphics.lineTo(drawnWidth, drawnHeight - radius);
        drawnCustomSprite.graphics.curveTo(drawnWidth, drawnHeight, drawnWidth - radius, drawnHeight);
        drawnCustomSprite.graphics.lineTo(radius, drawnHeight);
        drawnCustomSprite.graphics.curveTo(0, drawnHeight, 0, drawnHeight - radius);
        drawnCustomSprite.graphics.lineTo(0, 0);
        drawnCustomSprite.graphics.endFill();
        drawnBitmapData.draw(drawnCustomSprite);
      }
    }
    /**
     * Draws the gradient strip standing above the squares: the very same one of the
     * complementer color.
     */
    private function draw2Bitmap():void
    {
      application.trace("<" + this + " ColorPanel draw2Bitmap> called.", 1);
      if (drawn2CustomSprite != null && drawn2BitmapData != null)
      {
        const radius:int = application.getDynamicsConfig().getAppRadius();
        drawn2CustomSprite.graphics.clear();
        drawn2CustomSprite.graphics.beginGradientFill(GradientType.LINEAR
          , [application.getComponentsConfig().getColorDrawedColorArrayBright(), compColorNumber
          , application.getComponentsConfig().getColorDrawedColorArrayDark()]
          , application.getComponentsConfig().getColorDrawedAlphaArray()
          , application.getComponentsConfig().getColorDrawedRatioArray(), drawn2Matrix);
        drawn2CustomSprite.graphics.moveTo(0, 0);
        drawn2CustomSprite.graphics.lineTo(drawnWidth - radius, 0);
        drawn2CustomSprite.graphics.curveTo(drawnWidth, 0, drawnWidth, drawnHeight - radius);
        drawn2CustomSprite.graphics.lineTo(drawnWidth, drawnHeight);
        drawn2CustomSprite.graphics.lineTo(0, drawnHeight);
        drawn2CustomSprite.graphics.lineTo(0, 0);
        drawn2CustomSprite.graphics.endFill();
        drawn2BitmapData.draw(drawn2CustomSprite);
      }
    }
    /**
     * Displays the actual color of this panel together with the complementer of it.
     * @param color the actual color as a number
     */
    private function displayTempAndCompColor(color:Number):void
    {
      application.trace("<" + this + " ColorPanel displayTempAndCompColor> called.", 1);
      application.trace("<" + this + " ColorPanel displayTempAndCompColor> color: " + color, 0);
      compColorNumber = application.getComponentsConfig().getColorToCalcComplementer() - color;
      drawColorPanel(panelColorActual, color);
      drawColorPanel(panelColorComplementer, compColorNumber);
    }
    /**
     * Displays the committed default color of this panel.
     * @param color the default color as a number
     */
    private function displayDefaultColor(color:Number):void
    {
      application.trace("<" + this + " ColorPanel displayDefaultColor> called.", 1);
      application.trace("<" + this + " ColorPanel displayDefaultColor> color: " + color, 0);
      drawColorPanel(panelColorDefault, color);
    }
    /**
     * Fills one of the three color displaying squares of this panel, with every corner of it
     * rounded by the radius of the application.
     * @param sprite the square to be filled
     * @param color the color to fill that square with
     */
    private function drawColorPanel(sprite:BaseSprite, color:Number):void
    {
      application.trace("<" + this + " ColorPanel drawColorPanel> called.", 1);
      application.trace("<" + this + " ColorPanel drawColorPanel> sprite: " + sprite, 0);
      application.trace("<" + this + " ColorPanel drawColorPanel> color: " + color, 0);
      if (sprite != null)
      {
        const radius:int = application.getDynamicsConfig().getAppRadius();
        const dw:int = sprite.getDw();
        const dh:int = sprite.getDh();
        sprite.graphics.clear();
        sprite.graphics.beginFill(color, application.getComponentsConfig().getColorSquareLineAlphaMouseOver());
        sprite.graphics.drawRoundRect(0, 0, dw, dh, radius);
        sprite.graphics.endFill();
      }
    }
    /**
     * Commits the color of the double clicked point of the gradient strip as the default
     * color of this panel.
     * @param e the double click event of that strip
     */
    private function drawnCustomSpriteDoubleClick(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel drawnCustomSpriteDoubleClick> called.", 1);
      application.trace("<" + this + " ColorPanel drawnCustomSpriteDoubleClick> e: " + e, 0);
      if (e != null && drawnBitmapData != null)
      {
        setRGBColor(application.getUtils().colorToString(drawnBitmapData.getPixel(e.localX, e.localY)));
      }
    }
    /**
     * Takes the color of the dragged point of the gradient strip as the actual color.
     * @param e the mouse down or mouse move event of that strip
     */
    private function updateBitmapColor(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel updateBitmapColor> called.", 0);
      if (e != null && drawnBitmapData != null && inputRgb != null && e.buttonDown)
      {
        // the strip of the actual color is not redrawn here: that would move the very color
        // standing under the mouse away from it
        tempColorNumber = drawnBitmapData.getPixel(e.localX, e.localY);
        displayTempAndCompColor(tempColorNumber);
        inputRgb.setLabel(application.getUtils().colorToString(tempColorNumber));
        draw2Bitmap();
        markSquare();
      }
    }
    /**
     * Takes the color of the pressed point of the complementer gradient strip as the actual
     * color.
     * @param e the mouse down event of that strip
     */
    private function update2BitmapColor(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel update2BitmapColor> called.", 1);
      application.trace("<" + this + " ColorPanel update2BitmapColor> e: " + e, 0);
      if (e != null && drawn2BitmapData != null && e.buttonDown)
      {
        applyTempColor(drawn2BitmapData.getPixel(e.localX, e.localY));
      }
    }
    /**
     * Takes the committed default color of this panel back as the actual color of it.
     * @param e the click event of the sprite of the default color
     */
    private function setDefaultColor(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel setDefaultColor> called.", 1);
      application.trace("<" + this + " ColorPanel setDefaultColor> e: " + e, 0);
      applyTempColor(colorToNumber(String(getValue())));
    }
    /**
     * Swaps the complementer and the actual colors of this panel.
     * @param e the mouse down event of the sprite of the complementer color
     */
    private function setComplementerToTemp(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel setComplementerToTemp> called.", 1);
      application.trace("<" + this + " ColorPanel setComplementerToTemp> e: " + e, 0);
      applyTempColor(compColorNumber);
    }
    /**
     * Displays the complementer color in the rgb text input while the mouse stands over the
     * sprite of that color.
     * @param e the mouse over event of the sprite of the complementer color
     */
    private function displayCompColor(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel displayCompColor> called.", 1);
      application.trace("<" + this + " ColorPanel displayCompColor> e: " + e, 0);
      if (inputRgb != null)
      {
        inputRgb.setLabel(application.getUtils().colorToString(compColorNumber));
      }
    }
    /**
     * Displays the actual color in the rgb text input again after the mouse has left the
     * sprite of the complementer color.
     * @param e the mouse out event of the sprite of the complementer color
     */
    private function displayTempColor(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel displayTempColor> called.", 1);
      application.trace("<" + this + " ColorPanel displayTempColor> e: " + e, 0);
      if (inputRgb != null)
      {
        inputRgb.setLabel(application.getUtils().colorToString(tempColorNumber));
      }
    }
    /**
     * Takes the given color as the actual color of this panel and refreshes everything that
     * displays it.
     * @param color the new actual color as a number
     */
    private function applyTempColor(color:Number):void
    {
      application.trace("<" + this + " ColorPanel applyTempColor> called.", 1);
      application.trace("<" + this + " ColorPanel applyTempColor> color: " + color, 0);
      if (inputRgb != null)
      {
        tempColorNumber = color;
        displayTempAndCompColor(tempColorNumber);
        inputRgb.setLabel(application.getUtils().colorToString(tempColorNumber));
        drawBitmap();
        draw2Bitmap();
        markSquare();
      }
    }
    /**
     * Follows the color typed into the rgb text input without committing it.
     * @param e the change event of that text input
     */
    private function onChangeInputRgbText(e:Event):void
    {
      application.trace("<" + this + " ColorPanel onChangeInputRgbText> called.", 1);
      application.trace("<" + this + " ColorPanel onChangeInputRgbText> e: " + e, 0);
      if (inputRgb != null)
      {
        inputRgb.setTextToUpperCase();
        tempColorNumber = colorToNumber(inputRgb.getText());
        displayTempAndCompColor(tempColorNumber);
        drawBitmap();
        draw2Bitmap();
        markSquare();
      }
    }
    /**
     * Commits the typed color as the default one after the enter key has been pressed in the
     * rgb text input.
     * @param e the changed event of that text input
     */
    private function inputRgbChanged(e:Event):void
    {
      application.trace("<" + this + " ColorPanel inputRgbChanged> called.", 1);
      application.trace("<" + this + " ColorPanel inputRgbChanged> e: " + e, 0);
      if (inputRgb != null)
      {
        acceptNewColorButtonPressed();
      }
    }
    /**
     * Commits the typed color as the default one after the button of that has been pressed.
     * @param e the click event of that button
     */
    private function acceptNewColorButtonPressed(e:Event = null):void
    {
      application.trace("<" + this + " ColorPanel acceptNewColorButtonPressed> called.", 1);
      application.trace("<" + this + " ColorPanel acceptNewColorButtonPressed> e: " + e, 0);
      if (acceptNewColorButton != null && inputRgb != null)
      {
        setRGBColor(inputRgb.getText());
        acceptNewColorButton.setEnabled(true);
      }
    }
    /**
     * Starts the stealing of the color of any pixel of the stage: takes a snapshot of that
     * stage and follows the mouse above it until the button of it is released.
     * @param e the mouse down event of the sprite of the actual color
     */
    private function stealPixel(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel stealPixel> called.", 1);
      application.trace("<" + this + " ColorPanel stealPixel> e: " + e, 0);
      if (stage != null && inputRgb != null)
      {
        // the stage has to stand still before the snapshot of it is taken below
        setBackgroundPixelStealing(true);
        getBaseEventDispatcher().dispatchEvent(eventColorStealFromStageStart);
        stage.addEventListener(MouseEvent.MOUSE_UP, getColorFromStage, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stealPixelMouseMove, false, 0, true);
        stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_UP, stealPixelKeyUp, false, 0, true);
        stealPixelSprite = new BaseSprite(application);
        application.addChild(stealPixelSprite);
        stageResized();
        stealPixelColorText = new TextLabel(application);
        application.addChild(stealPixelColorText);
        stealPixelColorText.setLabel(application.getUtils().colorToString(stealPixelBitmapData.getPixel(stage.mouseX, stage.mouseY)));
        stealPixelColorText.setCxy(stage.mouseX + colorStealTextCDelta
          , stage.mouseY - stealPixelColorText.getDh() - colorStealTextCDelta);
        stealPixelColorText.getBaseTextField().background = true;
        stealPixelColorText.getBaseTextField().backgroundColor = colorToNumber(stealPixelColorText.getBaseTextField().getText());
      }
    }
    /**
     * Takes the color of the pixel the mouse has been released above as the actual color of
     * this panel and finishes the stealing.
     * @param e the mouse up event of the stage
     */
    private function getColorFromStage(e:Event):void
    {
      application.trace("<" + this + " ColorPanel getColorFromStage> called.", 1);
      application.trace("<" + this + " ColorPanel getColorFromStage> e: " + e, 0);
      if (stealPixelBitmapData != null && stage != null)
      {
        applyTempColor(stealPixelBitmapData.getPixel(stage.mouseX, stage.mouseY));
        stealPixelStop();
      }
    }
    /**
     * Displays the color of the pixel the mouse currently stands above.
     * @param e the mouse move event of the stage
     */
    private function stealPixelMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPanel stealPixelMouseMove> called.", 0);
      if (stealPixelColorText != null && stealPixelBitmapData != null && stage != null)
      {
        stealPixelColorText.setLabel(application.getUtils().colorToString(stealPixelBitmapData.getPixel(stage.mouseX, stage.mouseY)));
        stealPixelColorText.getBaseTextField().backgroundColor = colorToNumber(stealPixelColorText.getBaseTextField().getText());
        stealPixelColorText.getBaseTextField().borderColor = stealPixelColorText.getBaseTextField().backgroundColor;
        stealPixelColorText.setCxy(stage.mouseX + colorStealTextCDelta
          , stage.mouseY - stealPixelColorText.getDh() - colorStealTextCDelta);
        // the displayed color has to stay inside the stage
        if (stealPixelColorText.getCx() > stage.stageWidth - stealPixelColorText.getDw())
        {
          stealPixelColorText.setCx(stage.mouseX - colorStealTextCDelta - stealPixelColorText.getDw());
        }
        if (stealPixelColorText.getCy() < 0)
        {
          stealPixelColorText.setCy(stage.mouseY + colorStealTextCDelta);
        }
      }
    }
    /**
     * Finishes the stealing when the escape key has been pressed.
     * @param e the key up event of the stage
     */
    private function stealPixelKeyUp(e:KeyboardEvent):void
    {
      application.trace("<" + this + " ColorPanel stealPixelKeyUp> called.", 1);
      application.trace("<" + this + " ColorPanel stealPixelKeyUp> e: " + e, 0);
      if (e != null)
      {
        if (e.keyCode == Keyboard.ESCAPE)
        {
          stealPixelStop();
        }
        e.stopImmediatePropagation();
      }
    }
    /**
     * Takes a new snapshot of the stage during the stealing after that stage has been
     * resized.
     * @param e the resize event of the stage
     */
    private function stageResized(e:Event = null):void
    {
      application.trace("<" + this + " ColorPanel stageResized> called.", 1);
      application.trace("<" + this + " ColorPanel stageResized> e: " + e, 0);
      if (stage != null && stealPixelSprite != null)
      {
        // the displayed color itself has to be left out of the snapshot
        if (stealPixelColorText != null)
        {
          stealPixelColorText.visible = false;
        }
        stealPixelSprite.graphics.clear();
        stealPixelSprite.graphics.beginFill(0, 0);
        stealPixelSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        stealPixelSprite.graphics.endFill();
        if (stealPixelBitmapData != null)
        {
          stealPixelBitmapData.dispose();
        }
        stealPixelBitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);
        stealPixelBitmapData.draw(stage);
        if (stealPixelColorText != null)
        {
          stealPixelColorText.visible = true;
        }
      }
    }
    /**
     * Finishes the stealing of the color of a pixel of the stage: frees up everything that
     * belongs to it.
     */
    private function stealPixelStop():void
    {
      application.trace("<" + this + " ColorPanel stealPixelStop> called.", 1);
      removeStealPixelStageListeners();
      if (stealPixelColorText != null)
      {
        stealPixelColorText.filters = null;
        stealPixelColorText.destroy();
        if (application.contains(stealPixelColorText))
        {
          application.removeChild(stealPixelColorText);
        }
        stealPixelColorText = null;
      }
      if (stealPixelSprite != null)
      {
        stealPixelSprite.destroy();
        if (application.contains(stealPixelSprite))
        {
          application.removeChild(stealPixelSprite);
        }
        stealPixelSprite = null;
      }
      if (stealPixelBitmapData != null)
      {
        stealPixelBitmapData.dispose();
      }
      stealPixelBitmapData = new BitmapData(1, 1);
      markSquare();
      setBackgroundPixelStealing(false);
      getBaseEventDispatcher().dispatchEvent(eventColorStealFromStageStop);
    }
    /**
     * Tells the background of the application whether a pixel of the stage is being stolen
     * right now. A live background image moves while the mouse is moving above it, so the
     * colors read from the snapshot would differ from the ones seen by the one using the
     * application: that image has to stay exactly where it is until the stealing is over.
     * @param b whether the stealing is in progress right now
     */
    private function setBackgroundPixelStealing(b:Boolean):void
    {
      application.trace("<" + this + " ColorPanel setBackgroundPixelStealing> called.", 1);
      application.trace("<" + this + " ColorPanel setBackgroundPixelStealing> b: " + b, 0);
      if (application.getBackground() != null)
      {
        application.getBackground().stealPixel(b);
      }
    }
    /**
     * Removes every listener the stealing of a pixel has added to the stage.
     */
    private function removeStealPixelStageListeners():void
    {
      application.trace("<" + this + " ColorPanel removeStealPixelStageListeners> called.", 1);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, getColorFromStage);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stealPixelMouseMove);
        stage.removeEventListener(Event.RESIZE, stageResized);
        stage.removeEventListener(KeyboardEvent.KEY_UP, stealPixelKeyUp);
      }
    }
    /**
     * Sets or clears every listener of this panel according to the enabled state of it.
     */
    private function setOrClearAllListeners():void
    {
      application.trace("<" + this + " ColorPanel setOrClearAllListeners> called.", 1);
      if (acceptNewColorButton != null)
      {
        acceptNewColorButton.setEnabled(getEnabled());
      }
      if (inputRgb != null)
      {
        inputRgb.setEnabled(getEnabled());
      }
      if (getEnabled())
      {
        addAllListeners();
      }
      else
      {
        removeAllListeners();
      }
    }
    /**
     * Adds every mouse listener of the clickable objects of this panel.
     */
    private function addAllListeners():void
    {
      application.trace("<" + this + " ColorPanel addAllListeners> called.", 1);
      if (panelColorActual != null)
      {
        panelColorActual.addEventListener(MouseEvent.MOUSE_DOWN, stealPixel);
      }
      if (panelColorComplementer != null)
      {
        panelColorComplementer.addEventListener(MouseEvent.MOUSE_DOWN, setComplementerToTemp);
        panelColorComplementer.addEventListener(MouseEvent.MOUSE_OVER, displayCompColor);
        panelColorComplementer.addEventListener(MouseEvent.MOUSE_OUT, displayTempColor);
      }
      if (panelColorDefault != null)
      {
        panelColorDefault.addEventListener(MouseEvent.CLICK, setDefaultColor);
      }
      if (drawnCustomSprite != null)
      {
        drawnCustomSprite.addEventListener(MouseEvent.MOUSE_DOWN, updateBitmapColor);
        drawnCustomSprite.addEventListener(MouseEvent.MOUSE_MOVE, updateBitmapColor);
        drawnCustomSprite.addEventListener(MouseEvent.DOUBLE_CLICK, drawnCustomSpriteDoubleClick);
      }
      if (drawn2CustomSprite != null)
      {
        drawn2CustomSprite.addEventListener(MouseEvent.MOUSE_DOWN, update2BitmapColor);
      }
      if (squareArray != null)
      {
        for (var i:int = 0; i < squareArray.length; i++)
        {
          const square:BaseSprite = BaseSprite(squareArray[i]);
          square.addEventListener(MouseEvent.MOUSE_DOWN, drawSquareMouseDown);
          square.addEventListener(MouseEvent.MOUSE_OVER, drawSquareOver);
          square.addEventListener(MouseEvent.MOUSE_OUT, drawSquareOut);
          square.addEventListener(MouseEvent.DOUBLE_CLICK, drawSquareDoubleClick);
        }
      }
    }
    /**
     * Removes every mouse listener of the clickable objects of this panel.
     */
    private function removeAllListeners():void
    {
      application.trace("<" + this + " ColorPanel removeAllListeners> called.", 1);
      if (panelColorActual != null)
      {
        panelColorActual.removeEventListener(MouseEvent.MOUSE_DOWN, stealPixel);
      }
      if (panelColorComplementer != null)
      {
        panelColorComplementer.removeEventListener(MouseEvent.MOUSE_DOWN, setComplementerToTemp);
        panelColorComplementer.removeEventListener(MouseEvent.MOUSE_OVER, displayCompColor);
        panelColorComplementer.removeEventListener(MouseEvent.MOUSE_OUT, displayTempColor);
      }
      if (panelColorDefault != null)
      {
        panelColorDefault.removeEventListener(MouseEvent.CLICK, setDefaultColor);
      }
      if (drawnCustomSprite != null)
      {
        drawnCustomSprite.removeEventListener(MouseEvent.MOUSE_DOWN, updateBitmapColor);
        drawnCustomSprite.removeEventListener(MouseEvent.MOUSE_MOVE, updateBitmapColor);
        drawnCustomSprite.removeEventListener(MouseEvent.DOUBLE_CLICK, drawnCustomSpriteDoubleClick);
      }
      if (drawn2CustomSprite != null)
      {
        drawn2CustomSprite.removeEventListener(MouseEvent.MOUSE_DOWN, update2BitmapColor);
      }
      if (squareArray != null)
      {
        for (var i:int = 0; i < squareArray.length; i++)
        {
          removeSquareListeners(BaseSprite(squareArray[i]));
        }
      }
    }
    /**
     * Removes every mouse listener of one single prepared color square.
     * @param square the square the listeners have to be removed from
     */
    private function removeSquareListeners(square:BaseSprite):void
    {
      application.trace("<" + this + " ColorPanel removeSquareListeners> called.", 1);
      application.trace("<" + this + " ColorPanel removeSquareListeners> square: " + square, 0);
      if (square != null)
      {
        square.removeEventListener(MouseEvent.MOUSE_DOWN, drawSquareMouseDown);
        square.removeEventListener(MouseEvent.MOUSE_OVER, drawSquareOver);
        square.removeEventListener(MouseEvent.MOUSE_OUT, drawSquareOut);
        square.removeEventListener(MouseEvent.DOUBLE_CLICK, drawSquareDoubleClick);
      }
    }
    /**
     * Returns the number of a color given as an rgb string, padded by leading zeros to the six
     * characters a color needs.
     * @param rgbColor that color as an rgb string, an empty or a shorter one as well
     */
    private function colorToNumber(rgbColor:String):Number
    {
      application.trace("<" + this + " ColorPanel colorToNumber> called.", 1);
      application.trace("<" + this + " ColorPanel colorToNumber> rgbColor: " + rgbColor, 0);
      // the text input can stand empty or can hold a part of a color only, and the number of
      // an unpadded one of those would be NaN, poisoning every color of this panel from then
      const padded:String = application.getComponentsConfig().getColorRgbInputZeros() + (rgbColor == null ? "" : rgbColor);
      const color:Number = Number(application.getComponentsConfig().getColorHexToNumberString() + padded.substr(padded.length - 6));
      // setRGBColor is a public method, so a color that is not a hexadecimal one at all can
      // arrive here as well: the black of the zeros is taken instead of a NaN in that case
      return isNaN(color) ? Number(application.getComponentsConfig().getColorHexToNumberString()
        + application.getComponentsConfig().getColorRgbInputZeros()) : color;
    }
    /**
     * Frees all listeners, events, bitmaps and references held by this panel.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ColorPanel destroy> called.", 1);
      application.trace("<" + this + " ColorPanel destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      if (stealPixelSprite != null)
      {
        stealPixelStop();
      }
      removeStealPixelStageListeners();
      removeAllListeners();
      if (inputRgb != null)
      {
        inputRgb.removeEventListener(Event.CHANGE, onChangeInputRgbText);
      }
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), contentHasToBeRebuilt);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), contentHasToBeRebuilt);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), contentHasToBeRebuilt);
      application.trace("<" + this + " ColorPanel destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      eventColorStealFromStageStart.stopImmediatePropagation();
      eventColorStealFromStageStop.stopImmediatePropagation();
      if (drawnBitmapData != null)
      {
        drawnBitmapData.dispose();
      }
      if (drawn2BitmapData != null)
      {
        drawn2BitmapData.dispose();
      }
      if (stealPixelBitmapData != null)
      {
        stealPixelBitmapData.dispose();
      }
      if (squareArray != null)
      {
        squareArray.splice(0);
      }
      application.trace("<" + this + " ColorPanel destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " ColorPanel destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      inputRgb = null;
      acceptNewColorButton = null;
      panelColorDefault = null;
      panelColorActual = null;
      panelColorComplementer = null;
      drawnCustomSprite = null;
      drawnMatrix = null;
      drawnBitmapData = null;
      drawn2CustomSprite = null;
      drawn2Matrix = null;
      drawn2BitmapData = null;
      drawnWidth = 0;
      drawnHeight = 0;
      squareArray = null;
      stealPixelBitmapData = null;
      stealPixelSprite = null;
      stealPixelColorText = null;
      colorStealTextCDelta = 0;
      tempColorNumber = 0;
      compColorNumber = 0;
      eventChanged = null;
      eventColorStealFromStageStart = null;
      eventColorStealFromStageStop = null;
    }
  }
}
