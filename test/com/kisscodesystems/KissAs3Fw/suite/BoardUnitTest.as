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
 * BoardUnitTest
 * Checks the Board component.
 *
 * MAIN FEATURES:
 * - the colors and the thickness of the drawing come from the config and can be set
 * - every tool of the toolbar can be switched on and off, and the enabled state of the
 *   whole board switches all of them at once
 * - the picker of the color of the background keeps the state it has been given from the
 *   outside through a clearing
 * - the movements of the drawing are counted, the last one of them can be undone and the
 *   last undone one can be redone
 * - an empty board can be resized, both as a whole and by its drawable area only
 * - the content of the drawable area is available as a png byte array
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.ui.Board;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.utils.ByteArray;
  public class BoardUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BoardUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Board";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const board:Board = new Board(application);
      addTested(board);
      // a fresh board is empty, resizable, and it holds the values of the config
      assertTrue("isContentEmpty of a fresh Board", board.isContentEmpty());
      assertTrue("getResizeIsPossible of a fresh Board", board.getResizeIsPossible());
      assertTrue("getDraw of a fresh Board", board.getDraw());
      assertEquals("getMovementsCount of a fresh Board", 0, board.getMovementsCount());
      assertEquals("getUndoneMovementsCount of a fresh Board", 0, board.getUndoneMovementsCount());
      assertEquals("getBackgroundRGBColor of a fresh Board"
        , application.getComponentsConfig().getBoardBackgroundColor(), board.getBackgroundRGBColor());
      assertEquals("getLineRGBColor of a fresh Board"
        , application.getComponentsConfig().getBoardLineColor(), board.getLineRGBColor());
      assertEquals("getLineThickness of a fresh Board"
        , application.getComponentsConfig().getBoardLineThickness(), board.getLineThickness());
      // the label that names the board
      board.setLabel("the board of the test");
      assertEquals("getLabel after setLabel", "the board of the test", board.getLabel());
      // the colors of the drawing
      board.setBackgroundRGBColor("FF0000");
      assertEquals("getBackgroundRGBColor after setBackgroundRGBColor", "FF0000", board.getBackgroundRGBColor());
      board.setLineRGBColor("00FF00");
      assertEquals("getLineRGBColor after setLineRGBColor", "00FF00", board.getLineRGBColor());
      // the thickness of the drawing, inside the range of the config
      board.setLineThickness(application.getComponentsConfig().getBoardLineMaxThickness());
      assertEquals("getLineThickness after setLineThickness"
        , application.getComponentsConfig().getBoardLineMaxThickness(), board.getLineThickness());
      // the drawing can be switched to the rubber and back
      board.setDraw(false);
      assertFalse("getDraw after setDraw(false)", board.getDraw());
      board.setDraw(true);
      assertTrue("getDraw after setDraw(true)", board.getDraw());
      // every element of the toolbar can be enabled and disabled one by one
      assertTrue("getBackgroundEnabled of a fresh Board", board.getBackgroundEnabled());
      assertTrue("getLineEnabled of a fresh Board", board.getLineEnabled());
      assertTrue("getLineThicknessEnabled of a fresh Board", board.getLineThicknessEnabled());
      assertTrue("getDrawEnabled of a fresh Board", board.getDrawEnabled());
      assertTrue("getUndoEnabled of a fresh Board", board.getUndoEnabled());
      assertTrue("getRedoEnabled of a fresh Board", board.getRedoEnabled());
      assertTrue("getClearEnabled of a fresh Board", board.getClearEnabled());
      board.setBackgroundEnabled(false);
      board.setLineEnabled(false);
      board.setLineThicknessEnabled(false);
      board.setDrawEnabled(false);
      board.setUndoEnabled(false);
      board.setRedoEnabled(false);
      board.setClearEnabled(false);
      assertFalse("getBackgroundEnabled after setBackgroundEnabled(false)", board.getBackgroundEnabled());
      assertFalse("getLineEnabled after setLineEnabled(false)", board.getLineEnabled());
      assertFalse("getLineThicknessEnabled after setLineThicknessEnabled(false)", board.getLineThicknessEnabled());
      assertFalse("getDrawEnabled after setDrawEnabled(false)", board.getDrawEnabled());
      assertFalse("getUndoEnabled after setUndoEnabled(false)", board.getUndoEnabled());
      assertFalse("getRedoEnabled after setRedoEnabled(false)", board.getRedoEnabled());
      assertFalse("getClearEnabled after setClearEnabled(false)", board.getClearEnabled());
      // a picker of the background that has been switched off from the outside stays off
      // through a clearing: that clearing unlocks such a picker and gives it the very state
      // it has been asked for from the outside
      board.clear();
      assertFalse("getBackgroundEnabled after the clearing of a switched off background picker", board.getBackgroundEnabled());
      board.setBackgroundEnabled(true);
      board.setLineEnabled(true);
      board.setLineThicknessEnabled(true);
      board.setDrawEnabled(true);
      board.setUndoEnabled(true);
      board.setRedoEnabled(true);
      board.setClearEnabled(true);
      assertTrue("getBackgroundEnabled after setBackgroundEnabled(true)", board.getBackgroundEnabled());
      assertTrue("getLineEnabled after setLineEnabled(true)", board.getLineEnabled());
      assertTrue("getLineThicknessEnabled after setLineThicknessEnabled(true)", board.getLineThicknessEnabled());
      assertTrue("getDrawEnabled after setDrawEnabled(true)", board.getDrawEnabled());
      assertTrue("getUndoEnabled after setUndoEnabled(true)", board.getUndoEnabled());
      assertTrue("getRedoEnabled after setRedoEnabled(true)", board.getRedoEnabled());
      assertTrue("getClearEnabled after setClearEnabled(true)", board.getClearEnabled());
      board.clear();
      assertTrue("getBackgroundEnabled after the clearing of a switched on background picker", board.getBackgroundEnabled());
      // the resizing can be forbidden
      board.setResizeIsPossible(false);
      assertFalse("getResizeIsPossible after setResizeIsPossible(false)", board.getResizeIsPossible());
      board.setResizeIsPossible(true);
      // the drawable area can be resized on its own
      board.setDwhContent(300, 200);
      assertEquals("getDwContent after setDwhContent", 300, board.getDwContent());
      assertEquals("getDhContent after setDwhContent", 200, board.getDhContent());
      assertEquals("getCanvasWidth follows the drawable area", 300, board.getCanvasWidth());
      assertEquals("getCanvasHeight follows the drawable area", 200, board.getCanvasHeight());
      // the whole board can be resized as well, while nothing has been drawn onto it
      board.setDw(500);
      assertEquals("getDw after setDw(500)", expectedDw(500), board.getDw());
      board.setDh(400);
      assertEquals("getDh after setDh(400)", expectedDh(400), board.getDh());
      board.setDwh(600, 450);
      assertEquals("getDw after setDwh", expectedDw(600), board.getDw());
      assertEquals("getDh after setDwh", expectedDh(450), board.getDh());
      // the content of the drawable area comes out as a png byte array
      const canvas:ByteArray = board.getCanvasByteArray();
      assertNotNull("getCanvasByteArray", canvas);
      assertTrue("the png byte array is not empty", canvas.length > 0);
      // undoing on a board that has no movement at all leaves everything as it is, and
      // nothing lands in the movements that could be redone either
      board.undo();
      assertEquals("getMovementsCount after an undo with no movement", 0, board.getMovementsCount());
      assertEquals("getUndoneMovementsCount after an undo with no movement", 0, board.getUndoneMovementsCount());
      assertTrue("isContentEmpty after an undo with no movement", board.isContentEmpty());
      // redoing on a board that has no undone movement at all leaves everything as it is
      board.redo();
      assertEquals("getMovementsCount after a redo with no undone movement", 0, board.getMovementsCount());
      assertEquals("getUndoneMovementsCount after a redo with no undone movement", 0, board.getUndoneMovementsCount());
      assertTrue("isContentEmpty after a redo with no undone movement", board.isContentEmpty());
      // clearing an already empty board leaves it empty, with nothing to be undone and
      // nothing to be redone
      board.clear();
      assertTrue("isContentEmpty after clear", board.isContentEmpty());
      assertEquals("getMovementsCount after clear", 0, board.getMovementsCount());
      assertEquals("getUndoneMovementsCount after clear", 0, board.getUndoneMovementsCount());
      // every element of the toolbar follows the enabled state of the board
      board.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", board.getEnabled());
      assertFalse("getBackgroundEnabled after the board has been switched off", board.getBackgroundEnabled());
      assertFalse("getLineEnabled after the board has been switched off", board.getLineEnabled());
      assertFalse("getLineThicknessEnabled after the board has been switched off", board.getLineThicknessEnabled());
      assertFalse("getDrawEnabled after the board has been switched off", board.getDrawEnabled());
      assertFalse("getUndoEnabled after the board has been switched off", board.getUndoEnabled());
      assertFalse("getRedoEnabled after the board has been switched off", board.getRedoEnabled());
      assertFalse("getClearEnabled after the board has been switched off", board.getClearEnabled());
      board.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", board.getEnabled());
      assertTrue("getBackgroundEnabled after the board has been switched on", board.getBackgroundEnabled());
      assertTrue("getLineEnabled after the board has been switched on", board.getLineEnabled());
      assertTrue("getLineThicknessEnabled after the board has been switched on", board.getLineThicknessEnabled());
      assertTrue("getDrawEnabled after the board has been switched on", board.getDrawEnabled());
      assertTrue("getUndoEnabled after the board has been switched on", board.getUndoEnabled());
      assertTrue("getRedoEnabled after the board has been switched on", board.getRedoEnabled());
      assertTrue("getClearEnabled after the board has been switched on", board.getClearEnabled());
      runBaseSpriteTests(board);
      removeTested(board);
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
