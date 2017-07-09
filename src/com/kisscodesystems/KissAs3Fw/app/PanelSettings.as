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
** PanelSettings.
** The panel of the settings stuff will be visible if the user clicks on the settings button.
**
** MAIN FEATURES:
** - handles:
**   - language
**   - widget orientation
**   - displaying styles
**   - changing of all of the modifiable properties of this app.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . LangSetter ;
  import com . kisscodesystems . KissAs3Fw . base . BasePanel ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ColorPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Potmet ;
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
// predefined disdplaying styles
    private var displayingStyleLAB : TextLabel = null ;
    private var displayingStyleOBJ : ListPicker = null ;
// The number of the widget containers.
    private var numOfWidgetcontainersLAB : TextLabel = null ;
    private var numOfWidgetcontainersOBJ : ListPicker = null ;
    private var numOfWidgetcontainersARR : Array = null ;
// The current widget container.
    private var currWidgetcontainerLAB : TextLabel = null ;
    private var currWidgetcontainerOBJ : ListPicker = null ;
    private var currWidgetcontainerARR : Array = null ;
// appWidgetsOrientation
    private var appWidgetsOrientationLAB : TextLabel = null ;
    private var appWidgetsOrientationOBJ : ListPicker = null ;
// appLineThickness
    private var appLineThicknessLAB : TextLabel = null ;
    private var appLineThicknessOBJ : Potmet = null ;
    private const appLineThicknessMIN : Number = 1 ;
    private const appLineThicknessMAX : Number = 5 ;
    private const appLineThicknessINC : Number = 1 ;
// appMargin
    private var appMarginLAB : TextLabel = null ;
    private var appMarginOBJ : Potmet = null ;
    private const appMarginMIN : Number = 0 ;
    private const appMarginMAX : Number = 30 ;
    private const appMarginINC : Number = 1 ;
// appMargin
    private var appPaddingLAB : TextLabel = null ;
    private var appPaddingOBJ : Potmet = null ;
    private const appPaddingMIN : Number = 0 ;
    private const appPaddingMAX : Number = 10 ;
    private const appPaddingINC : Number = 1 ;
// appRadius0, 1
    private var appRadiusLAB : TextLabel = null ;
    private var appRadiusOBJ0 : Potmet = null ;
    private var appRadiusOBJ1 : Potmet = null ;
    private const appRadiusMIN : Number = 0 ;
    private const appRadiusMAX : Number = 20 ;
    private const appRadiusINC : Number = 1 ;
// appBackgroundBgColor
    private var appBackgroundBgColorLAB : TextLabel = null ;
    private var appBackgroundBgColorOBJ : ColorPicker = null ;
// appBackgroundFgColor
    private var appBackgroundFgColorLAB : TextLabel = null ;
    private var appBackgroundFgColorOBJ : ColorPicker = null ;
// appBackgroundFillAlpha
    private var appBackgroundFillAlphaLAB : TextLabel = null ;
    private var appBackgroundFillAlphaOBJ : Potmet = null ;
    private const appBackgroundFillAlphaMIN : Number = 0 ;
    private const appBackgroundFillAlphaMAX : Number = 1 ;
    private const appBackgroundFillAlphaINC : Number = 0.01 ;
// appBackgroundImage
    private var appBackgroundImageLAB : TextLabel = null ;
    private var appBackgroundImageOBJ : ListPicker = null ;
// appBackgroundAlign
    private var appBackgroundAlignLAB : TextLabel = null ;
    private var appBackgroundAlignOBJ : ListPicker = null ;
// appBackgroundAlpha
    private var appBackgroundAlphaLAB : TextLabel = null ;
    private var appBackgroundAlphaOBJ : Potmet = null ;
    private const appBackgroundAlphaMIN : Number = 0 ;
    private const appBackgroundAlphaMAX : Number = 1 ;
    private const appBackgroundAlphaINC : Number = 0.01 ;
// appBackgroundLive
    private var appBackgroundLiveOBJ : Switcher = null ;
