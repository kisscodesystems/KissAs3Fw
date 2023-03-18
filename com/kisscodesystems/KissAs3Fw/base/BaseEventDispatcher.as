/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Dm
**
** DESCRIPTION:
** BaseEventDispatcher.
** This class exists for many reasons.
** The grabage collecting is suported by using this class instead of EventDispatcher.
**
** MAIN FEATURES:
** - it can store the subscribed objects, and if it is to be destroyed,
**   all of the subscribes will be removed first.
**   So, in the classes where you use this base event dispatcher,
**   it needs to be overwrite the destroy ( ) method with destroys
**   this base event dispatcher object. This does that all of the dependencies
**   will be destroyed and your actual object will be grabage collected safely.
**   (but, this is just one part of this, see the header of BaseSprite)
** - and, it applies weakReference = false.
** - automatic grabage collection call
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . EventDispatcher ;
  import flash . events . IEventDispatcher ;
  import flash . system . System ;
  public class BaseEventDispatcher extends EventDispatcher
  {
// This will be the array of the references of the registered events.
// We can loop on this when the destroy ( ) will be called.
    private var registeredEvents : Array ;
// This will be the ID of the object in which this base event dispatcher has been defined.
// Used for example in widgets.
    private var parentObject : Object = null ;
/*
** This is the constructor.
** We are going to create the array of registering here.
*/
    public function BaseEventDispatcher ( target : IEventDispatcher = null )
    {
      super ( target ) ;
      registeredEvents = new Array ( ) ;
    }
/*
** Overrides the addEventListener method for 2 reason:
** - 1: useWeakReference = false
** - 2: stores the registered events to able to destroy all of them from here if it is needed.
*/
    override public function addEventListener ( type : String , listener : Function , useCapture : Boolean = false , priority : int = 0 , useWeakReference : Boolean = true ) : void
    {
// Calling this method of the parent.
      super . addEventListener ( type , listener , useCapture , priority , useWeakReference ) ;
      if ( registeredEvents != null )
      {
// We can store now this event.
        registeredEvents . push ( [ type , listener ] ) ;
      }
    }
    override public function removeEventListener ( type : String , listener : Function , useCapture : Boolean = false ) : void
    {
      super . removeEventListener ( type , listener , useCapture ) ;
      if ( registeredEvents != null )
      {
        var found : Boolean = true ;
        while ( found )
        {
          found = false ;
          for ( var i : int = 0 ; i < registeredEvents . length ; i ++ )
          {
            if ( registeredEvents [ i ] [ 0 ] == type && registeredEvents [ i ] [ 1 ] == listener )
            {
              registeredEvents . splice ( i , 1 ) ;
              found = true ;
              break ;
            }
          }
        }
      }
    }
/*
** Getting the reference of the parent object.
*/
    public function getParentObject ( ) : Object
    {
      return parentObject ;
    }
/*
** Setting of the reference to the parent object.
*/
    public function setParentObject ( object : Object ) : void
    {
      parentObject = object ;
    }
/*
** Same as in BaseSprite or BaseTextField.
*/
    private function systemGc ( ) : void
    {
      for ( var i : int = 0 ; i < 10 ; i ++ )
      {
        System . gc ( ) ;
      }
    }
/*
** Removes all of the subscribed listeners.
** Its parameter means: need the grabage collector be called or not.
*/
    public function removeAllListeners ( toCallSystemGc : Boolean = true ) : void
    {
      if ( registeredEvents != null )
      {
// Looping on the array of registered events and removing that subscription.
        while ( registeredEvents . length > 0 )
        {
          removeEventListener ( registeredEvents [ 0 ] [ 0 ] , registeredEvents [ 0 ] [ 1 ] ) ;
        }
// If the above is done then we can purge all of the elements of this array.
        registeredEvents . splice ( 0 ) ;
      }
// The grabace collector can work now if it is requested.
      if ( toCallSystemGc )
      {
        systemGc ( ) ;
      }
    }
/*
** Destroys everything within this class so it is needed to be called from outside.
*/
    public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      removeAllListeners ( false ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// Calling the grabage collection to work.
      systemGc ( ) ;
// 3: calling the super destroy.
// 4: every reference and value should be resetted to null, 0 or false.
      registeredEvents = null ;
      parentObject = null ;
    }
  }
}