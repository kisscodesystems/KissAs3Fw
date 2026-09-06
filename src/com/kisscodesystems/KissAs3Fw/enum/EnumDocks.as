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
 * EnumDocks.
 * The sides an element of a docking content can be docked to.
 *
 * MAIN FEATURES:
 * - the four sides an element can take a strip of the content at
 * - the center, which is the whole room the docked elements have left
 * - an element docked to the top or to the bottom is as wide as that room, one docked
 *   to the left or to the right is as tall as it, and the element of the center takes
 *   the whole of it
 * - the top is the default: a content of elements that have never been docked stands
 *   as a column of them, every one of them as wide as that content
 * - these values are never displayed to anybody, so they have no labels
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumDocks
  {
    /**
     * Returns the value of the dock taking a strip at the top of the room left.
     */
    public static function DOCK_TOP():String
    {
      return "[DOCK_TOP]";
    }
    /**
     * Returns the value of the dock taking a strip at the bottom of the room left.
     */
    public static function DOCK_BOTTOM():String
    {
      return "[DOCK_BOTTOM]";
    }
    /**
     * Returns the value of the dock taking a strip at the left of the room left.
     */
    public static function DOCK_LEFT():String
    {
      return "[DOCK_LEFT]";
    }
    /**
     * Returns the value of the dock taking a strip at the right of the room left.
     */
    public static function DOCK_RIGHT():String
    {
      return "[DOCK_RIGHT]";
    }
    /**
     * Returns the value of the dock taking the whole room left.
     */
    public static function DOCK_CENTER():String
    {
      return "[DOCK_CENTER]";
    }
  }
}
