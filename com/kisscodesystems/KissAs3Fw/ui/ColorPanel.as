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
** ColorPanel.
** Coloring panel actually.
** Can be used standalone but usually it appears in the ColorPicker.
**
** MAIN FEATURES:
** - actual and default colors.
** - commit of the actual color to default color.
** - set color from outside: setRGBColor ( string )
** - set color by RGB code from the text input
** - set color from any pixel of the stage
** - set color from the prepared color squares
** - set color from the colored rectangle: ffffff - actual_color - 000000
** - calculates the complementer of the temp color
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . TextInput ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . display . Bitmap ;
  import flash . display . BitmapData ;
  import flash . display . GradientType ;
  import flash . events . Event ;
  import flash . events . FocusEvent ;
  import flash . events . KeyboardEvent ;
  import flash . events . MouseEvent ;
  import flash . geom . Matrix ;
  import flash . ui . Keyboard ;
  public class ColorPanel extends BaseSprite
  {
// The input text what accepts the rgb color from the keyboard.
    private var inputRgb : TextInput = null ;
// To make the actual color as the default color.
    private var acceptNewColorButton : ButtonText = null ;
// This is the sprite that is clickable and colored by ffffff - actual_color - 000000
    private var drawnCustomSprite : BaseSprite = null ;
// The array containing the colors of the above.
    private var drawnColorArray : Array = null ;
// This also helps to the coloring of the above.
    private var drawnMatrix : Matrix = null ;
// The bitmap and bitmapdata objects to draw the drawn sprite.
    private var drawnBitmapData : BitmapData = null ;
    private var drawnBitmap : Bitmap = null ;
// The complementer properties.
    private var drawn2CustomSprite : BaseSprite = null ;
    private var drawn2ColorArray : Array = null ;
    private var drawn2Matrix : Matrix = null ;
    private var drawn2BitmapData : BitmapData = null ;
    private var drawn2Bitmap : Bitmap = null ;
// The size of this.
    private var drawnWidth : int = 0 ;
    private var drawnHeight : int = 0 ;
// The colored sprite of the actual color.
    private var panelColorActual : BaseSprite = null ;
// Displays the complementer color of the actual color.
    private var panelColorComplementer : BaseSprite = null ;
// The colored sprite of the default color.
    private var panelColorDefault : BaseSprite = null ;
// This bitmapdata will be used when this object want to get a pixel from a satge.
    private var stealPixelBitmapData : BitmapData = null ;
// The background of the below.
    private var stealPixelSprite : BaseSprite = null ;
// Shows the rgb code of the pixel where the mouse is currently point into.
    private var stealPixelColorText : TextLabel = null ;
// What is the margin size between the mouse pointer and the rgb displaying.
    private var colorStealTextCDelta : int = 0 ;
// The array of the colored squares. (references to BaseSprite objects)
    private var squareArray : Array = null ;
// The size of the squares.
    private var squareWidth : int = 0 ;
// The variables help to create the base of the panel (creating the colored squares)
    private var mx : int = 0 ;
    private var my : int = 0 ;
    private var st1 : int = 0 ;
    private var st2 : int = 0 ;
    private var st3 : int = 0 ;
    private var rr : String = null ;
    private var gg : String = null ;
    private var bb : String = null ;
    private var r : int = 0 ;
    private var g : int = 0 ;
    private var b : int = 0 ;
    private var startSquaresX : int = 0 ;
    private var startSquaresY : int = 0 ;
// The color of the actual color (in number format)
    private var tempColorNumber : Number = 0 ;
// The complementer color has to be known.
    private var compColorNumber : Number = 0xffffff ;
// The index which square has to be marked.
    private var markedSquareIndex : int = 0 ;
// This event will be changed after the changing of the default color of this Color object.
    private var eventChanged : Event = null ;
// The color stealing events (start, stop)
    private var eventColorStealFromStageStart : Event = null ;
    private var eventColorStealFromStageStop : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ColorPanel ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The default color has been changed, this message goes to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// To be able to dispatch these to the outside world (fe. PanelSettings)
      eventColorStealFromStageStart = new Event ( application . EVENT_COLOR_STEAL_FROM_STAGE_START ) ;
      eventColorStealFromStageStop = new Event ( application . EVENT_COLOR_STEAL_FROM_STAGE_STOP ) ;
// This is the index of the marked square: 0 by default.
      markedSquareIndex = 0 ;
// Sets these to the default zero value.
      setValue ( application . COLOR_RGB_INPUT_ZEROS ) ;
      setRGBColor ( application . COLOR_RGB_INPUT_ZEROS ) ;
// This bitmapdata has to be this default bidmap data.
      stealPixelBitmapData = new BitmapData ( 1 , 1 ) ;
// Now creating the content.
      createContentSingle ( ) ;
// Registering into these changes of the application itself.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
    }
/*
** Owerwriting the removedFromStage.
*/
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , getColorFromStage ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove ) ;
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp ) ;
      }
      super . removedFromStage ( e ) ;
    }
