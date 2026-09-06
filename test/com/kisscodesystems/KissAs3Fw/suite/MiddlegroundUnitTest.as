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
 * MiddlegroundUnitTest
 * Checks the Middleground of the framework.
 *
 * MAIN FEATURES:
 * - the widgets, the watch and the two panels are built by the configuration
 * - the panels can be opened and closed, and the buttons of them follow that
 * - everything asked from the panels is passed on to them
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Middleground;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class MiddlegroundUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function MiddlegroundUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Middleground";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const middleground:Middleground = new Middleground(application);
      addTested(middleground);
      // the widgets are always there, the watch only when it is enabled
      assertNotNull("getWidgets of a fresh Middleground", middleground.getWidgets());
      assertEquals("the widget container of a fresh Middleground", 1, middleground.getWidgets().getNumOfContents());
      if (application.getComponentsConfig().getWatchEnabled())
      {
        assertNotNull("getWatch when the watch is enabled", middleground.getWatch());
      }
      else
      {
        assertNull("getWatch when the watch is disabled", middleground.getWatch());
      }
      // the dimensions reach everything standing on this object
      middleground.setDwh(1024, 768);
      assertEquals("getDw after setDwh", expectedDw(1024), middleground.getDw());
      assertEquals("getDh after setDwh", expectedDh(768), middleground.getDh());
      assertTrue("getWidgetsDh is inside the height of this object"
        , middleground.getWidgetsDh() > 0 && middleground.getWidgetsDh() <= middleground.getDh());
      assertTrue("getPanelWidth is inside the width of this object"
        , middleground.getPanelWidth() > 0 && middleground.getPanelWidth() <= middleground.getDw());
      assertTrue("getPanelMenuHeight is inside the height of this object"
        , middleground.getPanelMenuHeight() > 0 && middleground.getPanelMenuHeight() <= middleground.getDh());
      assertTrue("getPanelSettingsHeight is inside the height of this object"
        , middleground.getPanelSettingsHeight() > 0 && middleground.getPanelSettingsHeight() <= middleground.getDh());
      middleground.middlegroundRePosSize();
      // the name of the application is displayed with and without an icon
      middleground.setApplicationNameWithIcon("");
      middleground.setApplicationNameWithIcon(null);
      // the panels can be opened and closed
      middleground.openPanelMenu();
      middleground.closePanelMenu();
      middleground.openPanelSettings();
      middleground.closePanelSettings();
      middleground.setVisibleButtonTextMenu(true);
      middleground.setVisibleButtonTextSettings(true);
      // everything asked from the panels is passed on to them
      middleground.setLangCode(application.getLabelManager().getLang());
      middleground.updateLangCodes();
      middleground.updateDisplayingStyles();
      middleground.updateMenuxml();
      // the widget containers of the panel of the settings
      assertEquals("getActiveWidgetContainer of a fresh Middleground", 0, middleground.getActiveWidgetContainer());
      middleground.setActiveWidgetContainer(0);
      middleground.showWidgetContainer(0);
      assertEquals("getActiveWidgetContainer after showWidgetContainer(0)"
        , 0, middleground.getActiveWidgetContainer());
      // a widget can be added into a widget container and closed again
      const widget:Widget = new Widget(application);
      middleground.addWidget(0, widget);
      assertEquals("the number of the widgets after addWidget", 1, middleground.getWidgets().getNumOfAllWidgets());
      middleground.closeWidget(widget);
      assertEquals("the number of the widgets after closeWidget", 0, middleground.getWidgets().getNumOfAllWidgets());
      // the background image handler of the extender applications
      assertNull("getUserBgHandler of a fresh Middleground", middleground.getUserBgHandler());
      const userBgHandler:BaseSprite = new BaseSprite(application);
      middleground.addUserBgHandler(userBgHandler);
      assertEquals("getUserBgHandler after addUserBgHandler", userBgHandler, middleground.getUserBgHandler());
      middleground.setUserBgHandlerVisible(false);
      assertFalse("the visible of the hidden user background handler", userBgHandler.visible);
      middleground.setUserBgHandlerVisible(true);
      // this object is hidden while the foreground is displaying something
      middleground.setVisible(false);
      assertFalse("the visible after setVisible(false)", middleground.visible);
      middleground.setVisible(true);
      assertTrue("the visible after setVisible(true)", middleground.visible);
      // the enabled state reaches the buttons of the panels
      middleground.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", middleground.getEnabled());
      middleground.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", middleground.getEnabled());
      runBaseSpriteTests(middleground);
      removeTested(middleground);
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
