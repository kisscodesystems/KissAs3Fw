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
 * BaseConfigValues.
 * The parsed content of one configuration xml file of a config class.
 *
 * MAIN FEATURES:
 * - parses a config xml string into a key and value store
 * - every getter takes the default value and returns it if the key is not in the xml
 * - so an application configuration xml only has to hold the values it wants to change
 * - the values are converted to the asked type, an unconvertible value is logged and skipped
 * - the xml format is: <config name="..."><value key="...">the value</value></config>
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  public class BaseConfigValues
  {
    private var application:Application = null;
    private var values:Object = null;
    /**
     * Constructs the config value store and parses the given config xml string into it.
     * @param applicationRef the main application reference
     * @param configXmlString the content of the configuration xml file
     */
    public function BaseConfigValues(applicationRef:Application, configXmlString:String):void
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
      application.trace("<" + this + " BaseConfigValues> called.", 1);
      application.trace("<" + this + " BaseConfigValues> configXmlString: " + configXmlString, 0);
      values = new Object();
      parseConfigXmlString(configXmlString);
      application.trace("<" + this + " BaseConfigValues> constructed.", 1);
    }
    /**
     * Returns true if the given key has been found in the configuration xml.
     * @param key the key of the configuration value
     */
    public function hasKey(key:String):Boolean
    {
      return values[key] != undefined;
    }
    /**
     * Returns the string value of the given key, the default value if it is not in the xml.
     * @param key the key of the configuration value
     * @param defaultValue the value to be returned if the key is not in the xml
     */
    public function getString(key:String, defaultValue:String):String
    {
      application.trace("<" + this + " BaseConfigValues getString> called.", 1);
      application.trace("<" + this + " BaseConfigValues getString> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues getString> defaultValue: " + defaultValue, 0);
      if (!hasKey(key))
      {
        return defaultValue;
      }
      return String(values[key]);
    }
    /**
     * Returns the int value of the given key, the default value if it is not in the xml.
     * @param key the key of the configuration value
     * @param defaultValue the value to be returned if the key is not in the xml
     */
    public function getInt(key:String, defaultValue:int):int
    {
      application.trace("<" + this + " BaseConfigValues getInt> called.", 1);
      application.trace("<" + this + " BaseConfigValues getInt> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues getInt> defaultValue: " + defaultValue, 0);
      if (!hasKey(key))
      {
        return defaultValue;
      }
      const value:Number = parseFloat(String(values[key]));
      if (isNaN(value))
      {
        traceInvalidValue(key, "int");
        return defaultValue;
      }
      return int(value);
    }
    /**
     * Returns the number value of the given key, the default value if it is not in the xml.
     * @param key the key of the configuration value
     * @param defaultValue the value to be returned if the key is not in the xml
     */
    public function getNumber(key:String, defaultValue:Number):Number
    {
      application.trace("<" + this + " BaseConfigValues getNumber> called.", 1);
      application.trace("<" + this + " BaseConfigValues getNumber> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues getNumber> defaultValue: " + defaultValue, 0);
      if (!hasKey(key))
      {
        return defaultValue;
      }
      const value:Number = parseFloat(String(values[key]));
      if (isNaN(value))
      {
        traceInvalidValue(key, "Number");
        return defaultValue;
      }
      return value;
    }
    /**
     * Returns the color value of the given key, the default value if it is not in the xml.
     * The 0xRRGGBB, the #RRGGBB and the plain decimal forms are all accepted.
     * @param key the key of the configuration value
     * @param defaultValue the value to be returned if the key is not in the xml
     */
    public function getColor(key:String, defaultValue:Number):Number
    {
      application.trace("<" + this + " BaseConfigValues getColor> called.", 1);
      application.trace("<" + this + " BaseConfigValues getColor> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues getColor> defaultValue: " + defaultValue, 0);
      if (!hasKey(key))
      {
        return defaultValue;
      }
      const text:String = String(values[key]);
      var value:Number = Number.NaN;
      if (text.indexOf("0x") == 0 || text.indexOf("0X") == 0)
      {
        value = parseInt(text.substr(2), 16);
      }
      else if (text.indexOf("#") == 0)
      {
        value = parseInt(text.substr(1), 16);
      }
      else
      {
        value = parseFloat(text);
      }
      if (isNaN(value))
      {
        traceInvalidValue(key, "color");
        return defaultValue;
      }
      return value;
    }
    /**
     * Returns the boolean value of the given key, the default value if it is not in the xml.
     * The true, false, 1 and 0 forms are all accepted.
     * @param key the key of the configuration value
     * @param defaultValue the value to be returned if the key is not in the xml
     */
    public function getBoolean(key:String, defaultValue:Boolean):Boolean
    {
      application.trace("<" + this + " BaseConfigValues getBoolean> called.", 1);
      application.trace("<" + this + " BaseConfigValues getBoolean> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues getBoolean> defaultValue: " + defaultValue, 0);
      if (!hasKey(key))
      {
        return defaultValue;
      }
      const text:String = String(values[key]).toLowerCase();
      if (text == "true" || text == "1")
      {
        return true;
      }
      if (text == "false" || text == "0")
      {
        return false;
      }
      traceInvalidValue(key, "Boolean");
      return defaultValue;
    }
    /**
     * Parses the given config xml string into the key and value store.
     * @param configXmlString the content of the configuration xml file
     */
    private function parseConfigXmlString(configXmlString:String):void
    {
      application.trace("<" + this + " BaseConfigValues parseConfigXmlString> called.", 1);
      application.trace("<" + this + " BaseConfigValues parseConfigXmlString> configXmlString: " + configXmlString, 0);
      const ignoreWhitespaceOrig:Boolean = XML.ignoreWhitespace;
      try
      {
        // a value can begin or end with a space on purpose, so it must not be trimmed away
        XML.ignoreWhitespace = false;
        const configXml:XML = new XML(configXmlString);
        application.trace("<" + this + " BaseConfigValues parseConfigXmlString> parsing config: " + configXml.@name, 0);
        for each (var valueXml:XML in configXml.child("value"))
        {
          const key:String = valueXml.@key;
          if (key == null || key == "")
          {
            application.trace("<" + this + " BaseConfigValues parseConfigXmlString> a value element without a key has been skipped.", 6);
          }
          else
          {
            values[key] = valueXml.text();
            application.trace("<" + this + " BaseConfigValues parseConfigXmlString> " + key + ": " + values[key], 0);
          }
        }
        application.trace("<" + this + " BaseConfigValues parseConfigXmlString> parsing done.", 0);
      }
      catch (e:*)
      {
        application.trace("<" + this + " BaseConfigValues parseConfigXmlString> unable to parse the config xml: " + e, 7);
      }
      XML.ignoreWhitespace = ignoreWhitespaceOrig;
    }
    /**
     * Logs that the value of the given key cannot be converted to the asked type.
     * @param key the key of the configuration value
     * @param typeName the name of the type the value should have been converted to
     */
    private function traceInvalidValue(key:String, typeName:String):void
    {
      application.trace("<" + this + " BaseConfigValues traceInvalidValue> called.", 1);
      application.trace("<" + this + " BaseConfigValues traceInvalidValue> key: " + key, 0);
      application.trace("<" + this + " BaseConfigValues traceInvalidValue> typeName: " + typeName, 0);
      application.trace("<" + this + " BaseConfigValues traceInvalidValue> the value of " + key + " is not a valid " + typeName + ", the default value is used: " + values[key], 6);
    }
    /**
     * Frees all references held by this config value store.
     */
    public function destroy():void
    {
      application.trace("<" + this + " BaseConfigValues destroy> called.", 1);
      values = null;
      application = null;
    }
  }
}
