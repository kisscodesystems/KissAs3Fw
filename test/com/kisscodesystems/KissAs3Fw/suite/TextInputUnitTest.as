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
 * TextInputUnitTest
 * Checks the TextInput component.
 *
 * MAIN FEATURES:
 * - the text, the hint and the minimum length of the input
 * - only the width of an input can be set, its height comes from the font
 * - the elements the auto completion offers for the element being typed
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Fw.ui.TextInput;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.display.DisplayObject;
  import flash.events.TextEvent;
  public class TextInputUnitTest extends BaseUnitTest
  {
    // the input the assertions of the auto completion are typed into
    private var testedTextInput:TextInput = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function TextInputUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "TextInput";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const textInput:TextInput = new TextInput(application);
      addTested(textInput);
      // a fresh input is empty
      assertEquals("getText of a fresh input", "", textInput.getText());
      // the label of an input is its text
      textInput.setLabel("Kiss Code Systems");
      assertEquals("getText after setLabel", "Kiss Code Systems", textInput.getText());
      textInput.setTextToUpperCase();
      assertEquals("getText after setTextToUpperCase", "KISS CODE SYSTEMS", textInput.getText());
      textInput.setTextToLowerCase();
      assertEquals("getText after setTextToLowerCase", "kiss code systems", textInput.getText());
      textInput.setLabel("");
      assertEquals("getText after setLabel with an empty label", "", textInput.getText());
      // the minimum length is checked against the trimmed text
      textInput.setMinChars(3);
      assertFalse("getTextIsAtLeastLength of an empty input", textInput.getTextIsAtLeastLength());
      textInput.setLabel("ab");
      assertFalse("getTextIsAtLeastLength of a too short text", textInput.getTextIsAtLeastLength());
      textInput.setLabel("abc");
      assertTrue("getTextIsAtLeastLength of a long enough text", textInput.getTextIsAtLeastLength());
      textInput.setLabel("   ");
      assertFalse("getTextIsAtLeastLength of a text of spaces only"
        , textInput.getTextIsAtLeastLength());
      textInput.setMinChars(0);
      assertTrue("getTextIsAtLeastLength without a minimum", textInput.getTextIsAtLeastLength());
      // the hint is an object of its own, it can be created and dropped any time
      textInput.setHint("This is the hint of this input");
      textInput.clearHint();
      textInput.setHint("This is the hint of this input");
      // only the width of an input can be set, and never below the configured minimum
      const textsMinSize:int = application.getComponentsConfig().getTextsMinSize();
      textInput.setDw(200);
      assertEquals("getDw after setDw", expectedDw(Math.max(200, textsMinSize)), textInput.getDw());
      const dhBefore:int = textInput.getDh();
      textInput.setDh(500);
      assertEquals("getDh is not changed by setDh", dhBefore, textInput.getDh());
      textInput.setDwh(400, 500);
      assertEquals("getDw is not changed by setDwh"
        , expectedDw(Math.max(200, textsMinSize)), textInput.getDw());
      assertEquals("getDh is not changed by setDwh", dhBefore, textInput.getDh());
      textInput.setDw(1);
      assertEquals("the width can not go below the minimum of the texts"
        , expectedDw(textsMinSize), textInput.getDw());
      textInput.setDw(200);
      // the password mode and the restriction have no state to read back
      textInput.setDisplayAsPassword(true);
      textInput.setDisplayAsPassword(false);
      textInput.setRestrict("[a-z]");
      textInput.setRestrict(null);
      textInput.setMaxChars(100);
      // the focus can only be taken when this object is on the stage
      textInput.toFocus();
      assertEquals("isInFocus after toFocus", textInput.stage != null, textInput.isInFocus());
      // the dataset of the auto completion is given and dropped from the outside. The
      // list of it opens on a typed key only, so this suite checks that the dataset can
      // be handed over in every form of it and that no list stands open without a key:
      // an open one would make this object taller than its own field
      const dhWithoutList:int = textInput.getDh();
      textInput.addAutoCompleteElements("alpha,beta,gamma", ",");
      assertEquals("getDh is not changed by a dataset of the auto completion"
        , dhWithoutList, textInput.getDh());
      // a second dataset replaces the first one instead of being added to it
      textInput.addAutoCompleteElements("delta;epsilon", ";");
      assertEquals("getDh is not changed by a second dataset", dhWithoutList, textInput.getDh());
      // a null in either of the two turns the whole feature off
      textInput.addAutoCompleteElements(null, ",");
      textInput.addAutoCompleteElements("alpha,beta", null);
      textInput.addAutoCompleteElements(null, null);
      // an empty separator would cut the elements into single characters, so it is
      // taken as a request to turn the feature off as well
      textInput.addAutoCompleteElements("alpha,beta", "");
      assertEquals("getDh is not changed by a dropped dataset", dhWithoutList, textInput.getDh());
      runBaseSpriteTests(textInput);
      removeTested(textInput);
      runAutoCompleteTests();
    }
    /**
     * Runs the assertions of the auto completion: the text of an input can hold more
     * elements of the dataset, separated from each other by a comma, a semicolon or a
     * space, and the list of the completion offers the matches of the element the caret
     * stands in, leaving the elements typed already out of them.
     */
    private function runAutoCompleteTests():void
    {
      testedTextInput = new TextInput(application);
      addTested(testedTextInput);
      testedTextInput.setDw(300);
      testedTextInput.addAutoCompleteElements("anna,bela,cecil,daniel", ",");
      // the typing of this suite works with the caret of the field, and that caret only
      // stands where it is put while the field is the one in focus
      testedTextInput.toFocus();
      assertTrue("the input of the auto completion is in focus", testedTextInput.isInFocus());
      // the very first character opens the list of every element holding it
      assertEquals("the matches of the first typed character", "anna|bela|daniel"
        , typeInAutoComplete("", 0, "a"));
      assertEquals("the matches of the second typed character", "anna|daniel"
        , typeInAutoComplete("a", 1, "n"));
      // a separator closes the element that has been typed and starts a new one: the
      // completion offers the whole rest of the dataset for that new element
      assertEquals("the matches after a comma", "bela|cecil|daniel"
        , typeInAutoComplete("anna", 4, ","));
      assertEquals("the matches after a semicolon", "cecil|daniel"
        , typeInAutoComplete("anna;bela", 9, ";"));
      assertEquals("the matches after a space", "cecil|daniel"
        , typeInAutoComplete("anna;bela ", 10, " "));
      // the element typed already is offered no more, whichever separator stands in
      // front of the element being typed
      assertEquals("the matches of a character typed after a comma", "bela|daniel"
        , typeInAutoComplete("anna,", 5, "a"));
      assertEquals("the matches of a character typed after a space", "daniel"
        , typeInAutoComplete("anna bela ", 10, "a"));
      // the completion works on the element the caret stands in and not on the whole
      // text: a character typed into the middle of an element that is standing there
      // already leaves no match at all, so the list of it goes
      assertEquals("the matches of a character typed into the middle of the first element"
        , "CLOSED", typeInAutoComplete("anna,bela", 4, "x"));
      removeTested(testedTextInput);
      testedTextInput = null;
    }
    /**
     * Types one single character into the input of the auto completion and returns the
     * elements the list of it displays afterwards, joined into one single string, and
     * the CLOSED word when that list is not standing open at all.
     * The character of a text input event is not in the field yet when that event is
     * heard, so the text this typing starts from and the position of the caret in it are
     * given from the outside, exactly as the runtime would leave them.
     * @param text the text of the input the character is typed into
     * @param caretIndex the position of the caret inside that text
     * @param character the typed character
     */
    private function typeInAutoComplete(text:String, caretIndex:int, character:String):String
    {
      const baseTextField:BaseTextField = findBaseTextField();
      baseTextField.text = text;
      baseTextField.setSelection(caretIndex, caretIndex);
      baseTextField.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, character));
      const listPanel:ListPanel = findListPanel();
      return listPanel == null ? "CLOSED" : listPanel.getArrayValues().join("|");
    }
    /**
     * Returns the text field of the input of the auto completion: the object the typing
     * of this suite happens on. That field is no public property of that input, so it is
     * picked out of the children of it.
     */
    private function findBaseTextField():BaseTextField
    {
      for (var i:int = 0; i < testedTextInput.numChildren; i++)
      {
        const displayObject:DisplayObject = testedTextInput.getChildAt(i);
        if (displayObject is BaseTextField)
        {
          return BaseTextField(displayObject);
        }
      }
      return null;
    }
    /**
     * Returns the list of the completion of that input, null while it is not standing
     * open. That list is no public property of that input either, so it is picked out of
     * the children of it as well.
     */
    private function findListPanel():ListPanel
    {
      for (var i:int = 0; i < testedTextInput.numChildren; i++)
      {
        const displayObject:DisplayObject = testedTextInput.getChildAt(i);
        if (displayObject is ListPanel)
        {
          return ListPanel(displayObject);
        }
      }
      return null;
    }
  }
}
