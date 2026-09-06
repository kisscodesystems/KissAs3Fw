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
 * PotmeterUnitTest
 * Checks the Potmeter component.
 *
 * MAIN FEATURES:
 * - the range is only taken when the difference of it is a multiply of the increment, and
 *   the three getters of it answer the one that is in force
 * - a value out of the range is dropped
 * - the value is rounded to the current decimal precision
 * - the changed event is dispatched on a real change only
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class PotmeterUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function PotmeterUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Potmeter";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const potmeter:Potmeter = new Potmeter(application);
      addTested(potmeter);
      potmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), potmeterChanged);
      // a fresh potmeter holds the zero and two decimals
      assertEqualsNumber("getCurValue of a fresh Potmeter", 0, potmeter.getCurValue());
      assertEquals("getDecimalPrecision of a fresh Potmeter", 2, potmeter.getDecimalPrecision());
      assertEqualsNumber("getMinValue of a fresh Potmeter", 0, potmeter.getMinValue());
      assertEqualsNumber("getMaxValue of a fresh Potmeter", 0, potmeter.getMaxValue());
      assertEqualsNumber("getIncValue of a fresh Potmeter", 0, potmeter.getIncValue());
      assertTrue("a fresh Potmeter is as wide as its label", potmeter.getDw() > 0);
      // the range is taken and the value can be set inside it
      potmeter.setMinMaxIncValues(0, 10, 1);
      assertEqualsNumber("getMinValue after setMinMaxIncValues(0, 10, 1)", 0, potmeter.getMinValue());
      assertEqualsNumber("getMaxValue after setMinMaxIncValues(0, 10, 1)", 10, potmeter.getMaxValue());
      assertEqualsNumber("getIncValue after setMinMaxIncValues(0, 10, 1)", 1, potmeter.getIncValue());
      potmeter.setCurValue(5);
      assertEqualsNumber("getCurValue after setCurValue(5)", 5, potmeter.getCurValue());
      assertEquals("one changed event after a real change", 1, changedCount);
      // the very same value changes nothing
      potmeter.setCurValue(5);
      assertEquals("no changed event without a real change", 1, changedCount);
      // a silent value is displayed without a changed event of it
      potmeter.setCurValue(6, false);
      assertEqualsNumber("getCurValue after a silent setCurValue(6)", 6, potmeter.getCurValue());
      assertEquals("no changed event after a silent setCurValue", 1, changedCount);
      potmeter.setCurValue(5, false);
      // a value out of the range is dropped
      potmeter.setCurValue(11);
      assertEqualsNumber("getCurValue after a value above the maximum", 5, potmeter.getCurValue());
      potmeter.setCurValue(-1);
      assertEqualsNumber("getCurValue after a value below the minimum", 5, potmeter.getCurValue());
      assertEquals("a dropped value dispatches no changed event", 1, changedCount);
      // a range whose difference is not a multiply of the increment is dropped
      potmeter.setMinMaxIncValues(0, 10, 3);
      assertEqualsNumber("getIncValue after a range that can not be stepped through", 1, potmeter.getIncValue());
      potmeter.setCurValue(9.5);
      assertEqualsNumber("getCurValue after setCurValue(9.5)", 9.5, potmeter.getCurValue());
      // an inverted range is dropped as well
      potmeter.setMinMaxIncValues(10, 0, 1);
      assertEqualsNumber("getMinValue after an inverted range", 0, potmeter.getMinValue());
      assertEqualsNumber("getMaxValue after an inverted range", 10, potmeter.getMaxValue());
      potmeter.setCurValue(10);
      assertEqualsNumber("getCurValue after the maximum of the kept range", 10, potmeter.getCurValue());
      // the decimal precision rounds the value that arrives from now
      potmeter.setDecimalPrecision(1);
      assertEquals("getDecimalPrecision after setDecimalPrecision(1)", 1, potmeter.getDecimalPrecision());
      potmeter.setCurValue(3.14);
      assertEqualsNumber("getCurValue rounded to one decimal", 3.1, potmeter.getCurValue());
      // only a precision between zero and ten is taken
      potmeter.setDecimalPrecision(-1);
      assertEquals("getDecimalPrecision after a negative precision", 1, potmeter.getDecimalPrecision());
      potmeter.setDecimalPrecision(11);
      assertEquals("getDecimalPrecision after a precision above ten", 1, potmeter.getDecimalPrecision());
      potmeter.setDecimalPrecision(0);
      potmeter.setCurValue(3.6);
      assertEqualsNumber("getCurValue rounded to no decimals", 4, potmeter.getCurValue());
      // the dimensions come from the label and the padding, so the setters do nothing
      const dwBefore:int = potmeter.getDw();
      const dhBefore:int = potmeter.getDh();
      potmeter.setDw(500);
      potmeter.setDh(500);
      potmeter.setDwh(500, 500);
      assertEquals("setDw, setDh and setDwh do not change the width", dwBefore, potmeter.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", dhBefore, potmeter.getDh());
      runBaseSpriteTests(potmeter);
      potmeter.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), potmeterChanged);
      removeTested(potmeter);
    }
    /**
     * Counts the changed events of the tested potmeter.
     * @param e the changed event
     */
    private function potmeterChanged(e:Event):void
    {
      changedCount++;
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
      changedCount = 0;
    }
  }
}