/*
** The line thickness has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
      createContentSingle ( ) ;
    }
/*
** The radius has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
      createContentSingle ( ) ;
    }
/*
** Override this: every clickable object has to be changed at this time.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      setOrClearAllListeners ( ) ;
    }
/*
** Sets or clears the listeners according to the value of the enabled property.
*/
    private function setOrClearAllListeners ( ) : void
    {
      if ( acceptNewColorButton != null )
      {
        acceptNewColorButton . setEnabled ( getEnabled ( ) ) ;
      }
      if ( inputRgb != null )
      {
        inputRgb . setEnabled ( getEnabled ( ) ) ;
      }
      if ( panelColorActual != null )
      {
        if ( getEnabled ( ) )
        {
          panelColorActual . addEventListener ( MouseEvent . MOUSE_DOWN , stealPixel ) ;
        }
        else
        {
          panelColorActual . removeEventListener ( MouseEvent . MOUSE_DOWN , stealPixel ) ;
        }
      }
      if ( panelColorComplementer != null )
      {
        if ( getEnabled ( ) )
        {
          panelColorComplementer . addEventListener ( MouseEvent . MOUSE_DOWN , setComplementerToTemp ) ;
          panelColorComplementer . addEventListener ( MouseEvent . MOUSE_OVER , displayCompColor ) ;
          panelColorComplementer . addEventListener ( MouseEvent . MOUSE_OUT , displayTempColor ) ;
        }
        else
        {
          panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_DOWN , setComplementerToTemp ) ;
          panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_OVER , displayCompColor ) ;
          panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_OUT , displayTempColor ) ;
        }
      }
      if ( panelColorDefault != null )
      {
        if ( getEnabled ( ) )
        {
          panelColorDefault . addEventListener ( MouseEvent . CLICK , setDefaultColor ) ;
        }
        else
        {
          panelColorDefault . removeEventListener ( MouseEvent . CLICK , setDefaultColor ) ;
        }
      }
      if ( drawnCustomSprite != null )
      {
        if ( getEnabled ( ) )
        {
          drawnCustomSprite . addEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
          drawnCustomSprite . addEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
          drawnCustomSprite . addEventListener ( MouseEvent . DOUBLE_CLICK , drawnCustomSpriteDoubleClick ) ;
        }
        else
        {
          drawnCustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
          drawnCustomSprite . removeEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
          drawnCustomSprite . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawnCustomSpriteDoubleClick ) ;
        }
      }
      if ( drawn2CustomSprite != null )
      {
        if ( getEnabled ( ) )
        {
          drawn2CustomSprite . addEventListener ( MouseEvent . MOUSE_DOWN , update2BitmapColor ) ;
        }
        else
        {
          drawn2CustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , update2BitmapColor ) ;
        }
      }
      if ( squareArray != null )
      {
        var i : int = 0 ;
        if ( getEnabled ( ) )
        {
          for ( i = 0 ; i < squareArray . length ; i ++ )
          {
            if ( squareArray [ i ] is BaseSprite )
            {
              BaseSprite ( squareArray [ i ] ) . addEventListener ( MouseEvent . MOUSE_DOWN , drawSquareMouseDown ) ;
              BaseSprite ( squareArray [ i ] ) . addEventListener ( MouseEvent . MOUSE_OVER , drawSquareOver ) ;
              BaseSprite ( squareArray [ i ] ) . addEventListener ( MouseEvent . MOUSE_OUT , drawSquareOut ) ;
              BaseSprite ( squareArray [ i ] ) . addEventListener ( MouseEvent . DOUBLE_CLICK , drawSquareDoubleClick ) ;
            }
          }
        }
        else
        {
          for ( i = 0 ; i < squareArray . length ; i ++ )
          {
            if ( squareArray [ i ] is BaseSprite )
            {
              BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_DOWN , drawSquareMouseDown ) ;
              BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OVER , drawSquareOver ) ;
              BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OUT , drawSquareOut ) ;
              BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawSquareDoubleClick ) ;
            }
          }
        }
      }
    }
