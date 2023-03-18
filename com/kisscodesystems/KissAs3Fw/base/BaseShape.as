/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Dm
**
** DESCRIPTION:
** BaseShape.
** Extends the original Shape class.
** It is just for basic rect drawing.
** It will not subscribe for any events (except EVENT_LINE_THICKNESS_CHANGED ):
** this is the job of the parent object.
** This little object will do the job what is requested.
** The drawing of the rounded corner is better
** than using the default graphics.drawRoundRect method.
**
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import flash . display . DisplayObject ;
  import flash . display . GradientType ;
  import flash . display . InterpolationMethod ;
  import flash . display . Shape ;
  import flash . display . SpreadMethod ;
  import flash . events . Event ;
  import flash . geom . Matrix ;
  import flash . system . System ;
  public class BaseShape extends Shape
  {
// Reference to the Application object.
    protected var application : Application = null ;
// The matrix used for drawing a little bright layer to the shape.
    private var brightMatrix : Matrix = null ;
// This matrix will be used to draw the base with 2 colors.
    private var baseMatrix : Matrix = null ;
// The matrix used for drawing the curve (bright-to-dark)
    private var lineMatrix : Matrix = null ;
// The color of the line.
    private var lineColor : Number = 0 ;
// The colors of the filling.
    private var fillColor1 : Number = 0 ;
    private var fillColor2 : Number = 0 ;
// The alpha of the filling.
    private var fillAlpha : Number = 0 ;
// The box properties, count only general boxing (0).
    private var boxCorner : int = 0 ;
    private var boxFrame : String = "" ;
// The color of the bright.
    private var brightColor1 : Number = 0 ;
// Radius. (of the corners)
    private var sr : int = 0 ;
// Width.
    private var sw : int = 0 ;
// Height.
    private var sh : int = 0 ;
// Bright (layer needed or not).
    private var db : Boolean = false ;
// Type (-1: pushed, 0: general, 1: unpushed).
    private var dt : int = 0 ;
// Fill is needed or not
    private var df : Boolean = true ;
// A rectangle was drawn or not.
    private var rectangleDrawn : Boolean = false ;
/*
** Constructs the original Shape.
*/
    public function BaseShape ( applicationRef : Application ) : void
    {
// Super.
      super ( ) ;
// Getting the not null reference to the Application object.
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// These are initialized now.
      boxCorner = 8 ;
      boxFrame = application . getTexts ( ) . BOX_FRAME_FULL ;
// Now registering the events of adding and removing this object to and from the stage.
      addEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      addEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
// Registering into the EVENT_LINE_THICKNESS_CHANGED only.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
    }
/*
** Listener functions: added and removed from stage.
** (The stage propery will be not null in addedToStage
** and null will be null in removedFromStage.)
*/
    protected function addedToStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
    protected function removedFromStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
/*
** Publicly available clearing method.
*/
    public function clear ( ) : void
    {
      graphics . clear ( ) ;
    }
/*
** Sets the colors of the drawing.
** (cccac: color color alpha color)
** The object has to be redrawn after this!
*/
    public function setcccac ( lineColor : Number , fillColor1 : Number , fillColor2 : Number , fillAlpha : Number , brightColor1 : Number ) : void
    {
      this . lineColor = lineColor ;
      this . fillColor1 = fillColor1 ;
      this . fillColor2 = fillColor2 ;
      this . fillAlpha = fillAlpha ;
      this . brightColor1 = brightColor1 ;
    }
/*
** Sets the sr (radius).
** The object has to be redrawn after this!
*/
    public function setsr ( sr : int ) : void
    {
      this . sr = sr ;
    }
/*
** Sets the sb (box) properties.
** The object has to be redrawn after this!
*/
    public function setsb ( boxCorner : int , boxFrame : String ) : void
    {
      this . boxCorner = boxCorner ;
      this . boxFrame = boxFrame ;
    }
/*
** Sets the r radius and the w and h sizes.
** The object has to be redrawn after this!
*/
    public function setswh ( sw : int , sh : int ) : void
    {
      this . sw = Math . max ( sw , application . getPropsApp ( ) . getBaseMinw ( ) ) ;
      this . sh = Math . max ( sh , application . getPropsApp ( ) . getBaseMinh ( ) ) ;
    }
/*
** Gets the width and height and the radius of the painting.
*/
    public function getsw ( ) : int
    {
      return sw ;
    }
    public function getsh ( ) : int
    {
      return sh ;
    }
    public function getsr ( ) : int
    {
      return sr ;
    }
/*
** Sets the necessary of the filling of the rectangle.
** The object has to be redrawn after this!
*/
    public function setdf ( df : Boolean ) : void
    {
      this . df = df ;
    }
/*
** Sets the necessary of the bright layer of the shape.
** The object has to be redrawn after this!
*/
    public function setdb ( db : Boolean ) : void
    {
      this . db = db ;
    }
/*
** Sets the type of the shape.
** -1 0 and 1 are acceptable.
** The object has to be redrawn after this!
*/
    public function setdt ( dt : int ) : void
    {
      if ( dt == - 1 )
      {
        this . dt = - 1 ;
      }
      else if ( dt == 1 )
      {
        this . dt = 1 ;
      }
      else if ( dt == 0 )
      {
        this . dt = 0 ;
      }
    }
/*
** Draws the rect.
*/
    public function drawRect ( ) : void
    {
      if ( application != null )
      {
// This is true at this point!
        rectangleDrawn = true ;
// Let's clear first.
        clear ( ) ;
// Begin of filling.
        if ( df )
        {
          baseMatrix = new Matrix ( ) ;
          baseMatrix . createGradientBox ( sw * 2 , sh , Math . PI / 2 , - sw / 2 , 0 ) ;
          graphics . beginGradientFill ( GradientType . LINEAR , [ fillColor1 , fillColor2 ] , [ fillAlpha , fillAlpha ] , [ application . getPropsApp ( ) . getLinearRatio1 ( ) , application . getPropsApp ( ) . getLinearRatio2 ( ) ] , baseMatrix , SpreadMethod . PAD , InterpolationMethod . RGB ) ;
        }
// Really drawing the rect, with line drawing.
        drawThatRect ( true ) ;
// End of filling.
        if ( df )
        {
          graphics . endFill ( ) ;
        }
// If the bright layer is needed..
        if ( db )
        {
// The matrix has to be reconstructed.
          brightMatrix = new Matrix ( ) ;
          brightMatrix . createGradientBox ( sw , sh , Math . PI / 2 , 0 , 0 ) ;
// Begin of filling.
          graphics . beginGradientFill ( GradientType . RADIAL , [ brightColor1 , application . getPropsApp ( ) . getBrightColor2 ( ) ] , [ application . getPropsApp ( ) . getGradientAlpha1 ( ) , application . getPropsApp ( ) . getGradientAlpha2 ( ) ] , [ application . getPropsApp ( ) . getGradientRatio1 ( ) , application . getPropsApp ( ) . getGradientRatio2 ( ) ] , brightMatrix , SpreadMethod . PAD , InterpolationMethod . RGB , application . getPropsApp ( ) . getFocalPointRatio ( ) ) ;
// Drawing the rect again but without line.
          drawThatRect ( false ) ;
// End of filling.
          graphics . endFill ( ) ;
        }
// Calling the content size recalc.
        application . callContentSizeRecalc ( this ) ;
      }
    }
/*
** The line thickness has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
// If the rectangleDrawn is true then redraw the rectangle.
      if ( rectangleDrawn )
      {
        drawRect ( ) ;
      }
    }
/*
** Drawing the (curved) rect based on the above given data.
** (use this instead of the graphics.drawRect)
*/
    private function drawThatRect ( lineNeeded : Boolean ) : void
    {
      var lineColor1 : Number = application . getPropsApp ( ) . getLineColor1 ( ) ;
      var lineColor2 : Number = application . getPropsApp ( ) . getLineColor2 ( ) ;
      var pixelHinting : Boolean = application . getPropsApp ( ) . getPixelHinting ( ) ;
      var lineThickness : Number = application . getPropsDyn ( ) . getAppLineThickness ( ) ;
      var lineAlpha : Number = lineThickness == 0 ? 0 : application . getPropsApp ( ) . getLineAlpha ( ) ;
// 1
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . moveTo ( Math . max ( sr , lineThickness / 2 ) , lineThickness / 2 ) ;
      graphics . lineTo ( Math . max ( boxCorner , lineThickness / 2 , sr ) , lineThickness / 2 ) ;
// 2
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          if ( boxFrame == application . getTexts ( ) . BOX_FRAME_FULL || boxFrame == application . getTexts ( ) . BOX_FRAME_HORIZONTAL )
          {
            graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
          }
          else
          {
            graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
          }
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( Math . min ( sw - boxCorner , sw - sr , sw - lineThickness / 2 ) , lineThickness / 2 ) ;
// 3
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( Math . min ( sw - sr , sw - lineThickness / 2 ) , lineThickness / 2 ) ;
// 4
      if ( lineNeeded )
      {
        if ( dt == - 1 || dt == 1 )
        {
// .. and in this cases, the brighting of the curves.
          lineMatrix = new Matrix ( ) ;
          lineMatrix . createGradientBox ( sr , sr , 0 , sw - sr - lineThickness / 2 , lineThickness / 2 ) ;
          if ( dt == 1 )
          {
            graphics . lineGradientStyle ( GradientType . LINEAR , [ lineColor2 , lineColor1 ] , [ lineAlpha , lineAlpha ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
          }
          else
          {
            graphics . lineGradientStyle ( GradientType . LINEAR , [ lineColor1 , lineColor2 ] , [ lineAlpha , lineAlpha ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
          }
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . curveTo ( sw - lineThickness / 2 , lineThickness / 2
                         , sw - lineThickness / 2 , Math . max ( sr , lineThickness / 2 ) ) ;
// 5
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( sw - lineThickness / 2 , Math . max ( boxCorner , sr , lineThickness / 2 ) ) ;
// 6
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          if ( boxFrame == application . getTexts ( ) . BOX_FRAME_FULL || boxFrame == application . getTexts ( ) . BOX_FRAME_VERTICAL )
          {
            graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
          }
          else
          {
            graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
          }
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( sw - lineThickness / 2 , Math . min ( sh - boxCorner , sh - sr , sh - lineThickness / 2 ) ) ;
// 7
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( sw - lineThickness / 2 , Math . min ( sh - sr , sh - lineThickness / 2 ) ) ;
// 8
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . curveTo ( sw - lineThickness / 2 , sh - lineThickness / 2 
                         , Math . min ( sw - sr , sw - lineThickness / 2 ) , sh - lineThickness / 2 ) ;
// 9
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( Math . min ( sw - boxCorner , sw - sr , sw - lineThickness / 2 ) , sh - lineThickness / 2 ) ;
// 10
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          if ( boxFrame == application . getTexts ( ) . BOX_FRAME_FULL || boxFrame == application . getTexts ( ) . BOX_FRAME_HORIZONTAL )
          {
            graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
          }
          else
          {
            graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
          }
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( Math . max ( boxCorner , sr , lineThickness / 2 ) , sh - lineThickness / 2 ) ;
// 11
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( Math . max ( sr , lineThickness / 2 ) , sh - lineThickness / 2 ) ;
// 12
      if ( lineNeeded )
      {
        if ( dt == - 1 || dt == 1 )
        {
          lineMatrix = new Matrix ( ) ;
          lineMatrix . createGradientBox ( sr , sr , 0 , lineThickness / 2 , sh - sr - lineThickness / 2 ) ;
          if ( dt == 1 )
          {
            graphics . lineGradientStyle ( GradientType . LINEAR , [ lineColor2 , lineColor1 ] , [ lineAlpha , lineAlpha ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
          }
          else
          {
            graphics . lineGradientStyle ( GradientType . LINEAR , [ lineColor1 , lineColor2 ] , [ lineAlpha , lineAlpha ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
          }
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . curveTo ( lineThickness / 2 , sh - lineThickness / 2
                         , lineThickness / 2 , Math . min ( sh - sr , sh - lineThickness / 2 ) ) ;
// 13
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( lineThickness / 2 , Math . min ( sh - boxCorner , sh - sr , sh - lineThickness / 2 ) ) ;
// 14
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          if ( boxFrame == application . getTexts ( ) . BOX_FRAME_FULL || boxFrame == application . getTexts ( ) . BOX_FRAME_VERTICAL )
          {
            graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
          }
          else
          {
            graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
          }
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( lineThickness / 2 , Math . max ( boxCorner , sr , lineThickness / 2 ) ) ;
// 15
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . lineTo ( lineThickness / 2 , Math . max ( sr , lineThickness / 2 ) ) ;
// 16
      if ( lineNeeded )
      {
        if ( dt == - 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor1 , lineAlpha , pixelHinting ) ;
        }
        else if ( dt == 1 )
        {
          graphics . lineStyle ( lineThickness , lineColor2 , lineAlpha , pixelHinting ) ;
        }
        else
        {
          graphics . lineStyle ( lineThickness , lineColor , lineAlpha , pixelHinting ) ;
        }
      }
      else
      {
        graphics . lineStyle ( lineThickness , lineColor , 0 , pixelHinting ) ;
      }
      graphics . curveTo ( lineThickness / 2 , lineThickness / 2
                         , Math . max ( sr , lineThickness / 2 ) , lineThickness / 2 ) ;
    }
/*
** Destroying this object by calling this method.
*/
    public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      removeEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      removeEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      graphics . clear ( ) ;
      filters = null ;
// 3: calling the super destroy.
// 4: every reference and value should be resetted to null, 0 or false.
      baseMatrix = null ;
      brightMatrix = null ;
      lineMatrix = null ;
      lineColor = 0 ;
      fillColor1 = 0 ;
      fillColor2 = 0 ;
      fillAlpha = 0 ;
      brightColor1 = 0 ;
      sr = 0 ;
      sw = 0 ;
      sh = 0 ;
      db = false ;
      dt = 0 ;
      df = false ;
      application = null ;
    }
  }
}
