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
 * EnumRoles.
 * The roles the one using this application can have. The role tells the menu panel
 * which items have to be displayed on it.
 *
 * MAIN FEATURES:
 * - the guest role is the only one this framework brings
 * - the extenders of this framework can add their own roles to the label manager
 * - the labels of these keys are in resource/label/KissAs3FwLabels.xml
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumRoles
  {
    /**
     * Returns the text key of the role of the one who has not logged in.
     */
    public static function ROLE_GUEST():String
    {
      return "[ROLE_GUEST]";
    }
  }
}
