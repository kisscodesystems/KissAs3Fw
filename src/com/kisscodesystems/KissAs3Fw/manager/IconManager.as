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
 * IconManager.
 * Handles icons that can be used on labels.
 * This class is generated so can be overwritten from outside.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  import flash.system.System;
  public class IconManager
  {
    protected var application:Application = null;
    private var calendarBitmap:Bitmap;
    private var cameracrossedBitmap:Bitmap;
    private var cameraBitmap:Bitmap;
    private var cancelBitmap:Bitmap;
    private var circlefullBitmap:Bitmap;
    private var circleBitmap:Bitmap;
    private var clearerBitmap:Bitmap;
    private var closeBitmap:Bitmap;
    private var copyBitmap:Bitmap;
    private var doubleleftarrowBitmap:Bitmap;
    private var doublerightarrowBitmap:Bitmap;
    private var downarrow1Bitmap:Bitmap;
    private var downarrowBitmap:Bitmap;
    private var drawerBitmap:Bitmap;
    private var emojiplusBitmap:Bitmap;
    private var fileBitmap:Bitmap;
    private var folderBitmap:Bitmap;
    private var infoBitmap:Bitmap;
    private var leftarrowBitmap:Bitmap;
    private var lightningBitmap:Bitmap;
    private var listingBitmap:Bitmap;
    private var listBitmap:Bitmap;
    private var logoutBitmap:Bitmap;
    private var maximizeBitmap:Bitmap;
    private var menuBitmap:Bitmap;
    private var minimizeBitmap:Bitmap;
    private var minusBitmap:Bitmap;
    private var moreBitmap:Bitmap;
    private var ok1Bitmap:Bitmap;
    private var okBitmap:Bitmap;
    private var orderascBitmap:Bitmap;
    private var orderdescBitmap:Bitmap;
    private var pausedBitmap:Bitmap;
    private var playingBitmap:Bitmap;
    private var plusBitmap:Bitmap;
    private var potmeterBitmap:Bitmap;
    private var questionBitmap:Bitmap;
    private var redoerBitmap:Bitmap;
    private var refresharrowBitmap:Bitmap;
    private var rightarrowBitmap:Bitmap;
    private var rubberBitmap:Bitmap;
    private var settingsBitmap:Bitmap;
    private var soundhighBitmap:Bitmap;
    private var soundlowBitmap:Bitmap;
    private var soundmidBitmap:Bitmap;
    private var soundmutedBitmap:Bitmap;
    private var soundzeroBitmap:Bitmap;
    private var starblankBitmap:Bitmap;
    private var starfullBitmap:Bitmap;
    private var starhalfBitmap:Bitmap;
    private var stoppedBitmap:Bitmap;
    private var switchoffBitmap:Bitmap;
    private var switchonBitmap:Bitmap;
    private var undoerBitmap:Bitmap;
    private var uparrow1Bitmap:Bitmap;
    private var uparrowBitmap:Bitmap;
    private var warningBitmap:Bitmap;
    private var watchBitmap:Bitmap;
    private var files:IconManagerFiles = new IconManagerFiles();
    public function IconManager(applicationRef:Application):void
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
      calendarBitmap = new files.calendarClass() as Bitmap;
      cameracrossedBitmap = new files.cameracrossedClass() as Bitmap;
      cameraBitmap = new files.cameraClass() as Bitmap;
      cancelBitmap = new files.cancelClass() as Bitmap;
      circlefullBitmap = new files.circlefullClass() as Bitmap;
      circleBitmap = new files.circleClass() as Bitmap;
      clearerBitmap = new files.clearerClass() as Bitmap;
      closeBitmap = new files.closeClass() as Bitmap;
      copyBitmap = new files.copyClass() as Bitmap;
      doubleleftarrowBitmap = new files.doubleleftarrowClass() as Bitmap;
      doublerightarrowBitmap = new files.doublerightarrowClass() as Bitmap;
      downarrow1Bitmap = new files.downarrow1Class() as Bitmap;
      downarrowBitmap = new files.downarrowClass() as Bitmap;
      drawerBitmap = new files.drawerClass() as Bitmap;
      emojiplusBitmap = new files.emojiplusClass() as Bitmap;
      fileBitmap = new files.fileClass() as Bitmap;
      folderBitmap = new files.folderClass() as Bitmap;
      infoBitmap = new files.infoClass() as Bitmap;
      leftarrowBitmap = new files.leftarrowClass() as Bitmap;
      lightningBitmap = new files.lightningClass() as Bitmap;
      listingBitmap = new files.listingClass() as Bitmap;
      listBitmap = new files.listClass() as Bitmap;
      logoutBitmap = new files.logoutClass() as Bitmap;
      maximizeBitmap = new files.maximizeClass() as Bitmap;
      menuBitmap = new files.menuClass() as Bitmap;
      minimizeBitmap = new files.minimizeClass() as Bitmap;
      minusBitmap = new files.minusClass() as Bitmap;
      moreBitmap = new files.moreClass() as Bitmap;
      ok1Bitmap = new files.ok1Class() as Bitmap;
      okBitmap = new files.okClass() as Bitmap;
      orderascBitmap = new files.orderascClass() as Bitmap;
      orderdescBitmap = new files.orderdescClass() as Bitmap;
      pausedBitmap = new files.pausedClass() as Bitmap;
      playingBitmap = new files.playingClass() as Bitmap;
      plusBitmap = new files.plusClass() as Bitmap;
      potmeterBitmap = new files.potmeterClass() as Bitmap;
      questionBitmap = new files.questionClass() as Bitmap;
      redoerBitmap = new files.redoerClass() as Bitmap;
      refresharrowBitmap = new files.refresharrowClass() as Bitmap;
      rightarrowBitmap = new files.rightarrowClass() as Bitmap;
      rubberBitmap = new files.rubberClass() as Bitmap;
      settingsBitmap = new files.settingsClass() as Bitmap;
      soundhighBitmap = new files.soundhighClass() as Bitmap;
      soundlowBitmap = new files.soundlowClass() as Bitmap;
      soundmidBitmap = new files.soundmidClass() as Bitmap;
      soundmutedBitmap = new files.soundmutedClass() as Bitmap;
      soundzeroBitmap = new files.soundzeroClass() as Bitmap;
      starblankBitmap = new files.starblankClass() as Bitmap;
      starfullBitmap = new files.starfullClass() as Bitmap;
      starhalfBitmap = new files.starhalfClass() as Bitmap;
      stoppedBitmap = new files.stoppedClass() as Bitmap;
      switchoffBitmap = new files.switchoffClass() as Bitmap;
      switchonBitmap = new files.switchonClass() as Bitmap;
      undoerBitmap = new files.undoerClass() as Bitmap;
      uparrow1Bitmap = new files.uparrow1Class() as Bitmap;
      uparrowBitmap = new files.uparrowClass() as Bitmap;
      warningBitmap = new files.warningClass() as Bitmap;
      watchBitmap = new files.watchClass() as Bitmap;
      application.trace("<IconManager> constructed.", 1);
    }
    protected function transformBitmapData(bitmap:Bitmap, textType:String, iconSize:int):BitmapData
    {
      var bitmapData:BitmapData = new BitmapData(iconSize, iconSize, true, 0x00ffffff);
      if (bitmap != null)
      {
        var matrix:Matrix = new Matrix();
        matrix.scale(iconSize / bitmap.width, iconSize / bitmap.height);
        bitmapData.draw(bitmap.bitmapData, matrix, null, null, null, true);
        var color:int = 0;
        if (textType == EnumTextTypes.TEXT_TYPE_MID())
        {
          color = application.getDynamicsConfig().getAppFontColorMid();
        }
        else if (textType == EnumTextTypes.TEXT_TYPE_DARK())
        {
          color = application.getDynamicsConfig().getAppFontColorDark();
        }
        else
        {
          color = application.getDynamicsConfig().getAppFontColorBright();
        }
        for ( var i:int = 0; i < bitmapData.height; i++)
        {
          for ( var j:int = 0; j < bitmapData.width; j++)
          {
            bitmapData.setPixel(i, j, color);
          }
        }
      }
      return bitmapData;
    }
    public function getNewBitmapData(iconType:String, textType:String, iconSize:int):BitmapData
    {
      if (iconType == "calendar") return transformBitmapData(calendarBitmap, textType, iconSize);
      else if (iconType == "cameracrossed") return transformBitmapData(cameracrossedBitmap, textType, iconSize);
      else if (iconType == "camera") return transformBitmapData(cameraBitmap, textType, iconSize);
      else if (iconType == "cancel") return transformBitmapData(cancelBitmap, textType, iconSize);
      else if (iconType == "circlefull") return transformBitmapData(circlefullBitmap, textType, iconSize);
      else if (iconType == "circle") return transformBitmapData(circleBitmap, textType, iconSize);
      else if (iconType == "clearer") return transformBitmapData(clearerBitmap, textType, iconSize);
      else if (iconType == "close") return transformBitmapData(closeBitmap, textType, iconSize);
      else if (iconType == "copy") return transformBitmapData(copyBitmap, textType, iconSize);
      else if (iconType == "doubleleftarrow") return transformBitmapData(doubleleftarrowBitmap, textType, iconSize);
      else if (iconType == "doublerightarrow") return transformBitmapData(doublerightarrowBitmap, textType, iconSize);
      else if (iconType == "downarrow1") return transformBitmapData(downarrow1Bitmap, textType, iconSize);
      else if (iconType == "downarrow") return transformBitmapData(downarrowBitmap, textType, iconSize);
      else if (iconType == "drawer") return transformBitmapData(drawerBitmap, textType, iconSize);
      else if (iconType == "emojiplus") return transformBitmapData(emojiplusBitmap, textType, iconSize);
      else if (iconType == "file") return transformBitmapData(fileBitmap, textType, iconSize);
      else if (iconType == "folder") return transformBitmapData(folderBitmap, textType, iconSize);
      else if (iconType == "info") return transformBitmapData(infoBitmap, textType, iconSize);
      else if (iconType == "leftarrow") return transformBitmapData(leftarrowBitmap, textType, iconSize);
      else if (iconType == "lightning") return transformBitmapData(lightningBitmap, textType, iconSize);
      else if (iconType == "listing") return transformBitmapData(listingBitmap, textType, iconSize);
      else if (iconType == "list") return transformBitmapData(listBitmap, textType, iconSize);
      else if (iconType == "logout") return transformBitmapData(logoutBitmap, textType, iconSize);
      else if (iconType == "maximize") return transformBitmapData(maximizeBitmap, textType, iconSize);
      else if (iconType == "menu") return transformBitmapData(menuBitmap, textType, iconSize);
      else if (iconType == "minimize") return transformBitmapData(minimizeBitmap, textType, iconSize);
      else if (iconType == "minus") return transformBitmapData(minusBitmap, textType, iconSize);
      else if (iconType == "more") return transformBitmapData(moreBitmap, textType, iconSize);
      else if (iconType == "ok1") return transformBitmapData(ok1Bitmap, textType, iconSize);
      else if (iconType == "ok") return transformBitmapData(okBitmap, textType, iconSize);
      else if (iconType == "orderasc") return transformBitmapData(orderascBitmap, textType, iconSize);
      else if (iconType == "orderdesc") return transformBitmapData(orderdescBitmap, textType, iconSize);
      else if (iconType == "paused") return transformBitmapData(pausedBitmap, textType, iconSize);
      else if (iconType == "playing") return transformBitmapData(playingBitmap, textType, iconSize);
      else if (iconType == "plus") return transformBitmapData(plusBitmap, textType, iconSize);
      else if (iconType == "potmeter") return transformBitmapData(potmeterBitmap, textType, iconSize);
      else if (iconType == "question") return transformBitmapData(questionBitmap, textType, iconSize);
      else if (iconType == "redoer") return transformBitmapData(redoerBitmap, textType, iconSize);
      else if (iconType == "refresharrow") return transformBitmapData(refresharrowBitmap, textType, iconSize);
      else if (iconType == "rightarrow") return transformBitmapData(rightarrowBitmap, textType, iconSize);
      else if (iconType == "rubber") return transformBitmapData(rubberBitmap, textType, iconSize);
      else if (iconType == "settings") return transformBitmapData(settingsBitmap, textType, iconSize);
      else if (iconType == "soundhigh") return transformBitmapData(soundhighBitmap, textType, iconSize);
      else if (iconType == "soundlow") return transformBitmapData(soundlowBitmap, textType, iconSize);
      else if (iconType == "soundmid") return transformBitmapData(soundmidBitmap, textType, iconSize);
      else if (iconType == "soundmuted") return transformBitmapData(soundmutedBitmap, textType, iconSize);
      else if (iconType == "soundzero") return transformBitmapData(soundzeroBitmap, textType, iconSize);
      else if (iconType == "starblank") return transformBitmapData(starblankBitmap, textType, iconSize);
      else if (iconType == "starfull") return transformBitmapData(starfullBitmap, textType, iconSize);
      else if (iconType == "starhalf") return transformBitmapData(starhalfBitmap, textType, iconSize);
      else if (iconType == "stopped") return transformBitmapData(stoppedBitmap, textType, iconSize);
      else if (iconType == "switchoff") return transformBitmapData(switchoffBitmap, textType, iconSize);
      else if (iconType == "switchon") return transformBitmapData(switchonBitmap, textType, iconSize);
      else if (iconType == "undoer") return transformBitmapData(undoerBitmap, textType, iconSize);
      else if (iconType == "uparrow1") return transformBitmapData(uparrow1Bitmap, textType, iconSize);
      else if (iconType == "uparrow") return transformBitmapData(uparrowBitmap, textType, iconSize);
      else if (iconType == "warning") return transformBitmapData(warningBitmap, textType, iconSize);
      else if (iconType == "watch") return transformBitmapData(watchBitmap, textType, iconSize);
      else return null;
    }
    /**
     * Disposes the bitmap data of the given bitmap.
     * @param bitmap the bitmap the data of which has to be freed up
     */
    protected function disposeBitmap(bitmap:Bitmap):void
    {
      if (bitmap != null && bitmap.bitmapData != null)
      {
        bitmap.bitmapData.dispose();
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    public function destroy():void
    {
      application.trace("<IconManager destroy> called.", 1);
      disposeBitmap(calendarBitmap);
      calendarBitmap = null;
      disposeBitmap(cameracrossedBitmap);
      cameracrossedBitmap = null;
      disposeBitmap(cameraBitmap);
      cameraBitmap = null;
      disposeBitmap(cancelBitmap);
      cancelBitmap = null;
      disposeBitmap(circlefullBitmap);
      circlefullBitmap = null;
      disposeBitmap(circleBitmap);
      circleBitmap = null;
      disposeBitmap(clearerBitmap);
      clearerBitmap = null;
      disposeBitmap(closeBitmap);
      closeBitmap = null;
      disposeBitmap(copyBitmap);
      copyBitmap = null;
      disposeBitmap(doubleleftarrowBitmap);
      doubleleftarrowBitmap = null;
      disposeBitmap(doublerightarrowBitmap);
      doublerightarrowBitmap = null;
      disposeBitmap(downarrow1Bitmap);
      downarrow1Bitmap = null;
      disposeBitmap(downarrowBitmap);
      downarrowBitmap = null;
      disposeBitmap(drawerBitmap);
      drawerBitmap = null;
      disposeBitmap(emojiplusBitmap);
      emojiplusBitmap = null;
      disposeBitmap(fileBitmap);
      fileBitmap = null;
      disposeBitmap(folderBitmap);
      folderBitmap = null;
      disposeBitmap(infoBitmap);
      infoBitmap = null;
      disposeBitmap(leftarrowBitmap);
      leftarrowBitmap = null;
      disposeBitmap(lightningBitmap);
      lightningBitmap = null;
      disposeBitmap(listingBitmap);
      listingBitmap = null;
      disposeBitmap(listBitmap);
      listBitmap = null;
      disposeBitmap(logoutBitmap);
      logoutBitmap = null;
      disposeBitmap(maximizeBitmap);
      maximizeBitmap = null;
      disposeBitmap(menuBitmap);
      menuBitmap = null;
      disposeBitmap(minimizeBitmap);
      minimizeBitmap = null;
      disposeBitmap(minusBitmap);
      minusBitmap = null;
      disposeBitmap(moreBitmap);
      moreBitmap = null;
      disposeBitmap(ok1Bitmap);
      ok1Bitmap = null;
      disposeBitmap(okBitmap);
      okBitmap = null;
      disposeBitmap(orderascBitmap);
      orderascBitmap = null;
      disposeBitmap(orderdescBitmap);
      orderdescBitmap = null;
      disposeBitmap(pausedBitmap);
      pausedBitmap = null;
      disposeBitmap(playingBitmap);
      playingBitmap = null;
      disposeBitmap(plusBitmap);
      plusBitmap = null;
      disposeBitmap(potmeterBitmap);
      potmeterBitmap = null;
      disposeBitmap(questionBitmap);
      questionBitmap = null;
      disposeBitmap(redoerBitmap);
      redoerBitmap = null;
      disposeBitmap(refresharrowBitmap);
      refresharrowBitmap = null;
      disposeBitmap(rightarrowBitmap);
      rightarrowBitmap = null;
      disposeBitmap(rubberBitmap);
      rubberBitmap = null;
      disposeBitmap(settingsBitmap);
      settingsBitmap = null;
      disposeBitmap(soundhighBitmap);
      soundhighBitmap = null;
      disposeBitmap(soundlowBitmap);
      soundlowBitmap = null;
      disposeBitmap(soundmidBitmap);
      soundmidBitmap = null;
      disposeBitmap(soundmutedBitmap);
      soundmutedBitmap = null;
      disposeBitmap(soundzeroBitmap);
      soundzeroBitmap = null;
      disposeBitmap(starblankBitmap);
      starblankBitmap = null;
      disposeBitmap(starfullBitmap);
      starfullBitmap = null;
      disposeBitmap(starhalfBitmap);
      starhalfBitmap = null;
      disposeBitmap(stoppedBitmap);
      stoppedBitmap = null;
      disposeBitmap(switchoffBitmap);
      switchoffBitmap = null;
      disposeBitmap(switchonBitmap);
      switchonBitmap = null;
      disposeBitmap(undoerBitmap);
      undoerBitmap = null;
      disposeBitmap(uparrow1Bitmap);
      uparrow1Bitmap = null;
      disposeBitmap(uparrowBitmap);
      uparrowBitmap = null;
      disposeBitmap(warningBitmap);
      warningBitmap = null;
      disposeBitmap(watchBitmap);
      watchBitmap = null;
      files = null;
      application = null;
    }
  }
}
class IconManagerFiles
{
  [Embed(source = "../resource/icon/calendar.png")]
  public var calendarClass:Class;
  [Embed(source = "../resource/icon/cameracrossed.png")]
  public var cameracrossedClass:Class;
  [Embed(source = "../resource/icon/camera.png")]
  public var cameraClass:Class;
  [Embed(source = "../resource/icon/cancel.png")]
  public var cancelClass:Class;
  [Embed(source = "../resource/icon/circlefull.png")]
  public var circlefullClass:Class;
  [Embed(source = "../resource/icon/circle.png")]
  public var circleClass:Class;
  [Embed(source = "../resource/icon/clearer.png")]
  public var clearerClass:Class;
  [Embed(source = "../resource/icon/close.png")]
  public var closeClass:Class;
  [Embed(source = "../resource/icon/copy.png")]
  public var copyClass:Class;
  [Embed(source = "../resource/icon/doubleleftarrow.png")]
  public var doubleleftarrowClass:Class;
  [Embed(source = "../resource/icon/doublerightarrow.png")]
  public var doublerightarrowClass:Class;
  [Embed(source = "../resource/icon/downarrow1.png")]
  public var downarrow1Class:Class;
  [Embed(source = "../resource/icon/downarrow.png")]
  public var downarrowClass:Class;
  [Embed(source = "../resource/icon/drawer.png")]
  public var drawerClass:Class;
  [Embed(source = "../resource/icon/emojiplus.png")]
  public var emojiplusClass:Class;
  [Embed(source = "../resource/icon/file.png")]
  public var fileClass:Class;
  [Embed(source = "../resource/icon/folder.png")]
  public var folderClass:Class;
  [Embed(source = "../resource/icon/info.png")]
  public var infoClass:Class;
  [Embed(source = "../resource/icon/leftarrow.png")]
  public var leftarrowClass:Class;
  [Embed(source = "../resource/icon/lightning.png")]
  public var lightningClass:Class;
  [Embed(source = "../resource/icon/listing.png")]
  public var listingClass:Class;
  [Embed(source = "../resource/icon/list.png")]
  public var listClass:Class;
  [Embed(source = "../resource/icon/logout.png")]
  public var logoutClass:Class;
  [Embed(source = "../resource/icon/maximize.png")]
  public var maximizeClass:Class;
  [Embed(source = "../resource/icon/menu.png")]
  public var menuClass:Class;
  [Embed(source = "../resource/icon/minimize.png")]
  public var minimizeClass:Class;
  [Embed(source = "../resource/icon/minus.png")]
  public var minusClass:Class;
  [Embed(source = "../resource/icon/more.png")]
  public var moreClass:Class;
  [Embed(source = "../resource/icon/ok1.png")]
  public var ok1Class:Class;
  [Embed(source = "../resource/icon/ok.png")]
  public var okClass:Class;
  [Embed(source = "../resource/icon/orderasc.png")]
  public var orderascClass:Class;
  [Embed(source = "../resource/icon/orderdesc.png")]
  public var orderdescClass:Class;
  [Embed(source = "../resource/icon/paused.png")]
  public var pausedClass:Class;
  [Embed(source = "../resource/icon/playing.png")]
  public var playingClass:Class;
  [Embed(source = "../resource/icon/plus.png")]
  public var plusClass:Class;
  [Embed(source = "../resource/icon/potmeter.png")]
  public var potmeterClass:Class;
  [Embed(source = "../resource/icon/question.png")]
  public var questionClass:Class;
  [Embed(source = "../resource/icon/redoer.png")]
  public var redoerClass:Class;
  [Embed(source = "../resource/icon/refresharrow.png")]
  public var refresharrowClass:Class;
  [Embed(source = "../resource/icon/rightarrow.png")]
  public var rightarrowClass:Class;
  [Embed(source = "../resource/icon/rubber.png")]
  public var rubberClass:Class;
  [Embed(source = "../resource/icon/settings.png")]
  public var settingsClass:Class;
  [Embed(source = "../resource/icon/soundhigh.png")]
  public var soundhighClass:Class;
  [Embed(source = "../resource/icon/soundlow.png")]
  public var soundlowClass:Class;
  [Embed(source = "../resource/icon/soundmid.png")]
  public var soundmidClass:Class;
  [Embed(source = "../resource/icon/soundmuted.png")]
  public var soundmutedClass:Class;
  [Embed(source = "../resource/icon/soundzero.png")]
  public var soundzeroClass:Class;
  [Embed(source = "../resource/icon/starblank.png")]
  public var starblankClass:Class;
  [Embed(source = "../resource/icon/starfull.png")]
  public var starfullClass:Class;
  [Embed(source = "../resource/icon/starhalf.png")]
  public var starhalfClass:Class;
  [Embed(source = "../resource/icon/stopped.png")]
  public var stoppedClass:Class;
  [Embed(source = "../resource/icon/switchoff.png")]
  public var switchoffClass:Class;
  [Embed(source = "../resource/icon/switchon.png")]
  public var switchonClass:Class;
  [Embed(source = "../resource/icon/undoer.png")]
  public var undoerClass:Class;
  [Embed(source = "../resource/icon/uparrow1.png")]
  public var uparrow1Class:Class;
  [Embed(source = "../resource/icon/uparrow.png")]
  public var uparrowClass:Class;
  [Embed(source = "../resource/icon/warning.png")]
  public var warningClass:Class;
  [Embed(source = "../resource/icon/watch.png")]
  public var watchClass:Class;
  public function IconManagerFiles():void {}
}
