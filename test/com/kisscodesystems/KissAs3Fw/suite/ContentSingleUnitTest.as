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
 * ContentSingleUnitTest
 * Checks the ContentSingle component.
 *
 * MAIN FEATURES:
 * - the orientation and the automatic positioning of the elements
 * - adding elements to the content and removing them from it
 * - the aligns of an element inside its own cell and the fill of a whole cell
 * - the flowing and the docking layouts, and the gap factor of every layout
 * - the dimensions of the scrolled content and the scrolling to the edges
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDocks;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class ContentSingleUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ContentSingleUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "ContentSingle";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const contentSingle:ContentSingle = new ContentSingle(application);
      addTested(contentSingle);
      assertNotNull("getBaseScroll", contentSingle.getBaseScroll());
      assertNotNull("getBaseSprite", contentSingle.getBaseSprite());
      // a content takes both of the dimensions it is given and hands them to its scroll
      contentSingle.setDwh(200, 150);
      assertEquals("getDw after setDwh", expectedDw(200), contentSingle.getDw());
      assertEquals("getDh after setDwh", expectedDh(150), contentSingle.getDh());
      assertEquals("the width of the base scroll"
        , contentSingle.getDw(), contentSingle.getBaseScroll().getDw());
      assertEquals("the height of the base scroll"
        , contentSingle.getDh(), contentSingle.getBaseScroll().getDh());
      // the dimensions of the scrolled content are independent of the dimensions of the content
      contentSingle.setDwhContent(1000, 800);
      assertEquals("getDwContent after setDwhContent", 1000, contentSingle.getDwContent());
      assertEquals("getDhContent after setDwhContent", 800, contentSingle.getDhContent());
      assertEquals("getDw is not changed by setDwhContent"
        , expectedDw(200), contentSingle.getDw());
      // a fresh content is vertical and positions its elements one under the other
      assertEquals("getOrientation of a fresh content"
        , EnumOrientations.ORIENTATION_VERTICAL(), contentSingle.getOrientation());
      assertEquals("getElementsFix of a fresh content", -1, contentSingle.getElementsFix());
      assertFalse("getAutomaticPositioning without a fix element count"
        , contentSingle.getAutomaticPositioning());
      contentSingle.setElementsFix(2);
      assertEquals("getElementsFix after setElementsFix", 2, contentSingle.getElementsFix());
      assertTrue("getAutomaticPositioning with a fix element count"
        , contentSingle.getAutomaticPositioning());
      contentSingle.setOrientation(EnumOrientations.ORIENTATION_HORIZONTAL());
      assertEquals("getOrientation after setOrientation"
        , EnumOrientations.ORIENTATION_HORIZONTAL(), contentSingle.getOrientation());
      contentSingle.setOrientation(EnumOrientations.ORIENTATION_MANUAL());
      assertFalse("getAutomaticPositioning of a manual content"
        , contentSingle.getAutomaticPositioning());
      contentSingle.setOrientation("thisIsNotAnOrientation");
      assertEquals("an orientation that does not exist is refused"
        , EnumOrientations.ORIENTATION_MANUAL(), contentSingle.getOrientation());
      contentSingle.setOrientation(EnumOrientations.ORIENTATION_VERTICAL());
      // the elements of the content
      const first:TextLabel = new TextLabel(application);
      first.setLabel("the first element");
      const second:TextLabel = new TextLabel(application);
      second.setLabel("the second element");
      assertEquals("getCellIndex of an element that is not in the content"
        , -1, contentSingle.getCellIndex(first));
      contentSingle.addToContent(first, 0);
      contentSingle.addToContent(second, 1);
      assertEquals("getCellIndex of the first element", 0, contentSingle.getCellIndex(first));
      assertEquals("getCellIndex of the second element", 1, contentSingle.getCellIndex(second));
      assertTrue("the first element is inside the base sprite"
        , contentSingle.getBaseSprite().contains(first));
      contentSingle.changeCellIndex(second, 5);
      assertEquals("getCellIndex after changeCellIndex", 5, contentSingle.getCellIndex(second));
      contentSingle.removeFromContent(second);
      assertEquals("getCellIndex of the removed element", -1, contentSingle.getCellIndex(second));
      assertFalse("the removed element is out of the base sprite"
        , contentSingle.getBaseSprite().contains(second));
      second.destroy();
      // the recalculation sizes the base sprite to the elements it holds
      contentSingle.contentDimensionsRecalculation();
      assertTrue("the base sprite has a width after the recalculation"
        , contentSingle.getBaseSprite().getDw() > 0);
      // scrolling to the edges of the content
      contentSingle.setDwhContent(1000, 800);
      contentSingle.toTop();
      assertEquals("the content y after toTop", 0, contentSingle.getBaseScroll().getCyContent());
      contentSingle.toBottom();
      assertEquals("the content y after toBottom"
        , contentSingle.getDh() - contentSingle.getDhContent()
        , contentSingle.getBaseScroll().getCyContent());
      contentSingle.toLeft();
      assertEquals("the content x after toLeft", 0, contentSingle.getBaseScroll().getCxContent());
      contentSingle.toRight();
      assertEquals("the content x after toRight"
        , contentSingle.getDw() - contentSingle.getDwContent()
        , contentSingle.getBaseScroll().getCxContent());
      contentSingle.setContentPosition(0, 0, false);
      assertEquals("the content x after setContentPosition"
        , 0, contentSingle.getBaseScroll().getCxContent());
      assertEquals("the content y after setContentPosition"
        , 0, contentSingle.getBaseScroll().getCyContent());
      // the aligns and the fill work on the elements of a two column content: the cell of
      // an element is as wide as the widest cell of its column and as tall as the tallest
      // cell of its row, and the aligns place that element inside that cell
      const aligned:ContentSingle = new ContentSingle(application);
      addTested(aligned);
      aligned.setOrientation(EnumOrientations.ORIENTATION_VERTICAL());
      aligned.setElementsFix(1);
      const tall:BaseSprite = new BaseSprite(application);
      tall.setDwh(120, 90);
      const label:TextLabel = new TextLabel(application);
      label.setLabel("an aligned label");
      const narrow:BaseSprite = new BaseSprite(application);
      narrow.setDwh(40, 30);
      aligned.addToContent(tall, 0);
      aligned.addToContent(label, 1);
      aligned.addToContent(narrow, 2);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      // the first column is as wide as the wider one of the elements standing in it, the
      // first row is as tall as the taller one of the elements standing in it
      const columnDw:int = Math.max(tall.getDw(), narrow.getDw());
      const rowDh:int = Math.max(tall.getDh(), label.getDh());
      assertNull("getElementAlignHorizontal of an element of another content"
        , aligned.getElementAlignHorizontal(first));
      assertNull("getElementAlignVertical of an element of another content"
        , aligned.getElementAlignVertical(first));
      assertFalse("getElementFill of an element of another content"
        , aligned.getElementFill(first));
      assertEquals("the horizontal align of a fresh element"
        , EnumAligns.ALIGN_LEFT(), aligned.getElementAlignHorizontal(narrow));
      assertEquals("the vertical align of a fresh element"
        , EnumAligns.ALIGN_TOP(), aligned.getElementAlignVertical(narrow));
      assertEquals("the left aligned element stands at the left of its cell"
        , margin, int(narrow.x));
      aligned.setElementAlignHorizontal(narrow, EnumAligns.ALIGN_RIGHT());
      assertEquals("getElementAlignHorizontal after setElementAlignHorizontal"
        , EnumAligns.ALIGN_RIGHT(), aligned.getElementAlignHorizontal(narrow));
      assertEquals("the right aligned element stands at the right of its cell"
        , margin + columnDw - narrow.getDw(), int(narrow.x));
      aligned.setElementAlignHorizontal(narrow, EnumAligns.ALIGN_CENTER());
      assertEquals("the centered element stands in the middle of its cell"
        , margin + int((columnDw - narrow.getDw()) / 2), int(narrow.x));
      aligned.setElementAlignHorizontal(narrow, EnumAligns.ALIGN_TOP());
      assertEquals("a vertical align is refused by the horizontal setter"
        , EnumAligns.ALIGN_CENTER(), aligned.getElementAlignHorizontal(narrow));
      // a label stands a padding under the top of its cell, but an explicit vertical
      // align tells where that label has to stand, so it loses that padding then
      assertEquals("the label of the first row stands a padding under the top of its cell"
        , margin + padding, int(label.y));
      aligned.setElementAlignVertical(label, EnumAligns.ALIGN_BOTTOM());
      assertEquals("getElementAlignVertical after setElementAlignVertical"
        , EnumAligns.ALIGN_BOTTOM(), aligned.getElementAlignVertical(label));
      assertEquals("the bottom aligned label stands at the bottom of its cell"
        , margin + rowDh - label.getDh(), int(label.y));
      aligned.setElementAlignVertical(label, EnumAligns.ALIGN_MIDDLE());
      assertEquals("the middle aligned label stands in the middle of its cell"
        , margin + int((rowDh - label.getDh()) / 2), int(label.y));
      aligned.setElementAlignVertical(label, EnumAligns.ALIGN_LEFT());
      assertEquals("a horizontal align is refused by the vertical setter"
        , EnumAligns.ALIGN_MIDDLE(), aligned.getElementAlignVertical(label));
      // an element that does not count in the cell dimensions can fill its whole cell
      const filler:BaseSprite = new BaseSprite(application);
      aligned.addToContent(filler, 0, false, true);
      assertFalse("getElementFill of a fresh element", aligned.getElementFill(filler));
      aligned.setElementFill(filler, true);
      assertTrue("getElementFill after setElementFill", aligned.getElementFill(filler));
      assertEquals("the filling element is as wide as its cell", columnDw, filler.getDw());
      assertEquals("the filling element is as tall as its cell", rowDh, filler.getDh());
      assertEquals("the filling element stands at the left of its cell", margin, int(filler.x));
      assertEquals("the filling element stands at the top of its cell", margin, int(filler.y));
      assertEquals("the filling element leaves the width of its cell alone"
        , columnDw, Math.max(tall.getDw(), narrow.getDw()));
      // the filling element is left out of the dimensions of its cell completely, so it
      // does not pin that cell to the size it has been given before: it follows a
      // shrinking cell down as well
      tall.setDwh(tall.getDw(), 60);
      assertEquals("the filling element follows its shrinking cell"
        , Math.max(tall.getDh(), label.getDh()), filler.getDh());
      // the fill of an element counting in the cell dimensions is stored but not applied
      const counted:BaseSprite = new BaseSprite(application);
      counted.setDwh(50, 40);
      aligned.addToContent(counted, 2);
      aligned.setElementFill(counted, true);
      assertTrue("getElementFill of a counting element", aligned.getElementFill(counted));
      assertEquals("the fill of a counting element does not size it"
        , expectedDw(50), counted.getDw());
      removeTested(aligned);
      // the room between the elements and around them is counted in the margins of the
      // application: one margin by default, none at all with a factor of zero
      const gapped:ContentSingle = new ContentSingle(application);
      addTested(gapped);
      gapped.setOrientation(EnumOrientations.ORIENTATION_VERTICAL());
      gapped.setElementsFix(0);
      const upper:BaseSprite = new BaseSprite(application);
      upper.setDwh(60, 40);
      const lower:BaseSprite = new BaseSprite(application);
      lower.setDwh(80, 30);
      gapped.addToContent(upper, 0);
      gapped.addToContent(lower, 1);
      assertEquals("the gap factor of a fresh content", 1, gapped.getGapFactor());
      assertEquals("the first element stands one margin from the corner"
        , margin, int(upper.x));
      assertEquals("the second element stands one margin below the first one"
        , margin + upper.getDh() + margin, int(lower.y));
      gapped.setGapFactor(0);
      assertEquals("getGapFactor after setGapFactor", 0, gapped.getGapFactor());
      assertEquals("no gap puts the first element into the corner", 0, int(upper.x));
      assertEquals("no gap joins the second element to the first one"
        , upper.getDh(), int(lower.y));
      gapped.setGapFactor(2);
      assertEquals("two margins of gap stand in front of the first element"
        , 2 * margin, int(upper.x));
      assertEquals("two margins of gap stand between the elements"
        , 2 * margin + upper.getDh() + 2 * margin, int(lower.y));
      gapped.setGapFactor(-1);
      assertEquals("a gap factor below zero is refused", 2, gapped.getGapFactor());
      removeTested(gapped);
      // the flowing layout places the elements next to each other and breaks the row
      // every time the width of the content has been filled up
      const flowing:ContentSingle = new ContentSingle(application);
      addTested(flowing);
      flowing.setOrientation(EnumOrientations.ORIENTATION_FLOW());
      assertEquals("getOrientation of a flowing content"
        , EnumOrientations.ORIENTATION_FLOW(), flowing.getOrientation());
      assertTrue("a flowing content needs no fix element count"
        , flowing.getAutomaticPositioning());
      // this width takes two of the elements below and breaks the row in front of the third
      flowing.setDwh(3 * margin + 120, 500);
      assertEquals("the flowing content has the width it has been given"
        , 3 * margin + 120, flowing.getDw());
      const firstOfTheRow:BaseSprite = new BaseSprite(application);
      firstOfTheRow.setDwh(60, 40);
      const secondOfTheRow:BaseSprite = new BaseSprite(application);
      secondOfTheRow.setDwh(60, 20);
      const brokenToTheNextRow:BaseSprite = new BaseSprite(application);
      brokenToTheNextRow.setDwh(60, 30);
      flowing.addToContent(firstOfTheRow, 0);
      flowing.addToContent(secondOfTheRow, 0);
      flowing.addToContent(brokenToTheNextRow, 0);
      assertEquals("the first element of the row stands at the gap", margin, int(firstOfTheRow.x));
      assertEquals("the second element follows the first one"
        , 2 * margin + firstOfTheRow.getDw(), int(secondOfTheRow.x));
      assertEquals("the second element stands in the very same row"
        , int(firstOfTheRow.y), int(secondOfTheRow.y));
      assertEquals("the third element has been broken to the next row"
        , margin, int(brokenToTheNextRow.x));
      assertEquals("the next row stands below the tallest element of the first one"
        , 2 * margin + firstOfTheRow.getDh(), int(brokenToTheNextRow.y));
      // a row is as tall as its tallest element and the vertical align places the
      // shorter ones inside it
      flowing.setElementAlignVertical(secondOfTheRow, EnumAligns.ALIGN_MIDDLE());
      assertEquals("the shorter element stands in the middle of its row"
        , margin + int((firstOfTheRow.getDh() - secondOfTheRow.getDh()) / 2)
        , int(secondOfTheRow.y));
      // a wider content takes one more element into the first row by itself
      flowing.setDwh(4 * margin + 180, 500);
      assertEquals("the third element has been taken back into the first row"
        , 3 * margin + 2 * firstOfTheRow.getDw(), int(brokenToTheNextRow.x));
      assertEquals("the third element stands in the first row"
        , margin, int(brokenToTheNextRow.y));
      // a row that has not been filled up keeps free space at its end, and the horizontal
      // align of an element moves the whole row it stands in inside that space. This width
      // takes all the three elements and leaves the width of one more of them empty.
      flowing.setDwh(4 * margin + 240, 500);
      const rowFreeSpace:int = flowing.getDw()
        - (margin + 3 * (firstOfTheRow.getDw() + margin));
      assertTrue("the row of the three elements has free space left", rowFreeSpace > 0);
      assertEquals("the row aligned to the left starts at the gap", margin, int(firstOfTheRow.x));
      flowing.setElementAlignHorizontal(firstOfTheRow, EnumAligns.ALIGN_RIGHT());
      flowing.setElementAlignHorizontal(secondOfTheRow, EnumAligns.ALIGN_RIGHT());
      flowing.setElementAlignHorizontal(brokenToTheNextRow, EnumAligns.ALIGN_RIGHT());
      assertEquals("the row aligned to the right starts at the end of the free space"
        , margin + rowFreeSpace, int(firstOfTheRow.x));
      assertEquals("the whole row aligned to the right has been moved"
        , 2 * margin + firstOfTheRow.getDw() + rowFreeSpace, int(secondOfTheRow.x));
      assertEquals("the last element of the row ends at the gap of the far side"
        , flowing.getDw() - margin
        , int(brokenToTheNextRow.x) + brokenToTheNextRow.getDw());
      flowing.setElementAlignHorizontal(firstOfTheRow, EnumAligns.ALIGN_CENTER());
      flowing.setElementAlignHorizontal(secondOfTheRow, EnumAligns.ALIGN_CENTER());
      flowing.setElementAlignHorizontal(brokenToTheNextRow, EnumAligns.ALIGN_CENTER());
      assertEquals("the centered row stands in the middle of the free space"
        , margin + int(rowFreeSpace / 2), int(firstOfTheRow.x));
      // every row of a flowing content is aligned inside the free space of that very row:
      // this width breaks the third element into a row of its own again, where it has
      // more room left to be centered in than the full row above it has
      flowing.setDwh(3 * margin + 120, 500);
      const brokenRowFreeSpace:int = flowing.getDw()
        - (2 * margin + brokenToTheNextRow.getDw());
      assertTrue("the row of one element has more free space than the full row"
        , brokenRowFreeSpace > rowFreeSpace);
      assertEquals("the broken row is centered inside the free space of its own"
        , margin + int(brokenRowFreeSpace / 2), int(brokenToTheNextRow.x));
      removeTested(flowing);
      // the docking layout gives every element a strip of the room the ones before it
      // have left, and the element of the center takes the whole of that room
      const docked:ContentSingle = new ContentSingle(application);
      addTested(docked);
      docked.setOrientation(EnumOrientations.ORIENTATION_DOCK());
      assertTrue("a docking content needs no fix element count"
        , docked.getAutomaticPositioning());
      docked.setDwh(300, 200);
      const header:BaseSprite = new BaseSprite(application);
      header.setDwh(50, 30);
      const sidebar:BaseSprite = new BaseSprite(application);
      sidebar.setDwh(40, 10);
      const body:BaseSprite = new BaseSprite(application);
      body.setDwh(10, 10);
      docked.addToContent(header, 0);
      docked.addToContent(sidebar, 0);
      docked.addToContent(body, 0);
      // a docked element keeps its own dimensions, so the dock of it can be changed at
      // any time: the strip it takes is always as thick as the element itself
      assertEquals("the docked element keeps its own width", 50, header.getDw());
      assertEquals("the docked element keeps its own height", 30, header.getDh());
      assertEquals("the dock of a fresh element", EnumDocks.DOCK_TOP(), docked.getElementDock(header));
      docked.setElementDock(sidebar, EnumDocks.DOCK_LEFT());
      assertEquals("getElementDock after setElementDock"
        , EnumDocks.DOCK_LEFT(), docked.getElementDock(sidebar));
      assertEquals("the element docked to the left keeps its own width", 40, sidebar.getDw());
      docked.setElementDock(body, EnumDocks.DOCK_CENTER());
      docked.setElementDock(body, "thisIsNotADock");
      assertEquals("a dock that does not exist is refused"
        , EnumDocks.DOCK_CENTER(), docked.getElementDock(body));
      // the room is the content itself, one gap smaller on every side
      const roomDw:int = docked.getDw() - 2 * margin;
      const roomDh:int = docked.getDh() - 2 * margin;
      assertEquals("the header stands at the left of the room", margin, int(header.x));
      assertEquals("the header stands at the top of the room", margin, int(header.y));
      // the header has taken its own height and a gap of the room
      const roomDhBelowTheHeader:int = roomDh - header.getDh() - margin;
      const roomCyBelowTheHeader:int = margin + header.getDh() + margin;
      assertEquals("the sidebar stands at the left of the room", margin, int(sidebar.x));
      assertEquals("the sidebar stands below the header", roomCyBelowTheHeader, int(sidebar.y));
      assertEquals("the body follows the sidebar"
        , margin + sidebar.getDw() + margin, int(body.x));
      assertEquals("the body stands below the header", roomCyBelowTheHeader, int(body.y));
      // the fill stretches a docked element across its own strip
      docked.setElementFill(header, true);
      docked.setElementFill(sidebar, true);
      docked.setElementFill(body, true);
      assertEquals("the filling header is as wide as the room", roomDw, header.getDw());
      assertEquals("the filling header keeps its own height", 30, header.getDh());
      assertEquals("the filling sidebar keeps its own width", 40, sidebar.getDw());
      assertEquals("the filling sidebar is as tall as the room below the header"
        , roomDhBelowTheHeader, sidebar.getDh());
      assertEquals("the filling body takes the width of the room that is left"
        , roomDw - sidebar.getDw() - margin, body.getDw());
      assertEquals("the filling body takes the height of the room that is left"
        , roomDhBelowTheHeader, body.getDh());
      // an element docked to the bottom stands at the bottom of the room that is left
      const footer:BaseSprite = new BaseSprite(application);
      footer.setDwh(20, 25);
      docked.addToContent(footer, 0);
      docked.setElementDock(footer, EnumDocks.DOCK_BOTTOM());
      assertEquals("the footer stands at the bottom of the room"
        , margin + roomDh - footer.getDh(), int(footer.y));
      removeTested(docked);
      runNestedScrollingTests();
      runBaseSpriteTests(contentSingle);
      removeTested(contentSingle);
    }
    /**
     * Runs the assertions of the scrolling an element hands its own press over to. Every
     * parent of a pressed element hands that very same press over as well, and only one
     * single object can be dragged by the mouse at a time, so the content that has taken
     * the drag has to keep it: an outer content taking it away would stop the scrolling
     * of the inner one right after it has started.
     */
    private function runNestedScrollingTests():void
    {
      // both of these contents hold an element that is bigger than the room of it, so
      // both of them have something to be scrolled
      const outer:ContentSingle = new ContentSingle(application);
      addTested(outer);
      outer.setDwh(400, 200);
      outer.setElementsFix(0);
      const inner:ContentSingle = new ContentSingle(application);
      outer.addToContent(inner, 0);
      inner.setDwh(300, 100);
      inner.setElementsFix(0);
      const innerElement:BaseSprite = new BaseSprite(application);
      innerElement.setDwh(500, 300);
      inner.addToContent(innerElement, 0);
      const outerElement:BaseSprite = new BaseSprite(application);
      outerElement.setDwh(600, 400);
      outer.addToContent(outerElement, 2);
      assertTrue("a fresh content takes the presses of its elements", inner.enableScrollingFromOthers);
      assertTrue("the inner content has something to be scrolled"
        , inner.getBaseScroll().hasSomethingToScroll());
      assertTrue("the outer content has something to be scrolled"
        , outer.getBaseScroll().hasSomethingToScroll());
      // the press of an element belongs to the closest content above it
      application.findFirstParentContentSingleAndStartScrolling(innerElement);
      assertTrue("the inner content has taken the drag", inner.getBaseScroll().getScrolled());
      assertFalse("the outer content has not taken the drag", outer.getBaseScroll().getScrolled());
      // the very same press handed over by a parent of that element leaves that drag alone
      application.findFirstParentContentSingleAndStartScrolling(inner);
      assertTrue("the inner content still holds the drag", inner.getBaseScroll().getScrolled());
      assertFalse("the outer content has not taken the drag away"
        , outer.getBaseScroll().getScrolled());
      // the drag is over as soon as the mouse has been released, so the next press of the
      // very same parent starts the scrolling of the outer content
      inner.getBaseScroll().setScrolled(false);
      application.findFirstParentContentSingleAndStartScrolling(inner);
      assertTrue("the outer content takes the next drag", outer.getBaseScroll().getScrolled());
      outer.getBaseScroll().setScrolled(false);
      // a content that has nothing to be scrolled is walked past: the drag of an element
      // of it belongs to the closest outer content that can be scrolled
      const fitting:ContentSingle = new ContentSingle(application);
      outer.addToContent(fitting, 1);
      fitting.setDwh(300, 100);
      fitting.setElementsFix(0);
      const fittingElement:BaseSprite = new BaseSprite(application);
      fittingElement.setDwh(50, 20);
      fitting.addToContent(fittingElement, 0);
      assertFalse("the content that fits has nothing to be scrolled"
        , fitting.getBaseScroll().hasSomethingToScroll());
      application.findFirstParentContentSingleAndStartScrolling(fittingElement);
      assertFalse("the content that fits has not taken the drag"
        , fitting.getBaseScroll().getScrolled());
      assertTrue("the outer content has taken the drag instead"
        , outer.getBaseScroll().getScrolled());
      outer.getBaseScroll().setScrolled(false);
      // a content that hands no press over at all is walked past as well
      inner.enableScrollingFromOthers = false;
      application.findFirstParentContentSingleAndStartScrolling(innerElement);
      assertFalse("the content that hands no press over has not taken the drag"
        , inner.getBaseScroll().getScrolled());
      assertTrue("the outer content has taken that drag", outer.getBaseScroll().getScrolled());
      outer.getBaseScroll().setScrolled(false);
      removeTested(outer);
    }
  }
}
