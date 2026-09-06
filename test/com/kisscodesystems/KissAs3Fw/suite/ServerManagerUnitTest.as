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
 * ServerManagerUnitTest
 * Checks the ServerManager of the framework.
 *
 * MAIN FEATURES:
 * - the framework manager knows no server at all, so every method of it has to answer
 *   that instead of handing out a machine of any kind
 * - the servers of an application are built by the ServerManagerUnderTest standing at the
 *   bottom of this file: two of them, the very way an application does it
 * - the picking of the server in use, the failure of one and the answers of the api are
 *   all checked on that one, and nothing of this suite ever touches the network: the
 *   answers of that api are handed over by hand
 * - every change of the servers is told with one single event, so this suite counts those
 *   events as well: one change tells the ones listening once
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ServerManagerUnitTest extends BaseUnitTest
  {
    // the two servers of the manager under test and the third one that appears later on,
    // with the addresses the api of an application answers them with
    private const SERVER_KEY_1:String = "app1";
    private const SERVER_KEY_2:String = "app2";
    private const SERVER_KEY_3:String = "app3";
    private const SERVER_ADDRESS_1:String = "app1.kisscodesystems.com";
    private const SERVER_ADDRESS_2:String = "app2.kisscodesystems.com";
    private const SERVER_ADDRESS_3:String = "app3.kisscodesystems.com";
    // the number of the events telling that the servers have changed
    private var serversChangedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ServerManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ServerManager";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      runFrameworkManagerTests();
      runServerTests();
    }
    /**
     * Checks the manager of the framework: it knows no server at all, so there is nothing
     * to hand out and nothing to fail either.
     */
    private function runFrameworkManagerTests():void
    {
      const serverManager:ServerManager = new ServerManager(application);
      assertNotNull("a ServerManager is built", serverManager);
      assertEquals("getServerCount of the framework", 0, serverManager.getServerCount());
      assertEquals("getServerKeys of the framework", 0, serverManager.getServerKeys().length);
      assertEquals("getServerInUse of the framework", "", serverManager.getServerInUse());
      assertEquals("getServerAddress of a server that does not exist"
        , "", serverManager.getServerAddress(SERVER_KEY_1));
      assertFalse("setServerInUse of a server that does not exist"
        , serverManager.setServerInUse(SERVER_KEY_1));
      assertFalse("serverFailed while there is no server at all"
        , serverManager.serverFailed(SERVER_KEY_1));
      assertFalse("removeServer of a server that does not exist"
        , serverManager.removeServer(SERVER_KEY_1));
      assertFalse("addServer of a server carrying no address"
        , serverManager.addServer(SERVER_KEY_1, ""));
      assertFalse("refreshServers while the uri of the api is not set"
        , serverManager.refreshServers());
      // the refreshing is never started without that uri either, so this changes nothing
      serverManager.startRefreshingServers();
      assertEquals("getServerCount after that", 0, serverManager.getServerCount());
      serverManager.destroy();
      assertEquals("getServerInUse after the destroy", "", serverManager.getServerInUse());
    }
    /**
     * Checks the servers of an application: the machine in use is one of them, a failed
     * one is left for another one and the answers of the api add and remove them.
     */
    private function runServerTests():void
    {
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_SERVERS_CHANGED()
        , serversChangedHandler);
      const managerUnderTest:ServerManagerUnderTest = new ServerManagerUnderTest(application);
      assertNotNull("a ServerManagerUnderTest is built", managerUnderTest);
      assertEquals("getServerCount of the two servers of an application"
        , 2, managerUnderTest.getServerCount());
      assertEquals("getServerKeys of those two servers"
        , 2, managerUnderTest.getServerKeys().length);
      assertEquals("getServerAddress of the first server"
        , SERVER_ADDRESS_1, managerUnderTest.getServerAddress(SERVER_KEY_1));
      const serverInUse:String = managerUnderTest.getServerInUse();
      assertTrue("one of those two servers is the one in use"
        , serverInUse == SERVER_KEY_1 || serverInUse == SERVER_KEY_2);
      // the machine in use is picked by hand from here on, so this suite knows which one
      // of them stands there: the one the framework has picked is a random one
      assertFalse("setServerInUse of a server that does not exist"
        , managerUnderTest.setServerInUse(SERVER_KEY_3));
      assertTrue("setServerInUse of the first server"
        , managerUnderTest.setServerInUse(SERVER_KEY_1));
      assertEquals("getServerInUse after that", SERVER_KEY_1, managerUnderTest.getServerInUse());
      serversChangedCount = 0;
      assertTrue("setServerInUse of the server that is in use already"
        , managerUnderTest.setServerInUse(SERVER_KEY_1));
      assertEquals("setting the very same server tells the ones listening nothing"
        , 0, serversChangedCount);
      assertTrue("setServerInUse of the second server"
        , managerUnderTest.setServerInUse(SERVER_KEY_2));
      assertEquals("giving this application over tells the ones listening once"
        , 1, serversChangedCount);
      assertTrue("setServerInUse of the first server once more"
        , managerUnderTest.setServerInUse(SERVER_KEY_1));
      // only the server in use can fail: the second manager reporting a machine that has
      // been left behind already is answered with a false and nothing happens
      serversChangedCount = 0;
      assertFalse("serverFailed of a server that is not the one in use"
        , managerUnderTest.serverFailed(SERVER_KEY_2));
      assertEquals("the server in use after that", SERVER_KEY_1, managerUnderTest.getServerInUse());
      assertEquals("that failure has told the ones listening nothing", 0, serversChangedCount);
      assertTrue("serverFailed of the server in use", managerUnderTest.serverFailed(SERVER_KEY_1));
      assertEquals("the second server is the one in use from now"
        , SERVER_KEY_2, managerUnderTest.getServerInUse());
      assertEquals("that failure has told the ones listening once", 1, serversChangedCount);
      // the answers of the api: a server that stands there already changes nothing at all
      serversChangedCount = 0;
      assertFalse("the answer of the api holding the two servers that stand here already"
        , managerUnderTest.takeAnswer(SERVER_ADDRESS_1 + ";" + SERVER_ADDRESS_2));
      assertEquals("that answer has told the ones listening nothing", 0, serversChangedCount);
      assertEquals("getServerCount after that answer", 2, managerUnderTest.getServerCount());
      assertFalse("an answer that is empty", managerUnderTest.takeAnswer(""));
      assertFalse("an answer that never arrived", managerUnderTest.takeAnswer(null));
      assertEquals("getServerCount after those answers", 2, managerUnderTest.getServerCount());
      // a third server appears
      assertTrue("the answer of the api holding a third server"
        , managerUnderTest.takeAnswer(SERVER_ADDRESS_1 + ";" + SERVER_ADDRESS_2 + ";" + SERVER_ADDRESS_3));
      assertEquals("getServerCount after that server has appeared"
        , 3, managerUnderTest.getServerCount());
      assertEquals("the address of that third server"
        , SERVER_ADDRESS_3, managerUnderTest.getServerAddress(SERVER_KEY_3));
      assertEquals("the server in use is left alone by that answer"
        , SERVER_KEY_2, managerUnderTest.getServerInUse());
      assertEquals("that answer has told the ones listening once", 1, serversChangedCount);
      // the server in use disappears: another one of them takes this application over
      serversChangedCount = 0;
      assertTrue("the answer of the api without the server in use"
        , managerUnderTest.takeAnswer(SERVER_ADDRESS_1 + ";" + SERVER_ADDRESS_3));
      assertEquals("getServerCount after that removal", 2, managerUnderTest.getServerCount());
      assertEquals("the address of the server that has disappeared"
        , "", managerUnderTest.getServerAddress(SERVER_KEY_2));
      const newServerInUse:String = managerUnderTest.getServerInUse();
      assertTrue("another server of this application is the one in use from now"
        , newServerInUse == SERVER_KEY_1 || newServerInUse == SERVER_KEY_3);
      assertTrue("that answer has told the ones listening", serversChangedCount > 0);
      // and the last server of an application is never taken away
      assertTrue("the answer of the api holding one single server"
        , managerUnderTest.takeAnswer(SERVER_ADDRESS_1));
      assertEquals("getServerCount after that answer", 1, managerUnderTest.getServerCount());
      assertEquals("the one server left is the one in use"
        , SERVER_KEY_1, managerUnderTest.getServerInUse());
      assertFalse("removeServer of the last server of this application"
        , managerUnderTest.removeServer(SERVER_KEY_1));
      assertFalse("serverFailed while this application has one single server"
        , managerUnderTest.serverFailed(SERVER_KEY_1));
      assertEquals("the server in use after that failure"
        , SERVER_KEY_1, managerUnderTest.getServerInUse());
      // an address holding no name of a machine is dropped, so the servers stay as they are
      assertFalse("the answer of the api holding no name of a machine"
        , managerUnderTest.takeAnswer(" ; "));
      assertEquals("getServerCount after that answer", 1, managerUnderTest.getServerCount());
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_SERVERS_CHANGED()
        , serversChangedHandler);
      managerUnderTest.destroy();
    }
    /**
     * Counts the events telling that the servers of the application have changed.
     * @param e the event of that change
     */
    private function serversChangedHandler(e:Event):void
    {
      serversChangedCount++;
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_SERVERS_CHANGED()
        , serversChangedHandler);
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      serversChangedCount = 0;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
/**
 * ServerManagerUnderTest: the manager this suite talks to. It carries the two servers of
 * an application, the very way an application fills them in, and it opens the answers of
 * the api up as well: those are the ones the storing of the servers is checked with,
 * without one single request being sent to anywhere.
 */
