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
** Widget.
** This object will be the replacement of a usual window.
**
** MAIN FEATURES:
** - can be:
**   - added to the content of the Widgets (implemented in Widgets class)
**   - repositioned (implemented in Widgets class)
**   - closed and removed from the content of the widgets (implemented in Widgets clas)
**   - resized
**   - minimised (content hide, only the header is visible)
** - cannot be under each other
** - new widgets should extend this
** - can have an id and a type and these can be set once.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . Widgets ;
  import com . kisscodesystems . KissAs3Fw . base . BaseEventDispatcher ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class Widget extends BaseSprite
  {
// The mouse down event can be happened on this objects.
    private const mouseDownHappenedMover : String = "mouseDownHappenedMover" ;
    private const mouseDownHappenedResizer : String = "mouseDownHappenedResizer" ;
// The id of the Widget (unique identifier integer), can be set only one time.
    private var widgetId : int = - 1 ;
// The header of the Widget (unique text or text code of the header label), can be set only one time.
    private var widgetHeader : String = null ;
// The type of the Widget (basically the menu item, not has to be unique), can be set only one time.
    private var widgetType : String = null ;
// A shape to the background of all.
    private var baseShape : BaseShape = null ;
// The background of the widget
    private var backLabel : BaseShape = null ;
// The label of the widget
    private var textLabel : TextLabel = null ;
// The mover of this widget.
    private var mover : BaseSprite = null ;
// The closer of this widget.
// Double click on it results the close me event to the outside.
    private var closer : BaseSprite = null ;
// The resizer of this widget.
    private var resizer : BaseSprite = null ;
// And the contentMultiple of this widget.
    protected var contentMultiple : ContentMultiple = null ;
// To be able to determine: the widget is moved or not.
    private var prevMouseX : int = 0 ;
    private var prevMouseY : int = 0 ;
// The mouse down has happened in..
    private var mouseDownHappened : String = null ;
// The event of closing this widget.
    private var eventWidgetCloseMe : Event = null ;
// The events of dragging and dropping this widget.
    private var eventWidgetDragStart : Event = null ;
    private var eventWidgetDragStop : Event = null ;
// The movement of the widget is controlled.
    private var prevX : Number = 0 ;
    private var prevY : Number = 0 ;
    private var widgetInMove : Boolean = false ;
// The buttons of the navigation.
    private var buttonDrawMove : ButtonDraw = null ;
    private var buttonDrawPrev : ButtonDraw = null ;
    private var buttonDrawNext : ButtonDraw = null ;
    private var buttonDrawList : ButtonDraw = null ;
// The id of the content.
    private var contentId : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Widget ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating the resizer object first. (if we can)
      if ( application . getPropsApp ( ) . getWidgetEnableManualResize ( ) )
      {
        resizer = new BaseSprite ( application ) ;
        addChild ( resizer ) ;
        resizer . addEventListener ( MouseEvent . MOUSE_DOWN , resizerMouseDown ) ;
      }
// Creating the base shape: the background of all.
      baseShape = new BaseShape ( application ) ;
      addChild ( baseShape ) ;
      baseShape . setdb ( false ) ;
      baseShape . setdt ( - 1 ) ;
// Creating the contentMultiple.
      contentMultiple = new ContentMultiple ( application ) ;
      addChild ( contentMultiple ) ;
// Creating the header (label + mover) of this widget.
      backLabel = new BaseShape ( application ) ;
      addChild ( backLabel ) ;
      backLabel . setdb ( true ) ;
      backLabel . setdt ( 1 ) ;
      textLabel = new TextLabel ( application ) ;
      addChild ( textLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , textLabelResized ) ;
      mover = new BaseSprite ( application ) ;
      addChild ( mover ) ;
      mover . addEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
// The widget navigator buttons.
      buttonDrawMove = new ButtonDraw ( application ) ;
      addChild ( buttonDrawMove ) ;
      buttonDrawMove . setButtonType ( application . DRAW_BUTTON_TYPE_WIDGET_MOVE ) ;
      buttonDrawMove . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawMoveClick ) ;
      buttonDrawMove . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonDrawResized ) ;
      buttonDrawPrev = new ButtonDraw ( application ) ;
      addChild ( buttonDrawPrev ) ;
      buttonDrawPrev . setButtonType ( application . DRAW_BUTTON_TYPE_WIDGETS_PREV ) ;
      buttonDrawPrev . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawPrevClick ) ;
      buttonDrawPrev . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonDrawResized ) ;
      buttonDrawNext = new ButtonDraw ( application ) ;
      addChild ( buttonDrawNext ) ;
      buttonDrawNext . setButtonType ( application . DRAW_BUTTON_TYPE_WIDGETS_NEXT ) ;
      buttonDrawNext . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawNextClick ) ;
      buttonDrawNext . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonDrawResized ) ;
      buttonDrawList = new ButtonDraw ( application ) ;
      addChild ( buttonDrawList ) ;
      buttonDrawList . setButtonType ( application . DRAW_BUTTON_TYPE_WIDGETS_LIST ) ;
      buttonDrawList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawListClick ) ;
      buttonDrawList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonDrawResized ) ;