// appFontFace
    private var appFontFaceLAB : TextLabel = null ;
    private var appFontFaceOBJ : ListPicker = null ;
// appFontSize
    private var appFontSizeLAB : TextLabel = null ;
    private var appFontSizeOBJ : ListPicker = null ;
// appFontColorBright
    private var appFontColorBrightOBJ : ColorPicker = null ;
// appFontColorBright
    private var appFontColorMidOBJ : ColorPicker = null ;
// appFontColorBright
    private var appFontColorDarkOBJ : ColorPicker = null ;
    private var appFontColorsLAB : TextLabel = null ;
// appFontBold
    private var appFontBoldOBJ : Switcher = null ;
// appFontItalic
    private var appFontItalicOBJ : Switcher = null ;
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
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setEnabled ( getEnabled ( ) ) ;
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
      if ( appBackgroundBgColorOBJ != null )
      {
        appBackgroundBgColorOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundFgColorOBJ != null )
      {
        appBackgroundFgColorOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundFillAlphaOBJ != null )
      {
        appBackgroundFillAlphaOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundImageOBJ != null )
      {
        appBackgroundImageOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( appBackgroundAlignOBJ != null )
      {
        appBackgroundAlignOBJ . setEnabled ( getEnabled ( ) ) ;
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
// langCode
      langCodeOBJ = new LangSetter ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeOBJ , true , 0 ) ;
      langCodeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeLAB , false , 1 ) ;
      langCodeLAB . setTextCode ( application . getTexts ( ) . SETTING_LANGUAGE ) ;
// predefined disdplaying styles
      displayingStyleOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , displayingStyleOBJ , true , 2 ) ;
      displayingStyleOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfDisplayingStylesOBJ ( ) ;
      displayingStyleLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , displayingStyleLAB , false , 3 ) ;
      displayingStyleLAB . setTextCode ( application . getTexts ( ) . SETTING_DISPLAYING_STYLE ) ;
// The number of the widget containers.
      numOfWidgetcontainersOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , numOfWidgetcontainersOBJ , true , 4 ) ;
      numOfWidgetcontainersOBJ . setNumOfElements ( listPickerCNT ) ;
      numOfWidgetcontainersARR = new Array ( ) ;
      for ( var i : int = 1 ; i <= application . getPropsApp ( ) . getMaxNumOfWidgetcontainers ( ) ; i ++ )
      {
        numOfWidgetcontainersARR [ i - 1 ] = i ;
      }
      numOfWidgetcontainersOBJ . setArrays ( numOfWidgetcontainersARR , numOfWidgetcontainersARR ) ;
      numOfWidgetcontainersOBJ . setSelectedIndex ( 0 ) ;
      numOfWidgetcontainersLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , numOfWidgetcontainersLAB , false , 5 ) ;
      numOfWidgetcontainersLAB . setTextCode ( application . getTexts ( ) . SETTING_NUM_OF_WIDGETCONTAINERS ) ;
// The current widget container.
      currWidgetcontainerOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , currWidgetcontainerOBJ , true , 6 ) ;
      currWidgetcontainerOBJ . setNumOfElements ( listPickerCNT ) ;
      setArraysCurrWidgetcontainerOBJ ( ) ;
      currWidgetcontainerOBJ . setSelectedIndex ( 0 ) ;
      currWidgetcontainerLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , currWidgetcontainerLAB , false , 7 ) ;
      currWidgetcontainerLAB . setTextCode ( application . getTexts ( ) . SETTING_CURR_WIDGETCONTAINER ) ;
// appWidgetsOrientation
      appWidgetsOrientationOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationOBJ , true , 8 ) ;
      appWidgetsOrientationOBJ . setNumOfElements ( listPickerCNT ) ;
      appWidgetsOrientationOBJ . setArrays ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) , application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) ) ;
      appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) ) ) ;
      appWidgetsOrientationLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationLAB , false , 9 ) ;
      appWidgetsOrientationLAB . setTextCode ( application . getTexts ( ) . SETTING_WIDGET_ORIENTATION ) ;
