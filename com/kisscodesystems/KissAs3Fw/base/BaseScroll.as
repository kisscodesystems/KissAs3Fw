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
** BaseScroll.
** Scrolling means displaying a part of the content under a mask.
** This can be continuously (for example a content of a widget)
** or not (for example the currently displayed elements of a list).
** The moving of the shapes and the calculations of the coordinates of
** the content will happen here, the real positioning happens outside.
** Mouse wheel works since version 1.2.
**
** MAIN FEATURES:
** - displaying the two rectangles
** - contains the two mask usable for the outside world
** - the mover can be dragged to trigger the reposition of the content to the outside
** - the target coordinates ( where to move the content) will be calculated as
**   slow down the content continuously.
** - the size and the initial position of the content can be specified from outside
** - the outside can listen to the event of application . EVENT_CONTENT_POSITION_CHANGED
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . ui . Mouse ;
  import flash . utils . getTimer ;
  public class BaseScroll extends BaseSprite
  {
// The base rectangle frame of the object.
// This will not be moved.
    private var shapeFrame : BaseShape = null ;
// The base shape that shows the actual position of the content.
// This will be not movable by hand but will be moved according to the actual position.
// Setting its coordinates can be hppened by sdetting its x and y coordinates (and not using setcxy())!
    private var shapeActualpos : BaseShape = null ;
// The mask objects of the content.
    private var shapeMask0 : BaseShape = null ;
    private var shapeMask1 : BaseShape = null ;
// This is the positioner of the external displayable object.
// If this is moved then it will be returned immediately to the 0-0 coordinates.
// The x and y property will be used instead of getcxy because this object will be dragged.
    private var spriteMover : BaseSprite = null ;
// The event is dispatched when the position of the content is changed.
// This can be watched by the outside world.
    private var eventContentPositionChanged : Event = null ;
// The events of the content caching
    private var eventContentCacheBegin : Event = null ;
// The sizes of the external content. (We have to know it to calculate the proper content position.)
    private var scw : int = 0 ;
    private var sch : int = 0 ;
// The actual coordinates of the content (depend on the scw-sch and the current size of this basescroll.)
    private var ccx : Number = 0 ;
    private var ccy : Number = 0 ;
// The previous coordinates (saved when the mouse is down)
    private var ccxPrev : Number = 0 ;
    private var ccyPrev : Number = 0 ;
// These are the target coordinates where the content will be moved into.
    private var ccxTarget : int = 0 ;
    private var ccyTarget : int = 0 ;
// These are the coordinates of the spriteMover in the previous frame.
// The difference between the actual pos and the pos in the
// previous enterframe decides the speed of the moving of the content!
    private var prevMoverx : int = 0 ;
    private var prevMovery : int = 0 ;
// The deltas of the coordinates
    private var deltax : int = 0 ;
    private var deltay : int = 0 ;
// The getTimer value when the button is pressed or the screen is tapped.
    private var mouseDownTime : int = - 1 ;
// Regular operation false: all of the area of the scroll will behave as the
// usual scroll to handle really long lists or other contents.
    private var regularOperation : Boolean = true ;
// Events of the reaches of the tops, bottoms.
    private var eventTopReached : Event = null ;
    private var eventBottomReached : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseScroll ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating and initializing the objects.
      shapeFrame = new BaseShape ( application ) ;
      addChild ( shapeFrame ) ;
      shapeFrame . x = 0 ;
      shapeFrame . y = 0 ;
      shapeFrame . setdb ( false ) ;
      shapeFrame . setdt ( 0 ) ;
      shapeActualpos = new BaseShape ( application ) ;
      addChild ( shapeActualpos ) ;
      shapeActualpos . x = 0 ;
      shapeActualpos . y = 0 ;
      shapeActualpos . setdb ( false ) ;
      shapeActualpos . setdt ( 0 ) ;
      shapeMask0 = new BaseShape ( application ) ;
      addChild ( shapeMask0 ) ;
      shapeMask0 . x = 0 ;
      shapeMask0 . y = 0 ;
      shapeMask0 . setdb ( false ) ;
      shapeMask0 . setdt ( 0 ) ;
      shapeMask1 = new BaseShape ( application ) ;
      addChild ( shapeMask1 ) ;
      shapeMask1 . x = 0 ;
      shapeMask1 . y = 0 ;
      shapeMask1 . setdb ( false ) ;
      shapeMask1 . setdt ( 0 ) ;
      shapeMask1 . visible = false ;
      spriteMover = new BaseSprite ( application ) ;
      addChild ( spriteMover ) ;
// This event has to be initialized now.
      eventContentPositionChanged = new Event ( application . EVENT_CONTENT_POSITION_CHANGED ) ;
      eventContentCacheBegin = new Event ( application . EVENT_CONTENT_CACHE_BEGIN ) ;
// The event of the reaching the bottom.
      eventTopReached = new Event ( application . EVENT_TOP_REACHED ) ;
      eventBottomReached = new Event ( application . EVENT_BOTTOM_REACHED ) ;
// Adding this event listeners to the spriteMover.
      spriteMover . addEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
// These have to be zero!
      scw = 0 ;
      sch = 0 ;
      ccx = 0 ;
      ccy = 0 ;
      ccxTarget = 0 ;
      ccyTarget = 0 ;
      prevMoverx = 0 ;
      prevMovery = 0 ;
    }
