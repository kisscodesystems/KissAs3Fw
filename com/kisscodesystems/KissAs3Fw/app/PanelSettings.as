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
** PanelSettings.
** The panel of the settings stuff will be visible if the user clicks on the settings button.
**
** MAIN FEATURES:
** - handles:
**   - language
**   - displaying styles
**   - widget orientation
**   - many containers to handle widgets well
**   - changing of all of the modifiable properties of this app
**   - user can upload own bg image in extender applications.
**   - switching between mobile or desktop appearance
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . LangSetter ;
  import com . kisscodesystems . KissAs3Fw . base . BasePanel ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ColorPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Potmeter ;
  import com . kisscodesystems . KissAs3Fw . ui . Switcher ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class PanelSettings extends BasePanel
  {
// The identifiers of the contents are:
    private var indexGeneral : int = - 1 ;
    private var indexLining : int = - 1 ;
    private var indexColoring : int = - 1 ;
    private var indexImaging : int = - 1 ;
    private var indexFonting : int = - 1 ;
    private var indexAbout : int = - 1 ;
// The list picker should get the width of the panel as its:
    private const listPickerFAC : Number = 0.42 ;
// The number of items to be visible in the opened list picker:
    private const listPickerCNT : int = 5 ;
// langCode
    private var langCodeLAB : TextLabel = null ;
    private var langCodeOBJ : LangSetter = null ;
// The number of the widget containers.
    private var numOfWidgetcontainersLAB : TextLabel = null ;
    private var numOfWidgetcontainersOBJ : ListPicker = null ;
    private var numOfWidgetcontainersARR : Array = null ;
    private var numOfWidgetcontainersOBJprevIndex : int = - 1 ;
// The current widget container.
    private var currWidgetcontainerLAB : TextLabel = null ;
    private var currWidgetcontainerOBJ : ListPicker = null ;
    private var currWidgetcontainerARR : Array = null ;
// appWidgetsOrientation
    private var appWidgetsOrientationLAB : TextLabel = null ;
    private var appWidgetsOrientationOBJ : ListPicker = null ;
// appWidgetMode
    private var appWidgetModeLAB : TextLabel = null ;
    private var appWidgetModeOBJ : ListPicker = null ;
// sound
    private var appSoundVolumeOBJ : Potmeter = null ;
    private const appSoundVolumeMIN : Number = 0 ;
    private const appSoundVolumeMAX : Number = 100 ;
    private const appSoundVolumeINC : Number = 1 ;
    private var appSoundPlayingOBJ : Switcher = null ;
// appLineThickness
    private var appLineThicknessLAB : TextLabel = null ;
    private var appLineThicknessOBJ : Potmeter = null ;
    private const appLineThicknessMIN : Number = 0 ;
    private const appLineThicknessMAX : Number = 5 ;
    private const appLineThicknessINC : Number = 1 ;
// appMargin
    private var appMarginLAB : TextLabel = null ;
    private var appMarginOBJ : Potmeter = null ;
    private const appMarginMIN : Number = 0 ;
    private const appMarginMAX : Number = 20 ;
    private const appMarginINC : Number = 1 ;
// appMargin
    private var appPaddingLAB : TextLabel = null ;
    private var appPaddingOBJ : Potmeter = null ;
    private const appPaddingMIN : Number = 0 ;
    private const appPaddingMAX : Number = 16 ;
    private const appPaddingINC : Number = 1 ;
// appRadius
    private var appRadiusLAB : TextLabel = null ;
    private var appRadiusOBJ : Potmeter = null ;
    private const appRadiusMIN : Number = 0 ;
    private const appRadiusMAX : Number = 12 ;
    private const appRadiusINC : Number = 1 ;
// appBoxMinCorner
    private var appBoxCornerLAB : TextLabel = null ;
    private var appBoxCornerOBJ : Potmeter = null ;
    private const appBoxCornerMIN : Number = 0 ;
    private const appBoxCornerMAX : Number = 22 ;
    private const appBoxCornerINC : Number = 1 ;
// appBoxFrame
    private var appBoxFrameLAB : TextLabel = null ;
    private var appBoxFrameOBJ : ListPicker = null ;
// predefined disdplaying styles
    private var displayingStyleLAB : TextLabel = null ;
    private var displayingStyleOBJ : ListPicker = null ;
    private var appBackgroundColorsLAB : TextLabel = null ;
// appBackgroundColorDark
    private var appBackgroundColorDarkOBJ : ColorPicker = null ;
// appBackgroundColorMid
    private var appBackgroundColorMidOBJ : ColorPicker = null ;
// appBackgroundColorBright
    private var appBackgroundColorBrightOBJ : ColorPicker = null ;
// appBackgroundColorAlpha
    private var appBackgroundColorAlphaLAB : TextLabel = null ;
    private var appBackgroundColorAlphaOBJ : Potmeter = null ;
    private const appBackgroundColorAlphaMIN : Number = 0 ;
    private const appBackgroundColorAlphaMAX : Number = 1 ;
    private const appBackgroundColorAlphaINC : Number = 0.01 ;
// appBackgroundColorRand
    private var appBackgroundColorRandOBJ : Switcher = null ;
    private var appBackgroundColorRandLAB : TextLabel = null ;
// appBackgroundColorToFont
    private var appBackgroundColorToFontOBJ : Switcher = null ;
// appBackgroundColorGetNewSchema
    private var appBackgroundColorGetNewSchema : ButtonLink = null ;
// appBackgroundImage
    private var appBackgroundImageVAL : TextLabel = null ;
// appBackgroundAlign
    private var appBackgroundAlignLAB : TextLabel = null ;
    private var appBackgroundAlignOBJ : ListPicker = null ;
// appBackgroundAlpha
    private var appBackgroundAlphaLAB : TextLabel = null ;
    private var appBackgroundAlphaOBJ : Potmeter = null ;
    private const appBackgroundAlphaMIN : Number = 0 ;
    private const appBackgroundAlphaMAX : Number = 1 ;
    private const appBackgroundAlphaINC : Number = 0.01 ;
// appBackgroundBlur
    private var appBackgroundBlurLAB : TextLabel = null ;
    private var appBackgroundBlurOBJ : Potmeter = null ;
    private const appBackgroundBlurMIN : Number = 0 ;
    private const appBackgroundBlurMAX : Number = 12 ;
    private const appBackgroundBlurINC : Number = 2 ;
// appBackgroundLive
    private var appBackgroundLiveOBJ : Switcher = null ;
    private var appBackgroundLiveLAB : TextLabel = null ;
// userBgHandler
    private var userBgHandler : BaseSprite = null ;
// appFontFace
    private var appFontFaceLAB : TextLabel = null ;
    private var appFontFaceOBJ : ListPicker = null ;
// appFontSize
    private var appFontSizeLAB : TextLabel = null ;
    private var appFontSizeOBJ : ListPicker = null ;
// appFontColorBright
    private var appFontColorBrightOBJ : ColorPicker = null ;
// appFontColorMid
    private var appFontColorMidOBJ : ColorPicker = null ;
// appFontColorDark
    private var appFontColorDarkOBJ : ColorPicker = null ;
    private var appFontColorsLAB : TextLabel = null ;
// appFontBold
    private var appFontBoldOBJ : Switcher = null ;
    private var appFontBoldLAB : TextLabel = null ;
// appFontItalic
    private var appFontItalicOBJ : Switcher = null ;
    private var appFontItalicLAB : TextLabel = null ;
// appFontColorRand
    private var appFontColorRandOBJ : Switcher = null ;
    private var appFontColorRandLAB : TextLabel = null ;
// appFontColorToBackground
    private var appFontColorToBackgroundOBJ : Switcher = null ;
// appFontColorGetNewSchema
    private var appFontColorGetNewSchema : ButtonLink = null ;
// ABOUT
    private var applicationNameLAB : TextLabel = null ;
    private var applicationVersionLAB : TextLabel = null ;
    private var applicationReleaseDateLAB : TextLabel = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function PanelSettings ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// The array of the widget containers.
      numOfWidgetcontainersARR = new Array ( ) ;
      for ( var i : int = 1 ; i <= application . getPropsApp ( ) . getMaxNumOfWidgetcontainers ( ) ; i ++ )
      {
        numOfWidgetcontainersARR [ i - 1 ] = i ;
      }
// Creating the elements.
      createElements ( ) ;
    }
