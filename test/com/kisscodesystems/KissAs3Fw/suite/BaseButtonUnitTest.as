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
 * BaseButtonUnitTest
 * Checks the BaseButton of the framework.
 *
 * MAIN FEATURES:
 * - only the three button states of the enum are taken, everything else is dropped
 * - the state of a fresh button is the default one
 * - it is a BaseShape, so it is drawn in the colors and dimensions of one
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseButton;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseButtonStates;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseButtonUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseButtonUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseButton";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseButton:BaseButton = new BaseButton(application);
      application.addChild(baseButton);
      // a fresh button stands in no state at all: nothing of it is painted until it is
      // given the first one, so the default state is a change to it as well
      assertEquals("getState of a fresh BaseButton", -1, baseButton.getState());
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
      assertEquals("getState of the first state given"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT(), baseButton.getState());
      // every one of the three states can be taken
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED());
      assertEquals("getState after the highlighted one"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED(), baseButton.getState());
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED());
      assertEquals("getState after the pushed one"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED(), baseButton.getState());
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
      assertEquals("getState after the default one"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT(), baseButton.getState());
      // a state that does not exist is dropped
      baseButton.setState(4711);
      assertEquals("a state that does not exist is dropped"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT(), baseButton.getState());
      // the very same state changes nothing
      baseButton.setState(EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT());
      assertEquals("the very same state is kept"
        , EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT(), baseButton.getState());
      // it is a BaseShape as well, so it takes the dimensions of one
      baseButton.setDwh(160, 40);
      assertEquals("getDw after setDwh", expectedDw(160), baseButton.getDw());
      assertEquals("getDh after setDwh", expectedDh(40), baseButton.getDh());
      baseButton.drawRect();
      assertTrue("the drawn BaseButton has a width", baseButton.width > 0);
      baseButton.destroy();
      if (application.contains(baseButton))
      {
        application.removeChild(baseButton);
      }
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
