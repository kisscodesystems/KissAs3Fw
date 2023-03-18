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
** Board.
** This is an object that can be drawn by hand.
** Can be used for example to sign by hand.
**
** MAIN FEATURES:
** - backgroundColor, line color and ttthickness can be specified
** - rubber and clear functions
** - the content of this can be used as a bytearray
** - can be resized
** - content can be loaded from outside
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseAlerter ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ColorPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Potmeter ;
  import com . kisscodesystems . KissAs3Fw . ui . Switcher ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . display . BitmapData ;
  import flash . display . PNGEncoderOptions ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . geom . Rectangle ;
  import flash . utils . ByteArray ;
  public class Board extends BaseAlerter
  {
// The actual behavior: can we draw or not.
    private var ableToDraw : Boolean = true ;
// The mouse down event can be happened on this objects.
    private const mouseDownHappenedResizer : String = "mouseDownHappenedResizer" ;
// The resizing of this board is possible or not
    private var resizeIsPossible : Boolean = true ;
// Is the content empty or not?
    private var contentIsEmpty : Boolean = true ;
// To be able to determine: the board is resized or not.
    private var prevMouseX : int = 0 ;
    private var prevMouseY : int = 0 ;
// The mouse down has happened in..
    private var mouseDownHappened : String = null ;
// The main frame of this board object
    private var frame : BaseShape = null ;
// The resizer of this board.
    private var resizer : BaseSprite = null ;
// The background of the drawable area
    private var drawnFrame : BaseShape = null ;
// The sprite to be drawn above the drawnFrame
    private var drawnContainer : BaseSprite = null ;
    private var drawnSprite : BaseSprite = null ;
    private var drawnMask : BaseSprite = null ;
// A label to name this board
    private var textLabel : TextLabel = null ;
// Drawing elements
    private var elements : BaseSprite = null ;
// Color of the background
    private var backgroundColorPicker : ColorPicker = null ;
// Color of the line to draw
    private var lineColorPicker : ColorPicker = null ;
// Thickness of the drawing
    private var lineThicknessPotmeter : Potmeter = null ;
// There will be a draw mode to switch into
    private var drawSwitcher : Switcher = null ;
// This clears all of the drawable area of this board
    private var clearButtonLink : ButtonLink = null ;
// To send the content of this board.
    private var byteArray : ByteArray = null ;
    private var bitmapData : BitmapData = null ;
// The event object to be dispatched when it is changed.
    private var eventChanged : Event = null ;
// The event object to be dispatched when it is cleared (by clear button).
    private var eventCleared : Event = null ;
// The drawing is currently in progress or not.
    private var drawingIsInProgress : Boolean = false ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Board ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The main frame
      frame = new BaseShape ( application ) ;
      addChild ( frame ) ;
      frame . setdb ( false ) ;
      frame . setdf ( false ) ;
      frame . setdt ( 1 ) ;
// This event will trigger the change of the selection to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
      eventCleared = new Event ( application . EVENT_CLEARED ) ;
// This is a resizer just like on the widget objects.
      resizer = new BaseSprite ( application ) ;
      addChild ( resizer ) ;
      resizer . addEventListener ( MouseEvent . MOUSE_DOWN , resizerMouseDown ) ;
// This is the background of the drawable area
      drawnFrame = new BaseShape ( application ) ;
      addChild ( drawnFrame ) ;
      drawnFrame . setdb ( false ) ;
      drawnFrame . setdf ( true ) ;
      drawnFrame . setdt ( 0 ) ;
// A text label to name this board
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
// This is a container first.
      elements = new BaseSprite ( application ) ;
      addChild ( elements ) ;
// The UI elements of drawing the main content
      backgroundColorPicker = new ColorPicker ( application ) ;
      elements . addChild ( backgroundColorPicker ) ;
      backgroundColorPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , backgroundColorPickerChanged ) ;
      backgroundColorPicker . setRGBColor ( application . BOARD_BACKGROUND_COLOR ) ;
      lineColorPicker = new ColorPicker ( application ) ;
      elements . addChild ( lineColorPicker ) ;
      lineColorPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , lineColorPickerChanged ) ;
      lineColorPicker . setRGBColor ( application . BOARD_LINE_COLOR ) ;
      lineThicknessPotmeter = new Potmeter ( application ) ;
      elements . addChild ( lineThicknessPotmeter ) ;
      lineThicknessPotmeter . setMinMaxIncValues ( application . BOARD_LINE_MINTHICKNESS , application . BOARD_LINE_MAXTHICKNESS , application . BOARD_LINE_INCTHICKNESS ) ;
      lineThicknessPotmeter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , lineThicknessPotmeterChanged ) ;
      lineThicknessPotmeter . setCurValue ( application . BOARD_LINE_THICKNESS ) ;
      drawSwitcher = new Switcher ( application ) ;
      elements . addChild ( drawSwitcher ) ;
      drawSwitcher . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , drawSwitcherChanged ) ;
      drawSwitcher . setUp ( true ) ;
      drawSwitcher . setIcons ( "drawer" , "rubber" ) ;
      clearButtonLink = new ButtonLink ( application ) ;
      elements . addChild ( clearButtonLink ) ;
      clearButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , clearButtonLinkClicked ) ;
      clearButtonLink . setEventDispatcherObjectToThis ( ) ;
      clearButtonLink . setIcon ( "clearer" ) ;
