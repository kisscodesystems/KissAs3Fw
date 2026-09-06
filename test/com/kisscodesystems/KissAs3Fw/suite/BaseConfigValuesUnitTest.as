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
 * BaseConfigValuesUnitTest
 * Checks the BaseConfigValues of the framework.
 *
 * MAIN FEATURES:
 * - a key that stands in the xml comes back in the type it has been asked in
 * - a key that is not in the xml gives the default value back
 * - a value that can not be converted gives the default value back as well
 * - an xml that can not be parsed at all leaves every default value in place
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseConfigValues;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseConfigValuesUnitTest extends BaseUnitTest
  {
    private static const CONFIG_XML:String = "<config name=\"the config of the test\">"
        + "<value key=\"aString\">the value of the string</value>"
        + "<value key=\"anInt\">42</value>"
        + "<value key=\"aNumber\">4.25</value>"
        + "<value key=\"aColorX\">0xFF8800</value>"
        + "<value key=\"aColorHash\">#FF8800</value>"
        + "<value key=\"aTrue\">true</value>"
        + "<value key=\"aFalse\">false</value>"
        + "<value key=\"notANumber\">this is not a number</value>"
        + "<value key=\"\">a value without a key</value>"
        + "</config>";
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseConfigValuesUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseConfigValues";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const values:BaseConfigValues = new BaseConfigValues(application, CONFIG_XML);
      // the keys of the xml are found, everything else is not
      assertTrue("hasKey of a key of the xml", values.hasKey("aString"));
      assertFalse("hasKey of a key that is not in the xml", values.hasKey("thisKeyDoesNotExist"));
      assertFalse("a value element without a key is skipped", values.hasKey(""));
      // every getter gives the value of the xml back in its own type
      assertEquals("getString of a key of the xml"
        , "the value of the string", values.getString("aString", "the default one"));
      assertEquals("getInt of a key of the xml", 42, values.getInt("anInt", 7));
      assertEquals("getNumber of a key of the xml", 4.25, values.getNumber("aNumber", 7.5));
      assertEquals("getColor of a 0x color of the xml", 0xFF8800, values.getColor("aColorX", 0));
      assertEquals("getColor of a hashmark color of the xml", 0xFF8800, values.getColor("aColorHash", 0));
      assertTrue("getBoolean of a true of the xml", values.getBoolean("aTrue", false));
      assertFalse("getBoolean of a false of the xml", values.getBoolean("aFalse", true));
      // a key that is not in the xml gives the default value back
      assertEquals("getString of a key that is not in the xml"
        , "the default one", values.getString("thisKeyDoesNotExist", "the default one"));
      assertEquals("getInt of a key that is not in the xml", 7, values.getInt("thisKeyDoesNotExist", 7));
      assertEquals("getNumber of a key that is not in the xml"
        , 7.5, values.getNumber("thisKeyDoesNotExist", 7.5));
      assertEquals("getColor of a key that is not in the xml"
        , 0x123456, values.getColor("thisKeyDoesNotExist", 0x123456));
      assertTrue("getBoolean of a key that is not in the xml"
        , values.getBoolean("thisKeyDoesNotExist", true));
      // a value that can not be converted gives the default value back
      assertEquals("getInt of a value that is not a number", 7, values.getInt("notANumber", 7));
      assertEquals("getColor of a value that is not a color", 0x123456, values.getColor("notANumber", 0x123456));
      values.destroy();
      // an xml that can not be parsed at all leaves every default value in place
      const broken:BaseConfigValues = new BaseConfigValues(application, "this is not an xml at all");
      assertFalse("hasKey of a broken xml", broken.hasKey("aString"));
      assertEquals("getString of a broken xml", "the default one", broken.getString("aString", "the default one"));
      broken.destroy();
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
