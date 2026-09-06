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
 * SwitcherUnitTest
 * Checks the Switcher component.
 *
 * MAIN FEATURES:
 * - the on and the off states and the state strings behind them
 * - the changed event is dispatched only when it has been asked for
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.Switcher;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class SwitcherUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function SwitcherUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Switcher";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const switcher:Switcher = new Switcher(application);
      addTested(switcher);
      switcher.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), switcherChanged);
      // a fresh switcher is off, with the built in state strings
      assertFalse("getOn of a fresh switcher", switcher.getOn());
      assertEquals("getObjectState of a fresh switcher", "off", switcher.getObjectState());
      // switching on and off
      switcher.setOn(true, false);
      assertTrue("getOn after setOn(true)", switcher.getOn());
      assertEquals("getObjectState after setOn(true)", "on", switcher.getObjectState());
      switcher.setOn(false, false);
      assertFalse("getOn after setOn(false)", switcher.getOn());
      assertEquals("getObjectState after setOn(false)", "off", switcher.getObjectState());
      assertEquals("no changed event has been dispatched so far", 0, changedCount);
      // the changed event is dispatched on a real change only
      switcher.setOn(true, true);
      assertEquals("one changed event after a real change", 1, changedCount);
      switcher.setOn(true, true);
      assertEquals("no changed event without a real change", 1, changedCount);
      switcher.setOn(false, true);
      assertEquals("two changed events after the second real change", 2, changedCount);
      // the state strings can be replaced, the current state follows them
      switcher.setStates(EnumTextKeys.YN_YES(), EnumTextKeys.YN_NO());
      assertEquals("getObjectState after setStates", EnumTextKeys.YN_NO(), switcher.getObjectState());
      assertFalse("the switcher is still off after setStates", switcher.getOn());
      switcher.setObjectState(EnumTextKeys.YN_YES(), false);
      assertTrue("getOn after setObjectState to the on state", switcher.getOn());
      assertEquals("getObjectState after setObjectState"
        , EnumTextKeys.YN_YES(), switcher.getObjectState());
      // the icons and the labels have no getters, the label of the link shows the active one
      switcher.setIcons(EnumIcons.switchon(), EnumIcons.switchoff());
      assertEquals("getIconType of the switched on switcher"
        , EnumIcons.switchon(), switcher.getIconType());
      switcher.setLabels("the on label", "the off label");
      assertEquals("getLabel of the switched on switcher", "the on label", switcher.getLabel());
      switcher.setOn(false, false);
      assertEquals("getLabel of the switched off switcher", "the off label", switcher.getLabel());
      assertEquals("getIconType of the switched off switcher"
        , EnumIcons.switchoff(), switcher.getIconType());
      // the inherited setters of the link do nothing on a switcher
      switcher.setIcon(EnumIcons.switchon());
      assertEquals("setIcon does not change the icon of a switcher"
        , EnumIcons.switchoff(), switcher.getIconType());
      switcher.setLabel("this label is refused");
      assertEquals("setLabel does not change the label of a switcher"
        , "the off label", switcher.getLabel());
      switcher.destIcon();
      assertEquals("destIcon does not drop the icon of a switcher"
        , EnumIcons.switchoff(), switcher.getIconType());
      runBaseSpriteTests(switcher);
      switcher.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), switcherChanged);
      removeTested(switcher);
    }
    /**
     * Counts the changed events of the tested switcher.
     * @param e the changed event
     */
    private function switcherChanged(e:Event):void
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
