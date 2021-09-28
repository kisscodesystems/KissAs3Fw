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
** Watch.
** This can be used to display the current time.
** Especially when the full screen is used and the user
** cannot see its computer clock.
**
** MAIN FEATURES:
** - displaying the time and date
** - switch between modes (normal, digital, analog, binary)
** - an openable area displays the date, the current timezone and the day
** - switcher to display seconds on the main displaying
** - event can be thrown to the outside to save this state.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Switcher ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . events . TimerEvent ;
  import flash . utils . Timer ;
  public class Watch extends BaseSprite
  {
// This event will be thrown when the seconds switcher or the watch type is changed.
    private var eventWatchChanged : Event = null ;
// This is the event of the repositioning of the watch elements.
    private var eventWatchRepositioned : Event = null ;
// The click on this will open the watch
    private var spriteFg : BaseSprite = null ;
// This is the object which will contain all of the background elements
    private var spriteBg : BaseSprite = null ;
// The watch itself
    private var spriteWatch : BaseSprite = null ;
// A background basically
    private var shapeBgFrame : BaseShape = null ;
// The frame of the main displaying
    private var shapeFgFrame : BaseShape = null ;
// Timer object is needed to update the watch
    private var timer : Timer = null ;
// These will display the time and date data on the background
    private var timeTextLabel : TextLabel = null ;
    private var dateTextLabel : TextLabel = null ;
    private var watchTypeListPicker : ListPicker = null ;
    private var secondsSwitcher : Switcher = null ;
    private var textCodesWeekdays : Array = null ;
    private var textCodesWatchTypes : Array = null ;
// The watch itself, 4 layers to hold the 4 different dime displaying
    private var basicTimeTextLabel : TextLabel = null ;
    private var digitalTimeBaseSprite : BaseSprite = null ;
    private var analogTimeBaseSprite : BaseSprite = null ;
    private var binaryTimeBaseSprite : BaseSprite = null ;
// Digital watch elements
    private var digitalH1 : BaseSprite = null ;
    private var digitalH2 : BaseSprite = null ;
    private var digitalM1 : BaseSprite = null ;
    private var digitalM2 : BaseSprite = null ;
    private var digitalS1 : BaseSprite = null ;
    private var digitalS2 : BaseSprite = null ;
    private var digitalC1 : BaseSprite = null ;
    private var digitalC2 : BaseSprite = null ;
    private var digitalElementsArray : Array = null ;
// Analog watch elements
    private var analogFrame : BaseShape = null ;
    private var analogH : BaseSprite = null ;
    private var analogM : BaseSprite = null ;
    private var analogS : BaseSprite = null ;
// Binary watch elements
    private var binaryH1 : BaseSprite = null ;
    private var binaryH2 : BaseSprite = null ;
    private var binaryM1 : BaseSprite = null ;
    private var binaryM2 : BaseSprite = null ;
    private var binaryS1 : BaseSprite = null ;
    private var binaryS2 : BaseSprite = null ;
    private var binaryElementsArray : Array = null ;
// Some shared properties used in all watch displaying
    private var digitThickness : int = 1 ;
    private var binaryDigitDelta : int = 1 ;
    private var margin : int = 1 ;
    private var rectWidth : int = 1 ;
    private var watchw : int = 1 ;
    private var allwBinary : int = 0 ;
    private var allwDigital : int = 0 ;
    private var temps : String = "" ;
    private var tempm : String = "" ;
    private var temph : String = "" ;
    private var s : Number = 0 ;
    private var m : Number = 0 ;
    private var h : Number = 0 ;
// The type of the watch: normal, digital, analog or binary
    private var watchType : String = "" ;
    public function Watch ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The event has to be ready at the first.
      eventWatchChanged = new Event ( application . EVENT_WATCH_CHANGED ) ;
      eventWatchRepositioned = new Event ( application . EVENT_WATCH_REPOSITIONED ) ;
// The width of the watch digits
      watchw = 1 ;
// Ini this array to know the available names of the weekdays.
      textCodesWeekdays = [ application . getTexts ( ) . WEEKDAY_SUNDAY , application . getTexts ( ) . WEEKDAY_MONDAY , application . getTexts ( ) . WEEKDAY_TUESDAY , application . getTexts ( ) . WEEKDAY_WEDNESDAY , application . getTexts ( ) . WEEKDAY_THURSDAY , application . getTexts ( ) . WEEKDAY_FRIDAY , application . getTexts ( ) . WEEKDAY_SATURDAY ] ;
// The available types of the watch are the following
      textCodesWatchTypes = [ application . getTexts ( ) . WATCH_TYPE_BASIC , application . getTexts ( ) . WATCH_TYPE_DIGITAL , application . getTexts ( ) . WATCH_TYPE_ANALOG , application . getTexts ( ) . WATCH_TYPE_BINARY ] ;
// The type of the watch is
      watchType = application . getTexts ( ) . WATCH_TYPE_BASIC ;
// The base sizes of drawing the watches
      calcWidthHeightPositions ( ) ;
// The main UI
      shapeBgFrame = new BaseShape ( application ) ;
      addChild ( shapeBgFrame ) ;
      shapeBgFrame . setdb ( true ) ;
      shapeBgFrame . setdt ( - 1 ) ;
      shapeBgFrame . visible = false ;
      spriteBg = new BaseSprite ( application ) ;
      addChild ( spriteBg ) ;
      spriteBg . visible = false ;
      timeTextLabel = new TextLabel ( application ) ;
      spriteBg . addChild ( timeTextLabel ) ;
      dateTextLabel = new TextLabel ( application ) ;
      spriteBg . addChild ( dateTextLabel ) ;
      watchTypeListPicker = new ListPicker ( application ) ;
      spriteBg . addChild ( watchTypeListPicker ) ;
      watchTypeListPicker . setArrays ( textCodesWatchTypes , textCodesWatchTypes ) ;
      watchTypeListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , watchTypeListPickerChanged ) ;
      watchTypeListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , watchTypeListPickerSizesChanged ) ;
      watchTypeListPicker . setNumOfElements ( 4 ) ;
      watchTypeListPicker . setSelectedIndex ( textCodesWatchTypes . indexOf ( watchType ) ) ;
      secondsSwitcher = new Switcher ( application ) ;
      spriteBg . addChild ( secondsSwitcher ) ;
      secondsSwitcher . setTextCodes ( application . getTexts ( ) . WATCH_SHOW_SECONDS , application . getTexts ( ) . WATCH_WITHOUT_SECONDS ) ;
      secondsSwitcher . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposElements ) ;
      secondsSwitcher . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , secondsSwitcherChanged ) ;
      timeTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposElements ) ;
      dateTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposElements ) ;
      shapeFgFrame = new BaseShape ( application ) ;
      addChild ( shapeFgFrame ) ;
      shapeFgFrame . setdb ( true ) ;
      shapeFgFrame . setdt ( 1 ) ;
      spriteWatch = new BaseSprite ( application ) ;
      addChild ( spriteWatch ) ;
      spriteFg = new BaseSprite ( application ) ;
      addChild ( spriteFg ) ;
      spriteFg . addEventListener ( MouseEvent . CLICK , open ) ;