// Finally the closer.
      closer = new BaseSprite ( application ) ;
      addChild ( closer ) ;
      closer . addEventListener ( MouseEvent . DOUBLE_CLICK , closerDoubleClick ) ;
      closer . doubleClickEnabled = true ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
// The event of closing itself or drag start or drag stop.
      eventWidgetCloseMe = new Event ( application . EVENT_WIDGET_CLOSE_ME ) ;
      eventWidgetDragStart = new Event ( application . EVENT_WIDGET_DRAG_START ) ;
      eventWidgetDragStop = new Event ( application . EVENT_WIDGET_DRAG_STOP ) ;
// Tell to the base event dispatcher the reference.
      setEventDispatcherObjectToThis ( ) ;
    }
/*
** This method will be called if the object is being added to the stage.
** A lot of initializing happens here because the stage is available
** from here.
*/
    override protected function addedToStage ( e : Event ) : void
    {
      super . addedToStage ( e ) ;
// This object is created and now is the part of the hierarchy of display objects.
      onCreate ( ) ;
// Listens to the mouse up on stage.
      stage . addEventListener ( MouseEvent . MOUSE_UP , stageMouseUp , false , 0 , true ) ;
    }
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      super . removedFromStage ( e ) ;
    }
/*
** Sets and gets the id of the content of this widget.
*/
    public function setContentId ( cid : int ) : void
    {
      contentId = cid ;
    }
    public function getContentId ( ) : int
    {
      return contentId ;
    }
/*
** Sets the visible of the buttons located in the header.
*/
    public function setButtonsVisible ( prev : Boolean , next : Boolean , list : Boolean ) : void
    {
      if ( buttonDrawPrev != null )
      {
        if ( buttonDrawPrev . visible != prev )
        {
          buttonDrawPrev . visible = prev ;
        }
      }
      if ( buttonDrawNext != null )
      {
        if ( buttonDrawNext . visible != next )
        {
          buttonDrawNext . visible = next ;
        }
      }
      if ( buttonDrawList != null )
      {
        if ( buttonDrawList . visible != list )
        {
          buttonDrawList . visible = list ;
        }
      }
    }
/*
** Sets the visible of the buttons located in the header.
*/
    public function setButtonMoveVisible ( move : Boolean ) : void
    {
      if ( buttonDrawMove != null )
      {
        if ( buttonDrawMove . visible != move )
        {
          buttonDrawMove . visible = move ;
        }
      }
    }
/*
** Sets the orientation of a content.
*/
    public function setOrientation ( index : int , o : String ) : void
    {
      contentMultiple . setOrientation ( index , o ) ;
    }
/*
** Navigates on the widgets.
*/
    private function buttonDrawMoveClick ( e : Event ) : void
    {
      buttonDrawMove . setEnabled ( true ) ;
      application . getForeground ( ) . createContentsList ( this ) ;
    }
    private function buttonDrawPrevClick ( e : Event ) : void
    {
      buttonDrawPrev . setEnabled ( true ) ;
      application . getMiddleground ( ) . getWidgets ( ) . goToPrevWidget ( this ) ;
    }
    private function buttonDrawNextClick ( e : Event ) : void
    {
      buttonDrawNext . setEnabled ( true ) ;
      application . getMiddleground ( ) . getWidgets ( ) . goToNextWidget ( this ) ;
    }
    private function buttonDrawListClick ( e : Event ) : void
    {
      buttonDrawList . setEnabled ( true ) ;
      application . getForeground ( ) . createWidgetsList ( ) ;
    }
