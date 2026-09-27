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
 * StateManager.
 * The keeper of the state of the application on the device: one object of values that
 * is written when the application is sent to the background and read on its next start.
 *
 * MAIN FEATURES:
 * - a mobile operating system kills a backgrounded application whenever it needs the
 *   memory, and the application learns nothing of it: the one using it only finds it
 *   started from the very beginning. The state written here is the answer to that, the
 *   application goes on from the point it has been left at
 * - the state is a plain object of simple values (strings, numbers, booleans and arrays
 *   of those), and it is written as it is into the shared object of this application
 * - it is the Application that decides when the state is written and read, see its
 *   saveState and restoreState: this manager only keeps it
 * - every state carries the version of this manager, and a state written by another
 *   version is thrown away instead of being handed over
 * - the shared object is inside the private storage of the application, and an
 *   uninstallation wipes it: this is a state to go on with, not a value that cannot be lost
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.net.SharedObject;
  import flash.net.SharedObjectFlushStatus;
  import flash.system.System;
  public class StateManager
  {
    // the version of the state written onto the device: a state of another version of
    // this manager is not read at all
    private const STATE_VERSION:int = 1;
    // the names of the values inside the shared object
    private const SHARED_OBJECT_VERSION_NAME:String = "stateVersion";
    private const SHARED_OBJECT_STATE_NAME:String = "state";
    protected var application:Application = null;
    // the name the state is kept under, coming from the properties of the application
    protected var storeName:String = "";
    /**
     * Constructs the manager of the state of the application, exiting if no application
     * reference is given. Nothing is read from the device here.
     * @param applicationRef the application reference used for logging and services
     */
    public function StateManager(applicationRef:Application):void
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
      application.trace("<" + this + " StateManager> called.", 1);
      application.trace("<" + this + " StateManager> applicationRef: " + applicationRef, 0);
      storeName = application.getPropertiesConfig().getStateStoreName();
      application.trace("<" + this + " StateManager> storeName: " + storeName, 0);
      application.trace("<" + this + " StateManager> constructed.", 1);
    }
    /**
     * Writes the given state onto the device, in the place of the one kept there.
     * @param state the object of the values to be kept
     * @return true when the state has been written
     */
    public function writeState(state:Object):Boolean
    {
      application.trace("<" + this + " StateManager writeState> called.", 1);
      application.trace("<" + this + " StateManager writeState> state: " + state, 0);
      if (state == null)
      {
        application.trace("<" + this + " StateManager writeState> there is no state to be written!", 6);
        return false;
      }
      const sharedObject:SharedObject = openSharedObject();
      if (sharedObject == null)
      {
        return false;
      }
      var written:Boolean = false;
      try
      {
        sharedObject.data[SHARED_OBJECT_VERSION_NAME] = STATE_VERSION;
        sharedObject.data[SHARED_OBJECT_STATE_NAME] = state;
        const status:String = sharedObject.flush();
        written = status == SharedObjectFlushStatus.FLUSHED;
        if (!written)
        {
          application.trace("<" + this + " StateManager writeState> the shared object has not been written yet, its status is: " + status, 6);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " StateManager writeState> the shared object has thrown an error: " + e, 7);
      }
      sharedObject.close();
      return written;
    }
    /**
     * Returns the state kept on the device, null when there is none or when it has been
     * written by another version of this manager.
     * @return the object of the values kept, or null
     */
    public function readState():Object
    {
      application.trace("<" + this + " StateManager readState> called.", 1);
      const sharedObject:SharedObject = openSharedObject();
      if (sharedObject == null)
      {
        return null;
      }
      var state:Object = null;
      try
      {
        if (sharedObject.data[SHARED_OBJECT_VERSION_NAME] == STATE_VERSION)
        {
          state = sharedObject.data[SHARED_OBJECT_STATE_NAME];
        }
        else if (sharedObject.data[SHARED_OBJECT_VERSION_NAME] != undefined)
        {
          application.trace("<" + this + " StateManager readState> the state has been written by another version of this manager: " + sharedObject.data[SHARED_OBJECT_VERSION_NAME], 6);
        }
      }
      catch (e:Error)
      {
        application.trace("<" + this + " StateManager readState> the shared object has thrown an error: " + e, 7);
      }
      sharedObject.close();
      application.trace("<" + this + " StateManager readState> state: " + state, 0);
      return state;
    }
    /**
     * Takes the state out of the device, so the next start of the application finds none.
     */
    public function clearState():void
    {
      application.trace("<" + this + " StateManager clearState> called.", 1);
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
        application.trace("<" + this + " StateManager clearState> the shared object has thrown an error: " + e, 7);
      }
      sharedObject.close();
    }
    /**
     * Returns the shared object the state is kept in, null when the runtime hands out
     * none of it: a device that is out of space or that keeps the local storage of this
     * application locked answers nothing here.
     */
    protected function openSharedObject():SharedObject
    {
      application.trace("<" + this + " StateManager openSharedObject> called.", 1);
      var sharedObject:SharedObject = null;
      try
      {
        sharedObject = SharedObject.getLocal(storeName);
      }
      catch (e:Error)
      {
        application.trace("<" + this + " StateManager openSharedObject> the shared object has thrown an error: " + e, 7);
      }
      if (sharedObject == null)
      {
        application.trace("<" + this + " StateManager openSharedObject> the shared object of this application is not there!", 6);
      }
      return sharedObject;
    }
    /**
     * Frees up everything and destroys this object. The state itself stays on the device:
     * it is the very value that outlives every run of this application.
     */
    public function destroy():void
    {
      application.trace("<" + this + " StateManager destroy> called.", 1);
      application.trace("<" + this + " StateManager destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      application.trace("<" + this + " StateManager destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " StateManager destroy> 3: calling the super destroy.", 0);
      application.trace("<" + this + " StateManager destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      storeName = null;
      application = null;
    }
  }
}
