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
 * NetConnectionManagerUnitTest
 * Checks the NetConnectionManager of the framework.
 *
 * MAIN FEATURES:
 * - the framework manager knows no address of any server at all, so it carries no
 *   connection group either: every method of it has to refuse a group of that kind
 *   instead of opening anything
 * - the group of two servers is built by the NetConnectionManagerUnderTest standing at
 *   the bottom of this file, on a port of this very machine nothing listens on, so the
 *   connection of it never leaves the machine this suite runs on and it never stands
 * - the connecting itself is an answer arriving frames later, so this suite checks what
 *   the manager does with that group up to the moment the connecting is started
 * - the two servers of that group are the servers of this application as well, so they
 *   are put into the ServerManager of it: a machine taken away there has to disappear
 *   from this group too, and the connection follows the one standing in use
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.manager.NetConnectionManager;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  import flash.events.NetStatusEvent;
  import flash.net.NetConnection;
  public class NetConnectionManagerUnitTest extends BaseUnitTest
  {
    // the name of the remote method this suite calls
    private const CALL_NAME:String = "callAppWorks";
    // the number of the answers of that method: it is never called at all here, because
    // there is no connection standing to call it on
    private var callBackCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function NetConnectionManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "NetConnectionManager";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      runFrameworkManagerTests();
      runConnectionGroupTests();
    }
    /**
     * Checks the manager of the framework: it knows no address at all, so there is no
     * connection group of any kind to open a connection to or to call a method on.
     */
    private function runFrameworkManagerTests():void
    {
      const netConnectionManager:NetConnectionManager = new NetConnectionManager(application);
      assertNotNull("a NetConnectionManager is built", netConnectionManager);
      assertEquals("the status of a failed net stream", "NetStream.Failed", netConnectionManager.NS_FAILED);
      assertEquals("the status of a starting net stream", "NetStream.Play.Start", netConnectionManager.NS_START);
      assertEquals("the status of a publishing net stream", "NetStream.Publish.Start", netConnectionManager.NS_PSTART);
      assertFalse("close of a net connection that is null", netConnectionManager.close(null, null, null));
      assertFalse("call on a net connection that is null"
        , netConnectionManager.call(null, CALL_NAME, callBack, ""));
      assertFalse("closeConnection of a connection object that is null"
        , netConnectionManager.closeConnection(null));
      assertTrue("closeAllConnections of a manager carrying no connection at all"
        , netConnectionManager.closeAllConnections());
      assertEquals("getDefaultConnectionKey of the framework", ""
        , netConnectionManager.getDefaultConnectionKey(NetConnectionManagerUnderTest.GROUP_KEY));
      assertFalse("setConnectionGroupHandlers of a group that does not exist"
        , netConnectionManager.setConnectionGroupHandlers(NetConnectionManagerUnderTest.GROUP_KEY, null, null));
      assertFalse("isConnectionGroupConnected of a group that does not exist"
        , netConnectionManager.isConnectionGroupConnected(NetConnectionManagerUnderTest.GROUP_KEY));
      assertFalse("connectByConnectionGroup of a group that does not exist"
        , netConnectionManager.connectByConnectionGroup(NetConnectionManagerUnderTest.GROUP_KEY));
      assertFalse("connectByConnection of a connection that does not exist"
        , netConnectionManager.connectByConnection(NetConnectionManagerUnderTest.GROUP_KEY
          , NetConnectionManagerUnderTest.CONNECTION_KEY_1));
      assertFalse("callByConnectionGroup of a group that does not exist"
        , netConnectionManager.callByConnectionGroup(NetConnectionManagerUnderTest.GROUP_KEY
          , CALL_NAME, callBack, ""));
      assertFalse("callByConnection of a connection that does not exist"
        , netConnectionManager.callByConnection(NetConnectionManagerUnderTest.GROUP_KEY
          , NetConnectionManagerUnderTest.CONNECTION_KEY_1, CALL_NAME, callBack, ""));
      assertFalse("closeEveryConnections of a group that does not exist"
        , netConnectionManager.closeEveryConnections(NetConnectionManagerUnderTest.GROUP_KEY));
      // the one shot connection of this manager: it is opened to an address nothing
      // listens on, so it never stands, and it is closed again right away
      const netConnection:NetConnection = netConnectionManager.connect(
          NetConnectionManagerUnderTest.CONNECTION_URL_1, new Object(), netStatus, netError
        , application.getPropertiesConfig().getApplicationVersion());
      assertNotNull("connect hands the net connection it has built back", netConnection);
      assertFalse("that net connection does not stand yet", netConnection.connected);
      assertFalse("call on a net connection that does not stand"
        , netConnectionManager.call(netConnection, CALL_NAME, callBack, ""));
      assertTrue("close of that net connection"
        , netConnectionManager.close(netConnection, netStatus, netError));
      assertEquals("no answer of any call has arrived", 0, callBackCount);
      netConnectionManager.destroy();
      assertNull("the status of a failed net stream after the destroy", netConnectionManager.NS_FAILED);
    }
    /**
     * Checks the group of the two servers: the settings of every connection of it stand in
     * the manager, the handlers of them are set on all of them at once, and a method can
     * only be called on a connection that stands open.
     */
    private function runConnectionGroupTests():void
    {
      // the two servers of the group are the servers of this application: the manager
      // under test follows them, so they stand in the ServerManager before it is built
      const serverManager:ServerManager = application.getServerManager();
      serverManager.addServer(NetConnectionManagerUnderTest.CONNECTION_KEY_1
        , NetConnectionManagerUnderTest.CONNECTION_URL_1);
      serverManager.addServer(NetConnectionManagerUnderTest.CONNECTION_KEY_2
        , NetConnectionManagerUnderTest.CONNECTION_URL_2);
      serverManager.setServerInUse(NetConnectionManagerUnderTest.CONNECTION_KEY_1);
      const managerUnderTest:NetConnectionManagerUnderTest = new NetConnectionManagerUnderTest(application);
      assertNotNull("a NetConnectionManagerUnderTest is built", managerUnderTest);
      assertEquals("the first server of the group is the default one"
        , NetConnectionManagerUnderTest.CONNECTION_KEY_1
        , managerUnderTest.getDefaultConnectionKey(NetConnectionManagerUnderTest.GROUP_KEY));
      assertEquals("the url of the first server", NetConnectionManagerUnderTest.CONNECTION_URL_1
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "url"));
      assertNotNull("the client of the first server"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "client"));
      assertNotNull("the connect parameters of the first server"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "connectParams"));
      assertEquals("a new connection has been tried by no connecting at all", 0
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "connectAttempts"));
      assertNull("the net connection of a connection that has never been opened"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "netConnection"));
      assertFalse("isConnectionGroupConnected before the connection of it is opened"
        , managerUnderTest.isConnectionGroupConnected(NetConnectionManagerUnderTest.GROUP_KEY));
      assertFalse("callByConnectionGroup while there is no connection standing open"
        , managerUnderTest.callByConnectionGroup(NetConnectionManagerUnderTest.GROUP_KEY
          , CALL_NAME, callBack, ""));
      // the handlers of the group are set on every server of it, because the manager opens
      // another one of them by itself when the one in use fails
      assertTrue("setConnectionGroupHandlers of the group of the two servers"
        , managerUnderTest.setConnectionGroupHandlers(NetConnectionManagerUnderTest.GROUP_KEY
          , netStatus, netError));
      assertNotNull("the net status handler of the first server"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "onNetStatus"));
      assertNotNull("the net status handler of the second server"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_2, "onNetStatus"));
      assertNotNull("the net error handler of the second server"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_2, "onNetError"));
      assertTrue("setConnectionGroupHandlers taking those handlers away again"
        , managerUnderTest.setConnectionGroupHandlers(NetConnectionManagerUnderTest.GROUP_KEY, null, null));
      assertNull("the net status handler of the first server after that"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_1, "onNetStatus"));
      // the connections of every server of the group are closed whether they stand open
      // or not: a group that has never been connected is closed just as well
      assertTrue("closeEveryConnections of the group of the two servers"
        , managerUnderTest.closeEveryConnections(NetConnectionManagerUnderTest.GROUP_KEY));
      // the group follows the server in use: giving this application over to the second
      // server makes that one the default connection of the group as well
      assertEquals("the first server is the default connection of the group"
        , NetConnectionManagerUnderTest.CONNECTION_KEY_1
        , managerUnderTest.getDefaultConnectionKey(NetConnectionManagerUnderTest.GROUP_KEY));
      assertTrue("setServerInUse of the second server"
        , serverManager.setServerInUse(NetConnectionManagerUnderTest.CONNECTION_KEY_2));
      assertEquals("the second server is the default connection of the group from now"
        , NetConnectionManagerUnderTest.CONNECTION_KEY_2
        , managerUnderTest.getDefaultConnectionKey(NetConnectionManagerUnderTest.GROUP_KEY));
      // and a server taken away from this application disappears from the group of its
      // own accord: the manager is told about it with the event of the server manager
      assertTrue("removeServer of the second server, the one in use"
        , serverManager.removeServer(NetConnectionManagerUnderTest.CONNECTION_KEY_2));
      assertNull("the connection of that server after the event of that change"
        , managerUnderTest.getParam(NetConnectionManagerUnderTest.CONNECTION_KEY_2, "url"));
      assertEquals("the first server is the default connection of the group again"
        , NetConnectionManagerUnderTest.CONNECTION_KEY_1
        , managerUnderTest.getDefaultConnectionKey(NetConnectionManagerUnderTest.GROUP_KEY));
      assertFalse("no connection of that group stands open after that either"
        , managerUnderTest.isConnectionGroupConnected(NetConnectionManagerUnderTest.GROUP_KEY));
      managerUnderTest.destroy();
    }
    /**
     * Takes the answer of the remote method: it is never called here, because there is no
     * connection standing open to call it on.
     * @param resultObject the answer of that method
     */
    private function callBack(resultObject:Object):void
    {
      callBackCount++;
    }
    /**
     * Takes the status of the connection of the group.
     * @param e the net status event of that connection
     */
    private function netStatus(e:NetStatusEvent):void
    {
    }
    /**
     * Takes the failure of the connection of the group.
     * @param e the error event of that connection
     */
    private function netError(e:Event):void
    {
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
      callBackCount = 0;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.manager.NetConnectionManager;
/**
 * NetConnectionManagerUnderTest: the manager the group tests of this suite talk to. It
 * builds one group of two servers, both of them standing on a port of this very machine
 * nothing listens on, so a connection to them never leaves this machine. The parameters of
 * a connection are opened up as well: those are the settings the applications keep on the
 * connections of their own.
 */
internal class NetConnectionManagerUnderTest extends NetConnectionManager
{
  public static const GROUP_KEY:String = "KissAs3Ut";
  public static const CONNECTION_KEY_1:String = "app1";
  public static const CONNECTION_KEY_2:String = "app2";
  public static const CONNECTION_URL_1:String = "rtmp://127.0.0.1:1/one";
  public static const CONNECTION_URL_2:String = "rtmp://127.0.0.1:1/two";
  /**
   * Constructs the manager under test.
   * @param applicationRef the main application reference
   */
  public function NetConnectionManagerUnderTest(applicationRef:Application):void
  {
    super(applicationRef);
  }
  /**
   * Returns a parameter of a connection of the group of this manager.
   * @param connectionKey the key of the connection
   * @param paramKey the key of the parameter
   */
  public function getParam(connectionKey:String, paramKey:String):Object
  {
    return getConnectionParam(GROUP_KEY, connectionKey, paramKey);
  }
  /**
   * Builds the group of the two servers of this manager. That group is the group of the
   * servers of this application as well, so it follows the ServerManager of it: the two
   * connections below are the very servers standing there while this suite runs.
   */
  override protected function initializeConnections():void
  {
    super.initializeConnections();
    serverGroupKey = GROUP_KEY;
    addNewConnectionGroup(GROUP_KEY);
    addNewConnection(GROUP_KEY, CONNECTION_KEY_1);
    setConnectionParam(GROUP_KEY, CONNECTION_KEY_1, "url", CONNECTION_URL_1);
    addNewConnection(GROUP_KEY, CONNECTION_KEY_2);
    setConnectionParam(GROUP_KEY, CONNECTION_KEY_2, "url", CONNECTION_URL_2);
    for (var connectionKey:String in getConnectionGroup(GROUP_KEY))
    {
      setConnectionParam(GROUP_KEY, connectionKey, "client", new Object());
      setConnectionParam(GROUP_KEY, connectionKey, "connectParams"
        , [ application.getPropertiesConfig().getApplicationVersion() ]);
    }
    setDefaultConnection(GROUP_KEY, CONNECTION_KEY_1);
  }
}
