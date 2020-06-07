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
** PropsDyn. Variables that can trigger an event and which event
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
  import flash . filters . DropShadowFilter ;
  import flash . system . System ;
  import flash . text . Font ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  import flash . text . TextFormat ;
  public class PropsDyn
  {
// Adding the font.
    public const FONT_FACE_ARIAL : String = "Arial" ;
// Adding the background bitmap.
    [ Embed ( source = "../../../../../res/bg1.jpg" ) ]
    private var Bg1 : Class ;
    private var bg1Bitmap : Bitmap ;
// Reference to the Application object.
// Protected because we may add some newapplication . getTexts ( ) into it.
    protected var application : Application = null ;
// APP VARIABLES: THEY CAN BE CHANGED AND USED FOR DISPLAYING.
// THE CHANGING OF THESE WILL DISPATCH THE SPECIFIC EVENT
// TO NOTIFY THE OBJECT TO HANDLE THE PROPER CHANGE EVENTS.
// (THE CHANGING OF THE LANGUAGE CODE IS IN THE TEXTSTOCK CLASS.)
    private var appWidgetsOrientation : String = "" ;
    private var appLineThickness : int = 5 ;
    private var appMargin : int = 20 ;
    private var appPadding : int = 10 ;
    private var appRadius2 : int = 10 ;
    private var appRadius1 : int = 10 ;
    private var appBackgroundBgColor : Number = 0x000000 ;
    private var appBackgroundFgColor : Number = 0xffffff ;
    private var appBackgroundFillAlpha : Number = 1 ;
    protected var appBackgroundImage : String = "" ;
    private var appBackgroundAlign : String = "" ;
    private var appBackgroundAlpha : Number = 1 ;
    private var appBackgroundLive : Boolean = false ;
    private var appFontFace : String = "Arial" ;
    private var appFontSize : int = 20 ;
    private var appFontColorBright : Number = 0xffffff ;
    private var appFontColorMid : Number = 0x888888 ;
    private var appFontColorDark : Number = 0x000000 ;
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
    private var eventAppWidgetsOrientationChanged : Event = null ;
    private var eventAppLineThicknessChanged : Event = null ;
    private var eventAppMarginChanged : Event = null ;
    private var eventAppPaddingChanged : Event = null ;
    private var eventAppRadiusChanged : Event = null ;
    private var eventAppBackgroundBgColorChanged : Event = null ;
    private var eventAppBackgroundFgColorChanged : Event = null ;
    protected var eventAppBackgroundImageChanged : Event = null ;
    private var eventAppBackgroundImageAlignChanged : Event = null ;
    private var eventAppBackgroundImageAlphaChanged : Event = null ;
    private var eventAppBackgroundImageLiveChanged : Event = null ;
    private var eventAppBackgroundFillAlphaChanged : Event = null ;
    private var eventAppTextFormatBrightChanged : Event = null ;
    private var eventAppTextFormatMidChanged : Event = null ;
    private var eventAppTextFormatDarkChanged : Event = null ;
// This bitmapdata will be drawn onto the backgroundImageShape of Background.
    protected var backgroundBitmapData : BitmapData = null ;
// Object for the predefined displaying styles.
    protected var appDisplayingStyles : Object = new Object ( ) ;
// Image object to get images from outside.
    protected var image : Image = null ;
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
// These are the background bitmap objects.
      bg1Bitmap = new Bg1 ( ) as Bitmap ;
// Creating the event objects usable here.
      eventAppWidgetsOrientationChanged = new Event ( application . EVENT_ORIENTATIONS_CHANGED ) ;
      eventAppLineThicknessChanged = new Event ( application . EVENT_LINE_THICKNESS_CHANGED ) ;
      eventAppMarginChanged = new Event ( application . EVENT_MARGIN_CHANGED ) ;
      eventAppPaddingChanged = new Event ( application . EVENT_PADDING_CHANGED ) ;
      eventAppRadiusChanged = new Event ( application . EVENT_RADIUS_CHANGED ) ;
      eventAppBackgroundBgColorChanged = new Event ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED ) ;
      eventAppBackgroundFgColorChanged = new Event ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED ) ;
      eventAppBackgroundFillAlphaChanged = new Event ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED ) ;
      eventAppBackgroundImageChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_CHANGED ) ;
      eventAppBackgroundImageAlignChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_ALIGN_CHANGED ) ;
      eventAppBackgroundImageAlphaChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_ALPHA_CHANGED ) ;
      eventAppBackgroundImageLiveChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_LIVE_CHANGED ) ;
      eventAppTextFormatBrightChanged = new Event ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED ) ;
      eventAppTextFormatMidChanged = new Event ( application . EVENT_TEXT_FORMAT_MID_CHANGED ) ;
      eventAppTextFormatDarkChanged = new Event ( application . EVENT_TEXT_FORMAT_DARK_CHANGED ) ;
