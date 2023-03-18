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
** Widget.
** This object will be the replacement of a usual window.
**
** MAIN FEATURES:
** - can be:
**   - added to the content of the Widgets (implemented in Widgets class)
**   - repositioned (implemented in Widgets class)
**   - closed and removed from the content of the widgets (implemented in Widgets clas)
**   - resized
**   - minimized (content hide, only the header is visible)
** - new widgets should extend this
** - can have an id and a type and these can be set once.
** - an info content can be displayed to help users.
** - desktop and mobile displaying can be set.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . Widgets ;
  import com . kisscodesystems . KissAs3Fw . base . BaseAlerter ;
  import com . kisscodesystems . KissAs3Fw . base . BaseEventDispatcher ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class Widget extends BaseAlerter
  {
// To insert a tab to a specific TextValue values
    protected const tab : String = "  " ;
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
// The resizer of this widget.
    private var resizer : BaseSprite = null ;
// And the contentMultiple of this widget.
    private var contentMultiple : ContentMultiple = null ;
// To be able to determine: the widget is moved or resized or none of these.
    private var prevMouseX : int = 0 ;
    private var prevMouseY : int = 0 ;
// The mouse down has happened in..
    private var mouseDownHappened : String = null ;
// The event of closing this widget.
    private var eventWidgetCloseMe : Event = null ;
// The events of dragging and dropping this widget.
    private var eventWidgetDragStart : Event = null ;
    private var eventWidgetDragStop : Event = null ;
// Gonna be closed.
    private var eventWidgetClosed : Event = null ;
// The movement of the widget is controlled.
    private var prevX : Number = 0 ;
    private var prevY : Number = 0 ;
    private var widgetInMove : Boolean = false ;
// The buttons of the navigation.
    private var buttonLinkInfo : ButtonLink = null ;
    private var buttonLinkMove : ButtonLink = null ;
    private var buttonLinkPrev : ButtonLink = null ;
    private var buttonLinkNext : ButtonLink = null ;
    private var buttonLinkList : ButtonLink = null ;
    private var buttonLinkMima : ButtonLink = null ;
    private var buttonLinkClos : ButtonLink = null ;
// The info content of this widget can be displayed.
    private var hintTextBox : TextBox = null ;
// The id of the content.
    private var contentId : int = 0 ;
// The possibility of moving the widget.
    private var buttonMoveEventPossible : Boolean = true ;
// The possibility of closing the widget.
    private var buttonClosEventPossible : Boolean = true ;
// The text label to inform the user, for example while loading something into the widget.
    private var infoTextLabel : TextLabel = null ;
// The sizes of the initialized widget, these should be set in every extender Widget.
// These should be defined as the font size would be 16.
// If this is not, then the initialization size will be changed depending on the actual font size.
    protected var iniSizeWidth : int = 543 ;
    protected var iniSizeHeight : int = 432 ;
// It is necessary to save the currently (or lastly) mode to display.
    protected var widgetMode : String = "" ;
// This can be modified is necessary, for example after loading some data.
    protected var loaded : Boolean = false ;
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
      mover = new BaseSprite ( application ) ;
      addChild ( mover ) ;
      mover . addEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      mover . mouseDownForScrollingEnabled = false ;
// info buttonlink
      buttonLinkInfo = new ButtonLink ( application ) ;
      addChild ( buttonLinkInfo ) ;
      buttonLinkInfo . setIcon ( "info" ) ;
      buttonLinkInfo . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkInfoClick ) ;
      buttonLinkInfo . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
