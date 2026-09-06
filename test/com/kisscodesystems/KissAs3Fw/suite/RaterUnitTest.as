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
 * RaterUnitTest
 * Checks the Rater component.
 *
 * MAIN FEATURES:
 * - the rate can be set and read back, a half rate as well
 * - the readonly state can be set and read back
 * - the dimensions come from the number and the size of the stars
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.Rater;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class RaterUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function RaterUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Rater";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const rater:Rater = new Rater(application);
      addTested(rater);
      // a fresh rater displays nothing and can not be clicked
      assertEqualsNumber("getRate of a fresh Rater", 0, rater.getRate());
      assertTrue("getReadonly of a fresh Rater", rater.getReadonly());
      // the dimensions hold as many stars as the config asks for
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const starsw:int = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID());
      const numOfStars:int = application.getComponentsConfig().getRaterNumOfStars();
      assertEquals("getDw of a fresh Rater", 2 * padding + numOfStars * starsw, rater.getDw());
      assertEquals("getDh of a fresh Rater", 2 * padding + starsw, rater.getDh());
      // the rate can be set, a half star as well
      rater.setRate(3);
      assertEqualsNumber("getRate after setRate(3)", 3, rater.getRate());
      rater.setRate(2.5);
      assertEqualsNumber("getRate after setRate(2.5)", 2.5, rater.getRate());
      // the readonly state can be dropped and taken back
      rater.setReadonly(false);
      assertFalse("getReadonly after setReadonly(false)", rater.getReadonly());
      rater.setReadonly(true);
      assertTrue("getReadonly after setReadonly(true)", rater.getReadonly());
      // the dimensions come from the stars, so the setters do nothing
      const dwBefore:int = rater.getDw();
      const dhBefore:int = rater.getDh();
      rater.setDw(500);
      rater.setDh(500);
      rater.setDwh(500, 500);
      assertEquals("setDw, setDh and setDwh do not change the width", dwBefore, rater.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", dhBefore, rater.getDh());
      runBaseSpriteTests(rater);
      removeTested(rater);
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
