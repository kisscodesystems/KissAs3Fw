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
 * SoundManager.
 * Handles embedded sounds.
 * This class is generated so can be overwritten from outside.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.system.System;
  public class SoundManager
  {
    protected var application:Application = null;
    private var buttonSound:Sound;
    private var confirmSound:Sound;
    private var errorSound:Sound;
    private var menuitemSound:Sound;
    private var messageSound:Sound;
    private var openSound:Sound;
    private var screenlockSound:Sound;
    private var settingsSound:Sound;
    private var files:SoundManagerFiles = new SoundManagerFiles();
    public function SoundManager(applicationRef:Application):void
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
      buttonSound = new files.buttonClass() as Sound;
      confirmSound = new files.confirmClass() as Sound;
      errorSound = new files.errorClass() as Sound;
      menuitemSound = new files.menuitemClass() as Sound;
      messageSound = new files.messageClass() as Sound;
      openSound = new files.openClass() as Sound;
      screenlockSound = new files.screenlockClass() as Sound;
      settingsSound = new files.settingsClass() as Sound;
      application.trace("<SoundManager> constructed.", 1);
    }
    public function playSound(soundType:String, startTime:Number = 0):SoundChannel
    {
      var soundChannel:SoundChannel = null;
      if (application.getDynamicsConfig().getAppSoundPlaying())
      {
        var soundTransform:SoundTransform = new SoundTransform();
        soundTransform.volume = application.getDynamicsConfig().getAppSoundVolume() / 100;
        if (soundType == "button") soundChannel = buttonSound.play(startTime);
        else if (soundType == "confirm") soundChannel = confirmSound.play(startTime);
        else if (soundType == "error") soundChannel = errorSound.play(startTime);
        else if (soundType == "menuitem") soundChannel = menuitemSound.play(startTime);
        else if (soundType == "message") soundChannel = messageSound.play(startTime);
        else if (soundType == "open") soundChannel = openSound.play(startTime);
        else if (soundType == "screenlock") soundChannel = screenlockSound.play(startTime);
        else if (soundType == "settings") soundChannel = settingsSound.play(startTime);
        else soundChannel = null;
        if (soundChannel != null)
        {
          soundChannel.soundTransform = soundTransform;
        }
      }
      return soundChannel;
    }
    public function getSound(soundType:String):Sound
    {
      if (soundType == "button") return buttonSound;
      else if (soundType == "confirm") return confirmSound;
      else if (soundType == "error") return errorSound;
      else if (soundType == "menuitem") return menuitemSound;
      else if (soundType == "message") return messageSound;
      else if (soundType == "open") return openSound;
      else if (soundType == "screenlock") return screenlockSound;
      else if (soundType == "settings") return settingsSound;
      else return null;
    }
    /**
     * Destroys this object and frees up everything.
     */
    public function destroy():void
    {
      application.trace("<SoundManager destroy> called.", 1);
      buttonSound = null;
      confirmSound = null;
      errorSound = null;
      menuitemSound = null;
      messageSound = null;
      openSound = null;
      screenlockSound = null;
      settingsSound = null;
      files = null;
      application = null;
    }
  }
}
class SoundManagerFiles
{
  [Embed(source = "../resource/sound/button.mp3")]
  public var buttonClass:Class;
  [Embed(source = "../resource/sound/confirm.mp3")]
  public var confirmClass:Class;
  [Embed(source = "../resource/sound/error.mp3")]
  public var errorClass:Class;
  [Embed(source = "../resource/sound/menuitem.mp3")]
  public var menuitemClass:Class;
  [Embed(source = "../resource/sound/message.mp3")]
  public var messageClass:Class;
  [Embed(source = "../resource/sound/open.mp3")]
  public var openClass:Class;
  [Embed(source = "../resource/sound/screenlock.mp3")]
  public var screenlockClass:Class;
  [Embed(source = "../resource/sound/settings.mp3")]
  public var settingsClass:Class;
  public function SoundManagerFiles():void {}
}
