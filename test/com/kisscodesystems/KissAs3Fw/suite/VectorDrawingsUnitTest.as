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
 * VectorDrawingsUnitTest
 * Checks the vector drawing reader of the framework.
 *
 * MAIN FEATURES:
 * - the emoji blob of the framework is read, and the drawings of it are asked for
 * - the same drawing is asked for at several sizes: a vector has no size of its own,
 *   so every one of them has to come back with the very size asked for
 * - a blob written here drives the reader through the format: the winding rules, the
 *   stroked shapes, the cubic curves and the transparent fills
 * - a broken blob and an unknown name are answered instead of thrown
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.util.VectorDrawings;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.display.BitmapData;
  import flash.utils.ByteArray;
  import flash.utils.Endian;
  public class VectorDrawingsUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function VectorDrawingsUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "VectorDrawings";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      runBlobTests();
      runSizeTests();
      runShapeTests();
      runBrokenBlobTests();
    }
    /**
     * Checks the drawings of the emoji blob the framework embeds.
     */
    private function runBlobTests():void
    {
      const drawings:VectorDrawings = getDrawingsOfOneShape();
      assertTrue("hasDrawing of a drawing that is there", drawings.hasDrawing("one"));
      assertFalse("hasDrawing of a drawing that is not there", drawings.hasDrawing("two"));
      assertFalse("hasDrawing of an empty name", drawings.hasDrawing(""));
      assertFalse("hasDrawing of null", drawings.hasDrawing(null));
      drawings.destroy();
      // The emoji manager answers through a VectorDrawings of its own, so what it
      // gives back tells whether the blob of the framework itself can be read.
      const emoji:BitmapData = application.getEmojiManager().getNewBitmapData(
        EnumEmojis.smileys_smile(), 32);
      assertNotNull("the emoji manager answers a bitmap data", emoji);
      assertEquals("the width of that bitmap data", 32, emoji.width);
      assertEquals("the height of that bitmap data", 32, emoji.height);
      assertTrue("an emoji of the blob has painted pixels", getPaintedPixels(emoji) > 0);
      emoji.dispose();
      // An emoji the blob does not hold is answered with an empty bitmap data of the
      // size asked for, so a caller never has to check for a null.
      const missing:BitmapData = application.getEmojiManager().getNewBitmapData("no_such_emoji", 24);
      assertNotNull("an unknown emoji answers a bitmap data as well", missing);
      assertEquals("the width of that bitmap data", 24, missing.width);
      assertEquals("an unknown emoji paints nothing", 0, getPaintedPixels(missing));
      missing.dispose();
    }
    /**
     * Checks that a drawing comes back at every size it is asked for, and that it is
     * really drawn at that size instead of being scaled up from a smaller one.
     */
    private function runSizeTests():void
    {
      const drawings:VectorDrawings = getDrawingsOfOneShape();
      const sizes:Array = new Array(1, 8, 16, 32, 64, 111, 256);
      for (var i:int = 0; i < sizes.length; i++)
      {
        const size:int = int(sizes[i]);
        const bitmapData:BitmapData = drawings.getNewBitmapData("one", size);
        assertEquals("the width at the size of " + size, size, bitmapData.width);
        assertEquals("the height at the size of " + size, size, bitmapData.height);
        assertTrue("the drawing paints something at the size of " + size,
          getPaintedPixels(bitmapData) > 0);
        bitmapData.dispose();
      }
      // A size of zero or less cannot be a bitmap data, so the smallest one is answered.
      const zero:BitmapData = drawings.getNewBitmapData("one", 0);
      assertEquals("the width at the size of zero", 1, zero.width);
      zero.dispose();
      // The shape of the drawing is a square covering the whole box, so at any size
      // nearly every pixel of the answer has to be painted, and the paint of it has to
      // be the very colour of the fill instead of a blend of it with the background.
      const big:BitmapData = drawings.getNewBitmapData("one", 128);
      assertTrue("a full box drawing paints the whole bitmap data at 128",
        getPaintedPixels(big) > 128 * 128 * 9 / 10);
      assertEquals("the colour of the middle pixel", 0x2040a0, getColour(big, 64, 64));
      assertEquals("the alpha of the middle pixel", 0xff, getAlpha(big, 64, 64));
      big.dispose();
      drawings.destroy();
    }
    /**
     * Drives the reader through the format: the two winding rules, a stroke, a cubic
     * curve and a fill that paints nothing.
     */
    private function runShapeTests():void
    {
      // A ring: the outer square and the inner one in the same shape, with the even-odd
      // winding rule, so the middle of it stays empty. With the non-zero rule the very
      // same geometry paints that middle as well, and that is what tells the two apart.
      const evenOdd:VectorDrawings = getDrawings(writeBlob("ring", newRing(true)));
      const evenOddData:BitmapData = evenOdd.getNewBitmapData("ring", 32);
      assertEquals("the middle of an even-odd ring is empty", 0, getAlpha(evenOddData, 16, 16));
      assertTrue("the border of an even-odd ring is painted", getAlpha(evenOddData, 2, 16) > 0);
      evenOddData.dispose();
      evenOdd.destroy();
      const nonZero:VectorDrawings = getDrawings(writeBlob("ring", newRing(false)));
      const nonZeroData:BitmapData = nonZero.getNewBitmapData("ring", 32);
      assertTrue("the middle of a non-zero ring is painted", getAlpha(nonZeroData, 16, 16) > 0);
      nonZeroData.dispose();
      nonZero.destroy();
      // A shape with no fill and a stroke on it paints its outline only.
      const stroked:VectorDrawings = getDrawings(writeBlob("stroked", newStroked()));
      const strokedData:BitmapData = stroked.getNewBitmapData("stroked", 32);
      assertEquals("the middle of a stroked square is empty", 0, getAlpha(strokedData, 16, 16));
      assertTrue("the outline of a stroked square is painted", getAlpha(strokedData, 16, 6) > 0);
      strokedData.dispose();
      stroked.destroy();
      // A cubic curve is the third command the format knows, and a half transparent
      // fill has to arrive half transparent.
      const curved:VectorDrawings = getDrawings(writeBlob("curved", newCurved()));
      const curvedData:BitmapData = curved.getNewBitmapData("curved", 32);
      assertTrue("a cubic curve paints something", getPaintedPixels(curvedData) > 0);
      assertEquals("the alpha of a half transparent fill", 0x80, getAlpha(curvedData, 16, 16));
      curvedData.dispose();
      curved.destroy();
    }
    /**
     * Checks that a blob which cannot be read is answered instead of thrown.
     */
    private function runBrokenBlobTests():void
    {
      const noBlob:VectorDrawings = new VectorDrawings(application, null);
      assertFalse("hasDrawing of a reader with no blob at all", noBlob.hasDrawing("one"));
      const empty:BitmapData = noBlob.getNewBitmapData("one", 16);
      assertNotNull("a reader with no blob answers a bitmap data", empty);
      assertEquals("a reader with no blob paints nothing", 0, getPaintedPixels(empty));
      empty.dispose();
      noBlob.destroy();
      // A blob of another format is dropped on its magic instead of being read as one.
      const alien:ByteArray = new ByteArray();
      alien.endian = Endian.LITTLE_ENDIAN;
      alien.writeUTFBytes("PNG!");
      alien.writeShort(1);
      const wrongMagic:VectorDrawings = new VectorDrawings(application, alien);
      assertFalse("hasDrawing of a blob of the wrong magic", wrongMagic.hasDrawing("one"));
      wrongMagic.destroy();
      // A blob that stops in the middle of a drawing is caught while it is decoded, and
      // the drawing of it comes back empty rather than taking the application down.
      const truncated:ByteArray = writeBlob("one", newSquare());
      truncated.length = truncated.length - 6;
      const cut:VectorDrawings = new VectorDrawings(application, truncated);
      assertTrue("the index of a truncated blob is still read", cut.hasDrawing("one"));
      const cutData:BitmapData = cut.getNewBitmapData("one", 16);
      assertNotNull("a truncated drawing answers a bitmap data", cutData);
      assertEquals("the width of that bitmap data", 16, cutData.width);
      cutData.dispose();
      cut.destroy();
    }
    /**
     * Returns a reader over a blob holding one full box square named "one".
     * @return the new reader, the caller destroys it
     */
    private function getDrawingsOfOneShape():VectorDrawings
    {
      return getDrawings(writeBlob("one", newSquare()));
    }
    /**
     * Returns a reader over the given blob.
     * @param blob the blob to read
     * @return the new reader, the caller destroys it
     */
    private function getDrawings(blob:ByteArray):VectorDrawings
    {
      return new VectorDrawings(application, blob);
    }
    /**
     * Wraps one drawing into a whole KVG1 blob under the given name.
     * @param name the name of the drawing
     * @param drawing the shapes of it, as the format stores them
     * @return the new blob
     */
    private function writeBlob(name:String, drawing:ByteArray):ByteArray
    {
      const blob:ByteArray = new ByteArray();
      blob.endian = Endian.LITTLE_ENDIAN;
      blob.writeUTFBytes("KVG1");
      blob.writeShort(1);
      blob.writeByte(name.length);
      blob.writeUTFBytes(name);
      blob.writeUnsignedInt(4 + 2 + 1 + name.length + 4);
      blob.writeBytes(drawing);
      return blob;
    }
    /**
     * Starts one shape of a drawing: the fill, the flags and the stroke of it.
     * @param drawing the drawing being written
     * @param argb the fill colour, a zero meaning the shape is outlined only
     * @param evenOdd true when the winding rule of it is even-odd
     * @param strokeArgb the stroke colour, a zero meaning there is no stroke
     */
    private function writeShapeHeader(drawing:ByteArray, argb:uint, evenOdd:Boolean,
      strokeArgb:uint):void
    {
      drawing.writeUnsignedInt(argb);
      drawing.writeByte((evenOdd ? 1 : 0) | (strokeArgb != 0 ? 2 : 0));
      if (strokeArgb != 0)
      {
        drawing.writeUnsignedInt(strokeArgb);
        // two units wide, the coordinates of the format being in sixtyfourths
        drawing.writeShort(2 * 64);
        drawing.writeByte(1);
      }
    }
    /**
     * Writes one point of a drawing, turning the units into the fixed point numbers of
     * the format.
     * @param drawing the drawing being written
     * @param x the horizontal coordinate, in units of the box
     * @param y the vertical coordinate, in units of the box
     */
    private function writePoint(drawing:ByteArray, x:Number, y:Number):void
    {
      drawing.writeShort(Math.round(x * 64));
      drawing.writeShort(Math.round(y * 64));
    }
    /**
     * A drawing of one square covering the whole box.
     * @return the shapes of it
     */
    private function newSquare():ByteArray
    {
      const drawing:ByteArray = newDrawing(1);
      writeShapeHeader(drawing, 0xff2040a0, false, 0);
      writeSquareCommands(drawing, 0, 32);
      return drawing;
    }
    /**
     * A drawing of a square with a smaller one inside it, in the same shape.
     * @param evenOdd true when the winding rule of it is even-odd
     * @return the shapes of it
     */
    private function newRing(evenOdd:Boolean):ByteArray
    {
      const drawing:ByteArray = newDrawing(1);
      writeShapeHeader(drawing, 0xffc02020, evenOdd, 0);
      drawing.writeShort(8);
      writeSquarePath(drawing);
      writeSquarePath(drawing);
      writeSquarePoints(drawing, 0, 32);
      writeSquarePoints(drawing, 8, 16);
      return drawing;
    }
    /**
     * A drawing of a square that is outlined and not filled.
     * @return the shapes of it
     */
    private function newStroked():ByteArray
    {
      const drawing:ByteArray = newDrawing(1);
      writeShapeHeader(drawing, 0, false, 0xff20a040);
      writeSquareCommands(drawing, 6, 20);
      return drawing;
    }
    /**
     * A drawing of one cubic curve, filled half transparently.
     * @return the shapes of it
     */
    private function newCurved():ByteArray
    {
      const drawing:ByteArray = newDrawing(1);
      writeShapeHeader(drawing, 0x80308020, false, 0);
      drawing.writeShort(3);
      drawing.writeByte(1);
      drawing.writeByte(6);
      drawing.writeByte(6);
      writePoint(drawing, 2, 16);
      writePoint(drawing, 2, 0);
      writePoint(drawing, 30, 0);
      writePoint(drawing, 30, 16);
      writePoint(drawing, 30, 32);
      writePoint(drawing, 2, 32);
      writePoint(drawing, 2, 16);
      return drawing;
    }
    /**
     * Starts a drawing of the given number of shapes.
     * @param shapeCount how many shapes it holds
     * @return the drawing being written
     */
    private function newDrawing(shapeCount:int):ByteArray
    {
      const drawing:ByteArray = new ByteArray();
      drawing.endian = Endian.LITTLE_ENDIAN;
      drawing.writeShort(shapeCount);
      return drawing;
    }
    /**
     * Writes the commands and the points of one axis aligned square.
     * @param drawing the drawing being written
     * @param from the coordinate of the near corner of it
     * @param size the side of it
     */
    private function writeSquareCommands(drawing:ByteArray, from:Number, size:Number):void
    {
      drawing.writeShort(4);
      writeSquarePath(drawing);
      writeSquarePoints(drawing, from, size);
    }
    /**
     * Writes the four commands of one square: a move and three lines, the fill closing
     * the fourth side of it.
     * @param drawing the drawing being written
     */
    private function writeSquarePath(drawing:ByteArray):void
    {
      drawing.writeByte(1);
      drawing.writeByte(2);
      drawing.writeByte(2);
      drawing.writeByte(2);
    }
    /**
     * Writes the four corners of one square.
     * @param drawing the drawing being written
     * @param from the coordinate of the near corner of it
     * @param size the side of it
     */
    private function writeSquarePoints(drawing:ByteArray, from:Number, size:Number):void
    {
      writePoint(drawing, from, from);
      writePoint(drawing, from + size, from);
      writePoint(drawing, from + size, from + size);
      writePoint(drawing, from, from + size);
    }
    /**
     * Returns the colour of one pixel, without the alpha of it.
     * @param bitmapData the bitmap data to read
     * @param x the horizontal coordinate of the pixel
     * @param y the vertical coordinate of the pixel
     * @return the colour, as an int of the 0xrrggbb form
     */
    private function getColour(bitmapData:BitmapData, x:int, y:int):int
    {
      return int(bitmapData.getPixel32(x, y) & 0xffffff);
    }
    /**
     * Returns the alpha of one pixel.
     * @param bitmapData the bitmap data to read
     * @param x the horizontal coordinate of the pixel
     * @param y the vertical coordinate of the pixel
     * @return the alpha, between zero and 0xff
     */
    private function getAlpha(bitmapData:BitmapData, x:int, y:int):int
    {
      return int((bitmapData.getPixel32(x, y) >>> 24) & 0xff);
    }
    /**
     * Counts the pixels of a bitmap data that are not fully transparent.
     * @param bitmapData the bitmap data to walk
     * @return how many pixels of it carry any paint at all
     */
    private function getPaintedPixels(bitmapData:BitmapData):int
    {
      var painted:int = 0;
      for (var y:int = 0; y < bitmapData.height; y++)
      {
        for (var x:int = 0; x < bitmapData.width; x++)
        {
          if (getAlpha(bitmapData, x, y) != 0)
          {
            painted++;
          }
        }
      }
      return painted;
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
