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
** BaseScroll.
** Scrolling means displaying a part of the content under a mask.
** This can be continuously (for example a content of a widget)
** or not (for example the currently displayed elements of a list).
** The moving of the shapes and the calculations of the coordinates of
** the content will happen here, the real positioning happens outside.
**
** MAIN FEATURES:
** - displaying the two rectangles
** - contains the two mask usable for the outside world
** - the mover can be dragged to trigger the reposition of the content to the outside
** - the target coordinates ( where to move the content) will be calculated as
**   slow down the content continuously.
** - the size and the initial position of the content can be specified from outside
** - the outside can liten to the event of application . EVENT_CONTENT_POSITION_CHANGED
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . ui . Mouse ;
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
// The sizes of the external content. (We have to know it to calculate the proper content position.)
    private var scw : int = 0 ;
    private var sch : int = 0 ;
// The actual coordinates of the content (depend on the scw-sch and the current size of this basescroll.)
    private var ccx : Number = 0 ;
    private var ccy : Number = 0 ;
// These are the target coordinates where the content will be moved into.
    private var targetx : int = 0 ;
    private var targety : int = 0 ;
// These are the coordinates of the spriteMover in the previous frame.
// The difference between the actual pos and the pos in the
// previous enterframe decides the speed of the moving of the content!
    private var prevx : int = 0 ;
    private var prevy : int = 0 ;
// The deltas of the coordinates
    private var deltax : int = 0 ;
    private var deltay : int = 0 ;
// The mouse is down or up.
    private var mouseIsDown : Boolean = false ;
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
// Adding this event listeners to the spriteMover.
      spriteMover . addEventListener ( MouseEvent . MOUSE_DOWN , mouseDown ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
// These have to be zero!
      scw = 0 ;
      sch = 0 ;
      ccx = 0 ;
      ccy = 0 ;
      targetx = 0 ;
      targety = 0 ;
      prevx = 0 ;
      prevy = 0 ;
    }
