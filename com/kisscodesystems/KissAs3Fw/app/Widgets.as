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
** Widgets.
**
** MAIN FEATURES:
** Handles the widgets. (adding, closing, repositioning, searching, etc.)
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseEventDispatcher ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . events . Event ;
  public class Widgets extends BaseSprite
  {
// The id-s of the widgets!
    private var currentWidgetId : int = - 1 ;
// The content multiple!
    private var contentMultiple : ContentMultiple = null ;
// The array of the widgets, two dimensional!
// Needed for the order, contains the references to the added widgets.
    private var widgetsArray : Array = null ;
// The width and height data have to be saved to switch between desktop and mobile widget mode.
    private var widgetWidths : Array = null ;
    private var widgetHeights : Array = null ;
// Has to be an actual widget which is currently displayed.
// It is defined by desktops. Null if there is no widget.
    private var actualWidgets : Array = null ;
// One dimensipnal array to store the orientations of each contents.
    private var orientationsArray : Array = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Widgets ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Creating the contentSingle.
      contentMultiple = new ContentMultiple ( application ) ;
      addChild ( contentMultiple ) ;
      contentMultiple . setButtonBarVisible ( false ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGETS_ORIENTATION_CHANGED , widgetsOrientationChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_MODE_CHANGED , widgetModeChanged ) ;
// An array is needed to store the references to the widgets.
// Every loop on widgets should be happened on this array.
      widgetsArray = new Array ( ) ;
// Sizes.
      widgetWidths = new Array ( ) ;
      widgetHeights = new Array ( ) ;
// Actual widgets.
      actualWidgets = new Array ( ) ;
// Orientations.
      orientationsArray = new Array ( ) ;
    }
/*
** Adds a widget container.
*/
    public function addWidgetContainer ( ) : int
    {
      var containerId : int = contentMultiple . addContent ( "" + contentMultiple . getNumOfContents ( ) ) ;
      widgetsArray [ containerId ] = new Array ( ) ;
      orientationsArray [ containerId ] = application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) ;
      setActiveWidgetContainer ( containerId ) ;
      return containerId ;
    }
/*
** Gets the widget orientation.
*/
    public function getWidgetOrientation ( i : int ) : String
    {
      return orientationsArray [ i ] ;
    }
/*
** Gets the number of contents.
*/
    public function getNumOfContents ( ) : int
    {
      return contentMultiple . getNumOfContents ( ) ;
    }
/*
** Goes to the actual widget
*/
    public function goToTheActualWidget ( ) : void
    {
      goToTheWidget ( actualWidgets [ contentMultiple . getActiveIndex ( ) ] ) ;
    }
/*
** Gets the count of all widgets.
*/
    public function getNumOfAllWidgets ( ) : int
    {
      var num : int = 0 ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          num ++ ;
        }
      }
      return num ;
    }
/*
** Sets the active container.
*/
    public function setActiveWidgetContainer ( i : int ) : void
    {
      if ( i >= 0 && i < orientationsArray . length )
      {
        if ( contentMultiple . getActiveIndex ( ) != i )
        {
          contentMultiple . setActiveIndex ( i ) ;
          goToTheWidget ( actualWidgets [ i ] ) ;
        }
      }
    }
/*
** Removes a content.
*/
    public function removeWidgetContainer ( ) : void
    {
      var containerId : int = contentMultiple . getNumOfContents ( ) - 1 ;
      if ( containerId > 0 )
      {
        moveAllWidgetsFromContent ( containerId ) ;
        contentMultiple . removeContent ( containerId ) ;
        widgetsArray . splice ( containerId , 1 ) ;
        actualWidgets . splice ( containerId , 1 ) ;
        orientationsArray . splice ( containerId , 1 ) ;
        setActiveWidgetContainer ( containerId - 1 ) ;
      }
    }
