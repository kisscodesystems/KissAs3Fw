/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3FwDemos
**
** DESCRIPTION:
** BaseSprite.
** The base sprite class. (Very similar at logic to the BaseTextField.)
** Every displayable object on the applications using this framework
** should be extended by this class or by an extending class of this.
**
** This base class has the main properties as:
** - x coordinate (stored as cx (coordinate x))
** - y coordinate (stored as cy (coordinate y))
** - width (stored as sw (size width))
** - height (stored as sh (size height))
**
** What if these properties have been changed.
**
** 1: other classes.
** This class has the baseEventDispatcher.
** This will be the object to allow other objects to be registered into.
** If the coordinates or sizes above will be changed then other objects
** can be informed aboout the changing of this main properties using base event dispatcher.
** (If these register to the eventCoordinatesChanged or eventSizesChanged events.)
**
** 2: classes extending this.
** These classes has not to be registered into this baseEventDispatcher
** because the changing of the size or coordinate properties mean the calling
** of the doCoordinateChanged or doSizeChanged. These two method can be
** overwritten in the extending classes.
**
** This has to contain the overridable destroy method. This is used for destroying
** everything we created in the current extending class of this base class.
** The initialize function: addedToStage and the removedFromStage have to be
** here too. These also have to be overwritten in extending classes.
**
** This also has to contain the grabage collector callings in a method: systemGc.
**
** MAIN FEATURES:
** - coordinates and sizes are stored separately!
** - events will be dispatched when the sizes or the coordinates are changed.
** - the stage width and height can be watched
**   and the sizes can be recalculated according to the stage.
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . display . DisplayObject ;
  import flash . display . Sprite ;
  import flash . events . Event ;
  import flash . system . System ;
  public class BaseSprite extends Sprite
  {
// Reference to the Application object.
    protected var application : Application = null ;
// These are the base properties.
    private var cx : int = 0 ;
    private var cy : int = 0 ;
    private var sw : int = 0 ;
    private var sh : int = 0 ;
// The event objects to be constructed and to be dispatched from here.
    private var eventCoordinatesChanged : Event = null ;
    private var eventSizesChanged : Event = null ;
// The base event dispatcher object: other objects can be registered into this.
    private var baseEventDispatcher : BaseEventDispatcher = null ;
// This is a general object to be able to point into.
    private var value : Object = null ;
// This is an enabled object or not.
    private var enabled : Boolean = true ;
// Follow the size of the stage.
    private var followStageWidth : Boolean = false ;
    private var followStageHeight : Boolean = false ;
    private var factorStageWidth : Number = 0 ;
    private var factorStageHeight : Number = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseSprite ( applicationRef : Application ) : void
    {
// Super.
      super ( ) ;
// Getting the not null reference to the Application object.
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// Creating the events.
      eventCoordinatesChanged = new Event ( application . EVENT_COORDINATES_CHANGED ) ;
      eventSizesChanged = new Event ( application . EVENT_SIZES_CHANGED ) ;
// Let's create the base event dispatcher object.
      baseEventDispatcher = new BaseEventDispatcher ( ) ;
// Let's reset the coordinate and the size of this object.
      coordinateSizeReset ( ) ;
// Now registering the events of adding and removing this object to and from the stage.
      addEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      addEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
    }
/*
** Listener functions: added and removed from stage.
** (The stage propery will be not null in addedToStage
** and null will be null in removedFromStage.)
*/
    protected function addedToStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
    protected function removedFromStage ( e : Event ) : void
    {
// Calling the content size recalc.
      application . callContentSizeRecalc ( this ) ;
    }
/*
** This is the resetter of the basic properties.
** Coordinate and size.
** Every of them have to be 0.
** The x and y coordinates of this object have to be set to 0 also.
*/
    private function coordinateSizeReset ( ) : void
    {
// Resetting everything. (stored properties.)
      cx = 0 ;
      cy = 0 ;
      sw = 0 ;
      sh = 0 ;
// The x and y coordinates have to be 0.
      x = cx ;
      y = cy ;
    }
/*
** Gets the base event dispatcher object to the outside world.
** Usable from right after the object creation.
*/
    public function getBaseEventDispatcher ( ) : BaseEventDispatcher
    {
      return baseEventDispatcher ;
    }
/*
** This two method have to be overwritten and not needed to register for the
** eventCoordinatesChanged and eventSizesChanged events of this in extending classes.
*/
    protected function doCoordinateChanged ( ) : void
    {
// Calling the content size recalc because the whole size of the content can be changed.
      application . callContentSizeRecalc ( this ) ;
    }
    protected function doSizeChanged ( ) : void
    {
// Calling the content size recalc because the whole size of the content can be changed.
      application . callContentSizeRecalc ( this ) ;
    }
/*
** Setting the coordinate and size properties of this object.
** A property will be changed if it doesn't have that value already.
** If a value changing is necessary then
** - that will be done
** - the x and y will also be set if necessary
** - doCoordinateChanged or doSizeChanged method calls
** - dispatching the event which is necessary to inform other objects
**   of the changing of values of these properties.
*/
    public function setcx ( newcx : int ) : void
    {
      if ( cx != newcx )
      {
        cx = newcx ;
        x = cx ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setcy ( newcy : int ) : void
    {
      if ( cy != newcy )
      {
        cy = newcy ;
        y = cy ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setcxy ( newcx : int , newcy : int ) : void
    {
      if ( cx != newcx || cy != newcy )
      {
        cx = newcx ;
        cy = newcy ;
        x = cx ;
        y = cy ;
        doCoordinateChanged ( ) ;
        dispatchEventCoordinatesChanged ( ) ;
      }
    }
    public function setsw ( newsw : int ) : void
    {
      if ( sw != Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) )
      {
        sw = Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) ;
        calcFactorStageWidth ( ) ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
    public function setsh ( newsh : int ) : void
    {
      if ( sh != Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) )
      {
        sh = Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) ;
        calcFactorStageHeight ( ) ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
    public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( sw != Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) || sh != Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) )
      {
        sw = Math . max ( newsw , application . getPropsApp ( ) . getBaseMinw ( ) ) ;
        sh = Math . max ( newsh , application . getPropsApp ( ) . getBaseMinh ( ) ) ;
        calcFactorStageWidth ( ) ;
        calcFactorStageHeight ( ) ;
        doSizeChanged ( ) ;
        dispatchEventSizesChanged ( ) ;
      }
    }
/*
** Sometimes we want an object to be in different location
** but without the dispatch of coordinate changed event.
** We can set the x and y properties of that object and then
** these can update the own cx and cy properties using this method.
*/
    public function updatecxy ( ) : void
    {
      cx = int ( x ) ;
      cy = int ( y ) ;
      x = cx ;
      y = cy ;
    }
/*
** Follows the stage width.
*/
    public function setFollowStageWidth ( b : Boolean ) : void
    {
      if ( followStageWidth )
      {
        if ( ! b )
        {
          followStageWidth = false ;
          factorStageWidth = 0 ;
          if ( stage != null )
          {
            stage . removeEventListener ( Event . RESIZE , stageResized ) ;
          }
        }
      }
      else
      {
        if ( b && ( ! application . getPropsApp ( ) . getSmartphoneMode ( ) || ! this is Widget ) )
        {
          followStageWidth = true ;
          calcFactorStageWidth ( ) ;
          if ( stage != null )
          {
            stage . addEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
          }
          stageResized ( null ) ;
        }
      }
    }
/*
** Follows the stage height.
*/
    public function setFollowStageHeight ( b : Boolean ) : void
    {
      if ( followStageHeight )
      {
        if ( ! b )
        {
          followStageHeight = false ;
          factorStageHeight = 0 ;
          if ( stage != null )
          {
            stage . removeEventListener ( Event . RESIZE , stageResized ) ;
          }
        }
      }
      else
      {
        if ( b )
        {
          followStageHeight = true ;
          calcFactorStageHeight ( ) ;
          if ( stage != null )
          {
            stage . addEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
          }
          stageResized ( null ) ;
        }
      }
    }
/*
** Calculate the factors.
*/
    private function calcFactorStageWidth ( ) : void
    {
      if ( followStageWidth )
      {
        factorStageWidth = getsw ( ) / application . getsw ( ) ;
      }
    }
    private function calcFactorStageHeight ( ) : void
    {
      if ( followStageHeight )
      {
        factorStageHeight = getsh ( ) / application . getsh ( ) ;
      }
    }
/*
** The stage has been resized.
*/
    private function stageResized ( e : Event ) : void
    {
      if ( followStageWidth && ! followStageHeight )
      {
        setsw ( application . getsw ( ) * factorStageWidth ) ;
      }
      else if ( ! followStageWidth && followStageHeight )
      {
        setsh ( application . getsh ( ) * factorStageHeight ) ;
      }
      else if ( followStageWidth && followStageHeight )
      {
        setswh ( application . getsw ( ) * factorStageWidth , application . getsh ( ) * factorStageHeight ) ;
      }
    }
/*
** Dispatches the sizes changed event.
** (To be lazy: instead of getBaseEventDispatcher ( ) . dispatchEvent ( eventSizesChanged ))
*/
    protected function dispatchEventSizesChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventSizesChanged ) ;
      }
    }