// And this is the object which can be drawable.
      drawnContainer = new BaseSprite ( application ) ;
      addChild ( drawnContainer ) ;
      drawnSprite = new BaseSprite ( application ) ;
      drawnContainer . addChild ( drawnSprite ) ;
      drawnSprite . addEventListener ( MouseEvent . MOUSE_DOWN , drawnSpriteMouseDown ) ;
      drawnMask = new BaseSprite ( application ) ;
      drawnContainer . addChild ( drawnMask ) ;
      drawnSprite . mask = drawnMask ;
// These have to be registered to keep up to date displaying according to the application level.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOX_CORNER_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOX_FRAME_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , insideElementsSizesChanged ) ;
// The object have to be listen only from now.
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
      backgroundColorPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
      lineColorPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
      lineThicknessPotmeter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
      drawSwitcher . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
      clearButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , insideElementsSizesChanged ) ;
// Initializes the drawable area.
      clearDrawnSprite ( ) ;
    }
/*
** If there is a bitmapdata object than it is necessary to clear before use or when destroying this whole thing.
*/
    private function destroyBitmapData ( ) : void
    {
      if ( bitmapData != null )
      {
        bitmapData . dispose ( ) ;
        bitmapData = null ;
      }
    }
/*
** Get the content of this canvas!
*/
    public function getCanvasBarr ( ) : ByteArray
    {
      destroyBitmapData ( ) ;
      bitmapData = new BitmapData ( drawnContainer . getsw ( ) , drawnContainer . getsh ( ) , true , 0 ) ;
      bitmapData . draw ( drawnFrame ) ;
      bitmapData . draw ( drawnContainer ) ;
      byteArray = new ByteArray ( ) ;
      bitmapData . encode ( new Rectangle ( 0 , 0 , drawnContainer . getsw ( ) , drawnContainer . getsh ( ) ) , new PNGEncoderOptions ( false ) , byteArray ) ;
      return byteArray ;
    }
    public function getCanvasWidth ( ) : int
    {
      if ( drawnContainer != null )
      {
        return drawnContainer . getsw ( ) ;
      }
      return 0 ;
    }
    public function getCanvasHeight ( ) : int
    {
      if ( drawnContainer != null )
      {
        return drawnContainer . getsh ( ) ;
      }
      return 0 ;
    }
/*
** This method will be called if the object is being added to the stage.
** A lot of initializing happens here because the stage is available
** from here.
*/
    override protected function addedToStage ( e : Event ) : void
    {
      super . addedToStage ( e ) ;
// Listens to the mouse up on stage.
      stage . addEventListener ( MouseEvent . MOUSE_UP , stageMouseUp , false , 0 , true ) ;
    }
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      super . removedFromStage ( e ) ;
    }
