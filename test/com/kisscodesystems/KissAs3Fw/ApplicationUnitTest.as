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
 * ApplicationUnitTest
 * The application that runs the unit test suites of the framework components.
 * It is built on the plain framework, so every value it meets is a framework default.
 *
 * MAIN FEATURES:
 * - the suites are run on the first frame, so they have a stage to work with
 * - the summary of the run is displayed on the screen, so the one starting this
 *   application sees what has happened without reading any file, and the window closes
 *   itself afterwards: SECONDS_TO_DISPLAY below tells how long it stands
 * - the text field of that summary is built of flash primitives, the way the Tracer of
 *   the framework is: the components of the framework are the ones under test here, so
 *   the display of the result must not depend on them
 * - the result of every assertion goes into a report file
 * - an error thrown where no suite can catch it is one more failed assertion as well:
 *   without that the runtime would stop the whole run with a modal dialog
 * - the exit code is zero when every assertion has passed
 */
package com.kisscodesystems.KissAs3Fw
{
  import com.kisscodesystems.KissAs3Fw.enum.EnumAppEnvs;
  import com.kisscodesystems.KissAs3Fw.suite.BackgroundUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseAlerterUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseButtonUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseConfigValuesUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseEventDispatcherUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseListUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseOpenUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BasePanelUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseReactUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseRequestManagerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseResizerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseScrollUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseShapeUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseSpriteUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseTextFieldUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BaseWorkingButtonUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.BoardUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ButtonBarUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ButtonLinkUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ButtonTextUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.CameraUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ColorPanelUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ColorPickerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ComponentsConfigUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ContentMultipleUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ContentSingleUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.CryptoUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.DatePanelUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.DatePickerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.DeviceIdManagerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.DynamicsConfigUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.EnumUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ForegroundUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.IconUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ImageUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.LangSetterUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ListPanelUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ListPickerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.MiddlegroundUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.MoreUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.NetConnectionManagerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.PanelMenuUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.PanelSettingsUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.PropertiesConfigUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.PotmeterUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.RaterUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.ServerManagerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.SoundPlayerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.SwitcherUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.TextAreaUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.TextBoxUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.TextInputUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.TextLabelUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.TracerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.UrlRequestManagerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.UserUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.UtilsUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.VectorDrawingsUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.VideoPlayerUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.WatchUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.WidgetUnitTest;
  import com.kisscodesystems.KissAs3Fw.suite.XmlListerUnitTest;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.desktop.NativeApplication;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.utils.Timer;
  import flash.utils.getTimer;
  public class ApplicationUnitTest extends Application
  {
    // the report goes next to the application descriptor, so it is found on every
    // operating system the tests are run on
    private static const RESULT_FILE:String = "KissAs3Fw-results.txt";
    // the summary stands on the screen this long, then this application quits by itself
    private static const SECONDS_TO_DISPLAY:int = 5;
    // the summary is displayed with the very same primitives the Tracer is built of
    private static const FONTNAME:String = "_typewriter";
    private static const FONTSIZE:int = 12;
    private static const TEXTCOLOR:uint = 0x101010;
    private static const PADDING:int = 8;
    private var report:UnitTestReport = null;
    private var suitesArray:Array = null;
    private var resultField:TextField = null;
    private var exitTimer:Timer = null;
    private var exitCode:int = 0;
    private var millisecondsOfTheRun:int = 0;
    /**
     * Constructs the test application and asks for the first frame to run the suites on.
     */
    public function ApplicationUnitTest():void
    {
      try
      {
        // the super call has to come first: every inherited method, setTraceLevel among
        // them, reaches the application reference this call is the one to set
        super();
        setTraceLevel(9);
        appEnv = EnumAppEnvs.appEnvDev();
        addEventListener(Event.ENTER_FRAME, firstFrame);
      }
      catch (e:*)
      {
        this.trace("<ApplicationUnitTest> main error: " + e, 7);
      }
    }
    /**
     * The test application builds no objects of its own, every suite builds what it needs.
     */
    override protected function createObjects():void
    {
    }
    /**
     * Runs the suites on the first frame, when the stage is already there, then reports
     * the result on the screen and into the report file, and quits when that result has
     * stood on the screen long enough. The exit code is zero when every assertion has
     * passed, one when at least one of them has failed and two when the report file could
     * not be written at all.
     * @param e the enter frame event
     */
    private function firstFrame(e:Event):void
    {
      removeEventListener(Event.ENTER_FRAME, firstFrame);
      const millisecondsOfTheStart:int = getTimer();
      runSuites();
      millisecondsOfTheRun = getTimer() - millisecondsOfTheStart;
      // the report file is one channel of this application, so a report that could not be
      // written is an exit code of its own: without it that run looks like a crash
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
     * Runs every suite. An error thrown by a suite is one more failed assertion, the
     * suites after it are still run.
     */
    private function runSuites():void
    {
      report = new UnitTestReport();
      // The runtime dispatches some of the events on its own: the added to stage one for
      // example. An error thrown by such a listener never reaches the try below, it goes
      // to the runtime instead, which stops the whole run with a modal dialog nobody is
      // there to close. Every one of them is caught here and reported as a failure.
      loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
      suitesArray = new Array();
      // the enums come first: every class of the framework asks its own values from them
      suitesArray.push(new EnumUnitTest(this, report));
      // the configs next: every value of the framework is asked from one of these three,
      // and they are checked in the order they are built by the application
      suitesArray.push(new PropertiesConfigUnitTest(this, report));
      suitesArray.push(new ComponentsConfigUnitTest(this, report));
      suitesArray.push(new DynamicsConfigUnitTest(this, report));
      // the utils and the user next: the base classes below calculate with them
      suitesArray.push(new UtilsUnitTest(this, report));
      suitesArray.push(new VectorDrawingsUnitTest(this, report));
      // the cryptography and the identifier of the device built on top of it
      suitesArray.push(new CryptoUnitTest(this, report));
      suitesArray.push(new DeviceIdManagerUnitTest(this, report));
      suitesArray.push(new UserUnitTest(this, report));
      // the base classes next, every component of the framework is built of them
      suitesArray.push(new BaseAlerterUnitTest(this, report));
      suitesArray.push(new BaseButtonUnitTest(this, report));
      suitesArray.push(new BaseConfigValuesUnitTest(this, report));
      suitesArray.push(new BaseEventDispatcherUnitTest(this, report));
      suitesArray.push(new BaseListUnitTest(this, report));
      suitesArray.push(new BaseOpenUnitTest(this, report));
      suitesArray.push(new BasePanelUnitTest(this, report));
      suitesArray.push(new ServerManagerUnitTest(this, report));
      suitesArray.push(new BaseRequestManagerUnitTest(this, report));
      suitesArray.push(new UrlRequestManagerUnitTest(this, report));
      suitesArray.push(new NetConnectionManagerUnitTest(this, report));
      suitesArray.push(new BaseResizerUnitTest(this, report));
      suitesArray.push(new BaseScrollUnitTest(this, report));
      suitesArray.push(new BaseShapeUnitTest(this, report));
      suitesArray.push(new BaseSpriteUnitTest(this, report));
      suitesArray.push(new BaseTextFieldUnitTest(this, report));
      suitesArray.push(new BaseWorkingButtonUnitTest(this, report));
      suitesArray.push(new IconUnitTest(this, report));
      suitesArray.push(new ImageUnitTest(this, report));
      suitesArray.push(new TextLabelUnitTest(this, report));
      suitesArray.push(new ButtonTextUnitTest(this, report));
      suitesArray.push(new ButtonLinkUnitTest(this, report));
      suitesArray.push(new SwitcherUnitTest(this, report));
      suitesArray.push(new TextInputUnitTest(this, report));
      suitesArray.push(new SoundPlayerUnitTest(this, report));
      suitesArray.push(new CameraUnitTest(this, report));
      suitesArray.push(new VideoPlayerUnitTest(this, report));
      suitesArray.push(new TextBoxUnitTest(this, report));
      suitesArray.push(new TextAreaUnitTest(this, report));
      suitesArray.push(new ButtonBarUnitTest(this, report));
      // the list and the color panels come before the components that are built of them
      suitesArray.push(new ListPanelUnitTest(this, report));
      suitesArray.push(new ListPickerUnitTest(this, report));
      suitesArray.push(new ColorPanelUnitTest(this, report));
      suitesArray.push(new ColorPickerUnitTest(this, report));
      suitesArray.push(new RaterUnitTest(this, report));
      suitesArray.push(new PotmeterUnitTest(this, report));
      suitesArray.push(new MoreUnitTest(this, report));
      suitesArray.push(new XmlListerUnitTest(this, report));
      suitesArray.push(new DatePanelUnitTest(this, report));
      suitesArray.push(new DatePickerUnitTest(this, report));
      suitesArray.push(new BoardUnitTest(this, report));
      suitesArray.push(new WatchUnitTest(this, report));
      suitesArray.push(new ContentSingleUnitTest(this, report));
      suitesArray.push(new ContentMultipleUnitTest(this, report));
      // the react base class is built of the button link and of the content multiple
      suitesArray.push(new BaseReactUnitTest(this, report));
      suitesArray.push(new WidgetUnitTest(this, report));
      // the layers of the application come last: they are built of the components above
      suitesArray.push(new BackgroundUnitTest(this, report));
      suitesArray.push(new LangSetterUnitTest(this, report));
      suitesArray.push(new PanelMenuUnitTest(this, report));
      suitesArray.push(new PanelSettingsUnitTest(this, report));
      suitesArray.push(new MiddlegroundUnitTest(this, report));
      suitesArray.push(new ForegroundUnitTest(this, report));
      suitesArray.push(new TracerUnitTest(this, report));
      var suite:BaseUnitTest = null;
      for (var i:int = 0; i < suitesArray.length; i++)
      {
        suite = BaseUnitTest(suitesArray[i]);
        report.startSuite(suite.getName());
        try
        {
          suite.run();
        }
        catch (e:*)
        {
          report.addFailed(suite.getName() + " has thrown an error", "no error", "" + e);
        }
        try
        {
          suite.destroy();
        }
        catch (e:*)
        {
          report.addFailed(suite.getName() + " has thrown an error while it was freed"
            , "no error", "" + e);
        }
      }
      suite = null;
      loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
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
      report.addFailed("an uncaught error has been thrown", "no error", details);
    }
    /**
     * Returns the summary of the run: what has happened, the numbers of it, the path of
     * the file holding every assertion and the failed assertions themselves.
     */
    private function getSummaryText():String
    {
      var text:String = "KissAs3Fw unit tests\n\n";
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
     * Displays the summary of the run on the screen: what has happened, the numbers of
     * it, the path of the file holding every assertion and the failed assertions
     * themselves. The suites have been freed by now, so nothing of them is disturbed by
     * this field standing on the application.
     */
    private function displayResult():void
    {
      const text:String = getSummaryText()
        + "\nThis window closes itself in " + SECONDS_TO_DISPLAY + " seconds.";
      resultField = new TextField();
      resultField.defaultTextFormat = new TextFormat(FONTNAME, FONTSIZE, TEXTCOLOR);
      resultField.multiline = true;
      resultField.wordWrap = true;
      // the path above is worth copying out of the field
      resultField.selectable = true;
      resultField.x = PADDING;
      resultField.y = PADDING;
      if (stage != null)
      {
        resultField.width = stage.stageWidth - 2 * PADDING;
        resultField.height = stage.stageHeight - 2 * PADDING;
      }
      resultField.text = text;
      addChild(resultField);
    }
    /**
     * Quits this application when the summary has stood on the screen long enough.
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
      return new File(File.applicationDirectory.nativePath).resolvePath(RESULT_FILE);
    }
    /**
     * Writes the report of the run into the result file.
     * Returns true when that file has been written.
     */
    private function writeReport():Boolean
    {
      const fileStream:FileStream = new FileStream();
      try
      {
        fileStream.open(getResultFile(), FileMode.WRITE);
        fileStream.writeUTFBytes(report.getReport());
        fileStream.close();
        return true;
      }
      catch (e:*)
      {
        this.trace("<ApplicationUnitTest writeReport> unable to write the result file: " + e, 7);
      }
      return false;
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      removeEventListener(Event.ENTER_FRAME, firstFrame);
      if (exitTimer != null)
      {
        exitTimer.removeEventListener(TimerEvent.TIMER, secondsOfDisplayingOver);
      }
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      if (exitTimer != null)
      {
        exitTimer.stop();
      }
      if (resultField != null && contains(resultField))
      {
        removeChild(resultField);
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
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      suitesArray = null;
      report = null;
      resultField = null;
      exitTimer = null;
      exitCode = 0;
      millisecondsOfTheRun = 0;
    }
  }
}