// appLineThickness
      appLineThicknessOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessOBJ , true , 0 ) ;
      appLineThicknessOBJ . setMinMaxIncValues ( appLineThicknessMIN , appLineThicknessMAX , appLineThicknessINC ) ;
      appLineThicknessOBJ . setCurValue ( application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      appLineThicknessLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessLAB , false , 2 ) ;
      appLineThicknessLAB . setTextCode ( application . getTexts ( ) . SETTING_LINE_THICKNESS ) ;
// appMargin
      appMarginOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginOBJ , true , 3 ) ;
      appMarginOBJ . setMinMaxIncValues ( appMarginMIN , appMarginMAX , appMarginINC ) ;
      appMarginOBJ . setCurValue ( application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      appMarginLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginLAB , false , 5 ) ;
      appMarginLAB . setTextCode ( application . getTexts ( ) . SETTING_MARGIN ) ;
// appPadding
      appPaddingOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingOBJ , true , 6 ) ;
      appPaddingOBJ . setMinMaxIncValues ( appPaddingMIN , appPaddingMAX , appPaddingINC ) ;
      appPaddingOBJ . setCurValue ( application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      appPaddingLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingLAB , false , 8 ) ;
      appPaddingLAB . setTextCode ( application . getTexts ( ) . SETTING_PADDING ) ;
// appRadius0, 1
      appRadiusOBJ0 = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusOBJ0 , true , 9 ) ;
      appRadiusOBJ0 . setMinMaxIncValues ( appRadiusMIN , appRadiusMAX , appRadiusINC ) ;
      appRadiusOBJ0 . setCurValue ( application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
      appRadiusOBJ1 = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusOBJ1 , true , 10 ) ;
      appRadiusOBJ1 . setMinMaxIncValues ( appRadiusMIN , appRadiusMAX , appRadiusINC ) ;
      appRadiusOBJ1 . setCurValue ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
      appRadiusLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusLAB , false , 11 ) ;
      appRadiusLAB . setTextCode ( application . getTexts ( ) . SETTING_RADIUS ) ;
// appBackgroundBgColor
      appBackgroundBgColorOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundBgColorOBJ , true , 0 ) ;
      appBackgroundBgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) . toString ( 16 ) ) ;
      appBackgroundBgColorLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundBgColorLAB , false , 1 ) ;
      appBackgroundBgColorLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_BG_COLOR ) ;
// appBackgroundFgColor
      appBackgroundFgColorOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFgColorOBJ , true , 2 ) ;
      appBackgroundFgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) . toString ( 16 ) ) ;
      appBackgroundFgColorLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFgColorLAB , false , 3 ) ;
      appBackgroundFgColorLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_FG_COLOR ) ;
// appBackgroundFillAlpha
      appBackgroundFillAlphaOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFillAlphaOBJ , true , 4 ) ;
      appBackgroundFillAlphaOBJ . setMinMaxIncValues ( appBackgroundFillAlphaMIN , appBackgroundFillAlphaMAX , appBackgroundFillAlphaINC ) ;
      appBackgroundFillAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) ) ;
      appBackgroundFillAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFillAlphaLAB , false , 5 ) ;
      appBackgroundFillAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_FILL_ALPHA ) ;
// appBackgroundImage
      appBackgroundImageOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundImageOBJ , true , 0 ) ;
      appBackgroundImageOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfBackgroundImageOBJ ( ) ;
      appBackgroundImageLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundImageLAB , false , 1 ) ;
      appBackgroundImageLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_IMAGE ) ;
// appBackgroundAlign
      appBackgroundAlignOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignOBJ , true , 2 ) ;
      appBackgroundAlignOBJ . setNumOfElements ( listPickerCNT ) ;
      appBackgroundAlignOBJ . setArrays ( application . getTextStock ( ) . getTextsBgImageAligns ( ) , application . getTextStock ( ) . getTextCodesBgImageAligns ( ) ) ;
      appBackgroundAlignOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) . indexOf ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) ) ) ;
      appBackgroundAlignLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignLAB , false , 3 ) ;
      appBackgroundAlignLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALIGN ) ;
