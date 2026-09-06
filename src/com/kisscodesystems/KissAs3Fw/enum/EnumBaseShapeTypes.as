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
 * EnumBaseShapeTypes.
 * The types a shape of this framework can be painted with. The type tells the shape
 * which way its lights and shadows have to point.
 *
 * MAIN FEATURES:
 * - the pressed type looks like a hole, the not pressed one looks like a button
 * - the flat type has no lights and no shadows, and the none type paints nothing
 * - these values are numbers, so they are never displayed to anybody
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumBaseShapeTypes
  {
    /**
     * Returns the type of a shape that looks like a hole in the surface.
     */
    public static function BASE_SHAPE_TYPE_PRESSED():int
    {
      return -1;
    }
    /**
     * Returns the type of a shape that stands in the plane of the surface.
     */
    public static function BASE_SHAPE_TYPE_FLAT():int
    {
      return 0;
    }
    /**
     * Returns the type of a shape that stands out of the surface.
     */
    public static function BASE_SHAPE_TYPE_NOT_PRESSED():int
    {
      return 1;
    }
    /**
     * Returns the type of a shape that is not painted at all.
     */
    public static function BASE_SHAPE_TYPE_NONE():int
    {
      return 2;
    }
  }
}
