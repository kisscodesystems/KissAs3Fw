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
** DatePanel.
** This object can show the days in calendar view.
** The DatePicker will use it.
** The first day of the week will always be monday as it will
** handle the weeks.
** All of the elements will be created at the beginning and the
** visible properties will be set to hide unused days and week numbers.
**
** MAIN FEATURES:
** - date panel with increasing/decreasing of year and month
** - hours and minutes are available to display and select
**
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . display . Shape ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . globalization . DateTimeFormatter ;
  public class DatePanel extends BaseSprite
  {
// The event of the changing of the selected items.
    private var eventChanged : Event = null ;
// The date object to be used to calculate the actual displaying.
    private var currentDateObject : Date = null ;
// Can select hours and minutes or not.
    private var hoursAndMinutes : Boolean = false ;
// And the stuffs that will be used to select the hour and minute property.
    private var hoursLabelArray : Array = null ;
    private var hoursValueArray : Array = null ;
    private var hoursListPicker : ListPicker = null ;
    private var minutesLabelArray : Array = null ;
    private var minutesValueArray : Array = null ;
    private var minutesListPicker : ListPicker = null ;
    private var hmSepTextLabel : TextLabel = null ;
// This will be the background that can be painted.
    private var background : Shape = null ;
// The date format to apply when displaying the current date.
// Has to be the format of as3!
    private var dateFormat : String = null ;
    private var dateFormatter : DateTimeFormatter = null ;
// The main objects of this panel.
    private var firstButtonText : ButtonText = null ;
    private var leftButtonText : ButtonText = null ;
    private var dateTextLabel : TextLabel = null ;
    private var rightButtonText : ButtonText = null ;
    private var lastButtonText : ButtonText = null ;
    private var monthsCodesArray : Array = null ;
    private var weekdaysCodesArray : Array = null ;
    private var weekdaysElementsArray : Array = null ;
    private var weeksElementsArray : Array = null ;
    private var daysElementsArray : Array = null ;
    private var todayButtonLink : ButtonLink = null ;
// The width of an element will be this to nice positioning.
    private var allElementsW : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function DatePanel ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The hours and minutes arrays first.
      hoursLabelArray = new Array ( ) ;
      hoursValueArray = new Array ( ) ;
      for ( var i : int = 0 ; i < 24 ; i ++ )
      {
        hoursLabelArray . push ( i < 10 ? "0" + i : "" + i ) ;
        hoursValueArray . push ( i ) ;
      }
      minutesLabelArray = new Array ( ) ;
      minutesValueArray = new Array ( ) ;
      for ( var j : int = 0 ; j < 60 ; j ++ )
      {
        minutesLabelArray . push ( j < 10 ? "0" + j : "" + j ) ;
        minutesValueArray . push ( j ) ;
      }
// Tha background is on the deepest layer.
      background = new Shape ( ) ;
      addChild ( background ) ;
// The event of changing needs to be constructed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// The date formatter object at first!
      dateFormatter = new DateTimeFormatter ( "en-US" ) ;
// The date format by default.
      setDateFormat ( application . ASDATEFORMAT ) ;
// The dates has to be initialized as the zero.
      currentDateObject = new Date ( ) ;
// This events are required now. (application baselist basescroll)
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
// These arrays has to be initialized once.
      weekdaysCodesArray = application . getTextStock ( ) . getTextCodesWeekdays ( ) ;
      monthsCodesArray = application . getTextStock ( ) . getTextCodesMonths ( ) ;
// Creating first and left buttons (first: year--, left: month--)
      firstButtonText = new ButtonText ( application ) ;
      addChild ( firstButtonText ) ;
      firstButtonText . setTextCode ( "«" ) ;
      firstButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
      firstButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , firstButtonTextClicked ) ;
      leftButtonText = new ButtonText ( application ) ;
      addChild ( leftButtonText ) ;
      leftButtonText . setTextCode ( "‹" ) ;
      leftButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
      leftButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , leftButtonTextClicked ) ;
// Adding the displaying of the currently selected date.
      dateTextLabel = new TextLabel ( application ) ;
      addChild ( dateTextLabel ) ;
      dateTextLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      dateTextLabel . setTextCode ( "Date.." ) ;
      dateTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposDateTextLabel ) ;
