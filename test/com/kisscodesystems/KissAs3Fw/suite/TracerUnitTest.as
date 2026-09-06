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
 * TracerUnitTest
 * Checks the Tracer object of the application.
 *
 * MAIN FEATURES:
 * - the collected lines, the numbering of them and the dropping of every one of them
 * - the paused state, the filter and the opened state of the log
 * - a tracer can be created and fed while it stands on no stage at all
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Tracer;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class TracerUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function TracerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Tracer";
    }
    /**
     * Runs the assertions of this suite. The tracer is not added to the application on purpose:
     * it is the one object of this framework that has to work while it stands on no stage.
     */
    override public function run():void
    {
      const tracer:Tracer = new Tracer(application);
      // a fresh tracer is closed, is logging and holds no line at all
      assertFalse("isOpened of a fresh tracer", tracer.isOpened());
      assertFalse("getPaused of a fresh tracer", tracer.getPaused());
      assertEquals("getLineCount of a fresh tracer", 0, tracer.getLineCount());
      assertEquals("getFilter of a fresh tracer", "", tracer.getFilter());
      // one message without an attribute delimiter becomes one single line
      tracer.trace(["the first message"]);
      assertEquals("getLineCount after one message", 1, tracer.getLineCount());
      // a whole batch is taken in one single step
      tracer.trace(["the second message", "the third message"]);
      assertEquals("getLineCount after a batch of two messages", 3, tracer.getLineCount());
      // a message carrying attributes gets one line per attribute, plus the line of itself
      tracer.trace(["the fourth message>firstAttr=1&secondAttr=2"]);
      assertEquals("getLineCount after a message with two attributes", 6, tracer.getLineCount());
      // a message carrying an attribute delimiter only stays one single line
      tracer.trace(["the fifth message: a && b"]);
      assertEquals("getLineCount after a message with an && in it", 7, tracer.getLineCount());
      // a paused tracer drops every message it is given
      tracer.setPaused(true);
      assertTrue("getPaused after setPaused(true)", tracer.getPaused());
      tracer.trace(["this message is dropped"]);
      assertEquals("getLineCount of a paused tracer", 7, tracer.getLineCount());
      tracer.setPaused(false);
      assertFalse("getPaused after setPaused(false)", tracer.getPaused());
      tracer.trace(["this message is kept again"]);
      assertEquals("getLineCount of a logging tracer again", 8, tracer.getLineCount());
      // the filter is kept as it is given, and it keeps every collected line
      tracer.setFilter("second");
      assertEquals("getFilter after setFilter", "second", tracer.getFilter());
      assertEquals("getLineCount is not touched by the filter", 8, tracer.getLineCount());
      // a filter that is not a valid pattern is taken as a text to be looked for
      tracer.setFilter("the third (");
      assertEquals("getFilter after an invalid pattern", "the third (", tracer.getFilter());
      tracer.setFilter("");
      assertEquals("getFilter after an empty filter", "", tracer.getFilter());
      // the log is displayed and hidden by the opened state
      tracer.open();
      assertTrue("isOpened after open", tracer.isOpened());
      tracer.close();
      assertFalse("isOpened after close", tracer.isOpened());
      tracer.open();
      // the level buttons of the tracer set the level of the tracing of the application, and
      // the level the application stands on is the one the tracer displays as the actual one
      const levelBefore:int = application.getTraceLevel();
      application.setTraceLevel(6);
      assertEquals("getTraceLevel of the application after setTraceLevel(6)", 6, application.getTraceLevel());
      application.setTraceLevel(9);
      assertEquals("getTraceLevel of the application after setTraceLevel(9)", 9, application.getTraceLevel());
      // a level out of the range is corrected to the closest allowed one
      application.setTraceLevel(-3);
      assertEquals("getTraceLevel after a negative level", 0, application.getTraceLevel());
      application.setTraceLevel(17);
      assertEquals("getTraceLevel after a level above nine", 9, application.getTraceLevel());
      application.setTraceLevel(levelBefore);
      // every collected line is dropped and the numbering starts again
      tracer.clear();
      assertEquals("getLineCount after clear", 0, tracer.getLineCount());
      tracer.trace(["the first message of the new numbering"]);
      assertEquals("getLineCount after clear and one message", 1, tracer.getLineCount());
      tracer.destroy();
    }
  }
}
