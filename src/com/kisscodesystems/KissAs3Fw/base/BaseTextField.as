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
** BaseTextField.
** The base textfield class. (Very similar to the BaseSprite.)
**
** This base class has the main properties as:
** - x coordinate (store as cx (coordinate x))
** - y coordinate (store as cy (coordinate y))
** - width (store as sw (size width))
** - height (store as sh (size height))
**
** What if these properties have been changed.
**
** 1: other classes.
** This class has the baseEventDispatcher.
** This will be the object to allow other objects to be registered.
** The coordinates or size aboves will be changed then thru this object,
** other objects can be informed aboout the changing of this main properties.
** (If it registers to the eventCoordinatesChanged or eventSizesChanged events.)
**
** 2: classes extending this.
** These classes has not to be registered into this baseEventDispatcher
** because the changing of the size or coordinate properties mean the calling
** of the doCoordinateChanged or doSizeChanged. These two method can be
** overwritten in the extending classes.
**
** This has to contain the overridable destroy method. This is used for destroying
** everything we created in the current extending class of this base class.
** The initializator function: addedToStage and the removedFromStage have to be
** here too. These also have to be overwritten in extending classes.
**
** This also has to contain the grabage collector callings in a method: systemGc.
**
** It can handle text codes and can listen to the changing of the app language!
**
** If the html is set to true then we are going to listening continuously of the
** changing of properties of the specified text type!
** (The html property can be set to false.)
**
** MAIN FEATURES:
** - coordinates and sizes are stored separately!
** - events will be dispatched when the sizes or the coordinates are changed.
** - textType: what textformat to apply
** - textCode: automatically changes the displayed text
**   according to the actual lang code of the applicaton
** - html or single texts can be displayed
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import flash . events . Event ;
  import flash . system . System ;
  import flash . text . AntiAliasType ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  import flash . text . TextFormat ;
  public class BaseTextField extends TextField
  {
// Reference to the Application object.
    protected var application : Application = null ;
// These are the base properties.
    private var cx : int = 0 ;
    private var cy : int = 0 ;
    private var sw : int = 0 ;
    private var sh : int = 0 ;
// The event objects to be constructed and to be dispatched from here.
    private var eventCoordinatesChanged : Event = null ;
    private var eventSizesChanged : Event = null ;
// The base event dispatcher object: other objects can be registered into this.
    private var baseEventDispatcher : BaseEventDispatcher = null ;
// This will be the type of the textfield. (application . getTexts ( ) . TEXT_TYPE_... )
    private var textType : String = "" ;
// This will be the code of the textfield. The text will be displayed according to this.
// The text codes between texts . BTC and texts . ETC will be replaced by the texts on the
// actually used language. Can be a single text code or static text
// (always displayed with the same text independently from the lang code)
// or any mix up of these, the text will always be displayed correctly.
    private var textCode : String = "" ;
// This will be the actual representation of the text code.
// (So, this will be displayed in the textfield.)
    private var textText : String = "" ;
// This is a html textfield or not.
    private var isHtml : Boolean = false ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseTextField ( applicationRef : Application ) : void
    {
// Super.
      super ( ) ;
// Getting the not null reference to the Application object.
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// Let's create the base event dispatcher object.
      baseEventDispatcher = new BaseEventDispatcher ( ) ;
// Let's create now these two event objects.
      eventCoordinatesChanged = new Event ( application . EVENT_COORDINATES_CHANGED ) ;
      eventSizesChanged = new Event ( application . EVENT_SIZES_CHANGED ) ;
// Let's reset the coordinate and the size of this object.
      coordinateSizeReset ( ) ;
// Now registering the events of adding and removing this object to and from the stage.
      addEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      addEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
// Changing these text properties.
      antiAliasType = AntiAliasType . NORMAL ;
      embedFonts = application . getPropsApp ( ) . getUseEmbedFonts ( ) ;
// The default textformat is set.
      setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
    }
/*
** Listener functions: added and removed from stage.
** (The stage propery will be not null in addedToStage
** and null will be null in removedFromStage.)
*/
    protected function addedToStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
    protected function removedFromStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
/*
** This is the resetter of the basic properties.
** Coordinate and size.
** Every of them have to be 0.
** The x and y coordinates of this object have to be set to 0 also.
*/
    private function coordinateSizeReset ( ) : void
    {
// Resetting everything. (stored properties.)
      cx = 0 ;
      cy = 0 ;
      sw = 0 ;
      sh = 0 ;
// And the real dimensions.
      x = cx ;
      y = cy ;
      width = sw ;
      height = sh ;
    }
/*
** Gets the base event dispatcher object to the outside world.
** Usable from right after the object creating.
*/
    public function getBaseEventDispatcher ( ) : BaseEventDispatcher
    {
      return baseEventDispatcher ;
    }
/*
** This two method have to be overwritten and not needed to register for the
** eventCoordinatesChanged and eventSizesChanged events of this in extending classes.
*/
    protected function doCoordinateChanged ( ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
    protected function doSizeChanged ( ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
/*
** Setting the coordinate and size properties of this object.
** A property will be changed if it doesn't have that value already.
** If a value changing is necessary then
** - that will be done
** - the x and y will also be set if necessary
** - doCoordinateChanged or doSizeChanged method calls
** - dispatching the event which is necessary to inform other objects
**   of the changing of values of these properties.
** setAutoSizeNone has to be called before setting size.
*/
    public function setcx ( newcx : int ) : void
    {
      if ( cx != newcx )
      {
        cx = newcx ;
        x = cx ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setcy ( newcy : int ) : void
    {
      if ( cy != newcy )
      {
        cy = newcy ;
        y = cy ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setcxy ( newcx : int , newcy : int ) : void
    {
      if ( cx != newcx || cy != newcy )
      {
        cx = newcx ;
        cy = newcy ;
        x = cx ;
        y = cy ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setsw ( newsw : int ) : void
    {
      if ( sw != Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) )
      {
        sw = Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) ;
        width = sw ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
    public function setsh ( newsh : int ) : void
    {
      if ( sh != Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) )
      {
        sh = Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) ;
        height = sh ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
    public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( sw != Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) || sh != Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) )
      {
        sw = Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) ;
        sh = Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) ;
        width = sw ;
        height = sh ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
/*
** Sometimes we want an object to be in different location
** but without the dispatch of coordinate changed event.
** We can set the x and y properties of that object and then
** these can update the own cx and cy properties using this method.
*/
    public function updatecxy ( ) : void
    {
      cx = int ( x ) ;
      cy = int ( y ) ;
      x = cx ;
      y = cy ;
    }
/*
** Dispatches the sizes changed event.
*/
    private function dispatchEventSizesChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventSizesChanged ) ;
      }
    }
/*
** Dispatches the coordinates changed event.
*/
    private function dispatchEventCoordinatesChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventCoordinatesChanged ) ;
      }
    }
