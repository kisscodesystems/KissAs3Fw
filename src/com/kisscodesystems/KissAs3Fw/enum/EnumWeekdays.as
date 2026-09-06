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
 * EnumWeekdays.
 * The days of the week. These values are text keys: every object displaying a date asks
 * for the name of the weekday here.
 *
 * MAIN FEATURES:
 * - the seven weekdays, from monday to sunday
 * - the label manager holds them in two arrays: one starting with monday and one
 *   starting with sunday, because the day index of a date object points into that one
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumWeekdays
  {
    /**
     * Returns the text key of the name of monday.
     */
    public static function WEEKDAY_MONDAY():String
    {
      return "[WEEKDAY_MONDAY]";
    }
    /**
     * Returns the text key of the name of tuesday.
     */
    public static function WEEKDAY_TUESDAY():String
    {
      return "[WEEKDAY_TUESDAY]";
    }
    /**
     * Returns the text key of the name of wednesday.
     */
    public static function WEEKDAY_WEDNESDAY():String
    {
      return "[WEEKDAY_WEDNESDAY]";
    }
    /**
     * Returns the text key of the name of thursday.
     */
    public static function WEEKDAY_THURSDAY():String
    {
      return "[WEEKDAY_THURSDAY]";
    }
    /**
     * Returns the text key of the name of friday.
     */
    public static function WEEKDAY_FRIDAY():String
    {
      return "[WEEKDAY_FRIDAY]";
    }
    /**
     * Returns the text key of the name of saturday.
     */
    public static function WEEKDAY_SATURDAY():String
    {
      return "[WEEKDAY_SATURDAY]";
    }
    /**
     * Returns the text key of the name of sunday.
     */
    public static function WEEKDAY_SUNDAY():String
    {
      return "[WEEKDAY_SUNDAY]";
    }
  }
}