// Creating right and last buttons (right: month++, last: year++)
      rightButtonText = new ButtonText ( application ) ;
      addChild ( rightButtonText ) ;
      rightButtonText . setTextCode ( "›" ) ;
      rightButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
      rightButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , rightButtonTextClicked ) ;
      lastButtonText = new ButtonText ( application ) ;
      addChild ( lastButtonText ) ;
      lastButtonText . setTextCode ( "»" ) ;
      lastButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
      lastButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , lastButtonTextClicked ) ;
// The today button is the next, the current date (by local time) wil be selected.
      todayButtonLink = new ButtonLink ( application ) ;
      addChild ( todayButtonLink ) ;
      todayButtonLink . setTextCode ( application . getTexts ( ) . TODAY ) ;
      todayButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
      todayButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , todayButtonLinkClicked ) ;
// The containers first to avoid loops on null references.
      weekdaysElementsArray = new Array ( ) ;
      daysElementsArray = new Array ( ) ;
      weeksElementsArray = new Array ( ) ;
// Creating all of the elements of weekdays, weeknumbers and dates.
// Weekdays first.
      for ( var k : int = 0 ; k < weekdaysCodesArray . length ; k ++ )
      {
        var label : TextLabel = new TextLabel ( application ) ;
        addChild ( label ) ;
        label . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , objectsSizesChanged ) ;
        label . setTextCode ( weekdaysCodesArray [ k ] ) ;
        weekdaysElementsArray . push ( label ) ;
      }
// The days of the month.
      for ( var l : int = 1 ; l <= 31 ; l ++ )
      {
        var label1 : TextLabel = new TextLabel ( application ) ;
        addChild ( label1 ) ;
        label1 . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
        label1 . setTextCode ( l <= 9 ? "0" + l : "" + l ) ;
        label1 . addEventListener ( MouseEvent . CLICK , dayClicked ) ;
        label1 . addEventListener ( MouseEvent . MOUSE_OVER , dayMouseOver ) ;
        label1 . addEventListener ( MouseEvent . MOUSE_OUT , dayMouseOut ) ;
        label1 . addEventListener ( MouseEvent . MOUSE_DOWN , dayMouseDown ) ;
        daysElementsArray . push ( label1 ) ;
      }
// And the number of the weeks finally.
      var currentNumberOfWeek : int = 0 ;
      for ( var m : int = 0 ; m < 6 ; m ++ )
      {
        var label2 : TextLabel = new TextLabel ( application ) ;
        addChild ( label2 ) ;
        weeksElementsArray . push ( label2 ) ;
        currentNumberOfWeek = getCurrentWeek ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) , m * weekdaysCodesArray . length + 1 ) ) ;
        label2 . setTextCode ( String ( currentNumberOfWeek ) ) ;
      }
      reposElements ( ) ;
      setSelectedDate ( currentDateObject ) ;
    }
/*
** When the size of any of the label buttons has been changed.
*/
    private function objectsSizesChanged ( e : Event ) : void
    {
      reposElements ( ) ;
    }
/*
** Will calculate the number of the week from the given date object.
** jan 1 on mon,tue,wed,thu - that is W01
** jan 1 on fri,sat,sun - that is W52 or W53 of the prev. year
** and the W01 will start from the next monday.
*/
    private function getCurrentWeek ( theDate : Date ) : int
    {
      var firstDateOfTheYear : Date = new Date ( theDate . getFullYear ( ) , 0 , 1 ) ;
      var firstDayOfTheYear : int = ( firstDateOfTheYear . getDay ( ) + ( weekdaysCodesArray . length - 1 ) ) % weekdaysCodesArray . length ;
      var firstDateOfThatWeek : Date = new Date ( theDate . getFullYear ( ) , 0 , 1 ) ;
      while ( firstDateOfThatWeek . getDay ( ) != 1 )
      {
        firstDateOfThatWeek . setDate ( firstDateOfThatWeek . getDate ( ) - 1 ) ;
      }
      var weekNumber : int = 1 - ( firstDayOfTheYear < 3 ? 0 : 1 ) ;
      while ( true )
      {
        firstDateOfThatWeek . setDate ( firstDateOfThatWeek . getDate ( ) + 1 ) ;
        if ( firstDateOfThatWeek . getDay ( ) == 1 )
        {
          weekNumber ++ ;
        }
        if ( firstDateOfThatWeek . getTime ( ) >= theDate . getTime ( ) )
        {
          break ;
        }
      }
      if ( weekNumber == 0 )
      {
        return getCurrentWeek ( new Date ( firstDateOfThatWeek . getFullYear ( ) , firstDateOfThatWeek . getMonth ( ) , firstDateOfThatWeek . getDate ( ) - 1 ) ) ;
      }
      else
      {
        return weekNumber ;
      }
    }