/*
** Gets the stored sprite properties: x y coordinates and w h sizes.
*/
    public function getcx ( ) : int
    {
      return cx ;
    }
    public function getcy ( ) : int
    {
      return cy ;
    }
    public function getsw ( ) : int
    {
      return sw ;
    }
    public function getsh ( ) : int
    {
      return sh ;
    }
/*
** Gets the properties needed for the reposition of the form elements.
*/
    public function getcxam ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcxap ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxamap ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxsw ( ) : int
    {
      return cx + sw ;
    }
    public function getcxswam ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcxswap ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxswamap ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyam ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcyap ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyamap ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcysh ( ) : int
    {
      return cy + sh ;
    }
    public function getcysham ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcyshap ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyshamap ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
/*
** This is the calling of the grabage collector avoiding to have huge memory usage.
** This System . gc ( ) do almost nothing at the first time, so let's invoke it multiple times.
*/
    private function systemGc ( ) : void
    {
      for ( var i : int = 0 ; i < 10 ; i ++ )
      {
        System . gc ( ) ;
      }
    }
/*
** This is the destructor method of this base object.
** Public because sometimes we want to execute this on other objects.
** Has to be overridden in extending classes.
** This method is for exactly destroying everything that we can create in
** the current class.
** Systematically have to go thru the class and destroy everything.
** 1 have to unregister from all of the registered events not registered into local_var . getBaseEventDispatcher ( )!
**   This is important!
** 2 every event object has to stopImmediatePropagation
** 3 has to call the parent destroy like this:
**   override public function destroy ( ) : void
**   {
**     ...
**     ...
**     super . destroy ( ) ;
**     ...
**   }
** 4 properties have to be set the default value: to null, 0 or false.
*/
    public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      removeEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      removeEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LANG_CODE_CHANGED , langCodeChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textFormatMidChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , textFormatBrightChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventCoordinatesChanged != null )
      {
        eventCoordinatesChanged . stopImmediatePropagation ( ) ;
      }
      if ( eventSizesChanged != null )
      {
        eventSizesChanged . stopImmediatePropagation ( ) ;
      }
      if ( baseEventDispatcher != null )
      {
        baseEventDispatcher . destroy ( ) ;
      }
// The grabage collecting has to be executed now.
      systemGc ( ) ;
