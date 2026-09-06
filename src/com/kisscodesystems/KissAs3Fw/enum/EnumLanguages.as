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
 * EnumLanguages.
 * The languages this framework is available in. These values are text keys as well:
 * the language setter displays them.
 *
 * MAIN FEATURES:
 * - english and hungarian
 * - the extenders of this framework can add their own languages to the label manager
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumLanguages
  {
    /**
     * Returns the text key of the english language.
     */
    public static function EN():String
    {
      return "[EN]";
    }
    /**
     * Returns the text key of the hungarian language.
     */
    public static function HU():String
    {
      return "[HU]";
    }
  }
}
