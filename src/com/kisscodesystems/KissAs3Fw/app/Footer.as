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
** Footer.
** This is basically an area at the bottom of the application.
**
** MAIN FEATURES:
** - area with background
** - can follow the size of the stage automatically
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  public class Footer extends BaseSprite
  {
// The shape object of this.
    private var footerShape : BaseShape = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Footer ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Let's create this..
      footerShape = new BaseShape ( application ) ;
      addChild ( footerShape ) ;
      footerShape . setdb ( false ) ;
      footerShape . setdt ( - 1 ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
// So we have to redraw.
      footerRePosSize ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      footerRePosSize ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      footerRePosSize ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      footerRePosSize ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to redraw.
      footerRePosSize ( ) ;
    }
/*
** Overriding the setsw setsh and setswh functions.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Redrawing the shape.
*/
    public function footerRePosSize ( ) : void
    {
      if ( application != null )
      {
        if ( application . getMiddleground ( ) . getFooterh ( ) > 0 )
        {
// Reinitializing and positioning this.
          setcxy ( 0 , application . getMiddleground ( ) . getHeaderh ( ) + application . getMiddleground ( ) . getWidgetsh ( ) ) ;
          super . setswh ( application . getsw ( ) , application . getMiddleground ( ) . getFooterh ( ) ) ;
// Reinitializing and positioning the base shape.
          footerShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
          footerShape . x = application . getPropsDyn ( ) . getAppMargin ( ) ;
          footerShape . y = 0 ;
          footerShape . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
          footerShape . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , getsh ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) ;
// Redrawing the rectangle.
          footerShape . drawRect ( ) ;
        }
        else
        {
          super . setswh ( 0 , 0 ) ;
          setcxy ( 0 , application . getsh ( ) ) ;
          footerShape . x = 0 ;
          footerShape . y = 0 ;
          footerShape . setswh ( 0 , 0 ) ;
          footerShape . clear ( ) ;
        }
      }
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      footerShape = null ;
    }
  }
}