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
 * StateManagerUnitTest
 * Checks the StateManager of the framework and the saving and the restoring of the state
 * of the Application.
 *
 * MAIN FEATURES:
 * - the state outlives the manager holding it, so this suite builds manager after manager
 *   on the very same device: the second one has to answer the state the first one wrote
 * - every manager of this suite is a StateManagerUnderTest standing at the bottom of this
 *   file: it keeps its state under a name of its own, so the run of the tests never
 *   touches the state of the application itself
 * - a state written by another version of the manager is thrown away instead of being
 *   answered
 * - the saveState and the restoreState of the application are called directly: the test
 *   application switches the keeping of the state off, so nothing calls them on its own
 * - the suite leaves the device the way it has found it: every state is cleared at the end
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.net.SharedObject;
  public class StateManagerUnitTest extends BaseUnitTest
  {
    // the keys the application keeps its own values under
    private const STATE_LANG_CODE:String = "Application.langCode";
    private const STATE_DISPLAYING_STYLE:String = "Application.displayingStyle";
    private var managerUnderTest:StateManagerUnderTest = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function StateManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "StateManager";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      assertNotNull("the application has a manager of its state", application.getStateManager());
      managerUnderTest = new StateManagerUnderTest(application);
      managerUnderTest.clearState();
      runWritingTests();
      runKeepingTests();
      runVersionTests();
      runClearingTests();
      runApplicationTests();
      managerUnderTest.clearState();
      application.getStateManager().clearState();
    }
    /**
     * Checks the writing and the reading of a state.
     */
    protected function runWritingTests():void
    {
      assertNull("there is no state before anything is written", managerUnderTest.readState());
      assertFalse("a missing state is not written", managerUnderTest.writeState(null));
      const state:Object = new Object();
      state["text"] = "a text";
      state["number"] = 42;
      state["flag"] = true;
      state["array"] = [3, 1, 2];
      assertTrue("the state is written", managerUnderTest.writeState(state));
      const read:Object = managerUnderTest.readState();
      assertNotNull("the state written is read", read);
      assertEquals("the text of the state is read", "a text", read["text"]);
      assertEquals("the number of the state is read", 42, read["number"]);
      assertEquals("the flag of the state is read", true, read["flag"]);
      assertEquals("the array of the state is read", "3,1,2", String(read["array"]));
    }
    /**
     * Checks the keeping of the state: a manager built after the one that has written it
     * answers that very state.
     */
    protected function runKeepingTests():void
    {
      managerUnderTest.destroy();
      managerUnderTest = new StateManagerUnderTest(application);
      const read:Object = managerUnderTest.readState();
      assertNotNull("the manager built after the first one reads the state", read);
      assertEquals("that state holds the same text", "a text", read == null ? null : read["text"]);
    }
    /**
     * Checks that a state written by another version of the manager is not answered.
     */
    protected function runVersionTests():void
    {
      const sharedObject:SharedObject = SharedObject.getLocal(StateManagerUnderTest.STORE_NAME);
      sharedObject.data["stateVersion"] = 99;
      sharedObject.flush();
      sharedObject.close();
      assertNull("a state of another version is not answered", managerUnderTest.readState());
    }
    /**
     * Checks the clearing of the state.
     */
    protected function runClearingTests():void
    {
      const state:Object = new Object();
      state["text"] = "to be cleared";
      managerUnderTest.writeState(state);
      managerUnderTest.clearState();
      assertNull("there is no state after the clearing", managerUnderTest.readState());
    }
    /**
     * Checks the saving and the restoring of the state of the application: the language
     * and the displaying style are the values the framework keeps by itself.
     */
    protected function runApplicationTests():void
    {
      const langOrig:String = application.getLabelManager().getLang();
      const styleOrig:String = application.getDynamicsConfig().getCurrentDisplayingStyle();
      application.saveState();
      const saved:Object = application.getStateManager().readState();
      assertNotNull("the application saves its state", saved);
      assertEquals("the state holds the language", langOrig
        , saved == null ? null : saved[STATE_LANG_CODE]);
      assertEquals("the state holds the displaying style", styleOrig
        , saved == null ? null : saved[STATE_DISPLAYING_STYLE]);
      // another language of the application is restored from a state holding that one
      const langs:Array = application.getLabelManager().getKeysLang();
      const langOther:String = langs.length > 1 && langs[0] == langOrig ? langs[1] : langs[0];
      const state:Object = new Object();
      state[STATE_LANG_CODE] = langOther;
      state[STATE_DISPLAYING_STYLE] = "a displaying style that does not exist";
      application.getStateManager().writeState(state);
      application.restoreState();
      assertEquals("the language of the state is restored", langOther
        , application.getLabelManager().getLang());
      assertEquals("a displaying style that does not exist is not restored", styleOrig
        , application.getDynamicsConfig().getCurrentDisplayingStyle());
      application.getLabelManager().setLang(langOrig);
      // a state without any value of the framework changes nothing
      application.getStateManager().writeState(new Object());
      application.restoreState();
      assertEquals("an empty state leaves the language alone", langOrig
        , application.getLabelManager().getLang());
      application.getStateManager().clearState();
      application.restoreState();
      assertEquals("no state at all leaves the language alone", langOrig
        , application.getLabelManager().getLang());
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      if (managerUnderTest != null)
      {
        managerUnderTest.destroy();
      }
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      managerUnderTest = null;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.manager.StateManager;
/**
 * The state manager this suite works with: the very manager of the framework, keeping its
 * state under a name no application uses.
 */
internal class StateManagerUnderTest extends StateManager
{
  // the name of the state of this manager: another one than the name of any application
  public static const STORE_NAME:String = "KissAs3UtStateUnderTest";
  /**
   * Constructs the manager under test. The name of the state is rewritten here, after the
   * constructor of the manager has taken the one of the application: nothing is read from
   * the device before that.
   * @param applicationRef the main application reference
   */
  public function StateManagerUnderTest(applicationRef:Application):void
  {
    super(applicationRef);
    storeName = STORE_NAME;
  }
}
