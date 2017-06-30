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
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . events . Event ;
  public class Widgets extends BaseSprite
  {
// The id-s of the widgets!
    private var currentWidgetId : int = - 1 ;
// The contentSingle!
    private var contentSingle : ContentSingle = null ;
// The array of the widgets!
// Needed for the order, contains the references to the added widgets.
    private var widgetsArray : Array = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Widgets ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Creating the contentSingle.
      contentSingle = new ContentSingle ( application ) ;
      addChild ( contentSingle ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_ORIENTATIONS_CHANGED , widgetsOrientationChanged ) ;
// An array is needed to store the references to the widgets.
// Every loop on widgets should be happened on this array.
      widgetsArray = new Array ( ) ;
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
** The orientation of the widgets has been changed.
*/
    private function widgetsOrientationChanged ( e : Event ) : void
    {
      reposWidgets ( ) ;
    }
/*
** When one or more of the widgets have been resized.
*/
    private function widgetResized ( e : Event ) : void
    {
      reposWidgets ( ) ;
    }
/*
** When one or more of the widgets have been repositioned.
*/
    private function widgetRepositioned ( e : Event ) : void
    {
// Getting the target widget first.
      var widget : Widget = Widget ( BaseEventDispatcher ( e . target ) . getParentObject ( ) ) ;
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// The widgets has to be reordered according to the coordinate changing of this widget.
      var widget2 : Widget = null ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        if ( widget != Widget ( widgetsArray [ i ] ) && widget . hitTestObject ( Widget ( widgetsArray [ i ] ) ) )
        {
          widget2 = Widget ( widgetsArray [ i ] ) ;
          break ;
        }
      }
// Let's reorder if a widget is found to be hittested.
      if ( widget2 != null )
      {
        swapWidgets ( widget , widget2 ) ;
      }
// And now the repositioning
      reposWidgets ( ) ;
    }
/*
** Swaps the two widgets. (changing their position in the widgetsArray into each other)
*/
    private function swapWidgets ( w : Widget , w2 : Widget ) : void
    {
// A temporary widget reference.
      var tempWidget : Widget = null ;
// The position of the two widgets
      var pos : int = widgetsArray . indexOf ( w ) ;
      var pos2 : int = widgetsArray . indexOf ( w2 ) ;
      if ( pos != pos2 && pos != - 1 && pos2 != - 1 )
      {
// Changing the references of the widget objects.
        tempWidget = widgetsArray [ pos ] ;
        widgetsArray [ pos ] = widgetsArray [ pos2 ] ;
        widgetsArray [ pos2 ] = tempWidget ;
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
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// Setting the glow onto the other widgets!
      setOrClearGlow ( widget ) ;
    }
/*
** That widget has been stopped to drag.
*/
    private function widgetDragStop ( e : Event ) : void
    {
// The event needs to be stopped to loose contact with that widget object.
      e . stopImmediatePropagation ( ) ;
// Clearing the glow from all of the widgets!
      setOrClearGlow ( null ) ;
    }
/*
** Sets or clears the blur filter of widgets.
** If the widget is not null then everybody will get their blur filter
** except the not null widget.
** If the widget is null then everybody (including the not null widget)
** will lose their blur filter.
*/
    private function setOrClearGlow ( widget : Widget ) : void
    {
// Looping on the widgets.
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        Widget ( widgetsArray [ i ] ) . safePlace ( ) ;
        if ( widget != null )
        {
          if ( Widget ( widgetsArray [ i ] ) != widget )
          {
            Widget ( widgetsArray [ i ] ) . filters = [ application . getPropsApp ( ) . getBlurFilterBackMiddle ( ) ] ;
          }
        }
        else
        {
          Widget ( widgetsArray [ i ] ) . filters = null ;
        }
      }
    }
