/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** Potmet. This object can be the numeric stepper.
**
** MAIN FEATURES:
** - min max and inc value can be specified
** - the decimal precision can be specified too
** - a glow filter is displayed in the size depending on the current value.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . filters . GlowFilter ;
  import flash . geom . Matrix ;
  public class Potmeter extends BaseSprite
  {
// The event of the changing of the selected items.
    private var eventChanged : Event = null ;
// The mover object.
    private var spriteMover : BaseSprite = null ;
// The label object to display the actual state.
    private var textLabel : TextLabel = null ;
// The drawn shapes.
    private var sprite : BaseSprite = null ;
    private var icon : Icon = null ;
// And the container of the shapes.
    private var drawContainer : BaseSprite = null ;
// The glow filter of the potmeter.
    private var glowFilter : GlowFilter = null ;
// The values of this object. min-max values and the increase and the current and temp value.
    private var minValue : Number = 0 ;
    private var maxValue : Number = 0 ;
    private var incValue : Number = 0 ;
    private var curValue : Number = 0 ;
    private var tmpValue : Number = 0 ;
// The radiuses of the circles.
    private var radius : int = 0 ;
    private var radiusLittle : int = 0 ;
// What is the size of the expectable glow filter.
    private var factor : Number = 0 ;
// The decimal precision of the values to be displayed.
    private var decimalPrecision : int = 2 ;
// How many pixels have to be dragged to increase 1 time.
// At least 1 pixel per inc will be calculated.
    private var pxsPerInc : int = 1 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Potmeter ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The container first.
      drawContainer = new BaseSprite ( application ) ;
      addChild ( drawContainer ) ;
// The drawn shapes.
      sprite = new BaseSprite ( application ) ;
      drawContainer . addChild ( sprite ) ;
// This will be the rotated element.
      icon = new Icon ( application ) ;
      sprite . addChild ( icon ) ;
// The label of the displayed value (when mouse is down -> visible is false by default)
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
      textLabel . visible = false ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
// And then mover finally.
      spriteMover = new BaseSprite ( application ) ;
      addChild ( spriteMover ) ;
      spriteMover . addEventListener ( MouseEvent . ROLL_OVER , spriteMoverRollOver ) ;
      spriteMover . addEventListener ( MouseEvent . ROLL_OUT , spriteMoverRollOut ) ;
      spriteMover . addEventListener ( MouseEvent . MOUSE_DOWN , spriteMoverMouseDown ) ;
      spriteMover . addEventListener ( MouseEvent . CLICK , spriteMoverClick ) ;
// The event needs to be constructed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// Events to listen to.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// The initial drawing of the shapes.
      resize ( null ) ;
    }
/*
** The mouse events on the mover.
*/
    private function spriteMoverRollOver ( e : MouseEvent ) : void
    {
      textLabel . visible = true ;
    }
    private function spriteMoverRollOut ( e : MouseEvent ) : void
    {
      textLabel . visible = false ;
      moverReset ( ) ;
    }
    private function spriteMoverMouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        addEventListener ( Event . ENTER_FRAME , updatePotmeter ) ;
        spriteMover . startDrag ( ) ;
        toTheHighestDepth ( ) ;
      }
    }
    private function spriteMoverClick ( e : MouseEvent ) : void
    {
      moverReset ( ) ;
    }
/*
** Sets the precision of the potmeter.
*/
    public function setDecimalPrecision ( i : int ) : void
    {
      if ( decimalPrecision != i && i >= 0 && i <= 10 )
      {
        decimalPrecision = i ;
        setCurValue ( curValue ) ;
      }
    }
/*
** Gets the decimal precision.
*/
    public function getDecimalPrecision ( ) : int
    {
      return decimalPrecision ;
    }
/*
** Updating the whole potmeter.
*/
    private function updatePotmeter ( e : Event ) : void
    {
      tmpValue = Math . round ( ( curValue - Math . round ( spriteMover . y / pxsPerInc ) * incValue + Math . round ( spriteMover . x / pxsPerInc ) * incValue ) * Math . pow ( 10 , decimalPrecision ) ) / Math . pow ( 10 , decimalPrecision ) ;
      if ( tmpValue < minValue )
      {
        tmpValue = minValue ;
      }
      else if ( tmpValue > maxValue )
      {
        tmpValue = maxValue ;
      }
      updateDisplaying ( tmpValue ) ;
    }
/*
** Resetting the mover object.
*/
    private function moverReset ( ) : void
    {
      spriteMover . stopDrag ( ) ;
      removeEventListener ( Event . ENTER_FRAME , updatePotmeter ) ;
      if ( getEnabled ( ) )
      {
        setCurValue ( tmpValue ) ;
        toTheLowestDepth ( ) ;
      }
      spriteMover . x = 0 ;
      spriteMover . y = 0 ;
    }