// appBackgroundAlpha
      appBackgroundAlphaOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaOBJ , true , 4 ) ;
      appBackgroundAlphaOBJ . setMinMaxIncValues ( appBackgroundAlphaMIN , appBackgroundAlphaMAX , appBackgroundAlphaINC ) ;
      appBackgroundAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundAlpha ( ) ) ;
      appBackgroundAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaLAB , false , 5 ) ;
      appBackgroundAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALPHA ) ;
// appBackgroundLive
      appBackgroundLiveOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundLiveOBJ , true , 6 ) ;
      appBackgroundLiveOBJ . setTextCodes ( application . getTexts ( ) . SETTING_BACKGROUND_LIVE , application . getTexts ( ) . SETTING_BACKGROUND_FIXED ) ;
      appBackgroundLiveOBJ . setUp ( application . getPropsDyn ( ) . getAppBackgroundLive ( ) ) ;
// appFontFace
      appFontFaceOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceOBJ , true , 0 ) ;
      appFontFaceOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfAppFontFacesOBJ ( ) ;
      appFontFaceLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceLAB , false , 1 ) ;
      appFontFaceLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_FACE ) ;
// appFontSize
      appFontSizeOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeOBJ , true , 2 ) ;
      appFontSizeOBJ . setNumOfElements ( listPickerCNT ) ;
      appFontSizeOBJ . setArrays ( application . getPropsDyn ( ) . getFontSizes ( ) , application . getPropsDyn ( ) . getFontSizes ( ) ) ;
      appFontSizeOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontSizes ( ) . indexOf ( "" + application . getPropsDyn ( ) . getAppFontSize ( ) ) ) ;
      appFontSizeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeLAB , false , 3 ) ;
      appFontSizeLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_SIZE ) ;
// appFontColorBright
      appFontColorBrightOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorBrightOBJ , true , 4 ) ;
      appFontColorBrightOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorBright ( ) . toString ( 16 ) ) ;
      appFontColorMidOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorMidOBJ , true , 4 ) ;
      appFontColorMidOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorMid ( ) . toString ( 16 ) ) ;
      appFontColorDarkOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorDarkOBJ , true , 4 ) ;
      appFontColorDarkOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorDark ( ) . toString ( 16 ) ) ;
      appFontColorsLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorsLAB , false , 5 ) ;
      appFontColorsLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_COLORS ) ;
// appFontBold
      appFontBoldOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontBoldOBJ , true , 6 ) ;
      appFontBoldOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_BOLD , application . getTexts ( ) . SETTING_FONT_BOLD ) ;
      appFontBoldOBJ . setUp ( application . getPropsDyn ( ) . getAppFontBold ( ) ) ;
// appFontItalic
      appFontItalicOBJ = new Switcher ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontItalicOBJ , true , 8 ) ;
      appFontItalicOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_ITALIC , application . getTexts ( ) . SETTING_FONT_ITALIC ) ;
      appFontItalicOBJ . setUp ( application . getPropsDyn ( ) . getAppFontItalic ( ) ) ;
// ABOUT
      applicationNameLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationNameLAB , false , 0 ) ;
      applicationNameLAB . setTextCode ( application . getPropsApp ( ) . getApplicationName ( ) ) ;
      applicationNameLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      applicationVersionLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationVersionLAB , false , 1 ) ;
      applicationVersionLAB . setTextCode ( application . getPropsApp ( ) . getApplicationVersion ( ) ) ;
      applicationVersionLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      applicationReleaseDateLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexAbout , applicationReleaseDateLAB , false , 2 ) ;
      applicationReleaseDateLAB . setTextCode ( application . getPropsApp ( ) . getApplicationReleaseDate ( ) ) ;
      applicationReleaseDateLAB . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      for ( var j : int = 0 ; j < Math . min ( 10 , application . getPropsApp ( ) . getApplicationSoftwareHomepageTxt ( ) . length ) ; j ++ )
      {
        var buttonLink : ButtonLink = new ButtonLink ( application ) ;
        contentMultiple . addToContent ( indexAbout , buttonLink , true , 5 + j ) ;
        buttonLink . setTextCode ( application . getPropsApp ( ) . getApplicationSoftwareHomepageTxt ( ) [ j ] ) ;
        buttonLink . setUrl ( application . getPropsApp ( ) . getApplicationSoftwareHomepageUrl ( ) [ j ] ) ;
      }
