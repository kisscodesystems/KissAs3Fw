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
 ** More.
 ** Openable panel which contains a set of other UI elements.
 ** Useful when ther are many buttons and these buttons
 ** should be displayed many times.
 **
 ** MAIN FEATURES:
 ** - opens and closes a panel with other elements,
 **   such as buttons, links, and others.
 ** - hidable panel resizes automatically if one of its element resizes,
 **   or when an element is added or removed.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseOpen ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class More extends BaseOpen
  {
// The label object on the button.
    private var textLabel : TextLabel = null ;
// The panel around the added elements.
    private var shapeBgFrame : BaseShape = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function More ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating the components.
      textLabel = new TextLabel ( application ) ;
      baseWorkingButton . getContentSprite ( ) . addChild ( textLabel ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      textLabel . setTextCode ( application . getTexts ( ) . MORE ) ;
      textLabel . setIcon ( "more" ) ;
// The background shape.
      shapeBgFrame = new BaseShape ( application ) ;
      addChild ( shapeBgFrame ) ;
      shapeBgFrame . setdb ( false ) ;
      shapeBgFrame . setdt ( - 1 ) ;
      shapeBgFrame . visible = false ;
// Events to listen to.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resizeContent ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , redrawShape ) ;
    }
/*
** The label resized.
*/
    private function resizeLabel ( e : Event = null ) : void
    {
      if ( textLabel != null )
      {
        textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        if ( ! isOpened ( ) )
        {
          super . setswh ( textLabel . getcxswap ( ) , textLabel . getcyshap ( ) ) ;
        }
      }
    }
/*
** Redraws the shape only.
*/
    private function redrawShape ( e : Event = null ) : void
    {
      if ( shapeBgFrame != null )
      {
        shapeBgFrame . setcccac ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
        shapeBgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeBgFrame . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeBgFrame . drawRect ( ) ;
      }
    }
/*
** Override these to set the correct width and height values.
*/
    override public function open ( ) : void
    {
      super . open ( ) ;
      resizeContent ( ) ;
      if ( shapeBgFrame != null )
      {
        shapeBgFrame . visible = true ;
      }
    }
    override public function close ( ) : void
    {
      super . close ( ) ;
      if ( shapeBgFrame != null )
      {
        shapeBgFrame . visible = false ;
      }
      resizeLabel ( ) ;
    }
/*
** When an element resizes or new element has been added,
** it is necessary to reposition all of the elements and resize the hidable content.
*/
    private function resizeContent ( e : Event = null ) : void
    {
      if ( contentSprite != null )
      {
        var maxw : int = 0 ;
        var allh : int = application . getPropsDyn ( ) . getAppPadding ( ) ;
        for ( var i : int = 0 ; i < contentSprite . numChildren ; i ++ )
        {
          if ( contentSprite . getChildAt ( i ) is BaseTextField )
          {
            if ( maxw < BaseTextField ( contentSprite . getChildAt ( i ) ) . getsw ( ) )
            {
              maxw = BaseTextField ( contentSprite . getChildAt ( i ) ) . getsw ( ) ;
            }
            BaseTextField ( contentSprite . getChildAt ( i ) ) . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , allh ) ;
            allh += BaseTextField ( contentSprite . getChildAt ( i ) ) . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
          }
          else if ( contentSprite . getChildAt ( i ) is BaseSprite )
          {
            if ( maxw < BaseSprite ( contentSprite . getChildAt ( i ) ) . getsw ( ) )
            {
              maxw = BaseSprite ( contentSprite . getChildAt ( i ) ) . getsw ( ) ;
            }
            BaseSprite ( contentSprite . getChildAt ( i ) ) . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , allh ) ;
            allh += BaseSprite ( contentSprite . getChildAt ( i ) ) . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ;
          }
          else
          {
            if ( maxw < contentSprite . getChildAt ( i ) . width )
            {
              maxw = contentSprite . getChildAt ( i ) . width ;
            }
            contentSprite . getChildAt ( i ) . x = application . getPropsDyn ( ) . getAppPadding ( ) ;
            contentSprite . getChildAt ( i ) . y = allh ;
            allh += contentSprite . getChildAt ( i ) . width + application . getPropsDyn ( ) . getAppPadding ( ) ;
          }
        }
        maxw += 2 * application . getPropsDyn ( ) . getAppPadding ( ) ;
        contentSprite . setswh ( maxw , allh ) ;
        if ( isOpened ( ) )
        {
          super . setswh ( maxw , allh ) ;
          if ( shapeBgFrame != null )
          {
            shapeBgFrame . setswh ( getsw ( ) , getsh ( ) ) ;
            redrawShape ( ) ;
          }
        }
      }
      resizeLabel ( ) ;
    }
/*
** Adds an element to the content sprite.
*/
    public function addToContent ( displayObject : DisplayObject ) : void
    {
      if ( contentSprite != null && displayObject != null && ! contentSprite . contains ( displayObject ) )
      {
        contentSprite . addChild ( displayObject ) ;
        if ( displayObject is BaseSprite )
        {
          BaseSprite ( displayObject ) . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeContent ) ;
        }
        else if ( displayObject is BaseTextField )
        {
          BaseTextField ( displayObject ) . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeContent ) ;
        }
        resizeContent ( ) ;
      }
    }
/*
** Removes an element from the content sprite.
*/
    public function removeFromContent ( displayObject : DisplayObject ) : void
    {
      if ( contentSprite != null && displayObject != null )
      {
        if ( contentSprite . contains ( displayObject ) )
        {
          contentSprite . removeChild ( displayObject ) ;
          resizeContent ( ) ;
        }
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** All should be out of order!
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resizeContent ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , redrawShape ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , redrawShape ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      textLabel = null ;
      shapeBgFrame = null ;
    }
  }
}