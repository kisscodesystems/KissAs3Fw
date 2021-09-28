/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/
**
** DESCRIPTION
** PropsDyn. ariables that can trigger an event and which event
** is able to listen to in the application . getBaseEventDispatcher ( ).
** No destroy method.
**
*/
package com . kisscodesystems . KissAs3Fw . prop
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . Image ;
  import flash . display . Bitmap ;
  import flash . display . BitmapData ;
  import flash . events . Event ;
  import flash . filters . BlurFilter ;
  import flash . filters . DropShadowFilter ;
  import flash . geom . Point ;
  import flash . geom . Rectangle ;
  import flash . system . System ;
  import flash . text . Font ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  import flash . text . TextFormat ;
  public class PropsDyn
  {
// Reference to the Application object.
// Protected because we may add some newapplication . getTexts ( ) into it.
    protected var application : Application = null ;
// Adding the font.
    public const FONT_FACE_ARIAL : String = "Arial" ;
// Adding the background bitmap.
    [ Embed ( source = "../../../../../res/view.jpg" ) ]
    private var View : Class ;
    private var view : Bitmap ;
// This bitmapdata will be drawn onto the backgroundImageShape of Background.
    private var bitmapData : BitmapData = null ;
// Image object to get images from outside.
    protected var image : Image = null ;
// APP VARIABLES: THEY CAN BE CHANGED AND USED FOR DISPLAYING.
// THE CHANGING OF THESE WILL DISPATCH THE SPECIFIC EVENT
// TO NOTIFY THE OBJECT TO HANDLE THE PROPER CHANGE EVENTS.
// (THE CHANGING OF THE LANGUAGE CODE IS IN THE TEXTSTOCK CLASS.)
// Widgets orientation
    private var appWidgetsOrientation : String = "" ;
// Widget mode
    private var appWidgetMode : String = "" ;
// Sound properties
    private var appSoundVolume : int = 66 ;
    private var appSoundPlaying : Boolean = true ;
// Displayable properties
    private var appLineThickness : int = 1 ;
    private var appMargin : int = 10 ;
    private var appPadding : int = 10 ;
    private var appRadius : int = 8 ;
    private var appBackgroundFillBgColor : Number = 0x395871 ;
    private var appBackgroundFillFgColor : Number = 0x72972E ;
    private var appBackgroundFillAlpha : Number = 0 ;
    protected var appBackgroundImage : String = "" ;
    private var appBackgroundAlign : String = "" ;
    private var appBackgroundAlpha : Number = 1 ;
    private var appBackgroundBlur : int = 0 ;
    private var appBackgroundLive : Boolean = true ;
    private var appFontFace : String = FONT_FACE_ARIAL ;
    private var appFontSize : int = 0 ;
    private var appFontColorBright : Number = 0xF4F4F4 ;
    private var appFontColorMid : Number = 0xB3CBAB ;
    private var appFontColorDark : Number = 0x4E312B ;
    private var appFontBold : Boolean = false ;
    private var appFontItalic : Boolean = false ;
// THE OBJECTS ARE FROM THE ABOVES.
// These are the textformat objects. Every BaseTextField referers to them.
    private var textFormatBright : TextFormat = null ;
    private var textFormatMid : TextFormat = null ;
    private var textFormatDark : TextFormat = null ;
// The initial text sizes. These will allways be recalculated if the text formats change.
    private var textFieldHeightBright : int = 0 ;
    private var textFieldHeightMid : int = 0 ;
    private var textFieldHeightDark : int = 0 ;
// THESE ARE THE EVENTS THE APPLICATION AND ITS OBJECT CAN LISTEN TO.
// The orientation of the widget can be modified
    private var eventAppWidgetsOrientationChanged : Event = null ;
// The mode of the widget can be modified
    private var eventAppWidgetModeChanged : Event = null ;
// The sound properties can be modified
    private var eventAppSoundVolumeChanged : Event = null ;
    private var eventAppSoundPlayingChanged : Event = null ;
// The events of the skin property changings
    private var eventAppLineThicknessChanged : Event = null ;
    private var eventAppMarginChanged : Event = null ;
    private var eventAppPaddingChanged : Event = null ;
    private var eventAppRadiusChanged : Event = null ;
    private var eventAppBackgroundFillBgColorChanged : Event = null ;
    private var eventAppBackgroundFillFgColorChanged : Event = null ;
    private var eventAppBackgroundFillAlphaChanged : Event = null ;
    protected var eventAppBackgroundImageChanged : Event = null ;
    private var eventAppBackgroundAlignChanged : Event = null ;
    private var eventAppBackgroundAlphaChanged : Event = null ;
    private var eventAppBackgroundBlurChanged : Event = null ;
    private var eventAppBackgroundLiveChanged : Event = null ;
    private var eventAppFontFaceChanged : Event = null ;
    private var eventAppFontSizeChanged : Event = null ;
    private var eventAppFontColorBrightChanged : Event = null ;
    private var eventAppFontColorMidChanged : Event = null ;
    private var eventAppFontColorDarkChanged : Event = null ;
    private var eventAppFontBoldChanged : Event = null ;
    private var eventAppFontItalicChanged : Event = null ;
    private var eventTextFormatBrightChanged : Event = null ;
    private var eventTextFormatMidChanged : Event = null ;
    private var eventTextFormatDarkChanged : Event = null ;
// Object for the predefined displaying styles.
    protected var appDisplayingStyles : Object = new Object ( ) ;
// The current style to view
    protected var currentDisplayingStyle : String = "" ;
// An event has to be thrown after the value changing.
    private var eventDisplayingStyleChanged : Event = null ;
// The container of the background images to be stored.
    protected var appBackgroundImages : Array = new Array ( ) ;
// The setApp.... function is in operation during style changing or not.
    protected var styleChangingInProgress : Boolean = false ;
/*
** Constructing the props dyn object.
*/
    public function PropsDyn ( applicationRef : Application ) : void
    {
// This is necessary.
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// Initialized now.
      appBackgroundImage = application . getTexts ( ) . DISPLAYING_STYLE_VIEW ;
      appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ;
// These are the background bitmap objects.
      view = new View ( ) as Bitmap ;
// Creating the event objects usable here.
      eventDisplayingStyleChanged = new Event ( application . EVENT_DISPLAYING_STYLE_CHANGED ) ;
      eventAppWidgetsOrientationChanged = new Event ( application . EVENT_WIDGETS_ORIENTATION_CHANGED ) ;
      eventAppWidgetModeChanged = new Event ( application . EVENT_WIDGET_MODE_CHANGED ) ;
      eventAppSoundVolumeChanged = new Event ( application . EVENT_SOUND_VOLUME_CHANGED ) ;
      eventAppSoundPlayingChanged = new Event ( application . EVENT_SOUND_PLAYING_CHANGED ) ;
      eventAppLineThicknessChanged = new Event ( application . EVENT_LINE_THICKNESS_CHANGED ) ;
      eventAppMarginChanged = new Event ( application . EVENT_MARGIN_CHANGED ) ;
      eventAppPaddingChanged = new Event ( application . EVENT_PADDING_CHANGED ) ;
      eventAppRadiusChanged = new Event ( application . EVENT_RADIUS_CHANGED ) ;
      eventAppBackgroundFillBgColorChanged = new Event ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED ) ;
      eventAppBackgroundFillFgColorChanged = new Event ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED ) ;
      eventAppBackgroundFillAlphaChanged = new Event ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED ) ;
      eventAppBackgroundImageChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_CHANGED ) ;
      eventAppBackgroundAlignChanged = new Event ( application . EVENT_BACKGROUND_ALIGN_CHANGED ) ;
      eventAppBackgroundAlphaChanged = new Event ( application . EVENT_BACKGROUND_ALPHA_CHANGED ) ;
      eventAppBackgroundBlurChanged = new Event ( application . EVENT_BACKGROUND_BLUR_CHANGED ) ;
      eventAppBackgroundLiveChanged = new Event ( application . EVENT_BACKGROUND_LIVE_CHANGED ) ;
      eventAppFontFaceChanged = new Event ( application . EVENT_FONT_FACE_CHANGED ) ;
      eventAppFontSizeChanged = new Event ( application . EVENT_FONT_SIZE_CHANGED ) ;
      eventAppFontColorBrightChanged = new Event ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED ) ;
      eventAppFontColorMidChanged = new Event ( application . EVENT_FONT_COLOR_MID_CHANGED ) ;
      eventAppFontColorDarkChanged = new Event ( application . EVENT_FONT_COLOR_DARK_CHANGED ) ;
      eventAppFontBoldChanged = new Event ( application . EVENT_FONT_BOLD_CHANGED ) ;
      eventAppFontItalicChanged = new Event ( application . EVENT_FONT_ITALIC_CHANGED ) ;
      eventTextFormatBrightChanged = new Event ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED ) ;
      eventTextFormatMidChanged = new Event ( application . EVENT_TEXT_FORMAT_MID_CHANGED ) ;
      eventTextFormatDarkChanged = new Event ( application . EVENT_TEXT_FORMAT_DARK_CHANGED ) ;
