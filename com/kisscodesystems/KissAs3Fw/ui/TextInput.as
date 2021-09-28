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
** TextInput.
** Single line text input.
**
** MAIN FEATURES:
** - single line text input
** - text to uppercase
** - auto completion
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  import flash . events . FocusEvent ;
  import flash . events . KeyboardEvent ;
  import flash . events . TextEvent ;
  import flash . text . TextFieldType ;
  import flash . ui . Keyboard ;
  public class TextInput extends BaseSprite
  {
// The textfield to write in.
    private var baseTextField : BaseTextField = null ;
// There is a background under it.
    private var baseShape : BaseShape = null ;
// The original text has been changed or not.
// ( changed when the user enters text into textfield.)
    private var iniTextChanged : Boolean = false ;
// Auto complete these items. (Not using text codes.)
    private var autoCompleteThese : Array = null ;
// The list of separator chars to use in this order
    private var autoCompleteSeparatorChar : String = null ;
// The list object of the autocompletion
    private var autoCompleteList : ListPanel = null ;
// The current hits for autocompletion
    private var autoCompleteCurrents : Array = null ;
// The strings to use for auto completion.
    private var toAutoComplete0 : String = "" ;
    private var toAutoComplete1 : String = "" ;
// The event if the text (after ENTER) has been changed.
    private var eventChanged : Event = null ;
// Content and its original y position has to be saved if it is mobile mode.
    private var contentSprite : BaseSprite = null ;
    private var backSprite : BaseSprite = null ;
    private var origContentPos : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextInput ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The changed event.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
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
      baseTextField . addEventListener ( FocusEvent . FOCUS_OUT , focusOut ) ;
      baseTextField . addEventListener ( FocusEvent . FOCUS_IN , focusIn ) ;
      baseTextField . addEventListener ( KeyboardEvent . KEY_UP , keyUp ) ;
      baseTextField . addEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      baseTextFieldRepos ( ) ;
// This events are required for us.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , resize ) ;
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
** Sets the password property of its textfield
*/
    public function setDisplayAsPassword ( b : Boolean ) : void
    {
      baseTextField . setDisplayAsPassword ( b ) ;
    }
/*
** Get this into the focus! (and make it visible if not visible on the content)
*/
    public function toFocus ( ) : void
    {
      if ( stage != null )
      {
        stage . focus = baseTextField ;
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          toBeVisible ( ) ;
        }
      }
    }
/*
** Adds auto complete elements. null clears the functionality.
*/
    public function addAutoCompleteElements ( elements : String , separator : String ) : void
    {
// Removing the already used elements.
      if ( autoCompleteThese != null )
      {
        autoCompleteThese . splice ( 0 ) ;
        autoCompleteThese = null ;
      }
// null value means reset this feature to disabled.
      if ( elements != null && separator != null )
      {
// The array has to be recreated at this point.
        autoCompleteThese = elements . split ( separator ) ;
// This will be the separator in the input field too.
        autoCompleteSeparatorChar = separator ;
      }
    }
/*
** When the input field gets the focus.
** Mobile mode: the input has to be moved to the top of the screen!
** User wants to see what is typed into it.
** TextInput and TextArea contains the same implementation.
*/
    private function focusIn ( e : FocusEvent ) : void
    {
      if ( ! application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        var currentObject : DisplayObject = DisplayObject ( this ) ;
        if ( currentObject != null )
        {
          var currentParent : DisplayObject = currentObject . parent ;
          var dist : int = y ;
          while ( currentParent != null )
          {
            if ( currentParent is DisplayObject )
            {
              dist += DisplayObject ( currentParent ) . y ;
              if ( currentParent is ContentSingle )
              {
                if ( currentParent . parent != null && currentParent . parent is ContentMultiple )
                {
                  dist -= ContentMultiple ( currentParent . parent ) . getButtonBarcysh ( ) ;
                }
                var contentSingle : ContentSingle = ContentSingle ( currentParent ) ;
                contentSprite = ContentSingle ( currentParent ) . getBaseSprite ( ) ;
                backSprite = ContentSingle ( currentParent ) . getBackSprite ( ) ;
                if ( contentSingle != null && contentSprite != null && backSprite != null )
                {
                  origContentPos = contentSprite . y ;
                  contentSprite . y = application . getPropsApp ( ) . getScrollMargin ( ) + application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) - dist + contentSingle . getBaseScroll ( ) . getccy ( ) ;
                  backSprite . y = contentSprite . y ;
                }
                break ;
              }
              currentObject = currentParent ;
              currentParent = currentObject . parent ;
            }
            else
            {
              break ;
            }
          }
        }
      }
    }
