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
** ContentSingle.
** A base scroll object and a base sprite behind it containing the elements of the content.
**
** MAIN FEATURES:
** - two sprites to add the elements into:
**   baseSprite: the elements can be used in it
**   backSprite: the elements can be only displayed and no user interaction.
** - automatic element reposition according to the
     orientation , elementsFix and cellIndexesArray
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseScroll ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  public class ContentSingle extends BaseSprite
  {
// The back content: adding content here withto have no interaction and not to stpo the mover of scroll!
// for example text label.
    private var backSprite : BaseSprite = null ;
// The content of the Content.
    private var baseSprite : BaseSprite = null ;
// The scroll of the Content.
    private var baseScroll : BaseScroll = null ;
// The array of the elementsArray of content.
    private var elementsArray : Array = new Array ( ) ;
// The position to add the element into. Zero based indexes can be given.
    private var cellIndexesArray : Array = new Array ( ) ;
// The orientation of the content.
// orientation == application . getTexts ( ) . ORIENTATION_MANUAL || elementsFix == -1 means no automatic positioning.
    private var orientation : String = null ;
// Max index of elementsArray in perpendicular direction from the orientation.
// orientation == application . getTexts ( ) . ORIENTATION_MANUAL || elementsFix == -1 means no automatic positioning.
    private var elementsFix : int = - 1 ;
    private var eventElementsRepositioned : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ContentSingle ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The event of the reposition.
      eventElementsRepositioned = new Event ( application . EVENT_ELEMENTS_REPOSITIONED ) ;
// The orientation is manual by default.
      orientation = application . getTexts ( ) . ORIENTATION_VERTICAL ;
// The back sprite!
      backSprite = new BaseSprite ( application ) ;
      addChild ( backSprite ) ;
// Creating the new scroll object.
      baseScroll = new BaseScroll ( application ) ;
      addChild ( baseScroll ) ;
// Creating the content.
      baseSprite = new BaseSprite ( application ) ;
      addChild ( baseSprite ) ;
// Masking of the content!
      backSprite . mask = baseScroll . getMask0 ( ) ;
      baseSprite . mask = baseScroll . getMask1 ( ) ;
// This events are required to listen to.
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CONTENT_CACHE_BEGIN , cacheBeginContent ) ;
      baseScroll . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CONTENT_POSITION_CHANGED , reposContent ) ;
      baseSprite . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , contentResized ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
    }
/*
** If the content has to be cached as a bitmap.
*/
    private function cacheBeginContent ( e : Event ) : void
    {
      baseSprite . cacheAsBitmap = true ;
      backSprite . cacheAsBitmap = true ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
      reposElements ( ) ;
    }
/*
** The padding of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
      reposElements ( ) ;
    }
/*
** Automatic positioning?
*/
    public function getAutomaticPositioning ( ) : Boolean
    {
      return ! ( orientation == application . getTexts ( ) . ORIENTATION_MANUAL || elementsFix == - 1 ) ;
    }
/*
** Sets and gets the max elementsArray of the line or column.
*/
    public function setElementsFix ( es : int ) : void
    {
      if ( elementsFix != es )
      {
        elementsFix = es ;
        reposElements ( ) ;
      }
    }
    public function getElementsFix ( ) : int
    {
      return elementsFix ;
    }
/*
** Gets and sets the orientation of the content.
*/
    public function setOrientation ( o : String ) : void
    {
      if ( orientation != o )
      {
        if ( o == application . getTexts ( ) . ORIENTATION_VERTICAL || o == application . getTexts ( ) . ORIENTATION_HORIZONTAL || o == application . getTexts ( ) . ORIENTATION_MANUAL )
        {
          orientation = o ;
          reposElements ( ) ;
        }
      }
    }
    public function getOrientation ( ) : String
    {
      return orientation ;
    }