/*
** These are not necessary to be listened to.
*/
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_UP , mouseUp ) ;
      }
// This is always necessary at the end of the function body.
      super . removedFromStage ( e ) ;
    }
/*
** Callable method to simulate rollOver.
** (for example resizing widget on tablet or on smartphone devices)
*/
    public function doRollOver ( ) : void
    {
      if ( spriteMover != null )
      {
        if ( ! spriteMover . hasEventListener ( MouseEvent . MOUSE_WHEEL ) )
        {
          spriteMover . removeEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
          spriteMover . addEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
          spriteMover . addEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
          spriteMover . addEventListener ( MouseEvent . MOUSE_WHEEL , mouseWheel ) ;
        }
      }
    }
/*
** Mouse rolls over the mover sprite.
*/
    private function rollOver ( e : MouseEvent ) : void
    {
      if ( e != null )
      {
        if ( ! e . buttonDown )
        {
          doRollOver ( ) ;
        }
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Mouse rolls out the mover sprite.
*/
    private function rollOut ( e : MouseEvent ) : void
    {
      if ( e != null )
      {
        if ( ! e . buttonDown )
        {
          if ( spriteMover != null )
          {
            spriteMover . addEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
            spriteMover . removeEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
            spriteMover . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
            spriteMover . removeEventListener ( MouseEvent . MOUSE_WHEEL , mouseWheel ) ;
          }
        }
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Mouse down on the mover sprite.
*/
    private function mouseDown ( e : MouseEvent ) : void
    {
// The previous moving is stopping and a new one can be started.
      removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
      addEventListener ( Event . ENTER_FRAME , enterFrameSaveMoverPos ) ;
// This is the time when the mouse is down.
      mouseDownTime = getTimer ( ) ;
// Regular operation by default.
      regularOperation = true ;
// Cache the content!
      dispatchEventCacheBegin ( ) ;
      ccxPrev = ccx ;
      ccyPrev = ccy ;
      if ( stage != null )
      {
        stage . addEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
        stage . addEventListener ( MouseEvent . MOUSE_UP , mouseUp ) ;
      }
// Starts drag the spriteMover shape.
      spriteMover . startDrag ( ) ;
    }
/*
** Saves the actual position of the mover.
*/
    private function enterFrameSaveMoverPos ( e : Event ) : void
    {
      prevMoverx = spriteMover . x ;
      prevMovery = spriteMover . y ;
    }
/*
** When the mouse is moving.
*/
    private function mouseMove ( e : MouseEvent ) : void
    {
      if ( mouseDownTime > - 1 && regularOperation && getTimer ( ) - mouseDownTime > 500 && ccx == ccxPrev && ccy == ccyPrev )
      {
        regularOperation = false ;
      }
// Regular operation: simply follow the mover.
      if ( regularOperation )
      {
        mouseDownTime = - 1 ;
        ccxTarget = ccxPrev + spriteMover . x ;
        ccyTarget = ccyPrev + spriteMover . y ;
      }
// Not regular operation: all of the scroll area works like a classical scroll!
      else
      {
        ccxTarget = - ( scw - getsw ( ) ) * ( spriteMover . x + spriteMover . mouseX ) / getsw ( ) ;
        ccyTarget = - ( sch - getsh ( ) ) * ( spriteMover . y + spriteMover . mouseY ) / getsh ( ) ;
      }
// The corrections.
// The target coordinates have to be between the bounds.
      targetCoordinatesCorrection ( ) ;
      ccx = ccxTarget ;
      ccy = ccyTarget ;
// This is the show of the actual position.
      calcShapeActualposCoordinatesByContentPos ( ) ;
// The event of the content position changing has to be dispatched in each frame!
      dispatchEventContentPositionChanged ( ) ;
// This can improve rendering.
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** The mouse is up!
*/
    private function mouseUp ( e : MouseEvent ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_UP , mouseUp ) ;
      }
      if ( spriteMover . x != prevMoverx )
      {
        deltax = spriteMover . x - prevMoverx ;
        if ( deltax > 0 )
        {
          ccxTarget += Math . max ( deltax , ( deltax ) * Math . abs ( deltax ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
        else
        {
          ccxTarget += Math . min ( deltax , ( deltax ) * Math . abs ( deltax ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
      }
      else
      {
        ccxTarget = ccx ;
        deltax = 0 ;
      }
      if ( spriteMover . y != prevMovery )
      {
        deltay = spriteMover . y - prevMovery ;
        if ( deltay > 0 )
        {
          ccyTarget += Math . max ( deltay , ( deltay ) * Math . abs ( deltay ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
        else
        {
          ccyTarget += Math . min ( deltay , ( deltay ) * Math . abs ( deltay ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
      }
      else
      {
        ccyTarget = ccy ;
        deltay = 0 ;
      }
      if ( regularOperation && ( spriteMover . x != prevMoverx || spriteMover . y != prevMovery ) )
      {
// The corrections.
// The target coordinates have to be between the bounds.
        targetCoordinatesCorrection ( ) ;
        addEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
        removeEventListener ( Event . ENTER_FRAME , enterFrameSaveMoverPos ) ;
      }
      else
      {
        ccxTarget = ccx ;
        ccyTarget = ccy ;
        deltax = 0 ;
        deltay = 0 ;
      }
// Stopping the spriteMover.
      stopMover ( ) ;
// These have to be reinitialized.
      mouseDownTime = - 1 ;
      regularOperation = true ;
// This can improve rendering.
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Positions the content continuously to the target coordinates.
*/
    private function enterFrameMoveContent ( e : Event ) : void
    {
// The position of the content has to be the follows.
      ccx += ( ccxTarget - ccx ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ;
      ccy += ( ccyTarget - ccy ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ;
// We should check the current and the target position in every frame.
// If the x or the y coordinate has reached the final corrdinate
      if ( Math . round ( ccx ) == ccxTarget && Math . round ( ccy ) == ccyTarget )
      {
// Then this function has to be unregistered.
        removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
// And the position have to be the target coordinates.
        ccx = ccxTarget ;
        ccy = ccyTarget ;
      }
// This is the show of the actual position.
      calcShapeActualposCoordinatesByContentPos ( ) ;
// The event of the content position changing has to be dispatched in each frame!
      dispatchEventContentPositionChanged ( ) ;
    }
/*
** Stops the spriteMover and places it into the 0-0.
*/
    private function stopMover ( ) : void
    {
      if ( spriteMover != null )
      {
        spriteMover . stopDrag ( ) ;
        spriteMover . x = 0 ;
        spriteMover . y = 0 ;
      }
    }
/*
** Handles the mouse wheel event.
*/
    private function mouseWheel ( e : MouseEvent ) : void
    {
      if ( false )
      {
        ccxTarget += e . delta * application . getPropsApp ( ) . getWheelDeltaPixels ( ) ;
      }
      else
      {
        ccyTarget += e . delta * application . getPropsApp ( ) . getWheelDeltaPixels ( ) ;
      }
      targetCoordinatesCorrection ( ) ;
// Cache the content!
      dispatchEventCacheBegin ( ) ;
      addEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameSaveMoverPos ) ;
// This can improve rendering.
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** The correction of the target coordiantes.
*/
    private function targetCoordinatesCorrection ( ) : void
    {
      if ( ccxTarget > 0 )
      {
        ccxTarget = 0 ;
      }
      else if ( ccxTarget < getsw ( ) - scw )
      {
        ccxTarget = getsw ( ) - scw ;
      }
      if ( ccyTarget > 0 )
      {
        ccyTarget = 0 ;
      }
      else if ( ccyTarget < getsh ( ) - sch )
      {
        ccyTarget = getsh ( ) - sch ;
      }
    }
/*
** Gets the reference to the masks.
** If this is a continuous content (like the content of the widget for example)
** then this has to be the mask of that content.
** There are two because the front and the back content sprite of the ContentSingle
** need different masks! These two have to be resized and repositioned in the same way.
*/
    public function getMask0 ( ) : BaseShape
    {
      return shapeMask0 ;
    }
    public function getMask1 ( ) : BaseShape
    {
      shapeMask1 . visible = true ;
      return shapeMask1 ;
    }
/*
** Gets the reference to the spriteMover sprite.
*/
    public function getMover ( ) : BaseSprite
    {
      return spriteMover ;
    }
/*
** Dispatches when the content position has been changed.
*/
    private function dispatchEventContentPositionChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventContentPositionChanged != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventContentPositionChanged ) ;
      }
      if ( ccy == getsh ( ) - sch )
      {
        dispatchEventBottomReached ( ) ;
      }
      if ( ccy == 0 )
      {
        dispatchEventTopReached ( ) ;
      }
    }
/*
** Dispatches when the content position has to be cached.
*/
    private function dispatchEventCacheBegin ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventContentCacheBegin != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventContentCacheBegin ) ;
      }
    }
/*
** To be able to set the coordinates of the content!
*/
    public function setccx ( newccx : int ) : void
    {
      if ( ccx != newccx )
      {
        ccx = newccx ;
        ccxTarget = ccx ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
    public function setccy ( newccy : int ) : void
    {
      if ( ccy != newccy )
      {
        ccy = newccy ;
        ccyTarget = ccy ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
    public function setccxcy ( newccx : int , newccy : int ) : void
    {
      if ( ccx != newccx || ccy != newccy )
      {
        ccx = newccx ;
        ccy = newccy ;
        ccxTarget = ccx ;
        ccyTarget = ccy ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
    public function setccxn ( n : Number ) : void
    {
      ccx = n ;
    }
    public function setccyn ( n : Number ) : void
    {
      ccy = n ;
    }
/*
** To be able to set the size of the content!
*/
    public function setscw ( newscw : int ) : void
    {
      if ( scw != newscw )
      {
        scw = newscw ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
    public function setsch ( newsch : int ) : void
    {
      if ( sch != newsch )
      {
        sch = newsch ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
    public function setscwch ( newscw : int , newsch : int ) : void
    {
      if ( scw != newscw || sch != newsch )
      {
        scw = newscw ;
        sch = newsch ;
        redrawShapesMover ( ) ;
        calcShapeActualposCoordinatesByContentPos ( ) ;
        dispatchEventContentPositionChanged ( ) ;
      }
    }
/*
** Gets the actual x and y of the content.
*/
    public function getccx ( ) : Number
    {
      return ccx ;
    }
    public function getccy ( ) : Number
    {
      return ccy ;
    }
/*
** Gets the actual width and height of the content.
*/
    public function getscw ( ) : int
    {
      return scw ;
    }
    public function getsch ( ) : int
    {
      return sch ;
    }
/*
** The line thickness has been changed
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
      redrawShapesMover ( ) ;
      calcShapeActualposCoordinatesByContentPos ( ) ;
      dispatchEventContentPositionChanged ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      redrawShapesMover ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So we have to redraw.
      redrawShapesMover ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So we have to redraw.
      redrawShapesMover ( ) ;
    }
/*
** This is the method runs after the changing of the size of this object.
*/
    override protected function doSizeChanged ( ) : void
    {
// The spriteMover has to be stopped.
      stopMover ( ) ;
// The moving also has to be stopped.
      removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameSaveMoverPos ) ;
// The 0-0 coordinates will be reached after resizing of a basescroll!
      if ( ccx != 0 || ccy != 0 )
      {
// And the position have to be zero.
        ccx = 0 ;
        ccy = 0 ;
        ccxTarget = 0 ;
        ccyTarget = 0 ;
      }
// This is the show of the actual position.
      redrawShapesMover ( ) ;
      calcShapeActualposCoordinatesByContentPos ( ) ;
      dispatchEventContentPositionChanged ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** Redraws the shapes and the spriteMover.
** Only the redrawing is here, the repositioning is elsewhere.
*/
    private function redrawShapesMover ( ) : void
    {
      if ( application != null )
      {
// The frame is redrawn and repositioned.
        shapeFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeFrame . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeFrame . drawRect ( ) ;
// The actual pos moved shape is redrawn and repositioned.
        shapeActualpos . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeActualpos . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeActualpos . setswh ( getsw ( ) - ( scw <= getsw ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) , getsh ( ) - ( sch <= getsh ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) ) ;
        shapeActualpos . drawRect ( ) ;
// The mask has to be updated too.
        shapeMask0 . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeMask0 . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeMask0 . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) - ( getscw ( ) <= getsw ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) , getsh ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) - ( getsch ( ) <= getsh ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) ) ;
        shapeMask0 . drawRect ( ) ;
        shapeMask1 . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeMask1 . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeMask1 . setswh ( shapeMask0 . getsw ( ) , shapeMask0 . getsh ( ) ) ;
        shapeMask1 . drawRect ( ) ;
// The spriteMover also has to be repainted and repositioned.
        spriteMover . graphics . clear ( ) ;
        spriteMover . graphics . lineStyle ( 0 , 0 , 0 ) ;
        spriteMover . graphics . beginFill ( 0 , 0 ) ;
        spriteMover . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
        spriteMover . graphics . endFill ( ) ;
        spriteMover . x = 0 ;
        spriteMover . y = 0 ;
        spriteMover . setswh ( getsw ( ) , getsh ( ) ) ;
        spriteMover . stopDrag ( ) ;
      }
    }
/*
** Calculating the position of the shapeActualpos by the current position of the content.
** If the position is invalid (lesser than 0 or greather than scroll margin)
** then a correction will be applied both on x and y coordinates and both on actual pos shape and on content.
** The masks will be also repositioned.
*/
    public function calcShapeActualposCoordinatesByContentPos ( ) : void
    {
      if ( application != null )
      {
        shapeActualpos . x = Math . round ( - application . getPropsApp ( ) . getScrollMargin ( ) / ( scw - getsw ( ) ) * ccx ) ;
        if ( shapeActualpos . x < 0 || scw <= getsw ( ) )
        {
          shapeActualpos . x = 0 ;
          ccx = 0 ;
          ccxTarget = ccx ;
        }
        else if ( shapeActualpos . x > application . getPropsApp ( ) . getScrollMargin ( ) )
        {
          shapeActualpos . x = application . getPropsApp ( ) . getScrollMargin ( ) ;
          ccx = getsw ( ) - scw ;
          ccxTarget = ccx ;
        }
        shapeActualpos . y = Math . round ( - application . getPropsApp ( ) . getScrollMargin ( ) / ( sch - getsh ( ) ) * ccy ) ;
        if ( shapeActualpos . y < 0 || sch <= getsh ( ) )
        {
          shapeActualpos . y = 0 ;
          ccy = 0 ;
          ccyTarget = ccy ;
        }
        else if ( shapeActualpos . y > application . getPropsApp ( ) . getScrollMargin ( ) )
        {
          shapeActualpos . y = application . getPropsApp ( ) . getScrollMargin ( ) ;
          ccy = getsh ( ) - sch ;
          ccyTarget = ccy ;
        }
        shapeMask0 . x = shapeActualpos . x + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask0 . y = shapeActualpos . y + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask1 . x = shapeActualpos . x + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask1 . y = shapeActualpos . y + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
      }
    }
/*
** Dispatches an event to reached the top or bottom of the content.
** The formulas of the calculating of the current content position may
** be not 100% correct, so the top or bottom reaching events are
** mandatory to be dispatched to get the content exactly to the top
** or bottom.
*/
    protected function dispatchEventTopReached ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventTopReached != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventTopReached ) ;
      }
    }
    protected function dispatchEventBottomReached ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventBottomReached != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventBottomReached ) ;
      }
    }
/*
** Overwriting this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , mouseMove ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_UP , mouseUp ) ;
      }
      spriteMover . removeEventListener ( MouseEvent . ROLL_OVER , rollOver ) ;
      spriteMover . removeEventListener ( MouseEvent . ROLL_OUT , rollOut ) ;
      spriteMover . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
      spriteMover . removeEventListener ( MouseEvent . MOUSE_WHEEL , mouseWheel ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameSaveMoverPos ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventContentPositionChanged != null )
      {
        eventContentPositionChanged . stopImmediatePropagation ( ) ;
      }
      if ( eventContentCacheBegin != null )
      {
        eventContentCacheBegin . stopImmediatePropagation ( ) ;
      }
      if ( eventTopReached != null )
      {
        eventTopReached . stopImmediatePropagation ( ) ;
      }
      if ( eventBottomReached != null )
      {
        eventBottomReached . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      shapeFrame = null ;
      shapeMask0 = null ;
      shapeMask1 = null ;
      shapeActualpos = null ;
      spriteMover = null ;
      eventContentPositionChanged = null ;
      eventContentCacheBegin = null ;
      eventTopReached = null ;
      eventBottomReached = null ;
      scw = 0 ;
      sch = 0 ;
      ccx = 0 ;
      ccy = 0 ;
      ccxPrev = 0 ;
      ccyPrev = 0 ;
      ccxTarget = 0 ;
      ccyTarget = 0 ;
      prevMoverx = 0 ;
      prevMovery = 0 ;
      deltax = 0 ;
      deltay = 0 ;
      mouseDownTime = 0 ;
      regularOperation = false ;
    }
  }
}