// Creating the textformat objects text type by text type.
      textFormatBright = new TextFormat ( appFontFace , appFontSize , appFontColorBright , appFontBold , appFontItalic ) ;
      textFormatMid = new TextFormat ( appFontFace , appFontSize , appFontColorMid , appFontBold , appFontItalic ) ;
      textFormatDark = new TextFormat ( appFontFace , appFontSize , appFontColorDark , appFontBold , appFontItalic ) ;
// Setting the initial height ofapplication . getTexts ( ) by text type.
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
// The orientation of the widgets will be initially:
      setAppWidgetsOrientation ( application . getTexts ( ) . ORIENTATION_HORIZONTAL ) ;
// We can create the predefined displaying style.
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] = new Array ( ) ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appLineThickness" ] = 1 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appMargin" ] = 8 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appPadding" ] = 8 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius1" ] = 5 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius2" ] = 10 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundBgColor" ] = "222222" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFgColor" ] = "CCCCCC" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFillAlpha" ] = 0.5 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundImage" ] = application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlign" ] = application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlpha" ] = 1 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundLive" ] = true ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontFace" ] = FONT_FACE_ARIAL ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontSize" ] = 20 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorBright" ] = "CCCCCC" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorMid" ] = "999999" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorDark" ] = "111111" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontBold" ] = false ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontItalic" ] = false ;
// The setting of this default values to the application.
      setAppLineThickness ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appLineThickness" ] ) ;
      setAppMargin ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appMargin" ] ) ;
      setAppPadding ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appPadding" ] ) ;
      setAppRadius1 ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius1" ] ) ;
      setAppRadius2 ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius2" ] ) ;
      setAppBackgroundBgColor ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundBgColor" ] ) ) ;
      setAppBackgroundFgColor ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFgColor" ] ) ) ;
      setAppBackgroundFillAlpha ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFillAlpha" ] ) ;
      setAppBackgroundImage ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundImage" ] ) ;
      setAppBackgroundAlign ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlign" ] ) ;
      setAppBackgroundAlpha ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlpha" ] ) ;
      setAppBackgroundLive ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundLive" ] ) ;
      setAppFontFace ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontFace" ] ) ;
      setAppFontSize ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontSize" ] ) ;
      setAppFontColorBright ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorBright" ] ) ) ;
      setAppFontColorMid ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorMid" ] ) ) ;
      setAppFontColorDark ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorDark" ] ) ) ;
      setAppFontBold ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontBold" ] ) ;
      setAppFontItalic ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontItalic" ] ) ;
    }
/*
** Sets the image by the id.
*/
    public function setParamsAndLoadImage ( pId : String , sId : String , fUrl : String ) : void
    {
      destImage ( ) ;
      image = new Image ( application ) ;
      image . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FILE_LOADED , imageLoaded ) ;
      image . setParamsAndLoadImage ( pId , sId , fUrl ) ;
    }
/*
** Destroys the image.
*/
    private function destImage ( ) : void
    {
      if ( image != null )
      {
        image . destroy ( ) ;
        image = null ;
      }
    }
/*
** The image has been loaded so it can be handled.
*/
    private function imageLoaded ( e : Event ) : void
    {
      if ( application != null && image != null )
      {
        setBg1BitmapData ( image . getBitmapData ( ) ) ;
        image . clear ( ) ;
      }
    }
