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
 * PanelSettingsUnitTest
 * Checks the PanelSettings of the framework.
 *
 * MAIN FEATURES:
 * - the seven contents of the panel are built with every element on them
 * - three of those contents stand on the button bar and the four ones describing the
 *   appearance are hidden from it, reachable by their text keys only
 * - the lists of the languages, of the displaying styles and of the font faces
 *   can be reloaded at any time
 * - the background image handler of the extender applications can be added to it
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.PanelSettings;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class PanelSettingsUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function PanelSettingsUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "PanelSettings";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const panelSettings:PanelSettings = new PanelSettings(application);
      addTested(panelSettings);
      panelSettings.setDwh(600, 500);
      assertEquals("getDw after setDwh", expectedDw(600), panelSettings.getDw());
      assertEquals("getDh after setDwh", expectedDh(500), panelSettings.getDh());
      panelSettings.setDw(500);
      assertEquals("getDw after setDw", expectedDw(500), panelSettings.getDw());
      // a fresh panel is a closed one, the open and the close switch it
      assertFalse("the visible of a fresh PanelSettings", panelSettings.visible);
      panelSettings.open();
      assertTrue("the visible after the open", panelSettings.visible);
      panelSettings.close();
      assertFalse("the visible after the close", panelSettings.visible);
      // the settings, the appearance and the about contents stand on the button bar, and
      // the four contents of the appearance are hidden from it
      assertEquals("getNumOfContents of the panel", 7, panelSettings.getNumOfContents());
      assertEquals("the settings content is the displayed one at the beginning"
        , 0, panelSettings.getActiveContentIndex());
      assertTrue("the button of the settings content"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_SETTINGS()));
      assertTrue("the button of the appearance content"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_APPEARANCE()));
      assertTrue("the button of the about content"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_ABOUT()));
      assertFalse("the lines and spacing content is hidden from the button bar"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_LINING()));
      assertFalse("the colors content is hidden from the button bar"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_COLORING()));
      assertFalse("the background image content is hidden from the button bar"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_IMAGING()));
      assertFalse("the fonts content is hidden from the button bar"
        , panelSettings.getContentButtonVisible(EnumTextKeys.SETTINGS_PANEL_FONTING()));
      assertFalse("getContentButtonVisible of a text key of no content of this panel"
        , panelSettings.getContentButtonVisible(EnumTextKeys.YN_YES()));
      // a hidden content is displayed by its own text key, and that is the only way to it
      panelSettings.showContent(EnumTextKeys.SETTINGS_PANEL_COLORING());
      assertEquals("the colors content after showContent", 4, panelSettings.getActiveContentIndex());
      panelSettings.showContent(EnumTextKeys.SETTINGS_PANEL_FONTING());
      assertEquals("the fonts content after showContent", 6, panelSettings.getActiveContentIndex());
      panelSettings.showContent(EnumTextKeys.YN_YES());
      assertEquals("a text key of no content displays nothing new"
        , 6, panelSettings.getActiveContentIndex());
      panelSettings.showContent(EnumTextKeys.SETTINGS_PANEL_SETTINGS());
      assertEquals("the settings content is back", 0, panelSettings.getActiveContentIndex());
      // the picked displaying style is one of the ones the application knows
      assertTrue("the picked displaying style is a known one"
        , application.getLabelManager().getKeysDisplayingStyles()
          .indexOf(panelSettings.getSelectedDisplayingStyleValue()) > -1);
      // the widget container of the index zero is the active one at the beginning
      assertEquals("getActiveWidgetContainer of a fresh PanelSettings", 0, panelSettings.getActiveWidgetContainer());
      panelSettings.setActiveWidgetContainer(0);
      assertEquals("getActiveWidgetContainer after setActiveWidgetContainer(0)"
        , 0, panelSettings.getActiveWidgetContainer());
      panelSettings.showWidgetContainer(0);
      assertEquals("getActiveWidgetContainer after showWidgetContainer(0)"
        , 0, panelSettings.getActiveWidgetContainer());
      // the lists of this panel can be reloaded at any time, and a reload keeps every
      // current value of the application: it is not a value picked by the one using it
      const styleBefore:String = application.getDynamicsConfig().getCurrentDisplayingStyle();
      const langBefore:String = application.getLabelManager().getLang();
      const fontFaceBefore:String = application.getDynamicsConfig().getAppFontFace();
      panelSettings.updateLangCodes();
      panelSettings.updateDisplayingStyles();
      panelSettings.updateFontFaces();
      panelSettings.refreshAbout();
      assertEquals("the displaying style after updateDisplayingStyles"
        , styleBefore, application.getDynamicsConfig().getCurrentDisplayingStyle());
      assertEquals("the language after updateLangCodes", langBefore, application.getLabelManager().getLang());
      assertEquals("the font face after updateFontFaces"
        , fontFaceBefore, application.getDynamicsConfig().getAppFontFace());
      assertEquals("the picked displaying style after updateDisplayingStyles"
        , styleBefore, panelSettings.getSelectedDisplayingStyleValue());
      // the language of the application can be set through this panel
      panelSettings.setLangCode(application.getLabelManager().getLang());
      assertEquals("the language after setLangCode", langBefore, application.getLabelManager().getLang());
      // the background image handler of the extender applications
      assertNull("getUserBgHandler of a fresh PanelSettings", panelSettings.getUserBgHandler());
      const userBgHandler:BaseSprite = new BaseSprite(application);
      panelSettings.addUserBgHandler(userBgHandler);
      assertEquals("getUserBgHandler after addUserBgHandler", userBgHandler, panelSettings.getUserBgHandler());
      panelSettings.setUserBgHandlerVisible(false);
      assertFalse("the visible of the hidden user background handler", userBgHandler.visible);
      panelSettings.setUserBgHandlerVisible(true);
      assertTrue("the visible of the shown user background handler", userBgHandler.visible);
      // the enabled state reaches every element standing on this panel
      panelSettings.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", panelSettings.getEnabled());
      panelSettings.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", panelSettings.getEnabled());
      runBaseSpriteTests(panelSettings);
      removeTested(panelSettings);
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