/*
** Override this.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( langCodeOBJ != null )
      {
        langCodeOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( numOfWidgetcontainersOBJ != null )
      {
        numOfWidgetcontainersOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appWidgetModeOBJ != null )
      {
        appWidgetModeOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appSoundVolumeOBJ != null )
      {
        appSoundVolumeOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appSoundPlayingOBJ != null )
      {
        appSoundPlayingOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appLineThicknessOBJ != null )
      {
        appLineThicknessOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appMarginOBJ != null )
      {
        appMarginOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appPaddingOBJ != null )
      {
        appPaddingOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorDarkOBJ != null )
      {
        appBackgroundColorDarkOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorMidOBJ != null )
      {
        appBackgroundColorMidOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorBrightOBJ != null )
      {
        appBackgroundColorBrightOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorAlphaOBJ != null )
      {
        appBackgroundColorAlphaOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorRandOBJ != null )
      {
        appBackgroundColorRandOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorToFontOBJ != null )
      {
        appBackgroundColorToFontOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundColorGetNewSchema != null )
      {
        appBackgroundColorGetNewSchema . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundAlignOBJ != null )
      {
        appBackgroundAlignOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundBlurOBJ != null )
      {
        appBackgroundBlurOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundAlphaOBJ != null )
      {
        appBackgroundAlphaOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundLiveOBJ != null )
      {
        appBackgroundLiveOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontFaceOBJ != null )
      {
        appFontFaceOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontSizeOBJ != null )
      {
        appFontSizeOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorBrightOBJ != null )
      {
        appFontColorBrightOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorMidOBJ != null )
      {
        appFontColorMidOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorDarkOBJ != null )
      {
        appFontColorDarkOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorRandOBJ != null )
      {
        appFontColorRandOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorToBackgroundOBJ != null )
      {
        appFontColorToBackgroundOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontColorGetNewSchema != null )
      {
        appFontColorGetNewSchema . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontBoldOBJ != null )
      {
        appFontBoldOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appFontItalicOBJ != null )
      {
        appFontItalicOBJ . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** The creation of the elements.
*/
    private function createElements ( ) : void
    {
// The content multiple first.
      indexGeneral = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_GENERAL ) ;
      indexLining = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_LINING ) ;
      indexColoring = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_COLORING ) ;
      indexImaging = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_IMAGING ) ;
      indexFonting = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_FONTING ) ;
      indexAbout = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_ABOUT ) ;
      contentMultiple . setElementsFix ( indexGeneral , 1 ) ;
      contentMultiple . setElementsFix ( indexLining , 2 ) ;
      contentMultiple . setElementsFix ( indexColoring , 1 ) ;
      contentMultiple . setElementsFix ( indexImaging , 1 ) ;
      contentMultiple . setElementsFix ( indexFonting , 1 ) ;
      contentMultiple . setElementsFix ( indexAbout , 0 ) ;
      contentMultiple . setActiveIndex ( 0 ) ;
// The current index to use for adding new objects to the panel.
      var curr : int = 0 ;
// langCode
      langCodeOBJ = new LangSetter ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeOBJ , curr ) ;
      curr ++ ;
      langCodeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeLAB , curr ) ;
      curr ++ ;
      langCodeLAB . setTextCode ( application . getTexts ( ) . SETTING_LANGUAGE ) ;
// The number of the widget containers.
      if ( application . getPropsApp ( ) . getPanelSettingsEnableMaxDesktops ( ) )
      {
        numOfWidgetcontainersOBJ = new ListPicker ( application ) ;
        contentMultiple . addToContent ( indexGeneral , numOfWidgetcontainersOBJ , curr ) ;
        curr ++ ;
        numOfWidgetcontainersOBJ . setNumOfElements ( listPickerCNT ) ;
        numOfWidgetcontainersOBJ . setArrays ( numOfWidgetcontainersARR , numOfWidgetcontainersARR ) ;
        numOfWidgetcontainersOBJ . setSelectedIndex ( 0 ) ;
        numOfWidgetcontainersLAB = new TextLabel ( application ) ;
        contentMultiple . addToContent ( indexGeneral , numOfWidgetcontainersLAB , curr ) ;
        curr ++ ;
        numOfWidgetcontainersLAB . setTextCode ( application . getTexts ( ) . SETTING_NUM_OF_WIDGETCONTAINERS ) ;
      }
// The current widget container.
      if ( application . getPropsApp ( ) . getPanelSettingsEnableCurrDesktop ( ) )
      {
        currWidgetcontainerOBJ = new ListPicker ( application ) ;
        contentMultiple . addToContent ( indexGeneral , currWidgetcontainerOBJ , curr ) ;
        curr ++ ;
        currWidgetcontainerOBJ . setNumOfElements ( listPickerCNT ) ;
        setArraysCurrWidgetcontainerOBJ ( ) ;
        currWidgetcontainerOBJ . setSelectedIndex ( 0 ) ;
        currWidgetcontainerLAB = new TextLabel ( application ) ;
        contentMultiple . addToContent ( indexGeneral , currWidgetcontainerLAB , curr ) ;
        curr ++ ;
        currWidgetcontainerLAB . setTextCode ( application . getTexts ( ) . SETTING_CURR_WIDGETCONTAINER ) ;
      }
// appWidgetsOrientation
      if ( application . getPropsApp ( ) . getPanelSettingsEnableWidgetsOrientation ( ) )
      {
        appWidgetsOrientationOBJ = new ListPicker ( application ) ;
        contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationOBJ , curr ) ;
        curr ++ ;
        appWidgetsOrientationOBJ . setNumOfElements ( listPickerCNT ) ;
        appWidgetsOrientationOBJ . setArrays ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) , application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) ) ;
        appWidgetsOrientationLAB = new TextLabel ( application ) ;
        contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationLAB , curr ) ;
        curr ++ ;
        appWidgetsOrientationLAB . setTextCode ( application . getTexts ( ) . SETTING_WIDGETS_ORIENTATION ) ;
      }