/*
** Dispatches the coordinates changed event.
** (Same reason.)
*/
    protected function dispatchEventCoordinatesChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventCoordinatesChanged ) ;
      }
    }
/*
** Gets the stored sprite properties: x y coordinates and w h sizes.
*/
    public function getcx ( ) : int
    {
      return cx ;
    }
    public function getcy ( ) : int
    {
      return cy ;
    }
    public function getsw ( ) : int
    {
      return sw ;
    }
    public function getsh ( ) : int
    {
      return sh ;
    }
/*
** Gets the properties needed for the reposition of the form elements.
*/
    public function getcxam ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcxap ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxamap ( ) : int
    {
      return cx + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxsw ( ) : int
    {
      return cx + sw ;
    }
    public function getcxswam ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcxswap ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcxswamap ( ) : int
    {
      return cx + sw + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyam ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcyap ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyamap ( ) : int
    {
      return cy + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcysh ( ) : int
    {
      return cy + sh ;
    }
    public function getcysham ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getcyshap ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
    public function getcyshamap ( ) : int
    {
      return cy + sh + application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
/*
** This is the calling of the grabage collector avoiding to have huge memory usage.
** This System . gc ( ) do almost nothing at the first time, so let's invoke it multiple times.
*/
    private function systemGc ( ) : void
    {
      for ( var i : int = 0 ; i < 10 ; i ++ )
      {
        System . gc ( ) ;
      }
    }
/*
** Sets and gets the value object
*/
    public function setValue ( v : Object ) : void
    {
      value = v ;
    }
    public function getValue ( ) : Object
    {
      return value ;
    }
/*
** Sets ad gets the enabled property of this base sprite.
** When disabled then the alpha can be set to a lower value than 1.
*/
    public function setEnabled ( e : Boolean ) : void
    {
      if ( enabled )
      {
        if ( ! e )
        {
          enabled = false ;
          mouseEnabled = false ;
          tabChildren = false ;
          alpha = application . getPropsApp ( ) . getDisabledAlpha ( ) ;
        }
      }
      else
      {
        if ( e )
        {
          enabled = true ;
          mouseEnabled = true ;
          tabChildren = true ;
          alpha = 1 ;
        }
      }
    }
/*
** Sends the object to the highest or to the lowest depths.
*/
    public function toTheHighestDepth ( ) : void
    {
      if ( parent != null )
      {
        parent . setChildIndex ( this , parent . numChildren - 1 ) ;
      }
    }
    public function toTheLowestDepth ( ) : void
    {
      if ( parent != null )
      {
        parent . setChildIndex ( this , 0 ) ;
      }
    }
/*
** Gets the enabled property of this object.
*/
    public function getEnabled ( ) : Boolean
    {
      return enabled ;
    }
/*
** If the parent parent object is a content single then this opened object has to be
** repositioned to get it visible in all of its size. (so the scroll may be scrolled.)
*/
    public function toBeVisible ( ) : void
    {
      if ( parent != null )
      {
        if ( parent . parent is ContentSingle )
        {
          var baseScroll : BaseScroll = ContentSingle ( parent . parent ) . getBaseScroll ( ) ;
          if ( baseScroll != null )
          {
            if ( - getcy ( ) > baseScroll . getccy ( ) )
            {
              baseScroll . setccy ( - getcy ( ) ) ;
            }
            if ( - getcx ( ) > baseScroll . getccx ( ) )
            {
              baseScroll . setccx ( - getcx ( ) ) ;
            }
            if ( - ( getcy ( ) + getsh ( ) ) < baseScroll . getccy ( ) - baseScroll . getMask0 ( ) . getsh ( ) )
            {
              baseScroll . setccy ( - ( getcy ( ) + getsh ( ) ) + baseScroll . getMask0 ( ) . getsh ( ) ) ;
            }
            if ( - ( getcx ( ) + getsw ( ) ) < baseScroll . getccx ( ) - baseScroll . getMask0 ( ) . getsw ( ) )
            {
              baseScroll . setccx ( - ( getcx ( ) + getsw ( ) ) + baseScroll . getMask0 ( ) . getsw ( ) ) ;
            }
          }
        }
      }
    }
/*
** If the event dispatcher needs the reference to this object.
*/
    public function setEventDispatcherObjectToThis ( ) : void
    {
// Tell to the base event dispatcher the reference.
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . setParentObject ( this ) ;
      }
    }
/*
** This is the destructor method of this base object.
** Public because sometimes we want to execute this on other objects.
** Has to be overridden in extending classes.
** This method is for exactly destroying everything that we can create in
** the current class.
** Systematically have to go thru the class and destroy everything.
** 1 have to unregister from all of the registered events not registered into local_var . getBaseEventDispatcher ( )!
**   This is important!
** 2 every event object has to stopImmediatePropagation
** 3 has to call the parent destroy like this:
**   override public function destroy ( ) : void
**   {
**     ...
**     ...
**     super . destroy ( ) ;
**     ...
**   }
** 4 properties have to be set the default value: to null, 0 or false.
*/
    public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      removeEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      removeEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      var displayObject : DisplayObject = null ;
      while ( numChildren > 0 )
      {
        displayObject = getChildAt ( 0 ) ;
        if ( displayObject is BaseSprite )
        {
          BaseSprite ( displayObject ) . destroy ( ) ;
        }
        else if ( displayObject is BaseTextField )
        {
          BaseTextField ( displayObject ) . destroy ( ) ;
        }
        else if ( displayObject is BaseShape )
        {
          BaseShape ( displayObject ) . destroy ( ) ;
        }
        removeChild ( displayObject ) ;
      }
      displayObject = null ;
      if ( eventCoordinatesChanged != null )
      {
        eventCoordinatesChanged . stopImmediatePropagation ( ) ;
      }
      if ( eventSizesChanged != null )
      {
        eventSizesChanged . stopImmediatePropagation ( ) ;
      }
      if ( baseEventDispatcher != null )
      {
        baseEventDispatcher . destroy ( ) ;
      }
      graphics . clear ( ) ;
      filters = null ;
// The grabage collecting has to be executed now.
      systemGc ( ) ;
// 3: calling the super destroy.
// 4: every reference and value should be resetted to null, 0 or false.
      coordinateSizeReset ( ) ;
      eventCoordinatesChanged = null ;
      eventSizesChanged = null ;
      baseEventDispatcher = null ;
      value = null ;
      enabled = false ;
      followStageWidth = false ;
      followStageHeight = false ;
      factorStageWidth = 0 ;
      factorStageHeight = 0 ;
      application = null ;
    }
  }
}