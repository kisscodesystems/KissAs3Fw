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
** BaseOpen.
** This is the base of the openable components
** like listpicker, timepicker or colorpicker.
**
** MAIN FEATURES:
** - has a base working button
** - opens and close methods
** - decides when to close by mouse and keyboard
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . Event ;
  import flash . events . KeyboardEvent ;
  import flash . events . MouseEvent ;
  import flash . ui . Keyboard ;
  public class BaseOpen extends BaseSprite
  {
// This will be the background of the object.
    protected var baseWorkingButton : BaseWorkingButton = null ;
// This will contain the opened object. Its size has to be updated!
    protected var contentSprite : BaseSprite = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseOpen ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creation of the background of this object.
      baseWorkingButton = new BaseWorkingButton ( application ) ;
      addChild ( baseWorkingButton ) ;
      baseWorkingButton . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , baseWorkingButtonClick ) ;
// The base sprite always presents but not visible if it is closed.
      contentSprite = new BaseSprite ( application ) ;
      addChild ( contentSprite ) ;
      contentSprite . visible = false ;
      baseWorkingButton . visible = true ;
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
        baseWorkingButton . setsw ( getsw ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        baseWorkingButton . setsh ( getsh ( ) ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        baseWorkingButton . setswh ( getsw ( ) , getsh ( ) ) ;
      }
    }
/*
** Override setEnabled. This property has to be piped to the base working button object.
*/
    override public function setEnabled ( b : Boolean ) : void
    {
      super . setEnabled ( b ) ;
      baseWorkingButton . setEnabled ( b ) ;
    }
/*
** This will be happened if the base button is pressed.
** The Base Open object will be opened.
*/
    protected function baseWorkingButtonClick ( e : Event ) : void
    {
      open ( ) ;
    }
/*
** Opens the conponent, some things are happened here.
*/
    public function open ( ) : void
    {
// First, the visible of the button and the content is replaced.
      contentSprite . visible = true ;
      baseWorkingButton . visible = false ;
// Listening to the mouse and keyboard events (when to close).
      if ( stage != null )
      {
        stage . addEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse , false , 0 , true ) ;
        stage . addEventListener ( KeyboardEvent . KEY_DOWN , hasToCloseByKeyboard , false , 0 , true ) ;
      }
// Be visible if not.
      toBeVisible ( ) ;
    }
/*
** This method will decide to close the contentSprite or not (by mouse).
*/
    protected function hasToCloseByMouse ( e : MouseEvent ) : void
    {
      if ( ! mouseIsOnTheContentSprite ( ) )
      {
        close ( ) ;
      }
    }
/*
** The mouse is on the area of the contentSprite?
*/
    protected function mouseIsOnTheContentSprite ( ) : Boolean
    {
      if ( contentSprite != null )
      {
        return ( mouseX >= contentSprite . getcx ( ) && mouseX <= contentSprite . getcxsw ( ) && mouseY >= contentSprite . getcy ( ) && mouseY <= contentSprite . getcysh ( ) ) ;
      }
      else
      {
        return true ;
      }
    }
/*
** This method will decide to close the contentSprite or not (by keyboard).
*/
    private function hasToCloseByKeyboard ( e : KeyboardEvent ) : void
    {
      if ( e . keyCode == Keyboard . TAB || e . keyCode == Keyboard . ESCAPE )
      {
        close ( ) ;
      }
    }
/*
** Closes the component.
*/
    public function close ( ) : void
    {
// The listeners should be unregistered.
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_DOWN , hasToCloseByKeyboard ) ;
      }
// The visible properties have to be replaced again.
      contentSprite . visible = false ;
      baseWorkingButton . visible = true ;
// To the highest depth!
      toTheLowestDepth ( ) ;
    }
/*
** Is the component opened?
*/
    public function isOpened ( ) : Boolean
    {
      return contentSprite . visible ;
    }
/*
** Overriding destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_DOWN , hasToCloseByKeyboard ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// (removing any object added before into this sprite.)
// The grabage collecting has to be executed now.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseWorkingButton = null ;
      contentSprite = null ;
    }
  }
}
