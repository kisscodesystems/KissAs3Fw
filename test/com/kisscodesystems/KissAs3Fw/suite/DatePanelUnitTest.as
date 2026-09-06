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
 * DatePanelUnitTest
 * Checks the DatePanel component.
 *
 * MAIN FEATURES:
 * - the selected date can be set and read back, both as a string and as an object
 * - the hours and the minutes are only taken while those are selectable
 * - a null date means the current one
 * - the dimensions come from the calendar view
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.ui.DatePanel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class DatePanelUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function DatePanelUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "DatePanel";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const datePanel:DatePanel = new DatePanel(application);
      addTested(datePanel);
      // a fresh panel holds the date format of the config and it displays no hours
      assertEquals("getDateFormat of a fresh DatePanel"
        , application.getComponentsConfig().getDatePanelDateFormat(), datePanel.getDateFormat());
      assertFalse("getHoursAndMinutes of a fresh DatePanel", datePanel.getHoursAndMinutes());
      assertTrue("a fresh DatePanel is as wide as its calendar view", datePanel.getDw() > 0);
      assertTrue("a fresh DatePanel is as tall as its calendar view", datePanel.getDh() > 0);
      // the selected date can be set, the hours are dropped while those are not selectable
      const testDate:Date = new Date(2026, 7, 14, 13, 45);
      datePanel.setSelectedDate(testDate);
      assertEquals("getSelectedDate of the selected date", "2026-08-14", datePanel.getSelectedDate());
      assertEquals("the year of the selected date object", 2026, datePanel.getSelectedDateObject().getFullYear());
      assertEquals("the month of the selected date object", 7, datePanel.getSelectedDateObject().getMonth());
      assertEquals("the day of the selected date object", 14, datePanel.getSelectedDateObject().getDate());
      assertEquals("the hours of the selected date object", 0, datePanel.getSelectedDateObject().getHours());
      // the date object that comes out is a copy, so the panel can not be poisoned by it
      const dateObject:Date = datePanel.getSelectedDateObject();
      dateObject.setFullYear(1970);
      assertEquals("the selected date object is a copy", 2026, datePanel.getSelectedDateObject().getFullYear());
      // the displayed date is the selected one, formatted
      assertEquals("getDisplayedDate of the selected date", "2026-08-14", datePanel.getDisplayedDate());
      // the format can be replaced
      datePanel.setDateFormat("yyyy");
      assertEquals("getDateFormat after setDateFormat", "yyyy", datePanel.getDateFormat());
      assertEquals("getDisplayedDate in the new format", "2026", datePanel.getDisplayedDate());
      datePanel.setDateFormat(application.getComponentsConfig().getDatePanelDateFormat());
      // the hours and the minutes become selectable, so those are taken from now
      datePanel.setHoursAndMinutes(true);
      assertTrue("getHoursAndMinutes after setHoursAndMinutes(true)", datePanel.getHoursAndMinutes());
      assertEquals("getDateFormat of the panel of the hours and the minutes"
        , application.getComponentsConfig().getDatePanelDateTimeFormat(), datePanel.getDateFormat());
      datePanel.setSelectedDate(testDate);
      assertEquals("getSelectedDate with the hours and the minutes"
        , "2026-08-14 13:45", datePanel.getSelectedDate());
      assertEquals("the hours of the selected date object", 13, datePanel.getSelectedDateObject().getHours());
      assertEquals("the minutes of the selected date object", 45, datePanel.getSelectedDateObject().getMinutes());
      // and the hours are dropped again as soon as those are not selectable any more
      datePanel.setHoursAndMinutes(false);
      assertFalse("getHoursAndMinutes after setHoursAndMinutes(false)", datePanel.getHoursAndMinutes());
      datePanel.setSelectedDate(testDate);
      assertEquals("getSelectedDate without the hours and the minutes"
        , "2026-08-14", datePanel.getSelectedDate());
      // a null date means the current one
      datePanel.setSelectedDate(null);
      assertEquals("the year of the current date", new Date().getFullYear()
        , datePanel.getSelectedDateObject().getFullYear());
      // the static content can be repositioned from the outside
      datePanel.reposStaticContent();
      assertTrue("the DatePanel is still as wide as its calendar view", datePanel.getDw() > 0);
      // the dimensions come from the calendar view, so the setters do nothing
      const dwBefore:int = datePanel.getDw();
      const dhBefore:int = datePanel.getDh();
      datePanel.setDw(900);
      datePanel.setDh(900);
      datePanel.setDwh(900, 900);
      assertEquals("setDw, setDh and setDwh do not change the width", dwBefore, datePanel.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", dhBefore, datePanel.getDh());
      // every button of the panel follows its enabled state
      datePanel.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", datePanel.getEnabled());
      datePanel.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", datePanel.getEnabled());
      runBaseSpriteTests(datePanel);
      removeTested(datePanel);
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