// appWidgetMode
      appWidgetModeOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetModeOBJ , curr ) ;
      curr ++ ;
      appWidgetModeOBJ . setNumOfElements ( 3 ) ;
      appWidgetModeOBJ . setArrays ( application . getTextStock ( ) . getTextCodesWidgetModes ( ) , application . getTextStock ( ) . getTextCodesWidgetModes ( ) ) ;
      appWidgetModeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetModeLAB , curr ) ;
      curr ++ ;
      appWidgetModeLAB . setTextCode ( application . getTexts ( ) . SETTING_WIDGET_MODE ) ;
// sound
      appSoundPlayingOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appSoundPlayingOBJ , curr ) ;
      curr ++ ;
      appSoundPlayingOBJ . setTextCodes ( application . getTexts ( ) . SETTING_SOUND_PLAYING_ON , application . getTexts ( ) . SETTING_SOUND_PLAYING_OFF ) ;
      appSoundVolumeOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appSoundVolumeOBJ , curr ) ;
      curr ++ ;
      appSoundVolumeOBJ . setMinMaxIncValues ( appSoundVolumeMIN , appSoundVolumeMAX , appSoundVolumeINC ) ;
// appLineThickness
      appLineThicknessOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessOBJ , 0 ) ;
      appLineThicknessOBJ . setMinMaxIncValues ( appLineThicknessMIN , appLineThicknessMAX , appLineThicknessINC ) ;
      appLineThicknessLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessLAB , 2 ) ;
      appLineThicknessLAB . setTextCode ( application . getTexts ( ) . SETTING_LINE_THICKNESS ) ;
// appMargin
      appMarginOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginOBJ , 3 ) ;
      appMarginOBJ . setMinMaxIncValues ( appMarginMIN , appMarginMAX , appMarginINC ) ;
      appMarginLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginLAB , 5 ) ;
      appMarginLAB . setTextCode ( application . getTexts ( ) . SETTING_MARGIN ) ;
// appPadding
      appPaddingOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingOBJ , 6 ) ;
      appPaddingOBJ . setMinMaxIncValues ( appPaddingMIN , appPaddingMAX , appPaddingINC ) ;
      appPaddingLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingLAB , 8 ) ;
      appPaddingLAB . setTextCode ( application . getTexts ( ) . SETTING_PADDING ) ;
// appRadius
      appRadiusOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusOBJ , 9 ) ;
      appRadiusOBJ . setMinMaxIncValues ( appRadiusMIN , appRadiusMAX , appRadiusINC ) ;
      appRadiusLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusLAB , 11 ) ;
      appRadiusLAB . setTextCode ( application . getTexts ( ) . SETTING_RADIUS ) ;
// appBoxCorner
      appBoxCornerOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexLining , appBoxCornerOBJ , 12 ) ;
      appBoxCornerOBJ . setMinMaxIncValues ( appBoxCornerMIN , appBoxCornerMAX , appBoxCornerINC ) ;
      appBoxCornerLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appBoxCornerLAB , 14 ) ;
      appBoxCornerLAB . setTextCode ( application . getTexts ( ) . SETTING_BOX_CORNER ) ;
// appBoxFrame
      appBoxFrameOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexLining , appBoxFrameOBJ , 15 ) ;
      appBoxFrameOBJ . setNumOfElements ( 4 ) ;
      appBoxFrameOBJ . setArrays ( application . getTextStock ( ) . getTextCodesBoxFrames ( ) , application . getTextStock ( ) . getTextCodesBoxFrames ( ) ) ;
      appBoxFrameLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appBoxFrameLAB , 17 ) ;
      appBoxFrameLAB . setTextCode ( application . getTexts ( ) . SETTING_BOX_FRAME ) ;
// Predefined disdplaying styles
      displayingStyleOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , displayingStyleOBJ , 0 ) ;
      displayingStyleOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfDisplayingStylesOBJ ( ) ;
      displayingStyleLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , displayingStyleLAB , 1 ) ;
      displayingStyleLAB . setTextCode ( application . getTexts ( ) . SETTING_DISPLAYING_STYLE ) ;
// appBackgroundColorBright, Mid , Dark
      appBackgroundColorBrightOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorBrightOBJ , 2 ) ;
      appBackgroundColorMidOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorMidOBJ , 2 ) ;
      appBackgroundColorDarkOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorDarkOBJ , 2 ) ;
      appBackgroundColorsLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorsLAB , 3 ) ;
      appBackgroundColorsLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_COLORS ) ;
// appBackgroundColorAlpha
      appBackgroundColorAlphaOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorAlphaOBJ , 4 ) ;
      appBackgroundColorAlphaOBJ . setMinMaxIncValues ( appBackgroundColorAlphaMIN , appBackgroundColorAlphaMAX , appBackgroundColorAlphaINC ) ;
      appBackgroundColorAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorAlphaLAB , 5 ) ;
      appBackgroundColorAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_COLOR_ALPHA ) ;
// appBackgroundColorRand
      appBackgroundColorRandOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorRandOBJ , 6 ) ;
      appBackgroundColorRandOBJ . setTextCodes ( application . getTexts ( ) . SETTING_BACKGROUND_COLOR_RANDOM , application . getTexts ( ) . SETTING_BACKGROUND_COLOR_NORMAL ) ;
      appBackgroundColorRandLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorRandLAB , 7 ) ;
      appBackgroundColorRandLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_COLOR_RANDOMNESS ) ;
// appBackgroundColorToBackground
      appBackgroundColorToFontOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorToFontOBJ , 8 ) ;
      appBackgroundColorToFontOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_COLOR_CHANGE , application . getTexts ( ) . SETTING_FONT_COLOR_REMAIN ) ;
// appBackgroundColorGetNewSchema
      appBackgroundColorGetNewSchema = new ButtonLink ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundColorGetNewSchema , 9 ) ;
      appBackgroundColorGetNewSchema . setTextCode ( application . getTexts ( ) . SETTING_GET_NEW_BACKGROUND_COLORSCHEMA ) ;
      appBackgroundColorGetNewSchema . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , getNewRandomBackgroundColorSchema ) ;
// appBackgroundImage
      appBackgroundImageVAL = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundImageVAL , 0 ) ;
      appBackgroundImageVAL . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
// userBgHandler
// appBackgroundAlign
      appBackgroundAlignOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignOBJ , 2 ) ;
      appBackgroundAlignOBJ . setNumOfElements ( listPickerCNT ) ;
      appBackgroundAlignOBJ . setArrays ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) , application . getTextStock ( ) . getTextCodesBgImageAligns ( ) ) ;
      appBackgroundAlignLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignLAB , 3 ) ;
      appBackgroundAlignLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALIGN ) ;
// appBackgroundAlpha
      appBackgroundAlphaOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaOBJ , 4 ) ;
      appBackgroundAlphaOBJ . setMinMaxIncValues ( appBackgroundAlphaMIN , appBackgroundAlphaMAX , appBackgroundAlphaINC ) ;
      appBackgroundAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaLAB , 5 ) ;
      appBackgroundAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALPHA ) ;
// appBackgroundBlur
      appBackgroundBlurOBJ = new Potmeter ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundBlurOBJ , 6 ) ;
      appBackgroundBlurOBJ . setMinMaxIncValues ( appBackgroundBlurMIN , appBackgroundBlurMAX , appBackgroundBlurINC ) ;
      appBackgroundBlurLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundBlurLAB , 7 ) ;
      appBackgroundBlurLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_BLUR ) ;
