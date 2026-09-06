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
 * BaseOpenUnitTest
 * Checks the BaseOpen of the framework, the base of every component that opens.
 *
 * MAIN FEATURES:
 * - a fresh object is a closed one and it can be opened and closed again
 * - the opening and the closing swap the button and the content of it
 * - a disabled object follows the enabled state of the button inside it
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseOpen;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseOpenUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseOpenUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseOpen";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseOpen:BaseOpen = new BaseOpen(application);
      addTested(baseOpen);
      // a fresh object is a closed one
      assertFalse("isOpened of a fresh BaseOpen", baseOpen.isOpened());
      // the dimensions are taken and handed to the elements inside
      baseOpen.setDwh(240, 120);
      assertEquals("getDw after setDwh", expectedDw(240), baseOpen.getDw());
      assertEquals("getDh after setDwh", expectedDh(120), baseOpen.getDh());
      baseOpen.setDw(260);
      assertEquals("getDw after setDw", expectedDw(260), baseOpen.getDw());
      baseOpen.setDh(140);
      assertEquals("getDh after setDh", expectedDh(140), baseOpen.getDh());
      // it opens and closes
      baseOpen.open();
      assertTrue("isOpened after open", baseOpen.isOpened());
      baseOpen.open();
      assertTrue("an open object stays open after a second open", baseOpen.isOpened());
      baseOpen.close();
      assertFalse("isOpened after close", baseOpen.isOpened());
      baseOpen.close();
      assertFalse("a closed object stays closed after a second close", baseOpen.isOpened());
      // the enabled state reaches the button inside as well
      baseOpen.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", baseOpen.getEnabled());
      baseOpen.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", baseOpen.getEnabled());
      runBaseSpriteTests(baseOpen);
      removeTested(baseOpen);
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
