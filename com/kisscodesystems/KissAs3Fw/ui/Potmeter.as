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
  import flash . geom . Matrix ;
  public class Potmeter extends BaseSprite
  {
// The event of the changing of the selected items.
    private var eventChanged : Event = null ;
// Stuff to be visible this object.
    private var background : BaseShape = null ;
// The mover object.
    private var spriteMover : BaseSprite = null ;
// The label object to display the actual state.
    private var textLabel : TextLabel = null ;
// The drawn shapes.
    private var sprite : BaseSprite = null ;
    private var icon : Icon = null ;
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
// Bg.
      background = new BaseShape ( application ) ;
      addChild ( background ) ;
// The drawn shapes.
      sprite = new BaseSprite ( application ) ;
      addChild ( sprite ) ;
// This will be the rotated element.
      icon = new Icon ( application ) ;
      sprite . addChild ( icon ) ;
// The label of the displayed value (when mouse is down -> visible is false by default)
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
// And then mover finally.
      spriteMover = new BaseSprite ( application ) ;
      addChild ( spriteMover ) ;
      spriteMover . addEventListener ( MouseEvent . MOUSE_DOWN , spriteMoverMouseDown ) ;
// The event needs to be constructed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// Events to listen to.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// The initial drawing of the shapes.
      resize ( null ) ;
      stageMouseUp ( null ) ;
    }
/*
** AddedToStage
*/
    override protected function addedToStage ( e : Event ) : void
    {
      super . addedToStage ( e ) ;
      stage . addEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      bgRedraw ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgRedraw ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgRedraw ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgRedraw ( ) ;
    }
/*
** This is the base of drawing this rater object, bg fg only.
** after sizes, or radius or bg fg colors-alpha changing
*/
    private function bgRedraw ( ) : void
    {
      if ( background != null && textLabel != null )
      {
        var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) ;
        background . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) / 2 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        background . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        background . setswh ( textLabel . getcxswap ( ) , tfh + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        background . drawRect ( ) ;
      }
    }
/*
** The mouse events on the mover.
*/
    private function stageMouseUp ( e : MouseEvent ) : void
    {
      var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) ;
      if ( textLabel != null )
      {
        super . setswh ( textLabel . getcxsw ( ) + application . getPropsDyn ( ) . getAppPadding ( ) , tfh + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
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
      updateShapes ( ) ;
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
      reposTextLabel ( ) ;
      updateShapes ( ) ;
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
        textLabel . setTextCode ( "" + val ) ;
        reposTextLabel ( ) ;
      }
    }
/*
** Repositions the text label.
*/
    private function reposTextLabel ( ) : void
    {
      var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) ;
      textLabel . setcxy ( tfh + application . getPropsDyn ( ) . getAppPadding ( ) , ( tfh + application . getPropsDyn ( ) . getAppPadding ( ) * 2 - textLabel . getsh ( ) ) / 2 ) ;
    }
/*
** Redrawing the shape objects. ( draw and mask)
*/
    private function updateShapes ( ) : void
    {
      var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) ;
      spriteMover . graphics . clear ( ) ;
      spriteMover . graphics . lineStyle ( 0 , 0 , 0 ) ;
      spriteMover . graphics . beginFill ( 0 , 0 ) ;
      spriteMover . graphics . drawRect ( 0 , 0 , textLabel . getcxswap ( ) , tfh + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      spriteMover . graphics . endFill ( ) ;
      calcPxsPerInc ( ) ;
      bgRedraw ( ) ;
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
      spriteMover . removeEventListener ( MouseEvent . MOUSE_DOWN , spriteMoverMouseDown ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      removeEventListener ( Event . ENTER_FRAME , updatePotmeter ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      eventChanged = null ;
      background = null ;
      spriteMover = null ;
      textLabel = null ;
      sprite = null ;
      icon = null ;
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
