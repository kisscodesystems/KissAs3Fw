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
** SoundPlayer.
** This is a class that can play an embedded sound object.
**
** MAIN FEATURES:
** - Standard player features, such as play, pause, stop and seek.
** - Playing time and remaing time are also displayed.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . Icon ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . display . Shape ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . events . TimerEvent ;
  import flash . geom . Rectangle ;
  import flash . media . Sound ;
  import flash . media . SoundChannel ;
  import flash . media . SoundTransform ;
  import flash . utils . Timer ;
  public class SoundPlayer extends BaseSprite
  {
// The zero time is this string.
    private const INI_TIME : String = "0:00" ;
// The type and the name of the sound to be played, from outside.
    private var soundType : String = "" ;
    private var soundName : String = "" ;
// These can be from the sound itself: how long it is (milliseconds and bytes)
    private var soundLengthMillis : Number = 0 ;
    private var soundLengthBytes : Number = 0 ;
    private var soundMaxSecs : int = 0 ;
// The pieces of this player object.
    private var shapeBgFrame : BaseShape = null ;
    private var playButtonLink : ButtonLink = null ;
    private var pausButtonLink : ButtonLink = null ;
    private var stopButtonLink : ButtonLink = null ;
    private var soundNameTextLabel : TextLabel = null ;
    private var seekIcon : Icon = null ;
    private var seekRect : Rectangle = null ;
    private var progressTimeTextLabel : TextLabel = null ;
    private var remainingTimeTextLabel : TextLabel = null ;
    private var bufferDraw : Shape = null ;
// The events to the outside world.
    private var eventPlayed : Event = null ;
// The soundChannel object to gain control on the played sound.
    private var soundChannel : SoundChannel = null ;
// Timer to display the progress of playing.
    private var timeDisplayingTimer : Timer = null ;
// The line of the progress.
    private var bufferDrawColor : Number = 0 ;
    private var bufferDrawLineThickness : int = 1 ;
// The current point to store when pausing.
    private var pausePoint : Number = 0 ;
// The boolean property that holds the current playing or stopped (paused) state.
    private var playing : Boolean = false ;
// When the seek icon is dragged than it should not be moved to the actual progress position.
    private var seekIconIsDragged : Boolean = false ;
// To handle the sound volume changing from the settings panel.
    private var soundTr : SoundTransform = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function SoundPlayer ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This event is for broadcasting the fact that this player just has been started.
      eventPlayed = new Event ( application . EVENT_PLAYED ) ;
// Let's create the main content!
// progress and remaining time textfields, seek icon, buffer drawing and stop button link: these are invisible until playing.
      shapeBgFrame = new BaseShape ( application ) ;
      addChild ( shapeBgFrame ) ;
      shapeBgFrame . setdb ( true ) ;
      shapeBgFrame . setdt ( 1 ) ;
      playButtonLink = new ButtonLink ( application ) ;
      addChild ( playButtonLink ) ;
      playButtonLink . setIcon ( "playing" ) ;
      playButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , playButtonLinkClicked ) ;
      playButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposResize ) ;
      playButtonLink . setEnabled ( false ) ;
      pausButtonLink = new ButtonLink ( application ) ;
      addChild ( pausButtonLink ) ;
      pausButtonLink . setIcon ( "paused" ) ;
      pausButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , pausButtonLinkClicked ) ;
      pausButtonLink . visible = false ;
      soundNameTextLabel = new TextLabel ( application ) ;
      addChild ( soundNameTextLabel ) ;
      stopButtonLink = new ButtonLink ( application ) ;
      addChild ( stopButtonLink ) ;
      stopButtonLink . setIcon ( "stopped" ) ;
      stopButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , stopButtonLinkClicked ) ;
      stopButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposResize ) ;
      stopButtonLink . setEnabled ( false ) ;
      stopButtonLink . visible = false ;
      bufferDraw = new Shape ( ) ;
      addChild ( bufferDraw ) ;
      bufferDraw . visible = false ;
      seekIcon = new Icon ( application ) ;
      addChild ( seekIcon ) ;
      redrawSeekIcon ( null ) ;
      seekIcon . visible = false ;
      progressTimeTextLabel = new TextLabel ( application ) ;
      addChild ( progressTimeTextLabel ) ;
      progressTimeTextLabel . visible = false ;
      remainingTimeTextLabel = new TextLabel ( application ) ;
      addChild ( remainingTimeTextLabel ) ;
      remainingTimeTextLabel . visible = false ;
      remainingTimeTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , reposRemainingTimeTextLabel ) ;