/*
** Repositions all of the elements.
*/
    private function reposElements ( ) : void
    {
      reposDaysWeeksWeekdays ( ) ;
      reposStaticContent ( ) ;
    }
/*
** Repositions the static content: buttons and date textfield.
** This should happen after the others because the size of this
** datepanel object depends on the positions of the actual month.
*/
    public function reposStaticContent ( ) : void
    {
      var lineThickness : int = application . getPropsDyn ( ) . getAppLineThickness ( ) ;
      var padding : int = application . getPropsDyn ( ) . getAppPadding ( ) ;
      if ( firstButtonText != null )
      {
        firstButtonText . setcxy ( lineThickness , lineThickness ) ;
        if ( leftButtonText != null )
        {
          leftButtonText . setcxy ( firstButtonText . getcxsw ( ) + lineThickness , firstButtonText . getcy ( ) ) ;
          if ( lastButtonText != null )
          {
            lastButtonText . setcxy ( getsw ( ) - lastButtonText . getsw ( ) - lineThickness , firstButtonText . getcy ( ) ) ;
            if ( rightButtonText != null )
            {
              rightButtonText . setcxy ( lastButtonText . getcx ( ) - rightButtonText . getsw ( ) - lineThickness , lastButtonText . getcy ( ) ) ;
              reposDateTextLabel ( ) ;
              if ( hoursAndMinutes )
              {
                if ( hoursListPicker != null && hmSepTextLabel != null && minutesListPicker != null )
                {
                  hoursListPicker . setsw ( firstButtonText . getsw ( ) + rightButtonText . getsw ( ) ) ;
                  hoursListPicker . setcxy ( ( getsw ( ) - 2 * lineThickness - 2 * hoursListPicker . getsw ( ) - hmSepTextLabel . getsw ( ) ) / 2 , firstButtonText . getcysh ( ) + lineThickness ) ;
                  hmSepTextLabel . setcxy ( hoursListPicker . getcxsw ( ) + lineThickness , hoursListPicker . getcy ( ) + padding ) ;
                  minutesListPicker . setsw ( hoursListPicker . getsw ( ) ) ;
                  minutesListPicker . setcxy ( hmSepTextLabel . getcxsw ( ) + lineThickness , hoursListPicker . getcy ( ) ) ;
                }
              }
            }
          }
        }
        if ( todayButtonLink != null )
        {
          if ( hoursAndMinutes && hoursListPicker != null && minutesListPicker != null )
          {
            todayButtonLink . setcxy ( firstButtonText . getcx ( ) , Math . max ( hoursListPicker . getcysh ( ) , minutesListPicker . getcysh ( ) ) + lineThickness ) ;
          }
          else
          {
            todayButtonLink . setcxy ( firstButtonText . getcx ( ) , firstButtonText . getcysh ( ) + lineThickness ) ;
          }
        }
      }
    }