// These have to be registered to keep up to date displaying according to the application level.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_SIZE_CHANGED , fontSizeChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED , fontColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
// Basic initialization
      createFrame ( ) ;
      reposElements ( null ) ;
      secondsSwitcher . setUp ( true ) ;
// The timer at the end, the updating will begin.
      timer = new Timer ( 1000 ) ;
      timer . start ( ) ;
      timer . addEventListener ( TimerEvent . TIMER , timerHandler ) ;
    }
/*
** Some application properties has been changed.
*/
    private function fontSizeChanged ( e : Event ) : void
    {
      reposElements ( null ) ;
    }
    private function paddingChanged ( e : Event ) : void
    {
      reposElements ( null ) ;
    }
/*
** Drops the watch changing event to the outside world.
*/
    private function dropWatchChangedEvent ( ) : void
    {
      if ( application != null && application . getBaseEventDispatcher ( ) != null && eventWatchChanged != null )
      {
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventWatchChanged ) ;
      }
    }
/*
** Drops the watch reposition event to the outside world.
*/
    private function dropWatchRepositionedEvent ( ) : void
    {
      if ( application != null && application . getBaseEventDispatcher ( ) != null && eventWatchRepositioned != null )
      {
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventWatchRepositioned ) ;
      }
    }
/*
** The type of this watch is changed.
*/
    private function watchTypeListPickerChanged ( e : Event ) : void
    {
      watchType = watchTypeListPicker . getSelectedValue ( ) ;
      reposElements ( null ) ;
      setWatchLayersVisible ( ) ;
      update ( ) ;
      dropWatchChangedEvent ( ) ;
    }
/*
** The sizes of the watch type list picker is chanted ( it is opened or closed ).
*/
    private function watchTypeListPickerSizesChanged ( e : Event ) : void
    {
      reposElements ( null ) ;
    }
/*
** Sets the visibility of the watch layers.
*/
    private function setWatchLayersVisible ( ) : void
    {
      if ( basicTimeTextLabel != null && digitalTimeBaseSprite != null && analogTimeBaseSprite != null && binaryTimeBaseSprite != null )
      {
        basicTimeTextLabel . visible = watchType == application . getTexts ( ) . WATCH_TYPE_BASIC ;
        digitalTimeBaseSprite . visible = watchType == application . getTexts ( ) . WATCH_TYPE_DIGITAL ;
        analogTimeBaseSprite . visible = watchType == application . getTexts ( ) . WATCH_TYPE_ANALOG ;
        binaryTimeBaseSprite . visible = watchType == application . getTexts ( ) . WATCH_TYPE_BINARY ;
      }
    }
/*
** Sets and gets the type or the watch.
*/
    public function setWatchType ( t : String ) : void
    {
      if ( watchType != t )
      {
        if ( t == application . getTexts ( ) . WATCH_TYPE_BASIC || t == application . getTexts ( ) . WATCH_TYPE_DIGITAL || t == application . getTexts ( ) . WATCH_TYPE_ANALOG || t == application . getTexts ( ) . WATCH_TYPE_BINARY )
        {
          watchTypeListPicker . setSelectedIndex ( textCodesWatchTypes . indexOf ( t ) ) ;
        }
      }
    }
    public function getWatchType ( ) : String
    {
      return watchType ;
    }
/*
** Sets and gets the show seconds of the watch.
*/
    public function setWatchSecs ( s : Boolean ) : void
    {
      if ( secondsSwitcher != null )
      {
        secondsSwitcher . setUp ( s ) ;
      }
    }
    public function getWatchSecs ( ) : Boolean
    {
      if ( secondsSwitcher != null )
      {
        return secondsSwitcher . getUp ( ) ;
      }
      return true ;
    }
/*
** The frame creation.
** All of the layers containing a displayable watch will be created here.
*/
    private function createFrame ( ) : void
    {
      if ( spriteWatch != null )
      {
        if ( basicTimeTextLabel == null )
        {
          basicTimeTextLabel = new TextLabel ( application ) ;
          spriteWatch . addChild ( basicTimeTextLabel ) ;
          basicTimeTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , basicTimeTextLabelResized ) ;
          basicTimeTextLabel . setTextCode ( " " ) ;
          basicTimeTextLabel . setIcon ( "watch" ) ;
        }
        if ( digitalTimeBaseSprite == null )
        {
          digitalTimeBaseSprite = new BaseSprite ( application ) ;
          spriteWatch . addChild ( digitalTimeBaseSprite ) ;
          digitalElementsArray = new Array ( 6 ) ;
          digitalElementsArray [ "digitalH1" ] = new Array ( 7 ) ;
          digitalElementsArray [ "digitalH2" ] = new Array ( 7 ) ;
          digitalElementsArray [ "digitalM1" ] = new Array ( 7 ) ;
          digitalElementsArray [ "digitalM2" ] = new Array ( 7 ) ;
          digitalElementsArray [ "digitalS1" ] = new Array ( 7 ) ;
          digitalElementsArray [ "digitalS2" ] = new Array ( 7 ) ;
          digitalH1 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalH1 ) ;
          digitalH2 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalH2 ) ;
          digitalC1 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalC1 ) ;
          digitalM1 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalM1 ) ;
          digitalM2 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalM2 ) ;
          digitalC2 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalC2 ) ;
          digitalS1 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalS1 ) ;
          digitalS2 = new BaseSprite ( application ) ;
          digitalTimeBaseSprite . addChild ( digitalS2 ) ;
        }
        if ( analogTimeBaseSprite == null )
        {
          analogTimeBaseSprite = new BaseSprite ( application ) ;
          spriteWatch . addChild ( analogTimeBaseSprite ) ;
          analogFrame = new BaseShape ( application ) ;
          analogTimeBaseSprite . addChild ( analogFrame ) ;
          analogFrame . setdb ( true ) ;
          analogFrame . setdt ( 0 ) ;
          analogH = new BaseSprite ( application ) ;
          analogTimeBaseSprite . addChild ( analogH ) ;
          analogM = new BaseSprite ( application ) ;
          analogTimeBaseSprite . addChild ( analogM ) ;
          analogS = new BaseSprite ( application ) ;
          analogTimeBaseSprite . addChild ( analogS ) ;
        }
        if ( binaryTimeBaseSprite == null )
        {
          binaryTimeBaseSprite = new BaseSprite ( application ) ;
          spriteWatch . addChild ( binaryTimeBaseSprite ) ;
          binaryElementsArray = new Array ( 6 ) ;
          binaryElementsArray [ "binaryH1" ] = new Array ( 8 ) ;
          binaryElementsArray [ "binaryH2" ] = new Array ( 8 ) ;
          binaryElementsArray [ "binaryM1" ] = new Array ( 8 ) ;
          binaryElementsArray [ "binaryM2" ] = new Array ( 8 ) ;
          binaryElementsArray [ "binaryS1" ] = new Array ( 8 ) ;
          binaryElementsArray [ "binaryS2" ] = new Array ( 8 ) ;
          binaryH1 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryH1 ) ;
          binaryH2 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryH2 ) ;
          binaryM1 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryM1 ) ;
          binaryM2 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryM2 ) ;
          binaryS1 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryS1 ) ;
          binaryS2 = new BaseSprite ( application ) ;
          binaryTimeBaseSprite . addChild ( binaryS2 ) ;
        }
        setWatchLayersVisible ( ) ;
      }
    }
