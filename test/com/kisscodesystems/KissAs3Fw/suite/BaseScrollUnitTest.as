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
 * BaseScrollUnitTest
 * Checks the BaseScroll of the framework.
 *
 * MAIN FEATURES:
 * - the dimensions of the scrolled content are independent of the ones of the scroll
 * - the position of the content is clamped between the edges of the scroll
 * - the two directions can be enabled, quantized and hidden one by one
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseScrollUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseScrollUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseScroll";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseScroll:BaseScroll = new BaseScroll(application);
      addTested(baseScroll);
      // the parts of a fresh scroll are all there
      assertNotNull("getContent of a fresh BaseScroll", baseScroll.getContent());
      assertNotNull("getMask of a fresh BaseScroll", baseScroll.getMask());
      assertNotNull("getMover of a fresh BaseScroll", baseScroll.getMover());
      assertFalse("getScrolled of a fresh BaseScroll", baseScroll.getScrolled());
      assertFalse("getResizable of a fresh BaseScroll", baseScroll.getResizable());
      // the dimensions of the scroll, the mask follows them
      baseScroll.setDwh(300, 200);
      assertEquals("getDw after setDwh", expectedDw(300), baseScroll.getDw());
      assertEquals("getDh after setDwh", expectedDh(200), baseScroll.getDh());
      // the mask of a scroll sits inside the frame of it, inset by the line thickness of
      // the application on every side, so that frame stays visible around the content
      const maskInset:int = 2 * application.getDynamicsConfig().getAppLineThickness();
      assertEquals("the width of the mask"
        , baseScroll.getDw() - maskInset, baseScroll.getMask().getDw());
      assertEquals("the height of the mask"
        , baseScroll.getDh() - maskInset, baseScroll.getMask().getDh());
      // the dimensions of the scrolled content are independent of the ones of the scroll
      baseScroll.setDwhContent(1000, 800);
      assertEquals("getDwContent after setDwhContent", 1000, baseScroll.getDwContent());
      assertEquals("getDhContent after setDwhContent", 800, baseScroll.getDhContent());
      assertEquals("the dimensions of the scroll are untouched", expectedDw(300), baseScroll.getDw());
      baseScroll.setDwContent(1200);
      assertEquals("getDwContent after setDwContent", 1200, baseScroll.getDwContent());
      baseScroll.setDhContent(900);
      assertEquals("getDhContent after setDhContent", 900, baseScroll.getDhContent());
      // the position of the content is clamped between the edges of the scroll
      baseScroll.setContentPosition(0, 0, false);
      assertEquals("the content x after a set to the origin", 0, baseScroll.getCxContent());
      assertEquals("the content y after a set to the origin", 0, baseScroll.getCyContent());
      baseScroll.setContentPosition(1000, 1000, false);
      assertEquals("the content x is never above zero", 0, baseScroll.getCxContent());
      assertEquals("the content y is never above zero", 0, baseScroll.getCyContent());
      baseScroll.setContentPosition(-100000, -100000, true);
      assertEquals("the content x is clamped to the right edge"
        , baseScroll.getDw() - baseScroll.getDwContent(), baseScroll.getCxContent());
      assertEquals("the content y is clamped to the bottom edge"
        , baseScroll.getDh() - baseScroll.getDhContent(), baseScroll.getCyContent());
      // the position comes back as a factor of the scrollable distance as well
      baseScroll.setContentPosition(0, 0, false);
      assertEquals("calcFactorToBeSetH at the origin", 0, baseScroll.calcFactorToBeSetH());
      assertEquals("calcFactorToBeSetV at the origin", 0, baseScroll.calcFactorToBeSetV());
      // the two directions can be enabled one by one
      assertTrue("getEnabledHorizontal of a fresh BaseScroll", baseScroll.getEnabledHorizontal());
      assertTrue("getEnabledVertical of a fresh BaseScroll", baseScroll.getEnabledVertical());
      baseScroll.setEnabledHorizontal(false);
      assertFalse("getEnabledHorizontal after setEnabledHorizontal(false)"
        , baseScroll.getEnabledHorizontal());
      baseScroll.setEnabledVertical(false);
      assertFalse("getEnabledVertical after setEnabledVertical(false)", baseScroll.getEnabledVertical());
      baseScroll.setEnabledHorizontal(true);
      baseScroll.setEnabledVertical(true);
      // a scroll has something to be scrolled when its content is bigger than itself in a
      // direction that is enabled: a content that fits into it stays where it is
      assertTrue("hasSomethingToScroll with a content bigger in both directions"
        , baseScroll.hasSomethingToScroll());
      baseScroll.setDwhContent(baseScroll.getDw(), 900);
      assertTrue("hasSomethingToScroll with a content that is only taller"
        , baseScroll.hasSomethingToScroll());
      baseScroll.setEnabledVertical(false);
      assertFalse("hasSomethingToScroll when the only bigger direction is switched off"
        , baseScroll.hasSomethingToScroll());
      baseScroll.setEnabledVertical(true);
      baseScroll.setDwhContent(baseScroll.getDw(), baseScroll.getDh());
      assertFalse("hasSomethingToScroll with a content that fits", baseScroll.hasSomethingToScroll());
      baseScroll.setDwhContent(1200, 900);
      // the scrolling can be quantized, so that it stops at the edges of the rows
      assertFalse("getQuantizedHorizontal of a fresh BaseScroll", baseScroll.getQuantizedHorizontal());
      assertFalse("getQuantizedVertical of a fresh BaseScroll", baseScroll.getQuantizedVertical());
      baseScroll.setQuantizedHorizontal(true);
      assertTrue("getQuantizedHorizontal after setQuantizedHorizontal(true)"
        , baseScroll.getQuantizedHorizontal());
      baseScroll.setQuantizedVertical(true);
      assertTrue("getQuantizedVertical after setQuantizedVertical(true)"
        , baseScroll.getQuantizedVertical());
      baseScroll.setQuantizedHorizontal(false);
      baseScroll.setQuantizedVertical(false);
      // every one of the four navigation bars can be hidden on its own
      baseScroll.hideNavigationTop(true);
      assertTrue("isHiddenNavigationTop after hideNavigationTop(true)"
        , baseScroll.isHiddenNavigationTop());
      baseScroll.hideNavigationBottom(true);
      assertTrue("isHiddenNavigationBottom after hideNavigationBottom(true)"
        , baseScroll.isHiddenNavigationBottom());
      baseScroll.hideNavigationLeft(true);
      assertTrue("isHiddenNavigationLeft after hideNavigationLeft(true)"
        , baseScroll.isHiddenNavigationLeft());
      baseScroll.hideNavigationRight(true);
      assertTrue("isHiddenNavigationRight after hideNavigationRight(true)"
        , baseScroll.isHiddenNavigationRight());
      baseScroll.hideNavigationTop(false);
      assertFalse("isHiddenNavigationTop after hideNavigationTop(false)"
        , baseScroll.isHiddenNavigationTop());
      baseScroll.hideNavigationBottom(false);
      baseScroll.hideNavigationLeft(false);
      baseScroll.hideNavigationRight(false);
      // a center only scroll hides all the four bars at once and lets its center area cover
      // its whole surface, so that nothing of the content is taken away by a margin
      assertFalse("getCenterOnly of a fresh BaseScroll", baseScroll.getCenterOnly());
      baseScroll.setCenterOnly(true);
      assertTrue("getCenterOnly after setCenterOnly(true)", baseScroll.getCenterOnly());
      assertTrue("isHiddenNavigationTop of a center only BaseScroll"
        , baseScroll.isHiddenNavigationTop());
      assertTrue("isHiddenNavigationBottom of a center only BaseScroll"
        , baseScroll.isHiddenNavigationBottom());
      assertTrue("isHiddenNavigationLeft of a center only BaseScroll"
        , baseScroll.isHiddenNavigationLeft());
      assertTrue("isHiddenNavigationRight of a center only BaseScroll"
        , baseScroll.isHiddenNavigationRight());
      assertEquals("the drawn width of the mover of a center only BaseScroll"
        , baseScroll.getDw(), int(baseScroll.getMover().width));
      assertEquals("the drawn height of the mover of a center only BaseScroll"
        , baseScroll.getDh(), int(baseScroll.getMover().height));
      baseScroll.setCenterOnly(false);
      assertFalse("getCenterOnly after setCenterOnly(false)", baseScroll.getCenterOnly());
      assertFalse("isHiddenNavigationTop after setCenterOnly(false)"
        , baseScroll.isHiddenNavigationTop());
      assertTrue("the mover of a scroll of bars is narrower than that scroll"
        , int(baseScroll.getMover().width) < baseScroll.getDw());
      // the scrolled flag tells whether the one using it is dragging the content right now
      baseScroll.setScrolled(true);
      assertTrue("getScrolled after setScrolled(true)", baseScroll.getScrolled());
      baseScroll.setScrolled(false);
      assertFalse("getScrolled after setScrolled(false)", baseScroll.getScrolled());
      // the resizer handle in the bottom right corner
      baseScroll.setResizable(true);
      assertTrue("getResizable after setResizable(true)", baseScroll.getResizable());
      baseScroll.setResizable(false);
      assertFalse("getResizable after setResizable(false)", baseScroll.getResizable());
      // the frame of the scroll is drawn by the type and the alpha it has been given
      baseScroll.setShapeFrameType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      baseScroll.setShapeFrameBackgroundAlpha(0.5);
      baseScroll.setShapeFrameType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      // and it can be hidden completely
      assertTrue("getShapeFrameVisible of a fresh BaseScroll", baseScroll.getShapeFrameVisible());
      baseScroll.setShapeFrameVisible(false);
      assertFalse("getShapeFrameVisible after setShapeFrameVisible(false)", baseScroll.getShapeFrameVisible());
      baseScroll.setShapeFrameVisible(true);
      assertTrue("getShapeFrameVisible after setShapeFrameVisible(true)", baseScroll.getShapeFrameVisible());
      // the dragging can be started from the outside, a null event starts nothing
      baseScroll.mouseDown(null);
      // the enabled state reaches every navigation bar of the scroll
      baseScroll.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", baseScroll.getEnabled());
      baseScroll.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", baseScroll.getEnabled());
      runBaseSpriteTests(baseScroll);
      removeTested(baseScroll);
      // a scroll can be built with a dummy content in it as well
      const withDummy:BaseScroll = new BaseScroll(application, true);
      addTested(withDummy);
      withDummy.setDwh(200, 150);
      assertNotNull("the content of the BaseScroll built with a dummy", withDummy.getContent());
      removeTested(withDummy);
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
