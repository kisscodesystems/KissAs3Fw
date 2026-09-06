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
 * MoreUnitTest
 * Checks the More component.
 *
 * MAIN FEATURES:
 * - the panel opens and closes
 * - an element can be added into the panel and removed from it
 * - the panel counts its elements and answers every one of them by its index
 * - the dimensions of the panel come from its elements, so the setters do nothing
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.ui.More;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class MoreUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function MoreUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "More";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const more:More = new More(application);
      addTested(more);
      // a fresh panel is closed and it has the label of its button
      assertFalse("isOpened of a fresh More", more.isOpened());
      assertNotNull("getTextLabel", more.getTextLabel());
      assertEquals("getNumOfElements of a fresh More", 0, more.getNumOfElements());
      assertNull("getElementAt of a fresh More", more.getElementAt(0));
      const closedDh:int = more.getDh();
      assertTrue("a fresh More is as tall as its label", closedDh > 0);
      // the dimensions come from the elements, so the setters do nothing
      more.setDw(500);
      assertEquals("setDw does nothing", closedDh, more.getDh());
      more.setDh(500);
      more.setDwh(500, 500);
      assertEquals("setDh and setDwh do nothing", closedDh, more.getDh());
      // an element can be put into the panel
      const element:TextLabel = new TextLabel(application);
      element.setLabel("an element of the panel");
      more.addToContent(element);
      assertEquals("the element is inside the panel", more, element.parent.parent);
      assertEquals("getNumOfElements after one element has been added", 1, more.getNumOfElements());
      assertEquals("getElementAt answers that very element", element, more.getElementAt(0));
      // the same element is not added twice
      more.addToContent(element);
      assertEquals("the element is still inside the panel once", more, element.parent.parent);
      assertEquals("getNumOfElements after the same element again", 1, more.getNumOfElements());
      // there is no element of a negative index and none above the last one
      assertNull("getElementAt of a negative index", more.getElementAt(-1));
      assertNull("getElementAt above the last element", more.getElementAt(1));
      // the open panel is exactly as tall and as wide as its elements need, with the
      // padding of the application standing around every one of them. One short element
      // makes a panel shorter than the closed one, so the height is not compared to that.
      const padding:int = application.getDynamicsConfig().getAppPadding();
      more.open();
      assertTrue("isOpened after open", more.isOpened());
      assertEquals("the open More is as tall as its element needs"
        , expectedDh(2 * padding + element.getDh()), more.getDh());
      assertEquals("the open More is as wide as its element needs"
        , expectedDw(2 * padding + element.getDw()), more.getDw());
      more.close();
      assertFalse("isOpened after close", more.isOpened());
      assertEquals("the closed More is as tall as its label again", closedDh, more.getDh());
      // the element can be taken out of the panel
      more.removeFromContent(element);
      assertNull("the element is out of the panel", element.parent);
      assertEquals("getNumOfElements after the element has been removed", 0, more.getNumOfElements());
      // the element has been created outside, so it is not destroyed by the panel
      assertNotNull("the element is still alive", element.getBaseEventDispatcher());
      element.destroy();
      runBaseSpriteTests(more);
      removeTested(more);
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