// appBackgroundLive
      appBackgroundLiveOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundLiveOBJ , 8 ) ;
      appBackgroundLiveOBJ . setTextCodes ( application . getTexts ( ) . SETTING_BACKGROUND_LIVE , application . getTexts ( ) . SETTING_BACKGROUND_FIXED ) ;
      appBackgroundLiveLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundLiveLAB , 9 ) ;
      appBackgroundLiveLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_MOVEMENT ) ;
// appFontFace
      appFontFaceOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceOBJ , 0 ) ;
      appFontFaceOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfAppFontFacesOBJ ( ) ;
      appFontFaceLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceLAB , 1 ) ;
      appFontFaceLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_FACE ) ;
// appFontSize
      appFontSizeOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeOBJ , 2 ) ;
      appFontSizeOBJ . setNumOfElements ( listPickerCNT ) ;
      appFontSizeOBJ . setArrays ( application . getPropsDyn ( ) . getFontSizes ( ) , application . getPropsDyn ( ) . getFontSizes ( ) ) ;
      appFontSizeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeLAB , 3 ) ;
      appFontSizeLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_SIZE ) ;
// appFontColorBright, Mid, Dark
      appFontColorBrightOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorBrightOBJ , 4 ) ;
      appFontColorMidOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorMidOBJ , 4 ) ;
      appFontColorDarkOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorDarkOBJ , 4 ) ;
      appFontColorsLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorsLAB , 5 ) ;
      appFontColorsLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_COLORS ) ;
// appFontBold
      appFontBoldOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontBoldOBJ , 6 ) ;
      appFontBoldOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_BOLD , application . getTexts ( ) . SETTING_FONT_NORMAL ) ;
      appFontBoldLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontBoldLAB , 7 ) ;
      appFontBoldLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_THICKNESS ) ;
// appFontItalic
      appFontItalicOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontItalicOBJ , 8 ) ;
      appFontItalicOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_ITALIC , application . getTexts ( ) . SETTING_FONT_NORMAL ) ;
      appFontItalicLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontItalicLAB , 9 ) ;
      appFontItalicLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_SKEWNESS ) ;
// appFontColorRand
      appFontColorRandOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorRandOBJ , 10 ) ;
      appFontColorRandOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_COLOR_RANDOM , application . getTexts ( ) . SETTING_FONT_COLOR_NORMAL ) ;
      appFontColorRandLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorRandLAB , 11 ) ;
      appFontColorRandLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_COLOR_RANDOMNESS ) ;
// appFontColorToBackground
      appFontColorToBackgroundOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorToBackgroundOBJ , 12 ) ;
      appFontColorToBackgroundOBJ . setTextCodes ( application . getTexts ( ) . SETTING_BACKGROUND_COLOR_CHANGE , application . getTexts ( ) . SETTING_BACKGROUND_COLOR_REMAIN ) ;
// appFontColorGetNewSchema
      appFontColorGetNewSchema = new ButtonLink ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorGetNewSchema , 13 ) ;
      appFontColorGetNewSchema . setTextCode ( application . getTexts ( ) . SETTING_GET_NEW_FONT_COLORSCHEMA ) ;
      appFontColorGetNewSchema . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , getNewRandomFontColorSchema ) ;
// ABOUT
      applicationNameLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationNameLAB , 0 ) ;
      applicationNameLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      applicationVersionLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationVersionLAB , 1 ) ;
      applicationVersionLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      applicationReleaseDateLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationReleaseDateLAB , 2 ) ;
      applicationReleaseDateLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      refreshAbout ( ) ;
      for ( var j : int = 0 ; j < Math . min ( 10 , application . getPropsApp ( ) . getApplicationSoftwareHomepageTxt ( ) . length ) ; j ++ )
      {
        var buttonLink : ButtonLink = new ButtonLink ( application ) ;
        contentMultiple . addToContent ( indexAbout , buttonLink , 5 + j ) ;
        buttonLink . setTextCode ( application . getPropsApp ( ) . getApplicationSoftwareHomepageTxt ( ) [ j ] ) ;
        buttonLink . setUrl ( application . getPropsApp ( ) . getApplicationSoftwareHomepageUrl ( ) [ j ] ) ;
      }
// The default values have to be displayed from PropsDyn.
      displayingStyleChangedOutside ( null ) ;
      widgetsOrientationChangedOutside ( null ) ;
      widgetModeChangedOutside ( null ) ;
      soundVolumeChangedOutside ( null ) ;
      soundPlayingChangedOutside ( null ) ;
      lineThicknessChangedOutside ( null ) ;
      marginChangedOutside ( null ) ;
      paddingChangedOutside ( null ) ;
      radiusChangedOutside ( null ) ;
      boxCornerChangedOutside ( null ) ;
      boxFrameChangedOutside ( null ) ;
      backgroundColorDarkChangedOutside ( null ) ;
      backgroundColorMidChangedOutside ( null ) ;
      backgroundColorBrightChangedOutside ( null ) ;
      backgroundFillAlphaChangedOutside ( null ) ;
      backgroundImageChangedOutside ( null ) ;
      backgroundAlignChangedOutside ( null ) ;
      backgroundAlphaChangedOutside ( null ) ;
      backgroundBlurChangedOutside ( null ) ;
      backgroundLiveChangedOutside ( null ) ;
      fontFaceChangedOutside ( null ) ;
      fontSizeChangedOutside ( null ) ;
      fontColorBrightChangedOutside ( null ) ;
      fontColorMidChangedOutside ( null ) ;
      fontColorDarkChangedOutside ( null ) ;
      fontBoldChangedOutside ( null ) ;
      fontItalicChangedOutside ( null ) ;
// Default picker sizes.
      resizeListPickers ( ) ;
      appBackgroundAlignLABResized ( null ) ;
// This is at the end!
// Events that will be thrown when the object changes its value.
      if ( numOfWidgetcontainersOBJ != null )
      {
        numOfWidgetcontainersOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , numOfWidgetcontainersOBJChanged ) ;
      }
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
      }
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
      }
      appWidgetModeOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetModeOBJChanged ) ;
      appSoundVolumeOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appSoundVolumeOBJchanged ) ;
      appSoundPlayingOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appSoundPlayingOBJresized ) ;
      appSoundPlayingOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appSoundPlayingOBJchanged ) ;
      appLineThicknessOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appLineThicknessOBJchanged ) ;
      appMarginOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appMarginOBJchanged ) ;
      appPaddingOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appPaddingOBJchanged ) ;
      appRadiusOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appRadiusOBJchanged ) ;
      appBoxCornerOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBoxCornerOBJchanged ) ;
      appBoxFrameOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBoxFrameOBJchanged ) ;
      displayingStyleOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , displayingStyleOBJChanged ) ;
      appBackgroundAlignLAB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appBackgroundAlignLABResized ) ;
      appBackgroundColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorDarkOBJChanged ) ;
      appBackgroundColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appBackgroundColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appBackgroundColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appBackgroundColorsOBJSizesChanged ) ;
      appBackgroundColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorMidOBJChanged ) ;
      appBackgroundColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appBackgroundColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appBackgroundColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appBackgroundColorsOBJSizesChanged ) ;
      appBackgroundColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorBrightOBJChanged ) ;
      appBackgroundColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appBackgroundColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appBackgroundColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appBackgroundColorsOBJSizesChanged ) ;
      appBackgroundColorAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorAlphaOBJchanged ) ;
      appBackgroundAlignOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlignOBJChanged ) ;
      appBackgroundAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlphaOBJchanged ) ;
      appBackgroundBlurOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundBlurOBJchanged ) ;
      appBackgroundLiveOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundLiveOBJChanged ) ;
      appBackgroundColorRandOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorRandOBJChanged ) ;
      appBackgroundColorToFontOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundColorToFontOBJChanged ) ;
      appFontFaceOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontFaceOBJChanged ) ;
      appFontSizeOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontSizeOBJChanged ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorBrightOBJChanged ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appFontColorsOBJSizesChanged ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorMidOBJChanged ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appFontColorsOBJSizesChanged ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorDarkOBJChanged ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_START , colorStealStart ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP , colorStealStop ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , appFontColorsOBJSizesChanged ) ;
      appFontColorRandOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorRandOBJChanged ) ;
      appFontColorToBackgroundOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorToBackgroundOBJChanged ) ;
      appFontBoldOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontBoldOBJChanged ) ;
      appFontItalicOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontItalicOBJChanged ) ;
