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
 * BaseRequestManager.
 * The base of every request manager of the framework: it stores the connections those
 * managers talk to the outside world on, the http ones of the UrlRequestManager and the
 * socket ones of the NetConnectionManager alike.
 *
 * MAIN FEATURES:
 * - the connections stand in groups: one group holds the servers of one and the same
 *   application, so that a request of it can be sent to any one of them
 * - one connection of every group is the default one, the one in use: the requests of
 *   that group are sent on it as long as it answers
 * - when it fails, the manager extending this class picks another connection of that
 *   very group with the getAnotherConnection below and it repeats the request on it: the
 *   one using the application never learns that the request has been sent twice
 * - that other connection becomes the default one of its group, so every further request
 *   goes to the server that has just answered
 * - this class carries no address of any server at all: the extenders of the framework
 *   build the groups of their own and they are the ones knowing where their servers
 *   stand
 * - the properties of a connection this class stores are:
 *   connectionObject [ "groupKey" ]      : String
 *   connectionObject [ "connectionKey" ] : String
 *   connectionObject [ "default" ]       : Boolean
 * - every further property of a connection belongs to the manager using it, and it is
 *   listed in the header comment lines of that manager
 * - one group of a manager can be the group of the servers of the application: the
 *   ServerManager is the one holding those servers and the one of them in use, and the
 *   synchronizeServers below gives that group over to them, connection by connection
 * - that manager listens to the one event of the ServerManager from then on, so a server
 *   that has just appeared is added to the group, one that has disappeared is removed
 *   from it and the default connection of it is the server the whole application is
 *   talking to at the moment
 * - a connection of that group failing does not pick another server on its own either: it
 *   reports the failure to the ServerManager with the anotherConnectionAfterFailure below,
 *   and every manager of the application moves to the server it picks, together
 * - the group of the servers is the setting of the extenders and it stands empty here, so
 *   a manager of the framework follows no server at all
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import flash.events.Event;
  import flash.system.System;
  public class BaseRequestManager
  {
    protected var application:Application = null;
    protected var connectionGroups:Object = null;
    // The key of the group holding the servers of this application: the connections of
    // that one group follow the ServerManager, and every other group of this manager is
    // left alone. It is the setting of the extenders and it stands empty here, so a
    // manager of the framework follows no server at all.
    protected var serverGroupKey:String = "";
    /**
     * Constructs the request manager and stores the application reference, exiting if none is given.
     * @param applicationRef the application reference used for logging and services
     */
    public function BaseRequestManager(applicationRef:Application):void
    {
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " BaseRequestManager> called.", 1);
      application.trace("<" + this + " BaseRequestManager> applicationRef: " + applicationRef, 0);
      connectionGroups = new Object();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_SERVERS_CHANGED()
        , serversChangedHandler);
      application.trace("<" + this + " BaseRequestManager> constructed.", 1);
    }
    /**
     * Returns the key of the default connection of the given group, the empty string when
     * that group holds no default connection at all. The one using this is the application
     * displaying which server of a group it talks to at the moment.
     * @param groupKey the key of the connection group
     */
    public function getDefaultConnectionKey(groupKey:String):String
    {
      application.trace("<" + this + " BaseRequestManager getDefaultConnectionKey> called.", 1);
      application.trace("<" + this + " BaseRequestManager getDefaultConnectionKey> groupKey: " + groupKey, 0);
      const connectionObject:Object = getDefaultConnection(groupKey);
      if (connectionObject == null)
      {
        application.trace("<" + this + " BaseRequestManager getDefaultConnectionKey> there is no default connection in this group!", 6);
        return "";
      }
      application.trace("<" + this + " BaseRequestManager getDefaultConnectionKey> connectionKey: " + connectionObject["connectionKey"], 0);
      return "" + connectionObject["connectionKey"];
    }
    /**
     * Initializes the missing default fields of a connection object. This class stores the
     * two keys of a connection and the flag of the default one, so it is that flag alone
     * that is prepared here: every manager extending this class overrides this one and
     * prepares the properties of its own afterwards.
     * @param connectionObject the connection object to prepare
     */
    protected function prepareConnection(connectionObject:Object):void
    {
      application.trace("<" + this + " BaseRequestManager prepareConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager prepareConnection> connectionObject: " + connectionObject, 0);
      if (connectionObject == null)
      {
        application.trace("<" + this + " BaseRequestManager prepareConnection> connectionObject is null!", 6);
        return;
      }
      if (connectionObject["default"] == undefined)
      {
        connectionObject["default"] = false;
        application.trace("<" + this + " BaseRequestManager prepareConnection> connectionObject [ \"default\" ] = " + connectionObject["default"], 0);
      }
      application.trace("<" + this + " BaseRequestManager prepareConnection> connectionObject is initialized.", 1);
    }
    /**
     * Adds a new empty connection group with the given key.
     * @param groupKey the key of the new connection group
     */
    protected function addNewConnectionGroup(groupKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> called.", 1);
      application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] != undefined)
      {
        application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> connectionGroup with key " + groupKey + " is existing!", 6);
        return null;
      }
      const groupObject:Object = new Object();
      connectionGroups[groupKey] = groupObject;
      application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> connection group is added.", 1);
      application.trace("<" + this + " BaseRequestManager addNewConnectionGroup> groupKey: " + groupKey, 0);
      return groupObject;
    }
    /**
     * Returns the connection group stored under the given key.
     * @param groupKey the key of the connection group
     */
    protected function getConnectionGroup(groupKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getConnectionGroup> called.", 1);
      application.trace("<" + this + " BaseRequestManager getConnectionGroup> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionGroup> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionGroup> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      application.trace("<" + this + " BaseRequestManager getConnectionGroup> group is: " + connectionGroups[groupKey], 0);
      application.trace("<" + this + " BaseRequestManager getConnectionGroup> group is from groupKey: " + groupKey, 0);
      return connectionGroups[groupKey];
    }
    /**
     * Removes the connection group and all of its connections.
     * @param groupKey the key of the connection group to remove
     */
    protected function removeConnectionGroup(groupKey:String):Boolean
    {
      application.trace("<" + this + " BaseRequestManager removeConnectionGroup> called.", 1);
      application.trace("<" + this + " BaseRequestManager removeConnectionGroup> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionGroup> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionGroup> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      var removedAllConnections:Boolean = true;
      for (var connectionKey:String in connectionGroups[groupKey])
      {
        if (!removeConnection(groupKey, connectionKey))
        {
          application.trace("<" + this + " BaseRequestManager removeConnectionGroup> with keys: " + groupKey + " - " + connectionKey + " unsuccessful removal!", 6);
          removedAllConnections = false;
          break;
        }
      }
      if (removedAllConnections)
      {
        connectionGroups[groupKey] = null;
        if (delete connectionGroups[groupKey])
        {
          application.trace("<" + this + " BaseRequestManager removeConnectionGroup> connection group is removed.", 1);
          application.trace("<" + this + " BaseRequestManager removeConnectionGroup> removed groupKey: " + groupKey, 0);
          return true;
        }
        else
        {
          application.trace("<" + this + " BaseRequestManager removeConnectionGroup> unable to delete connection group!", 6);
          return false;
        }
      }
      else
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionGroup> unable to remove connectionGroup with key " + groupKey + ": cannot remove all of its connections! ", 6);
        return false;
      }
    }
    /**
     * Adds a new connection to the given group. The group has to be added before this one
     * is called, and the connection it hands back carries the prepared properties of the
     * manager doing that call, without an address of any kind: that address is the setting
     * of the application and it is set on this connection afterwards.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the new connection
     */
    protected function addNewConnection(groupKey:String, connectionKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager addNewConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager addNewConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager addNewConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager addNewConnection> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager addNewConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      if (connectionGroups[groupKey][connectionKey] != undefined)
      {
        application.trace("<" + this + " BaseRequestManager addNewConnection> connection with keys " + groupKey + " - " + connectionKey + " is existing!", 6);
        return null;
      }
      const connectionObject:Object = new Object();
      connectionObject["groupKey"] = groupKey;
      connectionObject["connectionKey"] = connectionKey;
      connectionGroups[groupKey][connectionKey] = connectionObject;
      application.trace("<" + this + " BaseRequestManager addNewConnection> new connection is set.", 1);
      application.trace("<" + this + " BaseRequestManager addNewConnection> param from connectionObject groupKey: " + connectionObject["groupKey"], 0);
      application.trace("<" + this + " BaseRequestManager addNewConnection> param from connectionObject connectionKey: " + connectionObject["connectionKey"], 0);
      prepareConnection(connectionObject);
      return connectionObject;
    }
    /**
     * Returns the connection stored under the given group and connection keys.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     */
    protected function getConnection(groupKey:String, connectionKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager getConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getConnection> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnection> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return null;
      }
      application.trace("<" + this + " BaseRequestManager getConnection> connection is: " + connectionGroups[groupKey][connectionKey], 1);
      application.trace("<" + this + " BaseRequestManager getConnection> connection is from groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnection> connection is from connectionKey: " + connectionKey, 0);
      return connectionGroups[groupKey][connectionKey];
    }
    /**
     * Returns the number of the connections standing in the given group: that is the number
     * of the servers a request of that group can be sent to.
     * @param groupKey the key of the connection group
     */
    protected function getConnectionCount(groupKey:String):int
    {
      application.trace("<" + this + " BaseRequestManager getConnectionCount> called.", 1);
      application.trace("<" + this + " BaseRequestManager getConnectionCount> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionCount> connectionGroups is null!", 6);
        return 0;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionCount> connectionGroup with key " + groupKey + " is not existing!", 6);
        return 0;
      }
      var connectionCount:int = 0;
      for (var currentConnectionKey:String in connectionGroups[groupKey])
      {
        connectionCount++;
      }
      application.trace("<" + this + " BaseRequestManager getConnectionCount> connectionCount: " + connectionCount, 0);
      return connectionCount;
    }
    /**
     * Returns a randomly chosen connection from the given group.
     * @param groupKey the key of the connection group
     */
    protected function getRandomConnection(groupKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getRandomConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager getRandomConnection> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getRandomConnection> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getRandomConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      const connectionKeysArray:Array = new Array();
      for (var currentConnectionKey:String in connectionGroups[groupKey])
      {
        connectionKeysArray.push(currentConnectionKey);
      }
      if (connectionKeysArray.length == 0)
      {
        application.trace("<" + this + " BaseRequestManager getRandomConnection> connectionGroup with key " + groupKey + " is empty!", 6);
        return null;
      }
      const randomConnectionKey:String = connectionKeysArray[application.getUtils().getRandomInt(0, connectionKeysArray.length - 1)];
      if (connectionGroups[groupKey][randomConnectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getRandomConnection> connection with groupKey " + groupKey + " and random connectionKey " + randomConnectionKey + " is empty!", 6);
        return null;
      }
      application.trace("<" + this + " BaseRequestManager getRandomConnection> random connection will be used: " + connectionGroups[groupKey][randomConnectionKey], 1);
      application.trace("<" + this + " BaseRequestManager getRandomConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getRandomConnection> randomConnectionKey: " + randomConnectionKey, 0);
      return connectionGroups[groupKey][randomConnectionKey];
    }
    /**
     * Returns a randomly chosen connection of the given group other than the given one:
     * the server the manager extending this class repeats an unsuccessful request on. The
     * answer is null when that group holds no other connection at all, and then there is
     * nowhere left to repeat that request.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection that must not be chosen
     */
    protected function getAnotherConnection(groupKey:String, connectionKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getAnotherConnection> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getAnotherConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      const otherConnectionKeysArray:Array = new Array();
      for (var currentConnectionKey:String in connectionGroups[groupKey])
      {
        if (currentConnectionKey != connectionKey)
        {
          otherConnectionKeysArray.push(currentConnectionKey);
        }
      }
      if (otherConnectionKeysArray.length == 0)
      {
        application.trace("<" + this + " BaseRequestManager getAnotherConnection> connectionGroup with key " + groupKey + " holds no other connection than " + connectionKey + "!", 6);
        return null;
      }
      const anotherConnectionKey:String = otherConnectionKeysArray[application.getUtils().getRandomInt(0, otherConnectionKeysArray.length - 1)];
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> another connection will be used: " + connectionGroups[groupKey][anotherConnectionKey], 1);
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getAnotherConnection> anotherConnectionKey: " + anotherConnectionKey, 0);
      return connectionGroups[groupKey][anotherConnectionKey];
    }
    /**
     * Returns the default connection of the given group.
     * @param groupKey the key of the connection group
     */
    protected function getDefaultConnection(groupKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getDefaultConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager getDefaultConnection> groupKey: " + groupKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getDefaultConnection> cannot get default connection: connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getDefaultConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      for (var currentConnectionKey:String in connectionGroups[groupKey])
      {
        if (connectionGroups[groupKey][currentConnectionKey]["default"])
        {
          application.trace("<" + this + " BaseRequestManager getDefaultConnection> default connection is found.", 1);
          application.trace("<" + this + " BaseRequestManager getDefaultConnection> groupKey: " + groupKey, 0);
          application.trace("<" + this + " BaseRequestManager getDefaultConnection> connectionKey: " + currentConnectionKey, 0);
          return connectionGroups[groupKey][currentConnectionKey];
        }
      }
      application.trace("<" + this + " BaseRequestManager getDefaultConnection> default connection is not found!", 6);
      return null;
    }
    /**
     * Marks the given connection as the default one within its group.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection to set as default
     */
    protected function setDefaultConnection(groupKey:String, connectionKey:String):Boolean
    {
      application.trace("<" + this + " BaseRequestManager setDefaultConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager setDefaultConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager setDefaultConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager setDefaultConnection> cannot set default connection: connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager setDefaultConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager setDefaultConnection> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      for (var currentConnectionKey:String in connectionGroups[groupKey])
      {
        if (connectionKey == currentConnectionKey)
        {
          connectionGroups[groupKey][currentConnectionKey]["default"] = true;
          application.trace("<" + this + " BaseRequestManager setDefaultConnection> default connection is set.", 1);
          application.trace("<" + this + " BaseRequestManager setDefaultConnection> default connection is : " + groupKey + " - " + currentConnectionKey, 0);
        }
        else
        {
          connectionGroups[groupKey][currentConnectionKey]["default"] = false;
        }
      }
      return true;
    }
    /**
     * Returns the value of a parameter of the given connection.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     * @param paramKey the key of the parameter to read
     */
    protected function getConnectionParam(groupKey:String, connectionKey:String, paramKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager getConnectionParam> called.", 1);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> connectionKey: " + connectionKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> paramKey: " + paramKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionParam> connectionGroups is null!", 6);
        return null;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionParam> connectionGroup with key " + groupKey + " is not existing!", 6);
        return null;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager getConnectionParam> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return null;
      }
      const connectionObject:Object = connectionGroups[groupKey][connectionKey];
      application.trace("<" + this + " BaseRequestManager getConnectionParam> param is: " + connectionObject[paramKey], 1);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> param is from groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> param is from connectionKey: " + connectionKey, 0);
      application.trace("<" + this + " BaseRequestManager getConnectionParam> param is from paramKey: " + paramKey, 0);
      return connectionObject[paramKey];
    }
    /**
     * Sets the value of a parameter of the given connection.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     * @param paramKey the key of the parameter to set
     * @param paramObject the value to store for the parameter
     */
    protected function setConnectionParam(groupKey:String, connectionKey:String, paramKey:String, paramObject:Object):Boolean
    {
      application.trace("<" + this + " BaseRequestManager setConnectionParam> called.", 1);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> connectionKey: " + connectionKey, 0);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> paramKey: " + paramKey, 0);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> paramObject: " + paramObject, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager setConnectionParam> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager setConnectionParam> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager setConnectionParam> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      const connectionObject:Object = connectionGroups[groupKey][connectionKey];
      connectionObject[paramKey] = paramObject;
      application.trace("<" + this + " BaseRequestManager setConnectionParam> connection param is set: " + paramObject, 1);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> param is set to groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> param is set to connectionKey: " + connectionKey, 0);
      application.trace("<" + this + " BaseRequestManager setConnectionParam> param is set to paramKey: " + paramKey, 0);
      return true;
    }
    /**
     * Removes a parameter from the given connection.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection
     * @param paramKey the key of the parameter to remove
     */
    protected function removeConnectionParam(groupKey:String, connectionKey:String, paramKey:String):Boolean
    {
      application.trace("<" + this + " BaseRequestManager removeConnectionParam> called.", 1);
      application.trace("<" + this + " BaseRequestManager removeConnectionParam> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager removeConnectionParam> connectionKey: " + connectionKey, 0);
      application.trace("<" + this + " BaseRequestManager removeConnectionParam> paramKey: " + paramKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      connectionGroups[groupKey][connectionKey][paramKey] = null;
      if (delete connectionGroups[groupKey][connectionKey][paramKey])
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> connection param is removed.", 1);
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> removed groupKey: " + groupKey, 0);
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> removed connectionKey: " + connectionKey, 0);
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> removed paramKey: " + paramKey, 0);
        return true;
      }
      else
      {
        application.trace("<" + this + " BaseRequestManager removeConnectionParam> unable to delete connection param!", 6);
        return false;
      }
    }
    /**
     * Removes the given connection and reassigns the default if it was the default one.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection to remove
     */
    protected function removeConnection(groupKey:String, connectionKey:String):Boolean
    {
      application.trace("<" + this + " BaseRequestManager removeConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager removeConnection> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager removeConnection> connectionKey: " + connectionKey, 0);
      if (connectionGroups == null)
      {
        application.trace("<" + this + " BaseRequestManager removeConnection> connectionGroups is null!", 6);
        return false;
      }
      if (connectionGroups[groupKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager removeConnection> connectionGroup with key " + groupKey + " is not existing!", 6);
        return false;
      }
      if (connectionGroups[groupKey][connectionKey] == undefined)
      {
        application.trace("<" + this + " BaseRequestManager removeConnection> connection with keys " + groupKey + " - " + connectionKey + " is not existing!", 6);
        return false;
      }
      var thisWasDefault:Boolean = false;
      if (connectionGroups[groupKey][connectionKey]["default"])
      {
        thisWasDefault = true;
        application.trace("<" + this + " BaseRequestManager removeConnection> warning! this connection is the default connection! removing anyways.", 1);
      }
      connectionGroups[groupKey][connectionKey] = null;
      if (delete connectionGroups[groupKey][connectionKey])
      {
        application.trace("<" + this + " BaseRequestManager removeConnection> connection is removed.", 1);
        application.trace("<" + this + " BaseRequestManager removeConnection> removed groupKey: " + groupKey, 0);
        application.trace("<" + this + " BaseRequestManager removeConnection> removed connectionKey: " + connectionKey, 0);
        if (thisWasDefault)
        {
          // the last connection of the group has just been removed: a group standing empty
          // carries no default connection either, and that is no failure of this removal
          if (getConnectionCount(groupKey) == 0)
          {
            application.trace("<" + this + " BaseRequestManager removeConnection> the group holds no connection at all any more, so it has no default one either.", 1);
            return true;
          }
          const newDefaultConnection:Object = getRandomConnection(groupKey);
          if (newDefaultConnection == null)
          {
            application.trace("<" + this + " BaseRequestManager removeConnection> unable to set another default connection!", 6);
            return false;
          }
          else
          {
            return setDefaultConnection(groupKey, newDefaultConnection["connectionKey"]);
          }
        }
        else
        {
          return true;
        }
      }
      else
      {
        application.trace("<" + this + " BaseRequestManager removeConnection> unable to delete connection!", 6);
        return false;
      }
    }
    /**
     * Gives the group of the servers of this application over to the servers the
     * ServerManager holds at the moment: a server that has just appeared is added to that
     * group, one that has disappeared is removed from it and the machine in use becomes
     * the default connection, the one every request of this manager travels on. It is
     * called once when the extender has built that group and once every time the servers
     * of the application change, and it does the very same thing every time: the group
     * stands for the servers as they are, whatever has happened to them.
     * A ServerManager knowing no server at all changes nothing here: an application whose
     * api cannot be reached keeps the servers it was built with.
     */
    protected function synchronizeServers():Boolean
    {
      application.trace("<" + this + " BaseRequestManager synchronizeServers> called.", 1);
      if (serverGroupKey == "")
      {
        application.trace("<" + this + " BaseRequestManager synchronizeServers> this manager holds no group of the servers of the application.", 1);
        return false;
      }
      const serverManager:ServerManager = application.getServerManager();
      if (serverManager == null)
      {
        application.trace("<" + this + " BaseRequestManager synchronizeServers> there is no server manager to follow!", 6);
        return false;
      }
      const connectionGroup:Object = getConnectionGroup(serverGroupKey);
      if (connectionGroup == null)
      {
        application.trace("<" + this + " BaseRequestManager synchronizeServers> the group of the servers is not existing!", 6);
        return false;
      }
      const serverKeys:Array = serverManager.getServerKeys();
      if (serverKeys.length == 0)
      {
        application.trace("<" + this + " BaseRequestManager synchronizeServers> the server manager knows no server at all, so this group is left alone!", 6);
        return false;
      }
      // the servers that have just appeared are added first and the ones that have
      // disappeared are removed afterwards: this way the group never stands empty
      const activeConnectionKeys:Object = new Object();
      var serverKey:String = "";
      for (var i:int = 0; i < serverKeys.length; i++)
      {
        serverKey = "" + serverKeys[i];
        activeConnectionKeys[serverKey] = serverKey;
        if (getConnection(serverGroupKey, serverKey) != null)
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + serverKey + " stands in this group already.", 0);
          continue;
        }
        if (addServerConnection(serverKey, serverManager.getServerAddress(serverKey)))
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + serverKey + " has just appeared and the connection of it is added.", 1);
        }
        else
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + serverKey + " has just appeared but the connection of it cannot be added!", 6);
        }
      }
      const storedConnectionKeys:Array = new Array();
      for (var currentConnectionKey:String in connectionGroup)
      {
        storedConnectionKeys.push(currentConnectionKey);
      }
      for (var j:int = 0; j < storedConnectionKeys.length; j++)
      {
        if (activeConnectionKeys[storedConnectionKeys[j]] != undefined)
        {
          continue;
        }
        if (getConnectionCount(serverGroupKey) <= 1)
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + storedConnectionKeys[j] + " is the last one of this group, so it is kept instead of being removed!", 6);
          break;
        }
        if (removeConnection(serverGroupKey, storedConnectionKeys[j]))
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + storedConnectionKeys[j] + " has disappeared and the connection of it is removed.", 1);
        }
        else
        {
          application.trace("<" + this + " BaseRequestManager synchronizeServers> the server " + storedConnectionKeys[j] + " has disappeared but the connection of it cannot be removed!", 6);
        }
      }
      // the machine this application talks to is the default connection of this group: the
      // requests of every manager of it travel on the very same server this way
      const serverInUse:String = serverManager.getServerInUse();
      if (getConnection(serverGroupKey, serverInUse) == null)
      {
        application.trace("<" + this + " BaseRequestManager synchronizeServers> the server in use carries no connection of this group!", 6);
        return false;
      }
      return setDefaultConnection(serverGroupKey, serverInUse);
    }
    /**
     * Builds the connection of a server that has just appeared. This class knows no
     * address and no setting of any server at all, so it builds no connection either: the
     * extenders of the framework override this one and add that connection with the very
     * settings the servers they were built with carry.
     * @param serverKey the name of the machine that server stands on
     * @param serverAddress the address of that server
     */
    protected function addServerConnection(serverKey:String, serverAddress:String):Boolean
    {
      application.trace("<" + this + " BaseRequestManager addServerConnection> called.", 1);
      application.trace("<" + this + " BaseRequestManager addServerConnection> serverKey: " + serverKey, 0);
      application.trace("<" + this + " BaseRequestManager addServerConnection> serverAddress: " + serverAddress, 0);
      application.trace("<" + this + " BaseRequestManager addServerConnection> the extenders of the framework build the connection of that server here.", 0);
      return false;
    }
    /**
     * Returns the connection a request that has just failed is to be repeated on. The
     * servers of this application are handed out by the ServerManager, so the failure of
     * one of them is reported to it and it is the one picking the machine this whole
     * application talks to from now on: the managers of it move together instead of ending
     * up on two servers. That picking is told with an event, and the ones listening to it
     * have moved already by the time this answers, so the connection handed back here is
     * the default one of the group. Every other group of this manager is one this
     * application knows nothing about, and another connection of it is picked as it always
     * has been. The answer is null when there is nowhere left to turn to.
     * @param groupKey the key of the connection group
     * @param connectionKey the key of the connection that has just failed
     */
    protected function anotherConnectionAfterFailure(groupKey:String, connectionKey:String):Object
    {
      application.trace("<" + this + " BaseRequestManager anotherConnectionAfterFailure> called.", 1);
      application.trace("<" + this + " BaseRequestManager anotherConnectionAfterFailure> groupKey: " + groupKey, 0);
      application.trace("<" + this + " BaseRequestManager anotherConnectionAfterFailure> connectionKey: " + connectionKey, 0);
      if (groupKey != serverGroupKey)
      {
        return getAnotherConnection(groupKey, connectionKey);
      }
      const serverManager:ServerManager = application.getServerManager();
      if (serverManager == null)
      {
        application.trace("<" + this + " BaseRequestManager anotherConnectionAfterFailure> there is no server manager to report this failure to!", 6);
        return getAnotherConnection(groupKey, connectionKey);
      }
      if (!serverManager.serverFailed(connectionKey))
      {
        application.trace("<" + this + " BaseRequestManager anotherConnectionAfterFailure> the server manager keeps the server this application talks to.", 1);
        return null;
      }
      return getDefaultConnection(groupKey);
    }
    /**
     * Takes the servers of this application as they stand every time they change: the
     * list of them or the machine in use alike.
     * @param e the event of that change
     */
    protected function serversChangedHandler(e:Event):void
    {
      application.trace("<" + this + " BaseRequestManager serversChangedHandler> called.", 1);
      application.trace("<" + this + " BaseRequestManager serversChangedHandler> e: " + e, 0);
      synchronizeServers();
    }
    /**
     * Stops following the servers of this application and releases every reference held
     * by this request manager.
     */
    public function destroy():void
    {
      application.trace("<" + this + " BaseRequestManager destroy> called.", 1);
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_SERVERS_CHANGED()
        , serversChangedHandler);
      connectionGroups = null;
      application = null;
      serverGroupKey = "";
    }
  }
}
