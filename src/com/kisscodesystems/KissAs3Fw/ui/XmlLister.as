/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 *
 * DESCRIPTION:
 * XmlLister.
 * A list that displays a tree described by an xml, one indented item per row.
 * The keywords of that xml are: items, item, opened, value and icon.
 *
 * MAIN FEATURES:
 * - the xml can be given as a string and it is answered as it arrived, an unparsable
 *   one leaves an empty list behind
 * - a branch item opens and closes on a click, a leaf item gets selected
 * - the changed event is only dispatched when the selected leaf item has changed,
 *   and not when a branch has been opened or closed
 * - the labels, the values, the icons and the indentations are given to the list
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import flash.events.Event;
  public class XmlLister extends BaseSprite
  {
    private var list:ListPanel = null;
    private var arrayLabels:Array = null;
    private var arrayValues:Array = null;
    private var arrayIcons:Array = null;
    private var arrayTabcnts:Array = null;
    private var xml:XML = null;
    // The xml this object has been given the last time, as it arrived. The parsed tree is
    // dropped when it can not be walked, so this is the only store telling what this
    // object has been asked to display.
    private var xmlString:String = "";
    private var selectedItem:String = "";
    private var startIndex:int = 0;
    private var eventChanged:Event = null;
    /**
     * Constructs the XmlLister object: creates the list that displays the tree and
     * the empty arrays the tree is collected into.
     * @param applicationRef the main application reference
     */
    public function XmlLister(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " XmlLister> called.", 1);
      application.trace("<" + this + " XmlLister> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      list = new ListPanel(application);
      addChild(list);
      list.setCanBeEmpty(false);
      list.setMultiple(false);
      list.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), listResized);
      list.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), listChanged);
      emptyArrays();
      application.trace("<" + this + " XmlLister> constructed.", 1);
    }
    /**
     * Returns the text type of the list of this object.
     */
    public function getTextType():String
    {
      return list.getTextType();
    }
    /**
     * Returns the value of the selected leaf item, an empty string when there has
     * been no leaf item selected yet.
     */
    public function getSelectedItem():String
    {
      return selectedItem;
    }
    /**
     * Returns the xml this object has been given the last time, as it arrived: an
     * unparsable one is answered just as well, because it is the very string this object
     * has been asked to display.
     */
    public function getXmlAsString():String
    {
      return xmlString;
    }
    /**
     * Parses the given xml and displays the tree of it. An unparsable xml leaves an
     * empty list behind.
     * @param s the xml to be displayed, as a string
     */
    public function setXmlAsString(s:String):void
    {
      application.trace("<" + this + " XmlLister setXmlAsString> called.", 1);
      application.trace("<" + this + " XmlLister setXmlAsString> s: " + s, 0);
      xmlString = s;
      try
      {
        xml = new XML(xmlString);
        createArrays();
      }
      catch (e:Error)
      {
        application.trace("<" + this + " XmlLister setXmlAsString> the xml can not be parsed: " + e, 7);
        xml = null;
        emptyArrays();
        setArraysToList(0);
      }
    }
    /**
     * Returns the number of the items the list displays at the same time.
     */
    public function getNumOfElements():int
    {
      return list.getNumOfElements();
    }
    /**
     * Sets the number of the items the list displays at the same time.
     * @param num the number of the items to be displayed
     */
    public function setNumOfElements(num:int):void
    {
      application.trace("<" + this + " XmlLister setNumOfElements> called.", 1);
      application.trace("<" + this + " XmlLister setNumOfElements> num: " + num, 0);
      list.setNumOfElements(num);
    }
    /**
     * Returns the index of the item the displaying of the list starts from.
     */
    public function getStartIndex():int
    {
      return startIndex;
    }
    /**
     * Sets the index of the item the displaying of the list starts from.
     * @param index the index of the first item to be displayed
     */
    public function setStartIndex(index:int):void
    {
      application.trace("<" + this + " XmlLister setStartIndex> called.", 1);
      application.trace("<" + this + " XmlLister setStartIndex> index: " + index, 0);
      startIndex = index;
      list.setStartIndex(startIndex);
    }
    /**
     * Tells whether every selection dispatches the changed event, or only the one really
     * changing the selected leaf item, which is the default.
     */
    public function getAlwaysDispatchSelectedEvent():Boolean
    {
      return list.getAlwaysDispatchSelectedEvent();
    }
    /**
     * Tells whether the changed event has to be dispatched on every selection, or
     * only when the selected leaf item really changes, which is the default.
     * @param b true if every selection has to dispatch the changed event
     */
    public function setAlwaysDispatchSelectedEvent(b:Boolean):void
    {
      application.trace("<" + this + " XmlLister setAlwaysDispatchSelectedEvent> called.", 1);
      application.trace("<" + this + " XmlLister setAlwaysDispatchSelectedEvent> b: " + b, 0);
      list.setAlwaysDispatchSelectedEvent(b);
    }
    /**
     * Sets the width of this object and of its list.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " XmlLister setDw> called.", 1);
      application.trace("<" + this + " XmlLister setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        list.setDw(getDw());
      }
    }
    /**
     * The height of this object comes from the number of the displayed items, so this
     * does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " XmlLister setDh> called.", 1);
      application.trace("<" + this + " XmlLister setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " XmlLister setDh> do nothing.", 1);
    }
    /**
     * The height of this object comes from the number of the displayed items, so this
     * does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " XmlLister setDwh> called.", 1);
      application.trace("<" + this + " XmlLister setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " XmlLister setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " XmlLister setDwh> do nothing.", 1);
    }
    /**
     * Enables or disables this object together with its list.
     * @param e true when this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " XmlLister setEnabled> called.", 1);
      application.trace("<" + this + " XmlLister setEnabled> e: " + e, 0);
      super.setEnabled(e);
      list.setEnabled(e);
    }
    /**
     * Takes the dimensions of the list as soon as this object gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " XmlLister addedToStage> called.", 1);
      application.trace("<" + this + " XmlLister addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resizeToList();
    }
    /**
     * Empties every array the tree is collected into.
     */
    private function emptyArrays():void
    {
      application.trace("<" + this + " XmlLister emptyArrays> called.", 1);
      arrayLabels = new Array();
      arrayValues = new Array();
      arrayIcons = new Array();
      arrayTabcnts = new Array();
    }
    /**
     * Gives the collected arrays to the list and scrolls it to the given item.
     * @param index the index of the first item to be displayed
     */
    private function setArraysToList(index:int):void
    {
      application.trace("<" + this + " XmlLister setArraysToList> called.", 1);
      application.trace("<" + this + " XmlLister setArraysToList> index: " + index, 0);
      list.setArrays(arrayLabels, arrayValues, arrayIcons, arrayTabcnts);
      list.setStartIndex(index);
    }
    /**
     * Collects the items to be displayed from the current xml and gives them to the
     * list. An unwalkable xml leaves an empty list behind.
     */
    private function createArrays():void
    {
      application.trace("<" + this + " XmlLister createArrays> called.", 1);
      try
      {
        emptyArrays();
        listAnItem(new XMLList(xml.children()), 0);
      }
      catch (e:Error)
      {
        application.trace("<" + this + " XmlLister createArrays> the xml can not be walked: " + e, 7);
        emptyArrays();
      }
      setArraysToList(startIndex);
    }
    /**
     * Collects one level of the tree into the arrays, and calls itself for the
     * children of every open branch item.
     * @param xmlList the items of the level to be collected
     * @param tabcnt the current depth of the tree, the indentation of that level
     */
    private function listAnItem(xmlList:XMLList, tabcnt:int):void
    {
      application.trace("<" + this + " XmlLister listAnItem> called.", 1);
      application.trace("<" + this + " XmlLister listAnItem> xmlList: " + xmlList, 0);
      application.trace("<" + this + " XmlLister listAnItem> tabcnt: " + tabcnt, 0);
      for each (var x:XML in xmlList)
      {
        // A leaf item has no items under it, so it is collected as it is.
        if (x.item.length() == 0)
        {
          pushAnItem(x, tabcnt, x.@icon.length() > 0 ? String(x.@icon) : "");
        }
        // A closed branch item is collected with the icon that opens it on a click.
        else if (x.@opened == "0")
        {
          pushAnItem(x, tabcnt, EnumIcons.plus());
        }
        // An open branch item is collected with the icon that closes it on a click,
        // and the items under it are collected as well.
        else if (x.@opened == "1")
        {
          pushAnItem(x, tabcnt, EnumIcons.minus());
        }
      }
    }
    /**
     * Collects one single item of the tree into the arrays, and the children of it as
     * well when it is an open branch item.
     * @param x the item to be collected
     * @param tabcnt the current depth of the tree, the indentation of that item
     * @param iconType the icon type to be displayed on that item
     */
    private function pushAnItem(x:XML, tabcnt:int, iconType:String):void
    {
      application.trace("<" + this + " XmlLister pushAnItem> called.", 1);
      application.trace("<" + this + " XmlLister pushAnItem> x: " + x, 0);
      application.trace("<" + this + " XmlLister pushAnItem> tabcnt: " + tabcnt, 0);
      application.trace("<" + this + " XmlLister pushAnItem> iconType: " + iconType, 0);
      arrayLabels.push(String(x.@value));
      arrayValues.push(String(x.@value));
      arrayIcons.push(iconType);
      arrayTabcnts.push(tabcnt);
      if (x.item.length() > 0 && x.@opened == "1")
      {
        listAnItem(new XMLList(x.children()), tabcnt + 1);
      }
    }
    /**
     * Takes the dimensions of the resized list.
     * @param e the dimensions changed event of the list
     */
    private function listResized(e:Event):void
    {
      application.trace("<" + this + " XmlLister listResized> called.", 1);
      application.trace("<" + this + " XmlLister listResized> e: " + e, 0);
      resizeToList();
    }
    /**
     * Sets the dimensions of this object to the dimensions of its list.
     */
    private function resizeToList():void
    {
      application.trace("<" + this + " XmlLister resizeToList> called.", 1);
      super.setDwh(list.getDw(), list.getDh());
    }
    /**
     * Handles the selection of the list: a leaf item becomes the selected item of
     * this object, a branch item opens or closes instead.
     * @param e the changed event of the list
     */
    private function listChanged(e:Event):void
    {
      application.trace("<" + this + " XmlLister listChanged> called.", 1);
      application.trace("<" + this + " XmlLister listChanged> e: " + e, 0);
      const selectedIndex:int = list.getSelectedIndexes()[0];
      const selectedValue:String = arrayValues[selectedIndex];
      const xmlList:XMLList = xml..item.(@value == selectedValue);
      if (xmlList.item.length() == 0)
      {
        if (selectedItem != selectedValue || list.getAlwaysDispatchSelectedEvent())
        {
          selectedItem = selectedValue;
          dispatchEventChanged();
        }
      }
      else
      {
        const x:XML = xmlList.item[0].parent();
        if (x.@opened == "0")
        {
          x.@opened = "1";
        }
        else if (x.@opened == "1")
        {
          x.@opened = "0";
        }
        // The displaying tries to start from the item that has been opened or closed.
        startIndex = selectedIndex;
        createArrays();
      }
    }
    /**
     * Dispatches the changed event of this object.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " XmlLister dispatchEventChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Frees all listeners, events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " XmlLister destroy> called.", 1);
      application.trace("<" + this + " XmlLister destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      arrayLabels.splice(0);
      arrayValues.splice(0);
      arrayIcons.splice(0);
      arrayTabcnts.splice(0);
      application.trace("<" + this + " XmlLister destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      list = null;
      xmlString = null;
      arrayLabels = null;
      arrayValues = null;
      arrayIcons = null;
      arrayTabcnts = null;
      xml = null;
      selectedItem = null;
      startIndex = 0;
      eventChanged = null;
    }
  }
}
