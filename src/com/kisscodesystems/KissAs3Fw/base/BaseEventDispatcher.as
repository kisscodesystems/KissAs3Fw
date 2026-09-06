package com.kisscodesystems.KissAs3Fw.base
{
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.system.System;
  public class BaseEventDispatcher extends EventDispatcher
  {
    private var registeredEvents:Array;
    private var parentObject:Object = null;
    /**
     * Constructs the base event dispatcher and initializes the registered events store.
     * @param target the optional event target passed to the base EventDispatcher
     */
    public function BaseEventDispatcher(target:IEventDispatcher = null)
    {
      super(target);
      registeredEvents = new Array();
    }
    /**
     * Adds an event listener and records it so it can be removed automatically later.
     * @param type the event type
     * @param listener the listener function
     * @param useCapture whether the listener works in the capture phase
     * @param priority the listener priority
     * @param useWeakReference whether the listener is held with a weak reference
     */
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
    {
      super.addEventListener(type, listener, useCapture, priority, useWeakReference);
      registeredEvents.push([type, listener]);
    }
    /**
     * Removes an event listener and drops every matching entry from the registered events store.
     * @param type the event type
     * @param listener the listener function
     * @param useCapture whether the listener worked in the capture phase
     */
    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
      super.removeEventListener(type, listener, useCapture);
      var found:Boolean = true;
      while (found)
      {
        found = false;
        for (var i:int = 0; i < registeredEvents.length; i++)
        {
          if (registeredEvents[i][0] == type && registeredEvents[i][1] == listener)
          {
            registeredEvents.splice(i, 1);
            found = true;
            break;
          }
        }
      }
    }
    /**
     * Returns the parent object this dispatcher belongs to.
     */
    public function getParentObject():Object
    {
      return parentObject;
    }
    /**
     * Sets the parent object this dispatcher belongs to.
     * @param object the parent object
     */
    public function setParentObject(object:Object):void
    {
      parentObject = object;
    }
    /**
     * Removes every registered listener and optionally forces a garbage collection.
     * @param toCallSystemGc whether to force garbage collection after removing the listeners
     */
    public function removeAllListeners(toCallSystemGc:Boolean = true):void
    {
      while (registeredEvents.length > 0)
      {
        removeEventListener(registeredEvents[0][0], registeredEvents[0][1]);
      }
      registeredEvents.splice(0);
      if (toCallSystemGc)
      {
        systemGc();
      }
    }
    /**
     * Forces the Flash Player garbage collector to run several times.
     */
    private function systemGc():void
    {
      for (var i:int = 0; i < 10; i++)
      {
        System.gc();
      }
    }
    /**
     * Removes every listener, forces garbage collection and resets every reference.
     */
    public function destroy():void
    {
      removeAllListeners(false);
      systemGc();
      registeredEvents.splice(0);
      registeredEvents = null;
      parentObject = null;
    }
  }
}
