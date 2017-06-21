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
** PropsApp.
** The properties of the application which will not dispatch any event after changing.
** No destroy method.
*/
package com . kisscodesystems . KissAs3Fw . prop
{
  import flash . filters . BlurFilter ;
  public class PropsApp
  {
// THE VALUES CAN BE REDEFINED RIGHT AFTER THE SUPER CALLING
// IN THE CONSTRUCTOR IN THE EXTENDING CLASS OF THE APPLICATION.
// PLEASE NOTE THAT THIS VALUE CHANGING WILL DISPATCH NO EVENTS
// The name of the application.
    protected var applicationName : String = "Application" ;
// The maximum blur of the glow filter.
    protected var maxBlur : int = 8 ;
// Uses embed foonts or not.
    protected var useEmbedFonts : Boolean = false ;
// The menu and the settings panel is enabled or disabled: here at the beginning!
    protected var panelMenuEnabled : Boolean = true ;
    protected var panelSettingsEnabled : Boolean = true ;
// The line thickness of other drawing.
    protected var drawOtherLineThickness : int = 2 ;
// The minimum marker alpha values.
    protected var baseListMarkMinAlpha1 : Number = 0.15 ;
    protected var baseListMarkMinAlpha2 : Number = 0.3 ;
// The factor of the filling alpha to mark the elements.
    protected var baseListMarkAlpha1Factor : Number = 1 / 6 ;
    protected var baseListMarkAlpha2Factor : Number = 1 / 3 ;
// The constants of the color object.
    protected var colorSquareLineColor : Number = 0x000000 ;
    protected var colorSquareLineAlphaMouseOut : Number = 0.2 ;
    protected var colorSquareLineAlphaMouseOver : Number = 1 ;
// The alpha of the disabled object.
    protected var disabledAlpha : Number = 0.5 ;
// The minimum sizes of this application.
    protected var appSizeMinWidth : int = 300 ;
    protected var appSizeMinHeight : int = 300 ;
// The height o fhte header and footeer by mid text type line numbers.
// 0 means no header or no footer.
    protected var headerHeightMidLines : int = 1 ;
    protected var footerHeightMidLines : int = 0 ;
// The weight of the background.
// Higher value results slower movement.
    protected var weightBackgroundPicture : int = 8 ;
// The weight of the content in the base scroll.
    protected var weightScrollContent : int = 8 ;
// This will be the margin of the scroll.
// Shows where the content is actually.
    protected var scrollMargin : int = 10 ;
// The maximum number of widgets in the first line/column (orientation horizontal/vertical).
    protected var widgetsMaxElementsInLineOrColumn : int = 3 ;
// The margin of the widgets.
    protected var widgetsMargin : int = 30 ;
// The minimum sizes of a widget.
    protected var widgetSizeMinWidth : int = 200 ;
    protected var widgetSizeMinHeight : int = 150 ;
// Enable or disable the resizing of the widgets.
    protected var widgetEnableManualResize : Boolean = true ;
// The margin of resizing the widget (the margin around the widget to grab to resize it).
    protected var widgetResizeMargin : int = 5 ;
// The font size from the stage is calculated by this value if appFontSize == 0.
    protected var fontSizeFactor : Number = 1 / 60 ;
// The size factors for the menu and settings panel.
    protected var panelSettingsWidthFactor : Number = 2 / 5 ;
    protected var panelSettingsHeightFactor : Number = 3 / 5 ;
    protected var panelAlertWidthFactor : Number = 1 / 3 ;
    protected var panelAlertHeighthFactor : Number = 1 / 4 ;
    protected var panelMenuWidthFactor : Number = 1 / 5 ;
    protected var panelMenuHeighthFactor : Number = 4 / 5 ;
// Properties to draw the base shapes.
    protected var lineAlpha : Number = 1 ;
    protected var lineColor2 : Number = 0xaaaaaa ;
    protected var lineColor1 : Number = 0x111111 ;
    protected var brightColor2 : Number = 0x222222 ;
    protected var pixelHinting : Boolean = true ;
    protected var gradientAlpha1 : Number = 0.4 ;
    protected var gradientAlpha2 : Number = 0.3 ;
    protected var gradientRatio1 : int = 0 ;
    protected var gradientRatio2 : int = 255 ;
    protected var lineRatio1 : int = 0 ;
    protected var lineRatio2 : int = 255 ;
    protected var focalPointRatio : Number = 0.7 ;
// The margin of the background.
// This is the half of the difference when
// the background image can move according to the mouse pointer.
    protected var liveBackgroundMargin : int = 50 ;
// A blur filter object when the foreground is set to visible.
    protected var blurFilterBackMiddle : BlurFilter = new BlurFilter ( 8 , 8 , 8 ) ;
// Blur filter to the color displayer shape of color picker.
    protected var blurFilterColorPickerColor : BlurFilter = new BlurFilter ( 5 , 1 , 1 ) ;
// The minimum size of the base objects.
    protected var baseMinw : int = 0 ;
    protected var baseMinh : int = 0 ;
// The minimum width of a single line text field.
    protected var textsMinSize : int = 50 ;
// Smartphone mode.
    protected var smartphoneMode : Boolean = false ;
// The maximum displayable elements in the lang setter.
    protected var langSetterMaxElements : int = 5 ;
/*
** Constructor.
*/
    public function PropsApp ( ) : void { }
/*
** Prepares the view of this application into smartphone friendly.
*/
    public function toSmartphone ( ) : void
    {
      smartphoneMode = true ;
      fontSizeFactor = 1 / 30 ;
      panelSettingsWidthFactor = 4 / 5 ;
      panelSettingsHeightFactor = 3 / 4 ;
      panelAlertWidthFactor = 2 / 3 ;
      panelAlertHeighthFactor = 1 / 4 ;
      panelMenuWidthFactor = 1 / 2 ;
      panelMenuHeighthFactor = 4 / 5 ;
      widgetsMaxElementsInLineOrColumn = 1 ;
      widgetsMargin = 0 ;
      widgetEnableManualResize = false ;
      widgetResizeMargin = 0 ;
    }
/*
** The getter functions of the properties can be overwritten in the constructor of extending class.
*/
    public function getApplicationName ( ) : String
    {
      return applicationName ;
    }
    public function getUseEmbedFonts ( ) : Boolean
    {
      return useEmbedFonts ;
    }
    public function getPanelMenuEnabled ( ) : Boolean
    {
      return panelMenuEnabled ;
    }
    public function getPanelSettingsEnabled ( ) : Boolean
    {
      return panelSettingsEnabled ;
    }
    public function getDrawOtherLineThickness ( ) : int
    {
      return drawOtherLineThickness ;
    }
    public function getBaseListMarkMinAlpha1 ( ) : Number
    {
      return baseListMarkMinAlpha1 ;
    }
    public function getBaseListMarkMinAlpha2 ( ) : Number
    {
      return baseListMarkMinAlpha2 ;
    }
    public function getBaseListMarkAlpha1Factor ( ) : Number
    {
      return baseListMarkAlpha1Factor ;
    }
    public function getBaseListMarkAlpha2Factor ( ) : Number
    {
      return baseListMarkAlpha2Factor ;
    }
    public function getColorSquareLineColor ( ) : Number
    {
      return colorSquareLineColor ;
    }
    public function getColorSquareLineAlphaMouseOut ( ) : Number
    {
      return colorSquareLineAlphaMouseOut ;
    }
    public function getColorSquareLineAlphaMouseOver ( ) : Number
    {
      return colorSquareLineAlphaMouseOver ;
    }
    public function getDisabledAlpha ( ) : Number
    {
      return disabledAlpha ;
    }
    public function getAppSizeMinWidth ( ) : int
    {
      return appSizeMinWidth ;
    }
    public function getAppSizeMinHeight ( ) : int
    {
      return appSizeMinHeight ;
    }
    public function getHeaderHeightMidLines ( ) : int
    {
      return headerHeightMidLines ;
    }
    public function getFooterHeightMidLines ( ) : int
    {
      return footerHeightMidLines ;
    }
    public function getWeightBackgroundPicture ( ) : int
    {
      return weightBackgroundPicture ;
    }
    public function getWeightScrollContent ( ) : int
    {
      return weightScrollContent ;
    }
    public function getScrollMargin ( ) : int
    {
      return scrollMargin ;
    }
    public function getWidgetsMaxElementsInLineOrColumn ( ) : int
    {
      return widgetsMaxElementsInLineOrColumn ;
    }
    public function getWidgetsMargin ( ) : int
    {
      return widgetsMargin ;
    }
    public function getWidgetSizeMinWidth ( ) : int
    {
      return widgetSizeMinWidth ;
    }
    public function getWidgetSizeMinHeight ( ) : int
    {
      return widgetSizeMinHeight ;
    }
    public function getWidgetEnableManualResize ( ) : Boolean
    {
      return widgetEnableManualResize ;
    }
    public function getWidgetResizeMargin ( ) : int
    {
      return widgetResizeMargin ;
    }
    public function getFontSizeFactor ( ) : Number
    {
      return fontSizeFactor ;
    }
    public function getPanelSettingsWidthFactor ( ) : Number
    {
      return panelSettingsWidthFactor ;
    }
    public function getPanelSettingsHeightFactor ( ) : Number
    {
      return panelSettingsHeightFactor ;
    }
    public function getPanelMenuWidthFactor ( ) : Number
    {
      return panelMenuWidthFactor ;
    }
    public function getPanelMenuHeighthFactor ( ) : Number
    {
      return panelMenuHeighthFactor ;
    }
    public function getPanelAlertWidthFactor ( ) : Number
    {
      return panelAlertWidthFactor ;
    }
    public function getPanelAlertHeighthFactor ( ) : Number
    {
      return panelAlertHeighthFactor ;
    }
    public function getLineAlpha ( ) : Number
    {
      return lineAlpha ;
    }
    public function getLineColor2 ( ) : Number
    {
      return lineColor2 ;
    }
    public function getLineColor1 ( ) : Number
    {
      return lineColor1 ;
    }
    public function getBrightColor2 ( ) : Number
    {
      return brightColor2 ;
    }
    public function getPixelHinting ( ) : Boolean
    {
      return pixelHinting ;
    }
    public function getGradientAlpha1 ( ) : Number
    {
      return gradientAlpha1 ;
    }
    public function getGradientAlpha2 ( ) : Number
    {
      return gradientAlpha2 ;
    }
    public function getGradientRatio1 ( ) : int
    {
      return gradientRatio1 ;
    }
    public function getGradientRatio2 ( ) : int
    {
      return gradientRatio2 ;
    }
    public function getLineRatio1 ( ) : int
    {
      return lineRatio1 ;
    }
    public function getLineRatio2 ( ) : int
    {
      return lineRatio2 ;
    }
    public function getFocalPointRatio ( ) : Number
    {
      return focalPointRatio ;
    }
    public function getLiveBackgroundMargin ( ) : int
    {
      return liveBackgroundMargin ;
    }
    public function getBlurFilterBackMiddle ( ) : BlurFilter
    {
      return blurFilterBackMiddle ;
    }
    public function getMaxBlur ( ) : int
    {
      return maxBlur ;
    }
    public function getBlurFilterColorPickerColor ( ) : BlurFilter
    {
      return blurFilterColorPickerColor ;
    }
    public function getBaseMinw ( ) : int
    {
      return baseMinw ;
    }
    public function getBaseMinh ( ) : int
    {
      return baseMinh ;
    }
    public function getTextsMinSize ( ) : int
    {
      return textsMinSize ;
    }
    public function getSmartphoneMode ( ) : Boolean
    {
      return smartphoneMode ;
    }
    public function getLangSetterMaxElements ( ) : int
    {
      return langSetterMaxElements ;
    }
  }
}