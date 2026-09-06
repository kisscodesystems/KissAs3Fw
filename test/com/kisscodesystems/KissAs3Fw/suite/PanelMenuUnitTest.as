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
 * PanelMenuUnitTest
 * Checks the PanelMenu of the framework.
 *
 * MAIN FEATURES:
 * - the menu itself comes from the xml of the application
 * - the panel can be opened, closed, enabled and disabled
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.PanelMenu;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class PanelMenuUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function PanelMenuUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "PanelMenu";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const panelMenu:PanelMenu = new PanelMenu(application);
      addTested(panelMenu);
      panelMenu.setDwh(400, 500);
      assertEquals("getDw after setDwh", expectedDw(400), panelMenu.getDw());
      assertEquals("getDh after setDwh", expectedDh(500), panelMenu.getDh());
      // a fresh panel is a closed one, the open and the close switch it
      assertFalse("the visible of a fresh PanelMenu", panelMenu.visible);
      panelMenu.open();
      assertTrue("the visible after the open", panelMenu.visible);
      panelMenu.close();
      assertFalse("the visible after the close", panelMenu.visible);
      // nothing is picked from the menu of an application that has no menu xml at all
      panelMenu.updateMenuxml();
      assertEquals("getSelectedItem of a fresh PanelMenu", "", panelMenu.getSelectedItem());
      // the enabled state reaches every element standing on this panel
      panelMenu.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", panelMenu.getEnabled());
      panelMenu.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", panelMenu.getEnabled());
      runBaseSpriteTests(panelMenu);
      removeTested(panelMenu);
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
