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
** ListPanel.
** The class of the selectable list object.
** Texts and its value representation can be set.
**
** MAIN FEATURES:
** - labels and values can be specified separately
** - multiple selection is possible
** - it can be empty or not (as specified)
** - number of displayable elements can be set
** - the already selected indexes can be specified
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseList ;
  import com . kisscodesystems . KissAs3Fw . base . BaseScroll ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class ListPanel extends BaseSprite
  {
// This will be the type of the text using in the list.
    private var textType : String = null ;
// The content of the Content.
    private var baseList : BaseList = null ;
// The scroll of the Content.
    private var baseScroll : BaseScroll = null ;
// The displayable texts and the values are here.
    private var arrayLabels : Array = null ;
    private var arrayValues : Array = null ;
    private var arrayIcons : Array = null ;
// Multiple or not
    private var multiple : Boolean = false ;
// The index to start the displaying from.
    private var startIndex : int = - 1 ;
// The array of the selected items.
    private var selectedIndexes : Array = null ;
// The original mouse x and y corrdinates (mouse down event)
    private var origMouseX : int = 0 ;
    private var origMouseY : int = 0 ;
// The event of the changing of the selected items.
    private var eventChanged : Event = null ;
// This is the number of maximum displayable items in this list.
    private var numOfElements : int = 0 ;
// Can the list be empty or not.
    private var canBeEmpty : Boolean = false ;
// The dispatch selected event will be thrown always or when the selected item really changes.
    private var alwaysDispatchSelectedEvent : Boolean = false ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ListPanel ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The event of changing needs to be constructed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// This will be the type of the text to be used in the list.
      textType = application . getTexts ( ) . TEXT_TYPE_MID ;
// Creating the content.
      baseList = new BaseList ( application ) ;
      addChild ( baseList ) ;
      baseList . setTextType ( textType ) ;
// Creating the new scroll object on the content.
      baseScroll = new BaseScroll ( application ) ;
      addChild ( baseScroll ) ;
// Masking of the content!
      baseList . mask = baseScroll . getMask0 ( ) ;
// This events needed to trigger the base actions.
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . ROLL_OUT , moverRollOut ) ;
// Other initializations.
      arrayLabels = new Array ( ) ;
      arrayValues = new Array ( ) ;
      arrayIcons = new Array ( ) ;
      selectedIndexes = new Array ( ) ;
// This events are required now. (application baselist basescroll)
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CONTENT_POSITION_CHANGED , reposContent ) ;
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TOP_REACHED , topReached ) ;
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BOTTOM_REACHED , bottomReached ) ;
      baseList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , listResized ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
    }
/*
** Override this setEnabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( baseScroll != null )
      {
        if ( baseScroll . getMover ( ) != null )
        {
          if ( getEnabled ( ) )
          {
            baseScroll . getMover ( ) . addEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
          }
          else
          {
            baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
          }
        }
      }
    }
/*
** The bottom of the base scroll content has been reached.
** So, it is mandatory to display the very last item ot the list.
*/
    private function topReached ( e : Event ) : void
    {
      startIndex = 0 ;
      displayFromIndex ( startIndex , false ) ;
    }
    private function bottomReached ( e : Event ) : void
    {
      startIndex = arrayLabels . length - baseList . getNumOfElements ( ) ;
      displayFromIndex ( startIndex , false ) ;
    }
/*
** Sets the canBeEmpty property.
*/
    public function setCanBeEmpty ( e : Boolean ) : void
    {
      if ( canBeEmpty != e )
      {
        canBeEmpty = e ;
        if ( ! canBeEmpty && selectedIndexes . length == 0 )
        {
// Sets the 0 as the selected index if the selected indexes array is empty and
// this object cannot be empty.
          selectedIndexes [ 0 ] = 0 ;
        }
      }
    }
/*
** Gets the canBeEmpty property.
*/
    public function getCanBeEmpty ( ) : Boolean
    {
      return canBeEmpty ;
    }