/*
** The set size methods have to have no effects.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Creating the content of the whole panel:
** - color default
** - color actual
** - rgb input textfield
** - OK button to accept the temp color
** - color squares
** - drawn bitmap according to the temp color.
*/
    private function createContentSingle ( ) : void
    {
      if ( application != null )
      {
        squareWidth = int ( application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) * 2 / 3 ) ;
        super . setsw ( 19 * squareWidth ) ;
        drawnWidth = 19 * squareWidth ;
        drawnHeight = squareWidth ;
        if ( drawnColorArray != null )
        {
          drawnColorArray . splice ( 0 ) ;
          drawnColorArray = null ;
        }
        drawnColorArray = new Array ( 3 ) ;
        drawnMatrix = null ;
        drawnMatrix = new Matrix ( ) ;
        drawnMatrix . createGradientBox ( drawnWidth , drawnHeight , Math . PI , 0 , 0 ) ;
        if ( drawn2ColorArray != null )
        {
          drawn2ColorArray . splice ( 0 ) ;
          drawn2ColorArray = null ;
        }
        drawn2ColorArray = new Array ( 3 ) ;
        drawn2Matrix = null ;
        drawn2Matrix = new Matrix ( ) ;
        drawn2Matrix . createGradientBox ( drawnWidth , drawnHeight , Math . PI , 0 , 0 ) ;
        colorStealTextCDelta = squareWidth ;
        startSquaresX = squareWidth ;
        if ( acceptNewColorButton == null )
        {
          acceptNewColorButton = new ButtonText ( application ) ;
          addChild ( acceptNewColorButton ) ;
          acceptNewColorButton . setTextCode ( application . getTexts ( ) . OC_OK ) ;
          acceptNewColorButton . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , acceptNewColorButtonPressed ) ;
          acceptNewColorButton . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , acceptNewColorButtonResized ) ;
        }
        if ( acceptNewColorButton != null )
        {
          acceptNewColorButton . setcxy ( getsw ( ) - acceptNewColorButton . getsw ( ) , 0 ) ;
          super . setsh ( 14 * squareWidth + acceptNewColorButton . getsh ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ) ;
        }
        else
        {
          super . setsh ( 14 * squareWidth ) ;
        }
        startSquaresY = squareWidth + acceptNewColorButton . getcysh ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ;
        if ( panelColorActual == null )
        {
          panelColorActual = new BaseSprite ( application ) ;
          addChild ( panelColorActual ) ;
        }
        if ( panelColorActual != null && acceptNewColorButton != null )
        {
          panelColorActual . setswh ( acceptNewColorButton . getsw ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , acceptNewColorButton . getsh ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
          panelColorActual . setcxy ( 0 , acceptNewColorButton . getcy ( ) ) ;
        }
        if ( panelColorDefault == null )
        {
          panelColorDefault = new BaseSprite ( application ) ;
          addChild ( panelColorDefault ) ;
          panelColorDefault . mouseEnabled = true ;
        }
        if ( panelColorDefault != null && panelColorActual != null )
        {
          panelColorDefault . setswh ( panelColorActual . getsw ( ) , int ( panelColorActual . getsh ( ) / 2 ) ) ;
          panelColorDefault . setcxy ( panelColorActual . getcx ( ) , panelColorActual . getcy ( ) ) ;
        }
        if ( panelColorComplementer == null )
        {
          panelColorComplementer = new BaseSprite ( application ) ;
          addChild ( panelColorComplementer ) ;
        }
        if ( panelColorComplementer != null && panelColorActual != null )
        {
          panelColorComplementer . setswh ( int ( panelColorActual . getsw ( ) / 2 ) , int ( panelColorActual . getsh ( ) / 2 ) ) ;
          panelColorComplementer . setcxy ( panelColorActual . getcx ( ) + panelColorActual . getsw ( ) / 2 - application . getPropsDyn ( ) . getAppLineThickness ( ) , panelColorActual . getcy ( ) + panelColorActual . getsh ( ) * 1 / 3 ) ;
        }
        displayTempAndCompColor ( tempColorNumber ) ;
        displayDefaultColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getValue ( ) ) ) ;
        if ( inputRgb == null )
        {
          inputRgb = new TextInput ( application ) ;
          addChild ( inputRgb ) ;
          inputRgb . addEventListener ( Event . CHANGE , onChangeInputRgbText ) ;
          inputRgb . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , inputRgbChanged ) ;
          inputRgb . setMaxChars ( application . COLOR_MAX_CHARS_RGB_INPUT ) ;
          inputRgb . setRestrict ( application . TEXT_ENABLED_CHARS_HEX ) ;
        }
        if ( inputRgb != null )
        {
          inputRgb . setcxy ( panelColorDefault . getcxsw ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , acceptNewColorButton . getcy ( ) ) ;
          inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
          if ( panelColorDefault != null && acceptNewColorButton != null )
          {
            inputRgb . setsw ( getsw ( ) - panelColorDefault . getsw ( ) - acceptNewColorButton . getsw ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ) ;
          }
        }
        removeAllSquares ( ) ;
        squareArray = new Array ( ) ;
        mx = 0 ;
        my = 0 ;
        st1 = 0 ;
        st2 = 0 ;
        st3 = 0 ;
        rr = "" ;
        gg = "" ;
        bb = "" ;
        for ( var k : int = 1 ; k <= 6 ; k ++ )
        {
          for ( var i : int = 1 ; i <= 6 ; i ++ )
          {
            for ( var j : int = 1 ; j <= 6 ; j ++ )
            {
              if ( st1 == 12 )
              {
                rr = "CC" ;
              }
              else if ( st1 == 15 )
              {
                rr = "FF" ;
              }
              else
              {
                rr = st1 + "" + st1 ;
              }
              if ( st2 == 12 )
              {
                gg = "CC" ;
              }
              else if ( st2 == 15 )
              {
                gg = "FF" ;
              }
              else
              {
                gg = st2 + "" + st2 ;
              }
              if ( st3 == 12 )
              {
                bb = "CC" ;
              }
              else if ( st3 == 15 )
              {
                bb = "FF" ;
              }
              else
              {
                bb = st3 + "" + st3 ;
              }
              squareArray [ squareArray . length ] = new BaseSprite ( application ) ;
              addChild ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
              BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setswh ( squareWidth , squareWidth ) ;
              createSquare ( rr + gg + bb , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
              BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setcxy ( mx + startSquaresX , st1 >= 9 ? my + 6 * squareWidth + startSquaresY : my + startSquaresY ) ;
              my += squareWidth ;
              st3 += 3 ;
            }
            my = 0 ;
            mx += squareWidth ;
            st3 = 0 ;
            st2 += 3 ;
          }
          st3 = 0 ;
          st2 = 0 ;
          st1 += 3 ;
          if ( st1 == 9 )
          {
            mx = 0 ;
          }
        }
        r = 0 ;
        g = 0 ;
        b = 0 ;
        for ( var l : int = 1 ; l <= 12 ; l ++ )
        {
          if ( l <= 6 )
          {
            squareArray [ squareArray . length ] = new BaseSprite ( application ) ;
            addChild ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setswh ( squareWidth , squareWidth ) ;
            BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setcxy ( 0 , ( l - 1 ) * squareWidth + startSquaresY ) ;
            if ( r == 12 )
            {
              createSquare ( "CCCCCC" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            else if ( r == 15 )
            {
              createSquare ( "FFFFFF" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            else
            {
              createSquare ( String ( r ) + String ( r ) + String ( g ) + String ( g ) + String ( b ) + String ( b ) , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            r += 3 ;
            g += 3 ;
            b += 3 ;
          }
          else
          {
            squareArray [ squareArray . length ] = new BaseSprite ( application ) ;
            addChild ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setswh ( squareWidth , squareWidth ) ;
            BaseSprite ( squareArray [ squareArray . length - 1 ] ) . setcxy ( 0 , ( l - 1 ) * squareWidth + startSquaresY ) ;
            if ( l == 7 )
            {
              createSquare ( "FF0000" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            if ( l == 8 )
            {
              createSquare ( "00FF00" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            if ( l == 9 )
            {
              createSquare ( "0000FF" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            if ( l == 10 )
            {
              createSquare ( "FFFF00" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            if ( l == 11 )
            {
              createSquare ( "00FFFF" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
            if ( l == 12 )
            {
              createSquare ( "FF00FF" , BaseSprite ( squareArray [ squareArray . length - 1 ] ) ) ;
            }
          }
        }
        if ( drawn2CustomSprite == null )
        {
          drawn2CustomSprite = new BaseSprite ( application ) ;
          addChild ( drawn2CustomSprite ) ;
          drawn2CustomSprite . mouseDownForScrollingEnabled = false ;
        }
        if ( drawn2BitmapData != null )
        {
          drawn2BitmapData . dispose ( ) ;
        }
        if ( drawn2CustomSprite != null )
        {
          drawn2CustomSprite . setswh ( drawnWidth , drawnHeight ) ;
          drawn2CustomSprite . setcxy ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) . getcx ( ) , startSquaresY - squareWidth ) ;
        }
        drawn2BitmapData = new BitmapData ( drawn2CustomSprite . getsw ( ) , drawn2CustomSprite . getsh ( ) ) ;
        drawn2Bitmap = new Bitmap ( ) ;
        if ( drawnCustomSprite == null )
        {
          drawnCustomSprite = new BaseSprite ( application ) ;
          addChild ( drawnCustomSprite ) ;
          drawnCustomSprite . doubleClickEnabled = true ;
          drawnCustomSprite . mouseDownForScrollingEnabled = false ;
        }
        if ( drawnBitmapData != null )
        {
          drawnBitmapData . dispose ( ) ;
        }
        if ( drawnCustomSprite != null )
        {
          drawnCustomSprite . setswh ( drawnWidth , drawnHeight ) ;
          drawnCustomSprite . setcxy ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) . getcx ( ) , startSquaresY + 12 * squareWidth ) ;
        }
        drawnBitmapData = new BitmapData ( drawnCustomSprite . getsw ( ) , drawnCustomSprite . getsh ( ) ) ;
        drawnBitmap = new Bitmap ( ) ;
        drawBitmap ( ) ;
        draw2Bitmap ( ) ;
        markSquare ( ) ;
        setOrClearAllListeners ( ) ;
      }
    }
/*
** The size of the button has been changed.
*/
    private function acceptNewColorButtonResized ( e : Event ) : void
    {
      createContentSingle ( ) ;
    }
/*
** Creates a square object to the panel to be displayed.
*/
    private function createSquare ( rgbColor : String , cs : BaseSprite ) : void
    {
      if ( cs != null )
      {
        cs . setValue ( rgbColor ) ;
        drawSquare ( cs , false ) ;
        cs . doubleClickEnabled = true ;
      }
    }
    private function drawSquare ( cs : BaseSprite , over : Boolean ) : void
    {
      if ( cs != null )
      {
        cs . graphics . clear ( ) ;
        cs . graphics . beginFill ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + cs . getValue ( ) ) , application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) ) ;
        cs . graphics . drawRect ( 0 , 0 , cs . getsw ( ) , cs . getsh ( ) ) ;
        cs . graphics . endFill ( ) ;
        cs . graphics . lineStyle ( application . getPropsApp ( ) . getDrawOtherLineThickness ( ) , application . getPropsApp ( ) . getColorSquareLineColor ( ) , over ? application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) : application . getPropsApp ( ) . getColorSquareLineAlphaMouseOut ( ) , true ) ;
        cs . graphics . drawRect ( application . getPropsApp ( ) . getDrawOtherLineThickness ( ) / 2 , application . getPropsApp ( ) . getDrawOtherLineThickness ( ) / 2 , cs . getsw ( ) - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) , cs . getsh ( ) - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) ) ;
      }
    }
/*
** Removes all of the squares.
*/
    private function removeAllSquares ( ) : void
    {
      if ( squareArray != null )
      {
        for ( var i : int = 0 ; i < squareArray . length ; i ++ )
        {
          if ( squareArray [ i ] is BaseSprite )
          {
            BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_DOWN , drawSquareMouseDown ) ;
            BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OVER , drawSquareOver ) ;
            BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OUT , drawSquareOut ) ;
            BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawSquareDoubleClick ) ;
            BaseSprite ( squareArray [ i ] ) . destroy ( ) ;
            removeChild ( BaseSprite ( squareArray [ i ] ) ) ;
            squareArray [ i ] = null ;
          }
        }
        squareArray = null ;
      }
    }
/*
** Marks and unmarks the squares. (according to the current tempColorNumber)
*/
    private function markSquare ( ) : void
    {
      var marked : Boolean = false ;
      if ( squareArray != null )
      {
        for ( var i : int = 0 ; i < squareArray . length ; i ++ )
        {
          if ( squareArray [ i ] is BaseSprite )
          {
            if ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + BaseSprite ( squareArray [ i ] ) . getValue ( ) ) != tempColorNumber )
            {
              drawSquare ( BaseSprite ( squareArray [ i ] ) , false ) ;
            }
            else
            {
              if ( ! marked )
              {
                drawSquare ( BaseSprite ( squareArray [ i ] ) , true ) ;
                markedSquareIndex = i ;
                marked = true ;
              }
            }
          }
        }
      }
      marked = undefined ;
    }