// Creating the textformat objects text type by text type.
      var size : int = application . calcFontSizeFromStageSize ( ) ;
      textFormatBright = new TextFormat ( appFontFace , size , appFontColorBright , appFontBold , appFontItalic ) ;
      textFormatMid = new TextFormat ( appFontFace , size , appFontColorMid , appFontBold , appFontItalic ) ;
      textFormatDark = new TextFormat ( appFontFace , size , appFontColorDark , appFontBold , appFontItalic ) ;
// Setting the initial height ofapplication . getTexts ( ) by text type.
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
// The current style
      currentDisplayingStyle = application . getTexts ( ) . DISPLAYING_STYLE_VIEW ;
// The orientation of the widgets will be initially:
      setAppWidgetsOrientation ( application . getTexts ( ) . ORIENTATION_HORIZONTAL ) ;
// And the Widget mode is:
      setAppWidgetMode ( application . getTexts ( ) . WIDGET_MODE_AUTOMATIC ) ;
// The url will be stored here to the background images.
//   null: default view image from the app
//   "": no image to load (fe. user did not uploaded)
//   "a_value": url to load the file from the internet
      appBackgroundImages [ currentDisplayingStyle ] = null ;
// We can create the predefined displaying style.
      appDisplayingStyles [ currentDisplayingStyle ] = new Array ( ) ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appLineThickness" ] = 1 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appMargin" ] = 10 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appPadding" ] = 10 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appRadius" ] = 8 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillBgColor" ] = "395871" ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillFgColor" ] = "72972E" ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillAlpha" ] = 0 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundImage" ] = currentDisplayingStyle ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlign" ] = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlpha" ] = 1 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundBlur" ] = 0 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundLive" ] = true ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontFace" ] = FONT_FACE_ARIAL ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontSize" ] = 0 ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorBright" ] = "F4F4F4" ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorMid" ] = "B3CBAB" ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorDark" ] = "4E312B" ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontBold" ] = false ;
      appDisplayingStyles [ currentDisplayingStyle ] [ "appFontItalic" ] = false ;
    }