/*
** Repositions a widget according to the elements being backward of this.
** In case of manual positioning, it will be called and will call itself recursivelly.
*/
    private function reposWidget ( widget : Widget ) : void
    {
// The index of the element.
      var widgetIndex : int = widgetsArray . indexOf ( widget ) ;
      if ( widgetIndex > - 1 )
      {
// The current line or column we are staying in.
        var rowOrCol : int = Math . floor ( widgetIndex / application . getPropsApp ( ) . getWidgetsMaxElementsInLineOrColumn ( ) ) ;
// Should we place this object into new line or column?
        var intoNewRowOrCol : Boolean = widgetIndex % application . getPropsApp ( ) . getWidgetsMaxElementsInLineOrColumn ( ) == 0 ;
// Wanted the x and y coordinates where we have to place the element.
        var tox : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var toy : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
// Other variables
        var maxx : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var maxy : int = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
        var i : int = 0 ;
// Setting the visible of the buttons (header: prev widget, next widget, list widget)
        if ( widgetIndex == 0 )
        {
          widget . setButtonVisible ( false , widgetsArray . length > 1 , widgetsArray . length > 1 ) ;
        }
        else if ( widgetIndex == widgetsArray . length - 1 )
        {
          widget . setButtonVisible ( true , false , widgetsArray . length > 1 ) ;
        }
        else
        {
          widget . setButtonVisible ( true , true , widgetsArray . length > 1 ) ;
        }
// Determining these x y values according to the orientation of the widgets: HORIZONTAL
// Maximum number of elements in COLUMNS next to each other.
// (Direction widget-by-widget: DOWN)
        if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) == application . getTexts ( ) . ORIENTATION_HORIZONTAL )
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
              toy = Widget ( widgetsArray [ widgetIndex - 1 ] ) . y + Widget ( widgetsArray [ widgetIndex - 1 ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
          else
          {
            if ( intoNewRowOrCol )
            {
// The new row/column has to be started, so this is the point to determine the size of the previous row/col.
              for ( i = ( rowOrCol - 1 ) * application . getPropsApp ( ) . getWidgetsMaxElementsInLineOrColumn ( ) ; i < widgetIndex ; i ++ )
              {
                if ( maxx < Widget ( widgetsArray [ i ] ) . x + Widget ( widgetsArray [ i ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) )
                {
                  maxx = Widget ( widgetsArray [ i ] ) . x + Widget ( widgetsArray [ i ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
              }
              tox = maxx ;
            }
            else
            {
// We are currently in a started row/col, so we continue that: coordinates from the previous widget.
              tox = Widget ( widgetsArray [ widgetIndex - 1 ] ) . x ;
              toy = Widget ( widgetsArray [ widgetIndex - 1 ] ) . y + Widget ( widgetsArray [ widgetIndex - 1 ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
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
        else if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) == application . getTexts ( ) . ORIENTATION_VERTICAL )
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
              tox = Widget ( widgetsArray [ widgetIndex - 1 ] ) . x + Widget ( widgetsArray [ widgetIndex - 1 ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
          else
          {
            if ( intoNewRowOrCol )
            {
// The new row/column has to be started, so this is the point to determine the size of the previous row/col.
              for ( i = ( rowOrCol - 1 ) * application . getPropsApp ( ) . getWidgetsMaxElementsInLineOrColumn ( ) ; i < widgetIndex ; i ++ )
              {
                if ( maxy < Widget ( widgetsArray [ i ] ) . y + Widget ( widgetsArray [ i ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) )
                {
                  maxy = Widget ( widgetsArray [ i ] ) . y + Widget ( widgetsArray [ i ] ) . getsh ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
              }
              toy = maxy ;
            }
            else
            {
// We are currently in a started row/col, so we continue that: coordinates from the previous widget.
              toy = Widget ( widgetsArray [ widgetIndex - 1 ] ) . y ;
              tox = Widget ( widgetsArray [ widgetIndex - 1 ] ) . x + Widget ( widgetsArray [ widgetIndex - 1 ] ) . getsw ( ) + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
            }
          }
// Finally: let's place this widget if this is not in this coordinates.
          if ( widget . x != tox || widget . y != toy )
          {
            widget . x = tox ;
            widget . y = toy ;
          }
        }
// Determining these x y values according to the orientation of the widgets: MANUAL
// The user can place the widgets but if a widget is on one of the others then the widgets
// will be slided until none of the widgets are under another.
// (Direction widget-by-widget: none)
        else if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) == application . getTexts ( ) . ORIENTATION_MANUAL )
        {
// Goes on all of the widgets.
          for ( var j : int = 0 ; j < widgetsArray . length ; j ++ )
          {
// If the current is not the widget reference coming from the argument of this function call..
            if ( Widget ( widgetsArray [ j ] ) != widget )
            {
// If this widget and the widget comes from the function arguments are hit test positive..
              if ( Widget ( widgetsArray [ j ] ) . hitTestObject ( widget ) )
              {
// The current widget has to be dragged out in the direction which is shorter than the other.
                if ( Widget ( widgetsArray [ j ] ) . width > Widget ( widgetsArray [ j ] ) . height )
                {
                  Widget ( widgetsArray [ j ] ) . x = widget . x + widget . width + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
                else
                {
                  Widget ( widgetsArray [ j ] ) . y = widget . y + widget . height + application . getPropsApp ( ) . getWidgetsMargin ( ) ;
                }
// Because this widget is moved, it may be on other widgets so it has to be passed to another function call!
                reposWidget ( Widget ( widgetsArray [ j ] ) ) ;
              }
            }
          }
        }
      }
    }
/*
** Repositioning all of the widgets if the size of the contentSingle
** has changed or widgets have been removed or added.
*/
    private function reposWidgets ( ) : void
    {
      if ( application != null )
      {
// This is easy, each widget has to be repositioned one-by-one.
        for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
        {
          reposWidget ( Widget ( widgetsArray [ i ] ) ) ;
        }
// Because the x and y coordinates is set, the own cx and cy coordinates have to be updated.
        for ( var j : int = 0 ; j < widgetsArray . length ; j ++ )
        {
          Widget ( widgetsArray [ j ] ) . updatecxy ( ) ;
        }
// And now, the recalculation of the size of the content has to be recalculated manually.
        if ( widgetsArray . length > 0 )
        {
          application . callContentSizeRecalc ( Widget ( widgetsArray [ 0 ] ) ) ;
        }
        else
        {
          application . callContentSizeRecalc ( contentSingle ) ;
        }
      }
    }
/*
** Getting a Widget by its id.
*/
    public function getWidgetById ( id : int ) : Widget
    {
      var widget : Widget = null ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ i ] ) . getWidgetId ( ) == id )
        {
          widget = Widget ( widgetsArray [ i ] ) ;
          break ;
        }
      }
      return widget ;
    }
/*
** Getting a Widget by its header.
*/
    public function getWidgetByHeader ( header : String ) : Widget
    {
      var widget : Widget = null ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ i ] ) . getWidgetHeader ( ) == header )
        {
          widget = Widget ( widgetsArray [ i ] ) ;
          break ;
        }
      }
      return widget ;
    }
