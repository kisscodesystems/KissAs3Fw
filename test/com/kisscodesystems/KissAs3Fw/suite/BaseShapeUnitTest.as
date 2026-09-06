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
 * BaseShapeUnitTest
 * Checks the BaseShape of the framework.
 *
 * MAIN FEATURES:
 * - the colors, the radius and the box of the drawn rectangle
 * - only the three shape types and the four box frames of the enums are taken
 * - the dimensions never go below the minimum of the components config
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseShapeUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseShapeUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseShape";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const shape:BaseShape = new BaseShape(application);
      application.addChild(shape);
      // a fresh shape is a filled and not bright one, with the box of the defaults
      assertTrue("getIsFilled of a fresh BaseShape", shape.getIsFilled());
      assertFalse("getIsBright of a fresh BaseShape", shape.getIsBright());
      assertEquals("getBoxFrame of a fresh BaseShape"
        , EnumBoxFrames.BOX_FRAME_FULL(), shape.getBoxFrame());
      assertTrue("getBoxCorner of a fresh BaseShape", shape.getBoxCorner() > 0);
      // the corner radius
      shape.setRadius(12);
      assertEquals("getRadius after setRadius", 12, shape.getRadius());
      // the colors and the alpha arrive together
      shape.setColorsAndAlpha(0x111111, 0x222222, 0x333333, 0.5, 0x444444);
      assertEquals("getLineColor after setColorsAndAlpha", 0x111111, shape.getLineColor());
      assertEquals("getFillColor1 after setColorsAndAlpha", 0x222222, shape.getFillColor1());
      assertEquals("getFillColor2 after setColorsAndAlpha", 0x333333, shape.getFillColor2());
      assertEquals("getFillAlpha after setColorsAndAlpha", 0.5, shape.getFillAlpha());
      assertEquals("getBrightColor1 after setColorsAndAlpha", 0x444444, shape.getBrightColor1());
      // the filled and the bright states can be switched
      shape.setIsFilled(false);
      assertFalse("getIsFilled after setIsFilled(false)", shape.getIsFilled());
      shape.setIsFilled(true);
      shape.setIsBright(true);
      assertTrue("getIsBright after setIsBright(true)", shape.getIsBright());
      shape.setIsBright(false);
      // only the three types of the enum are taken
      shape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      assertEquals("getType after the pressed one"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED(), shape.getType());
      shape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      assertEquals("getType after the flat one"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT(), shape.getType());
      shape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      assertEquals("getType after the not pressed one"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED(), shape.getType());
      shape.setType(4711);
      assertEquals("a type that does not exist is dropped"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED(), shape.getType());
      // the box corner is always taken, the box frame only when it is one of the enum
      shape.setBox(20, EnumBoxFrames.BOX_FRAME_HORIZONTAL());
      assertEquals("getBoxCorner after setBox", 20, shape.getBoxCorner());
      assertEquals("getBoxFrame after setBox"
        , EnumBoxFrames.BOX_FRAME_HORIZONTAL(), shape.getBoxFrame());
      shape.setBox(24, "thisIsNotABoxFrame");
      assertEquals("the box corner of a dropped box frame is still taken", 24, shape.getBoxCorner());
      assertEquals("a box frame that does not exist is dropped"
        , EnumBoxFrames.BOX_FRAME_HORIZONTAL(), shape.getBoxFrame());
      shape.setBox(24, EnumBoxFrames.BOX_FRAME_VERTICAL());
      shape.setBox(24, EnumBoxFrames.BOX_FRAME_NONE());
      shape.setBox(24, EnumBoxFrames.BOX_FRAME_FULL());
      // the dimensions never go below the minimum of the config
      shape.setDw(120);
      assertEquals("getDw after setDw(120)", expectedDw(120), shape.getDw());
      shape.setDh(90);
      assertEquals("getDh after setDh(90)", expectedDh(90), shape.getDh());
      shape.setDw(1);
      assertEquals("getDw is never below the minimum", expectedDw(1), shape.getDw());
      shape.setDh(1);
      assertEquals("getDh is never below the minimum", expectedDh(1), shape.getDh());
      shape.setDwh(200, 150);
      assertEquals("getDw after setDwh", expectedDw(200), shape.getDw());
      assertEquals("getDh after setDwh", expectedDh(150), shape.getDh());
      // the drawing and the clearing of it
      shape.drawRect();
      assertTrue("the drawn BaseShape has a width", shape.width > 0);
      shape.clear();
      assertEquals("the cleared BaseShape has no width", 0, int(shape.width));
      shape.destroy();
      if (application.contains(shape))
      {
        application.removeChild(shape);
      }
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
    }
  }
}
