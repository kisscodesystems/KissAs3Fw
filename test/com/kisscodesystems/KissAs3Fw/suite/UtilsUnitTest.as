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
 * UtilsUnitTest
 * Checks the utility functions of the framework.
 *
 * MAIN FEATURES:
 * - the digits of an int are summed and the check digit of one is validated
 * - a color is turned into a six digit string, and a dark color asks for a bright shadow
 * - a long text is shortened at a whole word, and the seconds are displayed as a time
 * - a date arrives from a database like string, and the random values stay in their range
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.util.Utils;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class UtilsUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function UtilsUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Utils";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      // the utils of the application are the very ones every object of the framework
      // reaches, so those are tested here instead of a fresh set of them
      const utils:Utils = application.getUtils();
      assertNotNull("getUtils of the application", utils);
      // the digits of an int are summed, a single digit one is the sum of itself
      assertEquals("getSumOfDigits of 0", 0, utils.getSumOfDigits(0));
      assertEquals("getSumOfDigits of 7", 7, utils.getSumOfDigits(7));
      assertEquals("getSumOfDigits of 123", 6, utils.getSumOfDigits(123));
      assertEquals("getSumOfDigits of 999", 27, utils.getSumOfDigits(999));
      // the last digit of a valid int is the sum of the others modulo ten: the 124 is
      // valid because the 1 plus the 2 gives the 3, and 3 modulo 10 is not the 4, so
      // the 123 is the valid one instead of it
      assertTrue("isValidInt of 123", utils.isValidInt(123));
      assertFalse("isValidInt of 124", utils.isValidInt(124));
      // an int of one single digit carries no check digit at all
      assertFalse("isValidInt of 5", utils.isValidInt(5));
      // a color arrives as a six digit uppercase string, shorter ones are padded
      assertEquals("colorToString of 0x000000", "000000", utils.colorToString(0x000000));
      assertEquals("colorToString of 0xffffff", "FFFFFF", utils.colorToString(0xffffff));
      assertEquals("colorToString of 0xff", "0000FF", utils.colorToString(0xff));
      assertEquals("colorToString of 0xabcdef", "ABCDEF", utils.colorToString(0xabcdef));
      // a dark color asks for a bright shadow, a bright one does not: the bound comes
      // from the components config, so it is asked for instead of being coded here
      assertTrue("brightShadowToApply of 000000", utils.brightShadowToApply("000000"));
      assertFalse("brightShadowToApply of FFFFFF", utils.brightShadowToApply("FFFFFF"));
      assertFalse("brightShadowToApply of FF0000", utils.brightShadowToApply("FF0000"));
      // the seconds are displayed as a time, the hours stay away while there are none
      assertEquals("secondsToDisplayedTime of 0", "0:00", utils.secondsToDisplayedTime(0));
      assertEquals("secondsToDisplayedTime of 9", "0:09", utils.secondsToDisplayedTime(9));
      assertEquals("secondsToDisplayedTime of 59", "0:59", utils.secondsToDisplayedTime(59));
      assertEquals("secondsToDisplayedTime of 60", "1:00", utils.secondsToDisplayedTime(60));
      assertEquals("secondsToDisplayedTime of 3599", "59:59", utils.secondsToDisplayedTime(3599));
      assertEquals("secondsToDisplayedTime of 3600", "1:00:00", utils.secondsToDisplayedTime(3600));
      assertEquals("secondsToDisplayedTime of 3661", "1:01:01", utils.secondsToDisplayedTime(3661));
      // the whitespace is trimmed off both of the ends, and a null gives an empty string
      assertEquals("trim of a padded string", "abc", utils.trim("   abc   "));
      assertEquals("trim of a string with no padding", "abc", utils.trim("abc"));
      assertEquals("trim of an inner space", "a b", utils.trim("  a b  "));
      assertEquals("trim of null", "", utils.trim(null));
      // a text that is shorter than the limit is left alone
      const limit:int = application.getComponentsConfig().getShortTextLimit();
      const ending:String = application.getComponentsConfig().getShortTextEnding();
      assertEquals("createShortText of null", "", utils.createShortText(null));
      assertEquals("createShortText of a short text", "a short one", utils.createShortText("a short one"));
      // a text that is longer than the limit is cut at the last whole word fitting in it
      var longWords:String = "";
      while (longWords.length <= limit)
      {
        longWords += "word ";
      }
      const shortenedWords:String = utils.createShortText(longWords);
      assertTrue("createShortText cuts a long text", shortenedWords.length < longWords.length);
      assertTrue("createShortText appends the ending"
        , shortenedWords.substr(shortenedWords.length - ending.length) == ending);
      assertTrue("createShortText cuts at a whole word"
        , shortenedWords.indexOf(" ") > -1);
      // a long text holding no space at all is cut at the limit itself
      var longWord:String = "";
      while (longWord.length <= limit)
      {
        longWord += "x";
      }
      assertEquals("createShortText of a text with no space"
        , limit + ending.length, utils.createShortText(longWord).length);
      // a date arrives from a database like string, the missing parts stand on zero
      const fullDate:Date = utils.getDateFromTime("2026-08-17 13:45:59");
      assertNotNull("getDateFromTime of a full timestamp", fullDate);
      assertEquals("getDateFromTime year", 2026, fullDate.fullYear);
      // the month of a Date counts from zero, so the eighth month is the seven
      assertEquals("getDateFromTime month", 7, fullDate.month);
      assertEquals("getDateFromTime date", 17, fullDate.date);
      assertEquals("getDateFromTime hours", 13, fullDate.hours);
      assertEquals("getDateFromTime minutes", 45, fullDate.minutes);
      assertEquals("getDateFromTime seconds", 59, fullDate.seconds);
      const dayOnly:Date = utils.getDateFromTime("2026-08-17");
      assertEquals("getDateFromTime of a day only, year", 2026, dayOnly.fullYear);
      assertEquals("getDateFromTime of a day only, hours", 0, dayOnly.hours);
      // a null gives the current moment instead of nothing at all
      assertNotNull("getDateFromTime of null", utils.getDateFromTime(null));
      // a random int stays between the two bounds, both of them included
      for (var i:int = 0; i < 50; i++)
      {
        const randomInt:int = utils.getRandomInt(3, 5);
        assertTrue("getRandomInt(3, 5) stays in its range", randomInt >= 3 && randomInt <= 5);
      }
      assertEquals("getRandomInt of one single possible value", 8, utils.getRandomInt(8, 8));
      // every guid differs from the one asked for before it
      const guid1:String = utils.getRandomGuid();
      const guid2:String = utils.getRandomGuid();
      assertNotNull("getRandomGuid gives a value", guid1);
      assertTrue("getRandomGuid gives a non empty value", guid1.length > 0);
      assertFalse("two guids differ", guid1 == guid2);
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
