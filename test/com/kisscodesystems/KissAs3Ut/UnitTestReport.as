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
 * UnitTestReport
 * Collects the results of the unit test suites and formats them into one report.
 *
 * MAIN FEATURES:
 * - one line per assertion, grouped by suite
 * - counts the suites, the passed and the failed assertions
 * - keeps the failed lines apart as well: the test application displays those on the
 *   screen, where the whole report would not fit
 * - the failed count is the exit code of the test application
 */
package com.kisscodesystems.KissAs3Ut
{
  public class UnitTestReport
  {
    private var linesArray:Array = null;
    private var failedLinesArray:Array = null;
    private var currentSuite:String = "";
    private var suites:int = 0;
    private var passed:int = 0;
    private var failed:int = 0;
    /**
     * Constructs the report with an empty line list.
     */
    public function UnitTestReport():void
    {
      linesArray = new Array();
      failedLinesArray = new Array();
    }
    /**
     * Opens a new suite block in the report.
     * @param suiteName the name of the suite the following assertions belong to
     */
    public function startSuite(suiteName:String):void
    {
      currentSuite = suiteName;
      suites++;
      linesArray.push(suiteName);
    }
    /**
     * Records a passed assertion.
     * @param what the description of the assertion
     */
    public function addPassed(what:String):void
    {
      passed++;
      linesArray.push("  ok    " + what);
    }
    /**
     * Records a failed assertion.
     * @param what the description of the assertion
     * @param expected the expected value
     * @param actual the value that has been found
     */
    public function addFailed(what:String, expected:String, actual:String):void
    {
      failed++;
      const line:String = "  FAIL  " + what + ": expected [" + expected + "] but was [" + actual + "]";
      linesArray.push(line);
      // the suite is named in the failed line as well: this one is displayed on its own,
      // out of the report the suite blocks group the lines in
      failedLinesArray.push(currentSuite + " |" + line);
    }
    /**
     * Returns the number of the suites the assertions of this report belong to.
     */
    public function getSuites():int
    {
      return suites;
    }
    /**
     * Returns the number of the passed assertions.
     */
    public function getPassed():int
    {
      return passed;
    }
    /**
     * Returns the number of the failed assertions.
     */
    public function getFailed():int
    {
      return failed;
    }
    /**
     * Returns the failed lines of this report, every one of them naming the suite it
     * comes from. It is an empty text when every assertion has passed.
     */
    public function getFailedLines():String
    {
      return failedLinesArray.join("\n");
    }
    /**
     * Returns the whole report with the summary line at its end.
     */
    public function getReport():String
    {
      return linesArray.join("\n")
        + "\n"
        + (passed + failed) + " assertions, " + passed + " passed, " + failed + " failed"
        + "\n";
    }
    /**
     * Frees everything this report holds.
     */
    public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      linesArray.splice(0);
      failedLinesArray.splice(0);
      // 3: call the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      linesArray = null;
      failedLinesArray = null;
      currentSuite = null;
      suites = 0;
      passed = 0;
      failed = 0;
    }
  }
}