// Some basic initialization.
      resetDisplayedTimes ( ) ;
      reposResize ( null ) ;
      soundVolumeChanged ( null ) ;
// This events have to be registered to the correct display and to sound volume.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED , redrawSeekIcon ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_FONT_COLOR_DARK_CHANGED , redrawBufferDraw ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , redrawBufferDraw ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SOUND_VOLUME_CHANGED , soundVolumeChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , redrawShape ) ;
    }
/*
** The volume of the sound has been changed from the PropsDyn. ( from the settings panel for example )
*/
    private function soundVolumeChanged ( e : Event ) : void
    {
// A new sound transform object will be created every time.
      soundTr = new SoundTransform ( ) ;
      soundTr . volume = application . getPropsDyn ( ) . getAppSoundVolume ( ) / 100 ;
// And give it to the sound channel if it is playing now.
      if ( soundChannel != null )
      {
        soundChannel . soundTransform = soundTr ;
      }
    }
/*
** Redrawing of the seek icon.
*/
    private function redrawSeekIcon ( e : Event ) : void
    {
      if ( seekIcon != null )
      {
        seekIcon . drawBitmapData ( "potmeter" , application . getTexts ( ) . TEXT_TYPE_BRIGHT , application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ) ;
      }
    }
/*
** To determine the seeking properties.
*/
    private function recreateSeekRect ( ) : void
    {
      seekRect = new Rectangle ( getSeekIconInix ( ) , getSeekIconIniy ( ) , getSeekIconDragWidth ( ) ) ;
    }
    private function getSeekIconInix ( ) : int
    {
      if ( application != null )
      {
        return 2 * application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      }
      return 1 ;
    }
    private function getSeekIconIniy ( ) : int
    {
      if ( application != null )
      {
        return application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ;
      }
      return 1 ;
    }
    private function getSeekIconDragWidth ( ) : int
    {
      if ( application != null && seekIcon != null )
      {
        return getsw ( ) - 4 * application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) - seekIcon . getsw ( ) ;
      }
      return 1 ;
    }
    private function seekIconToBegin ( ) : void
    {
      if ( seekIcon != null )
      {
        seekIcon . setcxy ( getSeekIconInix ( ) , getSeekIconIniy ( ) ) ;
        recreateSeekRect ( ) ;
      }
    }
/*
** Get the sound properties.
*/
    public function getSoundType ( ) : String
    {
      return soundType ;
    }
    public function getSoundName ( ) : String
    {
      return soundName ;
    }
    public function getSoundLengthMillis ( ) : Number
    {
      return soundLengthMillis ;
    }
    public function getSoundLengthBytes ( ) : Number
    {
      return soundLengthBytes ;
    }
    public function getSoundMaxSecs ( ) : int
    {
      return soundMaxSecs ;
    }
/*
** playing property to the outside.
** playing true: playing.
** pause point is not 0 than it is paused: playing.
** playing means that this player is currently in use.
*/
    public function isPlaying ( ) : Boolean
    {
      return playing || pausePoint != 0 ;
    }
/*
** Dispatches the event of playing.
** Useful when many players are in use.
*/
    private function dispatchEventPlayed ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventPlayed ) ;
      }
    }
/*
** Sets the soundType (the name of the sound to be played)
*/
    public function setSoundTypeAndName ( st : String , sn : String ) : void
    {
// Just for sure.
      stop ( ) ;
// New values
      soundType = st ;
      soundName = sn ;
// Now get the sound itself.
      var sound : Sound = application . getSoundManager ( ) . getSound ( soundType ) ;
// In case of existing sound, other initialization will be done.
      if ( sound != null )
      {
        soundLengthMillis = sound . length ;
        soundMaxSecs = int ( soundLengthMillis / 1000 ) ;
        resetDisplayedTimes ( ) ;
        soundLengthBytes = sound . bytesTotal ;
        if ( playButtonLink != null )
        {
          playButtonLink . setEnabled ( true ) ;
        }
        if ( stopButtonLink != null )
        {
          stopButtonLink . setEnabled ( true ) ;
        }
        if ( soundNameTextLabel != null )
        {
          soundNameTextLabel . setTextCode ( soundName ) ;
        }
      }
      else
      {
        if ( soundNameTextLabel != null )
        {
          soundNameTextLabel . setTextCode ( "" ) ;
        }
      }
    }
