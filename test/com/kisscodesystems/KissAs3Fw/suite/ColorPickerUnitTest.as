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
 * ColorPickerUnitTest
 * Checks the ColorPicker component.
 *
 * MAIN FEATURES:
 * - the color of the panel of this picker is reached through the picker itself
 * - the panel opens and closes, and the size of the own button comes back on closing
 * - a color committed in the panel closes the picker and is reported by the picker
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ColorPicker;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ColorPickerUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ColorPickerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ColorPicker";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const zeros:String = application.getComponentsConfig().getColorRgbInputZeros();
      const colorPicker:ColorPicker = new ColorPicker(application);
      addTested(colorPicker);
      colorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), colorPickerChanged);
      // a fresh picker is closed, it is as small as its own button and its panel holds the
      // zeros of the config
      assertFalse("isOpened of a fresh ColorPicker", colorPicker.isOpened());
      assertEquals("getTextType of a fresh ColorPicker"
        , EnumTextTypes.TEXT_TYPE_MID(), colorPicker.getTextType());
      assertEquals("getRGBColor of a fresh ColorPicker", zeros, colorPicker.getRGBColor());
      assertTrue("a fresh ColorPicker is as wide as its button", colorPicker.getDw() > 0);
      assertTrue("a fresh ColorPicker is as tall as its button", colorPicker.getDh() > 0);
      // the color of the panel is reached through the picker, and the picker reports it
      colorPicker.setRGBColor("3366CC");
      assertEquals("getRGBColor after setRGBColor", "3366CC", colorPicker.getRGBColor());
      assertEquals("one changed event after a set of the color", 1, changedCount);
      // the open picker is as large as its panel, the closed one as large as its own button
      const closedDw:int = colorPicker.getDw();
      const closedDh:int = colorPicker.getDh();
      colorPicker.open();
      assertTrue("isOpened after open", colorPicker.isOpened());
      assertTrue("the open ColorPicker is wider than its button", colorPicker.getDw() > closedDw);
      assertTrue("the open ColorPicker is taller than its button", colorPicker.getDh() > closedDh);
      // a silent color is committed without a changed event of it, so it leaves the open
      // picker open as well: only a color picked by the one using it closes that picker
      colorPicker.setRGBColor("445566", false);
      assertEquals("getRGBColor after a silent setRGBColor", "445566", colorPicker.getRGBColor());
      assertEquals("no changed event after a silent setRGBColor", 1, changedCount);
      assertTrue("isOpened after a silent setRGBColor", colorPicker.isOpened());
      // a color committed in the panel closes the picker
      colorPicker.setRGBColor("AABBCC");
      assertFalse("isOpened after a color has been committed", colorPicker.isOpened());
      assertEquals("two changed events after the second set of the color", 2, changedCount);
      assertEquals("the closed ColorPicker is as wide as its button again", closedDw, colorPicker.getDw());
      assertEquals("the closed ColorPicker is as tall as its button again", closedDh, colorPicker.getDh());
      // the picker can be closed while it is already a closed one
      colorPicker.open();
      colorPicker.close();
      assertFalse("isOpened after close", colorPicker.isOpened());
      // the dimensions come from the own button or from the open panel, so the setters do nothing
      colorPicker.setDw(900);
      colorPicker.setDh(900);
      colorPicker.setDwh(900, 900);
      assertEquals("setDw, setDh and setDwh do not change the width", closedDw, colorPicker.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", closedDh, colorPicker.getDh());
      // the panel of the picker follows the enabled state of it
      colorPicker.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", colorPicker.getEnabled());
      colorPicker.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", colorPicker.getEnabled());
      runBaseSpriteTests(colorPicker);
      colorPicker.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), colorPickerChanged);
      removeTested(colorPicker);
    }
    /**
     * Counts the changed events of the tested picker.
     * @param e the changed event
     */
    private function colorPickerChanged(e:Event):void
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
