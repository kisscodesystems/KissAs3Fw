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
 * ListPicker.
 * A button displaying the selected item of a list that opens below it.
 *
 * MAIN FEATURES:
 * - the label of the button is the label of the selected item, together with its icon
 * - exactly one item is selected, the list of the items can not be left empty
 * - the list opens on a click and closes as soon as an item has been selected
 * - the closed picker is as tall as its label, the open one is as tall as its list
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseOpen;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class ListPicker extends BaseOpen
  {
    private var textLabel:TextLabel = null;
    private var list:ListPanel = null;
    private var eventChanged:Event = null;
    /**
     * Constructs the ListPicker object and builds up its label and its list.
     * @param applicationRef the main application reference
     */
    public function ListPicker(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ListPicker> called.", 1);
      application.trace("<" + this + " ListPicker> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      textLabel = new TextLabel(application);
      baseWorkingButton.getContentSprite().addChild(textLabel);
      reposResizeLabel();
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      list = new ListPanel(application);
      contentSprite.addChild(list);
      list.setMultiple(false);
      list.setCanBeEmpty(false);
      list.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), selectedItemChanged);
      list.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), listResized);
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ListPicker> constructed.", 1);
    }
    /**
     * Returns the text type of the label of this picker.
     */
    public function getTextType():String
    {
      return textLabel.getType();
    }
    /**
     * Returns the displayed text of the label of this picker.
     */
    public function getText():String
    {
      return textLabel.getBaseTextField().getText();
    }
    /**
     * Returns the index of the selected item, minus one when there is nothing selected.
     */
    public function getSelectedIndex():int
    {
      return list.getSelectedIndexes()[0];
    }
    /**
     * Selects the item of the given index.
     * @param index the index of the item to be selected
     * @param fireChangedEvent whether the changed event has to be dispatched. A selection
     *                         made by the code of the application instead of the one using
     *                         it has to be a silent one: the caller knows the new value
     *                         already, and an event of it would be taken as a user action
     */
    public function setSelectedIndex(index:int, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ListPicker setSelectedIndex> called.", 1);
      application.trace("<" + this + " ListPicker setSelectedIndex> index: " + index, 0);
      application.trace("<" + this + " ListPicker setSelectedIndex> fireChangedEvent: " + fireChangedEvent, 0);
      if (getSelectedIndex() != index)
      {
        list.setSelectedIndexes([index], fireChangedEvent);
        if (!fireChangedEvent)
        {
          // the changed event of the list is the one refreshing the button of this
          // picker, and that event has not been dispatched, so it is refreshed here
          displaySelectedItem();
        }
        if (index < 0)
        {
          textLabel.destIcon();
        }
      }
    }
    /**
     * Drops the selection of this picker and empties its label.
     */
    public function clearSelectedIndex():void
    {
      application.trace("<" + this + " ListPicker clearSelectedIndex> called.", 1);
      list.clearSelectedIndexes();
      textLabel.destIcon();
      textLabel.setLabel("");
    }
    /**
     * Returns the value of the selected item, an empty string when there is nothing selected.
     */
    public function getSelectedValue():String
    {
      application.trace("<" + this + " ListPicker getSelectedValue> called.", 1);
      if (getSelectedIndex() != -1 && list != null)
      {
        if (list.getArrayValues() != null)
        {
          if (getSelectedIndex() < list.getArrayValues().length)
          {
            return list.getArrayValues()[getSelectedIndex()];
          }
        }
      }
      return "";
    }
    /**
     * Tells whether the changed event has to be dispatched on every selection, or only when
     * the selected item really changes, which is the default.
     * @param b true if every selection has to dispatch the changed event
     */
    public function setAlwaysDispatchSelectedEvent(b:Boolean):void
    {
      application.trace("<" + this + " ListPicker setAlwaysDispatchSelectedEvent> called.", 1);
      application.trace("<" + this + " ListPicker setAlwaysDispatchSelectedEvent> b: " + b, 0);
      if (list != null)
      {
        list.setAlwaysDispatchSelectedEvent(b);
      }
    }
    /**
     * Sets the number of the items the open list displays at the same time.
     * @param num the number of the elements to be displayed
     */
    public function setNumOfElements(num:int):void
    {
      application.trace("<" + this + " ListPicker setNumOfElements> called.", 1);
      application.trace("<" + this + " ListPicker setNumOfElements> num: " + num, 0);
      list.setNumOfElements(num);
    }
    /**
     * Gives the items of the list of this picker.
     * @param labels the text codes of the items
     * @param values the values of the items
     * @param icons the icon types of the items, no icon at all when it is null
     */
    public function setArrays(labels:Array, values:Array, icons:Array = null):void
    {
      application.trace("<" + this + " ListPicker setArrays> called.", 1);
      application.trace("<" + this + " ListPicker setArrays> labels: " + labels, 0);
      application.trace("<" + this + " ListPicker setArrays> values: " + values, 0);
      application.trace("<" + this + " ListPicker setArrays> icons: " + icons, 0);
      list.setArrays(labels, values, icons);
    }
    /**
     * Returns the text codes of the items of the list of this picker.
     */
    public function getArrayLabels():Array
    {
      return list.getArrayLabels();
    }
    /**
     * Returns the values of the items of the list of this picker.
     */
    public function getArrayValues():Array
    {
      return list.getArrayValues();
    }
    /**
     * Opens the list of this picker, scrolled to the selected item.
     */
    override public function open():void
    {
      application.trace("<" + this + " ListPicker open> called.", 1);
      list.setStartIndex(Math.min(list.getArrayLabels().length - list.getNumOfElements(), getSelectedIndex()));
      super.setDh(contentSprite.getDh());
      super.open();
    }
    /**
     * Closes the list of this picker and takes the height of its label back.
     */
    override public function close():void
    {
      application.trace("<" + this + " ListPicker close> called.", 1);
      super.close();
      dhToLabel();
    }
    /**
     * Sets the width of this picker, of its label and of its list.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ListPicker setDw> called.", 1);
      application.trace("<" + this + " ListPicker setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        reposResizeLabel();
        list.setDw(getDw());
      }
    }
    /**
     * The height of this picker comes from its label or from its open list, so it does
     * nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ListPicker setDh> called.", 1);
      application.trace("<" + this + " ListPicker setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ListPicker setDh> do nothing.", 1);
    }
    /**
     * The height of this picker comes from its label or from its open list, so it does
     * nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ListPicker setDwh> called.", 1);
      application.trace("<" + this + " ListPicker setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ListPicker setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ListPicker setDwh> do nothing.", 1);
    }
    /**
     * Closes the list and displays the label and the icon of the item that has been selected.
     * @param e the changed event of the list
     */
    private function selectedItemChanged(e:Event):void
    {
      application.trace("<" + this + " ListPicker selectedItemChanged> called.", 1);
      application.trace("<" + this + " ListPicker selectedItemChanged> e: " + e, 0);
      close();
      displaySelectedItem();
      dispatchEventChanged();
    }
    /**
     * Displays the label and the icon of the selected item on the button of this picker,
     * or an empty label when there is nothing selected. A silent selection comes here as
     * well: the newly selected item has to be displayed whoever has selected it.
     */
    private function displaySelectedItem():void
    {
      application.trace("<" + this + " ListPicker displaySelectedItem> called.", 1);
      if (getSelectedIndex() != -1)
      {
        textLabel.setLabel(list.getArrayLabels()[getSelectedIndex()]);
        if (list.getArrayIcons() != null && list.getArrayIcons()[getSelectedIndex()] != null)
        {
          textLabel.setIcon(list.getArrayIcons()[getSelectedIndex()]);
        }
        else
        {
          textLabel.destIcon();
        }
      }
      else
      {
        textLabel.destIcon();
        textLabel.setLabel("");
      }
    }
    /**
     * Takes the dimensions of the resized list, and the height of it as well when the list
     * is the open one at the moment.
     * @param e the dimensions changed event of the list
     */
    private function listResized(e:Event):void
    {
      application.trace("<" + this + " ListPicker listResized> called.", 1);
      application.trace("<" + this + " ListPicker listResized> e: " + e, 0);
      contentSprite.setDwh(list.getDw(), list.getDh());
      if (isOpened())
      {
        super.setDwh(list.getDw(), list.getDh());
      }
    }
    /**
     * Takes the height of the label back after the label or the padding has been changed,
     * but only while the list is closed, because an open list owns the height.
     * @param e the dimensions changed event of the label or the padding changed event
     */
    private function resize(e:Event):void
    {
      application.trace("<" + this + " ListPicker resize> called.", 1);
      application.trace("<" + this + " ListPicker resize> e: " + e, 0);
      if (application != null && !isOpened())
      {
        dhToLabel();
        reposResizeLabel();
      }
    }
    /**
     * Sets the height of this picker to the height its label needs.
     */
    private function dhToLabel():void
    {
      application.trace("<" + this + " ListPicker dhToLabel> called.", 1);
      super.setDh(textLabel.getDh() + 2 * application.getDynamicsConfig().getAppPadding());
    }
    /**
     * Repositions and resizes the label of this picker inside the button of it.
     */
    private function reposResizeLabel():void
    {
      application.trace("<" + this + " ListPicker reposResizeLabel> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setMaxWidth(getDw() - 2 * padding, false);
      textLabel.setCxy(padding, padding);
    }
    /**
     * Dispatches the changed event of this picker.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " ListPicker dispatchEventChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Frees all listeners, events and references held by this picker.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ListPicker destroy> called.", 1);
      application.trace("<" + this + " ListPicker destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ListPicker destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " ListPicker destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textLabel = null;
      list = null;
      eventChanged = null;
    }
  }
}
