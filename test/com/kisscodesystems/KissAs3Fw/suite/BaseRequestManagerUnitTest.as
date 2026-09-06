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
 * BaseRequestManagerUnitTest
 * Checks the BaseRequestManager of the framework.
 *
 * MAIN FEATURES:
 * - the manager is built and freed without touching the network at all
 * - the storing of the connections is what this class is: the groups of them, the default
 *   one standing in use and the picking of another one when that one fails, so all of
 *   that is checked here, connection by connection
 * - the whole of that API is a protected one, because the managers extending this class
 *   are the ones using it, so the suite talks to it through the RequestManagerUnderTest
 *   standing at the bottom of this file
 * - the group of the servers of the application is checked here as well: the servers are
 *   put into the ServerManager of this application and this manager has to follow them,
 *   connection by connection, without one single request being sent to anywhere
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseRequestManager;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseRequestManagerUnitTest extends BaseUnitTest
  {
    // the group of the two servers this suite builds, and the keys of those two servers
    private const GROUP_KEY:String = "KissAs3Ut";
    private const CONNECTION_KEY_1:String = "app1";
    private const CONNECTION_KEY_2:String = "app2";
    // the key of a server that is never added: every method has to refuse it
    private const CONNECTION_KEY_MISSING:String = "app3";
    // the key of a group of connections this application knows no server of
    private const GROUP_KEY_OTHER:String = "KissAs3UtOther";
    // the address of a connection, one setting of the extenders of this class
    private const CONNECTION_URL:String = "https://app1.kisscodesystems.com/kcsops/";
    // the addresses of the servers this suite puts into the ServerManager of the
    // application: the connections of the group are built of those very servers
    private const SERVER_ADDRESS_1:String = "app1.kisscodesystems.com";
    private const SERVER_ADDRESS_2:String = "app2.kisscodesystems.com";
    private const SERVER_ADDRESS_3:String = "app3.kisscodesystems.com";
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseRequestManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseRequestManager";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const requestManager:BaseRequestManager = new BaseRequestManager(application);
      assertNotNull("a BaseRequestManager is built", requestManager);
      requestManager.destroy();
      const managerUnderTest:RequestManagerUnderTest = new RequestManagerUnderTest(application);
      assertNotNull("a RequestManagerUnderTest is built", managerUnderTest);
      runEmptyManagerTests(managerUnderTest);
      runConnectionGroupTests(managerUnderTest);
      runDefaultConnectionTests(managerUnderTest);
      runAnotherConnectionTests(managerUnderTest);
      runConnectionParamTests(managerUnderTest);
      runRemoveTests(managerUnderTest);
      runServerGroupTests(managerUnderTest);
      managerUnderTest.destroy();
    }
    /**
     * Checks a manager that carries no connection at all: every one of these methods is
     * asked about a group that has never been built, and every one of them has to refuse
     * that instead of answering something.
     * @param managerUnderTest the manager of this suite
     */
    private function runEmptyManagerTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertNull("getConnectionGroup of a group that does not exist"
        , managerUnderTest.getGroup(GROUP_KEY));
      assertEquals("getConnectionCount of a group that does not exist"
        , 0, managerUnderTest.getCount(GROUP_KEY));
      assertNull("getConnection of a group that does not exist"
        , managerUnderTest.getConnectionByKeys(GROUP_KEY, CONNECTION_KEY_1));
      assertNull("getRandomConnection of a group that does not exist"
        , managerUnderTest.getRandom(GROUP_KEY));
      assertNull("getAnotherConnection of a group that does not exist"
        , managerUnderTest.getAnother(GROUP_KEY, CONNECTION_KEY_1));
      assertNull("getDefaultConnection of a group that does not exist"
        , managerUnderTest.getDefault(GROUP_KEY));
      assertEquals("getDefaultConnectionKey of a group that does not exist"
        , "", managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertFalse("setDefaultConnection of a group that does not exist"
        , managerUnderTest.setDefault(GROUP_KEY, CONNECTION_KEY_1));
      assertNull("addNewConnection into a group that does not exist"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_1));
      assertFalse("removeConnection of a group that does not exist"
        , managerUnderTest.removeConnectionByKeys(GROUP_KEY, CONNECTION_KEY_1));
      assertFalse("removeConnectionGroup of a group that does not exist"
        , managerUnderTest.removeGroup(GROUP_KEY));
    }
    /**
     * Checks the building of the group of the two servers: a group and a connection are
     * added once and once only, and the connection carries the two keys it has been added
     * with and no setting of any kind, because the addresses belong to the managers
     * extending this class.
     * @param managerUnderTest the manager of this suite
     */
    private function runConnectionGroupTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertNotNull("addNewConnectionGroup", managerUnderTest.addGroup(GROUP_KEY));
      assertNull("addNewConnectionGroup of a group that exists already"
        , managerUnderTest.addGroup(GROUP_KEY));
      assertNotNull("getConnectionGroup", managerUnderTest.getGroup(GROUP_KEY));
      assertEquals("getConnectionCount of a group standing empty"
        , 0, managerUnderTest.getCount(GROUP_KEY));
      assertNotNull("addNewConnection of the first server"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_1));
      assertNotNull("addNewConnection of the second server"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_2));
      assertNull("addNewConnection of a connection that exists already"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_1));
      assertEquals("getConnectionCount of the group of the two servers"
        , 2, managerUnderTest.getCount(GROUP_KEY));
      assertNull("getConnection of a connection that does not exist"
        , managerUnderTest.getConnectionByKeys(GROUP_KEY, CONNECTION_KEY_MISSING));
      const connectionObject:Object = managerUnderTest.getConnectionByKeys(GROUP_KEY, CONNECTION_KEY_1);
      assertNotNull("getConnection of the first server", connectionObject);
      assertEquals("the groupKey of that connection", GROUP_KEY, connectionObject["groupKey"]);
      assertEquals("the connectionKey of that connection"
        , CONNECTION_KEY_1, connectionObject["connectionKey"]);
      assertFalse("a new connection is not the default one of its group"
        , Boolean(connectionObject["default"]));
      assertNull("the base stores no address of any connection at all"
        , managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "url"));
      assertNotNull("getRandomConnection of the group of the two servers"
        , managerUnderTest.getRandom(GROUP_KEY));
    }
    /**
     * Checks the default connection of the group: that is the one server of it standing in
     * use, so one of them is the default at a time and setting another one gives the group
     * over to that other one.
     * @param managerUnderTest the manager of this suite
     */
    private function runDefaultConnectionTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertNull("getDefaultConnection before any of them has been set"
        , managerUnderTest.getDefault(GROUP_KEY));
      assertEquals("getDefaultConnectionKey before any of them has been set"
        , "", managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertFalse("setDefaultConnection of a connection that does not exist"
        , managerUnderTest.setDefault(GROUP_KEY, CONNECTION_KEY_MISSING));
      assertTrue("setDefaultConnection of the first server"
        , managerUnderTest.setDefault(GROUP_KEY, CONNECTION_KEY_1));
      assertEquals("getDefaultConnectionKey of the first server"
        , CONNECTION_KEY_1, managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertTrue("the default flag of the first server"
        , Boolean(managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "default")));
      assertFalse("the default flag of the second server"
        , Boolean(managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_2, "default")));
      assertTrue("setDefaultConnection of the second server"
        , managerUnderTest.setDefault(GROUP_KEY, CONNECTION_KEY_2));
      assertEquals("getDefaultConnectionKey of the second server"
        , CONNECTION_KEY_2, managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertFalse("the default flag of the first server after the second one has taken it"
        , Boolean(managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "default")));
      const defaultConnectionObject:Object = managerUnderTest.getDefault(GROUP_KEY);
      assertNotNull("getDefaultConnection of the group", defaultConnectionObject);
      assertEquals("the connectionKey of the default connection"
        , CONNECTION_KEY_2, defaultConnectionObject["connectionKey"]);
    }
    /**
     * Checks the picking of another server of the group: that is the one a failed request
     * is repeated on, so it is never the very connection it is asked about.
     * @param managerUnderTest the manager of this suite
     */
    private function runAnotherConnectionTests(managerUnderTest:RequestManagerUnderTest):void
    {
      const anotherThanTheSecond:Object = managerUnderTest.getAnother(GROUP_KEY, CONNECTION_KEY_2);
      assertNotNull("getAnotherConnection than the second server", anotherThanTheSecond);
      assertEquals("getAnotherConnection than the second server is the first one"
        , CONNECTION_KEY_1, anotherThanTheSecond["connectionKey"]);
      const anotherThanTheFirst:Object = managerUnderTest.getAnother(GROUP_KEY, CONNECTION_KEY_1);
      assertNotNull("getAnotherConnection than the first server", anotherThanTheFirst);
      assertEquals("getAnotherConnection than the first server is the second one"
        , CONNECTION_KEY_2, anotherThanTheFirst["connectionKey"]);
      // a key of no connection of the group rules nothing out, so any one of them answers
      assertNotNull("getAnotherConnection than a connection that does not exist"
        , managerUnderTest.getAnother(GROUP_KEY, CONNECTION_KEY_MISSING));
    }
    /**
     * Checks the parameters of a connection: those are the settings the managers extending
     * this class keep on the connections of their own, the addresses of them among them.
     * @param managerUnderTest the manager of this suite
     */
    private function runConnectionParamTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertTrue("setConnectionParam of the url of the first server"
        , managerUnderTest.setParam(GROUP_KEY, CONNECTION_KEY_1, "url", CONNECTION_URL));
      assertEquals("getConnectionParam of that url"
        , CONNECTION_URL, managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "url"));
      assertNull("getConnectionParam of the url of the second server"
        , managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_2, "url"));
      assertFalse("setConnectionParam of a connection that does not exist"
        , managerUnderTest.setParam(GROUP_KEY, CONNECTION_KEY_MISSING, "url", CONNECTION_URL));
      assertNull("getConnectionParam of a connection that does not exist"
        , managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_MISSING, "url"));
      assertTrue("removeConnectionParam of that url"
        , managerUnderTest.removeParam(GROUP_KEY, CONNECTION_KEY_1, "url"));
      assertNull("getConnectionParam of that url after the removal"
        , managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "url"));
      assertFalse("removeConnectionParam of a connection that does not exist"
        , managerUnderTest.removeParam(GROUP_KEY, CONNECTION_KEY_MISSING, "url"));
    }
    /**
     * Checks the removing of the connections: the group hands itself over to another server
     * of its own when the default one is taken away, and the last connection of it leaves
     * a group that carries no default connection either.
     * @param managerUnderTest the manager of this suite
     */
    private function runRemoveTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertFalse("removeConnection of a connection that does not exist"
        , managerUnderTest.removeConnectionByKeys(GROUP_KEY, CONNECTION_KEY_MISSING));
      assertTrue("removeConnection of the second server, the default one of the group"
        , managerUnderTest.removeConnectionByKeys(GROUP_KEY, CONNECTION_KEY_2));
      assertEquals("getConnectionCount after that removal"
        , 1, managerUnderTest.getCount(GROUP_KEY));
      assertEquals("the first server is the default one of the group from now"
        , CONNECTION_KEY_1, managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertNull("getAnotherConnection when the group holds one connection alone"
        , managerUnderTest.getAnother(GROUP_KEY, CONNECTION_KEY_1));
      assertTrue("removeConnection of the last connection of the group"
        , managerUnderTest.removeConnectionByKeys(GROUP_KEY, CONNECTION_KEY_1));
      assertEquals("getConnectionCount of the group standing empty"
        , 0, managerUnderTest.getCount(GROUP_KEY));
      assertEquals("getDefaultConnectionKey of the group standing empty"
        , "", managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertTrue("removeConnectionGroup", managerUnderTest.removeGroup(GROUP_KEY));
      assertNull("getConnectionGroup after the removal", managerUnderTest.getGroup(GROUP_KEY));
      // a group that carries its connections still is removed with all of them
      assertNotNull("addNewConnectionGroup once more", managerUnderTest.addGroup(GROUP_KEY));
      assertNotNull("addNewConnection of the first server once more"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_1));
      assertNotNull("addNewConnection of the second server once more"
        , managerUnderTest.addConnection(GROUP_KEY, CONNECTION_KEY_2));
      assertTrue("setDefaultConnection of the first server once more"
        , managerUnderTest.setDefault(GROUP_KEY, CONNECTION_KEY_1));
      assertTrue("removeConnectionGroup of a group carrying its two connections"
        , managerUnderTest.removeGroup(GROUP_KEY));
      assertNull("getConnectionGroup of that group afterwards"
        , managerUnderTest.getGroup(GROUP_KEY));
    }
    /**
     * Checks the group of the servers of the application: that one group of this manager
     * follows the ServerManager, so a server put in front of the users appears in it, one
     * taken away disappears from it and the default connection of it is the machine the
     * whole application is talking to. The failure of a server is reported to that manager
     * as well, and it is the one picking the machine this application turns to.
     * @param managerUnderTest the manager of this suite
     */
    private function runServerGroupTests(managerUnderTest:RequestManagerUnderTest):void
    {
      assertFalse("synchronizeServers while this manager holds no group of the servers"
        , managerUnderTest.synchronize());
      const serverManager:ServerManager = application.getServerManager();
      assertNotNull("the application carries a server manager", serverManager);
      managerUnderTest.setServerGroup(GROUP_KEY);
      assertFalse("synchronizeServers of a group that does not exist"
        , managerUnderTest.synchronize());
      assertNotNull("addNewConnectionGroup of the group of the servers"
        , managerUnderTest.addGroup(GROUP_KEY));
      assertFalse("synchronizeServers while the server manager knows no server at all"
        , managerUnderTest.synchronize());
      assertEquals("the group is left empty by that", 0, managerUnderTest.getCount(GROUP_KEY));
      // the two servers of this application arrive, so the group is built of them
      assertTrue("addServer of the first server"
        , serverManager.addServer(CONNECTION_KEY_1, SERVER_ADDRESS_1));
      assertTrue("addServer of the second server"
        , serverManager.addServer(CONNECTION_KEY_2, SERVER_ADDRESS_2));
      assertTrue("setServerInUse of the first server"
        , serverManager.setServerInUse(CONNECTION_KEY_1));
      assertEquals("the connections of the group after the event of that change"
        , 2, managerUnderTest.getCount(GROUP_KEY));
      assertEquals("the server in use is the default connection of the group"
        , CONNECTION_KEY_1, managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertEquals("the address of the connection of the first server"
        , SERVER_ADDRESS_1, managerUnderTest.getParam(GROUP_KEY, CONNECTION_KEY_1, "url"));
      // a third server appears and the group follows it
      assertTrue("addServer of a third server"
        , serverManager.addServer(CONNECTION_KEY_MISSING, SERVER_ADDRESS_3));
      assertTrue("synchronizeServers after that server has appeared"
        , managerUnderTest.synchronize());
      assertEquals("the connections of the group after that", 3, managerUnderTest.getCount(GROUP_KEY));
      assertNotNull("the connection of that third server"
        , managerUnderTest.getConnectionByKeys(GROUP_KEY, CONNECTION_KEY_MISSING));
      // the failure of a server is reported to the server manager, and the one it picks is
      // the default connection of the group by the time this manager hears about it
      const anotherConnectionObject:Object = managerUnderTest.anotherAfterFailure(GROUP_KEY
        , CONNECTION_KEY_1);
      assertNotNull("anotherConnectionAfterFailure of the server in use", anotherConnectionObject);
      assertTrue("the server manager has left that server behind"
        , serverManager.getServerInUse() != CONNECTION_KEY_1);
      assertEquals("the connection it hands back is the default one of the group"
        , managerUnderTest.getDefaultConnectionKey(GROUP_KEY)
        , anotherConnectionObject["connectionKey"]);
      assertNull("anotherConnectionAfterFailure of a server that is not the one in use"
        , managerUnderTest.anotherAfterFailure(GROUP_KEY, CONNECTION_KEY_1));
      // and a group this application knows no server of picks another connection by itself
      assertNotNull("addNewConnectionGroup of a group of no server of this application"
        , managerUnderTest.addGroup(GROUP_KEY_OTHER));
      assertNotNull("addNewConnection of the first connection of that group"
        , managerUnderTest.addConnection(GROUP_KEY_OTHER, CONNECTION_KEY_1));
      assertNotNull("addNewConnection of the second connection of that group"
        , managerUnderTest.addConnection(GROUP_KEY_OTHER, CONNECTION_KEY_2));
      const anotherOfTheOtherGroup:Object = managerUnderTest.anotherAfterFailure(GROUP_KEY_OTHER
        , CONNECTION_KEY_1);
      assertNotNull("anotherConnectionAfterFailure of that group", anotherOfTheOtherGroup);
      assertEquals("it is the other connection of that group and no server of this application"
        , CONNECTION_KEY_2, anotherOfTheOtherGroup["connectionKey"]);
      assertTrue("removeConnectionGroup of that group", managerUnderTest.removeGroup(GROUP_KEY_OTHER));
      // a server that has been taken away disappears from the group as well. The server
      // manager tells the ones listening about a removal by picking another machine for
      // this application to talk to, so the one to be taken away is put in front of the
      // users first: the failure above has left a machine of its own choosing in use, and
      // removing an idle one is a change the managers only see at their next synchronizing
      assertTrue("setServerInUse of the third server, the one to be taken away"
        , serverManager.setServerInUse(CONNECTION_KEY_MISSING));
      assertTrue("removeServer of the third server, the one in use"
        , serverManager.removeServer(CONNECTION_KEY_MISSING));
      assertNull("the connection of that server after the event of that change"
        , managerUnderTest.getConnectionByKeys(GROUP_KEY, CONNECTION_KEY_MISSING));
      assertEquals("the connections of the group after that removal"
        , 2, managerUnderTest.getCount(GROUP_KEY));
      assertEquals("the server in use is the default connection of the group still"
        , serverManager.getServerInUse(), managerUnderTest.getDefaultConnectionKey(GROUP_KEY));
      assertTrue("removeConnectionGroup of the group of the servers"
        , managerUnderTest.removeGroup(GROUP_KEY));
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
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.base.BaseRequestManager;
/**
 * RequestManagerUnderTest: the manager this suite talks to. The API storing the
 * connections is a protected one, because the request managers extending the
 * BaseRequestManager are the ones using it, so this class opens every one of those methods
 * up and hands it over as it stands, without adding anything of its own to it.
 */
internal class RequestManagerUnderTest extends BaseRequestManager
{
  /**
   * Constructs the manager under test.
   * @param applicationRef the main application reference
   */
  public function RequestManagerUnderTest(applicationRef:Application):void
  {
    super(applicationRef);
  }
  /**
   * Adds a new connection group.
   * @param groupKey the key of the new connection group
   */
  public function addGroup(groupKey:String):Object
  {
    return addNewConnectionGroup(groupKey);
  }
  /**
   * Returns a connection group.
   * @param groupKey the key of the connection group
   */
  public function getGroup(groupKey:String):Object
  {
    return getConnectionGroup(groupKey);
  }
  /**
   * Removes a connection group with every connection of it.
   * @param groupKey the key of the connection group
   */
  public function removeGroup(groupKey:String):Boolean
  {
    return removeConnectionGroup(groupKey);
  }
  /**
   * Adds a new connection to a group.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the new connection
   */
  public function addConnection(groupKey:String, connectionKey:String):Object
  {
    return addNewConnection(groupKey, connectionKey);
  }
  /**
   * Returns a connection of a group.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection
   */
  public function getConnectionByKeys(groupKey:String, connectionKey:String):Object
  {
    return getConnection(groupKey, connectionKey);
  }
  /**
   * Removes a connection of a group.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection
   */
  public function removeConnectionByKeys(groupKey:String, connectionKey:String):Boolean
  {
    return removeConnection(groupKey, connectionKey);
  }
  /**
   * Returns the number of the connections of a group.
   * @param groupKey the key of the connection group
   */
  public function getCount(groupKey:String):int
  {
    return getConnectionCount(groupKey);
  }
  /**
   * Returns a random connection of a group.
   * @param groupKey the key of the connection group
   */
  public function getRandom(groupKey:String):Object
  {
    return getRandomConnection(groupKey);
  }
  /**
   * Returns a connection of a group other than the given one.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection that must not be answered
   */
  public function getAnother(groupKey:String, connectionKey:String):Object
  {
    return getAnotherConnection(groupKey, connectionKey);
  }
  /**
   * Returns the default connection of a group.
   * @param groupKey the key of the connection group
   */
  public function getDefault(groupKey:String):Object
  {
    return getDefaultConnection(groupKey);
  }
  /**
   * Sets the default connection of a group.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection to set as default
   */
  public function setDefault(groupKey:String, connectionKey:String):Boolean
  {
    return setDefaultConnection(groupKey, connectionKey);
  }
  /**
   * Returns a parameter of a connection.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection
   * @param paramKey the key of the parameter
   */
  public function getParam(groupKey:String, connectionKey:String, paramKey:String):Object
  {
    return getConnectionParam(groupKey, connectionKey, paramKey);
  }
  /**
   * Sets a parameter of a connection.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection
   * @param paramKey the key of the parameter
   * @param paramObject the value of the parameter
   */
  public function setParam(groupKey:String, connectionKey:String, paramKey:String, paramObject:Object):Boolean
  {
    return setConnectionParam(groupKey, connectionKey, paramKey, paramObject);
  }
  /**
   * Removes a parameter of a connection.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection
   * @param paramKey the key of the parameter
   */
  public function removeParam(groupKey:String, connectionKey:String, paramKey:String):Boolean
  {
    return removeConnectionParam(groupKey, connectionKey, paramKey);
  }
  /**
   * Sets the group of the servers of the application, the one setting the extenders of
   * the framework fill in.
   * @param groupKey the key of that group
   */
  public function setServerGroup(groupKey:String):void
  {
    serverGroupKey = groupKey;
  }
  /**
   * Gives the group of the servers over to the ServerManager of the application.
   */
  public function synchronize():Boolean
  {
    return synchronizeServers();
  }
  /**
   * Returns the connection a request that has just failed is to be repeated on.
   * @param groupKey the key of the connection group
   * @param connectionKey the key of the connection that has just failed
   */
  public function anotherAfterFailure(groupKey:String, connectionKey:String):Object
  {
    return anotherConnectionAfterFailure(groupKey, connectionKey);
  }
  /**
   * Builds the connection of a server that has just appeared: the extenders of the
   * framework are the ones knowing the settings of a connection of their own, and the
   * address of that server is every setting this one carries.
   * @param serverKey the name of the machine that server stands on
   * @param serverAddress the address of that server
   */
  override protected function addServerConnection(serverKey:String, serverAddress:String):Boolean
  {
    super.addServerConnection(serverKey, serverAddress);
    if (addNewConnection(serverGroupKey, serverKey) == null)
    {
      return false;
    }
    return setConnectionParam(serverGroupKey, serverKey, "url", serverAddress);
  }
}