/*
** Repositions the day and week and weekday objects only.
** The buttons and the date displaying remain untouched.
*/
    private function reposDaysWeeksWeekdays ( ) : void
    {
// The references to the values of that properties (for less typing)
      var lineThickness : int = application . getPropsDyn ( ) . getAppLineThickness ( ) ;
      var padding : int = application . getPropsDyn ( ) . getAppPadding ( ) ;
// This can be calculated now: how about the width of the elements we will display.
      allElementsW = 0 ;
      for ( var j : int = 0 ; j < weekdaysElementsArray . length ; j ++ )
      {
        if ( weekdaysElementsArray [ j ] is TextLabel )
        {
          if ( allElementsW < TextLabel ( weekdaysElementsArray [ j ] ) . getsw ( ) )
          {
            allElementsW = TextLabel ( weekdaysElementsArray [ j ] ) . getsw ( ) ;
          }
        }
      }
// These positions are essential, many further objects depend on it.
      var iniXweekdays : int = 0 ;
      var weekdaysY : int = 0 ;
      var weeksX : int = 0 ;
      var iniYweeks : int = 0 ;
      var currentXdays : int = 0 ;
      var currentYdays : int = 0 ;
      if ( firstButtonText != null )
      {
        iniXweekdays = Math . max ( allElementsW , firstButtonText . getsw ( ) ) + 2 * lineThickness ;
        if ( hoursAndMinutes && hoursListPicker != null && minutesListPicker != null )
        {
          weekdaysY = Math . max ( hoursListPicker . getcysh ( ) , minutesListPicker . getcysh ( ) ) + lineThickness + padding ;
        }
        else
        {
          weekdaysY = firstButtonText . getcysh ( ) + lineThickness + padding ;
        }
        iniYweeks = weekdaysY + firstButtonText . getsh ( ) - padding ;
        weeksX = firstButtonText . getcx ( ) ;
        currentXdays = iniXweekdays + ( allElementsW + lineThickness ) * getFirstDayDelta ( ) ;
        currentYdays = iniYweeks ;
      }
// Weekdays first.
// Will be positioned from the first weekday label position
      var lastWeekdayPos : int = 0 ;
      for ( var i : int = 0 ; i < weekdaysElementsArray . length ; i ++ )
      {
        if ( weekdaysElementsArray [ i ] is TextLabel )
        {
          TextLabel ( weekdaysElementsArray [ i ] ) . setcxy ( iniXweekdays + ( ( i + weekdaysElementsArray . length ) % weekdaysElementsArray . length ) * ( allElementsW + lineThickness ) , weekdaysY ) ;
          if ( lastWeekdayPos < TextLabel ( weekdaysElementsArray [ i ] ) . getcx ( ) )
          {
            lastWeekdayPos = TextLabel ( weekdaysElementsArray [ i ] ) . getcx ( ) ;
          }
        }
      }
// The days of the month.
// currentDateObject . getDay ( )   0:sun 1:mon 2:tue ...
      var weeksVisible : int = 0 ;
      for ( var l : int = 0 ; l < daysElementsArray . length ; l ++ )
      {
        if ( daysElementsArray [ l ] is TextLabel )
        {
          TextLabel ( daysElementsArray [ l ] ) . setcxy ( currentXdays , currentYdays ) ;
          TextLabel ( daysElementsArray [ l ] ) . visible = l < getMonthLength ( ) ;
          currentXdays += allElementsW + lineThickness ;
          if ( currentXdays > lastWeekdayPos )
          {
            currentXdays = iniXweekdays ;
            currentYdays += TextLabel ( daysElementsArray [ l ] ) . getsh ( ) + lineThickness ;
            if ( l < getMonthLength ( ) - 1 )
            {
              weeksVisible ++ ;
            }
          }
        }
      }
// And the number of the weeks finally.
// Will be positioned to the very first column.
      var currentNumberOfWeek : int = 0 ;
      for ( var k : int = 0 ; k < weeksElementsArray . length ; k ++ )
      {
        if ( weeksElementsArray [ k ] is TextLabel )
        {
          if ( weeksElementsArray [ k ] is TextLabel )
          {
            currentNumberOfWeek = getCurrentWeek ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) , k * weekdaysCodesArray . length + 1 ) ) ;
            TextLabel ( weeksElementsArray [ k ] ) . setTextCode ( String ( currentNumberOfWeek ) ) ;
            TextLabel ( weeksElementsArray [ k ] ) . setcxy ( weeksX , iniYweeks + k * ( TextLabel ( weeksElementsArray [ k ] ) . getsh ( ) + lineThickness ) ) ;
            TextLabel ( weeksElementsArray [ k ] ) . visible = k <= weeksVisible ;
            if ( k == weeksVisible )
            {
              super . setswh ( lastWeekdayPos + allElementsW + lineThickness , TextLabel ( weeksElementsArray [ k ] ) . getcysh ( ) + lineThickness ) ;
            }
          }
        }
      }
// The repainting of the days has to be done at this point!
      paintDatesToBackground ( true ) ;
    }
/*
** To set the dateformat.
*/
    public function setDateFormat ( df : String ) : void
    {
      dateFormat = df ;
      dateFormatter . setDateTimePattern ( dateFormat ) ;
      dateDisplay ( ) ;
    }
    public function getDateFormat ( ) : String
    {
      return dateFormat ;
    }
/*
** Displaying the actual date.
*/
    private function dateDisplay ( ) : void
    {
      if ( dateTextLabel != null && dateFormatter != null )
      {
        var dateToDisplay : String = dateFormatter . format ( currentDateObject ) ;
        dateTextLabel . setTextCode ( dateToDisplay ) ;
      }
      paintDatesToBackground ( false ) ;
    }
