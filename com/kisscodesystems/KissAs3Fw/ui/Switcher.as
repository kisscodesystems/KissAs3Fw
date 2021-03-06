/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3FwDemos
**
** DESCRIPTION:
** Switcher.
** An object that can be up or down.
**
** MAIN FEATURES:
** - states: up (true) or down (false)
** - different text codes are able to specify for up and down state
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . filters . GlowFilter ;
  public class Switcher extends BaseSprite
  {
// The padding size of the drawn.
    private var drawnPadding : int = 0 ;
// The label of this switcher.
    private var textLabel : TextLabel = null ;
// The foreground of the switcher.
    private var foregroundSprite : BaseSprite = null ;
// This will be drawn.
    private var drawn : BaseShape = null ;
// And this will contain the drawn.
    private var drawnContainer : BaseSprite = null ;
// The text of the up and down switcher.
    private var textUp : String = null ;
    private var textDown : String = null ;
// up or not.
    private var up : Boolean = false ;
// The event object to be dispatched.
    private var eventChanged : Event = null ;
// The glow filter of the up switcher.
    private var glowFilter : GlowFilter = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Switcher ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The text to be displayed.
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
// The drawn container.
      drawnContainer = new BaseSprite ( application ) ;
      addChild ( drawnContainer ) ;
// The object to be drawn.
      drawn = new BaseShape ( application ) ;
      drawnContainer . addChild ( drawn ) ;
// The foreground.
      foregroundSprite = new BaseSprite ( application ) ;
      addChild ( foregroundSprite ) ;
      foregroundSprite . addEventListener ( MouseEvent . CLICK , foregroundSpriteClick ) ;
      foregroundSprite . addEventListener ( MouseEvent . MOUSE_DOWN , foregroundSpriteMouseDown ) ;
      foregroundSprite . addEventListener ( MouseEvent . ROLL_OUT , foregroundSpriteRollOut ) ;
// This is the event when the label is resized.
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
// This event will trigger the change of the selection to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// Litening to the changing events of the application.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
// First draw.
      resize ( null ) ;
    }
/*
** Mouse down on the foreground.
*/
    private function foregroundSpriteMouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        draw ( true ) ;
      }
    }
/*
** Click on the foreground: let's modify the value to its opposite.
*/
    private function foregroundSpriteClick ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        setUp ( ! up ) ;
      }
    }
/*
** Roll out on the foreground.
*/
    private function foregroundSpriteRollOut ( e : MouseEvent ) : void
    {
      draw ( ) ;
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** The sh depends on the number of elements to be displayed.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** The content of the label or some of the properties of the application has been changed.
*/
    private function resize ( e : Event ) : void
    {
      if ( application != null )
      {
        textLabel . setcxy ( application . getPropsDyn ( ) . getTextFieldHeight ( textLabel . getTextType ( ) ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        super . setswh ( textLabel . getcxswap ( ) , textLabel . getcyshap ( ) ) ;
        draw ( ) ;
      }
    }
/*
** Draws the switcher.
*/
    private function draw ( buttonDown : Boolean = false ) : void
    {
// The drawnPadding is set according to the size of this object.
      drawnPadding = getsh ( ) / 7 ;
// Clearing, initializing.
      drawn . graphics . clear ( ) ;
      drawn . graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppFontColorMid ( ) , 1 ) ;
// Drawing.
      if ( buttonDown )
      {
// If the button is down then it will be a simple square and the applied filter will be untouched.
        drawn . graphics . moveTo ( drawnPadding / 2 , 0 ) ;
        drawn . graphics . lineTo ( getsh ( ) - drawnPadding / 2 , 0 ) ;
        drawn . graphics . lineTo ( getsh ( ) - drawnPadding / 2 , getsh ( ) ) ;
        drawn . graphics . lineTo ( drawnPadding / 2 , getsh ( ) ) ;
        drawn . graphics . lineTo ( drawnPadding / 2 , 0 ) ;
      }
      else
      {
// Let's clear the filter first.
        drawnContainer . filters = null ;
// Then let's draw according to the value of up.
        if ( up )
        {
          drawn . graphics . moveTo ( drawnPadding , 0 ) ;
          drawn . graphics . lineTo ( getsh ( ) - drawnPadding , 0 ) ;
          drawn . graphics . lineTo ( getsh ( ) , getsh ( ) ) ;
          drawn . graphics . lineTo ( 0 , getsh ( ) ) ;
          drawn . graphics . lineTo ( drawnPadding , 0 ) ;
// Creation of a new glow filter and apply it if this switcher is up.
          glowFilter = new GlowFilter ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , 2 , 8 , 8 , 3 , 3 , false , false ) ;
          drawnContainer . filters = [ glowFilter ] ;
        }
        else
        {
          drawn . graphics . moveTo ( 0 , 0 ) ;
          drawn . graphics . lineTo ( getsh ( ) , 0 ) ;
          drawn . graphics . lineTo ( getsh ( ) - drawnPadding , getsh ( ) ) ;
          drawn . graphics . lineTo ( drawnPadding , getsh ( ) ) ;
          drawn . graphics . lineTo ( 0 , 0 ) ;
        }
      }
// Applying the drop shadow filter to the shape as it would be text.
      if ( application . brightShadowToApply ( application . getPropsDyn ( ) . getAppFontColorMid ( ) . toString ( 16 ) ) )
      {
        drawn . filters = application . TEXT_DROP_SHADOW_ARRAY_BRIGHT ;
      }
      else
      {
        drawn . filters = application . TEXT_DROP_SHADOW_ARRAY_DARK ;
      }
// The foreground (click area) also has to be resized.
      foregroundSprite . graphics . clear ( ) ;
      foregroundSprite . graphics . lineStyle ( 0 , 0 , 0 ) ;
      foregroundSprite . graphics . beginFill ( 0 , 0 ) ;
      foregroundSprite . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
      foregroundSprite . graphics . endFill ( ) ;
    }
/*
** Gets the selection of the switcher.
*/
    public function getUp ( ) : Boolean
    {
      return up ;
    }
/*
** Sets the selection if it is different from the current value
** and does all of the configuration.
*/
    public function setUp ( s : Boolean ) : void
    {
      if ( ! s )
      {
        if ( up )
        {
          up = false ;
          textLabel . setTextCode ( textDown ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
          draw ( ) ;
        }
      }
      else
      {
        if ( ! up )
        {
          up = true ;
          textLabel . setTextCode ( textUp ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
          draw ( ) ;
        }
      }
    }
/*
** Sets the texts (tu: up text, td: down text) of this switcher.
*/
    public function setTextCodes ( tu : String , td : String ) : void
    {
      textUp = tu ;
      textDown = td ;
      if ( up )
      {
        textLabel . setTextCode ( textUp ) ;
      }
      else
      {
        textLabel . setTextCode ( textDown ) ;
      }
      draw ( ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      foregroundSprite . removeEventListener ( MouseEvent . CLICK , foregroundSpriteClick ) ;
      foregroundSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , foregroundSpriteMouseDown ) ;
      foregroundSprite . removeEventListener ( MouseEvent . ROLL_OUT , foregroundSpriteRollOut ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      drawnPadding = 0 ;
      textLabel = null ;
      foregroundSprite = null ;
      drawn = null ;
      drawnContainer = null ;
      textUp = null ;
      textDown = null ;
      up = false ;
      eventChanged = null ;
      glowFilter = null ;
    }
  }
}