// 3: calling the super destroy.
// 4: every reference and value should be resetted to null, 0 or false.
      coordinateSizeReset ( ) ;
      eventCoordinatesChanged = null ;
      eventSizesChanged = null ;
      baseEventDispatcher = null ;
      textType = null ;
      textCode = null ;
      textText = null ;
      isHtml = false ;
      filters = null ;
      text = "" ;
      htmlText = "" ;
      application = null ;
    }
/*
** Gets the html property.
*/
    public function getHtml ( ) : Boolean
    {
      return isHtml ;
    }
/*
** Sets the html property.
*/
    public function setHtml ( html : Boolean ) : void
    {
      if ( isHtml != html )
      {
        isHtml = html ;
        if ( ! isHtml )
        {
          embedFonts = application . getPropsApp ( ) . getUseEmbedFonts ( ) ;
        }
        else
        {
          embedFonts = false ;
        }
        displayText ( ) ;
      }
    }
/*
** Gets the wordwrap property.
*/
    public function getWordWrap ( ) : Boolean
    {
      return wordWrap ;
    }
/*
** Sets the wordwrap property.
*/
    public function setWordWrap ( ww : Boolean ) : void
    {
      if ( wordWrap != ww )
      {
        wordWrap = ww ;
        displayText ( ) ;
      }
    }
/*
** Sets the maxChars property.
*/
    public function setMaxChars ( i : int ) : void
    {
      if ( maxChars != i )
      {
        maxChars = i ;
      }
    }
/*
** Sets the restrict property.
*/
    public function setRestrict ( s : String ) : void
    {
      if ( restrict != s )
      {
        restrict = s ;
      }
    }
/*
** Clears the autoSize. After this, the textfield can be formatted as we want.
*/
    public function setAutoSizeNone ( ) : void
    {
      if ( autoSize != TextFieldAutoSize . NONE )
      {
        autoSize = TextFieldAutoSize . NONE ;
        setswh ( width , height ) ;
        textFormatApply ( ) ;
      }
    }
/*
** Sets the autoSize to left.
*/
    public function setAutoSizeLeft ( ) : void
    {
      if ( autoSize != TextFieldAutoSize . LEFT )
      {
        autoSize = TextFieldAutoSize . LEFT ;
        setswh ( width , height ) ;
        textFormatApply ( ) ;
      }
    }
/*
** Sets the password property of this textfield
*/
    public function setDisplayAsPassword ( b : Boolean ) : void
    {
      displayAsPassword = b ;
    }
/*
** Clears the dropshadow filter of this textfield.
*/
    private function clearDropShadowFilter ( ) : void
    {
      filters = null ;
    }
/*
** Sets the dropShadowFilter according to the given color.
** (The dropshadow filter can be bright or dark.)
*/
    private function setDropShadowFilter ( color : Number ) : void
    {
      if ( application . brightShadowToApply ( color . toString ( 16 ) ) )
      {
        filters = application . TEXT_DROP_SHADOW_ARRAY_BRIGHT ;
      }
      else
      {
        filters = application . TEXT_DROP_SHADOW_ARRAY_DARK ;
      }
    }
/*
** It will happen if the text format of this object has been changed.
*/
    private function textFormatBrightChanged ( e : Event ) : void
    {
// Just applying the textformat.
      textFormatApply ( ) ;
    }
    private function textFormatMidChanged ( e : Event ) : void
    {
// Just applying the textformat.
      textFormatApply ( ) ;
    }
    private function textFormatDarkChanged ( e : Event ) : void
    {
// Just applying the textformat.
      textFormatApply ( ) ;
    }
/*
** Gets the textcode of this textfield.
** Having textCode means that in case of language changing, we can change
** the displayed text automatically.
*/
    public function getTextCode ( ) : String
    {
      return textCode ;
    }
/*
** Gets the calculated value of the textCode.
*/
    public function getTextText ( ) : String
    {
      return textText ;
    }
/*
** Gets the plain text.
*/
    public function getPlainText ( ) : String
    {
      return text ;
    }
/*
** Gets the html text.
*/
    public function getHtmlText ( ) : String
    {
      return htmlText ;
    }
/*
** Is this a single text or contains one or more text codes?
*/
    private function containsTextCode ( string : String ) : Boolean
    {
      if ( string != null )
      {
        return string . indexOf ( application . getTexts ( ) . BTC ) != - 1 ;
      }
      else
      {
        return false ;
      }
    }
