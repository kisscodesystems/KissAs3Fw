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
 * BaseTextFieldUnitTest
 * Checks the BaseTextField of the framework.
 *
 * MAIN FEATURES:
 * - the label is the text code and the text is what is displayed of it
 * - the text type, the auto size, the word wrap and the html mode
 * - the minimal length a text has to reach and the maximal one it can not pass
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseTextFieldUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseTextFieldUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseTextField";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseTextField:BaseTextField = new BaseTextField(application);
      application.addChild(baseTextField);
      assertNotNull("getBaseEventDispatcher of a fresh BaseTextField"
        , baseTextField.getBaseEventDispatcher());
      // the label is the text code, the text is what is displayed of it
      baseTextField.setLabel("Kiss Code Systems");
      assertEquals("getLabel after setLabel", "Kiss Code Systems", baseTextField.getLabel());
      assertEquals("getText after setLabel", "Kiss Code Systems", baseTextField.getText());
      assertNotNull("getHtmlText after setLabel", baseTextField.getHtmlText());
      // the text can be turned into an upper case and into a lower case one
      baseTextField.setTextToUpperCase();
      assertEquals("getText after setTextToUpperCase", "KISS CODE SYSTEMS", baseTextField.getText());
      baseTextField.setTextToLowerCase();
      assertEquals("getText after setTextToLowerCase", "kiss code systems", baseTextField.getText());
      // The text keys standing between brackets are looked up until that looking up is
      // switched off. A key that does not exist at all is answered by an empty string, so
      // a text carrying brackets of its own, the array literals of a source code for
      // example, loses everything standing between them while the keys are on.
      assertTrue("getTextKeysEnabled of a fresh BaseTextField"
        , baseTextField.getTextKeysEnabled());
      baseTextField.setLabel("setChapters([ThisKeyDoesNotExistAtAll]);");
      assertEquals("a text key that does not exist is displayed as an empty string"
        , "setChapters();", baseTextField.getText());
      baseTextField.setTextKeysEnabled(false);
      assertFalse("getTextKeysEnabled after setTextKeysEnabled(false)"
        , baseTextField.getTextKeysEnabled());
      assertEquals("every bracket is displayed as it is while the keys are switched off"
        , "setChapters([ThisKeyDoesNotExistAtAll]);", baseTextField.getText());
      assertEquals("the switch leaves the label alone"
        , "setChapters([ThisKeyDoesNotExistAtAll]);", baseTextField.getLabel());
      baseTextField.setTextKeysEnabled(true);
      assertTrue("getTextKeysEnabled after setTextKeysEnabled(true)"
        , baseTextField.getTextKeysEnabled());
      assertEquals("the keys are looked up again after the switching back on"
        , "setChapters();", baseTextField.getText());
      baseTextField.setLabel("Kiss Code Systems");
      // the text type
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_DARK());
      assertEquals("getType after setType", EnumTextTypes.TEXT_TYPE_DARK(), baseTextField.getType());
      baseTextField.setType(EnumTextTypes.TEXT_TYPE_MID());
      assertEquals("getType after the mid one", EnumTextTypes.TEXT_TYPE_MID(), baseTextField.getType());
      // the html mode and the word wrapping
      assertFalse("getHtml of a fresh BaseTextField", baseTextField.getHtml());
      baseTextField.setHtml(true);
      assertTrue("getHtml after setHtml(true)", baseTextField.getHtml());
      baseTextField.setHtml(false);
      baseTextField.setWordWrap(true);
      assertTrue("getWordWrap after setWordWrap(true)", baseTextField.getWordWrap());
      baseTextField.setWordWrap(false);
      assertFalse("getWordWrap after setWordWrap(false)", baseTextField.getWordWrap());
      // the minimal length the text has to reach
      baseTextField.setMinChars(0);
      assertTrue("getTextIsAtLeastLength without a minimal length"
        , baseTextField.getTextIsAtLeastLength());
      baseTextField.setMinChars(500);
      assertFalse("getTextIsAtLeastLength under the minimal length"
        , baseTextField.getTextIsAtLeastLength());
      baseTextField.setMinChars(0);
      // the settings that only reach the text field itself
      baseTextField.setMaxChars(120);
      assertEquals("maxChars after setMaxChars", 120, baseTextField.maxChars);
      baseTextField.setRestrict("0-9");
      assertEquals("restrict after setRestrict", "0-9", baseTextField.restrict);
      baseTextField.setRestrict(null);
      baseTextField.setDisplayAsPassword(true);
      assertTrue("displayAsPassword after setDisplayAsPassword(true)", baseTextField.displayAsPassword);
      baseTextField.setDisplayAsPassword(false);
      // every one of the four auto size modes can be taken
      baseTextField.setAutoSizeLeft();
      baseTextField.setAutoSizeRight();
      baseTextField.setAutoSizeCenter();
      baseTextField.setAutoSizeNone();
      // the dimensions are only taken when they are asked to be taken
      baseTextField.setDwh(300, 40, true);
      assertEquals("getDw after setDwh with the dimensions", 300, baseTextField.getDw());
      assertEquals("getDh after setDwh with the dimensions", 40, baseTextField.getDh());
      baseTextField.setDw(220);
      assertEquals("getDw after setDw", 220, baseTextField.getDw());
      baseTextField.setDh(30);
      assertEquals("getDh after setDh", 30, baseTextField.getDh());
      // the coordinates
      baseTextField.setCx(10);
      assertEquals("getCx after setCx", 10, baseTextField.getCx());
      baseTextField.setCy(20);
      assertEquals("getCy after setCy", 20, baseTextField.getCy());
      baseTextField.setCxy(30, 40);
      assertEquals("getCx after setCxy", 30, baseTextField.getCx());
      assertEquals("getCy after setCxy", 40, baseTextField.getCy());
      assertEquals("getCx with the width", 30 + baseTextField.getDw(), baseTextField.getCx(true));
      assertEquals("getCy with the height", 40 + baseTextField.getDh(), baseTextField.getCy(true));
      baseTextField.x = 55;
      baseTextField.y = 66;
      baseTextField.updateCxy();
      assertEquals("getCx after updateCxy", 55, baseTextField.getCx());
      assertEquals("getCy after updateCxy", 66, baseTextField.getCy());
      baseTextField.destroy();
      if (application.contains(baseTextField))
      {
        application.removeChild(baseTextField);
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
