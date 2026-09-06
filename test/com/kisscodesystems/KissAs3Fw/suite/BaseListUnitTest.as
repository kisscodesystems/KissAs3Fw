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
 * BaseListUnitTest
 * Checks the BaseList of the framework, the row of the elements of a ListPanel.
 *
 * MAIN FEATURES:
 * - the number of the elements builds and drops the rows of the list
 * - a label, an icon and an indentation can be given to every single element
 * - the height comes from the number of the elements, so its setters do nothing
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseList;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseListUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseListUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseList";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseList:BaseList = new BaseList(application);
      addTested(baseList);
      // a fresh list holds no element at all
      assertEquals("getNumOfElements of a fresh BaseList", 0, baseList.getNumOfElements());
      assertNotNull("getTextType of a fresh BaseList", baseList.getTextType());
      // the elements are built by the number of them
      baseList.setNumOfElements(5);
      assertEquals("getNumOfElements after setNumOfElements(5)", 5, baseList.getNumOfElements());
      baseList.setNumOfElements(3);
      assertEquals("getNumOfElements after setNumOfElements(3)", 3, baseList.getNumOfElements());
      // the text type reaches every element of the list
      baseList.setTextType(EnumTextTypes.TEXT_TYPE_DARK());
      assertEquals("getTextType after setTextType"
        , EnumTextTypes.TEXT_TYPE_DARK(), baseList.getTextType());
      baseList.setTextType(EnumTextTypes.TEXT_TYPE_MID());
      assertEquals("getTextType after the mid one"
        , EnumTextTypes.TEXT_TYPE_MID(), baseList.getTextType());
      // a label, an icon and an indentation can be given to every single element
      baseList.setLabel(0, "the first element");
      baseList.setLabel(1, "the second element", EnumIcons.ok1());
      baseList.setLabel(2, "the third element", EnumIcons.ok1(), 2);
      // an element that does not exist is dropped
      baseList.setLabel(99, "the element that does not exist");
      assertEquals("an element that does not exist builds nothing", 3, baseList.getNumOfElements());
      // every element can be marked, and a marking that does not exist is dropped
      baseList.markElement(0, 1);
      baseList.markElement(1, 2);
      baseList.markElement(2, 0);
      baseList.markElement(0, 4711);
      baseList.markElement(-1, 1);
      baseList.markElement(99, 1);
      baseList.markElements();
      // the width is taken, the height comes from the number of the elements
      baseList.setDw(240);
      assertEquals("getDw after setDw(240)", expectedDw(240), baseList.getDw());
      const dhBefore:int = baseList.getDh();
      baseList.setDh(900);
      baseList.setDwh(900, 900);
      assertEquals("setDh and setDwh do not change the height", dhBefore, baseList.getDh());
      assertEquals("setDwh does not change the width", expectedDw(240), baseList.getDw());
      // the height follows the number of the elements
      baseList.setNumOfElements(6);
      assertTrue("more elements make the BaseList taller", baseList.getDh() > dhBefore);
      runBaseSpriteTests(baseList);
      removeTested(baseList);
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
