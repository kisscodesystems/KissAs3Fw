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
** Color.
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
  public class Color extends BaseSprite
  {
// The input text what accepts the rgb color from the keyboard.
    private var inputRgb : TextInput = null ;
// To make the actual color as the default color.
    private var acceptNewColorButton : ButtonText = null ;
// This is the sprite that is clickable and colored by ffffff - actual_color - 000000
    private var drawedCustomSprite : BaseSprite = null ;
// The array containing the colors of the above.
    private var drawedColorArray : Array = null ;
// This also helps to the coloring of the above.
    private var drawedMatrix : Matrix = null ;
// The size of this.
    private var drawedWidth : int = 0 ;
    private var drawedHeight : int = 0 ;
// The bitmap and bitmapdata objects to draw the drawed sprite.
    private var drawedBitmapData : BitmapData = null ;
    private var drawedBitmap : Bitmap = null ;
// The colored sprite of the actual color.
    private var panelColorActual : BaseSprite = null ;
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
// The index which square has to be marked.
    private var markedSquareIndex : int = 0 ;
// This event will be changed after the changing of the default color of this Color object.
    private var eventChanged : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Color ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The default color has been changed, this message goes to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
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
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , getColorFromStage ) ;
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
          panelColorActual . addEventListener ( MouseEvent . CLICK , stealPixel ) ;
        }
        else
        {
          panelColorActual . removeEventListener ( MouseEvent . CLICK , stealPixel ) ;
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
      if ( drawedCustomSprite != null )
      {
        if ( getEnabled ( ) )
        {
          drawedCustomSprite . addEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
          drawedCustomSprite . addEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
          drawedCustomSprite . addEventListener ( MouseEvent . DOUBLE_CLICK , drawedCustomSpriteDoubleClick ) ;
        }
        else
        {
          drawedCustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
          drawedCustomSprite . removeEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
          drawedCustomSprite . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawedCustomSpriteDoubleClick ) ;
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
** - drawed bitmap according to the temp color.
*/
    private function createContentSingle ( ) : void
    {
      if ( application != null )
      {
        squareWidth = int ( application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) * 2 / 3 ) ;
        super . setsw ( 19 * squareWidth ) ;
        drawedWidth = 19 * squareWidth ;
        drawedHeight = squareWidth ;
        if ( drawedColorArray != null )
        {
          drawedColorArray . splice ( 0 ) ;
          drawedColorArray = null ;
        }
        drawedColorArray = new Array ( 3 ) ;
        drawedMatrix = null ;
        drawedMatrix = new Matrix ( ) ;
        drawedMatrix . createGradientBox ( drawedWidth , drawedHeight , Math . PI , 0 , 0 ) ;
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
          super . setsh ( 13 * squareWidth + acceptNewColorButton . getsh ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ) ;
        }
        else
        {
          super . setsh ( 13 * squareWidth ) ;
        }
        startSquaresY = acceptNewColorButton . getcysh ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ;
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
        displayTempColor ( tempColorNumber ) ;
        displayDefaultColor ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + getValue ( ) ) ) ;
        if ( inputRgb == null )
        {
          inputRgb = new TextInput ( application ) ;
          addChild ( inputRgb ) ;
          inputRgb . addEventListener ( Event . CHANGE , onChangeInputRgbText ) ;
          inputRgb . setMaxChars ( application . COLOR_MAX_CHARS_RGB_INPUT ) ;
          inputRgb . setRestrict ( application . TEXT_ENABLED_CHARS_HEX ) ;
        }
        if ( inputRgb != null )
        {
          inputRgb . setcxy ( panelColorDefault . getcxsw ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , acceptNewColorButton . getcy ( ) ) ;
          inputRgb . setTextCode ( colorToString ( tempColorNumber ) ) ;
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
        if ( drawedCustomSprite == null )
        {
          drawedCustomSprite = new BaseSprite ( application ) ;
          addChild ( drawedCustomSprite ) ;
          drawedCustomSprite . doubleClickEnabled = true ;
        }
        if ( drawedBitmapData != null )
        {
          drawedBitmapData . dispose ( ) ;
        }
        if ( drawedCustomSprite != null )
        {
          drawedCustomSprite . setswh ( drawedWidth , drawedHeight ) ;
          drawedCustomSprite . setcxy ( BaseSprite ( squareArray [ squareArray . length - 1 ] ) . getcx ( ) , startSquaresY + 12 * squareWidth ) ;
        }
        drawedBitmapData = new BitmapData ( drawedCustomSprite . getsw ( ) , drawedCustomSprite . getsh ( ) ) ;
        drawedBitmap = new Bitmap ( ) ;
        drawBitmap ( ) ;
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
          displayTempColor ( tempColorNumber ) ;
          inputRgb . setTextCode ( colorToString ( tempColorNumber ) ) ;
          drawBitmap ( ) ;
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
          setRGBColor ( colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + BaseSprite ( e . currentTarget ) . getValue ( ) ) ) ) ;
        }
      }
    }