/*
** Updating the watch ( main displaying only )
** The actual and visible watch displaying will be updated.
*/
    private function updateWatch ( date : Date ) : void
    {
      if ( secondsSwitcher != null && date != null )
      {
// Hours, minutes and seconds are needed.
        h = date . getHours ( ) ;
        m = date . getMinutes ( ) ;
        s = date . getSeconds ( ) ;
// Updates immediately the temporary values, zero leading if necessary.
        temps = String ( s ) ;
        if ( temps . length == 1 ) temps = "0" + temps ;
        tempm = String ( m ) ;
        if ( tempm . length == 1 ) tempm = "0" + tempm ;
        temph = String ( h ) ;
        if ( temph . length == 1 ) temph = "0" + temph ;
// The currently displayed watch will be updated to save some cpu time, others are not visible.
        if ( watchType == application . getTexts ( ) . WATCH_TYPE_BASIC && basicTimeTextLabel != null && basicTimeTextLabel . visible )
        {
// The basic watch is simple, only a label will be modified.
          basicTimeTextLabel . setTextCode ( "" + h + " : " + tempm + ( secondsSwitcher . getUp ( ) ? " : " + temps : "" ) ) ;
        }
        else if ( watchType == application . getTexts ( ) . WATCH_TYPE_DIGITAL && digitalTimeBaseSprite != null && digitalTimeBaseSprite . visible )
        {
// The digital displaying can be updated by manipulating the alpha (visibility) property of the specific pieces of that digit.
          writeDigit ( "digitalH1" , temph . substr ( 0 , 1 ) ) ;
          writeDigit ( "digitalH2" , temph . substr ( 1 , 1 ) ) ;
          writeDigit ( "digitalM1" , tempm . substr ( 0 , 1 ) ) ;
          writeDigit ( "digitalM2" , tempm . substr ( 1 , 1 ) ) ;
// If the displaying of seconds is necessary then do it, and the second colon is visible or not.
          if ( secondsSwitcher . getUp ( ) )
          {
            digitalC2 . alpha = s % 2 == 0 ? 1 : 0 ;
            writeDigit ( "digitalS1" , temps . substr ( 0 , 1 ) ) ;
            writeDigit ( "digitalS2" , temps . substr ( 1 , 1 ) ) ;
          }
          else
          {
            digitalC2 . alpha = 0 ;
            writeDigit ( "digitalS1" , "hide" ) ;
            writeDigit ( "digitalS2" , "hide" ) ;
          }
        }
        else if ( watchType == application . getTexts ( ) . WATCH_TYPE_ANALOG && analogTimeBaseSprite != null && analogTimeBaseSprite . visible )
        {
// The analog watch is also simple: the pointers have to be rotated depending on the current time.
          spinTime ( analogH , h , 12 ) ;
          spinTime ( analogM , m , 60 ) ;
          if ( secondsSwitcher . getUp ( ) )
          {
            spinTime ( analogS , s , 60 ) ;
          }
          else
          {
            spinTime ( analogS , - 1 , 60 ) ;
          }
        }
        else if ( watchType == application . getTexts ( ) . WATCH_TYPE_BINARY && binaryTimeBaseSprite != null && binaryTimeBaseSprite . visible )
        {
// Binary displaying is very similar to the digital, except the colon, there is no such a thing.
          writeDots ( "binaryH1" , temph . substr ( 0 , 1 ) ) ;
          writeDots ( "binaryH2" , temph . substr ( 1 , 1 ) ) ;
          writeDots ( "binaryM1" , tempm . substr ( 0 , 1 ) ) ;
          writeDots ( "binaryM2" , tempm . substr ( 1 , 1 ) ) ;
          if ( secondsSwitcher . getUp ( ) )
          {
            writeDots ( "binaryS1" , temps . substr ( 0 , 1 ) ) ;
            writeDots ( "binaryS2" , temps . substr ( 1 , 1 ) ) ;
          }
          else
          {
            writeDots ( "binaryS1" , "hide" ) ;
            writeDots ( "binaryS2" , "hide" ) ;
          }
        }
      }
    }
/*
** It is necessary to reposition the elements if its size has been changed.
*/
    private function basicTimeTextLabelResized ( e : Event ) : void
    {
      reposElements ( null ) ;
    }