/*
** The event listeners of the navigation buttons (first, left, right, last today)
*/
    private function firstButtonTextClicked ( e : Event ) : void
    {
      if ( firstButtonText != null )
      {
        setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) - 1 , currentDateObject . getMonth ( ) , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
        firstButtonText . setEnabled ( true ) ;
      }
    }
    private function leftButtonTextClicked ( e : Event ) : void
    {
      if ( leftButtonText != null )
      {
        setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) - 1 , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
        leftButtonText . setEnabled ( true ) ;
      }
    }
    private function rightButtonTextClicked ( e : Event ) : void
    {
      if ( rightButtonText != null )
      {
        setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) + 1 , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
        rightButtonText . setEnabled ( true ) ;
      }
    }
    private function lastButtonTextClicked ( e : Event ) : void
    {
      if ( lastButtonText != null )
      {
        setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) + 1 , currentDateObject . getMonth ( ) , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
        lastButtonText . setEnabled ( true ) ;
      }
    }
    private function todayButtonLinkClicked ( e : Event ) : void
    {
      setSelectedDate ( new Date ( ) ) ;
      dispatchSelectedChanged ( ) ;
    }
    private function dayClicked ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) && e != null && e . target != null && e . target . parent is TextLabel )
      {
        setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) , TextLabel ( e . target . parent ) . getTextCode ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
        dispatchSelectedChanged ( ) ;
      }
    }
    private function dayMouseOver ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) && background != null && e != null && e . target != null && e . target . parent is TextLabel )
      {
        background . graphics . clear ( ) ;
        paintRect ( TextLabel ( e . target . parent ) , false , application . getPropsApp ( ) . getDatePanelAlphaMouseOver ( ) ) ;
        paintDatesToBackground ( false ) ;
      }
    }
    private function dayMouseDown ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) && background != null && e != null && e . target != null && e . target . parent is TextLabel )
      {
        background . graphics . clear ( ) ;
        paintRect ( TextLabel ( e . target . parent ) , false , application . getPropsApp ( ) . getDatePanelAlphaMouseDown ( ) ) ;
        paintDatesToBackground ( false ) ;
      }
    }
    private function dayMouseOut ( e : MouseEvent ) : void
    {
      if ( getEnabled ( ) )
      {
        paintDatesToBackground ( true ) ;
      }
    }
/*
** Handles the painting of the background (one single rectangle).
** Doesn't clear the graphics just paints.
*/
    private function paintRect ( textLabel : TextLabel , border : Boolean , fillAlpha : Number ) : void
    {
      if ( background != null && textLabel != null )
      {
        background . graphics . lineStyle ( border ? application . getPropsDyn ( ) . getAppLineThickness ( ) : 0 , application . getPropsDyn ( ) . getAppFontColorDark ( ) , border ? 1 : 0 , true ) ;
        background . graphics . beginFill ( application . getPropsDyn ( ) . getAppFontColorDark ( ) , fillAlpha ) ;
        background . graphics . drawRect ( textLabel . getcx ( ) , textLabel . getcy ( ) , textLabel . getsw ( ) , textLabel . getsh ( ) ) ;
        background . graphics . endFill ( ) ;
      }
    }
/*
** The selected date and/or today is visible or not.
** If these are currently visible then we want to display this fact by drawing a rectangle below.
*/
    private function paintDatesToBackground ( toClear : Boolean ) : void
    {
// The background and the date object to calculate are necessary of course.
      if ( background != null && daysElementsArray != null )
      {
// Clearing the background shape is specified.
        if ( toClear )
        {
          background . graphics . clear ( ) ;
        }
// The date of current date will be searched for. It will get the rectangle is visible.
        if ( daysElementsArray [ currentDateObject . getDate ( ) - 1 ] is TextLabel )
        {
          paintRect ( TextLabel ( daysElementsArray [ currentDateObject . getDate ( ) - 1 ] ) , false , application . getPropsApp ( ) . getDatePanelAlphaMouseOver ( ) ) ;
        }
// And the date of today too.
        var today : Date = new Date ( ) ;
        if ( currentDateObject . getFullYear ( ) == today . getFullYear ( ) && currentDateObject . getMonth ( ) == today . getMonth ( ) )
        {
          if ( daysElementsArray [ today . getDate ( ) - 1 ] is TextLabel )
          {
            paintRect ( TextLabel ( daysElementsArray [ today . getDate ( ) - 1 ] ) , true , 0 ) ;
          }
        }
      }
    }
