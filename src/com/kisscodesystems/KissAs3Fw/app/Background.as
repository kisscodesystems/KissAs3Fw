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
 * Background.
 * The bottom layer of the application: it paints the background and moves the
 * background image when that one is a live one.
 *
 * MAIN FEATURES:
 * - three layers are drawn above each other:
 *     - a back shape filled with the dark background color, alpha: 1
 *     - a background image shape painted with the background image, alpha: 0 - 1
 *     - a background color shape colored by the dark and the bright color, alpha: 0 - 1
 * - live property: the background image can follow the mouse pointer slowly
 * - the background is fixed while a color object is stealing a pixel from the stage
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBackgroundAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  public class Background extends BaseSprite
  {
    // the opaque back of the whole background
    private var backShape:BaseShape = null;
    // the shape painted with the bitmap data of the background image
    private var backgroundImageShape:BaseShape = null;
    // the shape coloring the background above the image
    private var backgroundColorShape:BaseShape = null;
    // the coordinates the live background image is moving into
    private var targetCx:int = 0;
    private var targetCy:int = 0;
    // a color object is stealing a pixel from the stage right now or not
    private var pixelStealing:Boolean = false;
    /**
     * Constructs the background with the three layers it is built of.
     * @param applicationRef the main application reference
     */
    public function Background(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Background> called.", 1);
      application.trace("<" + this + " Background> applicationRef: " + applicationRef, 0);
      backShape = new BaseShape(application);
      addChild(backShape);
      backgroundImageShape = new BaseShape(application);
      addChild(backgroundImageShape);
      backgroundColorShape = new BaseShape(application);
      addChild(backgroundColorShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), fillAlphaChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED(), backgroundLiveChanged);
      application.trace("<" + this + " Background> constructed.", 1);
    }
    /**
     * A color object is stealing a pixel from the stage, so everything displayed
     * has to stay exactly where it is until that stealing is over.
     * @param b whether the stealing is in progress right now
     */
    public function stealPixel(b:Boolean):void
    {
      application.trace("<" + this + " Background stealPixel> called.", 1);
      application.trace("<" + this + " Background stealPixel> b: " + b, 0);
      pixelStealing = b;
      registerOrUnregisterCanBackgroundMove();
    }
    /**
     * Handles the added to stage event by watching the clicks of the stage and
     * by deciding whether the background image is a moving one.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Background addedToStage> called.", 1);
      application.trace("<" + this + " Background addedToStage> e: " + e, 0);
      super.addedToStage(e);
      stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown, false, 0, true);
      // there is a stage from now on, so this one is able to do its work
      registerOrUnregisterCanBackgroundMove();
    }
    /**
     * Handles the removed from stage event by dropping every listener of the stage.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Background removedFromStage> called.", 1);
      application.trace("<" + this + " Background removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, posBackgroundImageForBackgroundLive);
      }
      super.removedFromStage(e);
    }
    /**
     * Redraws every layer after the dimensions of this object have been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " Background doDimensionsChanged> called.", 1);
      backgroundRedraw();
      super.doDimensionsChanged();
    }
    /**
     * The one using the application has clicked, so the live background jumps
     * to the position belonging to the mouse pointer.
     * @param e the mouse down event of the stage
     */
    private function stageMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Background stageMouseDown> called.", 1);
      application.trace("<" + this + " Background stageMouseDown> e: " + e, 0);
      if (canBackgroundMove())
      {
        posBackgroundImageForBackgroundLive(e);
      }
    }
    /**
     * One of the background colors of the application has been changed.
     * @param e the event of the color that has been changed
     */
    private function backgroundColorChanged(e:Event):void
    {
      application.trace("<" + this + " Background backgroundColorChanged> called.", 1);
      application.trace("<" + this + " Background backgroundColorChanged> e: " + e, 0);
      drawBackgroundColorShape();
    }
    /**
     * The alpha of the background color has been changed. A fully opaque background
     * hides the image completely, so the moving of it may become needless.
     * @param e the event of the alpha changing
     */
    private function fillAlphaChanged(e:Event):void
    {
      application.trace("<" + this + " Background fillAlphaChanged> called.", 1);
      application.trace("<" + this + " Background fillAlphaChanged> e: " + e, 0);
      registerOrUnregisterCanBackgroundMove();
      drawBackgroundColorShape();
    }
    /**
     * The background image or one of its displayed properties has been changed.
     * @param e the event of the property that has been changed
     */
    private function backgroundImageChanged(e:Event):void
    {
      application.trace("<" + this + " Background backgroundImageChanged> called.", 1);
      application.trace("<" + this + " Background backgroundImageChanged> e: " + e, 0);
      registerOrUnregisterCanBackgroundMove();
      drawBackgroundImageShape();
    }
    /**
     * The live property of the background has been changed. A live background image is
     * a bit larger than the stage, so that it has room to follow the mouse pointer in.
     * @param e the event of the live property changing
     */
    private function backgroundLiveChanged(e:Event):void
    {
      application.trace("<" + this + " Background backgroundLiveChanged> called.", 1);
      application.trace("<" + this + " Background backgroundLiveChanged> e: " + e, 0);
      registerOrUnregisterCanBackgroundMove();
      drawBackgroundImageShape();
    }
    /**
     * Tells whether the background image is able to move right now. It is able to when
     * no pixel is being stolen, the background is a live one, it has an align, the color
     * above it is not fully opaque and the image itself is not fully transparent.
     */
    private function canBackgroundMove():Boolean
    {
      application.trace("<" + this + " Background canBackgroundMove> called.", 1);
      const canMove:Boolean = !pixelStealing
        && application.getDynamicsConfig().getAppBackgroundLive()
        && application.getDynamicsConfig().getAppBackgroundAlign() != EnumBackgroundAligns.BACKGROUND_ALIGN_NONE()
        && application.getDynamicsConfig().getAppBackgroundColorAlpha() < 1
        && application.getDynamicsConfig().getAppBackgroundAlpha() > 0;
      application.trace("<" + this + " Background canBackgroundMove> canMove: " + canMove, 0);
      return canMove;
    }
    /**
     * Registers the moving of the background image if that is possible right now,
     * and unregisters it if it is not.
     */
    private function registerOrUnregisterCanBackgroundMove():void
    {
      application.trace("<" + this + " Background registerOrUnregisterCanBackgroundMove> called.", 1);
      if (application == null)
      {
        return;
      }
      if (canBackgroundMove())
      {
        registerMouseMoveForBackgroundLive();
      }
      else
      {
        // both of them are needed: the image may be on its way to its target right now
        unregisterEnterFrameForBackgroundLive();
        unregisterMouseMoveFromBackgroundLive();
      }
    }
    /**
     * Redraws every layer of this background.
     */
    private function backgroundRedraw():void
    {
      application.trace("<" + this + " Background backgroundRedraw> called.", 1);
      drawBackgroundImageShape();
      drawBackgroundColorShape();
      drawBackShape();
    }
    /**
     * Redraws the color shape standing above the background image.
     */
    private function drawBackgroundColorShape():void
    {
      application.trace("<" + this + " Background drawBackgroundColorShape> called.", 1);
      if (application == null)
      {
        return;
      }
      backgroundColorShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorAlpha()
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      backgroundColorShape.x = 0;
      backgroundColorShape.y = 0;
      backgroundColorShape.setRadius(0);
      backgroundColorShape.setDwh(getDw(), getDh());
      backgroundColorShape.setIsBright(true);
      backgroundColorShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      backgroundColorShape.drawRect();
    }
    /**
     * Redraws the opaque back of this background.
     */
    private function drawBackShape():void
    {
      application.trace("<" + this + " Background drawBackShape> called.", 1);
      if (application == null)
      {
        return;
      }
      backShape.x = 0;
      backShape.y = 0;
      backShape.graphics.clear();
      backShape.graphics.lineStyle(0, 0, 0);
      backShape.graphics.beginFill(application.getDynamicsConfig().getAppBackgroundColorDark(), 1);
      backShape.graphics.drawRect(0, 0, getDw(), getDh());
      backShape.graphics.endFill();
    }
    /**
     * Repaints the shape of the background image according to the current align of it.
     */
    private function drawBackgroundImageShape():void
    {
      application.trace("<" + this + " Background drawBackgroundImageShape> called.", 1);
      if (application == null || stage == null)
      {
        return;
      }
      const bitmapData:BitmapData = application.getDynamicsConfig().getBitmapData();
      if (bitmapData == null)
      {
        application.trace("<" + this + " Background drawBackgroundImageShape> there is no background image to paint with.", 0);
        return;
      }
      // a live background image has to be larger than the stage: it needs room to move in
      const margin:int = canBackgroundMove() ? application.getComponentsConfig().getLiveBackgroundMargin() : 0;
      const dwCorrected:int = getDw() + margin;
      const dhCorrected:int = getDh() + margin;
      backgroundImageShape.alpha = application.getDynamicsConfig().getAppBackgroundAlpha();
      const align:String = application.getDynamicsConfig().getAppBackgroundAlign();
      if (align == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER1())
      {
        drawBackgroundImageShapeFitted(bitmapData, dwCorrected, dhCorrected, true);
      }
      else if (align == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER2())
      {
        drawBackgroundImageShapeFitted(bitmapData, dwCorrected, dhCorrected, false);
      }
      else if (align == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER3())
      {
        drawBackgroundImageShapeCentered(bitmapData, dwCorrected, dhCorrected);
      }
      else if (align == EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC())
      {
        drawBackgroundImageShapeMosaic(bitmapData, dwCorrected, dhCorrected);
      }
      else
      {
        // the align is BACKGROUND_ALIGN_NONE, so no image has to be painted at all
        backgroundImageShape.graphics.clear();
      }
    }
    /**
     * Paints the background image scaled into the corrected area, keeping its own ratio.
     * @param bitmapData the bitmap data of the background image
     * @param dwCorrected the width of the area to paint into
     * @param dhCorrected the height of the area to paint into
     * @param toFitInside whether the whole image has to fit inside the area (true) or
     *                    the whole area has to be covered by the image (false)
     */
    private function drawBackgroundImageShapeFitted(bitmapData:BitmapData, dwCorrected:int, dhCorrected:int, toFitInside:Boolean):void
    {
      application.trace("<" + this + " Background drawBackgroundImageShapeFitted> called.", 1);
      application.trace("<" + this + " Background drawBackgroundImageShapeFitted> bitmapData: " + bitmapData, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeFitted> dwCorrected: " + dwCorrected, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeFitted> dhCorrected: " + dhCorrected, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeFitted> toFitInside: " + toFitInside, 0);
      var tempWidth:int = bitmapData.width;
      var tempHeight:int = bitmapData.height;
      if (toFitInside)
      {
        if (dwCorrected < tempWidth)
        {
          tempHeight = Math.round(dwCorrected / tempWidth * tempHeight);
          tempWidth = dwCorrected;
        }
        if (dhCorrected < tempHeight)
        {
          tempWidth = Math.round(dhCorrected / tempHeight * tempWidth);
          tempHeight = dhCorrected;
        }
      }
      else
      {
        if (dwCorrected != tempWidth)
        {
          tempWidth = dwCorrected;
          tempHeight = Math.round(dwCorrected / bitmapData.width * bitmapData.height);
        }
        if (dhCorrected > tempHeight)
        {
          tempHeight = dhCorrected;
          tempWidth = Math.round(dhCorrected / bitmapData.height * bitmapData.width);
        }
      }
      const matrix:Matrix = new Matrix();
      matrix.scale(tempWidth / bitmapData.width, tempHeight / bitmapData.height);
      matrix.translate((dwCorrected - tempWidth) / 2, (dhCorrected - tempHeight) / 2);
      backgroundImageShape.graphics.clear();
      backgroundImageShape.graphics.beginBitmapFill(bitmapData, matrix, false, true);
      backgroundImageShape.graphics.drawRect((dwCorrected - tempWidth) / 2, (dhCorrected - tempHeight) / 2, tempWidth, tempHeight);
      backgroundImageShape.graphics.endFill();
    }
    /**
     * Paints the background image into the middle of the corrected area, in its own size.
     * @param bitmapData the bitmap data of the background image
     * @param dwCorrected the width of the area to paint into
     * @param dhCorrected the height of the area to paint into
     */
    private function drawBackgroundImageShapeCentered(bitmapData:BitmapData, dwCorrected:int, dhCorrected:int):void
    {
      application.trace("<" + this + " Background drawBackgroundImageShapeCentered> called.", 1);
      application.trace("<" + this + " Background drawBackgroundImageShapeCentered> bitmapData: " + bitmapData, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeCentered> dwCorrected: " + dwCorrected, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeCentered> dhCorrected: " + dhCorrected, 0);
      const cx:int = (dwCorrected - bitmapData.width) / 2;
      const cy:int = (dhCorrected - bitmapData.height) / 2;
      const matrix:Matrix = new Matrix();
      matrix.translate(cx, cy);
      backgroundImageShape.graphics.clear();
      backgroundImageShape.graphics.beginBitmapFill(bitmapData, matrix, false, true);
      backgroundImageShape.graphics.drawRect(cx, cy, bitmapData.width, bitmapData.height);
      backgroundImageShape.graphics.endFill();
    }
    /**
     * Tiles the whole corrected area with the background image.
     * @param bitmapData the bitmap data of the background image
     * @param dwCorrected the width of the area to paint into
     * @param dhCorrected the height of the area to paint into
     */
    private function drawBackgroundImageShapeMosaic(bitmapData:BitmapData, dwCorrected:int, dhCorrected:int):void
    {
      application.trace("<" + this + " Background drawBackgroundImageShapeMosaic> called.", 1);
      application.trace("<" + this + " Background drawBackgroundImageShapeMosaic> bitmapData: " + bitmapData, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeMosaic> dwCorrected: " + dwCorrected, 0);
      application.trace("<" + this + " Background drawBackgroundImageShapeMosaic> dhCorrected: " + dhCorrected, 0);
      backgroundImageShape.graphics.clear();
      backgroundImageShape.graphics.beginBitmapFill(bitmapData, null, true, true);
      backgroundImageShape.graphics.drawRect(0, 0, dwCorrected, dhCorrected);
      backgroundImageShape.graphics.endFill();
    }
    /**
     * Starts to follow the mouse pointer with the background image.
     */
    private function registerMouseMoveForBackgroundLive():void
    {
      application.trace("<" + this + " Background registerMouseMoveForBackgroundLive> called.", 1);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, posBackgroundImageForBackgroundLive, false, 0, true);
        // the image is larger from now on, so it has to be repainted
        backgroundRedraw();
      }
    }
    /**
     * Stops following the mouse pointer and puts the background image back to the origin,
     * except when it is a pixel stealing that has stopped the following.
     */
    private function unregisterMouseMoveFromBackgroundLive():void
    {
      application.trace("<" + this + " Background unregisterMouseMoveFromBackgroundLive> called.", 1);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, posBackgroundImageForBackgroundLive);
        // the image standing still during a stealing has to stay exactly where it is: taking
        // it back to the origin would be a move as well, and the snapshot the colors are
        // read from is taken right after this
        if (!pixelStealing)
        {
          backgroundImageShape.x = 0;
          backgroundImageShape.y = 0;
        }
      }
    }
    /**
     * Updates the coordinates the live background image has to move into. The image
     * itself does not jump there: the enter frame below takes it there step by step.
     * @param e the mouse event holding the current position of the pointer
     */
    private function posBackgroundImageForBackgroundLive(e:MouseEvent):void
    {
      application.trace("<" + this + " Background posBackgroundImageForBackgroundLive> called.", 0);
      if (stage != null)
      {
        const margin:int = application.getComponentsConfig().getLiveBackgroundMargin();
        targetCx = -margin + int(margin * (stage.mouseX / stage.stageWidth));
        targetCy = -margin + int(margin * (stage.mouseY / stage.stageHeight));
        registerEnterFrameForBackgroundLive();
      }
    }
    /**
     * Starts to take the background image to its target coordinates.
     */
    private function registerEnterFrameForBackgroundLive():void
    {
      application.trace("<" + this + " Background registerEnterFrameForBackgroundLive> called.", 0);
      if (!hasEventListener(Event.ENTER_FRAME))
      {
        addEventListener(Event.ENTER_FRAME, enterFrameBackgroundImageShapePos);
      }
    }
    /**
     * Stops taking the background image to its target coordinates.
     */
    private function unregisterEnterFrameForBackgroundLive():void
    {
      application.trace("<" + this + " Background unregisterEnterFrameForBackgroundLive> called.", 0);
      removeEventListener(Event.ENTER_FRAME, enterFrameBackgroundImageShapePos);
    }
    /**
     * Takes the background image one step closer to its target coordinates, and stops
     * itself when that target has been reached.
     * @param e the enter frame event
     */
    private function enterFrameBackgroundImageShapePos(e:Event):void
    {
      application.trace("<" + this + " Background enterFrameBackgroundImageShapePos> called.", 0);
      const weight:int = application.getComponentsConfig().getWeightBackgroundPicture();
      backgroundImageShape.x += (targetCx - backgroundImageShape.x) / weight;
      backgroundImageShape.y += (targetCy - backgroundImageShape.y) / weight;
      if (Math.round(backgroundImageShape.x) == targetCx && Math.round(backgroundImageShape.y) == targetCy)
      {
        unregisterEnterFrameForBackgroundLive();
        backgroundImageShape.x = targetCx;
        backgroundImageShape.y = targetCy;
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Background destroy> called.", 1);
      application.trace("<" + this + " Background destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      unregisterEnterFrameForBackgroundLive();
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, posBackgroundImageForBackgroundLive);
      }
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), fillAlphaChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED(), backgroundImageChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED(), backgroundLiveChanged);
      application.trace("<" + this + " Background destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " Background destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " Background destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      backShape = null;
      backgroundImageShape = null;
      backgroundColorShape = null;
      targetCx = 0;
      targetCy = 0;
      pixelStealing = false;
    }
  }
}
