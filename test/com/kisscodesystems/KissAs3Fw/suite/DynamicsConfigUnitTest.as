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
 * DynamicsConfigUnitTest
 * Checks the DynamicsConfig of the framework.
 *
 * MAIN FEATURES:
 * - every displayed property can be written and read back, that pair is the contract of
 *   this class: a setter writing another field than the one its getter reads is caught
 * - the height of a text field comes from the font, so it follows the size of it
 * - a fresh instance is built and destroyed here: the one of the running application is
 *   left alone, destroying that one would take the values out of the test itself
 * - the switching and the resetting of the displaying styles are checked on a style of
 *   this suite: that style is registered with no background file at all, so the styles
 *   this suite touches only ever draw the empty or the embedded background and it never
 *   reaches the loading of a picture from the framework server
 * - the two random color schema methods are not called: those restyle the whole running
 *   application, so a suite is not the place of them
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.config.DynamicsConfig;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBackgroundAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDisplayingStyles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWidgetModes;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class DynamicsConfigUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function DynamicsConfigUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "DynamicsConfig";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const config:DynamicsConfig = new DynamicsConfig(application);
      // the sizes of the drawings are written and read back one by one
      config.setAppLineThickness(3);
      assertEquals("getAppLineThickness after setAppLineThickness", 3, config.getAppLineThickness());
      config.setAppMargin(14);
      assertEquals("getAppMargin after setAppMargin", 14, config.getAppMargin());
      config.setAppPadding(7);
      assertEquals("getAppPadding after setAppPadding", 7, config.getAppPadding());
      config.setAppRadius(5);
      assertEquals("getAppRadius after setAppRadius", 5, config.getAppRadius());
      config.setAppBoxCorner(9);
      assertEquals("getAppBoxCorner after setAppBoxCorner", 9, config.getAppBoxCorner());
      config.setAppBoxFrame(EnumBoxFrames.BOX_FRAME_FULL());
      assertEquals("getAppBoxFrame after setAppBoxFrame"
        , EnumBoxFrames.BOX_FRAME_FULL(), config.getAppBoxFrame());
      // the sound of the application is a volume and a switch
      config.setAppSoundVolume(42);
      assertEquals("getAppSoundVolume after setAppSoundVolume", 42, config.getAppSoundVolume());
      config.setAppSoundPlaying(false);
      assertFalse("getAppSoundPlaying after setAppSoundPlaying with a false"
        , config.getAppSoundPlaying());
      config.setAppSoundPlaying(true);
      assertTrue("getAppSoundPlaying after setAppSoundPlaying with a true"
        , config.getAppSoundPlaying());
      // the colors of the background and the alpha of them
      config.setAppBackgroundColorDark(0x102030);
      assertEquals("getAppBackgroundColorDark after setAppBackgroundColorDark"
        , 0x102030, config.getAppBackgroundColorDark());
      config.setAppBackgroundColorMid(0x405060);
      assertEquals("getAppBackgroundColorMid after setAppBackgroundColorMid"
        , 0x405060, config.getAppBackgroundColorMid());
      config.setAppBackgroundColorBright(0x708090);
      assertEquals("getAppBackgroundColorBright after setAppBackgroundColorBright"
        , 0x708090, config.getAppBackgroundColorBright());
      config.setAppBackgroundColorAlpha(0.25);
      assertEqualsNumber("getAppBackgroundColorAlpha after setAppBackgroundColorAlpha"
        , 0.25, config.getAppBackgroundColorAlpha());
      config.setAppBackgroundColorRand(false);
      assertFalse("getAppBackgroundColorRand after setAppBackgroundColorRand"
        , config.getAppBackgroundColorRand());
      config.setAppBackgroundColorToFont(false);
      assertFalse("getAppBackgroundColorToFont after setAppBackgroundColorToFont"
        , config.getAppBackgroundColorToFont());
      // the background itself: its align, its alpha, its blur and whether it is a live one
      config.setAppBackgroundAlpha(0.75);
      assertEqualsNumber("getAppBackgroundAlpha after setAppBackgroundAlpha"
        , 0.75, config.getAppBackgroundAlpha());
      config.setAppBackgroundBlur(4);
      assertEquals("getAppBackgroundBlur after setAppBackgroundBlur", 4, config.getAppBackgroundBlur());
      config.setAppBackgroundLive(false);
      assertFalse("getAppBackgroundLive after setAppBackgroundLive", config.getAppBackgroundLive());
      assertNotNull("getAppBackgroundAlign gives a value", config.getAppBackgroundAlign());
      config.setAppBackgroundAlign(config.getAppBackgroundAlign());
      assertNotNull("getAppBackgroundImage gives a value", config.getAppBackgroundImage());
      // the url of a background image is only stored by this class, the loading of it is
      // asked for by setAppBackgroundImage that is not called here
      config.changeBgImage("theStyleOfThisTest", "");
      // the colors of the font and the two switches of it
      config.setAppFontColorBright(0xFEFEFE);
      assertEquals("getAppFontColorBright after setAppFontColorBright"
        , 0xFEFEFE, config.getAppFontColorBright());
      config.setAppFontColorMid(0x808080);
      assertEquals("getAppFontColorMid after setAppFontColorMid"
        , 0x808080, config.getAppFontColorMid());
      config.setAppFontColorDark(0x010101);
      assertEquals("getAppFontColorDark after setAppFontColorDark"
        , 0x010101, config.getAppFontColorDark());
      config.setAppFontColorRand(false);
      assertFalse("getAppFontColorRand after setAppFontColorRand", config.getAppFontColorRand());
      config.setAppFontColorToBackground(false);
      assertFalse("getAppFontColorToBackground after setAppFontColorToBackground"
        , config.getAppFontColorToBackground());
      // the face of the font: its name, its size and the two styles of it
      config.setAppFontFace("FreeSerif");
      assertEquals("getAppFontFace after setAppFontFace", "FreeSerif", config.getAppFontFace());
      config.setAppFontBold(true);
      assertTrue("getAppFontBold after setAppFontBold", config.getAppFontBold());
      config.setAppFontItalic(true);
      assertTrue("getAppFontItalic after setAppFontItalic", config.getAppFontItalic());
      config.setAppFontBold(false);
      config.setAppFontItalic(false);
      // the framework asks for a calculated font size, so a fresh instance keeps the zero
      // marker of that calculation and the texts of it take the size of the stage
      assertEquals("getAppFontSize of a fresh instance", 0, config.getAppFontSize());
      assertEquals("the size of the texts of a fresh instance is the one of the stage"
        , application.calcFontSizeFromStageSize(), int(config.getTextFormatBright().size));
      // and the running application follows every size of its stage: this framework asks
      // for a calculated font size, so the texts of it stand on the calculated one here
      assertEquals("getAppFontSize of the running application", 0
        , application.getDynamicsConfig().getAppFontSize());
      assertEquals("the size of the texts of the running application is the one of its stage"
        , application.calcFontSizeFromStageSize()
        , int(application.getDynamicsConfig().getTextFormatBright().size));
      // the size of the font drives the height of a text field, so that one follows it
      config.setAppFontSize(16);
      assertEquals("getAppFontSize after setAppFontSize", 16, config.getAppFontSize());
      const heightOfSize16:int = config.getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      assertTrue("the height of a text field of the size 16 is a positive one", heightOfSize16 > 0);
      // setAllFontSizes writes the three text formats and the heights coming from them, and
      // it leaves the font size of the application alone: that property is only moved by
      // setAppFontSize, which calls this one to follow it
      config.setAllFontSizes(32);
      assertTrue("a text field of the size 32 is taller than one of the size 16"
        , config.getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) > heightOfSize16);
      assertEquals("getAppFontSize is not changed by setAllFontSizes", 16, config.getAppFontSize());
      // the zero font size is the marker of the calculated one: it is kept as it is, and
      // the texts take the size belonging to the current size of the stage again
      config.setAppFontSize(0);
      assertEquals("getAppFontSize after setAppFontSize with a zero", 0, config.getAppFontSize());
      assertEquals("the size of the texts of a zero font size is the one of the stage"
        , application.calcFontSizeFromStageSize(), int(config.getTextFormatBright().size));
      config.setAppFontSize(16);
      // every text type has a height and a correction of its own
      assertTrue("the height of a bright text field is a positive one"
        , config.getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) > 0);
      assertTrue("the height of a mid text field is a positive one"
        , config.getTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID()) > 0);
      assertTrue("the height of a dark text field is a positive one"
        , config.getTextFieldHeight(EnumTextTypes.TEXT_TYPE_DARK()) > 0);
      assertTrue("the height of a text field of the default type is a positive one"
        , config.getTextFieldHeight() > 0);
      config.getTextFieldHeightCorrection(EnumTextTypes.TEXT_TYPE_BRIGHT());
      config.getTextFieldHeightCorrection();
      // the three formats of the texts are built together with the face of the font
      assertNotNull("getTextFormatBright gives a value", config.getTextFormatBright());
      assertNotNull("getTextFormatMid gives a value", config.getTextFormatMid());
      assertNotNull("getTextFormatDark gives a value", config.getTextFormatDark());
      // the orientation and the widget mode are enumerated values, and the mode decides
      // whether the application stands in the desktop mode at the moment
      assertNotNull("getAppOrientation gives a value", config.getAppOrientation());
      config.setAppOrientation(config.getAppOrientation());
      config.setAppWidgetMode(EnumWidgetModes.WIDGET_MODE_DESKTOP());
      assertEquals("getAppWidgetMode after setAppWidgetMode"
        , EnumWidgetModes.WIDGET_MODE_DESKTOP(), config.getAppWidgetMode());
      assertTrue("weAreInDesktopMode in the desktop widget mode", config.weAreInDesktopMode());
      config.setAppWidgetMode(EnumWidgetModes.WIDGET_MODE_MOBILE());
      assertFalse("weAreInDesktopMode in the mobile widget mode", config.weAreInDesktopMode());
      // the displaying style this instance has started in
      assertNotNull("getCurrentDisplayingStyle gives a value", config.getCurrentDisplayingStyle());
      // every style the panel of the settings offers has to be a style this config really
      // holds: a key of the label manager with no style behind it would silently fall back
      // to the default one as soon as it was picked
      const offeredStyles:Array = application.getLabelManager().getKeysDisplayingStyles();
      assertTrue("the label manager offers displaying styles at all", offeredStyles.length > 0);
      for (var i:int = 0; i < offeredStyles.length; i++)
      {
        assertTrue("hasDisplayingStyle of the offered style " + offeredStyles[i]
          , config.hasDisplayingStyle(String(offeredStyles[i])));
      }
      assertFalse("hasDisplayingStyle of a style this config does not hold"
        , config.hasDisplayingStyle("[UT_UNKNOWN_DISPLAYING_STYLE]"));
      offeredStyles.splice(0);
      // the style of the start displays the embedded background, so it has no file name
      assertEquals("getAppBackgroundImageFile of the style of the start", "", config.getAppBackgroundImageFile());
      // a style of this suite is built, switched to and read back property by property. It
      // is registered with an empty background file on purpose: such a style draws an empty
      // bitmap instead of loading an image, so this suite stays off the network
      const styleKey:String = "[UT_DISPLAYING_STYLE]";
      // the assertions above have written their own values into the style of the start, so
      // the way back to it is checked against a value read from it and not against a literal
      const lineThicknessOfTheStartStyle:int = config.getAppLineThickness();
      config.addDisplayingStyle(styleKey, "");
      config.setDisplayingStyleColors(styleKey, "102030", "405060", "708090", "A0B0C0", "D0E0F0", "010203");
      config.setDisplayingStyleShaping(styleKey, EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC(), 6
        , EnumBoxFrames.BOX_FRAME_VERTICAL(), 4, 7, 15);
      config.setCurrentDisplayingStyle(styleKey);
      assertEquals("getCurrentDisplayingStyle after setCurrentDisplayingStyle", styleKey, config.getCurrentDisplayingStyle());
      assertEquals("getAppBackgroundAlign of the style of this suite"
        , EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC(), config.getAppBackgroundAlign());
      assertEquals("getAppBackgroundBlur of the style of this suite", 6, config.getAppBackgroundBlur());
      assertEquals("getAppBoxFrame of the style of this suite"
        , EnumBoxFrames.BOX_FRAME_VERTICAL(), config.getAppBoxFrame());
      assertEquals("getAppLineThickness of the style of this suite", 4, config.getAppLineThickness());
      assertEquals("getAppRadius of the style of this suite", 7, config.getAppRadius());
      assertEquals("getAppBoxCorner of the style of this suite", 15, config.getAppBoxCorner());
      assertEquals("getAppBackgroundColorDark of the style of this suite", 0x102030, config.getAppBackgroundColorDark());
      assertEquals("getAppBackgroundColorMid of the style of this suite", 0x405060, config.getAppBackgroundColorMid());
      assertEquals("getAppBackgroundColorBright of the style of this suite", 0x708090, config.getAppBackgroundColorBright());
      assertEquals("getAppFontColorBright of the style of this suite", 0xA0B0C0, config.getAppFontColorBright());
      assertEquals("getAppFontColorMid of the style of this suite", 0xD0E0F0, config.getAppFontColorMid());
      assertEquals("getAppFontColorDark of the style of this suite", 0x010203, config.getAppFontColorDark());
      assertEquals("getAppBackgroundImageFile of a style with no background file", "", config.getAppBackgroundImageFile());
      // the settings of the application write the values of the current style one by one,
      // so the style itself carries the changed values and not the described ones any more:
      // the resetting is the one way back to the very values that style is described with
      config.setAppRadius(21);
      config.setAppBoxCorner(23);
      config.setAppBackgroundBlur(2);
      assertEquals("getAppRadius after it has been changed by hand", 21, config.getAppRadius());
      assertEquals("getAppBoxCorner after it has been changed by hand", 23, config.getAppBoxCorner());
      assertEquals("getAppBackgroundBlur after it has been changed by hand", 2, config.getAppBackgroundBlur());
      config.resetCurrentDisplayingStyle();
      assertEquals("getAppRadius after resetCurrentDisplayingStyle", 7, config.getAppRadius());
      assertEquals("getAppBoxCorner after resetCurrentDisplayingStyle", 15, config.getAppBoxCorner());
      assertEquals("getAppBackgroundBlur after resetCurrentDisplayingStyle", 6, config.getAppBackgroundBlur());
      assertEquals("getCurrentDisplayingStyle after resetCurrentDisplayingStyle", styleKey, config.getCurrentDisplayingStyle());
      // a style this config does not know at all is refused by every one of those three,
      // and switching to it falls back to the default style instead
      const missingStyleKey:String = "[UT_MISSING_DISPLAYING_STYLE]";
      config.setDisplayingStyleColors(missingStyleKey, "000000", "000000", "000000", "000000", "000000", "000000");
      config.setDisplayingStyleShaping(missingStyleKey, EnumBackgroundAligns.BACKGROUND_ALIGN_NONE(), 0
        , EnumBoxFrames.BOX_FRAME_NONE(), 0, 0, 0);
      config.setCurrentDisplayingStyle(missingStyleKey);
      assertEquals("getCurrentDisplayingStyle after switching to an unknown style"
        , EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT(), config.getCurrentDisplayingStyle());
      assertEquals("getAppLineThickness is the one of the style of the start again"
        , lineThicknessOfTheStartStyle, config.getAppLineThickness());
      config.resetDisplayingStyleOf(missingStyleKey);
      assertEquals("getAppLineThickness after resetDisplayingStyleOf of an unknown style"
        , lineThicknessOfTheStartStyle, config.getAppLineThickness());
      // the default style takes its own default values back as well, so the way out of an
      // unreadable appearance works even when that style is the current one already. The
      // first call is the one giving those default values, the second one is the assertion
      config.setDefaultDisplayingStyle();
      assertEquals("getCurrentDisplayingStyle after setDefaultDisplayingStyle"
        , EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT(), config.getCurrentDisplayingStyle());
      const radiusOfTheDefaultStyle:int = config.getAppRadius();
      config.setAppRadius(radiusOfTheDefaultStyle + 5);
      assertEquals("getAppRadius of the default style after it has been changed by hand"
        , radiusOfTheDefaultStyle + 5, config.getAppRadius());
      config.setDefaultDisplayingStyle();
      assertEquals("getAppRadius after setDefaultDisplayingStyle", radiusOfTheDefaultStyle, config.getAppRadius());
      // the bitmap data of the background is only drawn when a background is asked for
      config.getBitmapData();
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
