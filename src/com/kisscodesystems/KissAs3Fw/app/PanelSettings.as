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
** The panel of the settings stuff. Visible if the user clicks on the settings button.
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
  import com . kisscodesystems . KissAs3Fw . ui . Checkbox ;
  import com . kisscodesystems . KissAs3Fw . ui . ColorPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Potmet ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class PanelSettings extends BasePanel
  {
// The multiple content.
    private var contentMultiple : ContentMultiple = null ;
// The identifiers of the contents are:
    private var indexGeneral : int = - 1 ;
    private var indexLining : int = - 1 ;
    private var indexColoring : int = - 1 ;
    private var indexImaging : int = - 1 ;
    private var indexFonting : int = - 1 ;
// The list picker should get the width of the panel as its:
    private const listPickerFAC : Number = 0.5 ;
// The number of items to be visible in the opened list picker:
    private const listPickerCNT : int = 5 ;
// langCode
    private var langCodeLAB : TextLabel = null ;
    private var langCodeOBJ : LangSetter = null ;
// appWidgetsOrientation
    private var appWidgetsOrientationLAB : TextLabel = null ;
    private var appWidgetsOrientationOBJ : ListPicker = null ;
// PREDEFINED DISDPLAYING STYLES
    private var displayingStyleLAB : TextLabel = null ;
    private var displayingStyleOBJ : ListPicker = null ;
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
    private var appBackgroundLiveOBJ : Checkbox = null ;
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
    private var appFontBoldOBJ : Checkbox = null ;
// appFontItalic
    private var appFontItalicOBJ : Checkbox = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function PanelSettings ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Creating the elements.
      createElements ( ) ;
// Registering into these events.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , reposResizeContentMultiple ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , reposResizeContentMultiple ) ;
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
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . setEnabled ( getEnabled ( ) ) ;
      }
      if ( displayingStyleOBJ != null )
      {
        displayingStyleOBJ . setEnabled ( getEnabled ( ) ) ;
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
      contentMultiple = new ContentMultiple ( application ) ;
      addChild ( contentMultiple ) ;
      indexGeneral = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_GENERAL ) ;
      indexLining = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_LINING ) ;
      indexColoring = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_COLORING ) ;
      indexImaging = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_IMAGING ) ;
      indexFonting = contentMultiple . addContent ( application . getTexts ( ) . SETTINGS_PANEL_FONTING ) ;
      contentMultiple . setElementsFix ( indexGeneral , 1 ) ;
      contentMultiple . setElementsFix ( indexLining , 2 ) ;
      contentMultiple . setElementsFix ( indexColoring , 1 ) ;
      contentMultiple . setElementsFix ( indexImaging , 1 ) ;
      contentMultiple . setElementsFix ( indexFonting , 1 ) ;
      contentMultiple . setActiveIndex ( 0 ) ;
      setContentVisible ( false ) ;
// langCode
      langCodeOBJ = new LangSetter ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeOBJ , true , 0 ) ;
      langCodeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , langCodeLAB , false , 1 ) ;
      langCodeLAB . setTextCode ( application . getTexts ( ) . SETTING_LANGUAGE ) ;
// appWidgetsOrientation
      appWidgetsOrientationOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationOBJ , true , 2 ) ;
      appWidgetsOrientationOBJ . setNumOfElements ( listPickerCNT ) ;
      appWidgetsOrientationOBJ . setArrays ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) , application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) ) ;
      appWidgetsOrientationOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) . indexOf ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) ) ) ;
      appWidgetsOrientationOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appWidgetsOrientationOBJChanged ) ;
      appWidgetsOrientationLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , appWidgetsOrientationLAB , false , 3 ) ;
      appWidgetsOrientationLAB . setTextCode ( application . getTexts ( ) . SETTING_WIDGET_ORIENTATION ) ;
// PREDEFINED DISDPLAYING STYLES
      displayingStyleOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexGeneral , displayingStyleOBJ , true , 4 ) ;
      displayingStyleOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfDisplayingStylesOBJ ( ) ;
      displayingStyleOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , displayingStyleOBJChanged ) ;
      displayingStyleLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexGeneral , displayingStyleLAB , false , 5 ) ;
      displayingStyleLAB . setTextCode ( application . getTexts ( ) . SETTING_DISPLAYING_STYLE ) ;