/*
** Resets the displaying of times.
*/
    private function resetDisplayedTimes ( ) : void
    {
      if ( remainingTimeTextLabel != null )
      {
        remainingTimeTextLabel . setTextCode ( "-" + application . secondsToMinutes ( soundMaxSecs ) ) ;
      }
      if ( progressTimeTextLabel != null )
      {
        progressTimeTextLabel . setTextCode ( INI_TIME ) ;
      }
    }
/*
** Controller methods to play and stop this sound, can be accessible by others.
*/
    public function play ( ) : void
    {
      playButtonLinkClicked ( null ) ;
    }
    public function pause ( ) : void
    {
      pausButtonLinkClicked ( null ) ;
    }
    public function stop ( ) : void
    {
      stopButtonLinkClicked ( null ) ;
    }
/*
** These will handle the creation and destroying of the sound channel.
** Sound will be played always from the pausePoint. This can be 0 or a positive number (milliseconds).
** Every new sound channel creation will cause a whole new sound channel object, so
** if it is existing, than we have to destroy it first.
*/
    private function dropSoundChannel ( ) : void
    {
      if ( soundChannel != null )
      {
        soundChannel . stop ( ) ;
        soundChannel . removeEventListener ( Event . SOUND_COMPLETE , soundComplete ) ;
        soundChannel = null ;
      }
    }
    private function createSoundChannel ( ) : void
    {
      dropSoundChannel ( ) ;
      soundChannel = application . getSoundManager ( ) . playSound ( soundType , pausePoint ) ;
      if ( soundChannel != null )
      {
        soundChannel . addEventListener ( Event . SOUND_COMPLETE , soundComplete , false , 0 , true ) ;
        soundChannel . soundTransform = soundTr ;
      }
    }
