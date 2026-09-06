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
 * ListPanelUnitTest
 * Checks the ListPanel component.
 *
 * MAIN FEATURES:
 * - the items of the list, the optional icons and the optional indentations
 * - the single and the multiple selection, and the list that must not stand empty
 * - the selection reports every change of it, the deselection of a clicked item among
 *   them, but the clearing of it reports nothing
 * - the height comes from the number of the displayed elements, so its setters do nothing
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class ListPanelUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ListPanelUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ListPanel";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const listPanel:ListPanel = new ListPanel(application);
      addTested(listPanel);
      listPanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), listPanelChanged);
      // a fresh list is an empty single selection one that is allowed to stand empty
      assertEquals("getTextType of a fresh ListPanel"
        , EnumTextTypes.TEXT_TYPE_MID(), listPanel.getTextType());
      assertFalse("getMultiple of a fresh ListPanel", listPanel.getMultiple());
      assertFalse("getCanBeEmpty of a fresh ListPanel", listPanel.getCanBeEmpty());
      assertFalse("getAlwaysDispatchSelectedEvent of a fresh ListPanel"
        , listPanel.getAlwaysDispatchSelectedEvent());
      assertEquals("getNumOfElements of a fresh ListPanel", 0, listPanel.getNumOfElements());
      assertEquals("getSelectedIndexes of a fresh ListPanel holds one single item"
        , 1, listPanel.getSelectedIndexes().length);
      assertEquals("getSelectedIndexes of a fresh ListPanel is a minus one"
        , -1, listPanel.getSelectedIndexes()[0]);
      // the width is taken, the height comes from the number of the displayed elements
      listPanel.setDw(240);
      assertEquals("getDw after setDw(240)", expectedDw(240), listPanel.getDw());
      const dhBefore:int = listPanel.getDh();
      listPanel.setDh(900);
      listPanel.setDwh(900, 900);
      assertEquals("setDh and setDwh do not change the height", dhBefore, listPanel.getDh());
      assertEquals("setDwh does not change the width", expectedDw(240), listPanel.getDw());
      // there are never more elements built than the number of the items the list holds, so
      // an empty list displays nothing at all no matter how many elements it has been asked for
      listPanel.setNumOfElements(4);
      assertEquals("getNumOfElements of an empty ListPanel", 0, listPanel.getNumOfElements());
      // the items of the list, with the icons and the indentations left out
      const labels:Array = ["the item 0", "the item 1", "the item 2"
        , "the item 3", "the item 4", "the item 5"];
      const values:Array = ["value0", "value1", "value2", "value3", "value4", "value5"];
      listPanel.setArrays(labels, values);
      assertEquals("getNumOfElements after the items have arrived", 4, listPanel.getNumOfElements());
      assertEquals("getArrayLabels holds every item", 6, listPanel.getArrayLabels().length);
      assertEquals("the first item of getArrayLabels", "the item 0", listPanel.getArrayLabels()[0]);
      assertEquals("the first item of getArrayValues", "value0", listPanel.getArrayValues()[0]);
      assertEquals("getArrayIcons is filled up when no icon has arrived"
        , 6, listPanel.getArrayIcons().length);
      assertEquals("the items have no icon", "", listPanel.getArrayIcons()[0]);
      assertEquals("getArrayTabcnts is filled up when no indentation has arrived"
        , 6, listPanel.getArrayTabcnts().length);
      assertEquals("the items are not indented", 0, listPanel.getArrayTabcnts()[0]);
      // a number of the elements below zero is dropped
      listPanel.setNumOfElements(-1);
      assertEquals("getNumOfElements after a number below zero", 4, listPanel.getNumOfElements());
      // the icons and the indentations of the items can be given as well
      const icons:Array = [EnumIcons.ok1(), "", EnumIcons.ok1(), "", EnumIcons.ok1(), ""];
      const tabcnts:Array = [0, 1, 0, 1, 0, 1];
      listPanel.setArrays(labels, values, icons, tabcnts);
      assertEquals("the icon of the first item", EnumIcons.ok1(), listPanel.getArrayIcons()[0]);
      assertEquals("the indentation of the second item", 1, listPanel.getArrayTabcnts()[1]);
      // one single item can be refreshed, and the icon is always taken as it has been given
      listPanel.refreshItem(1, "the refreshed item 1", "value1refreshed", null, 2);
      assertEquals("the refreshed label", "the refreshed item 1", listPanel.getArrayLabels()[1]);
      assertEquals("the refreshed value", "value1refreshed", listPanel.getArrayValues()[1]);
      assertNull("the cleared icon of the refreshed item", listPanel.getArrayIcons()[1]);
      assertEquals("the refreshed indentation", 2, listPanel.getArrayTabcnts()[1]);
      // a null label, a null value and an indentation below zero leave those parts untouched
      listPanel.refreshItem(1, null, null, "", -1);
      assertEquals("a null label leaves the label untouched"
        , "the refreshed item 1", listPanel.getArrayLabels()[1]);
      assertEquals("a null value leaves the value untouched"
        , "value1refreshed", listPanel.getArrayValues()[1]);
      assertEquals("an indentation below zero leaves the indentation untouched"
        , 2, listPanel.getArrayTabcnts()[1]);
      // an item that does not exist is dropped
      listPanel.refreshItem(99, "the item that does not exist", "value99");
      assertEquals("an item that does not exist adds nothing", 6, listPanel.getArrayLabels().length);
      // a single selection list keeps the first index only, and it reports the change
      changedCount = 0;
      listPanel.setSelectedIndexes([1, 3]);
      assertEquals("a single selection list keeps one index only"
        , 1, listPanel.getSelectedIndexes().length);
      assertEquals("the kept index of the single selection list", 1, listPanel.getSelectedIndexes()[0]);
      assertEquals("one changed event after a set of the selection", 1, changedCount);
      // a silent selection is displayed without a changed event of it
      listPanel.setSelectedIndexes([3], false);
      assertEquals("the index of a silent selection", 3, listPanel.getSelectedIndexes()[0]);
      assertEquals("no changed event after a silent selection", 1, changedCount);
      listPanel.setSelectedIndexes([1], false);
      // more than one item can be selected at the same time
      listPanel.setMultiple(true);
      assertTrue("getMultiple after setMultiple(true)", listPanel.getMultiple());
      listPanel.setSelectedIndexes([1, 3]);
      assertEquals("a multiple selection list keeps every index"
        , 2, listPanel.getSelectedIndexes().length);
      // an index that no item belongs to is dropped
      listPanel.setSelectedIndexes([2, 99]);
      assertEquals("an index that no item belongs to is dropped"
        , 1, listPanel.getSelectedIndexes().length);
      assertEquals("the index that has been kept", 2, listPanel.getSelectedIndexes()[0]);
      // going back to the single selection keeps the first selected item only and reports it
      listPanel.setSelectedIndexes([2, 4]);
      changedCount = 0;
      listPanel.setMultiple(false);
      assertFalse("getMultiple after setMultiple(false)", listPanel.getMultiple());
      assertEquals("the single selection list has one index left"
        , 1, listPanel.getSelectedIndexes().length);
      assertEquals("the index that has been left", 2, listPanel.getSelectedIndexes()[0]);
      assertEquals("one changed event after the selection has been cut", 1, changedCount);
      // the clearing of the selection reports nothing
      changedCount = 0;
      listPanel.clearSelectedIndexes();
      assertEquals("getSelectedIndexes after clearSelectedIndexes"
        , -1, listPanel.getSelectedIndexes()[0]);
      assertEquals("the clearing of the selection dispatches no changed event", 0, changedCount);
      // a list that must not stand empty selects its very first item right away
      listPanel.setCanBeEmpty(true);
      assertTrue("getCanBeEmpty after setCanBeEmpty(true)", listPanel.getCanBeEmpty());
      listPanel.clearSelectedIndexes();
      listPanel.setCanBeEmpty(false);
      assertFalse("getCanBeEmpty after setCanBeEmpty(false)", listPanel.getCanBeEmpty());
      assertEquals("a list that must not stand empty selects its first item"
        , 0, listPanel.getSelectedIndexes()[0]);
      // such a list keeps one item selected: a set of the indexes can not empty it, neither
      // with no index at all nor with an index that no item belongs to
      listPanel.setSelectedIndexes([3], false);
      listPanel.setSelectedIndexes([], false);
      assertEquals("an empty set of the indexes keeps one item selected"
        , 1, listPanel.getSelectedIndexes().length);
      assertEquals("the item that has been kept selected", 0, listPanel.getSelectedIndexes()[0]);
      listPanel.setSelectedIndexes([3], false);
      listPanel.setSelectedIndexes([99], false);
      assertEquals("an index that no item belongs to keeps the first item selected"
        , 0, listPanel.getSelectedIndexes()[0]);
      // the clearing of the selection is the one call emptying such a list all the same
      listPanel.clearSelectedIndexes();
      assertEquals("the clearing empties the selection of such a list as well"
        , -1, listPanel.getSelectedIndexes()[0]);
      listPanel.setSelectedIndexes([0], false);
      // the changed event can be asked for on every click
      listPanel.setAlwaysDispatchSelectedEvent(true);
      assertTrue("getAlwaysDispatchSelectedEvent after setAlwaysDispatchSelectedEvent(true)"
        , listPanel.getAlwaysDispatchSelectedEvent());
      listPanel.setAlwaysDispatchSelectedEvent(false);
      // the list can be scrolled to any of its items, an index standing too far is corrected
      listPanel.setStartIndex(3);
      listPanel.setStartIndex(99);
      listPanel.setStartIndex(0);
      // a disabled list does not follow the mouse any more
      listPanel.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", listPanel.getEnabled());
      listPanel.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", listPanel.getEnabled());
      runClickTests(listPanel);
      runBaseSpriteTests(listPanel);
      listPanel.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), listPanelChanged);
      removeTested(listPanel);
    }
    /**
     * Clicks one item of the given list twice: the first click selects that item and the
     * second one takes it out of the selection, and both of those are changes the list has
     * to report. The handlers of a list read the real mouse pointer, so it is placed under
     * that very pointer here and the clicks are dispatched onto it afterwards. That pointer
     * can stand outside the window of a test run, and then no item of that list is hit at
     * all: the assertions below are only made when the first click has really selected one.
     * @param listPanel the list to be clicked
     */
    private function runClickTests(listPanel:ListPanel):void
    {
      listPanel.setMultiple(true);
      listPanel.setCanBeEmpty(true);
      listPanel.clearSelectedIndexes();
      listPanel.setCxy(int(application.stage.mouseX) - int(listPanel.getDw() / 2)
        , int(application.stage.mouseY) - int(listPanel.getDh() / 2));
      changedCount = 0;
      clickTheList(listPanel);
      if (listPanel.getSelectedIndexes()[0] == -1)
      {
        report.addPassed("the mouse pointer stands outside the list, so the clicks of it are not checked");
        return;
      }
      assertEquals("one item is selected after a click on it", 1, listPanel.getSelectedIndexes().length);
      assertEquals("one changed event after a click selecting an item", 1, changedCount);
      // the very same item is clicked again: it leaves the selection and that is reported
      const clickedIndex:int = int(listPanel.getSelectedIndexes()[0]);
      clickTheList(listPanel);
      assertEquals("the clicked item is not selected any more"
        , -1, listPanel.getSelectedIndexes().indexOf(clickedIndex));
      assertEquals("one more changed event after the click deselecting that item", 2, changedCount);
    }
    /**
     * Dispatches the mouse events of one click onto the given list. The move, the down and
     * the click of a list are listened to between the roll over and the roll out of it only,
     * so the pointer has to arrive onto it before every one of those clicks.
     * @param listPanel the list to be clicked
     */
    private function clickTheList(listPanel:ListPanel):void
    {
      listPanel.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      listPanel.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      listPanel.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }
    /**
     * Counts the changed events of the tested list.
     * @param e the changed event
     */
    private function listPanelChanged(e:Event):void
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
