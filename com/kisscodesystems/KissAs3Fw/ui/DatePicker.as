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
** DatePicker.
** This is an openable version of the Date class.
**
** MAIN FEATURES:
** - openable component, has a text label in a base working button and a list.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseOpen ;
  import flash . events . Event ;
  public class DatePicker extends BaseOpen
  {
// The label object to display the label belonging to the actual value.
    private var textLabel : TextLabel = null ;
// The list of this listpicker.
    private var datePanel : DatePanel = null ;
// The event to the outside world of the changing of the selected items.
    private var eventChanged : Event = null ;
// It is necessary to store the width of the closed date picker.
    private var closedWidth : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function DatePicker ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating the components.
      textLabel = new TextLabel ( application ) ;
      baseWorkingButton . getContentSprite ( ) . addChild ( textLabel ) ;
      reposResizeLabel ( ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      datePanel = new DatePanel ( application ) ;
      contentSprite . addChild ( datePanel ) ;
// These are the events to listen to.
      datePanel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , selectedItemChanged ) ;
      datePanel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , datePanelResized ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// The default color has been changed, message to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// This will help to initialize the size of the contentSprite.
      contentSprite . setswh ( datePanel . getsw ( ) , datePanel . getsh ( ) ) ;
    }
/*
** The list has been resized so the content of this has to be updated.
*/
    private function datePanelResized ( e : Event ) : void
    {
      contentSprite . setswh ( datePanel . getsw ( ) , datePanel . getsh ( ) ) ;
      if ( isOpened ( ) )
      {
        super . setswh ( datePanel . getsw ( ) , datePanel . getsh ( ) ) ;
      }
    }
/*
** Sets the selected date.
** This will dispatch the selected event while the panel won't.
*/
    public function setSelectedDate ( date : Date ) : void
    {
      if ( datePanel != null && textLabel != null )
      {
        datePanel . setSelectedDate ( date ) ;
        textLabel . setTextCode ( datePanel . getDisplayedDate ( ) ) ;
        dispatchEventChanged ( ) ;
      }
    }
/*
** Gets the date format used to display date.
*/
    public function getDateFormat ( ) : String
    {
      if ( datePanel != null )
      {
        return datePanel . getDateFormat ( ) ;
      }
      return "" ;
    }
/*
** Gets the displayed date.
*/
    public function getDisplayedDate ( ) : String
    {
      if ( textLabel != null )
      {
        return textLabel . getTextCode ( ) ;
      }
      else
      {
        return "" ;
      }
    }
/*
** Gets the selected date (object).
*/
    public function getSelectedDateObject ( ) : Date
    {
      if ( datePanel != null )
      {
        return datePanel . getSelectedDateObject ( ) ;
      }
      else
      {
        return null ;
      }
    }
/*
** Gets the selected date (string).
*/
    public function getSelectedDate ( ) : String
    {
      if ( datePanel != null )
      {
        return datePanel . getSelectedDate ( ) ;
      }
      else
      {
        return "" ;
      }
    }
/*
** Sets the hoursAndMinutes property.
*/
    public function setHoursAndMinutes ( v : Boolean ) : void
    {
      if ( datePanel != null )
      {
        datePanel . setHoursAndMinutes ( v ) ;
      }
    }
/*
** The selected item has been changed.
*/
    private function selectedItemChanged ( e : Event ) : void
    {
      close ( ) ;
      textLabel . setTextCode ( datePanel . getDisplayedDate ( ) ) ;
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
** Gets the text currently having in the label..
*/
    public function getText ( ) : String
    {
      return textLabel . getBaseTextField ( ) . getPlainText ( ) ;
    }
/*
** Override open:
** - the list has to start from the correct index
** - the size will be changed
** - calls the original open method.
*/
    override public function open ( ) : void
    {
      super . setswh ( contentSprite . getsw ( ) , contentSprite . getsh ( ) ) ;
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
      if ( closedWidth > 0 )
      {
        super . setsw ( closedWidth ) ;
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** setsw changes only the width of the text label.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        closedWidth = newsw ;
        super . setsw ( newsw ) ;
        reposResizeLabel ( ) ;
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
      datePanel = null ;
      eventChanged = null ;
      closedWidth = 0 ;
    }
  }
}