// The widget navigator buttons.
      buttonLinkMove = new ButtonLink ( application ) ;
      addChild ( buttonLinkMove ) ;
      buttonLinkMove . setIcon ( "downarrow" ) ;
      buttonLinkMove . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkMoveClick ) ;
      buttonLinkMove . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
      buttonLinkPrev = new ButtonLink ( application ) ;
      addChild ( buttonLinkPrev ) ;
      buttonLinkPrev . setIcon ( "leftarrow" ) ;
      buttonLinkPrev . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkPrevClick ) ;
      buttonLinkPrev . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
      buttonLinkNext = new ButtonLink ( application ) ;
      addChild ( buttonLinkNext ) ;
      buttonLinkNext . setIcon ( "rightarrow" ) ;
      buttonLinkNext . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkNextClick ) ;
      buttonLinkNext . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
      buttonLinkList = new ButtonLink ( application ) ;
      addChild ( buttonLinkList ) ;
      buttonLinkList . setIcon ( "settings" ) ;
      buttonLinkList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkListClick ) ;
      buttonLinkList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
      buttonLinkMima = new ButtonLink ( application ) ;
      addChild ( buttonLinkMima ) ;
      buttonLinkMima . setIcon ( "minimize" ) ;
      buttonLinkMima . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkMimaClick ) ;
      buttonLinkMima . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
      if ( ! application . getPropsApp ( ) . getWidgetEnableManualHide ( ) )
      {
        buttonLinkMima . setSpriteVisible ( false ) ;
      }
      buttonLinkClos = new ButtonLink ( application ) ;
      addChild ( buttonLinkClos ) ;
      buttonLinkClos . setIcon ( "close" ) ;
      buttonLinkClos . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkClosClick ) ;
      buttonLinkClos . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonLinkResized ) ;
// Registering onto these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , backgroundDarkColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , backgroundMidColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , backgroundBrightColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , fillAlphaChanged ) ;
// The event of closing itself or drag start or drag stop.
      eventWidgetCloseMe = new Event ( application . EVENT_WIDGET_CLOSE_ME ) ;
      eventWidgetDragStart = new Event ( application . EVENT_WIDGET_DRAG_START ) ;
      eventWidgetDragStop = new Event ( application . EVENT_WIDGET_DRAG_STOP ) ;
      eventWidgetClosed = new Event ( application . EVENT_WIDGET_CLOSED ) ;
// Tell to the base event dispatcher the reference.
      setEventDispatcherObjectToThis ( ) ;
// A standard size will be set.
      setswh ( application . getPropsApp ( ) . getWidgetSizeStandardWidth ( ) , application . getPropsApp ( ) . getWidgetSizeStandardHeight ( ) ) ;
// Hidden by default
      buttonLinkInfo . setSpriteVisible ( false ) ;
    }
/*
** Sets the info content. This is a hint to the user how to use this widget.
*/
    public function setInfoContent ( tc : String , html : Boolean = false ) : void
    {
      if ( hintTextBox == null )
      {
        hintTextBox = new TextBox ( application ) ;
        addChild ( hintTextBox ) ;
        hintTextBox . setWordWrap ( true ) ;
        resizeHintTextBox ( ) ;
      }
      if ( contentMultiple != null )
      {
        contentMultiple . visible = true ;
        hintTextBox . visible = false ;
      }
      if ( buttonLinkInfo != null )
      {
        buttonLinkInfo . setSpriteVisible ( true ) ;
      }
      hintTextBox . setHtml ( html ) ;
      hintTextBox . setTextCode ( tc ) ;
    }
    public function clearInfoContent ( ) : void
    {
      if ( hintTextBox != null )
      {
        removeChild ( hintTextBox ) ;
        hintTextBox = null ;
      }
      if ( buttonLinkInfo != null )
      {
        buttonLinkInfo . setSpriteVisible ( false ) ;
      }
      if ( contentMultiple != null )
      {
        contentMultiple . visible = true ;
      }
    }
