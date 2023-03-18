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
** TextLabel.
** Not scrollable text. Can be multiline if maxWidth has been set.
**
** MAIN FEATURES:
** - the text code is displayed and will be changed automatically if the lang code is changed.
** - multiline text displaying is enabled.
** - maxWidth can be set. (useful for example in base list.)
** - icon can be set
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import com . kisscodesystems . KissAs3Fw . ui . Icon ;
  import flash . events . Event ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  public class TextLabel extends BaseSprite
  {
// The maximum width of the label.
    private var maxWidth : int = 0 ;
// The textfield to display the label itself.
    private var baseTextField : BaseTextField = null ;
// An icon can be set.
    private var icon : Icon = null ;
    private var iconType : String = "" ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextLabel ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The base text field is the first!
      baseTextField = new BaseTextField ( application ) ;
      addChild ( baseTextField ) ;
      baseTextField . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , baseTextFieldResized ) ;
// Changing these text properties.
      baseTextField . selectable = false ;
      baseTextField . autoSize = TextFieldAutoSize . LEFT ;
// The text type is bright by default.
      baseTextField . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
// We will listen to the changing of the line thickness.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
    }
/*
** If the base text field resized then the label must resized too.
*/
    private function updateswh ( ) : void
    {
      if ( baseTextField != null )
      {
        var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( baseTextField . getTextType ( ) ) ;
        if ( maxWidth == 0 )
        {
          if ( baseTextField . getTextCode ( ) == "" )
          {
            setswh ( tfh , tfh ) ;
          }
          else
          {
            setswh ( baseTextField . getcx ( ) + baseTextField . getsw ( ) , Math . max ( baseTextField . getsh ( ) , tfh ) ) ;
          }
        }
        else
        {
          if ( icon == null )
          {
            baseTextField . setsw ( maxWidth ) ;
          }
          else
          {
            baseTextField . setsw ( maxWidth - baseTextField . getcx ( ) ) ;
          }
          setswh ( maxWidth , Math . max ( baseTextField . getsh ( ) , tfh ) ) ;
        }
      }
    }
    private function baseTextFieldResized ( e : Event ) : void
    {
      setIcon ( iconType ) ;
      updateswh ( ) ;
    }
    private function lineThicknessChanged ( e : Event ) : void
    {
      setIcon ( iconType ) ;
    }
/*
** An icon can be set from outside.
*/
    public function getIcon ( ) : Icon
    {
      return icon ;
    }
    public function getIconType ( ) : String
    {
      return iconType ;
    }
    public function destIcon ( ) : void
    {
      if ( icon != null )
      {
        icon . destroy ( ) ;
        if ( contains ( icon ) )
        {
          removeChild ( icon ) ;
        }
        icon = null ;
      }
      iconType = "" ;
      if ( baseTextField != null )
      {
        baseTextField . setcx ( 0 ) ;
        updateswh ( ) ;
      }
    }
    public function setIcon ( it : String ) : void
    {
      if ( it != "" && baseTextField != null )
      {
        iconType = "" + it ;
        if ( icon == null )
        {
          icon = new Icon ( application ) ;
          addChild ( icon ) ;
        }
        var tfh : int = application . getPropsDyn ( ) . getTextFieldHeight ( baseTextField . getTextType ( ) ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        icon . drawBitmapData ( iconType , baseTextField . getTextType ( ) , tfh ) ;
        icon . setcx ( application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        icon . setcy ( application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        baseTextField . setcx ( application . getPropsDyn ( ) . getTextFieldHeight ( baseTextField . getTextType ( ) ) ) ;
        updateswh ( ) ;
      }
    }
/*
** Stuff to get base text field working
*/
    public function getBaseTextField ( ) : BaseTextField
    {
      return baseTextField ;
    }
    public function getTextCode ( ) : String
    {
      if ( baseTextField != null ) return baseTextField . getTextCode ( ) ;
      return "" ;
    }
    public function setTextCode ( tc : String ) : void
    {
      if ( baseTextField != null ) baseTextField . setTextCode ( tc ) ;
    }
    public function getTextType ( ) : String
    {
      if ( baseTextField != null ) return baseTextField . getTextType ( ) ;
      return "" ;
    }
    public function setTextType ( tt : String ) : void
    {
      if ( baseTextField != null ) baseTextField . setTextType ( tt ) ;
    }
/*
** Sets the maximum width of the label.
** If the displayed text is longer than this value then multiple lines
** of the text will be displayed.
*/
    public function setMaxWidth ( newWidth : int , allowMultiline : Boolean ) : void
    {
      if ( baseTextField != null && newWidth >= 0 && newWidth != maxWidth )
      {
        maxWidth = newWidth ;
        if ( maxWidth > 0 )
        {
          if ( allowMultiline )
          {
            baseTextField . autoSize = TextFieldAutoSize . LEFT ;
            baseTextField . wordWrap = true ;
            baseTextField . multiline = true ;
            baseTextField . width = maxWidth - ( icon == null ? 0 : icon . getsw ( ) ) ;
          }
          else
          {
            baseTextField . autoSize = TextFieldAutoSize . NONE ;
            baseTextField . wordWrap = false ;
            baseTextField . multiline = false ;
            baseTextField . width = maxWidth - ( icon == null ? 0 : icon . getsw ( ) ) ;
            baseTextField . height = application . getPropsDyn ( ) . getTextFieldHeight ( getTextType ( ) ) ;
          }
        }
        else
        {
          baseTextField . autoSize = TextFieldAutoSize . LEFT ;
          baseTextField . wordWrap = false ;
          baseTextField . multiline = false ;
        }
        super . setswh ( baseTextField . getcx ( ) + baseTextField . width , baseTextField . height ) ;
      }
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      maxWidth = 0 ;
      icon = null ;
      iconType = null ;
      baseTextField = null ;
    }
  }
}
