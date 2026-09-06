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
 * VectorDrawings.
 * Draws the named vector drawings of one embedded KVG1 blob at any size.
 *
 * MAIN FEATURES:
 * - the drawings are vectors, so an emoji asked for at four hundred pixels is
 *   as sharp as the same one asked for at sixteen, which a bitmap resource
 *   cannot do
 * - nothing is decoded until it is asked for: the blob is one ByteArray, and a
 *   drawing is turned into drawing commands the first time somebody wants it,
 *   then that result is kept for the next caller
 * - the blob is built at build time by resource/svg_to_kvg.py out of the SVG
 *   files of a resource folder, and the format is described in the header
 *   comment lines of that script
 */

package com.kisscodesystems.KissAs3Fw.util
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.display.BitmapData;
  import flash.display.CapsStyle;
  import flash.display.GraphicsPathWinding;
  import flash.display.JointStyle;
  import flash.display.LineScaleMode;
  import flash.display.Shape;
  import flash.display.StageQuality;
  import flash.geom.Matrix;
  import flash.system.System;
  import flash.utils.ByteArray;
  import flash.utils.Endian;
  public class VectorDrawings
  {
    // The command of a cubic curve, the only one of the three that consumes more
    // than one point. See flash.display.GraphicsPathCommand.
    private static const CUBIC_CURVE_TO:int = 6;
    // The side of the box every drawing of the blob is normalized into, and the
    // fixed point divisor of the stored coordinates. Both are set by svg_to_kvg.py.
    private static const BOX:Number = 32;
    private static const UNIT:Number = 64;
    // The flags of one shape.
    private static const FLAG_EVEN_ODD:int = 1;
    private static const FLAG_STROKED:int = 2;
    protected var application:Application = null;
    // The blob itself, and where the drawing of a name starts inside it.
    private var blob:ByteArray = null;
    private var offsets:Object = null;
    // The decoded drawings, by name. A drawing lands here the first time it is
    // asked for and stays, because the callers of the framework come back to the
    // same handful of emojis over and over.
    private var decoded:Object = null;
    /**
     * Constructs this object and reads the index of the given blob.
     * @param applicationRef the main application reference
     * @param blobRef the embedded KVG1 blob the drawings are read from
     */
    public function VectorDrawings(applicationRef:Application, blobRef:ByteArray):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      offsets = new Object();
      decoded = new Object();
      readIndex(blobRef);
      application.trace("<VectorDrawings> constructed.", 1);
    }
    /**
     * Tells whether this object holds a drawing of the given name.
     * @param name the name of the drawing
     * @return true when the drawing can be asked for
     */
    public function hasDrawing(name:String):Boolean
    {
      return offsets[name] != null;
    }
    /**
     * Draws the named drawing into a new, transparent, square bitmap data.
     * The drawing is rebuilt at the size asked for instead of being scaled
     * from anything, so no size is sharper than another one.
     * @param name the name of the drawing
     * @param size the width and the height of the bitmap data to return
     * @return the new bitmap data, empty when there is no such drawing
     */
    public function getNewBitmapData(name:String, size:int):BitmapData
    {
      application.trace("<VectorDrawings getNewBitmapData> called.", 1);
      application.trace("<VectorDrawings getNewBitmapData> name: " + name, 0);
      application.trace("<VectorDrawings getNewBitmapData> size: " + size, 0);
      const bitmapData:BitmapData = new BitmapData(Math.max(1, size), Math.max(1, size),
        true, 0x00ffffff);
      const shape:Shape = getShape(name);
      if (shape != null)
      {
        // The drawing is built once in its own box and scaled by the matrix of
        // the draw, so the vectors are rasterized straight at the size asked for.
        const matrix:Matrix = new Matrix();
        matrix.scale(size / BOX, size / BOX);
        bitmapData.drawWithQuality(shape, matrix, null, null, null, true, StageQuality.BEST);
      }
      return bitmapData;
    }
    /**
     * Reads the name and the position of every drawing of the blob.
     * @param blobRef the embedded KVG1 blob
     */
    private function readIndex(blobRef:ByteArray):void
    {
      application.trace("<VectorDrawings readIndex> called.", 1);
      if (blobRef == null)
      {
        application.trace("<VectorDrawings readIndex> there is no blob to read.", 0);
        return;
      }
      blob = blobRef;
      blob.endian = Endian.LITTLE_ENDIAN;
      try
      {
        blob.position = 0;
        const magic:String = blob.readUTFBytes(4);
        if (magic != "KVG1")
        {
          application.trace("<VectorDrawings readIndex> the magic is " + magic
            + " instead of KVG1.", 7);
          blob = null;
          return;
        }
        const count:int = blob.readUnsignedShort();
        for (var i:int = 0; i < count; i++)
        {
          const name:String = blob.readUTFBytes(blob.readUnsignedByte());
          offsets[name] = blob.readUnsignedInt();
        }
        application.trace("<VectorDrawings readIndex> count: " + count, 0);
      }
      catch (error:Error)
      {
        application.trace("<VectorDrawings readIndex> the blob cannot be read: "
          + error.message, 7);
        blob = null;
      }
    }
    /**
     * Returns the shape of the named drawing, decoding the blob when it is the
     * first time that one is asked for.
     * @param name the name of the drawing
     * @return the shape holding the vectors, null when there is no such drawing
     */
    private function getShape(name:String):Shape
    {
      application.trace("<VectorDrawings getShape> called.", 1);
      application.trace("<VectorDrawings getShape> name: " + name, 0);
      if (decoded[name] != null)
      {
        return Shape(decoded[name]);
      }
      if (blob == null || offsets[name] == null)
      {
        return null;
      }
      const shape:Shape = new Shape();
      try
      {
        decodeInto(shape, uint(offsets[name]));
      }
      catch (error:Error)
      {
        application.trace("<VectorDrawings getShape> " + name + " cannot be decoded: "
          + error.message, 7);
        shape.graphics.clear();
      }
      decoded[name] = shape;
      return shape;
    }
    /**
     * Reads one drawing of the blob and puts its shapes into the given shape.
     * @param shape the shape to draw into
     * @param offset where the drawing starts inside the blob
     */
    private function decodeInto(shape:Shape, offset:uint):void
    {
      application.trace("<VectorDrawings decodeInto> called.", 1);
      application.trace("<VectorDrawings decodeInto> offset: " + offset, 0);
      blob.position = offset;
      const shapeCount:int = blob.readUnsignedShort();
      for (var i:int = 0; i < shapeCount; i++)
      {
        const argb:uint = blob.readUnsignedInt();
        const flags:int = blob.readUnsignedByte();
        var strokeArgb:uint = 0;
        var strokeWidth:Number = 0;
        var strokeCaps:String = CapsStyle.NONE;
        if ((flags & FLAG_STROKED) != 0)
        {
          strokeArgb = blob.readUnsignedInt();
          strokeWidth = blob.readUnsignedShort() / UNIT;
          strokeCaps = getCapsStyle(blob.readUnsignedByte());
        }
        // The commands come first and the coordinates after them, so how many
        // coordinates there are is known only once every command has been read.
        const commandCount:int = blob.readUnsignedShort();
        const commands:Vector.<int> = new Vector.<int>(commandCount, true);
        var pointCount:int = 0;
        for (var j:int = 0; j < commandCount; j++)
        {
          const command:int = blob.readUnsignedByte();
          commands[j] = command;
          pointCount += command == CUBIC_CURVE_TO ? 3 : 1;
        }
        const data:Vector.<Number> = new Vector.<Number>(pointCount * 2, true);
        for (var k:int = 0; k < data.length; k++)
        {
          data[k] = blob.readShort() / UNIT;
        }
        if (strokeArgb != 0)
        {
          shape.graphics.lineStyle(strokeWidth, strokeArgb & 0xffffff,
            ((strokeArgb >>> 24) & 0xff) / 255, false, LineScaleMode.NORMAL,
            strokeCaps, JointStyle.ROUND);
        }
        if (argb != 0)
        {
          shape.graphics.beginFill(argb & 0xffffff, ((argb >>> 24) & 0xff) / 255);
        }
        shape.graphics.drawPath(commands, data, (flags & FLAG_EVEN_ODD) != 0
          ? GraphicsPathWinding.EVEN_ODD : GraphicsPathWinding.NON_ZERO);
        if (argb != 0)
        {
          shape.graphics.endFill();
        }
        shape.graphics.lineStyle();
      }
    }
    /**
     * Turns the caps code of the blob into the caps style of the runtime.
     * @param caps the code stored in the blob
     * @return the matching flash.display.CapsStyle value
     */
    private function getCapsStyle(caps:int):String
    {
      application.trace("<VectorDrawings getCapsStyle> called.", 1);
      application.trace("<VectorDrawings getCapsStyle> caps: " + caps, 0);
      if (caps == 1)
      {
        return CapsStyle.ROUND;
      }
      if (caps == 2)
      {
        return CapsStyle.SQUARE;
      }
      return CapsStyle.NONE;
    }
    /**
     * Destroys this object and frees up everything.
     */
    public function destroy():void
    {
      application.trace("<VectorDrawings destroy> called.", 1);
      for (var name:String in decoded)
      {
        Shape(decoded[name]).graphics.clear();
        delete decoded[name];
      }
      if (blob != null)
      {
        blob.clear();
      }
      decoded = null;
      offsets = null;
      blob = null;
      application = null;
    }
  }
}