/*
 ** An information can be displayed using these methods.
 ** The information text will be displayed on the top level, not inside the widget.
*/
    protected function setInfoTextLabel ( t : String ) : void
    {
      if ( infoTextLabel == null )
      {
        infoTextLabel = new TextLabel ( application ) ;
        addChild ( infoTextLabel ) ;
        infoTextLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
        infoTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , infoTextLabelSizeChanged ) ;
      }
      infoTextLabel . setTextCode ( t ) ;
    }
    private function infoTextLabelSizeChanged ( e : Event ) : void
    {
      reposInfoTextLabel ( ) ;
    }
    protected function removeInfoTextLabel ( ) : void
    {
      if ( infoTextLabel != null )
      {
        removeChild ( infoTextLabel ) ;
        infoTextLabel = null ;
      }
    }
    private function reposInfoTextLabel ( ) : void
    {
      if ( infoTextLabel != null )
      {
        infoTextLabel . setcxy ( ( getsw ( ) - infoTextLabel . getsw ( ) ) / 2 , ( getsh ( ) - infoTextLabel . getsh ( ) ) / 2 ) ;
      }
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
// The actual sizes depend on the actual font size.
      setIniSizes ( ) ;
    }
/*
** This calculates the actual sizes, but to be failsafe, this has to be callable from outside.
*/
    public function setIniSizes ( ) : void
    {
      var iniSizeWidthModified : int = 0 ;
      var iniSizeHeightModified : int = 0 ;
      var factor : Number = application . getPropsApp ( ) . getWidgetSizeFromFontSizeFactor ( ) ;
      var origFontSize : int = 16 ;
      var currFontSize : int = 0 ;
      if ( application . getPropsDyn ( ) . getAppFontSize ( ) == 0 )
      {
        currFontSize = application . calcFontSizeFromStageSize ( ) ;
      }
      else
      {
        currFontSize = application . getPropsDyn ( ) . getAppFontSize ( ) ;
      }
      iniSizeWidthModified = currFontSize / origFontSize * factor * iniSizeWidth ;
      iniSizeHeightModified = currFontSize / origFontSize * factor * iniSizeHeight ;
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
// Sets to the initialized size.
        super . setswh ( iniSizeWidthModified , iniSizeHeightModified ) ;
// And, also saved to the container.
        application . getMiddleground ( ) . getWidgets ( ) . saveWidgetSizes ( this , iniSizeWidthModified , iniSizeHeightModified ) ;
      }
      else
      {
        super . setswh ( iniSizeWidth , iniSizeHeight ) ;
        application . getMiddleground ( ) . getWidgets ( ) . saveWidgetSizes ( this , iniSizeWidth , iniSizeHeight ) ;
      }
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
      if ( buttonLinkPrev != null )
      {
        buttonLinkPrev . setSpriteVisible ( prev ) ;
      }
      if ( buttonLinkNext != null )
      {
        buttonLinkNext . setSpriteVisible ( next ) ;
      }
      if ( buttonLinkList != null )
      {
        buttonLinkList . setSpriteVisible ( list ) ;
      }
    }
/*
** Sets the visible of the buttons located in the header.
*/
    public function setButtonMoveVisible ( move : Boolean ) : void
    {
      if ( buttonLinkMove != null )
      {
        if ( ( move && buttonMoveEventPossible ) || ! move )
        {
          buttonLinkMove . setSpriteVisible ( move ) ;
        }
      }
    }
/*
** Sets the visible of the buttons located in the header.
*/
    public function setButtonClosVisible ( clos : Boolean ) : void
    {
      if ( buttonLinkClos != null )
      {
        if ( ( clos && buttonClosEventPossible ) || ! clos )
        {
          buttonLinkClos . setSpriteVisible ( clos ) ;
        }
      }
    }
/*
** Sets the button moving action disabled or enabled.
*/
    public function setButtonMoveEventPossible ( p : Boolean ) : void
    {
      buttonMoveEventPossible = p ;
      if ( ! buttonMoveEventPossible )
      {
        setButtonMoveVisible ( p ) ;
      }
    }
/*
** Sets the button moving action disabled or enabled.
*/
    public function setButtonClosEventPossible ( p : Boolean ) : void
    {
      buttonClosEventPossible = p ;
      if ( ! buttonClosEventPossible )
      {
        setButtonClosVisible ( p ) ;
      }
    }