// And then these are the events which can be thrown by the PropsDyn,
// so, the value has to be actualized.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGETS_ORIENTATION_CHANGED , widgetsOrientationChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_MODE_CHANGED , widgetModeChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SOUND_PLAYING_CHANGED , soundPlayingChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SOUND_VOLUME_CHANGED , soundVolumeChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOX_CORNER_CHANGED , boxCornerChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOX_FRAME_CHANGED , boxFrameChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_DISPLAYING_STYLE_CHANGED , displayingStyleChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_RAND_CHANGED , backgroundColorRandChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED , backgroundColorToFontChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , backgroundColorDarkChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , backgroundColorMidChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , backgroundColorBrightChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , backgroundFillAlphaChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_IMAGE_CHANGED , backgroundImageChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_ALIGN_CHANGED , backgroundAlignChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_ALPHA_CHANGED , backgroundAlphaChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BLUR_CHANGED , backgroundBlurChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_LIVE_CHANGED , backgroundLiveChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_FACE_CHANGED , fontFaceChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_SIZE_CHANGED , fontSizeChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_RAND_CHANGED , fontColorRandChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED , fontColorToBackgroundChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED , fontColorBrightChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_MID_CHANGED , fontColorMidChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_DARK_CHANGED , fontColorDarkChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_BOLD_CHANGED , fontBoldChangedOutside ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_ITALIC_CHANGED , fontItalicChangedOutside ) ;
    }
/*
** To add later a custom user background handler object.
*/
    public function addUserBgHandler ( baseSprite : BaseSprite ) : void
    {
      if ( contentMultiple != null && indexImaging > - 1 && baseSprite != null )
      {
        userBgHandler = baseSprite ;
        contentMultiple . addToContent ( indexImaging , baseSprite , 1 ) ;
      }
    }
/*
** To get a new font or background color schema from the background image.
*/
    private function getNewRandomFontColorSchema ( e : Event ) : void
    {
      application . getPropsDyn ( ) . getNewRandomFontColorSchema ( ) ;
    }
    private function getNewRandomBackgroundColorSchema ( e : Event ) : void
    {
      application . getPropsDyn ( ) . getNewRandomBackgroundColorSchema ( ) ;
    }
/*
** It may be necessary to refresh these values.
*/
    public function refreshAbout ( ) : void
    {
      if ( applicationNameLAB != null )
      {
        if ( application . getApplicationType ( ) != "" )
        {
          applicationNameLAB . setTextCode ( application . getApplicationType ( ) + " " + application . getPropsApp ( ) . getApplicationName ( ) ) ;
        }
        else
        {
          applicationNameLAB . setTextCode ( application . getPropsApp ( ) . getApplicationName ( ) ) ;
        }
      }
      if ( applicationVersionLAB != null )
      {
        applicationVersionLAB . setTextCode ( application . getPropsApp ( ) . getApplicationVersion ( ) ) ;
      }
      if ( applicationReleaseDateLAB != null )
      {
        applicationReleaseDateLAB . setTextCode ( application . getPropsApp ( ) . getApplicationReleaseDate ( ) ) ;
      }
    }
/*
** The settings panel has to be invisible during the color stealing.
*/
    private function colorStealStart ( e : Event ) : void
    {
      visible = false ;
    }
    private function colorStealStop ( e : Event ) : void
    {
      visible = true ;
    }
