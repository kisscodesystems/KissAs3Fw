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
 * EnumBackgroundAligns.
 * The ways the background image of this application can be painted onto the background.
 * These values are text keys as well: the panel of the settings displays them.
 *
 * MAIN FEATURES:
 * - no image at all, three centered ways and a mosaic of the image
 * - the three centered ways are the image scaled to fit inside the area, the image
 *   scaled to cover the whole area and the image painted in its own size
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumBackgroundAligns
  {
    /**
     * Returns the text key of the align painting no image at all.
     */
    public static function BACKGROUND_ALIGN_NONE():String
    {
      return "[BACKGROUND_ALIGN_NONE]";
    }
    /**
     * Returns the text key of the align scaling the image to fit inside the area, so
     * the whole image stays visible.
     */
    public static function BACKGROUND_ALIGN_CENTER1():String
    {
      return "[BACKGROUND_ALIGN_CENTER1]";
    }
    /**
     * Returns the text key of the align scaling the image to cover the whole area, so
     * the image is cut on one of its sides.
     */
    public static function BACKGROUND_ALIGN_CENTER2():String
    {
      return "[BACKGROUND_ALIGN_CENTER2]";
    }
    /**
     * Returns the text key of the align painting the image in its own size in the
     * middle of the area.
     */
    public static function BACKGROUND_ALIGN_CENTER3():String
    {
      return "[BACKGROUND_ALIGN_CENTER3]";
    }
    /**
     * Returns the text key of the align tiling the image over the whole area.
     */
    public static function BACKGROUND_ALIGN_MOSAIC():String
    {
      return "[BACKGROUND_ALIGN_MOSAIC]";
    }
  }
}
