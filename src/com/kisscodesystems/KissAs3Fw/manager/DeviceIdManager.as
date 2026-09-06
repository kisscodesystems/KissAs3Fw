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
 * DeviceIdManager.
 * The identifier of the device this application is running on: one value that is created
 * once and that stands from then on, every start of the application answering the same.
 *
 * MAIN FEATURES:
 * - the identifier of the application, the one of the PropertiesConfig, is a new one in
 *   every instance of it: this one is the opposite of that, it is the value telling that
 *   two starts of the application have happened on one and the same device
 * - it is asked for with the getDeviceId below, and the very first of those calls is the
 *   one creating it: an application never asking for it writes nothing onto the device
 * - it is kept in two places, in a shared object and in the encrypted local store, and
 *   whichever of the two is found answers it: the one that is missing is written again
 *   from the other, so the identifier survives the loss of either of them
 * - both of those places are inside the private storage of the application: neither the
 *   files application of an android device nor the one of an iphone shows anything of
 *   them to the one holding that device
 * - the value written is enciphered by the Crypto of the framework with the secret of the
 *   application, and it is signed as well, so a payload that has been rewritten by anyone
 *   is thrown away instead of being answered as an identifier
 * - THIS IS NOT A VALUE THAT CANNOT BE LOST: the mobile operating systems wipe the
 *   storage of an application when it is uninstalled and they may wipe it while it is
 *   installed as well, and the secret enciphering it lives inside the application, so
 *   this identifier tells that a device is the same one, it never proves it
 * - the encrypted local store is a service of the air runtime, so this manager is one of
 *   the classes of the framework that ask for that runtime and not for the player
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.util.Crypto;
  import flash.data.EncryptedLocalStore;
  import flash.net.SharedObject;
  import flash.net.SharedObjectFlushStatus;
  import flash.system.System;
  import flash.utils.ByteArray;
  public class DeviceIdManager
  {
    // the number of the random bytes one identifier is built of, and the number of the
    // characters those bytes are written with: every identifier is a hexadecimal string
    private const DEVICE_ID_BYTES:int = 16;
    private const DEVICE_ID_CHARACTERS:int = 32;
    // the version of the payload written onto the device, the first byte of it: a payload
    // written by another version of this manager is not read at all, it is written again
    private const PAYLOAD_VERSION:int = 1;
    // the name of the value inside the shared object
    private const SHARED_OBJECT_VALUE_NAME:String = "deviceId";
    protected var application:Application = null;
    // the enciphering of the payload: this manager brings its own one, so the framework
    // carries the cryptography where it is used and nowhere else
    protected var crypto:Crypto = null;
    // the name the payload is kept under and the secret it is enciphered with, both of
    // them coming from the properties of the application, which never change
    protected var storeName:String = "";
    protected var secret:String = "";
    // the identifier of this device, the empty string as long as nobody has asked for it
    protected var deviceId:String = "";
    // whether the identifier answered has been created in this very run of the
    // application: it tells the application that it stands on this device the first time
    protected var newDeviceId:Boolean = false;
    /**
     * Constructs the manager of the identifier of the device, exiting if no application
     * reference is given. Nothing is read from the device and nothing is written onto it
     * here: the identifier is created and kept the first time it is asked for, so an
     * application that never asks leaves that device alone.
     * @param applicationRef the application reference used for logging and services
     */
    public function DeviceIdManager(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " DeviceIdManager> called.", 1);
      application.trace("<" + this + " DeviceIdManager> applicationRef: " + applicationRef, 0);
      crypto = new Crypto(application);
      storeName = application.getPropertiesConfig().getDeviceIdStoreName();
      secret = application.getPropertiesConfig().getDeviceIdSecret();
      application.trace("<" + this + " DeviceIdManager> storeName: " + storeName, 0);
      application.trace("<" + this + " DeviceIdManager> constructed.", 1);
    }
    /**
     * Returns the identifier of this device, creating and keeping it if it is not there
     * yet. Every call after the first one answers the very same value, and so does every
     * later start of this application on this device.
     * @return the identifier of the device, the empty string when it cannot be created
     */
    public function getDeviceId():String
    {
      application.trace("<" + this + " DeviceIdManager getDeviceId> called.", 1);
      if (deviceId == "")
      {
        loadOrCreateDeviceId();
      }
      application.trace("<" + this + " DeviceIdManager getDeviceId> deviceId: " + deviceId, 0);
      return deviceId;
    }
    /**
     * Tells whether the identifier answered by the getter above has been created in this
     * run: true when this application has found nothing of itself on this device, so it
     * is standing here the first time, or the first time after a wipe of that storage.
     */
    public function isNewDeviceId():Boolean
    {
      return newDeviceId;
    }
    /**
     * Forgets the identifier of this device: it is taken out of both of the places it is
     * kept in and out of this manager as well, so the next getDeviceId creates a new one.
     * This is the call of an application handing the ones using it a way to stop being
     * the very same device for it.
     */
    public function forgetDeviceId():void
    {
      application.trace("<" + this + " DeviceIdManager forgetDeviceId> called.", 1);
      removeFromEncryptedLocalStore();
      removeFromSharedObject();
      deviceId = "";
      newDeviceId = false;
    }
    /**
     * Reads the identifier of this device from the two places it is kept in, and creates
     * it when neither of them holds one. The place that has answered nothing is written
     * again with the identifier that stands, so the two of them heal each other: losing
     * one of the two costs nothing as long as the other one is there.
     */
    protected function loadOrCreateDeviceId():void
    {
      application.trace("<" + this + " DeviceIdManager loadOrCreateDeviceId> called.", 1);
      const idOfEncryptedLocalStore:String = readFromEncryptedLocalStore();
      const idOfSharedObject:String = readFromSharedObject();
      newDeviceId = false;
      if (idOfEncryptedLocalStore != "")
      {
        deviceId = idOfEncryptedLocalStore;
      }
      else if (idOfSharedObject != "")
      {
        deviceId = idOfSharedObject;
      }
      else
      {
        deviceId = generateDeviceId();
        newDeviceId = true;
        application.trace("<" + this + " DeviceIdManager loadOrCreateDeviceId> this application has not stood on this device yet, so the identifier of it is a new one.", 1);
      }
      if (idOfEncryptedLocalStore != deviceId)
      {
        writeToEncryptedLocalStore(deviceId);
      }
      if (idOfSharedObject != deviceId)
      {
        writeToSharedObject(deviceId);
      }
    }
    /**
     * Returns the identifier kept in the encrypted local store of the runtime, the empty
     * string when there is none or when the payload found there cannot be read.
     */
    protected function readFromEncryptedLocalStore():String
    {
      application.trace("<" + this + " DeviceIdManager readFromEncryptedLocalStore> called.", 1);
      var payload:ByteArray = null;
      try
      {
        if (EncryptedLocalStore.isSupported)
        {
          payload = EncryptedLocalStore.getItem(storeName);
        }
        else
        {
          application.trace("<" + this + " DeviceIdManager readFromEncryptedLocalStore> the encrypted local store is not supported here!", 6);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager readFromEncryptedLocalStore> the encrypted local store has thrown an error: " + e, 7);
      }
      return decodeDeviceId(payload);
    }
    /**
     * Writes the given identifier into the encrypted local store of the runtime.
     * @param id the identifier of this device
     */
    protected function writeToEncryptedLocalStore(id:String):void
    {
      application.trace("<" + this + " DeviceIdManager writeToEncryptedLocalStore> called.", 1);
      const payload:ByteArray = encodeDeviceId(id);
      try
      {
        if (EncryptedLocalStore.isSupported)
        {
          // the payload is not bound to the machine it is written on, because a bound one
          // is lost every time this application is updated on that machine
          EncryptedLocalStore.setItem(storeName, payload, false);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager writeToEncryptedLocalStore> the encrypted local store has thrown an error: " + e, 7);
      }
      payload.clear();
    }
    /**
     * Takes the identifier out of the encrypted local store of the runtime.
     */
    protected function removeFromEncryptedLocalStore():void
    {
      application.trace("<" + this + " DeviceIdManager removeFromEncryptedLocalStore> called.", 1);
      try
      {
        if (EncryptedLocalStore.isSupported)
        {
          EncryptedLocalStore.removeItem(storeName);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager removeFromEncryptedLocalStore> the encrypted local store has thrown an error: " + e, 7);
      }
    }
    /**
     * Returns the identifier kept in the shared object of this application, the empty
     * string when there is none or when the payload found there cannot be read.
     */
    protected function readFromSharedObject():String
    {
      application.trace("<" + this + " DeviceIdManager readFromSharedObject> called.", 1);
      var payload:ByteArray = null;
      const sharedObject:SharedObject = openSharedObject();
      if (sharedObject != null)
      {
        payload = sharedObject.data[SHARED_OBJECT_VALUE_NAME] as ByteArray;
        sharedObject.close();
      }
      return decodeDeviceId(payload);
    }
    /**
     * Writes the given identifier into the shared object of this application.
     * @param id the identifier of this device
     */
    protected function writeToSharedObject(id:String):void
    {
      application.trace("<" + this + " DeviceIdManager writeToSharedObject> called.", 1);
      const sharedObject:SharedObject = openSharedObject();
      if (sharedObject == null)
      {
        return;
      }
      const payload:ByteArray = encodeDeviceId(id);
      sharedObject.data[SHARED_OBJECT_VALUE_NAME] = payload;
      try
      {
        const status:String = sharedObject.flush();
        if (status != SharedObjectFlushStatus.FLUSHED)
        {
          application.trace("<" + this + " DeviceIdManager writeToSharedObject> the shared object has not been written yet, its status is: " + status, 6);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager writeToSharedObject> the shared object has thrown an error: " + e, 7);
      }
      sharedObject.close();
    }
    /**
     * Takes the identifier out of the shared object of this application, deleting that
     * shared object itself: it holds this one single value.
     */
    protected function removeFromSharedObject():void
    {
      application.trace("<" + this + " DeviceIdManager removeFromSharedObject> called.", 1);
      const sharedObject:SharedObject = openSharedObject();
      if (sharedObject == null)
      {
        return;
      }
      try
      {
        sharedObject.clear();
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager removeFromSharedObject> the shared object has thrown an error: " + e, 7);
      }
      sharedObject.close();
    }
    /**
     * Returns the shared object the identifier is kept in, null when the runtime hands
     * out none of it: a device that is out of space or that keeps the local storage of
     * this application locked answers nothing here.
     */
    protected function openSharedObject():SharedObject
    {
      application.trace("<" + this + " DeviceIdManager openSharedObject> called.", 1);
      var sharedObject:SharedObject = null;
      try
      {
        sharedObject = SharedObject.getLocal(storeName);
      }
      catch (e:Error)
      {
        application.trace("<" + this + " DeviceIdManager openSharedObject> the shared object has thrown an error: " + e, 7);
      }
      if (sharedObject == null)
      {
        application.trace("<" + this + " DeviceIdManager openSharedObject> the shared object of this application is not there!", 6);
      }
      return sharedObject;
    }
    /**
     * Returns the payload the given identifier is kept as: the version of it and the
     * enciphered, signed bytes of that identifier.
     * @param id the identifier of this device
     * @return the bytes to be written onto the device
     */
    protected function encodeDeviceId(id:String):ByteArray
    {
      application.trace("<" + this + " DeviceIdManager encodeDeviceId> called.", 1);
      const payload:ByteArray = new ByteArray();
      payload.writeByte(PAYLOAD_VERSION);
      const plain:ByteArray = crypto.stringToBytes(id);
      const enciphered:ByteArray = crypto.encrypt(plain, secret);
      payload.writeBytes(enciphered, 0, enciphered.length);
      plain.clear();
      enciphered.clear();
      payload.position = 0;
      return payload;
    }
    /**
     * Returns the identifier held by the given payload. The answer is the empty string
     * when there is no payload, when it has been written by another version of this
     * manager, when it fails its signature and when the identifier inside it is not one
     * of this manager: a value that cannot be trusted is thrown away and written again.
     * @param payload the bytes read from the device
     * @return the identifier of this device, the empty string when there is none
     */
    protected function decodeDeviceId(payload:ByteArray):String
    {
      application.trace("<" + this + " DeviceIdManager decodeDeviceId> called.", 1);
      if (payload == null || payload.length == 0)
      {
        return "";
      }
      payload.position = 0;
      const version:int = payload.readUnsignedByte();
      if (version != PAYLOAD_VERSION)
      {
        application.trace("<" + this + " DeviceIdManager decodeDeviceId> the payload has been written by another version of this manager: " + version, 6);
        return "";
      }
      const enciphered:ByteArray = new ByteArray();
      enciphered.writeBytes(payload, payload.position, payload.length - payload.position);
      const plain:ByteArray = crypto.decrypt(enciphered, secret);
      enciphered.clear();
      if (plain == null)
      {
        application.trace("<" + this + " DeviceIdManager decodeDeviceId> the payload cannot be deciphered, so it is thrown away!", 6);
        return "";
      }
      const id:String = crypto.bytesToString(plain);
      plain.clear();
      if (!isValidDeviceId(id))
      {
        application.trace("<" + this + " DeviceIdManager decodeDeviceId> the payload holds something else than an identifier, so it is thrown away!", 6);
        return "";
      }
      return id;
    }
    /**
     * Returns a new identifier of a device: the random bytes of the runtime, written as a
     * hexadecimal string.
     */
    protected function generateDeviceId():String
    {
      application.trace("<" + this + " DeviceIdManager generateDeviceId> called.", 1);
      const bytes:ByteArray = crypto.randomBytes(DEVICE_ID_BYTES);
      const id:String = crypto.bytesToHex(bytes);
      bytes.clear();
      return id;
    }
    /**
     * Tells whether the given string is an identifier this manager has created: the right
     * number of hexadecimal characters and nothing else.
     * @param id the string to be looked at
     * @return true when that string is an identifier of this manager
     */
    protected function isValidDeviceId(id:String):Boolean
    {
      if (id == null || id.length != DEVICE_ID_CHARACTERS)
      {
        return false;
      }
      const bytes:ByteArray = crypto.hexToBytes(id);
      const valid:Boolean = bytes.length == DEVICE_ID_BYTES;
      bytes.clear();
      return valid;
    }
    /**
     * Frees up everything and destroys this object. The identifier itself stays on the
     * device: it is the very value that outlives every run of this application.
     */
    public function destroy():void
    {
      application.trace("<" + this + " DeviceIdManager destroy> called.", 1);
      if (crypto != null)
      {
        crypto.destroy();
      }
      crypto = null;
      storeName = null;
      secret = null;
      deviceId = null;
      newDeviceId = false;
      application = null;
    }
  }
}