/*
** Moves all of the widgets from a content to the first content.
*/
    private function moveAllWidgetsFromContent ( contentId : int ) : void
    {
      if ( contentId > 0 )
      {
        while ( widgetsArray [ contentId ] . length > 0 )
        {
          moveWidgetFromContent ( contentId , contentId - 1 , Widget ( widgetsArray [ contentId ] [ 0 ] ) , false ) ;
        }
        reposWidgets ( contentId - 1 ) ;
      }
    }
/*
** Moves one widget to the previous.
*/
    public function moveWidgetFromContent ( fromContentId : int , toContentId : int , widget : Widget , repositionRequired : Boolean ) : void
    {
      var indexOnFrom : int = widgetsArray [ fromContentId ] . indexOf ( widget ) ;
      var countOnFrom : int = widgetsArray [ fromContentId ] . length ;
      widgetsArray [ fromContentId ] . splice ( indexOnFrom , 1 ) ;
      widgetsArray [ toContentId ] . push ( widget ) ;
      contentMultiple . removeFromContent ( fromContentId , widget ) ;
      contentMultiple . addToContent ( toContentId , widget , 0 ) ;
      widget . setContentId ( toContentId ) ;
      if ( repositionRequired )
      {
        reposWidgets ( fromContentId ) ;
        reposWidgets ( toContentId ) ;
      }
      application . getMiddleground ( ) . setActiveWidgetContainer ( toContentId ) ;
      actualWidgets [ fromContentId ] = countOnFrom > 1 ? Widget ( widgetsArray [ fromContentId ] [ Math . max ( 0 , indexOnFrom - 1 ) ] ) : null ;
      actualWidgets [ toContentId ] = widget ;
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        widget . setDesktopSizes ( ) ;
      }
      else
      {
        widget . setMobileSizes ( ) ;
      }
      actualizeButtonsVisible ( fromContentId ) ;
      actualizeButtonsVisible ( toContentId ) ;
      goToTheWidget ( actualWidgets [ toContentId ] ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
      widgetsRePosSize ( ) ;
    }
/*
** Gets the next id for the widget.
*/
    private function getNextWidgetId ( ) : int
    {
      return ++ currentWidgetId ;
    }
/*
** Sets the sizes of the widget and goes to the first if needed.
*/
    private function resizeAllWidgetsAndGoTo ( ) : void
    {
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
          {
            Widget ( widgetsArray [ i ] [ j ] ) . setDesktopSizes ( ) ;
          }
          else
          {
            Widget ( widgetsArray [ i ] [ j ] ) . setMobileSizes ( ) ;
          }
        }
      }
      if ( ! application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        application . getPropsDyn ( ) . setAppBackgroundLive ( false ) ;
      }
      goToTheWidget ( actualWidgets [ contentMultiple . getActiveIndex ( ) ] ) ;
    }
/*
** When the widget mode has been changed.
*/
    private function widgetModeChanged ( e : Event ) : void
    {
      resizeAllWidgetsAndGoTo ( ) ;
    }
/*
** The orientation of the widgets has been changed.
*/
    private function widgetsOrientationChanged ( e : Event ) : void
    {
      orientationsArray [ contentMultiple . getActiveIndex ( ) ] = application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) ;
      reposWidgets ( contentMultiple . getActiveIndex ( ) ) ;
      goToTheWidget ( actualWidgets [ contentMultiple . getActiveIndex ( ) ] ) ;
    }
/*
** When one or more of the widgets have been resized.
*/
    private function widgetResized ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The event needs to be stopped to loose contact with that widget object if the orientation is not manual.
// (There may be objects listen to it.)
      if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) != application . getTexts ( ) . ORIENTATION_MANUAL )
      {
        e . stopImmediatePropagation ( ) ;
      }
// And now the repositioning
      reposWidgets ( widget . getContentId ( ) ) ;
    }
/*
** When one or more of the widgets have been repositioned.
*/
    private function widgetRepositioned ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The content id.
      var contentId : int = widget . getContentId ( ) ;