/*
** To be able to set the coordinates of the content!
*/
    public function setccx ( index , newccx : int ) : void
    {
      contentMultiple . setccx ( index , newccx ) ;
    }
    public function setccy ( index , newccy : int ) : void
    {
      contentMultiple . setccy ( index , newccy ) ;
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
    private function buttonLinkInfoClick ( e : Event ) : void
    {
      if ( contentMultiple != null && hintTextBox != null )
      {
        if ( contentMultiple . visible )
        {
          contentMultiple . visible = false ;
          hintTextBox . visible = true ;
          if ( getHidden ( ) )
          {
            buttonLinkMimaClick ( null ) ;
          }
        }
        else
        {
          contentMultiple . visible = true ;
          hintTextBox . visible = false ;
        }
        if ( infoTextLabel != null )
        {
          infoTextLabel . visible = contentMultiple . visible ;
        }
      }
    }
    private function buttonLinkMoveClick ( e : Event ) : void
    {
      application . getForeground ( ) . createContentsList ( this ) ;
    }
    private function buttonLinkPrevClick ( e : Event ) : void
    {
      application . getMiddleground ( ) . getWidgets ( ) . goToPrevWidget ( this ) ;
    }
    private function buttonLinkNextClick ( e : Event ) : void
    {
      application . getMiddleground ( ) . getWidgets ( ) . goToNextWidget ( this ) ;
    }
    private function buttonLinkListClick ( e : Event ) : void
    {
      application . getForeground ( ) . createWidgetsList ( ) ;
    }
    private function buttonLinkMimaClick ( e : Event ) : void
    {
      if ( application . getPropsApp ( ) . getWidgetEnableManualHide ( ) )
      {
        setHidden ( ! getHidden ( ) ) ;
        buttonLinkMima . setIcon ( getHidden ( ) ? "maximize" : "minimize" ) ;
      }
    }
    protected function buttonLinkClosClick ( e : Event = null ) : void
    {
      if ( application . getPropsApp ( ) . getWidgetEnableManualClose ( ) )
      {
// The close event to the outside
        getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetCloseMe ) ;
      }
    }
/*
** Gets the position and size of the content.
*/
    public function getContentcx ( ) : int
    {
      return contentMultiple . getcx ( ) ;
    }
    public function getContentcy ( ) : int
    {
      return contentMultiple . getcy ( ) ;
    }
    public function getContentsw ( ) : int
    {
      return contentMultiple . getContentsw ( ) ;
    }
    public function getContentsh ( ) : int
    {
      return contentMultiple . getContentsh ( ) ;
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
      var safePos : int = 0 ;
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        safePos = application . getPropsApp ( ) . getWidgetsMargin ( ) ;
      }
// If it is too right then bring it left.
      if ( getcx ( ) < safePos )
      {
        setcx ( safePos ) ;
      }
// If it is too up then bring it down.
      if ( getcy ( ) < safePos )
      {
        setcy ( safePos ) ;
      }
    }
/*
** When the mouse is up on stage.
*/
    private function stageMouseUp ( e : MouseEvent ) : void
    {
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        if ( mouseDownHappened == mouseDownHappenedMover )
        {
          stopDrag ( ) ;
          setcxy ( x , y ) ;
          removeEventListener ( Event . ENTER_FRAME , enterFrameCheckMovement ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetDragStop ) ;
        }
        else if ( mouseDownHappened == mouseDownHappenedResizer )
        {
          removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
          if ( mouseX != prevMouseX || mouseY != prevMouseY )
          {
            setswh ( getsw ( ) + mouseX - prevMouseX , getsh ( ) + mouseY - prevMouseY ) ;
            application . getMiddleground ( ) . getWidgets ( ) . saveWidgetSizes ( this , getsw ( ) , getsh ( ) ) ;
          }
          clearResizer ( ) ;
        }
        safePlace ( ) ;
      }
      prevMouseX = 0 ;
      prevMouseY = 0 ;
      mouseDownHappened = "" ;
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** The overriding of the set size methods.
** The sizes of the widgets have to be at least the following constants.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
      {
        super . setsw ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( ! getHidden ( ) )
      {
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          super . setsh ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinHeight ( ) , newsh ) ) ;
        }
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( ! getHidden ( ) )
      {
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          super . setswh ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) , Math . max ( application . getPropsApp ( ) . getWidgetSizeMinHeight ( ) , newsh ) ) ;
        }
      }
      else
      {
        if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
        {
          super . setsw ( Math . max ( application . getPropsApp ( ) . getWidgetSizeMinWidth ( ) , newsw ) ) ;
        }
      }
    }
