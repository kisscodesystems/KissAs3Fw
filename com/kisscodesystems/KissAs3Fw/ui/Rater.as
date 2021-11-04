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
** Rater.
** This can be used to make or display voting.
** Uses stars to visualize the rating.
**
** MAIN FEATURES:
** - one click to rate
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class Rater extends BaseSprite
  {
// This property has to be changed to enable to rate.
// Else this can display a rate by default.
    private var readonly : Boolean = true ;
// This object is usable only once to take a rate.
// If the user wants to rate again then this rater object has to be reloaded.
    private var ratedByMouse : Boolean = false ;
// Stuff to be visible this object.
    private var background : BaseShape = null ;
    private var foreground : BaseSprite = null ;
// This will hold the refs to the icons.
    private var starsArray : Array = null ;
// This is the width of a star, this will be updated if the user
// change this by changing MID textformat.
    private var starsw : int = 0 ;
// This is the rate to be displayed, can be set from outside.
    private var rate : Number = 0 ;
// This will be the event to dispatch when the user clicks.
    private var eventChanged : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Rater ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Base stuff to be created.
// Bg: a base frame like text input
// Fg: an invisible layer to handle mouse interactions.
      background = new BaseShape ( application ) ;
      addChild ( background ) ;
      foreground = new BaseSprite ( application ) ;
      addChild ( foreground ) ;
// This can listen to the following events if it is allowed and no mouse voting has been taken.
      foreground . addEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foreground . addEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
// This will hold the references to the star icon objects.
      starsArray = new Array ( ) ;
// First, this is to get manually.
      getStarw ( ) ;
// .. and creating them.
      createStars ( ) ;
// The event needs to be constructed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// All of these are necessary to handle application level property changing.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textformatChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
    }
/*
** Sets - gets the current rate value from outside.
*/
    public function setRate ( n : Number ) : void
    {
      rate = n ;
      updateRateDisplaying ( rate ) ;
    }
    public function getRate ( ) : Number
    {
      return rate ;
    }
/*
** Sets - gets the readonly property.
*/
    public function setReadonly ( b : Boolean ) : void
    {
      readonly = b ;
      if ( readonly )
      {
        rollOut ( null ) ;
      }
    }
    public function getReadonly ( ) : Boolean
    {
      return readonly ;
    }
/*
** Mouse event handlers. When rolling over, the continuous value displaying
** and the clicking will be available if possible.
*/
    private function rollOver ( e : MouseEvent ) : void
    {
      if ( ! readonly && ! ratedByMouse && getEnabled ( ) )
      {
        foreground . addEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
        foreground . addEventListener ( MouseEvent . CLICK , click ) ;
      }
    }
/*
** On roll out: the clicking and the continuous displaying will be gone.
*/
    private function rollOut ( e : MouseEvent ) : void
    {
      foreground . removeEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
      foreground . removeEventListener ( MouseEvent . CLICK , click ) ;
      updateRateDisplaying ( rate ) ;
    }
/*
** If this handler is registered then the click will create a new rate value,
** and this event will be dispatched to the outside world. Every further mouse
** events will be ignored.
*/
    private function click ( e : MouseEvent ) : void
    {
      ratedByMouse = true ;
      rate = getRateValueByMouse ( ) ;
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
      rollOut ( null ) ;
    }
/*
** Displays the value continuously.
*/
    private function mouseMove ( e : MouseEvent ) : void
    {
      updateRateDisplaying ( getRateValueByMouse ( ) ) ;
    }
/*
** This calculates a value depending on the current mouse position.
*/
    private function getRateValueByMouse ( ) : Number
    {
      return Math . round ( ( foreground . mouseX - application . getPropsDyn ( ) . getAppPadding ( ) ) / starsw * 2 ) / 2 ;
    }
/*
** This one clears all of the stars.
*/
    private function clearStars ( ) : void
    {
      for ( var i : int = 0 ; i < starsArray . length ; i ++ )
      {
        if ( starsArray [ i ] is Icon )
        {
          Icon ( starsArray [ i ] ) . destroy ( ) ;
          removeChild ( Icon ( starsArray [ i ] ) ) ;
          starsArray [ i ] = null ;
        }
      }
      starsArray . splice ( 0 ) ;
    }
/*
** Sets the number of stars, creates them.
*/
    private function createStars ( ) : void
    {
      clearStars ( ) ;
      for ( var i : int = 0 ; i < application . VOTER_STARS ; i ++ )
      {
        var icon : Icon = new Icon ( application ) ;
        addChild ( icon ) ;
        starsArray . push ( icon ) ;
      }
      sizesChanged ( ) ;
      setChildIndex ( foreground , numChildren - 1 ) ;
    }
/*
** Gets the current value of starsw
*/
    private function getStarw ( ) : void
    {
      starsw = application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
    }
/*
** When the textformat has been changed..
*/
    private function textformatChanged ( e : Event ) : void
    {
      getStarw ( ) ;
      sizesChanged ( ) ;
    }
/*
** The padding change causes redrawing this object.
*/
    private function paddingChanged ( e : Event ) : void
    {
      sizesChanged ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      bgfgRedraw ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgfgRedraw ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgfgRedraw ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So, we have to redraw.
      bgfgRedraw ( ) ;
    }
/*
** This is the base of drawing this rater object, bg fg only.
** after sizes, or radius or bg fg colors-alpha changing
*/
    private function bgfgRedraw ( ) : void
    {
      background . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) / 2 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
      background . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
      background . setswh ( getsw ( ) , getsh ( ) ) ;
      background . drawRect ( ) ;
      foreground . graphics . clear ( ) ;
      foreground . graphics . beginFill ( 0 , 0 ) ;
      foreground . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
      foreground . graphics . endFill ( ) ;
    }
/*
** Updates the displaying by the value specified.
*/
    private function updateRateDisplaying ( rate : Number ) : void
    {
      for ( var i : int = 0 ; i < starsArray . length ; i ++ )
      {
        if ( starsArray [ i ] is Icon )
        {
          var iconType : String = "starblank" ;
          if ( i + 0.75 < rate )
          {
            iconType = "starfull" ;
          }
          else if ( i + 0.25 < rate && rate < i + 0.75 )
          {
            iconType = "starhalf" ;
          }
          Icon ( starsArray [ i ] ) . drawBitmapData ( iconType , application . getTexts ( ) . TEXT_TYPE_MID , starsw ) ;
        }
      }
    }
/*
** These have to be executed when the sizes (starsw) or the application padding is changed.
*/
    private function sizesChanged ( ) : void
    {
      for ( var i : int = 0 ; i < starsArray . length ; i ++ )
      {
        if ( starsArray [ i ] is Icon )
        {
          Icon ( starsArray [ i ] ) . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) + i * starsw , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        }
      }
      super . setswh ( 2 * application . getPropsDyn ( ) . getAppPadding ( ) + starsArray . length * starsw , 2 * application . getPropsDyn ( ) . getAppPadding ( ) + starsw ) ;
      bgfgRedraw ( ) ;
      rollOut ( null ) ;
    }
/*
** The set size methods have to have no effects.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Override of destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textformatChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      foreground . removeEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foreground . removeEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      foreground . removeEventListener ( MouseEvent . CLICK , click ) ;
      foreground . removeEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      clearStars ( ) ;
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      readonly = false ;
      ratedByMouse = false ;
      background = null ;
      foreground = null ;
      starsArray = null ;
      starsw = 0 ;
      rate = 0 ;
      eventChanged = null ;
    }
  }
}