internal class ServerManagerUnderTest extends ServerManager
{
  public static const SERVER_KEY_1:String = "app1";
  public static const SERVER_KEY_2:String = "app2";
  public static const SERVER_ADDRESS_1:String = "app1.kisscodesystems.com";
  public static const SERVER_ADDRESS_2:String = "app2.kisscodesystems.com";
  /**
   * Constructs the manager under test.
   * @param applicationRef the main application reference
   */
  public function ServerManagerUnderTest(applicationRef:Application):void
  {
    super(applicationRef);
  }
  /**
   * Hands the answer of the api of an application over to this manager.
   * @param answer the plain text answer of that api
   */
  public function takeAnswer(answer:String):Boolean
  {
    const serverCountBefore:int = getServerCount();
    const serverInUseBefore:String = getServerInUse();
    activeServersAnswer(answer);
    return serverCountBefore != getServerCount() || serverInUseBefore != getServerInUse();
  }
  /**
   * Fills in the two servers of this manager. The uri of the api is left empty on purpose:
   * this manager asks for the addresses of the active servers nowhere, and the suite hands
   * the answers of that api over by itself.
   */
  override protected function initializeServers():void
  {
    super.initializeServers();
    addServer(SERVER_KEY_1, SERVER_ADDRESS_1);
    addServer(SERVER_KEY_2, SERVER_ADDRESS_2);
  }
}
