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
** BaseList.
** Used for example in the List.
**
** MAIN FEATURES:
** - just text labels and cannot be scrolled
** - marking elements with states: 0, 1, 2
** - number of elements to be displayed can be set
** - the displayed text codes and the marks can be set
*/
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . display . Shape ;
  import flash . events . Event ;
  public class BaseList extends BaseSprite
  {
// The array of references of labels.
    private var textLabelArray : Array = null ;
// The array of marks of labels.
    private var textMarkedArray : Array = null ;
// The type of the text elements initially.
    private var textType : String = null ;
// The shape to mark the elements.
    private var mark : BaseShape = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseList ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Creating new arrays.
      textLabelArray = new Array ( ) ;
      textMarkedArray = new Array ( ) ;
// The marking shape.
      mark = new BaseShape ( application ) ;
      addChild ( mark ) ;
// The types of the labels
      textType = application . getTexts ( ) . TEXT_TYPE_BRIGHT ;
// This events are required.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , fillAlphaChanged ) ;
    }
/*
** The radius of the application has been changed.
*/
    private function radiusChanged ( e : Event ) : void
    {
// So we have to remark the elements.
      markElements ( ) ;
    }
/*
** The filler color (background) of the background has been changed.
*/
    private function backgroundFgColorChanged ( e : Event ) : void
    {
// So, we have to remark the elements.
      markElements ( ) ;
    }
/*
** The alpha of the filler color of the background has been changed.
*/
    private function fillAlphaChanged ( e : Event ) : void
    {
// So we have to remark the elements.
      markElements ( ) ;
    }
/*
** Marks the elements.
*/
    public function markElements ( ) : void
    {
      if ( application != null )
      {
// The initial clearance.
        mark . graphics . clear ( ) ;
// No lines.
        mark . graphics . lineStyle ( 0 , 0 , 0 ) ;
// Looping on the marked array.
        for ( var i : int = 0 ; i < textMarkedArray . length ; i ++ )
        {
// If 1 or 2 is the state of the current element then paint that otherwise the mark of this element remains blank.
          if ( textMarkedArray [ i ] == 1 )
          {
            drawMark ( Math . max ( application . getPropsApp ( ) . getBaseListMarkMinAlpha1 ( ) , application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) * application . getPropsApp ( ) . getBaseListMarkAlpha1Factor ( ) ) , i ) ;
          }
          else if ( textMarkedArray [ i ] == 2 )
          {
            drawMark ( Math . max ( application . getPropsApp ( ) . getBaseListMarkMinAlpha2 ( ) , application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) * application . getPropsApp ( ) . getBaseListMarkAlpha2Factor ( ) ) , i ) ;
          }
        }
      }
    }
/*
** Draws a filling on the mark shape at a specified area of the label and being at the specified index.
*/
    private function drawMark ( a : Number , i : int ) : void
    {
      mark . graphics . beginFill ( application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) , a ) ;
      mark . graphics . drawRoundRect ( 0 , TextLabel ( textLabelArray [ i ] ) . getcy ( ) , TextLabel ( textLabelArray [ i ] ) . getsw ( ) , TextLabel ( textLabelArray [ i ] ) . getsh ( ) , application . getPropsDyn ( ) . getAppRadius ( ) , application . getPropsDyn ( ) . getAppRadius ( ) ) ;
      mark . graphics . endFill ( ) ;
    }
/*
** Marks an element at the specified index.
** The markElements ( ) ; has to be called after this.
*/
    public function markElement ( i : int , marking : int ) : void
    {
// In case of existing element (valid index) and valid marking state, the marking is stored.
      if ( i < textLabelArray . length && i > - 1 )
      {
        if ( marking == 0 || marking == 1 || marking == 2 )
        {
          textMarkedArray [ i ] = marking ;
        }
      }
    }
/*
** Sets the number of the displayed elements.
** This number of elements will be mdisplayed in the list.
*/
    public function setNumOfElements ( numOfElements : int ) : void
    {
// Only positive number or zero is acceptable.
      if ( numOfElements >= 0 )
      {
// The current number of elements is considered.
// If it is less than the new value then the not existing items have to be created.
        if ( textLabelArray . length < numOfElements )
        {
          while ( textLabelArray . length < numOfElements )
          {
// Creation and initialization of the new item.
            var textLabel : TextLabel = new TextLabel ( application ) ;
            addChild ( textLabel ) ;
            textLabel . setTextCode ( "" ) ;
            textLabel . setTextType ( textType ) ;
            textLabel . setMaxWidth ( getsw ( ) , false ) ;
            textLabel . setcxy ( 0 , textLabelArray . length * application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ) ;
            textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , textLabelResized ) ;
            textLabelArray . push ( textLabel ) ;
            textMarkedArray . push ( 0 ) ;
            textLabel = null ;
          }
// This is called to calculate the new height of this base list.
          setHeight ( ) ;
        }
// Else if the current number of elements is greather
        else if ( textLabelArray . length > numOfElements )
        {
// then some elements have to be removed.
          removeElementsFromIndex ( numOfElements ) ;
// This is called to calculate the new height of this base list.
          setHeight ( ) ;
        }
      }
    }
