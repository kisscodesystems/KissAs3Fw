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
** BaseButton.
** Button behaviour but has to be changed from outside.
**
** MAIN FEATURES:
** - Has 3 states:
**   - 0 (default)
**   - 1 (highlighted)
**   - 2 (pushed)
** - It will register for the events of changing the properties of Application.
**
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import flash . events . Event ;
  public class BaseButton extends BaseShape
  {
// Storing the actual state of this base button.
// Possible values: 0, 1, 2
    private var state : int = - 1 ;
/*
** Constructs the original Shape.
*/
    public function BaseButton ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Registering onto these events!
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// First time reset.
      reset ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      reset ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      reset ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      reset ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to redraw the header, footer shapes and widgets.
      reset ( ) ;
    }
/*
** Sets the actual state of this base button.
** 0,1,2 are the acceptable values.
*/
    public function setState ( state : int ) : void
    {
// If this is a different value.
      if ( this . state != state )
      {
// If the state is an expected value.
        if ( state == 0 || state == 1 || state == 2 )
        {
// Let's mark this.
          this . state = state ;
// Let's repaint the object.
          repaint ( ) ;
        }
      }
    }
/*
** Resets the properties of this base button and then repaints it of course.
** This method will be registered into the changing of the properties of Application.
*/
    private function reset ( ) : void
    {
      if ( application != null )
      {
        setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        repaint ( ) ;
      }
    }
/*
** Repaints the button according to the current state of this button.
*/
    private function repaint ( ) : void
    {
      if ( state == 0 )
      {
        setdb ( false ) ;
        setdt ( 1 ) ;
        drawRect ( ) ;
      }
      else if ( state == 1 )
      {
        setdb ( true ) ;
        setdt ( 1 ) ;
        drawRect ( ) ;
      }
      else if ( state == 2 )
      {
        setdb ( false ) ;
        setdt ( - 1 ) ;
        drawRect ( ) ;
      }
    }
/*
** Destroying this object by calling this method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      state = 0 ;
    }
  }
}