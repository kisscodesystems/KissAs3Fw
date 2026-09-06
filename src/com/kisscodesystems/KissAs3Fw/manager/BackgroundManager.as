/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 * https://github.com/kisscodesystems/KissAs3Mp
 * DESCRIPTION:
 * BackgroundManager.
 * Provides the embedded background bitmap of the application.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.display.Bitmap;
  import flash.system.System;
  public class BackgroundManager
  {
    protected var application:Application = null;
    private var files:BackgroundManagerFiles = new BackgroundManagerFiles();
    private var embeddedBackgroundBitmap:Bitmap;
    /**
     * Constructs the background manager and loads the embedded background bitmap.
     * @param applicationRef the application reference
     */
    public function BackgroundManager(applicationRef:Application):void
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
      application.trace("<BackgroundManager> called.", 1);
      application.trace("<BackgroundManager> applicationRef: " + applicationRef, 0);
      embeddedBackgroundBitmap = new files.EmbeddedBackgroundClass() as Bitmap;
      application.trace("<BackgroundManager> constructed.", 1);
    }
    /**
     * Returns the embedded background bitmap of the application.
     */
    public function getEmbeddedBackgroundBitmap():Bitmap
    {
      return embeddedBackgroundBitmap;
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<BackgroundManager destroy> called.", 1);
      if (embeddedBackgroundBitmap != null)
      {
        if (embeddedBackgroundBitmap.bitmapData != null)
        {
          embeddedBackgroundBitmap.bitmapData.dispose();
        }
      }
      embeddedBackgroundBitmap = null;
      files = null;
      application = null;
    }
  }
}
/**
 * BackgroundManagerFiles.
 * Holds the resources embedded into the BackgroundManager.
 */
class BackgroundManagerFiles
{
  [Embed(source = "../resource/background/DefaultMosaicBackground.jpg")]
  public var EmbeddedBackgroundClass:Class;
  /**
   * Constructs the embedded resource holder of the background manager.
   */
  public function BackgroundManagerFiles():void
  {
  }
}