/*
** When the input field losts the focus.
** Mobile mode: the input has to be moved back to its original position !
*/
    private function focusOut ( e : FocusEvent ) : void
    {
      if ( autoCompleteList != null )
      {
        if ( ! ( mouseX >= autoCompleteList . getcx ( ) && mouseX <= autoCompleteList . getcxsw ( ) && mouseY >= autoCompleteList . getcy ( ) && mouseY <= autoCompleteList . getcysh ( ) ) )
        {
          autoCompleteListRemove ( ) ;
        }
      }
      if ( ! application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        if ( contentSprite != null )
        {
          contentSprite . y = origContentPos ;
        }
        if ( backSprite != null )
        {
          backSprite . y = origContentPos ;
        }
      }
    }
/*
** Dispatches the event about the changing of the text. (Usually ENTER was hit.)
*/
    private function dispatchEventChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
    }
/*
** Changed event can be thrown if the enter was hit.
*/
    private function keyUp ( e : KeyboardEvent ) : void
    {
      if ( e != null )
      {
        if ( e . keyCode == Keyboard . ENTER || e . keyCode == Keyboard . NUMPAD_ENTER )
        {
          dispatchEventChanged ( ) ;
        }
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
// Auto completion will happen if this array is not null.
      if ( autoCompleteThese != null && e != null )
      {
// The String that should be autocompleted: string from the beginning of the text or from the last separator.
        var currentText : String = baseTextField . text + e . text ;
// Auto completion will happen if the cursor in the last position.
        if ( baseTextField . caretIndex == currentText . length - 1 )
        {
          if ( currentText . lastIndexOf ( autoCompleteSeparatorChar ) == - 1 )
          {
            toAutoComplete0 = currentText ;
          }
          else
          {
            toAutoComplete0 = currentText . substr ( currentText . lastIndexOf ( autoCompleteSeparatorChar ) + 1 ) ;
          }
// Only if it has a valid value (non-empty)
          if ( toAutoComplete0 != "" )
          {
            if ( currentText . lastIndexOf ( autoCompleteSeparatorChar ) == - 1 )
            {
              toAutoComplete1 = "" ;
            }
            else
            {
              toAutoComplete1 = currentText . substr ( 0 , currentText . lastIndexOf ( autoCompleteSeparatorChar + toAutoComplete0 ) ) ;
            }
            if ( autoCompleteCurrents != null )
            {
              autoCompleteCurrents . splice ( 0 ) ;
              autoCompleteCurrents = null ;
            }
            autoCompleteCurrents = new Array ( ) ;
// Can we find such an element?
            var foundElements : int = 0 ;
            for ( var i : int = 0 ; i < autoCompleteThese . length ; i ++ )
            {
              if ( autoCompleteThese [ i ] != null && autoCompleteThese [ i ] . indexOf ( toAutoComplete0 ) == 0 )
              {
                autoCompleteCurrents . push ( autoCompleteThese [ i ] ) ;
                foundElements ++ ;
              }
            }
// Are there any hits? If not, then the list should go.
            if ( foundElements > 0 )
            {
// The list should be created if not exists.
              autoCompleteListCreate ( foundElements ) ;
// And then the customization: these should happen every time when the user hits a key.
              autoCompleteList . setArrays ( autoCompleteCurrents , autoCompleteCurrents ) ;
            }
            else
            {
              autoCompleteListRemove ( ) ;
            }
          }
          else
          {
            autoCompleteListRemove ( ) ;
          }
        }
        else
        {
          autoCompleteListRemove ( ) ;
        }
      }
      if ( getBaseEventDispatcher ( ) != null && e != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( e ) ;
      }
    }
/*
** The list has to be created.
*/
    private function autoCompleteListCreate ( foundElements : int ) : void
    {
      if ( autoCompleteList == null )
      {
        autoCompleteList = new ListPanel ( application ) ;
        addChild ( autoCompleteList ) ;
        autoCompleteList . setMultiple ( false ) ;
        autoCompleteList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , autoCompleteListResized ) ;
        autoCompleteList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , autoCompleteListChanged ) ;
        autoCompleteList . setNumOfElements ( Math . min ( foundElements , application . getPropsApp ( ) . getAutoCompleteMaxElements ( ) ) ) ;
        autoCompleteListReposResize ( ) ;
      }
    }