// This is at the end!
      displayingStyleOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , displayingStyleOBJChanged ) ;
      numOfWidgetcontainersOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , numOfWidgetcontainersOBJChanged ) ;
      currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
      appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
      appLineThicknessOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appLineThicknessOBJchanged ) ;
      appMarginOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appMarginOBJchanged ) ;
      appPaddingOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appPaddingOBJchanged ) ;
      appRadiusOBJ0 . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appRadiusOBJ0changed ) ;
      appRadiusOBJ1 . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appRadiusOBJ1changed ) ;
      appBackgroundBgColorOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundBgColorOBJChanged ) ;
      appBackgroundFgColorOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundFgColorOBJChanged ) ;
      appBackgroundFillAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundFillAlphaOBJchanged ) ;
      appBackgroundImageOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundImageOBJChanged ) ;
      appBackgroundAlignOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlignOBJChanged ) ;
      appBackgroundAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlphaOBJchanged ) ;
      appBackgroundLiveOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundLiveOBJChanged ) ;
      appFontFaceOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontFaceOBJChanged ) ;
      appFontSizeOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontSizeOBJChanged ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorBrightOBJChanged ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorMidOBJChanged ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorDarkOBJChanged ) ;
      appFontBoldOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontBoldOBJChanged ) ;
      appFontItalicOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontItalicOBJChanged ) ;
    }
/*
** To smartphone mode.
*/
    public function toSmartphone ( ) : void
    {
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setEnabled ( false ) ;
      }
      if ( numOfWidgetcontainersOBJ != null )
      {
        numOfWidgetcontainersOBJ . setEnabled ( false ) ;
      }
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . setEnabled ( false ) ;
      }
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setEnabled ( false ) ;
      }
    }
/*
** This would be in a public function because more background images are available to add later.
*/
    public function setElementsOfBackgroundImageOBJ ( ) : void
    {
      if ( appBackgroundImageOBJ != null )
      {
        appBackgroundImageOBJ . setArrays ( application . getTextStock ( ) . getTextsBgImagePics ( ) , application . getTextStock ( ) . getTextCodesBgImagePics ( ) ) ;
        appBackgroundImageOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImagePics ( ) . indexOf ( application . getPropsDyn ( ) . getAppBackgroundImage ( ) ) ) ;
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
      for ( var i : int = 1 ; i <= numOfWidgetcontainersOBJ . getSelectedIndex ( ) + 1 ; i ++ )
      {
        currWidgetcontainerARR [ i - 1 ] = i ;
      }
      currWidgetcontainerOBJ . setArrays ( currWidgetcontainerARR , currWidgetcontainerARR ) ;
    }
/*
** This would be in a public function because more fonts are available to add later.
*/
    public function setElementsOfAppFontFacesOBJ ( ) : void
    {
      if ( appFontFaceOBJ != null )
      {
        appFontFaceOBJ . setArrays ( application . getPropsDyn ( ) . getFontFaces ( ) , application . getPropsDyn ( ) . getFontFaces ( ) ) ;
        appFontFaceOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontFaces ( ) . indexOf ( application . getPropsDyn ( ) . getAppFontFace ( ) ) ) ;
      }
    }
/*
** Shows the actual widget container.
*/
    public function showWidgetContainer ( i : int ) : void
    {
      currWidgetcontainerOBJ . setSelectedIndex ( i ) ;
    }
