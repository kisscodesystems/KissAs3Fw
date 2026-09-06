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
 * EnumBoxFrames.
 * The frames a box of this application can be painted with. These values are text keys
 * as well: the panel of the settings displays them.
 *
 * MAIN FEATURES:
 * - the full frame, the horizontal and the vertical lines of it only, and no frame
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumBoxFrames
  {
    /**
     * Returns the text key of the frame painted on every side of a box.
     */
    public static function BOX_FRAME_FULL():String
    {
      return "[BOX_FRAME_FULL]";
    }
    /**
     * Returns the text key of the frame painted on the top and the bottom of a box
     * only.
     */
    public static function BOX_FRAME_HORIZONTAL():String
    {
      return "[BOX_FRAME_HORIZONTAL]";
    }
    /**
     * Returns the text key of the frame painted on the left and the right side of a box
     * only.
     */
    public static function BOX_FRAME_VERTICAL():String
    {
      return "[BOX_FRAME_VERTICAL]";
    }
    /**
     * Returns the text key of the box that has no frame at all.
     */
    public static function BOX_FRAME_NONE():String
    {
      return "[BOX_FRAME_NONE]";
    }
  }
}
