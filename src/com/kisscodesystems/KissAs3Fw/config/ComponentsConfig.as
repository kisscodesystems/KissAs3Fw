/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 *
 * DESCRIPTION:
 * ComponentsConfig.
 * The properties of the components which cannot be changed while the application is running.
 *
 * MAIN FEATURES:
 * - every value has a default coded into this class
 * - the defaults can be overwritten from the embedded configuration xml,
 *   resource/config/KissAs3FwComponentsConfig.xml
 * - an application brings its own values in a small class extending this one:
 *   that class embeds its own xml and overrides readValuesFromConfigXml to call
 *   the super and then applyConfigXml with it, so the application values are
 *   applied on top of the framework ones and stay in an xml, not in the code
 * - the xml only has to hold the values it wants to change
 * - the blur filters and the text drop shadow arrays are coded into this class only
 * - a class extending this one is still possible, it has to assign the protected
 *   variables after the super call, because the xml is applied by that super call
 */
package com.kisscodesystems.KissAs3Fw.config
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseConfigValues;
  import flash.filters.BlurFilter;
  import flash.filters.DropShadowFilter;
  import flash.system.System;
  import flash.utils.ByteArray;
  public class ComponentsConfig
  {
    [Embed(source = "../resource/config/KissAs3FwComponentsConfig.xml", mimeType = "application/octet-stream")]
    private var EmbeddedConfig:Class;
    private var embeddedConfigByteArray:ByteArray = new EmbeddedConfig() as ByteArray;
    protected var application:Application = null;
    protected var timeDisplayingTimerDelay:int = 200;
    protected var blurFilterBackMiddle:BlurFilter = new BlurFilter(8, 8, 8);
    protected var blurFilterColorPickerColor:BlurFilter = new BlurFilter(5, 1, 1);
    protected var textDropShadowArrayDark:Array = [new DropShadowFilter(1, 45, 0x000000, 1, 1, 1, 1, 2)];
    protected var textDropShadowArrayBright:Array = [new DropShadowFilter(1, 45, 0xffffff, 1, 1, 1, 1, 2)];
    protected var panelMenuEnabled:Boolean = true;
    protected var panelSettingsEnabled:Boolean = true;
    protected var watchEnabled:Boolean = true;
    protected var panelSettingsEnableDesktops:Boolean = true;
    protected var panelSettingsEnableOrientation:Boolean = true;
    protected var panelSettingsEnableWidgetMode:Boolean = true;
    protected var panelSettingsEnableSound:Boolean = true;
    protected var panelSettingsEnableAppearance:Boolean = true;
    protected var panelSettingsEnableLining:Boolean = true;
    protected var panelSettingsEnableColoring:Boolean = true;
    protected var panelSettingsEnableImaging:Boolean = true;
    protected var panelSettingsEnableFonting:Boolean = true;
    protected var panelSettingsEnableDefaultAppearance:Boolean = true;
    protected var drawOtherLineThickness:int = 2;
    protected var baseListMarkMinAlpha1:Number = 0.15;
    protected var baseListMarkMinAlpha2:Number = 0.3;
    protected var baseListMarkAlpha1Factor:Number = 1 / 6;
    protected var baseListMarkAlpha2Factor:Number = 1 / 3;
    protected var colorSquareLineColor:Number = 0x000000;
    protected var colorSquareLineAlphaMouseOut:Number = 0.2;
    protected var colorSquareLineAlphaMouseOver:Number = 1;
    protected var colorToCalcComplementer:int = 16777215;
    protected var colorDrawedColorArrayDark:Number = 0x000000;
    protected var colorDrawedColorArrayBright:Number = 0xffffff;
    protected var colorDrawedAlphaArray:Array = [1, 1, 1];
    protected var colorDrawedRatioArray:Array = [5, 126, 250];
    protected var widgetSizeFromFontSizeFactor:Number = 0.8;
    protected var disabledAlpha:Number = 0.5;
    protected var appSizeMinWidth:int = 300;
    protected var appSizeMinHeight:int = 300;
    protected var scrollSizeMinWidth:int = 80;
    protected var scrollSizeMinHeight:int = 60;
    protected var weightBackgroundPicture:int = 9;
    protected var weightScrollContent:int = 9;
    protected var widgetsElementsFix:int = 3;
    protected var widgetsMargin:int = 42;
    protected var widgetSizeStandardWidth:int = 400;
    protected var widgetSizeStandardHeight:int = 300;
    protected var widgetSizeMinWidth:int = 200;
    protected var widgetSizeMinHeight:int = 150;
    protected var widgetEnableManualHide:Boolean = true;
    protected var widgetEnableManualResize:Boolean = true;
    protected var widgetEnableManualClose:Boolean = true;
    protected var resizeMargin:int = 12;
    protected var fontSizeFactorMobile:Number = 1 / 19;
    protected var fontSizeFactorDesktop:Number = 1 / 69;
    protected var isDesktop:Boolean = true;
    protected var lineAlpha:Number = 1;
    protected var lineColor2:Number = 0xaaaaaa;
    protected var lineColor1:Number = 0x111111;
    protected var brightColor2:Number = 0x222222;
    protected var pixelHinting:Boolean = true;
    protected var gradientAlpha1:Number = 0.4;
    protected var gradientAlpha2:Number = 0.3;
    protected var gradientRatio1:int = 0;
    protected var gradientRatio2:int = 255;
    protected var linearRatio1:int = 85;
    protected var linearRatio2:int = 255;
    protected var lineRatio1:int = 0;
    protected var lineRatio2:int = 255;
    protected var focalPointRatio:Number = 0.7;
    protected var liveBackgroundMargin:int = 60;
    protected var backgroundImageMaxSize:int = 2560;
    protected var scrollMargin:int = 10;
    protected var maxBlur:int = 10;
    protected var baseMinw:int = 0;
    protected var baseMinh:int = 0;
    protected var textsMinSize:int = 50;
    protected var langSetterMaxElements:int = 5;
    protected var wheelDeltaPixels:int = 30;
    protected var buttonDrawMovePrevNextScale:Number = 0.7;
    protected var maxNumOfWidgetcontainers:int = 5;
    protected var minFontSize:int = 12;
    protected var maxFontSize:int = 72;
    protected var regexpStrFilename:String = "^[a-zA-Z0-9_\\-]{1,200}\\.[a-zA-Z0-9]{3,4}$";
    protected var fileBrowseMaxElements:int = 7;
    protected var autoCompleteMaxElements:int = 6;
    protected var datePanelAlphaMouseOver:Number = 0.3;
    protected var datePanelAlphaMouseDown:Number = 0.6;
    protected var datePanelDateFormat:String = "yyyy-MM-dd";
    protected var datePanelDateTimeFormat:String = "yyyy-MM-dd HH:mm";
    protected var datePanelDateTimeSecFormat:String = "yyyy-MM-dd HH:mm:ss";
    protected var inputTimerDelay:int = 666;
    protected var emptyHtmlParagraph:String = "<p>&nbsp;</p>";
    protected var boardBackgroundColor:String = "DDDDDD";
    protected var boardLineColor:String = "111111";
    protected var boardPadding:int = 6;
    protected var boardLineThickness:int = 2;
    protected var boardLineMinThickness:int = 1;
    protected var boardLineMaxThickness:int = 10;
    protected var boardLineIncThickness:int = 1;
    protected var boardRubberThicknessFactor:int = 5;
    protected var boardChangedTimerDelay:int = 1111;
    protected var raterNumOfStars:int = 5;
    protected var cameraWidthMin:int = 480;
    protected var cameraWidthMax:int = 1280;
    protected var cameraWidthInc:int = 160;
    protected var cameraWidthIni:int = 640;
    protected var cameraFpsMin:int = 10;
    protected var cameraFpsMax:int = 42;
    protected var cameraFpsIni:int = 24;
    protected var cameraQualityMin:int = 42;
    protected var cameraQualityMax:int = 100;
    protected var cameraQualityIni:int = 100;
    protected var cameraBlurMin:int = 0;
    protected var cameraBlurMax:int = 16;
    protected var cameraBlurInc:int = 1;
    protected var cameraChannelMin:Number = 0;
    protected var cameraChannelMax:Number = 2;
    protected var cameraChannelAlphaMax:Number = 1;
    protected var cameraChannelIni:Number = 1;
    protected var cameraChannelInc:Number = 0.01;
    protected var cameraChannelPrecision:int = 2;
    protected var cameraDevicesMaxElements:int = 5;
    protected var cameraPictureNamePrefix:String = "Cam";
    protected var cameraPictureNameExtension:String = ".png";
    protected var cameraTakePictureTimerDelay:int = 5000;
    protected var cameraSoundVolumeMin:int = 0;
    protected var cameraSoundVolumeMax:int = 100;
    protected var cameraSoundVolumeInc:int = 1;
    protected var cameraSoundVolumeIni:int = 50;
    protected var cameraSoundLevelTimerDelay:int = 100;
    protected var videoPlayerBufferTime:Number = 3;
    protected var videoPlayerTitleTimerDelay:int = 5000;
    protected var videoPlayerChapterListAlpha:Number = 0.85;
    protected var videoPlayerSoundVolume:int = 85;
    protected var soundPlayerSoundVolume:int = 85;
    protected var reactMaxNumOfEmojis:int = 10;
    protected var reactEmojiAlphaMouseOut:Number = 0.7;
    protected var reactPickerNumOfColumns:int = 10;
    protected var reactPickerNumOfRows:int = 6;
    protected var reactPickerEmojiSizeFactor:Number = 2;
    protected var reactPickerMaxNumOfHits:int = 50;
    protected var watchTimerDelay:int = 1000;
    protected var activeServersTimerDelay:int = 180000;
    protected var shortTextLimit:int = 142;
    protected var shortTextEnding:String = "...";
    protected var minTextInputAlpha:Number = 0.15;
    protected var clickGap:int = 5;
    protected var tracerBgalpha:Number = 0.5;
    protected var tracerAttrDelim:String = "&";
    protected var tracerAttrMargin:String = "   | ";
    protected var tracerFilterMinChars:int = 0;
    protected var tracerFilterMaxChars:int = 100;
    protected var tracerFilterRestrict:String = "a-zA-Z0-9áíűőüöúóéÁÍŰŐÜÖÚÓÉ";
    protected var tracerPauseLabelYes:String = "Logging";
    protected var tracerPauseLabelNo:String = "Paused";
    protected var tracerPauseIconYes:String = "playing";
    protected var tracerPauseIconNo:String = "paused";
    protected var tracerClearLabel:String = "Clear";
    protected var tracerClearIcon:String = "cancel";
    protected var tracerTracerLabel:String = "Tracer";
    protected var tracerTraceMaxLength:int = 1000;
    protected var tracerMaxLines:int = 2000;
    protected var tracerTracerIcon:String = "settings";
    protected var tracerLineNumDelim:String = ": ";
    protected var tracerNetworkAttrDelim:String = ">";
    protected var colorRgbInputZeros:String = "000000";
    protected var colorHexToNumberString:String = "0x";
    protected var colorMaxCharsRgbInput:int = 6;
    protected var textEnabledCharsHex:String = "0-9a-fA-F";
    protected var textBrightDarkChangeBound:int = 4 * 16;
    protected var textFieldMaxKeys:int = 99;
    /**
     * Constructs the components config and applies the embedded configuration xml onto it.
     * @param applicationRef the main application reference
     */
    public function ComponentsConfig(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " ComponentsConfig> called.", 1);
      application.trace("<" + this + " ComponentsConfig> applicationRef: " + applicationRef, 0);
      readValuesFromConfigXml();
      application.trace("<" + this + " ComponentsConfig> constructed.", 1);
    }
    /**
     * Applies the embedded framework configuration xml onto the default values.
     */
    protected function readValuesFromConfigXml():void
    {
      application.trace("<" + this + " ComponentsConfig readValuesFromConfigXml> called.", 1);
      applyConfigXml(embeddedConfigByteArray.toString());
      embeddedConfigByteArray.clear();
      embeddedConfigByteArray = null;
    }
    /**
     * Overwrites the current values with the ones found in the given configuration xml.
     * A class extending this one applies its own embedded xml on top of the framework
     * one by overriding readValuesFromConfigXml, calling the super and then this.
     * @param configXmlString the content of a configuration xml file
     */
    protected function applyConfigXml(configXmlString:String):void
    {
      application.trace("<" + this + " ComponentsConfig applyConfigXml> called.", 1);
      application.trace("<" + this + " ComponentsConfig applyConfigXml> configXmlString: " + configXmlString, 0);
      const values:BaseConfigValues = new BaseConfigValues(application, configXmlString);
      timeDisplayingTimerDelay = values.getInt("timeDisplayingTimerDelay", timeDisplayingTimerDelay);
      panelMenuEnabled = values.getBoolean("panelMenuEnabled", panelMenuEnabled);
      panelSettingsEnabled = values.getBoolean("panelSettingsEnabled", panelSettingsEnabled);
      watchEnabled = values.getBoolean("watchEnabled", watchEnabled);
      panelSettingsEnableDesktops = values.getBoolean("panelSettingsEnableDesktops", panelSettingsEnableDesktops);
      panelSettingsEnableOrientation = values.getBoolean("panelSettingsEnableOrientation", panelSettingsEnableOrientation);
      panelSettingsEnableWidgetMode = values.getBoolean("panelSettingsEnableWidgetMode", panelSettingsEnableWidgetMode);
      panelSettingsEnableSound = values.getBoolean("panelSettingsEnableSound", panelSettingsEnableSound);
      panelSettingsEnableAppearance = values.getBoolean("panelSettingsEnableAppearance", panelSettingsEnableAppearance);
      panelSettingsEnableLining = values.getBoolean("panelSettingsEnableLining", panelSettingsEnableLining);
      panelSettingsEnableColoring = values.getBoolean("panelSettingsEnableColoring", panelSettingsEnableColoring);
      panelSettingsEnableImaging = values.getBoolean("panelSettingsEnableImaging", panelSettingsEnableImaging);
      panelSettingsEnableFonting = values.getBoolean("panelSettingsEnableFonting", panelSettingsEnableFonting);
      panelSettingsEnableDefaultAppearance = values.getBoolean("panelSettingsEnableDefaultAppearance", panelSettingsEnableDefaultAppearance);
      drawOtherLineThickness = values.getInt("drawOtherLineThickness", drawOtherLineThickness);
      baseListMarkMinAlpha1 = values.getNumber("baseListMarkMinAlpha1", baseListMarkMinAlpha1);
      baseListMarkMinAlpha2 = values.getNumber("baseListMarkMinAlpha2", baseListMarkMinAlpha2);
      baseListMarkAlpha1Factor = values.getNumber("baseListMarkAlpha1Factor", baseListMarkAlpha1Factor);
      baseListMarkAlpha2Factor = values.getNumber("baseListMarkAlpha2Factor", baseListMarkAlpha2Factor);
      colorSquareLineColor = values.getColor("colorSquareLineColor", colorSquareLineColor);
      colorSquareLineAlphaMouseOut = values.getNumber("colorSquareLineAlphaMouseOut", colorSquareLineAlphaMouseOut);
      colorSquareLineAlphaMouseOver = values.getNumber("colorSquareLineAlphaMouseOver", colorSquareLineAlphaMouseOver);
      colorToCalcComplementer = values.getInt("colorToCalcComplementer", colorToCalcComplementer);
      colorDrawedColorArrayDark = values.getColor("colorDrawedColorArrayDark", colorDrawedColorArrayDark);
      colorDrawedColorArrayBright = values.getColor("colorDrawedColorArrayBright", colorDrawedColorArrayBright);
      widgetSizeFromFontSizeFactor = values.getNumber("widgetSizeFromFontSizeFactor", widgetSizeFromFontSizeFactor);
      disabledAlpha = values.getNumber("disabledAlpha", disabledAlpha);
      appSizeMinWidth = values.getInt("appSizeMinWidth", appSizeMinWidth);
      appSizeMinHeight = values.getInt("appSizeMinHeight", appSizeMinHeight);
      scrollSizeMinWidth = values.getInt("scrollSizeMinWidth", scrollSizeMinWidth);
      scrollSizeMinHeight = values.getInt("scrollSizeMinHeight", scrollSizeMinHeight);
      weightBackgroundPicture = values.getInt("weightBackgroundPicture", weightBackgroundPicture);
      weightScrollContent = values.getInt("weightScrollContent", weightScrollContent);
      widgetsElementsFix = values.getInt("widgetsElementsFix", widgetsElementsFix);
      widgetsMargin = values.getInt("widgetsMargin", widgetsMargin);
      widgetSizeStandardWidth = values.getInt("widgetSizeStandardWidth", widgetSizeStandardWidth);
      widgetSizeStandardHeight = values.getInt("widgetSizeStandardHeight", widgetSizeStandardHeight);
      widgetSizeMinWidth = values.getInt("widgetSizeMinWidth", widgetSizeMinWidth);
      widgetSizeMinHeight = values.getInt("widgetSizeMinHeight", widgetSizeMinHeight);
      widgetEnableManualHide = values.getBoolean("widgetEnableManualHide", widgetEnableManualHide);
      widgetEnableManualResize = values.getBoolean("widgetEnableManualResize", widgetEnableManualResize);
      widgetEnableManualClose = values.getBoolean("widgetEnableManualClose", widgetEnableManualClose);
      resizeMargin = values.getInt("resizeMargin", resizeMargin);
      fontSizeFactorMobile = values.getNumber("fontSizeFactorMobile", fontSizeFactorMobile);
      fontSizeFactorDesktop = values.getNumber("fontSizeFactorDesktop", fontSizeFactorDesktop);
      isDesktop = values.getBoolean("isDesktop", isDesktop);
      lineAlpha = values.getNumber("lineAlpha", lineAlpha);
      lineColor2 = values.getColor("lineColor2", lineColor2);
      lineColor1 = values.getColor("lineColor1", lineColor1);
      brightColor2 = values.getColor("brightColor2", brightColor2);
      pixelHinting = values.getBoolean("pixelHinting", pixelHinting);
      gradientAlpha1 = values.getNumber("gradientAlpha1", gradientAlpha1);
      gradientAlpha2 = values.getNumber("gradientAlpha2", gradientAlpha2);
      gradientRatio1 = values.getInt("gradientRatio1", gradientRatio1);
      gradientRatio2 = values.getInt("gradientRatio2", gradientRatio2);
      linearRatio1 = values.getInt("linearRatio1", linearRatio1);
      linearRatio2 = values.getInt("linearRatio2", linearRatio2);
      lineRatio1 = values.getInt("lineRatio1", lineRatio1);
      lineRatio2 = values.getInt("lineRatio2", lineRatio2);
      focalPointRatio = values.getNumber("focalPointRatio", focalPointRatio);
      liveBackgroundMargin = values.getInt("liveBackgroundMargin", liveBackgroundMargin);
      backgroundImageMaxSize = values.getInt("backgroundImageMaxSize", backgroundImageMaxSize);
      scrollMargin = values.getInt("scrollMargin", scrollMargin);
      maxBlur = values.getInt("maxBlur", maxBlur);
      baseMinw = values.getInt("baseMinw", baseMinw);
      baseMinh = values.getInt("baseMinh", baseMinh);
      textsMinSize = values.getInt("textsMinSize", textsMinSize);
      langSetterMaxElements = values.getInt("langSetterMaxElements", langSetterMaxElements);
      wheelDeltaPixels = values.getInt("wheelDeltaPixels", wheelDeltaPixels);
      buttonDrawMovePrevNextScale = values.getNumber("buttonDrawMovePrevNextScale", buttonDrawMovePrevNextScale);
      maxNumOfWidgetcontainers = values.getInt("maxNumOfWidgetcontainers", maxNumOfWidgetcontainers);
      minFontSize = values.getInt("minFontSize", minFontSize);
      maxFontSize = values.getInt("maxFontSize", maxFontSize);
      regexpStrFilename = values.getString("regexpStrFilename", regexpStrFilename);
      fileBrowseMaxElements = values.getInt("fileBrowseMaxElements", fileBrowseMaxElements);
      autoCompleteMaxElements = values.getInt("autoCompleteMaxElements", autoCompleteMaxElements);
      datePanelAlphaMouseOver = values.getNumber("datePanelAlphaMouseOver", datePanelAlphaMouseOver);
      datePanelAlphaMouseDown = values.getNumber("datePanelAlphaMouseDown", datePanelAlphaMouseDown);
      datePanelDateFormat = values.getString("datePanelDateFormat", datePanelDateFormat);
      datePanelDateTimeFormat = values.getString("datePanelDateTimeFormat", datePanelDateTimeFormat);
      datePanelDateTimeSecFormat = values.getString("datePanelDateTimeSecFormat", datePanelDateTimeSecFormat);
      inputTimerDelay = values.getInt("inputTimerDelay", inputTimerDelay);
      emptyHtmlParagraph = values.getString("emptyHtmlParagraph", emptyHtmlParagraph);
      boardBackgroundColor = values.getString("boardBackgroundColor", boardBackgroundColor);
      boardLineColor = values.getString("boardLineColor", boardLineColor);
      boardPadding = values.getInt("boardPadding", boardPadding);
      boardLineThickness = values.getInt("boardLineThickness", boardLineThickness);
      boardLineMinThickness = values.getInt("boardLineMinThickness", boardLineMinThickness);
      boardLineMaxThickness = values.getInt("boardLineMaxThickness", boardLineMaxThickness);
      boardLineIncThickness = values.getInt("boardLineIncThickness", boardLineIncThickness);
      boardRubberThicknessFactor = values.getInt("boardRubberThicknessFactor", boardRubberThicknessFactor);
      boardChangedTimerDelay = values.getInt("boardChangedTimerDelay", boardChangedTimerDelay);
      raterNumOfStars = values.getInt("raterNumOfStars", raterNumOfStars);
      cameraWidthMin = values.getInt("cameraWidthMin", cameraWidthMin);
      cameraWidthMax = values.getInt("cameraWidthMax", cameraWidthMax);
      cameraWidthInc = values.getInt("cameraWidthInc", cameraWidthInc);
      cameraWidthIni = values.getInt("cameraWidthIni", cameraWidthIni);
      cameraFpsMin = values.getInt("cameraFpsMin", cameraFpsMin);
      cameraFpsMax = values.getInt("cameraFpsMax", cameraFpsMax);
      cameraFpsIni = values.getInt("cameraFpsIni", cameraFpsIni);
      cameraQualityMin = values.getInt("cameraQualityMin", cameraQualityMin);
      cameraQualityMax = values.getInt("cameraQualityMax", cameraQualityMax);
      cameraQualityIni = values.getInt("cameraQualityIni", cameraQualityIni);
      cameraBlurMin = values.getInt("cameraBlurMin", cameraBlurMin);
      cameraBlurMax = values.getInt("cameraBlurMax", cameraBlurMax);
      cameraBlurInc = values.getInt("cameraBlurInc", cameraBlurInc);
      cameraChannelMin = values.getNumber("cameraChannelMin", cameraChannelMin);
      cameraChannelMax = values.getNumber("cameraChannelMax", cameraChannelMax);
      cameraChannelAlphaMax = values.getNumber("cameraChannelAlphaMax", cameraChannelAlphaMax);
      cameraChannelIni = values.getNumber("cameraChannelIni", cameraChannelIni);
      cameraChannelInc = values.getNumber("cameraChannelInc", cameraChannelInc);
      cameraChannelPrecision = values.getInt("cameraChannelPrecision", cameraChannelPrecision);
      cameraDevicesMaxElements = values.getInt("cameraDevicesMaxElements", cameraDevicesMaxElements);
      cameraPictureNamePrefix = values.getString("cameraPictureNamePrefix", cameraPictureNamePrefix);
      cameraPictureNameExtension = values.getString("cameraPictureNameExtension", cameraPictureNameExtension);
      cameraTakePictureTimerDelay = values.getInt("cameraTakePictureTimerDelay", cameraTakePictureTimerDelay);
      cameraSoundVolumeMin = values.getInt("cameraSoundVolumeMin", cameraSoundVolumeMin);
      cameraSoundVolumeMax = values.getInt("cameraSoundVolumeMax", cameraSoundVolumeMax);
      cameraSoundVolumeInc = values.getInt("cameraSoundVolumeInc", cameraSoundVolumeInc);
      cameraSoundVolumeIni = values.getInt("cameraSoundVolumeIni", cameraSoundVolumeIni);
      cameraSoundLevelTimerDelay = values.getInt("cameraSoundLevelTimerDelay", cameraSoundLevelTimerDelay);
      videoPlayerBufferTime = values.getNumber("videoPlayerBufferTime", videoPlayerBufferTime);
      videoPlayerTitleTimerDelay = values.getInt("videoPlayerTitleTimerDelay", videoPlayerTitleTimerDelay);
      videoPlayerChapterListAlpha = values.getNumber("videoPlayerChapterListAlpha", videoPlayerChapterListAlpha);
      videoPlayerSoundVolume = values.getInt("videoPlayerSoundVolume", videoPlayerSoundVolume);
      soundPlayerSoundVolume = values.getInt("soundPlayerSoundVolume", soundPlayerSoundVolume);
      reactMaxNumOfEmojis = values.getInt("reactMaxNumOfEmojis", reactMaxNumOfEmojis);
      reactEmojiAlphaMouseOut = values.getNumber("reactEmojiAlphaMouseOut", reactEmojiAlphaMouseOut);
      reactPickerNumOfColumns = values.getInt("reactPickerNumOfColumns", reactPickerNumOfColumns);
      reactPickerNumOfRows = values.getInt("reactPickerNumOfRows", reactPickerNumOfRows);
      reactPickerEmojiSizeFactor = values.getNumber("reactPickerEmojiSizeFactor", reactPickerEmojiSizeFactor);
      reactPickerMaxNumOfHits = values.getInt("reactPickerMaxNumOfHits", reactPickerMaxNumOfHits);
      watchTimerDelay = values.getInt("watchTimerDelay", watchTimerDelay);
      activeServersTimerDelay = values.getInt("activeServersTimerDelay", activeServersTimerDelay);
      shortTextLimit = values.getInt("shortTextLimit", shortTextLimit);
      shortTextEnding = values.getString("shortTextEnding", shortTextEnding);
      minTextInputAlpha = values.getNumber("minTextInputAlpha", minTextInputAlpha);
      clickGap = values.getInt("clickGap", clickGap);
      tracerBgalpha = values.getNumber("tracerBgalpha", tracerBgalpha);
      tracerAttrDelim = values.getString("tracerAttrDelim", tracerAttrDelim);
      tracerAttrMargin = values.getString("tracerAttrMargin", tracerAttrMargin);
      tracerFilterMinChars = values.getInt("tracerFilterMinChars", tracerFilterMinChars);
      tracerFilterMaxChars = values.getInt("tracerFilterMaxChars", tracerFilterMaxChars);
      tracerFilterRestrict = values.getString("tracerFilterRestrict", tracerFilterRestrict);
      tracerPauseLabelYes = values.getString("tracerPauseLabelYes", tracerPauseLabelYes);
      tracerPauseLabelNo = values.getString("tracerPauseLabelNo", tracerPauseLabelNo);
      tracerPauseIconYes = values.getString("tracerPauseIconYes", tracerPauseIconYes);
      tracerPauseIconNo = values.getString("tracerPauseIconNo", tracerPauseIconNo);
      tracerClearLabel = values.getString("tracerClearLabel", tracerClearLabel);
      tracerClearIcon = values.getString("tracerClearIcon", tracerClearIcon);
      tracerTracerLabel = values.getString("tracerTracerLabel", tracerTracerLabel);
      tracerTraceMaxLength = values.getInt("tracerTraceMaxLength", tracerTraceMaxLength);
      tracerMaxLines = values.getInt("tracerMaxLines", tracerMaxLines);
      tracerTracerIcon = values.getString("tracerTracerIcon", tracerTracerIcon);
      tracerLineNumDelim = values.getString("tracerLineNumDelim", tracerLineNumDelim);
      tracerNetworkAttrDelim = values.getString("tracerNetworkAttrDelim", tracerNetworkAttrDelim);
      colorRgbInputZeros = values.getString("colorRgbInputZeros", colorRgbInputZeros);
      colorHexToNumberString = values.getString("colorHexToNumberString", colorHexToNumberString);
      colorMaxCharsRgbInput = values.getInt("colorMaxCharsRgbInput", colorMaxCharsRgbInput);
      textEnabledCharsHex = values.getString("textEnabledCharsHex", textEnabledCharsHex);
      textBrightDarkChangeBound = values.getInt("textBrightDarkChangeBound", textBrightDarkChangeBound);
      textFieldMaxKeys = values.getInt("textFieldMaxKeys", textFieldMaxKeys);
      values.destroy();
    }
    public function getPanelMenuEnabled():Boolean
    {
      return panelMenuEnabled;
    }
    public function getPanelSettingsEnabled():Boolean
    {
      return panelSettingsEnabled;
    }
    public function getWatchEnabled():Boolean
    {
      return watchEnabled;
    }
    public function getPanelSettingsEnableDesktops():Boolean
    {
      return panelSettingsEnableDesktops;
    }
    public function getPanelSettingsEnableOrientation():Boolean
    {
      return panelSettingsEnableOrientation;
    }
    public function getPanelSettingsEnableWidgetMode():Boolean
    {
      return panelSettingsEnableWidgetMode;
    }
    public function getPanelSettingsEnableSound():Boolean
    {
      return panelSettingsEnableSound;
    }
    public function getPanelSettingsEnableAppearance():Boolean
    {
      return panelSettingsEnableAppearance;
    }
    public function getPanelSettingsEnableLining():Boolean
    {
      return panelSettingsEnableLining;
    }
    public function getPanelSettingsEnableColoring():Boolean
    {
      return panelSettingsEnableColoring;
    }
    public function getPanelSettingsEnableImaging():Boolean
    {
      return panelSettingsEnableImaging;
    }
    public function getPanelSettingsEnableFonting():Boolean
    {
      return panelSettingsEnableFonting;
    }
    public function getPanelSettingsEnableDefaultAppearance():Boolean
    {
      return panelSettingsEnableDefaultAppearance;
    }
    public function getDrawOtherLineThickness():int
    {
      return drawOtherLineThickness;
    }
    public function getBaseListMarkMinAlpha1():Number
    {
      return baseListMarkMinAlpha1;
    }
    public function getBaseListMarkMinAlpha2():Number
    {
      return baseListMarkMinAlpha2;
    }
    public function getBaseListMarkAlpha1Factor():Number
    {
      return baseListMarkAlpha1Factor;
    }
    public function getBaseListMarkAlpha2Factor():Number
    {
      return baseListMarkAlpha2Factor;
    }
    public function getColorSquareLineColor():Number
    {
      return colorSquareLineColor;
    }
    public function getColorSquareLineAlphaMouseOut():Number
    {
      return colorSquareLineAlphaMouseOut;
    }
    public function getColorSquareLineAlphaMouseOver():Number
    {
      return colorSquareLineAlphaMouseOver;
    }
    public function getColorToCalcComplementer():int
    {
      return colorToCalcComplementer;
    }
    public function getColorDrawedColorArrayDark():Number
    {
      return colorDrawedColorArrayDark;
    }
    public function getColorDrawedColorArrayBright():Number
    {
      return colorDrawedColorArrayBright;
    }
    public function getColorDrawedAlphaArray():Array
    {
      return colorDrawedAlphaArray;
    }
    public function getColorDrawedRatioArray():Array
    {
      return colorDrawedRatioArray;
    }
    public function getWidgetSizeFromFontSizeFactor():Number
    {
      return widgetSizeFromFontSizeFactor;
    }
    public function getDisabledAlpha():Number
    {
      return disabledAlpha;
    }
    public function getAppSizeMinWidth():int
    {
      return appSizeMinWidth;
    }
    public function getAppSizeMinHeight():int
    {
      return appSizeMinHeight;
    }
    public function getScrollSizeMinWidth():int
    {
      return scrollSizeMinWidth;
    }
    public function getScrollSizeMinHeight():int
    {
      return scrollSizeMinHeight;
    }
    public function getWeightBackgroundPicture():int
    {
      return weightBackgroundPicture;
    }
    public function getWeightScrollContent():int
    {
      return weightScrollContent;
    }
    public function getWidgetsElementsFix():int
    {
      return widgetsElementsFix;
    }
    public function getWidgetsMargin():int
    {
      return widgetsMargin;
    }
    public function getWidgetSizeStandardWidth():int
    {
      return widgetSizeStandardWidth;
    }
    public function getWidgetSizeStandardHeight():int
    {
      return widgetSizeStandardHeight;
    }
    public function getWidgetSizeMinWidth():int
    {
      return widgetSizeMinWidth;
    }
    public function getWidgetSizeMinHeight():int
    {
      return widgetSizeMinHeight;
    }
    public function getWidgetEnableManualHide():Boolean
    {
      return widgetEnableManualHide;
    }
    public function getWidgetEnableManualResize():Boolean
    {
      return widgetEnableManualResize;
    }
    public function getWidgetEnableManualClose():Boolean
    {
      return widgetEnableManualClose;
    }
    public function getResizeMargin():int
    {
      return resizeMargin;
    }
    public function getFontSizeFactorMobile():Number
    {
      return fontSizeFactorMobile;
    }
    public function getFontSizeFactorDesktop():Number
    {
      return fontSizeFactorDesktop;
    }
    public function getIsDesktop():Boolean
    {
      return isDesktop;
    }
    public function getLineAlpha():Number
    {
      return lineAlpha;
    }
    public function getLineColor2():Number
    {
      return lineColor2;
    }
    public function getLineColor1():Number
    {
      return lineColor1;
    }
    public function getBrightColor2():Number
    {
      return brightColor2;
    }
    public function getPixelHinting():Boolean
    {
      return pixelHinting;
    }
    public function getGradientAlpha1():Number
    {
      return gradientAlpha1;
    }
    public function getGradientAlpha2():Number
    {
      return gradientAlpha2;
    }
    public function getGradientRatio1():int
    {
      return gradientRatio1;
    }
    public function getGradientRatio2():int
    {
      return gradientRatio2;
    }
    public function getLinearRatio1():int
    {
      return linearRatio1;
    }
    public function getLinearRatio2():int
    {
      return linearRatio2;
    }
    public function getLineRatio1():int
    {
      return lineRatio1;
    }
    public function getLineRatio2():int
    {
      return lineRatio2;
    }
    public function getFocalPointRatio():Number
    {
      return focalPointRatio;
    }
    public function getLiveBackgroundMargin():int
    {
      return liveBackgroundMargin;
    }
    /**
     * Returns the largest side a background image is kept in the memory with. A picture
     * larger than this is scaled down to it once, when it arrives: the background paints
     * it scaled to the stage anyway, so the pixels above this size are never displayed and
     * they would only hold the memory. A zero or a negative value turns the scaling off
     * and keeps every picture in its own size.
     */
    public function getBackgroundImageMaxSize():int
    {
      return backgroundImageMaxSize;
    }
    public function getScrollMargin():int
    {
      return scrollMargin;
    }
    public function getMaxBlur():int
    {
      return maxBlur;
    }
    public function getBlurFilterBackMiddle():BlurFilter
    {
      return blurFilterBackMiddle;
    }
    public function getTimeDisplayingTimerDelay():int
    {
      return timeDisplayingTimerDelay;
    }
    public function getBlurFilterColorPickerColor():BlurFilter
    {
      return blurFilterColorPickerColor;
    }
    public function getBaseMinw():int
    {
      return baseMinw;
    }
    public function getBaseMinh():int
    {
      return baseMinh;
    }
    public function getTextsMinSize():int
    {
      return textsMinSize;
    }
    public function getLangSetterMaxElements():int
    {
      return langSetterMaxElements;
    }
    public function getWheelDeltaPixels():int
    {
      return wheelDeltaPixels;
    }
    public function getButtonDrawMovePrevNextScale():Number
    {
      return buttonDrawMovePrevNextScale;
    }
    public function getMaxNumOfWidgetcontainers():int
    {
      return maxNumOfWidgetcontainers;
    }
    public function getMinFontSize():int
    {
      return minFontSize;
    }
    public function getMaxFontSize():int
    {
      return maxFontSize;
    }
    public function getRegexpStrFilename():String
    {
      return regexpStrFilename;
    }
    public function getFileBrowseMaxElements():int
    {
      return fileBrowseMaxElements;
    }
    public function getAutoCompleteMaxElements():int
    {
      return autoCompleteMaxElements;
    }
    public function getDatePanelAlphaMouseOver():Number
    {
      return datePanelAlphaMouseOver;
    }
    public function getDatePanelAlphaMouseDown():Number
    {
      return datePanelAlphaMouseDown;
    }
    public function getDatePanelDateFormat():String
    {
      return datePanelDateFormat;
    }
    public function getDatePanelDateTimeFormat():String
    {
      return datePanelDateTimeFormat;
    }
    public function getDatePanelDateTimeSecFormat():String
    {
      return datePanelDateTimeSecFormat;
    }
    public function getInputTimerDelay():int
    {
      return inputTimerDelay;
    }
    public function getEmptyHtmlParagraph():String
    {
      return emptyHtmlParagraph;
    }
    public function getBoardBackgroundColor():String
    {
      return boardBackgroundColor;
    }
    public function getBoardLineColor():String
    {
      return boardLineColor;
    }
    public function getBoardPadding():int
    {
      return boardPadding;
    }
    public function getBoardLineThickness():int
    {
      return boardLineThickness;
    }
    public function getBoardLineMinThickness():int
    {
      return boardLineMinThickness;
    }
    public function getBoardLineMaxThickness():int
    {
      return boardLineMaxThickness;
    }
    public function getBoardLineIncThickness():int
    {
      return boardLineIncThickness;
    }
    public function getBoardRubberThicknessFactor():int
    {
      return boardRubberThicknessFactor;
    }
    public function getBoardChangedTimerDelay():int
    {
      return boardChangedTimerDelay;
    }
    public function getRaterNumOfStars():int
    {
      return raterNumOfStars;
    }
    /**
     * Returns the narrowest picture a camera of this framework can be asked for.
     */
    public function getCameraWidthMin():int
    {
      return cameraWidthMin;
    }
    /**
     * Returns the widest picture a camera of this framework can be asked for.
     */
    public function getCameraWidthMax():int
    {
      return cameraWidthMax;
    }
    /**
     * Returns the step between the two widths a camera can be asked for.
     */
    public function getCameraWidthInc():int
    {
      return cameraWidthInc;
    }
    /**
     * Returns the width a brand new camera starts with.
     */
    public function getCameraWidthIni():int
    {
      return cameraWidthIni;
    }
    /**
     * Returns the fewest frames per second a camera can be asked for.
     */
    public function getCameraFpsMin():int
    {
      return cameraFpsMin;
    }
    /**
     * Returns the most frames per second a camera can be asked for.
     */
    public function getCameraFpsMax():int
    {
      return cameraFpsMax;
    }
    /**
     * Returns the frames per second a brand new camera starts with.
     */
    public function getCameraFpsIni():int
    {
      return cameraFpsIni;
    }
    /**
     * Returns the worst quality a camera can be asked for.
     */
    public function getCameraQualityMin():int
    {
      return cameraQualityMin;
    }
    /**
     * Returns the best quality a camera can be asked for.
     */
    public function getCameraQualityMax():int
    {
      return cameraQualityMax;
    }
    /**
     * Returns the quality a brand new camera starts with.
     */
    public function getCameraQualityIni():int
    {
      return cameraQualityIni;
    }
    /**
     * Returns the weakest blur of the picture of a camera: no blur at all.
     */
    public function getCameraBlurMin():int
    {
      return cameraBlurMin;
    }
    /**
     * Returns the strongest blur of the picture of a camera.
     */
    public function getCameraBlurMax():int
    {
      return cameraBlurMax;
    }
    /**
     * Returns the step between the two blurs of the picture of a camera.
     */
    public function getCameraBlurInc():int
    {
      return cameraBlurInc;
    }
    /**
     * Returns the smallest value one color channel of the picture of a camera can be multiplied by.
     */
    public function getCameraChannelMin():Number
    {
      return cameraChannelMin;
    }
    /**
     * Returns the greatest value one color channel of the picture of a camera can be multiplied by.
     */
    public function getCameraChannelMax():Number
    {
      return cameraChannelMax;
    }
    /**
     * Returns the greatest value the alpha channel of the picture of a camera can be multiplied by.
     */
    public function getCameraChannelAlphaMax():Number
    {
      return cameraChannelAlphaMax;
    }
    /**
     * Returns the value every channel of the picture of a camera starts with: the untouched picture.
     */
    public function getCameraChannelIni():Number
    {
      return cameraChannelIni;
    }
    /**
     * Returns the step between the two values one channel of the picture of a camera can take.
     */
    public function getCameraChannelInc():Number
    {
      return cameraChannelInc;
    }
    /**
     * Returns the number of the decimals one channel of the picture of a camera is set with.
     */
    public function getCameraChannelPrecision():int
    {
      return cameraChannelPrecision;
    }
    /**
     * Returns the number of the camera devices the picker of them displays at the same time.
     */
    public function getCameraDevicesMaxElements():int
    {
      return cameraDevicesMaxElements;
    }
    /**
     * Returns the first characters of the name of a picture taken by a camera.
     */
    public function getCameraPictureNamePrefix():String
    {
      return cameraPictureNamePrefix;
    }
    /**
     * Returns the extension of the name of a picture taken by a camera.
     */
    public function getCameraPictureNameExtension():String
    {
      return cameraPictureNameExtension;
    }
    /**
     * Returns the milliseconds the button of the photo of a camera stays disabled for
     * after a photo has been taken by it.
     */
    public function getCameraTakePictureTimerDelay():int
    {
      return cameraTakePictureTimerDelay;
    }
    /**
     * Returns the quietest microphone a camera of this framework can be asked for: the
     * gain a muted camera stands on as well.
     */
    public function getCameraSoundVolumeMin():int
    {
      return cameraSoundVolumeMin;
    }
    /**
     * Returns the loudest microphone a camera of this framework can be asked for.
     */
    public function getCameraSoundVolumeMax():int
    {
      return cameraSoundVolumeMax;
    }
    /**
     * Returns the step between the two gains the microphone of a camera can be asked for.
     */
    public function getCameraSoundVolumeInc():int
    {
      return cameraSoundVolumeInc;
    }
    /**
     * Returns the gain a brand new camera asks its microphone for: the potmeter of the
     * sound of it stands on this value until the user drags it somewhere else.
     */
    public function getCameraSoundVolumeIni():int
    {
      return cameraSoundVolumeIni;
    }
    /**
     * Returns the milliseconds between the two readings of the loudness the microphone of
     * a camera hears: the bar displaying that loudness is drawn again at every one of them.
     */
    public function getCameraSoundLevelTimerDelay():int
    {
      return cameraSoundLevelTimerDelay;
    }
    /**
     * Returns the seconds of the video a player of this framework collects before it
     * starts to display the picture of it.
     */
    public function getVideoPlayerBufferTime():Number
    {
      return videoPlayerBufferTime;
    }
    /**
     * Returns the milliseconds the name of the chapter stands on the picture of a
     * fullscreen player before it leaves that picture alone.
     */
    public function getVideoPlayerTitleTimerDelay():int
    {
      return videoPlayerTitleTimerDelay;
    }
    /**
     * Returns the alpha the background of the list of the chapters of a player is drawn
     * with: that list stands on the picture of the video, so it lets a little of that
     * picture through and it keeps the names of the chapters readable at the same time.
     */
    public function getVideoPlayerChapterListAlpha():Number
    {
      return videoPlayerChapterListAlpha;
    }
    /**
     * Returns the volume a brand new player of this framework starts with: the potmeter
     * of the sound of it stands on this value until the user drags it somewhere else.
     */
    public function getVideoPlayerSoundVolume():int
    {
      return videoPlayerSoundVolume;
    }
    /**
     * Returns the volume a brand new sound player of this framework starts with: the
     * potmeter of the sound of it stands on this value until the user drags it somewhere
     * else.
     */
    public function getSoundPlayerSoundVolume():int
    {
      return soundPlayerSoundVolume;
    }
    public function getReactMaxNumOfEmojis():int
    {
      return reactMaxNumOfEmojis;
    }
    public function getReactEmojiAlphaMouseOut():Number
    {
      return reactEmojiAlphaMouseOut;
    }
    public function getReactPickerNumOfColumns():int
    {
      return reactPickerNumOfColumns;
    }
    public function getReactPickerNumOfRows():int
    {
      return reactPickerNumOfRows;
    }
    public function getReactPickerEmojiSizeFactor():Number
    {
      return reactPickerEmojiSizeFactor;
    }
    public function getReactPickerMaxNumOfHits():int
    {
      return reactPickerMaxNumOfHits;
    }
    public function getWatchTimerDelay():int
    {
      return watchTimerDelay;
    }
    public function getActiveServersTimerDelay():int
    {
      return activeServersTimerDelay;
    }
    public function getShortTextLimit():int
    {
      return shortTextLimit;
    }
    public function getShortTextEnding():String
    {
      return shortTextEnding;
    }
    public function getMinTextInputAlpha():Number
    {
      return minTextInputAlpha;
    }
    public function getClickGap():int
    {
      return clickGap;
    }
    public function getTracerBgalpha():Number
    {
      return tracerBgalpha;
    }
    public function getTracerAttrDelim():String
    {
      return tracerAttrDelim;
    }
    public function getTracerAttrMargin():String
    {
      return tracerAttrMargin;
    }
    public function getTracerFilterMinChars():int
    {
      return tracerFilterMinChars;
    }
    public function getTracerFilterMaxChars():int
    {
      return tracerFilterMaxChars;
    }
    public function getTracerFilterRestrict():String
    {
      return tracerFilterRestrict;
    }
    public function getTracerPauseLabelYes():String
    {
      return tracerPauseLabelYes;
    }
    public function getTracerPauseLabelNo():String
    {
      return tracerPauseLabelNo;
    }
    public function getTracerPauseIconYes():String
    {
      return tracerPauseIconYes;
    }
    public function getTracerPauseIconNo():String
    {
      return tracerPauseIconNo;
    }
    public function getTracerClearLabel():String
    {
      return tracerClearLabel;
    }
    public function getTracerClearIcon():String
    {
      return tracerClearIcon;
    }
    public function getTracerTracerLabel():String
    {
      return tracerTracerLabel;
    }
    public function getTracerTraceMaxLength():int
    {
      return tracerTraceMaxLength;
    }
    public function getTracerMaxLines():int
    {
      return tracerMaxLines;
    }
    public function getTracerTracerIcon():String
    {
      return tracerTracerIcon;
    }
    public function getTracerLineNumDelim():String
    {
      return tracerLineNumDelim;
    }
    public function getTracerNetworkAttrDelim():String
    {
      return tracerNetworkAttrDelim;
    }
    public function getColorRgbInputZeros():String
    {
      return colorRgbInputZeros;
    }
    public function getColorHexToNumberString():String
    {
      return colorHexToNumberString;
    }
    public function getColorMaxCharsRgbInput():int
    {
      return colorMaxCharsRgbInput;
    }
    public function getTextEnabledCharsHex():String
    {
      return textEnabledCharsHex;
    }
    public function getTextBrightDarkChangeBound():int
    {
      return textBrightDarkChangeBound;
    }
    public function getTextDropShadowArrayDark():Array
    {
      return textDropShadowArrayDark;
    }
    public function getTextDropShadowArrayBright():Array
    {
      return textDropShadowArrayBright;
    }
    public function getTextFieldMaxKeys():int
    {
      return textFieldMaxKeys;
    }
    /**
     * Destroys this object and frees up everything.
     */
    public function destroy():void
    {
      application.trace("<" + this + " ComponentsConfig destroy> called.", 1);
      if (embeddedConfigByteArray != null)
      {
        embeddedConfigByteArray.clear();
      }
      textDropShadowArrayDark.splice(0);
      textDropShadowArrayBright.splice(0);
      colorDrawedAlphaArray.splice(0);
      colorDrawedRatioArray.splice(0);
      EmbeddedConfig = null;
      embeddedConfigByteArray = null;
      timeDisplayingTimerDelay = 0;
      blurFilterBackMiddle = null;
      blurFilterColorPickerColor = null;
      textDropShadowArrayDark = null;
      textDropShadowArrayBright = null;
      panelMenuEnabled = false;
      panelSettingsEnabled = false;
      watchEnabled = false;
      panelSettingsEnableDesktops = false;
      panelSettingsEnableOrientation = false;
      panelSettingsEnableWidgetMode = false;
      panelSettingsEnableSound = false;
      panelSettingsEnableAppearance = false;
      panelSettingsEnableLining = false;
      panelSettingsEnableColoring = false;
      panelSettingsEnableImaging = false;
      panelSettingsEnableFonting = false;
      panelSettingsEnableDefaultAppearance = false;
      drawOtherLineThickness = 0;
      baseListMarkMinAlpha1 = 0;
      baseListMarkMinAlpha2 = 0;
      baseListMarkAlpha1Factor = 0;
      baseListMarkAlpha2Factor = 0;
      colorSquareLineColor = 0;
      colorSquareLineAlphaMouseOut = 0;
      colorSquareLineAlphaMouseOver = 0;
      colorToCalcComplementer = 0;
      colorDrawedColorArrayDark = 0;
      colorDrawedColorArrayBright = 0;
      colorDrawedAlphaArray = null;
      colorDrawedRatioArray = null;
      widgetSizeFromFontSizeFactor = 0;
      disabledAlpha = 0;
      appSizeMinWidth = 0;
      appSizeMinHeight = 0;
      scrollSizeMinWidth = 0;
      scrollSizeMinHeight = 0;
      weightBackgroundPicture = 0;
      weightScrollContent = 0;
      widgetsElementsFix = 0;
      widgetsMargin = 0;
      widgetSizeStandardWidth = 0;
      widgetSizeStandardHeight = 0;
      widgetSizeMinWidth = 0;
      widgetSizeMinHeight = 0;
      widgetEnableManualHide = false;
      widgetEnableManualResize = false;
      widgetEnableManualClose = false;
      resizeMargin = 0;
      fontSizeFactorMobile = 0;
      fontSizeFactorDesktop = 0;
      isDesktop = false;
      lineAlpha = 0;
      lineColor2 = 0;
      lineColor1 = 0;
      brightColor2 = 0;
      pixelHinting = false;
      gradientAlpha1 = 0;
      gradientAlpha2 = 0;
      gradientRatio1 = 0;
      gradientRatio2 = 0;
      linearRatio1 = 0;
      linearRatio2 = 0;
      lineRatio1 = 0;
      lineRatio2 = 0;
      focalPointRatio = 0;
      liveBackgroundMargin = 0;
      scrollMargin = 0;
      maxBlur = 0;
      baseMinw = 0;
      baseMinh = 0;
      textsMinSize = 0;
      langSetterMaxElements = 0;
      wheelDeltaPixels = 0;
      buttonDrawMovePrevNextScale = 0;
      maxNumOfWidgetcontainers = 0;
      minFontSize = 0;
      maxFontSize = 0;
      regexpStrFilename = null;
      fileBrowseMaxElements = 0;
      autoCompleteMaxElements = 0;
      datePanelAlphaMouseOver = 0;
      datePanelAlphaMouseDown = 0;
      datePanelDateFormat = null;
      datePanelDateTimeFormat = null;
      datePanelDateTimeSecFormat = null;
      inputTimerDelay = 0;
      emptyHtmlParagraph = null;
      boardBackgroundColor = null;
      boardLineColor = null;
      boardPadding = 0;
      boardLineThickness = 0;
      boardLineMinThickness = 0;
      boardLineMaxThickness = 0;
      boardLineIncThickness = 0;
      boardRubberThicknessFactor = 0;
      boardChangedTimerDelay = 0;
      raterNumOfStars = 0;
      cameraWidthMin = 0;
      cameraWidthMax = 0;
      cameraWidthInc = 0;
      cameraWidthIni = 0;
      cameraFpsMin = 0;
      cameraFpsMax = 0;
      cameraFpsIni = 0;
      cameraQualityMin = 0;
      cameraQualityMax = 0;
      cameraQualityIni = 0;
      cameraBlurMin = 0;
      cameraBlurMax = 0;
      cameraBlurInc = 0;
      cameraChannelMin = 0;
      cameraChannelMax = 0;
      cameraChannelAlphaMax = 0;
      cameraChannelIni = 0;
      cameraChannelInc = 0;
      cameraChannelPrecision = 0;
      cameraDevicesMaxElements = 0;
      cameraPictureNamePrefix = null;
      cameraPictureNameExtension = null;
      cameraTakePictureTimerDelay = 0;
      cameraSoundVolumeMin = 0;
      cameraSoundVolumeMax = 0;
      cameraSoundVolumeInc = 0;
      cameraSoundVolumeIni = 0;
      cameraSoundLevelTimerDelay = 0;
      videoPlayerBufferTime = 0;
      videoPlayerTitleTimerDelay = 0;
      videoPlayerChapterListAlpha = 0;
      videoPlayerSoundVolume = 0;
      soundPlayerSoundVolume = 0;
      reactMaxNumOfEmojis = 0;
      reactEmojiAlphaMouseOut = 0;
      reactPickerNumOfColumns = 0;
      reactPickerNumOfRows = 0;
      reactPickerEmojiSizeFactor = 0;
      reactPickerMaxNumOfHits = 0;
      watchTimerDelay = 0;
      shortTextLimit = 0;
      shortTextEnding = null;
      minTextInputAlpha = 0;
      clickGap = 0;
      tracerBgalpha = 0;
      tracerAttrDelim = null;
      tracerAttrMargin = null;
      tracerFilterMinChars = 0;
      tracerFilterMaxChars = 0;
      tracerFilterRestrict = null;
      tracerPauseLabelYes = null;
      tracerPauseLabelNo = null;
      tracerPauseIconYes = null;
      tracerPauseIconNo = null;
      tracerClearLabel = null;
      tracerClearIcon = null;
      tracerTracerLabel = null;
      tracerTraceMaxLength = 0;
      tracerMaxLines = 0;
      tracerTracerIcon = null;
      tracerLineNumDelim = null;
      tracerNetworkAttrDelim = null;
      colorRgbInputZeros = null;
      colorHexToNumberString = null;
      colorMaxCharsRgbInput = 0;
      textEnabledCharsHex = null;
      textBrightDarkChangeBound = 0;
      textFieldMaxKeys = 0;
      application = null;
    }
  }
}
