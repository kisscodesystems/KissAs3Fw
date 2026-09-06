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
 * User.
 * The object of the client.
 */
package com.kisscodesystems.KissAs3Fw.user
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  public class User
  {
    protected var application:Application = null;
    protected var username:String = "";
    /**
     * Constructs the User object of the client. Nobody is logged in at this point.
     * @param applicationRef the main application reference
     */
    public function User(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<User> constructed.", 1);
    }
    /**
     * Returns the name of this user, an empty string when there is nobody logged in.
     */
    public function getUsername():String
    {
      return username;
    }
    /**
     * Sets the name of this user.
     * @param newUsername the name of the user who is logged in
     */
    public function setUsername(newUsername:String):void
    {
      application.trace("<User setUsername> newUsername: " + newUsername, 0);
      username = newUsername;
    }
    /**
     * Frees every reference held by this user object.
     */
    public function destroy():void
    {
      application.trace("<User destroy> called.", 1);
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      username = null;
      application = null;
    }
  }
}
