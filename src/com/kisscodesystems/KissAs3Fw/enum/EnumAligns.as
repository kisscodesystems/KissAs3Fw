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
 * EnumAligns.
 * The aligns an element of a content can be placed inside its own cell by.
 *
 * MAIN FEATURES:
 * - three horizontal aligns: to the left, to the center and to the right
 * - three vertical ones: to the top, to the middle and to the bottom
 * - the left and the top aligns are the defaults, they place the element into the
 *   upper left corner of its cell, which is where every element stands without
 *   an align given
 * - a horizontal align is refused by a vertical setter and the other way round
 * - these values are never displayed to anybody, so they have no labels
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumAligns
  {
    /**
     * Returns the value of the align placing the element to the left of its cell.
     */
    public static function ALIGN_LEFT():String
    {
      return "[ALIGN_LEFT]";
    }
    /**
     * Returns the value of the align placing the element to the horizontal center
     * of its cell.
     */
    public static function ALIGN_CENTER():String
    {
      return "[ALIGN_CENTER]";
    }
    /**
     * Returns the value of the align placing the element to the right of its cell.
     */
    public static function ALIGN_RIGHT():String
    {
      return "[ALIGN_RIGHT]";
    }
    /**
     * Returns the value of the align placing the element to the top of its cell.
     */
    public static function ALIGN_TOP():String
    {
      return "[ALIGN_TOP]";
    }
    /**
     * Returns the value of the align placing the element to the vertical middle of
     * its cell.
     */
    public static function ALIGN_MIDDLE():String
    {
      return "[ALIGN_MIDDLE]";
    }
    /**
     * Returns the value of the align placing the element to the bottom of its cell.
     */
    public static function ALIGN_BOTTOM():String
    {
      return "[ALIGN_BOTTOM]";
    }
  }
}