// appLineThickness
      appLineThicknessOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessOBJ , true , 0 ) ;
      appLineThicknessOBJ . setMinMaxIncValues ( appLineThicknessMIN , appLineThicknessMAX , appLineThicknessINC ) ;
      appLineThicknessOBJ . setCurValue ( application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      appLineThicknessOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appLineThicknessOBJchanged ) ;
      appLineThicknessLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appLineThicknessLAB , false , 2 ) ;
      appLineThicknessLAB . setTextCode ( application . getTexts ( ) . SETTING_LINE_THICKNESS ) ;
// appMargin
      appMarginOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginOBJ , true , 3 ) ;
      appMarginOBJ . setMinMaxIncValues ( appMarginMIN , appMarginMAX , appMarginINC ) ;
      appMarginOBJ . setCurValue ( application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      appMarginOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appMarginOBJchanged ) ;
      appMarginLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appMarginLAB , false , 5 ) ;
      appMarginLAB . setTextCode ( application . getTexts ( ) . SETTING_MARGIN ) ;
// appPadding
      appPaddingOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingOBJ , true , 6 ) ;
      appPaddingOBJ . setMinMaxIncValues ( appPaddingMIN , appPaddingMAX , appPaddingINC ) ;
      appPaddingOBJ . setCurValue ( application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      appPaddingOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appPaddingOBJchanged ) ;
      appPaddingLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appPaddingLAB , false , 8 ) ;
      appPaddingLAB . setTextCode ( application . getTexts ( ) . SETTING_PADDING ) ;
// appRadius0, 1
      appRadiusOBJ0 = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusOBJ0 , true , 9 ) ;
      appRadiusOBJ0 . setMinMaxIncValues ( appRadiusMIN , appRadiusMAX , appRadiusINC ) ;
      appRadiusOBJ0 . setCurValue ( application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
      appRadiusOBJ0 . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appRadiusOBJ0changed ) ;
      appRadiusOBJ1 = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusOBJ1 , true , 10 ) ;
      appRadiusOBJ1 . setMinMaxIncValues ( appRadiusMIN , appRadiusMAX , appRadiusINC ) ;
      appRadiusOBJ1 . setCurValue ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
      appRadiusOBJ1 . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appRadiusOBJ1changed ) ;
      appRadiusLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexLining , appRadiusLAB , false , 11 ) ;
      appRadiusLAB . setTextCode ( application . getTexts ( ) . SETTING_RADIUS ) ;
// appBackgroundBgColor
      appBackgroundBgColorOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundBgColorOBJ , true , 0 ) ;
      appBackgroundBgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) . toString ( 16 ) ) ;
      appBackgroundBgColorOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundBgColorOBJChanged ) ;
      appBackgroundBgColorLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundBgColorLAB , false , 1 ) ;
      appBackgroundBgColorLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_BG_COLOR ) ;
// appBackgroundFgColor
      appBackgroundFgColorOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFgColorOBJ , true , 2 ) ;
      appBackgroundFgColorOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) . toString ( 16 ) ) ;
      appBackgroundFgColorOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundFgColorOBJChanged ) ;
      appBackgroundFgColorLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFgColorLAB , false , 3 ) ;
      appBackgroundFgColorLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_FG_COLOR ) ;
// appBackgroundFillAlpha
      appBackgroundFillAlphaOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFillAlphaOBJ , true , 4 ) ;
      appBackgroundFillAlphaOBJ . setMinMaxIncValues ( appBackgroundFillAlphaMIN , appBackgroundFillAlphaMAX , appBackgroundFillAlphaINC ) ;
      appBackgroundFillAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) ) ;
      appBackgroundFillAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundFillAlphaOBJchanged ) ;
      appBackgroundFillAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexColoring , appBackgroundFillAlphaLAB , false , 5 ) ;
      appBackgroundFillAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_FILL_ALPHA ) ;
// appBackgroundImage
      appBackgroundImageOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundImageOBJ , true , 0 ) ;
      appBackgroundImageOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfBackgroundImageOBJ ( ) ;
      appBackgroundImageOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundImageOBJChanged ) ;
      appBackgroundImageLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundImageLAB , false , 1 ) ;
      appBackgroundImageLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_IMAGE ) ;
