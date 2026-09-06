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
 * TextBoxUnitTest
 * Checks the TextBox component.
 *
 * MAIN FEATURES:
 * - the word wrapping and the resizable state of the box
 * - the text code the box has been written with and the text it displays
 * - the text type and the html mode of that text
 * - a text box takes both of the dimensions it is given
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextBox;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class TextBoxUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function TextBoxUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "TextBox";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const textBox:TextBox = new TextBox(application);
      addTested(textBox);
      // a text box takes both of the dimensions it is given
      textBox.setDwh(200, 150);
      assertEquals("getDw after setDwh", expectedDw(200), textBox.getDw());
      assertEquals("getDh after setDwh", expectedDh(150), textBox.getDh());
      textBox.setDw(240);
      assertEquals("getDw after setDw", expectedDw(240), textBox.getDw());
      assertEquals("getDh is kept by setDw", expectedDh(150), textBox.getDh());
      textBox.setDh(180);
      assertEquals("getDh after setDh", expectedDh(180), textBox.getDh());
      assertEquals("getDw is kept by setDh", expectedDw(240), textBox.getDw());
      // the word wrapping is off until it is asked for
      assertFalse("getWordWrap of a fresh box", textBox.getWordWrap());
      textBox.setWordWrap(true);
      assertTrue("getWordWrap after setWordWrap(true)", textBox.getWordWrap());
      textBox.setWordWrap(false);
      assertFalse("getWordWrap after setWordWrap(false)", textBox.getWordWrap());
      textBox.setWordWrap(true);
      // the resizer of the scroll is created and dropped by the resizable state
      assertFalse("getResizable of a fresh box", textBox.getResizable());
      textBox.setResizable(true);
      assertTrue("getResizable after setResizable(true)", textBox.getResizable());
      textBox.setResizable(false);
      assertFalse("getResizable after setResizable(false)", textBox.getResizable());
      textBox.setResizable(true);
      // the text type is the bright one until another one is asked for
      assertEquals("getType of a fresh box", EnumTextTypes.TEXT_TYPE_BRIGHT(), textBox.getType());
      textBox.setType(EnumTextTypes.TEXT_TYPE_DARK());
      assertEquals("getType after setType", EnumTextTypes.TEXT_TYPE_DARK(), textBox.getType());
      // a text that carries no text key at all is displayed as it is, so the code the box
      // has been written with and the text it displays are one and the same here
      assertEquals("getLabel of a fresh box", "", textBox.getLabel());
      assertEquals("getText of a fresh box", "", textBox.getText());
      textBox.setLabel("Kiss Code Systems");
      assertEquals("getLabel after setLabel", "Kiss Code Systems", textBox.getLabel());
      assertEquals("getText after setLabel", "Kiss Code Systems", textBox.getText());
      // An appended text grows the text that is displayed and leaves that code alone. A
      // flash text field stores every line break of its own as a carriage return, so the
      // new line handed over below is answered as one of those.
      textBox.appendText("\n" + "This line has been appended.");
      assertEquals("getLabel after appendText", "Kiss Code Systems", textBox.getLabel());
      assertEquals("getText after appendText"
        , "Kiss Code Systems" + "\r" + "This line has been appended.", textBox.getText());
      // an empty text is taken as well, and it empties both of them
      textBox.setLabel("");
      assertEquals("getLabel after an empty setLabel", "", textBox.getLabel());
      assertEquals("getText after an empty setLabel", "", textBox.getText());
      textBox.setLabel("Kiss Code Systems");
      // The text keys standing between brackets are looked up until that looking up is
      // switched off. A key that does not exist at all is answered by an empty string, so
      // a text carrying brackets of its own, the array literals of a source code for
      // example, loses everything standing between them while the keys are on.
      assertTrue("getTextKeysEnabled of a fresh box", textBox.getTextKeysEnabled());
      textBox.setLabel("setChapters([ThisKeyDoesNotExistAtAll]);");
      assertEquals("a text key that does not exist is displayed as an empty string"
        , "setChapters();", textBox.getText());
      textBox.setTextKeysEnabled(false);
      assertFalse("getTextKeysEnabled after setTextKeysEnabled(false)"
        , textBox.getTextKeysEnabled());
      assertEquals("every bracket is displayed as it is while the keys are switched off"
        , "setChapters([ThisKeyDoesNotExistAtAll]);", textBox.getText());
      assertEquals("the switch leaves the code the box has been written with alone"
        , "setChapters([ThisKeyDoesNotExistAtAll]);", textBox.getLabel());
      textBox.setTextKeysEnabled(true);
      assertTrue("getTextKeysEnabled after setTextKeysEnabled(true)"
        , textBox.getTextKeysEnabled());
      assertEquals("the keys are looked up again after the switching back on"
        , "setChapters();", textBox.getText());
      textBox.setTextKeysEnabled(false);
      textBox.setLabel("Kiss Code Systems");
      assertEquals("a text of no bracket at all is displayed with the keys switched off too"
        , "Kiss Code Systems", textBox.getText());
      textBox.setTextKeysEnabled(true);
      // the html mode is off until it is asked for
      assertFalse("getHtml of a fresh box", textBox.getHtml());
      textBox.setHtml(true);
      assertTrue("getHtml after setHtml(true)", textBox.getHtml());
      textBox.setHtml(false);
      assertFalse("getHtml after setHtml(false)", textBox.getHtml());
      // the dimensions survive the text changes
      assertEquals("getDw after the text changes", expectedDw(240), textBox.getDw());
      assertEquals("getDh after the text changes", expectedDh(180), textBox.getDh());
      runBaseSpriteTests(textBox);
      removeTested(textBox);
    }
  }
}