/*
** The function to be called after doubleClick.
*/
    private function closerDoubleClick ( e : MouseEvent ) : void
    {
      if ( application . getPropsApp ( ) . getWidgetEnableManualClose ( ) )
      {
// The close event to the outside
        getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetCloseMe ) ;
      }
    }
/*
** Gets the size of the content.
*/
    public function getContentsw ( ) : int
    {
      return contentMultiple . getsw ( ) ;
    }
    public function getContentsh ( ) : int
    {
      return contentMultiple . getsh ( ) ;
    }
/*
** Gets the event dispatcher of the content.
*/
    public function getContentBaseEventDispatcher ( ) : BaseEventDispatcher
    {
      return contentMultiple . getBaseEventDispatcher ( ) ;
    }
/*
** The header has to be at visible space all the time.
** If not (the header is too up or too left), then this method
** brings the widget into a place where the header is accessible
** for further repositioning.
*/
    public function safePlace ( ) : void
    {
// If it is too right then bring it left.
      if ( getcx ( ) < application . getPropsApp ( ) . getWidgetsMargin ( ) )
      {
        setcx ( application . getPropsApp ( ) . getWidgetsMargin ( ) ) ;
      }
// If it is too up then bring it down.
      if ( getcy ( ) < application . getPropsApp ( ) . getWidgetsMargin ( ) )
      {
        setcy ( application . getPropsApp ( ) . getWidgetsMargin ( ) ) ;
      }
    }
/*
** When the mouse is up on stage.
*/
    private function stageMouseUp ( e : MouseEvent ) : void
    {
      if ( mouseDownHappened == mouseDownHappenedMover )
      {
        stopDrag ( ) ;
        setcxy ( x , y ) ;
        if ( prevMouseX == parent . mouseX && prevMouseY == parent . mouseY )
        {
          if ( application . getPropsApp ( ) . getWidgetEnableManualHide ( ) )
          {
            setHidden ( ! getHidden ( ) ) ;
          }
        }
        removeEventListener ( Event . ENTER_FRAME , enterFrameCheckMovement ) ;
        getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetDragStop ) ;
      }
      else if ( mouseDownHappened == mouseDownHappenedResizer )
      {
        removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
        if ( mouseX != prevMouseX || mouseY != prevMouseY )
        {
          setswh ( getsw ( ) + mouseX - prevMouseX , getsh ( ) + mouseY - prevMouseY ) ;
        }
        clearResizer ( ) ;
      }
      prevMouseX = 0 ;
      prevMouseY = 0 ;
      safePlace ( ) ;
      mouseDownHappened = "" ;
    }
/*
** The overriding of the set size methods.
** The sizes of the widgets have to be at least the following constants.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( ! application . getPropsApp ( ) . getSmartphoneMode ( ) )
      {
        super . setsw ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) ) ;
      }
      else
      {
        super . setsw ( getswFromParentContent ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( ! getHidden ( ) )
      {
        if ( ! application . getPropsApp ( ) . getSmartphoneMode ( ) )
        {
          super . setsh ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinHeight ( ) , newsh ) ) ;
        }
        else
        {
          super . setsh ( getshFromParentContent ( ) ) ;
        }
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( ! getHidden ( ) )
      {
        if ( ! application . getPropsApp ( ) . getSmartphoneMode ( ) )
        {
          super . setswh ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) , Math . max ( application . getPropsApp ( ) . getWidgetSizeMinHeight ( ) , newsh ) ) ;
        }
        else
        {
          super . setswh ( getswFromParentContent ( ) , getshFromParentContent ( ) ) ;
        }
      }
      else
      {
        if ( ! application . getPropsApp ( ) . getSmartphoneMode ( ) )
        {
          super . setsw ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) ) ;
        }
        else
        {
          super . setsw ( getswFromParentContent ( ) ) ;
        }
      }
    }
/*
** Gets the sizes from the size of stage (more precisely from parent content).
*/
    public function getswFromParentContent ( ) : int
    {
      var w : int = 0 ;
      if ( parent != null )
      {
        if ( parent . parent is ContentSingle )
        {
          w = ContentSingle ( parent . parent ) . getsw ( ) - application . getPropsApp ( ) . getWidgetsMargin ( ) * 2 ;
        }
      }
      return w ;
    }
    public function getshFromParentContent ( ) : int
    {
      var h : int = 0 ;
      if ( parent != null )
      {
        if ( parent . parent is ContentSingle )
        {
          h = ContentSingle ( parent . parent ) . getsh ( ) - application . getPropsApp ( ) . getWidgetsMargin ( ) * 2 ;
        }
      }
      return h ;
    }