// The event needs to be stopped to loose contact with that widget object if the orientation is not manual.
      if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) != application . getTexts ( ) . ORIENTATION_MANUAL )
      {
        e . stopImmediatePropagation ( ) ;
      }
// The widgets has to be reordered according to the coordinate changing of this widget.
      var widget2 : Widget = null ;
      for ( var j : int = 0 ; j < widgetsArray [ contentId ] . length ; j ++ )
      {
        if ( widget != Widget ( widgetsArray [ contentId ] [ j ] ) && widget . hitTestObject ( Widget ( widgetsArray [ contentId ] [ j ] ) ) )
        {
          widget2 = Widget ( widgetsArray [ contentId ] [ j ] ) ;
          break ;
        }
      }
// Let's reorder if a widget is found to be hittested.
      if ( widget2 != null )
      {
        swapWidgets ( widget , widget2 ) ;
      }
// And now the repositioning
      reposWidgets ( contentId ) ;
    }
/*
** Swaps the two widgets. (changing their position in the widgetsArray into each other)
*/
    private function swapWidgets ( w : Widget , w2 : Widget ) : void
    {
// A temporary widget reference.
      var tempWidget : Widget = null ;
// One layer contains the widgets.
      var contentId : int = w . getContentId ( ) ;
      if ( contentId == w2 . getContentId ( ) )
      {
// The position of the two widgets
        var pos : int = widgetsArray [ contentId ] . indexOf ( w ) ;
        var pos2 : int = widgetsArray [ contentId ] . indexOf ( w2 ) ;
        if ( pos != pos2 && pos != - 1 && pos2 != - 1 )
        {
// Changing the references of the widget objects.
          tempWidget = widgetsArray [ contentId ] [ pos ] ;
          widgetsArray [ contentId ] [ pos ] = widgetsArray [ contentId ] [ pos2 ] ;
          widgetsArray [ contentId ] [ pos2 ] = tempWidget ;
        }
      }
    }
/*
** When a widget sends a message to close itself.
*/
    public function widgetCloseMe ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// Then the closure of that widget can be started.
      closeWidget ( widget ) ;
    }
/*
** A widget is being dragged.
*/
    private function widgetDragStart ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The content id.
      var contentId : int = widget . getContentId ( ) ;
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// Setting the glow onto the other widgets!
      setOrClearGlow ( contentId , widget ) ;
    }
/*
** That widget has been stopped to drag.
*/
    private function widgetDragStop ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The content id.
      var contentId : int = widget . getContentId ( ) ;
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// Clearing the glow from all of the widgets!
      setOrClearGlow ( contentId , null ) ;
    }
/*
** Sets or clears the blur filter of widgets.
** If the widget is not null then everybody will get their blur filter
** except the not null widget.
** If the widget is null then everybody (including the not null widget)
** will lose their blur filter.
** Manual orientation: there is no such thing that automatic repositioning.
*/
    private function setOrClearGlow ( contentId : int , widget : Widget ) : void
    {
// Looping on the widgets.
      for ( var i : int = 0 ; i < widgetsArray [ contentId ] . length ; i ++ )
      {
        Widget ( widgetsArray [ contentId ] [ i ] ) . safePlace ( ) ;
        if ( widget != null )
        {
          if ( Widget ( widgetsArray [ contentId ] [ i ] ) != widget )
          {
            Widget ( widgetsArray [ contentId ] [ i ] ) . filters = [ application . getPropsApp ( ) . getBlurFilterBackMiddle ( ) ] ;
          }
        }
        else
        {
          Widget ( widgetsArray [ contentId ] [ i ] ) . filters = null ;
        }
      }
    }