/*
** Event listeners to get colors and others working.
*/
    private function dispatchEventChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
    }
    private function dispatchEventCleared ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventCleared ) ;
      }
    }
    private function backgroundColorPickerChanged ( e : Event ) : void
    {
      redrawDrawnFrame ( ) ;
      dispatchEventChanged ( ) ;
    }
    private function lineColorPickerChanged ( e : Event ) : void
    {
      setLineStyle ( true ) ;
      setDraw ( true ) ;
    }
    private function lineThicknessPotmeterChanged ( e : Event ) : void
    {
      if ( drawSwitcher != null )
      {
        setLineStyle ( drawSwitcher . getUp ( ) ) ;
      }
    }
    private function drawSwitcherChanged ( e : Event ) : void
    {
      if ( drawSwitcher != null )
      {
        setLineStyle ( drawSwitcher . getUp ( ) ) ;
      }
    }
    private function setLineStyle ( useLineColor : Boolean ) : void
    {
      if ( drawnSprite != null && lineThicknessPotmeter != null && lineColorPicker != null )
      {
        drawnSprite . graphics . lineStyle ( ( useLineColor ? 1 : 5 ) * lineThicknessPotmeter . getCurValue ( ) , Number ( application . COLOR_HEX_TO_NUMBER_STRING + ( useLineColor ? lineColorPicker . getRGBColor ( ) : backgroundColorPicker . getRGBColor ( ) ) ) , 1 , true ) ;
      }
    }
/*
** Set stuff from outside.
*/
    public function setLabel ( s : String ) : void
    {
      if ( textLabel != null && s != null )
      {
        textLabel . setTextCode ( s ) ;
      }
    }
/*
** The properties of the background.
*/
    public function setBackgroundEnabled ( e : Boolean ) : void
    {
      if ( backgroundColorPicker != null )
      {
        backgroundColorPicker . setEnabled ( e ) ;
      }
    }
    public function setBackgroundRGBColor ( c : String ) : void
    {
      if ( contentIsEmpty && backgroundColorPicker != null )
      {
        backgroundColorPicker . setRGBColor ( c ) ;
      }
    }
    public function getBackgroundRGBColor ( ) : String
    {
      if ( backgroundColorPicker != null )
      {
        return backgroundColorPicker . getRGBColor ( ) ;
      }
      return "" ;
    }
/*
** The properties of the drawing.
*/
    public function setLineEnabled ( e : Boolean ) : void
    {
      if ( lineColorPicker != null )
      {
        lineColorPicker . setEnabled ( e ) ;
      }
    }
    public function setLineRGBColor ( c : String ) : void
    {
      if ( lineColorPicker != null )
      {
        lineColorPicker . setRGBColor ( c ) ;
      }
    }
    public function getLineRGBColor ( ) : String
    {
      if ( lineColorPicker != null )
      {
        return lineColorPicker . getRGBColor ( ) ;
      }
      return "" ;
    }
/*
** The properties of the line ttthickness.
*/
    public function setLineThicknessEnabled ( e : Boolean ) : void
    {
      if ( lineThicknessPotmeter != null )
      {
        lineThicknessPotmeter . setEnabled ( e ) ;
      }
    }
    public function setLineThickness ( i : int ) : void
    {
      if ( lineThicknessPotmeter != null )
      {
        lineThicknessPotmeter . setCurValue ( i ) ;
      }
    }
    public function getLineThickness ( ) : int
    {
      if ( lineThicknessPotmeter != null )
      {
        return lineThicknessPotmeter . getCurValue ( ) ;
      }
      return 1 ;
    }
/*
** The drawing / drawing modes.
*/
    public function setDrawEnabled ( e : Boolean ) : void
    {
      if ( drawSwitcher != null )
      {
        drawSwitcher . setEnabled ( e ) ;
      }
    }
    public function setDraw ( b : Boolean ) : void
    {
      if ( drawSwitcher != null )
      {
        drawSwitcher . setUp ( b ) ;
      }
    }
    public function getDraw ( ) : Boolean
    {
      if ( drawSwitcher != null )
      {
        return drawSwitcher . getUp ( ) ;
      }
      return false ;
    }
