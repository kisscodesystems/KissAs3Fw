/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** Background.
** This class is the background of the application.
** Handles the painting of the background and the moving of the background image.
**
** MAIN FEATURES:
** - contains the layers:
**     - a backShape shape which can be colored to getAppBackgroundFillBgColor ( ) , alpha : 1
**     - a backgroundImageShape which can be painted with the background image, alpha: 0 - 1
**     - a backgroundColorShape  which can be colored to getAppBackgroundFillBgColor ( ) and getAppBackgroundFillFgColor ( ) , alpha: 0 - 1
** - live property: the background image can follow the mouse pointer slowly
** - the background is fixed automatically if a color object steals pixel from the stage
** - external image loading is available to get the bitmap from
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . display . BitmapData ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . geom . Matrix ;
  public class Background extends BaseSprite
  {
// The back of the whole background.
    private var backShape : BaseShape = null ;
// This is the shape to be painted with the background bitmap data.
    private var backgroundImageShape : BaseShape = null ;
// This is the base shape object of coloring the background.
    private var backgroundColorShape : BaseShape = null ;
// The matrix to paint.
    private var matrix : Matrix = null ;
// These temporary width and height values are to help the scaling of the
// background image. The image has to fill the area of stage depending on
// the current background aligning.
    private var tempWidth : int = 0 ;
    private var tempHeight : int = 0 ;
// These are the target coordinates where the live background will be moved into.
    private var targetx : int = 0 ;
    private var targety : int = 0 ;
// These width and height values are for correcting the actual size of stage.
// If the background is live then the size of the background image has to be
// a little larger than the actual size of the stage.
    private var swCorrected : int = 0 ;
    private var shCorrected : int = 0 ;
// A pixel stealing from a color object is in progress or not.
    private var pixelStealing : Boolean = false ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Background ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Creating the necessary objects here.
      backShape = new BaseShape ( application ) ;
      addChild ( backShape ) ;
      backgroundImageShape = new BaseShape ( application ) ;
      addChild ( backgroundImageShape ) ;
      backgroundColorShape = new BaseShape ( application ) ;
      addChild ( backgroundColorShape ) ;
// Registering onto the events which can modify this object.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_IMAGE_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_ALIGN_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_ALPHA_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BLUR_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_LIVE_CHANGED , backgroundLiveChanged ) ;
    }
/*
** Overwriting the addedToStage.
*/
    override protected function addedToStage ( e : Event ) : void
    {
// This is always necessary!
      super . addedToStage ( e ) ;
// We have to register this event.
      stage . addEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown , false , 0 , true ) ;
// Here we have a stage so we can call this now.
      registerOrUnregisterCanBackgroundMove ( ) ;
    }
/*
** Owerwriting the removedFromStage.
*/
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
      }
      super . removedFromStage ( e ) ;
    }
/*
** This method has been registered to the mouse down
*/
    private function stageMouseDown ( e : MouseEvent ) : void
    {
// Only if the background can move.
      if ( canBackgroundMove ( ) )
      {
// Positioning the background.
        posBackgroundImageForBackgroundLive ( e ) ;
      }
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      drawBackgroundColorShape ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      drawBackgroundColorShape ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// Can the background move? If yes then let's make that movable..
      registerOrUnregisterCanBackgroundMove ( ) ;
// So, we have to redraw the color shape.
      drawBackgroundColorShape ( ) ;
    }
/*
** The image of the background or the align or the alpha of the background image has been changed.
*/
    private function backgroundImageChanged ( e : Event ) : void
    {
// Can the background move? If yes then let's make that movable..
      registerOrUnregisterCanBackgroundMove ( ) ;
// We have to repaint the bacground image.
      drawBackgroundImageShape ( ) ;
    }
/*
** The live property of the background has been changed.
** Live true means: the background can follow slowly the mouse pointer.
** (So the background image is a little bit larger than the size of the stage.)
*/
    private function backgroundLiveChanged ( e : Event ) : void
    {
// Can the background move? If yes then let's make that movable..
      registerOrUnregisterCanBackgroundMove ( ) ;
// The size of the background image will be changed so it has to be repainted.
      drawBackgroundImageShape ( ) ;
    }
/*
** This is the method runs after the changing of the size of this object.
*/
    override protected function doSizeChanged ( ) : void
    {
// All of the shapes have to be repainted.
      backgroundRedraw ( ) ;
// Super, do not forget!
      super . doSizeChanged ( ) ;
    }