/*
** The listener functions to update the values from outside.
*/
    private function displayingStyleChangedOutside ( e : Event ) : void
    {
      if ( displayingStyleOBJ != null )
      {
        var index : int = displayingStyleOBJ . getArrayValues ( ) . indexOf ( application . getPropsDyn ( ) . getCurrentDisplayingStyle ( ) ) ;
        if ( index > - 1 )
        {
          displayingStyleOBJ . setSelectedIndex ( index ) ;
        }
      }
    }
    private function widgetsOrientationChangedOutside ( e : Event ) : void
    {
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) ) ) ;
      }
    }
    private function widgetModeChangedOutside ( e : Event ) : void
    {
      if ( appWidgetModeOBJ != null )
      {
        appWidgetModeOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetModes ( ) . indexOf ( application . getPropsDyn ( ) . getAppWidgetMode ( ) ) ) ;
      }
    }
    private function soundVolumeChangedOutside ( e : Event ) : void
    {
      if ( appSoundVolumeOBJ != null )
      {
        appSoundVolumeOBJ . setCurValue ( application . getPropsDyn ( ) . getAppSoundVolume ( ) ) ;
      }
    }
    private function soundPlayingChangedOutside ( e : Event ) : void
    {
      if ( appSoundPlayingOBJ != null )
      {
        appSoundPlayingOBJ . setUp ( application . getPropsDyn ( ) . getAppSoundPlaying ( ) ) ;
      }
    }
    private function lineThicknessChangedOutside ( e : Event ) : void
    {
      if ( appLineThicknessOBJ != null )
      {
        appLineThicknessOBJ . setCurValue ( application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      }
    }
    private function marginChangedOutside ( e : Event ) : void
    {
      if ( appMarginOBJ != null )
      {
        appMarginOBJ . setCurValue ( application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      }
    }
    private function paddingChangedOutside ( e : Event ) : void
    {
      if ( appPaddingOBJ != null )
      {
        appPaddingOBJ . setCurValue ( application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
    }
    private function radiusChangedOutside ( e : Event ) : void
    {
      if ( appRadiusOBJ != null )
      {
        appRadiusOBJ . setCurValue ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
      }
    }
    private function boxCornerChangedOutside ( e : Event ) : void
    {
      if ( appBoxCornerOBJ != null )
      {
        appBoxCornerOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBoxCorner ( ) ) ;
      }
    }
    private function boxFrameChangedOutside ( e : Event ) : void
    {
      if ( appBoxFrameOBJ != null )
      {
        appBoxFrameOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBoxFrames ( ) . indexOf ( application . getPropsDyn ( ) . getAppBoxFrame ( ) ) ) ;
      }
    }
    private function backgroundColorDarkChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorDarkOBJ != null )
      {
        appBackgroundColorDarkOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) . toString ( 16 ) ) ;
      }
    }
    private function backgroundColorMidChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorMidOBJ != null )
      {
        appBackgroundColorMidOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) . toString ( 16 ) ) ;
      }
    }
    private function backgroundColorBrightChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorBrightOBJ != null )
      {
        appBackgroundColorBrightOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) . toString ( 16 ) ) ;
      }
    }
    private function backgroundFillAlphaChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorAlphaOBJ != null )
      {
        appBackgroundColorAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) ) ;
      }
    }
    private function backgroundImageChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundImageVAL != null )
      {
        appBackgroundImageVAL . setTextCode ( application . getPropsDyn ( ) . getAppBackgroundImage ( ) ) ;
      }
    }
    private function backgroundAlignChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundAlignOBJ != null )
      {
        appBackgroundAlignOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) . indexOf ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) ) ) ;
      }
    }
    private function backgroundAlphaChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundAlphaOBJ != null )
      {
        appBackgroundAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundAlpha ( ) ) ;
      }
    }
    private function backgroundBlurChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundBlurOBJ != null )
      {
        appBackgroundBlurOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundBlur ( ) ) ;
      }
    }
    private function backgroundLiveChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundLiveOBJ != null )
      {
        appBackgroundLiveOBJ . setUp ( application . getPropsDyn ( ) . getAppBackgroundLive ( ) ) ;
      }
    }
    private function fontFaceChangedOutside ( e : Event ) : void
    {
      if ( appFontFaceOBJ != null )
      {
        appFontFaceOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontFaces ( ) . indexOf ( application . getPropsDyn ( ) . getAppFontFace ( ) ) ) ;
      }
    }
    private function fontSizeChangedOutside ( e : Event ) : void
    {
      if ( appFontSizeOBJ != null )
      {
        appFontSizeOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontSizes ( ) . indexOf ( application . getPropsDyn ( ) . getAppFontSize ( ) ) ) ;
      }
    }
    private function fontColorBrightChangedOutside ( e : Event ) : void
    {
      if ( appFontColorBrightOBJ != null )
      {
        appFontColorBrightOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorBright ( ) . toString ( 16 ) ) ;
      }
    }
    private function fontColorMidChangedOutside ( e : Event ) : void
    {
      if ( appFontColorMidOBJ != null )
      {
        appFontColorMidOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorMid ( ) . toString ( 16 ) ) ;
      }
    }
    private function fontColorDarkChangedOutside ( e : Event ) : void
    {
      if ( appFontColorDarkOBJ != null )
      {
        appFontColorDarkOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorDark ( ) . toString ( 16 ) ) ;
      }
    }
    private function backgroundColorRandChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorRandOBJ != null )
      {
        appBackgroundColorRandOBJ . setUp ( application . getPropsDyn ( ) . getAppBackgroundColorRand ( ) ) ;
      }
    }
    private function backgroundColorToFontChangedOutside ( e : Event ) : void
    {
      if ( appBackgroundColorToFontOBJ != null )
      {
        appBackgroundColorToFontOBJ . setUp ( application . getPropsDyn ( ) . getAppBackgroundColorToFont ( ) ) ;
      }
    }
    private function fontColorRandChangedOutside ( e : Event ) : void
    {
      if ( appFontColorRandOBJ != null )
      {
        appFontColorRandOBJ . setUp ( application . getPropsDyn ( ) . getAppFontColorRand ( ) ) ;
      }
    }
    private function fontColorToBackgroundChangedOutside ( e : Event ) : void
    {
      if ( appFontColorToBackgroundOBJ != null )
      {
        appFontColorToBackgroundOBJ . setUp ( application . getPropsDyn ( ) . getAppFontColorToBackground ( ) ) ;
      }
    }
    private function fontBoldChangedOutside ( e : Event ) : void
    {
      if ( appFontBoldOBJ != null )
      {
        appFontBoldOBJ . setUp ( application . getPropsDyn ( ) . getAppFontBold ( ) ) ;
      }
    }
    private function fontItalicChangedOutside ( e : Event ) : void
    {
      if ( appFontItalicOBJ != null )
      {
        appFontItalicOBJ . setUp ( application . getPropsDyn ( ) . getAppFontItalic ( ) ) ;
      }
    }
/*
** The enabled and disabled has to be set separately on this object.
*/
    public function setUserBgHandlerVisible ( b : Boolean ) : void
    {
      if ( userBgHandler != null )
      {
        userBgHandler . setSpriteVisible ( b ) ;
      }
    }
/*
** This would be in a public function because more languages are available to add later.
*/
    public function setElementsOfLangCodesOBJ ( ) : void
    {
      if ( langCodeOBJ != null )
      {
        langCodeOBJ . updateLangCodes ( ) ;
      }
    }
/*
** This would be in a public function because more languages are available to add later.
*/
    public function setElementsOfDisplayingStylesOBJ ( ) : void
    {
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setArrays ( application . getTextStock ( ) . getTextCodesDisplayingStyles ( ) , application . getTextStock ( ) . getTextCodesDisplayingStyles ( ) ) ;
        displayingStyleOBJ . setSelectedIndex ( 0 ) ;
      }
    }
/*
** Sets the elements of the curr widget container.
** (It depends on the max number of widget containers selected by the user.)
*/
    private function setArraysCurrWidgetcontainerOBJ ( ) : void
    {
      currWidgetcontainerARR = new Array ( ) ;
      if ( numOfWidgetcontainersOBJ != null && currWidgetcontainerOBJ != null )
      {
        for ( var i : int = 1 ; i <= numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 ; i ++ )
        {
          currWidgetcontainerARR [ i - 1 ] = i ;
        }
        currWidgetcontainerOBJ . setArrays ( currWidgetcontainerARR , currWidgetcontainerARR ) ;
      }
    }
/*
** This would be in a public function because more fonts are available to add later.
*/
    public function setElementsOfAppFontFacesOBJ ( ) : void
    {
      if ( appFontFaceOBJ != null )
      {
        appFontFaceOBJ . setArrays ( application . getPropsDyn ( ) . getFontFaces ( ) , application . getPropsDyn ( ) . getFontFaces ( ) ) ;
        fontFaceChangedOutside ( null ) ;
      }
    }
/*
** Shows the actual widget container.
*/
    public function showWidgetContainer ( i : int ) : void
    {
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . setSelectedIndex ( i ) ;
      }
    }
/*
** The style which is currently selected.
*/
    public function getSelectedDisplayingStyleValue ( ) : String
    {
      return displayingStyleOBJ . getArrayValues ( ) [ displayingStyleOBJ . getSelectedIndex ( ) ] ;
    }
/*
** The listener functions to set the properties of the application.
*/
    private function displayingStyleOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setCurrentDisplayingStyle ( getSelectedDisplayingStyleValue ( ) ) ;
      application . getMiddleground ( ) . closePanelSettings ( ) ;
    }