/*
** These methods will switch the sizes between desktop and mobile mode.
*/
    public function setDesktopSizes ( ) : void
    {
      super . setswh ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetSavedWidth ( this ) , application . getMiddleground ( ) . getWidgets ( ) . getWidgetSavedHeight ( this ) ) ;
      if ( application . getPropsApp ( ) . getWidgetEnableManualHide ( ) )
      {
        buttonLinkMima . setSpriteVisible ( true ) ;
      }
    }
    public function setMobileSizes ( ) : void
    {
      setHidden ( false ) ;
      if ( application . getPropsApp ( ) . getWidgetEnableManualHide ( ) )
      {
        buttonLinkMima . setSpriteVisible ( false ) ;
      }
      super . setswh ( getswFromParentContent ( ) , getshFromParentContent ( ) ) ;
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
          if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
          {
            w = ContentSingle ( parent . parent ) . getsw ( ) - application . getPropsApp ( ) . getWidgetsMargin ( ) * 2 ;
          }
          else
          {
            w = ContentSingle ( parent . parent ) . getsw ( ) ;
          }
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
          if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
          {
            h = ContentSingle ( parent . parent ) . getsh ( ) - application . getPropsApp ( ) . getWidgetsMargin ( ) * 2 ;
          }
          else
          {
            h = ContentSingle ( parent . parent ) . getsh ( ) ;
          }
        }
      }
      return h ;
    }
/*
** Grabs the widget on the header.
*/
    private function moverMouseDown ( e : MouseEvent ) : void
    {
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
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
    }
/*
** To get the index of the active tab (content multiple)
*/
    public function getActiveIndex ( ) : int
    {
      if ( contentMultiple != null )
      {
        return contentMultiple . getActiveIndex ( ) ;
      }
      return 0 ;
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
      if ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) )
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
        resizer . graphics . lineStyle ( application . getPropsDyn ( ) . getAppLineThickness ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsApp ( ) . getLineAlpha ( ) , application . getPropsApp ( ) . getPixelHinting ( ) ) ;
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getResizeMargin ( ) , - application . getPropsApp ( ) . getResizeMargin ( ) , getsw ( ) + mouseX - prevMouseX + 2 * application . getPropsApp ( ) . getResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) , getsh ( ) + mouseY - prevMouseY + 2 * application . getPropsApp ( ) . getResizeMargin ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
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
          dispatchEventSizesChanged ( ) ;
        }
      }
      else
      {
        if ( ! hidden )
        {
          mask = null ;
          textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
          dispatchEventSizesChanged ( ) ;
        }
      }
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
    public function addContent ( label : String , it : String = "" ) : int
    {
      return contentMultiple . addContent ( label , it ) ;
    }