/*
** This method will be called if the object is being added to the stage.
** A lot of initializing happens here because the stage is available
** from here.
*/
    override protected function addedToStage ( e : Event ) : void
    {
// Calling the addedToStage of parent.
      super . addedToStage ( e ) ;
// These events have to be registered.
      stage . addEventListener ( MouseEvent . MOUSE_MOVE , mouseMove , false , 0 , true ) ;
      stage . addEventListener ( MouseEvent . MOUSE_UP , mouseUp , false , 0 , true ) ;
    }
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
** The mouse down function.
** The user presses the left mouse.
** The target x and y coordinates will be calculated continuously
** and the content x and y coordinates will go to these also continuously
** and independently from the above.
*/
    private function mouseDown ( e : MouseEvent ) : void
    {
// Let's stop the current moving.
      removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
// The target coordinates have to be cleared.
      targetx = ccx ;
      targety = ccy ;
// The prev x and y coordinates.
      prevx = spriteMover . getcx ( ) ;
      prevy = spriteMover . getcy ( ) ;
// The mose is down.
      mouseIsDown = true ;
// Starts drag the spriteMover shape.
      spriteMover . startDrag ( ) ;
    }
    private function mouseMove ( e : MouseEvent ) : void
    {
// Works only if the mouse is down. (And then always.)
      if ( mouseIsDown )
      {
// The spriteMover position is..
        spriteMover . updatecxy ( ) ;
// The delta x and y.. they are the current minus the previous coordinates.
        deltax = spriteMover . getcx ( ) - prevx ;
        deltay = spriteMover . getcy ( ) - prevy ;
// The target coordinates have to be increased as follows.
// Positive deltax: math . max, otherwise math . min will be used!
        if ( deltax > 0 )
        {
          targetx += Math . max ( deltax , ( deltax ) * Math . abs ( deltax ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
        else
        {
          targetx += Math . min ( deltax , ( deltax ) * Math . abs ( deltax ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
        if ( deltay > 0 )
        {
          targety += Math . max ( deltay , ( deltay ) * Math . abs ( deltay ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
        else
        {
          targety += Math . min ( deltay , ( deltay ) * Math . abs ( deltay ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ) ;
        }
// The corrections.
// The target coordinates have to be between the bounds.
        if ( targetx < getsw ( ) - scw )
        {
          targetx = getsw ( ) - scw ;
        }
        if ( targetx > 0 )
        {
          targetx = 0 ;
        }
        if ( targety < getsh ( ) - sch )
        {
          targety = getsh ( ) - sch ;
        }
        if ( targety > 0 )
        {
          targety = 0 ;
        }
// Now let these coordinates be the current coordinates of the spriteMover.
// (In the next enter frame event, these are really the previous coordinates.)
        prevx = spriteMover . getcx ( ) ;
        prevy = spriteMover . getcy ( ) ;
// If the content moving is not registered then it has to be done now.
        if ( ! hasEventListener ( Event . ENTER_FRAME ) )
        {
          addEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
        }
      }
    }
/*
** The user lets the left mouse button up.
*/
    private function mouseUp ( e : MouseEvent ) : void
    {
// Stopping the spriteMover.
      stopMover ( ) ;
      mouseIsDown = false ;
    }
/*
** Positions the content continuously to the target coordinates.
*/
    private function enterFrameMoveContent ( e : Event ) : void
    {
// The position of the content has to be the follows.
      ccx += ( targetx - ccx ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ;
      ccy += ( targety - ccy ) / application . getPropsApp ( ) . getWeightScrollContent ( ) ;
// We should check the current and the target position in every frame.
// If the x or the y coordinate has reached the final corrdinate
      if ( Math . round ( ccx ) == targetx && Math . round ( ccy ) == targety )
      {
// Then this function has to be unregistered if the mouse is up.
        if ( ! mouseIsDown )
        {
          removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
        }
// And the position have to be the target coordinates.
        ccx = targetx ;
        ccy = targety ;
      }
// This is the show of the actual position.
      calcShapeActualposCoordinatesByContentPos ( ) ;
// The event of the content position changing has to be dispatched in each frame!
      dispatchEventContentPositionChanged ( ) ;
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
    }
/*
** Stops the spriteMover and places it into the 0-0.
*/
    private function stopMover ( ) : void
    {
      if ( spriteMover != null )
      {
        spriteMover . stopDrag ( ) ;
        spriteMover . setcxy ( 0 , 0 ) ;
      }
      prevx = 0 ;
      prevy = 0 ;
      deltax = 0 ;
      deltay = 0 ;
    }
/*
** To be able to set the coordinates of the content!
*/
    public function setccx ( newccx : int ) : void
    {
      if ( ccx != newccx )
      {
        ccx = newccx ;
        targetx = ccx ;
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
        targety = ccy ;
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
        targetx = ccx ;
        targety = ccy ;
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
// The 0-0 coordinates will be reached after resizing of a basescroll!
      if ( ccx != 0 || ccy != 0 )
      {
// And the position have to be zero.
        ccx = 0 ;
        ccy = 0 ;
        targetx = 0 ;
        targety = 0 ;
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
// The frame is redrawed and repositioned.
        shapeFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeFrame . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        shapeFrame . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeFrame . drawRect ( ) ;
// The actual pos moved shape is redrawed and repositioned.
        shapeActualpos . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeActualpos . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        shapeActualpos . setswh ( getsw ( ) - ( scw <= getsw ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) , getsh ( ) - ( sch <= getsh ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) ) ;
        shapeActualpos . drawRect ( ) ;
// The mask has to be updated too.
        shapeMask0 . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeMask0 . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        shapeMask0 . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) - ( getscw ( ) <= getsw ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) , getsh ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) - ( getsch ( ) <= getsh ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) ) ;
        shapeMask0 . drawRect ( ) ;
        shapeMask1 . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeMask1 . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        shapeMask1 . setswh ( shapeMask0 . getsw ( ) , shapeMask0 . getsh ( ) ) ;
        shapeMask1 . drawRect ( ) ;
// The spriteMover also has to be repainted and repositioned.
        spriteMover . graphics . clear ( ) ;
        spriteMover . graphics . lineStyle ( 0 , 0 , 0 ) ;
        spriteMover . graphics . beginFill ( 0 , 0 ) ;
        spriteMover . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
        spriteMover . graphics . endFill ( ) ;
        spriteMover . setcxy ( 0 , 0 ) ;
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
        if ( shapeActualpos . x < 0 )
        {
          shapeActualpos . x = 0 ;
          ccx = 0 ;
          targetx = ccx ;
        }
        else if ( shapeActualpos . x > application . getPropsApp ( ) . getScrollMargin ( ) )
        {
          shapeActualpos . x = application . getPropsApp ( ) . getScrollMargin ( ) ;
          ccx = getsw ( ) - scw ;
          targetx = ccx ;
        }
        shapeActualpos . y = Math . round ( - application . getPropsApp ( ) . getScrollMargin ( ) / ( sch - getsh ( ) ) * ccy ) ;
        if ( shapeActualpos . y < 0 )
        {
          shapeActualpos . y = 0 ;
          ccy = 0 ;
          targety = ccy ;
        }
        else if ( shapeActualpos . y > application . getPropsApp ( ) . getScrollMargin ( ) )
        {
          shapeActualpos . y = application . getPropsApp ( ) . getScrollMargin ( ) ;
          ccy = getsh ( ) - sch ;
          targety = ccy ;
        }
        shapeMask0 . x = shapeActualpos . x + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask0 . y = shapeActualpos . y + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask1 . x = shapeActualpos . x + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        shapeMask1 . y = shapeActualpos . y + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
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
      removeEventListener ( Event . ENTER_FRAME , enterFrameMoveContent ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventContentPositionChanged != null )
      {
        eventContentPositionChanged . stopImmediatePropagation ( ) ;
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
      scw = 0 ;
      sch = 0 ;
      ccx = 0 ;
      ccy = 0 ;
      targetx = 0 ;
      targety = 0 ;
      prevx = 0 ;
      prevy = 0 ;
      deltax = 0 ;
      deltay = 0 ;
      mouseIsDown = false ;
    }
  }
}