/*
** The working of the max and curr widget containers.
** Cannot be modified from outside, this is not the
** part of the displaying style for example.
*/
    private function numOfWidgetcontainersOBJChanged ( e : Event ) : void
    {
      if ( numOfWidgetcontainersOBJ != null )
      {
        if ( application . getMiddleground ( ) . getWidgets ( ) . getNumOfContents ( ) > numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 )
        {
          var messageString : String = application . getTexts ( ) . SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS ;
          var uniqueString : String = "" + new Date ( ) . time ;
          var alertOkButtonBar : Function = function ( e : Event ) : void
          {
            application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , alertOkButtonBar ) ;
            application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , alertCancelButtonBar ) ;
            application . getForeground ( ) . closeAlert ( uniqueString ) ;
            changeMaxWidgetContainers ( ) ;
            application . getMiddleground ( ) . openPanelSettings ( ) ;
            e . stopImmediatePropagation ( ) ;
          }
          var alertCancelButtonBar : Function = function ( e : Event ) : void
          {
            application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , alertOkButtonBar ) ;
            application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , alertCancelButtonBar ) ;
            application . getForeground ( ) . closeAlert ( uniqueString ) ;
            numOfWidgetcontainersOBJ . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , numOfWidgetcontainersOBJChanged ) ;
            numOfWidgetcontainersOBJ . setSelectedIndex ( numOfWidgetcontainersOBJprevIndex ) ;
            numOfWidgetcontainersOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , numOfWidgetcontainersOBJChanged ) ;
            application . getMiddleground ( ) . openPanelSettings ( ) ;
            e . stopImmediatePropagation ( ) ;
          }
          application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_OK , alertOkButtonBar ) ;
          application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_CANCEL , alertCancelButtonBar ) ;
          application . getForeground ( ) . createAlert ( messageString , uniqueString , true , true ) ;
        }
        else
        {
          changeMaxWidgetContainers ( ) ;
        }
      }
    }
    private function changeMaxWidgetContainers ( ) : void
    {
      if ( numOfWidgetcontainersOBJ != null && currWidgetcontainerOBJ != null && appWidgetsOrientationOBJ != null )
      {
        if ( application . getMiddleground ( ) . getWidgets ( ) . getNumOfContents ( ) > numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 )
        {
          while ( application . getMiddleground ( ) . getWidgets ( ) . getNumOfContents ( ) != numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 )
          {
            application . getMiddleground ( ) . getWidgets ( ) . removeWidgetContainer ( ) ;
          }
        }
        else
        {
          while ( application . getMiddleground ( ) . getWidgets ( ) . getNumOfContents ( ) != numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 )
          {
            application . getMiddleground ( ) . getWidgets ( ) . addWidgetContainer ( ) ;
          }
        }
        numOfWidgetcontainersOBJprevIndex = numOfWidgetcontainersOBJ . getSelectedIndex ( ) ;
        currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
        setArraysCurrWidgetcontainerOBJ ( ) ;
        currWidgetcontainerOBJ . setSelectedIndex ( numOfWidgetcontainersOBJ . getSelectedIndex ( ) ) ;
        currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
        appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetOrientation ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ) ) ;
        application . getMiddleground ( ) . getWidgets ( ) . changeButtonMoveVisibleOnAllWidgets ( ) ;
      }
    }
    private function currWidgetcontainerOBJChanged ( e : Event ) : void
    {
      if ( currWidgetcontainerOBJ != null && appWidgetsOrientationOBJ != null )
      {
        application . getMiddleground ( ) . getWidgets ( ) . setActiveWidgetContainer ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ;
        appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
        appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetOrientation ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ) ) ;
        appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
      }
    }
/*
** The working of the displaying!
** Widget orientation is not the part of the whole handling of displaying style.
*/
    private function appWidgetsOrientationOBJChanged ( e : Event ) : void
    {
      if ( appWidgetsOrientationOBJ != null )
      {
        application . getPropsDyn ( ) . setAppWidgetsOrientation ( appWidgetsOrientationOBJ . getArrayValues ( ) [ appWidgetsOrientationOBJ . getSelectedIndex ( ) ] ) ;
        application . getMiddleground ( ) . closePanelSettings ( ) ;
      }
    }
    private function appWidgetModeOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppWidgetMode ( appWidgetModeOBJ . getArrayValues ( ) [ appWidgetModeOBJ . getSelectedIndex ( ) ] ) ;
      application . setFontSizeFromStage ( ) ;
      application . getMiddleground ( ) . closePanelSettings ( ) ;
    }
    private function appSoundVolumeOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppSoundVolume ( int ( appSoundVolumeOBJ . getCurValue ( ) ) ) ;
    }
    private function appSoundPlayingOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppSoundPlaying ( appSoundPlayingOBJ . getUp ( ) ) ;
    }
    private function appLineThicknessOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppLineThickness ( int ( appLineThicknessOBJ . getCurValue ( ) ) ) ;
      application . getMiddleground ( ) . getWidgets ( ) . goToTheActualWidget ( ) ;
    }
    private function appMarginOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppMargin ( int ( appMarginOBJ . getCurValue ( ) ) ) ;
    }
    private function appPaddingOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppPadding ( int ( appPaddingOBJ . getCurValue ( ) ) ) ;
    }
    private function appRadiusOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppRadius ( int ( appRadiusOBJ . getCurValue ( ) ) ) ;
    }
    private function appBoxCornerOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBoxCorner ( int ( appBoxCornerOBJ . getCurValue ( ) ) ) ;
    }
    private function appBoxFrameOBJchanged ( e : Event ) : void
    {
      if ( appBoxFrameOBJ != null )
      {
        application . getPropsDyn ( ) . setAppBoxFrame ( appBoxFrameOBJ . getArrayValues ( ) [ appBoxFrameOBJ . getSelectedIndex ( ) ] ) ;
      }
    }
    private function appBackgroundColorDarkOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorDark ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appBackgroundColorDarkOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundColorMidOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorMid ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appBackgroundColorMidOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundColorBrightOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorBright ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appBackgroundColorBrightOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundColorAlphaOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorAlpha ( appBackgroundColorAlphaOBJ . getCurValue ( ) ) ;
    }
    private function appBackgroundAlignOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundAlign ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) [ appBackgroundAlignOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function appBackgroundAlphaOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundAlpha ( appBackgroundAlphaOBJ . getCurValue ( ) ) ;
    }
    private function appBackgroundBlurOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundBlur ( appBackgroundBlurOBJ . getCurValue ( ) ) ;
    }
    private function appBackgroundLiveOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundLive ( appBackgroundLiveOBJ . getUp ( ) ) ;
    }
    private function appFontFaceOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontFace ( application . getPropsDyn ( ) . getFontFaces ( ) [ appFontFaceOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function appFontSizeOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontSize ( int ( application . getPropsDyn ( ) . getFontSizes ( ) [ appFontSizeOBJ . getSelectedIndex ( ) ] ) ) ;
    }
    private function appFontColorBrightOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontColorBright ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appFontColorBrightOBJ . getRGBColor ( ) ) ) ;
    }
    private function appFontColorMidOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontColorMid ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appFontColorMidOBJ . getRGBColor ( ) ) ) ;
    }
    private function appFontColorDarkOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontColorDark ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appFontColorDarkOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundColorRandOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorRand ( appBackgroundColorRandOBJ . getUp ( ) ) ;
    }
    private function appBackgroundColorToFontOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundColorToFont ( appBackgroundColorToFontOBJ . getUp ( ) ) ;
    }
    private function appFontColorRandOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontColorRand ( appFontColorRandOBJ . getUp ( ) ) ;
    }
    private function appFontColorToBackgroundOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontColorToBackground ( appFontColorToBackgroundOBJ . getUp ( ) ) ;
    }
    private function appFontBoldOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontBold ( appFontBoldOBJ . getUp ( ) ) ;
    }
    private function appFontItalicOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontItalic ( appFontItalicOBJ . getUp ( ) ) ;
    }
