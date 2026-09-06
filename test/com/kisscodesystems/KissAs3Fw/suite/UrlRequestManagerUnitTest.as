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
 * UrlRequestManagerUnitTest
 * Checks the UrlRequestManager of the framework.
 *
 * MAIN FEATURES:
 * - the framework manager knows no address of any server at all, so every url of it is an
 *   empty one and it carries no connection group either: the applications extending it are
 *   the ones building those groups
 * - the repeating of a failed request is the one thing this manager does on its own, and
 *   that is checked on the UrlRequestManagerUnderTest standing at the bottom of this file:
 *   it carries a group of two servers, both of them on a port of this very machine nothing
 *   listens on, so nothing of this suite ever leaves the machine it runs on
 * - the failure of a server is raised by hand on the loader of it, because a real one
 *   arrives frames later, and the suite is a synchronous one
 * - the two servers of that group are the servers of this application as well, so they
 *   are put into the ServerManager of it: the failure of a request is reported to that
 *   manager and it is the one handing out the machine the request is repeated on
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import com.kisscodesystems.KissAs3Fw.manager.UrlRequestManager;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.IOErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequestMethod;
  public class UrlRequestManagerUnitTest extends BaseUnitTest
  {
    // the uri of the request this suite sends
    private const REQUEST_URI:String = "apiworks";
    // the uri of the api answering the addresses of the active servers
    private const ACTIVE_SERVERS_URI:String = "apiactiveservers";
    // the number of the answers the handler below has been called with, and the last one of
    // them: the repeating of a request is a silent one, so an answer arrives once only
    private var answerCount:int = 0;
    private var lastAnswer:Object = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function UrlRequestManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "UrlRequestManager";
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
     * Checks the manager of the framework: it knows no address at all, so every url of it
     * stands empty and there is no connection group of any kind to send a request on.
     */
    private function runFrameworkManagerTests():void
    {
      const requestManager:UrlRequestManager = new UrlRequestManager(application);
      assertNotNull("an UrlRequestManager is built", requestManager);
      // the urls of an application are the empty ones of the framework here
      assertEquals("getUrlBackgrounds of the framework", "", requestManager.getUrlBackgrounds());
      assertEquals("getUrlNc of the framework", "", requestManager.getUrlNc());
      assertEquals("getUrlSite of the framework", "", requestManager.getUrlSite());
      assertEquals("getUrlFiles of the framework", "", requestManager.getUrlFiles());
      assertEquals("getUrlSubmit of the framework", "", requestManager.getUrlSubmit());
      assertEquals("getUrlProfile of the framework", "", requestManager.getUrlProfile());
      assertEquals("getUrlCustom of the framework", "", requestManager.getUrlCustom());
      assertEquals("getUrlCustom2 of the framework", "", requestManager.getUrlCustom2());
      assertEquals("getUrlCustom3 of the framework", "", requestManager.getUrlCustom3());
      // and the framework builds no connection group either
      assertEquals("getDefaultConnectionKey of the framework", ""
        , requestManager.getDefaultConnectionKey(UrlRequestManagerUnderTest.GROUP_KEY));
      assertFalse("setConnectionGroupHandler of a group that does not exist"
        , requestManager.setConnectionGroupHandler(UrlRequestManagerUnderTest.GROUP_KEY, null));
      assertFalse("loadByConnectionGroup of a group that does not exist"
        , requestManager.loadByConnectionGroup(UrlRequestManagerUnderTest.GROUP_KEY, REQUEST_URI
          , URLRequestMethod.GET, null, answerHandler));
      assertFalse("loadByConnection of a connection that does not exist"
        , requestManager.loadByConnection(UrlRequestManagerUnderTest.GROUP_KEY
          , UrlRequestManagerUnderTest.CONNECTION_KEY_1, REQUEST_URI
          , URLRequestMethod.GET, null, answerHandler));
      assertEquals("no answer has arrived at all", 0, answerCount);
      // the one shot request of this manager: it is sent to a port of this very machine
      // nothing listens on and it is closed right away, so no answer of it can arrive
      const urlLoader:URLLoader = requestManager.send(UrlRequestManagerUnderTest.CONNECTION_URL_1
        , REQUEST_URI, URLRequestMethod.GET, null, null, null);
      assertNotNull("send hands the url loader it has built back", urlLoader);
      urlLoader.close();
      // and it has no server of this application to ask the active ones on either
      assertNull("loadActiveServers while the group of the servers is not set"
        , requestManager.loadActiveServers(ACTIVE_SERVERS_URI, null, null));
      requestManager.destroy();
      assertEquals("getUrlBackgrounds after the destroy", "", requestManager.getUrlBackgrounds());
    }
    /**
     * Checks the group of the two servers: a request is sent to the default one of them,
     * and the failure of that one is repeated on the other one silently. The one asking
     * for that request hears one single answer, and it hears it once every server of the
     * group has failed with it.
     */
    private function runConnectionGroupTests():void
    {
      // the two servers of the group are the servers of this application: the manager
      // under test follows them, so they stand in the ServerManager before it is built
      const serverManager:ServerManager = application.getServerManager();
      serverManager.addServer(UrlRequestManagerUnderTest.CONNECTION_KEY_1
        , UrlRequestManagerUnderTest.CONNECTION_URL_1);
      serverManager.addServer(UrlRequestManagerUnderTest.CONNECTION_KEY_2
        , UrlRequestManagerUnderTest.CONNECTION_URL_2);
      serverManager.setServerInUse(UrlRequestManagerUnderTest.CONNECTION_KEY_1);
      const managerUnderTest:UrlRequestManagerUnderTest = new UrlRequestManagerUnderTest(application);
      assertNotNull("an UrlRequestManagerUnderTest is built", managerUnderTest);
      assertEquals("the first server of the group is the default one"
        , UrlRequestManagerUnderTest.CONNECTION_KEY_1
        , managerUnderTest.getDefaultConnectionKey(UrlRequestManagerUnderTest.GROUP_KEY));
      assertEquals("the url of the first server", UrlRequestManagerUnderTest.CONNECTION_URL_1
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "url"));
      assertEquals("the answer of a new connection is read as a query string of variables"
        , URLLoaderDataFormat.VARIABLES
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "dataFormat"));
      assertEquals("a new connection has been tried by no request at all", 0
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "tries"));
      assertFalse("a new connection is not busy"
        , Boolean(managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "busy")));
      // the request is sent to the default server of the group
      assertTrue("loadByConnectionGroup of the group of the two servers"
        , managerUnderTest.loadByConnectionGroup(UrlRequestManagerUnderTest.GROUP_KEY, REQUEST_URI
          , URLRequestMethod.GET, null, answerHandler));
      assertTrue("the first server is busy with that request"
        , Boolean(managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "busy")));
      assertEquals("that request has been sent to one server so far", 1
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "tries"));
      assertFalse("loadByConnectionGroup while the server of the group is busy"
        , managerUnderTest.loadByConnectionGroup(UrlRequestManagerUnderTest.GROUP_KEY, REQUEST_URI
          , URLRequestMethod.GET, null, answerHandler));
      // the first server fails with it, so it is repeated on the second one silently
      const urlLoaderOfTheFirst:URLLoader = managerUnderTest.getUrlLoaderOf(
        UrlRequestManagerUnderTest.CONNECTION_KEY_1);
      assertNotNull("the url loader of the first server", urlLoaderOfTheFirst);
      urlLoaderOfTheFirst.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
      assertEquals("the second server is the default one of the group from now"
        , UrlRequestManagerUnderTest.CONNECTION_KEY_2
        , managerUnderTest.getDefaultConnectionKey(UrlRequestManagerUnderTest.GROUP_KEY));
      assertEquals("the server manager has given this application over to that server"
        , UrlRequestManagerUnderTest.CONNECTION_KEY_2, serverManager.getServerInUse());
      assertFalse("the first server is not busy any more"
        , Boolean(managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "busy")));
      assertTrue("the second server is busy with the repeated request"
        , Boolean(managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "busy")));
      assertEquals("that request has been sent to two servers by now", 2
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "tries"));
      assertEquals("the one asking for it has heard nothing of that failure", 0, answerCount);
      // the second server fails as well: every server of the group has been tried with
      // this request, so there is nothing left to repeat it on and the caller is told
      const urlLoaderOfTheSecond:URLLoader = managerUnderTest.getUrlLoaderOf(
        UrlRequestManagerUnderTest.CONNECTION_KEY_2);
      assertNotNull("the url loader of the second server", urlLoaderOfTheSecond);
      urlLoaderOfTheSecond.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
      assertEquals("the one asking for it is told about the failure of the whole group"
        , 1, answerCount);
      assertNull("and that answer is a null one", lastAnswer);
      assertEquals("the tries of the second server are counted from the start again", 0
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "tries"));
      assertFalse("the second server is not busy any more"
        , Boolean(managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "busy")));
      // the handler of the group is taken away the way an object being torn down does it
      assertTrue("setConnectionGroupHandler of the group of the two servers"
        , managerUnderTest.setConnectionGroupHandler(UrlRequestManagerUnderTest.GROUP_KEY, null));
      assertNull("the answer handler of the second server after that"
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "onUrlStatus"));
      // the request asking the addresses of the active servers travels on the server of
      // the group standing in use, and it is closed right away: it is sent to a port nothing listens on, and
      // one that is left standing keeps this application from closing itself
      const activeServersRequestLoader:URLLoader = managerUnderTest.loadActiveServers(
        ACTIVE_SERVERS_URI, null, null);
      assertNotNull("loadActiveServers on the server of the group standing in use"
        , activeServersRequestLoader);
      activeServersRequestLoader.close();
      // a server taken away from this application disappears from the group of its own
      // accord: the manager is told about it with the event of the server manager
      assertTrue("removeServer of the second server, the one in use"
        , serverManager.removeServer(UrlRequestManagerUnderTest.CONNECTION_KEY_2));
      assertNull("the connection of that server after the event of that change"
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_2, "url"));
      assertEquals("the url of the first server, the one left standing"
        , UrlRequestManagerUnderTest.CONNECTION_URL_1
        , managerUnderTest.getParam(UrlRequestManagerUnderTest.CONNECTION_KEY_1, "url"));
      assertEquals("the first server is the default one of the group from now"
        , UrlRequestManagerUnderTest.CONNECTION_KEY_1
        , managerUnderTest.getDefaultConnectionKey(UrlRequestManagerUnderTest.GROUP_KEY));
      managerUnderTest.destroy();
    }
    /**
     * Takes the answer of the group of the two servers: that is the handler this suite
     * hands over to every request of it.
     * @param answer the answer of the server, or null when every one of them has failed
     */
    private function answerHandler(answer:Object):void
    {
      answerCount++;
      lastAnswer = answer;
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
      answerCount = 0;
      lastAnswer = null;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.manager.UrlRequestManager;
import flash.net.URLLoader;
/**
 * UrlRequestManagerUnderTest: the manager the group tests of this suite talk to. It builds
 * one group of two servers, both of them standing on a port of this very machine nothing
 * listens on, so a request sent to them never leaves this machine and it fails at once.
 * The parameters of a connection and the loader of it are opened up as well: those are the
 * ones telling whether a request has been repeated and which server it has gone to.
 */
internal class UrlRequestManagerUnderTest extends UrlRequestManager
{
  public static const GROUP_KEY:String = "KissAs3Ut";
  public static const CONNECTION_KEY_1:String = "app1";
  public static const CONNECTION_KEY_2:String = "app2";
  public static const CONNECTION_URL_1:String = "http://127.0.0.1:1/one/";
  public static const CONNECTION_URL_2:String = "http://127.0.0.1:1/two/";
  /**
   * Constructs the manager under test.
   * @param applicationRef the main application reference
   */
  public function UrlRequestManagerUnderTest(applicationRef:Application):void
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
   * Returns the url loader of a connection of the group of this manager, the one a failure
   * of that server is raised on.
   * @param connectionKey the key of the connection
   */
  public function getUrlLoaderOf(connectionKey:String):URLLoader
  {
    const connectionObject:Object = getConnection(GROUP_KEY, connectionKey);
    if (connectionObject == null)
    {
      return null;
    }
    return connectionObject["urlLoader"] as URLLoader;
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
    setDefaultConnection(GROUP_KEY, CONNECTION_KEY_1);
  }
}
