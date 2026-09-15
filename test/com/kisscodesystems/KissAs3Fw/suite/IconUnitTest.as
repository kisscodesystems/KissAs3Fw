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
 * IconUnitTest
 * Checks the Icon component.
 *
 * MAIN FEATURES:
 * - the drawing keeps the icon type, the text type and the icon size
 * - the dimensions of an icon come from its icon size only
 * - a drawing made outside the display list is still there once the icon lands on the
 *   stage: that landing draws it over again
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.display.BitmapData;
  public class IconUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function IconUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Icon";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const icon:Icon = new Icon(application);
      addTested(icon);
      // a fresh icon has nothing drawn into it
      assertEquals("getIconType of a fresh icon", "", icon.getIconType());
      assertEquals("getEmojiType of a fresh icon", "", icon.getEmojiType());
      assertEquals("getIconSize of a fresh icon", 0, icon.getIconSize());
      assertEquals("getDw of a fresh icon", 0, icon.getDw());
      // the drawing stores everything it has been called with
      icon.drawBitmapData(EnumIcons.switchon(), EnumTextTypes.TEXT_TYPE_BRIGHT(), 70);
      assertEquals("getIconType after drawBitmapData", EnumIcons.switchon(), icon.getIconType());
      assertEquals("getTextType after drawBitmapData", EnumTextTypes.TEXT_TYPE_BRIGHT(), icon.getTextType());
      assertEquals("getIconSize after drawBitmapData", 70, icon.getIconSize());
      assertEquals("getDw after drawBitmapData", expectedDw(70), icon.getDw());
      assertEquals("getDh after drawBitmapData", expectedDh(70), icon.getDh());
      // the dimensions of an icon can not be set from the outside
      icon.setDw(200);
      assertEquals("getDw is not changed by setDw", expectedDw(70), icon.getDw());
      icon.setDh(300);
      assertEquals("getDh is not changed by setDh", expectedDh(70), icon.getDh());
      icon.setDwh(400, 500);
      assertEquals("getDw is not changed by setDwh", expectedDw(70), icon.getDw());
      assertEquals("getDh is not changed by setDwh", expectedDh(70), icon.getDh());
      // a redraw with another size resizes the icon
      icon.drawBitmapData(EnumIcons.switchoff(), EnumTextTypes.TEXT_TYPE_DARK(), 40);
      assertEquals("getIconType after the second drawBitmapData", EnumIcons.switchoff(), icon.getIconType());
      assertEquals("getTextType after the second drawBitmapData", EnumTextTypes.TEXT_TYPE_DARK(), icon.getTextType());
      assertEquals("getDw after the second drawBitmapData", expectedDw(40), icon.getDw());
      // dropping the drawing drops the dimensions but keeps the type
      icon.destBitmapData();
      assertEquals("getDw after destBitmapData", 0, icon.getDw());
      assertEquals("getDh after destBitmapData", 0, icon.getDh());
      assertEquals("getIconType is kept after destBitmapData", EnumIcons.switchoff(), icon.getIconType());
      // an emoji and an icon are exclusive to each other in one icon object
      icon.drawEmojiBitmapData(EnumEmojis.hands_thumbsup(), 50);
      assertEquals("getEmojiType after drawEmojiBitmapData", EnumEmojis.hands_thumbsup(), icon.getEmojiType());
      assertEquals("getIconType after drawEmojiBitmapData", "", icon.getIconType());
      assertEquals("getIconSize after drawEmojiBitmapData", 50, icon.getIconSize());
      assertEquals("getDw after drawEmojiBitmapData", expectedDw(50), icon.getDw());
      assertEquals("getDh after drawEmojiBitmapData", expectedDh(50), icon.getDh());
      icon.drawBitmapData(EnumIcons.switchon(), EnumTextTypes.TEXT_TYPE_BRIGHT(), 70);
      assertEquals("getEmojiType after a drawBitmapData of an emoji icon", "", icon.getEmojiType());
      runBaseSpriteTests(icon);
      removeTested(icon);
      runOffStageDrawingTests();
    }
    /**
     * Checks that an icon drawn while it was standing outside the display list really
     * carries its drawing once it lands on the stage: that landing draws the icon over
     * again, and a repetition that lost the bitmap data of it would leave an empty square
     * behind.
     */
    private function runOffStageDrawingTests():void
    {
      const icon:Icon = new Icon(application);
      icon.drawBitmapData(EnumIcons.close(), EnumTextTypes.TEXT_TYPE_BRIGHT(), 40);
      assertTrue("the drawing of an icon outside the display list", drawnPixelsOf(icon) > 0);
      addTested(icon);
      assertEquals("getIconSize after the icon has landed on the stage", 40, icon.getIconSize());
      assertEquals("getDw after the icon has landed on the stage", expectedDw(40), icon.getDw());
      assertTrue("the drawing of an icon after it has landed on the stage", drawnPixelsOf(icon) > 0);
      // an emoji carries no drop shadow, so the repetition of it has no filter to build
      icon.drawEmojiBitmapData(EnumEmojis.hands_thumbsup(), 30);
      assertTrue("the drawing of an emoji icon on the stage", drawnPixelsOf(icon) > 0);
      removeTested(icon);
    }
    /**
     * Returns the number of the pixels the given icon has really drawn: the ones that are
     * not fully transparent.
     * @param icon the icon the drawn pixels are counted of
     */
    private function drawnPixelsOf(icon:Icon):int
    {
      const size:int = Math.max(1, icon.getIconSize());
      const bitmapData:BitmapData = new BitmapData(size, size, true, 0);
      bitmapData.draw(icon);
      var drawn:int = 0;
      for (var i:int = 0; i < size; i++)
      {
        for (var j:int = 0; j < size; j++)
        {
          if (bitmapData.getPixel32(i, j) >>> 24 > 0)
          {
            drawn++;
          }
        }
      }
      bitmapData.dispose();
      return drawn;
    }
  }
}