// appBackgroundAlign
      appBackgroundAlignOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignOBJ , true , 2 ) ;
      appBackgroundAlignOBJ . setNumOfElements ( listPickerCNT ) ;
      appBackgroundAlignOBJ . setArrays ( application . getTextStock ( ) . getTextsBgImageAligns ( ) , application . getTextStock ( ) . getTextCodesBgImageAligns ( ) ) ;
      appBackgroundAlignOBJ . setSelectedIndex ( application . getTextStock ( ) . getTextCodesBgImageAligns ( ) . indexOf ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) ) ) ;
      appBackgroundAlignOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlignOBJChanged ) ;
      appBackgroundAlignLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlignLAB , false , 3 ) ;
      appBackgroundAlignLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALIGN ) ;
// appBackgroundAlpha
      appBackgroundAlphaOBJ = new Potmet ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaOBJ , true , 4 ) ;
      appBackgroundAlphaOBJ . setMinMaxIncValues ( appBackgroundAlphaMIN , appBackgroundAlphaMAX , appBackgroundAlphaINC ) ;
      appBackgroundAlphaOBJ . setCurValue ( application . getPropsDyn ( ) . getAppBackgroundAlpha ( ) ) ;
      appBackgroundAlphaOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundAlphaOBJchanged ) ;
      appBackgroundAlphaLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundAlphaLAB , false , 5 ) ;
      appBackgroundAlphaLAB . setTextCode ( application . getTexts ( ) . SETTING_BACKGROUND_ALPHA ) ;
// appBackgroundLive
      appBackgroundLiveOBJ = new Checkbox ( application ) ;
      contentMultiple . addToContent ( indexImaging , appBackgroundLiveOBJ , true , 6 ) ;
      appBackgroundLiveOBJ . setTextCodes ( application . getTexts ( ) . SETTING_BACKGROUND_LIVE , application . getTexts ( ) . SETTING_BACKGROUND_FIXED ) ;
      appBackgroundLiveOBJ . setChecked ( application . getPropsDyn ( ) . getAppBackgroundLive ( ) ) ;
      appBackgroundLiveOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appBackgroundLiveOBJChanged ) ;
// appFontFace
      appFontFaceOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceOBJ , true , 0 ) ;
      appFontFaceOBJ . setNumOfElements ( listPickerCNT ) ;
      setElementsOfAppFontFacesOBJ ( ) ;
      appFontFaceOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontFaceOBJChanged ) ;
      appFontFaceLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontFaceLAB , false , 1 ) ;
      appFontFaceLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_FACE ) ;
// appFontSize
      appFontSizeOBJ = new ListPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeOBJ , true , 2 ) ;
      appFontSizeOBJ . setNumOfElements ( listPickerCNT ) ;
      appFontSizeOBJ . setArrays ( application . getPropsDyn ( ) . getFontSizes ( ) , application . getPropsDyn ( ) . getFontSizes ( ) ) ;
      appFontSizeOBJ . setSelectedIndex ( application . getPropsDyn ( ) . getFontSizes ( ) . indexOf ( "" + application . getPropsDyn ( ) . getAppFontSize ( ) ) ) ;
      appFontSizeOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontSizeOBJChanged ) ;
      appFontSizeLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontSizeLAB , false , 3 ) ;
      appFontSizeLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_SIZE ) ;
// appFontColorBright
      appFontColorBrightOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorBrightOBJ , true , 4 ) ;
      appFontColorBrightOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorBright ( ) . toString ( 16 ) ) ;
      appFontColorBrightOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorBrightOBJChanged ) ;
      appFontColorMidOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorMidOBJ , true , 4 ) ;
      appFontColorMidOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorMid ( ) . toString ( 16 ) ) ;
      appFontColorMidOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorMidOBJChanged ) ;
      appFontColorDarkOBJ = new ColorPicker ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorDarkOBJ , true , 4 ) ;
      appFontColorDarkOBJ . setRGBColor ( application . getPropsDyn ( ) . getAppFontColorDark ( ) . toString ( 16 ) ) ;
      appFontColorDarkOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontColorDarkOBJChanged ) ;
      appFontColorsLAB = new TextLabel ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontColorsLAB , false , 5 ) ;
      appFontColorsLAB . setTextCode ( application . getTexts ( ) . SETTING_FONT_COLORS ) ;
// appFontBold
      appFontBoldOBJ = new Checkbox ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontBoldOBJ , true , 6 ) ;
      appFontBoldOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_BOLD , application . getTexts ( ) . SETTING_FONT_BOLD ) ;
      appFontBoldOBJ . setChecked ( application . getPropsDyn ( ) . getAppFontBold ( ) ) ;
      appFontBoldOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontBoldOBJChanged ) ;
