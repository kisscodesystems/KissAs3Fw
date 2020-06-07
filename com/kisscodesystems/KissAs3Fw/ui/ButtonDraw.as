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
** ButtonDraw.
** The button object that can be drawn.
**
** MAINN FEATURES:
** - button type (what to draw)
** - text type (what colors and sizes to use)
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseWorkingButton ;
  import flash . events . Event ;
  public class ButtonDraw extends BaseWorkingButton
  {
// The shape to be drawn
    private var baseShape : BaseShape = null ;
// This is the type of the button.
    private var buttonType : String = null ;
// This is the text type of the button.
// (There will be no texts, just for the coloring from the given textformat.)
    private var textType : String = null ;
// The color of the drawing.
    private var drawColor : Number = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ButtonDraw ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The drawn object.
      baseShape = new BaseShape ( application ) ;
      contentSprite . addChild ( baseShape ) ;
      setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
// This events has to be registered.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , redraw ) ;
    }
/*
** The set size methods have to have no effects.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** click + disabled!
*/
    override protected function baseWorkingButtonClick ( ) : void
    {
      setEnabled ( false ) ;
      super . baseWorkingButtonClick ( ) ;
    }
/*
** The redrawing and the resizing.
*/
    private function redraw ( e : Event ) : void
    {
      if ( application != null )
      {
// First we can have the color to draw.
        if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
        {
          drawColor = application . getPropsDyn ( ) . getAppFontColorMid ( ) ;
        }
        else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          drawColor = application . getPropsDyn ( ) . getAppFontColorDark ( ) ;
        }
        else
        {
          drawColor = application . getPropsDyn ( ) . getAppFontColorBright ( ) ;
        }
// Clear and configure.
        baseShape . filters = null ;
        baseShape . graphics . clear ( ) ;
        baseShape . graphics . lineStyle ( application . getPropsApp ( ) . getDrawOtherLineThickness ( ) , drawColor , 1 , true ) ;
// Now draws the symbol.
        if ( buttonType == application . DRAW_BUTTON_TYPE_SETTINGS )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 2 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 2 ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 * 3 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 * 3 ) ;
        }
        else if ( buttonType == application . DRAW_BUTTON_TYPE_MENU )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 , getsh ( ) / 4 * 3 ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 2 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 2 , getsh ( ) / 4 * 3 ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 * 3 ) ;
        }
        else if ( buttonType == application . DRAW_BUTTON_TYPE_WIDGET_MOVE )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) * application . getPropsApp ( ) . getButtonDrawMovePrevNextScale ( ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) , getsh ( ) / 4 * 2 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 , getsh ( ) / 4 * 3 ) ;
        }
        else if ( buttonType == application . DRAW_BUTTON_TYPE_WIDGETS_PREV )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) * application . getPropsApp ( ) . getButtonDrawMovePrevNextScale ( ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 * 3 - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 2 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 * 3 - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) ) ;
        }
        else if ( buttonType == application . DRAW_BUTTON_TYPE_WIDGETS_NEXT )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) * application . getPropsApp ( ) . getButtonDrawMovePrevNextScale ( ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 4 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 2 , getsh ( ) / 4 * 3 - application . getPropsApp ( ) . getDrawOtherLineThickness ( ) ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 4 ) ;
        }
        else if ( buttonType == application . DRAW_BUTTON_TYPE_WIDGETS_LIST )
        {
          super . setswh ( application . getPropsDyn ( ) . getTextFieldHeight ( textType ) , application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ) ;
          baseShape . setswh ( getsw ( ) , getsh ( ) ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 3 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 3 ) ;
          baseShape . graphics . moveTo ( getsw ( ) / 4 , getsh ( ) / 3 * 2 ) ;
          baseShape . graphics . lineTo ( getsw ( ) / 4 * 3 , getsh ( ) / 3 * 2 ) ;
        }
// Reset the dropshadow filter according to the current color.
        if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
        {
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorMid ( ) ) ;
        }
        else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorDark ( ) ) ;
        }
        else
        {
          setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorBright ( ) ) ;
        }
      }
    }
/*
** Sets the dropShadowFilter according to the given color.
** (The dropshadow filter can be bright or dark.)
*/
    private function setDropShadowFilter ( color : Number ) : void
    {
      if ( application . brightShadowToApply ( color . toString ( 16 ) ) )
      {
        baseShape . filters = application . TEXT_DROP_SHADOW_ARRAY_BRIGHT ;
      }
      else
      {
        baseShape . filters = application . TEXT_DROP_SHADOW_ARRAY_DARK ;
      }
    }
/*
** Sets the type of the button.
*/
    public function setButtonType ( newButtonType : String ) : void
    {
      if ( buttonType != newButtonType )
      {
        buttonType = newButtonType ;
        redraw ( null ) ;
      }
    }
/*
** Sets the label of the button.
** Almost the same as in the base text field.
*/
    public function setTextType ( newTextType : String ) : void
    {
// By text types.
// If the new textType is different from the existing value,
// then the new value will be set.
// And, we will unsubscribe from the textformat changing event we won't have to listen to,
// and subscribe to the new event of changing the relevant textformat.
// And at the end, we will apply the (changed) textformat.
      if ( newTextType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_MID )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_MID ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , redraw ) ;
          redraw ( null ) ;
        }
      }
      else if ( newTextType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_DARK ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , redraw ) ;
          redraw ( null ) ;
        }
      }
      else
      {
        if ( textType != application . getTexts ( ) . TEXT_TYPE_BRIGHT )
        {
          textType = application . getTexts ( ) . TEXT_TYPE_BRIGHT ;
          application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , redraw ) ;
          application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , redraw ) ;
          redraw ( null ) ;
        }
      }
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , redraw ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , redraw ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , redraw ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_BRIGHT_CHANGED , redraw ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseShape = null ;
      buttonType = null ;
      textType = null ;
      drawColor = 0 ;
    }
  }
}