/*
** A color object is stealing a pixel now so everybody have to stay in its current position.
*/
    public function stealPixel ( b : Boolean ) : void
    {
      pixelStealing = b ;
      registerOrUnregisterCanBackgroundMove ( ) ;
    }
/*
** Determining of the movable property of the background image.
** The bg image can move if
** - pixel stealing is not in progress from a color object.
** - it is live
** - and not none the align of the bg
** - and if the fill alpha is smaller than 1.
** - the alpha of the background image is greather than 0
*/
    private function canBackgroundMove ( ) : Boolean
    {
      return ! pixelStealing && application . getPropsDyn ( ) . getAppBackgroundLive ( ) && application . getPropsDyn ( ) . getAppBackgroundAlign ( ) != application . getTexts ( ) . BACKGROUND_ALIGN_NONE && application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) < 1 && application . getPropsDyn ( ) . getAppBackgroundAlpha ( ) > 0 ;
    }
/*
** Registering for the background image moving if possible,
** and unregistering if not.
*/
    private function registerOrUnregisterCanBackgroundMove ( ) : void
    {
      if ( application != null )
      {
// The background is movable now or not.
        if ( canBackgroundMove ( ) )
        {
// If yes then register for the event.
          registerMouseMoveForBackgroundLive ( ) ;
        }
        else
        {
// If not then unregister.
// Both unregistering is required.
          unregisterEnterFrameForBackgroundLive ( ) ;
          unregisterMouseMoveFromBackgroundLive ( ) ;
        }
      }
    }
/*
** Drawing all of the background objects.
*/
    private function backgroundRedraw ( ) : void
    {
// Redrawing all the objects.
      drawBackgroundImageShape ( ) ;
      drawBackgroundColorShape ( ) ;
      drawBackShape ( ) ;
    }
/*
** Redrawing the color shape.
*/
    private function drawBackgroundColorShape ( ) : void
    {
      if ( application != null )
      {
// Reinitializing and positioning.
        backgroundColorShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        backgroundColorShape . x = 0 ;
        backgroundColorShape . y = 0 ;
        backgroundColorShape . setsr ( 0 ) ;
        backgroundColorShape . setswh ( getsw ( ) , getsh ( ) ) ;
        backgroundColorShape . setdb ( true ) ;
        backgroundColorShape . setdt ( 0 ) ;
// Redrawing the rectangle.
        backgroundColorShape . drawRect ( ) ;
      }
    }
/*
** Draws the back.
*/
    private function drawBackShape ( ) : void
    {
      if ( application != null )
      {
        backShape . x = 0 ;
        backShape . y = 0 ;
        backShape . graphics . clear ( ) ;
        backShape . graphics . lineStyle ( 0 , 0 , 0 ) ;
        backShape . graphics . beginFill ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 1 ) ;
        backShape . graphics . drawRect ( 0 , 0 , application . getsw ( ) , application . getsh ( ) ) ;
        backShape . graphics . endFill ( ) ;
      }
    }
