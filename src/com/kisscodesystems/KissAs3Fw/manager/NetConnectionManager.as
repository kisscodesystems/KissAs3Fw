/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 * https://github.com/kisscodesystems/KissAs3Mp
 * DESCRIPTION:
 * NetConnectionManager.
 * Manages the rtmp communication to the outside world.
 * - the connections stand in the groups of the BaseRequestManager: one connection of a
 *   group is open at a time, the default one of it, and the remote methods of that group
 *   are called on it
 * - when that connection fails, this manager opens another server of the very same group
 *   silently and that server becomes the default one of the group: the one using the
 *   application only sees that the connection has been there all along
 * - it stops once every server of the group has failed to take that connection, so a
 *   group that can not be reached at all is left alone instead of being knocked on for
 *   ever: connectAttempts counts the servers tried since the last standing connection
 * - this class knows no address of any server at all: the initializeConnections below is
 *   the place an application builds the groups of its own in
 * - the properties of a connection of this manager are:
 *   connectionObject [ "url" ]             : String
 *   connectionObject [ "netConnection" ]   : NetConnection
 *   connectionObject [ "onNetStatus" ]     : Function
 *   connectionObject [ "onNetError" ]      : Function
 *   connectionObject [ "client" ]          : Object
 *   connectionObject [ "connectParams" ]   : Array
 *   connectionObject [ "connectAttempts" ] : int
 * - a connection parameter must be added to define the onXxx handlers and the client, and
 *   the setConnectionGroupHandlers below sets those handlers on every connection of a
 *   group at once, so that they stay in place when the group fails over to another server
 * - connectParams holds the parameters of the connect call one by one: they are spread
 *   into that call, because an array handed over as it stands would arrive at the server
 *   as one single parameter
 * - a connection that carries no client of its own is given the one of this manager: the
 *   server calls onBWCheck, onBWDone and onStatus on the client of a connection by itself
 *   and a client that does not answer them raises an async error, which this manager would
 *   take for a failed connection and reconnect on
 * - every connection agrees on amf0 while it connects: red5 answers a call in the encoding
 *   of the connection and its amf3 answers never reach the Responder of the call, so the
 *   call goes out, the server runs the method and nothing ever comes back of it
 * - the group of the servers of an application follows the ServerManager: the base of
 *   this class gives it over to the servers standing there, so the connection of it is
 *   opened to the very machine the whole application is talking to at the moment
 * - a connection that fails is reported to the ServerManager and reopened on the server
 *   it hands out then, and the http requests of the application move along with it
 * - a server taken away while the connection stands on it is removed like every other
 *   one, and the connection is reopened on another server right away, so the application
 *   does not lose it without a word
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseRequestManager;
  import flash.events.AsyncErrorEvent;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.NetConnection;
  import flash.net.ObjectEncoding;
  import flash.net.Responder;
  public class NetConnectionManager extends BaseRequestManager
  {
    public var NS_FAILED:String = "NetStream.Failed";
    public var NS_START:String = "NetStream.Play.Start";
    public var NS_STOP:String = "NetStream.Play.Stop";
    public var NS_RESET:String = "NetStream.Play.Reset";
    public var NS_BFULL:String = "NetStream.Buffer.Full";
    public var NS_BEMPTY:String = "NetStream.Buffer.Empty";
    public var NS_SNOTIFY:String = "NetStream.Seek.Notify";
    public var NS_SSNOTIFY:String = "NetStream.SeekStart.Notify";
    public var NS_SCOMPLETE:String = "NetStream.Seek.Complete";
    public var NS_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
    public var NS_BFLUSH:String = "NetStream.Buffer.Flush";
    public var NS_PSTART:String = "NetStream.Publish.Start";
    protected var toReconnect:Boolean = true;
    // the object encoding of every net connection of this manager: red5 answers a call in
    // the encoding the connecting has agreed on, and the answers it writes in amf3 never
    // reach the Responder of the call, so the call is started and nothing ever comes back
    // of it. Every connection of this manager therefore agrees on amf0 while it connects,
    // which is the encoding the answers do arrive in
    protected var objectEncoding:uint = ObjectEncoding.AMF0;
    // the client object of a net connection that carries none of its own: the server calls
    // these methods on the client of the connection and the runtime raises an async error
    // when it does not find them, which the manager would see as a failed connection and
    // reconnect on, so they stand here even though nothing of the application uses them
    protected var defaultClient:Object = null;
    /**
     * Constructs the net connection manager: it builds the connection groups of the
     * application, the servers the socket connections of it are opened to.
     * @param applicationRef the application reference
     */
    public function NetConnectionManager(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<NetConnectionManager> called.", 1);
      application.trace("<NetConnectionManager> applicationRef: " + applicationRef, 0);
      defaultClient = createDefaultClient();
      initializeConnections();
      application.trace("<NetConnectionManager> constructed.", 1);
    }
    /**
     * Creates a new net connection, wires its listeners and starts connecting.
     * @param url the url to connect to
     * @param client the client object of the net connection
     * @param onNetStatus the external net status handler
     * @param onNetError the external net error handler
     * @param connectParams the parameters passed to the connect call
     */
    public function connect(url:String, client:Object = null, onNetStatus:Function = null, onNetError:Function = null, ...connectParams):NetConnection
    {
      application.trace("<NetConnectionManager connect> called.", 1);
      application.trace("<NetConnectionManager connect> url: " + url, 0);
      application.trace("<NetConnectionManager connect> client: " + client, 0);
      application.trace("<NetConnectionManager connect> onNetStatus: " + onNetStatus, 0);
      application.trace("<NetConnectionManager connect> onNetError: " + onNetError, 0);
      application.trace("<NetConnectionManager connect> connectParams: " + connectParams, 0);
      var netConnection:NetConnection = new NetConnection();
      try
      {
        if (onNetStatus != null)
        {
          netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
        }
        if (onNetError != null)
        {
          netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onNetError);
          netConnection.addEventListener(IOErrorEvent.IO_ERROR, onNetError);
          netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError);
        }
        netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler0);
        netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler0);
        netConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
        netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
        // a net connection takes no client of null at all, so the one of this manager is
        // given to a connection that carries none of its own
        netConnection.client = client == null ? defaultClient : client;
        // the encoding has to be agreed on before the connecting starts: it is the one the
        // answers of the calls of this connection arrive in afterwards
        netConnection.objectEncoding = objectEncoding;
        // the rest arguments have to be spread back into the connect call one by one:
        // handing the array of them over as it stands would send one single parameter
        // holding all of them, and the server would see an array instead of the values
        netConnection.connect.apply(netConnection, [ url ].concat(connectParams));
        application.trace("<NetConnectionManager connect> started to connect.", 1);
      }
      catch (e:*)
      {
        application.trace("<NetConnectionManager connect> exception: " + e, 7);
        close(netConnection, onNetStatus, onNetError);
        netConnection = null;
        application.trace("<NetConnectionManager connect> unable to connect, closed.", 6);
      }
      return netConnection;
    }
    /**
     * Calls a remote method on the given net connection.
     * @param netConnection the connected net connection
     * @param callName the name of the remote method
     * @param callBack the result handler (callBack0 is used when null)
     * @param callParams the parameters passed to the remote method
     */
    public function call(netConnection:NetConnection, callName:String, callBack:Function, ...callParams):Boolean
    {
      application.trace("<NetConnectionManager call> called.", 1);
      application.trace("<NetConnectionManager call> netConnection: " + netConnection, 0);
      application.trace("<NetConnectionManager call> callName: " + callName, 0);
      application.trace("<NetConnectionManager call> callBack: " + callBack, 0);
      application.trace("<NetConnectionManager call> callParams: " + callParams, 0);
      if (netConnection == null)
      {
        application.trace("<NetConnectionManager call> netConnection is null!", 6);
        return false;
      }
      if (!netConnection.connected)
      {
        application.trace("<NetConnectionManager call> netConnection is not connected!", 6);
        return false;
      }
      try
      {
        // the rest arguments have to be spread back into the call one by one, the same way
        // the connect above does it: an array handed over as it stands arrives at the server
        // as one single parameter, and red5 gives that array to the remote method without
        // converting it, so the call dies with an argument type mismatch
        netConnection.call.apply(netConnection
          , [ callName, new Responder(callBack == null ? callBack0 : callBack) ].concat(callParams));
        application.trace("<NetConnectionManager call> calling is started.", 1);
        return true;
      }
      catch (e:*)
      {
        application.trace("<NetConnectionManager call> exception: " + e, 7);
      }
      application.trace("<NetConnectionManager call> unable to call!", 6);
      return false;
    }
    /**
     * Removes every listener of the given net connection and closes it.
     * @param netConnection the net connection to close
     * @param onNetStatus the external net status handler to remove
     * @param onNetError the external net error handler to remove
     */
    public function close(netConnection:NetConnection, onNetStatus:Function = null, onNetError:Function = null):Boolean
    {
      application.trace("<NetConnectionManager close> called.", 1);
      application.trace("<NetConnectionManager close> netConnection: " + netConnection, 0);
      application.trace("<NetConnectionManager close> onNetStatus: " + onNetStatus, 0);
      application.trace("<NetConnectionManager close> onNetError: " + onNetError, 0);
      if (netConnection == null)
      {
        application.trace("<NetConnectionManager close> netConnection is null!", 6);
        return false;
      }
      try
      {
        if (onNetStatus != null)
        {
          netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
        }
        if (onNetError != null)
        {
          netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onNetError);
          netConnection.removeEventListener(IOErrorEvent.IO_ERROR, onNetError);
          netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError);
        }
        netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler0);
        netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler0);
        netConnection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
        netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
        netConnection.client = new Object();
        netConnection.close();
        netConnection = null;
        application.trace("<NetConnectionManager close> netConnection is now closed.", 1);
        return true;
      }
      catch (e:*)
      {
        application.trace("<NetConnectionManager close> exception: " + e, 7);
      }
      application.trace("<NetConnectionManager close> unable to close!", 6);
      return false;
    }
    /**
     * Sets the two handlers of the connection of the given group: they are set on every
     * connection of it at once, because the group opens another server of its own when the
     * one in use fails, and the one listening to that connection has to hear the new one
     * just as it heard the old one.
     * @param groupKey the key of the connection group
     * @param onNetStatus the net status handler of every connection of that group
     * @param onNetError the net error handler of every connection of that group
     */
    public function setConnectionGroupHandlers(groupKey:String, onNetStatus:Function, onNetError:Function):Boolean
    {
      application.trace("<NetConnectionManager setConnectionGroupHandlers> called.", 1);
      application.trace("<NetConnectionManager setConnectionGroupHandlers> groupKey: " + groupKey, 0);
      application.trace("<NetConnectionManager setConnectionGroupHandlers> onNetStatus: " + onNetStatus, 0);
      application.trace("<NetConnectionManager setConnectionGroupHandlers> onNetError: " + onNetError, 0);
      const connectionGroup:Object = getConnectionGroup(groupKey);
      if (connectionGroup == null)
      {
        application.trace("<NetConnectionManager setConnectionGroupHandlers> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      for (var connectionKey:String in connectionGroup)
      {
        setConnectionParam(groupKey, connectionKey, "onNetStatus", onNetStatus);
        setConnectionParam(groupKey, connectionKey, "onNetError", onNetError);
      }
      application.trace("<NetConnectionManager setConnectionGroupHandlers> the handlers of every connection of this group are set.", 1);
      return true;
    }
    /**
     * Tells whether the connection of the given group stands open at the moment: that is
     * the default connection of it, the one server of that group this manager talks to.
     * @param groupKey the key of the connection group
     */
    public function isConnectionGroupConnected(groupKey:String):Boolean
    {
      application.trace("<NetConnectionManager isConnectionGroupConnected> called.", 1);
      application.trace("<NetConnectionManager isConnectionGroupConnected> groupKey: " + groupKey, 0);
      const connectionObject:Object = getDefaultConnection(groupKey);
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager isConnectionGroupConnected> there is no default connection in this group!", 6);
        return false;
      }
      if (!(connectionObject["netConnection"] is NetConnection))
      {
        application.trace("<NetConnectionManager isConnectionGroupConnected> netConnection of the default connection is not a NetConnection.", 0);
        return false;
      }
      const connected:Boolean = NetConnection(connectionObject["netConnection"]).connected;
      application.trace("<NetConnectionManager isConnectionGroupConnected> connected: " + connected, 0);
      return connected;
    }
    /**
     * Connects to the default connection of the given group: that is the server the whole
     * application is talking to at the moment, so the socket of it is opened to the very
     * machine its http requests travel on. A group that carries no default connection at
     * all is one no server has been picked of yet, and then any one of them is as good as
     * the others.
     * @param groupKey the key of the connection group
     */
    public function connectByConnectionGroup(groupKey:String):Boolean
    {
      application.trace("<NetConnectionManager connectByConnectionGroup> called.", 1);
      application.trace("<NetConnectionManager connectByConnectionGroup> groupKey: " + groupKey, 0);
      const connectionObject:Object = getDefaultConnection(groupKey);
      if (connectionObject != null)
      {
        return connectToConnection(connectionObject);
      }
      return connectToConnection(getRandomConnection(groupKey));
    }
    /**
     * Connects to the given connection of the given group.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     */
    public function connectByConnection(groupKey:String, connectionKey:String):Boolean
    {
      application.trace("<NetConnectionManager connectByConnection> called.", 1);
      application.trace("<NetConnectionManager connectByConnection> groupKey: " + groupKey, 0);
      application.trace("<NetConnectionManager connectByConnection> connectionKey: " + connectionKey, 0);
      return connectToConnection(getConnection(groupKey, connectionKey));
    }
    /**
     * Calls a remote method on the default connection of the given group: the one server
     * of that group standing connected at the moment.
     * @param groupKey the key of the connection group
     * @param callName the name of the remote method
     * @param callBack the result handler
     * @param callParams the parameters passed to the remote method
     */
    public function callByConnectionGroup(groupKey:String, callName:String, callBack:Function, ...callParams):Boolean
    {
      application.trace("<NetConnectionManager callByConnectionGroup> called.", 1);
      application.trace("<NetConnectionManager callByConnectionGroup> groupKey: " + groupKey, 0);
      application.trace("<NetConnectionManager callByConnectionGroup> callName: " + callName, 0);
      application.trace("<NetConnectionManager callByConnectionGroup> callBack: " + callBack, 0);
      application.trace("<NetConnectionManager callByConnectionGroup> callParams: " + callParams, 0);
      return callOnConnection(getDefaultConnection(groupKey), callName, callBack, callParams);
    }
    /**
     * Calls a remote method on the given connection of the given group.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     * @param callName the name of the remote method
     * @param callBack the result handler
     * @param callParams the parameters passed to the remote method
     */
    public function callByConnection(groupKey:String, connectionKey:String, callName:String, callBack:Function, ...callParams):Boolean
    {
      application.trace("<NetConnectionManager callByConnection> called.", 1);
      application.trace("<NetConnectionManager callByConnection> groupKey: " + groupKey, 0);
      application.trace("<NetConnectionManager callByConnection> connectionKey: " + connectionKey, 0);
      application.trace("<NetConnectionManager callByConnection> callName: " + callName, 0);
      application.trace("<NetConnectionManager callByConnection> callBack: " + callBack, 0);
      application.trace("<NetConnectionManager callByConnection> callParams: " + callParams, 0);
      return callOnConnection(getConnection(groupKey, connectionKey), callName, callBack, callParams);
    }
    /**
     * Closes the net connection stored in the given connection object.
     * @param connectionObject the connection object whose net connection has to be closed
     */
    public function closeConnection(connectionObject:Object):Boolean
    {
      application.trace("<NetConnectionManager closeConnection> called.", 1);
      application.trace("<NetConnectionManager closeConnection> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager closeConnection> connectionObject is null or undefined!", 6);
        return false;
      }
      if (connectionObject["netConnection"] == null || connectionObject["netConnection"] == undefined)
      {
        application.trace("<NetConnectionManager closeConnection> netConnection of connectionObject is null or undefined!", 6);
        return false;
      }
      return close(NetConnection(connectionObject["netConnection"]), connectionObject["onNetStatus"], connectionObject["onNetError"]);
    }
    /**
     * Closes every net connection of every group.
     */
    public function closeAllConnections():Boolean
    {
      application.trace("<NetConnectionManager closeAllConnections> called.", 1);
      for (var groupKey:String in connectionGroups)
      {
        for (var connectionKey:String in connectionGroups[groupKey])
        {
          closeConnection(connectionGroups[groupKey][connectionKey]);
        }
      }
      return true;
    }
    /**
     * Closes every net connection of the given group.
     * @param groupKey the key of the connection group
     */
    public function closeEveryConnections(groupKey:String):Boolean
    {
      application.trace("<NetConnectionManager closeEveryConnections> called.", 1);
      application.trace("<NetConnectionManager closeEveryConnections> groupKey: " + groupKey, 0);
      const connectionGroup:Object = getConnectionGroup(groupKey);
      if (connectionGroup == null)
      {
        application.trace("<NetConnectionManager closeEveryConnections> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      for (var connectionKey:String in connectionGroup)
      {
        closeConnection(connectionGroup[connectionKey]);
      }
      return true;
    }
    /**
     * Gives the group of the servers over to the ServerManager and reopens the connection
     * of it on the machine standing in use from now on. That connection is reopened only
     * when it stood open before this: a group nobody had opened is left closed, because
     * opening one is the business of the ones using it. This is what keeps the socket of
     * the application on the very server its http requests travel on, whichever of the
     * two has failed and moved the application to another machine.
     */
    override protected function synchronizeServers():Boolean
    {
      application.trace("<NetConnectionManager synchronizeServers> called.", 1);
      const connectionStood:Boolean = isConnectionGroupConnected(serverGroupKey);
      const synchronized:Boolean = super.synchronizeServers();
      if (connectionStood && !isConnectionGroupConnected(serverGroupKey))
      {
        application.trace("<NetConnectionManager synchronizeServers> the server this group stood on is not the one in use any more, so the connection of it is reopened on that one.", 1);
        connectByConnectionGroup(serverGroupKey);
      }
      return synchronized;
    }
    /**
     * Builds the connection groups of this application: the servers its socket connections
     * are opened to. The framework knows no address of any server, so it builds no group at
     * all: an application extending this class overrides this one, calls the super and then
     * adds the groups and the connections of its own with the addNewConnectionGroup, the
     * addNewConnection and the setConnectionParam of the BaseRequestManager.
     */
    protected function initializeConnections():void
    {
      application.trace("<NetConnectionManager initializeConnections> called.", 1);
      application.trace("<NetConnectionManager initializeConnections> the extenders of this class build their connection groups here.", 0);
    }
    /**
     * Handles the net status event of a managed net connection and reconnects on connection errors.
     * @param e the net status event
     */
    protected function netStatusHandler0(e:NetStatusEvent):void
    {
      application.trace("<NetConnectionManager netStatusHandler0> called.", 1);
      application.trace("<NetConnectionManager netStatusHandler0> e: " + e, 0);
      if (e != null)
      {
        application.trace("<NetConnectionManager netStatusHandler0> e.info: " + e.info, 0);
        if (e.info != null)
        {
          application.trace("<NetConnectionManager netStatusHandler0> e.info.code: " + e.info.code, 0);
          switch (e.info.code)
          {
            case "NetConnection.Connect.Success":
              connectionStands(e);
              break;
            case "NetConnection.Connect.AppShutdown":
            case "NetConnection.Connect.Closed":
            case "NetConnection.Connect.Failed":
            case "NetConnection.Connect.IdleTimeout":
            case "NetConnection.Connect.InvalidApp":
            case "NetConnection.Connect.Rejected":
              reconnectLogic(e);
              break;
            default:
              break;
          }
        }
      }
    }
    /**
     * Handles the async error event of a managed net connection and tries to reconnect.
     * @param e the async error event
     */
    protected function asyncErrorHandler0(e:AsyncErrorEvent):void
    {
      application.trace("<NetConnectionManager asyncErrorHandler0> called.", 1);
      application.trace("<NetConnectionManager asyncErrorHandler0> e: " + e, 0);
      reconnectLogic(e);
    }
    /**
     * Handles the io error event of a managed net connection and tries to reconnect.
     * @param e the io error event
     */
    protected function ioErrorHandler0(e:IOErrorEvent):void
    {
      application.trace("<NetConnectionManager ioErrorHandler0> called.", 1);
      application.trace("<NetConnectionManager ioErrorHandler0> e: " + e, 0);
      reconnectLogic(e);
    }
    /**
     * Handles the security error event of a managed net connection and tries to reconnect.
     * @param e the security error event
     */
    protected function securityErrorHandler0(e:SecurityErrorEvent):void
    {
      application.trace("<NetConnectionManager securityErrorHandler0> called.", 1);
      application.trace("<NetConnectionManager securityErrorHandler0> e: " + e, 0);
      reconnectLogic(e);
    }
    /**
     * The default result handler used when no callback is given to a call.
     * @param resultObject the result object returned by the remote method
     */
    protected function callBack0(resultObject:Object):void
    {
      application.trace("<NetConnectionManager callBack0> called.", 1);
      application.trace("<NetConnectionManager callBack0> resultObject: " + resultObject, 0);
    }
    /**
     * Builds the client object every connection of this manager carries when it has none of
     * its own: the three methods below are the ones an rtmp server calls on the client of a
     * connection by itself, and a connection whose client does not answer them loses itself
     * on the first one of them, so they are answered here and nothing more is done of them.
     */
    protected function createDefaultClient():Object
    {
      application.trace("<NetConnectionManager createDefaultClient> called.", 1);
      const client:Object = new Object();
      client.onBWCheck = onBWCheck0;
      client.onBWDone = onBWDone0;
      client.onStatus = onStatus0;
      return client;
    }
    /**
     * Answers the bandwidth check of the server: it asks the client of the connection how
     * much of it there is and the number sent back is the one it goes on with.
     * @param callParams the parameters of that check
     */
    protected function onBWCheck0(... callParams):Number
    {
      application.trace("<NetConnectionManager onBWCheck0> called.", 1);
      application.trace("<NetConnectionManager onBWCheck0> callParams: " + callParams, 0);
      return 0;
    }
    /**
     * Takes the end of the bandwidth check of the server.
     * @param callParams the parameters of that check
     */
    protected function onBWDone0(... callParams):void
    {
      application.trace("<NetConnectionManager onBWDone0> called.", 1);
      application.trace("<NetConnectionManager onBWDone0> callParams: " + callParams, 0);
    }
    /**
     * Takes the status the server sends to the client of the connection by itself.
     * @param callParams the parameters of that status
     */
    protected function onStatus0(... callParams):void
    {
      application.trace("<NetConnectionManager onStatus0> called.", 1);
      application.trace("<NetConnectionManager onStatus0> callParams: " + callParams, 0);
    }
    /**
     * Calls a remote method on the net connection stored in the given connection object.
     * @param connectionObject the connection object holding the net connection
     * @param callName the name of the remote method
     * @param callBack the result handler
     * @param callParams the array of the parameters passed to the remote method
     */
    protected function callOnConnection(connectionObject:Object, callName:String, callBack:Function, callParams:Array):Boolean
    {
      application.trace("<NetConnectionManager callOnConnection> called.", 1);
      application.trace("<NetConnectionManager callOnConnection> connectionObject: " + connectionObject, 0);
      application.trace("<NetConnectionManager callOnConnection> callName: " + callName, 0);
      application.trace("<NetConnectionManager callOnConnection> callBack: " + callBack, 0);
      application.trace("<NetConnectionManager callOnConnection> callParams: " + callParams, 0);
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager callOnConnection> connectionObject is null!", 6);
        return false;
      }
      if (!(connectionObject["netConnection"] is NetConnection))
      {
        application.trace("<NetConnectionManager callOnConnection> netConnection of connectionObject is not a NetConnection!", 6);
        return false;
      }
      // callParams is the array of the parameters of this call, so it is spread into the
      // call above, which takes them one by one
      var callArguments:Array = [ NetConnection(connectionObject["netConnection"]), callName, callBack ];
      if (callParams != null)
      {
        callArguments = callArguments.concat(callParams);
      }
      return call.apply(this, callArguments);
    }
    /**
     * Reconnects the group of the connection that raised the given error event: another
     * server of that very group is opened silently and it becomes the default one of it.
     * Nothing is opened once every server of the group has failed to take that connection:
     * a group that can not be reached at all is left alone instead of being knocked on for
     * ever, and the next connection standing on any server of it opens that road again.
     * @param e the error event of the failed connection
     */
    protected function reconnectLogic(e:Event):void
    {
      application.trace("<NetConnectionManager reconnectLogic> called.", 1);
      application.trace("<NetConnectionManager reconnectLogic> e: " + e, 0);
      if (!toReconnect)
      {
        application.trace("<NetConnectionManager reconnectLogic> no need to reconnect, quit.", 1);
        return;
      }
      if (e == null)
      {
        application.trace("<NetConnectionManager reconnectLogic> e is null!", 6);
        return;
      }
      if (!(e.target is NetConnection))
      {
        application.trace("<NetConnectionManager reconnectLogic> e.target is not a NetConnection object!", 6);
        return;
      }
      const connectionObject:Object = findConnectionObjectByNetConnection(NetConnection(e.target));
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager reconnectLogic> cannot find the object of this net connection, quit.", 1);
        return;
      }
      const groupKey:String = "" + connectionObject["groupKey"];
      const connectAttempts:int = int(connectionObject["connectAttempts"]);
      application.trace("<NetConnectionManager reconnectLogic> " + connectAttempts + " server(s) of the group " + groupKey + " have been tried since the last standing connection.", 0);
      if (connectAttempts >= getConnectionCount(groupKey))
      {
        application.trace("<NetConnectionManager reconnectLogic> every server of the group " + groupKey + " has failed to take this connection!", 6);
        return;
      }
      const anotherConnectionObject:Object = anotherConnectionAfterFailure(groupKey
        , "" + connectionObject["connectionKey"]);
      if (anotherConnectionObject == null)
      {
        application.trace("<NetConnectionManager reconnectLogic> there is no other server this group could be reconnected to!", 6);
        return;
      }
      if (connectToConnection(anotherConnectionObject))
      {
        // the connecting above counts the attempts of that server from one: the ones of
        // the servers that have failed before it are added here
        anotherConnectionObject["connectAttempts"] = connectAttempts + 1;
        application.trace("<NetConnectionManager reconnectLogic> reconnecting to another server of the group silently.", 1);
        application.trace("<NetConnectionManager reconnectLogic> the connectionKey of that server: " + anotherConnectionObject["connectionKey"], 0);
      }
      else
      {
        application.trace("<NetConnectionManager reconnectLogic> the connection cannot be reopened to the other server!", 6);
      }
    }
    /**
     * Takes the connection of a group that has just been opened: the servers that have
     * failed before it are forgotten, so a connection that is lost later on has every one
     * of them to be reopened to.
     * @param e the net status event of the connection that stands
     */
    protected function connectionStands(e:NetStatusEvent):void
    {
      application.trace("<NetConnectionManager connectionStands> called.", 1);
      application.trace("<NetConnectionManager connectionStands> e: " + e, 0);
      if (!(e.target is NetConnection))
      {
        application.trace("<NetConnectionManager connectionStands> e.target is not a NetConnection object!", 6);
        return;
      }
      const connectionObject:Object = findConnectionObjectByNetConnection(NetConnection(e.target));
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager connectionStands> cannot find the object of this net connection, quit.", 1);
        return;
      }
      connectionObject["connectAttempts"] = 0;
      application.trace("<NetConnectionManager connectionStands> the connection of the group " + connectionObject["groupKey"] + " stands on the server " + connectionObject["connectionKey"] + ".", 1);
    }
    /**
     * Returns the connection object that owns the given net connection.
     * @param netConnection the net connection to look up
     */
    protected function findConnectionObjectByNetConnection(netConnection:NetConnection):Object
    {
      application.trace("<NetConnectionManager findConnectionObjectByNetConnection> called.", 1);
      application.trace("<NetConnectionManager findConnectionObjectByNetConnection> netConnection: " + netConnection, 0);
      if (netConnection == null)
      {
        application.trace("<NetConnectionManager findConnectionObjectByNetConnection> netConnection is null!", 6);
        return null;
      }
      for (var groupKey:String in connectionGroups)
      {
        for (var connectionKey:String in connectionGroups[groupKey])
        {
          if (connectionGroups[groupKey][connectionKey]["netConnection"] is NetConnection)
          {
            if (netConnection == NetConnection(connectionGroups[groupKey][connectionKey]["netConnection"]))
            {
              application.trace("<NetConnectionManager findConnectionObjectByNetConnection> object is found.", 1);
              application.trace("<NetConnectionManager findConnectionObjectByNetConnection> object: " + connectionGroups[groupKey][connectionKey], 0);
              return connectionGroups[groupKey][connectionKey];
            }
          }
        }
      }
      application.trace("<NetConnectionManager findConnectionObjectByNetConnection> object is not found.", 1);
      return null;
    }
    /**
     * Initializes the net connection specific fields of a connection object.
     * @param connectionObject the connection object to prepare
     */
    override protected function prepareConnection(connectionObject:Object):void
    {
      application.trace("<NetConnectionManager prepareConnection> called.", 1);
      application.trace("<NetConnectionManager prepareConnection> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager prepareConnection> connectionObject is null!", 6);
        return;
      }
      super.prepareConnection(connectionObject);
      if (connectionObject["url"] == undefined || connectionObject["url"] == null)
      {
        connectionObject["url"] = "";
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"url\" ] = " + connectionObject["url"], 0);
      }
      if (connectionObject["netConnection"] == undefined)
      {
        connectionObject["netConnection"] = null;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"netConnection\" ] = " + connectionObject["netConnection"], 0);
      }
      if (connectionObject["onNetStatus"] == undefined)
      {
        connectionObject["onNetStatus"] = null;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"onNetStatus\" ] = " + connectionObject["onNetStatus"], 0);
      }
      if (connectionObject["onNetError"] == undefined)
      {
        connectionObject["onNetError"] = null;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"onNetError\" ] = " + connectionObject["onNetError"], 0);
      }
      if (connectionObject["client"] == undefined)
      {
        connectionObject["client"] = null;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"client\" ] = " + connectionObject["client"], 0);
      }
      if (connectionObject["connectParams"] == undefined)
      {
        connectionObject["connectParams"] = null;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"connectParams\" ] = " + connectionObject["connectParams"], 0);
      }
      if (connectionObject["connectAttempts"] == undefined)
      {
        connectionObject["connectAttempts"] = 0;
        application.trace("<NetConnectionManager prepareConnection> connectionObject [ \"connectAttempts\" ] = " + connectionObject["connectAttempts"], 0);
      }
      application.trace("<NetConnectionManager prepareConnection> connectionObject is initialized.", 0);
    }
    /**
     * Closes the net connection of the given connection, then removes the connection.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection to remove
     */
    override protected function removeConnection(groupKey:String, connectionKey:String):Boolean
    {
      application.trace("<NetConnectionManager removeConnection> called.", 1);
      application.trace("<NetConnectionManager removeConnection> groupKey: " + groupKey, 0);
      application.trace("<NetConnectionManager removeConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<NetConnectionManager removeConnection> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<NetConnectionManager removeConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<NetConnectionManager removeConnection> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      closeConnection(connectionGroups[groupKey][connectionKey]);
      return super.removeConnection(groupKey, connectionKey);
    }
    /**
     * Connects to the given connection object, initializing and wiring its net connection.
     * @param connectionObject the connection object to connect to
     */
    private function connectToConnection(connectionObject:Object):Boolean
    {
      application.trace("<NetConnectionManager connectToConnection> called.", 1);
      application.trace("<NetConnectionManager connectToConnection> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<NetConnectionManager connectToConnection> connectionObject is null!", 6);
        return false;
      }
      else
      {
        application.trace("<NetConnectionManager connectToConnection> connectionObject groupKey: " + connectionObject["groupKey"], 0);
        application.trace("<NetConnectionManager connectToConnection> connectionObject connectionKey: " + connectionObject["connectionKey"], 0);
      }
      prepareConnection(connectionObject);
      if (connectionObject["url"] == "")
      {
        application.trace("<NetConnectionManager connectToConnection> url of connectionObject is empty!", 6);
        return false;
      }
      closeEveryConnections(connectionObject["groupKey"]);
      var netConnection:NetConnection = null;
      if (connectionObject["netConnection"] != null)
      {
        try
        {
          netConnection = NetConnection(connectionObject["netConnection"]);
          application.trace("<NetConnectionManager connectToConnection> netConnection of connectionObject is found and is not empty.", 1);
        }
        catch (e:*)
        {
          application.trace("<NetConnectionManager connectToConnection> exception(1): " + e, 7);
          netConnection = new NetConnection();
          connectionObject["netConnection"] = netConnection;
          application.trace("<NetConnectionManager connectToConnection> netConnection of connectionObject is re-initialized.", 1);
        }
      }
      else
      {
        netConnection = new NetConnection();
        connectionObject["netConnection"] = netConnection;
        application.trace("<NetConnectionManager connectToConnection> netConnection of connectionObject is initialized.", 1);
      }
      try
      {
        if (connectionObject["onNetStatus"] != null)
        {
          netConnection.addEventListener(NetStatusEvent.NET_STATUS, connectionObject["onNetStatus"]);
        }
        if (connectionObject["onNetError"] != null)
        {
          netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, connectionObject["onNetError"]);
          netConnection.addEventListener(IOErrorEvent.IO_ERROR, connectionObject["onNetError"]);
          netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionObject["onNetError"]);
        }
        netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler0);
        netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler0);
        netConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
        netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
        // a net connection takes no client of null at all, so the one of this manager is
        // given to a connection that carries none of its own
        netConnection.client = connectionObject["client"] == null
          ? defaultClient : connectionObject["client"];
        // the encoding has to be agreed on before the connecting starts: it is the one the
        // answers of the calls of this connection arrive in afterwards
        netConnection.objectEncoding = objectEncoding;
        // the parameters of this connection are spread into the connect call one by one:
        // the array of them handed over as it stands would arrive at the server as one
        // single parameter holding all of them
        var connectArguments:Array = [ connectionObject["url"] ];
        const connectParams:Array = connectionObject["connectParams"] as Array;
        if (connectParams != null)
        {
          connectArguments = connectArguments.concat(connectParams);
        }
        netConnection.connect.apply(netConnection, connectArguments);
        // this is the first server of the group being tried: the reconnectLogic counts
        // this one further every time it opens another server of the group
        connectionObject["connectAttempts"] = 1;
        application.trace("<NetConnectionManager connectToConnection> connect method is started.", 1);
        return setDefaultConnection(connectionObject["groupKey"], connectionObject["connectionKey"]);
      }
      catch (e:*)
      {
        application.trace("<NetConnectionManager connectToConnection> exception(6): " + e, 7);
        close(netConnection, connectionObject["onNetStatus"], connectionObject["onNetError"]);
        netConnection = null;
        application.trace("<NetConnectionManager connectToConnection> connect method cannot be started, netConnection set to null!", 1);
      }
      return false;
    }
    /**
     * Closes every net connection and destroys this object.
     */
    override public function destroy():void
    {
      application.trace("<NetConnectionManager destroy> called.", 1);
      closeAllConnections();
      super.destroy();
      toReconnect = false;
      defaultClient = null;
      NS_FAILED = null;
      NS_START = null;
      NS_STOP = null;
      NS_RESET = null;
      NS_BFULL = null;
      NS_BEMPTY = null;
      NS_SNOTIFY = null;
      NS_SSNOTIFY = null;
      NS_SCOMPLETE = null;
      NS_NOT_FOUND = null;
      NS_BFLUSH = null;
      NS_PSTART = null;
    }
  }
}