/*
** Grabs the widget on the header.
*/
    private function moverMouseDown ( e : MouseEvent ) : void
    {
      mouseDownHappened = mouseDownHappenedMover ;
      prevMouseX = parent . mouseX ;
      prevMouseY = parent . mouseY ;
      startDrag ( ) ;
      toTheHighestDepth ( ) ;
      prevX = x ;
      prevY = y ;
      widgetInMove = false ;
      addEventListener ( Event . ENTER_FRAME , enterFrameCheckMovement ) ;
    }
/*
** The blur effect should be applied when this Widget really moves.
** (In case of hiding-unhiding, the other widgets should not be blured.)
*/
    private function enterFrameCheckMovement ( e : Event ) : void
    {
      if ( prevX != x || prevY != y )
      {
        prevX = x ;
        prevY = y ;
        if ( ! widgetInMove )
        {
          widgetInMove = true ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetDragStart ) ;
        }
      }
    }
/*
** Overrides the setsh method!
** If the content of the widget hides then the height will be reduced!
** (just for displaying, the sh property will beuntouched in case of masking)
*/
    override public function getsh ( ) : int
    {
      if ( getHidden ( ) )
      {
        return textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 4 ;
      }
      else
      {
        return super . getsh ( ) ;
      }
    }
/*
** Grabs the widget on the resizer area.
*/
    private function resizerMouseDown ( e : MouseEvent ) : void
    {
      if ( getcx ( ) < 0 || getcy ( ) < 0 )
      {
        safePlace ( ) ;
      }
      else
      {
        mouseDownHappened = mouseDownHappenedResizer ;
        prevMouseX = mouseX ;
        prevMouseY = mouseY ;
        addEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
      }
    }
/*
** Updates the resizer to see the new size of the widget.
** Not needed to register into the line thickness changing.
*/
    private function enterFrameUpdateResizer ( e : Event ) : void
    {
      if ( resizer != null )
      {
        resizer . graphics . clear ( ) ;
        resizer . graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getWidgetResizeMargin ( ) , - application . getPropsApp ( ) . getWidgetResizeMargin ( ) , getsw ( ) + mouseX - prevMouseX + 2 * application . getPropsApp ( ) . getWidgetResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) , getsh ( ) + mouseY - prevMouseY + 2 * application . getPropsApp ( ) . getWidgetResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      }
    }
/*
** Hides or unhides the content of the widget.
*/
    public function setHidden ( hidden : Boolean ) : void
    {
      if ( mask == null )
      {
        if ( hidden )
        {
          mask = backLabel ;
          textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
        }
      }
      else
      {
        if ( ! hidden )
        {
          mask = null ;
          textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
        }
      }
      dispatchEventSizesChanged ( ) ;
    }
/*
** Gets the hidden property of this widget
*/
    public function getHidden ( ) : Boolean
    {
      return mask != null ;
    }
/*
** Sets the default content.
*/
    public function setDefaultContent ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setDefaultContent ( ) ;
      }
    }
/*
** Adds a content and returns the index of the content.
** Unique elements can be added as the labels of the buttons.
*/
    public function addContent ( label : String ) : int
    {
      return contentMultiple . addContent ( label ) ;
    }
/*
** Removes a content.
*/
    public function removeContent ( i : int ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . removeContent ( i ) ;
      }
    }
/*
** Sets the active index.
*/
    public function setActiveContent ( index : int ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setActiveIndex ( index ) ;
      }
    }
/*
** Sets the visible of the button bar.
** (If it is not visible then the contents will be resized!)
*/
    public function setButtonBarVisible ( v : Boolean ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setButtonBarVisible ( v ) ;
      }
    }
/*
** Adds an element to the content sprite.
*/
    public function addToContent ( index : int , displayObject : DisplayObject , normal : Boolean , cellIndex : int ) : void
    {
      contentMultiple . addToContent ( index , displayObject , normal , cellIndex ) ;
    }
