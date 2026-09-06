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
 * EnumTextTypes.
 * The types a text of this application can be displayed with. The type tells the text
 * which font color and which font size it has to be painted with.
 *
 * MAIN FEATURES:
 * - the bright, the mid and the dark type
 * - every type has a text format and a text field height of its own in the dynamics
 *   config, so a text of one type is repainted when that format changes
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumTextTypes
  {
    /**
     * Returns the text key of the brightest and largest text type.
     */
    public static function TEXT_TYPE_BRIGHT():String
    {
      return "[TEXT_TYPE_BRIGHT]";
    }
    /**
     * Returns the text key of the text type of the everyday texts.
     */
    public static function TEXT_TYPE_MID():String
    {
      return "[TEXT_TYPE_MID]";
    }
    /**
     * Returns the text key of the darkest and smallest text type.
     */
    public static function TEXT_TYPE_DARK():String
    {
      return "[TEXT_TYPE_DARK]";
    }
  }
}
