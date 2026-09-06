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
 * BaseResizerUnitTest
 * Checks the BaseResizer of the framework.
 *
 * MAIN FEATURES:
 * - the size of the handle is the height of one bright text field of the application
 * - the dimensions it carries never go under the minimum of the components config
 * - the corner of the owner is the place of the handle, and an owner smaller than the
 *   handle itself keeps it inside its own origin
 * - the pixels of a drag come from the mouse of the stage, so a run of this suite can
 *   not move the handle: the press and the release of it are the ones driven below, and
 *   they are the two that open and close the drag
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseResizer;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.MouseEvent;
  public class BaseResizerUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseResizerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseResizer";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseResizer:BaseResizer = new BaseResizer(application);
      addTested(baseResizer);
      // the handle is as big as one bright text field of the application
      const handleSize:int = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      assertEquals("getDw of a fresh handle", expectedDw(handleSize), baseResizer.getDw());
      assertEquals("getDh of a fresh handle", expectedDh(handleSize), baseResizer.getDh());
      // a fresh handle is not dragged and it carries the minimal dimensions
      assertFalse("getDragging of a fresh handle", baseResizer.getDragging());
      assertEquals("getDimensionDw of a fresh handle", 0, baseResizer.getDimensionDw());
      assertEquals("getDimensionDh of a fresh handle", 0, baseResizer.getDimensionDh());
      runDimensionsTests(baseResizer);
      runCornerTests(baseResizer);
      runDragTests(baseResizer);
      runBaseSpriteTests(baseResizer);
      removeTested(baseResizer);
    }
    /**
     * Checks the dimensions a drag has to start from: they are taken as they are given,
     * and the minimum of the components config is the lowest one they can reach.
     * @param baseResizer the object to be tested
     */
    private function runDimensionsTests(baseResizer:BaseResizer):void
    {
      const minDw:int = application.getComponentsConfig().getScrollSizeMinWidth();
      const minDh:int = application.getComponentsConfig().getScrollSizeMinHeight();
      baseResizer.setDimensions(400, 300);
      assertEquals("getDimensionDw after setDimensions", 400, baseResizer.getDimensionDw());
      assertEquals("getDimensionDh after setDimensions", 300, baseResizer.getDimensionDh());
      baseResizer.setDimensions(0, 0);
      assertEquals("the width never goes under the minimum", minDw, baseResizer.getDimensionDw());
      assertEquals("the height never goes under the minimum", minDh, baseResizer.getDimensionDh());
      baseResizer.setDimensions(-100, -100);
      assertEquals("a negative width is the minimum as well", minDw, baseResizer.getDimensionDw());
      assertEquals("a negative height is the minimum as well", minDh, baseResizer.getDimensionDh());
      baseResizer.setDimensions(400, 300);
    }
    /**
     * Checks the place of the handle: it stands inside the corner of its owner, and an
     * owner that is smaller than the handle itself keeps it at its own origin.
     * @param baseResizer the object to be tested
     */
    private function runCornerTests(baseResizer:BaseResizer):void
    {
      baseResizer.setCornerDimensions(500, 400);
      assertEquals("the handle stands inside the corner of its owner"
        , 500 - baseResizer.getDw(), baseResizer.getCx());
      assertEquals("the handle stands above the bottom of its owner"
        , 400 - baseResizer.getDh(), baseResizer.getCy());
      assertEquals("the corner of the owner is the corner of the handle"
        , 500, baseResizer.getCx(true));
      assertEquals("the bottom of the owner is the bottom of the handle"
        , 400, baseResizer.getCy(true));
      baseResizer.setCornerDimensions(0, 0);
      assertEquals("an owner smaller than the handle keeps it at its own x", 0, baseResizer.getCx());
      assertEquals("an owner smaller than the handle keeps it at its own y", 0, baseResizer.getCy());
    }
    /**
     * Checks the press and the release of the handle: a drag is open between the two, and
     * the dimensions of it can not be overwritten from the outside while it is going on,
     * because the owner is taking them from the handle right then. The pointer of this run
     * stands still, so the drag itself covers no pixel at all.
     * @param baseResizer the object to be tested
     */
    private function runDragTests(baseResizer:BaseResizer):void
    {
      baseResizer.setDimensions(400, 300);
      baseResizer.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      assertTrue("getDragging after a press on the handle", baseResizer.getDragging());
      baseResizer.setDimensions(100, 100);
      assertEquals("a drag keeps the width it has been started with"
        , 400, baseResizer.getDimensionDw());
      assertEquals("a drag keeps the height it has been started with"
        , 300, baseResizer.getDimensionDh());
      application.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
      assertFalse("getDragging after the release of the handle", baseResizer.getDragging());
      assertEquals("a drag that has covered no pixel changes no width"
        , 400, baseResizer.getDimensionDw());
      baseResizer.setDimensions(200, 150);
      assertEquals("the dimensions are taken again as soon as the drag is over"
        , 200, baseResizer.getDimensionDw());
    }
  }
}
