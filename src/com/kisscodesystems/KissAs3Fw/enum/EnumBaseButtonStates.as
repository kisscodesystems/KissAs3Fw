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
 * EnumBaseButtonStates.
 * The states a button of this framework can be in. The state tells the button how it
 * has to be painted.
 *
 * MAIN FEATURES:
 * - the default state, the highlighted one the mouse is above and the pushed one
 * - these values are numbers, so they are never displayed to anybody
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumBaseButtonStates
  {
    /**
     * Returns the state of a button nobody is touching.
     */
    public static function BASE_BUTTON_STATE_DEFAULT():int
    {
      return 0;
    }
    /**
     * Returns the state of a button the mouse pointer stands above.
     */
    public static function BASE_BUTTON_STATE_HIGHLIGHTED():int
    {
      return 1;
    }
    /**
     * Returns the state of a button that is being pushed.
     */
    public static function BASE_BUTTON_STATE_PUSHED():int
    {
      return 2;
    }
  }
}