/*
** Sets the icon of a tab.
*/
    public function destIcon ( index : int ) : void
    {
      contentMultiple . destIcon ( index ) ;
    }
    public function setIcon ( index : int , it : String ) : void
    {
      contentMultiple . setIcon ( index , it ) ;
    }
    public function setIconIfNotActive ( index : int , it : String ) : void
    {
      contentMultiple . setIconIfNotActive ( index , it ) ;
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
** Changes a cell index only.
*/
    public function changeCellIndex ( index : int , displayObject : DisplayObject , cellIndex : int ) : void
    {
      contentMultiple . changeCellIndex ( index , displayObject , cellIndex ) ;
    }
/*
** Returns the cell index of an element.
*/
    public function getCellIndex ( index : int , displayObject : DisplayObject ) : int
    {
      return contentMultiple . getCellIndex ( index , displayObject ) ;
    }
/*
** Adds an element to the content sprite.
*/
    public function addToContent ( index : int , displayObject : DisplayObject , cellIndex : int , sizeConsider : Boolean = true , to0 : Boolean = false ) : void
    {
      contentMultiple . addToContent ( index , displayObject , cellIndex , sizeConsider , to0 ) ;
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
** In case of resizing the drawn buttons, the elements have to be resized and repositioned.
*/
    private function buttonLinkResized ( e : Event ) : void
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
    public function setWidgetHeaderIcon ( icon : String ) : void
    {
      if ( textLabel != null )
      {
        textLabel . setIcon ( icon ) ;
      }
    }
/*
** Sets the header ot fhe widget.
** (Not changable later.)
*/
    public function setWidgetHeaderCode ( header : String ) : void
    {
      if ( widgetHeader == null )
      {
        changeWidgetHeaderCode ( header ) ;
      }
    }
/*
** The same as above but this is available in extender classes.
*/
    protected function changeWidgetHeaderCode ( header : String ) : void
    {
      widgetHeader = header ;
      textLabel . setTextCode ( header ) ;
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
// The info text (if existing) also has to be repositioned.
      reposInfoTextLabel ( ) ;
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
** The margin of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
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
    private function backgroundDarkColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      resizeElements ( ) ;
    }
/*
** The filler color 2 (background) of the background has been changed.
*/
    private function backgroundMidColorChanged ( e : Event ) : void
    {
// So, we have to redraw.
      resizeElements ( ) ;
    }
/*
** The filler color (foreground) of the background has been changed.
*/
    private function backgroundBrightColorChanged ( e : Event ) : void
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
        resizer . graphics . drawRect ( - application . getPropsApp ( ) . getResizeMargin ( ) , - application . getPropsApp ( ) . getResizeMargin ( ) , getsw ( ) + 2 * application . getPropsApp ( ) . getResizeMargin ( ) , super . getsh ( ) + 2 * application . getPropsApp ( ) . getResizeMargin ( ) ) ;
        resizer . graphics . endFill ( ) ;
        resizer . setcxy ( 0 , 0 ) ;
        resizer . setswh ( super . getsw ( ) , super . getsh ( ) ) ;
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
      baseShape . setcccac ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) , application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) / 4 , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
      baseShape . x = 0 ;
      baseShape . y = 0 ;
      baseShape . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
      baseShape . setswh ( getsw ( ) , super . getsh ( ) ) ;
      baseShape . drawRect ( ) ;
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
// The info icon first.
        buttonLinkInfo . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
// The label.
        textLabel . setcxy ( ( buttonLinkInfo . getsw ( ) == 0 ? application . getPropsDyn ( ) . getAppPadding ( ) : buttonLinkInfo . getsw ( ) ) + application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        textLabel . setMaxWidth ( getsw ( ) - textLabel . getcx ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) , false ) ;
        backLabel . setcccac ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) , application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) / 2 , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
        backLabel . x = application . getPropsDyn ( ) . getAppMargin ( ) ;
        backLabel . y = application . getPropsDyn ( ) . getAppMargin ( ) ;
        backLabel . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        backLabel . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 ) ;
        backLabel . drawRect ( ) ;
// And the mover.
        mover . graphics . clear ( ) ;
        mover . graphics . beginFill ( 0 , 0 ) ;
        mover . graphics . drawRoundRect ( 0 , 0 , getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 , application . getPropsDyn ( ) . getAppRadius ( ) , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        mover . graphics . endFill ( ) ;
        mover . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        mover . setswh ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) * 2 , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 ) ;