/*
** This will be the delta of the first day of the month.
** (Where should we start the current month.)
*/
    private function getFirstDayDelta ( ) : int
    {
      if ( weekdaysElementsArray != null )
      {
        var date0 : Date = new Date ( currentDateObject . getFullYear ( ) , currentDateObject . month , 1 ) ;
        return ( date0 . getDay ( ) - 1 + weekdaysElementsArray . length ) % weekdaysElementsArray . length ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** Repositions only the date text label.
*/
    private function reposDateTextLabel ( e : Event = null ) : void
    {
      if ( dateTextLabel != null )
      {
        var lineThickness : int = application . getPropsDyn ( ) . getAppLineThickness ( ) ;
        var padding : int = application . getPropsDyn ( ) . getAppPadding ( ) ;
        dateTextLabel . setcxy ( ( getsw ( ) - dateTextLabel . getsw ( ) ) / 2 , lineThickness + padding ) ;
      }
    }
/*
** Removes the elements of the hours and minutes.
*/
    private function removeElementsOfHoursAndMinutes ( ) : void
    {
      if ( hoursListPicker != null )
      {
        if ( contains ( hoursListPicker ) )
        {
          hoursListPicker . destroy ( ) ;
          removeChild ( hoursListPicker ) ;
        }
        hoursListPicker = null ;
      }
      if ( hmSepTextLabel != null )
      {
        if ( contains ( hmSepTextLabel ) )
        {
          hmSepTextLabel . destroy ( ) ;
          removeChild ( hmSepTextLabel ) ;
        }
        hmSepTextLabel = null ;
      }
      if ( minutesListPicker != null )
      {
        if ( contains ( minutesListPicker ) )
        {
          minutesListPicker . destroy ( ) ;
          removeChild ( minutesListPicker ) ;
        }
        minutesListPicker = null ;
      }
    }
/*
** Gets the hoursAndMinutes property.
*/
    public function getHoursAndMinutes ( ) : Boolean
    {
      return hoursAndMinutes ;
    }
/*
** Sets the hoursAndMinutes property.
*/
    public function setHoursAndMinutes ( v : Boolean ) : void
    {
      if ( hoursAndMinutes != v )
      {
        hoursAndMinutes = v ;
        if ( ! hoursAndMinutes )
        {
          removeElementsOfHoursAndMinutes ( ) ;
          setDateFormat ( application . ASDATEFORMAT ) ;
        }
        else
        {
          if ( hoursListPicker == null )
          {
            hoursListPicker = new ListPicker ( application ) ;
            addChild ( hoursListPicker ) ;
            hoursListPicker . setNumOfElements ( 4 ) ;
            hoursListPicker . setArrays ( hoursLabelArray , hoursValueArray ) ;
            hoursListPicker . setSelectedIndex ( 0 ) ;
            hoursListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , hoursOrMinutesResized ) ;
            hoursListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , hoursChanged ) ;
          }
          if ( hmSepTextLabel == null )
          {
            hmSepTextLabel = new TextLabel ( application ) ;
            addChild ( hmSepTextLabel ) ;
            hmSepTextLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
            hmSepTextLabel . setTextCode ( ":" ) ;
          }
          if ( minutesListPicker == null )
          {
            minutesListPicker = new ListPicker ( application ) ;
            addChild ( minutesListPicker ) ;
            minutesListPicker . setNumOfElements ( 4 ) ;
            minutesListPicker . setArrays ( minutesLabelArray , minutesValueArray ) ;
            minutesListPicker . setSelectedIndex ( 0 ) ;
            minutesListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , hoursOrMinutesResized ) ;
            minutesListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , minutesChanged ) ;
            minutesListPicker . setAlwaysDispatchSelectedEvent ( true ) ;
          }
          setDateFormat ( application . ASMINSFORMAT ) ;
        }
        reposElements ( ) ;
      }
    }
/*
** The size of the hour or minute listpicker has changed.
*/
    private function hoursOrMinutesResized ( e : Event ) : void
    {
      reposElements ( ) ;
    }
/*
** The hours or minutes changed so the date displaying might be necessary.
*/
    private function hoursChanged ( e : Event ) : void
    {
      setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
      dateDisplay ( ) ;
    }
    private function minutesChanged ( e : Event ) : void
    {
      setSelectedDate ( new Date ( currentDateObject . getFullYear ( ) , currentDateObject . getMonth ( ) , currentDateObject . getDate ( ) , ( hoursAndMinutes && hoursListPicker != null ) ? hoursListPicker . getSelectedIndex ( ) : 0 , ( hoursAndMinutes && minutesListPicker != null ) ? minutesListPicker . getSelectedIndex ( ) : 0 ) ) ;
      dateDisplay ( ) ;
      dispatchSelectedChanged ( ) ;
    }