/*
** Mouse out a square.
*/
    private function drawSquareOut ( e : MouseEvent ) : void
    {
      if ( e != null )
      {
        if ( e . currentTarget is BaseSprite )
        {
          markSquare ( ) ;
        }
      }
    }
/*
** Mouse over a square.
*/
    private function drawSquareOver ( e : MouseEvent ) : void
    {
      if ( e != null )
      {
        if ( e . currentTarget is BaseSprite )
        {
          drawSquare ( BaseSprite ( e . currentTarget ) , true ) ;
        }
      }
    }
/*
** MouseDown a square.
*/
    private function drawSquareMouseDown ( e : MouseEvent ) : void
    {
      if ( e != null && inputRgb != null )
      {
        if ( e . currentTarget is BaseSprite )
        {
          tempColorNumber = Number ( application . COLOR_HEX_TO_NUMBER_STRING + BaseSprite ( e . currentTarget ) . getValue ( ) ) ;
          displayTempAndCompColor ( tempColorNumber ) ;
          inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
          drawBitmap ( ) ;
          draw2Bitmap ( ) ;
          markSquare ( ) ;
        }
      }
    }
/*
** Click a square.
*/
    private function drawSquareDoubleClick ( e : MouseEvent ) : void
    {
      if ( e != null && inputRgb != null )
      {
        if ( e . currentTarget is BaseSprite )
        {
          setRGBColor ( application . colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + BaseSprite ( e . currentTarget ) . getValue ( ) ) ) ) ;
        }
      }
    }