/*
** Repositioning only of the time text label.
*/
    private function basicTimeTextLabelRepos ( ) : void
    {
      if ( basicTimeTextLabel != null )
      {
        basicTimeTextLabel . setcxy ( ( shapeFgFrame . getsw ( ) - basicTimeTextLabel . getsw ( ) ) / 2 , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
    }
/*
** When the seconds switcher is changed then updates the time displaying immediately.
*/
    private function secondsSwitcherChanged ( e : Event ) : void
    {
      reposElements ( null ) ;
      update ( ) ;
      dropWatchChangedEvent ( ) ;
    }
/*
** Update everything. (also on the background)
*/
    private function update ( ) : void
    {
      var date : Date = new Date ( ) ;
      var s : Number = date . getSeconds ( ) ;
      if ( secondsSwitcher != null )
      {
        updateWatch ( date ) ;
        if ( spriteBg != null && spriteBg . visible )
        {
          var h : Number = date . getHours ( ) ;
          var m : Number = date . getMinutes ( ) ;
          var tzo : Number = date . getTimezoneOffset ( ) ;
          var tzos : String = tzo >= 0 ? "+" : "-" ;
          var tzostr : String = tzo == 0 ? "UTC" : "UTC " + tzos + ( tzo % 60 ) + ":" + ( tzo - ( tzo % 60 ) * 60 ) ;
          var yyyy : Number = date . getFullYear ( ) ;
          var mm : Number = date . getMonth ( ) + 1 ;
          var dd : Number = date . getDate ( ) ;
          if ( timeTextLabel != null )
          {
            timeTextLabel . setTextCode ( h + " : " + ( m < 10 ? "0" + m : m ) + " : " + ( s < 10 ? "0" + s : s ) + "  (" + tzostr + ")" ) ;
          }
          if ( dateTextLabel != null && textCodesWeekdays != null )
          {
            dateTextLabel . setTextCode ( textCodesWeekdays [ date . getDay ( ) ] + ",  " + yyyy + " - " + ( mm < 10 ? "0" + mm : mm ) + " - " + ( dd < 10 ? "0" + dd : dd ) ) ;
          }
        }
      }
    }
/*
** This will run in every seconds.
** The visible panel will be updated, otherwise the displayed watch only to save some cpu time.
*/
    private function timerHandler ( e : TimerEvent ) : void
    {
      if ( shapeBgFrame != null )
      {
        if ( shapeBgFrame . visible )
        {
          update ( ) ;
        }
        else
        {
          updateWatch ( new Date ( ) ) ;
        }
      }
    }
/*
** The frames can be resized, these happen when this event is triggered.
*/
    private function shapeFgFrameSizesChanged ( ) : void
    {
      if ( shapeFgFrame != null )
      {
        if ( spriteFg != null )
        {
          spriteFg . graphics . clear ( ) ;
          spriteFg . graphics . beginFill ( 0 , 0 ) ;
          spriteFg . graphics . drawRect ( 0 , 0 , shapeFgFrame . getsw ( ) , shapeFgFrame . getsh ( ) ) ;
          spriteFg . graphics . endFill ( ) ;
          spriteFg . x = shapeFgFrame . x ;
          spriteFg . y = shapeFgFrame . y ;
        }
        if ( spriteWatch != null )
        {
          spriteWatch . x = shapeFgFrame . x ;
          spriteWatch . y = shapeFgFrame . y ;
        }
      }
    }
    private function shapeBgFrameSizesChanged ( ) : void
    {
      if ( shapeBgFrame != null )
      {
        if ( spriteBg != null )
        {
          spriteBg . setcxy ( shapeBgFrame . x , shapeBgFrame . y ) ;
        }
      }
    }
/*
** Opens the background to display other information and to be able to switch seconds displaying.
*/
    private function open ( e : MouseEvent ) : void
    {
      update ( ) ;
      if ( shapeBgFrame != null && ! shapeBgFrame . visible && spriteBg != null )
      {
        shapeBgFrame . visible = true ;
        spriteBg . visible = true ;
        reposElements ( null ) ;
        update ( ) ;
        if ( stage != null )
        {
          stage . addEventListener ( MouseEvent . MOUSE_DOWN , mouseClose ) ;
        }
      }
    }
/*
** When the mouse down event happens outside of the used area, then it is necessary to close the background.
*/
    private function mouseClose ( e : MouseEvent ) : void
    {
      if ( shapeBgFrame != null )
      {
        if ( ! ( mouseX >= 0 && mouseX <= getsw ( ) && mouseY >= 0 && mouseY <= getsh ( ) ) )
        {
          close ( ) ;
        }
      }
    }
/*
** The closing itself.
*/
    private function close ( ) : void
    {
      if ( shapeBgFrame != null )
      {
        shapeBgFrame . visible = false ;
      }
      if ( spriteBg != null )
      {
        spriteBg . visible = false ;
      }
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseClose ) ;
      }
    }
