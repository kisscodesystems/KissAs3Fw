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
 * BaseUnitTest
 * The base class of every unit test suite.
 *
 * MAIN FEATURES:
 * - assertion methods that write their result into the report
 * - the base sprite assertions every visual object has to fulfill
 * - helpers to place the tested object onto the application and to free it
 */
package com.kisscodesystems.KissAs3Ut
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  public class BaseUnitTest
  {
    protected var application:Application = null;
    protected var report:UnitTestReport = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      application = applicationRef;
      report = reportRef;
    }
    /**
     * Returns the name of this suite, every suite overrides this.
     */
    public function getName():String
    {
      return "BaseUnitTest";
    }
    /**
     * Runs the assertions of this suite, every suite overrides this.
     */
    public function run():void
    {
    }
    /**
     * Asserts that two values are the same.
     * @param what the description of the assertion
     * @param expected the expected value
     * @param actual the value that has been found
     */
    protected function assertEquals(what:String, expected:Object, actual:Object):void
    {
      if (expected === actual)
      {
        report.addPassed(what);
      }
      else
      {
        report.addFailed(what, "" + expected, "" + actual);
      }
    }
    /**
     * Asserts that two numbers are close enough to each other. The alpha of a display
     * object for example is stored in steps, so it never compares exactly.
     * @param what the description of the assertion
     * @param expected the expected value
     * @param actual the value that has been found
     */
    protected function assertEqualsNumber(what:String, expected:Number, actual:Number):void
    {
      if (Math.abs(expected - actual) < 0.005)
      {
        report.addPassed(what);
      }
      else
      {
        report.addFailed(what, "" + expected, "" + actual);
      }
    }
    /**
     * Asserts that a value is true.
     * @param what the description of the assertion
     * @param actual the value that has been found
     */
    protected function assertTrue(what:String, actual:Boolean):void
    {
      assertEquals(what, true, actual);
    }
    /**
     * Asserts that a value is false.
     * @param what the description of the assertion
     * @param actual the value that has been found
     */
    protected function assertFalse(what:String, actual:Boolean):void
    {
      assertEquals(what, false, actual);
    }
    /**
     * Asserts that a reference is null.
     * @param what the description of the assertion
     * @param actual the reference that has been found
     */
    protected function assertNull(what:String, actual:Object):void
    {
      if (actual == null)
      {
        report.addPassed(what);
      }
      else
      {
        report.addFailed(what, "null", "" + actual);
      }
    }
    /**
     * Asserts that a reference is not null.
     * @param what the description of the assertion
     * @param actual the reference that has been found
     */
    protected function assertNotNull(what:String, actual:Object):void
    {
      if (actual != null)
      {
        report.addPassed(what);
      }
      else
      {
        report.addFailed(what, "not null", "null");
      }
    }
    /**
     * Returns the width a base sprite gets after a set of the given width.
     * The base sprite never goes below the configured minimum.
     * @param newdw the width that has been asked for
     */
    protected function expectedDw(newdw:int):int
    {
      return Math.max(newdw, application.getComponentsConfig().getBaseMinw());
    }
    /**
     * Returns the height a base sprite gets after a set of the given height.
     * The base sprite never goes below the configured minimum.
     * @param newdh the height that has been asked for
     */
    protected function expectedDh(newdh:int):int
    {
      return Math.max(newdh, application.getComponentsConfig().getBaseMinh());
    }
    /**
     * Places the tested object onto the application.
     * @param baseSprite the object to be tested
     */
    protected function addTested(baseSprite:BaseSprite):void
    {
      application.addChild(baseSprite);
    }
    /**
     * Frees the tested object and removes it from the application.
     * @param baseSprite the object that has been tested
     */
    protected function removeTested(baseSprite:BaseSprite):void
    {
      baseSprite.destroy();
      if (application.contains(baseSprite))
      {
        application.removeChild(baseSprite);
      }
    }
    /**
     * Runs the assertions that hold on every base sprite: the coordinates, the stored
     * value, the enabled state, the sprite visibility and the depth handling.
     * The dimensions are not checked here because every component drives them differently.
     * @param baseSprite the object to be tested
     */
    protected function runBaseSpriteTests(baseSprite:BaseSprite):void
    {
      assertNotNull("getBaseEventDispatcher", baseSprite.getBaseEventDispatcher());
      baseSprite.setCx(10);
      assertEquals("getCx after setCx", 10, baseSprite.getCx());
      baseSprite.setCy(20);
      assertEquals("getCy after setCy", 20, baseSprite.getCy());
      baseSprite.setCxy(30, 40);
      assertEquals("getCx after setCxy", 30, baseSprite.getCx());
      assertEquals("getCy after setCxy", 40, baseSprite.getCy());
      assertEquals("getCx with the width", 30 + baseSprite.getDw(), baseSprite.getCx(true));
      assertEquals("getCy with the height", 40 + baseSprite.getDh(), baseSprite.getCy(true));
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      assertEquals("getCx with the width, the margin and the padding"
        , 30 + baseSprite.getDw() + margin + padding, baseSprite.getCx(true, true, true));
      assertEquals("getCy with the height, the margin and the padding"
        , 40 + baseSprite.getDh() + margin + padding, baseSprite.getCy(true, true, true));
      baseSprite.setValue(4711);
      assertEquals("getValue after setValue", 4711, baseSprite.getValue());
      baseSprite.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", baseSprite.getEnabled());
      assertEqualsNumber("the alpha of the disabled object"
        , application.getComponentsConfig().getDisabledAlpha(), baseSprite.alpha);
      baseSprite.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", baseSprite.getEnabled());
      assertEqualsNumber("the alpha of the enabled object", 1, baseSprite.alpha);
      // the hide and show cycle below needs a visible object to start with: a suite may
      // hand over an object it has closed or hidden, and hiding an already hidden object
      // does nothing at all, so the dimensions of it would never be zeroed
      baseSprite.setSpriteVisible(true);
      const dwBefore:int = baseSprite.getDw();
      const dhBefore:int = baseSprite.getDh();
      baseSprite.setSpriteVisible(false);
      assertFalse("visible after setSpriteVisible(false)", baseSprite.visible);
      assertEquals("getDw of the hidden object", 0, baseSprite.getDw());
      assertEquals("getDh of the hidden object", 0, baseSprite.getDh());
      baseSprite.setSpriteVisible(true);
      assertTrue("visible after setSpriteVisible(true)", baseSprite.visible);
      assertEquals("getDw of the shown object", dwBefore, baseSprite.getDw());
      assertEquals("getDh of the shown object", dhBefore, baseSprite.getDh());
      baseSprite.toTheLowestDepth();
      assertEquals("the depth after toTheLowestDepth", 0, application.getChildIndex(baseSprite));
      baseSprite.toTheHighestDepth();
      assertEquals("the depth after toTheHighestDepth"
        , application.numChildren - 1, application.getChildIndex(baseSprite));
    }
    /**
     * Frees everything this suite holds.
     */
    public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      application = null;
      report = null;
    }
  }
}