/*
** Actualize the buttons of all of the widgets on the content.
*/
    private function actualizeButtonsVisible ( contentId : int ) : void
    {
      var allWidgets : int = getNumOfAllWidgets ( ) ;
// Setting the visible of the buttons (header: prev widget, next widget, list widget)
      for ( var i : int = 0 ; i < widgetsArray [ contentId ] . length ; i ++ )
      {
        if ( i == 0 )
        {
          Widget ( widgetsArray [ contentId ] [ i ] ) . setButtonsVisible ( false , widgetsArray [ contentId ] . length > 1 , allWidgets > 1 ) ;
        }
        else if ( i == widgetsArray [ contentId ] . length - 1 )
        {
          Widget ( widgetsArray [ contentId ] [ i ] ) . setButtonsVisible ( true , false , allWidgets > 1 ) ;
        }
        else
        {
          Widget ( widgetsArray [ contentId ] [ i ] ) . setButtonsVisible ( true , true , allWidgets > 1 ) ;
        }
      }
    }
/*
** Repositions a widget according to the elements being backward of this.
*/
    private function reposWidget ( widget : Widget ) : void
    {
// The index of the element.
      var contentId : int = widget . getContentId ( ) ;
      var widgetIndex : int = widgetsArray [ contentId ] . indexOf ( widget ) ;
      if ( widgetIndex > - 1 )
      {
// The current line or column we are staying in.
        var rowOrCol : int = Math . floor ( widgetIndex / application . getPropsApp ( ) . getWidgetsElementsFix ( ) ) ;
// Should we place this object into new line or column?
        var intoNewRowOrCol : Boolean = widgetIndex % application . getPropsApp ( ) . getWidgetsElementsFix ( ) == 0 ;
// Wanted the x and y coordinates where we have to place the element.
        var tox : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var toy : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
// Other variables
        var maxx : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var maxy : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var i : int = 0 ;
        var allWidgets : int = getNumOfAllWidgets ( ) ;
// Setting the visible of the buttons (header: prev widget, next widget, list widget)
        if ( widgetIndex == 0 )
        {
          widget . setButtonsVisible ( false , widgetsArray [ contentId ] . length > 1 , allWidgets > 1 ) ;
        }
        else if ( widgetIndex == widgetsArray [ contentId ] . length - 1 )
        {
          widget . setButtonsVisible ( true , false , allWidgets > 1 ) ;
        }
        else
        {
          widget . setButtonsVisible ( true , true , allWidgets > 1 ) ;
        }
// Determining these x y values according to the orientation of the widgets: HORIZONTAL
// Maximum number of elements in COLUMNS next to each other.
// (Direction widget-by-widget: DOWN)
        if ( orientationsArray [ contentId ] == application . getTexts ( ) . ORIENTATION_HORIZONTAL )
        {
          if ( rowOrCol == 0 )
          {
            if ( widgetIndex == 0 )
            {
// This is the first widget so the x-y coordinates remain the initial margin values, do nothing.
            }
            else
            {
// Not the first widget but in the first row/column, so the other coordinate is set.
              toy = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . y + Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
          else
          {
            if ( intoNewRowOrCol )
            {
// The new row/column has to be started, so this is the point to determine the size of the previous row/col.
              for ( i = ( rowOrCol - 1 ) * application . getPropsApp ( ) . getWidgetsElementsFix ( ) ; i < widgetIndex ; i ++ )
              {
                if ( maxx < Widget ( widgetsArray [ contentId ] [ i ] ) . x + Widget ( widgetsArray [ contentId ] [ i ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) )
                {
                  maxx = Widget ( widgetsArray [ contentId ] [ i ] ) . x + Widget ( widgetsArray [ contentId ] [ i ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
              }
              tox = maxx ;
            }
            else
            {
// We are currently in a started row/col, so we continue that: coordinates from the previous widget.
              tox = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . x ;
              toy = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . y + Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
// Finally: let's place this widget if this is not in this coordinates.
          if ( widget . x != tox || widget . y != toy )
          {
            widget . x = tox ;
            widget . y = toy ;
          }
        }
// Determining these x y values according to the orientation of the widgets: VERTICAL
// Maximum number of elements in ROWS under each other.
// (Direction widget-by-widget: RIGHT)
        else if ( orientationsArray [ contentId ] == application . getTexts ( ) . ORIENTATION_VERTICAL )
        {
          if ( rowOrCol == 0 )
          {
            if ( widgetIndex == 0 )
            {
// This is the first widget so the x-y coordinates remain the initial margin values, do nothing.
            }
            else
            {
// Not the first widget but in the first row/column, so the other coordinate is set.
              tox = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . x + Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
          else
          {
            if ( intoNewRowOrCol )
            {
// The new row/column has to be started, so this is the point to determine the size of the previous row/col.
              for ( i = ( rowOrCol - 1 ) * application . getPropsApp ( ) . getWidgetsElementsFix ( ) ; i < widgetIndex ; i ++ )
              {
                if ( maxy < Widget ( widgetsArray [ contentId ] [ i ] ) . y + Widget ( widgetsArray [ contentId ] [ i ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) )
                {
                  maxy = Widget ( widgetsArray [ contentId ] [ i ] ) . y + Widget ( widgetsArray [ contentId ] [ i ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
              }
              toy = maxy ;
            }
            else
            {
// We are currently in a started row/col, so we continue that: coordinates from the previous widget.
              toy = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . y ;
              tox = Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . x + Widget ( widgetsArray [ contentId ] [ widgetIndex - 1 ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
// Finally: let's place this widget if this is not in this coordinates.
          if ( widget . x != tox || widget . y != toy )
          {
            widget . x = tox ;
            widget . y = toy ;
          }
        }
      }
    }
/*
** Repositioning all of the widgets if the size of the contentSingle
** has changed or widgets have been removed or added.
*/
    private function reposWidgets ( contentId : int ) : void
    {
      if ( application != null )
      {
// This is easy, each widget has to be repositioned one-by-one.
        for ( var i : int = 0 ; i < widgetsArray [ contentId ] . length ; i ++ )
        {
          reposWidget ( Widget ( widgetsArray [ contentId ] [ i ] ) ) ;
        }
// Because the x and y coordinates is set, the own cx and cy coordinates have to be updated.
        for ( var j : int = 0 ; j < widgetsArray [ contentId ] . length ; j ++ )
        {
          Widget ( widgetsArray [ contentId ] [ j ] ) . updatecxy ( ) ;
        }
// And now, the recalculation of the size of the content has to be recalculated manually.
        if ( widgetsArray [ contentId ] . length > 0 )
        {
          application . callContentSizeRecalc ( Widget ( widgetsArray [ contentId ] [ 0 ] ) ) ;
        }
        else
        {
          application . callContentSizeRecalc ( contentMultiple . getContentSingle ( contentId ) ) ;
        }
      }
    }
/*
** Getting a Widget by its id. (in any widget containers)
*/
    public function getWidgetById ( id : int ) : Widget
    {
      var widget : Widget = null ;
      all : for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          if ( Widget ( widgetsArray [ i ] [ j ] ) . getWidgetId ( ) == id )
          {
            widget = Widget ( widgetsArray [ i ] [ j ] ) ;
            break all ;
          }
        }
      }
      return widget ;
    }
/*
** Getting a Widget by its header. (in any widget containers)
*/
    public function getWidgetByHeader ( header : String ) : Widget
    {
      var widget : Widget = null ;
      all : for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          if ( Widget ( widgetsArray [ i ] [ j ] ) . getWidgetHeader ( ) == header )
          {
            widget = Widget ( widgetsArray [ i ] [ j ] ) ;
            break all ;
          }
        }
      }
      return widget ;
    }
/*
** Getting a Widget by its id. (in any widget containers)
*/
    public function getWidgetByValue ( val : String ) : Widget
    {
      var widget : Widget = null ;
      all : for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          try
          {
            if ( Widget ( widgetsArray [ i ] [ j ] ) . getValue ( ) . toString ( ) == val )
            {
              widget = Widget ( widgetsArray [ i ] [ j ] ) ;
              break all ;
            }
          }
          catch ( e : * )
          {
            continue ;
          }
        }
      }
      return widget ;
    }
/*
** Gets the headers of the widgets. (in any widget containers)
*/
    public function getWidgetHeaders ( ) : Array
    {
      var headers : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          headers . push ( Widget ( widgetsArray [ i ] [ j ] ) . getWidgetHeader ( ) ) ;
        }
      }
      return headers ;
    }
/*
** Gets the headers of the widgets. (in any widget containers)
*/
    public function getWidgetIds ( ) : Array
    {
      var ids : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          ids . push ( Widget ( widgetsArray [ i ] [ j ] ) . getWidgetId ( ) ) ;
        }
      }
      return ids ;
    }
/*
** Selects the previous or next widget from the given.
*/
    public function goToPrevWidget ( widget : Widget ) : void
    {
      var contentId : int = widget . getContentId ( ) ;
      for ( var i : int = 0 ; i < widgetsArray [ contentId ] . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ contentId ] [ i ] ) == widget )
        {
          if ( i > 0 )
          {
            goToTheWidget ( Widget ( widgetsArray [ contentId ] [ i - 1 ] ) ) ;
            break ;
          }
        }
      }
    }
    public function goToNextWidget ( widget : Widget ) : void
    {
      var contentId : int = widget . getContentId ( ) ;
      for ( var i : int = 0 ; i < widgetsArray [ contentId ] . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ contentId ] [ i ] ) == widget )
        {
          if ( i < widgetsArray [ contentId ] . length - 1 )
          {
            goToTheWidget ( Widget ( widgetsArray [ contentId ] [ i + 1 ] ) ) ;
            break ;
          }
        }
      }
    }
/*
** Goes to a specific widget!
*/
    public function goToTheWidget ( widget : Widget ) : void
    {
      if ( widget != null )
      {
        actualWidgets [ widget . getContentId ( ) ] = widget ;
        setActiveWidgetContainer ( widget . getContentId ( ) ) ;
        application . getMiddleground ( ) . setActiveWidgetContainer ( widget . getContentId ( ) ) ;
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          contentMultiple . getBaseScroll ( widget . getContentId ( ) ) . setccxcy ( application . getPropsApp ( ) . getWidgetsMargin ( ) - widget . getcx ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) - widget . getcy ( ) ) ;
        }
        else
        {
          contentMultiple . getBaseSprite ( widget . getContentId ( ) ) . setcxy ( - widget . getcx ( ) , - widget . getcy ( ) ) ;
        }
      }
    }
