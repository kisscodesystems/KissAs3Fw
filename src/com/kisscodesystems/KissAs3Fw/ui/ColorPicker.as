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
** ColorPicker.
** Openable coloring panel.
**
** MAIN FEATURES:
** - dispatches the event of the changing of the color
** - also when click event occurs on the colored shape
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseOpen ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . Color ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class ColorPicker extends BaseOpen
  {
// The sprite to display the color belonging to the actual value.
    private var baseSprite : BaseSprite = null ;
// The color panel of this colorpicker.
    private var color : Color = null ;
// The event to the outside world of the changing of the color.
    private var eventChanged : Event = null ;
// The type of the text to be used for considering the size of this object.
    private var textType : String = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ColorPicker ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This will be the "text type". ( there is no text to display, just for the resizing)
      textType = application . getTexts ( ) . TEXT_TYPE_MID ;
// Creating the color panel.
      color = new Color ( application ) ;
      contentSprite . addChild ( color ) ;
      color . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , colorChanged ) ;
      color . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , colorResized ) ;
// The content sprite has to be updated now.
      contentSprite . setswh ( color . getsw ( ) , color . getsh ( ) ) ;
// The default color has been changed, message to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// Creating the elements.
      baseSprite = new BaseSprite ( application ) ;
      baseWorkingButton . addChild ( baseSprite ) ;
      resize ( ) ;
      baseSprite . addEventListener ( MouseEvent . ROLL_OUT , baseSpriteRollOut ) ;
      baseSprite . addEventListener ( MouseEvent . MOUSE_DOWN , baseSpriteMouseDown ) ;
      baseSprite . addEventListener ( MouseEvent . CLICK , baseSpriteClick ) ;
// Events to listen to.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
    }
/*
** The color object has been resized.
*/
    private function colorResized ( e : Event ) : void
    {
      contentSprite . setswh ( color . getsw ( ) , color . getsh ( ) ) ;
      if ( isOpened ( ) )
      {
        dispatchEventSizesChanged ( ) ;
      }
    }
/*
** override open.
*/
    override public function open ( ) : void
    {
      super . setswh ( contentSprite . getsw ( ) , contentSprite . getsh ( ) ) ;
      super . open ( ) ;
    }
/*
** override close.
*/
    override public function close ( ) : void
    {
      super . close ( ) ;
      superSetswh ( ) ;
    }
/*
** The color of the color object has been changed.
*/
    private function colorChanged ( e : Event ) : void
    {
      close ( ) ;
      dispatchEventChanged ( ) ;
      baseSpriteColorPos ( ) ;
    }
/*
** Sets the rgb color as a string.
*/
    public function setRGBColor ( s : String ) : void
    {
      color . setRGBColor ( s ) ;
    }
/*
** Gets the rgb color as a string.
*/
    public function getRGBColor ( ) : String
    {
      return color . getRGBColor ( ) ;
    }
/*
** The events of the base sprite to get it working.
*/
    private function baseSpriteRollOut ( e : MouseEvent ) : void
    {
      blurBaseShape ( false ) ;
    }
    private function baseSpriteMouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        blurBaseShape ( true ) ;
      }
    }
    private function baseSpriteClick ( e : MouseEvent ) : void
    {
      blurBaseShape ( false ) ;
      if ( getEnabled ( ) )
      {
        dispatchEventChanged ( ) ;
      }
    }
/*
** The method to dispatch the coloring event (even if the color is the same!)
*/
    private function dispatchEventChanged ( ) : void
    {
      getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
    }
/*
** Creates a blur filter to the baseSprite
*/
    private function blurBaseShape ( b : Boolean ) : void
    {
      baseSprite . filters = b ? [ application . getPropsApp ( ) . getBlurFilterColorPickerColor ( ) ] : null ;
    }
/*
** Resize the button object.
*/
    private function resize ( e : Event = null ) : void
    {
      if ( application != null )
      {
        if ( ! isOpened ( ) )
        {
          superSetswh ( ) ;
          baseSpriteColorPos ( ) ;
        }
      }
    }
/*
** Override the mouse close method!
** the pixel stealing has to be not in progress.
*/
    override protected function hasToCloseByMouse ( e : MouseEvent ) : void
    {
      if ( ! mouseIsOnTheContentSprite ( ) )
      {
        close ( ) ;
      }
    }
/*
** Calling the super . setswh ( )
*/
    private function superSetswh ( ) : void
    {
      super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) * 2 + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
    }
/*
** Displaying the actual color.
*/
    private function baseSpriteColorPos ( ) : void
    {
      baseSprite . setswh ( getsh ( ) / 2 , getsh ( ) / 2 ) ;
      baseSprite . setcxy ( getsh ( ) / 4 , getsh ( ) / 4 ) ;
      baseSprite . graphics . clear ( ) ;
      baseSprite . graphics . lineStyle ( 0 , 0 , 0 ) ;
      baseSprite . graphics . beginFill ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getRGBColor ( ) ) , 1 ) ;
      baseSprite . graphics . drawRect ( 0 , 0 , baseSprite . getsw ( ) , baseSprite . getsh ( ) ) ;
      baseSprite . graphics . endFill ( ) ;
    }
/*
** Overriding the sizer methods.
** (to do nothing.)
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
      baseSprite . removeEventListener ( MouseEvent . ROLL_OUT , baseSpriteRollOut ) ;
      baseSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , baseSpriteMouseDown ) ;
      baseSprite . removeEventListener ( MouseEvent . CLICK , baseSpriteClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseSprite = null ;
      color = null ;
      eventChanged = null ;
      textType = null ;
    }
  }
}