/*
** Automatic reposition of the elementsArray.
** One cellIndex can contain multiuple elements!
*/
    private function reposElements ( e : Event = null ) : void
    {
      if ( application != null )
      {
// Doing if the condition allowes this.
        if ( getAutomaticPositioning ( ) )
        {
// Loop variables.
          var i : int = 0 ;
          var j : int = 0 ;
          var k : int = 0 ;
// The maximum value of the elements of cellIndexesArray.
          var maxCellIndex : int = 0 ;
// The count of the other elements in the direction of the orientation.
// (elementsFix can be specified and the elementsVar depends on the elementsFix and maxCellIndex)
          var elementsVar : int = 0 ;
// A maximum width or height value to be counted from a column or row.
          var max : int = 0 ;
// This is a temporary value of the maximum size (width or height) if we should
// count the size of multiple objects. (Two or more objects in the same cell.)
          var maxtemp : int = 0 ;
// The current x and y coordinates of the specific object to be placed.
          var currx : int = 0 ;
          var curry : int = 0 ;
// The arrays of the widths of columns and heights of the rows.
          var maxws : Array = new Array ( ) ;
          var maxhs : Array = new Array ( ) ;
// The loop end indexes and what we are looking for.
          var a : int = 0 ;
          var b : int = 0 ;
          var v : Boolean = orientation == application . getTexts ( ) . ORIENTATION_VERTICAL ;
          var h : Boolean = orientation == application . getTexts ( ) . ORIENTATION_HORIZONTAL ;
// 0: Let's find the maximum value contained by the cellIndexesArray.
          for ( i = 0 ; i < cellIndexesArray . length ; i ++ )
          {
            if ( maxCellIndex < cellIndexesArray [ i ] )
            {
              maxCellIndex = cellIndexesArray [ i ] ;
            }
          }
// 1: The elementsVar can be calculated now -> the elementsVar and elementsFix are known.
          elementsVar = Math . floor ( maxCellIndex / ( elementsFix + 1 ) ) ;
// 2: The maximum indexes of the loops are:
          if ( orientation == application . getTexts ( ) . ORIENTATION_VERTICAL )
          {
            a = elementsFix ;
            b = elementsVar ;
          }
          else if ( orientation == application . getTexts ( ) . ORIENTATION_HORIZONTAL )
          {
            a = elementsVar ;
            b = elementsFix ;
          }
// 3: Let's fill the maxws array.
// Loop on the fix or var index: calculate the maximum width value to each columns.
// If the a is 2 then we will have 3 width value into the maxws at the end of this loop!
          for ( i = 0 ; i <= a ; i ++ )
          {
// The maximum width is zero by default.
            max = 0 ;
// Looping on the cell indexes.
            for ( j = 0 ; j < cellIndexesArray . length ; j ++ )
            {
// Counts if the current element is in the column defined by i.
              if ( cellIndexesArray [ j ] % ( a + 1 ) == i )
              {
// The sum of the widths of this cell is zero by default.
// Note: multiple objects can be specified into a single cell!)
                maxtemp = 0 ;
// Let's find all of the objects that are in this cell (not column, just this single cell!)
                for ( k = 0 ; k < cellIndexesArray . length ; k ++ )
                {
// The i and j object is in this cell if the cellIndexes values match!
                  if ( cellIndexesArray [ k ] == cellIndexesArray [ j ] )
                  {
// vertical (v): sum , horizontal (h): max!
                    if ( v )
                    {
// Now add the value to the sum.
                      if ( elementsArray [ k ] is BaseSprite )
                      {
                        maxtemp += BaseSprite ( elementsArray [ k ] ) . getsw ( ) ;
                      }
                      else if ( elementsArray [ k ] is BaseTextField )
                      {
                        maxtemp += BaseTextField ( elementsArray [ k ] ) . getsw ( ) ;
                      }
                      else
                      {
                        maxtemp += elementsArray [ k ] . width ;
                      }
                    }
                    else if ( h )
                    {
// Let's replace the current maximum width value if the width of this object is bigger than that.
                      if ( elementsArray [ k ] is BaseSprite )
                      {
                        if ( maxtemp < BaseSprite ( elementsArray [ k ] ) . getsw ( ) )
                        {
                          maxtemp = BaseSprite ( elementsArray [ k ] ) . getsw ( ) ;
                        }
                      }
                      else if ( elementsArray [ k ] is BaseTextField )
                      {
                        if ( maxtemp < BaseTextField ( elementsArray [ k ] ) . getsw ( ) )
                        {
                          maxtemp = BaseTextField ( elementsArray [ k ] ) . getsw ( ) ;
                        }
                      }
                      else
                      {
                        if ( maxtemp < elementsArray [ k ] . width )
                        {
                          maxtemp = elementsArray [ k ] . width ;
                        }
                      }
                    }
                  }
                }
// If this value is bigger than the current width then this new value will be the maximum width of this column.
                if ( max < maxtemp )
                {
                  max = maxtemp ;
                }
              }
            }
// Let's append this value to the end of the widths array.
            maxws . push ( max ) ;
          }
// 4: Let's fill the maxhs array.
          for ( i = 0 ; i <= b ; i ++ )
          {
// The maximum height is zero by default.
            max = 0 ;
// Looping on the cell indexes.
            for ( j = 0 ; j < cellIndexesArray . length ; j ++ )
            {
// Only if we are in the correct row: i.
              if ( Math . floor ( cellIndexesArray [ j ] / ( a + 1 ) ) == i )
              {
// The max of the heights of this cell is zero by default.
// Note: multiple objects can be specified into a single cell!)
                maxtemp = 0 ;
// Looking for the objects in this single cell.
                for ( k = 0 ; k < cellIndexesArray . length ; k ++ )
                {
// Also in this single cell if the cellIndex values are the same.
                  if ( cellIndexesArray [ k ] == cellIndexesArray [ j ] )
                  {
// vertical (v): max , horizontal (h): sum!
                    if ( v )
                    {
// Let's replace the current maximum height value if the height of this object is bigger than that.
                      if ( elementsArray [ k ] is BaseSprite )
                      {
                        if ( maxtemp < BaseSprite ( elementsArray [ k ] ) . getsh ( ) )
                        {
                          maxtemp = BaseSprite ( elementsArray [ k ] ) . getsh ( ) ;
                        }
                      }
                      else if ( elementsArray [ k ] is BaseTextField )
                      {
                        if ( maxtemp < BaseTextField ( elementsArray [ k ] ) . getsh ( ) )
                        {
                          maxtemp = BaseTextField ( elementsArray [ k ] ) . getsh ( ) ;
                        }
                      }
                      else
                      {
                        if ( maxtemp < elementsArray [ k ] . height )
                        {
                          maxtemp = elementsArray [ k ] . height ;
                        }
                      }
                    }
                    else if ( h )
                    {
// Now add the value to the sum.
                      if ( elementsArray [ k ] is BaseSprite )
                      {
                        maxtemp += BaseSprite ( elementsArray [ k ] ) . getsh ( ) ;
                      }
                      else if ( elementsArray [ k ] is BaseTextField )
                      {
                        maxtemp += BaseTextField ( elementsArray [ k ] ) . getsh ( ) ;
                      }
                      else
                      {
                        maxtemp += elementsArray [ k ] . height ;
                      }
                    }
                  }
                }
// This is a larger value? If yes than we should replace.
                if ( max < maxtemp )
                {
                  max = maxtemp ;
                }
              }
            }
// Put this value into the end of the array.
            maxhs . push ( max ) ;
          }
// 5: Object to their position!
          for ( i = 0 ; i < elementsArray . length ; i ++ )
          {
// By default, the margin is the position.
            currx = application . getPropsDyn ( ) . getAppMargin ( ) ;
            curry = application . getPropsDyn ( ) . getAppMargin ( ) ;
// The x and y coordinates will be calculated of the current object.
// Depending on the cellIndex value of the object,
// the x and y coordinates will be increased.
            for ( j = 0 ; j < cellIndexesArray [ i ] % maxws . length ; j ++ )
            {
              currx += maxws [ j ] + application . getPropsDyn ( ) . getAppMargin ( ) ;
            }
            for ( j = 0 ; j < Math . floor ( cellIndexesArray [ i ] / maxws . length ) ; j ++ )
            {
              curry += maxhs [ j ] + application . getPropsDyn ( ) . getAppMargin ( ) ;
            }
// If the cell of the current object contains other objects then
// Their sizes have to be considered! (just from 0 to the current not included)
            for ( k = 0 ; k < i ; k ++ )
            {
// Same cell if the values are the same.
              if ( cellIndexesArray [ k ] == cellIndexesArray [ i ] )
              {
// vertical: x coordinate is increased, horizontal: y coordinate is increased.
                if ( v )
                {
                  if ( elementsArray [ k ] is BaseSprite )
                  {
                    currx += BaseSprite ( elementsArray [ k ] ) . getsw ( ) ;
                  }
                  else if ( elementsArray [ k ] is BaseTextField )
                  {
                    currx += BaseTextField ( elementsArray [ k ] ) . getsw ( ) ;
                  }
                  else
                  {
                    currx += elementsArray [ k ] . width ;
                  }
                }
                else if ( h )
                {
                  if ( elementsArray [ k ] is BaseSprite )
                  {
                    curry += BaseSprite ( elementsArray [ k ] ) . getsh ( ) ;
                  }
                  else if ( elementsArray [ k ] is BaseTextField )
                  {
                    curry += BaseTextField ( elementsArray [ k ] ) . getsh ( ) ;
                  }
                  else
                  {
                    curry += elementsArray [ k ] . height ;
                  }
                }
              }
            }
// If this is a text label then its coordinate has to be increased by a padding.
            if ( elementsArray [ i ] is TextLabel )
            {
              curry += application . getPropsDyn ( ) . getAppPadding ( ) ;
            }
// Go into the position!
            elementsArray [ i ] . x = currx ;
            elementsArray [ i ] . y = curry ;
          }
// Because the x and y coordinates is set, the own cx and cy coordinates have to be updated.
          for ( i = 0 ; i < elementsArray . length ; i ++ )
          {
            if ( elementsArray [ i ] is BaseSprite )
            {
              BaseSprite ( elementsArray [ i ] ) . updatecxy ( ) ;
            }
            else if ( elementsArray [ i ] is BaseTextField )
            {
              BaseTextField ( elementsArray [ i ] ) . updatecxy ( ) ;
            }
          }
        }
// And now, the recalculation of the size of the content has to be done manually.
        contentSizeRecalc ( ) ;
// An event has to be dropped by this point.
        if ( getBaseEventDispatcher ( ) != null )
        {
          getBaseEventDispatcher ( ) . dispatchEvent ( eventElementsRepositioned ) ;
        }
      }
    }
