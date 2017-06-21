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
** ButtonBar.
** Multiple buttonlinks. One of them can be active.
**
** MAIN FEATURES:
** - ButtonLinks can be added by the text code of its label
** - The maximum width can be specified so the buttonlinks go into a content.
** - The changing of the active element will be dispatched to others.
** -
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseScroll ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class ButtonBar extends BaseSprite
  {
// The array of the buttonlinks.
    private var buttonLinksArray : Array = null ;
// The scroll of the buttons, it will scroll only horizontally.
    private var baseScroll : BaseScroll = null ;
// The content of this button bar. It has to be different as the content of the scroll!
    private var content : BaseSprite = null ;
// The active button of this link button bar.
    private var activeIndex : int = - 1 ;
// The event of the changing.
    private var eventChanged : Event = null ;
// The max width.0 means no limit to the displayed width.
    private var maxWidth : int = 0 ;
// The original mouse x and y corrdinates (mouse down event)
    private var origMouseX : int = 0 ;
    private var origMouseY : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ButtonBar ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The new event to be dispatched when the active button is changed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// The array will contain the buttons.
      buttonLinksArray = new Array ( ) ;
// The content will contain al of the buttons.
      content = new BaseSprite ( application ) ;
      addChild ( content ) ;
// The scroll of the content.
      baseScroll = new BaseScroll ( application ) ;
      addChild ( baseScroll ) ;
// Masking of the content!
      content . mask = baseScroll . getMask0 ( ) ;
// This events needed.
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . ROLL_OUT , moverRollOut ) ;
// This events are required now.
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CONTENT_POSITION_CHANGED , reposContent ) ;
      content . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , contentResized ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
    }
/*
** Gets the first index of the button having the specified label.
*/
    public function getIndexByLabel ( label : String ) : int
    {
      var index : int = - 1 ;
      for ( var i : int = 0 ; i < buttonLinksArray . length ; i ++ )
      {
        if ( ButtonLink ( buttonLinksArray [ i ] ) . getTextCode ( ) == label )
        {
          index = i ;
          break ;
        }
      }
      return index ;
    }
/*
** The lineThickness is changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
      reposButtons ( ) ;
    }
/*
** The padding is changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
      reposButtons ( ) ;
    }
/*
** Repositioning the content object according to the scrolling.
*/
    private function reposContent ( e : Event ) : void
    {
      content . setcxy ( baseScroll . getccx ( ) , baseScroll . getccy ( ) ) ;
    }
/*
** Sets the max width.
** If this is not be set then the size can be anything.
** But if the max width is set and the sum sizes of the
** buttons is larget than this max width then the buttons
** can be dragged.
*/
    public function setMaxWidth ( w : int ) : void
    {
      if ( maxWidth != w )
      {
        maxWidth = w ;
        reposButtons ( ) ;
      }
    }
/*
** Roll over the mover.
*/
    private function moverRollOver ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
// Adding some listeners if enabled.
        baseScroll . getMover ( ) . addEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
        baseScroll . getMover ( ) . addEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
        baseScroll . getMover ( ) . addEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
      }
    }
/*
** Roll out the mover.
*/
    private function moverRollOut ( e : MouseEvent ) : void
    {
// Removing of the listeners added in the moverRollOver
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
// Sets no button to active.
      setState ( - 1 , 2 ) ;
    }
/*
** Moving the mouse over the mover object.
*/
    private function moverMouseMove ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
// Sets the state mouse over on the current button.
        setState ( getActualElementIndexByMouse ( ) , 1 ) ;
      }
    }
/*
** Mouse down on the mover.
*/
    private function moverMouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
// Sets the state mouse down on the current button and stores the coordinates of the mouse.
        origMouseX = int ( mouseX ) ;
        origMouseY = int ( mouseY ) ;
        setState ( getActualElementIndexByMouse ( ) , - 1 ) ;
      }
    }
/*
** Clicking on the mover!
*/
    private function moverMouseClick ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) && origMouseX == int ( mouseX ) && origMouseY == int ( mouseY ) )
      {
// If enabled and the current mouse position equals the previous stored mouse potision..
        if ( getActualElementIndexByMouse ( ) != - 1 )
        {
// Activate the current index.
          setActiveIndex ( getActualElementIndexByMouse ( ) ) ;
        }
      }
    }
