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
 * UnitTestRunner
 * Runs the unit test suites of an application and reports the result of that run.
 *
 * MAIN FEATURES:
 * - the suites are run in the order they are handed over, and an error thrown by one of
 *   them is one more failed assertion: every suite after it is still run
 * - an error thrown where no suite can catch it is one more failed assertion as well:
 *   without that the runtime would stop the whole run with a modal dialog nobody is
 *   there to close
 * - the result of every assertion goes into a report file standing next to the descriptor
 *   of the application, so it is found on every operating system the tests are run on
 * - the summary of that run is displayed on the screen as well, so the one starting the
 *   application sees what has happened without reading any file, and the application
 *   quits by itself when that summary has stood there long enough
 * - the text field of that summary is built of flash primitives, the way the Tracer of
 *   the framework is: the components of the framework are the ones under test here, so
 *   the display of the result must not depend on them
 * - the exit code is zero when every assertion has passed, one when at least one of them
 *   has failed and two when the report file could not be written at all
 */
package com.kisscodesystems.KissAs3Ut
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.desktop.NativeApplication;
  import flash.events.TimerEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.utils.Timer;
  import flash.utils.getTimer;
  public class UnitTestRunner
  {
    // the summary stands on the screen this long, then the application quits by itself
    private static const SECONDS_TO_DISPLAY:int = 5;
    // the summary is displayed with the very same primitives the Tracer is built of
    private static const FONTNAME:String = "_typewriter";
    private static const FONTSIZE:int = 12;
    private static const TEXTCOLOR:uint = 0x101010;
    private static const BACKGROUNDCOLOR:uint = 0xffffff;
    private static const PADDING:int = 8;
    private var application:Application = null;
    private var titleOfTheRun:String = "";
    private var nameOfTheResultFile:String = "";
    private var report:UnitTestReport = null;
    private var suitesArray:Array = null;
    private var resultField:TextField = null;
    private var exitTimer:Timer = null;
    private var exitCode:int = 0;
    private var millisecondsOfTheRun:int = 0;
    /**
     * Constructs the runner of a set of suites.
     * @param applicationRef the application the suites are run on
     * @param title the name of this run, the first line of the summary of it
     * @param resultFileName the name of the file the report is written into
     */
    public function UnitTestRunner(applicationRef:Application, title:String, resultFileName:String):void
    {
      application = applicationRef;
      titleOfTheRun = title;
      nameOfTheResultFile = resultFileName;
    }
    /**
     * Runs every suite of the given array, reports the result of that run on the screen
     * and into the report file, and asks the application to quit when that result has
     * stood on the screen long enough.
     * @param suites the suites to be run, in the order they have to be run in
     */
    public function run(suites:Array):void
    {
      suitesArray = suites;
      const millisecondsOfTheStart:int = getTimer();
      runSuites();
      millisecondsOfTheRun = getTimer() - millisecondsOfTheStart;
      // the report file is one channel of this run, so a report that could not be written
      // is an exit code of its own: without it that run looks like a crash
      exitCode = 2;
      if (writeReport())
      {
        exitCode = 0;
        if (report.getFailed() > 0)
        {
          exitCode = 1;
        }
      }
      displayResult();
      exitTimer = new Timer(SECONDS_TO_DISPLAY * 1000, 1);
      exitTimer.addEventListener(TimerEvent.TIMER, secondsOfDisplayingOver);
      exitTimer.start();
    }
    /**
     * Returns the report of this run, so the suites of an application can be built with
     * the very report their results are collected in.
     */
    public function getReport():UnitTestReport
    {
      if (report == null)
      {
        report = new UnitTestReport();
      }
      return report;
    }
    /**
     * Runs every suite. An error thrown by a suite is one more failed assertion, the
     * suites after it are still run.
     */
    private function runSuites():void
    {
      // The runtime dispatches some of the events on its own: the added to stage one for
      // example. An error thrown by such a listener never reaches the try below, it goes
      // to the runtime instead, which stops the whole run with a modal dialog nobody is
      // there to close. Every one of them is caught here and reported as a failure.
      application.loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
      var suite:BaseUnitTest = null;
      for (var i:int = 0; i < suitesArray.length; i++)
      {
        suite = BaseUnitTest(suitesArray[i]);
        getReport().startSuite(suite.getName());
        try
        {
          suite.run();
        }
        catch (e:*)
        {
          getReport().addFailed(suite.getName() + " has thrown an error", "no error", "" + e);
        }
        try
        {
          suite.destroy();
        }
        catch (e:*)
        {
          getReport().addFailed(suite.getName() + " has thrown an error while it was freed"
            , "no error", "" + e);
        }
      }
      suite = null;
      application.loaderInfo.uncaughtErrorEvents.removeEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
    }
    /**
     * Reports an error thrown where no suite could catch it and keeps the run going: the
     * default handling of the runtime would stop everything with a modal dialog.
     * @param e the uncaught error event
     */
    private function uncaughtError(e:UncaughtErrorEvent):void
    {
      e.preventDefault();
      var details:String = "" + e.error;
      if (e.error is Error)
      {
        details = Error(e.error).getStackTrace();
      }
      getReport().addFailed("an uncaught error has been thrown", "no error", details);
    }
    /**
     * Returns the summary of this run: what has happened, the numbers of it, the path of
     * the file holding every assertion and the failed assertions themselves.
     */
    private function getSummaryText():String
    {
      var text:String = titleOfTheRun + "\n\n";
      if (report.getFailed() == 0)
      {
        text += "PASSED. Every assertion of every suite has passed.\n\n";
      }
      else if (report.getFailed() == 1)
      {
        text += "FAILED. One assertion has failed.\n\n";
      }
      else
      {
        text += "FAILED. " + report.getFailed() + " assertions have failed.\n\n";
      }
      text += "suites      " + report.getSuites() + "\n";
      text += "assertions  " + (report.getPassed() + report.getFailed()) + "\n";
      text += "passed      " + report.getPassed() + "\n";
      text += "failed      " + report.getFailed() + "\n";
      text += "run in      " + millisecondsOfTheRun + " ms\n";
      text += "exit code   " + exitCode + "\n\n";
      text += "Every assertion of this run, the passed ones as well, stands in\n";
      text += getResultFile().nativePath + "\n";
      if (exitCode == 2)
      {
        text += "This file could not be written, so that report is lost.\n";
      }
      if (report.getFailed() > 0)
      {
        text += "\nThe failed assertions:\n" + report.getFailedLines() + "\n";
      }
      return text;
    }
    /**
     * Displays the summary of this run on the screen: what has happened, the numbers of
     * it, the path of the file holding every assertion and the failed assertions
     * themselves. The suites have been freed by now, so nothing of them is disturbed by
     * this field standing on the application. The field carries a background of its own:
     * an application under test draws its own content behind it, and this summary is the
     * one thing that has to be readable when the run is over.
     */
    private function displayResult():void
    {
      const text:String = getSummaryText()
        + "\nThis window closes itself in " + SECONDS_TO_DISPLAY + " seconds.";
      resultField = new TextField();
      resultField.defaultTextFormat = new TextFormat(FONTNAME, FONTSIZE, TEXTCOLOR);
      resultField.multiline = true;
      resultField.wordWrap = true;
      resultField.background = true;
      resultField.backgroundColor = BACKGROUNDCOLOR;
      // the path above is worth copying out of the field
      resultField.selectable = true;
      resultField.x = PADDING;
      resultField.y = PADDING;
      if (application.stage != null)
      {
        resultField.width = application.stage.stageWidth - 2 * PADDING;
        resultField.height = application.stage.stageHeight - 2 * PADDING;
      }
      resultField.text = text;
      application.addChild(resultField);
    }
    /**
     * Quits the application when the summary has stood on the screen long enough.
     * @param e the timer event
     */
    private function secondsOfDisplayingOver(e:TimerEvent):void
    {
      exitTimer.stop();
      exitTimer.removeEventListener(TimerEvent.TIMER, secondsOfDisplayingOver);
      NativeApplication.nativeApplication.exit(exitCode);
    }
    /**
     * Returns the file the report of every assertion is written into. The application
     * directory itself is a read only reference, so this file is built of the native path
     * of it: that one is an ordinary file reference and it is writable.
     */
    private function getResultFile():File
    {
      return new File(File.applicationDirectory.nativePath).resolvePath(nameOfTheResultFile);
    }
    /**
     * Writes the report of this run into the result file.
     * Returns true when that file has been written.
     */
    private function writeReport():Boolean
    {
      const fileStream:FileStream = new FileStream();
      try
      {
        fileStream.open(getResultFile(), FileMode.WRITE);
        fileStream.writeUTFBytes(getReport().getReport());
        fileStream.close();
        return true;
      }
      catch (e:*)
      {
        application.trace("<UnitTestRunner writeReport> unable to write the result file: " + e, 7);
      }
      return false;
    }
    /**
     * Frees everything this runner holds.
     */
    public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      if (application != null)
      {
        application.loaderInfo.uncaughtErrorEvents.removeEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
      }
      if (exitTimer != null)
      {
        exitTimer.removeEventListener(TimerEvent.TIMER, secondsOfDisplayingOver);
      }
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      if (exitTimer != null)
      {
        exitTimer.stop();
      }
      if (resultField != null && application != null && application.contains(resultField))
      {
        application.removeChild(resultField);
      }
      if (suitesArray != null)
      {
        suitesArray.splice(0);
      }
      if (report != null)
      {
        report.destroy();
      }
      // 3: call the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      application = null;
      titleOfTheRun = "";
      nameOfTheResultFile = "";
      report = null;
      suitesArray = null;
      resultField = null;
      exitTimer = null;
      exitCode = 0;
      millisecondsOfTheRun = 0;
    }
  }
}
