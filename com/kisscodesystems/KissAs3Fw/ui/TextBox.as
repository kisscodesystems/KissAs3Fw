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
** TextBox.
** Read only and scrollable text area views silngle or html text.
** The wordWrap property also available for changing.
**
** MAIN FEATURES:
** - display multiline (single or html formatted) text
** - able to scroll when the text is longer than the area to view it
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseScroll ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import flash . events . Event ;
  public class TextBox extends BaseSprite
  {
// This contains a base textfield.
    protected var baseTextField : BaseTextField = null ;
// And a base scroll object.
    protected var baseScroll : BaseScroll = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextBox ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Adding the textfield first.
      baseTextField = new BaseTextField ( application ) ;
      addChild ( baseTextField ) ;
      baseTextField . setAutoSizeNone ( ) ;
// This has to be a multiline textfield.
      baseTextField . multiline = true ;
// And adding the scroll object.
      baseScroll = new BaseScroll ( application ) ;
      addChild ( baseScroll ) ;
// This event is required for us now.
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CONTENT_POSITION_CHANGED , reposText ) ;
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TOP_REACHED , dispatchEventTopReached ) ;
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOTTOM_REACHED , dispatchEventBottomReached ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , doSizeOrTextChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , doSizeOrTextChanged ) ;
// Setting the mask ( but not necessary since the textfield always will have the size of the mask).
      baseTextField . mask = baseScroll . getMask0 ( ) ;
    }
/*
** The width has to be at least the minimum.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) )
      {
        super . setsw ( Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != Math . max ( newsh , application . getPropsApp ( ) . getTextsMinSize ( ) ) )
      {
        super . setsh ( Math . max ( newsh , application . getPropsApp ( ) . getTextsMinSize ( ) ) ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) || getsh ( ) != Math . max ( newsh , application . getPropsApp ( ) . getTextsMinSize ( ) ) )
      {
        super . setswh ( Math . max ( newsw , application . getPropsApp ( ) . getTextsMinSize ( ) ) , Math . max ( newsh , application . getPropsApp ( ) . getTextsMinSize ( ) ) ) ;
      }
    }
/*
** Repositions the visible content of the text.
*/
    private function reposText ( e : Event ) : void
    {
// Scrolling vertically (y, height)
      baseTextField . scrollV = Math . min ( Math . abs ( Math . round ( baseScroll . getccy ( ) * ( baseTextField . maxScrollV ) / ( baseTextField . textHeight - application . getPropsApp ( ) . getScrollMargin ( ) - baseTextField . height ) ) ) , baseTextField . maxScrollV ) ;
// Scrolling horizontally (x, width)
      baseTextField . scrollH = Math . min ( Math . abs ( Math . round ( baseScroll . getccx ( ) * ( baseTextField . maxScrollH ) / ( baseTextField . textWidth - 2 * application . getPropsDyn ( ) . getAppPadding ( ) - application . getPropsApp ( ) . getScrollMargin ( ) - baseTextField . width ) ) ) , baseTextField . maxScrollH ) ;
// Positioning the textfield.
      baseTextFieldPos ( ) ;
    }
/*
** Dispatches an event.
*/
    protected function dispatchEventTopReached ( eventTopReached : Event ) : void
    {
      if ( baseTextField != null )
      {
        baseTextField . scrollV = 0 ;
      }
      if ( getBaseEventDispatcher ( ) != null && eventTopReached != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventTopReached ) ;
      }
    }
    protected function dispatchEventBottomReached ( eventBottomReached : Event ) : void
    {
      if ( baseTextField != null )
      {
        baseTextField . scrollV = baseTextField . maxScrollV ;
      }
      if ( getBaseEventDispatcher ( ) != null && eventBottomReached != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventBottomReached ) ;
      }
    }
/*
** Positioning of the base text field according to the current position of mask.
*/
    protected function baseTextFieldPos ( ) : void
    {
// Positioning the textfield.
      baseTextField . x = baseScroll . getMask0 ( ) . x + application . getPropsDyn ( ) . getAppPadding ( ) ;
      baseTextField . y = baseScroll . getMask0 ( ) . y + application . getPropsDyn ( ) . getAppPadding ( ) ;
    }
/*
** This is the method runs after the changing of the size of this object.
*/
    override protected function doSizeChanged ( ) : void
    {
      doSizeOrTextChanged ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** When the text or the size have been changed.
*/
    protected function doSizeOrTextChanged ( e : Event = null ) : void
    {
      if ( application != null )
      {
// The base scroll will also have the actual size of this object.
        baseScroll . setswh ( getsw ( ) , getsh ( ) ) ;
// Because the size of the textfield has been changed, the content size has to be updated according to this.
        baseScroll . setscwch ( baseTextField . textWidth , baseTextField . textHeight ) ;
// The textfield has to be the size of the actual size minus the margin.
        baseTextField . setswh ( getsw ( ) - ( baseScroll . getscw ( ) <= getsw ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) - application . getPropsDyn ( ) . getAppPadding ( ) * 2 - application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 , getsh ( ) - ( baseScroll . getsch ( ) <= getsh ( ) ? 0 : application . getPropsApp ( ) . getScrollMargin ( ) ) - application . getPropsDyn ( ) . getAppPadding ( ) * 2 - application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ) ;
// The textfield has to be in the same position as the mask of the scroll.
        baseTextFieldPos ( ) ;
// And again.. ( the size may be changed)
        baseScroll . setscwch ( baseTextField . textWidth , baseTextField . textHeight ) ;
      }
    }
/*
** Sets the wordWrap.
*/
    public function setWordWrap ( wordWrap : Boolean ) : void
    {
      if ( baseTextField . getWordWrap != wordWrap )
      {
        baseTextField . setWordWrap ( wordWrap ) ;
        doSizeOrTextChanged ( ) ;
      }
    }
/*
** Sets the type of this text.
*/
    public function setTextType ( newTextType : String ) : void
    {
      if ( baseTextField . getTextType ( ) != newTextType )
      {
        baseTextField . setTextType ( newTextType ) ;
      }
    }
/*
** Sets the textcode.
*/
    public function setTextCode ( newTextCode : String ) : void
    {
      if ( baseTextField . getTextCode ( ) != newTextCode || newTextCode == "" )
      {
        baseTextField . setTextCode ( newTextCode ) ;
        doSizeOrTextChanged ( ) ;
      }
    }
/*
** Sets the html property.
*/
    public function setHtml ( html : Boolean ) : void
    {
      if ( baseTextField . getHtml ( ) != html )
      {
        baseTextField . setHtml ( html ) ;
        doSizeOrTextChanged ( ) ;
      }
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , doSizeOrTextChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , doSizeOrTextChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      baseTextField = null ;
      baseScroll = null ;
    }
  }
}