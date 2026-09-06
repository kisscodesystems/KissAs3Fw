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
 * ComponentsConfigUnitTest
 * Checks the ComponentsConfig of the framework.
 *
 * MAIN FEATURES:
 * - the values the components are built of have to hold their own invariants: a minimum
 *   can not stand above its maximum and a size can not be a negative one
 * - every other getter is called as well, so a getter reading the wrong field is caught
 * - a fresh instance is built and destroyed here: the one of the running application is
 *   left alone, destroying that one would take the values out of the test itself
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.config.ComponentsConfig;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ComponentsConfigUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ComponentsConfigUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ComponentsConfig";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const config:ComponentsConfig = new ComponentsConfig(application);
      // the font sizes and the thicknesses stand between a minimum and a maximum
      assertTrue("the minimum font size is below the maximum one"
        , config.getMinFontSize() < config.getMaxFontSize());
      assertTrue("the minimum font size is a positive one", config.getMinFontSize() > 0);
      assertTrue("the minimum line thickness of the board is below the maximum one"
        , config.getBoardLineMinThickness() < config.getBoardLineMaxThickness());
      assertTrue("the line thickness of the board is not below its minimum"
        , config.getBoardLineThickness() >= config.getBoardLineMinThickness());
      assertTrue("the line thickness of the board is not above its maximum"
        , config.getBoardLineThickness() <= config.getBoardLineMaxThickness());
      // a size of an object can never be a negative one, and the minimums of the
      // application and of a scroll have to leave room for something to be displayed
      assertTrue("the minimum width of the application is a positive one"
        , config.getAppSizeMinWidth() > 0);
      assertTrue("the minimum height of the application is a positive one"
        , config.getAppSizeMinHeight() > 0);
      assertTrue("the minimum width of a scroll is a positive one"
        , config.getScrollSizeMinWidth() > 0);
      assertTrue("the minimum height of a scroll is a positive one"
        , config.getScrollSizeMinHeight() > 0);
      assertTrue("the minimum size of the texts is a positive one", config.getTextsMinSize() > 0);
      assertTrue("the minimum width of an object is not a negative one", config.getBaseMinw() >= 0);
      assertTrue("the minimum height of an object is not a negative one", config.getBaseMinh() >= 0);
      assertTrue("the margin of a scroll is not a negative one", config.getScrollMargin() >= 0);
      assertTrue("the gap of a click is not a negative one", config.getClickGap() >= 0);
      assertTrue("the maximum blur is not a negative one", config.getMaxBlur() >= 0);
      // the timers have to have a delay, a zero would fire them in every frame
      assertTrue("the delay of the input timer is a positive one"
        , config.getInputTimerDelay() > 0);
      assertTrue("the delay of the timer of the watch is a positive one"
        , config.getWatchTimerDelay() > 0);
      assertTrue("the delay of the timer of the active servers is a positive one"
        , config.getActiveServersTimerDelay() > 0);
      // the lists and the shortened texts have to have room for something
      assertTrue("the auto completion displays at least one element"
        , config.getAutoCompleteMaxElements() > 0);
      assertTrue("a rater has at least one star", config.getRaterNumOfStars() > 0);
      // a react row displays at least one emoji, its picker at least one emoji as well
      assertTrue("a react row displays at least one emoji", config.getReactMaxNumOfEmojis() > 0);
      assertTrue("an emoji of the picker is visible", config.getReactEmojiAlphaMouseOut() > 0);
      assertTrue("an emoji of the picker is not overpainted"
        , config.getReactEmojiAlphaMouseOut() <= 1);
      assertTrue("the picker has at least one column", config.getReactPickerNumOfColumns() > 0);
      assertTrue("the picker has at least one row", config.getReactPickerNumOfRows() > 0);
      assertTrue("an emoji of the picker has a size"
        , config.getReactPickerEmojiSizeFactor() > 0);
      assertTrue("the search of the picker displays at least one hit"
        , config.getReactPickerMaxNumOfHits() > 0);
      assertTrue("a shortened text keeps at least one character", config.getShortTextLimit() > 0);
      assertNotNull("the ending of a shortened text is a value", config.getShortTextEnding());
      // the filters and the arrays of the drawings are built in the code, not in the xml
      assertNotNull("the blur filter of the background is a value"
        , config.getBlurFilterBackMiddle());
      assertNotNull("the blur filter of the color picker is a value"
        , config.getBlurFilterColorPickerColor());
      assertTrue("the dark drop shadow of the texts has an element"
        , config.getTextDropShadowArrayDark().length > 0);
      assertTrue("the bright drop shadow of the texts has an element"
        , config.getTextDropShadowArrayBright().length > 0);
      assertEquals("the alphas and the ratios of the drawn colors are of the same length"
        , config.getColorDrawedAlphaArray().length, config.getColorDrawedRatioArray().length);
      // Every remaining getter is called as well: a getter of this class reads one single
      // field, so the only mistake it can carry is reading the wrong one, and that shows up
      // as a value of the wrong type or of the wrong sign. The booleans are decided by the
      // xml alone, so those carry no invariant of their own, they are only called here.
      config.getPanelMenuEnabled();
      config.getPanelSettingsEnabled();
      config.getWatchEnabled();
      config.getPanelSettingsEnableDesktops();
      config.getPanelSettingsEnableOrientation();
      config.getPanelSettingsEnableWidgetMode();
      config.getPanelSettingsEnableSound();
      config.getPanelSettingsEnableAppearance();
      config.getPanelSettingsEnableLining();
      config.getPanelSettingsEnableColoring();
      config.getPanelSettingsEnableImaging();
      config.getPanelSettingsEnableFonting();
      config.getPanelSettingsEnableDefaultAppearance();
      assertTrue("getDrawOtherLineThickness gives a value", config.getDrawOtherLineThickness() >= 0);
      assertTrue("getBaseListMarkMinAlpha1 gives a value", config.getBaseListMarkMinAlpha1() >= 0);
      assertTrue("getBaseListMarkMinAlpha2 gives a value", config.getBaseListMarkMinAlpha2() >= 0);
      assertTrue("getBaseListMarkAlpha1Factor gives a value", config.getBaseListMarkAlpha1Factor() >= 0);
      assertTrue("getBaseListMarkAlpha2Factor gives a value", config.getBaseListMarkAlpha2Factor() >= 0);
      assertTrue("getColorSquareLineColor gives a value", config.getColorSquareLineColor() >= 0);
      assertTrue("getColorSquareLineAlphaMouseOut gives a value", config.getColorSquareLineAlphaMouseOut() >= 0);
      assertTrue("getColorSquareLineAlphaMouseOver gives a value", config.getColorSquareLineAlphaMouseOver() >= 0);
      assertTrue("getColorToCalcComplementer gives a value", config.getColorToCalcComplementer() >= 0);
      assertTrue("getColorDrawedColorArrayDark gives a value", config.getColorDrawedColorArrayDark() >= 0);
      assertTrue("getColorDrawedColorArrayBright gives a value", config.getColorDrawedColorArrayBright() >= 0);
      assertTrue("getWidgetSizeFromFontSizeFactor gives a value", config.getWidgetSizeFromFontSizeFactor() >= 0);
      assertTrue("getDisabledAlpha gives a value", config.getDisabledAlpha() >= 0);
      assertTrue("getWeightBackgroundPicture gives a value", config.getWeightBackgroundPicture() >= 0);
      assertTrue("getWeightScrollContent gives a value", config.getWeightScrollContent() >= 0);
      assertTrue("getWidgetsElementsFix gives a value", config.getWidgetsElementsFix() >= 0);
      assertTrue("getWidgetsMargin gives a value", config.getWidgetsMargin() >= 0);
      assertTrue("getWidgetSizeStandardWidth gives a value", config.getWidgetSizeStandardWidth() >= 0);
      assertTrue("getWidgetSizeStandardHeight gives a value", config.getWidgetSizeStandardHeight() >= 0);
      assertTrue("getWidgetSizeMinWidth gives a value", config.getWidgetSizeMinWidth() >= 0);
      assertTrue("getWidgetSizeMinHeight gives a value", config.getWidgetSizeMinHeight() >= 0);
      config.getWidgetEnableManualHide();
      config.getWidgetEnableManualResize();
      config.getWidgetEnableManualClose();
      assertTrue("getResizeMargin gives a value", config.getResizeMargin() >= 0);
      assertTrue("getFontSizeFactorMobile gives a value", config.getFontSizeFactorMobile() >= 0);
      assertTrue("getFontSizeFactorDesktop gives a value", config.getFontSizeFactorDesktop() >= 0);
      config.getIsDesktop();
      assertTrue("getLineAlpha gives a value", config.getLineAlpha() >= 0);
      assertTrue("getLineColor2 gives a value", config.getLineColor2() >= 0);
      assertTrue("getLineColor1 gives a value", config.getLineColor1() >= 0);
      assertTrue("getBrightColor2 gives a value", config.getBrightColor2() >= 0);
      config.getPixelHinting();
      assertTrue("getGradientAlpha1 gives a value", config.getGradientAlpha1() >= 0);
      assertTrue("getGradientAlpha2 gives a value", config.getGradientAlpha2() >= 0);
      assertTrue("getGradientRatio1 gives a value", config.getGradientRatio1() >= 0);
      assertTrue("getGradientRatio2 gives a value", config.getGradientRatio2() >= 0);
      assertTrue("getLinearRatio1 gives a value", config.getLinearRatio1() >= 0);
      assertTrue("getLinearRatio2 gives a value", config.getLinearRatio2() >= 0);
      assertTrue("getLineRatio1 gives a value", config.getLineRatio1() >= 0);
      assertTrue("getLineRatio2 gives a value", config.getLineRatio2() >= 0);
      assertTrue("getFocalPointRatio gives a value", config.getFocalPointRatio() >= 0);
      assertTrue("getLiveBackgroundMargin gives a value", config.getLiveBackgroundMargin() >= 0);
      assertTrue("getTimeDisplayingTimerDelay gives a value", config.getTimeDisplayingTimerDelay() >= 0);
      assertTrue("getLangSetterMaxElements gives a value", config.getLangSetterMaxElements() >= 0);
      assertTrue("getWheelDeltaPixels gives a value", config.getWheelDeltaPixels() >= 0);
      assertTrue("getButtonDrawMovePrevNextScale gives a value", config.getButtonDrawMovePrevNextScale() >= 0);
      assertTrue("getMaxNumOfWidgetcontainers gives a value", config.getMaxNumOfWidgetcontainers() >= 0);
      assertNotNull("getRegexpStrFilename gives a value", config.getRegexpStrFilename());
      assertTrue("getFileBrowseMaxElements gives a value", config.getFileBrowseMaxElements() >= 0);
      assertTrue("getDatePanelAlphaMouseOver gives a value", config.getDatePanelAlphaMouseOver() >= 0);
      assertTrue("getDatePanelAlphaMouseDown gives a value", config.getDatePanelAlphaMouseDown() >= 0);
      assertNotNull("getDatePanelDateFormat gives a value", config.getDatePanelDateFormat());
      assertNotNull("getDatePanelDateTimeFormat gives a value", config.getDatePanelDateTimeFormat());
      assertNotNull("getDatePanelDateTimeSecFormat gives a value", config.getDatePanelDateTimeSecFormat());
      assertNotNull("getEmptyHtmlParagraph gives a value", config.getEmptyHtmlParagraph());
      assertNotNull("getBoardBackgroundColor gives a value", config.getBoardBackgroundColor());
      assertNotNull("getBoardLineColor gives a value", config.getBoardLineColor());
      assertTrue("getBoardPadding gives a value", config.getBoardPadding() >= 0);
      assertTrue("getBoardLineIncThickness gives a value", config.getBoardLineIncThickness() >= 0);
      assertTrue("getBoardRubberThicknessFactor gives a value", config.getBoardRubberThicknessFactor() >= 0);
      assertTrue("getBoardChangedTimerDelay gives a value", config.getBoardChangedTimerDelay() >= 0);
      assertTrue("getMinTextInputAlpha gives a value", config.getMinTextInputAlpha() >= 0);
      assertTrue("getTracerBgalpha gives a value", config.getTracerBgalpha() >= 0);
      assertNotNull("getTracerAttrDelim gives a value", config.getTracerAttrDelim());
      assertNotNull("getTracerAttrMargin gives a value", config.getTracerAttrMargin());
      assertTrue("getTracerFilterMinChars gives a value", config.getTracerFilterMinChars() >= 0);
      assertTrue("getTracerFilterMaxChars gives a value", config.getTracerFilterMaxChars() >= 0);
      assertNotNull("getTracerFilterRestrict gives a value", config.getTracerFilterRestrict());
      assertNotNull("getTracerPauseLabelYes gives a value", config.getTracerPauseLabelYes());
      assertNotNull("getTracerPauseLabelNo gives a value", config.getTracerPauseLabelNo());
      assertNotNull("getTracerPauseIconYes gives a value", config.getTracerPauseIconYes());
      assertNotNull("getTracerPauseIconNo gives a value", config.getTracerPauseIconNo());
      assertNotNull("getTracerClearLabel gives a value", config.getTracerClearLabel());
      assertNotNull("getTracerClearIcon gives a value", config.getTracerClearIcon());
      assertNotNull("getTracerTracerLabel gives a value", config.getTracerTracerLabel());
      assertTrue("getTracerTraceMaxLength gives a value", config.getTracerTraceMaxLength() >= 0);
      assertTrue("getTracerMaxLines gives a value", config.getTracerMaxLines() >= 0);
      assertNotNull("getTracerTracerIcon gives a value", config.getTracerTracerIcon());
      assertNotNull("getTracerLineNumDelim gives a value", config.getTracerLineNumDelim());
      assertNotNull("getTracerNetworkAttrDelim gives a value", config.getTracerNetworkAttrDelim());
      assertNotNull("getColorRgbInputZeros gives a value", config.getColorRgbInputZeros());
      assertNotNull("getColorHexToNumberString gives a value", config.getColorHexToNumberString());
      assertTrue("getColorMaxCharsRgbInput gives a value", config.getColorMaxCharsRgbInput() >= 0);
      assertNotNull("getTextEnabledCharsHex gives a value", config.getTextEnabledCharsHex());
      assertTrue("getTextBrightDarkChangeBound gives a value", config.getTextBrightDarkChangeBound() >= 0);
      assertTrue("getTextFieldMaxKeys gives a value", config.getTextFieldMaxKeys() >= 0);
      assertTrue("the buffer of a video player is not a negative one"
        , config.getVideoPlayerBufferTime() >= 0);
      assertTrue("the title timer of a video player is not a negative one"
        , config.getVideoPlayerTitleTimerDelay() >= 0);
      assertTrue("the alpha of the list of the chapters is an alpha"
        , config.getVideoPlayerChapterListAlpha() >= 0
        && config.getVideoPlayerChapterListAlpha() <= 1);
      assertTrue("the volume a video player starts with stands inside its range"
        , config.getVideoPlayerSoundVolume() >= 0
        && config.getVideoPlayerSoundVolume() <= 100);
      config.destroy();
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
    }
  }
}
