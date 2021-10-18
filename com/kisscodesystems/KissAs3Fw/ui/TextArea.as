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
** TextArea.
** A multiline and editable textfield. (TextBox: multiline and NOT editable textfield.)
**
** MAIN FEATURES:
** - scroller ( the text can be scrolled)
** - and editor (the text can be edited) mode.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . TextBox ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  import flash . events . FocusEvent ;
  import flash . events . MouseEvent ;
  import flash . events . TextEvent ;
  import flash . text . TextFieldType ;
  public class TextArea extends TextBox
  {
// The original point of the click (on mover)
    private var origMouseX : int = 0 ;
    private var origMouseY : int = 0 ;
// The background of the textfield.
    private var baseShape : BaseShape = null ;
// The original text has been changed or not.
// ( changed when the user enters text into textfield.)
    private var iniTextChanged : Boolean = false ;
// Content and its original y position has to be saved if it is mobile mode.
    private var contentSprite : BaseSprite = null ;
    private var backSprite : BaseSprite = null ;
    private var origContentPos : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextArea ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The background of the textfield.
      baseShape = new BaseShape ( application ) ;
      addChildAt ( baseShape , 0 ) ;
      baseShape . setdb ( false ) ;
      baseShape . setdt ( - 1 ) ;
      baseShape . mask = baseScroll . getMask0 ( ) ;
// The scroll needs these.
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
// Needed for the background.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// This is the initial state:
      setModeScroller ( ) ;
// This is the default text type of the multiline text input.
      setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
// word wrap true by default.
      setWordWrap ( true ) ;
    }
/*
** Gets the text of the basetextfield.
*/
    public function getText ( ) : String
    {
      return baseTextField . text ;
    }
/*
** Sets the scroller mode.
*/
    private function setModeScroller ( ) : void
    {
      setChildIndex ( baseShape , 0 ) ;
      setChildIndex ( baseTextField , 1 ) ;
      setChildIndex ( baseScroll , 2 ) ;
    }
/*
** Sets the editor mode.
*/
    private function setModeEditor ( ) : void
    {
      setChildIndex ( baseShape , 1 ) ;
      setChildIndex ( baseTextField , 2 ) ;
      setChildIndex ( baseScroll , 0 ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
// So we have to redraw.
      baseShapeSetSize ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
// So we have to redraw.
      baseShapeSetSize ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      baseShapeRepaint ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      baseShapeRepaint ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      baseShapeRepaint ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to redraw.
      baseShapeRepaint ( ) ;
    }
/*
** The repainting of the background.
*/
    private function baseShapeRepaint ( ) : void
    {
      if ( application != null )
      {
        baseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        baseShape . drawRect ( ) ;
      }
    }
/*
** Sets the size of the base shape object.
*/
    private function baseShapeSetSize ( ) : void
    {
      if ( application != null )
      {
        baseShape . setswh ( baseTextField . getsw ( ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 - application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 , baseTextField . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 - application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ) ;
        baseShape . drawRect ( ) ;
      }
    }
/*
** Down on the mover.
*/
    private function moverMouseDown ( e : MouseEvent ) : void
    {
      origMouseX = int ( mouseX ) ;
      origMouseY = int ( mouseY ) ;
    }
/*
** Click on the mover.
*/
    private function moverMouseClick ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) && int ( mouseX ) == origMouseX && int ( mouseY ) == origMouseY && getEnabled ( ) )
      {
// If everything is ready then we can enter into edit mode.
        setModeEditor ( ) ;
// This is an input field now!
        baseTextField . type = TextFieldType . INPUT ;
// These event listener has to be registered.
        baseTextField . addEventListener ( FocusEvent . FOCUS_OUT , focusOut ) ;
        baseTextField . addEventListener ( FocusEvent . FOCUS_IN , focusIn ) ;
        baseTextField . addEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
        baseTextField . addEventListener ( Event . SCROLL , scroll ) ;
// The focus is on the base text field.
        if ( stage != null )
        {
          stage . focus = baseTextField ;
        }
      }
    }
/*
** When the text of the textField scrolled.
*/
    private function scroll ( e : Event ) : void
    {
      reposScroll ( ) ;
    }
/*
** When the text has not been changed but the scrol of the text has been changed.
*/
    private function reposScroll ( ) : void
    {
// Positioning the content.
      baseScroll . setccyn ( - ( baseTextField . scrollV - 1 ) / baseTextField . maxScrollV * ( baseTextField . textHeight - baseTextField . height ) ) ;
      baseScroll . setccxn ( - ( baseTextField . scrollH - 1 ) / baseTextField . maxScrollH * ( baseTextField . textWidth - baseTextField . width ) ) ;
      baseScroll . calcShapeActualposCoordinatesByContentPos ( ) ;
      baseShapeSetSize ( ) ;
      baseShapeRepaint ( ) ;
// Positioning the textfield.
      baseTextFieldPos ( ) ;
    }
