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
 * UrlRequestManager.
 * Manages the http communication to the outside world.
 * - the connections of the requests stand in the groups of the BaseRequestManager: the
 *   requests of one group are sent on the default connection of it, and a request that
 *   fails is repeated on another server of that very group, so the one using the
 *   application never learns that it has been sent twice
 * - that other server becomes the default one of its group, and the request is given up
 *   only after every server of the group has failed with it: the caller hears that one
 *   single failure, with a null answer
 * - this class knows no address of any server at all: the initializeConnections and the
 *   initializeUrls below are the two places an application fills those in
 * - the properties of a connection of this manager are:
 *   connectionObject [ "url" ]         : String
 *   connectionObject [ "dataFormat" ]  : String
 *   connectionObject [ "urlLoader" ]   : URLLoader
 *   connectionObject [ "urlRequest" ]  : URLRequest
 *   connectionObject [ "onUrlStatus" ] : Function
 *   connectionObject [ "busy" ]        : Boolean
 *   connectionObject [ "tries" ]       : int
 * - the answer handler of a connection is the one the request being sent carries, and the
 *   setConnectionGroupHandler below sets it on every connection of a group at once, so
 *   that an object being torn down can take its own handler away from all of them
 * - the format the answer of a server is read in is the setting of the connection it
 *   comes from, because one server answers in the very same format all the time
 * - the group of the servers of an application follows the ServerManager: the base of
 *   this class gives it over to the servers standing there, so every request of it
 *   travels on the machine the whole application is talking to at the moment
 * - a request that fails on that machine is reported to the ServerManager and repeated on
 *   the server it hands out then, so the rtmp connection of the application moves along
 *   with the requests of this manager
 * - the addresses of the active servers are asked by the ServerManager with the
 *   loadActiveServers below, on a one-shot loader of its own, so that asking never blocks
 *   a request of the application and never takes the answer of one either
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseRequestManager;
  import flash.events.Event;
  import flash.events.HTTPStatusEvent;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  public class UrlRequestManager extends BaseRequestManager
  {
    // The urls of the outside world this application talks to. Every one of them stands
    // empty in the framework: an application extending this class fills in the ones it
    // needs by overriding initializeUrls, so that every url of that application lives
    // in this one single place instead of being spread over the classes using them.
    // The folder of the background images of the displaying styles is one of them: the
    // framework brings the default style alone, whose image is an embedded one, so every
    // further style is the one of an application and it is loaded from the server of it.
    protected var urlBackgrounds:String = "";
    protected var urlNc:String = "";
    protected var urlSite:String = "";
    protected var urlFiles:String = "";
    protected var urlSubmit:String = "";
    protected var urlProfile:String = "";
    protected var urlCustom:String = "";
    protected var urlCustom2:String = "";
    protected var urlCustom3:String = "";
    /**
     * Constructs the url request manager: it builds the connection groups of the
     * application and it fills in the urls of it, in this order, because those urls are
     * usually taken from the very connections that have just been built.
     * @param applicationRef the application reference
     */
    public function UrlRequestManager(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<UrlRequestManager> called.", 1);
      application.trace("<UrlRequestManager> applicationRef: " + applicationRef, 0);
      initializeConnections();
      initializeUrls();
      application.trace("<UrlRequestManager> constructed.", 1);
    }
    /**
     * Returns the url of the folder the background images of the displaying styles are
     * loaded from, with the closing slash on the end of it.
     */
    public function getUrlBackgrounds():String
    {
      return urlBackgrounds;
    }
    /**
     * Returns the url of the net connection of this application.
     */
    public function getUrlNc():String
    {
      return urlNc;
    }
    /**
     * Returns the url of the site of this application.
     */
    public function getUrlSite():String
    {
      return urlSite;
    }
    /**
     * Returns the url the files of this application are loaded from.
     */
    public function getUrlFiles():String
    {
      return urlFiles;
    }
    /**
     * Returns the url the forms of this application are submitted to.
     */
    public function getUrlSubmit():String
    {
      return urlSubmit;
    }
    /**
     * Returns the url of the profile of the one using this application.
     */
    public function getUrlProfile():String
    {
      return urlProfile;
    }
    /**
     * Returns the first url this application uses for a purpose of its own.
     */
    public function getUrlCustom():String
    {
      return urlCustom;
    }
    /**
     * Returns the second url this application uses for a purpose of its own.
     */
    public function getUrlCustom2():String
    {
      return urlCustom2;
    }
    /**
     * Returns the third url this application uses for a purpose of its own.
     */
    public function getUrlCustom3():String
    {
      return urlCustom3;
    }
    /**
     * Sends a one-shot http request on a brand new url loader and returns that loader to the caller.
     * @param url the base url of the request
     * @param uri the uri appended to the base url
     * @param method the http method of the request
     * @param data the variables to be sent with the request
     * @param onUrlStatus the status handler wired to the loader events
     * @param onUrlError the error handler wired to the loader error events
     * @param dataFormat the format the answer is read in, the variables of a query string when none is given
     */
    public function send(url:String, uri:String, method:String, data:Object, onUrlStatus:Function, onUrlError:Function, dataFormat:String = null):URLLoader
    {
      application.trace("<UrlRequestManager send> called.", 1);
      application.trace("<UrlRequestManager send> url: " + url, 0);
      application.trace("<UrlRequestManager send> uri: " + uri, 0);
      application.trace("<UrlRequestManager send> method: " + method, 0);
      application.trace("<UrlRequestManager send> data: " + data, 0);
      application.trace("<UrlRequestManager send> onUrlStatus: " + onUrlStatus, 0);
      application.trace("<UrlRequestManager send> onUrlError: " + onUrlError, 0);
      application.trace("<UrlRequestManager send> dataFormat: " + dataFormat, 0);
      application.trace("<UrlRequestManager send> creating loader.", 0);
      const urlLoader:URLLoader = new URLLoader();
      urlLoader.dataFormat = dataFormat == null ? URLLoaderDataFormat.VARIABLES : dataFormat;
      if (onUrlStatus != null)
      {
        urlLoader.addEventListener(Event.OPEN, onUrlStatus);
        urlLoader.addEventListener(Event.COMPLETE, onUrlStatus);
        urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onUrlStatus);
        urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUrlStatus);
        urlLoader.addEventListener(ProgressEvent.PROGRESS, onUrlStatus);
      }
      if (onUrlError != null)
      {
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlError);
      }
      urlLoader.addEventListener(Event.OPEN, openHandler0);
      urlLoader.addEventListener(Event.COMPLETE, completeHandler0);
      urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler0);
      urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler0);
      urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler0);
      urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
      urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
      const urlVariables:URLVariables = new URLVariables();
      if (data != null)
      {
        application.trace("<UrlRequestManager send> setting variables.", 0);
        for (var key:String in data)
        {
          urlVariables[key] = data[key];
          application.trace("<UrlRequestManager send> urlVariables[\"" + key + "\"] = " + urlVariables[key], 0);
        }
      }
      else
      {
        application.trace("<UrlRequestManager send> variables remain empty.", 0);
      }
      application.trace("<UrlRequestManager send> creating urlrequest.", 0);
      const urlRequest:URLRequest = new URLRequest();
      urlRequest.data = urlVariables;
      urlRequest.method = method;
      urlRequest.url = url + uri;
      application.trace("<UrlRequestManager send> sending..", 0);
      urlLoader.load(urlRequest);
      return urlLoader;
    }
    /**
     * Sets the answer handler of every connection of the given group at once. A request
     * carries the handler of its own already, so the one calling this is the object that
     * has just been torn down: a null handler set here keeps an answer arriving afterwards
     * from ever reaching it, whichever server of the group that answer comes from.
     * @param groupKey the key of the connection group
     * @param onUrlStatus the answer handler of every connection of that group
     */
    public function setConnectionGroupHandler(groupKey:String, onUrlStatus:Function):Boolean
    {
      application.trace("<UrlRequestManager setConnectionGroupHandler> called.", 1);
      application.trace("<UrlRequestManager setConnectionGroupHandler> groupKey: " + groupKey, 0);
      application.trace("<UrlRequestManager setConnectionGroupHandler> onUrlStatus: " + onUrlStatus, 0);
      const connectionGroup:Object = getConnectionGroup(groupKey);
      if (connectionGroup == null)
      {
        application.trace("<UrlRequestManager setConnectionGroupHandler> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      for (var connectionKey:String in connectionGroup)
      {
        setConnectionParam(groupKey, connectionKey, "onUrlStatus", onUrlStatus);
      }
      application.trace("<UrlRequestManager setConnectionGroupHandler> the handler of every connection of this group is set.", 1);
      return true;
    }
    /**
     * Loads a request on the default connection of the given group: the server of that
     * group this manager talks to at the moment. A request that fails is repeated on
     * another server of the very same group silently, and the given handler is called with
     * a null answer only after every one of them has failed with it.
     * @param groupKey the key of the connection group
     * @param uri the uri of the request
     * @param method the http method of the request
     * @param data the variables to be sent with the request
     * @param onUrlStatus the status handler of the request
     */
    public function loadByConnectionGroup(groupKey:String, uri:String, method:String, data:Object, onUrlStatus:Function):Boolean
    {
      application.trace("<UrlRequestManager loadByConnectionGroup> called.", 1);
      application.trace("<UrlRequestManager loadByConnectionGroup> groupKey: " + groupKey, 0);
      application.trace("<UrlRequestManager loadByConnectionGroup> uri: " + uri, 0);
      application.trace("<UrlRequestManager loadByConnectionGroup> method: " + method, 0);
      application.trace("<UrlRequestManager loadByConnectionGroup> data: " + data, 0);
      application.trace("<UrlRequestManager loadByConnectionGroup> onUrlStatus: " + onUrlStatus, 0);
      return loadOnConnection(getDefaultConnection(groupKey), uri, method, data, onUrlStatus);
    }
    /**
     * Loads a request on the given connection of the given group.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     * @param uri the uri of the request
     * @param method the http method of the request
     * @param data the variables to be sent with the request
     * @param onUrlStatus the status handler of the request
     */
    public function loadByConnection(groupKey:String, connectionKey:String, uri:String, method:String, data:Object, onUrlStatus:Function):Boolean
    {
      application.trace("<UrlRequestManager loadByConnection> called.", 1);
      application.trace("<UrlRequestManager loadByConnection> groupKey: " + groupKey, 0);
      application.trace("<UrlRequestManager loadByConnection> connectionKey: " + connectionKey, 0);
      application.trace("<UrlRequestManager loadByConnection> uri: " + uri, 0);
      application.trace("<UrlRequestManager loadByConnection> method: " + method, 0);
      application.trace("<UrlRequestManager loadByConnection> data: " + data, 0);
      application.trace("<UrlRequestManager loadByConnection> onUrlStatus: " + onUrlStatus, 0);
      return loadOnConnection(getConnection(groupKey, connectionKey), uri, method, data, onUrlStatus);
    }
    /**
     * Sends the request asking the addresses of the servers of this application: that api
     * stands on the very servers this manager talks to, so the request travels on the http
     * server in use at the moment, and its plain text answer is handed to the given
     * handler. It is sent on a one-shot loader of its own on purpose: the connections of
     * the group carry the requests of the application, and this one has no business
     * blocking any of them. The one calling it is the ServerManager, whatever kind of
     * connection the addresses it asks for are opened by: that list is answered over http
     * all the same. The loader of that request is handed back to the caller the way the
     * send above does it, so an object that wants to give it up can close it.
     * @param uri the uri of the api answering those addresses
     * @param onUrlStatus the status handler of that request
     * @param onUrlError the error handler of that request
     */
    public function loadActiveServers(uri:String, onUrlStatus:Function, onUrlError:Function):URLLoader
    {
      application.trace("<UrlRequestManager loadActiveServers> called.", 1);
      application.trace("<UrlRequestManager loadActiveServers> uri: " + uri, 0);
      application.trace("<UrlRequestManager loadActiveServers> onUrlStatus: " + onUrlStatus, 0);
      application.trace("<UrlRequestManager loadActiveServers> onUrlError: " + onUrlError, 0);
      if (serverGroupKey == "")
      {
        application.trace("<UrlRequestManager loadActiveServers> the group of the servers of this manager is not set, so there is no server to ask at all!", 6);
        return null;
      }
      const urlObject:Object = getConnectionParam(serverGroupKey
        , getDefaultConnectionKey(serverGroupKey), "url");
      if (urlObject == null)
      {
        application.trace("<UrlRequestManager loadActiveServers> the group of the servers holds no server to ask!", 6);
        return null;
      }
      // the answer of this api is plain text and no query string of variables at all
      return send("" + urlObject, uri, URLRequestMethod.GET, null, onUrlStatus, onUrlError
        , URLLoaderDataFormat.TEXT);
    }
    /**
     * Gives the group of the servers over to the ServerManager and fills in the urls of
     * this application again: those urls are taken from the server standing in use, so
     * the background images of the displaying styles and every address of the application
     * travel on the very machine its requests do, whichever one that is at the moment.
     */
    override protected function synchronizeServers():Boolean
    {
      application.trace("<UrlRequestManager synchronizeServers> called.", 1);
      const synchronized:Boolean = super.synchronizeServers();
      if (synchronized)
      {
        initializeUrls();
      }
      return synchronized;
    }
    /**
     * Builds the connection groups of this application: the servers it sends its requests
     * to. The framework knows no address of any server, so it builds no group at all: an
     * application extending this class overrides this one, calls the super and then adds
     * the groups and the connections of its own with the addNewConnectionGroup, the
     * addNewConnection and the setConnectionParam of the BaseRequestManager.
     */
    protected function initializeConnections():void
    {
      application.trace("<UrlRequestManager initializeConnections> called.", 1);
      application.trace("<UrlRequestManager initializeConnections> the extenders of this class build their connection groups here.", 0);
    }
    /**
     * Fills in the urls of the outside world this application talks to. The framework
     * itself knows no address at all, so it leaves every one of them empty: an
     * application extending this class overrides this one, calls the super and then
     * assigns the urls it needs.
     */
    protected function initializeUrls():void
    {
      application.trace("<UrlRequestManager initializeUrls> called.", 1);
      application.trace("<UrlRequestManager initializeUrls> the extenders of this class assign their own urls here.", 0);
    }
    /**
     * Handles the open event of a managed url loader.
     * @param e the open event
     */
    protected function openHandler0(e:Event):void
    {
      application.trace("<UrlRequestManager openHandler0> called.", 1);
      application.trace("<UrlRequestManager openHandler0> e: " + e, 0);
    }
    /**
     * Handles the complete event of a managed url loader: the request of its connection is
     * over, so that connection is free again and the answer is handed to the caller. The
     * flags are cleared before that handler is called, because a new request can be
     * started right inside it.
     * @param e the complete event
     */
    protected function completeHandler0(e:Event):void
    {
      application.trace("<UrlRequestManager completeHandler0> called.", 1);
      application.trace("<UrlRequestManager completeHandler0> e: " + e, 0);
      const urlLoader:URLLoader = URLLoader(e.target);
      const connectionObject:Object = findConnectionObjectByUrlLoader(urlLoader);
      if (connectionObject == null)
      {
        application.trace("<UrlRequestManager completeHandler0> cannot find the object of this url loader, quit.", 1);
        return;
      }
      connectionObject["busy"] = false;
      connectionObject["tries"] = 0;
      const onUrlStatus:Function = connectionObject["onUrlStatus"] as Function;
      if (onUrlStatus != null)
      {
        onUrlStatus(e.target.data);
      }
    }
    /**
     * Handles the http response status event of a managed url loader.
     * @param e the http status event
     */
    protected function httpResponseStatusHandler0(e:HTTPStatusEvent):void
    {
      application.trace("<UrlRequestManager httpResponseStatusHandler0> called.", 1);
      application.trace("<UrlRequestManager httpResponseStatusHandler0> e: " + e, 0);
    }
    /**
     * Handles the http status event of a managed url loader.
     * @param e the http status event
     */
    protected function httpStatusHandler0(e:HTTPStatusEvent):void
    {
      application.trace("<UrlRequestManager httpStatusHandler0> called.", 1);
      application.trace("<UrlRequestManager httpStatusHandler0> e: " + e, 0);
    }
    /**
     * Handles the progress event of a managed url loader.
     * @param e the progress event
     */
    protected function progressHandler0(e:ProgressEvent):void
    {
      application.trace("<UrlRequestManager progressHandler0> called.", 1);
      application.trace("<UrlRequestManager progressHandler0> e: " + e, 0);
    }
    /**
     * Handles the io error event of a managed url loader and tries to resend the request.
     * @param e the io error event
     */
    protected function ioErrorHandler0(e:IOErrorEvent):void
    {
      application.trace("<UrlRequestManager ioErrorHandler0> called.", 1);
      application.trace("<UrlRequestManager ioErrorHandler0> e: " + e, 0);
      resendLogic(e);
    }
    /**
     * Handles the security error event of a managed url loader and tries to resend the request.
     * @param e the security error event
     */
    protected function securityErrorHandler0(e:SecurityErrorEvent):void
    {
      application.trace("<UrlRequestManager securityErrorHandler0> called.", 1);
      application.trace("<UrlRequestManager securityErrorHandler0> e: " + e, 0);
      resendLogic(e);
    }
    /**
     * Loads a request on the given connection object, creating its url loader if necessary.
     * @param connectionObject the connection object to load on
     * @param uri the uri of the request
     * @param method the http method of the request
     * @param data the variables to be sent with the request
     * @param onUrlStatus the status handler of the request
     */
    protected function loadOnConnection(connectionObject:Object, uri:String, method:String, data:Object, onUrlStatus:Function):Boolean
    {
      application.trace("<UrlRequestManager loadOnConnection> called.", 1);
      application.trace("<UrlRequestManager loadOnConnection> connectionObject: " + connectionObject, 0);
      application.trace("<UrlRequestManager loadOnConnection> uri: " + uri, 0);
      application.trace("<UrlRequestManager loadOnConnection> method: " + method, 0);
      application.trace("<UrlRequestManager loadOnConnection> data: " + data, 0);
      application.trace("<UrlRequestManager loadOnConnection> onUrlStatus: " + onUrlStatus, 0);
      if (connectionObject == null)
      {
        application.trace("<UrlRequestManager loadOnConnection> connectionObject is null!", 6);
        return false;
      }
      prepareConnection(connectionObject);
      if (connectionObject["url"] == "")
      {
        application.trace("<UrlRequestManager loadOnConnection> url of connectionObject is empty!", 6);
        return false;
      }
      if (connectionObject["busy"])
      {
        application.trace("<UrlRequestManager loadOnConnection> connectionObject is busy!", 6);
        return false;
      }
      connectionObject["busy"] = true;
      connectionObject["onUrlStatus"] = onUrlStatus;
      // this is the first server this request is sent to: the resendLogic below counts
      // this one further every time it repeats the request on another server of the group
      connectionObject["tries"] = 1;
      if (connectionObject["urlLoader"] == null)
      {
        const newUrlLoader:URLLoader = new URLLoader();
        newUrlLoader.addEventListener(Event.OPEN, openHandler0);
        newUrlLoader.addEventListener(Event.COMPLETE, completeHandler0);
        newUrlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler0);
        newUrlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler0);
        newUrlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler0);
        newUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
        newUrlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
        connectionObject["urlLoader"] = newUrlLoader;
      }
      if (!(connectionObject["urlLoader"] is URLLoader))
      {
        application.trace("<UrlRequestManager loadOnConnection> urlLoader of connectionObject is not a URLLoader!", 6);
        // this connection is carrying no request after all, so it is a free one again:
        // a busy flag left standing here would block every further request of it
        connectionObject["busy"] = false;
        connectionObject["tries"] = 0;
        return false;
      }
      const urlLoader:URLLoader = URLLoader(connectionObject["urlLoader"]);
      // the answer of one server is read in the very same format all the time, so that
      // format is the setting of the connection itself and not the one of a single request
      urlLoader.dataFormat = "" + connectionObject["dataFormat"];
      const urlVariables:URLVariables = new URLVariables();
      if (data != null)
      {
        application.trace("<UrlRequestManager loadOnConnection> setting variables.", 0);
        for (var key:String in data)
        {
          urlVariables[key] = data[key];
          application.trace("<UrlRequestManager loadOnConnection> urlVariables[\"" + key + "\"] = " + urlVariables[key], 0);
        }
      }
      else
      {
        application.trace("<UrlRequestManager loadOnConnection> variables remain empty.", 0);
      }
      var urlRequest:URLRequest = null;
      if (connectionObject["urlRequest"] == null)
      {
        application.trace("<UrlRequestManager loadOnConnection> creating urlrequest.", 0);
        urlRequest = new URLRequest();
        connectionObject["urlRequest"] = urlRequest;
      }
      else
      {
        application.trace("<UrlRequestManager loadOnConnection> urlrequest is existing.", 0);
        urlRequest = connectionObject["urlRequest"];
      }
      urlRequest.data = urlVariables;
      urlRequest.method = method;
      urlRequest.url = connectionObject["url"] + uri;
      urlLoader.load(urlRequest);
      return true;
    }
    /**
     * Returns the connection object that owns the given url loader.
     * @param urlLoader the url loader to look up
     */
    protected function findConnectionObjectByUrlLoader(urlLoader:URLLoader):Object
    {
      application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> called.", 1);
      application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> urlLoader: " + urlLoader, 0);
      if (urlLoader == null)
      {
        application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> urlLoader is null!", 6);
        return null;
      }
      for (var groupKey:String in connectionGroups)
      {
        for (var connectionKey:String in connectionGroups[groupKey])
        {
          if (connectionGroups[groupKey][connectionKey]["urlLoader"] is URLLoader)
          {
            if (urlLoader == URLLoader(connectionGroups[groupKey][connectionKey]["urlLoader"]))
            {
              application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> object is found.", 1);
              application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> object: " + connectionGroups[groupKey][connectionKey], 0);
              return connectionGroups[groupKey][connectionKey];
            }
          }
        }
      }
      application.trace("<UrlRequestManager findConnectionObjectByUrlLoader> object is not found.", 1);
      return null;
    }
    /**
     * Initializes the url loader specific fields of a connection object.
     * @param connectionObject the connection object to prepare
     */
    override protected function prepareConnection(connectionObject:Object):void
    {
      application.trace("<UrlRequestManager prepareConnection> called.", 1);
      application.trace("<UrlRequestManager prepareConnection> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<UrlRequestManager prepareConnection> connectionObject is null!", 6);
        return;
      }
      super.prepareConnection(connectionObject);
      if (connectionObject["url"] == undefined || connectionObject["url"] == null)
      {
        connectionObject["url"] = "";
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"url\" ] = " + connectionObject["url"], 0);
      }
      if (connectionObject["dataFormat"] == undefined || connectionObject["dataFormat"] == null)
      {
        connectionObject["dataFormat"] = URLLoaderDataFormat.VARIABLES;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"dataFormat\" ] = " + connectionObject["dataFormat"], 0);
      }
      if (connectionObject["urlLoader"] == undefined)
      {
        connectionObject["urlLoader"] = null;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"urlLoader\" ] = " + connectionObject["urlLoader"], 0);
      }
      if (connectionObject["urlRequest"] == undefined)
      {
        connectionObject["urlRequest"] = null;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"urlRequest\" ] = " + connectionObject["urlRequest"], 0);
      }
      if (connectionObject["onUrlStatus"] == undefined)
      {
        connectionObject["onUrlStatus"] = null;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"onUrlStatus\" ] = " + connectionObject["onUrlStatus"], 0);
      }
      if (connectionObject["busy"] == undefined)
      {
        connectionObject["busy"] = false;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"busy\" ] = " + connectionObject["busy"], 0);
      }
      if (connectionObject["tries"] == undefined)
      {
        connectionObject["tries"] = 0;
        application.trace("<UrlRequestManager prepareConnection> connectionObject [ \"tries\" ] = " + connectionObject["tries"], 0);
      }
      application.trace("<UrlRequestManager prepareConnection> connectionObject is initialized.", 0);
    }
    /**
     * Closes and removes the url loader of the given connection, then removes the connection.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection to remove
     */
    override protected function removeConnection(groupKey:String, connectionKey:String):Boolean
    {
      application.trace("<UrlRequestManager removeConnection> called.", 1);
      application.trace("<UrlRequestManager removeConnection> groupKey: " + groupKey, 0);
      application.trace("<UrlRequestManager removeConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<UrlRequestManager removeConnection> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<UrlRequestManager removeConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<UrlRequestManager removeConnection> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      const connectionObject:Object = getConnection(groupKey, connectionKey);
      if (connectionObject != null && connectionObject["urlLoader"] != null)
      {
        try
        {
          const urlLoader:URLLoader = URLLoader(connectionObject["urlLoader"]);
          if (urlLoader != null)
          {
            urlLoader.removeEventListener(Event.OPEN, openHandler0);
            urlLoader.removeEventListener(Event.COMPLETE, completeHandler0);
            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler0);
            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler0);
            urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler0);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler0);
            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler0);
            connectionObject["urlLoader"] = null;
            connectionObject["urlRequest"] = null;
            // the function of the caller has to go as well, exactly as the close method of
            // the NetConnectionManager does it: a loader that is still on its way would call
            // it on an object that has been torn down in the meantime
            connectionObject["onUrlStatus"] = null;
            try
            {
              urlLoader.close();
            }
            catch (closeException:*)
            {
              application.trace("<UrlRequestManager removeConnection> urlLoader closing exception, maybe there is no loading: " + closeException, 7);
            }
            application.trace("<UrlRequestManager removeConnection> urlLoader is now closed.", 1);
          }
          else
          {
            application.trace("<UrlRequestManager removeConnection> urlLoader is null!", 6);
          }
        }
        catch (exception:*)
        {
          application.trace("<UrlRequestManager removeConnection> exception: " + exception, 7);
        }
      }
      else
      {
        application.trace("<UrlRequestManager removeConnection> connection or urlLoader cannot be found!", 6);
      }
      return super.removeConnection(groupKey, connectionKey);
    }
    /**
     * Repeats the last unsuccessful request on another server of the same group, silently:
     * the one using the application is never told that the first server has failed. That
     * other server becomes the default one of its group, so every further request goes to
     * the one that has just answered. The request is given up only after every server of
     * the group has failed with it, and the caller hears that with a null answer.
     * @param e the error event of the failed request
     */
    private function resendLogic(e:Event):void
    {
      application.trace("<UrlRequestManager resendLogic> called.", 1);
      application.trace("<UrlRequestManager resendLogic> e: " + e, 0);
      if (e == null)
      {
        application.trace("<UrlRequestManager resendLogic> e is null!", 6);
        return;
      }
      if (!(e.target is URLLoader))
      {
        application.trace("<UrlRequestManager resendLogic> e.target is not a URLLoader object!", 6);
        return;
      }
      const urlLoader:URLLoader = URLLoader(e.target);
      const connectionObject:Object = findConnectionObjectByUrlLoader(urlLoader);
      if (connectionObject == null)
      {
        application.trace("<UrlRequestManager resendLogic> cannot find the object of this url loader, quit.", 1);
        return;
      }
      connectionObject["busy"] = false;
      const groupKey:String = "" + connectionObject["groupKey"];
      const connectionKey:String = "" + connectionObject["connectionKey"];
      const tries:int = int(connectionObject["tries"]);
      application.trace("<UrlRequestManager resendLogic> this request has been sent to " + tries + " server(s) of the group " + groupKey + " already.", 0);
      if (tries >= getConnectionCount(groupKey))
      {
        application.trace("<UrlRequestManager resendLogic> every server of the group " + groupKey + " has failed with this request!", 6);
        giveUpRequest(connectionObject);
        return;
      }
      const anotherConnectionObject:Object = anotherConnectionAfterFailure(groupKey, connectionKey);
      if (anotherConnectionObject == null)
      {
        application.trace("<UrlRequestManager resendLogic> there is no other server this request could be repeated on!", 6);
        giveUpRequest(connectionObject);
        return;
      }
      const urlRequest:URLRequest = connectionObject["urlRequest"] as URLRequest;
      if (urlRequest == null)
      {
        application.trace("<UrlRequestManager resendLogic> urlRequest of the failed connection is not there any more!", 6);
        giveUpRequest(connectionObject);
        return;
      }
      const uri:String = urlRequest.url.replace("" + connectionObject["url"], "");
      const method:String = urlRequest.method;
      const data:Object = urlRequest.data;
      const onUrlStatus:Function = connectionObject["onUrlStatus"] as Function;
      if (!setDefaultConnection(groupKey, "" + anotherConnectionObject["connectionKey"]))
      {
        application.trace("<UrlRequestManager resendLogic> unable to set the other server as the default one of its group!", 6);
      }
      if (loadOnConnection(anotherConnectionObject, uri, method, data, onUrlStatus))
      {
        // the load above has just started this request over on the other server, so it
        // counts the tries of it from one: the ones of the failed server are added here
        anotherConnectionObject["tries"] = tries + 1;
        application.trace("<UrlRequestManager resendLogic> the request is repeated on another server of the group silently.", 1);
        application.trace("<UrlRequestManager resendLogic> the connectionKey of that server: " + anotherConnectionObject["connectionKey"], 0);
      }
      else
      {
        application.trace("<UrlRequestManager resendLogic> the request cannot be repeated on the other server!", 6);
        giveUpRequest(connectionObject);
      }
    }
    /**
     * Gives up the request of the given connection: there is no server left to repeat it
     * on, so the caller of it is told that with a null answer. That answer is the only
     * failure it ever hears about, however many servers have been tried in the meantime.
     * @param connectionObject the connection object of the request being given up
     */
    private function giveUpRequest(connectionObject:Object):void
    {
      application.trace("<UrlRequestManager giveUpRequest> called.", 1);
      application.trace("<UrlRequestManager giveUpRequest> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<UrlRequestManager giveUpRequest> connectionObject is null!", 6);
        return;
      }
      connectionObject["tries"] = 0;
      const onUrlStatus:Function = connectionObject["onUrlStatus"] as Function;
      if (onUrlStatus != null)
      {
        onUrlStatus(null);
      }
    }
    /**
     * Closes every url loader of every connection and destroys this object.
     */
    override public function destroy():void
    {
      application.trace("<UrlRequestManager destroy> called.", 1);
      if (connectionGroups != null)
      {
        const groupKeys:Array = new Array();
        for (var groupKey:String in connectionGroups)
        {
          groupKeys.push(groupKey);
        }
        for (var i:int = 0; i < groupKeys.length; i++)
        {
          removeConnectionGroup(groupKeys[i]);
        }
      }
      super.destroy();
      urlBackgrounds = "";
      urlNc = "";
      urlSite = "";
      urlFiles = "";
      urlSubmit = "";
      urlProfile = "";
      urlCustom = "";
      urlCustom2 = "";
      urlCustom3 = "";
    }
  }
}
