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
 * ServerManager.
 * Manages the servers of the application: which ones there are and which one of them is
 * being talked to at the moment.
 *
 * MAIN FEATURES:
 * - one server of an application is in use at a time, and every manager of it talks to
 *   that very one: the http requests and the socket connections travel on the same
 *   machine, so the application stands on one server instead of being spread over the
 *   group of them
 * - this class knows the name and the address of every server and nothing else about
 *   them: how an address of one is turned into a url is the business of the manager
 *   using it, because that url is a different one for every kind of connection
 * - the servers of an application are the ones its extender adds while this manager is
 *   being built, and the api of that application answers the ones carrying it at the
 *   moment: that list is asked once when the application stands and once every
 *   activeServersTimerDelay milliseconds from then on, so a server that has just been put
 *   in front of the users appears here and one that has been taken away disappears
 * - a manager that fails to reach the server in use reports that with the serverFailed
 *   below, and this class is the one picking another server of the application then: one
 *   single failure moves every manager of it at once, so they never end up on two servers
 * - every change of these, the list and the server in use alike, is told with one single
 *   EVENT_SERVERS_CHANGED dispatched on the dispatcher of the application, and the ones
 *   listening to it take the servers of this class as they stand at that moment
 * - the uri of the api and the servers of an application are the settings of the
 *   extenders: this class asks nothing at all as long as that uri stands empty
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.net.URLLoader;
  import flash.system.System;
  import flash.utils.Timer;
  public class ServerManager
  {
    // the addresses of the active servers arrive in one single line of plain text, and
    // the name of the machine one of them stands on is the part of it standing before
    // its domain
    private const ACTIVE_SERVERS_SEPARATOR:String = ";";
    private const ACTIVE_SERVERS_DOMAIN_DELIMITER:String = ".";
    protected var application:Application = null;
    // the servers of this application: the address of every one of them stands under the
    // name of the machine it runs on, and that name is the key every manager knows it by
    protected var servers:Object = null;
    // the name of the machine in use at the moment, the empty string when this
    // application knows no server at all
    protected var serverInUse:String = "";
    // the uri of the api answering the addresses of the servers carrying this application
    // at the moment: it is the setting of the extenders and it stands empty here, so the
    // framework asks for those addresses nowhere
    protected var activeServersUri:String = "";
    protected var activeServersTimer:Timer = null;
    // the one event of this manager: it tells that the servers of this application have
    // changed, the list of them or the one in use alike
    private var eventServersChanged:Event = null;
    /**
     * Constructs the server manager and fills in the servers of the application, exiting
     * if no application reference is given. One of those servers is picked at random to
     * be the one in use, so the applications running at the same time share the load of
     * the group instead of standing on the very same machine all along.
     * @param applicationRef the application reference used for logging and services
     */
    public function ServerManager(applicationRef:Application):void
    {
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " ServerManager> called.", 1);
      application.trace("<" + this + " ServerManager> applicationRef: " + applicationRef, 0);
      servers = new Object();
      eventServersChanged = new Event(EnumEvents.EVENT_SERVERS_CHANGED());
      initializeServers();
      if (serverInUse == "")
      {
        setServerInUse(getRandomServerKey());
      }
      application.trace("<" + this + " ServerManager> the server in use: " + serverInUse, 1);
      application.trace("<" + this + " ServerManager> constructed.", 1);
    }
    /**
     * Returns the names of the machines the servers of this application stand on.
     */
    public function getServerKeys():Array
    {
      application.trace("<" + this + " ServerManager getServerKeys> called.", 1);
      const serverKeys:Array = new Array();
      for (var serverKey:String in servers)
      {
        serverKeys.push(serverKey);
      }
      application.trace("<" + this + " ServerManager getServerKeys> serverKeys: " + serverKeys, 0);
      return serverKeys;
    }
    /**
     * Returns the address of the given server, the empty string when this application
     * knows no server of that name.
     * @param serverKey the name of the machine that server stands on
     */
    public function getServerAddress(serverKey:String):String
    {
      application.trace("<" + this + " ServerManager getServerAddress> called.", 1);
      application.trace("<" + this + " ServerManager getServerAddress> serverKey: " + serverKey, 0);
      if (servers[serverKey] == undefined)
      {
        application.trace("<" + this + " ServerManager getServerAddress> there is no server with this name!", 6);
        return "";
      }
      return "" + servers[serverKey];
    }
    /**
     * Returns the number of the servers of this application.
     */
    public function getServerCount():int
    {
      application.trace("<" + this + " ServerManager getServerCount> called.", 1);
      var serverCount:int = 0;
      for (var serverKey:String in servers)
      {
        serverCount++;
      }
      application.trace("<" + this + " ServerManager getServerCount> serverCount: " + serverCount, 0);
      return serverCount;
    }
    /**
     * Returns the name of the machine in use at the moment.
     */
    public function getServerInUse():String
    {
      return serverInUse;
    }
    /**
     * Gives this application over to the given server: every manager of it talks to that
     * one from now on, and they are told about it with one single event. Setting the
     * server that is in use already changes nothing and tells nobody anything.
     * @param serverKey the name of the machine to be used from now on
     */
    public function setServerInUse(serverKey:String):Boolean
    {
      application.trace("<" + this + " ServerManager setServerInUse> called.", 1);
      application.trace("<" + this + " ServerManager setServerInUse> serverKey: " + serverKey, 0);
      if (servers[serverKey] == undefined)
      {
        application.trace("<" + this + " ServerManager setServerInUse> there is no server with this name!", 6);
        return false;
      }
      if (serverInUse == serverKey)
      {
        application.trace("<" + this + " ServerManager setServerInUse> this server is the one in use already.", 1);
        return true;
      }
      serverInUse = serverKey;
      application.trace("<" + this + " ServerManager setServerInUse> the server in use: " + serverInUse, 1);
      serversChanged();
      return true;
    }
    /**
     * Takes the failure of a server: the manager that could not reach it reports it here,
     * and this application is given over to another server of its own. Only the server in
     * use can fail, so the second manager reporting the very same machine is answered with
     * a false and nothing else: that machine has been left behind already. The answer is
     * false as well when this application has no other server to turn to, and then the one
     * reporting the failure is the one telling the ones using it about it.
     * @param serverKey the name of the machine that could not be reached
     */
    public function serverFailed(serverKey:String):Boolean
    {
      application.trace("<" + this + " ServerManager serverFailed> called.", 1);
      application.trace("<" + this + " ServerManager serverFailed> serverKey: " + serverKey, 0);
      if (serverKey != serverInUse)
      {
        application.trace("<" + this + " ServerManager serverFailed> this server is not the one in use, so it has been left behind already.", 1);
        return false;
      }
      const anotherServerKey:String = getAnotherServerKey(serverKey);
      if (anotherServerKey == "")
      {
        application.trace("<" + this + " ServerManager serverFailed> this application has no other server to turn to!", 6);
        return false;
      }
      application.trace("<" + this + " ServerManager serverFailed> the server " + serverKey + " has failed, so this application turns to " + anotherServerKey + ".", 1);
      return setServerInUse(anotherServerKey);
    }
    /**
     * Adds a server to this application, or overwrites the address of one that stands
     * here already. The extenders add the servers they were built with, and the answers
     * of the api of the application add the ones appearing later on.
     * @param serverKey the name of the machine that server stands on
     * @param serverAddress the address of that server
     */
    public function addServer(serverKey:String, serverAddress:String):Boolean
    {
      application.trace("<" + this + " ServerManager addServer> called.", 1);
      application.trace("<" + this + " ServerManager addServer> serverKey: " + serverKey, 0);
      application.trace("<" + this + " ServerManager addServer> serverAddress: " + serverAddress, 0);
      if (serverKey == null || serverKey == "" || serverAddress == null || serverAddress == "")
      {
        application.trace("<" + this + " ServerManager addServer> a server has to have a name and an address!", 6);
        return false;
      }
      servers[serverKey] = serverAddress;
      application.trace("<" + this + " ServerManager addServer> the server " + serverKey + " stands at " + serverAddress + ".", 1);
      return true;
    }
    /**
     * Removes a server from this application. The last server of it is kept whatever
     * happens: an application left with none would have nowhere to turn to at all.
     * @param serverKey the name of the machine that server stands on
     */
    public function removeServer(serverKey:String):Boolean
    {
      application.trace("<" + this + " ServerManager removeServer> called.", 1);
      application.trace("<" + this + " ServerManager removeServer> serverKey: " + serverKey, 0);
      if (servers[serverKey] == undefined)
      {
        application.trace("<" + this + " ServerManager removeServer> there is no server with this name!", 6);
        return false;
      }
      if (getServerCount() <= 1)
      {
        application.trace("<" + this + " ServerManager removeServer> this is the last server of this application, so it is kept instead of being removed!", 6);
        return false;
      }
      servers[serverKey] = null;
      if (!delete servers[serverKey])
      {
        application.trace("<" + this + " ServerManager removeServer> unable to remove this server!", 6);
        return false;
      }
      application.trace("<" + this + " ServerManager removeServer> the server " + serverKey + " is removed.", 1);
      if (serverInUse == serverKey)
      {
        // the machine this application stood on has just been taken away, so another one
        // of them takes it over: the ones listening hear that with the event of it
        serverInUse = "";
        setServerInUse(getRandomServerKey());
      }
      return true;
    }
    /**
     * Asks the api of this application for the addresses of the servers carrying it at
     * the moment. The one calling this is the timer of the refreshing, and the ones using
     * the application call it as well when they want those addresses right away. That api
     * answers over http, so the url request manager of the application is the one sending
     * this request, and nothing is asked at all as long as the uri of the extender stands
     * empty: that is the application keeping the servers it was built with.
     */
    public function refreshServers():Boolean
    {
      application.trace("<" + this + " ServerManager refreshServers> called.", 1);
      if (activeServersUri == "")
      {
        application.trace("<" + this + " ServerManager refreshServers> the uri of the api of the active servers is not set, so there is nothing to ask for.", 1);
        return false;
      }
      const urlRequestManager:UrlRequestManager = application.getUrlRequestManager();
      if (urlRequestManager == null)
      {
        application.trace("<" + this + " ServerManager refreshServers> there is no url request manager to ask those addresses with!", 6);
        return false;
      }
      return urlRequestManager.loadActiveServers(activeServersUri, activeServersStatusHandler
        , activeServersErrorHandler) != null;
    }
    /**
     * Starts the refreshing of the servers of this application: the application calls this
     * one when every manager of it stands, because the addresses are asked over http and
     * the url request manager has to be there to ask them with. The list is asked once
     * right here and once every activeServersTimerDelay milliseconds from then on, so an
     * application that runs for a long time follows the servers of it all along.
     */
    public function startRefreshingServers():void
    {
      application.trace("<" + this + " ServerManager startRefreshingServers> called.", 1);
      if (activeServersUri == "")
      {
        application.trace("<" + this + " ServerManager startRefreshingServers> the uri of the api of the active servers is not set, so the servers of this application are never refreshed.", 1);
        return;
      }
      if (activeServersTimer != null)
      {
        application.trace("<" + this + " ServerManager startRefreshingServers> the refreshing is running already.", 1);
        return;
      }
      activeServersTimer = new Timer(application.getComponentsConfig().getActiveServersTimerDelay());
      activeServersTimer.addEventListener(TimerEvent.TIMER, activeServersTimerHandler);
      activeServersTimer.start();
      application.trace("<" + this + " ServerManager startRefreshingServers> the timer of the refreshing is started.", 1);
      refreshServers();
    }
    /**
     * Fills in the servers this application is built with. The framework knows no address
     * of any server at all, so it adds none: an application extending this class overrides
     * this one, calls the super and then adds the servers of its own with the addServer
     * above, and it sets the uri of the api answering the active ones as well.
     */
    protected function initializeServers():void
    {
      application.trace("<" + this + " ServerManager initializeServers> called.", 1);
      application.trace("<" + this + " ServerManager initializeServers> the extenders of this class add the servers of their own here.", 0);
    }
    /**
     * Handles the events of the request asking the addresses of the active servers: the
     * answer of it arrives with the complete event of that one-shot loader and it is
     * handed over to the storing below. Every other event of it tells that the request is
     * on its way, and there is nothing to do with those.
     * @param e the event of that loader
     */
    protected function activeServersStatusHandler(e:Event):void
    {
      application.trace("<" + this + " ServerManager activeServersStatusHandler> called.", 1);
      application.trace("<" + this + " ServerManager activeServersStatusHandler> e: " + e, 0);
      if (e == null || e.type != Event.COMPLETE)
      {
        return;
      }
      if (!(e.target is URLLoader))
      {
        application.trace("<" + this + " ServerManager activeServersStatusHandler> e.target is not a URLLoader object!", 6);
        return;
      }
      activeServersAnswer("" + URLLoader(e.target).data);
    }
    /**
     * Handles the failure of the request asking the addresses of the active servers: the
     * servers of this application are left exactly as they stand, and the timer of the
     * refreshing asks for those addresses again later on.
     * @param e the error event of that loader
     */
    protected function activeServersErrorHandler(e:Event):void
    {
      application.trace("<" + this + " ServerManager activeServersErrorHandler> called.", 1);
      application.trace("<" + this + " ServerManager activeServersErrorHandler> e: " + e, 0);
      application.trace("<" + this + " ServerManager activeServersErrorHandler> the addresses of the active servers cannot be asked at the moment, so the servers of this application are left alone.", 6);
    }
    /**
     * Takes the answer of the api of this application: the addresses of the servers
     * carrying it stand in one single line of it, separated by semicolons, so that line is
     * cut into the addresses here and the storing below is left with the list of them. An
     * answer that is empty or that never arrived at all is dropped: the servers stay as
     * they are instead of being thrown away on the word of a request that has failed.
     * @param answer the plain text answer of that api
     */
    protected function activeServersAnswer(answer:String):void
    {
      application.trace("<" + this + " ServerManager activeServersAnswer> called.", 1);
      application.trace("<" + this + " ServerManager activeServersAnswer> answer: " + answer, 0);
      const answerToRead:String = application.getUtils().trim(answer);
      if (answerToRead == "")
      {
        application.trace("<" + this + " ServerManager activeServersAnswer> the api has answered no address at all, so the servers of this application are left alone!", 6);
        return;
      }
      updateServers(answerToRead.split(ACTIVE_SERVERS_SEPARATOR));
    }
    /**
     * Stores the addresses of the active servers: a server that has just appeared is added
     * to this application and one that has disappeared is removed from it. The ones that
     * have appeared are added before the ones that have disappeared are removed, so this
     * application is never left with no server in between, and the ones listening are told
     * once, when all of it stands, instead of once for every server that has moved.
     * @param serverAddresses the addresses of the active servers, one by one
     */
    protected function updateServers(serverAddresses:Array):Boolean
    {
      application.trace("<" + this + " ServerManager updateServers> called.", 1);
      application.trace("<" + this + " ServerManager updateServers> serverAddresses: " + serverAddresses, 0);
      if (serverAddresses == null || serverAddresses.length == 0)
      {
        application.trace("<" + this + " ServerManager updateServers> there is no address to store, so the servers of this application are left alone!", 6);
        return false;
      }
      const activeServerKeys:Object = new Object();
      var serverAddress:String = "";
      var serverKey:String = "";
      var changed:Boolean = false;
      for (var i:int = 0; i < serverAddresses.length; i++)
      {
        serverAddress = application.getUtils().trim("" + serverAddresses[i]);
        serverKey = serverKeyOfAddress(serverAddress);
        if (serverKey == "")
        {
          application.trace("<" + this + " ServerManager updateServers> this address of a server holds no name of a machine: " + serverAddresses[i], 6);
          continue;
        }
        activeServerKeys[serverKey] = serverAddress;
        if (getServerAddress(serverKey) == serverAddress)
        {
          application.trace("<" + this + " ServerManager updateServers> the server " + serverKey + " stands here already.", 0);
          continue;
        }
        if (addServer(serverKey, serverAddress))
        {
          application.trace("<" + this + " ServerManager updateServers> the server " + serverKey + " has just appeared.", 1);
          changed = true;
        }
      }
      const storedServerKeys:Array = getServerKeys();
      for (var j:int = 0; j < storedServerKeys.length; j++)
      {
        if (activeServerKeys[storedServerKeys[j]] != undefined)
        {
          continue;
        }
        // the removing below picks another server in use when the one taken away was the
        // machine this application stood on, and it tells that with an event of its own
        if (removeServer(storedServerKeys[j]))
        {
          application.trace("<" + this + " ServerManager updateServers> the server " + storedServerKeys[j] + " has disappeared.", 1);
          changed = true;
        }
      }
      if (changed)
      {
        serversChanged();
      }
      return changed;
    }
    /**
     * Returns the name of the machine the given server address stands on: that is the part
     * of it standing before the domain. The servers of an application are known by that
     * name, so this is what an address answered by the api is looked up and stored by, and
     * an extender naming the machines of its own in another way overrides this one.
     * @param serverAddress the address of a server
     */
    protected function serverKeyOfAddress(serverAddress:String):String
    {
      application.trace("<" + this + " ServerManager serverKeyOfAddress> called.", 1);
      application.trace("<" + this + " ServerManager serverKeyOfAddress> serverAddress: " + serverAddress, 0);
      if (serverAddress == null)
      {
        application.trace("<" + this + " ServerManager serverKeyOfAddress> serverAddress is null!", 6);
        return "";
      }
      const domainAt:int = serverAddress.indexOf(ACTIVE_SERVERS_DOMAIN_DELIMITER);
      return domainAt == -1 ? serverAddress : serverAddress.substring(0, domainAt);
    }
    /**
     * Returns the name of one server of this application, picked at random, the empty
     * string when it knows no server at all.
     */
    protected function getRandomServerKey():String
    {
      application.trace("<" + this + " ServerManager getRandomServerKey> called.", 1);
      const serverKeys:Array = getServerKeys();
      if (serverKeys.length == 0)
      {
        application.trace("<" + this + " ServerManager getRandomServerKey> this application knows no server at all!", 6);
        return "";
      }
      return "" + serverKeys[application.getUtils().getRandomInt(0, serverKeys.length - 1)];
    }
    /**
     * Returns the name of one server of this application other than the given one, picked
     * at random: that is the machine a failed one is left for. The answer is the empty
     * string when this application has no other server at all.
     * @param serverKey the name of the machine that must not be answered
     */
    protected function getAnotherServerKey(serverKey:String):String
    {
      application.trace("<" + this + " ServerManager getAnotherServerKey> called.", 1);
      application.trace("<" + this + " ServerManager getAnotherServerKey> serverKey: " + serverKey, 0);
      const otherServerKeys:Array = new Array();
      const serverKeys:Array = getServerKeys();
      for (var i:int = 0; i < serverKeys.length; i++)
      {
        if (serverKeys[i] != serverKey)
        {
          otherServerKeys.push(serverKeys[i]);
        }
      }
      if (otherServerKeys.length == 0)
      {
        application.trace("<" + this + " ServerManager getAnotherServerKey> this application knows no server other than " + serverKey + "!", 6);
        return "";
      }
      return "" + otherServerKeys[application.getUtils().getRandomInt(0, otherServerKeys.length - 1)];
    }
    /**
     * Tells every manager of this application that its servers have changed: the list of
     * them or the machine in use alike. The ones listening take the servers of this class
     * as they stand at that moment, so one event tells them everything that has happened.
     */
    protected function serversChanged():void
    {
      application.trace("<" + this + " ServerManager serversChanged> called.", 1);
      if (eventServersChanged == null)
      {
        application.trace("<" + this + " ServerManager serversChanged> the event of the changing is not there!", 6);
        return;
      }
      application.getBaseEventDispatcher().dispatchEvent(eventServersChanged);
    }
    /**
     * Asks the addresses of the active servers again, every time the timer of the
     * refreshing fires.
     * @param e the timer event
     */
    private function activeServersTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " ServerManager activeServersTimerHandler> called.", 1);
      application.trace("<" + this + " ServerManager activeServersTimerHandler> e: " + e, 0);
      refreshServers();
    }
    /**
     * Stops the refreshing of the servers and releases every reference held by this
     * manager.
     */
    public function destroy():void
    {
      application.trace("<" + this + " ServerManager destroy> called.", 1);
      if (activeServersTimer != null)
      {
        activeServersTimer.removeEventListener(TimerEvent.TIMER, activeServersTimerHandler);
        activeServersTimer.stop();
      }
      application = null;
      servers = null;
      serverInUse = "";
      activeServersUri = "";
      activeServersTimer = null;
      eventServersChanged = null;
    }
  }
}