/*
** Constructing the displayable text from the text code according to the actual language code.
*/
    private function constructText ( ) : void
    {
      if ( application != null )
      {
// This will be the text we are going to display.
        textText = textCode ;
// The texts . BTC is contained?
        if ( containsTextCode ( textText ) )
        {
// The beginning and ending indexes of a text code.
          var textCodeBeginIndex : int = 0 ;
          var textCodeEndIndex : int = 0 ;
// An actual text code and text belonging to this will be:
          var aTextCode : String = "" ;
          var aTextText : String = "" ;
// Have to do it until it has at least one text code.
          while ( containsTextCode ( textText ) )
          {
// The begin index of the text code is:
            textCodeBeginIndex = textText . indexOf ( application . getTexts ( ) . BTC ) ;
// The end index of the text code is:
            textCodeEndIndex = textText . indexOf ( application . getTexts ( ) . ETC , textCodeBeginIndex ) + application . getTexts ( ) . ETC . length ;
// So the current text code is:
            aTextCode = textText . substring ( textCodeBeginIndex , textCodeEndIndex ) ;
// The representation of this in the actual language is:
            aTextText = application . getTextStock ( ) . getText ( aTextCode ) ;
// So the final text with the replaced textCode->textText is:
            textText = textText . replace ( aTextCode , aTextText ) ;
          }
          textCodeBeginIndex = 0 ;
          textCodeEndIndex = 0 ;
          aTextCode = null ;
          aTextText = null ;
        }
      }
    }
/*
** Displays the text from the text code given before.
*/
    private function displayText ( ) : void
    {
// This will be the new text.
      if ( isHtml )
      {
        htmlText = textText ;
      }
      else
      {
        text = textText ;
      }
// And we have to apply the textofrmat to the changed text.
      textFormatApply ( ) ;
    }
/*
** Sets the text to uppercase.
*/
    public function setTextToUpperCase ( ) : void
    {
      setTextCode ( text . toUpperCase ( ) ) ;
    }
/*
** Will be called if we have registered to the language code changing event.
*/
    private function langCodeChanged ( e : Event ) : void
    {
// What is the new text to display?
      constructText ( ) ;
// We have to display again that text code.
// (Will result a different text to be displayed.)
      displayText ( ) ;
    }
/*
** Gets the type of this text.
*/
    public function getTextType ( ) : String
    {
      return textType ;
    }
/*
** Sets the textcode of this textfield.
** Having textCode means that in case of language changing, we can change
** the displayed text automatically.
*/
    public function setTextCode ( newTextCode : String ) : void
    {
// If this is different from the exisging..
      if ( textCode != newTextCode )
      {
// Then let it be the new value.
        textCode = newTextCode ;
// What is the new text to display?
        constructText ( ) ;
// Let's display the new text according to this new text code.
        displayText ( ) ;
// Registering onto the changing of the language code, or removing the event listener if it is not necessary now.
        if ( containsTextCode ( textCode ) )
        {
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LANG_CODE_CHANGED , langCodeChanged ) ;
        }
        else
        {
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LANG_CODE_CHANGED , langCodeChanged ) ;
        }
      }
    }
/*
** Applying the textformat to the current text.
*/
    protected function textFormatApply ( ) : void
    {
      if ( application != null )
      {
// This has to be cleared first.
        clearDropShadowFilter ( ) ;
        if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
        {
          defaultTextFormat = application . getPropsDyn ( ) . getTextFormatMid ( ) ;
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorMid ( ) ) ;
        }
        else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          defaultTextFormat = application . getPropsDyn ( ) . getTextFormatDark ( ) ;
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorDark ( ) ) ;
        }
        else
        {
          defaultTextFormat = application . getPropsDyn ( ) . getTextFormatBright ( ) ;
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorBright ( ) ) ;
        }
        if ( isHtml )
        {
          htmlText = textText ;
        }
        else
        {
          setTextFormat ( defaultTextFormat ) ;
        }
        if ( autoSize == TextFieldAutoSize . NONE && ! multiline )
        {
          height = application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ;
        }
        setswh ( width , height ) ;
      }
    }
/*
** Sets the type of this text.
*/
    public function setTextType ( newTextType : String ) : void
    {
// By text types.
// If the new textType is different from the existing value, then the new value will be set.
// And, we will unsubscribe from the textformat changing event we won't have to listen to,
// and subscribe to the new event of changing the relevant textformat.
// And at the end, we will apply the (changed) textformat.
      if ( newTextType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_MID )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_MID ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textFormatMidChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , textFormatBrightChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
          textFormatApply ( ) ;
        }
      }
      else if ( newTextType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_DARK ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , textFormatBrightChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textFormatMidChanged ) ;
          textFormatApply ( ) ;
        }
      }
      else
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_BRIGHT )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_BRIGHT ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , textFormatBrightChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , textFormatMidChanged ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
          textFormatApply ( ) ;
        }
      }
    }
  }
}