/*
** Sets the button active.
*/
    public function setActiveIndex ( index : int ) : void
    {
      if ( index >= - 1 && index < buttonLinksArray . length )
      {
        if ( activeIndex != index )
        {
          activeIndex = index ;
          setState ( activeIndex , 0 ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
        }
      }
    }
/*
** Gets the active index.
*/
    public function getActiveIndex ( ) : int
    {
      return activeIndex ;
    }
/*
** Gets the text code of the active button.
*/
    public function getActiveTextCode ( ) : String
    {
      if ( activeIndex == - 1 )
      {
        return "" ;
      }
      else
      {
        return ButtonLink ( buttonLinksArray [ activeIndex ] ) . getTextCode ( ) ;
      }
    }
/*
** Sets the elements.
** index: marks as the state says.
** activeIndex: let it be as state 2.
*/
    private function setState ( index : int , state : int ) : void
    {
      var buttonLink : ButtonLink = null ;
      for ( var i : int = 0 ; i < buttonLinksArray . length ; i ++ )
      {
        buttonLink = ButtonLink ( buttonLinksArray [ i ] ) ;
        if ( i != activeIndex )
        {
          if ( i != index )
          {
            buttonLink . setState ( 2 ) ;
          }
          else
          {
            buttonLink . setState ( state ) ;
          }
        }
        else
        {
          buttonLink . setState ( 0 ) ;
        }
      }
    }
/*
** Gets the current element from the mouseX of content.
*/
    private function getActualElementIndexByMouse ( ) : int
    {
      var index : int = - 1 ;
      var buttonLink : ButtonLink = null ;
      for ( var i : int = 0 ; i < buttonLinksArray . length ; i ++ )
      {
        buttonLink = ButtonLink ( buttonLinksArray [ i ] ) ;
        if ( content . mouseX > buttonLink . getcx ( ) && content . mouseX < buttonLink . getcxsw ( ) )
        {
          index = i ;
          break ;
        }
      }
      buttonLink = null ;
      return index ;
    }
/*
** Adds a button to the list of the buttons.
*/
    public function addButton ( label : String ) : void
    {
      var buttonLink : ButtonLink = new ButtonLink ( application ) ;
      content . addChild ( buttonLink ) ;
      buttonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
      buttonLink . setTextCode ( label ) ;
      buttonLinksArray . push ( buttonLink ) ;
      reposButtons ( ) ;
    }
/*
** Removes a button from the list.
*/
    public function removeButton ( i : int ) : void
    {
      var buttonLink : ButtonLink = null ;
      if ( i >= 0 && i < buttonLinksArray . length )
      {
        buttonLink = ButtonLink ( buttonLinksArray [ i ] ) ;
        buttonLink . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
        buttonLink . destroy ( ) ;
        content . removeChild ( buttonLink ) ;
        buttonLink = null ;
        buttonLinksArray . splice ( i , 1 ) ;
        reposButtons ( ) ;
      }
    }
/*
** Removes all of the buttons.
*/
    public function removeAllButtons ( ) : void
    {
      var buttonLink : ButtonLink = null ;
      for ( var i : int = 0 ; i < buttonLinksArray . length ; i ++ )
      {
        buttonLink = ButtonLink ( buttonLinksArray [ i ] ) ;
        buttonLink . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
        buttonLink . destroy ( ) ;
        content . removeChild ( buttonLink ) ;
        buttonLink = null ;
      }
      buttonLinksArray . splice ( 0 ) ;
      reposButtons ( ) ;
    }
/*
** Repositioning of the buttons.
*/
    private function reposButtons ( ) : void
    {
      if ( application != null )
      {
// If the array is empty
        if ( buttonLinksArray . length == 0 )
        {
// Then the sizes are zero-zero.
          super . setswh ( 0 , 0 ) ;
        }
        else
        {
// Else we have to loop on the array.
          for ( var i : int = 0 ; i < buttonLinksArray . length ; i ++ )
          {
            if ( i == 0 )
            {
// The first button has to be positioned into the first place.
              ButtonLink ( buttonLinksArray [ i ] ) . setcxy ( application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 + application . getPropsDyn ( ) . getAppPadding ( ) * 2 , application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
            }
            else
            {
// The second and the others have to be placed by the previous button.
              ButtonLink ( buttonLinksArray [ i ] ) . setcxy ( ButtonLink ( buttonLinksArray [ i - 1 ] ) . getcx ( ) + ButtonLink ( buttonLinksArray [ i - 1 ] ) . getsw ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) , ButtonLink ( buttonLinksArray [ i - 1 ] ) . getcy ( ) ) ;
            }
// The size of the content object has to be reset if the current button is the last.
            if ( i == buttonLinksArray . length - 1 )
            {
              content . setswh ( ButtonLink ( buttonLinksArray [ i ] ) . getcx ( ) + ButtonLink ( buttonLinksArray [ i ] ) . getsw ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 + application . getPropsDyn ( ) . getAppPadding ( ) * 2 , ButtonLink ( buttonLinksArray [ i ] ) . getsh ( ) + 4 * application . getPropsDyn ( ) . getAppLineThickness ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
            }
          }
// The size of the current buttonbar object has to be specified now.
          if ( maxWidth == 0 )
          {
            super . setswh ( content . getsw ( ) , content . getsh ( ) ) ;
          }
          else
          {
            super . setswh ( Math . min ( content . getsw ( ) , maxWidth ) , content . getsh ( ) ) ;
          }
        }
// The scroll also has to be resized.
        baseScroll . setswh ( getsw ( ) , getsh ( ) ) ;
      }
    }
/*
** Resizing the button bar because of the resizing of an element.
*/
    private function resize ( e : Event ) : void
    {
      reposButtons ( ) ;
    }
/*
** The content has been resized -> the size of the content of the base scroll has to be resized too.
*/
    private function contentResized ( e : Event ) : void
    {
      baseScroll . setscwch ( content . getsw ( ) , content . getsh ( ) ) ;
    }
/*
** The set size methods have to have no effects.
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
      removeAllButtons ( ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OUT , moverRollOut ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      buttonLinksArray = null ;
      baseScroll = null ;
      content = null ;
      activeIndex = 0 ;
      eventChanged = null ;
      maxWidth = 0 ;
      origMouseX = 0 ;
      origMouseY = 0 ;
    }
  }
}