/*
** Overriding this because the background also has to be dragged with the textfield.
*/
    override protected function baseTextFieldPos ( ) : void
    {
      super . baseTextFieldPos ( ) ;
      baseShape . x = baseTextField . x - application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
      baseShape . y = baseTextField . y - application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ;
    }
/*
** When the focus is got then the position of this field has to be a position
** where the user can see the text.
** TextInput and TextArea contains the same implementation.
*/
    private function focusIn ( e : FocusEvent ) : void
    {
      if ( ! application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        var currentObject : DisplayObject = DisplayObject ( this ) ;
        if ( currentObject != null )
        {
          var currentParent : DisplayObject = currentObject . parent ;
          var dist : int = y ;
          while ( currentParent != null )
          {
            if ( currentParent is DisplayObject )
            {
              dist += DisplayObject ( currentParent ) . y ;
              if ( currentParent is ContentSingle )
              {
                if ( currentParent . parent != null && currentParent . parent is ContentMultiple )
                {
                  dist -= ContentMultiple ( currentParent . parent ) . getButtonBarcysh ( ) ;
                }
                var contentSingle : ContentSingle = ContentSingle ( currentParent ) ;
                contentSprite = ContentSingle ( currentParent ) . getBaseSprite ( ) ;
                backSprite = ContentSingle ( currentParent ) . getBackSprite ( ) ;
                if ( contentSingle != null && contentSprite != null && backSprite != null )
                {
                  origContentPos = contentSprite . y ;
                  contentSprite . y = application . getPropsApp ( ) . getScrollMargin ( ) + application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) - dist + contentSingle . getBaseScroll ( ) . getccy ( ) ;
                  backSprite . y = contentSprite . y ;
                }
                break ;
              }
              currentObject = currentParent ;
              currentParent = currentObject . parent ;
            }
            else
            {
              break ;
            }
          }
        }
      }
    }
/*
** When the text field losts the focus then the original state should be set.
** And, should set the original position if it is mobile mode.
*/
    private function focusOut ( e : FocusEvent ) : void
    {
      setModeScroller ( ) ;
      baseTextField . type = TextFieldType . DYNAMIC ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_OUT , focusOut ) ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_IN , focusIn ) ;
      baseTextField . removeEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      baseTextField . removeEventListener ( Event . SCROLL , scroll ) ;
      if ( ! application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        if ( contentSprite != null )
        {
          contentSprite . y = origContentPos ;
        }
        if ( backSprite != null )
        {
          backSprite . y = origContentPos ;
        }
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** Do the same but it is necessary to reposition the actualpos shape.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        baseShapeSetSize ( ) ;
        baseShapeRepaint ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        baseShapeSetSize ( ) ;
        baseShapeRepaint ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        baseShapeSetSize ( ) ;
        baseShapeRepaint ( ) ;
      }
    }
/*
** The user enters text into this textfield.
*/
    private function textInput ( e : TextEvent ) : void
    {
      doSizeOrTextChanged ( ) ;
      if ( ! iniTextChanged )
      {
        iniTextChanged = true ;
        baseTextField . setTextCode ( baseTextField . text ) ;
      }
    }
/*
** Restrict.
*/
    public function setRestrict ( r : String ) : void
    {
      baseTextField . restrict = r ;
    }
/*
** minChars.
*/
    public function setMinChars ( m : int ) : void
    {
      baseTextField . setMinChars ( m ) ;
    }
/*
** maxChars.
*/
    public function setMaxChars ( m : int ) : void
    {
      baseTextField . maxChars = m ;
    }
/*
** Tests whether this textfield contains tne minimum number of chars.
*/
    public function getTextIsAtLeastLength ( ) : Boolean
    {
      return baseTextField . getTextIsAtLeastLength ( ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_OUT , focusOut ) ;
      baseTextField . removeEventListener ( FocusEvent . FOCUS_IN , focusIn ) ;
      baseTextField . removeEventListener ( TextEvent . TEXT_INPUT , textInput ) ;
      baseTextField . removeEventListener ( Event . SCROLL , scroll ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseShape = null ;
      origMouseX = 0 ;
      origMouseY = 0 ;
      iniTextChanged = false ;
      contentSprite = null ;
      backSprite = null ;
      origContentPos = 0 ;
    }
  }
}
