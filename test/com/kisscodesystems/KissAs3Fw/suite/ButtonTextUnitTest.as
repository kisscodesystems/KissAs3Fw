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
 * ButtonTextUnitTest
 * Checks the ButtonText component and the base working button behind it.
 *
 * MAIN FEATURES:
 * - the label of the button
 * - the dimensions of a working button can be set from the outside
 * - the content sprite and the visibility of the button parts
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ButtonTextUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ButtonTextUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ButtonText";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const buttonText:ButtonText = new ButtonText(application);
      addTested(buttonText);
      // the label is delegated to the text label inside the button
      buttonText.setLabel("Kiss Code Systems");
      assertEquals("getLabel after setLabel", "Kiss Code Systems", buttonText.getLabel());
      buttonText.setLabel("");
      assertEquals("getLabel after setLabel with an empty label", "", buttonText.getLabel());
      buttonText.setLabel("Kiss Code Systems");
      // an icon can be put onto the button, it has no getter of its own
      buttonText.setIcon(EnumIcons.switchon());
      assertNotNull("getContentSprite", buttonText.getContentSprite());
      // the dimensions of this button come from its label and from the padding of the
      // application, so it refuses every dimension it is given from the outside
      const dwOfTheLabel:int = buttonText.getDw();
      const dhOfTheLabel:int = buttonText.getDh();
      assertTrue("the button is as wide as its label needs", dwOfTheLabel > 0);
      assertTrue("the button is as tall as its label needs", dhOfTheLabel > 0);
      buttonText.setDwh(200, 60);
      assertEquals("getDw is not changed by setDwh", dwOfTheLabel, buttonText.getDw());
      assertEquals("getDh is not changed by setDwh", dhOfTheLabel, buttonText.getDh());
      buttonText.setDw(150);
      assertEquals("getDw is not changed by setDw", dwOfTheLabel, buttonText.getDw());
      buttonText.setDh(40);
      assertEquals("getDh is not changed by setDh", dhOfTheLabel, buttonText.getDh());
      // a longer label does change them
      buttonText.setLabel("Kiss Code Systems, a longer label than before");
      assertTrue("a longer label makes the button wider", buttonText.getDw() > dwOfTheLabel);
      buttonText.setLabel("Kiss Code Systems");
      assertEquals("the original label makes it as wide as it was"
        , dwOfTheLabel, buttonText.getDw());
      // the content sprite follows the dimensions of the button
      assertEquals("the width of the content sprite"
        , buttonText.getDw(), buttonText.getContentSprite().getDw());
      assertEquals("the height of the content sprite"
        , buttonText.getDh(), buttonText.getContentSprite().getDh());
      // the parts of the button can be hidden without hiding the button itself
      buttonText.setBaseWorkingButtonVisible(false);
      assertFalse("the content sprite after setBaseWorkingButtonVisible(false)"
        , buttonText.getContentSprite().visible);
      assertTrue("the button itself stays visible", buttonText.visible);
      buttonText.setBaseWorkingButtonVisible(true);
      assertTrue("the content sprite after setBaseWorkingButtonVisible(true)"
        , buttonText.getContentSprite().visible);
      // the custom event string and the forced roll out have no state to read back
      buttonText.setCustomEventString(EnumEvents.EVENT_CHANGED());
      buttonText.setCustomEventString(null);
      buttonText.onRollOut();
      runBaseSpriteTests(buttonText);
      removeTested(buttonText);
    }
  }
}
