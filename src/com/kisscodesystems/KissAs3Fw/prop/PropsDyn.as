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
    [ Embed ( source = "../../../../../res/bg/bg1.jpg" ) ]
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
    private var appRadius1 : int = 10 ;
    private var appRadius0 : int = 10 ;
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
    protected var eventAppBackgroundImageOrAlignOrAlphaChanged : Event = null ;
    private var eventAppBackgroundLiveChanged : Event = null ;
    private var eventAppBackgroundFillAlphaChanged : Event = null ;
    private var eventAppTextFormatBrightChanged : Event = null ;
    private var eventAppTextFormatMidChanged : Event = null ;
    private var eventAppTextFormatDarkChanged : Event = null ;
// This bitmapdata will be drawn onto the backgroundImageShape of Background.
    protected var backgroundBitmapData : BitmapData = null ;
// Object for the predefined displaying styles.
    protected var appDisplayingStyles : Object = new Object ( ) ;
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
      eventAppBackgroundImageOrAlignOrAlphaChanged = new Event ( application . EVENT_BACKGROUND_IMAGE_OR_ALIGN_OR_ALPHA_CHANGED ) ;
      eventAppBackgroundLiveChanged = new Event ( application . EVENT_BACKGROUND_LIVE_CHANGED ) ;
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
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius0" ] = 5 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius1" ] = 10 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundBgColor" ] = "222222" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFgColor" ] = "CCCCCC" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFillAlpha" ] = 0.5 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundImage" ] = application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlign" ] = application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlpha" ] = 1 ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundLive" ] = true ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontFace" ] = FONT_FACE_ARIAL ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontSize" ] = "20" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorBright" ] = "CCCCCC" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorMid" ] = "999999" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorDark" ] = "111111" ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontBold" ] = false ;
      appDisplayingStyles [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontItalic" ] = false ;
// The setting of this default values to the application.
      setAppLineThickness ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appLineThickness" ] ) ;
      setAppMargin ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appMargin" ] ) ;
      setAppPadding ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appPadding" ] ) ;
      setAppRadius0 ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius0" ] ) ;
      setAppRadius1 ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appRadius1" ] ) ;
      setAppBackgroundBgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundBgColor" ] ) ) ;
      setAppBackgroundFgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFgColor" ] ) ) ;
      setAppBackgroundFillAlpha ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundFillAlpha" ] ) ;
      setAppBackgroundImage ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundImage" ] ) ;
      setAppBackgroundAlign ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlign" ] ) ;
      setAppBackgroundAlpha ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundAlpha" ] ) ;
      setAppBackgroundLive ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appBackgroundLive" ] ) ;
      setAppFontFace ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontFace" ] ) ;
      setAppFontSize ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontSize" ] ) ;
      setAppFontColorBright ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorBright" ] ) ) ;
      setAppFontColorMid ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorMid" ] ) ) ;
      setAppFontColorDark ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontColorDark" ] ) ) ;
      setAppFontBold ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontBold" ] ) ;
      setAppFontItalic ( getAppDisplayingStyles ( ) [ application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] [ "appFontItalic" ] ) ;
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
      array . push ( "0" ) ;
      for ( var i : int = 8 ; i <= 72 ; i += 2 )
      {
        array . push ( "" + i ) ;
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
            setAppLineThickness ( getAppDisplayingStyles ( ) [ styleName ] [ "appLineThickness" ] ) ;
            setAppMargin ( getAppDisplayingStyles ( ) [ styleName ] [ "appMargin" ] ) ;
            setAppPadding ( getAppDisplayingStyles ( ) [ styleName ] [ "appPadding" ] ) ;
            setAppRadius0 ( getAppDisplayingStyles ( ) [ styleName ] [ "appRadius0" ] ) ;
            setAppRadius1 ( getAppDisplayingStyles ( ) [ styleName ] [ "appRadius1" ] ) ;
            setAppBackgroundBgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundBgColor" ] ) ) ;
            setAppBackgroundFgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFgColor" ] ) ) ;
            setAppBackgroundFillAlpha ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFillAlpha" ] ) ;
            setAppBackgroundImage ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundImage" ] ) ;
            setAppBackgroundAlign ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlign" ] ) ;
            setAppBackgroundAlpha ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlpha" ] ) ;
            setAppBackgroundLive ( getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundLive" ] ) ;
            setAppFontFace ( getAppDisplayingStyles ( ) [ styleName ] [ "appFontFace" ] ) ;
            setAppFontSize ( getAppDisplayingStyles ( ) [ styleName ] [ "appFontSize" ] ) ;
            setAppFontColorBright ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorBright" ] ) ) ;
            setAppFontColorMid ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorMid" ] ) ) ;
            setAppFontColorDark ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorDark" ] ) ) ;
            setAppFontBold ( getAppDisplayingStyles ( ) [ styleName ] [ "appFontBold" ] ) ;
            setAppFontItalic ( getAppDisplayingStyles ( ) [ styleName ] [ "appFontItalic" ] ) ;
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
    public function getAppLineThickness ( ) : int
    {
      return appLineThickness ;
    }
    public function setAppLineThickness ( newLineThickness : int ) : void
    {
      if ( appLineThickness != newLineThickness )
      {
        appLineThickness = newLineThickness ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppLineThicknessChanged ) ;
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
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppMarginChanged ) ;
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
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppPaddingChanged ) ;
      }
    }
    public function getAppRadius0 ( ) : int
    {
      return appRadius0 ;
    }
    public function getAppRadius1 ( ) : int
    {
      return appRadius1 ;
    }
    public function setAppRadius0 ( newRadius0 : int ) : void
    {
      if ( appRadius0 != newRadius0 )
      {
        appRadius0 = newRadius0 ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppRadiusChanged ) ;
      }
    }
    public function setAppRadius1 ( newRadius1 : int ) : void
    {
      if ( appRadius1 != newRadius1 )
      {
        appRadius1 = newRadius1 ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppRadiusChanged ) ;
      }
    }
    public function getAppBackgroundBgColor ( ) : Number
    {
      return appBackgroundBgColor ;
    }
    public function setAppBackgroundBgColor ( newBackgroundBgColor : Number ) : void
    {
      if ( appBackgroundBgColor != newBackgroundBgColor )
      {
        appBackgroundBgColor = newBackgroundBgColor ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundBgColorChanged ) ;
      }
    }
    public function getAppBackgroundFgColor ( ) : Number
    {
      return appBackgroundFgColor ;
    }
    public function setAppBackgroundFgColor ( newBackgroundFgColor : Number ) : void
    {
      if ( appBackgroundFgColor != newBackgroundFgColor )
      {
        appBackgroundFgColor = newBackgroundFgColor ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundFgColorChanged ) ;
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
        if ( appBackgroundImage != application . getTexts ( ) . BACKGROUND_IMAGE_BG1 )
        {
          appBackgroundImage = application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ;
          setBackgroundBitmapData ( ) ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
        }
      }
    }
    public function getAppBackgroundAlign ( ) : String
    {
      return appBackgroundAlign ;
    }
    public function setAppBackgroundAlign ( newBackgroundAlign : String ) : void
    {
      if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_NONE )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_NONE )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_NONE ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
        }
      }
      else if ( newBackgroundAlign == application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
      {
        if ( appBackgroundAlign != application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
        {
          appBackgroundAlign = application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ;
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
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
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundImageOrAlignOrAlphaChanged ) ;
      }
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
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppBackgroundLiveChanged ) ;
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
    public function setAppFontFace ( newFontFace : String ) : void
    {
      if ( appFontFace != newFontFace )
      {
        appFontFace = newFontFace ;
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
    public function setAppFontSize ( newFontSize : int ) : void
    {
      if ( appFontSize != newFontSize )
      {
        if ( newFontSize > 0 )
        {
          appFontSize = newFontSize ;
          setFontSize ( appFontSize ) ;
        }
        else
        {
          appFontSize = 0 ;
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
    public function setAppFontColorBright ( newFontColorBright : Number ) : void
    {
      if ( appFontColorBright != newFontColorBright )
      {
        appFontColorBright = newFontColorBright ;
        textFormatBright . color = appFontColorBright ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatBrightChanged ) ;
      }
    }
    public function setAppFontColorMid ( newFontColorMid : Number ) : void
    {
      if ( appFontColorMid != newFontColorMid )
      {
        appFontColorMid = newFontColorMid ;
        textFormatMid . color = appFontColorMid ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatMidChanged ) ;
      }
    }
    public function setAppFontColorDark ( newFontColorDark : Number ) : void
    {
      if ( appFontColorDark != newFontColorDark )
      {
        appFontColorDark = newFontColorDark ;
        textFormatDark . color = appFontColorDark ;
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventAppTextFormatDarkChanged ) ;
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
    public function setAppFontItalic ( newFontItalic : Boolean ) : void
    {
      if ( appFontItalic != newFontItalic )
      {
        appFontItalic = newFontItalic ;
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
    protected function setBackgroundBitmapData ( ) : void
    {
      disposeBackgroundBitmapData ( ) ;
      if ( application . getTexts ( ) != null )
      {
        if ( appBackgroundImage == application . getTexts ( ) . BACKGROUND_IMAGE_BG1 )
        {
          backgroundBitmapData = new BitmapData ( bg1Bitmap . bitmapData . width , bg1Bitmap . bitmapData . height , false ) ;
          backgroundBitmapData . draw ( bg1Bitmap . bitmapData ) ;
        }
      }
    }
    protected function disposeBackgroundBitmapData ( ) : void
    {
      if ( backgroundBitmapData != null )
      {
        backgroundBitmapData . dispose ( ) ;
        backgroundBitmapData = null ;
      }
    }
  }
}