/*
** Drawing the color object under the squares.
*/
    private function drawBitmap ( ) : void
    {
      if ( drawnColorArray && drawnCustomSprite && drawnBitmapData && drawnBitmap )
      {
        drawnColorArray . splice ( 0 ) ;
        drawnColorArray = [ application . COLOR_DRAWED_COLOR_ARRAY_DARK , tempColorNumber , application . COLOR_DRAWED_COLOR_ARRAY_BRIGHT ] ;
        drawnCustomSprite . graphics . clear ( ) ;
        drawnCustomSprite . graphics . beginGradientFill ( GradientType . LINEAR , drawnColorArray , application . COLOR_DRAWED_ALPHA_ARRAY , application . COLOR_DRAWED_RATIO_ARRAY , drawnMatrix ) ;
        drawnCustomSprite . graphics . moveTo ( 0 , 0 ) ;
        drawnCustomSprite . graphics . lineTo ( drawnWidth , 0 ) ;
        drawnCustomSprite . graphics . lineTo ( drawnWidth , drawnHeight - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        drawnCustomSprite . graphics . curveTo ( drawnWidth , drawnHeight , drawnWidth - application . getPropsDyn ( ) . getAppRadius ( ) , drawnHeight ) ;
        drawnCustomSprite . graphics . lineTo ( application . getPropsDyn ( ) . getAppRadius ( ) , drawnHeight ) ;
        drawnCustomSprite . graphics . curveTo ( 0 , drawnHeight , 0 , drawnHeight - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        drawnCustomSprite . graphics . lineTo ( 0 , 0 ) ;
        drawnCustomSprite . graphics . endFill ( ) ;
        drawnBitmapData . draw ( drawnCustomSprite ) ;
        drawnBitmap . bitmapData = drawnBitmapData ;
      }
    }
/*
** Updates the complementer drawing.
*/
    private function draw2Bitmap ( ) : void
    {
      if ( drawn2ColorArray && drawn2CustomSprite && drawn2BitmapData && drawn2Bitmap )
      {
        drawn2ColorArray . splice ( 0 ) ;
        drawn2ColorArray = [ application . COLOR_DRAWED_COLOR_ARRAY_BRIGHT , compColorNumber , application . COLOR_DRAWED_COLOR_ARRAY_DARK ] ;
        drawn2CustomSprite . graphics . clear ( ) ;
        drawn2CustomSprite . graphics . beginGradientFill ( GradientType . LINEAR , drawn2ColorArray , application . COLOR_DRAWED_ALPHA_ARRAY , application . COLOR_DRAWED_RATIO_ARRAY , drawn2Matrix ) ;
        drawn2CustomSprite . graphics . moveTo ( 0 , 0 ) ;
        drawn2CustomSprite . graphics . lineTo ( drawnWidth - application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        drawn2CustomSprite . graphics . curveTo ( drawnWidth , 0 , drawnWidth , drawnHeight - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        drawn2CustomSprite . graphics . lineTo ( drawnWidth , drawnHeight ) ;
        drawn2CustomSprite . graphics . lineTo ( 0 , drawnHeight ) ;
        drawn2CustomSprite . graphics . lineTo ( 0 , 0 ) ;
        drawn2CustomSprite . graphics . endFill ( ) ;
        drawn2BitmapData . draw ( drawn2CustomSprite ) ;
        drawn2Bitmap . bitmapData = drawn2BitmapData ;
      }
    }
/*
** Displaying the temporary color. (the actual value of this color object.)
*/
    private function displayTempAndCompColor ( color : Number ) : void
    {
      if ( panelColorActual != null )
      {
        panelColorActual . graphics . clear ( ) ;
        panelColorActual . graphics . beginFill ( color , application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) ) ;
        panelColorActual . graphics . moveTo ( application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorActual . graphics . lineTo ( panelColorActual . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorActual . graphics . curveTo ( panelColorActual . getsw ( ) , 0 , panelColorActual . getsw ( ) , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorActual . graphics . lineTo ( panelColorActual . getsw ( ) , panelColorActual . getsh ( ) - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorActual . graphics . curveTo ( panelColorActual . getsw ( ) , panelColorActual . getsh ( ) , panelColorActual . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , panelColorActual . getsh ( ) ) ;
        panelColorActual . graphics . lineTo ( 0 , panelColorActual . getsh ( ) ) ;
        panelColorActual . graphics . lineTo ( 0 , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorActual . graphics . curveTo ( 0 , 0 , application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorActual . graphics . endFill ( ) ;
      }
      if ( panelColorComplementer != null )
      {
        compColorNumber = application . COLOR_TO_CALC_COMPLEMENTER - color ;
        panelColorComplementer . graphics . clear ( ) ;
        panelColorComplementer . graphics . beginFill ( compColorNumber , application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) ) ;
        panelColorComplementer . graphics . moveTo ( 0 , 0 ) ;
        panelColorComplementer . graphics . lineTo ( panelColorComplementer . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorComplementer . graphics . curveTo ( panelColorComplementer . getsw ( ) , 0 , panelColorComplementer . getsw ( ) , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorComplementer . graphics . lineTo ( panelColorComplementer . getsw ( ) , panelColorComplementer . getsh ( ) - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorComplementer . graphics . curveTo ( panelColorComplementer . getsw ( ) , panelColorComplementer . getsh ( ) , panelColorComplementer . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , panelColorComplementer . getsh ( ) ) ;
        panelColorComplementer . graphics . lineTo ( 0 , panelColorComplementer . getsh ( ) ) ;
        panelColorComplementer . graphics . lineTo ( 0 , 0 ) ;
        panelColorComplementer . graphics . endFill ( ) ;
      }
    }
/*
** Displaying the default color. (the current value of this color object.)
*/
    private function displayDefaultColor ( color : Number ) : void
    {
      if ( panelColorDefault != null )
      {
        panelColorDefault . graphics . clear ( ) ;
        panelColorDefault . graphics . beginFill ( color , application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) ) ;
        panelColorDefault . graphics . moveTo ( application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorDefault . graphics . lineTo ( panelColorDefault . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorDefault . graphics . curveTo ( panelColorDefault . getsw ( ) , 0 , panelColorDefault . getsw ( ) , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorDefault . graphics . lineTo ( panelColorDefault . getsw ( ) , panelColorDefault . getsh ( ) - application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorDefault . graphics . curveTo ( panelColorDefault . getsw ( ) , panelColorDefault . getsh ( ) , panelColorDefault . getsw ( ) - application . getPropsDyn ( ) . getAppRadius ( ) , panelColorDefault . getsh ( ) ) ;
        panelColorDefault . graphics . lineTo ( 0 , panelColorDefault . getsh ( ) ) ;
        panelColorDefault . graphics . lineTo ( 0 , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        panelColorDefault . graphics . curveTo ( 0 , 0 , application . getPropsDyn ( ) . getAppRadius ( ) , 0 ) ;
        panelColorDefault . graphics . endFill ( ) ;
      }
    }
/*
** Sets the color immediately when double click on the drawn bitmap.
*/
    private function drawnCustomSpriteDoubleClick ( e : MouseEvent ) : void
    {
      if ( e != null && drawnBitmapData != null )
      {
        setRGBColor ( application . colorToString ( drawnBitmapData . getPixel ( e . localX , e . localY ) ) ) ;
      }
    }
/*
** Updating the tempColorNumber according the current click position.
*/
    private function updateBitmapColor ( e : MouseEvent ) : void
    {
      if ( e != null && drawnBitmapData != null && inputRgb != null )
      {
        if ( e . buttonDown )
        {
          tempColorNumber = drawnBitmapData . getPixel ( e . localX , e . localY ) ;
          displayTempAndCompColor ( tempColorNumber ) ;
          inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
          draw2Bitmap ( ) ;
          markSquare ( ) ;
        }
      }
    }
/*
** Sets the default color.
*/
    private function setDefaultColor ( e : MouseEvent ) : void
    {
      if ( inputRgb != null )
      {
        tempColorNumber = Number ( application . COLOR_HEX_TO_NUMBER_STRING + getValue ( ) ) ;
        displayTempAndCompColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
        drawBitmap ( ) ;
        draw2Bitmap ( ) ;
        markSquare ( ) ;
      }
    }
/*
** When the text changes in the rgb textfield.
*/
    private function onChangeInputRgbText ( e : Event ) : void
    {
      if ( inputRgb != null )
      {
        inputRgb . setTextToUpperCase ( ) ;
        tempColorNumber = Number ( application . COLOR_HEX_TO_NUMBER_STRING + inputRgb . getText ( ) ) ;
        displayTempAndCompColor ( tempColorNumber ) ;
        drawBitmap ( ) ;
        draw2Bitmap ( ) ;
        markSquare ( ) ;
      }
    }
/*
** The input Rgb input field is changed. (ENTER was hit.)
*/
    private function inputRgbChanged ( e : Event ) : void
    {
      if ( inputRgb != null )
      {
        acceptNewColorButtonPressed ( ) ;
      }
    }
/*
** When the button is pressed.
*/
    private function acceptNewColorButtonPressed ( e : Event = null ) : void
    {
      if ( acceptNewColorButton != null && inputRgb != null )
      {
        setRGBColor ( inputRgb . getText ( ) ) ;
        acceptNewColorButton . setEnabled ( true ) ;
      }
    }
/*
** Gets the rgb color.
*/
    public function getRGBColor ( ) : String
    {
      return application . colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + inputRgb . getText ( ) ) ) ;
    }
/*
** Sets the rgb color as a string.
*/
    public function setRGBColor ( s : String ) : void
    {
      s = application . colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + s ) ) ;
      if ( getValue ( ) != s )
      {
        setValue ( s ) ;
        tempColorNumber = Number ( application . COLOR_HEX_TO_NUMBER_STRING + s ) ;
        displayTempAndCompColor ( tempColorNumber ) ;
        displayDefaultColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( s ) ;
        drawBitmap ( ) ;
        draw2Bitmap ( ) ;
        markSquare ( ) ;
      }
      getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
    }
/*
** Let's start the pixel stealing (color) from any pixel of the stage.
*/
    private function stealPixel ( e : MouseEvent ) : void
    {
      if ( stage != null && inputRgb != null )
      {
        application . getBackground ( ) . stealPixel ( true ) ;
        getBaseEventDispatcher ( ) . dispatchEvent ( eventColorStealFromStageStart ) ;
        stage . addEventListener ( MouseEvent . MOUSE_UP , getColorFromStage , false , 0 , true ) ;
        stage . addEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove , false , 0 , true ) ;
        stage . addEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
        stage . addEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp , false , 0 , true ) ;
        stealPixelSprite = new BaseSprite ( application ) ;
        application . addChild ( stealPixelSprite ) ;
        stageResized ( ) ;
        stealPixelColorText = new TextLabel ( application ) ;
        application . addChild ( stealPixelColorText ) ;
        stealPixelColorText . setTextCode ( application . colorToString ( stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ) ) ;
        stealPixelColorText . setcxy ( stage . mouseX + colorStealTextCDelta , stage . mouseY - stealPixelColorText . getsh ( ) - colorStealTextCDelta ) ;
        stealPixelColorText . getBaseTextField ( ) . background = true ;
        stealPixelColorText . getBaseTextField ( ) . backgroundColor = Number ( application . COLOR_HEX_TO_NUMBER_STRING + stealPixelColorText . getBaseTextField ( ) . text ) ;
      }
    }
/*
** Gets the pixel from the stage.
*/
    private function getColorFromStage ( e : Event ) : void
    {
      if ( inputRgb != null && stealPixelBitmapData != null && stage != null )
      {
        tempColorNumber = stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ;
        displayTempAndCompColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
        drawBitmap ( ) ;
        draw2Bitmap ( ) ;
        markSquare ( ) ;
        stealPixelStop ( ) ;
      }
    }
/*
** The key up on the stage. The pixel stealing has to be finished.
*/
    private function stealPixelKeyUp ( e : KeyboardEvent ) : void
    {
      if ( e != null )
      {
        if ( e . keyCode == Keyboard . ESCAPE )
        {
          stealPixelStop ( ) ;
        }
        e . stopImmediatePropagation ( ) ;
      }
    }
/*
** The stage has been resized so the global bitmapdata has to be updated.
*/
    private function stageResized ( e : Event = null ) : void
    {
      if ( stage != null )
      {
        if ( stealPixelSprite != null )
        {
          if ( stealPixelColorText != null )
          {
            stealPixelColorText . visible = false ;
          }
          stealPixelSprite . graphics . clear ( ) ;
          stealPixelSprite . graphics . beginFill ( 0 , 0 ) ;
          stealPixelSprite . graphics . drawRect ( 0 , 0 , stage . stageWidth , stage . stageHeight ) ;
          stealPixelSprite . graphics . endFill ( ) ;
          stealPixelBitmapData = new BitmapData ( stage . stageWidth , stage . stageHeight ) ;
          stealPixelBitmapData . draw ( stage ) ;
          if ( stealPixelColorText != null )
          {
            stealPixelColorText . visible = true ;
          }
        }
      }
    }
/*
** When the mouse moves during the pixel stealing.
*/
    private function stealPixelMouseMove ( e : MouseEvent ) : void
    {
      if ( stealPixelColorText != null && stealPixelBitmapData != null && stage != null )
      {
        stealPixelColorText . setTextCode ( application . colorToString ( stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ) ) ;
        stealPixelColorText . getBaseTextField ( ) . backgroundColor = Number ( application . COLOR_HEX_TO_NUMBER_STRING + stealPixelColorText . getBaseTextField ( ) . text ) ;
        stealPixelColorText . getBaseTextField ( ) . borderColor = stealPixelColorText . getBaseTextField ( ) . backgroundColor ;
        stealPixelColorText . setcxy ( stage . mouseX + colorStealTextCDelta , stage . mouseY - stealPixelColorText . getsh ( ) - colorStealTextCDelta ) ;
        if ( stealPixelColorText . getcx ( ) > stage . stageWidth - stealPixelColorText . getsw ( ) )
        {
          stealPixelColorText . setcx ( stage . mouseX - colorStealTextCDelta - stealPixelColorText . getsw ( ) ) ;
        }
        if ( stealPixelColorText . getcy ( ) < 0 )
        {
          stealPixelColorText . setcy ( stage . mouseY + colorStealTextCDelta ) ;
        }
      }
    }
/*
** Stops the pixel stealing.
*/
    private function stealPixelStop ( ) : void
    {
      application . getBackground ( ) . stealPixel ( false ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , getColorFromStage ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove ) ;
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp ) ;
      }
      if ( stealPixelColorText != null )
      {
        stealPixelColorText . filters = undefined ;
        stealPixelColorText . destroy ( ) ;
        application . removeChild ( stealPixelColorText ) ;
        stealPixelColorText = null ;
      }
      if ( stealPixelSprite != null )
      {
        stealPixelSprite . destroy ( ) ;
        application . removeChild ( stealPixelSprite ) ;
        stealPixelSprite = null ;
      }
      if ( stealPixelBitmapData != null )
      {
        stealPixelBitmapData . dispose ( ) ;
      }
      stealPixelBitmapData = new BitmapData ( 1 , 1 ) ;
      markSquare ( ) ;
      getBaseEventDispatcher ( ) . dispatchEvent ( eventColorStealFromStageStop ) ;
    }
/*
** Sets the complementer color to the temp (switch the colors)
*/
    private function setComplementerToTemp ( e : MouseEvent ) : void
    {
      tempColorNumber = compColorNumber ;
      displayTempAndCompColor ( tempColorNumber ) ;
      inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
      drawBitmap ( ) ;
      draw2Bitmap ( ) ;
      markSquare ( ) ;
    }
/*
**  Let the color from complementer bitmap be the temp.
*/
    private function update2BitmapColor ( e : MouseEvent ) : void
    {
      if ( e != null && drawn2BitmapData != null && inputRgb != null )
      {
        if ( e . buttonDown )
        {
          tempColorNumber = drawn2BitmapData . getPixel ( e . localX , e . localY ) ;
          displayTempAndCompColor ( tempColorNumber ) ;
          inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
          drawBitmap ( ) ;
          draw2Bitmap ( ) ;
          markSquare ( ) ;
        }
      }
    }
/*
** Switch between complementer and temporary colors (input field).
*/
    private function displayCompColor ( e : MouseEvent ) : void
    {
      if ( inputRgb != null )
      {
        inputRgb . setTextCode ( application . colorToString ( compColorNumber ) ) ;
      }
    }
    private function displayTempColor ( e : MouseEvent ) : void
    {
      if ( inputRgb != null )
      {
        inputRgb . setTextCode ( application . colorToString ( tempColorNumber ) ) ;
      }
    }
/*
** Override of destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      stealPixelStop ( ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      panelColorActual . removeEventListener ( MouseEvent . CLICK , stealPixel ) ;
      panelColorDefault . removeEventListener ( MouseEvent . CLICK , setDefaultColor ) ;
      drawnCustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
      drawnCustomSprite . removeEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
      drawnCustomSprite . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawnCustomSpriteDoubleClick ) ;
      drawn2CustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , update2BitmapColor ) ;
      panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_DOWN , setComplementerToTemp ) ;
      panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_OVER , displayCompColor ) ;
      panelColorComplementer . removeEventListener ( MouseEvent . MOUSE_OUT , displayTempColor ) ;
      for ( var i : int = 0 ; i < squareArray . length ; i ++ )
      {
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_DOWN , drawSquareMouseDown ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OVER , drawSquareOver ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OUT , drawSquareOut ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawSquareDoubleClick ) ;
      }
      inputRgb . removeEventListener ( Event . CHANGE , onChangeInputRgbText ) ;
      inputRgb . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_CHANGED , inputRgbChanged ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , getColorFromStage ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove ) ;
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
      if ( eventColorStealFromStageStart != null )
      {
        eventColorStealFromStageStart . stopImmediatePropagation ( ) ;
      }
      if ( eventColorStealFromStageStop != null )
      {
        eventColorStealFromStageStop . stopImmediatePropagation ( ) ;
      }
      drawnBitmapData . dispose ( ) ;
      stealPixelBitmapData . dispose ( ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      inputRgb = null ;
      acceptNewColorButton = null ;
      drawnCustomSprite = null ;
      drawn2CustomSprite = null ;
      drawnColorArray . splice ( 0 ) ;
      drawnColorArray = null ;
      drawnMatrix = null ;
      drawn2ColorArray . splice ( 0 ) ;
      drawn2ColorArray = null ;
      drawn2Matrix = null ;
      drawnWidth = 0 ;
      drawnHeight = 0 ;
      drawnBitmapData = null ;
      drawnBitmap = null ;
      drawn2BitmapData = null ;
      drawn2Bitmap = null ;
      drawn2BitmapData = null ;
      drawn2Bitmap = null ;
      panelColorActual = null ;
      panelColorDefault = null ;
      panelColorComplementer = null ;
      stealPixelBitmapData = null ;
      stealPixelSprite = null ;
      stealPixelColorText = null ;
      colorStealTextCDelta = 0 ;
      squareArray . splice ( 0 ) ;
      squareArray = null ;
      squareWidth = 0 ;
      mx = 0 ;
      my = 0 ;
      st1 = 0 ;
      st2 = 0 ;
      st3 = 0 ;
      rr = null ;
      gg = null ;
      bb = null ;
      r = 0 ;
      g = 0 ;
      b = 0 ;
      startSquaresX = 0 ;
      startSquaresY = 0 ;
      tempColorNumber = 0 ;
      compColorNumber = 0 ;
      markedSquareIndex = 0 ;
      eventChanged = null ;
      eventColorStealFromStageStart = null ;
      eventColorStealFromStageStop = null ;
    }
  }
}
