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
 * EnumOrientations.
 * The ways the elements of a content can be arranged. These values are text keys as
 * well: the panel of the settings displays the first three of them.
 *
 * MAIN FEATURES:
 * - the vertical and the horizontal arrangement, and the manual one
 * - the manual orientation leaves every widget where the one using the application has
 *   dragged it, the other two arrange the widgets of the container automatically
 * - the flowing and the docking arrangements are layout modes of a content and no
 *   arrangements of a widget container: the panel of the settings never offers them,
 *   and the application orientation can not be set to one of them
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumOrientations
  {
    /**
     * Returns the text key of the orientation leaving every widget where it has been
     * dragged.
     */
    public static function ORIENTATION_MANUAL():String
    {
      return "[ORIENTATION_MANUAL]";
    }
    /**
     * Returns the text key of the orientation arranging the widgets below each other.
     */
    public static function ORIENTATION_VERTICAL():String
    {
      return "[ORIENTATION_VERTICAL]";
    }
    /**
     * Returns the text key of the orientation arranging the widgets next to each other.
     */
    public static function ORIENTATION_HORIZONTAL():String
    {
      return "[ORIENTATION_HORIZONTAL]";
    }
    /**
     * Returns the text key of the orientation placing the elements next to each other
     * and breaking the row every time the width of the content has been filled up.
     */
    public static function ORIENTATION_FLOW():String
    {
      return "[ORIENTATION_FLOW]";
    }
    /**
     * Returns the text key of the orientation docking every element to one side of the
     * content, every one of them taking a strip of the room the ones before it left.
     */
    public static function ORIENTATION_DOCK():String
    {
      return "[ORIENTATION_DOCK]";
    }
  }
}
