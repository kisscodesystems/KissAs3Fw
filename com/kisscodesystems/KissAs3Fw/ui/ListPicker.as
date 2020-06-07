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
** ListPicker.
** Usually known as combobox. Combination of a text and a list.
**
** MAIN FEATURES:
** - openable component, has a text label in a base working button and a list.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseOpen ;
  import flash . events . Event ;
  public class ListPicker extends BaseOpen
  {
// The label object to display the label belonging to the actual value.
    private var textLabel : TextLabel = null ;
// The list of this listpicker.
    private var list : ListPanel = null ;
// The event to the outside world of the changing of the selected items.
    private var eventChanged : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ListPicker ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating the components.
      textLabel = new TextLabel ( application ) ;
      baseWorkingButton . getContentSprite ( ) . addChild ( textLabel ) ;
      reposResizeLabel ( ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      list = new ListPanel ( application ) ;
      contentSprite . addChild ( list ) ;
      list . setMultiple ( false ) ;
      list . setCanBeEmpty ( false ) ;
// These are the events to listen to.
      list . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , selectedItemChanged ) ;
      list . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , listResized ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// The default color has been changed, message to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
    }
/*
** Sets the property of when should the selected event be thrown.
** (Default: single object, the selected event will be dispatched when the selected item changes.)
*/
    public function setAlwaysDispatchSelectedEvent ( b : Boolean ) : void
    {
      if ( list != null )
      {
        list . setAlwaysDispatchSelectedEvent ( b ) ;
      }
    }
/*
** The list has been resized so the content of this has to be updated.
*/
    private function listResized ( e : Event ) : void
    {
      contentSprite . setswh ( list . getsw ( ) , list . getsh ( ) ) ;
      if ( isOpened ( ) )
      {
        super . setswh ( list . getsw ( ) , list . getsh ( ) ) ;
      }
    }
/*
** Sets the selected index.
*/
    public function setSelectedIndex ( index : int ) : void
    {
      if ( getSelectedIndex ( ) != index )
      {
        list . setSelectedIndexes ( [ index ] ) ;
      }
    }
/*
** Clears the picker, without changed event.
*/
    public function clearSelectedIndex ( ) : void
    {
      list . clearSelectedIndexes ( ) ;
      textLabel . setTextCode ( "" ) ;
    }
/*
** Gets the selected index.
*/
    public function getSelectedIndex ( ) : int
    {
      return list . getSelectedIndexes ( ) [ 0 ] ;
    }
/*
** The selected item has been changed.
*/
    private function selectedItemChanged ( e : Event ) : void
    {
      close ( ) ;
      if ( getSelectedIndex ( ) != - 1 )
      {
        textLabel . setTextCode ( list . getArrayLabels ( ) [ getSelectedIndex ( ) ] ) ;
      }
      else
      {
        textLabel . setTextCode ( "" ) ;
      }
      dispatchEventChanged ( ) ;
    }
/*
** Dispatches the event of changing.
*/
    private function dispatchEventChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
    }
/*
** Sets the elements to be displayed.
*/
    public function setNumOfElements ( num : int ) : void
    {
      list . setNumOfElements ( num ) ;
    }
/*
** Sets the arrays of the list to be displayed.
*/
    public function setArrays ( labels : Array , values : Array ) : void
    {
      list . setArrays ( labels , values ) ;
    }
/*
** Repositioning the Label.
*/
    private function reposResizeLabel ( ) : void
    {
      textLabel . setMaxWidth ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) , false ) ;
      textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
    }
/*
** When the text label has been resized.
*/
    private function resize ( e : Event ) : void
    {
      if ( application != null )
      {
        if ( ! isOpened ( ) )
        {
          shToLabel ( ) ;
          reposResizeLabel ( ) ;
        }
      }
    }
/*
** Sets the sh to the size of label.
*/
    private function shToLabel ( ) : void
    {
      super . setsh ( textLabel . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
    }
/*
** Gets the type of the text used in the list.
*/
    public function getTextType ( ) : String
    {
      return textLabel . getTextType ( ) ;
    }
/*
** Gets the text currently having in the label..
*/
    public function getText ( ) : String
    {
      return textLabel . getPlainText ( ) ;
    }
/*
** The labels array.
*/
    public function getArrayLabels ( ) : Array
    {
      return list . getArrayLabels ( ) ;
    }
/*
** The values array.
*/
    public function getArrayValues ( ) : Array
    {
      return list . getArrayValues ( ) ;
    }
/*
** Override open:
** - the list has to start from the correct index
** - the size will be changed
** - calls the original open method.
*/
    override public function open ( ) : void
    {
      list . setStartIndex ( Math . min ( list . getArrayLabels ( ) . length - list . getNumOfElements ( ) , getSelectedIndex ( ) ) ) ;
      super . setsh ( contentSprite . getsh ( ) ) ;
      super . open ( ) ;
    }
/*
** Override close:
** - calls the original close method
** - the size will be reduced to the size of the label (and paddings)
*/
    override public function close ( ) : void
    {
      super . close ( ) ;
      shToLabel ( ) ;
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** The sh depends on the number of elements to be displayed and of the size of the label (and paddings)
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        reposResizeLabel ( ) ;
        list . setsw ( getsw ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      textLabel = null ;
      list = null ;
      eventChanged = null ;
    }
  }
}