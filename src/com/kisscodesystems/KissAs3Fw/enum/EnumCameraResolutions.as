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
 * EnumCameraResolutions.
 * The aspect ratios a camera of this framework can be asked to work in.
 *
 * MAIN FEATURES:
 * - one value is the ratio itself, the width and the height of it separated by a
 *   colon, so the camera counts its own height from its width and from this string
 * - a new ratio is one single function here, nothing else has to be touched
 * - these values are displayed to the one using the application, but they are the
 *   same in every language, so they are no text keys
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumCameraResolutions
  {
    /**
     * Returns the square aspect ratio.
     */
    public static function CAMERA_RESOLUTION_11():String
    {
      return "1:1";
    }
    /**
     * Returns the aspect ratio of the traditional television picture.
     */
    public static function CAMERA_RESOLUTION_43():String
    {
      return "4:3";
    }
    /**
     * Returns the aspect ratio of the widescreen picture.
     */
    public static function CAMERA_RESOLUTION_169():String
    {
      return "16:9";
    }
    /**
     * Returns every aspect ratio of this framework, in the order a picker of them has
     * to display them in: from the narrowest to the widest.
     */
    public static function getEveryResolution():Array
    {
      return [CAMERA_RESOLUTION_11(), CAMERA_RESOLUTION_43(), CAMERA_RESOLUTION_169()];
    }
    /**
     * Returns the height belonging to the given width in the given aspect ratio. The
     * ratio is the width and the height of it separated by a colon, so the height is
     * counted from those two numbers. A ratio this class does not know at all answers
     * the width itself, the height of a square picture.
     * @param resolution the aspect ratio, an EnumCameraResolutions value
     * @param dw the width the height is asked for
     */
    public static function getHeightOfWidth(resolution:String, dw:int):int
    {
      if (resolution == null)
      {
        return dw;
      }
      const parts:Array = resolution.split(":");
      if (parts.length != 2)
      {
        return dw;
      }
      const ratioDw:Number = Number(parts[0]);
      const ratioDh:Number = Number(parts[1]);
      if (!(ratioDw > 0) || !(ratioDh > 0))
      {
        return dw;
      }
      return int(dw * ratioDh / ratioDw);
    }
  }
}
