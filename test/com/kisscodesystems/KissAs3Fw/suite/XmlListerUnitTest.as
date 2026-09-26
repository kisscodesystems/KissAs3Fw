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
 * XmlListerUnitTest
 * Checks the XmlLister component.
 *
 * MAIN FEATURES:
 * - an xml is walked and the open branches of it are listed
 * - an unparsable xml leaves an empty list behind
 * - the width is given to the list, the height comes from the number of the items
 * - a clicked branch is reported by the opened or by the closed event, not by the
 *   changed one
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
  import com.kisscodesystems.KissAs3Fw.ui.XmlLister;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class XmlListerUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    private var openedCount:int = 0;
    private var closedCount:int = 0;
    // an open branch with one leaf under it, a closed branch and one single leaf
    private static const TEST_XML:String = "<items>"
      + "<item value=\"open branch\" opened=\"1\"><item value=\"leaf of it\"/></item>"
      + "<item value=\"closed branch\" opened=\"0\"><item value=\"hidden leaf\"/></item>"
      + "<item value=\"single leaf\"/>"
      + "</items>";
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function XmlListerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "XmlLister";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const xmlLister:XmlLister = new XmlLister(application);
      addTested(xmlLister);
      // a fresh lister has nothing selected and it has the text type of its list
      assertEquals("getSelectedItem of a fresh XmlLister", "", xmlLister.getSelectedItem());
      assertNotNull("getTextType", xmlLister.getTextType());
      assertEquals("getXmlAsString of a fresh XmlLister", "", xmlLister.getXmlAsString());
      assertEquals("getStartIndex of a fresh XmlLister", 0, xmlLister.getStartIndex());
      assertFalse("getAlwaysDispatchSelectedEvent of a fresh XmlLister"
        , xmlLister.getAlwaysDispatchSelectedEvent());
      // the number of the displayed items can be set, but the list of this lister builds
      // that many elements when it has that many items to display: the number given here
      // is remembered until then
      xmlLister.setNumOfElements(4);
      assertEquals("getNumOfElements of an empty XmlLister", 0, xmlLister.getNumOfElements());
      // the width is given to the list, the height comes from the number of the items
      xmlLister.setDw(300);
      assertEquals("getDw after setDw(300)", expectedDw(300), xmlLister.getDw());
      const dhBefore:int = xmlLister.getDh();
      xmlLister.setDh(500);
      xmlLister.setDwh(500, 500);
      assertEquals("setDh and setDwh do not change the height", dhBefore, xmlLister.getDh());
      assertEquals("setDwh does not change the width", expectedDw(300), xmlLister.getDw());
      // the xml is walked: the open branch shows its leaf, the closed one hides it
      xmlLister.setXmlAsString(TEST_XML);
      assertEquals("getXmlAsString after the xml has arrived", TEST_XML, xmlLister.getXmlAsString());
      assertTrue("the walked xml has made the lister taller", xmlLister.getDh() > 0);
      assertEquals("getNumOfElements after the items have arrived"
        , 4, xmlLister.getNumOfElements());
      xmlLister.setStartIndex(1);
      assertEquals("getStartIndex after setStartIndex(1)", 1, xmlLister.getStartIndex());
      // the selection is still empty, because no item has been clicked
      assertEquals("getSelectedItem after the xml has arrived", "", xmlLister.getSelectedItem());
      runBranchEventTests(xmlLister);
      // every selection can be asked to dispatch the changed event
      xmlLister.setAlwaysDispatchSelectedEvent(true);
      assertTrue("getAlwaysDispatchSelectedEvent after it has been switched on"
        , xmlLister.getAlwaysDispatchSelectedEvent());
      xmlLister.setAlwaysDispatchSelectedEvent(false);
      assertFalse("getAlwaysDispatchSelectedEvent after it has been switched off"
        , xmlLister.getAlwaysDispatchSelectedEvent());
      // an unparsable xml is survived and it leaves an empty list behind
      xmlLister.setXmlAsString("<items><item></items>");
      assertEquals("getXmlAsString answers an unparsable xml as well"
        , "<items><item></items>", xmlLister.getXmlAsString());
      assertEquals("getSelectedItem after an unparsable xml", "", xmlLister.getSelectedItem());
      assertEquals("getNumOfElements after an unparsable xml", 0, xmlLister.getNumOfElements());
      // the list follows the enabled state of the lister
      xmlLister.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", xmlLister.getEnabled());
      xmlLister.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", xmlLister.getEnabled());
      runBaseSpriteTests(xmlLister);
      removeTested(xmlLister);
    }
    /**
     * A branch clicked on the list of the lister opens or closes, and that is reported by
     * the opened or by the closed event: no leaf has been selected, so it is no changed
     * event of the lister, the one a menu built of it would run its last item on.
     * @param xmlLister the tested lister, standing on the test xml
     */
    private function runBranchEventTests(xmlLister:XmlLister):void
    {
      changedCount = 0;
      openedCount = 0;
      closedCount = 0;
      xmlLister.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), xmlListerChanged);
      xmlLister.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OPENED(), xmlListerOpened);
      xmlLister.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), xmlListerClosed);
      const listPanel:ListPanel = ListPanel(findElementOfClass(xmlLister, ListPanel));
      assertNotNull("the list of the lister", listPanel);
      if (listPanel != null)
      {
        // the items: the open branch, its leaf, the closed branch and the single leaf
        listPanel.setSelectedIndexes([2]);
        assertEquals("one opened event after the click of the closed branch", 1, openedCount);
        listPanel.setSelectedIndexes([0]);
        assertEquals("one closed event after the click of the open branch", 1, closedCount);
        assertEquals("no changed event after the clicks of branches", 0, changedCount);
        assertEquals("no leaf has been selected by those clicks", "", xmlLister.getSelectedItem());
      }
      xmlLister.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), xmlListerChanged);
      xmlLister.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_OPENED(), xmlListerOpened);
      xmlLister.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CLOSED(), xmlListerClosed);
      // the test xml is given again, the rest of this suite counts on its items
      xmlLister.setXmlAsString(TEST_XML);
    }
    /**
     * Counts the changed events of the tested lister.
     * @param e the changed event
     */
    private function xmlListerChanged(e:Event):void
    {
      changedCount++;
    }
    /**
     * Counts the opened events of the tested lister.
     * @param e the opened event
     */
    private function xmlListerOpened(e:Event):void
    {
      openedCount++;
    }
    /**
     * Counts the closed events of the tested lister.
     * @param e the closed event
     */
    private function xmlListerClosed(e:Event):void
    {
      closedCount++;
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
      openedCount = 0;
      closedCount = 0;
    }
  }
}
