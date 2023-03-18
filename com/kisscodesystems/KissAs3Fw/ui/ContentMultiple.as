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
** ContentMultiple.
** Multiple content objects with a button bar to navigate in them.
**
** MAIN FEATURES:
** - button bar
** - set of single contents
** - the -1 index can be set
** - the newer content go under the others
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseEventDispatcher ;
  import com . kisscodesystems . KissAs3Fw . base . BaseScroll ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonBar ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import flash . display . DisplayObject ;
  import flash . events . Event ;
  public class ContentMultiple extends BaseSprite
  {
// The button bar object to switch the contenst with.
    private var buttonBar : ButtonBar = null ;
// The arrays of the single contents (references to ContentSingle objects)
    private var arrayContentSinges : Array = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ContentMultiple ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The button bar object.
      buttonBar = new ButtonBar ( application ) ;
      addChild ( buttonBar ) ;
      buttonBar . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , buttonBarChanged ) ;
      buttonBar . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , buttonBarResized ) ;
// The array of the contents.
      arrayContentSinges = new Array ( ) ;
    }
/*
** Override this setEnabled method!
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( buttonBar != null )
      {
        buttonBar . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** To be able to set the coordinates of the content!
*/
    public function setccx ( index , newccx : int ) : void
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        if ( ContentSingle ( arrayContentSinges [ index ] ) . getBaseScroll ( ) != null )
        {
          ContentSingle ( arrayContentSinges [ index ] ) . getBaseScroll ( ) . setccx ( newccx ) ;
        }
      }
    }
    public function setccy ( index , newccy : int ) : void
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        if ( ContentSingle ( arrayContentSinges [ index ] ) . getBaseScroll ( ) != null )
        {
          ContentSingle ( arrayContentSinges [ index ] ) . getBaseScroll ( ) . setccy ( newccy ) ;
        }
      }
    }
/*
** Changes the icon of a button link on the button bar.
*/
    public function destIcon ( index : int ) : void
    {
      if ( buttonBar != null )
      {
        buttonBar . destIcon ( index ) ;
      }
    }
    public function setIcon ( index : int , it : String ) : void
    {
      if ( buttonBar != null )
      {
        buttonBar . setIcon ( index , it ) ;
      }
    }
    public function setIconIfNotActive ( index : int , it : String ) : void
    {
      if ( buttonBar != null )
      {
        buttonBar . setIconIfNotActive ( index , it ) ;
      }
    }
/*
** Sets the default content.
*/
    public function setDefaultContent ( ) : void
    {
      addContent ( application . getTexts ( ) . DEFAULT_CONTENT ) ;
      setActiveIndex ( 0 ) ;
      setButtonBarVisible ( false ) ;
    }
/*
** Sets the max elementsArray of the line or column in a content.
*/
    public function setElementsFix ( index : int , e : int ) : void
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        ContentSingle ( arrayContentSinges [ index ] ) . setElementsFix ( e ) ;
      }
    }
    public function getElementsFix ( index : int ) : int
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        return ContentSingle ( arrayContentSinges [ index ] ) . getElementsFix ( ) ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** Sets the orientation of one of the contents.
*/
    public function setOrientation ( index : int , o : String ) : void
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        ContentSingle ( arrayContentSinges [ index ] ) . setOrientation ( o ) ;
      }
    }
/*
** Gets the content single by its index.
*/
    public function getContentSingle ( index : int ) : ContentSingle
    {
      return ContentSingle ( arrayContentSinges [ index ] ) ;
    }
/*
** Gets the content single by its index.
*/
    public function getBaseScroll ( index : int ) : BaseScroll
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        return ContentSingle ( arrayContentSinges [ index ] ) . getBaseScroll ( ) ;
      }
      else
      {
        return null ;
      }
    }
/*
** Gets the content single by its index.
*/
    public function getBaseSprite ( index : int ) : BaseSprite
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        return ContentSingle ( arrayContentSinges [ index ] ) . getBaseSprite ( ) ;
      }
      else
      {
        return null ;
      }
    }
/*
** Sets the visible of the button bar.
** (If it is not visible then the contents will be resized!)
*/
    public function setButtonBarVisible ( v : Boolean ) : void
    {
      if ( buttonBar . visible != v )
      {
        buttonBar . visible = v ;
        buttonBarResized ( null ) ;
      }
    }
/*
** Sets the button active.
*/
    public function setActiveIndex ( index : int ) : void
    {
      buttonBar . setActiveIndex ( index ) ;
    }
/*
** Gets the active index.
*/
    public function getActiveIndex ( ) : int
    {
      return buttonBar . getActiveIndex ( ) ;
    }
/*
** Gets the index of the content by the label.
*/
    public function getContentIndexByLabel ( label : String ) : int
    {
      return buttonBar . getIndexByLabel ( label ) ;
    }
/*
** Gets the number of the contents.
*/
    public function getNumOfContents ( ) : int
    {
      return arrayContentSinges . length ;
    }