/*
** Adds a widget into the widgets.
*/
    public function addWidget ( contentId : int , widget : Widget ) : void
    {
      if ( widget != null )
      {
        widget . setContentId ( contentId ) ;
        contentMultiple . addToContent ( contentId , widget , widgetsArray . length ) ;
        widgetsArray [ contentId ] . push ( widget ) ;
        widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , widgetResized ) ;
        widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COORDINATES_CHANGED , widgetRepositioned ) ;
        widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_CLOSE_ME , widgetCloseMe ) ;
        widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_DRAG_START , widgetDragStart ) ;
        widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_DRAG_STOP , widgetDragStop ) ;
        widget . setWidgetId ( getNextWidgetId ( ) ) ;
        widget . setButtonMoveVisible ( getNumOfContents ( ) != 1 ) ;
        if ( orientationsArray [ contentId ] == application . getTexts ( ) . ORIENTATION_MANUAL )
        {
          widget . setcxy ( application . getPropsApp ( ) . getWidgetsMargin ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) ) ;
          reposWidgets ( contentId ) ;
        }
        else
        {
          reposWidget ( widget ) ;
          widget . updatecxy ( ) ;
          application . callContentSizeRecalc ( widget ) ;
        }
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          widget . setDesktopSizes ( ) ;
        }
        else
        {
          widget . setMobileSizes ( ) ;
        }
        actualizeButtonsVisible ( contentId ) ;
        goToTheWidget ( widget ) ;
      }
    }
