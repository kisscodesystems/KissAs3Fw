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
 * EnumAppEnvs.
 * The environments this application can run in. The environment is not a displayed
 * value: it tells the application which backend it has to work with.
 *
 * MAIN FEATURES:
 * - the development, the test and the production environment
 * - these values are not text keys, so they are never displayed to anybody
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumAppEnvs
  {
    /**
     * Returns the name of the development environment.
     */
    public static function appEnvDev():String
    {
      return "appEnvDev";
    }
    /**
     * Returns the name of the test environment.
     */
    public static function appEnvTst():String
    {
      return "appEnvTst";
    }
    /**
     * Returns the name of the production environment.
     */
    public static function appEnvPrd():String
    {
      return "appEnvPrd";
    }
  }
}
