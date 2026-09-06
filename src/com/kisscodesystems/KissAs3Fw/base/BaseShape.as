package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.display.GradientType;
  import flash.display.InterpolationMethod;
  import flash.display.Shape;
  import flash.display.SpreadMethod;
  import flash.events.Event;
  import flash.geom.Matrix;
  import flash.system.System;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  public class BaseShape extends Shape
  {
    protected var application:Application = null;
    private var brightMatrix:Matrix = null;
    private var baseMatrix:Matrix = null;
    private var lineMatrix:Matrix = null;
    private var rectangleDrawn:Boolean = false;
    private var dw:int = 0;
    private var dh:int = 0;
    private var type:int = EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT();
    private var radius:int = 0;
    private var isBright:Boolean = false;
    private var isFilled:Boolean = true;
    private var lineColor:Number = 0;
    private var fillColor1:Number = 0;
    private var fillColor2:Number = 0;
    private var fillAlpha:Number = 0;
    private var brightColor1:Number = 0;
    private var boxCorner:int = 8;
    private var boxFrame:String = EnumBoxFrames.BOX_FRAME_FULL();
    /**
     * Constructs the shape, stores the application reference and registers the stage and line thickness listeners.
     * @param applicationRef the application reference used for tracing and configuration
     */
    public function BaseShape(applicationRef:Application):void
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
      application.trace("<" + this + " BaseShape> called.", 1);
      application.trace("<" + this + " BaseShape> applicationRef: " + applicationRef, 0);
      addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.trace("<" + this + " BaseShape> constructed.", 1);
    }
    /**
     * Clears everything drawn into this shape's graphics.
     * There is no rectangle standing on this shape after this, so the appearance changes of
     * the application do not draw one on it either: the object holding this shape draws it
     * again when it needs it, in the state it needs it in. A button link clears the shape of
     * its background when the mouse leaves it, and a line thickness change used to bring
     * that background back, in the state the button was in when it was drawn the last time.
     */
    public function clear():void
    {
      application.trace("<" + this + " BaseShape clear> called.", 1);
      graphics.clear();
      rectangleDrawn = false;
    }
    /**
     * Sets the corner radius used when drawing the rectangle.
     * @param radius the corner radius in pixels
     */
    public function setRadius(radius:int):void
    {
      application.trace("<" + this + " BaseShape setRadius> called.", 1);
      application.trace("<" + this + " BaseShape setRadius> radius: " + radius, 0);
      this.radius = radius;
    }
    /**
     * Returns the currently set corner radius.
     */
    public function getRadius():int
    {
      return radius;
    }
    /**
     * Stores the line, fill and bright colors together with the fill alpha.
     * @param newLineColor the new line color
     * @param newFillColor1 the new first fill color
     * @param newFillColor2 the new second fill color
     * @param newFillAlpha the new fill alpha
     * @param newBrightColor1 the new first bright color
     */
    public function setColorsAndAlpha(newLineColor:Number, newFillColor1:Number, newFillColor2:Number, newFillAlpha:Number, newBrightColor1:Number):void
    {
      application.trace("<" + this + " BaseShape setColorsAndAlpha> called.", 1);
      application.trace("<" + this + " BaseShape setColorsAndAlpha> lineColor: " + newLineColor, 0);
      application.trace("<" + this + " BaseShape setColorsAndAlpha> fillColor1: " + newFillColor1, 0);
      application.trace("<" + this + " BaseShape setColorsAndAlpha> fillColor2: " + newFillColor2, 0);
      application.trace("<" + this + " BaseShape setColorsAndAlpha> fillAlpha: " + newFillAlpha, 0);
      application.trace("<" + this + " BaseShape setColorsAndAlpha> brightColor1: " + newBrightColor1, 0);
      lineColor = newLineColor;
      fillColor1 = newFillColor1;
      fillColor2 = newFillColor2;
      fillAlpha = newFillAlpha;
      brightColor1 = newBrightColor1;
    }
    /**
     * Returns the line color.
     */
    public function getLineColor():Number
    {
      return lineColor;
    }
    /**
     * Returns the first fill color.
     */
    public function getFillColor1():Number
    {
      return fillColor1;
    }
    /**
     * Returns the second fill color.
     */
    public function getFillColor2():Number
    {
      return fillColor2;
    }
    /**
     * Returns the fill alpha.
     */
    public function getFillAlpha():Number
    {
      return fillAlpha;
    }
    /**
     * Returns the first bright color.
     */
    public function getBrightColor1():Number
    {
      return brightColor1;
    }
    /**
     * Sets whether the rectangle is filled.
     * @param isFilled true when the rectangle should be filled
     */
    public function setIsFilled(isFilled:Boolean):void
    {
      application.trace("<" + this + " BaseShape setIsFilled> called.", 1);
      application.trace("<" + this + " BaseShape setIsFilled> isFilled: " + isFilled, 0);
      this.isFilled = isFilled;
    }
    /**
     * Returns whether the rectangle is filled.
     */
    public function getIsFilled():Boolean
    {
      return isFilled;
    }
    /**
     * Sets whether the bright gradient overlay is drawn.
     * @param isBright true when the bright overlay should be drawn
     */
    public function setIsBright(isBright:Boolean):void
    {
      application.trace("<" + this + " BaseShape setIsBright> called.", 1);
      application.trace("<" + this + " BaseShape setIsBright> isBright: " + isBright, 0);
      this.isBright = isBright;
    }
    /**
     * Returns whether the bright gradient overlay is drawn.
     */
    public function getIsBright():Boolean
    {
      return isBright;
    }
    /**
     * Sets the shape type when it is one of the allowed base shape types.
     * @param type the base shape type to apply
     */
    public function setType(type:int):void
    {
      application.trace("<" + this + " BaseShape setType> called.", 1);
      application.trace("<" + this + " BaseShape setType> type: " + type, 0);
      if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED()
       || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT()
       || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
      {
        this.type = type;
      }
    }
    /**
     * Returns the current shape type.
     */
    public function getType():int
    {
      return type;
    }
    /**
     * Sets the box corner size and, when valid, the box frame.
     * @param boxCorner the box corner size in pixels
     * @param boxFrame the box frame to apply
     */
    public function setBox(boxCorner:int, boxFrame:String):void
    {
      application.trace("<" + this + " BaseShape setBox> called.", 1);
      application.trace("<" + this + " BaseShape setBox> boxCorner: " + boxCorner, 0);
      application.trace("<" + this + " BaseShape setBox> boxFrame: " + boxFrame, 0);
      this.boxCorner = boxCorner;
      if (boxFrame == EnumBoxFrames.BOX_FRAME_FULL()
          || boxFrame == EnumBoxFrames.BOX_FRAME_HORIZONTAL()
          || boxFrame == EnumBoxFrames.BOX_FRAME_VERTICAL()
          || boxFrame == EnumBoxFrames.BOX_FRAME_NONE()
        )
      {
        this.boxFrame = boxFrame;
      }
    }
    /**
     * Returns the box corner size.
     */
    public function getBoxCorner():int
    {
      return boxCorner;
    }
    /**
     * Returns the box frame.
     */
    public function getBoxFrame():String
    {
      return boxFrame;
    }
    /**
     * Draws the rectangle with the configured fill and optional bright overlay.
     */
    public function drawRect():void
    {
      application.trace("<" + this + " BaseShape drawRect> called.", 1);
      clear();
      // the clearing above tells this shape that it holds no rectangle at all, so this
      // stands after that one: there is a rectangle standing on it again from here on
      rectangleDrawn = true;
      if (isFilled)
      {
        baseMatrix = new Matrix();
        baseMatrix.createGradientBox(dw * 2, dh, Math.PI / 2, -dw / 2, 0);
        graphics.beginGradientFill(GradientType.LINEAR, [fillColor1, fillColor2], [fillAlpha, fillAlpha], [application.getComponentsConfig().getLinearRatio1(), application.getComponentsConfig().getLinearRatio2()], baseMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
      }
      drawThatRect(true);
      if (isFilled)
      {
        graphics.endFill();
      }
      if (isBright)
      {
        brightMatrix = new Matrix();
        brightMatrix.createGradientBox(dw, dh, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.RADIAL, [brightColor1, application.getComponentsConfig().getBrightColor2()], [application.getComponentsConfig().getGradientAlpha1(), application.getComponentsConfig().getGradientAlpha2()], [application.getComponentsConfig().getGradientRatio1(), application.getComponentsConfig().getGradientRatio2()], brightMatrix, SpreadMethod.PAD, InterpolationMethod.RGB, application.getComponentsConfig().getFocalPointRatio());
        drawThatRect(false);
        graphics.endFill();
      }
      application.callContentSizeRecalc(this);
    }
    /**
     * Sets the drawing width, clamped to the configured minimum.
     * @param newdw the requested drawing width in pixels
     */
    public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseShape setDw> called.", 1);
      application.trace("<" + this + " BaseShape setDw> newdw: " + newdw, 0);
      dw = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
    }
    /**
     * Returns the drawing width.
     */
    public function getDw():int
    {
      return dw;
    }
    /**
     * Sets the drawing height, clamped to the configured minimum.
     * @param newdh the requested drawing height in pixels
     */
    public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseShape setDh> called.", 1);
      application.trace("<" + this + " BaseShape setDh> newdh: " + newdh, 0);
      dh = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
    }
    /**
     * Returns the drawing height.
     */
    public function getDh():int
    {
      return dh;
    }
    /**
     * Sets the drawing width and height, each clamped to the configured minimum.
     * @param newdw the requested drawing width in pixels
     * @param newdh the requested drawing height in pixels
     */
    public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseShape setDwh> called.", 1);
      application.trace("<" + this + " BaseShape setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseShape setDwh> newdh: " + newdh, 0);
      dw = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
      dh = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
    }
    /**
     * Recalculates the content size when the shape is added to the stage.
     * @param e the added to stage event
     */
    protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BaseShape addedToStage> called.", 1);
      application.trace("<" + this + " BaseShape addedToStage> e: " + e, 0);
      application.callContentSizeRecalc(this);
    }
    /**
     * Recalculates the content size when the shape is removed from the stage.
     * @param e the removed from stage event
     */
    protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseShape removedFromStage> called.", 1);
      application.trace("<" + this + " BaseShape removedFromStage> e: " + e, 0);
      application.callContentSizeRecalc(this);
    }
    /**
     * Redraws the rectangle when the line thickness changes and one was already drawn.
     * @param e the line thickness changed event
     */
    private function lineThicknessChanged(e:Event):void
    {
      application.trace("<" + this + " BaseShape lineThicknessChanged> called.", 1);
      application.trace("<" + this + " BaseShape lineThicknessChanged> e: " + e, 0);
      if (rectangleDrawn)
      {
        drawRect();
      }
    }
    /**
     * Draws the rounded rectangle path, optionally applying the border line styles.
     * @param lineNeeded whether the border line styles should be applied
     */
    private function drawThatRect(lineNeeded:Boolean):void
    {
      application.trace("<" + this + " BaseShape drawThatRect> called.", 1);
      application.trace("<" + this + " BaseShape drawThatRect> lineNeeded: " + lineNeeded, 0);
      const lineColor1:Number = application.getComponentsConfig().getLineColor1();
      const lineColor2:Number = application.getComponentsConfig().getLineColor2();
      const pixelHinting:Boolean = application.getComponentsConfig().getPixelHinting();
      const lineThickness:Number = application.getDynamicsConfig().getAppLineThickness();
      const lineAlpha:Number = lineThickness == 0 ? 0 : application.getComponentsConfig().getLineAlpha();
      // 1
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.moveTo(Math.max(radius, lineThickness / 2), lineThickness / 2);
      graphics.lineTo(Math.max(boxCorner, lineThickness / 2, radius), lineThickness / 2);
      // 2
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          if (boxFrame == EnumBoxFrames.BOX_FRAME_FULL() || boxFrame == EnumBoxFrames.BOX_FRAME_HORIZONTAL())
          {
            graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
          }
          else
          {
            graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
          }
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(Math.min(dw - boxCorner, dw - radius, dw - lineThickness / 2), lineThickness / 2);
      // 3
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(Math.min(dw - radius, dw - lineThickness / 2), lineThickness / 2);
      // 4
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED() || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          lineMatrix = new Matrix();
          lineMatrix.createGradientBox(radius, radius, 0, dw - radius - lineThickness / 2, lineThickness / 2);
          if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
          {
            graphics.lineGradientStyle(GradientType.LINEAR, [lineColor2, lineColor1], [lineAlpha, lineAlpha], [application.getComponentsConfig().getLineRatio1(), application.getComponentsConfig().getLineRatio2()], lineMatrix);
          }
          else
          {
            graphics.lineGradientStyle(GradientType.LINEAR, [lineColor1, lineColor2], [lineAlpha, lineAlpha], [application.getComponentsConfig().getLineRatio1(), application.getComponentsConfig().getLineRatio2()], lineMatrix);
          }
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.curveTo(dw - lineThickness / 2, lineThickness / 2
          , dw - lineThickness / 2, Math.max(radius, lineThickness / 2));
      // 5
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(dw - lineThickness / 2, Math.max(boxCorner, radius, lineThickness / 2));
      // 6
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          if (boxFrame == EnumBoxFrames.BOX_FRAME_FULL() || boxFrame == EnumBoxFrames.BOX_FRAME_VERTICAL())
          {
            graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
          }
          else
          {
            graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
          }
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(dw - lineThickness / 2, Math.min(dh - boxCorner, dh - radius, dh - lineThickness / 2));
      // 7
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(dw - lineThickness / 2, Math.min(dh - radius, dh - lineThickness / 2));
      // 8
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.curveTo(dw - lineThickness / 2, dh - lineThickness / 2
          , Math.min(dw - radius, dw - lineThickness / 2), dh - lineThickness / 2);
      // 9
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(Math.min(dw - boxCorner, dw - radius, dw - lineThickness / 2), dh - lineThickness / 2);
      // 10
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          if (boxFrame == EnumBoxFrames.BOX_FRAME_FULL() || boxFrame == EnumBoxFrames.BOX_FRAME_HORIZONTAL())
          {
            graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
          }
          else
          {
            graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
          }
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(Math.max(boxCorner, radius, lineThickness / 2), dh - lineThickness / 2);
      // 11
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(Math.max(radius, lineThickness / 2), dh - lineThickness / 2);
      // 12
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED() || type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          lineMatrix = new Matrix();
          lineMatrix.createGradientBox(radius, radius, 0, lineThickness / 2, dh - radius - lineThickness / 2);
          if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
          {
            graphics.lineGradientStyle(GradientType.LINEAR, [lineColor2, lineColor1], [lineAlpha, lineAlpha], [application.getComponentsConfig().getLineRatio1(), application.getComponentsConfig().getLineRatio2()], lineMatrix);
          }
          else
          {
            graphics.lineGradientStyle(GradientType.LINEAR, [lineColor1, lineColor2], [lineAlpha, lineAlpha], [application.getComponentsConfig().getLineRatio1(), application.getComponentsConfig().getLineRatio2()], lineMatrix);
          }
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.curveTo(lineThickness / 2, dh - lineThickness / 2
          , lineThickness / 2, Math.min(dh - radius, dh - lineThickness / 2));
      // 13
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(lineThickness / 2, Math.min(dh - boxCorner, dh - radius, dh - lineThickness / 2));
      // 14
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          if (boxFrame == EnumBoxFrames.BOX_FRAME_FULL() || boxFrame == EnumBoxFrames.BOX_FRAME_VERTICAL())
          {
            graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
          }
          else
          {
            graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
          }
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(lineThickness / 2, Math.max(boxCorner, radius, lineThickness / 2));
      // 15
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.lineTo(lineThickness / 2, Math.max(radius, lineThickness / 2));
      // 16
      if (lineNeeded)
      {
        if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor1, lineAlpha, pixelHinting);
        }
        else if (type == EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED())
        {
          graphics.lineStyle(lineThickness, lineColor2, lineAlpha, pixelHinting);
        }
        else
        {
          graphics.lineStyle(lineThickness, lineColor, lineAlpha, pixelHinting);
        }
      }
      else
      {
        graphics.lineStyle(lineThickness, lineColor, 0, pixelHinting);
      }
      graphics.curveTo(lineThickness / 2, lineThickness / 2
          , Math.max(radius, lineThickness / 2), lineThickness / 2);
    }
    /**
     * Forces the garbage collector to run several times.
     */
    private function systemGc():void
    {
      application.trace("<" + this + " BaseShape systemGc> called.", 1);
      for (var i:int = 0; i < 10; i++)
      {
        System.gc();
      }
    }
    /**
     * Resets the dimensions, type, radius and flags to their defaults.
     */
    private function allReset():void
    {
      application.trace("<" + this + " BaseShape allReset> called.", 1);
      dw = 0;
      dh = 0;
      type = 0;
      radius = 0;
      isBright = false;
      isFilled = false;
    }
    /**
     * Unregisters the listeners, clears the graphics and resets every reference and value.
     */
    public function destroy():void
    {
      application.trace("<" + this + " BaseShape destroy> called.", 1);
      application.trace("<" + this + " BaseShape destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
      removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.trace("<" + this + " BaseShape destroy> remove every child object if there are any (necessary only in BaseShape).", 0);
      application.trace("<" + this + " BaseShape destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      graphics.clear();
      filters = null;
      application.trace("<" + this + " BaseShape destroy> calling the super destroy (necessary only not in BaseShape) and clearing everything.", 0);
      systemGc();
      allReset();
      baseMatrix = null;
      brightMatrix = null;
      lineMatrix = null;
      lineColor = 0;
      fillColor1 = 0;
      fillColor2 = 0;
      fillAlpha = 0;
      brightColor1 = 0;
      rectangleDrawn = false;
      application = null;
    }
  }
}
