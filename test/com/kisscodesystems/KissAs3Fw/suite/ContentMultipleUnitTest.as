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
 * ContentMultipleUnitTest
 * Checks the ContentMultiple component.
 *
 * MAIN FEATURES:
 * - adding, finding and removing the single contents and the buttons above them
 * - the active content is the only visible one and its button is the active one
 * - the button bar takes the top of the object and the contents get what is left
 * - the contents hidden from the button bar and reachable by their index only
 * - every content call is forwarded to the single content of the given index
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class ContentMultipleUnitTest extends BaseUnitTest
  {
    private var changedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ContentMultipleUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ContentMultiple";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      changedCount = 0;
      const contentMultiple:ContentMultiple = new ContentMultiple(application);
      addTested(contentMultiple);
      contentMultiple.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), contentMultipleChanged);
      contentMultiple.setDwh(300, 200);
      assertEquals("getDw after setDwh", expectedDw(300), contentMultiple.getDw());
      assertEquals("getDh after setDwh", expectedDh(200), contentMultiple.getDh());
      // an object without contents has no button bar above them either
      assertEquals("getNumOfContents of a fresh object", 0, contentMultiple.getNumOfContents());
      assertEquals("getActiveIndex of a fresh object", -1, contentMultiple.getActiveIndex());
      assertEquals("getButtonBarCyAndHeight without buttons"
        , 0, contentMultiple.getButtonBarCyAndHeight());
      assertEquals("getContentDw is the whole width"
        , contentMultiple.getDw(), contentMultiple.getContentDw());
      assertEquals("getContentDh is the whole height without a button bar"
        , contentMultiple.getDh(), contentMultiple.getContentDh());
      assertNull("getBaseScroll of an index that holds no content", contentMultiple.getBaseScroll(0));
      assertNull("getBaseSprite of an index that holds no content", contentMultiple.getBaseSprite(0));
      // the contents are created together with their buttons, one label is used once only
      assertEquals("addContent returns the index of the new content"
        , 0, contentMultiple.addContent("first"));
      assertEquals("addContent of a content with an icon on its button"
        , 1, contentMultiple.addContent("second", EnumIcons.switchon()));
      assertEquals("addContent of the third content", 2, contentMultiple.addContent("third"));
      assertEquals("a label that is already in use is refused"
        , -1, contentMultiple.addContent("second"));
      assertEquals("getNumOfContents after the additions", 3, contentMultiple.getNumOfContents());
      assertEquals("getContentIndexByLabel of the first content"
        , 0, contentMultiple.getContentIndexByLabel("first"));
      assertEquals("getContentIndexByLabel of the second content"
        , 1, contentMultiple.getContentIndexByLabel("second"));
      assertEquals("getContentIndexByLabel of a label that is not there"
        , -1, contentMultiple.getContentIndexByLabel("fourth"));
      assertNotNull("getContentSingle of an existing content", contentMultiple.getContentSingle(0));
      assertNotNull("getBaseScroll of an existing content", contentMultiple.getBaseScroll(0));
      assertNotNull("getBaseSprite of an existing content", contentMultiple.getBaseSprite(0));
      // the button bar takes the top of this object, every content gets what is left below it
      assertTrue("the button bar has a height with buttons on it"
        , contentMultiple.getButtonBarCyAndHeight() > 0);
      assertEquals("getContentDh is the height without the button bar"
        , contentMultiple.getDh() - contentMultiple.getButtonBarCyAndHeight()
        , contentMultiple.getContentDh());
      assertEquals("the content is positioned below the button bar"
        , contentMultiple.getButtonBarCyAndHeight(), contentMultiple.getContentSingle(0).getCy());
      assertEquals("the content is positioned to the left edge"
        , 0, contentMultiple.getContentSingle(0).getCx());
      assertEquals("the width of the content"
        , expectedDw(contentMultiple.getContentDw()), contentMultiple.getContentSingle(0).getDw());
      assertEquals("the height of the content"
        , expectedDh(contentMultiple.getContentDh()), contentMultiple.getContentSingle(0).getDh());
      // only the active content is visible, and the changed event goes to the outside
      assertFalse("a content is not visible until it is activated"
        , contentMultiple.getContentSingle(0).visible);
      const changedBefore:int = changedCount;
      contentMultiple.setActiveIndex(1);
      assertEquals("getActiveIndex after setActiveIndex", 1, contentMultiple.getActiveIndex());
      assertTrue("the active content is visible", contentMultiple.getContentSingle(1).visible);
      assertFalse("the content before the active one is hidden"
        , contentMultiple.getContentSingle(0).visible);
      assertFalse("the content behind the active one is hidden"
        , contentMultiple.getContentSingle(2).visible);
      assertEquals("the changed event of the button bar is forwarded"
        , changedBefore + 1, changedCount);
      contentMultiple.setActiveIndex(1);
      assertEquals("no changed event without a real change", changedBefore + 1, changedCount);
      contentMultiple.setActiveIndex(99);
      assertEquals("an index above the last content is refused", 1, contentMultiple.getActiveIndex());
      assertEquals("no changed event on a refused index", changedBefore + 1, changedCount);
      contentMultiple.setActiveIndex(-1);
      assertEquals("minus one turns the active content off", -1, contentMultiple.getActiveIndex());
      assertFalse("no content is visible without an active one"
        , contentMultiple.getContentSingle(1).visible);
      contentMultiple.setActiveIndex(0);
      // the positioning of the elements belongs to the content of the given index
      contentMultiple.setElementsFix(0, 2);
      assertEquals("getElementsFix after setElementsFix", 2, contentMultiple.getElementsFix(0));
      assertEquals("getElementsFix of a content that has not been told"
        , -1, contentMultiple.getElementsFix(1));
      assertEquals("getElementsFix of an index that holds no content"
        , 0, contentMultiple.getElementsFix(99));
      contentMultiple.setOrientation(0, EnumOrientations.ORIENTATION_HORIZONTAL());
      const firstContent:ContentSingle = contentMultiple.getContentSingle(0);
      const secondContent:ContentSingle = contentMultiple.getContentSingle(1);
      assertEquals("the orientation of the content of the given index"
        , EnumOrientations.ORIENTATION_HORIZONTAL(), firstContent.getOrientation());
      assertEquals("the orientation of the other content is untouched"
        , EnumOrientations.ORIENTATION_VERTICAL(), secondContent.getOrientation());
      // the elements go into the content of the given index and nowhere else
      const first:TextLabel = new TextLabel(application);
      first.setLabel("the element of the first content");
      const second:TextLabel = new TextLabel(application);
      second.setLabel("the element of the second content");
      assertEquals("getCellIndex of an element that is not in the content"
        , -1, contentMultiple.getCellIndex(0, first));
      contentMultiple.addToContent(0, first, 0);
      contentMultiple.addToContent(1, second, 3);
      assertEquals("getCellIndex of the element of the first content"
        , 0, contentMultiple.getCellIndex(0, first));
      assertEquals("getCellIndex of the element of the second content"
        , 3, contentMultiple.getCellIndex(1, second));
      assertEquals("an element is not in the content it has not been added to"
        , -1, contentMultiple.getCellIndex(1, first));
      assertEquals("getCellIndex of an index that holds no content"
        , -1, contentMultiple.getCellIndex(99, first));
      assertTrue("the element is inside the base sprite of its own content"
        , contentMultiple.getBaseSprite(0).contains(first));
      assertFalse("the element is not inside the base sprite of the other content"
        , contentMultiple.getBaseSprite(1).contains(first));
      contentMultiple.changeCellIndex(0, first, 5);
      assertEquals("getCellIndex after changeCellIndex", 5, contentMultiple.getCellIndex(0, first));
      contentMultiple.removeFromContent(0, first);
      assertEquals("getCellIndex of the removed element", -1, contentMultiple.getCellIndex(0, first));
      assertFalse("the removed element is out of the base sprite"
        , contentMultiple.getBaseSprite(0).contains(first));
      first.destroy();
      contentMultiple.removeFromContent(1, second);
      second.destroy();
      // a hidden button bar gives its place to the contents
      contentMultiple.setButtonBarVisible(false);
      assertEquals("getButtonBarCyAndHeight with a hidden button bar"
        , 0, contentMultiple.getButtonBarCyAndHeight());
      assertEquals("getContentDh with a hidden button bar"
        , contentMultiple.getDh(), contentMultiple.getContentDh());
      assertEquals("the content is at the top with a hidden button bar"
        , 0, contentMultiple.getContentSingle(0).getCy());
      contentMultiple.setButtonBarVisible(true);
      assertTrue("getButtonBarCyAndHeight with a visible button bar again"
        , contentMultiple.getButtonBarCyAndHeight() > 0);
      assertEquals("the content is below the button bar again"
        , contentMultiple.getButtonBarCyAndHeight(), contentMultiple.getContentSingle(0).getCy());
      // the button of one single content can be hidden, that content stays reachable
      const buttonBarHeightWithEveryButton:int = contentMultiple.getButtonBarCyAndHeight();
      assertTrue("the button of a fresh content is on the bar"
        , contentMultiple.getContentButtonVisible(1));
      assertFalse("getContentButtonVisible of an index that holds no content"
        , contentMultiple.getContentButtonVisible(99));
      contentMultiple.setContentButtonVisible(1, false);
      assertFalse("getContentButtonVisible after setContentButtonVisible"
        , contentMultiple.getContentButtonVisible(1));
      assertEquals("the content of the hidden button keeps its index"
        , 1, contentMultiple.getContentIndexByLabel("second"));
      assertEquals("the contents behind the hidden button keep their indexes"
        , 2, contentMultiple.getContentIndexByLabel("third"));
      // the content of a hidden button is reached from the inside of the application
      const changedBeforeHiding:int = changedCount;
      contentMultiple.setActiveIndex(1);
      assertEquals("the content of a hidden button can be activated"
        , 1, contentMultiple.getActiveIndex());
      assertTrue("the content of a hidden button is visible when it is the active one"
        , contentMultiple.getContentSingle(1).visible);
      assertEquals("the changed event of a hidden button is forwarded as well"
        , changedBeforeHiding + 1, changedCount);
      // an object of hidden buttons only gives the whole height to its contents
      contentMultiple.setContentButtonVisible(0, false);
      contentMultiple.setContentButtonVisible(2, false);
      assertEquals("getButtonBarCyAndHeight with every button hidden"
        , 0, contentMultiple.getButtonBarCyAndHeight());
      assertEquals("getContentDh with every button hidden"
        , contentMultiple.getDh(), contentMultiple.getContentDh());
      assertEquals("the content is at the top with every button hidden"
        , 0, contentMultiple.getContentSingle(1).getCy());
      assertEquals("the active content is untouched by the hiding of the buttons"
        , 1, contentMultiple.getActiveIndex());
      // every button shown again gives the very same button bar back
      contentMultiple.setContentButtonVisible(0, true);
      contentMultiple.setContentButtonVisible(1, true);
      contentMultiple.setContentButtonVisible(2, true);
      assertTrue("getContentButtonVisible after the button has been shown again"
        , contentMultiple.getContentButtonVisible(1));
      assertEquals("getButtonBarCyAndHeight after every button has been shown again"
        , buttonBarHeightWithEveryButton, contentMultiple.getButtonBarCyAndHeight());
      assertEquals("the content is below the button bar again"
        , contentMultiple.getButtonBarCyAndHeight(), contentMultiple.getContentSingle(1).getCy());
      contentMultiple.setActiveIndex(0);
      // every dimension of this object is handed down to every content
      contentMultiple.setDwh(400, 300);
      assertEquals("getDw after setDwh", expectedDw(400), contentMultiple.getDw());
      assertEquals("getDh after setDwh", expectedDh(300), contentMultiple.getDh());
      assertEquals("the width of every content follows setDwh"
        , expectedDw(contentMultiple.getContentDw()), contentMultiple.getContentSingle(2).getDw());
      assertEquals("the height of every content follows setDwh"
        , expectedDh(contentMultiple.getContentDh()), contentMultiple.getContentSingle(2).getDh());
      contentMultiple.setDw(500);
      assertEquals("getDw after setDw", expectedDw(500), contentMultiple.getDw());
      assertEquals("the width of every content follows setDw"
        , expectedDw(contentMultiple.getContentDw()), contentMultiple.getContentSingle(2).getDw());
      contentMultiple.setDh(400);
      assertEquals("getDh after setDh", expectedDh(400), contentMultiple.getDh());
      assertEquals("the height of every content follows setDh"
        , expectedDh(contentMultiple.getContentDh()), contentMultiple.getContentSingle(2).getDh());
      // the scrolled content of one single content is independent of the others
      contentMultiple.setDwhContent(0, 1000, 800);
      contentMultiple.setDwhContent(1, 600, 500);
      assertEquals("getDwContent of the first content", 1000, contentMultiple.getDwContent(0));
      assertEquals("getDhContent of the first content", 800, contentMultiple.getDhContent(0));
      assertEquals("getDwContent of the second content", 600, contentMultiple.getDwContent(1));
      assertEquals("getDhContent of the second content", 500, contentMultiple.getDhContent(1));
      assertEquals("getDwContent of an index that holds no content"
        , 0, contentMultiple.getDwContent(99));
      assertEquals("getDhContent of an index that holds no content"
        , 0, contentMultiple.getDhContent(99));
      firstContent.toRight();
      firstContent.toBottom();
      assertTrue("the content x is scrolled away from its origin"
        , contentMultiple.getBaseScroll(0).getCxContent() < 0);
      assertTrue("the content y is scrolled away from its origin"
        , contentMultiple.getBaseScroll(0).getCyContent() < 0);
      contentMultiple.setContentPosition(0, 0, 0, false);
      assertEquals("the content x after setContentPosition"
        , 0, contentMultiple.getBaseScroll(0).getCxContent());
      assertEquals("the content y after setContentPosition"
        , 0, contentMultiple.getBaseScroll(0).getCyContent());
      assertTrue("setContentPosition leaves the other content alone"
        , contentMultiple.getBaseScroll(1).getCxContent() == 0);
      // the icons of the buttons have no getters, they must not break the indexes
      contentMultiple.setIcon(0, EnumIcons.switchoff());
      contentMultiple.destIcon(0);
      contentMultiple.setActiveIndex(2);
      contentMultiple.setIconIfNotActive(2, EnumIcons.switchon());
      contentMultiple.setIconIfNotActive(0, EnumIcons.switchon());
      assertEquals("the active index survives the icon changes", 2, contentMultiple.getActiveIndex());
      assertEquals("the labels survive the icon changes"
        , 1, contentMultiple.getContentIndexByLabel("second"));
      // an emoji stands in the very same slot an icon does, so it must not break the
      // indexes and the labels either
      contentMultiple.setEmoji(0, EnumEmojis.hands_thumbsup());
      contentMultiple.setEmojiIfNotActive(2, EnumEmojis.hearts_heart());
      contentMultiple.setEmojiIfNotActive(0, EnumEmojis.hearts_heart());
      assertEquals("the active index survives the emoji changes"
        , 2, contentMultiple.getActiveIndex());
      assertEquals("the labels survive the emoji changes"
        , 1, contentMultiple.getContentIndexByLabel("second"));
      // a removal behind the active content leaves the active one where it is
      assertEquals("addContent of the fourth content", 3, contentMultiple.addContent("fourth"));
      contentMultiple.setActiveIndex(1);
      contentMultiple.removeContent(3);
      assertEquals("getNumOfContents after a removal behind the active content"
        , 3, contentMultiple.getNumOfContents());
      assertEquals("the active index is kept on a removal behind it"
        , 1, contentMultiple.getActiveIndex());
      assertEquals("the active button is kept on a removal behind it"
        , 1, contentMultiple.getContentIndexByLabel("second"));
      assertTrue("the very same content is visible after a removal behind it"
        , contentMultiple.getContentSingle(1).visible);
      // a removal without an active content leaves every content hidden
      assertEquals("addContent of the fourth content again", 3, contentMultiple.addContent("fourth"));
      contentMultiple.setActiveIndex(-1);
      contentMultiple.removeContent(3);
      assertEquals("getActiveIndex after a removal without an active content"
        , -1, contentMultiple.getActiveIndex());
      assertFalse("no content is visible after a removal without an active content"
        , contentMultiple.getContentSingle(0).visible);
      // removing one content removes its button as well and shifts the ones behind it
      contentMultiple.setActiveIndex(2);
      contentMultiple.removeContent(0);
      assertEquals("getNumOfContents after removeContent", 2, contentMultiple.getNumOfContents());
      assertEquals("the removed content is not found by its label any more"
        , -1, contentMultiple.getContentIndexByLabel("first"));
      assertEquals("the content behind the removed one has taken its place"
        , 0, contentMultiple.getContentIndexByLabel("second"));
      assertEquals("the active index follows a removal before it"
        , 1, contentMultiple.getActiveIndex());
      assertEquals("the active button is still the very same one"
        , 1, contentMultiple.getContentIndexByLabel("third"));
      // the visible content and the active button always tell the same
      assertTrue("the content of the active index is the visible one"
        , contentMultiple.getContentSingle(contentMultiple.getActiveIndex()).visible);
      contentMultiple.removeContent(99);
      assertEquals("an index that holds no content removes nothing"
        , 2, contentMultiple.getNumOfContents());
      contentMultiple.removeContent(-1);
      assertEquals("a negative index removes nothing", 2, contentMultiple.getNumOfContents());
      // the active index is turned off together with the content it belongs to
      contentMultiple.setActiveIndex(1);
      contentMultiple.removeContent(1);
      assertEquals("getNumOfContents after the active content has been removed"
        , 1, contentMultiple.getNumOfContents());
      assertEquals("getActiveIndex after the active content has been removed"
        , -1, contentMultiple.getActiveIndex());
      assertFalse("no content is visible after the active one has been removed"
        , contentMultiple.getContentSingle(0).visible);
      // an emptied object is the fresh one again
      contentMultiple.removeAllContents();
      assertEquals("getNumOfContents after removeAllContents", 0, contentMultiple.getNumOfContents());
      assertEquals("getActiveIndex after removeAllContents", -1, contentMultiple.getActiveIndex());
      assertEquals("no content is found by its label after removeAllContents"
        , -1, contentMultiple.getContentIndexByLabel("second"));
      assertEquals("getButtonBarCyAndHeight after removeAllContents"
        , 0, contentMultiple.getButtonBarCyAndHeight());
      // a hidden content is created with its button already hidden
      assertEquals("addHiddenContent returns the index of the new content"
        , 0, contentMultiple.addHiddenContent("hidden"));
      assertEquals("addContent of a content next to the hidden one"
        , 1, contentMultiple.addContent("shown"));
      assertFalse("the button of the hidden content is not on the bar"
        , contentMultiple.getContentButtonVisible(0));
      assertTrue("the button of the other content is on the bar"
        , contentMultiple.getContentButtonVisible(1));
      assertEquals("the hidden content is found by its label"
        , 0, contentMultiple.getContentIndexByLabel("hidden"));
      assertEquals("the label of a hidden content is used once only"
        , -1, contentMultiple.addHiddenContent("hidden"));
      assertEquals("addHiddenContent of a label that is already on the bar"
        , -1, contentMultiple.addHiddenContent("shown"));
      assertEquals("getNumOfContents after the refused additions"
        , 2, contentMultiple.getNumOfContents());
      contentMultiple.setActiveIndex(0);
      assertTrue("the hidden content is visible when it is the active one"
        , contentMultiple.getContentSingle(0).visible);
      // a hidden content is removed the very same way as any other one
      contentMultiple.removeContent(0);
      assertEquals("getNumOfContents after the hidden content has been removed"
        , 1, contentMultiple.getNumOfContents());
      assertEquals("the content behind the hidden one has taken its place"
        , 0, contentMultiple.getContentIndexByLabel("shown"));
      assertTrue("the button of that content is still on the bar"
        , contentMultiple.getContentButtonVisible(0));
      contentMultiple.removeAllContents();
      // the default content is the one and only content, without a button bar above it
      contentMultiple.setDefaultContent();
      assertEquals("getNumOfContents after setDefaultContent", 1, contentMultiple.getNumOfContents());
      assertEquals("getActiveIndex after setDefaultContent", 0, contentMultiple.getActiveIndex());
      assertTrue("the default content is visible", contentMultiple.getContentSingle(0).visible);
      assertEquals("no button bar above the default content"
        , 0, contentMultiple.getButtonBarCyAndHeight());
      assertEquals("the default content takes the whole height"
        , contentMultiple.getDh(), contentMultiple.getContentDh());
      runBaseSpriteTests(contentMultiple);
      contentMultiple.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_CHANGED(), contentMultipleChanged);
      removeTested(contentMultiple);
    }
    /**
     * Counts the changed events forwarded by the tested object.
     * @param e the changed event
     */
    private function contentMultipleChanged(e:Event):void
    {
      changedCount++;
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
    }
  }
}
