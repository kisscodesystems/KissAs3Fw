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
 * UserUnitTest
 * Checks the User object of the client.
 *
 * MAIN FEATURES:
 * - the name of the user is empty until somebody logs in
 * - the name can be set and read back
 * - a fresh instance is built and destroyed here, the one of the running application is
 *   left alone
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.user.User;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class UserUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function UserUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "User";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const user:User = new User(application);
      // nobody is logged in until a name has been given
      assertEquals("getUsername of a fresh User", "", user.getUsername());
      // the name is stored as it has been given
      user.setUsername("anna");
      assertEquals("getUsername after setUsername", "anna", user.getUsername());
      user.setUsername("");
      assertEquals("getUsername after a logout", "", user.getUsername());
      // the user of the application is reachable and has a name of its own
      assertNotNull("the user of the application", application.getUser());
      assertNotNull("the name of the user of the application", application.getUser().getUsername());
      user.destroy();
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
    }
  }
}