/*
** Adds a content and returns the index of the content.
** Unique elements can be added as the labels of the buttons.
*/
    public function addContent ( label : String , it : String = "" ) : int
    {
      if ( buttonBar . getIndexByLabel ( label ) == - 1 )
      {
        buttonBar . addButton ( label , it ) ;
        var contentSingle : ContentSingle = new ContentSingle ( application ) ;
        addChildAt ( contentSingle , 0 ) ;
        contentSingle . visible = false ;
        resizeContent ( contentSingle ) ;
        arrayContentSinges . push ( contentSingle ) ;
        contentSingle = null ;
        return arrayContentSinges . length - 1 ;
      }
      else
      {
        return - 1 ;
      }
    }
/*
** Removes a content.
*/
    public function removeContent ( i : int ) : void
    {
      var contentSingle : ContentSingle = null ;
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        buttonBar . removeButton ( i ) ;
        contentSingle = ContentSingle ( arrayContentSinges [ i ] ) ;
        contentSingle . destroy ( ) ;
        removeChild ( contentSingle ) ;
        arrayContentSinges . splice ( i , 1 ) ;
        if ( i > 0 )
        {
          setActiveContent ( i - 1 ) ;
        }
        else
        {
          setActiveContent ( 0 ) ;
        }
      }
      contentSingle = null ;
    }
/*
** Removes all of the contents.
*/
    public function removeAllContents ( ) : void
    {
      buttonBar . removeAllButtons ( ) ;
      var contentSingle : ContentSingle = null ;
      for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
      {
        contentSingle = ContentSingle ( arrayContentSinges [ i ] ) ;
        contentSingle . destroy ( ) ;
        removeChild ( contentSingle ) ;
      }
      contentSingle = null ;
      arrayContentSinges . splice ( 0 ) ;
    }
/*
** Changes a cell index only.
*/
    public function changeCellIndex ( i : int , displayObject : DisplayObject , cellIndex : int ) : void
    {
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        ContentSingle ( arrayContentSinges [ i ] ) . changeCellIndex ( displayObject , cellIndex ) ;
      }
    }
/*
** Returns the cell index of an element.
*/
    public function getCellIndex ( i : int , displayObject : DisplayObject ) : int
    {
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        return ContentSingle ( arrayContentSinges [ i ] ) . getCellIndex ( displayObject ) ;
      }
      return - 1 ;
    }
/*
** Adds an element to the content sprite.
*/
    public function addToContent ( i : int , displayObject : DisplayObject , cellIndex : int , sizeConsider : Boolean = true , to0 : Boolean = false ) : void
    {
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        ContentSingle ( arrayContentSinges [ i ] ) . addToContent ( displayObject , cellIndex , sizeConsider , to0 ) ;
      }
    }
/*
** Removes an element from the content (baseSprite or backSprite) sprite.
*/
    public function removeFromContent ( i : int , displayObject : DisplayObject ) : void
    {
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        ContentSingle ( arrayContentSinges [ i ] ) . removeFromContent ( displayObject ) ;
      }
    }
/*
** When the button bar changes.
*/
    private function buttonBarChanged ( e : Event ) : void
    {
// The active content is set.
      setActiveContent ( buttonBar . getActiveIndex ( ) ) ;
// Forward this event.
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( e ) ;
      }
    }
/*
** The button bar is resized.
*/
    private function buttonBarResized ( e : Event ) : void
    {
// First: the button bar has to be repositioned.
      buttonBarRepos ( ) ;
// Second: all of the contents have to be resized and repositioned.
      resizeAllContents ( ) ;
    }
/*
** Sets the active index.
*/
    private function setActiveContent ( index : int ) : void
    {
      if ( index >= - 1 && i < arrayContentSinges . length )
      {
// Everyone is invisible.
        for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
        {
          ContentSingle ( arrayContentSinges [ i ] ) . visible = false ;
        }
// Except the given and not -1 content.
        if ( index != - 1 )
        {
          ContentSingle ( arrayContentSinges [ index ] ) . visible = true ;
        }
      }
    }
/*
** Repositions the button bar.
*/
    private function buttonBarRepos ( ) : void
    {
      buttonBar . setcxy ( ( getsw ( ) - buttonBar . getsw ( ) ) / 2 , 0 ) ;
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
        resizeAllContents ( ) ;
        buttonBar . setMaxWidth ( getsw ( ) ) ;
        buttonBarRepos ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        resizeAllContents ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        resizeAllContents ( ) ;
        buttonBar . setMaxWidth ( getsw ( ) ) ;
        buttonBarRepos ( ) ;
      }
    }
/*
** Resizes all of the contents.
*/
    private function resizeAllContents ( ) : void
    {
      for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
      {
        resizeContent ( ContentSingle ( arrayContentSinges [ i ] ) ) ;
      }
    }
/*
** Resizes one content.
*/
    private function resizeContent ( content : ContentSingle ) : void
    {
      content . setcxy ( 0 , getButtonBarcysh ( ) ) ;
      content . setswh ( getsw ( ) , getsh ( ) - getButtonBarcysh ( ) ) ;
    }
/*
** Gets the height of the buttonBar.
*/
    public function getButtonBarcysh ( ) : int
    {
      if ( buttonBar != null )
      {
        return buttonBar . visible ? buttonBar . getcysh ( ) : 0 ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** The content size itself.
** Depends on the visibility of the menu.
*/
    public function getContentsw ( ) : int
    {
      return getsw ( ) ;
    }
    public function getContentsh ( ) : int
    {
      return getsh ( ) - getButtonBarcysh ( ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      buttonBar = null ;
      arrayContentSinges = null ;
    }
  }
}