/*
** Repositions everything.
*/
    private function reposElements ( e : Event ) : void
    {
      if ( spriteBg != null )
      {
        if ( timeTextLabel != null )
        {
          timeTextLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
          if ( dateTextLabel != null )
          {
            dateTextLabel . setcxy ( timeTextLabel . getcx ( ) , timeTextLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
            if ( watchTypeListPicker != null )
            {
              if ( secondsSwitcher != null )
              {
                var max : int = 0 ;
                if ( timeTextLabel . getsw ( ) > max )
                {
                  max = timeTextLabel . getsw ( ) ;
                }
                if ( dateTextLabel . getsw ( ) > max )
                {
                  max = dateTextLabel . getsw ( ) ;
                }
                if ( secondsSwitcher . getsw ( ) > max )
                {
                  max = secondsSwitcher . getsw ( ) ;
                }
                watchTypeListPicker . setsw ( max ) ;
                watchTypeListPicker . setcxy ( dateTextLabel . getcx ( ) , dateTextLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
                secondsSwitcher . setcxy ( dateTextLabel . getcx ( ) , watchTypeListPicker . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
                if ( spriteBg . visible )
                {
                  super . setswh ( max + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , secondsSwitcher . getsh ( ) + secondsSwitcher . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
                }
                else
                {
                  super . setswh ( max + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , secondsSwitcher . getsh ( ) ) ;
                }
                calcWidthHeightPositions ( ) ;
                if ( shapeFgFrame != null )
                {
                  if ( watchType == application . getTexts ( ) . WATCH_TYPE_DIGITAL )
                  {
                    shapeFgFrame . setswh ( allwDigital + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , secondsSwitcher . getsh ( ) ) ;
                  }
                  else if ( watchType == application . getTexts ( ) . WATCH_TYPE_ANALOG )
                  {
                    shapeFgFrame . setswh ( secondsSwitcher . getsh ( ) , secondsSwitcher . getsh ( ) ) ;
                  }
                  else if ( watchType == application . getTexts ( ) . WATCH_TYPE_BINARY )
                  {
                    shapeFgFrame . setswh ( allwBinary + 2 * application . getPropsDyn ( ) . getAppPadding ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , secondsSwitcher . getsh ( ) ) ;
                  }
                  else
                  {
                    shapeFgFrame . setswh ( basicTimeTextLabel . getsw ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , secondsSwitcher . getsh ( ) ) ;
                  }
                }
                if ( shapeBgFrame != null )
                {
                  shapeBgFrame . setswh ( getsw ( ) , secondsSwitcher . getcysh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
                }
                redrawReposShapes ( null ) ;
                basicTimeTextLabelRepos ( ) ;
                update ( ) ;
              }
            }
          }
        }
      }
      dropWatchRepositionedEvent ( ) ;
    }
/*
** Gets the x coordinate of the fg frame.
*/
    public function getShapeFgFrameX ( ) : int
    {
      if ( shapeFgFrame != null )
      {
        return shapeFgFrame . x ;
      }
      return 0 ;
    }
/*
** These are base shapes so the parameters must pass again to repaint them.
*/
    private function redrawReposShapes ( e : Event ) : void
    {
      if ( secondsSwitcher != null )
      {
        if ( shapeFgFrame != null )
        {
          shapeFgFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
          shapeFgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
          shapeFgFrame . drawRect ( ) ;
          shapeFgFrame . x = getsw ( ) - shapeFgFrame . getsw ( ) ;
          shapeFgFrame . y = 0 ;
          shapeFgFrameSizesChanged ( ) ;
        }
        if ( shapeBgFrame != null )
        {
          shapeBgFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , ( application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) + ( 1 - application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) ) * 3 / 4 ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
          shapeBgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
          shapeBgFrame . drawRect ( ) ;
          shapeBgFrame . x = 0 ;
          shapeBgFrame . y = secondsSwitcher . getsh ( ) ;
          shapeBgFrameSizesChanged ( ) ;
        }
      }
      fontColorChanged ( null ) ;
    }
/*
** When the font colors are changed.
*/
    private function fontColorChanged ( e : Event ) : void
    {
      paintDigital ( ) ;
      paintAnalog ( ) ;
      paintBinary ( ) ;
      update ( ) ;
    }
/*
** Sets enabled or disabled.
*/
    override public function setEnabled ( b : Boolean ) : void
    {
      super . setEnabled ( b ) ;
      if ( secondsSwitcher != null )
      {
        secondsSwitcher . setEnabled ( b ) ;
      }
    }
/*
** These should not work at all!
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Shared functions.
** Used for displaying all of the watch appearance.
*/
    private function calcWidthHeightPositions ( ) : void
    {
      if ( shapeFgFrame != null )
      {
        var size : int = application . getPropsDyn ( ) . getAppFontSize ( ) ;
        if ( size == 0 ) size = application . calcFontSizeFromStageSize ( ) ;
        if ( size < 31 )
        {
          digitThickness = 3 ;
          binaryDigitDelta = 2 ;
        }
        else if ( size < 51 )
        {
          digitThickness = 5 ;
          binaryDigitDelta = 4 ;
        }
        else
        {
          digitThickness = 7 ;
          binaryDigitDelta = 6 ;
        }
        margin = digitThickness * 2 ;
        rectWidth = ( application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) - 2 * margin ) / 2 ;
        watchw = rectWidth * 6 + digitThickness * 2 + 7 * margin + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ;
        if ( secondsSwitcher != null && secondsSwitcher . getUp ( ) )
        {
          allwBinary = 6 * rectWidth ;
          allwDigital = rectWidth + margin + rectWidth + margin + digitThickness + margin + rectWidth + margin + rectWidth + margin + digitThickness + margin + rectWidth + margin + rectWidth ;
        }
        else
        {
          allwBinary = 4 * rectWidth ;
          allwDigital = rectWidth + margin + rectWidth + margin + digitThickness + margin + rectWidth + margin + rectWidth ;
        }
      }
    }
/*
** Digital watch functions.
** The digital numbers are assembled by little elements (e) as:
**   +-e1-+
** e2|    |e3
**   +-e4-+
** e5|    |e6
**   +-e7-+
** The current visiblity (alpha property) of these will draw the specific number as below.
*/
    private function writeDigit ( bs : String , number : String ) : void
    {
      if ( digitalElementsArray != null )
      {
        switch ( number )
        {
          case "0" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "1" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 0 ;
          break ;
          case "2" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "3" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "4" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 0 ;
          break ;
          case "5" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "6" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "7" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 0 ;
          break ;
          case "8" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ;
          case "9" : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          break ; default : BaseSprite ( digitalElementsArray [ bs ] [ "e1" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e2" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e3" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e4" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e5" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e6" ] ) . alpha = 0 ;
          BaseSprite ( digitalElementsArray [ bs ] [ "e7" ] ) . alpha = 0 ;
          break ;
        }
      }
    }
    private function makeDigitalColon ( bs : BaseSprite ) : void
    {
      if ( bs != null )
      {
        bs . graphics . clear ( ) ;
        bs . graphics . lineStyle ( 1 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        bs . graphics . beginFill ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        bs . graphics . moveTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 ) ;
        bs . graphics . lineTo ( digitThickness , ( rectWidth * 2 - digitThickness * 2 ) / 3 ) ;
        bs . graphics . lineTo ( digitThickness , ( rectWidth * 2 - digitThickness * 2 ) / 3 + digitThickness ) ;
        bs . graphics . lineTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 + digitThickness ) ;
        bs . graphics . lineTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 ) ;
        bs . graphics . endFill ( ) ;
        bs . graphics . beginFill ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        bs . graphics . moveTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 * 2 + digitThickness ) ;
        bs . graphics . lineTo ( digitThickness , ( rectWidth * 2 - digitThickness * 2 ) / 3 * 2 + digitThickness ) ;
        bs . graphics . lineTo ( digitThickness , ( rectWidth * 2 - digitThickness * 2 ) / 3 * 2 + digitThickness + digitThickness ) ;
        bs . graphics . lineTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 * 2 + digitThickness + digitThickness ) ;
        bs . graphics . lineTo ( 0 , ( rectWidth * 2 - digitThickness * 2 ) / 3 * 2 + digitThickness ) ;
        bs . graphics . endFill ( ) ;
      }
    }
    private function makeDigitalDigitPiece ( bs : BaseSprite ) : void
    {
      if ( bs != null )
      {
        bs . graphics . clear ( ) ;
        bs . graphics . lineStyle ( 1 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        bs . graphics . beginFill ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        bs . graphics . moveTo ( 0 , digitThickness / 2 ) ;
        bs . graphics . lineTo ( digitThickness / 2 , 0 ) ;
        bs . graphics . lineTo ( rectWidth - digitThickness / 2 , 0 ) ;
        bs . graphics . lineTo ( rectWidth , digitThickness / 2 ) ;
        bs . graphics . lineTo ( rectWidth - digitThickness / 2 , digitThickness ) ;
        bs . graphics . lineTo ( digitThickness / 2 , digitThickness ) ;
        bs . graphics . lineTo ( 0 , digitThickness / 2 ) ;
        bs . graphics . endFill ( ) ;
      }
    }
    private function makeDigitalDigit ( bsBaseSprite : BaseSprite , bsString : String ) : void
    {
      if ( digitalElementsArray != null )
      {
        if ( digitalElementsArray [ bsString ] [ "e1" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e1" ] ) ;
          digitalElementsArray [ bsString ] [ "e1" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e2" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e2" ] ) ;
          digitalElementsArray [ bsString ] [ "e2" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e3" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e3" ] ) ;
          digitalElementsArray [ bsString ] [ "e3" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e4" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e4" ] ) ;
          digitalElementsArray [ bsString ] [ "e4" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e5" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e5" ] ) ;
          digitalElementsArray [ bsString ] [ "e5" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e6" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e6" ] ) ;
          digitalElementsArray [ bsString ] [ "e6" ] = null ;
        }
        if ( digitalElementsArray [ bsString ] [ "e7" ] != null )
        {
          bsBaseSprite . removeChild ( digitalElementsArray [ bsString ] [ "e7" ] ) ;
          digitalElementsArray [ bsString ] [ "e7" ] = null ;
        }
        digitalElementsArray [ bsString ] [ "e1" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e1" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e1" ] ) ;
        digitalElementsArray [ bsString ] [ "e1" ] . x = 0 ;
        digitalElementsArray [ bsString ] [ "e1" ] . y = 0 ;
        digitalElementsArray [ bsString ] [ "e2" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e2" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e2" ] ) ;
        digitalElementsArray [ bsString ] [ "e2" ] . rotation = 90 ;
        digitalElementsArray [ bsString ] [ "e2" ] . x = digitThickness ;
        digitalElementsArray [ bsString ] [ "e2" ] . y = 0 ;
        digitalElementsArray [ bsString ] [ "e3" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e3" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e3" ] ) ;
        digitalElementsArray [ bsString ] [ "e3" ] . rotation = 90 ;
        digitalElementsArray [ bsString ] [ "e3" ] . x = rectWidth ;
        digitalElementsArray [ bsString ] [ "e3" ] . y = 0 ;
        digitalElementsArray [ bsString ] [ "e4" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e4" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e4" ] ) ;
        digitalElementsArray [ bsString ] [ "e4" ] . x = 0 ;
        digitalElementsArray [ bsString ] [ "e4" ] . y = rectWidth - digitThickness / 2 - 1 ;
        digitalElementsArray [ bsString ] [ "e5" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e5" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e5" ] ) ;
        digitalElementsArray [ bsString ] [ "e5" ] . rotation = 90 ;
        digitalElementsArray [ bsString ] [ "e5" ] . x = digitThickness ;
        digitalElementsArray [ bsString ] [ "e5" ] . y = rectWidth - digitThickness / 2 - 1 ;
        digitalElementsArray [ bsString ] [ "e6" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e6" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e6" ] ) ;
        digitalElementsArray [ bsString ] [ "e6" ] . rotation = 90 ;
        digitalElementsArray [ bsString ] [ "e6" ] . x = rectWidth ;
        digitalElementsArray [ bsString ] [ "e6" ] . y = rectWidth - digitThickness / 2 - 1 ;
        digitalElementsArray [ bsString ] [ "e7" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( digitalElementsArray [ bsString ] [ "e7" ] ) ;
        makeDigitalDigitPiece ( digitalElementsArray [ bsString ] [ "e7" ] ) ;
        digitalElementsArray [ bsString ] [ "e7" ] . x = 0 ;
        digitalElementsArray [ bsString ] [ "e7" ] . y = rectWidth * 2 - digitThickness - 2 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e1" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e2" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e3" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e4" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e5" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e6" ] ) . alpha = 0 ;
        BaseSprite ( digitalElementsArray [ bsString ] [ "e7" ] ) . alpha = 0 ;
      }
    }
    private function paintDigital ( e : Event = null ) : void
    {
      calcWidthHeightPositions ( ) ;
      makeDigitalDigit ( digitalH1 , "digitalH1" ) ;
      makeDigitalDigit ( digitalH2 , "digitalH2" ) ;
      makeDigitalColon ( digitalC1 ) ;
      makeDigitalDigit ( digitalM1 , "digitalM1" ) ;
      makeDigitalDigit ( digitalM2 , "digitalM2" ) ;
      makeDigitalColon ( digitalC2 ) ;
      makeDigitalDigit ( digitalS1 , "digitalS1" ) ;
      makeDigitalDigit ( digitalS2 , "digitalS2" ) ;
      if ( digitalH1 != null )
      {
        digitalH1 . x = int ( ( shapeFgFrame . getsw ( ) - allwDigital ) / 2 ) ;
        digitalH1 . y = margin + digitThickness / 2 ;
        digitalH2 . x = digitalH1 . x + rectWidth + margin ;
        digitalH2 . y = digitalH1 . y ;
        digitalC1 . x = digitalH2 . x + rectWidth + margin ;
        digitalC1 . y = digitalH1 . y ;
        digitalM1 . x = digitalC1 . x + digitThickness + margin ;
        digitalM1 . y = digitalH1 . y ;
        digitalM2 . x = digitalM1 . x + rectWidth + margin ;
        digitalM2 . y = digitalH1 . y ;
        digitalC2 . x = digitalM2 . x + rectWidth + margin ;
        digitalC2 . y = digitalH1 . y ;
        digitalS1 . x = digitalC2 . x + digitThickness + margin ;
        digitalS1 . y = digitalH1 . y ;
        digitalS2 . x = digitalS1 . x + rectWidth + margin ;
        digitalS2 . y = digitalH1 . y ;
      }
    }