/*
** Removes elements from the end of the list.
*/
    private function removeElementsFromIndex ( index : int ) : void
    {
// Removes the items.
      for ( var i : int = index ; i < textLabelArray . length ; i ++ )
      {
        if ( textLabelArray [ i ] is TextLabel )
        {
          TextLabel ( textLabelArray [ i ] ) . destroy ( ) ;
          removeChild ( TextLabel ( textLabelArray [ i ] ) ) ;
        }
        textLabelArray [ i ] = null ;
        textMarkedArray [ i ] = null ;
      }
      textLabelArray . splice ( index ) ;
      textMarkedArray . splice ( index ) ;
    }
/*
** When the size of the text label has been changed.
** For example: the text format has been changed.
** The whole height is recalculated.
*/
    private function textLabelResized ( e : Event ) : void
    {
      setHeight ( ) ;
    }
/*
** Sets the height of this application according to the number of elements.
** The getsh will return with the real height of the list.
** Happen:
** - repositioning of the elements
** - remarking of the elements
** - the super setsh is called.
*/
    private function setHeight ( ) : void
    {
      for ( var i : int = 0 ; i < textLabelArray . length ; i ++ )
      {
        TextLabel ( textLabelArray [ i ] ) . setcy ( i * application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ) ;
      }
      markElements ( ) ;
      super . setsh ( textLabelArray . length * application . getPropsDyn ( ) . getTextFieldHeight ( textType ) ) ;
    }
/*
** The setsh and setswh have to be out of order.
** (The height of the list is determined by the numOfElements.)
*/
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** This is the method runs after the changing of the size of this object.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( newsw != getsw ( ) )
      {
// Resizing all of the items.
        for ( var i : int = 0 ; i < textLabelArray . length ; i ++ )
        {
          TextLabel ( textLabelArray [ i ] ) . setMaxWidth ( newsw , false ) ;
        }
      }
      super . setsw ( newsw ) ;
    }
/*
** Gets the number of the displayed elements.
*/
    public function getNumOfElements ( ) : int
    {
// It is not stored separately, it is the length of the textLabelArray.
      return textLabelArray . length ;
    }
/*
** Sets the text code of the list element at index i.
*/
    public function setTextCode ( i : int , newTextCode : String , newIconType : String = null , newTabcnt : int = 0 ) : void
    {
// Sets the text code in case of valid index.
      if ( i < textLabelArray . length && i > - 1 )
      {
        TextLabel ( textLabelArray [ i ] ) . setcx ( newTabcnt * TextLabel ( textLabelArray [ i ] ) . getsh ( ) ) ;
        TextLabel ( textLabelArray [ i ] ) . setTextCode ( newTextCode ) ;
        if ( newIconType != null && newIconType != "" )
        {
          TextLabel ( textLabelArray [ i ] ) . setIcon ( newIconType ) ;
        }
        else
        {
          TextLabel ( textLabelArray [ i ] ) . destIcon ( ) ;
        }
      }
    }
/*
** Sets the type of this text.
*/
    public function setTextType ( newTextType : String ) : void
    {
      if ( textType != newTextType )
      {
// It should be stored if the value is different from the current.
        textType = newTextType ;
// All of the labels will get that.
        for ( var i : int = 0 ; i < textLabelArray . length ; i ++ )
        {
          TextLabel ( textLabelArray [ i ] ) . setTextType ( newTextType ) ;
        }
// This is also necessary while it may has a different textformat.
        setHeight ( ) ;
      }
    }
/*
** Gets the type of this base list object.
*/
    public function getTextType ( ) : String
    {
      return textType ;
    }
/*
** Overwrite the setting of the size.
*/
    override protected function doSizeChanged ( ) : void
    {
// So we have to remarking the elements.
      markElements ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** Overwriting this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , radiusChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , backgroundFgColorChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , fillAlphaChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      textLabelArray = null ;
      textMarkedArray = null ;
      textType = null ;
      mark = null ;
    }
  }
}