/*
** Sets the lang code of this application.
*/
    public function setLangCode ( langCode : String ) : void
    {
      if ( langCodeOBJ != null )
      {
        langCodeOBJ . setSelectedIndex ( application . getTextStock ( ) . getLangCodes ( ) . indexOf ( langCode ) ) ;
      }
    }
/*
** Gets the reference to the background user image.
** May be necessary in extender applications to access to this reference.
*/
    public function getUserBgHandler ( ) : BaseSprite
    {
      return userBgHandler ;
    }
/*
** Sets the active container.
*/
    public function setActiveWidgetContainer ( i : int ) : void
    {
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . setSelectedIndex ( i ) ;
      }
    }
/*
** Gets the active widget container.
*/
    public function getActiveWidgetContainer ( ) : int
    {
      if ( currWidgetcontainerOBJ != null )
      {
        return currWidgetcontainerOBJ . getSelectedIndex ( ) ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** Resizing the listpicker objects.
*/
    private function resizeListPickers ( ) : void
    {
      if ( appSoundPlayingOBJ != null )
      {
        if ( langCodeOBJ != null )
        {
          langCodeOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
        if ( numOfWidgetcontainersOBJ != null )
        {
          numOfWidgetcontainersOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
        if ( currWidgetcontainerOBJ != null )
        {
          currWidgetcontainerOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
        if ( appWidgetsOrientationOBJ != null )
        {
          appWidgetsOrientationOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
        if ( appWidgetModeOBJ != null )
        {
          appWidgetModeOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
        if ( appBoxFrameOBJ != null )
        {
          appBoxFrameOBJ . setsw ( appSoundPlayingOBJ . getsw ( ) ) ;
        }
      }
    }
/*
** When the size of its label changed.
*/
    private function appBackgroundAlignLABResized ( e : Event ) : void
    {
      if ( appBackgroundAlignOBJ != null && appBackgroundAlignLAB != null )
      {
        appBackgroundAlignOBJ . setsw ( appBackgroundAlignLAB . getsw ( ) ) ;
      }
    }
/*
** When the sizes of the dark font color object is changed.
*/
    private function appFontColorsOBJSizesChanged ( e : Event ) : void
    {
      if ( appFontFaceOBJ != null )
      {
        if ( appFontColorBrightOBJ != null && appFontColorDarkOBJ != null )
        {
          appFontFaceOBJ . setsw ( appFontColorDarkOBJ . getcxsw ( ) - appFontColorBrightOBJ . getcx ( ) ) ;
        }
        else
        {
          appFontFaceOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
        }
      }
      if ( appFontSizeOBJ != null )
      {
        if ( appFontFaceOBJ != null )
        {
          appFontSizeOBJ . setsw ( appFontFaceOBJ . getsw ( ) ) ;
        }
        else
        {
          appFontSizeOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
        }
      }
    }
/*
** When the sizes of the dark font color object is changed.
*/
    private function appBackgroundColorsOBJSizesChanged ( e : Event ) : void
    {
      if ( displayingStyleOBJ != null )
      {
        if ( appBackgroundColorBrightOBJ != null && appBackgroundColorDarkOBJ != null )
        {
          displayingStyleOBJ . setsw ( appBackgroundColorDarkOBJ . getcxsw ( ) - appBackgroundColorBrightOBJ . getcx ( ) ) ;
        }
        else
        {
          displayingStyleOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
        }
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
        appBackgroundColorsOBJSizesChanged ( null ) ;
        appFontColorsOBJSizesChanged ( null ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        appBackgroundColorsOBJSizesChanged ( null ) ;
        appFontColorsOBJSizesChanged ( null ) ;
      }
    }
/*
** When sound playing is resized.
*/
    private function appSoundPlayingOBJresized ( e : Event ) : void
    {
      resizeListPickers ( ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      indexGeneral = 0 ;
      indexLining = 0 ;
      indexColoring = 0 ;
      indexImaging = 0 ;
      indexFonting = 0 ;
      indexAbout = 0 ;
      langCodeLAB = null ;
      langCodeOBJ = null ;
      displayingStyleLAB = null ;
      displayingStyleOBJ = null ;
      numOfWidgetcontainersLAB = null ;
      numOfWidgetcontainersOBJ = null ;
      numOfWidgetcontainersARR . splice ( 0 ) ;
      numOfWidgetcontainersARR = null ;
      currWidgetcontainerLAB = null ;
      currWidgetcontainerOBJ = null ;
      currWidgetcontainerARR . splice ( 0 ) ;
      currWidgetcontainerARR = null ;
      appWidgetsOrientationLAB = null ;
      appWidgetsOrientationOBJ = null ;
      appWidgetModeOBJ = null ;
      appSoundVolumeOBJ = null ;
      appSoundPlayingOBJ = null ;
      appLineThicknessLAB = null ;
      appLineThicknessOBJ = null ;
      appMarginLAB = null ;
      appMarginOBJ = null ;
      appPaddingLAB = null ;
      appPaddingOBJ = null ;
      appRadiusLAB = null ;
      appRadiusOBJ = null ;
      appBoxCornerLAB = null ;
      appBoxCornerOBJ = null ;
      appBoxFrameLAB = null ;
      appBoxFrameOBJ = null ;
      appBackgroundColorsLAB = null ;
      appBackgroundColorDarkOBJ = null ;
      appBackgroundColorMidOBJ = null ;
      appBackgroundColorBrightOBJ = null ;
      appBackgroundColorAlphaLAB = null ;
      appBackgroundColorAlphaOBJ = null ;
      appBackgroundImageVAL = null ;
      appBackgroundAlignLAB = null ;
      appBackgroundAlignOBJ = null ;
      appBackgroundAlphaLAB = null ;
      appBackgroundAlphaOBJ = null ;
      appBackgroundBlurLAB = null ;
      appBackgroundBlurOBJ = null ;
      appBackgroundLiveLAB = null ;
      appBackgroundLiveOBJ = null ;
      userBgHandler = null ;
      appFontFaceLAB = null ;
      appFontFaceOBJ = null ;
      appFontSizeLAB = null ;
      appFontSizeOBJ = null ;
      appFontColorBrightOBJ = null ;
      appFontColorMidOBJ = null ;
      appFontColorDarkOBJ = null ;
      appFontColorsLAB = null ;
      appBackgroundColorRandOBJ = null ;
      appBackgroundColorToFontOBJ = null ;
      appBackgroundColorGetNewSchema = null ;
      appBackgroundColorRandLAB = null ;
      appFontColorRandOBJ = null ;
      appFontColorToBackgroundOBJ = null ;
      appFontColorGetNewSchema = null ;
      appFontColorRandLAB = null ;
      appFontBoldOBJ = null ;
      appFontBoldLAB = null ;
      appFontItalicOBJ = null ;
      appFontItalicLAB = null ;
      applicationNameLAB = null ;
      applicationVersionLAB = null ;
      applicationReleaseDateLAB = null ;
    }
  }
}