/*
** When the resizing is needed.
*/
    private function resize ( e : Event ) : void
    {
      var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) ;
      icon . drawBitmapData ( "potmeter" , textLabel . getTextType ( ) , tfh ) ;
      icon . setcxy ( - tfh / 2 , - tfh / 2 ) ;
      sprite . setcxy ( tfh / 2 + application . getPropsDyn ( ) . getAppPadding ( ) , tfh / 2 + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      super . setswh ( tfh + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , tfh + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      recreateGlowFilter ( Math . round ( ( curValue - minValue ) / ( maxValue - minValue ) * application . getPropsApp ( ) . getMaxBlur ( ) ) ) ;
      updateShapes ( ) ;
      reposTextLabel ( ) ;
    }
/*
** Recreates a glow filter based on the factor.
*/
    private function recreateGlowFilter ( blur : int ) : void
    {
      glowFilter = new GlowFilter ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , blur / application . getPropsApp ( ) . getMaxBlur ( ) , blur , blur , blur , 3 ) ;
      filters = [ glowFilter ] ;
    }
/*
** Only the rotating and the glow filter will be updated.
** Don't consider the precision here!
*/
    private function updateDisplaying ( val : Number ) : void
    {
      if ( application != null && sprite != null && textLabel != null )
      {
        factor = ( val - minValue ) / ( maxValue - minValue ) ;
        sprite . rotation = 240 * factor - 120 ;
        if ( glowFilter . blurX != Math . round ( application . getPropsApp ( ) . getMaxBlur ( ) * factor ) )
        {
          recreateGlowFilter ( Math . round ( application . getPropsApp ( ) . getMaxBlur ( ) * factor ) ) ;
        }
        textLabel . setTextCode ( "" + val ) ;
        reposTextLabel ( ) ;
      }
    }
/*
** Repositions the text label.
*/
    private function reposTextLabel ( ) : void
    {
      textLabel . setcxy ( ( getsw ( ) - textLabel . getsw ( ) ) / 2 , ( getsh ( ) - textLabel . getsh ( ) ) / 2 ) ;
    }
/*
** Redrawing the shape objects. ( draw and mask)
*/
    private function updateShapes ( ) : void
    {
      spriteMover . graphics . clear ( ) ;
      spriteMover . graphics . lineStyle ( 0 , 0 , 0 ) ;
      spriteMover . graphics . beginFill ( 0 , 0 ) ;
      spriteMover . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
      spriteMover . graphics . endFill ( ) ;
      if ( application . brightShadowToApply ( application . getPropsDyn ( ) . getAppFontColorMid ( ) . toString ( 16 ) ) )
      {
        drawContainer . filters = application . TEXT_DROP_SHADOW_ARRAY_BRIGHT ;
      }
      else
      {
        drawContainer . filters = application . TEXT_DROP_SHADOW_ARRAY_DARK ;
      }
      calcPxsPerInc ( ) ;
    }
/*
** Sets the min-max-inc values.
** The difference of max and min has to be the multiply of the inc!
*/
    public function setMinMaxIncValues ( min : Number , max : Number , inc : Number ) : void
    {
      if ( min < max && Math . floor ( ( max - min ) / inc ) == ( max - min ) / inc )
      {
        minValue = min ;
        maxValue = max ;
        incValue = inc ;
        calcPxsPerInc ( ) ;
        if ( curValue < minValue )
        {
          setCurValue ( minValue ) ;
        }
        else if ( curValue > maxValue )
        {
          setCurValue ( maxValue ) ;
        }
        updateDisplaying ( curValue ) ;
      }
    }
/*
** Calculates the speed of the increasing.
*/
    private function calcPxsPerInc ( ) : void
    {
      pxsPerInc = Math . max ( 1 , Math . round ( 3 * getsh ( ) / ( ( maxValue - minValue ) / incValue ) ) ) ;
    }
/*
** Sets the current value.
*/
    public function setCurValue ( n : Number ) : void
    {
      if ( n >= minValue && n <= maxValue && curValue != Math . round ( n * Math . pow ( 10 , decimalPrecision ) ) / Math . pow ( 10 , decimalPrecision ) )
      {
        curValue = Math . round ( n * Math . pow ( 10 , decimalPrecision ) ) / Math . pow ( 10 , decimalPrecision ) ;
        tmpValue = curValue ;
        updateDisplaying ( curValue ) ;
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
    }
/*
** Gets the value of the object.
*/
    public function getCurValue ( ) : Number
    {
      return curValue ;
    }
/*
** Overriding the setsw setsh and setswh functions.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      spriteMover . removeEventListener ( MouseEvent . ROLL_OVER , spriteMoverRollOver ) ;
      spriteMover . removeEventListener ( MouseEvent . ROLL_OUT , spriteMoverRollOut ) ;
      spriteMover . removeEventListener ( MouseEvent . MOUSE_DOWN , spriteMoverMouseDown ) ;
      spriteMover . removeEventListener ( MouseEvent . CLICK , spriteMoverClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      removeEventListener ( Event . ENTER_FRAME , updatePotmeter ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
      filters = null ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      eventChanged = null ;
      spriteMover = null ;
      textLabel = null ;
      sprite = null ;
      icon = null ;
      drawContainer = null ;
      glowFilter = null ;
      minValue = 0 ;
      maxValue = 0 ;
      incValue = 0 ;
      curValue = 0 ;
      tmpValue = 0 ;
      radius = 0 ;
      radiusLittle = 0 ;
      factor = 0 ;
      decimalPrecision = 0 ;
      pxsPerInc = 0 ;
    }
  }
}