/*
** To handle seek operations.
** Seek can happen if we start to drag the seekIcon.
** The sound playing and the time displaying will continue,
** but the seek icon is ours.
** When it is released (stageMouseUp), the new position will be
** calculated, and the playing will continue from that point.
*/ 
    private function seekIconMouseDown ( e : MouseEvent ) : void
    {
      if ( seekIcon != null )
      {
        seekIconIsDragged = true ;
        seekIcon . startDrag ( false , seekRect ) ;
      }
      if ( stage != null )
      {
        stage . addEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
    }
    private function stageMouseUp ( e : MouseEvent ) : void
    {
      if ( seekIcon != null )
      {
        seekIcon . stopDrag ( ) ;
        seekIconIsDragged = false ;
        pausePoint = soundLengthMillis * ( seekIcon . x - getSeekIconInix ( ) ) / ( getSeekIconDragWidth ( ) ) ;
        playButtonLinkClicked ( null ) ;
      }
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
    }
/*
** The play button link is clicked: everything will be reinitialized.
*/
    private function playButtonLinkClicked ( e : Event ) : void
    {
      createSoundChannel ( ) ;
      seekIconToBegin ( ) ;
      if ( seekIcon != null )
      {
        seekIcon . visible = true ;
        seekIcon . addEventListener ( MouseEvent . MOUSE_DOWN , seekIconMouseDown ) ;
      }
      if ( progressTimeTextLabel != null )
      {
        progressTimeTextLabel . visible = true ;
      }
      if ( remainingTimeTextLabel != null )
      {
        remainingTimeTextLabel . visible = true ;
      }
      if ( bufferDraw != null )
      {
        bufferDraw . visible = true ;
      }
      if ( playButtonLink != null )
      {
        super . setsh ( 2 * playButtonLink . getsh ( ) - application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        redrawShape ( null ) ;
        playButtonLink . visible = false ;
      }
      if ( pausButtonLink != null )
      {
        pausButtonLink . visible = true ;
      }
      if ( stopButtonLink != null )
      {
        stopButtonLink . visible = true ;
      }
      resizeSoundNameTextLabel ( ) ;
      playing = true ;
      createTimeDisplayingTimer ( ) ;
      dispatchEventPlayed ( ) ;
    }
    private function pausButtonLinkClicked ( e : Event ) : void
    {
      if ( soundChannel != null )
      {
        pausePoint = soundChannel . position ;
        dropSoundChannel ( ) ;
      }
      else
      {
        pausePoint = 0 ;
      }
      if ( pausButtonLink != null )
      {
        pausButtonLink . visible = false ;
      }
      if ( playButtonLink != null )
      {
        playButtonLink . visible = true ;
      }
      playing = false ;
      dropTimeDisplayingTimer ( ) ;
    }
    private function stopButtonLinkClicked ( e : Event ) : void
    {
      dropSoundChannel ( ) ;
      dropTimeDisplayingTimer ( ) ;
      resetDisplayedTimes ( ) ;
      seekIconToBegin ( ) ;
      if ( seekIcon != null )
      {
        seekIcon . visible = false ;
        seekIcon . removeEventListener ( MouseEvent . MOUSE_DOWN , seekIconMouseDown ) ;
      }
      if ( progressTimeTextLabel != null )
      {
        progressTimeTextLabel . visible = false ;
      }
      if ( remainingTimeTextLabel != null )
      {
        remainingTimeTextLabel . visible = false ;
      }
      if ( bufferDraw != null )
      {
        bufferDraw . visible = false ;
      }
      if ( playButtonLink != null )
      {
        super . setsh ( playButtonLink . getsh ( ) ) ;
        redrawShape ( null ) ;
        playButtonLink . visible = true ;
      }
      if ( pausButtonLink != null )
      {
        pausButtonLink . visible = false ;
      }
      if ( stopButtonLink != null )
      {
        stopButtonLink . visible = false ;
      }
      resizeSoundNameTextLabel ( ) ;
      seekIconIsDragged = false ;
      playing = false ;
      pausePoint = 0 ;
    }
/*
** This is just to be sure that the UI will return to the initial state.
*/
    private function soundComplete ( e : Event ) : void
    {
      stopButtonLinkClicked ( null ) ;
    }
/*
** The time displaying and the repositioning of the seek icon happen by timer.
*/
    private function dropTimeDisplayingTimer ( ) : void
    {
      if ( timeDisplayingTimer != null )
      {
        timeDisplayingTimer . stop ( ) ;
        timeDisplayingTimer . removeEventListener ( TimerEvent . TIMER , timeDisplayingTimerHandler ) ;
        timeDisplayingTimer = null ;
      }
    }
    private function createTimeDisplayingTimer ( ) : void
    {
      dropTimeDisplayingTimer ( ) ;
      timeDisplayingTimer = new Timer ( application . TIME_DISPLAYING_TIMER_DELAY ) ;
      timeDisplayingTimer . start ( ) ;
      timeDisplayingTimer . addEventListener ( TimerEvent . TIMER , timeDisplayingTimerHandler ) ;
    }
    private function timeDisplayingTimerHandler ( e : TimerEvent ) : void
    {
      if ( soundChannel != null )
      {
// The current position.
        var progress : Number = soundChannel . position ;
// The same but it can be displayed.
        var progressSecs : int = int ( progress / 1000 ) ;
// Updating the time displayings.
        if ( remainingTimeTextLabel != null )
        {
          remainingTimeTextLabel . setTextCode ( "-" + application . secondsToMinutes ( soundMaxSecs - progressSecs ) ) ;
        }
        if ( progressTimeTextLabel != null )
        {
          progressTimeTextLabel . setTextCode ( application . secondsToMinutes ( progressSecs ) ) ;
        }
// And the position of the seek icon too, if it is not dragged currently!
// If it is dragged then we will set the position by hand to set the new position to play from.
        if ( seekIcon != null && ! seekIconIsDragged )
        {
          seekIcon . setcxy ( Math . max ( getSeekIconInix ( ) , Math . min ( getSeekIconInix ( ) + getSeekIconDragWidth ( ) , getSeekIconInix ( ) + getSeekIconDragWidth ( ) * progress / soundLengthMillis ) ) , getSeekIconIniy ( ) ) ;
        }
      }
      else
      {
        stopButtonLinkClicked ( null ) ;
      }
    }
/*
** Resizes only the sound name text label.
*/
    private function resizeSoundNameTextLabel ( ) : void
    {
      if ( soundNameTextLabel != null && playButtonLink != null && stopButtonLink != null )
      {
        soundNameTextLabel . setMaxWidth ( ( stopButtonLink . visible ? stopButtonLink . getcx ( ) : getsw ( ) - application . getPropsDyn ( ) . getAppPadding ( ) ) - playButtonLink . getcxsw ( ) , false ) ;
      }
    }
/*
** Repositions only the remaining time text label.
*/
    private function reposRemainingTimeTextLabel ( e : Event ) : void
    {
      if ( remainingTimeTextLabel != null && progressTimeTextLabel != null )
      {
        remainingTimeTextLabel . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppPadding ( ) - remainingTimeTextLabel . getsw ( ) , progressTimeTextLabel . getcy ( ) ) ;
      }
    }
/*
** Repos and resize everything.
*/
    private function reposResize ( e : Event ) : void
    {
      if ( playButtonLink != null )
      {
        playButtonLink . setcxy ( 0 , 0 ) ;
        if ( pausButtonLink != null )
        {
          pausButtonLink . setcxy ( playButtonLink . getcx ( ) , playButtonLink . getcy ( ) ) ;
          if ( stopButtonLink != null )
          {
            stopButtonLink . setcxy ( getsw ( ) - stopButtonLink . getsw ( ) , playButtonLink . getcy ( ) ) ;
            if ( soundNameTextLabel != null )
            {
              soundNameTextLabel . setcxy ( playButtonLink . getcxsw ( ) , playButtonLink . getcyap ( ) ) ;
              resizeSoundNameTextLabel ( ) ;
              if ( progressTimeTextLabel != null )
              {
                progressTimeTextLabel . setcxy ( playButtonLink . getcxap ( ) , playButtonLink . getcysh ( ) ) ;
                reposRemainingTimeTextLabel ( null ) ;
                redrawSeekIcon ( null ) ;
                recreateSeekRect ( ) ;
                seekIconToBegin ( ) ;
                redrawBufferDraw ( null ) ;
              }
            }
          }
        }
// 2 different sizes (height) can be set:
// When it is playing, extra UI elements will be displayed such as times and seek icon, extra place is needed.
        if ( isPlaying ( ) )
        {
          super . setsh ( 2 * playButtonLink . getsh ( ) - application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        }
        else
        {
          super . setsh ( playButtonLink . getsh ( ) ) ;
        }
// The new sizes have to be displayed by the basic frame.
        redrawShape ( null ) ;
      }
    }
/*
** Redraws only the bufferDraw shape.
** The buffer drawing is a horizontal line basically,
** because we play embedded sounds so these are here immediately.
** The buffer drawing is a timeline.
*/
    private function redrawBufferDraw ( e : Event ) : void
    {
      bufferDrawColor = application . getPropsDyn ( ) . getAppFontColorDark ( ) ;
      bufferDrawLineThickness = application . getPropsDyn ( ) . getAppLineThickness ( ) * 2 ;
      if ( bufferDraw != null && seekIcon != null && playButtonLink != null )
      {
        bufferDraw . graphics . clear ( ) ;
        bufferDraw . graphics . lineStyle ( bufferDrawLineThickness , bufferDrawColor ) ;
        bufferDraw . graphics . moveTo ( seekIcon . getsw ( ) / 2 + getSeekIconInix ( ) , playButtonLink . getsh ( ) ) ;
        bufferDraw . graphics . lineTo ( seekIcon . getsw ( ) / 2 + getSeekIconInix ( ) + getSeekIconDragWidth ( ) , playButtonLink . getsh ( ) ) ;
      }
    }
/*
** Redraws the shape only.
*/
    private function redrawShape ( e : Event ) : void
    {
      if ( shapeBgFrame != null )
      {
        shapeBgFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeBgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeBgFrame . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeBgFrame . drawRect ( ) ;
      }
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        reposResize ( null ) ;
      }
    }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      stop ( ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_FONT_COLOR_BRIGHT_CHANGED , redrawSeekIcon ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_FONT_COLOR_DARK_CHANGED , redrawBufferDraw ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , redrawBufferDraw ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SOUND_VOLUME_CHANGED , soundVolumeChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawShape ) ;
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_UP , stageMouseUp ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventPlayed != null )
      {
        eventPlayed . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      soundType = null ;
      soundName = null ;
      soundLengthMillis = 0 ;
      soundLengthBytes = 0 ;
      soundMaxSecs = 0 ;
      shapeBgFrame = null ;
      playButtonLink = null ;
      pausButtonLink = null ;
      stopButtonLink = null ;
      soundNameTextLabel = null ;
      seekIcon = null ;
      seekRect = null ;
      progressTimeTextLabel = null ;
      remainingTimeTextLabel = null ;
      bufferDraw = null ;
      eventPlayed = null ;
      soundChannel = null ;
      timeDisplayingTimer = null ;
      bufferDrawColor = 0 ;
      bufferDrawLineThickness = 1 ;
      pausePoint = 0 ;
      playing = false ;
      seekIconIsDragged = false ;
      soundTr = null ;
    }
  }
}
