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
// The matrix used for drawing the curve (bright-to-dark)
    private var lineMatrix : Matrix = null ;
// The color of the line.
    private var lineColor : Number = 0 ;
// The color of the filling.
    private var fillColor : Number = 0 ;
// The alpha of the filling.
    private var fillAlpha : Number = 0 ;
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
** (ccac: color color alpha color)
** The object has to be redrawn after this!
*/
    public function setccac ( lineColor : Number , fillColor : Number , fillAlpha : Number , brightColor1 : Number ) : void
    {
      this . lineColor = lineColor ;
      this . fillColor = fillColor ;
      this . fillAlpha = fillAlpha ;
      this . brightColor1 = brightColor1 ;
    }
/*
** Sets the sr (radius).
*/
    public function setsr ( sr : int ) : void
    {
      this . sr = sr ;
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
          graphics . beginFill ( fillColor , fillAlpha ) ;
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
          brightMatrix . createGradientBox ( sw * 2 , sh , Math . PI / 2 , - sw / 2 , 0 ) ;
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
// If the radius has been set to 0..
      if ( sr == 0 )
      {
// Then we can do it easier. (just 4 line.)
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        else
        {
          graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , 0 , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
        }
        graphics . moveTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        graphics . lineTo ( sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . lineTo ( sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        graphics . lineTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . lineTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
      }
      else
      {
// OK, we need curving on the corners..
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        else
        {
          graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , 0 , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
        }
        graphics . moveTo ( sr + application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        graphics . lineTo ( sw - sr - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 || dt == 1 )
          {
// .. and in this cases, the brighting of the curves.
            lineMatrix = new Matrix ( ) ;
            lineMatrix . createGradientBox ( sr , sr , 0 , sw - sr - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
            if ( dt == 1 )
            {
              graphics . lineGradientStyle ( GradientType . LINEAR , [ application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineColor1 ( ) ] , [ application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getLineAlpha ( ) ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
            }
            else
            {
              graphics . lineGradientStyle ( GradientType . LINEAR , [ application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineColor2 ( ) ] , [ application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getLineAlpha ( ) ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
            }
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . curveTo ( sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sr + application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . lineTo ( sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 - sr ) ;
        graphics . curveTo ( sw - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sw - sr - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        graphics . lineTo ( sr + application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 || dt == 1 )
          {
            lineMatrix = new Matrix ( ) ;
            lineMatrix . createGradientBox ( sr , sr , 0 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - sr - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
            if ( dt == 1 )
            {
              graphics . lineGradientStyle ( GradientType . LINEAR , [ application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineColor1 ( ) ] , [ application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getLineAlpha ( ) ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
            }
            else
            {
              graphics . lineGradientStyle ( GradientType . LINEAR , [ application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineColor2 ( ) ] , [ application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getLineAlpha ( ) ] , [ application . getPropsApp ( ) . getLineRatio1 ( ) , application . getPropsApp ( ) . getLineRatio2 ( ) ] , lineMatrix ) ;
            }
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . curveTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sh - sr - application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        if ( lineNeeded )
        {
          if ( dt == - 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor1 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else if ( dt == 1 )
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsApp ( ) . getLineColor2 ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
          else
          {
            graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , lineColor , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
          }
        }
        graphics . lineTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sr + application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
        graphics . curveTo ( application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , sr + application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) / 2 ) ;
      }
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
      brightMatrix = null ;
      lineMatrix = null ;
      lineColor = 0 ;
      fillColor = 0 ;
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
