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
** ButtonLink.
** A clickable link surrounded with a base shape rect.
**
** MAIN FUNCTIONS:
** - clickable text label with underline (drawed)
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class ButtonLink extends BaseSprite
  {
// The background of the button.
    private var backgroundBaseShape : BaseShape = null ;
// The link underground of the baseShape.
    private var underlineBaseShape : BaseShape = null ;
// The label of the button.
    protected var textLabel : TextLabel = null ;
// The foreground of the button
    private var foregroundSprite : BaseSprite = null ;
// This will be the event object which will be dispatched.
    private var eventClick : Event = null ;
// This will be the current state to be painted:
// -1: pushed, 0: general, 1: unpushed, 2: no background to paint
    private var state : int = 2 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ButtonLink ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This will be the event of the click.
      eventClick = new Event ( application . EVENT_CLICK ) ;
// Creating the elements of the linkbutton.
      backgroundBaseShape = new BaseShape ( application ) ;
      addChild ( backgroundBaseShape ) ;
      backgroundBaseShape . setdb ( true ) ;
      backgroundBaseShape . setdt ( 0 ) ;
      underlineBaseShape = new BaseShape ( application ) ;
      addChild ( underlineBaseShape ) ;
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
      foregroundSprite = new BaseSprite ( application ) ;
      addChild ( foregroundSprite ) ;
      foregroundSprite . addEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foregroundSprite . addEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      foregroundSprite . addEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
      foregroundSprite . addEventListener ( MouseEvent . CLICK , click ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
    }
/*
** Gets the code of the text forom the label.
*/
    public function getTextCode ( ) : String
    {
      return textLabel . getTextCode ( ) ;
    }
/*
** Sets the label of the button.
*/
    public function setTextCode ( newTextCode : String ) : void
    {
      textLabel . setTextCode ( newTextCode ) ;
    }
/*
** Sets the state of this linkbutton manually.
*/
    public function setState ( i : int ) : void
    {
      if ( i >= - 1 && i <= 2 )
      {
        if ( state != i )
        {
          state = i ;
          repaintBackground ( ) ;
        }
      }
    }
/*
** Mouse events on the foreground.
*/
    private function rollOver ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        setState ( 1 ) ;
      }
    }
    private function rollOut ( e : MouseEvent ) : void
    {
      setState ( 2 ) ;
    }
    private function mouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        setState ( - 1 ) ;
      }
    }
    private function click ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        setState ( 1 ) ;
        baseWorkingButtonClick ( ) ;
      }
    }
/*
** When the resize is needed.
*/
    private function resize ( e : Event ) : void
    {
      if ( application != null )
      {
        super . setswh ( textLabel . getsw ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , textLabel . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        backgroundBaseShape . setswh ( getsw ( ) , getsh ( ) ) ;
        labelRepos ( ) ;
        repaintBackground ( ) ;
        repaintUnderline ( ) ;
        repaintForeground ( ) ;
      }
    }
/*
** Repainting the background.
*/
    private function repaintBackground ( ) : void
    {
      backgroundBaseShape . clear ( ) ;
      backgroundBaseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
      backgroundBaseShape . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
      if ( state == - 1 || state == 0 || state == 1 )
      {
        backgroundBaseShape . setdt ( state ) ;
        backgroundBaseShape . drawRect ( ) ;
      }
    }
/*
** Repositioning the label if necessary.
*/
    private function labelRepos ( ) : void
    {
      textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) - 1 , application . getPropsDyn ( ) . getAppPadding ( ) - 1 ) ;
    }
/*
** This will be called when the button is clicked.
*/
    protected function baseWorkingButtonClick ( ) : void
    {
      getBaseEventDispatcher ( ) . dispatchEvent ( eventClick ) ;
    }
/*
** Repainting the underline.
*/
    private function repaintUnderline ( ) : void
    {
      underlineBaseShape . graphics . clear ( ) ;
      underlineBaseShape . graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppFontColorDark ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
      underlineBaseShape . graphics . moveTo ( textLabel . getcx ( ) , textLabel . getcysh ( ) ) ;
      underlineBaseShape . graphics . lineTo ( textLabel . getcxsw ( ) , textLabel . getcysh ( ) ) ;
    }
/*
** Repainting the foreground.
*/
    private function repaintForeground ( ) : void
    {
      foregroundSprite . graphics . clear ( ) ;
      foregroundSprite . graphics . lineStyle ( 0 , 0 , 0 ) ;
      foregroundSprite . graphics . beginFill ( 0 , 0 ) ;
      foregroundSprite . graphics . drawRoundRect ( 0 , 0 , getsw ( ) , getsh ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
      foregroundSprite . graphics . endFill ( ) ;
    }
/*
** The set size methods have to have no effects.
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
      foregroundSprite . removeEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foregroundSprite . removeEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      foregroundSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
      foregroundSprite . removeEventListener ( MouseEvent . CLICK , click ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventClick != null )
      {
        eventClick . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      backgroundBaseShape = null ;
      underlineBaseShape = null ;
      textLabel = null ;
      foregroundSprite = null ;
      eventClick = null ;
      state = 0 ;
    }
  }
}