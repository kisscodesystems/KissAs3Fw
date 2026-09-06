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
 * EnumYesNo.
 * The two answers of a question. These values are text keys: the object asking the
 * question displays them.
 *
 * MAIN FEATURES:
 * - the yes and the no answer
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumYesNo
  {
    /**
     * Returns the text key of the yes answer.
     */
    public static function YN_YES():String
    {
      return "[YN_YES]";
    }
    /**
     * Returns the text key of the no answer.
     */
    public static function YN_NO():String
    {
      return "[YN_NO]";
    }
  }
}