/*
** Sets the selected date.
*/
    public function setSelectedDate ( date : Date ) : void
    {
      if ( date == null )
      {
        currentDateObject = new Date ( ) ;
      }
      else
      {
        currentDateObject = new Date ( date . getFullYear ( ) , date . getMonth ( ) , date . getDate ( ) , hoursAndMinutes ? date . getHours ( ) : 0 , hoursAndMinutes ? date . getMinutes ( ) : 0 ) ;
      }
      if ( hoursAndMinutes && hoursListPicker != null )
      {
        hoursListPicker . setSelectedIndex ( date . getHours ( ) ) ;
      }
      if ( hoursAndMinutes && minutesListPicker != null )
      {
        minutesListPicker . setSelectedIndex ( date . getMinutes ( ) ) ;
      }
      reposDaysWeeksWeekdays ( ) ;
      dateDisplay ( ) ;
      paintDatesToBackground ( true ) ;
    }
/*
** Gets the displayed date.
*/
    public function getDisplayedDate ( ) : String
    {
      if ( dateTextLabel != null )
      {
        return dateTextLabel . getBaseTextField ( ) . getPlainText ( ) ;
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
      return new Date ( currentDateObject ) ;
    }
/*
** Gets the selected date (string).
*/
    public function getSelectedDate ( ) : String
    {
      var theDate : String = "" ;
      var month : String = "" + ( currentDateObject . getMonth ( ) + 1 ) ;
      if ( month . length < 2 )
      {
        month = "0" + month ;
      }
      var date : String = "" + currentDateObject . getDate ( ) ;
      if ( date . length < 2 )
      {
        date = "0" + date ;
      }
      theDate = currentDateObject . getFullYear ( ) + "-" + month + "-" + date ;
      if ( hoursAndMinutes && hoursLabelArray != null && minutesLabelArray != null )
      {
        var hour : String = hoursLabelArray [ currentDateObject . getHours ( ) ] ;
        var minute : String = minutesLabelArray [ currentDateObject . getMinutes ( ) ] ;
        return theDate + " " + hour + ":" + minute ;
      }
      else
      {
        return theDate ;
      }
    }
/*
** Override this setEnabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( firstButtonText != null )
      {
        firstButtonText . setEnabled ( e ) ;
      }
      if ( leftButtonText != null )
      {
        leftButtonText . setEnabled ( e ) ;
      }
      if ( rightButtonText != null )
      {
        rightButtonText . setEnabled ( e ) ;
      }
      if ( lastButtonText != null )
      {
        lastButtonText . setEnabled ( e ) ;
      }
      if ( hoursListPicker != null )
      {
        hoursListPicker . setEnabled ( e ) ;
      }
      if ( minutesListPicker != null )
      {
        minutesListPicker . setEnabled ( e ) ;
      }
      if ( todayButtonLink != null )
      {
        todayButtonLink . setEnabled ( e ) ;
      }
    }
/*
** Gets the current date parts.
*/
    private function getCurrentDate ( ) : String
    {
      return String ( currentDateObject . getDate ( ) ) . length == 1 ? "0" + String ( currentDateObject . getDate ( ) ) : String ( currentDateObject . getDate ( ) ) ;
    }
    private function getCurrentMonth ( ) : String
    {
      return String ( currentDateObject . getMonth ( ) + 1 ) . length == 1 ? "0" + String ( currentDateObject . getMonth ( ) + 1 ) : String ( currentDateObject . getMonth ( ) + 1 ) ;
    }
    private function getCurrentMonthLetters ( ) : String
    {
      if ( application != null )
      {
        return application . getTextStock ( ) . getText ( monthsCodesArray [ int ( currentDateObject . getMonth ( ) ) ] ) ;
      }
      else
      {
        return "" ;
      }
    }
    private function getCurrentYear ( ) : String
    {
      return String ( currentDateObject . getFullYear ( ) ) ;
    }
/*
** The year is a leap year or not.
*/
    private function isLeapYear ( ) : Boolean
    {
      return ( int ( getCurrentYear ( ) ) % 4 == 0 && int ( getCurrentYear ( ) ) % 100 != 0 ) || int ( getCurrentYear ( ) ) % 400 == 0 ;
    }
/*
** Selects the length of the month.
*/
    private function getMonthLength ( ) : int
    {
      if ( getCurrentMonth ( ) == "02" )
      {
        if ( ! isLeapYear ( ) )
        {
          return 28 ;
        }
        else
        {
          return 29 ;
        }
      }
      else if ( getCurrentMonth ( ) == "04" || getCurrentMonth ( ) == "06" || getCurrentMonth ( ) == "09" || getCurrentMonth ( ) == "11" )
      {
        return 30 ;
      }
      else
      {
        return 31 ;
      }
    }
/*
** The padding of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
      reposElements ( ) ;
    }
/*
** The line thickness of the application has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
      reposElements ( ) ;
      paintDatesToBackground ( true ) ;
    }
/*
** When the dark text format is changed then the background has to be repainted.
*/
    private function textFormatDarkChanged ( e : Event ) : void
    {
      paintDatesToBackground ( true ) ;
    }
/*
** Dispatches the event of the changing of the selected items.
*/
    private function dispatchSelectedChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventChanged != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** These should not work.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// TODO
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_DARK_CHANGED , textFormatDarkChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( background != null )
      {
        background . graphics . clear ( ) ;
        if ( contains ( background ) )
        {
          removeChild ( background ) ;
        }
      }
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
      if ( weekdaysElementsArray != null )
      {
        for ( var k : int = 0 ; k < weekdaysElementsArray . length ; k ++ )
        {
          TextLabel ( weekdaysElementsArray [ k ] ) . destroy ( ) ;
          removeChild ( TextLabel ( weekdaysElementsArray [ k ] ) ) ;
        }
        weekdaysElementsArray . splice ( 0 ) ;
      }
      if ( weeksElementsArray != null )
      {
        for ( var j : int = 0 ; j < weeksElementsArray . length ; j ++ )
        {
          TextLabel ( weeksElementsArray [ j ] ) . destroy ( ) ;
          removeChild ( TextLabel ( weeksElementsArray [ j ] ) ) ;
        }
        weeksElementsArray . splice ( 0 ) ;
      }
      if ( daysElementsArray != null )
      {
        for ( var i : int = 0 ; i < daysElementsArray . length ; i ++ )
        {
          if ( TextLabel ( daysElementsArray [ i ] ) . hasEventListener ( MouseEvent . CLICK ) )
          {
            TextLabel ( daysElementsArray [ i ] ) . removeEventListener ( MouseEvent . CLICK , dayClicked ) ;
          }
          if ( TextLabel ( daysElementsArray [ i ] ) . hasEventListener ( MouseEvent . MOUSE_OVER ) )
          {
            TextLabel ( daysElementsArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OVER , dayMouseOver ) ;
          }
          if ( TextLabel ( daysElementsArray [ i ] ) . hasEventListener ( MouseEvent . MOUSE_OUT ) )
          {
            TextLabel ( daysElementsArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_OUT , dayMouseOut ) ;
          }
          if ( TextLabel ( daysElementsArray [ i ] ) . hasEventListener ( MouseEvent . MOUSE_DOWN ) )
          {
            TextLabel ( daysElementsArray [ i ] ) . removeEventListener ( MouseEvent . MOUSE_DOWN , dayMouseDown ) ;
          }
          TextLabel ( daysElementsArray [ i ] ) . destroy ( ) ;
          removeChild ( TextLabel ( daysElementsArray [ i ] ) ) ;
        }
        daysElementsArray . splice ( 0 ) ;
      }
      removeElementsOfHoursAndMinutes ( ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      eventChanged = null ;
      currentDateObject = null ;
      hoursAndMinutes = false ;
      hoursLabelArray = null ;
      hoursValueArray = null ;
      hoursListPicker = null ;
      minutesLabelArray = null ;
      minutesValueArray = null ;
      minutesListPicker = null ;
      hmSepTextLabel = null ;
      background = null ;
      dateFormat = null ;
      dateFormatter = null ;
      firstButtonText = null ;
      leftButtonText = null ;
      dateTextLabel = null ;
      rightButtonText = null ;
      lastButtonText = null ;
      monthsCodesArray = null ;
      weekdaysCodesArray = null ;
      weekdaysElementsArray = null ;
      weeksElementsArray = null ;
      daysElementsArray = null ;
      todayButtonLink = null ;
      allElementsW = 0 ;
    }
  }
}