/*
** Changes the visible of the move button of the widgets if necessary.
*/
    public function changeButtonMoveVisibleOnAllWidgets ( ) : void
    {
      var v : Boolean = getNumOfContents ( ) != 1 ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          Widget ( widgetsArray [ i ] [ j ] ) . setButtonMoveVisible ( v ) ;
        }
      }
    }
/*
** Removing a Widget.
*/
    public function closeWidget ( widget : Widget ) : void
    {
      if ( widget != null )
      {
        if ( widget . onClose ( ) )
        {
          var contentId : int = widget . getContentId ( ) ;
          var widgetIndex : int = widgetsArray [ contentId ] . indexOf ( widget ) ;
          widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , widgetResized ) ;
          widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_COORDINATES_CHANGED , widgetRepositioned ) ;
          widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_CLOSE_ME , widgetCloseMe ) ;
          widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_DRAG_START , widgetDragStart ) ;
          widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_DRAG_STOP , widgetDragStop ) ;
          widget . destroy ( ) ;
          contentMultiple . removeFromContent ( contentId , widget ) ;
          widgetsArray [ contentId ] . splice ( widgetIndex , 1 ) ;
          widgetWidths . splice ( widgetWidths . indexOf ( widget ) , 1 ) ;
          widgetHeights . splice ( widgetHeights . indexOf ( widget ) , 1 ) ;
          reposWidgets ( contentId ) ;
          if ( actualWidgets [ contentId ] == widget )
          {
            if ( widgetIndex > 0 )
            {
              actualWidgets [ contentId ] = widgetsArray [ contentId ] [ widgetIndex - 1 ] ;
            }
            else
            {
              actualWidgets [ contentId ] = null ;
            }
          }
          goToTheWidget ( actualWidgets [ contentId ] ) ;
        }
      }
    }
