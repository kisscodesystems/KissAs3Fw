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
 * BaseEventDispatcherUnitTest
 * Checks the BaseEventDispatcher of the framework.
 *
 * MAIN FEATURES:
 * - a registered listener is called and a removed one is not
 * - every listener of the dispatcher can be dropped by one single call
 * - the parent object is the one the dispatcher belongs to
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseEventDispatcher;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class BaseEventDispatcherUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseEventDispatcherUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseEventDispatcher";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const dispatcher:BaseEventDispatcher = new BaseEventDispatcher();
      // a fresh dispatcher belongs to nobody
      assertNull("getParentObject of a fresh BaseEventDispatcher", dispatcher.getParentObject());
      dispatcher.setParentObject(this);
      assertEquals("getParentObject after setParentObject", this, dispatcher.getParentObject());
      // a registered listener is called on every dispatch
      dispatcher.addEventListener(EnumEvents.EVENT_CHANGED(), changed);
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CHANGED()));
      assertEquals("one call after one dispatch", 1, changedCount);
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CHANGED()));
      assertEquals("two calls after two dispatches", 2, changedCount);
      // an event of another type reaches no listener of this one
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CLICK()));
      assertEquals("an event of another type calls nothing", 2, changedCount);
      // a removed listener is not called any more
      dispatcher.removeEventListener(EnumEvents.EVENT_CHANGED(), changed);
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CHANGED()));
      assertEquals("a removed listener is not called", 2, changedCount);
      // every listener can be dropped by one single call
      dispatcher.addEventListener(EnumEvents.EVENT_CHANGED(), changed);
      dispatcher.addEventListener(EnumEvents.EVENT_CLICK(), changed);
      dispatcher.removeAllListeners(false);
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CHANGED()));
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CLICK()));
      assertEquals("no listener is called after removeAllListeners", 2, changedCount);
      // the dropping of the listeners can ask for a garbage collection as well
      dispatcher.addEventListener(EnumEvents.EVENT_CHANGED(), changed);
      dispatcher.removeAllListeners();
      dispatcher.dispatchEvent(new Event(EnumEvents.EVENT_CHANGED()));
      assertEquals("no listener is called after removeAllListeners with the gc", 2, changedCount);
      dispatcher.destroy();
      assertNull("getParentObject of the destroyed dispatcher", dispatcher.getParentObject());
    }
    /**
     * Counts the events of the tested dispatcher.
     * @param e the event of the dispatcher
     */
    private function changed(e:Event):void
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