/*
** To remove an element from the contentMultiple of this widget.
*/
    public function removeFromContent ( index : int , displayObject : DisplayObject ) : void
    {
      contentMultiple . removeFromContent ( index , displayObject ) ;
    }
/*
** Sets and gets the max elementsArray of the line or column in the content.
*/
    public function setElementsFix ( index : int , es : int ) : void
    {
      contentMultiple . setElementsFix ( index , es ) ;
    }
    public function getElementsFix ( index : int ) : int
    {
      return contentMultiple . getElementsFix ( index ) ;
    }
/*
** What is the height of the buttonbar.
*/
    public function getButtonBarcysh ( ) : int
    {
      return contentMultiple . getButtonBarcysh ( ) ;
    }
/*
** In case of resizing the drawed buttons, the elements have to be resized and repositioned.
*/
    private function buttonDrawResized ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      resizeElements ( ) ;
    }
/*
** In case of resizing the label, the elements have to be resized and repositioned.
*/
    private function textLabelResized ( e : Event ) : void
    {
// So, we have to redraw the color shape.
      resizeElements ( ) ;
    }
/*
** Sets the id ot fhe widget.
** (Not changable later.)
*/
    public function setWidgetId ( id : int ) : void
    {
      if ( widgetId == - 1 )
      {
        widgetId = id ;
      }
    }
/*
** Gets the id of the widget.
*/
    public function getWidgetId ( ) : int
    {
      return widgetId ;
    }
/*
** Sets the header ot fhe widget.
** (Not changable later.)
*/
    public function setWidgetHeaderCode ( header : String ) : void
    {
      if ( widgetHeader == null )
      {
        widgetHeader = header ;
        textLabel . setTextCode ( header ) ;
        resizeCloser ( ) ;
      }
    }
/*
** Gets the header of the widget.
*/
    public function getWidgetHeader ( ) : String
    {
      return widgetHeader ;
    }
/*
** Sets the type ot fhe widget.
** (Not changable later.)
*/
    public function setWidgetType ( type : String ) : void
    {
      if ( widgetType == null )
      {
        widgetType = type ;
      }
    }
/*
** Gets the type ot fhe widget.
*/
    public function getWidgetType ( ) : String
    {
      return widgetType ;
    }
/*
** This is the method runs after the changing of the size of this object.
** If this has happened then the
*/
    override protected function doSizeChanged ( ) : void
    {
// So we have to redraw.
      resizeElements ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
// So we have to redraw.
      resizeElements ( ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to redraw.
      resizeElements ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundBgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      resizeElements ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      resizeElements ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to redraw the header.
      resizeElements ( ) ;
    }
/*
** Clears just the resizer.
** super . getsh! this is the way to work properly in hidden state.
*/
    private function clearResizer ( ) : void
    {
      if ( resizer != null )
      {
        resizer . graphics . clear ( ) ;
        resizer . graphics . beginFill ( 0 , 0 ) ;
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getWidgetResizeMargin ( ) , - application . getPropsApp ( ) . getWidgetResizeMargin ( ) , getsw ( ) + 2 * application . getPropsApp ( ) . getWidgetResizeMargin ( ) , super . getsh ( ) + 2 * application . getPropsApp ( ) . getWidgetResizeMargin ( ) ) ;
        resizer . graphics . endFill ( ) ;
        resizer . setcxy ( 0 , 0 ) ;
        resizer . setswh ( getsw ( ) , super . getsh ( ) ) ;
        if ( parent != null )
        {
          if ( parent . parent is ContentSingle )
          {
            if ( ContentSingle ( parent . parent ) . getBaseScroll ( ) != null )
            {
              ContentSingle ( parent . parent ) . getBaseScroll ( ) . doRollOver ( ) ;
            }
          }
        }
      }
    }
/*
** Resizes only the background.
*/
    private function resizeBackground ( ) : void
    {
      baseShape . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) / 4 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
      baseShape . x = 0 ;
      baseShape . y = 0 ;
      baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
      baseShape . setswh ( getsw ( ) , super . getsh ( ) ) ;
      baseShape . drawRect ( ) ;
    }
