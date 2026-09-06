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
 * EnumOkCancel.
 * The two answers of a confirm. These values are text keys as well: the buttons of the
 * confirm display them.
 *
 * MAIN FEATURES:
 * - the ok and the cancel answer
 * - the one asking the question listens on the dispatcher of the application for the
 *   unique string of that question plus one of these two values
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumOkCancel
  {
    /**
     * Returns the text key of the ok answer of a confirm.
     */
    public static function OC_OK():String
    {
      return "[OC_OK]";
    }
    /**
     * Returns the text key of the cancel answer of a confirm.
     */
    public static function OC_CANCEL():String
    {
      return "[OC_CANCEL]";
    }
  }
}
