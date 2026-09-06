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
 * EnumWidgetModes.
 * The appearances this application can be displayed in. These values are text keys as
 * well: the panel of the settings displays them.
 *
 * MAIN FEATURES:
 * - the desktop and the mobile appearance, and the automatic one
 * - the automatic mode takes the desktop appearance while the stage is wider than tall
 *   and the mobile one while it is not, so it follows the turning of a device
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumWidgetModes
  {
    /**
     * Returns the text key of the mode following the dimensions of the stage.
     */
    public static function WIDGET_MODE_AUTOMATIC():String
    {
      return "[WIDGET_MODE_AUTOMATIC]";
    }
    /**
     * Returns the text key of the desktop appearance.
     */
    public static function WIDGET_MODE_DESKTOP():String
    {
      return "[WIDGET_MODE_DESKTOP]";
    }
    /**
     * Returns the text key of the mobile appearance.
     */
    public static function WIDGET_MODE_MOBILE():String
    {
      return "[WIDGET_MODE_MOBILE]";
    }
  }
}
