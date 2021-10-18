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
** BasePanel.
** This is used as a background and content for example in the settings or the menu.
**
** MAIN FEATURES:
** - base shape (background) + content
** - the content is multiple so multiple paged content is available by default!
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class BasePanel extends BaseSprite
  {
// The event of closing this object (click elsewhere)
    private var eventClosed : Event = null ;
// The base shape object to have.
    private var baseShape : BaseShape = null ;
// A content to hold the items.
    protected var contentMultiple : ContentMultiple = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function BasePanel ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// This event will be dispatched when the user click elsewhere.
      eventClosed = new Event ( application . EVENT_CLOSED ) ;
// Now the base shape.
      baseShape = new BaseShape ( application ) ;
      addChild ( baseShape ) ;
      baseShape . setdb ( true ) ;
      baseShape . setdt ( - 1 ) ;
// The content.
      contentMultiple = new ContentMultiple ( application ) ;
      addChild ( contentMultiple ) ;
// Registering into these events.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// Closed by default.
      visible = false ;
    }
/*
** Sets the default content.
*/
    public function setDefaultContent ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setDefaultContent ( ) ;
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
        stuffsResize ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        stuffsResize ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        stuffsResize ( ) ;
      }
    }
/*
** The line thickness of the application has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to redraw and resize.
      stuffsResize ( ) ;
    }
/*
** Redrawing the shape and resizing of the content.
*/
    private function stuffsResize ( ) : void
    {
      if ( application != null )
      {
        baseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , ( application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) + ( 1 - application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) ) * 3 / 4 ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
        baseShape . drawRect ( ) ;
        contentMultiple . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        contentMultiple . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) , getsh ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      }
    }
/*
** Opens the panel.
*/
    public function open ( ) : void
    {
// It is visible.
      visible = true ;
// The listener must listens when to close this.
      if ( stage != null )
      {
        stage . addEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse , false , 0 , true ) ;
      }
    }
/*
** Closes the panel.
*/
    public function close ( ) : void
    {
// It is not visible.
      visible = false ;
// It is removable.
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse ) ;
      }
// The closed event has to be dispatched.
      getBaseEventDispatcher ( ) . dispatchEvent ( eventClosed ) ;
    }
/*
** This method will decide to close or not (by mouse).
*/
    protected function hasToCloseByMouse ( e : MouseEvent ) : void
    {
      if ( ! mouseIsOnTheContent ( ) )
      {
        close ( ) ;
      }
    }
/*
** The mouse is on the area of the content?
*/
    protected function mouseIsOnTheContent ( ) : Boolean
    {
      return ( mouseX >= 0 && mouseX <= getsw ( ) && mouseY >= 0 && mouseY <= getsh ( ) ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse ) ;
      }
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventClosed != null )
      {
        eventClosed . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      eventClosed = null ;
      baseShape = null ;
      contentMultiple = null ;
    }
  }
}
