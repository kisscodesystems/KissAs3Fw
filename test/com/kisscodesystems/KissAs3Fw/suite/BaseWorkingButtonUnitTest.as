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
 * BaseWorkingButtonUnitTest
 * Checks the BaseWorkingButton of the framework.
 *
 * MAIN FEATURES:
 * - the content sprite is the one the elements of the button are put into
 * - the button layer of it can be hidden while the content of it stays visible
 * - the roll out can be performed from the outside
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseWorkingButton;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseWorkingButtonUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseWorkingButtonUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseWorkingButton";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const button:BaseWorkingButton = new BaseWorkingButton(application);
      addTested(button);
      // the content sprite is there from the very beginning, the elements go into it
      assertNotNull("getContentSprite of a fresh BaseWorkingButton", button.getContentSprite());
      // the dimensions reach the content sprite as well
      button.setDwh(200, 60);
      assertEquals("getDw after setDwh", expectedDw(200), button.getDw());
      assertEquals("getDh after setDwh", expectedDh(60), button.getDh());
      button.setDw(240);
      assertEquals("getDw after setDw", expectedDw(240), button.getDw());
      button.setDh(80);
      assertEquals("getDh after setDh", expectedDh(80), button.getDh());
      // the button layer can be hidden while the content of it stays where it is
      button.setBaseWorkingButtonVisible(false);
      button.setBaseWorkingButtonVisible(true);
      assertNotNull("the content sprite survives the hiding", button.getContentSprite());
      // the event this button dispatches on a click can be replaced by a custom one
      button.setCustomEventString(EnumEvents.EVENT_CHANGED());
      button.setCustomEventString(null);
      // the roll out can be performed from the outside, it only clears the hovering
      button.onRollOut();
      runBaseSpriteTests(button);
      removeTested(button);
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