/*
** Redrawing the image shape.
*/
    private function drawBackgroundImageShape ( ) : void
    {
      if ( application != null )
      {
// Drawing if it is possible. (stage and background bitmap data of the app object are needed.)
        if ( stage != null && application . getPropsDyn ( ) . getBitmapData ( ) != null )
        {
// The sizes of this background object can be used.
          swCorrected = getsw ( ) ;
          shCorrected = getsh ( ) ;
// If the background image can be moved..
          if ( canBackgroundMove ( ) )
          {
// than it is necessary to the sizes be corrected.
            swCorrected += application . getPropsApp ( ) . getLiveBackgroundMargin ( ) ;
            shCorrected += application . getPropsApp ( ) . getLiveBackgroundMargin ( ) ;
          }
// The alpha has to be the correct value.
          backgroundImageShape . alpha = application . getPropsDyn ( ) . getAppBackgroundAlpha ( ) ;
// Doing the bitmap filling according to the current background aligning.
          if ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 )
          {
            matrix = new Matrix ( ) ;
            tempWidth = application . getPropsDyn ( ) . getBitmapData ( ) . width ;
            tempHeight = application . getPropsDyn ( ) . getBitmapData ( ) . height ;
            if ( swCorrected < tempWidth )
            {
              tempHeight = Math . round ( swCorrected / tempWidth * tempHeight ) ;
              tempWidth = swCorrected ;
            }
            if ( shCorrected < tempHeight )
            {
              tempWidth = Math . round ( shCorrected / tempHeight * tempWidth ) ;
              tempHeight = shCorrected ;
            }
            matrix . scale ( tempWidth / application . getPropsDyn ( ) . getBitmapData ( ) . width , tempHeight / application . getPropsDyn ( ) . getBitmapData ( ) . height ) ;
            matrix . translate ( ( swCorrected - tempWidth ) / 2 , ( shCorrected - tempHeight ) / 2 ) ;
            backgroundImageShape . graphics . clear ( ) ;
            backgroundImageShape . graphics . beginBitmapFill ( application . getPropsDyn ( ) . getBitmapData ( ) , matrix , false , true ) ;
            backgroundImageShape . graphics . drawRect ( ( swCorrected - tempWidth ) / 2 , ( shCorrected - tempHeight ) / 2 , tempWidth , tempHeight ) ;
            backgroundImageShape . graphics . endFill ( ) ;
          }
          else if ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 )
          {
            matrix = new Matrix ( ) ;
            tempWidth = application . getPropsDyn ( ) . getBitmapData ( ) . width ;
            tempHeight = application . getPropsDyn ( ) . getBitmapData ( ) . height ;
            if ( swCorrected != tempWidth )
            {
              tempWidth = swCorrected ;
              tempHeight = Math . round ( swCorrected / application . getPropsDyn ( ) . getBitmapData ( ) . width * application . getPropsDyn ( ) . getBitmapData ( ) . height ) ;
            }
            if ( shCorrected > tempHeight )
            {
              tempHeight = shCorrected ;
              tempWidth = Math . round ( shCorrected / application . getPropsDyn ( ) . getBitmapData ( ) . height * application . getPropsDyn ( ) . getBitmapData ( ) . width ) ;
            }
            matrix . scale ( tempWidth / application . getPropsDyn ( ) . getBitmapData ( ) . width , tempHeight / application . getPropsDyn ( ) . getBitmapData ( ) . height ) ;
            matrix . translate ( ( swCorrected - tempWidth ) / 2 , ( shCorrected - tempHeight ) / 2 ) ;
            backgroundImageShape . graphics . clear ( ) ;
            backgroundImageShape . graphics . beginBitmapFill ( application . getPropsDyn ( ) . getBitmapData ( ) , matrix , false , true ) ;
            backgroundImageShape . graphics . drawRect ( ( swCorrected - tempWidth ) / 2 , ( shCorrected - tempHeight ) / 2 , tempWidth , tempHeight ) ;
            backgroundImageShape . graphics . endFill ( ) ;
          }
          else if ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) == application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 )
          {
            matrix = new Matrix ( ) ;
            matrix . translate ( ( swCorrected - application . getPropsDyn ( ) . getBitmapData ( ) . width ) / 2 , ( shCorrected - application . getPropsDyn ( ) . getBitmapData ( ) . height ) / 2 ) ;
            backgroundImageShape . graphics . clear ( ) ;
            backgroundImageShape . graphics . beginBitmapFill ( application . getPropsDyn ( ) . getBitmapData ( ) , matrix , false , true ) ;
            backgroundImageShape . graphics . drawRect ( ( swCorrected - application . getPropsDyn ( ) . getBitmapData ( ) . width ) / 2 , ( shCorrected - application . getPropsDyn ( ) . getBitmapData ( ) . height ) / 2 , application . getPropsDyn ( ) . getBitmapData ( ) . width , application . getPropsDyn ( ) . getBitmapData ( ) . height ) ;
            backgroundImageShape . graphics . endFill ( ) ;
          }
          else if ( application . getPropsDyn ( ) . getAppBackgroundAlign ( ) == application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC )
          {
            matrix = null ;
            backgroundImageShape . graphics . clear ( ) ;
            backgroundImageShape . graphics . beginBitmapFill ( application . getPropsDyn ( ) . getBitmapData ( ) , null , true , true ) ;
            backgroundImageShape . graphics . drawRect ( 0 , 0 , swCorrected , shCorrected ) ;
            backgroundImageShape . graphics . endFill ( ) ;
          }
          else
          {
// application . getPropsDyn ( ) . getAppBackgroundAlign ( ) == application . getTexts ( ) . BACKGROUND_ALIGN_NONE for example
            matrix = null ;
            backgroundImageShape . graphics . clear ( ) ;
          }
        }
      }
    }
