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
 * ContentNotFoundUnitTest
 * Checks the ContentNotFound component.
 *
 * MAIN FEATURES:
 * - the text and the icon of the dummy picture
 * - the smallest dimensions and the placing of the text inside the given ones: in the
 *   middle of a wide area, broken into more lines in a narrow one
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.ContentNotFound;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ContentNotFoundUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ContentNotFoundUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ContentNotFound";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const contentNotFound:ContentNotFound = new ContentNotFound(application);
      addTested(contentNotFound);
      const textLabel:TextLabel = contentNotFound.getTextLabel();
      assertNotNull("getTextLabel", textLabel);
      assertEquals("the text of the dummy picture", EnumTextKeys.CONTENT_NOT_FOUND(), textLabel.getLabel());
      assertEquals("the icon of the dummy picture", EnumIcons.warning(), textLabel.getIconType());
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const minDw:int = contentNotFound.getMinDw();
      const minDh:int = contentNotFound.getMinDh();
      assertTrue("getMinDw holds the text and the two paddings", minDw > 2 * padding);
      assertTrue("getMinDh holds the text and the two paddings", minDh > 2 * padding);
      runWideTests(contentNotFound, minDw, minDh);
      runNarrowTests(contentNotFound, minDw, minDh);
      contentNotFound.setDwh(2 * minDw, 2 * minDh);
      runBaseSpriteTests(contentNotFound);
      removeTested(contentNotFound);
    }
    /**
     * Checks a wide area: the text stands in one single line in the middle of it.
     * @param contentNotFound the object to be tested
     * @param minDw the smallest width of that object
     * @param minDh the smallest height of that object
     */
    private function runWideTests(contentNotFound:ContentNotFound, minDw:int, minDh:int):void
    {
      contentNotFound.setDwh(2 * minDw, 2 * minDh);
      assertEquals("getDw after setDwh", 2 * minDw, contentNotFound.getDw());
      assertEquals("getDh after setDwh", 2 * minDh, contentNotFound.getDh());
      const textLabel:TextLabel = contentNotFound.getTextLabel();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      assertEquals("the text of a wide area stands in one line", minDw - 2 * padding, textLabel.getDw());
      assertEquals("the text stands in the middle horizontally"
        , int((contentNotFound.getDw() - textLabel.getDw()) / 2), textLabel.getCx());
      assertEquals("the text stands in the middle vertically"
        , int((contentNotFound.getDh() - textLabel.getDh()) / 2), textLabel.getCy());
      assertEquals("the smallest width does not follow the area", minDw, contentNotFound.getMinDw());
      assertEquals("the smallest height does not follow the area", minDh, contentNotFound.getMinDh());
    }
    /**
     * Checks a narrow area: the text is broken into more lines inside the padding of it.
     * @param contentNotFound the object to be tested
     * @param minDw the smallest width of that object
     * @param minDh the smallest height of that object
     */
    private function runNarrowTests(contentNotFound:ContentNotFound, minDw:int, minDh:int):void
    {
      contentNotFound.setDwh(int(minDw / 2), 3 * minDh);
      const textLabel:TextLabel = contentNotFound.getTextLabel();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      assertTrue("the text of a narrow area is kept inside the padding"
        , textLabel.getDw() <= contentNotFound.getDw() - 2 * padding);
      assertTrue("the text of a narrow area is broken into more lines"
        , textLabel.getDh() > minDh - 2 * padding);
      assertEquals("the text of a narrow area starts at the padding", padding, textLabel.getCx());
      assertEquals("the smallest width is the one of the single line", minDw, contentNotFound.getMinDw());
    }
  }
}