/*
** Clear link
*/
    public function clearButtonLinkClicked ( e : Event ) : void
    {
      doClear ( true ) ;
    }
    public function setClearEnabled ( e : Boolean ) : void
    {
      if ( clearButtonLink != null )
      {
        clearButtonLink . setEnabled ( e ) ;
      }
    }
    public function clear ( ) : void
    {
      doClear ( false ) ;
    }
    public function isContentEmpty ( ) : Boolean
    {
      return contentIsEmpty ;
    }
/*
** Sets enabled or disabled.
*/
    override public function setEnabled ( b : Boolean ) : void
    {
      super . setEnabled ( b ) ;
      setBackgroundEnabled ( b ) ;
      setLineEnabled ( b ) ;
      setLineThicknessEnabled ( b ) ;
      setDrawEnabled ( b ) ;
      setClearEnabled ( b ) ;
      ableToDraw = b ;
    }
/*
** Clears the content of the drawing,
** can display a dialog before delete.
*/
    private function doClear ( displayAlert : Boolean ) : void
    {
      if ( displayAlert )
      {
        if ( ! contentIsEmpty )
        {
          confirmOK = function ( ) : void
          {
            theClear ( ) ;
          }
          confirmCancel = function ( ) : void { }
          showConfirm ( application . getTexts ( ) . REALLY_WANT_TO_CLEAR_DRAWN_CONTENT ) ;
        }
      }
      else
      {
        theClear ( ) ;
      }
    }
    private function theClear ( ) : void
    {
      clearDrawnSprite ( ) ;
      if ( drawSwitcher != null )
      {
        if ( drawSwitcher . getEnabled ( ) )
        {
          drawSwitcher . setUp ( true ) ;
        }
      }
      if ( ! contentIsEmpty )
      {
        setBackgroundEnabled ( true ) ;
      }
      contentIsEmpty = true ;
      dispatchEventChanged ( ) ;
      dispatchEventCleared ( ) ;
    }
/*
** Grabs the board on the resizer area.
*/
    private function resizerMouseDown ( e : MouseEvent ) : void
    {
      if ( resizeIsPossible && contentIsEmpty )
      {
        mouseDownHappened = mouseDownHappenedResizer ;
        prevMouseX = mouseX ;
        prevMouseY = mouseY ;
        addEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
      }
    }
/*
** Updates the resizer to see the new size of this board.
** Not needed to register into the line ttthickness changing.
*/
    private function enterFrameUpdateResizer ( e : Event ) : void
    {
      if ( resizer != null )
      {
        resizer . graphics . clear ( ) ;
        resizer . graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getResizeMargin ( ) , - application . getPropsApp ( ) . getResizeMargin ( ) , getsw ( ) + mouseX - prevMouseX + 2 * application . getPropsApp ( ) . getResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) , getsh ( ) + mouseY - prevMouseY + 2 * application . getPropsApp ( ) . getResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      }
    }
/*
** Clears just the resizer.
** super . getsh! this is the way to work properly in hidden state.
*/
    private function clearResizer ( ) : void
    {
      if ( resizer != null )
      {
        resizer . graphics . clear ( ) ;
        resizer . graphics . beginFill ( 0 , 0 ) ;
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getResizeMargin ( ) , - application . getPropsApp ( ) . getResizeMargin ( ) , getsw ( ) + 2 * application . getPropsApp ( ) . getResizeMargin ( ) , super . getsh ( ) + 2 * application . getPropsApp ( ) . getResizeMargin ( ) ) ;
        resizer . graphics . endFill ( ) ;
        resizer . setcxy ( 0 , 0 ) ;
        resizer . setswh ( super . getsw ( ) , super . getsh ( ) ) ;
      }
    }
