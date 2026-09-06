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
 * WatchUnitTest
 * Checks the Watch component.
 *
 * MAIN FEATURES:
 * - every one of the four kinds of the watch can be taken, and nothing else
 * - the displaying of the seconds can be switched
 * - the watch changed and the watch repositioned events arrive onto the dispatcher of
 *   the watch itself and onto the one of the application as well
 * - the panel of the watch can be opened and closed, and the opened and the closed
 *   events of it arrive onto the dispatcher of the watch
 * - the dimensions come from the elements of the watch
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.Watch;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class WatchUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    // the same two events counted on the dispatcher of the tested watch itself
    private var ownChangedCount:int = 0;
    private var ownRepositionedCount:int = 0;
    // the opened and the closed events of the panel of the tested watch
    private var openedCount:int = 0;
    private var closedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function WatchUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Watch";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      ownChangedCount = 0;
      ownRepositionedCount = 0;
      openedCount = 0;
      closedCount = 0;
      const watch:Watch = new Watch(application);
      addTested(watch);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WATCH_CHANGED(), watchChanged);
      // a watch reports onto its own dispatcher as well, so that one single watch of an
      // application holding several of them can be listened to
      watch.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WATCH_CHANGED(), watchChangedOnItsOwn);
      watch.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WATCH_REPOSITIONED(), watchRepositionedOnItsOwn);
      watch.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OPENED(), watchOpened);
      watch.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), watchClosed);
      // a fresh watch is the basic one and it displays the seconds
      assertEquals("getWatchType of a fresh Watch", EnumTextKeys.WATCH_TYPE_BASIC(), watch.getWatchType());
      assertTrue("getWatchSecs of a fresh Watch", watch.getWatchSecs());
      assertTrue("a fresh Watch is as wide as its elements", watch.getDw() > 0);
      assertTrue("a fresh Watch is as tall as its elements", watch.getDh() > 0);
      assertTrue("the frame of the watch stands inside it", watch.getShapeFgFrameX() >= 0);
      // every one of the four kinds can be taken
      watch.setWatchType(EnumTextKeys.WATCH_TYPE_DIGITAL());
      assertEquals("getWatchType after the digital one"
        , EnumTextKeys.WATCH_TYPE_DIGITAL(), watch.getWatchType());
      assertEquals("one watch changed event after a real change", 1, changedCount);
      assertEquals("that change is reported on the dispatcher of the watch as well", 1, ownChangedCount);
      watch.setWatchType(EnumTextKeys.WATCH_TYPE_ANALOG());
      assertEquals("getWatchType after the analog one"
        , EnumTextKeys.WATCH_TYPE_ANALOG(), watch.getWatchType());
      watch.setWatchType(EnumTextKeys.WATCH_TYPE_BINARY());
      assertEquals("getWatchType after the binary one"
        , EnumTextKeys.WATCH_TYPE_BINARY(), watch.getWatchType());
      watch.setWatchType(EnumTextKeys.WATCH_TYPE_BASIC());
      assertEquals("getWatchType after the basic one"
        , EnumTextKeys.WATCH_TYPE_BASIC(), watch.getWatchType());
      assertEquals("four watch changed events after the four real changes", 4, changedCount);
      assertEquals("the four changes are reported on the dispatcher of the watch as well", 4, ownChangedCount);
      assertTrue("the watch has reported its new dimensions on its own dispatcher", ownRepositionedCount > 0);
      // a kind that does not exist is dropped
      watch.setWatchType("this is not a watch type");
      assertEquals("getWatchType after a kind that does not exist"
        , EnumTextKeys.WATCH_TYPE_BASIC(), watch.getWatchType());
      assertEquals("a dropped kind dispatches no watch changed event", 4, changedCount);
      assertEquals("a dropped kind is silent on the dispatcher of the watch as well", 4, ownChangedCount);
      // the very same kind changes nothing
      watch.setWatchType(EnumTextKeys.WATCH_TYPE_BASIC());
      assertEquals("the very same kind dispatches no watch changed event", 4, changedCount);
      // the displaying of the seconds can be switched
      watch.setWatchSecs(false);
      assertFalse("getWatchSecs after setWatchSecs(false)", watch.getWatchSecs());
      assertEquals("five watch changed events after the seconds have been switched", 5, changedCount);
      assertEquals("the switched seconds are reported on the dispatcher of the watch as well", 5, ownChangedCount);
      watch.setWatchSecs(true);
      assertTrue("getWatchSecs after setWatchSecs(true)", watch.getWatchSecs());
      runPanelTests(watch);
      // the dimensions come from the elements, so the setters do nothing
      const dwBefore:int = watch.getDw();
      const dhBefore:int = watch.getDh();
      watch.setDw(900);
      watch.setDh(900);
      watch.setDwh(900, 900);
      assertEquals("setDw, setDh and setDwh do not change the width", dwBefore, watch.getDw());
      assertEquals("setDw, setDh and setDwh do not change the height", dhBefore, watch.getDh());
      // the switcher of the seconds follows the enabled state of the watch
      watch.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", watch.getEnabled());
      watch.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", watch.getEnabled());
      runBaseSpriteTests(watch);
      watch.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_OPENED(), watchOpened);
      watch.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CLOSED(), watchClosed);
      watch.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WATCH_CHANGED(), watchChangedOnItsOwn);
      watch.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WATCH_REPOSITIONED(), watchRepositionedOnItsOwn);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WATCH_CHANGED(), watchChanged);
      removeTested(watch);
    }
    /**
     * Checks the panel of the watch: it can be opened and closed from the outside, an
     * open panel makes the watch taller, a second call of either of the two changes
     * nothing, and a disabled watch has no panel to be opened at all.
     * @param watch the object to be tested
     */
    private function runPanelTests(watch:Watch):void
    {
      assertFalse("isOpened of a watch that has never been opened", watch.isOpened());
      const dhClosed:int = watch.getDh();
      watch.open();
      assertTrue("isOpened after open", watch.isOpened());
      assertEquals("one opened event after the opening", 1, openedCount);
      assertTrue("an open panel makes the watch taller", watch.getDh() > dhClosed);
      watch.open();
      assertEquals("a second open dispatches no second opened event", 1, openedCount);
      watch.close();
      assertFalse("isOpened after close", watch.isOpened());
      assertEquals("one closed event after the closing", 1, closedCount);
      assertEquals("the watch is as tall as it was before the opening", dhClosed, watch.getDh());
      watch.close();
      assertEquals("a second close dispatches no second closed event", 1, closedCount);
      // a disabled watch is not to be opened at all
      watch.setEnabled(false);
      watch.open();
      assertFalse("a disabled watch is not opened", watch.isOpened());
      assertEquals("a disabled watch dispatches no opened event", 1, openedCount);
      watch.setEnabled(true);
      // an open panel of a watch that is disabled afterwards has to go away
      watch.open();
      assertTrue("isOpened after the watch has been enabled again", watch.isOpened());
      watch.setEnabled(false);
      assertFalse("a disabled watch closes its open panel", watch.isOpened());
      assertEquals("that closing is reported as well", 2, closedCount);
      watch.setEnabled(true);
    }
    /**
     * Counts the opened events of the panel of the tested watch.
     * @param e the opened event
     */
    private function watchOpened(e:Event):void
    {
      openedCount++;
    }
    /**
     * Counts the closed events of the panel of the tested watch.
     * @param e the closed event
     */
    private function watchClosed(e:Event):void
    {
      closedCount++;
    }
    /**
     * Counts the watch changed events of the tested watch.
     * @param e the watch changed event
     */
    private function watchChanged(e:Event):void
    {
      changedCount++;
    }
    /**
     * Counts the watch changed events arriving onto the dispatcher of the tested watch.
     * @param e the watch changed event
     */
    private function watchChangedOnItsOwn(e:Event):void
    {
      ownChangedCount++;
    }
    /**
     * Counts the watch repositioned events arriving onto the dispatcher of the tested
     * watch.
     * @param e the watch repositioned event
     */
    private function watchRepositionedOnItsOwn(e:Event):void
    {
      ownRepositionedCount++;
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
      ownChangedCount = 0;
      ownRepositionedCount = 0;
      openedCount = 0;
      closedCount = 0;
    }
  }
}
