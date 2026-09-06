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
 * EnumDisplayingStyles.
 * The displaying styles of this application. A style holds every displayed property of
 * it, so switching the style repaints the whole application at once.
 *
 * MAIN FEATURES:
 * - the framework brings the default style alone: it is the only style whose background
 *   image is the embedded one instead of a file of the framework server, a hundred
 *   pixels wide mosaic tile repeated over the whole stage, and it is the one every
 *   further style is built from
 * - the extenders of this framework name their own styles in an enum extending this one,
 *   and they add those styles to the label manager and to the dynamics config as well,
 *   so that the panel of the settings displays them
 * - getEveryDisplayingStyle answers all of them in the order a picker has to display
 *   them in, so the label manager and the dynamics config never fall out of step
 * - the label of this key is in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumDisplayingStyles
  {
    /**
     * Returns the text key of the default displaying style.
     */
    public static function DISPLAYING_STYLE_DEFAULT():String
    {
      return "[DISPLAYING_STYLE_DEFAULT]";
    }
    /**
     * Returns every displaying style of this framework, in the order a picker of them
     * has to display them in: the default one is the only style the framework itself
     * brings, so an extender of this enum answers its own styles after it.
     */
    public static function getEveryDisplayingStyle():Array
    {
      return [DISPLAYING_STYLE_DEFAULT()];
    }
  }
}
