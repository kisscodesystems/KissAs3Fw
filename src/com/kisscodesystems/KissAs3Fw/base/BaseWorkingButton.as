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
** BaseWorkingButton.
** The base working button class.
**
** MAIN FEATURES:
** - can handle: mouse over, mouse out, press, click
** - custom event string can be specified to be able to register into.
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class BaseWorkingButton extends BaseSprite
  {
// The background of the button.
    private var baseButton : BaseButton = null ;
// The content of the button
    protected var contentSprite : BaseSprite = null ;
// The foreground of the button
    private var foregroundSprite : BaseSprite = null ;
// This will be the event object which will be dispatched
// in application . getBaseEventDispatcher ( ).
    private var eventClick : Event = null ;
// Custom event to dispatched.
    private var customEvent : Event = null ;
/*
** Constructs the original object.
*/
    public function BaseWorkingButton ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This event has to be defined now.
      eventClick = new Event ( application . EVENT_CLICK ) ;
// This objects have to be created now.
      baseButton = new BaseButton ( application ) ;
      addChild ( baseButton ) ;
      baseButton . setState ( 0 ) ;
      contentSprite = new BaseSprite ( application ) ;
      addChild ( contentSprite ) ;
      foregroundSprite = new BaseSprite ( application ) ;
      addChild ( foregroundSprite ) ;
// Registering onto these events!
      foregroundSprite . addEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foregroundSprite . addEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      foregroundSprite . addEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
      foregroundSprite . addEventListener ( MouseEvent . CLICK , click ) ;
    }
/*
** Sets the custom event string to be dispatched later.
** Setting it to null clears the custom event and its dispatching.
*/
    public function setCustomEventString ( s : String ) : void
    {
      if ( customEvent != null )
      {
        customEvent . stopImmediatePropagation ( ) ;
        customEvent = null ;
      }
      if ( s != null )
      {
        customEvent = new Event ( s ) ;
      }
    }
/*
** Gets the contentSprite.
*/
    public function getContentSprite ( ) : BaseSprite
    {
      return contentSprite ;
    }
/*
** These mouse events have to be defined: roll over, roll out , mouse down, click.
*/
    private function rollOver ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        baseButton . setState ( 1 ) ;
        contentSprite . setcxy ( 0 , 0 ) ;
      }
    }
    private function rollOut ( e : MouseEvent ) : void
    {
      baseButton . setState ( 0 ) ;
      contentSprite . setcxy ( 0 , 0 ) ;
    }
    private function mouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        baseButton . setState ( 2 ) ;
        contentSprite . setcxy ( 1 , 1 ) ;
      }
    }
    private function click ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        baseButton . setState ( 0 ) ;
        contentSprite . setcxy ( 0 , 0 ) ;
        baseWorkingButtonClick ( ) ;
      }
    }
/*
** This will be called when the button is clicked.
*/
    protected function baseWorkingButtonClick ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventClick ) ;
      }
      if ( application . getBaseEventDispatcher ( ) != null )
      {
        if ( customEvent != null )
        {
          application . getBaseEventDispatcher ( ) . dispatchEvent ( customEvent ) ;
        }
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** Do the same but it is necessary to reposition the actualpos shape.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        resetSizes ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        resetSizes ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        resetSizes ( ) ;
      }
    }
/*
** Resets the properties of this base button.
** And then repaints it of course.
** This method will be registered into the changing of the properties of Application.
*/
    private function resetSizes ( ) : void
    {
      baseButton . setswh ( getsw ( ) , getsh ( ) ) ;
      baseButton . drawRect ( ) ;
      contentSprite . setswh ( getsw ( ) , getsh ( ) ) ;
      foregroundSprite . setswh ( getsw ( ) , getsh ( ) ) ;
      foregroundSprite . graphics . clear ( ) ;
      foregroundSprite . graphics . lineStyle ( 0 , 0 , 0 ) ;
      foregroundSprite . graphics . beginFill ( 0 , 0 ) ;
      foregroundSprite . graphics . drawRoundRect ( 0 , 0 , getsw ( ) , getsh ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
      foregroundSprite . graphics . endFill ( ) ;
    }
/*
** Destroying this object by calling this method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      foregroundSprite . removeEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      foregroundSprite . removeEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      foregroundSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
      foregroundSprite . removeEventListener ( MouseEvent . CLICK , click ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventClick != null )
      {
        eventClick . stopImmediatePropagation ( ) ;
      }
      if ( customEvent != null )
      {
        customEvent . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      foregroundSprite = null ;
      contentSprite = null ;
      baseButton = null ;
      eventClick = null ;
      customEvent = null ;
    }
  }
}