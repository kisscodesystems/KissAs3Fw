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
 * PropertiesConfig.
 * The properties of the application which cannot be changed while it is running.
 *
 * MAIN FEATURES:
 * - every value has a default coded into this class
 * - the defaults can be overwritten from the embedded configuration xml,
 *   resource/config/KissAs3FwPropertiesConfig.xml
 * - an application brings its own values in a small class extending this one:
 *   that class embeds its own xml and overrides readValuesFromConfigXml to call
 *   the super and then applyConfigXml with it, so the application values are
 *   applied on top of the framework ones and stay in an xml, not in the code
 * - the xml only has to hold the values it wants to change
 * - a class extending this one is still possible, it has to assign the protected
 *   variables after the super call, because the xml is applied by that super call
 */
package com.kisscodesystems.KissAs3Fw.config
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseConfigValues;
  import flash.crypto.generateRandomBytes;
  import flash.system.System;
  import flash.utils.ByteArray;
  public class PropertiesConfig
  {
    [Embed(source = "../resource/config/KissAs3FwPropertiesConfig.xml", mimeType = "application/octet-stream")]
    private var EmbeddedConfig:Class;
    private var embeddedConfigByteArray:ByteArray = new EmbeddedConfig() as ByteArray;
    protected var application:Application = null;
    private const applicationId:String = generateRandomBytes(1024).toString();
    protected var applicationName:String = "Application";
    protected var applicationVersion:String = "3.0";
    protected var applicationReleaseDate:String = "2026-08-29";
    protected var applicationSoftwareHomepageTxt:Array = new Array();
    protected var applicationSoftwareHomepageUrl:Array = new Array();
    // The name the identifier of the device is kept under, in the shared object and in
    // the encrypted local store alike: two applications giving the same name here look at
    // the very same value, so every application names it its own way.
    protected var deviceIdStoreName:String = "KissAs3FwDeviceId";
    // The secret the identifier of the device is enciphered with before it is written
    // onto the device. THE SECRET OF THE FRAMEWORK IS A PUBLIC ONE, it stands in the
    // configuration xml of it, so every application writes its own one into its own xml:
    // an application keeping this one enciphers with a secret anyone can read.
    protected var deviceIdSecret:String = "KissAs3FwDeviceIdSecret";
    /**
     * Constructs the properties config and applies the embedded configuration xml onto it.
     * @param applicationRef the main application reference
     */
    public function PropertiesConfig(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " PropertiesConfig> called.", 1);
      application.trace("<" + this + " PropertiesConfig> applicationRef: " + applicationRef, 0);
      readValuesFromConfigXml();
      application.trace("<" + this + " PropertiesConfig> constructed.", 1);
    }
    /**
     * Applies the embedded framework configuration xml onto the default values.
     */
    protected function readValuesFromConfigXml():void
    {
      application.trace("<" + this + " PropertiesConfig readValuesFromConfigXml> called.", 1);
      applyConfigXml(embeddedConfigByteArray.toString());
      embeddedConfigByteArray.clear();
      embeddedConfigByteArray = null;
    }
    /**
     * Overwrites the current values with the ones found in the given configuration xml.
     * A class extending this one applies its own embedded xml on top of the framework
     * one by overriding readValuesFromConfigXml, calling the super and then this.
     * @param configXmlString the content of a configuration xml file
     */
    protected function applyConfigXml(configXmlString:String):void
    {
      application.trace("<" + this + " PropertiesConfig applyConfigXml> called.", 1);
      application.trace("<" + this + " PropertiesConfig applyConfigXml> configXmlString: " + configXmlString, 0);
      const values:BaseConfigValues = new BaseConfigValues(application, configXmlString);
      applicationName = values.getString("applicationName", applicationName);
      applicationVersion = values.getString("applicationVersion", applicationVersion);
      applicationReleaseDate = values.getString("applicationReleaseDate", applicationReleaseDate);
      deviceIdStoreName = values.getString("deviceIdStoreName", deviceIdStoreName);
      deviceIdSecret = values.getString("deviceIdSecret", deviceIdSecret);
      values.destroy();
    }
    public function getApplicationId():String
    {
      return applicationId;
    }
    public function getApplicationName():String
    {
      return applicationName;
    }
    public function getApplicationVersion():String
    {
      return applicationVersion;
    }
    public function getApplicationReleaseDate():String
    {
      return applicationReleaseDate;
    }
    public function getApplicationSoftwareHomepageTxt():Array
    {
      return applicationSoftwareHomepageTxt.concat();
    }
    public function getApplicationSoftwareHomepageUrl():Array
    {
      return applicationSoftwareHomepageUrl.concat();
    }
    /**
     * Returns the name the identifier of the device is kept under on that device.
     */
    public function getDeviceIdStoreName():String
    {
      return deviceIdStoreName;
    }
    /**
     * Returns the secret the identifier of the device is enciphered with.
     */
    public function getDeviceIdSecret():String
    {
      return deviceIdSecret;
    }
    /**
     * Destroys this object and frees up everything. The identifier of the application is
     * a constant, so that one lives together with this object.
     */
    public function destroy():void
    {
      application.trace("<" + this + " PropertiesConfig destroy> called.", 1);
      if (embeddedConfigByteArray != null)
      {
        embeddedConfigByteArray.clear();
      }
      applicationSoftwareHomepageTxt.splice(0);
      applicationSoftwareHomepageUrl.splice(0);
      EmbeddedConfig = null;
      embeddedConfigByteArray = null;
      applicationName = null;
      applicationVersion = null;
      applicationReleaseDate = null;
      deviceIdStoreName = null;
      deviceIdSecret = null;
      applicationSoftwareHomepageTxt = null;
      applicationSoftwareHomepageUrl = null;
      application = null;
    }
  }
}