/*
** Analog watch functions.
** The pointers of this watch are sprites and contain a single line,
** the rotation of these will display the current time.
*/
    private function spinTime ( bs : BaseSprite , time : int , max : int ) : void
    {
      if ( bs != null && max > 0 )
      {
        if ( time >= 0 )
        {
          bs . rotation = time / max * 360 ;
          if ( bs . alpha == 0 )
          {
            bs . alpha = 1 ;
          }
        }
        else
        {
          if ( bs . alpha != 0 )
          {
            bs . alpha = 0 ;
          }
        }
      }
    }
    private function paintAnalog ( e : Event = null ) : void
    {
      calcWidthHeightPositions ( ) ;
      if ( analogFrame != null && shapeFgFrame != null )
      {
        analogFrame . setswh ( shapeFgFrame . getsh ( ) - 4 , shapeFgFrame . getsh ( ) - 4 ) ;
        analogFrame . x = ( shapeFgFrame . getsw ( ) - analogFrame . getsw ( ) ) / 2 ;
        analogFrame . y = 2 ;
        analogFrame . setccac ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 0 , application . getPropsDyn ( ) . getAppFontColorBright ( ) ) ;
        analogFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        analogFrame . drawRect ( ) ;
        if ( analogH != null )
        {
          analogH . graphics . clear ( ) ;
          analogH . graphics . lineStyle ( 4 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 , true ) ;
          analogH . graphics . moveTo ( 0 , 0 ) ;
          analogH . graphics . lineTo ( 0 , - shapeFgFrame . getsh ( ) / 4 ) ;
          analogH . x = analogFrame . x + analogFrame . getsw ( ) / 2 ;
          analogH . y = analogFrame . y + analogFrame . getsh ( ) / 2 ;
          if ( analogM != null )
          {
            analogM . graphics . clear ( ) ;
            analogM . graphics . lineStyle ( 3 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 , true ) ;
            analogM . graphics . moveTo ( 0 , 0 ) ;
            analogM . graphics . lineTo ( 0 , - ( shapeFgFrame . getsh ( ) / 3 ) ) ;
            analogM . x = analogH . x ;
            analogM . y = analogH . y ;
          }
          if ( analogS != null )
          {
            analogS . graphics . clear ( ) ;
            analogS . graphics . lineStyle ( 2 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 , true ) ;
            analogS . graphics . moveTo ( 0 , 0 ) ;
            analogS . graphics . lineTo ( 0 , - ( shapeFgFrame . getsh ( ) / 3 ) ) ;
            analogS . x = analogH . x ;
            analogS . y = analogH . y ;
          }
        }
      }
    }
