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
 * BasePanelUnitTest
 * Checks the BasePanel of the framework.
 *
 * MAIN FEATURES:
 * - a fresh panel is closed, the open and the close switch it
 * - the closing dispatches the closed event
 * - the content of the panel follows the dimensions of it
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BasePanel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class BasePanelUnitTest extends BaseUnitTest
  {
    // it turns true when the panel has dispatched its closed event
    private var closedArrived:Boolean = false;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BasePanelUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BasePanel";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      closedArrived = false;
      const basePanel:BasePanel = new BasePanel(application);
      addTested(basePanel);
      // a fresh panel is a closed one
      assertFalse("the visible of a fresh BasePanel", basePanel.visible);
      // the default content can be asked for
      basePanel.setDefaultContent();
      // the dimensions reach the content of the panel
      basePanel.setDwh(400, 300);
      assertEquals("getDw after setDwh", expectedDw(400), basePanel.getDw());
      assertEquals("getDh after setDwh", expectedDh(300), basePanel.getDh());
      basePanel.setDw(500);
      assertEquals("getDw after setDw", expectedDw(500), basePanel.getDw());
      basePanel.setDh(350);
      assertEquals("getDh after setDh", expectedDh(350), basePanel.getDh());
      // the open makes it visible
      basePanel.open();
      assertTrue("the visible after the open", basePanel.visible);
      // the close hides it and tells everybody about it
      basePanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), panelClosed);
      basePanel.close();
      assertFalse("the visible after the close", basePanel.visible);
      assertTrue("the closed event of the close", closedArrived);
      // the enabled state reaches the content of the panel as well: the button bar
      // switching between the pages of that content is a clickable object
      basePanel.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", basePanel.getEnabled());
      basePanel.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", basePanel.getEnabled());
      runBaseSpriteTests(basePanel);
      removeTested(basePanel);
    }
    /**
     * The panel has dispatched its closed event.
     * @param e the closed event of the panel
     */
    private function panelClosed(e:Event):void
    {
      closedArrived = true;
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
      closedArrived = false;
    }
  }
}
