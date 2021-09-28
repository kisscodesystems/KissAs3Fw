/*
 ** This class is a part of the KissAs3Fw actionscrip framework.
 ** See the header comment lines of the
 ** com . kisscodesystems . KissAs3Fw . Application
 ** The whole framework is available at:
 ** https://github.com/kisscodesystems/KissAs3Fw
 ** Demo applications:
 ** https://github.com/kisscodesystems/KissAs3Ds
 **
 ** DESCRIPTION:
 ** SoundManager.
 ** This class is for storing the embedded sound objects.
 **
 ** MAIN FEATURES:
 ** - Embeds and stores the sounds.
 **   These can be short sound effects or complete mp3 songs for example.
 ** - Gives references to them to give information about the usable sounds.
 */
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . media . Sound ;
  import flash . media . SoundChannel ;
  import flash . media . SoundTransform ;
  import flash . system . System ;
  public class SoundManager
  {
// Let's embed the sound files! Every file has 3 lines of codes:
// - embedding
// - the class right at the next code line
// - its sound object that will be usable.
    protected var application : Application = null ;
    [ Embed ( source = "../../../../../res/sounds/button.mp3" ) ]
    private var ButtonClass : Class ;
    private var buttonSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/confirm.mp3" ) ]
    private var ConfirmClass : Class ;
    private var confirmSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/error.mp3" ) ]
    private var ErrorClass : Class ;
    private var errorSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/menuitem.mp3" ) ]
    private var MenuitemClass : Class ;
    private var menuitemSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/message.mp3" ) ]
    private var MessageClass : Class ;
    private var messageSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/open.mp3" ) ]
    private var OpenClass : Class ;
    private var openSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/settings.mp3" ) ]
    private var SettingsClass : Class ;
    private var settingsSound : Sound = null ;
    [ Embed ( source = "../../../../../res/sounds/screenlock.mp3" ) ]
    private var ScreenlockClass : Class ;
    private var screenlockSound : Sound = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function SoundManager ( applicationRef : Application ) : void
    {
// Super.
      super ( ) ;
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// Creating of the usable sound object as we have promised.
      buttonSound = new ButtonClass ( ) as Sound ;
      confirmSound = new ConfirmClass ( ) as Sound ;
      errorSound = new ErrorClass ( ) as Sound ;
      menuitemSound = new MenuitemClass ( ) as Sound ;
      messageSound = new MessageClass ( ) as Sound ;
      openSound = new OpenClass ( ) as Sound ;
      settingsSound = new SettingsClass ( ) as Sound ;
      screenlockSound = new ScreenlockClass ( ) as Sound ;
    }
/*
** Play sound.
** This will play the sound immediately, and gives a reference back
** to be able to control this playback thru this reference.
** The sound transform object will apply the current volume set on
** the settings panel, but the existing and now playing sounds will
** not listen to the changing of that. (Short sounds are expected.)
*/
    public function playSound ( soundType : String , startTime : Number = 0 ) : SoundChannel
    {
      var soundChannel : SoundChannel = null ;
      var soundTransform : SoundTransform = null ;
      if ( application . getPropsDyn ( ) . getAppSoundPlaying ( ) )
      {
        if ( soundType == "button" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = buttonSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "confirm" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = confirmSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "error" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = errorSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "menuitem" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = menuitemSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "message" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = messageSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "open" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = openSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "settings" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = settingsSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
        else if ( soundType == "screenlock" )
        {
          soundTransform = new SoundTransform ( ) ;
          soundTransform . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
          soundChannel = screenlockSound . play ( startTime ) ;
          soundChannel . soundTransform = soundTransform ;
          return soundChannel ;
        }
      }
      return null ;
    }
/*
** Get sound.
** This gives reference to the specific sound and null if wrong string is given.
** Every properties can be get from this reference.
*/
    public function getSound ( soundType : String ) : Sound
    {
      if ( soundType == "button" )
      {
        return buttonSound ;
      }
      else if ( soundType == "confirm" )
      {
        return confirmSound ;
      }
      else if ( soundType == "error" )
      {
        return errorSound ;
      }
      else if ( soundType == "menuitem" )
      {
        return menuitemSound ;
      }
      else if ( soundType == "message" )
      {
        return messageSound ;
      }
      else if ( soundType == "open" )
      {
        return openSound ;
      }
      else if ( soundType == "settings" )
      {
        return settingsSound ;
      }
      else if ( soundType == "screenlock" )
      {
        return screenlockSound ;
      }
      return null ;
    }
  }
}