/*
** Selects the previous or next widget from the given.
*/
    public function goToPrevWidget ( widget : Widget ) : void
    {
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ i ] ) == widget )
        {
          if ( i > 0 )
          {
            contentSingle . getBaseScroll ( ) . setccxcy ( application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i - 1 ] ) . getcx ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i - 1 ] ) . getcy ( ) ) ;
            break ;
          }
        }
      }
    }
    public function goToNextWidget ( widget : Widget ) : void
    {
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        if ( Widget ( widgetsArray [ i ] ) == widget )
        {
          if ( i < widgetsArray . length - 1 )
          {
            contentSingle . getBaseScroll ( ) . setccxcy ( application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i + 1 ] ) . getcx ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i + 1 ] ) . getcy ( ) ) ;
            break ;
          }
        }
      }
    }
/*
** Goes to a specific widget!
*/
    public function goToTheWidget ( i : int ) : void
    {
      contentSingle . getBaseScroll ( ) . setccxcy ( application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i ] ) . getcx ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) - Widget ( widgetsArray [ i ] ) . getcy ( ) ) ;
    }
/*
** Adds a widget into the widgets.
*/
    public function addWidget ( widget : Widget ) : void
    {
      contentSingle . addToContent ( widget , true , 0 ) ;
      widgetsArray . push ( widget ) ;
      widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , widgetResized ) ;
      widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_COORDINATES_CHANGED , widgetRepositioned ) ;
      widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_CLOSE_ME , widgetCloseMe ) ;
      widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_DRAG_START , widgetDragStart ) ;
      widget . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_DRAG_STOP , widgetDragStop ) ;
      widget . setWidgetId ( getNextWidgetId ( ) ) ;
      if ( application . getPropsDyn ( ) . getAppWidgetsOrientation ( ) == application . getTexts ( ) . ORIENTATION_MANUAL )
      {
        widget . setcxy ( application . getPropsApp ( ) . getWidgetsMargin ( ) , application . getPropsApp ( ) . getWidgetsMargin ( ) ) ;
        reposWidgets ( ) ;
      }
      else
      {
        reposWidget ( widget ) ;
      }
    }