/*
** These are base shapes so the parameters must pass again to repaint them.
*/
    private function redrawShapes ( e : Event = null ) : void
    {
      if ( frame != null && textLabel != null )
      {
        frame . setcccac ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) , ( application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) + ( 1 - application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) ) * 3 / 4 ) , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
        frame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        frame . drawRect ( ) ;
      }
      redrawDrawnFrame ( ) ;
    }
/*
** When it is necessary the paint only the bachground.
*/
    private function redrawDrawnFrame ( ) : void
    {
      if ( drawnFrame != null && textLabel != null && backgroundColorPicker != null )
      {
        drawnFrame . setcccac ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + backgroundColorPicker . getRGBColor ( ) ) , Number ( application . COLOR_HEX_TO_NUMBER_STRING + backgroundColorPicker . getRGBColor ( ) ) , Number ( application . COLOR_HEX_TO_NUMBER_STRING + backgroundColorPicker . getRGBColor ( ) ) , 1 , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
        drawnFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        drawnFrame . setsb ( application . getPropsDyn ( ) . getAppBoxCorner ( ) , application . getPropsDyn ( ) . getAppBoxFrame ( ) ) ;
        drawnFrame . drawRect ( ) ;
      }
    }
/*
** The size of this board can be modified from outside.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( contentIsEmpty && getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        resizeReposAll ( ) ;
        dispatchEventChanged ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( contentIsEmpty && getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        resizeReposAll ( ) ;
        dispatchEventChanged ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( contentIsEmpty && ( getsw ( ) != newsw || getsh ( ) != newsh ) )
      {
        super . setswh ( newsw , newsh ) ;
        resizeReposAll ( ) ;
        dispatchEventChanged ( ) ;
      }
    }
/*
** The size of this board can be modified from outside.
*/
    public function setswhContent ( newsw : int , newsh : int ) : void
    {
      if ( contentIsEmpty && ( getswContent ( ) != newsw || getshContent ( ) != newsh ) )
      {
        if ( drawnFrame != null )
        {
          drawnFrame . setswh ( newsw , newsh ) ;
          clearDrawnSprite ( ) ;
        }
        insideElementsSizesChanged ( null ) ;
        dispatchEventChanged ( ) ;
      }
    }
    public function getswContent ( ) : int
    {
      if ( drawnFrame != null )
      {
        return drawnFrame . getsw ( ) ;
      }
      return 0 ;
    }
    public function getshContent ( ) : int
    {
      if ( drawnFrame != null )
      {
        return drawnFrame . getsh ( ) ;
      }
      return 0 ;
    }
/*
** Repos and resize all.
** This is when the resizing is from outside! setsw setsh setswh
** In this cases, the size of the drawable area can be changed.
** That is a different case when the font size or padding is changed.
** The drawable area should not be modofied but the sizes of other
** objects can be changed at this time.
*/
    private function resizeReposAll ( e : Event = null ) : void
    {
      if ( frame != null )
      {
        frame . setswh ( getsw ( ) , getsh ( ) ) ;
        frame . x = 0 ;
        frame . y = 0 ;
        if ( textLabel != null )
        {
          textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
          if ( backgroundColorPicker != null )
          {
            backgroundColorPicker . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , textLabel . getcyshap ( ) ) ;
            if ( lineColorPicker != null )
            {
              lineColorPicker . setcxy ( backgroundColorPicker . getcxsw ( ) , backgroundColorPicker . getcy ( ) ) ;
              if ( lineThicknessPotmeter != null )
              {
                lineThicknessPotmeter . setcxy ( lineColorPicker . getcxsw ( ) , lineColorPicker . getcy ( ) ) ;
                if ( drawSwitcher != null )
                {
                  drawSwitcher . setcxy ( lineThicknessPotmeter . getcxsw ( ) , lineThicknessPotmeter . getcy ( ) ) ;
                  if ( clearButtonLink != null )
                  {
                    clearButtonLink . setcxy ( drawSwitcher . getcxsw ( ) , drawSwitcher . getcy ( ) ) ;
                  }
                }
              }
            }
            if ( drawnFrame != null )
            {
              drawnFrame . x = application . getPropsDyn ( ) . getAppPadding ( ) ;
              drawnFrame . y = backgroundColorPicker . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
              drawnFrame . setswh ( getsw ( ) - 2 * drawnFrame . x , getsh ( ) - drawnFrame . y - application . getPropsDyn ( ) . getAppPadding ( ) ) ;
              if ( drawnContainer != null )
              {
                drawnContainer . setcxy ( drawnFrame . x , drawnFrame . y ) ;
                clearDrawnSprite ( ) ;
              }
            }
          }
        }
      }
      clearResizer ( ) ;
      redrawShapes ( ) ;
    }
