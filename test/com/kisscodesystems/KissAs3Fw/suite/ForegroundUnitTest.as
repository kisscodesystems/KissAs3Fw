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
 * - an alert without an ok button carries no answer at all, so nothing but a closeAlert
 *   of the unique string of it takes it away
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
      // an alert without a message displays nothing at all
      foreground.createAlert(null, "uniqueNoMessage", true, false);
      assertFalse("the visible after an alert without a message", foreground.visible);
      // an alert without an ok button is displayed just the same, it carries no answer at
      // all: nothing but a closeAlert of the unique string of it takes it away. That is
      // the alert of a long work, see the runWithLoading of the application
      foreground.createAlert("nothing", "uniqueNoButton", false, false);
      assertTrue("the visible after an alert without an ok button", foreground.visible);
      foreground.closeAlert("uniqueNoButton");
      assertFalse("the visible after closing the alert without an ok button", foreground.visible);
      // an alert with an ok button is displayed
      foreground.createAlert(EnumOkCancel.OC_OK(), "uniqueAlert", true, false);
      assertTrue("the visible after an alert", foreground.visible);
      // a confirm has a cancel button as well, and it can be the active one right away
      foreground.createAlert(EnumOkCancel.OC_CANCEL(), "uniqueConfirm", true, true, true, false);
      assertTrue("the visible after a confirm", foreground.visible);
      // closing an alert that is not there leaves everything as it is
      foreground.closeAlert("uniqueNoMessage");
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
      // a work that cannot be covered is done right away instead of being lost: this test
      // application builds no layer at all, so there is no foreground of it to display the
      // alert of that work on
      var workIsDone:Boolean = false;
      application.runWithLoading(function():void
      {
        workIsDone = true;
      });
      assertTrue("a work that cannot be covered is done right away", workIsDone);
      // a work that is not there at all is answered without an error and does nothing
      workIsDone = false;
      application.runWithLoading(null);
      assertFalse("a work that is not there at all does nothing", workIsDone);
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