/*
** Repositioning the content object according to the scrolling.
*/
    private function reposContent ( e : Event ) : void
    {
      baseSprite . setcx ( baseScroll . getccx ( ) ) ;
      baseSprite . setcy ( baseScroll . getccy ( ) ) ;
      backSprite . setcx ( baseScroll . getccx ( ) ) ;
      backSprite . setcy ( baseScroll . getccy ( ) ) ;
    }
/*
** THe size of the content has been changed.
*/
    private function contentResized ( e : Event ) : void
    {
      baseScroll . setscwch ( baseSprite . getsw ( ) , baseSprite . getsh ( ) ) ;
    }
/*
** Adds an element to the content sprite.
*/
    public function addToContent ( displayObject : DisplayObject , normal : Boolean , cellIndex : int ) : void
    {
      if ( ! baseSprite . contains ( displayObject ) && ! backSprite . contains ( displayObject ) )
      {
        elementsArray . push ( displayObject ) ;
        cellIndexesArray . push ( cellIndex ) ;
        if ( normal )
        {
          baseSprite . addChild ( displayObject ) ;
        }
        else
        {
          backSprite . addChild ( displayObject ) ;
        }
        if ( displayObject is BaseSprite )
        {
          BaseSprite ( displayObject ) . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposElements ) ;
        }
        else if ( displayObject is BaseTextField )
        {
          BaseTextField ( displayObject ) . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposElements ) ;
        }
        reposElements ( ) ;
      }
    }
