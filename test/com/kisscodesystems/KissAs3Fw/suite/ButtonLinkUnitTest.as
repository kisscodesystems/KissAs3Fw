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
 * ButtonLinkUnitTest
 * Checks the ButtonLink component.
 *
 * MAIN FEATURES:
 * - the label, the icon and the shape type of the link
 * - the dimensions of a link come from its content only
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ButtonLinkUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ButtonLinkUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ButtonLink";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const buttonLink:ButtonLink = new ButtonLink(application);
      addTested(buttonLink);
      buttonLink.setLabel("Kiss Code Systems");
      assertEquals("getLabel after setLabel", "Kiss Code Systems", buttonLink.getLabel());
      // the icon of the link
      assertEquals("getIconType without an icon", "", buttonLink.getIconType());
      buttonLink.setIcon(EnumIcons.switchon());
      assertEquals("getIconType after setIcon", EnumIcons.switchon(), buttonLink.getIconType());
      buttonLink.destIcon();
      assertEquals("getIconType after destIcon", "", buttonLink.getIconType());
      // the emoji of the link, standing in the very slot of the icon
      assertEquals("getEmojiType without an emoji", "", buttonLink.getEmojiType());
      buttonLink.setEmoji(EnumEmojis.hands_thumbsup());
      assertEquals("getEmojiType after setEmoji", EnumEmojis.hands_thumbsup(), buttonLink.getEmojiType());
      assertEquals("getIconType after setEmoji", "", buttonLink.getIconType());
      buttonLink.destIcon();
      assertEquals("getEmojiType after destIcon", "", buttonLink.getEmojiType());
      // the shape type of the link
      buttonLink.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      assertEquals("getType after setType"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT(), buttonLink.getType());
      buttonLink.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE());
      assertEquals("getType after the second setType"
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE(), buttonLink.getType());
      // the dimensions of a link can not be set from the outside
      const dwBefore:int = buttonLink.getDw();
      const dhBefore:int = buttonLink.getDh();
      buttonLink.setDw(500);
      assertEquals("getDw is not changed by setDw", dwBefore, buttonLink.getDw());
      buttonLink.setDh(500);
      assertEquals("getDh is not changed by setDh", dhBefore, buttonLink.getDh());
      buttonLink.setDwh(500, 500);
      assertEquals("getDw is not changed by setDwh", dwBefore, buttonLink.getDw());
      assertEquals("getDh is not changed by setDwh", dhBefore, buttonLink.getDh());
      // a long label is kept inside the maximum width. That width belongs to the label of
      // this button, the button itself stands around it with the padding of the
      // application on both sides: a caller sizing the whole button subtracts that
      // padding beforehand, as the music player of the demos does
      buttonLink.setLabel("Kiss Code Systems Kiss Code Systems Kiss Code Systems Kiss Code Systems");
      buttonLink.setMaxWidth(140, true);
      const paddingAroundTheLabel:int = 2 * application.getDynamicsConfig().getAppPadding();
      assertTrue("the width is not greater than the maximum width and the padding"
        , buttonLink.getDw() <= 140 + paddingAroundTheLabel);
      // the url and the post data have no state to read back
      buttonLink.setUrl("https://github.com/kisscodesystems/KissAs3Fw");
      buttonLink.setPostData(null, null);
      buttonLink.onRollOut();
      runBaseSpriteTests(buttonLink);
      removeTested(buttonLink);
    }
  }
}
