/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 * https://github.com/kisscodesystems/KissAs3Mp
 * DESCRIPTION:
 * CacheManager.
 * Stores data downloaded from the internet.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  public class CacheManager
  {
    protected var application:Application = null;
    private var cachedCountryIds:String = "";
    private var cachedCountryNames:String = "";
    private var cachedCountryCodes:String = "";
    private var cachedCountryPrefixes:String = "";
    /**
     * Constructs the cache manager.
     * @param applicationRef the application reference
     */
    public function CacheManager(applicationRef:Application):void
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
      application.trace("<CacheManager> called.", 1);
      application.trace("<CacheManager> applicationRef: " + applicationRef, 0);
      application.trace("<CacheManager> constructed.", 1);
    }
    /**
     * Stores the cached country ids.
     * @param s the country ids to be cached
     */
    public function setCachedCountryIds(s:String):void
    {
      application.trace("<CacheManager setCachedCountryIds> s: " + s, 0);
      cachedCountryIds = s;
    }
    /**
     * Returns the cached country ids.
     */
    public function getCachedCountryIds():String
    {
      return cachedCountryIds;
    }
    /**
     * Stores the cached country names.
     * @param s the country names to be cached
     */
    public function setCachedCountryNames(s:String):void
    {
      application.trace("<CacheManager setCachedCountryNames> s: " + s, 0);
      cachedCountryNames = s;
    }
    /**
     * Returns the cached country names.
     */
    public function getCachedCountryNames():String
    {
      return cachedCountryNames;
    }
    /**
     * Stores the cached country codes.
     * @param s the country codes to be cached
     */
    public function setCachedCountryCodes(s:String):void
    {
      application.trace("<CacheManager setCachedCountryCodes> s: " + s, 0);
      cachedCountryCodes = s;
    }
    /**
     * Returns the cached country codes.
     */
    public function getCachedCountryCodes():String
    {
      return cachedCountryCodes;
    }
    /**
     * Stores the cached country prefixes.
     * @param s the country prefixes to be cached
     */
    public function setCachedCountryPrefixes(s:String):void
    {
      application.trace("<CacheManager setCachedCountryPrefixes> s: " + s, 0);
      cachedCountryPrefixes = s;
    }
    /**
     * Returns the cached country prefixes.
     */
    public function getCachedCountryPrefixes():String
    {
      return cachedCountryPrefixes;
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<CacheManager destroy> called.", 1);
      cachedCountryIds = null;
      cachedCountryNames = null;
      cachedCountryCodes = null;
      cachedCountryPrefixes = null;
      application = null;
    }
  }
}