/*
** Removing a Widget.
*/
    public function closeWidget ( widget : Widget ) : void
    {
      if ( widget . onClose ( ) )
      {
        widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , widgetResized ) ;
        widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_COORDINATES_CHANGED , widgetRepositioned ) ;
        widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_CLOSE_ME , widgetCloseMe ) ;
        widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_DRAG_START , widgetDragStart ) ;
        widget . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_DRAG_STOP , widgetDragStop ) ;
        widget . destroy ( ) ;
        contentSingle . removeFromContent ( widget ) ;
        widgetsArray . splice ( widgetsArray . indexOf ( widget ) , 1 ) ;
        reposWidgets ( ) ;
      }
    }
/*
** Gets the headers of the widgets.
*/
    public function getWidgetHeaders ( ) : Array
    {
      var headers : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        headers . push ( Widget ( widgetsArray [ i ] ) . getWidgetHeader ( ) ) ;
      }
      return headers ;
    }
/*
** Gets the headers of the widgets.
*/
    public function getWidgetIds ( ) : Array
    {
      var ids : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
      {
        ids . push ( Widget ( widgetsArray [ i ] ) . getWidgetId ( ) ) ;
      }
      return ids ;
    }
/*
** Closing all of the widgets.
*/
    private function closeAllWidgets ( ) : void
    {
// Closing all.
      while ( widgetsArray . length > 0 )
      {
        closeWidget ( Widget ( widgetsArray [ 0 ] ) ) ;
      }
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
      if ( application != null )
      {
        if ( application . getBackground ( ) != null )
        {
          setcxy ( 0 , application . getMiddleground ( ) . getHeaderh ( ) ) ;
          super . setswh ( application . getsw ( ) , application . getMiddleground ( ) . getWidgetsh ( ) ) ;
          contentSingle . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          contentSingle . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , getsh ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
          if ( application . getPropsApp ( ) . getSmartphoneMode ( ) )
          {
            for ( var i : int = 0 ; i < widgetsArray . length ; i ++ )
            {
              Widget ( widgetsArray [ i ] ) . setswh ( Widget ( widgetsArray [ i ] ) . getswFromParentContent ( ) , Widget ( widgetsArray [ i ] ) . getshFromParentContent ( ) ) ;
            }
            reposWidgets ( ) ;
          }
        }
      }
    }
/*
** Sets the smartphone mode.
*/
    public function toSmartphone ( ) : void
    {
      widgetsRePosSize ( ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_ORIENTATIONS_CHANGED , widgetsOrientationChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      currentWidgetId = 0 ;
      contentSingle = null ;
      widgetsArray . splice ( 0 ) ;
      widgetsArray = null ;
    }
  }
}