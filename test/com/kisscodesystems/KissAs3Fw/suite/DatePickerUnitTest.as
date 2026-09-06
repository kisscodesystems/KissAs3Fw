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
 * DatePickerUnitTest
 * Checks the DatePicker component.
 *
 * MAIN FEATURES:
 * - the selected date arrives onto the label of the button
 * - the panel opens and closes, and the closed width comes back on closing
 * - the changed event is dispatched by the picker, and not by its panel
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.DatePicker;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class DatePickerUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function DatePickerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "DatePicker";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const datePicker:DatePicker = new DatePicker(application);
      addTested(datePicker);
      datePicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), datePickerChanged);
      // a fresh picker is closed and it holds the date format of the config
      assertFalse("isOpened of a fresh DatePicker", datePicker.isOpened());
      assertEquals("getDateFormat of a fresh DatePicker"
        , application.getComponentsConfig().getDatePanelDateFormat(), datePicker.getDateFormat());
      assertFalse("getHoursAndMinutes of a fresh DatePicker", datePicker.getHoursAndMinutes());
      // the label of a fresh picker stands with the date of its panel already: that panel has
      // selected the current date while it was being built
      assertEquals("the label of a fresh DatePicker is the date of its panel"
        , datePicker.getSelectedDate(), datePicker.getText());
      assertEquals("getDisplayedDate of a fresh DatePicker is that very date"
        , datePicker.getSelectedDate(), datePicker.getDisplayedDate());
      // the width is taken and the label of the button follows it
      datePicker.setDw(300);
      assertEquals("getDw after setDw(300)", expectedDw(300), datePicker.getDw());
      // the selected date arrives onto the label of the button
      const testDate:Date = new Date(2026, 7, 14, 13, 45);
      // a date time pattern of its own, the one no config of this framework carries
      const testDateFormat:String = "dd/MM/yyyy";
      datePicker.setSelectedDate(testDate);
      assertEquals("getSelectedDate of the selected date", "2026-08-14", datePicker.getSelectedDate());
      assertEquals("getDisplayedDate of the selected date", "2026-08-14", datePicker.getDisplayedDate());
      assertEquals("getText of the label of the button", "2026-08-14", datePicker.getText());
      assertEquals("the year of the selected date object", 2026, datePicker.getSelectedDateObject().getFullYear());
      assertEquals("one changed event after a set of the selected date", 1, changedCount);
      // the pattern of the displayed date can be given, and the label follows it right away
      datePicker.setDateFormat(testDateFormat);
      assertEquals("getDateFormat after setDateFormat", testDateFormat, datePicker.getDateFormat());
      assertEquals("the label of the button after setDateFormat", "14/08/2026", datePicker.getText());
      datePicker.setDateFormat(application.getComponentsConfig().getDatePanelDateFormat());
      assertEquals("the label of the button after the pattern of the config has come back"
        , "2026-08-14", datePicker.getText());
      // the hours and the minutes can be made selectable
      datePicker.setHoursAndMinutes(true);
      assertTrue("getHoursAndMinutes after setHoursAndMinutes(true)", datePicker.getHoursAndMinutes());
      datePicker.setSelectedDate(testDate);
      assertEquals("getSelectedDate with the hours and the minutes"
        , "2026-08-14 13:45", datePicker.getSelectedDate());
      // switching the time on takes the pattern carrying it, so the label displays it as well
      assertEquals("the label of the button carries the time as well"
        , "2026-08-14 13:45", datePicker.getText());
      datePicker.setHoursAndMinutes(false);
      // the open picker is as tall as its panel, the closed one as tall as its label
      const closedDh:int = datePicker.getDh();
      datePicker.open();
      assertTrue("isOpened after open", datePicker.isOpened());
      assertTrue("the open DatePicker is taller than its label", datePicker.getDh() > closedDh);
      datePicker.close();
      assertFalse("isOpened after close", datePicker.isOpened());
      assertEquals("the closed DatePicker is as tall as its label again", closedDh, datePicker.getDh());
      assertEquals("the closed DatePicker is as wide as it has been asked for"
        , expectedDw(300), datePicker.getDw());
      // the height comes from the label or from the panel, so its setters do nothing
      datePicker.setDh(900);
      datePicker.setDwh(900, 900);
      assertEquals("setDh and setDwh do not change the height", closedDh, datePicker.getDh());
      assertEquals("setDwh does not change the width", expectedDw(300), datePicker.getDw());
      runBaseSpriteTests(datePicker);
      datePicker.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), datePickerChanged);
      removeTested(datePicker);
    }
    /**
     * Counts the changed events of the tested picker.
     * @param e the changed event
     */
    private function datePickerChanged(e:Event):void
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