/*
** The listener functions to set the properties of the application.
*/
    private function displayingStyleOBJChanged ( e : Event ) : void
    {
      setDisplayingStyle ( application . getTextStock ( ) . getTextCodesDisplayingStyles ( ) [ displayingStyleOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function numOfWidgetcontainersOBJChanged ( e : Event ) : void
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
      currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
      setArraysCurrWidgetcontainerOBJ ( ) ;
      currWidgetcontainerOBJ . setSelectedIndex ( numOfWidgetcontainersOBJ . getSelectedIndex ( ) ) ;
      currWidgetcontainerOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , currWidgetcontainerOBJChanged ) ;
      appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetOrientation ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ) ) ;
      application . getMiddleground ( ) . getWidgets ( ) . changeButtonMoveVisibleOnAllWidgets ( ) ;
    }
    private function currWidgetcontainerOBJChanged ( e : Event ) : void
    {
      application . getMiddleground ( ) . getWidgets ( ) . setActiveWidgetContainer ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ;
      appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
      appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetOrientation ( currWidgetcontainerOBJ . getSelectedIndex ( ) ) ) ) ;
      appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
    }
    private function appWidgetsOrientationOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppWidgetsOrientation ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) [ appWidgetsOrientationOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function appLineThicknessOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppLineThickness ( int ( appLineThicknessOBJ . getCurValue ( ) ) ) ;
    }
    private function appMarginOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppMargin ( int ( appMarginOBJ . getCurValue ( ) ) ) ;
    }
    private function appPaddingOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppPadding ( int ( appPaddingOBJ . getCurValue ( ) ) ) ;
    }
    private function appRadiusOBJ0changed ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppRadius0 ( int ( appRadiusOBJ0 . getCurValue ( ) ) ) ;
    }
    private function appRadiusOBJ1changed ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppRadius1 ( int ( appRadiusOBJ1 . getCurValue ( ) ) ) ;
    }
    private function appBackgroundBgColorOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundBgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appBackgroundBgColorOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundFgColorOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundFgColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + appBackgroundFgColorOBJ . getRGBColor ( ) ) ) ;
    }
    private function appBackgroundFillAlphaOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundFillAlpha ( appBackgroundFillAlphaOBJ . getCurValue ( ) ) ;
    }
    private function appBackgroundImageOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundImage ( application . getTextStock ( ) . getTextCodesBgImagePics ( ) [ appBackgroundImageOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function appBackgroundAlignOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundAlign ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) [ appBackgroundAlignOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function appBackgroundAlphaOBJchanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppBackgroundAlpha ( appBackgroundAlphaOBJ . getCurValue ( ) ) ;
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
    private function appFontBoldOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontBold ( appFontBoldOBJ . getUp ( ) ) ;
    }
    private function appFontItalicOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontItalic ( appFontItalicOBJ . getUp ( ) ) ;
    }
/*
** Sets the displaying style by the listpicker.
*/
    public function setDisplayingStyleByListpicker ( styleName : String ) : void
    {
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesDisplayingStyles ( ) . indexOf ( styleName ) ) ;
      }
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
** Sets the widgets orientation.
*/
    public function setWidgetsOrientation ( widgetsOrientation : String ) : void
    {
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( widgetsOrientation ) ) ;
      }
    }