/*
** Clears and reinitialize the drawnContent.
*/
    private function clearDrawnSprite ( ) : void
    {
      if ( drawnContainer != null && drawnSprite != null && drawnMask != null && drawnFrame != null )
      {
        drawnContainer . setswh ( drawnFrame . getsw ( ) , drawnFrame . getsh ( ) ) ;
        drawnSprite . setswh ( drawnFrame . getsw ( ) , drawnFrame . getsh ( ) ) ;
        drawnSprite . graphics . clear ( ) ;
        drawnSprite . graphics . beginFill ( 0 , 0 ) ;
        drawnSprite . graphics . drawRect ( 0 , 0 , drawnFrame . getsw ( ) , drawnFrame . getsh ( ) ) ;
        drawnSprite . graphics . endFill ( ) ;
        drawnMask . setswh ( drawnFrame . getsw ( ) , drawnFrame . getsh ( ) ) ;
        drawnMask . graphics . clear ( ) ;
        drawnMask . graphics . beginFill ( 0 , 0 ) ;
        drawnMask . graphics . drawRect ( application . BOARD_PADDING , application . BOARD_PADDING , drawnFrame . getsw ( ) - 2 * application . BOARD_PADDING , drawnFrame . getsh ( ) - 2 * application . BOARD_PADDING ) ;
        drawnMask . graphics . endFill ( ) ;
      }
      setLineStyle ( true ) ;
    }
/*
** Repos and resize all.
** But, instead of the above logic, this is called when the inside elements change their sizes.
*/
    private function insideElementsSizesChanged ( e : Event = null ) : void
    {
      if ( textLabel != null )
      {
        textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        if ( backgroundColorPicker != null )
        {
          backgroundColorPicker . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , textLabel . getcyshap ( ) ) ;
          if ( lineColorPicker != null )
          {
            lineColorPicker . setcxy ( backgroundColorPicker . getcxsw ( ) , backgroundColorPicker . getcy ( ) ) ;
            if ( lineThicknessPotmeter != null )
            {
              lineThicknessPotmeter . setcxy ( lineColorPicker . getcxsw ( ) , lineColorPicker . getcy ( ) ) ;
              if ( drawSwitcher != null )
              {
                drawSwitcher . setcxy ( lineThicknessPotmeter . getcxsw ( ) , lineThicknessPotmeter . getcy ( ) ) ;
                if ( clearButtonLink != null )
                {
                  clearButtonLink . setcxy ( drawSwitcher . getcxsw ( ) , drawSwitcher . getcy ( ) ) ;
                  var maxh : int = 0 ;
                  if ( backgroundColorPicker . getsh ( ) > maxh )
                  {
                    maxh = backgroundColorPicker . getcyshap ( ) ;
                  }
                  if ( lineColorPicker . getsh ( ) > maxh )
                  {
                    maxh = lineColorPicker . getcyshap ( ) ;
                  }
                  if ( lineThicknessPotmeter . getsh ( ) > maxh )
                  {
                    maxh = lineThicknessPotmeter . getcyshap ( ) ;
                  }
                  if ( drawSwitcher . getsh ( ) > maxh )
                  {
                    maxh = drawSwitcher . getcyshap ( ) ;
                  }
                  if ( clearButtonLink . getsh ( ) > maxh )
                  {
                    maxh = clearButtonLink . getcyshap ( ) ;
                  }
                  if ( drawnFrame != null )
                  {
                    drawnFrame . x = application . getPropsDyn ( ) . getAppPadding ( ) ;
                    if ( drawnContainer != null )
                    {
                      drawnFrame . y = maxh ;
                      drawnContainer . setcxy ( drawnFrame . x , drawnFrame . y ) ;
                      super . setswh ( Math . max ( clearButtonLink . getcxswap ( ) , drawnContainer . getcxswap ( ) ) , drawnContainer . getcyshap ( ) ) ;
                    }
                  }
                }
              }
            }
          }
        }
      }
      if ( frame != null )
      {
        frame . setswh ( getsw ( ) , getsh ( ) ) ;
        frame . x = 0 ;
        frame . y = 0 ;
      }
      clearResizer ( ) ;
      redrawShapes ( ) ;
    }