/*
** Binary watch functions.
** The digital numbers are assembled by little elements (e) as:
** dots
** o   e1
** o   e2
** o   e3
** o   e4
** circles around them
** O   e5
** O   e6
** O   e7
** O   e8
** The visibility (alpha pproperty) will determine the currently displayed number as below.
*/
    private function writeDots ( bs : String , number : String ) : void
    {
      if ( binaryElementsArray != null )
      {
        switch ( number )
        {
          case "0" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "1" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 1 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "2" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "3" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 1 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "4" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "5" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 1 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "6" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "7" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 1 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "8" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setVisibleAllCircles ( bs ) ;
          break ;
          case "9" : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 1 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 1 ) ;
          setVisibleAllCircles ( bs ) ;
          break ; default : setAlphaToDot ( binaryElementsArray [ bs ] [ "e1" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e2" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e3" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e4" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e5" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e6" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e7" ] , 0 ) ;
          setAlphaToDot ( binaryElementsArray [ bs ] [ "e8" ] , 0 ) ;
          break ;
        }
      }
    }
    private function setVisibleAllCircles ( bs : String ) : void
    {
      if ( binaryElementsArray != null )
      {
        if ( BaseSprite ( binaryElementsArray [ bs ] [ "e8" ] ) . alpha == 0 )
        {
          if ( binaryElementsArray [ bs ] [ "e5" ] != null )
          {
            BaseSprite ( binaryElementsArray [ bs ] [ "e5" ] ) . alpha = 1 ;
          }
          if ( binaryElementsArray [ bs ] [ "e6" ] != null )
          {
            BaseSprite ( binaryElementsArray [ bs ] [ "e6" ] ) . alpha = 1 ;
          }
          BaseSprite ( binaryElementsArray [ bs ] [ "e7" ] ) . alpha = 1 ;
          BaseSprite ( binaryElementsArray [ bs ] [ "e8" ] ) . alpha = 1 ;
        }
      }
    }
    private function setAlphaToDot ( o : Object , a : Number ) : void
    {
      if ( o != null && o is BaseSprite )
      {
        BaseSprite ( o ) . alpha = a ;
      }
    }
    private function makeBinaryDot ( bs : BaseSprite , toFill : Boolean ) : void
    {
      if ( bs != null )
      {
        bs . graphics . clear ( ) ;
        bs . graphics . lineStyle ( 1 , application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 , true ) ;
        if ( toFill )
        {
          bs . graphics . beginFill ( application . getPropsDyn ( ) . getAppFontColorBright ( ) , 1 ) ;
        }
        bs . graphics . drawRect ( rectWidth / 2 , 0 , digitThickness , digitThickness ) ;
        if ( toFill )
        {
          bs . graphics . endFill ( ) ;
        }
      }
    }
    private function makeBinaryDigit ( bsBaseSprite : BaseSprite , bsString : String , visible1 : Boolean , visible2 : Boolean ) : void
    {
      if ( binaryElementsArray != null )
      {
        if ( binaryElementsArray [ bsString ] [ "e1" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e1" ] ) ;
          binaryElementsArray [ bsString ] [ "e1" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e2" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e2" ] ) ;
          binaryElementsArray [ bsString ] [ "e2" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e3" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e3" ] ) ;
          binaryElementsArray [ bsString ] [ "e3" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e4" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e4" ] ) ;
          binaryElementsArray [ bsString ] [ "e4" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e5" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e5" ] ) ;
          binaryElementsArray [ bsString ] [ "e5" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e6" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e6" ] ) ;
          binaryElementsArray [ bsString ] [ "e6" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e7" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e7" ] ) ;
          binaryElementsArray [ bsString ] [ "e7" ] = null ;
        }
        if ( binaryElementsArray [ bsString ] [ "e8" ] != null )
        {
          bsBaseSprite . removeChild ( binaryElementsArray [ bsString ] [ "e8" ] ) ;
          binaryElementsArray [ bsString ] [ "e8" ] = null ;
        }
        if ( visible1 )
        {
          binaryElementsArray [ bsString ] [ "e1" ] = new BaseSprite ( application ) ;
          bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e1" ] ) ;
          makeBinaryDot ( binaryElementsArray [ bsString ] [ "e1" ] , true ) ;
          binaryElementsArray [ bsString ] [ "e1" ] . x = 0 ;
          binaryElementsArray [ bsString ] [ "e1" ] . y = 0 ;
        }
        else
        {
          binaryElementsArray [ bsString ] [ "e1" ] = null ;
        }
        if ( visible2 )
        {
          binaryElementsArray [ bsString ] [ "e2" ] = new BaseSprite ( application ) ;
          bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e2" ] ) ;
          makeBinaryDot ( binaryElementsArray [ bsString ] [ "e2" ] , true ) ;
          binaryElementsArray [ bsString ] [ "e2" ] . x = 0 ;
          binaryElementsArray [ bsString ] [ "e2" ] . y = 1 * digitThickness + 1 * binaryDigitDelta ;
        }
        else
        {
          binaryElementsArray [ bsString ] [ "e2" ] = null ;
        }
        binaryElementsArray [ bsString ] [ "e3" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e3" ] ) ;
        makeBinaryDot ( binaryElementsArray [ bsString ] [ "e3" ] , true ) ;
        binaryElementsArray [ bsString ] [ "e3" ] . x = 0 ;
        binaryElementsArray [ bsString ] [ "e3" ] . y = 2 * digitThickness + 2 * binaryDigitDelta ;
        binaryElementsArray [ bsString ] [ "e4" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e4" ] ) ;
        makeBinaryDot ( binaryElementsArray [ bsString ] [ "e4" ] , true ) ;
        binaryElementsArray [ bsString ] [ "e4" ] . x = 0 ;
        binaryElementsArray [ bsString ] [ "e4" ] . y = 3 * digitThickness + 3 * binaryDigitDelta ;
        if ( visible1 )
        {
          binaryElementsArray [ bsString ] [ "e5" ] = new BaseSprite ( application ) ;
          bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e5" ] ) ;
          makeBinaryDot ( binaryElementsArray [ bsString ] [ "e5" ] , false ) ;
          binaryElementsArray [ bsString ] [ "e5" ] . x = 0 ;
          binaryElementsArray [ bsString ] [ "e5" ] . y = 0 ;
        }
        else
        {
          binaryElementsArray [ bsString ] [ "e5" ] = null ;
        }
        if ( visible2 )
        {
          binaryElementsArray [ bsString ] [ "e6" ] = new BaseSprite ( application ) ;
          bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e6" ] ) ;
          makeBinaryDot ( binaryElementsArray [ bsString ] [ "e6" ] , false ) ;
          binaryElementsArray [ bsString ] [ "e6" ] . x = 0 ;
          binaryElementsArray [ bsString ] [ "e6" ] . y = 1 * digitThickness + 1 * binaryDigitDelta ;
        }
        else
        {
          binaryElementsArray [ bsString ] [ "e6" ] = null ;
        }
        binaryElementsArray [ bsString ] [ "e7" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e7" ] ) ;
        makeBinaryDot ( binaryElementsArray [ bsString ] [ "e7" ] , false ) ;
        binaryElementsArray [ bsString ] [ "e7" ] . x = 0 ;
        binaryElementsArray [ bsString ] [ "e7" ] . y = 2 * digitThickness + 2 * binaryDigitDelta ;
        binaryElementsArray [ bsString ] [ "e8" ] = new BaseSprite ( application ) ;
        bsBaseSprite . addChild ( binaryElementsArray [ bsString ] [ "e8" ] ) ;
        makeBinaryDot ( binaryElementsArray [ bsString ] [ "e8" ] , false ) ;
        binaryElementsArray [ bsString ] [ "e8" ] . x = 0 ;
        binaryElementsArray [ bsString ] [ "e8" ] . y = 3 * digitThickness + 3 * binaryDigitDelta ;
        if ( visible1 )
        {
          BaseSprite ( binaryElementsArray [ bsString ] [ "e1" ] ) . alpha = 0 ;
        }
        if ( visible2 )
        {
          BaseSprite ( binaryElementsArray [ bsString ] [ "e2" ] ) . alpha = 0 ;
        }
        BaseSprite ( binaryElementsArray [ bsString ] [ "e3" ] ) . alpha = 0 ;
        BaseSprite ( binaryElementsArray [ bsString ] [ "e4" ] ) . alpha = 0 ;
        if ( visible1 )
        {
          BaseSprite ( binaryElementsArray [ bsString ] [ "e5" ] ) . alpha = 1 ;
        }
        if ( visible2 )
        {
          BaseSprite ( binaryElementsArray [ bsString ] [ "e6" ] ) . alpha = 1 ;
        }
        BaseSprite ( binaryElementsArray [ bsString ] [ "e7" ] ) . alpha = 1 ;
        BaseSprite ( binaryElementsArray [ bsString ] [ "e8" ] ) . alpha = 1 ;
      }
    }
    private function paintBinary ( e : Event = null ) : void
    {
      calcWidthHeightPositions ( ) ;
      makeBinaryDigit ( binaryH1 , "binaryH1" , false , false ) ;
      makeBinaryDigit ( binaryH2 , "binaryH2" , true , true ) ;
      makeBinaryDigit ( binaryM1 , "binaryM1" , false , true ) ;
      makeBinaryDigit ( binaryM2 , "binaryM2" , true , true ) ;
      makeBinaryDigit ( binaryS1 , "binaryS1" , false , true ) ;
      makeBinaryDigit ( binaryS2 , "binaryS2" , true , true ) ;
      if ( binaryH1 != null )
      {
        binaryH1 . x = int ( ( shapeFgFrame . getsw ( ) - allwBinary ) / 2 ) ;
        binaryH1 . y = int ( ( shapeFgFrame . getsh ( ) - 4 * digitThickness - 3 * binaryDigitDelta ) / 2 ) ;
        binaryH2 . x = binaryH1 . x + rectWidth ;
        binaryH2 . y = binaryH1 . y ;
        binaryM1 . x = binaryH2 . x + rectWidth ;
        binaryM1 . y = binaryH1 . y ;
        binaryM2 . x = binaryM1 . x + rectWidth ;
        binaryM2 . y = binaryH1 . y ;
        binaryS1 . x = binaryM2 . x + rectWidth ;
        binaryS1 . y = binaryH1 . y ;
        binaryS2 . x = binaryS1 . x + rectWidth ;
        binaryS2 . y = binaryH1 . y ;
      }
    }
/*
** Destroy
*/
    override public function destroy ( ) : void
    {
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , redrawReposShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_FONT_SIZE_CHANGED , fontSizeChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED , fontColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      if ( timer != null )
      {
        timer . stop ( ) ;
        timer . removeEventListener ( TimerEvent . TIMER , timerHandler ) ;
        timer = null ;
      }
      if ( spriteFg != null )
      {
        spriteFg . removeEventListener ( MouseEvent . CLICK , open ) ;
      }
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , mouseClose ) ;
      }
      super . destroy ( ) ;
      eventWatchChanged = null ;
      eventWatchRepositioned = null ;
      spriteFg = null ;
      spriteBg = null ;
      spriteWatch = null ;
      shapeBgFrame = null ;
      shapeFgFrame = null ;
      timer = null ;
      timeTextLabel = null ;
      dateTextLabel = null ;
      watchTypeListPicker = null ;
      secondsSwitcher = null ;
      textCodesWeekdays = null ;
      textCodesWatchTypes = null ;
      basicTimeTextLabel = null ;
      digitalTimeBaseSprite = null ;
      analogTimeBaseSprite = null ;
      binaryTimeBaseSprite = null ;
      digitalH1 = null ;
      digitalH2 = null ;
      digitalM1 = null ;
      digitalM2 = null ;
      digitalS1 = null ;
      digitalS2 = null ;
      digitalC1 = null ;
      digitalC2 = null ;
      digitalElementsArray = null ;
      analogFrame = null ;
      analogH = null ;
      analogM = null ;
      analogS = null ;
      binaryH1 = null ;
      binaryH2 = null ;
      binaryM1 = null ;
      binaryM2 = null ;
      binaryS1 = null ;
      binaryS2 = null ;
      binaryElementsArray = null ;
      digitThickness = 0 ;
      binaryDigitDelta = 0 ;
      margin = 0 ;
      rectWidth = 0 ;
      watchw = 0 ;
      temps = null ;
      tempm = null ;
      temph = null ;
      s = 0 ;
      m = 0 ;
      h = 0 ;
      watchType = null ;
    }
  }
}