/*
** Sets the predefined displaying styles.
*/
    private function setDisplayingStyle ( styleName : String ) : void
    {
      if ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) != null )
      {
        if ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] != null )
        {
          if ( appLineThicknessOBJ != null )
          {
            appLineThicknessOBJ . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appLineThickness" ] ) ;
          }
          if ( appMarginOBJ != null )
          {
            appMarginOBJ . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appMargin" ] ) ;
          }
          if ( appPaddingOBJ != null )
          {
            appPaddingOBJ . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appPadding" ] ) ;
          }
          if ( appRadiusOBJ0 != null )
          {
            appRadiusOBJ0 . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appRadius0" ] ) ;
          }
          if ( appRadiusOBJ1 != null )
          {
            appRadiusOBJ1 . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appRadius1" ] ) ;
          }
          if ( appBackgroundBgColorOBJ != null )
          {
            appBackgroundBgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundBgColor" ] ) ;
          }
          if ( appBackgroundFgColorOBJ != null )
          {
            appBackgroundFgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFgColor" ] ) ;
          }
          if ( appBackgroundFillAlphaOBJ != null )
          {
            appBackgroundFillAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundFillAlpha" ] ) ;
          }
          if ( appBackgroundImageOBJ != null )
          {
            appBackgroundImageOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImagePics ( ) . indexOf ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundImage" ] ) ) ;
          }
          if ( appBackgroundAlignOBJ != null )
          {
            appBackgroundAlignOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) . indexOf ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlign" ] ) ) ;
          }
          if ( appBackgroundAlphaOBJ != null )
          {
            appBackgroundAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundAlpha" ] ) ;
          }
          if ( appBackgroundLiveOBJ != null )
          {
            appBackgroundLiveOBJ . setUp ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundLive" ] ) ;
          }
          if ( appFontFaceOBJ != null )
          {
            appFontFaceOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontFaces ( ) . indexOf ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontFace" ] ) ) ;
          }
          if ( appFontSizeOBJ != null )
          {
            appFontSizeOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontSizes ( ) . indexOf ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontSize" ] ) ) ;
          }
          if ( appFontColorBrightOBJ != null )
          {
            appFontColorBrightOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorBright" ] ) ;
          }
          if ( appFontColorMidOBJ != null )
          {
            appFontColorMidOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorMid" ] ) ;
          }
          if ( appFontColorDarkOBJ != null )
          {
            appFontColorDarkOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontColorDark" ] ) ;
          }
          if ( appFontBoldOBJ != null )
          {
            appFontBoldOBJ . setUp ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontBold" ] ) ;
          }
          if ( appFontItalicOBJ != null )
          {
            appFontItalicOBJ . setUp ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontItalic" ] ) ;
          }
        }
      }
    }
/*
** Resizing the listpicker objects.
*/
    private function resizeListPickers ( ) : void
    {
      if ( langCodeOBJ != null )
      {
        langCodeOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( numOfWidgetcontainersOBJ != null )
      {
        numOfWidgetcontainersOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( currWidgetcontainerOBJ != null )
      {
        currWidgetcontainerOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( appBackgroundImageOBJ != null )
      {
        appBackgroundImageOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( appBackgroundAlignOBJ != null )
      {
        appBackgroundAlignOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( appFontFaceOBJ != null )
      {
        appFontFaceOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
      }
      if ( appFontSizeOBJ != null )
      {
        appFontSizeOBJ . setsw ( getsw ( ) * listPickerFAC ) ;
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
        resizeListPickers ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        resizeListPickers ( ) ;
      }
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
      appLineThicknessLAB = null ;
      appLineThicknessOBJ = null ;
      appMarginLAB = null ;
      appMarginOBJ = null ;
      appPaddingLAB = null ;
      appPaddingOBJ = null ;
      appRadiusLAB = null ;
      appRadiusOBJ0 = null ;
      appRadiusOBJ1 = null ;
      appBackgroundBgColorLAB = null ;
      appBackgroundBgColorOBJ = null ;
      appBackgroundFgColorLAB = null ;
      appBackgroundFgColorOBJ = null ;
      appBackgroundFillAlphaLAB = null ;
      appBackgroundFillAlphaOBJ = null ;
      appBackgroundImageLAB = null ;
      appBackgroundImageOBJ = null ;
      appBackgroundAlignLAB = null ;
      appBackgroundAlignOBJ = null ;
      appBackgroundAlphaLAB = null ;
      appBackgroundAlphaOBJ = null ;
      appBackgroundLiveOBJ = null ;
      appFontFaceLAB = null ;
      appFontFaceOBJ = null ;
      appFontSizeLAB = null ;
      appFontSizeOBJ = null ;
      appFontColorBrightOBJ = null ;
      appFontColorMidOBJ = null ;
      appFontColorDarkOBJ = null ;
      appFontColorsLAB = null ;
      appFontBoldOBJ = null ;
      appFontItalicOBJ = null ;
      applicationNameLAB = null ;
      applicationVersionLAB = null ;
      applicationReleaseDateLAB = null ;
    }
  }
}