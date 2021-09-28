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
** XmlLister. Lists and handles xmls.
**
** MAIN FEATURES:
** - xml-s can be specified as string
**   (empty XML will be used if the parsing of this is not successful.)
** - dispatches event only if the selected leaf item has been changed
**   and not that time when a tree part is closed or opened
** - labels and values can be set as into the list object
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPanel ;
  import flash . events . Event ;
  public class XmlLister extends BaseSprite
  {
// The list.
    private var list : ListPanel = null ;
// The array that can be displayed.
    private var arrayLabels : Array = null ;
    private var arrayValues : Array = null ;
    private var arrayIcons : Array = null ;
// The xml object to be handled.
// The keywords are: items, item, opened, value.
    private var xml : XML = null ;
// The selected item.
    private var selectedItem : String = null ;
// The start index
    private var startIndex : int = 0 ;
// The event if the selected item has been changed.
    private var eventChanged : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function XmlLister ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This event will be dispatched when the item is changed.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// The list.
      list = new ListPanel ( application ) ;
      addChild ( list ) ;
      list . setCanBeEmpty ( false ) ;
      list . setMultiple ( false ) ;
      list . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , listResized ) ;
      list . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , listChanged ) ;
// The array should be an empty one.
      arrayLabels = new Array ( ) ;
      arrayValues = new Array ( ) ;
      arrayIcons = new Array ( ) ;
// This is by default.
      selectedItem = "" ;
      startIndex = 0 ;
    }
/*
** Sets the property of when should the selected event be thrown.
** (Default: single object, the selected event will be dispatched when the selected item changes.)
*/
    public function setAlwaysDispatchSelectedEvent ( b : Boolean ) : void
    {
      if ( list != null )
      {
        list . setAlwaysDispatchSelectedEvent ( b ) ;
      }
    }
/*
** Gets the text type of the list.
*/
    public function getTextType ( ) : String
    {
      return list . getTextType ( ) ;
    }
/*
** Sets the xml to be displayed.
*/
    public function setXmlAsString ( xmlstring : String ) : void
    {
      try
      {
        xml = new XML ( xmlstring ) ;
        createArrays ( ) ;
      }
      catch ( e : Error )
      {
        xml = null ;
        arrayLabels = new Array ( ) ;
        arrayValues = new Array ( ) ;
        arrayIcons = new Array ( ) ;
        list . setArrays ( arrayLabels , arrayValues , arrayIcons ) ;
        list . setStartIndex ( 0 ) ;
      }
    }
/*
** Creates the elements to be displayed.
*/
    private function createArrays ( ) : void
    {
      try
      {
        arrayLabels = new Array ( ) ;
        arrayValues = new Array ( ) ;
        arrayIcons = new Array ( ) ;
        listAnItem ( new XMLList ( xml . children ( ) ) , "" ) ;
      }
      catch ( e : Error )
      {
        arrayLabels = new Array ( ) ;
        arrayValues = new Array ( ) ;
        arrayIcons = new Array ( ) ;
      }
      list . setArrays ( arrayLabels , arrayValues , arrayIcons ) ;
      list . setStartIndex ( startIndex ) ;
    }