/*
** Unregisters the positioning of the background image from the mouse move event.
*/
    private function unregisterMouseMoveFromBackgroundLive ( ) : void
    {
      if ( stage != null )
      {
// Removing this.
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , posBackgroundImageForBackgroundLive ) ;
// Positioning this to the 0 , 0.
        backgroundImageShape . x = 0 ;
        backgroundImageShape . y = 0 ;
      }
    }
/*
** Registers the positioning of the background image to the mouse move event.
*/
    private function registerMouseMoveForBackgroundLive ( ) : void
    {
      if ( stage != null )
      {
// Adding this.
        stage . addEventListener ( MouseEvent . MOUSE_MOVE , posBackgroundImageForBackgroundLive , false , 0 , true ) ;
// Repaint it for failsafe.
        backgroundRedraw ( ) ;
      }
    }
/*
** If the background image can be moved then this function has to be registered to the mouse move event.
*/
    private function posBackgroundImageForBackgroundLive ( e : MouseEvent ) : void
    {
      if ( stage != null )
      {
// Updating the target x and y coordinates: where the background image has to move.
// This target coordinate depends on the current position of the mouse.
        targetx = - application . getPropsApp ( ) . getLiveBackgroundMargin ( ) + int ( application . getPropsApp ( ) . getLiveBackgroundMargin ( ) * ( stage . mouseX / stage . stageWidth ) ) ;
        targety = - application . getPropsApp ( ) . getLiveBackgroundMargin ( ) + int ( application . getPropsApp ( ) . getLiveBackgroundMargin ( ) * ( stage . mouseY / stage . stageHeight ) ) ;
// The following of this target coordinate has to be happened continuously!
        registerEnterFrameForBackgroundLive ( ) ;
      }
    }
/*
** Registers the enterFrameBackgroundImageShapePos function to the enter frame event.
*/
    private function registerEnterFrameForBackgroundLive ( ) : void
    {
// Registers if it is not done.
      if ( ! hasEventListener ( Event . ENTER_FRAME ) )
      {
        addEventListener ( Event . ENTER_FRAME , enterFrameBackgroundImageShapePos ) ;
      }
    }
/*
** Unregisters the enterFrameBackgroundImageShapePos function from the enter frame event.
*/
    private function unregisterEnterFrameForBackgroundLive ( ) : void
    {
// Removes always.
      removeEventListener ( Event . ENTER_FRAME , enterFrameBackgroundImageShapePos ) ;
    }
/*
** This function is called by enter frame if it has been registered.
** Positions the background image into the correct position.
** (It depends on the targetx and targety set before in the posBackgroundImageForBackgroundLive.)
*/
    private function enterFrameBackgroundImageShapePos ( e : Event ) : void
    {
// The position of the image shape has to be the follows.
      backgroundImageShape . x += ( targetx - backgroundImageShape . x ) / application . getPropsApp ( ) . getWeightBackgroundPicture ( ) ;
      backgroundImageShape . y += ( targety - backgroundImageShape . y ) / application . getPropsApp ( ) . getWeightBackgroundPicture ( ) ;
// We should check the current and the target position in every frame.
// If the x or the y coordinate has reached the final corrdinate
      if ( Math . round ( backgroundImageShape . x ) == targetx && Math . round ( backgroundImageShape . y ) == targety )
      {
// Then this function has to be unregistered.
        unregisterEnterFrameForBackgroundLive ( ) ;
// And the position have to be the target coordinates.
        backgroundImageShape . x = targetx ;
        backgroundImageShape . y = targety ;
      }
    }
/*
** Destroying this object.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , posBackgroundImageForBackgroundLive ) ;
      }
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_IMAGE_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_ALIGN_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_ALPHA_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BLUR_CHANGED , backgroundImageChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_LIVE_CHANGED , backgroundLiveChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      backShape = null ;
      backgroundImageShape = null ;
      backgroundColorShape = null ;
      matrix = null ;
      tempWidth = 0 ;
      tempHeight = 0 ;
      targetx = 0 ;
      targety = 0 ;
      swCorrected = 0 ;
      shCorrected = 0 ;
      pixelStealing = false ;
    }
  }
}