// appFontItalic
      appFontItalicOBJ = new Checkbox ( application ) ;
      contentMultiple . addToContent ( indexFonting , appFontItalicOBJ , true , 8 ) ;
      appFontItalicOBJ . setTextCodes ( application . getTexts ( ) . SETTING_FONT_ITALIC , application . getTexts ( ) . SETTING_FONT_ITALIC ) ;
      appFontItalicOBJ . setChecked ( application . getPropsDyn ( ) . getAppFontItalic ( ) ) ;
      appFontItalicOBJ . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , appFontItalicOBJChanged ) ;
    }
/*
** To smartphone mode.
*/
    public function toSmartphone ( ) : void
    {
      if ( appWidgetsOrientationOBJ != null )
      {
        appWidgetsOrientationOBJ . visible = false ;
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
** The listener functions to set the properties of the application.
*/
    private function appWidgetsOrientationOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppWidgetsOrientation ( application . getTextStock ( ) . getTextCodesWidgetsOrientations ( ) [ appWidgetsOrientationOBJ . getSelectedIndex ( ) ] ) ;
    }
    private function displayingStyleOBJChanged ( e : Event ) : void
    {
      setDisplayingStyle ( application . getTextStock ( ) . getTextCodesDisplayingStyles ( ) [ displayingStyleOBJ . getSelectedIndex ( ) ] ) ;
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
      application . getPropsDyn ( ) . setAppBackgroundLive ( appBackgroundLiveOBJ . getChecked ( ) ) ;
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
      application . getPropsDyn ( ) . setAppFontBold ( appFontBoldOBJ . getChecked ( ) ) ;
    }
    private function appFontItalicOBJChanged ( e : Event ) : void
    {
      application . getPropsDyn ( ) . setAppFontItalic ( appFontItalicOBJ . getChecked ( ) ) ;
    }
/*
** Override the mouse close method!
** the pixel stealing has to be not in progress.
*/
    override protected function hasToCloseByMouse ( e : MouseEvent ) : void
    {
      if ( appBackgroundBgColorOBJ != null && appBackgroundFgColorOBJ != null && appFontColorBrightOBJ != null && appFontColorMidOBJ != null && appFontColorDarkOBJ != null )
      {
        if ( ! mouseIsOnTheContentSingle ( ) && ! appBackgroundBgColorOBJ . isPixelStealingInProgress ( ) && ! appBackgroundFgColorOBJ . isPixelStealingInProgress ( ) && ! appFontColorBrightOBJ . isPixelStealingInProgress ( ) && ! appFontColorMidOBJ . isPixelStealingInProgress ( ) && ! appFontColorDarkOBJ . isPixelStealingInProgress ( ) )
        {
          close ( ) ;
        }
      }
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
            appBackgroundLiveOBJ . setChecked ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appBackgroundLive" ] ) ;
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
            appFontBoldOBJ . setChecked ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontBold" ] ) ;
          }
          if ( appFontItalicOBJ != null )
          {
            appFontItalicOBJ . setChecked ( application . getPropsDyn ( ) . getAppDisplayingStyles ( ) [ styleName ] [ "appFontItalic" ] ) ;
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
        contentMultiple . setcx ( application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        contentMultiple . setsw ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        resizeListPickers ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        contentMultiple . setcy ( application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        contentMultiple . setsh ( getsh ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        reposResizeContentMultiple ( null ) ;
        resizeListPickers ( ) ;
      }
    }
/*
** The automatic reposition and resize of the multiple content.
*/
    private function reposResizeContentMultiple ( e : Event ) : void
    {
      if ( application != null )
      {
        if ( contentMultiple != null )
        {
          contentMultiple . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
          contentMultiple . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) , getsh ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        }
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
      contentMultiple = null ;
      indexGeneral = 0 ;
      indexLining = 0 ;
      indexColoring = 0 ;
      indexImaging = 0 ;
      indexFonting = 0 ;
      langCodeLAB = null ;
      langCodeOBJ = null ;
      appWidgetsOrientationLAB = null ;
      appWidgetsOrientationOBJ = null ;
      displayingStyleLAB = null ;
      displayingStyleOBJ = null ;
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
    }
  }
}