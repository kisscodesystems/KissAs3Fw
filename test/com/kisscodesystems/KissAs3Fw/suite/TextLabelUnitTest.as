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
 * TextLabelUnitTest
 * Checks the TextLabel component.
 *
 * MAIN FEATURES:
 * - the label, the text type and the icon of the label
 * - the dimensions come from the content and from the maximum width
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class TextLabelUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function TextLabelUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "TextLabel";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const textLabel:TextLabel = new TextLabel(application);
      addTested(textLabel);
      assertNotNull("getBaseTextField", textLabel.getBaseTextField());
      // the label is stored as it has been given, a text without a key is displayed as it is
      textLabel.setLabel("Kiss Code Systems");
      assertEquals("getLabel after setLabel", "Kiss Code Systems", textLabel.getLabel());
      assertEquals("the text of the base text field"
        , "Kiss Code Systems", textLabel.getBaseTextField().getText());
      // the text type is delegated to the base text field
      textLabel.setType(EnumTextTypes.TEXT_TYPE_DARK());
      assertEquals("getType after setType", EnumTextTypes.TEXT_TYPE_DARK(), textLabel.getType());
      assertEquals("the type of the base text field"
        , EnumTextTypes.TEXT_TYPE_DARK(), textLabel.getBaseTextField().getType());
      // a label without an icon has no icon object at all
      assertEquals("getIconType without an icon", "", textLabel.getIconType());
      assertNull("getIcon without an icon", textLabel.getIcon());
      const dwWithoutIcon:int = textLabel.getDw();
      textLabel.setIcon(EnumIcons.switchon());
      assertEquals("getIconType after setIcon", EnumIcons.switchon(), textLabel.getIconType());
      assertNotNull("getIcon after setIcon", textLabel.getIcon());
      assertTrue("the label with an icon is wider", textLabel.getDw() > dwWithoutIcon);
      textLabel.destIcon();
      assertEquals("getIconType after destIcon", "", textLabel.getIconType());
      assertNull("getIcon after destIcon", textLabel.getIcon());
      assertEquals("the width after destIcon", dwWithoutIcon, textLabel.getDw());
      // an empty icon type is refused
      textLabel.setIcon("");
      assertEquals("getIconType after setIcon with an empty type", "", textLabel.getIconType());
      assertNull("getIcon after setIcon with an empty type", textLabel.getIcon());
      // an emoji stands in the same slot as an icon, they are exclusive to each other
      assertEquals("getEmojiType without an emoji", "", textLabel.getEmojiType());
      textLabel.setEmoji(EnumEmojis.hands_thumbsup());
      assertEquals("getEmojiType after setEmoji", EnumEmojis.hands_thumbsup(), textLabel.getEmojiType());
      assertEquals("getIconType after setEmoji", "", textLabel.getIconType());
      assertNotNull("getIcon after setEmoji", textLabel.getIcon());
      assertTrue("the label with an emoji is wider", textLabel.getDw() > dwWithoutIcon);
      textLabel.setIcon(EnumIcons.switchon());
      assertEquals("getEmojiType after a setIcon of an emoji label", "", textLabel.getEmojiType());
      textLabel.destIcon();
      assertEquals("getEmojiType after destIcon", "", textLabel.getEmojiType());
      // an empty emoji type is refused
      textLabel.setEmoji("");
      assertEquals("getEmojiType after setEmoji with an empty type", "", textLabel.getEmojiType());
      assertNull("getIcon after setEmoji with an empty type", textLabel.getIcon());
      // the dimensions of a text label can not be set from the outside
      const dwBefore:int = textLabel.getDw();
      const dhBefore:int = textLabel.getDh();
      textLabel.setDw(500);
      assertEquals("getDw is not changed by setDw", dwBefore, textLabel.getDw());
      textLabel.setDh(500);
      assertEquals("getDh is not changed by setDh", dhBefore, textLabel.getDh());
      textLabel.setDwh(500, 500);
      assertEquals("getDw is not changed by setDwh", dwBefore, textLabel.getDw());
      assertEquals("getDh is not changed by setDwh", dhBefore, textLabel.getDh());
      // a long label is kept inside the maximum width
      textLabel.setLabel("Kiss Code Systems Kiss Code Systems Kiss Code Systems Kiss Code Systems");
      textLabel.setMaxWidth(120, true);
      assertTrue("the width is not greater than the maximum width", textLabel.getDw() <= 120);
      assertTrue("the multiline label is higher than one line", textLabel.getDh() > dhBefore);
      runBaseSpriteTests(textLabel);
      removeTested(textLabel);
    }
  }
}