/*
** Sets and gets the currently displayed style
** by the settings listpicker if existing or from anywhere in the application code.
*/
    public function setCurrentDisplayingStyle ( newDisplayingStyle : String ) : void
    {
      if ( currentDisplayingStyle != newDisplayingStyle )
      {
        if ( appDisplayingStyles [ currentDisplayingStyle ] is Array )
        {
          styleChangingInProgress = true ;
          currentDisplayingStyle = newDisplayingStyle ;
          setAppLineThickness ( appDisplayingStyles [ currentDisplayingStyle ] [ "appLineThickness" ] ) ;
          setAppMargin ( appDisplayingStyles [ currentDisplayingStyle ] [ "appMargin" ] ) ;
          setAppPadding ( appDisplayingStyles [ currentDisplayingStyle ] [ "appPadding" ] ) ;
          setAppRadius ( appDisplayingStyles [ currentDisplayingStyle ] [ "appRadius" ] ) ;
          setAppBackgroundFillBgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillBgColor" ] ) ) ;
          setAppBackgroundFillFgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillFgColor" ] ) ) ;
          setAppBackgroundFillAlpha ( appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillAlpha" ] ) ;
          setAppBackgroundImage ( ) ;
          setAppBackgroundAlign ( appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlign" ] ) ;
          setAppBackgroundAlpha ( appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlpha" ] ) ;
          setAppBackgroundBlur ( appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundBlur" ] ) ;
          setAppBackgroundLive ( appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundLive" ] ) ;
          setAppFontFace ( appDisplayingStyles [ currentDisplayingStyle ] [ "appFontFace" ] ) ;
          setAppFontSize ( appDisplayingStyles [ currentDisplayingStyle ] [ "appFontSize" ] ) ;
          setAppFontColorBright ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorBright" ] ) ) ;
          setAppFontColorMid ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorMid" ] ) ) ;
          setAppFontColorDark ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorDark" ] ) ) ;
          setAppFontBold ( appDisplayingStyles [ currentDisplayingStyle ] [ "appFontBold" ] ) ;
          setAppFontItalic ( appDisplayingStyles [ currentDisplayingStyle ] [ "appFontItalic" ] ) ;
          if ( application != null && eventDisplayingStyleChanged != null )
          {
            application . getBaseEventDispatcher ( ) . dispatchEvent ( eventDisplayingStyleChanged ) ;
          }
          displayingStyleHasChanged ( ) ;
          styleChangingInProgress = false ;
        }
      }
    }
/*
** We are in desktop mode or not.
** Desktop mode:
**   - WIDGET_MOPDE_DESKTOP is selected in propsDyn, or
**   - WIDGET_MODE_AUTOMATIC and the width of the application is greather than the height.
*/
    public function weAreInDesktopMode ( ) : Boolean
    {
      return appWidgetMode == application . getTexts ( ) . WIDGET_MODE_DESKTOP || ( appWidgetMode == application . getTexts ( ) . WIDGET_MODE_AUTOMATIC && application . getsw ( ) > application . getsh ( ) ) ;
    }
/*
** Gets the current displaying style code.
*/
    public function getCurrentDisplayingStyle ( ) : String
    {
      return currentDisplayingStyle ;
    }
/*
** Gets the fonts of this application.
** The same method as ibn theapplication . getTexts ( )tock:
** A new array will return containing the
** strings of the font names.
*/
    public function getFontFaces ( ) : Array
    {
      var array : Array = Font . enumerateFonts ( ! application . getPropsApp ( ) . getUseEmbedFonts ( ) ) ;
      var arrayRet : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < array . length ; i ++ )
      {
        arrayRet . push ( array [ i ] . fontName ) ;
      }
      arrayRet . sortOn ( Array . CASEINSENSITIVE ) ;
      return arrayRet ;
    }
/*
** Gets the font sizes.
*/
    public function getFontSizes ( ) : Array
    {
      var array : Array = new Array ( ) ;
      array . push ( 0 ) ;
      for ( var i : int = getMinFontSize ( ) ; i <= getMaxFontSize ( ) ; i += 2 )
      {
        array . push ( i ) ;
      }
      return array ;
    }
    public function getMinFontSize ( ) : int
    {
      return 12 ;
    }
    public function getMaxFontSize ( ) : int
    {
      return 72 ;
    }
/*
** Sets the text height.
*/
    private function setTextFieldHeight ( textType : String ) : void
    {
      var textField : TextField = new TextField ( ) ;
      if ( textType == application . getTexts ( ) . TEXT_TYPE_BRIGHT )
      {
        textField . defaultTextFormat = textFormatBright ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        textField . defaultTextFormat = textFormatMid ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        textField . defaultTextFormat = textFormatDark ;
      }
      textField . autoSize = TextFieldAutoSize . LEFT ;
      textField . text = "fÁ" ;
      textField . setTextFormat ( textField . defaultTextFormat ) ;
      if ( textType == application . getTexts ( ) . TEXT_TYPE_BRIGHT )
      {
        textFieldHeightBright = textField . height ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        textFieldHeightMid = textField . height ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        textFieldHeightDark = textField . height ;
      }
    }
/*
** Sets all of the text heights.
*/
    private function setAllTextFieldHeights ( ) : void
    {
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
    }
/*
** Sets all of the font sizes at once.
*/
    public function setAllFontSizes ( i : int ) : void
    {
      textFormatBright . size = i ;
      textFormatMid . size = i ;
      textFormatDark . size = i ;
      setAllTextFieldHeights ( ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontSizeChanged ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatBrightChanged ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatMidChanged ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatDarkChanged ) ;
      saveDisplaying ( ) ;
    }
/*
** Gets the text height.
*/
    public function getTextFieldHeight ( textType : String = "" ) : int
    {
      if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        return textFieldHeightMid ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        return textFieldHeightDark ;
      }
      else
      {
        return textFieldHeightBright ;
      }
    }
/*
** The following methods and functions get and set the proper values.
** Only the elements of the currently displayed style can be modified.
*/
    public function getAppWidgetsOrientation ( ) : String
    {
      return appWidgetsOrientation ;
    }
    public function setAppWidgetsOrientation ( newWidgetsOrientation : String ) : void
    {
      if ( appWidgetsOrientation != newWidgetsOrientation )
      {
        if ( newWidgetsOrientation == application . getTexts ( ) . ORIENTATION_VERTICAL )
        {
          appWidgetsOrientation = application . getTexts ( ) . ORIENTATION_VERTICAL ;
        }
        else if ( newWidgetsOrientation == application . getTexts ( ) . ORIENTATION_HORIZONTAL )
        {
          appWidgetsOrientation = application . getTexts ( ) . ORIENTATION_HORIZONTAL ;
        }
        else
        {
          appWidgetsOrientation = application . getTexts ( ) . ORIENTATION_MANUAL ;
        }
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppWidgetsOrientationChanged ) ;
      }
    }
    private function changeAppWidgetsOrientationIfManual ( ) : void
    {
      if ( appWidgetsOrientation == application . getTexts ( ) . ORIENTATION_MANUAL )
      {
        setAppWidgetsOrientation ( application . getTexts ( ) . ORIENTATION_VERTICAL ) ;
      }
    }
    public function getAppWidgetMode ( ) : String
    {
      return appWidgetMode ;
    }
    public function setAppWidgetMode ( newWidgetMode : String ) : void
    {
      if ( appWidgetMode != newWidgetMode )
      {
        if ( newWidgetMode == application . getTexts ( ) . WIDGET_MODE_DESKTOP )
        {
          appWidgetMode = application . getTexts ( ) . WIDGET_MODE_DESKTOP ;
        }
        else if ( newWidgetMode == application . getTexts ( ) . WIDGET_MODE_MOBILE )
        {
          appWidgetMode = application . getTexts ( ) . WIDGET_MODE_MOBILE ;
          setAppBackgroundLive ( false ) ;
          changeAppWidgetsOrientationIfManual ( ) ;
        }
        else
        {
          appWidgetMode = application . getTexts ( ) . WIDGET_MODE_AUTOMATIC ;
          changeAppWidgetsOrientationIfManual ( ) ;
        }
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppWidgetModeChanged ) ;
      }
    }
    public function getAppSoundVolume ( ) : int
    {
      return appSoundVolume ;
    }
    public function setAppSoundVolume ( newSoundVolume : int ) : void
    {
      if ( appSoundVolume != newSoundVolume )
      {
        appSoundVolume = newSoundVolume ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppSoundVolumeChanged ) ;
      }
    }
    public function getAppSoundPlaying ( ) : Boolean
    {
      return appSoundPlaying ;
    }
    public function setAppSoundPlaying ( newSoundPlaying : Boolean ) : void
    {
      if ( appSoundPlaying != newSoundPlaying )
      {
        appSoundPlaying = newSoundPlaying ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppSoundPlayingChanged ) ;
      }
    }
    public function getAppLineThickness ( ) : int
    {
      return appLineThickness ;
    }
    public function setAppLineThickness ( newLineThickness : int ) : void
    {
      if ( appLineThickness != newLineThickness )
      {
        appLineThickness = newLineThickness ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appLineThickness" ] = appLineThickness ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppLineThicknessChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppMargin ( ) : int
    {
      return appMargin ;
    }
    public function setAppMargin ( newMargin : int ) : void
    {
      if ( appMargin != newMargin )
      {
        appMargin = newMargin ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appMargin" ] = appMargin ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppMarginChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppPadding ( ) : int
    {
      return appPadding ;
    }
    public function setAppPadding ( newPadding : int ) : void
    {
      if ( appPadding != newPadding )
      {
        appPadding = newPadding ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appPadding" ] = appPadding ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppPaddingChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppRadius ( ) : int
    {
      return appRadius ;
    }
    public function setAppRadius ( newRadius : int ) : void
    {
      if ( appRadius != newRadius )
      {
        appRadius = newRadius ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appRadius" ] = appRadius ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppRadiusChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppBackgroundFillBgColor ( ) : Number
    {
      return appBackgroundFillBgColor ;
    }
    public function setAppBackgroundFillBgColor ( newBackgroundFillBgColor : Number ) : void
    {
      if ( appBackgroundFillBgColor != newBackgroundFillBgColor )
      {
        appBackgroundFillBgColor = newBackgroundFillBgColor ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillBgColor" ] = application . colorToString ( appBackgroundFillBgColor ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFillBgColorChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppBackgroundFillFgColor ( ) : Number
    {
      return appBackgroundFillFgColor ;
    }
    public function setAppBackgroundFillFgColor ( newBackgroundFillFgColor : Number ) : void
    {
      if ( appBackgroundFillFgColor != newBackgroundFillFgColor )
      {
        appBackgroundFillFgColor = newBackgroundFillFgColor ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillFgColor" ] = application . colorToString ( appBackgroundFillFgColor ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFillFgColorChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppBackgroundFillAlpha ( ) : Number
    {
      return appBackgroundFillAlpha ;
    }
    public function setAppBackgroundFillAlpha ( newFillAlpha : Number ) : void
    {
      if ( appBackgroundFillAlpha != newFillAlpha )
      {
        appBackgroundFillAlpha = newFillAlpha ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundFillAlpha" ] = appBackgroundFillAlpha ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFillAlphaChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppBackgroundImage ( ) : String
    {
      return appBackgroundImage ;
    }
    public function setAppBackgroundImage ( force : Boolean = false ) : void
    {
      if ( force || appBackgroundImage != appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundImage" ] )
      {
        appBackgroundImage = appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundImage" ] ;
        disposeBitmapData ( ) ;
        if ( appBackgroundImages [ appBackgroundImage ] == null )
        {
          drawBitmapDataFromSource ( view . bitmapData ) ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageChanged ) ;
        }
        else if ( appBackgroundImages [ appBackgroundImage ] == "" )
        {
          createEmptyBitmapData ( ) ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageChanged ) ;
        }
        else
        {
          destImage ( ) ;
          image = new Image ( application ) ;
          image . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FILE_LOADED , imageLoaded ) ;
          loadImage ( ) ;
        }
      }
    }
    private function disposeBitmapData ( ) : void
    {
      if ( bitmapData != null )
      {
        bitmapData . dispose ( ) ;
        bitmapData = null ;
      }
    }
    private function destImage ( ) : void
    {
      if ( image != null )
      {
        image . destroy ( ) ;
        image = null ;
      }
    }
    public function getBitmapData ( ) : BitmapData
    {
      return bitmapData ;
    }
    private function imageLoaded ( e : Event ) : void
    {
      if ( application != null )
      {
        if ( image != null )
        {
          if ( image . getBitmapData ( ) != null )
          {
            drawBitmapDataFromSource ( image . getBitmapData ( ) ) ;
          }
          else
          {
            createEmptyBitmapData ( ) ;
          }
        }
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageChanged ) ;
      }
    }
    public function getAppBackgroundAlign ( ) : String
    {
      return appBackgroundAlign ;
    }
    public function setAppBackgroundAlign ( newBackgroundAlign : String ) : void
    {
      if ( appBackgroundAlign != newBackgroundAlign )
      {
        if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_NONE || newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 || newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 || newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 || newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
        {
          appBackgroundAlign = newBackgroundAlign ;
          appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundAlignChanged ) ;
          saveDisplaying ( ) ;
        }
      }
    }
    public function getAppBackgroundAlpha ( ) : Number
    {
      return appBackgroundAlpha ;
    }
    public function setAppBackgroundAlpha ( newAppBackgroundAlpha : Number ) : void
    {
      if ( appBackgroundAlpha != newAppBackgroundAlpha )
      {
        appBackgroundAlpha = newAppBackgroundAlpha ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundAlpha" ] = appBackgroundAlpha ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundAlphaChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppBackgroundBlur ( ) : int
    {
      return appBackgroundBlur ;
    }
    public function setAppBackgroundBlur ( newAppBackgroundBlur : int ) : void
    {
      if ( appBackgroundBlur != newAppBackgroundBlur )
      {
        appBackgroundBlur = newAppBackgroundBlur ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundBlur" ] = appBackgroundBlur ;
        disposeBitmapData ( ) ;
        if ( appBackgroundImages [ appBackgroundImage ] == null )
        {
          drawBitmapDataFromSource ( view . bitmapData ) ;
        }
        else if ( appBackgroundImages [ appBackgroundImage ] == "" )
        {
          createEmptyBitmapData ( ) ;
        }
        else
        {
          drawBitmapDataFromSource ( image . getBitmapData ( ) ) ;
        }
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundBlurChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    private function drawBitmapDataFromSource ( srcBitmapData : BitmapData ) : void
    {
      try
      {
        bitmapData = new BitmapData ( srcBitmapData . width , srcBitmapData . height , false ) ;
        if ( appBackgroundBlur > 0 && appBackgroundBlur < 13 )
        {
          bitmapData . applyFilter ( srcBitmapData , new Rectangle ( 0 , 0 , bitmapData . width , bitmapData . height ) , new Point ( 0 , 0 ) , new BlurFilter ( appBackgroundBlur , appBackgroundBlur , appBackgroundBlur ) ) ;
        }
        else
        {
          bitmapData . draw ( srcBitmapData ) ;
        }
      }
      catch ( e : * )
      {
        createEmptyBitmapData ( ) ;
      }
    }
    private function createEmptyBitmapData ( ) : void
    {
      bitmapData = new BitmapData ( 1 , 1 , false ) ;
    }
    public function getAppBackgroundLive ( ) : Boolean
    {
      return appBackgroundLive ;
    }
    public function setAppBackgroundLive ( newBackgroundLive : Boolean ) : void
    {
      if ( appBackgroundLive != newBackgroundLive )
      {
        appBackgroundLive = newBackgroundLive ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appBackgroundLive" ] = appBackgroundLive ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundLiveChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontFace ( ) : String
    {
      return appFontFace ;
    }
    public function setAppFontFace ( newFontFace : String ) : void
    {
      if ( appFontFace != newFontFace )
      {
        appFontFace = newFontFace ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontFace" ] = appFontFace ;
        textFormatBright . font = appFontFace ;
        textFormatMid . font = appFontFace ;
        textFormatDark . font = appFontFace ;
        setAllTextFieldHeights ( ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontFaceChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatBrightChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatMidChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatDarkChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontSize ( ) : int
    {
      return appFontSize ;
    }
    public function setAppFontSize ( newFontSize : int ) : void
    {
      if ( appFontSize != newFontSize || newFontSize == 0 )
      {
        if ( newFontSize > 0 )
        {
          appFontSize = newFontSize ;
          appDisplayingStyles [ currentDisplayingStyle ] [ "appFontSize" ] = appFontSize ;
          setAllFontSizes ( appFontSize ) ;
        }
        else
        {
          appFontSize = 0 ;
          appDisplayingStyles [ currentDisplayingStyle ] [ "appFontSize" ] = appFontSize ;
          setAllFontSizes ( application . calcFontSizeFromStageSize ( ) ) ;
        }
      }
    }
    public function getAppFontColorBright ( ) : Number
    {
      return appFontColorBright ;
    }
    public function setAppFontColorBright ( newFontColorBright : Number ) : void
    {
      if ( appFontColorBright != newFontColorBright )
      {
        appFontColorBright = newFontColorBright ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorBright" ] = application . colorToString ( appFontColorBright ) ;
        textFormatBright . color = appFontColorBright ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontColorBrightChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatBrightChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontColorMid ( ) : Number
    {
      return appFontColorMid ;
    }
    public function setAppFontColorMid ( newFontColorMid : Number ) : void
    {
      if ( appFontColorMid != newFontColorMid )
      {
        appFontColorMid = newFontColorMid ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorMid" ] = application . colorToString ( appFontColorMid ) ;
        textFormatMid . color = appFontColorMid ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontColorMidChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatMidChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontColorDark ( ) : Number
    {
      return appFontColorDark ;
    }
    public function setAppFontColorDark ( newFontColorDark : Number ) : void
    {
      if ( appFontColorDark != newFontColorDark )
      {
        appFontColorDark = newFontColorDark ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontColorDark" ] = application . colorToString ( appFontColorDark ) ;
        textFormatDark . color = appFontColorDark ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontColorDarkChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatDarkChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontBold ( ) : Boolean
    {
      return appFontBold ;
    }
    public function setAppFontBold ( newFontBold : Boolean ) : void
    {
      if ( appFontBold != newFontBold )
      {
        appFontBold = newFontBold ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontBold" ] = appFontBold ;
        textFormatBright . bold = appFontBold ;
        textFormatMid . bold = appFontBold ;
        textFormatDark . bold = appFontBold ;
        setAllTextFieldHeights ( ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontBoldChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatBrightChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatMidChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatDarkChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getAppFontItalic ( ) : Boolean
    {
      return appFontItalic ;
    }
    public function setAppFontItalic ( newFontItalic : Boolean ) : void
    {
      if ( appFontItalic != newFontItalic )
      {
        appFontItalic = newFontItalic ;
        appDisplayingStyles [ currentDisplayingStyle ] [ "appFontItalic" ] = appFontItalic ;
        textFormatBright . italic = appFontItalic ;
        textFormatMid . italic = appFontItalic ;
        textFormatDark . italic = appFontItalic ;
        setAllTextFieldHeights ( ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppFontItalicChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatBrightChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatMidChanged ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventTextFormatDarkChanged ) ;
        saveDisplaying ( ) ;
      }
    }
    public function getTextFormatBright ( ) : TextFormat
    {
      return textFormatBright ;
    }
    public function getTextFormatMid ( ) : TextFormat
    {
      return textFormatMid ;
    }
    public function getTextFormatDark ( ) : TextFormat
    {
      return textFormatDark ;
    }
/*
** Features may be implemented in extender applications.
*/
    protected function loadImage ( ) : void { }
    protected function saveDisplaying ( ) : void { }
    protected function displayingStyleHasChanged ( ) : void { }
  }
}