/*
** Removes an element from the content (baseSprite or backSprite) sprite.
*/
    public function removeFromContent ( displayObject : DisplayObject ) : void
    {
      var index : int = elementsArray . indexOf ( displayObject ) ;
      if ( index != - 1 )
      {
        if ( baseSprite . contains ( displayObject ) )
        {
          baseSprite . removeChild ( displayObject ) ;
        }
        if ( backSprite . contains ( displayObject ) )
        {
          backSprite . removeChild ( displayObject ) ;
        }
        cellIndexesArray . splice ( index , 1 ) ;
        elementsArray . splice ( index , 1 ) ;
        reposElements ( ) ;
      }
    }
/*
** Gets the reference to the scroll.
*/
    public function getBaseScroll ( ) : BaseScroll
    {
      return baseScroll ;
    }
/*
** Calculating content size.
** Happens automatically for example if a BaseSprite or BaseShape
** or BaseTextField is added into the content base sprite.
** Has to be called manually if a non-Base... object is added to the content.
*/
    public function contentSizeRecalc ( ) : void
    {
      var maxw : int = 0 ;
      var maxh : int = 0 ;
      var sizesArrayBase : Array = contentSizeRecalcOnSprite ( baseSprite ) ;
      var sizesArrayBack : Array = contentSizeRecalcOnSprite ( backSprite ) ;
      if ( sizesArrayBase [ 0 ] > sizesArrayBack [ 0 ] )
      {
        maxw = sizesArrayBase [ 0 ] ;
      }
      else
      {
        maxw = sizesArrayBack [ 0 ] ;
      }
      if ( sizesArrayBase [ 1 ] > sizesArrayBack [ 1 ] )
      {
        maxh = sizesArrayBase [ 1 ] ;
      }
      else
      {
        maxh = sizesArrayBack [ 1 ] ;
      }
      baseSprite . setswh ( maxw , maxh ) ;
    }
    private function contentSizeRecalcOnSprite ( sprite : BaseSprite ) : Array
    {
      var maxw : int = 0 ;
      var maxh : int = 0 ;
      var arra : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < sprite . numChildren ; i ++ )
      {
        if ( sprite . getChildAt ( i ) is BaseSprite )
        {
          if ( maxw < ( sprite . getChildAt ( i ) as BaseSprite ) . getcx ( ) + ( sprite . getChildAt ( i ) as BaseSprite ) . getsw ( ) )
          {
            maxw = ( sprite . getChildAt ( i ) as BaseSprite ) . getcx ( ) + ( sprite . getChildAt ( i ) as BaseSprite ) . getsw ( ) ;
          }
          if ( maxh < ( sprite . getChildAt ( i ) as BaseSprite ) . getcy ( ) + ( sprite . getChildAt ( i ) as BaseSprite ) . getsh ( ) )
          {
            maxh = ( sprite . getChildAt ( i ) as BaseSprite ) . getcy ( ) + ( sprite . getChildAt ( i ) as BaseSprite ) . getsh ( ) ;
          }
        }
        else if ( sprite . getChildAt ( i ) is BaseTextField )
        {
          if ( maxw < ( sprite . getChildAt ( i ) as BaseTextField ) . getcx ( ) + ( sprite . getChildAt ( i ) as BaseTextField ) . getsw ( ) )
          {
            maxw = ( sprite . getChildAt ( i ) as BaseTextField ) . getcx ( ) + ( sprite . getChildAt ( i ) as BaseTextField ) . getsw ( ) ;
          }
          if ( maxh < ( sprite . getChildAt ( i ) as BaseTextField ) . getcy ( ) + ( sprite . getChildAt ( i ) as BaseTextField ) . getsh ( ) )
          {
            maxh = ( sprite . getChildAt ( i ) as BaseTextField ) . getcy ( ) + ( sprite . getChildAt ( i ) as BaseTextField ) . getsh ( ) ;
          }
        }
        else
        {
          if ( maxw < sprite . getChildAt ( i ) . x + sprite . getChildAt ( i ) . width )
          {
            maxw = sprite . getChildAt ( i ) . x + sprite . getChildAt ( i ) . width ;
          }
          if ( maxh < sprite . getChildAt ( i ) . y + sprite . getChildAt ( i ) . height )
          {
            maxh = sprite . getChildAt ( i ) . y + sprite . getChildAt ( i ) . height ;
          }
        }
      }
      arra = [ maxw , maxh ] ;
      return arra ;
    }
/*
** Overriding the setsw setsh and setswh functions.
** Do the same but it is necessary to reposition the actualpos shape.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        baseScroll . setsw ( getsw ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        baseScroll . setsh ( getsh ( ) ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        baseScroll . setswh ( getsw ( ) , getsh ( ) ) ;
      }
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventElementsRepositioned != null )
      {
        eventElementsRepositioned . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      backSprite = null ;
      baseSprite = null ;
      baseScroll = null ;
      elementsArray . splice ( 0 ) ;
      elementsArray = null ;
      cellIndexesArray . splice ( 0 ) ;
      cellIndexesArray = null ;
      orientation = null ;
      elementsFix = 0 ;
      eventElementsRepositioned = null ;
    }
  }
}