/*
** Lists the item specified as xmlList.
** beginString: holds the current depth of the tree.
*/
    private function listAnItem ( xmlList : XMLList , beginString : String ) : void
    {
// For every part of the xmlList
      for each ( var x : XML in xmlList )
      {
// The item . length ( ) is zero then it is a single (leaf) element
// and it should be added into the displayable array as this.
        if ( x . item . length ( ) == 0 )
        {
          arrayLabels . push ( beginString + "    " + x . @ value ) ;
          arrayValues . push ( x . @ value ) ;
          try
          {
            arrayIcons . push ( x . @ icon ) ;
          }
          catch ( e : * )
          {
            arrayIcons . push ( "" ) ;
          }
        }
// The item . length ( ) is greather than zero and it is closed (opened=="0"),
// so this single element has to be added into the displayable array,
// but the fact that this is a closed item should be displayed!
// (clicking on this in the list will open this item)
        else if ( x . item . length ( ) > 0 && x . @ opened == "0" )
        {
          arrayLabels . push ( beginString + "  +" + x . @ value ) ;
          arrayValues . push ( x . @ value ) ;
          try
          {
            arrayIcons . push ( x . @ icon ) ;
          }
          catch ( e : * )
          {
            arrayIcons . push ( "" ) ;
          }
        }
// The item . length ( ) is greather than zero and it is opened (opened=="1"),
// so this single element has to be added into the displayable array,
// and the items under it also have to be discovered
// so give this current xml item to a recursive function call.
// (clicking on this in the list will close this item)
        else if ( x . item . length ( ) > 0 && x . @ opened == "1" )
        {
          arrayLabels . push ( beginString + "  - " + x . @ value ) ;
          arrayValues . push ( x . @ value ) ;
          try
          {
            arrayIcons . push ( x . @ icon ) ;
          }
          catch ( e : * )
          {
            arrayIcons . push ( "" ) ;
          }
          listAnItem ( new XMLList ( x . children ( ) ) , beginString + "    " ) ;
        }
      }
    }
/*
** The list has been resized.
*/
    private function listResized ( e : Event ) : void
    {
      super . setswh ( list . getsw ( ) , list . getsh ( ) ) ;
    }
/*
** Gets the selected item.
*/
    public function getSelectedItem ( ) : String
    {
      return selectedItem ;
    }
/*
** The selected items of the list has been changed.
*/
    public function listChanged ( e : Event ) : void
    {
      var xmlList : XMLList = xml .. item . ( @ value == arrayValues [ list . getSelectedIndexes ( ) [ 0 ] ] ) ;
      if ( xmlList . item . length ( ) == 0 )
      {
        if ( selectedItem != arrayValues [ list . getSelectedIndexes ( ) [ 0 ] ] || list . getAlwaysDispatchSelectedEvent ( ) )
        {
// This is a single item so the changed event can go to the outside world!
          selectedItem = arrayValues [ list . getSelectedIndexes ( ) [ 0 ] ] ;
          dispatchEventChanged ( ) ;
        }
      }
      else
      {
// This is not a single item, its parent object is needed first.
        var x : XML = xmlList . item [ 0 ] . parent ( ) ;
// Open or close.
        if ( x . @ opened == "0" )
        {
          x . @ opened = "1" ;
        }
        else if ( x . @ opened == "1" )
        {
          x . @ opened = "0" ;
        }
// The start of the displaying is trying to be that element that is opened or closed.
        startIndex = list . getSelectedIndexes ( ) [ 0 ] ;
// The arrays have to be recreated.
        createArrays ( ) ;
// This is not needed.
        x = null ;
      }
// This is not necessary any more.
      xmlList = null ;
    }
/*
** Dispatches the event about the changing of the selected item.
*/
    private function dispatchEventChanged ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
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
        list . setsw ( getsw ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Sets the elements to be displayed.
*/
    public function setNumOfElements ( num : int ) : void
    {
      list . setNumOfElements ( num ) ;
    }
/*
** The number of the elements.
*/
    public function getNumOfElements ( ) : int
    {
      return list . getNumOfElements ( ) ;
    }
/*
** Sets the start index property.
*/
    public function setStartIndex ( index : int ) : void
    {
      list . setStartIndex ( index ) ;
    }
/*
** Override this: the list has to be enabled or disabled mostly.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      list . setEnabled ( e ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      list = null ;
      arrayLabels . splice ( 0 ) ;
      arrayLabels = null ;
      arrayValues . splice ( 0 ) ;
      arrayValues = null ;
      arrayIcons . splice ( 0 ) ;
      arrayIcons = null ;
      xml = null ;
      selectedItem = null ;
      startIndex = 0 ;
      eventChanged = null ;
    }
  }
}