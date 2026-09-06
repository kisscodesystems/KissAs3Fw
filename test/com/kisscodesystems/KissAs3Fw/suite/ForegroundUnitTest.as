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
 * ForegroundUnitTest
 * Checks the Foreground of the framework.
 *
 * MAIN FEATURES:
 * - a fresh foreground is invisible and it holds nothing
 * - an alert makes it visible, and closing every alert hides it again
 * - the answers of an alert arrive on the dispatcher of the application
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Foreground;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ForegroundUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ForegroundUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Foreground";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const foreground:Foreground = new Foreground(application);
      addTested(foreground);
      foreground.setDwh(800, 600);
      assertEquals("getDw after setDwh", expectedDw(800), foreground.getDw());
      assertEquals("getDh after setDwh", expectedDh(600), foreground.getDh());
      // a fresh foreground holds nothing, so it is invisible
      assertFalse("the visible of a fresh Foreground", foreground.visible);
      // an alert without an ok button displays nothing at all
      foreground.createAlert("nothing", "uniqueNothing", false, false);
      assertFalse("the visible after an alert without an ok button", foreground.visible);
      // an alert with an ok button is displayed
      foreground.createAlert(EnumOkCancel.OC_OK(), "uniqueAlert", true, false);
      assertTrue("the visible after an alert", foreground.visible);
      // a confirm has a cancel button as well, and it can be the active one right away
      foreground.createAlert(EnumOkCancel.OC_CANCEL(), "uniqueConfirm", true, true, true, false);
      assertTrue("the visible after a confirm", foreground.visible);
      // closing an alert that is not there leaves everything as it is
      foreground.closeAlert("uniqueNothing");
      assertTrue("the visible after closing an alert that is not there", foreground.visible);
      // closing every alert hides this object again
      foreground.closeAlert("uniqueAlert");
      foreground.closeAlert("uniqueConfirm");
      assertFalse("the visible after closing every alert", foreground.visible);
      // a fullscreen alert fills the whole foreground
      foreground.createAlert(EnumOkCancel.OC_OK(), "uniqueFullscreen", true, false, false, true);
      assertTrue("the visible after a fullscreen alert", foreground.visible);
      foreground.closeAlert("uniqueFullscreen");
      assertFalse("the visible after closing the fullscreen alert", foreground.visible);
      // the lists need the widgets of the middleground, and there is none of it here,
      // so these calls have to be answered without an error
      foreground.createWidgetsList();
      foreground.closeWidgetsList();
      foreground.createContentsList(null);
      foreground.closeContentsList();
      assertFalse("the visible after the lists without a middleground", foreground.visible);
      runBaseSpriteTests(foreground);
      removeTested(foreground);
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