/*
** Resizing the closer.
*/
    private function resizeCloser ( ) : void
    {
      closer . graphics . clear ( ) ;
      closer . graphics . beginFill ( 0 , 0 ) ;
      closer . graphics . drawRoundRect ( 0 , 0 , textLabel . textWidth , textLabel . getsh ( ) , application . getPropsDyn ( ) . getAppRadius1 ( ) , application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
      closer . graphics . endFill ( ) ;
      closer . setcxy ( textLabel . getcx ( ) , textLabel . getcy ( ) ) ;
      closer . setswh ( textLabel . textWidth , textLabel . getsh ( ) ) ;
    }
/*
** This is the method should be run after the size changing or changing of
** any of the properties we registered before.
** super . getsh! this is the way to work properly in hidden state.
*/
    private function resizeElements ( ) : void
    {
      if ( application != null )
      {
// Background!
        resizeBackground ( ) ;
// The resizer.
        clearResizer ( ) ;
// The label.
        textLabel . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) * 2 , application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
        textLabel . setMaxWidth ( getsw ( ) - textLabel . getsh ( ) * 3 - application . getPropsDyn ( ) . getAppMargin ( ) * 2 * 2 , false ) ;
        backLabel . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) / 2 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        backLabel . x = application . getPropsDyn ( ) . getAppMargin ( ) ;
        backLabel . y = application . getPropsDyn ( ) . getAppMargin ( ) ;
        backLabel . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        backLabel . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
        backLabel . drawRect ( ) ;
// The closer after the header label.
        resizeCloser ( ) ;
// And the mover.
        mover . graphics . clear ( ) ;
        mover . graphics . beginFill ( 0 , 0 ) ;
        mover . graphics . drawRoundRect ( 0 , 0 , getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 , application . getPropsDyn ( ) . getAppRadius1 ( ) , application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        mover . graphics . endFill ( ) ;
        mover . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        mover . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
// The widget list , prev, next buttons have to be repositioned.
        buttonDrawMove . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 - buttonDrawPrev . getsw ( ) - buttonDrawNext . getsw ( ) - buttonDrawList . getsw ( ) , textLabel . getcy ( ) ) ;
        buttonDrawPrev . setcxy ( buttonDrawMove . getcxsw ( ) , ( backLabel . getsh ( ) - buttonDrawPrev . getsh ( ) * 2 ) / 2 + backLabel . y ) ;
        buttonDrawNext . setcxy ( buttonDrawPrev . getcx ( ) , buttonDrawPrev . getcysh ( ) ) ;
        buttonDrawList . setcxy ( buttonDrawPrev . getcxsw ( ) , textLabel . getcy ( ) ) ;
// And the contentMultiple.
        contentMultiple . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 4 ) ;
        contentMultiple . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , super . getsh ( ) - textLabel . getsh ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 5 ) ;
      }
    }
/*
** Override these as necessary.
*/
    protected function onCreate ( ) : void { }
    public function onClose ( ) : Boolean
    {
      return true ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( resizer != null )
      {
        resizer . removeEventListener ( MouseEvent . MOUSE_DOWN , resizerMouseDown ) ;
      }
      mover . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      closer . removeEventListener ( MouseEvent . DOUBLE_CLICK , closerDoubleClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , backgroundBgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , fillAlphaChanged ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      removeEventListener ( Event . ENTER_FRAME , enterFrameCheckMovement ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventWidgetCloseMe != null )
      {
        eventWidgetCloseMe . stopImmediatePropagation ( ) ;
      }
      if ( eventWidgetDragStart != null )
      {
        eventWidgetDragStart . stopImmediatePropagation ( ) ;
      }
      if ( eventWidgetDragStop != null )
      {
        eventWidgetDragStop . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      widgetId = 0 ;
      widgetHeader = null ;
      widgetType = null ;
      baseShape = null ;
      backLabel = null ;
      textLabel = null ;
      mover = null ;
      closer = null ;
      resizer = null ;
      contentMultiple = null ;
      prevMouseX = 0 ;
      prevMouseY = 0 ;
      mouseDownHappened = null ;
      eventWidgetCloseMe = null ;
      eventWidgetDragStart = null ;
      eventWidgetDragStop = null ;
      prevX = 0 ;
      prevY = 0 ;
      widgetInMove = false ;
      buttonDrawMove = null ;
      buttonDrawPrev = null ;
      buttonDrawNext = null ;
      buttonDrawList = null ;
      contentId = 0 ;
    }
  }
}