/*
** The size of the widget has to be saved sometimes.
*/
    public function saveWidgetSizes ( widget : Widget , width : int , height : int ) : void
    {
      if ( widget != null )
      {
        widgetWidths [ widget ] = width ;
        widgetHeights [ widget ] = height ;
      }
    }
    public function getWidgetSavedWidth ( widget : Widget ) : int
    {
      if ( widget != null )
      {
        return widgetWidths [ widget ] ;
      }
      return application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) ;
    }
    public function getWidgetSavedHeight ( widget : Widget ) : int
    {
      if ( widget != null )
      {
        return widgetHeights [ widget ] ;
      }
      return application . getPropsApp ( ) . getWidgetSizeMinHeight ( ) ;
    }
/*
** Overriding the setsw setsh and setswh functions.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Redrawing the shape.
*/
    public function widgetsRePosSize ( ) : void
    {
      setcxy ( 0 , application . getsh ( ) - application . getMiddleground ( ) . getWidgetsh ( ) ) ;
      super . setswh ( application . getsw ( ) , application . getMiddleground ( ) . getWidgetsh ( ) ) ;
      contentMultiple . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      contentMultiple . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , getsh ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
      resizeAllWidgetsAndGoTo ( ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGETS_ORIENTATION_CHANGED , widgetsOrientationChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_MODE_CHANGED , widgetModeChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      currentWidgetId = 0 ;
      contentMultiple = null ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        for ( var j : int = 0 ; j < widgetsArray [ i ] . length ; j ++ )
        {
          widgetsArray [ i ] [ j ] = null ;
        }
        widgetsArray [ i ] . splice ( 0 ) ;
      }
      widgetsArray . splice ( 0 ) ;
      widgetsArray = null ;
      widgetWidths . splice ( 0 ) ;
      widgetWidths = null ;
      widgetHeights . splice ( 0 ) ;
      widgetHeights = null ;
      actualWidgets . splice ( 0 ) ;
      actualWidgets = null ;
      orientationsArray . splice ( 0 ) ;
      orientationsArray = null ;
    }
  }
}
