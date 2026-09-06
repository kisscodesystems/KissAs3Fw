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
 * TextAreaUnitTest
 * Checks the TextArea component and what it inherits from the text box.
 *
 * MAIN FEATURES:
 * - the text and the minimum length of the editable area
 * - the html mode an area takes over from the box it extends
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextArea;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class TextAreaUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function TextAreaUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "TextArea";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const textArea:TextArea = new TextArea(application);
      addTested(textArea);
      // an area takes both of the dimensions it is given, just like a box
      textArea.setDwh(200, 150);
      assertEquals("getDw after setDwh", expectedDw(200), textArea.getDw());
      assertEquals("getDh after setDwh", expectedDh(150), textArea.getDh());
      // an area wraps its words from the very beginning
      assertTrue("getWordWrap of a fresh area", textArea.getWordWrap());
      // the text of an area can be read back
      assertEquals("getText of a fresh area", "", textArea.getText());
      textArea.setLabel("Kiss Code Systems");
      assertEquals("getText after setLabel", "Kiss Code Systems", textArea.getText());
      textArea.appendText(" appended");
      assertEquals("getText after appendText", "Kiss Code Systems appended", textArea.getText());
      textArea.setLabel("");
      assertEquals("getText after setLabel with an empty label", "", textArea.getText());
      // the minimum length is checked against the trimmed text
      textArea.setMinChars(3);
      assertFalse("getTextIsAtLeastLength of an empty area", textArea.getTextIsAtLeastLength());
      textArea.setLabel("ab");
      assertFalse("getTextIsAtLeastLength of a too short text", textArea.getTextIsAtLeastLength());
      textArea.setLabel("abc");
      assertTrue("getTextIsAtLeastLength of a long enough text", textArea.getTextIsAtLeastLength());
      textArea.setMinChars(0);
      // an area displays a html text just like the box it extends does: the markup of it
      // is rendered and it is not a part of the text any more
      textArea.setHtml(true);
      assertTrue("getHtml after setHtml(true)", textArea.getHtml());
      textArea.setLabel("<b>Kiss Code Systems</b>");
      assertEquals("the html markup is rendered in the text of the area"
        , "Kiss Code Systems", textArea.getText());
      textArea.setHtml(false);
      assertFalse("getHtml after setHtml(false)", textArea.getHtml());
      textArea.setLabel("<b>Kiss Code Systems</b>");
      assertEquals("the html markup stays in the plain text of the area"
        , "<b>Kiss Code Systems</b>", textArea.getText());
      textArea.setLabel("");
      // the resizable state works the same way as on a box
      assertFalse("getResizable of a fresh area", textArea.getResizable());
      textArea.setResizable(true);
      assertTrue("getResizable after setResizable(true)", textArea.getResizable());
      // the text type and the restriction have no state to read back
      textArea.setType(EnumTextTypes.TEXT_TYPE_MID());
      textArea.setRestrict("[a-zA-Z]");
      textArea.setRestrict(null);
      textArea.setMaxChars(4000);
      textArea.toFocus();
      runBaseSpriteTests(textArea);
      removeTested(textArea);
    }
  }
}