/*
** The selected value of the list has been changed ( the user clicks on an item).
*/
    private function autoCompleteListChanged ( e : Event ) : void
    {
      if ( autoCompleteList != null && baseTextField != null )
      {
        var selectedItem : String = autoCompleteList . getArrayValues ( ) [ autoCompleteList . getSelectedIndexes ( ) [ 0 ] ] ;
        var theString : String = "" ;
        if ( toAutoComplete1 == "" )
        {
          theString = selectedItem + autoCompleteSeparatorChar ;
        }
        else
        {
          theString = toAutoComplete1 + autoCompleteSeparatorChar + selectedItem + autoCompleteSeparatorChar ;
        }
        baseTextField . text = theString ;
        if ( stage != null )
        {
          stage . focus = baseTextField ;
        }
        var theIndex : int = theString . length ;
        baseTextField . setSelection ( theIndex , theIndex ) ;
        autoCompleteListRemove ( ) ;
      }
    }
/*
** The list has to be removed.
*/
    private function autoCompleteListRemove ( ) : void
    {
      if ( autoCompleteList != null )
      {
        autoCompleteList . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , autoCompleteListResized ) ;
        autoCompleteList . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , autoCompleteListChanged ) ;
        autoCompleteList . destroy ( ) ;
        removeChild ( autoCompleteList ) ;
        autoCompleteList = null ;
        autoCompleteListResized ( null ) ;
        toAutoComplete1 = "" ;
      }
    }
/*
** The auto complete list has to be resized and repositioned.
*/
    private function autoCompleteListReposResize ( ) : void
    {
      if ( autoCompleteList != null && baseTextField != null )
      {
        autoCompleteList . setsw ( getsw ( ) ) ;
        autoCompleteList . setcxy ( 0 , baseTextField . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
    }
/*
** The autoComplete list is resized, so the size of this input has to be changed.
*/
    private function autoCompleteListResized ( e : Event ) : void
    {
      if ( autoCompleteList != null )
      {
        super . setsh ( baseTextField . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) + autoCompleteList . getsh ( ) ) ;
      }
      else
      {
        super . setsh ( baseTextField . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
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
        baseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
        baseShape . drawRect ( ) ;
        autoCompleteListReposResize ( ) ;
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
** minChars.
*/
    public function setMinChars ( m : int ) : void
    {
      baseTextField . setMinChars ( m ) ;
    }
/*
** maxChars.
*/
    public function setMaxChars ( m : int ) : void
    {
      baseTextField . maxChars = m ;
    }
/*
** Tests whether this textfield contains tne minimum number of chars.
*/
    public function getTextIsAtLeastLength ( ) : Boolean
    {
      return baseTextField . getTextIsAtLeastLength ( ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( autoCompleteList != null )
      {
        autoCompleteList . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , autoCompleteListResized ) ;
        autoCompleteList . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , autoCompleteListChanged ) ;
      }
      baseTextField . removeEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_OUT , focusOut ) ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_IN , focusIn ) ;
      baseTextField . removeEventListener ( KeyboardEvent . KEY_UP , keyUp ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( autoCompleteCurrents != null )
      {
        autoCompleteCurrents . splice ( 0 ) ;
      }
      if ( autoCompleteThese != null )
      {
        autoCompleteThese . splice ( 0 ) ;
      }
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseTextField = null ;
      baseShape = null ;
      iniTextChanged = false ;
      autoCompleteThese = null ;
      autoCompleteSeparatorChar = null ;
      autoCompleteList = null ;
      autoCompleteCurrents = null ;
      toAutoComplete0 = null ;
      toAutoComplete1 = null ;
      eventChanged = null ;
      contentSprite = null ;
      backSprite = null ;
      origContentPos = 0 ;
    }
  }
}
