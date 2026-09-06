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
 * BaseSpriteUnitTest
 * Checks the BaseSprite of the framework, the base class of every visual object.
 *
 * MAIN FEATURES:
 * - the coordinates, the dimensions, the stored value and the enabled state
 * - the destroy of a sprite frees and removes every child of it
 * - the dimensions changed event is only dispatched on a real change
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumSounds;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class BaseSpriteUnitTest extends BaseUnitTest
  {
    private var dimensionsCount:int = 0;
    private var coordinatesCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseSpriteUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseSprite";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      dimensionsCount = 0;
      coordinatesCount = 0;
      const baseSprite:BaseSprite = new BaseSprite(application);
      addTested(baseSprite);
      assertNotNull("getBaseEventDispatcher of a fresh BaseSprite", baseSprite.getBaseEventDispatcher());
      baseSprite.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), dimensionsChanged);
      baseSprite.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COORDINATES_CHANGED(), coordinatesChanged);
      // the dimensions never go below the minimum of the config, and every real change is reported
      baseSprite.setDwh(200, 150);
      assertEquals("getDw after setDwh", expectedDw(200), baseSprite.getDw());
      assertEquals("getDh after setDwh", expectedDh(150), baseSprite.getDh());
      assertTrue("the dimensions changed event has arrived", dimensionsCount > 0);
      dimensionsCount = 0;
      baseSprite.setDwh(200, 150);
      assertEquals("the very same dimensions dispatch no event", 0, dimensionsCount);
      baseSprite.setDw(1);
      assertEquals("getDw is never below the minimum", expectedDw(1), baseSprite.getDw());
      baseSprite.setDh(1);
      assertEquals("getDh is never below the minimum", expectedDh(1), baseSprite.getDh());
      // the coordinates are reported as well
      coordinatesCount = 0;
      baseSprite.setCxy(30, 40);
      assertTrue("the coordinates changed event has arrived", coordinatesCount > 0);
      // the coordinates follow the sprite when it has been moved by the display list
      baseSprite.x = 55;
      baseSprite.y = 66;
      baseSprite.updateCxy();
      assertEquals("getCx after updateCxy", 55, baseSprite.getCx());
      assertEquals("getCy after updateCxy", 66, baseSprite.getCy());
      // the dispatcher can be told which object it belongs to
      baseSprite.setEventDispatcherObjectToThis();
      assertEquals("the parent object of the dispatcher"
        , baseSprite, baseSprite.getBaseEventDispatcher().getParentObject());
      // the sound of the press can be set and cleared
      baseSprite.setSoundTypeClick(EnumSounds.button());
      baseSprite.setSoundTypeClick(null);
      baseSprite.setSoundTypeClick("");
      // this only scrolls the sprite into view when it stands in a content, so it does nothing here
      baseSprite.toBeVisible();
      // the destroy frees and removes every child of a sprite
      const parentSprite:BaseSprite = new BaseSprite(application);
      addTested(parentSprite);
      const childSprite:BaseSprite = new BaseSprite(application);
      parentSprite.addChild(childSprite);
      assertEquals("the child is inside the parent", 1, parentSprite.numChildren);
      parentSprite.destroy();
      assertEquals("the destroy has removed every child", 0, parentSprite.numChildren);
      if (application.contains(parentSprite))
      {
        application.removeChild(parentSprite);
      }
      runBaseSpriteTests(baseSprite);
      baseSprite.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), dimensionsChanged);
      baseSprite.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_COORDINATES_CHANGED(), coordinatesChanged);
      removeTested(baseSprite);
    }
    /**
     * Counts the dimensions changed events of the tested sprite.
     * @param e the dimensions changed event
     */
    private function dimensionsChanged(e:Event):void
    {
      dimensionsCount++;
    }
    /**
     * Counts the coordinates changed events of the tested sprite.
     * @param e the coordinates changed event
     */
    private function coordinatesChanged(e:Event):void
    {
      coordinatesCount++;
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
      dimensionsCount = 0;
      coordinatesCount = 0;
    }
  }
}
