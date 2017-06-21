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
** TextInput.
** Single line text input.
**
** MAIN FEATURES:
** - single line text input
** - text to uppercase
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import flash . events . Event ;
  import flash . events . TextEvent ;
  import flash . text . TextFieldType ;
  public class TextInput extends BaseSprite
  {
// The textfield to write in.
    private var baseTextField : BaseTextField = null ;
// There is a background under it.
    private var baseShape : BaseShape = null ;
// The original text has been changed or not.
// ( changed when the user enters text into textfield.)
    private var iniTextChanged : Boolean = false ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextInput ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Now the background.
      baseShape = new BaseShape ( application ) ;
      addChild ( baseShape ) ;
      baseShape . setdb ( false ) ;
      baseShape . setdt ( - 1 ) ;
// The input field of this input.
      baseTextField = new BaseTextField ( application ) ;
      addChild ( baseTextField ) ;
      baseTextField . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      baseTextField . setAutoSizeNone ( ) ;
      baseTextField . type = TextFieldType . INPUT ;
      baseTextField . setswh ( 1 , application . getPropsDyn ( ) . getTextFieldHeight ( baseTextField . getTextType ( ) ) ) ;
      baseTextField . addEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      baseTextFieldRepos ( ) ;
// This events are required for us.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , resize ) ;
    }
/*
** The type of the basetextfield has to be changed.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( getEnabled ( ) )
      {
        baseTextField . type = TextFieldType . INPUT ;
      }
      else
      {
        baseTextField . type = TextFieldType . DYNAMIC ;
      }
    }
/*
** The user enters text into this textfield.
*/
    private function textInput ( e : TextEvent ) : void
    {
      if ( ! iniTextChanged )
      {
        iniTextChanged = true ;
        baseTextField . setTextCode ( baseTextField . text ) ;
      }
    }
/*
** Gets the text of the basetextfield.
*/
    public function getText ( ) : String
    {
      return baseTextField . text ;
    }
/*
** Sets the text to uppercase.
*/
    public function setTextToUpperCase ( ) : void
    {
      baseTextField . setTextToUpperCase ( ) ;
    }
/*
** On changing of the padding.
*/
    private function resize ( e : Event ) : void
    {
      if ( application != null )
      {
        baseTextField . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getTextFieldHeight ( baseTextField . getTextType ( ) ) ) ;
        super . setsh ( baseTextField . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        baseTextFieldRepos ( ) ;
        baseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
        baseShape . drawRect ( ) ;
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** The sh depends on the number of elements to be displayed.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) )
      {
        super . setsw ( Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) ) ;
        resize ( null ) ;
      }
    }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Sets the label of the button.
*/
    public function setTextCode ( newTextCode : String ) : void
    {
      baseTextField . setTextCode ( newTextCode ) ;
    }
/*
** Repositioning the label if necessary.
*/
    private function baseTextFieldRepos ( ) : void
    {
      baseTextField . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
    }
/*
** Restrict.
*/
    public function setRestrict ( r : String ) : void
    {
      baseTextField . restrict = r ;
    }
/*
** maxChars.
*/
    public function setMaxChars ( m : int ) : void
    {
      baseTextField . maxChars = m ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      baseTextField . removeEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseTextField = null ;
      baseShape = null ;
      iniTextChanged = false ;
    }
  }
}