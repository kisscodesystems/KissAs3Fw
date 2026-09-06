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
 * ColorPanelUnitTest
 * Checks the ColorPanel component.
 *
 * MAIN FEATURES:
 * - the committed color is always a six character upper case rgb string
 * - a short color is padded and a color that is not a hexadecimal one becomes the zeros
 * - the changed event is dispatched even when the committed color is the current one
 * - the dimensions come from the size of the color squares, so the setters do nothing
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.ColorPanel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ColorPanelUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ColorPanelUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ColorPanel";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const zeros:String = application.getComponentsConfig().getColorRgbInputZeros();
      const colorPanel:ColorPanel = new ColorPanel(application);
      addTested(colorPanel);
      colorPanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), colorPanelChanged);
      // a fresh panel holds the zeros of the config, and it is as large as its own squares
      assertEquals("getRGBColor of a fresh ColorPanel", zeros, colorPanel.getRGBColor());
      assertEquals("getValue of a fresh ColorPanel", zeros, colorPanel.getValue());
      assertTrue("a fresh ColorPanel is as wide as its squares", colorPanel.getDw() > 0);
      assertTrue("a fresh ColorPanel is as tall as its squares", colorPanel.getDh() > 0);
      // the committed color is the value of the panel as well
      colorPanel.setRGBColor("3366CC");
      assertEquals("getRGBColor after setRGBColor", "3366CC", colorPanel.getRGBColor());
      assertEquals("the committed color is the value of the panel", "3366CC", colorPanel.getValue());
      assertEquals("one changed event after a set of the color", 1, changedCount);
      // the committed color always comes back in upper case
      colorPanel.setRGBColor("aabbcc");
      assertEquals("getRGBColor after a lower case color", "AABBCC", colorPanel.getRGBColor());
      // a color shorter than six characters is padded with the zeros of the config
      colorPanel.setRGBColor("F00");
      assertEquals("getRGBColor after a color of three characters", "000F00", colorPanel.getRGBColor());
      // a color that is not a hexadecimal one at all falls back to the zeros instead of a NaN
      colorPanel.setRGBColor("nothexadecimal");
      assertEquals("getRGBColor after a color that is not a hexadecimal one"
        , zeros, colorPanel.getRGBColor());
      // the changed event is dispatched even when the color is the current one already
      changedCount = 0;
      colorPanel.setRGBColor("112233");
      colorPanel.setRGBColor("112233");
      assertEquals("the very same color dispatches the changed event as well", 2, changedCount);
      assertEquals("the very same color is kept", "112233", colorPanel.getRGBColor());
      // a silent color is committed without a changed event of it
      colorPanel.setRGBColor("445566", false);
      assertEquals("getRGBColor after a silent setRGBColor", "445566", colorPanel.getRGBColor());
      assertEquals("no changed event after a silent setRGBColor", 2, changedCount);
      // the dimensions come from the size of the squares, so the setters do nothing
      const dwBefore:int = colorPanel.getDw();
      const dhBefore:int = colorPanel.getDh();
      colorPanel.setDw(900);
      colorPanel.setDh(900);
      colorPanel.setDwh(900, 900);
      assertEquals("setDw, setDh and setDwh do not change the width", dwBefore, colorPanel.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", dhBefore, colorPanel.getDh());
      // every clickable object of the panel follows the enabled state of it
      colorPanel.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", colorPanel.getEnabled());
      colorPanel.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", colorPanel.getEnabled());
      runBaseSpriteTests(colorPanel);
      colorPanel.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), colorPanelChanged);
      removeTested(colorPanel);
    }
    /**
     * Counts the changed events of the tested panel.
     * @param e the changed event
     */
    private function colorPanelChanged(e:Event):void
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
