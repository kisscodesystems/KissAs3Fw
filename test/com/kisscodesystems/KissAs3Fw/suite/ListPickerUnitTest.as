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
 * ListPickerUnitTest
 * Checks the ListPicker component.
 *
 * MAIN FEATURES:
 * - the label of the selected item arrives onto the button of this picker
 * - the list opens and closes, and the height of the label comes back on closing
 * - the selection reports every change of it, but the clearing of it reports nothing
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ListPickerUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ListPickerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ListPicker";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const listPicker:ListPicker = new ListPicker(application);
      addTested(listPicker);
      listPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), listPickerChanged);
      // a fresh picker is a closed one that has nothing selected
      assertFalse("isOpened of a fresh ListPicker", listPicker.isOpened());
      assertEquals("getTextType of a fresh ListPicker"
        , EnumTextTypes.TEXT_TYPE_MID(), listPicker.getTextType());
      assertEquals("getSelectedIndex of a fresh ListPicker", -1, listPicker.getSelectedIndex());
      assertEquals("getSelectedValue of a fresh ListPicker", "", listPicker.getSelectedValue());
      // the width is taken, the height comes from the label of the button
      listPicker.setDw(240);
      assertEquals("getDw after setDw(240)", expectedDw(240), listPicker.getDw());
      // the items of the list of this picker
      const labels:Array = ["the item 0", "the item 1", "the item 2"
        , "the item 3", "the item 4", "the item 5"];
      const values:Array = ["value0", "value1", "value2", "value3", "value4", "value5"];
      // every second item carries an icon, so the label of the button has to display one as
      // well as it has to stand without one
      const icons:Array = [EnumIcons.ok1(), "", EnumIcons.ok1(), "", EnumIcons.ok1(), ""];
      listPicker.setNumOfElements(3);
      listPicker.setArrays(labels, values, icons);
      assertEquals("getArrayLabels holds every item", 6, listPicker.getArrayLabels().length);
      assertEquals("the first item of getArrayLabels", "the item 0", listPicker.getArrayLabels()[0]);
      assertEquals("the first item of getArrayValues", "value0", listPicker.getArrayValues()[0]);
      // the label of the selected item arrives onto the button of this picker
      listPicker.setSelectedIndex(2);
      assertEquals("getSelectedIndex after setSelectedIndex(2)", 2, listPicker.getSelectedIndex());
      assertEquals("getSelectedValue of the selected item", "value2", listPicker.getSelectedValue());
      assertEquals("getText of the label of the button", "the item 2", listPicker.getText());
      assertEquals("one changed event after a set of the selection", 1, changedCount);
      // the very same index changes nothing
      listPicker.setSelectedIndex(2);
      assertEquals("the very same index dispatches no changed event", 1, changedCount);
      // a silent selection reaches the button of this picker as well, only the changed
      // event of it stays away: a displayed value has to be the selected one in every case
      listPicker.setSelectedIndex(1, false);
      assertEquals("getSelectedIndex after a silent setSelectedIndex(1)", 1, listPicker.getSelectedIndex());
      assertEquals("getText of the button after a silent setSelectedIndex", "the item 1", listPicker.getText());
      assertEquals("getSelectedValue after a silent setSelectedIndex", "value1", listPicker.getSelectedValue());
      assertEquals("no changed event after a silent setSelectedIndex", 1, changedCount);
      listPicker.setSelectedIndex(2, false);
      // an index that no item belongs to is dropped, and the list of this picker is not
      // allowed to stand empty, so its very first item stays the selected one
      listPicker.setSelectedIndex(99);
      assertEquals("getSelectedIndex after an index that no item belongs to"
        , 0, listPicker.getSelectedIndex());
      assertEquals("getText after an index that no item belongs to"
        , "the item 0", listPicker.getText());
      assertEquals("two changed events after the dropped index", 2, changedCount);
      listPicker.setSelectedIndex(4);
      assertEquals("getSelectedValue after the selection has come back", "value4", listPicker.getSelectedValue());
      // the open picker is as tall as its list, the closed one as tall as its label
      const closedDh:int = listPicker.getDh();
      listPicker.open();
      assertTrue("isOpened after open", listPicker.isOpened());
      assertTrue("the open ListPicker is taller than its label", listPicker.getDh() > closedDh);
      listPicker.close();
      assertFalse("isOpened after close", listPicker.isOpened());
      assertEquals("the closed ListPicker is as tall as its label again", closedDh, listPicker.getDh());
      // the height comes from the label or from the open list, so its setters do nothing
      listPicker.setDh(900);
      listPicker.setDwh(900, 900);
      assertEquals("setDh and setDwh do not change the height", closedDh, listPicker.getDh());
      assertEquals("setDwh does not change the width", expectedDw(240), listPicker.getDw());
      // the changed event can be asked for on every selection
      listPicker.setAlwaysDispatchSelectedEvent(true);
      listPicker.setAlwaysDispatchSelectedEvent(false);
      // the clearing of the selection empties the label and reports nothing
      changedCount = 0;
      listPicker.clearSelectedIndex();
      assertEquals("getSelectedIndex after clearSelectedIndex", -1, listPicker.getSelectedIndex());
      assertEquals("getText after clearSelectedIndex", "", listPicker.getText());
      assertEquals("getSelectedValue after clearSelectedIndex", "", listPicker.getSelectedValue());
      assertEquals("the clearing of the selection dispatches no changed event", 0, changedCount);
      runBaseSpriteTests(listPicker);
      listPicker.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), listPickerChanged);
      removeTested(listPicker);
    }
    /**
     * Counts the changed events of the tested picker.
     * @param e the changed event
     */
    private function listPickerChanged(e:Event):void
    {
      changedCount++;
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      changedCount = 0;
    }
  }
}