// The widget list , prev, next buttons have to be repositioned.
        var currx : int = getsw ( ) - textLabel . getsh ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ;
        if ( buttonLinkClos . visible )
        {
          buttonLinkClos . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkClos . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkClos . getsw ( ) ;
        }
        if ( buttonLinkMima . visible )
        {
          buttonLinkMima . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkMima . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkMima . getsw ( ) ;
        }
        if ( buttonLinkList . visible )
        {
          buttonLinkList . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkList . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkList . getsw ( ) ;
        }
        if ( buttonLinkNext . visible )
        {
          buttonLinkNext . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkNext . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkNext . getsw ( ) ;
        }
        if ( buttonLinkPrev . visible )
        {
          buttonLinkPrev . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkPrev . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkPrev . getsw ( ) ;
        }
        if ( buttonLinkMove . visible )
        {
          buttonLinkMove . setcxy ( currx , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textLabel . setMaxWidth ( buttonLinkMove . getcx ( ) - textLabel . getcx ( ) , false ) ;
          currx -= buttonLinkMove . getsw ( ) ;
        }
// And the contentMultiple.
        contentMultiple . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , textLabel . getsh ( ) + application . getPropsDyn ( ) . getAppPadding ( ) * 2 + application . getPropsDyn ( ) . getAppMargin ( ) * 2 ) ;
        contentMultiple . setswh ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , super . getsh ( ) - contentMultiple . getcy ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) ;
// similar to the above: info content
        resizeHintTextBox ( ) ;
      }
    }
/*
** Resizes the hint text box only (if any)
*/
    private function resizeHintTextBox ( ) : void
    {
      if ( hintTextBox != null && contentMultiple != null )
      {
        hintTextBox . setcxy ( contentMultiple . getcx ( ) , contentMultiple . getcy ( ) ) ;
        hintTextBox . setswh ( contentMultiple . getsw ( ) , contentMultiple . getsh ( ) ) ;
      }
    }
/*
** The widget will be closed.
*/
    protected function dispatchClosedEvent ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && eventWidgetClosed != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventWidgetClosed ) ;
      }
    }
/*
** Override these as necessary.
*/
    protected function onCreate ( ) : void { }
    public function onClose ( ) : Boolean
    {
      dispatchClosedEvent ( ) ;
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
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , backgroundDarkColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , backgroundMidColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , backgroundBrightColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , fillAlphaChanged ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
      removeEventListener ( Event . ENTER_FRAME , enterFrameCheckMovement ) ;
      removeEventListener ( Event . ENTER_FRAME , enterFrameUpdateResizer ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventWidgetDragStart != null )
      {
        eventWidgetDragStart . stopImmediatePropagation ( ) ;
      }
      if ( eventWidgetDragStop != null )
      {
        eventWidgetDragStop . stopImmediatePropagation ( ) ;
      }
      if ( eventWidgetClosed != null )
      {
        eventWidgetClosed . stopImmediatePropagation ( ) ;
      }
      if ( eventWidgetCloseMe != null )
      {
        eventWidgetCloseMe . stopImmediatePropagation ( ) ;
      }
// 4: every reference and value should be resetted to null, 0 or false.
      widgetId = 0 ;
      widgetHeader = null ;
      widgetType = null ;
      baseShape = null ;
      backLabel = null ;
      textLabel = null ;
      mover = null ;
      resizer = null ;
      contentMultiple = null ;
      prevMouseX = 0 ;
      prevMouseY = 0 ;
      mouseDownHappened = null ;
      eventWidgetCloseMe = null ;
      eventWidgetDragStart = null ;
      eventWidgetDragStop = null ;
      eventWidgetClosed = null ;
      prevX = 0 ;
      prevY = 0 ;
      widgetInMove = false ;
      buttonLinkInfo = null ;
      buttonLinkMove = null ;
      buttonLinkPrev = null ;
      buttonLinkNext = null ;
      buttonLinkList = null ;
      buttonLinkClos = null ;
      contentId = 0 ;
      infoTextLabel = null ;
      hintTextBox = null ;
      iniSizeWidth = 0 ;
      iniSizeHeight = 0 ;
    }
  }
}
