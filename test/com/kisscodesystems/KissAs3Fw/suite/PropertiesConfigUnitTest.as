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
 * PropertiesConfigUnitTest
 * Checks the PropertiesConfig of the framework.
 *
 * MAIN FEATURES:
 * - every property of the application comes from the embedded configuration xml
 * - the identifier of the application is generated, and it is unique in every instance
 * - the two homepage getters hand a copy out, so the caller can not rewrite the config
 * - a fresh instance is built and destroyed here: the one of the running application is
 *   left alone, destroying that one would take the values out of the test itself
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.config.PropertiesConfig;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class PropertiesConfigUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function PropertiesConfigUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "PropertiesConfig";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const config:PropertiesConfig = new PropertiesConfig(application);
      // every property arrives from the embedded xml, so none of them can stand empty
      assertNotNull("getApplicationName gives a value", config.getApplicationName());
      assertNotNull("getApplicationVersion gives a value", config.getApplicationVersion());
      assertNotNull("getApplicationReleaseDate gives a value", config.getApplicationReleaseDate());
      assertTrue("getApplicationName is not empty", config.getApplicationName().length > 0);
      assertTrue("getApplicationVersion is not empty", config.getApplicationVersion().length > 0);
      assertTrue("getApplicationReleaseDate is not empty"
        , config.getApplicationReleaseDate().length > 0);
      // the identifier is generated once and it stands as long as this object lives
      const applicationId:String = config.getApplicationId();
      assertNotNull("getApplicationId gives a value", applicationId);
      assertTrue("getApplicationId is not empty", applicationId.length > 0);
      assertEquals("getApplicationId gives the same value again", applicationId
        , config.getApplicationId());
      // the two homepage getters hand a copy out: writing that array leaves the config alone
      const homepageTxtLength:int = config.getApplicationSoftwareHomepageTxt().length;
      const homepageUrlLength:int = config.getApplicationSoftwareHomepageUrl().length;
      const homepageTxt:Array = config.getApplicationSoftwareHomepageTxt();
      const homepageUrl:Array = config.getApplicationSoftwareHomepageUrl();
      assertNotNull("getApplicationSoftwareHomepageTxt gives an array", homepageTxt);
      assertNotNull("getApplicationSoftwareHomepageUrl gives an array", homepageUrl);
      homepageTxt.push("this is written into the copy only");
      homepageUrl.push("this is written into the copy only");
      assertEquals("getApplicationSoftwareHomepageTxt is not changed by writing its copy"
        , homepageTxtLength, config.getApplicationSoftwareHomepageTxt().length);
      assertEquals("getApplicationSoftwareHomepageUrl is not changed by writing its copy"
        , homepageUrlLength, config.getApplicationSoftwareHomepageUrl().length);
      // a second instance generates an identifier of its own
      const other:PropertiesConfig = new PropertiesConfig(application);
      assertFalse("the identifier of another instance is a different one"
        , other.getApplicationId() == applicationId);
      other.destroy();
      config.destroy();
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
