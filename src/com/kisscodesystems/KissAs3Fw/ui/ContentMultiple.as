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
** Sets the max elementsArray of the line or column in a content.
*/
    public function setElementsFix ( index : int , e : int ) : void
    {
      if ( arrayContentSinges [ index ] is ContentSingle )
      {
        ContentSingle ( arrayContentSinges [ index ] ) . setElementsFix ( e ) ;
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
    public function addContent ( label : String ) : int
    {
      if ( buttonBar . getIndexByLabel ( label ) == - 1 )
      {
        buttonBar . addButton ( label ) ;
        var contentSingle : ContentSingle = new ContentSingle ( application ) ;
        addChildAt ( contentSingle , 0 ) ;
        contentSingle . visible = false ;
        contentSingle . setcxy ( 0 , buttonBar . getcysh ( ) ) ;
        contentSingle . setswh ( getsw ( ) , getsh ( ) - ( buttonBar . getcysh ( ) ) ) ;
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
        contentSingle = null ;
        arrayContentSinges . splice ( i , 1 ) ;
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
** Adds an element to the content sprite.
*/
    public function addToContent ( i : int , displayObject : DisplayObject , normal : Boolean , cellIndex : int ) : void
    {
      if ( i >= 0 && i < arrayContentSinges . length )
      {
        ContentSingle ( arrayContentSinges [ i ] ) . addToContent ( displayObject , normal , cellIndex ) ;
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
      setActiveContent ( buttonBar . getActiveIndex ( ) ) ;
    }
/*
** The button bar is resized.
*/
    private function buttonBarResized ( e : Event ) : void
    {
// First: the button bar has to be repositioned.
      buttonBarRepos ( ) ;
// Second: all of the contents have to be resized and repositioned.
      for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
      {
        ContentSingle ( arrayContentSinges [ i ] ) . setcxy ( 0 , buttonBar . visible ? buttonBar . getcysh ( ) : 0 ) ;
        ContentSingle ( arrayContentSinges [ i ] ) . setsh ( getsh ( ) - ( buttonBar . visible ? buttonBar . getcysh ( ) : 0 ) ) ;
      }
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
        for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
        {
          ContentSingle ( arrayContentSinges [ i ] ) . setsw ( getsw ( ) ) ;
        }
        buttonBar . setMaxWidth ( getsw ( ) ) ;
        buttonBarRepos ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh )
      {
        super . setsh ( newsh ) ;
        for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
        {
          ContentSingle ( arrayContentSinges [ i ] ) . setcxy ( 0 , buttonBar . getcysh ( ) ) ;
          ContentSingle ( arrayContentSinges [ i ] ) . setsh ( getsh ( ) - ( buttonBar . getcysh ( ) ) ) ;
        }
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( getsw ( ) != newsw || getsh ( ) != newsh )
      {
        super . setswh ( newsw , newsh ) ;
        for ( var i : int = 0 ; i < arrayContentSinges . length ; i ++ )
        {
          ContentSingle ( arrayContentSinges [ i ] ) . setcxy ( 0 , buttonBar . getcysh ( ) ) ;
          ContentSingle ( arrayContentSinges [ i ] ) . setswh ( getsw ( ) , getsh ( ) - ( buttonBar . getcysh ( ) ) ) ;
        }
        buttonBar . setMaxWidth ( getsw ( ) ) ;
        buttonBarRepos ( ) ;
      }
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