/*
** Draw starting and finishing.
*/
    private function drawnSpriteMouseDown ( e : MouseEvent ) : void
    {
      if ( ableToDraw )
      {
        startDraw ( ) ;
      }
    }
    private function startDraw ( ) : void
    {
      if ( drawnSprite != null )
      {
        drawingIsInProgress = true ;
        contentIsEmpty = false ;
        setBackgroundEnabled ( false ) ;
        drawnSprite . graphics . moveTo ( drawnSprite . mouseX , drawnSprite . mouseY ) ;
        addEventListener ( Event . ENTER_FRAME , drawing ) ;
      }
    }
    private function drawing ( e : Event ) : void
    {
      if ( drawnSprite != null )
      {
        drawnSprite . graphics . lineTo ( drawnSprite . mouseX , drawnSprite . mouseY ) ;
      }
    }
    private function stopDraw ( ) : void
    {
      removeEventListener ( Event . ENTER_FRAME , drawing ) ;
      dispatchEventChanged ( ) ;
      drawingIsInProgress = false ;
    }
/*
** When the mouse is up on stage.
*/
    private function stageMouseUp ( e : MouseEvent ) : void
    {
      if ( mouseDownHappened == mouseDownHappenedResizer )
      {
        mouseDownHappened = "" ;
        removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
        if ( mouseX != prevMouseX || mouseY != prevMouseY )
        {
          if ( clearButtonLink != null )
          {
            setswh ( Math . max ( getsw ( ) + mouseX - prevMouseX , clearButtonLink . getcxswap ( ) ) , Math . max ( getsh ( ) + mouseY - prevMouseY , 4 * clearButtonLink . getsh ( ) ) ) ;
          }
          else
          {
            setswh ( Math . max ( getsw ( ) + mouseX - prevMouseX ) , Math . max ( getsh ( ) + mouseY - prevMouseY ) ) ;
          }
        }
        clearResizer ( ) ;
        prevMouseX = 0 ;
        prevMouseY = 0 ;
      }
      if ( drawingIsInProgress )
      {
        stopDraw ( ) ;
      }
    }
/*
** Destroy
*/
    override public function destroy ( ) : void
    {
      if ( resizer != null )
      {
        resizer . removeEventListener ( MouseEvent . MOUSE_DOWN , resizerMouseDown ) ;
      }
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
      removeEventListener ( Event . ENTER_FRAME , drawing ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BOX_CORNER_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BOX_FRAME_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , insideElementsSizesChanged ) ;
      destroyBitmapData ( ) ;
      super . destroy ( ) ;
      ableToDraw = false ;
      resizeIsPossible = false ;
      contentIsEmpty = false ;
      prevMouseX = 0 ;
      prevMouseY = 0 ;
      mouseDownHappened = null ;
      frame = null ;
      resizer = null ;
      drawnFrame = null ;
      drawnContainer = null ;
      drawnSprite = null ;
      drawnMask = null ;
      textLabel = null ;
      elements = null ;
      backgroundColorPicker = null ;
      lineColorPicker = null ;
      lineThicknessPotmeter = null ;
      drawSwitcher = null ;
      clearButtonLink = null ;
      confirmOK = null ;
      confirmCancel = null ;
      byteArray = null ;
      bitmapData = null ;
    }
  }
}