/*
** Prepares the view of this application into smartphone friendly.
*/
    public function toSmartphone ( ) : void
    {
      setWidgetsOrientation ( application . getTexts ( ) . ORIENTATION_HORIZONTAL ) ;
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
      for ( var i : int = 8 ; i <= 72 ; i += 2 )
      {
        array . push ( i ) ;
      }
      return array ;
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
** Gets the text height.
*/
    public function getTextFieldHeight ( textType : String ) : int
    {
      if ( textType == application . getTexts ( ) . TEXT_TYPE_BRIGHT )
      {
        return textFieldHeightBright ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        return textFieldHeightMid ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        return textFieldHeightDark ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** Gets the reference of the displaying styles object.
*/
    public function getAppDisplayingStyles ( ) : Object
    {
      return appDisplayingStyles ;
    }
/*
** Sets the orientation of the widgets.
*/
    public function setWidgetsOrientation ( newWidgetsOrientation : String ) : void
    {
      if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        setAppWidgetsOrientation ( newWidgetsOrientation ) ;
      }
    }
/*
** Sets the predefined displaying styles.
*/
    public function setDisplayingStyle ( styleName : String ) : void
    {
      if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        if ( getAppDisplayingStyles ( ) != null )
        {
          if ( getAppDisplayingStyles ( ) [ styleName ] != null )
          {
            setAppLineThickness ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appLineThickness" ] ) ;
            setAppMargin ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appMargin" ] ) ;
            setAppPadding ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appPadding" ] ) ;
            setAppRadius1 ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appRadius1" ] ) ;
            setAppRadius2 ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appRadius2" ] ) ;
            setAppBackgroundBgColor ( styleName , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundBgColor" ] ) ) ;
            setAppBackgroundFgColor ( styleName , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFgColor" ] ) ) ;
            setAppBackgroundFillAlpha ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFillAlpha" ] ) ;
            setAppBackgroundImage ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundImage" ] ) ;
            setAppBackgroundAlign ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlign" ] ) ;
            setAppBackgroundAlpha ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlpha" ] ) ;
            setAppBackgroundLive ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundLive" ] ) ;
            setAppFontFace ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appFontFace" ] ) ;
            setAppFontSize ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appFontSize" ] ) ;
            setAppFontColorBright ( styleName , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorBright" ] ) ) ;
            setAppFontColorMid ( styleName , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorMid" ] ) ) ;
            setAppFontColorDark ( styleName , Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorDark" ] ) ) ;
            setAppFontBold ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appFontBold" ] ) ;
            setAppFontItalic ( styleName , getAppDisplayingStyles ( ) [ styleName ] [ "appFontItalic" ] ) ;
          }
        }
      }
    }
/*
** The following methods and functions get and set the proper values.
*/
    public function getAppWidgetsOrientation ( ) : String
    {
      return appWidgetsOrientation ;
    }
    public function setAppWidgetsOrientation ( newWidgetsOrientation : String ) : void
    {
// The new value can be the old value. (Dispatches the event every time.)
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
    public function getAppLineThickness ( ) : int
    {
      return appLineThickness ;
    }
    public function setAppLineThickness ( styleName : String , newLineThickness : int ) : void
    {
      if ( appLineThickness != newLineThickness || appDisplayingStyles [ styleName ] [ "appLineThickness" ] != newLineThickness )
      {
        appLineThickness = newLineThickness ;
        appDisplayingStyles [ styleName ] [ "appLineThickness" ] = appLineThickness ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppLineThicknessChanged ) ;
      }
    }
    public function getAppMargin ( ) : int
    {
      return appMargin ;
    }
    public function setAppMargin ( styleName : String , newMargin : int ) : void
    {
      if ( appMargin != newMargin || appDisplayingStyles [ styleName ] [ "appMargin" ] != newMargin )
      {
        appMargin = newMargin ;
        appDisplayingStyles [ styleName ] [ "appMargin" ] = appMargin ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppMarginChanged ) ;
      }
    }
    public function getAppPadding ( ) : int
    {
      return appPadding ;
    }
    public function setAppPadding ( styleName : String , newPadding : int ) : void
    {
      if ( appPadding != newPadding || appDisplayingStyles [ styleName ] [ "appPadding" ] != newPadding )
      {
        appPadding = newPadding ;
        appDisplayingStyles [ styleName ] [ "appPadding" ] = appPadding ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppPaddingChanged ) ;
      }
    }
    public function getAppRadius1 ( ) : int
    {
      return appRadius1 ;
    }
    public function getAppRadius2 ( ) : int
    {
      return appRadius2 ;
    }
    public function setAppRadius1 ( styleName : String , newRadius1 : int ) : void
    {
      if ( appRadius1 != newRadius1 || appDisplayingStyles [ styleName ] [ "appRadius1" ] != newRadius1 )
      {
        appRadius1 = newRadius1 ;
        appDisplayingStyles [ styleName ] [ "appRadius1" ] = appRadius1 ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppRadiusChanged ) ;
      }
    }
    public function setAppRadius2 ( styleName : String , newRadius2 : int ) : void
    {
      if ( appRadius2 != newRadius2 || appDisplayingStyles [ styleName ] [ "appRadius2" ] != newRadius2 )
      {
        appRadius2 = newRadius2 ;
        appDisplayingStyles [ styleName ] [ "appRadius2" ] = appRadius2 ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppRadiusChanged ) ;
      }
    }
    public function getAppBackgroundBgColor ( ) : Number
    {
      return appBackgroundBgColor ;
    }
    public function setAppBackgroundBgColor ( styleName : String , newBackgroundBgColor : Number ) : void
    {
      if ( appBackgroundBgColor != newBackgroundBgColor || appDisplayingStyles [ styleName ] [ "appBackgroundBgColor" ] != application . colorToString ( newBackgroundBgColor ) )
      {
        appBackgroundBgColor = newBackgroundBgColor ;
        appDisplayingStyles [ styleName ] [ "appBackgroundBgColor" ] = application . colorToString ( appBackgroundBgColor ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundBgColorChanged ) ;
      }
    }
    public function getAppBackgroundFgColor ( ) : Number
    {
      return appBackgroundFgColor ;
    }
    public function setAppBackgroundFgColor ( styleName : String , newBackgroundFgColor : Number ) : void
    {
      if ( appBackgroundFgColor != newBackgroundFgColor || appDisplayingStyles [ styleName ] [ "appBackgroundFgColor" ] != application . colorToString ( newBackgroundFgColor ) )
      {
        appBackgroundFgColor = newBackgroundFgColor ;
        appDisplayingStyles [ styleName ] [ "appBackgroundFgColor" ] = application . colorToString ( appBackgroundFgColor ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFgColorChanged ) ;
      }
    }
    public function getAppBackgroundFillAlpha ( ) : Number
    {
      return appBackgroundFillAlpha ;
    }
    public function setAppBackgroundFillAlpha ( styleName : String , newFillAlpha : Number ) : void
    {
      if ( appBackgroundFillAlpha != newFillAlpha || appDisplayingStyles [ styleName ] [ "appBackgroundFillAlpha" ] != newFillAlpha )
      {
        appBackgroundFillAlpha = newFillAlpha ;
        appDisplayingStyles [ styleName ] [ "appBackgroundFillAlpha" ] = appBackgroundFillAlpha ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFillAlphaChanged ) ;
      }
    }
    public function getAppBackgroundImage ( ) : String
    {
      return appBackgroundImage ;
    }
    public function setAppBackgroundImage ( newBackgroundImage : String ) : void
    {
      if ( newBackgroundImage == application . getTexts ( ) . BACKGROUND_IMAGE_BG1 )
      {
        appBackgroundImage = application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ;
        setBackgroundBitmapData ( ) ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageChanged ) ;
      }
    }
    public function getAppBackgroundAlign ( ) : String
    {
      return appBackgroundAlign ;
    }
    public function setAppBackgroundAlign ( styleName : String , newBackgroundAlign : String ) : void
    {
      if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_NONE )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_NONE || appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] != application . getTexts ( ) . BACKGROUND_ALIGN_NONE )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_NONE ;
          appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlignChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 || appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 ;
          appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlignChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 || appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ;
          appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlignChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 || appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 ;
          appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlignChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC || appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] != application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ;
          appDisplayingStyles [ styleName ] [ "appBackgroundAlign" ] = appBackgroundAlign ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlignChanged ) ;
        }
      }
    }
    public function getAppBackgroundAlpha ( ) : Number
    {
      return appBackgroundAlpha ;
    }
    public function setAppBackgroundAlpha ( styleName : String , newAppBackgroundAlpha : Number ) : void
    {
      if ( appBackgroundAlpha != newAppBackgroundAlpha || appDisplayingStyles [ styleName ] [ "appBackgroundAlpha" ] != newAppBackgroundAlpha )
      {
        appBackgroundAlpha = newAppBackgroundAlpha ;
        appDisplayingStyles [ styleName ] [ "appBackgroundAlpha" ] = appBackgroundAlpha ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageAlphaChanged ) ;
      }
    }
    public function getAppBackgroundLive ( ) : Boolean
    {
      return appBackgroundLive ;
    }
    public function setAppBackgroundLive ( styleName : String , newBackgroundLive : Boolean ) : void
    {
      if ( appBackgroundLive != newBackgroundLive || appDisplayingStyles [ styleName ] [ "appBackgroundLive" ] != newBackgroundLive )
      {
        appBackgroundLive = newBackgroundLive ;
        appDisplayingStyles [ styleName ] [ "appBackgroundLive" ] = appBackgroundLive ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageLiveChanged ) ;
      }
    }
    public function getAppFontFace ( ) : String
    {
      return appFontFace ;
    }
    private function setAllTextFieldHeightsAndDispatchChanging ( ) : void
    {
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      setTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatBrightChanged ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatMidChanged ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatDarkChanged ) ;
    }
    public function setAppFontFace ( styleName : String , newFontFace : String ) : void
    {
      if ( appFontFace != newFontFace || appDisplayingStyles [ styleName ] [ "appFontFace" ] != newFontFace )
      {
        appFontFace = newFontFace ;
        appDisplayingStyles [ styleName ] [ "appFontFace" ] = appFontFace ;
        textFormatBright . font = appFontFace ;
        textFormatMid . font = appFontFace ;
        textFormatDark . font = appFontFace ;
        setAllTextFieldHeightsAndDispatchChanging ( ) ;
      }
    }
    public function getAppFontSize ( ) : int
    {
      return appFontSize ;
    }
    public function setAppFontSize ( styleName : String , newFontSize : int ) : void
    {
      if ( appFontSize != newFontSize || appDisplayingStyles [ styleName ] [ "appFontSize" ] != newFontSize )
      {
        if ( newFontSize > 0 )
        {
          appFontSize = newFontSize ;
          appDisplayingStyles [ styleName ] [ "appFontSize" ] = appFontSize ;
          setFontSize ( appFontSize ) ;
        }
        else
        {
          appFontSize = 0 ;
          appDisplayingStyles [ styleName ] [ "appFontSize" ] = appFontSize ;
          setFontSize ( application . calcFontSizeFromStageSize ( ) ) ;
        }
      }
    }
    public function setFontSize ( i : int ) : void
    {
      textFormatBright . size = i ;
      textFormatMid . size = i ;
      textFormatDark . size = i ;
      setAllTextFieldHeightsAndDispatchChanging ( ) ;
    }
    public function getAppFontColorBright ( ) : Number
    {
      return appFontColorBright ;
    }
    public function getAppFontColorMid ( ) : Number
    {
      return appFontColorMid ;
    }
    public function getAppFontColorDark ( ) : Number
    {
      return appFontColorDark ;
    }
    public function setAppFontColorBright ( styleName : String , newFontColorBright : Number ) : void
    {
      if ( appFontColorBright != newFontColorBright || appDisplayingStyles [ styleName ] [ "appFontColorBright" ] != application . colorToString ( newFontColorBright ) )
      {
        appFontColorBright = newFontColorBright ;
        appDisplayingStyles [ styleName ] [ "appFontColorBright" ] = application . colorToString ( appFontColorBright ) ;
        textFormatBright . color = appFontColorBright ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatBrightChanged ) ;
      }
    }
    public function setAppFontColorMid ( styleName : String , newFontColorMid : Number ) : void
    {
      if ( appFontColorMid != newFontColorMid || appDisplayingStyles [ styleName ] [ "appFontColorMid" ] != application . colorToString ( newFontColorMid ) )
      {
        appFontColorMid = newFontColorMid ;
        appDisplayingStyles [ styleName ] [ "appFontColorMid" ] = application . colorToString ( appFontColorMid ) ;
        textFormatMid . color = appFontColorMid ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatMidChanged ) ;
      }
    }
    public function setAppFontColorDark ( styleName : String , newFontColorDark : Number ) : void
    {
      if ( appFontColorDark != newFontColorDark || appDisplayingStyles [ styleName ] [ "appFontColorDark" ] != application . colorToString ( newFontColorDark ) )
      {
        appFontColorDark = newFontColorDark ;
        appDisplayingStyles [ styleName ] [ "appFontColorDark" ] = application . colorToString ( appFontColorDark ) ;
        textFormatDark . color = appFontColorDark ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatDarkChanged ) ;
      }
    }
    public function getAppFontBold ( ) : Boolean
    {
      return appFontBold ;
    }
    public function setAppFontBold ( styleName : String , newFontBold : Boolean ) : void
    {
      if ( appFontBold != newFontBold || appDisplayingStyles [ styleName ] [ "appFontBold" ] != newFontBold )
      {
        appFontBold = newFontBold ;
        appDisplayingStyles [ styleName ] [ "appFontBold" ] = appFontBold ;
        textFormatBright . bold = appFontBold ;
        textFormatMid . bold = appFontBold ;
        textFormatDark . bold = appFontBold ;
        setAllTextFieldHeightsAndDispatchChanging ( ) ;
      }
    }
    public function getAppFontItalic ( ) : Boolean
    {
      return appFontItalic ;
    }
    public function setAppFontItalic ( styleName : String , newFontItalic : Boolean ) : void
    {
      if ( appFontItalic != newFontItalic || appDisplayingStyles [ styleName ] [ "appFontItalic" ] != newFontItalic )
      {
        appFontItalic = newFontItalic ;
        appDisplayingStyles [ styleName ] [ "appFontItalic" ] = appFontItalic ;
        textFormatBright . italic = appFontItalic ;
        textFormatMid . italic = appFontItalic ;
        textFormatDark . italic = appFontItalic ;
        setAllTextFieldHeightsAndDispatchChanging ( ) ;
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
    public function getBackgroundBitmapData ( ) : BitmapData
    {
      return backgroundBitmapData ;
    }
    private function setBg1BitmapData ( bd : BitmapData ) : void
    {
      bg1Bitmap = new Bitmap ( bd ) ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlign" ] = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ;
      setAppBackgroundImage ( application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ) ;
      setAppBackgroundAlign ( application . getTexts ( ) . DISPLAYING_STYLE_BASIC , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ) ;
      application . getMiddleground ( ) . setAppBackgroundImage ( 0 ) ;
      application . getMiddleground ( ) . setAppBackgroundAlign ( 2 ) ;
    }
    protected function setBackgroundBitmapData ( ) : void
    {
      disposeBackgroundBitmapData ( ) ;
      if ( application . getTexts ( ) != null )
      {
        if ( appBackgroundImage == application . getTexts ( ) . BACKGROUND_IMAGE_BG1 )
        {
          try
          {
            backgroundBitmapData = new BitmapData ( bg1Bitmap . bitmapData . width , bg1Bitmap . bitmapData . height , false ) ;
            backgroundBitmapData . draw ( bg1Bitmap . bitmapData ) ;
          }
          catch ( e : * )
          {
            backgroundBitmapData = new BitmapData ( 1 , 1 , false ) ;
          }
        }
      }
    }
    private function disposeBackgroundBitmapData ( ) : void
    {
      if ( backgroundBitmapData != null )
      {
        backgroundBitmapData . dispose ( ) ;
        backgroundBitmapData = null ;
      }
    }
  }
}
