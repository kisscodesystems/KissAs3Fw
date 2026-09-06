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
 * ButtonBarUnitTest
 * Checks the ButtonBar component.
 *
 * MAIN FEATURES:
 * - adding, finding and removing the buttons of the bar
 * - the active index and the maximum width of the bar
 * - the buttons hidden from the bar
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonBar;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ButtonBarUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ButtonBarUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ButtonBar";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const buttonBar:ButtonBar = new ButtonBar(application);
      addTested(buttonBar);
      buttonBar.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), buttonBarChanged);
      // an empty bar has no width and no active button
      assertEquals("getDw of an empty bar", 0, buttonBar.getDw());
      assertEquals("getActiveIndex of an empty bar", -1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel of an empty bar", "", buttonBar.getActiveLabel());
      assertEquals("getMaxWidth of a fresh bar", 0, buttonBar.getMaxWidth());
      // the buttons are found by their labels, in the order they have been added
      buttonBar.addButton("first");
      buttonBar.addButton("second", EnumIcons.switchon());
      buttonBar.addButton("third");
      assertEquals("getIndexByLabel of the first button", 0, buttonBar.getIndexByLabel("first"));
      assertEquals("getIndexByLabel of the second button", 1, buttonBar.getIndexByLabel("second"));
      assertEquals("getIndexByLabel of the third button", 2, buttonBar.getIndexByLabel("third"));
      assertEquals("getIndexByLabel of a label that is not on the bar"
        , -1, buttonBar.getIndexByLabel("fourth"));
      assertTrue("a bar with buttons has a width", buttonBar.getDw() > 0);
      // the active button
      buttonBar.setActiveIndex(1);
      assertEquals("getActiveIndex after setActiveIndex", 1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel after setActiveIndex", "second", buttonBar.getActiveLabel());
      buttonBar.setActiveIndex(99);
      assertEquals("an index above the last button is refused", 1, buttonBar.getActiveIndex());
      buttonBar.setActiveIndex(-2);
      assertEquals("an index below minus one is refused", 1, buttonBar.getActiveIndex());
      buttonBar.setActiveIndex(-1);
      assertEquals("minus one turns the active button off", -1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel without an active button", "", buttonBar.getActiveLabel());
      // the changed event is dispatched on a real change of the active button only
      const changedBefore:int = changedCount;
      buttonBar.setActiveIndex(2);
      assertEquals("one changed event after a real change", changedBefore + 1, changedCount);
      buttonBar.setActiveIndex(2);
      assertEquals("no changed event without a real change", changedBefore + 1, changedCount);
      buttonBar.setActiveIndex(99);
      assertEquals("no changed event on a refused index", changedBefore + 1, changedCount);
      buttonBar.setActiveIndex(0, false);
      assertEquals("no changed event when it has not been asked for"
        , changedBefore + 1, changedCount);
      assertEquals("the active button has changed anyway", 0, buttonBar.getActiveIndex());
      buttonBar.setActiveIndex(-1);
      assertEquals("one more changed event when the active button is turned off"
        , changedBefore + 2, changedCount);
      // the icons of the buttons have no getters, they must not break the indexes
      buttonBar.setIcon(0, EnumIcons.switchoff());
      buttonBar.destIcon(0);
      buttonBar.setActiveIndex(2);
      buttonBar.setIconIfNotActive(2, EnumIcons.switchon());
      buttonBar.setIconIfNotActive(0, EnumIcons.switchon());
      assertEquals("the indexes survive the icon changes", 2, buttonBar.getActiveIndex());
      // an emoji stands in the very same slot an icon does, so it must not break the
      // indexes either
      buttonBar.setEmoji(0, EnumEmojis.hands_thumbsup());
      buttonBar.setEmojiIfNotActive(2, EnumEmojis.hearts_heart());
      buttonBar.setEmojiIfNotActive(0, EnumEmojis.hearts_heart());
      assertEquals("the indexes survive the emoji changes", 2, buttonBar.getActiveIndex());
      // a hidden button is left out of the row, but it keeps its index and its label
      const dwWithEveryButton:int = buttonBar.getDw();
      assertTrue("a fresh button is shown on the bar", buttonBar.getButtonVisible(1));
      assertFalse("getButtonVisible of an index that is not on the bar"
        , buttonBar.getButtonVisible(99));
      assertFalse("getButtonVisible of a negative index", buttonBar.getButtonVisible(-1));
      buttonBar.setButtonVisible(1, false);
      assertFalse("getButtonVisible after setButtonVisible", buttonBar.getButtonVisible(1));
      assertTrue("the bar is narrower without the hidden button"
        , buttonBar.getDw() < dwWithEveryButton);
      assertEquals("the hidden button keeps its index", 1, buttonBar.getIndexByLabel("second"));
      assertEquals("the buttons behind the hidden one keep their indexes"
        , 2, buttonBar.getIndexByLabel("third"));
      // a hidden button can still be activated from the inside of the application
      const changedBeforeHiding:int = changedCount;
      buttonBar.setActiveIndex(1);
      assertEquals("the hidden button can be activated", 1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel of the hidden button", "second", buttonBar.getActiveLabel());
      assertEquals("one changed event of the hidden button"
        , changedBeforeHiding + 1, changedCount);
      // a bar of hidden buttons only takes no room at all
      buttonBar.setButtonVisible(0, false);
      buttonBar.setButtonVisible(2, false);
      assertEquals("getDw of a bar of hidden buttons only", 0, buttonBar.getDw());
      assertEquals("getDh of a bar of hidden buttons only", 0, buttonBar.getDh());
      assertEquals("the active index survives the hiding of every button"
        , 1, buttonBar.getActiveIndex());
      // every button shown again gives the very same bar back
      buttonBar.setButtonVisible(0, true);
      buttonBar.setButtonVisible(1, true);
      buttonBar.setButtonVisible(2, true);
      assertTrue("getButtonVisible after the button has been shown again"
        , buttonBar.getButtonVisible(1));
      assertEquals("getDw after every button has been shown again"
        , dwWithEveryButton, buttonBar.getDw());
      // the maximum width caps the width of the bar
      const dwWithoutMaxWidth:int = buttonBar.getDw();
      buttonBar.setMaxWidth(dwWithoutMaxWidth - 10);
      assertEquals("getMaxWidth after setMaxWidth", dwWithoutMaxWidth - 10, buttonBar.getMaxWidth());
      assertEquals("the width is capped by the maximum width"
        , dwWithoutMaxWidth - 10, buttonBar.getDw());
      buttonBar.setMaxWidth(0);
      assertEquals("the width is free again without a maximum width"
        , dwWithoutMaxWidth, buttonBar.getDw());
      // the dimensions of a bar can not be set from the outside
      buttonBar.setDw(500);
      buttonBar.setDh(500);
      buttonBar.setDwh(500, 500);
      assertEquals("getDw is not changed by the dimension setters"
        , dwWithoutMaxWidth, buttonBar.getDw());
      // removing one button shifts the ones behind it
      buttonBar.setActiveIndex(-1);
      buttonBar.removeButton(0);
      assertEquals("the removed button is not found any more"
        , -1, buttonBar.getIndexByLabel("first"));
      assertEquals("the second button has taken the first place"
        , 0, buttonBar.getIndexByLabel("second"));
      buttonBar.removeButton(99);
      assertEquals("an index that is not on the bar removes nothing"
        , 0, buttonBar.getIndexByLabel("second"));
      // the active index follows the button it belongs to, and that is a change to report
      buttonBar.setActiveIndex(1);
      const changedBeforeRemoval:int = changedCount;
      buttonBar.removeButton(0);
      assertEquals("the active index follows a removal before it"
        , 0, buttonBar.getActiveIndex());
      assertEquals("the active button is still the very same one"
        , "third", buttonBar.getActiveLabel());
      assertEquals("a changed event after the active index has followed a removal"
        , changedBeforeRemoval + 1, changedCount);
      buttonBar.addButton("fourth");
      buttonBar.removeButton(1);
      assertEquals("the active index is kept on a removal behind it"
        , 0, buttonBar.getActiveIndex());
      assertEquals("the active button is kept on a removal behind it"
        , "third", buttonBar.getActiveLabel());
      assertEquals("no changed event on a removal behind the active button"
        , changedBeforeRemoval + 1, changedCount);
      // the active index is turned off together with the button it belongs to, silently
      buttonBar.addButton("fifth");
      buttonBar.removeButton(0);
      assertEquals("getActiveIndex after the active button has been removed"
        , -1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel after the active button has been removed"
        , "", buttonBar.getActiveLabel());
      assertEquals("no changed event when the active button itself is removed"
        , changedBeforeRemoval + 1, changedCount);
      // a bar without buttons turns its active index off, so no index points to nothing
      buttonBar.setActiveIndex(0);
      buttonBar.removeButton(0);
      assertEquals("getActiveIndex after the last button has been removed"
        , -1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel of the emptied bar", "", buttonBar.getActiveLabel());
      buttonBar.addButton("second");
      buttonBar.addButton("third");
      buttonBar.setActiveIndex(1);
      const changedBeforeRemoveAll:int = changedCount;
      buttonBar.removeAllButtons();
      assertEquals("no changed event on removeAllButtons"
        , changedBeforeRemoveAll, changedCount);
      assertEquals("no button is found after removeAllButtons"
        , -1, buttonBar.getIndexByLabel("second"));
      assertEquals("getActiveIndex after removeAllButtons", -1, buttonBar.getActiveIndex());
      assertEquals("getActiveLabel after removeAllButtons", "", buttonBar.getActiveLabel());
      assertEquals("getDw of the emptied bar", 0, buttonBar.getDw());
      buttonBar.addButton("first");
      runBaseSpriteTests(buttonBar);
      buttonBar.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), buttonBarChanged);
      removeTested(buttonBar);
    }
    /**
     * Counts the changed events of the tested bar.
     * @param e the changed event
     */
    private function buttonBarChanged(e:Event):void
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