/*
** The padding of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
      if ( application != null )
      {
        setBaseScrollSch ( ) ;
        baseList . setsw ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        baseListRepos ( ) ;
      }
    }
/*
** The line thickness of the application has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
      if ( application != null )
      {
        setBaseScrollSch ( ) ;
        baseListRepos ( ) ;
      }
    }
/*
** Gets the type of the text used in the list.
*/
    public function getTextType ( ) : String
    {
      return textType ;
    }
/*
** Roll over the mover.
*/
    private function moverRollOver ( e : MouseEvent ) : void
    {
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . addEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
    }
/*
** Roll out the mover.
*/
    private function moverRollOut ( e : MouseEvent ) : void
    {
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
      displayFromIndex ( startIndex , false ) ;
    }
/*
** Moving the mouse over the mover object.
*/
    private function moverMouseMove ( e : MouseEvent ) : void
    {
      displayFromIndex ( startIndex , false ) ;
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Mouse down on the mover.
*/
    private function moverMouseDown ( e : MouseEvent ) : void
    {
      origMouseX = int ( mouseX ) ;
      origMouseY = int ( mouseY ) ;
      displayFromIndex ( startIndex , true ) ;
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Dispatches the event of the changing of the selected items.
*/
    private function dispatchSelectedChanged ( ) : void
    {
      selectedIndexes . sort ( ) ;
      displayFromIndex ( startIndex , false ) ;
      getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
    }
/*
** Clicking on the mover!
*/
    private function moverMouseClick ( e : MouseEvent ) : void
    {
// It is necessary to leave a gap otherwise it can be difficoult to click on an element.
      if ( Math . abs ( origMouseX - int ( mouseX ) ) < application . CLICK_GAP && Math . abs ( origMouseY - int ( mouseY ) ) < application . CLICK_GAP && mouseX > baseList . getcx ( ) && mouseX < baseList . getcxsw ( ) && mouseY > baseList . getcy ( ) && mouseY < baseList . getcysh ( ) && getActualElementIndexByMouse ( ) != - 1 )
      {
// Selecting the current item.
        if ( selectedIndexes . indexOf ( startIndex + getActualElementIndexByMouse ( ) ) != - 1 )
        {
          if ( selectedIndexes . length >= 2 || canBeEmpty )
          {
            selectedIndexes . splice ( selectedIndexes . indexOf ( startIndex + getActualElementIndexByMouse ( ) ) , 1 ) ;
          }
          if ( alwaysDispatchSelectedEvent )
          {
            dispatchSelectedChanged ( ) ;
          }
        }
        else
        {
          if ( multiple )
          {
            selectedIndexes . push ( startIndex + getActualElementIndexByMouse ( ) ) ;
            dispatchSelectedChanged ( ) ;
          }
          else
          {
            if ( selectedIndexes [ 0 ] != startIndex + getActualElementIndexByMouse ( ) )
            {
              selectedIndexes [ 0 ] = startIndex + getActualElementIndexByMouse ( ) ;
              dispatchSelectedChanged ( ) ;
            }
            else if ( alwaysDispatchSelectedEvent )
            {
              dispatchSelectedChanged ( ) ;
            }
          }
        }
      }
      if ( e != null )
      {
        e . updateAfterEvent ( ) ;
      }
    }
/*
** Sets the property of when should the selected event be thrown.
** (Default: single object, the selected event will be dispatched when the selected item changes.)
*/
    public function setAlwaysDispatchSelectedEvent ( b : Boolean ) : void
    {
      alwaysDispatchSelectedEvent = b ;
    }
    public function getAlwaysDispatchSelectedEvent ( ) : Boolean
    {
      return alwaysDispatchSelectedEvent ;
    }
/*
** Gets the multiple property of this list object.
*/
    public function getMultiple ( ) : Boolean
    {
      return multiple ;
    }
/*
** Sets the multiple property.
*/
    public function setMultiple ( m : Boolean ) : void
    {
      if ( m )
      {
        if ( ! multiple )
        {
// If not multiple and we would like this object to be multiple
// then it is possible without any considerations.
          multiple = m ;
        }
      }
      else
      {
        if ( multiple )
        {
// In the other case, the selected indexes array has to contain exactly one item,
// the other items will be dropped.
          if ( selectedIndexes . length > 1 )
          {
            selectedIndexes . splice ( 1 ) ;
            dispatchSelectedChanged ( ) ;
          }
          multiple = m ;
        }
      }
    }
/*
** Repositioning the content object according to the scrolling.
*/
    private function reposContent ( e : Event ) : void
    {
// Positioning the elements.
      displayFromIndex ( - Math . round ( baseScroll . getccy ( ) / ( application . getPropsDyn ( ) . getTextFieldHeight ( baseList . getTextType ( ) ) ) ) , false ) ;
// Positioning the list.
      baseListRepos ( ) ;
    }
/*
** Repositioning the list according to the position of the scroll mask.
*/
    private function baseListRepos ( ) : void
    {
      baseList . setcx ( baseScroll . getMask0 ( ) . x + application . getPropsDyn ( ) . getAppPadding ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
      baseList . setcy ( baseScroll . getMask0 ( ) . y + application . getPropsDyn ( ) . getAppPadding ( ) - application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
    }
/*
** Sets the selected items.
*/
    public function setSelectedIndexes ( indexes : Array ) : void
    {
      if ( indexes != null && selectedIndexes != null )
      {
        selectedIndexes . splice ( 0 ) ;
        for ( var i : int = 0 ; i < indexes . length ; i ++ )
        {
          if ( indexes [ i ] < arrayLabels . length )
          {
            selectedIndexes . push ( indexes [ i ] ) ;
          }
          if ( selectedIndexes . length == 1 && ! multiple )
          {
            break ;
          }
        }
        dispatchSelectedChanged ( ) ;
      }
    }
/*
** Clears the list, without changed event.
*/
    public function clearSelectedIndexes ( ) : void
    {
      if ( selectedIndexes != null )
      {
        selectedIndexes . splice ( 0 ) ;
      }
    }
/*
** Gets the selected indexes.
*/
    public function getSelectedIndexes ( ) : Array
    {
      var indexes : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < selectedIndexes . length ; i ++ )
      {
        indexes . push ( selectedIndexes [ i ] ) ;
      }
      if ( indexes . length == 0 )
      {
        indexes [ 0 ] = - 1 ;
      }
      return indexes ;
    }
/*
** The number of the elements.
*/
    public function getNumOfElements ( ) : int
    {
      return baseList . getNumOfElements ( ) ;
    }
/*
** Good start index?
** it not then it will correct that index and will returnn with that.
*/
    private function validStartIndex ( index : int ) : int
    {
      return Math . max ( 0 , Math . min ( index , arrayLabels . length - baseList . getNumOfElements ( ) ) ) ;
    }
/*
** Sets the start index property.
*/
    public function setStartIndex ( index : int ) : void
    {
      if ( startIndex != validStartIndex ( index ) )
      {
        startIndex = validStartIndex ( index ) ;
        baseScroll . setccy ( - startIndex * ( application . getPropsDyn ( ) . getTextFieldHeight ( baseList . getTextType ( ) ) ) ) ;
// Positioning the list.
        baseListRepos ( ) ;
        displayFromIndex ( startIndex , false ) ;
      }
    }
/*
** The size of the elements has been changed.
*/
    private function listResized ( e : Event ) : void
    {
      if ( arrayLabels . length > baseList . getNumOfElements ( ) )
      {
        baseScroll . setswh ( baseList . getsw ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , baseList . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsApp ( ) . getScrollMargin ( ) ) ;
      }
      else
      {
        baseScroll . setswh ( baseList . getsw ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , baseList . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
      super . setswh ( baseScroll . getsw ( ) , baseScroll . getsh ( ) ) ;
      setBaseScrollSch ( ) ;
      displayFromIndex ( 0 , false ) ;
    }
/*
** Sets the elements to be displayed.
*/
    public function setNumOfElements ( num : int ) : void
    {
      if ( numOfElements != num && num >= 0 )
      {
        numOfElements = num ;
        baseList . setNumOfElements ( Math . min ( num , arrayLabels . length ) ) ;
        reposContent ( null ) ;
      }
    }
/*
** This is necessary to be separated.
*/
    private function setBaseScrollSch ( ) : void
    {
      if ( baseScroll != null )
      {
        baseScroll . setsch ( arrayLabels . length * application . getPropsDyn ( ) . getTextFieldHeight ( baseList . getTextType ( ) ) + application . getPropsDyn ( ) . getAppLineThickness ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
      }
    }
/*
** Sets the arrays of the list to be displayed.
*/
    public function setArrays ( labels : Array , values : Array , icons : Array = null ) : void
    {
      arrayLabels = labels ;
      arrayValues = values ;
      arrayIcons = icons ;
      selectedIndexes = new Array ( ) ;
      baseList . setNumOfElements ( Math . min ( numOfElements , arrayLabels . length ) ) ;
      setBaseScrollSch ( ) ;
      displayFromIndex ( 0 , false ) ;
    }
/*
** Gets the array of labels.
*/
    public function getArrayLabels ( ) : Array
    {
      return arrayLabels ;
    }
/*
** Gets the array of labels.
*/
    public function getArrayValues ( ) : Array
    {
      return arrayValues ;
    }
/*
** Gets the array of labels.
*/
    public function getArrayIcons ( ) : Array
    {
      return arrayIcons ;
    }
/*
** Displays the list elements and their marks from the specified index.
*/
    private function displayFromIndex ( index : int , buttonDown : Boolean ) : void
    {
      startIndex = validStartIndex ( index ) ;
      for ( var i : int = 0 ; i < baseList . getNumOfElements ( ) ; i ++ )
      {
        baseList . setTextCode ( i , arrayLabels [ i + startIndex ] , arrayIcons == null ? null : arrayIcons [ i + startIndex ] ) ;
        if ( getActualElementIndexByMouse ( ) == i && ! buttonDown )
        {
          baseList . markElement ( i , 1 ) ;
        }
        else if ( ( selectedIndexes . indexOf ( i + startIndex ) != - 1 ) || ( getActualElementIndexByMouse ( ) == i && buttonDown ) )
        {
          baseList . markElement ( i , 2 ) ;
        }
        else
        {
          baseList . markElement ( i , 0 ) ;
        }
      }
      baseList . markElements ( ) ;
    }
/*
** Gets the actual element by the mouse pointer.
*/
    private function getActualElementIndexByMouse ( ) : int
    {
      if ( baseScroll . getMover ( ) . mouseX >= 0 && baseScroll . getMover ( ) . mouseX <= baseScroll . getMover ( ) . getsw ( ) && baseScroll . getMover ( ) . mouseY >= 0 && baseScroll . getMover ( ) . mouseY <= baseScroll . getMover ( ) . getsh ( ) )
      {
        return Math . floor ( ( ( baseScroll . getMover ( ) . mouseY - application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppLineThickness ( ) ) - baseScroll . getMask0 ( ) . y ) / application . getPropsDyn ( ) . getTextFieldHeight ( baseList . getTextType ( ) ) ) ;
      }
      else
      {
        return - 1 ;
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** The sh depends on the number of elements to be displayed.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        baseScroll . setsw ( getsw ( ) ) ;
        baseList . setsw ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
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
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OUT , moverRollOut ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . ROLL_OVER , moverRollOver ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_MOVE , moverMouseMove ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . MOUSE_DOWN , moverMouseDown ) ;
      baseScroll . getMover ( ) . removeEventListener ( MouseEvent . CLICK , moverMouseClick ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      textType = null ;
      baseList = null ;
      baseScroll = null ;
      arrayLabels = null ;
      arrayValues = null ;
      arrayIcons = null ;
      multiple = false ;
      startIndex = 0 ;
      selectedIndexes = null ;
      origMouseX = 0 ;
      origMouseY = 0 ;
      eventChanged = null ;
      numOfElements = 0 ;
      canBeEmpty = false ;
      alwaysDispatchSelectedEvent = false ;
    }
  }
}
