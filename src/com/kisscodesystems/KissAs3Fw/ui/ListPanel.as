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
 * ListPanel.
 * A scrollable list of selectable items.
 *
 * MAIN FEATURES:
 * - the labels, the values, the icons and the indentations come as arrays from outside
 * - only as many elements are built as the list displays, they show the scrolled window
 * - one item or more than one item can be selected, and the empty selection can be
 *   forbidden: such a list keeps one item selected whatever it is given, and only the
 *   clearing of the selection takes it back to the empty state it has been built in
 * - the item under the mouse is marked softly, the selected ones are marked strongly
 * - the height is determined by the number of the displayed elements
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseList;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class ListPanel extends BaseSprite
  {
    private var textType:String = null;
    private var baseList:BaseList = null;
    private var baseScroll:BaseScroll = null;
    private var arrayLabels:Array = null;
    private var arrayValues:Array = null;
    private var arrayIcons:Array = null;
    private var arrayTabcnts:Array = null;
    private var selectedIndexes:Array = null;
    private var multiple:Boolean = false;
    private var canBeEmpty:Boolean = false;
    private var alwaysDispatchSelectedEvent:Boolean = false;
    private var startIndex:int = -1;
    private var numOfElements:int = 0;
    private var origMouseX:int = 0;
    private var origMouseY:int = 0;
    private var eventChanged:Event = null;
    /**
     * Constructs the ListPanel object and builds up its list and its scroll.
     * @param applicationRef the main application reference
     */
    public function ListPanel(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ListPanel> called.", 1);
      application.trace("<" + this + " ListPanel> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      textType = EnumTextTypes.TEXT_TYPE_MID();
      baseList = new BaseList(application);
      addChild(baseList);
      baseList.setTextType(textType);
      baseScroll = new BaseScroll(application);
      addChild(baseScroll);
      baseList.mask = baseScroll.getMask();
      baseScroll.setEnabledHorizontal(false);
      baseScroll.getMover().mouseDownForScrollingEnabled = false;
      // the mouse is followed on this object and not on the mover of the scroll: that mover
      // covers the middle of the scroll only, so the first and the last element would be left
      // out of it. The mover keeps the dragging of the content, it is not touched here
      addEventListener(MouseEvent.ROLL_OVER, listRollOver);
      addEventListener(MouseEvent.ROLL_OUT, listRollOut);
      arrayLabels = new Array();
      arrayValues = new Array();
      arrayIcons = new Array();
      arrayTabcnts = new Array();
      selectedIndexes = new Array();
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CY_CHANGED(), reposContent);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TOP_REACHED(), topReached);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOTTOM_REACHED(), bottomReached);
      baseList.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), listResized);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.trace("<" + this + " ListPanel> constructed.", 1);
    }
    /**
     * Returns the text type of the items of this list.
     */
    public function getTextType():String
    {
      return textType;
    }
    /**
     * Returns true if this list is allowed to have nothing selected.
     */
    public function getCanBeEmpty():Boolean
    {
      return canBeEmpty;
    }
    /**
     * Allows or forbids the empty selection, and selects the very first item right away
     * when the empty selection is forbidden while nothing is selected.
     * @param e true if this list is allowed to have nothing selected
     */
    public function setCanBeEmpty(e:Boolean):void
    {
      application.trace("<" + this + " ListPanel setCanBeEmpty> called.", 1);
      application.trace("<" + this + " ListPanel setCanBeEmpty> e: " + e, 0);
      if (canBeEmpty != e)
      {
        canBeEmpty = e;
        if (keepOneItemSelected())
        {
          // the very first item has just been selected, so the marks of the items are drawn
          // again, silently: nobody has asked for that selection
          dispatchSelectedChanged(false);
        }
      }
    }
    /**
     * Returns true if more than one item of this list can be selected at the same time.
     */
    public function getMultiple():Boolean
    {
      return multiple;
    }
    /**
     * Allows or forbids the selection of more than one item. Going back to the single
     * selection keeps the first selected item only and reports the change.
     * @param m true if more than one item can be selected
     */
    public function setMultiple(m:Boolean):void
    {
      application.trace("<" + this + " ListPanel setMultiple> called.", 1);
      application.trace("<" + this + " ListPanel setMultiple> m: " + m, 0);
      if (m)
      {
        if (!multiple)
        {
          multiple = m;
        }
      }
      else
      {
        if (multiple)
        {
          if (selectedIndexes.length > 1)
          {
            selectedIndexes.splice(1);
            dispatchSelectedChanged();
          }
          multiple = m;
        }
      }
    }
    /**
     * Returns true if the changed event is dispatched even without a real change.
     */
    public function getAlwaysDispatchSelectedEvent():Boolean
    {
      return alwaysDispatchSelectedEvent;
    }
    /**
     * Tells whether the changed event has to be dispatched on every click, or only when the
     * selection really changes, which is the default.
     * @param b true if every click has to dispatch the changed event
     */
    public function setAlwaysDispatchSelectedEvent(b:Boolean):void
    {
      application.trace("<" + this + " ListPanel setAlwaysDispatchSelectedEvent> called.", 1);
      application.trace("<" + this + " ListPanel setAlwaysDispatchSelectedEvent> b: " + b, 0);
      alwaysDispatchSelectedEvent = b;
    }
    /**
     * Returns the number of the elements this list displays at the same time.
     */
    public function getNumOfElements():int
    {
      return baseList.getNumOfElements();
    }
    /**
     * Sets the number of the elements this list displays at the same time. There are never
     * more elements built than the number of the items that have been given to this list.
     * @param num the number of the elements to be displayed
     */
    public function setNumOfElements(num:int):void
    {
      application.trace("<" + this + " ListPanel setNumOfElements> called.", 1);
      application.trace("<" + this + " ListPanel setNumOfElements> num: " + num, 0);
      if (numOfElements != num && num >= 0)
      {
        numOfElements = num;
        baseList.setNumOfElements(Math.min(num, arrayLabels.length));
        reposContent(null);
      }
    }
    /**
     * Returns the indexes of the selected items, an array holding one single minus one when
     * there is nothing selected.
     */
    public function getSelectedIndexes():Array
    {
      application.trace("<" + this + " ListPanel getSelectedIndexes> called.", 1);
      const indexes:Array = new Array();
      for (var i:int = 0; i < selectedIndexes.length; i++)
      {
        indexes.push(selectedIndexes[i]);
      }
      if (indexes.length == 0)
      {
        indexes[0] = -1;
      }
      return indexes;
    }
    /**
     * Selects the items of the given indexes and reports the change. An index that no item
     * belongs to is dropped, and only the first one is kept on a single selection list. A
     * list that is not allowed to stand empty keeps its very first item selected when every
     * index it has been given has been dropped this way.
     * @param indexes the indexes of the items to be selected
     * @param fireChangedEvent whether the changed event has to be dispatched. A selection
     *                         made by the code of the application instead of the one using
     *                         it has to be a silent one: the caller knows the new value
     *                         already, and an event of it would be taken as a user action
     */
    public function setSelectedIndexes(indexes:Array, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ListPanel setSelectedIndexes> called.", 1);
      application.trace("<" + this + " ListPanel setSelectedIndexes> indexes: " + indexes, 0);
      application.trace("<" + this + " ListPanel setSelectedIndexes> fireChangedEvent: " + fireChangedEvent, 0);
      if (indexes != null && selectedIndexes != null)
      {
        selectedIndexes.splice(0);
        for (var i:int = 0; i < indexes.length; i++)
        {
          if (indexes[i] < arrayLabels.length)
          {
            selectedIndexes.push(indexes[i]);
          }
          if (selectedIndexes.length == 1 && !multiple)
          {
            break;
          }
        }
        keepOneItemSelected();
        dispatchSelectedChanged(fireChangedEvent);
      }
    }
    /**
     * Drops the selection of this list without reporting any change, and takes the marks of
     * the items that have been selected away. This is the one call emptying the selection of
     * a list that is not allowed to stand empty as well: it takes such a list back to the
     * very state it has been built in.
     */
    public function clearSelectedIndexes():void
    {
      application.trace("<" + this + " ListPanel clearSelectedIndexes> called.", 1);
      if (selectedIndexes != null)
      {
        selectedIndexes.splice(0);
        // the items that have been selected are marked no more, and no caller of this has
        // asked for a change, so the marks are drawn again without an event of them
        dispatchSelectedChanged(false);
      }
    }
    /**
     * Scrolls this list so that it displays the items from the given index. An index that
     * would leave the list half empty is corrected to the last possible one.
     * @param index the index of the first item to be displayed
     */
    public function setStartIndex(index:int):void
    {
      application.trace("<" + this + " ListPanel setStartIndex> called.", 1);
      application.trace("<" + this + " ListPanel setStartIndex> index: " + index, 0);
      if (startIndex != validStartIndex(index))
      {
        startIndex = validStartIndex(index);
        baseScroll.setContentPosition(0, -startIndex * application.getDynamicsConfig().getTextFieldHeight(baseList.getTextType()), false);
        baseListRepos();
        displayFromIndex(startIndex, false);
      }
    }
    /**
     * Gives the items of this list. The labels and the values belong to each other by their
     * indexes, the icons and the indentations are optional.
     * @param labels the text codes of the items
     * @param values the values of the items
     * @param icons the icon types of the items, no icon at all when it is null
     * @param tabcnts the numbers of the tabulators the items are indented by, none when null
     */
    public function setArrays(labels:Array, values:Array, icons:Array = null, tabcnts:Array = null):void
    {
      application.trace("<" + this + " ListPanel setArrays> called.", 1);
      application.trace("<" + this + " ListPanel setArrays> labels: " + labels, 0);
      application.trace("<" + this + " ListPanel setArrays> values: " + values, 0);
      application.trace("<" + this + " ListPanel setArrays> icons: " + icons, 0);
      application.trace("<" + this + " ListPanel setArrays> tabcnts: " + tabcnts, 0);
      arrayLabels = labels;
      arrayValues = values;
      arrayIcons = icons != null ? icons : filledArray(arrayLabels.length, "");
      arrayTabcnts = tabcnts != null ? tabcnts : filledArray(arrayLabels.length, 0);
      selectedIndexes.splice(0);
      baseList.setNumOfElements(Math.min(numOfElements, arrayLabels.length));
      setBaseScrollDhContent();
      displayFromIndex(0, false);
    }
    /**
     * Refreshes one single item of this list. A null label or a null value leaves that part
     * of the item untouched, and a negative indentation leaves the indentation untouched.
     * The icon is always taken as it is given, so a null one clears the icon of that item.
     * @param i the index of the item to be refreshed
     * @param label the new text code of that item
     * @param value the new value of that item
     * @param icon the new icon type of that item
     * @param tabcnt the new number of the tabulators that item is indented by
     */
    public function refreshItem(i:int, label:String, value:String, icon:String = null, tabcnt:int = -1):void
    {
      application.trace("<" + this + " ListPanel refreshItem> called.", 1);
      application.trace("<" + this + " ListPanel refreshItem> i: " + i, 0);
      application.trace("<" + this + " ListPanel refreshItem> label: " + label, 0);
      application.trace("<" + this + " ListPanel refreshItem> value: " + value, 0);
      application.trace("<" + this + " ListPanel refreshItem> icon: " + icon, 0);
      application.trace("<" + this + " ListPanel refreshItem> tabcnt: " + tabcnt, 0);
      if (arrayLabels != null && arrayValues != null && arrayIcons != null && arrayTabcnts != null)
      {
        if (i < arrayLabels.length)
        {
          if (label != null)
          {
            arrayLabels[i] = label;
          }
          if (value != null)
          {
            arrayValues[i] = value;
          }
          arrayIcons[i] = icon;
          if (tabcnt > -1)
          {
            arrayTabcnts[i] = tabcnt;
          }
          displayFromIndex(startIndex, false);
        }
      }
    }
    /**
     * Returns the text codes of the items of this list.
     */
    public function getArrayLabels():Array
    {
      return arrayLabels;
    }
    /**
     * Returns the values of the items of this list.
     */
    public function getArrayValues():Array
    {
      return arrayValues;
    }
    /**
     * Returns the icon types of the items of this list.
     */
    public function getArrayIcons():Array
    {
      return arrayIcons;
    }
    /**
     * Returns the numbers of the tabulators the items of this list are indented by.
     */
    public function getArrayTabcnts():Array
    {
      return arrayTabcnts;
    }
    /**
     * Enables or disables this list: a disabled list does not follow the mouse any more.
     * @param e true if this list has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " ListPanel setEnabled> called.", 1);
      application.trace("<" + this + " ListPanel setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (getEnabled())
      {
        addEventListener(MouseEvent.ROLL_OVER, listRollOver);
      }
      else
      {
        // the roll out has to run as well, otherwise a list disabled while the mouse stands
        // over it would keep following that mouse and would keep the mark of one item
        listRollOut(null);
        removeEventListener(MouseEvent.ROLL_OVER, listRollOver);
      }
    }
    /**
     * Sets the width of this list, of its scroll and of the list inside it.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ListPanel setDw> called.", 1);
      application.trace("<" + this + " ListPanel setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        baseScroll.setDw(getDw());
        baseList.setDw(getDw() - 2 * application.getDynamicsConfig().getAppPadding());
      }
    }
    /**
     * The height of this list comes from the number of the displayed elements, so it does
     * nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ListPanel setDh> called.", 1);
      application.trace("<" + this + " ListPanel setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ListPanel setDh> do nothing.", 1);
    }
    /**
     * The height of this list comes from the number of the displayed elements, so it does
     * nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ListPanel setDwh> called.", 1);
      application.trace("<" + this + " ListPanel setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ListPanel setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ListPanel setDwh> do nothing.", 1);
    }
    /**
     * Selects the very first item of this list when the selection has been left empty while
     * the empty selection is forbidden, and tells whether it has selected it: a list of that
     * rule stands with one item selected instead of standing with none of them. An empty
     * list is left alone, because there is no item to be selected in it at all.
     */
    private function keepOneItemSelected():Boolean
    {
      application.trace("<" + this + " ListPanel keepOneItemSelected> called.", 1);
      if (!canBeEmpty && selectedIndexes.length == 0 && arrayLabels.length > 0)
      {
        selectedIndexes.push(0);
        return true;
      }
      return false;
    }
    /**
     * Returns a new array of the given length, every item of it holding the given value.
     * @param length the length of the new array
     * @param value the value every item of the new array holds
     */
    private function filledArray(length:int, value:Object):Array
    {
      application.trace("<" + this + " ListPanel filledArray> called.", 1);
      application.trace("<" + this + " ListPanel filledArray> length: " + length, 0);
      application.trace("<" + this + " ListPanel filledArray> value: " + value, 0);
      const filled:Array = new Array(length);
      for (var i:int = 0; i < filled.length; i++)
      {
        filled[i] = value;
      }
      return filled;
    }
    /**
     * Returns the given start index corrected so that the list never stays half empty.
     * @param index the start index to be checked
     */
    private function validStartIndex(index:int):int
    {
      application.trace("<" + this + " ListPanel validStartIndex> called.", 1);
      application.trace("<" + this + " ListPanel validStartIndex> index: " + index, 0);
      return Math.max(0, Math.min(index, arrayLabels.length - baseList.getNumOfElements()));
    }
    /**
     * Displays the very first items of this list when the scroll has reached its top.
     * @param e the top reached event of the scroll
     */
    private function topReached(e:Event):void
    {
      application.trace("<" + this + " ListPanel topReached> called.", 1);
      application.trace("<" + this + " ListPanel topReached> e: " + e, 0);
      startIndex = 0;
      displayFromIndex(startIndex, false);
    }
    /**
     * Displays the very last items of this list when the scroll has reached its bottom.
     * @param e the bottom reached event of the scroll
     */
    private function bottomReached(e:Event):void
    {
      application.trace("<" + this + " ListPanel bottomReached> called.", 1);
      application.trace("<" + this + " ListPanel bottomReached> e: " + e, 0);
      startIndex = arrayLabels.length - baseList.getNumOfElements();
      displayFromIndex(startIndex, false);
    }
    /**
     * Displays the items belonging to the new position of the scrolled content.
     * @param e the content y coordinate changed event of the scroll, null if called by hand
     */
    private function reposContent(e:Event):void
    {
      application.trace("<" + this + " ListPanel reposContent> called.", 1);
      application.trace("<" + this + " ListPanel reposContent> e: " + e, 0);
      displayFromIndex(-Math.round(baseScroll.getCyContent() / application.getDynamicsConfig().getTextFieldHeight(baseList.getTextType())), false);
      baseListRepos();
    }
    /**
     * Positions the list to the masked area of the scroll.
     */
    private function baseListRepos():void
    {
      application.trace("<" + this + " ListPanel baseListRepos> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      baseList.setCx(baseScroll.getMask().x + padding - lineThickness);
      baseList.setCy(baseScroll.getMask().y + padding - lineThickness);
    }
    /**
     * Takes the dimensions the resized list needs, a padding around it on every side.
     * @param e the dimensions changed event of the list
     */
    private function listResized(e:Event):void
    {
      application.trace("<" + this + " ListPanel listResized> called.", 1);
      application.trace("<" + this + " ListPanel listResized> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      baseScroll.setDwh(baseList.getDw() + 2 * padding, baseList.getDh() + 2 * padding);
      super.setDwh(baseScroll.getDw(), baseScroll.getDh());
      setBaseScrollDhContent();
      displayFromIndex(0, false);
    }
    /**
     * Tells the scroll how tall the whole list of the items would be.
     */
    private function setBaseScrollDhContent():void
    {
      application.trace("<" + this + " ListPanel setBaseScrollDhContent> called.", 1);
      if (baseScroll != null)
      {
        baseScroll.setDhContent(arrayLabels.length * application.getDynamicsConfig().getTextFieldHeight(baseList.getTextType())
          + application.getDynamicsConfig().getAppLineThickness() + application.getDynamicsConfig().getAppPadding());
      }
    }
    /**
     * Puts the items standing from the given index into the elements of the list and marks
     * them afterwards.
     * @param index the index of the first item to be displayed
     * @param buttonDown true if the mouse button is held down at the moment
     */
    private function displayFromIndex(index:int, buttonDown:Boolean):void
    {
      application.trace("<" + this + " ListPanel displayFromIndex> called.", 1);
      application.trace("<" + this + " ListPanel displayFromIndex> index: " + index, 0);
      application.trace("<" + this + " ListPanel displayFromIndex> buttonDown: " + buttonDown, 0);
      startIndex = validStartIndex(index);
      for (var i:int = 0; i < baseList.getNumOfElements(); i++)
      {
        baseList.setLabel(i, arrayLabels[i + startIndex], arrayIcons[i + startIndex], arrayTabcnts[i + startIndex]);
      }
      markFromIndex(index, buttonDown);
    }
    /**
     * Marks the elements of the list: the one under the mouse softly, the selected ones and
     * the one being pressed strongly.
     * @param index the index of the first item that is displayed
     * @param buttonDown true if the mouse button is held down at the moment
     */
    private function markFromIndex(index:int, buttonDown:Boolean):void
    {
      application.trace("<" + this + " ListPanel markFromIndex> called.", 1);
      application.trace("<" + this + " ListPanel markFromIndex> index: " + index, 0);
      application.trace("<" + this + " ListPanel markFromIndex> buttonDown: " + buttonDown, 0);
      startIndex = validStartIndex(index);
      const elementIndexByMouse:int = getActualElementIndexByMouse();
      for (var i:int = 0; i < baseList.getNumOfElements(); i++)
      {
        if (elementIndexByMouse == i && !buttonDown)
        {
          baseList.markElement(i, 1);
        }
        else if (selectedIndexes.indexOf(i + startIndex) != -1 || (elementIndexByMouse == i && buttonDown))
        {
          baseList.markElement(i, 2);
        }
        else
        {
          baseList.markElement(i, 0);
        }
      }
      baseList.markElements();
    }
    /**
     * Returns the index of the element the mouse stands over, minus one when the mouse is
     * outside of this list.
     */
    private function getActualElementIndexByMouse():int
    {
      application.trace("<" + this + " ListPanel getActualElementIndexByMouse> called.", 1);
      // everything is measured in the coordinates of the list itself: the mover of the scroll
      // has no dimensions of its own at all, only a drawn hit area, and it stands away from
      // the origin of the scroll as well
      if (baseList.mouseX >= 0 && baseList.mouseX <= baseList.getDw()
        && baseList.mouseY >= 0 && baseList.mouseY <= baseList.getDh())
      {
        // every element begins at its own index times the height of one text field
        const index:int = Math.floor(baseList.mouseY / application.getDynamicsConfig().getTextFieldHeight(baseList.getTextType()));
        application.trace("<" + this + " ListPanel getActualElementIndexByMouse> index: " + index, 0);
        return index >= 0 && index < baseList.getNumOfElements() ? index : -1;
      }
      else
      {
        return -1;
      }
    }
    /**
     * Sorts the selected indexes, refreshes the marks and reports the change.
     * @param fireChangedEvent whether the changed event has to be dispatched
     */
    private function dispatchSelectedChanged(fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ListPanel dispatchSelectedChanged> called.", 1);
      application.trace("<" + this + " ListPanel dispatchSelectedChanged> fireChangedEvent: " + fireChangedEvent, 0);
      selectedIndexes.sort();
      // the redrawing below happens in every case: the newly selected items have to be
      // displayed as the selected ones whoever has selected them
      displayFromIndex(startIndex, false);
      if (fireChangedEvent)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Starts to follow the mouse as soon as it has come over this list. The move, the down
     * and the click are listened to between the roll over and the roll out only, so that a
     * list the mouse is nowhere near does not follow every single movement of it.
     * @param e the roll over event of this list
     */
    private function listRollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " ListPanel listRollOver> called.", 1);
      application.trace("<" + this + " ListPanel listRollOver> e: " + e, 0);
      addEventListener(MouseEvent.MOUSE_MOVE, listMouseMove);
      addEventListener(MouseEvent.MOUSE_DOWN, listMouseDown);
      addEventListener(MouseEvent.CLICK, listMouseClick);
    }
    /**
     * Stops following the mouse and drops the mark of the item it stood over.
     * @param e the roll out event of this list
     */
    private function listRollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " ListPanel listRollOut> called.", 1);
      application.trace("<" + this + " ListPanel listRollOut> e: " + e, 0);
      removeEventListener(MouseEvent.MOUSE_MOVE, listMouseMove);
      removeEventListener(MouseEvent.MOUSE_DOWN, listMouseDown);
      removeEventListener(MouseEvent.CLICK, listMouseClick);
      displayFromIndex(startIndex, false);
    }
    /**
     * Marks the item the mouse stands over, or the one it presses.
     * @param e the mouse move event of this list
     */
    private function listMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " ListPanel listMouseMove> called.", 0);
      if (e.buttonDown)
      {
        displayFromIndex(startIndex, true);
      }
      else
      {
        markFromIndex(startIndex, false);
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Stores where the pressing has begun, so that a dragging can be told from a click.
     * @param e the mouse down event of this list
     */
    private function listMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " ListPanel listMouseDown> called.", 1);
      application.trace("<" + this + " ListPanel listMouseDown> e: " + e, 0);
      origMouseX = int(mouseX);
      origMouseY = int(mouseY);
      displayFromIndex(startIndex, true);
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Selects or deselects the clicked item. The mouse has to stay inside the click gap,
     * otherwise the movement was a scrolling and not a click. Every real change of the
     * selection is reported, the deselection of an item among them, and a click changing
     * nothing at all is only reported when this list has been asked to report every one of
     * them: the one selected item of a list that can not stand empty is such a click.
     * @param e the click event of this list
     */
    private function listMouseClick(e:MouseEvent):void
    {
      application.trace("<" + this + " ListPanel listMouseClick> called.", 1);
      application.trace("<" + this + " ListPanel listMouseClick> e: " + e, 0);
      const clickGap:int = application.getComponentsConfig().getClickGap();
      const elementIndexByMouse:int = getActualElementIndexByMouse();
      if (Math.abs(origMouseX - int(mouseX)) < clickGap && Math.abs(origMouseY - int(mouseY)) < clickGap
        && mouseX > baseList.getCx() && mouseX < baseList.getCx(true)
        && mouseY > baseList.getCy() && mouseY < baseList.getCy(true)
        && elementIndexByMouse != -1)
      {
        const clickedIndex:int = startIndex + elementIndexByMouse;
        if (selectedIndexes.indexOf(clickedIndex) != -1)
        {
          if (selectedIndexes.length >= 2 || canBeEmpty)
          {
            // the clicked item leaves the selection, and that is a change of it, so it is
            // reported the very same way an item arriving into that selection is
            selectedIndexes.splice(selectedIndexes.indexOf(clickedIndex), 1);
            dispatchSelectedChanged();
          }
          else if (alwaysDispatchSelectedEvent)
          {
            // the one selected item of a list that is not allowed to stand empty stays
            // where it is, so there is nothing to report besides the click itself
            dispatchSelectedChanged();
          }
        }
        else if (multiple)
        {
          selectedIndexes.push(clickedIndex);
          dispatchSelectedChanged();
        }
        else if (selectedIndexes[0] != clickedIndex)
        {
          selectedIndexes[0] = clickedIndex;
          dispatchSelectedChanged();
        }
        else if (alwaysDispatchSelectedEvent)
        {
          dispatchSelectedChanged();
        }
      }
      if (e != null)
      {
        e.updateAfterEvent();
      }
    }
    /**
     * Repositions and resizes everything after the padding of the application has changed.
     * @param e the padding changed event
     */
    private function paddingChanged(e:Event):void
    {
      application.trace("<" + this + " ListPanel paddingChanged> called.", 1);
      application.trace("<" + this + " ListPanel paddingChanged> e: " + e, 0);
      if (application != null)
      {
        setBaseScrollDhContent();
        baseList.setDw(getDw() - 2 * application.getDynamicsConfig().getAppPadding());
        baseListRepos();
      }
    }
    /**
     * Repositions everything after the line thickness of the application has changed.
     * @param e the line thickness changed event
     */
    private function lineThicknessChanged(e:Event):void
    {
      application.trace("<" + this + " ListPanel lineThicknessChanged> called.", 1);
      application.trace("<" + this + " ListPanel lineThicknessChanged> e: " + e, 0);
      if (application != null)
      {
        setBaseScrollDhContent();
        baseListRepos();
      }
    }
    /**
     * Frees all listeners, events and references held by this list.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ListPanel destroy> called.", 1);
      application.trace("<" + this + " ListPanel destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(MouseEvent.ROLL_OVER, listRollOver);
      removeEventListener(MouseEvent.ROLL_OUT, listRollOut);
      removeEventListener(MouseEvent.MOUSE_MOVE, listMouseMove);
      removeEventListener(MouseEvent.MOUSE_DOWN, listMouseDown);
      removeEventListener(MouseEvent.CLICK, listMouseClick);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.trace("<" + this + " ListPanel destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      selectedIndexes.splice(0);
      application.trace("<" + this + " ListPanel destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textType = null;
      baseList = null;
      baseScroll = null;
      arrayLabels = null;
      arrayValues = null;
      arrayIcons = null;
      arrayTabcnts = null;
      selectedIndexes = null;
      multiple = false;
      canBeEmpty = false;
      alwaysDispatchSelectedEvent = false;
      startIndex = 0;
      numOfElements = 0;
      origMouseX = 0;
      origMouseY = 0;
      eventChanged = null;
    }
  }
}