/*
** Drawing the color object under the squares.
*/
    private function drawBitmap ( ) : void
    {
      if ( drawedColorArray && drawedCustomSprite && drawedBitmapData && drawedBitmap )
      {
        drawedColorArray . splice ( 0 ) ;
        drawedColorArray = [ application . COLOR_DRAWED_COLOR_ARRAY_DARK , tempColorNumber , application . COLOR_DRAWED_COLOR_ARRAY_BRIGHT ] ;
        drawedCustomSprite . graphics . clear ( ) ;
        drawedCustomSprite . graphics . beginGradientFill ( GradientType . LINEAR , drawedColorArray , application . COLOR_DRAWED_ALPHA_ARRAY , application . COLOR_DRAWED_RATIO_ARRAY , drawedMatrix ) ;
        drawedCustomSprite . graphics . moveTo ( 0 , 0 ) ;
        drawedCustomSprite . graphics . lineTo ( drawedWidth , 0 ) ;
        drawedCustomSprite . graphics . lineTo ( drawedWidth , drawedHeight - application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        drawedCustomSprite . graphics . curveTo ( drawedWidth , drawedHeight , drawedWidth - application . getPropsDyn ( ) . getAppRadius0 ( ) , drawedHeight ) ;
        drawedCustomSprite . graphics . lineTo ( application . getPropsDyn ( ) . getAppRadius0 ( ) , drawedHeight ) ;
        drawedCustomSprite . graphics . curveTo ( 0 , drawedHeight , 0 , drawedHeight - application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        drawedCustomSprite . graphics . lineTo ( 0 , 0 ) ;
        drawedCustomSprite . graphics . endFill ( ) ;
        drawedBitmapData . draw ( drawedCustomSprite ) ;
        drawedBitmap . bitmapData = drawedBitmapData ;
      }
    }
/*
** Displaying the temporary color. (the actual value of this color object.)
*/
    private function displayTempColor ( color : Number ) : void
    {
      if ( panelColorActual != null )
      {
        panelColorActual . graphics . clear ( ) ;
        panelColorActual . graphics . beginFill ( color , application . getPropsApp ( ) . getColorSquareLineAlphaMouseOver ( ) ) ;
        panelColorActual . graphics . moveTo ( application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorActual . graphics . lineTo ( panelColorActual . getsw ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorActual . graphics . curveTo ( panelColorActual . getsw ( ) , 0 , panelColorActual . getsw ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorActual . graphics . lineTo ( panelColorActual . getsw ( ) , panelColorActual . getsh ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorActual . graphics . curveTo ( panelColorActual . getsw ( ) , panelColorActual . getsh ( ) , panelColorActual . getsw ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) , panelColorActual . getsh ( ) ) ;
        panelColorActual . graphics . lineTo ( 0 , panelColorActual . getsh ( ) ) ;
        panelColorActual . graphics . lineTo ( 0 , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorActual . graphics . curveTo ( 0 , 0 , application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorActual . graphics . endFill ( ) ;
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
        panelColorDefault . graphics . moveTo ( application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorDefault . graphics . lineTo ( panelColorDefault . getsw ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorDefault . graphics . curveTo ( panelColorDefault . getsw ( ) , 0 , panelColorDefault . getsw ( ) , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorDefault . graphics . lineTo ( panelColorDefault . getsw ( ) , panelColorDefault . getsh ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorDefault . graphics . curveTo ( panelColorDefault . getsw ( ) , panelColorDefault . getsh ( ) , panelColorDefault . getsw ( ) - application . getPropsDyn ( ) . getAppRadius0 ( ) , panelColorDefault . getsh ( ) ) ;
        panelColorDefault . graphics . lineTo ( 0 , panelColorDefault . getsh ( ) ) ;
        panelColorDefault . graphics . lineTo ( 0 , application . getPropsDyn ( ) . getAppRadius0 ( ) ) ;
        panelColorDefault . graphics . curveTo ( 0 , 0 , application . getPropsDyn ( ) . getAppRadius0 ( ) , 0 ) ;
        panelColorDefault . graphics . endFill ( ) ;
      }
    }
/*
** Sets the color immediately when double click on the drawed bitmap.
*/
    private function drawedCustomSpriteDoubleClick ( e : MouseEvent ) : void
    {
      if ( e != null && drawedBitmapData != null )
      {
        setRGBColor ( colorToString ( drawedBitmapData . getPixel ( e . localX , e . localY ) ) ) ;
      }
    }
/*
** Updating the tempColorNumber according the current click position.
*/
    private function updateBitmapColor ( e : MouseEvent ) : void
    {
      if ( e != null && drawedBitmapData != null && inputRgb != null )
      {
        if ( e . buttonDown )
        {
          tempColorNumber = drawedBitmapData . getPixel ( e . localX , e . localY ) ;
          displayTempColor ( tempColorNumber ) ;
          inputRgb . setTextCode ( colorToString ( tempColorNumber ) ) ;
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
        displayTempColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( colorToString ( tempColorNumber ) ) ;
        drawBitmap ( ) ;
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
        displayTempColor ( tempColorNumber ) ;
        drawBitmap ( ) ;
        markSquare ( ) ;
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
** For displaying the color.
*/
    private function colorToString ( color : Number ) : String
    {
      var tempString : String = application . COLOR_RGB_INPUT_ZEROS + color . toString ( 16 ) ;
      return ( tempString . substr ( tempString . length - 6 ) . toUpperCase ( ) ) ;
    }
/*
** Gets the rgb color.
*/
    public function getRGBColor ( ) : String
    {
      return colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + inputRgb . getText ( ) ) ) ;
    }
/*
** Sets the rgb color as a string.
*/
    public function setRGBColor ( s : String ) : void
    {
      s = colorToString ( Number ( application . COLOR_HEX_TO_NUMBER_STRING + s ) ) ;
      if ( getValue ( ) != s )
      {
        setValue ( s ) ;
        tempColorNumber = Number ( application . COLOR_HEX_TO_NUMBER_STRING + s ) ;
        displayTempColor ( tempColorNumber ) ;
        displayDefaultColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( s ) ;
        drawBitmap ( ) ;
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
        stage . addEventListener ( MouseEvent . MOUSE_DOWN , getColorFromStage , false , 0 , true ) ;
        stage . addEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove , false , 0 , true ) ;
        stage . addEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
        stage . addEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp , false , 0 , true ) ;
        stealPixelSprite = new BaseSprite ( application ) ;
        application . addChild ( stealPixelSprite ) ;
        stageResized ( ) ;
        stealPixelColorText = new TextLabel ( application ) ;
        application . addChild ( stealPixelColorText ) ;
        stealPixelColorText . setTextCode ( colorToString ( stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ) ) ;
        stealPixelColorText . setcxy ( stage . mouseX + colorStealTextCDelta , stage . mouseY - stealPixelColorText . getsh ( ) - colorStealTextCDelta ) ;
        stealPixelColorText . background = true ;
        stealPixelColorText . backgroundColor = Number ( application . COLOR_HEX_TO_NUMBER_STRING + stealPixelColorText . text ) ;
      }
    }
/*
** Is the pixel stealing in progress?
*/
    public function isPixelStealingInProgress ( ) : Boolean
    {
      return stealPixelSprite != null ;
    }
/*
** Gets the pixel from the stage.
*/
    private function getColorFromStage ( e : Event ) : void
    {
      if ( inputRgb != null && stealPixelBitmapData != null && stage != null )
      {
        tempColorNumber = stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ;
        displayTempColor ( tempColorNumber ) ;
        inputRgb . setTextCode ( colorToString ( tempColorNumber ) ) ;
        drawBitmap ( ) ;
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
        stealPixelColorText . setTextCode ( colorToString ( stealPixelBitmapData . getPixel ( stage . mouseX , stage . mouseY ) ) ) ;
        stealPixelColorText . backgroundColor = Number ( application . COLOR_HEX_TO_NUMBER_STRING + stealPixelColorText . text ) ;
        stealPixelColorText . borderColor = stealPixelColorText . backgroundColor ;
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
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , getColorFromStage ) ;
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
      drawedCustomSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , updateBitmapColor ) ;
      drawedCustomSprite . removeEventListener ( MouseEvent . MOUSE_MOVE , updateBitmapColor ) ;
      drawedCustomSprite . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawedCustomSpriteDoubleClick ) ;
      for ( var i : int = 0 ; i < squareArray . length ; i ++ )
      {
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_DOWN , drawSquareMouseDown ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OVER , drawSquareOver ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OUT , drawSquareOut ) ;
        BaseSprite ( squareArray [ i ] ) . removeEventListener ( MouseEvent . DOUBLE_CLICK , drawSquareDoubleClick ) ;
      }
      inputRgb . removeEventListener ( Event . CHANGE , onChangeInputRgbText ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , getColorFromStage ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_MOVE , stealPixelMouseMove ) ;
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
        stage . removeEventListener ( KeyboardEvent . KEY_UP , stealPixelKeyUp ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
      drawedBitmapData . dispose ( ) ;
      stealPixelBitmapData . dispose ( ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      inputRgb = null ;
      acceptNewColorButton = null ;
      drawedCustomSprite = null ;
      drawedColorArray . splice ( 0 ) ;
      drawedColorArray = null ;
      drawedMatrix = null ;
      drawedWidth = 0 ;
      drawedHeight = 0 ;
      drawedBitmapData = null ;
      drawedBitmap = null ;
      panelColorActual = null ;
      panelColorDefault = null ;
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
      markedSquareIndex = 0 ;
      eventChanged = null ;
    }
  }
}