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
 * FontManager.
 * Handles the embedded fonts and provides other font related stuff.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  import flash.text.Font;
  public class FontManager
  {
    protected var application:Application = null;
    private var embeddedFonts:Array = new Array("FreeSans", "FreeSerif", "FreeMono");
    private var files:FontManagerFiles = new FontManagerFiles();
    /**
     * Constructs the font manager.
     * @param applicationRef the application reference
     */
    public function FontManager(applicationRef:Application):void
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
      application.trace("<FontManager> called.", 1);
      application.trace("<FontManager> applicationRef: " + applicationRef, 0);
      application.trace("<FontManager> constructed.", 1);
    }
    /**
     * Returns the available font faces: the embedded fonts first, then every device font.
     */
    public function getFontFaces():Array
    {
      application.trace("<FontManager getFontFaces> called.", 1);
      const array:Array = Font.enumerateFonts(true);
      array.sortOn(Array.CASEINSENSITIVE);
      const arrayRet:Array = new Array();
      for (var k:int = 0; k < embeddedFonts.length; k++)
      {
        arrayRet.push(embeddedFonts[k]);
      }
      var found:Boolean = false;
      for (var i:int = 0; i < array.length; i++)
      {
        for (var j:int = 0; j < embeddedFonts.length; j++)
        {
          found = false;
          if (embeddedFonts[j] == array[i].fontName)
          {
            found = true;
            break;
          }
        }
        if (!found)
        {
          arrayRet.push(array[i].fontName);
        }
      }
      application.trace("<FontManager getFontFaces> arrayRet: " + arrayRet, 0);
      return arrayRet;
    }
    /**
     * Returns whether the given font face is one of the embedded fonts.
     * @param fontFace the font face to be checked
     */
    public function getFontIsEmbedded(fontFace:String):Boolean
    {
      application.trace("<FontManager getFontIsEmbedded> called.", 1);
      application.trace("<FontManager getFontIsEmbedded> fontFace: " + fontFace, 0);
      const val:Boolean = embeddedFonts.indexOf(fontFace) > -1;
      application.trace("<FontManager getFontIsEmbedded> val: " + val, 0);
      return val;
    }
    /**
     * Returns the selectable font sizes between the min and the max font size.
     */
    public function getFontSizes():Array
    {
      application.trace("<FontManager getFontSizes> called.", 1);
      const arrayRet:Array = new Array();
      arrayRet.push(0);
      for (var i:int = getMinFontSize(); i <= getMaxFontSize(); i += 2)
      {
        arrayRet.push(i);
      }
      application.trace("<FontManager getFontSizes> arrayRet: " + arrayRet, 0);
      return arrayRet;
    }
    /**
     * Returns the minimum selectable font size.
     */
    public function getMinFontSize():int
    {
      application.trace("<FontManager getMinFontSize> called.", 1);
      const val:int = 12;
      application.trace("<FontManager getMinFontSize> val: " + val, 0);
      return val;
    }
    /**
     * Returns the maximum selectable font size.
     */
    public function getMaxFontSize():int
    {
      application.trace("<FontManager getMaxFontSize> called.", 1);
      const val:int = 72;
      application.trace("<FontManager getMaxFontSize> val: " + val, 0);
      return val;
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<FontManager destroy> called.", 1);
      embeddedFonts.splice(0);
      embeddedFonts = null;
      files = null;
      application = null;
    }
  }
}

/**
 * FontManagerFiles.
 * Holds the fonts embedded into the FontManager.
 */
class FontManagerFiles
{
  [Embed(source = "../resource/font/FreeSans.ttf", fontName = "FreeSans", fontStyle = "normal", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSansClass:Class;
  [Embed(source = "../resource/font/FreeSansBold.ttf", fontName = "FreeSans", fontStyle = "normal", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSansClassBold:Class;
  [Embed(source = "../resource/font/FreeSansOblique.ttf", fontName = "FreeSans", fontStyle = "italic", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSansClassItalic:Class;
  [Embed(source = "../resource/font/FreeSansBoldOblique.ttf", fontName = "FreeSans", fontStyle = "italic", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSansClassBoldItalic:Class;
  [Embed(source = "../resource/font/FreeSerif.ttf", fontName = "FreeSerif", fontStyle = "normal", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSerifClass:Class;
  [Embed(source = "../resource/font/FreeSerifBold.ttf", fontName = "FreeSerif", fontStyle = "normal", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSerifClassBold:Class;
  [Embed(source = "../resource/font/FreeSerifItalic.ttf", fontName = "FreeSerif", fontStyle = "italic", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSerifClassItalic:Class;
  [Embed(source = "../resource/font/FreeSerifBoldItalic.ttf", fontName = "FreeSerif", fontStyle = "italic", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeSerifClassBoldItalic:Class;
  [Embed(source = "../resource/font/FreeMono.ttf", fontName = "FreeMono", fontStyle = "normal", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeMonoClass:Class;
  [Embed(source = "../resource/font/FreeMonoBold.ttf", fontName = "FreeMono", fontStyle = "normal", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeMonoClassBold:Class;
  [Embed(source = "../resource/font/FreeMonoOblique.ttf", fontName = "FreeMono", fontStyle = "italic", fontWeight = "normal", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeMonoClassItalic:Class;
  [Embed(source = "../resource/font/FreeMonoBoldOblique.ttf", fontName = "FreeMono", fontStyle = "italic", fontWeight = "bold", mimeType = "application/x-font", advancedAntiAliasing = "true", embedAsCFF = "false")]
  public var FreeMonoClassBoldItalic:Class;
  /**
   * Constructs the embedded font holder of the font manager.
   */
  public function FontManagerFiles():void
  {
  }
}
