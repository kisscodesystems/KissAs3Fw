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
 * SoundPlayer.
 * A player of one embedded sound of the sound manager.
 *
 * MAIN FEATURES:
 * - the standard player buttons: play, pause, stop, and a seek icon to be dragged
 * - the time played so far and the time still to come are displayed continuously
 * - a played and a stopped player stand in a different height, so the buttons of a
 *   stopped one take no room at all
 * - it tells the outside by four events whether it has been played or stopped, and
 *   whether that has been done by the user or by the application
 * - it tells the outside by a changed event that the volume or the muting of it has been
 *   set on the player itself, so the one holding it follows the two controls of the sound
 *   the very way it follows the buttons of the playing
 * - a potmeter carrying the volume between zero and a hundred and a button muting and
 *   unmuting the sound stand in front of the stop button, so the sound is silenced
 *   without the volume being dragged away, and the icon of that button tells what the
 *   sound stands on: a muted player carries the icon of the muting, and an unmuted one
 *   the icon of the loudness it plays with
 * - those two are displayed while this player is playing only, the way the stop button
 *   and the seek icon are: a stopped player takes one single row
 * - the volume of it belongs to this player alone: the sound volume of the application
 *   is the one of the sound effects, so it does not touch a player at all
 * - it is never narrower than seven buttons: the name of the sound would have no room
 *   left between the buttons under that width
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Rectangle;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.utils.Timer;
  public class SoundPlayer extends BaseSprite
  {
    // The range and the increment value of the potmeter of the sound, and the two bounds
    // the icon of the button of that sound changes at: a volume under the first one is a
    // quiet player and one from the second one on is the loudest one.
    private const SOUND_VOLUME_MIN:int = 0;
    private const SOUND_VOLUME_MAX:int = 100;
    private const SOUND_VOLUME_INC:int = 1;
    private const SOUND_VOLUME_LOW_BOUND:int = 34;
    private const SOUND_VOLUME_MID_BOUND:int = 67;
    // The number of the buttons the smallest width of this player is measured in: the
    // play button, the potmeter of the sound, the button of it and the stop button take
    // four of them, and the three that are left are the room the name of the sound and
    // the times of the playing need to be readable at all.
    private const MIN_DW_IN_BUTTONS:int = 7;
    private var soundType:String = "";
    private var soundName:String = "";
    private var soundLengthMillis:Number = 0;
    private var soundLengthBytes:Number = 0;
    private var soundMaxSecs:int = 0;
    private var shapeBgFrame:BaseShape = null;
    private var playButtonLink:ButtonLink = null;
    private var pausButtonLink:ButtonLink = null;
    private var soundVolumePotmeter:Potmeter = null;
    private var soundMuteButtonLink:ButtonLink = null;
    private var stopButtonLink:ButtonLink = null;
    private var soundNameTextLabel:TextLabel = null;
    private var seekIcon:Icon = null;
    private var seekRect:Rectangle = null;
    private var progressTimeTextLabel:TextLabel = null;
    private var remainingTimeTextLabel:TextLabel = null;
    private var bufferDraw:Shape = null;
    private var sampleFrom:int = 0;
    private var eventPlayedByOutside:Event = null;
    private var eventPlayedByHand:Event = null;
    private var eventStoppedByEnd:Event = null;
    private var eventStoppedByHand:Event = null;
    private var eventChanged:Event = null;
    private var soundChannel:SoundChannel = null;
    private var timeDisplayingTimer:Timer = null;
    private var bufferDrawColor:Number = 0;
    private var bufferDrawLineThickness:int = 1;
    private var pausePoint:Number = 0;
    private var playing:Boolean = false;
    private var seekIconIsDragged:Boolean = false;
    private var soundTransform:SoundTransform = null;
    // the muting of this player: the volume it plays with is the one of its own potmeter,
    // and a muted player keeps that volume, so an unmuted one goes on with it
    private var soundMuted:Boolean = false;
    /**
     * Constructs the SoundPlayer object: creates the frame, the buttons, the controls of
     * the sound, the labels and the seek icon of it, and starts to follow the appearance
     * of the application.
     * @param applicationRef the main application reference
     */
    public function SoundPlayer(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " SoundPlayer> called.", 1);
      application.trace("<" + this + " SoundPlayer> applicationRef: " + applicationRef, 0);
      eventPlayedByHand = new Event(EnumEvents.EVENT_PLAYED_BY_HAND());
      eventPlayedByOutside = new Event(EnumEvents.EVENT_PLAYED_BY_OUTSIDE());
      eventStoppedByEnd = new Event(EnumEvents.EVENT_STOPPED_BY_END());
      eventStoppedByHand = new Event(EnumEvents.EVENT_STOPPED_BY_HAND());
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      shapeBgFrame = new BaseShape(application);
      addChild(shapeBgFrame);
      shapeBgFrame.setIsBright(true);
      shapeBgFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      playButtonLink = new ButtonLink(application);
      addChild(playButtonLink);
      playButtonLink.setIcon(EnumIcons.playing());
      playButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), playButtonLinkClicked);
      playButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposResize);
      playButtonLink.setEnabled(false);
      pausButtonLink = new ButtonLink(application);
      addChild(pausButtonLink);
      pausButtonLink.setIcon(EnumIcons.paused());
      pausButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), pausButtonLinkClicked);
      pausButtonLink.visible = false;
      soundNameTextLabel = new TextLabel(application);
      addChild(soundNameTextLabel);
      soundNameTextLabel.setLabel(" ");
      soundVolumePotmeter = new Potmeter(application);
      addChild(soundVolumePotmeter);
      soundVolumePotmeter.setDecimalPrecision(0);
      soundVolumePotmeter.setMinMaxIncValues(SOUND_VOLUME_MIN, SOUND_VOLUME_MAX, SOUND_VOLUME_INC);
      // the volume the potmeter starts with comes from the configuration and not from the
      // user, so it is a silent set: this player is taken onto it by the displaySound below
      soundVolumePotmeter.setCurValue(application.getComponentsConfig()
          .getSoundPlayerSoundVolume(), false);
      soundVolumePotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), soundVolumePotmeterChanged);
      soundVolumePotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposResize);
      soundVolumePotmeter.visible = false;
      soundMuteButtonLink = new ButtonLink(application);
      addChild(soundMuteButtonLink);
      soundMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), soundMuteButtonLinkClicked);
      soundMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposResize);
      soundMuteButtonLink.visible = false;
      stopButtonLink = new ButtonLink(application);
      addChild(stopButtonLink);
      stopButtonLink.setIcon(EnumIcons.stopped());
      stopButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), stopButtonLinkClicked);
      stopButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposResize);
      stopButtonLink.setEnabled(false);
      stopButtonLink.visible = false;
      bufferDraw = new Shape();
      addChild(bufferDraw);
      bufferDraw.visible = false;
      seekIcon = new Icon(application);
      addChild(seekIcon);
      redrawSeekIcon();
      seekIcon.visible = false;
      seekIcon.mouseDownForScrollingEnabled = false;
      progressTimeTextLabel = new TextLabel(application);
      addChild(progressTimeTextLabel);
      progressTimeTextLabel.visible = false;
      remainingTimeTextLabel = new TextLabel(application);
      addChild(remainingTimeTextLabel);
      remainingTimeTextLabel.visible = false;
      remainingTimeTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposRemainingTimeTextLabel);
      resetDisplayedTimes();
      reposResize();
      displaySound();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawSeekIcon);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), redrawBufferDraw);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), redrawBufferDraw);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShape);
      application.trace("<" + this + " SoundPlayer> constructed.", 1);
    }
    /**
     * Returns the type of the sound this player plays, an EnumSounds value.
     */
    public function getSoundType():String
    {
      return soundType;
    }
    /**
     * Returns the name of the sound this player displays.
     */
    public function getSoundName():String
    {
      return soundName;
    }
    /**
     * Takes the sound this player has to play and displays the name of it. A player
     * playing something at the moment is stopped first.
     * @param st the type of the new sound, an EnumSounds value
     * @param sn the name of the new sound, the one to be displayed
     * @param sample the second the playing has to be started at
     */
    public function setSoundTypeAndName(st:String, sn:String, sample:int = 0):void
    {
      application.trace("<" + this + " SoundPlayer setSoundTypeAndName> called.", 1);
      application.trace("<" + this + " SoundPlayer setSoundTypeAndName> st: " + st, 0);
      application.trace("<" + this + " SoundPlayer setSoundTypeAndName> sn: " + sn, 0);
      application.trace("<" + this + " SoundPlayer setSoundTypeAndName> sample: " + sample, 0);
      stop();
      soundType = st;
      soundName = sn;
      sampleFrom = sample;
      const sound:Sound = application.getSoundManager().getSound(soundType);
      if (sound != null)
      {
        soundLengthMillis = sound.length;
        soundMaxSecs = int(soundLengthMillis / 1000);
        resetDisplayedTimes();
        soundLengthBytes = sound.bytesTotal;
        playButtonLink.setEnabled(true);
        stopButtonLink.setEnabled(true);
        soundNameTextLabel.setLabel(soundName);
      }
      else
      {
        application.trace("<" + this + " SoundPlayer setSoundTypeAndName> there is no such sound!", 6);
        soundNameTextLabel.setLabel("");
      }
    }
    /**
     * Returns the length of the sound of this player in milliseconds.
     */
    public function getSoundLengthMillis():Number
    {
      return soundLengthMillis;
    }
    /**
     * Returns the length of the sound of this player in bytes.
     */
    public function getSoundLengthBytes():Number
    {
      return soundLengthBytes;
    }
    /**
     * Returns the length of the sound of this player in seconds.
     */
    public function getSoundMaxSecs():int
    {
      return soundMaxSecs;
    }
    /**
     * Tells whether this player is playing something at the moment. A paused player is
     * playing as well: it stands somewhere inside its sound.
     */
    public function isPlaying():Boolean
    {
      application.trace("<" + this + " SoundPlayer isPlaying> called.", 1);
      const b:Boolean = playing || pausePoint != 0;
      application.trace("<" + this + " SoundPlayer isPlaying> playing: " + b, 0);
      return b;
    }
    /**
     * Returns the volume this player plays with, a value between zero and a hundred: the
     * potmeter of the sound is the one carrying it. It belongs to this player alone, so
     * the sound volume of the application does not touch it: that one is the volume of
     * the sound effects.
     */
    public function getSoundVolume():int
    {
      return int(soundVolumePotmeter.getCurValue());
    }
    /**
     * Sets the volume this player plays with and takes the potmeter of the sound onto that
     * value. Only a value inside the range is taken, so the getter above is the one telling
     * what this player really stands with, and the icon of the button of the sound follows
     * the new value as well.
     * @param v the new volume, a value between zero and a hundred
     */
    public function setSoundVolume(v:int):void
    {
      application.trace("<" + this + " SoundPlayer setSoundVolume> called.", 1);
      application.trace("<" + this + " SoundPlayer setSoundVolume> v: " + v, 0);
      soundVolumePotmeter.setCurValue(v, false);
      displaySound();
    }
    /**
     * Tells whether this player is muted at the moment.
     */
    public function isSoundMuted():Boolean
    {
      return soundMuted;
    }
    /**
     * Mutes or unmutes this player. A muted one plays no sound at all and it keeps the
     * volume its potmeter stands on, so an unmuted one goes on with that very volume, and
     * the icon of the button of the sound tells which of the two states is on.
     * @param b true when this player has to be muted
     */
    public function setSoundMuted(b:Boolean):void
    {
      application.trace("<" + this + " SoundPlayer setSoundMuted> called.", 1);
      application.trace("<" + this + " SoundPlayer setSoundMuted> b: " + b, 0);
      if (soundMuted == b)
      {
        application.trace("<" + this + " SoundPlayer setSoundMuted> nothing to do.", 1);
        return;
      }
      soundMuted = b;
      displaySound();
    }
    /**
     * Starts the playing from the outside and dispatches the played by outside event.
     */
    public function play():void
    {
      application.trace("<" + this + " SoundPlayer play> called.", 1);
      doPlayingStuff();
      dispatchEventPlayedByOutside();
    }
    /**
     * Pauses the playing, so it can be continued from the very same point later.
     */
    public function pause():void
    {
      application.trace("<" + this + " SoundPlayer pause> called.", 1);
      pausButtonLinkClicked();
    }
    /**
     * Stops the playing and takes this player back to the beginning of its sound.
     */
    public function stop():void
    {
      application.trace("<" + this + " SoundPlayer stop> called.", 1);
      stopButtonLinkClicked();
    }
    /**
     * Enables or disables this player. A disabled one stops the playing first, and an
     * enabled one can only be played when there is a sound in it at all.
     * @param e true when this player has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " SoundPlayer setEnabled> called.", 1);
      application.trace("<" + this + " SoundPlayer setEnabled> e: " + e, 0);
      if (getEnabled())
      {
        if (!e)
        {
          stop();
          playButtonLink.setEnabled(false);
        }
      }
      else
      {
        if (e)
        {
          stop();
          const sound:Sound = application.getSoundManager().getSound(soundType);
          if (sound != null)
          {
            playButtonLink.setEnabled(true);
          }
        }
      }
      super.setEnabled(e);
    }
    /**
     * Returns the smallest width this player can stand in: seven buttons of the playing.
     * The play button, the potmeter of the sound, the button of it and the stop button take
     * four of them, and the three that are left are the room the name of the sound and the
     * times of the playing need to be readable at all. The height of the play button is the
     * one those seven are measured in, so a greater font size gives a wider player.
     */
    public function getMinDw():int
    {
      application.trace("<" + this + " SoundPlayer getMinDw> called.", 1);
      return MIN_DW_IN_BUTTONS * playButtonLink.getDh();
    }
    /**
     * Sets the width of this player and positions everything standing on it again. A width
     * under the smallest one this player can stand in is taken up to that smallest one:
     * the name of the sound would have no room left between the buttons under it.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " SoundPlayer setDw> called.", 1);
      application.trace("<" + this + " SoundPlayer setDw> newdw: " + newdw, 0);
      const dw:int = Math.max(newdw, getMinDw());
      if (getDw() != dw)
      {
        super.setDw(dw);
        reposResize();
      }
    }
    /**
     * The height of this player comes from the buttons of it and from the state it
     * stands in, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " SoundPlayer setDh> called.", 1);
      application.trace("<" + this + " SoundPlayer setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " SoundPlayer setDh> do nothing.", 1);
    }
    /**
     * The height of this player comes from the buttons of it, so this does nothing.
     * The width is set by the setDw.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " SoundPlayer setDwh> called.", 1);
      application.trace("<" + this + " SoundPlayer setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " SoundPlayer setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " SoundPlayer setDwh> do nothing.", 1);
    }
    /**
     * A player plays a sound of its own, so it plays no click sound at all: this does
     * nothing.
     * @param s the sound type of the click
     */
    override public function setSoundTypeClick(s:String):void
    {
      application.trace("<" + this + " SoundPlayer setSoundTypeClick> called.", 1);
      application.trace("<" + this + " SoundPlayer setSoundTypeClick> s: " + s, 0);
      application.trace("<" + this + " SoundPlayer setSoundTypeClick> do nothing.", 1);
    }
    /**
     * Renders this player in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " SoundPlayer addedToStage> called.", 1);
      application.trace("<" + this + " SoundPlayer addedToStage> e: " + e, 0);
      super.addedToStage(e);
      reposResize();
    }
    /**
     * Stops the dragging of the seek icon as soon as this player leaves the stage, so
     * that the listener of that drag is unregistered while the stage is still reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " SoundPlayer removedFromStage> called.", 1);
      application.trace("<" + this + " SoundPlayer removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      super.removedFromStage(e);
    }
    /**
     * Starts the playing: creates the sound channel, displays the buttons, the controls of
     * the sound and the labels of a playing player and starts the timer that displays the
     * time.
     */
    private function doPlayingStuff():void
    {
      application.trace("<" + this + " SoundPlayer doPlayingStuff> called.", 1);
      createSoundChannel();
      if (soundChannel == null)
      {
        application.trace("<" + this + " SoundPlayer doPlayingStuff> soundChannel is null!", 6);
        return;
      }
      seekIcon.visible = true;
      seekIcon.addEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
      redrawSeekIcon();
      progressTimeTextLabel.visible = true;
      remainingTimeTextLabel.visible = true;
      bufferDraw.visible = true;
      super.setDh(2 * playButtonLink.getDh() - application.getDynamicsConfig().getAppPadding());
      redrawShape();
      playButtonLink.visible = false;
      pausButtonLink.visible = true;
      soundVolumePotmeter.visible = true;
      soundMuteButtonLink.visible = true;
      stopButtonLink.visible = true;
      resizeSoundNameTextLabel();
      playing = true;
      createTimeDisplayingTimer();
    }
    /**
     * Stops the playing: drops the sound channel and the timer, and displays the buttons
     * and the labels of a stopped player, which carries no control of the sound at all.
     */
    private function doTheStop():void
    {
      application.trace("<" + this + " SoundPlayer doTheStop> called.", 1);
      dropSoundChannel();
      dropTimeDisplayingTimer();
      resetDisplayedTimes();
      seekIconToBegin();
      seekIcon.visible = false;
      seekIcon.removeEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
      progressTimeTextLabel.visible = false;
      remainingTimeTextLabel.visible = false;
      bufferDraw.visible = false;
      super.setDh(playButtonLink.getDh());
      redrawShape();
      playButtonLink.visible = true;
      pausButtonLink.visible = false;
      soundVolumePotmeter.visible = false;
      soundMuteButtonLink.visible = false;
      stopButtonLink.visible = false;
      resizeSoundNameTextLabel();
      seekIconIsDragged = false;
      playing = false;
      pausePoint = 0;
    }
    /**
     * Starts the playing on a click and dispatches the played by hand event.
     * @param e the click event of the play button, null on a direct call
     */
    private function playButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer playButtonLinkClicked> called.", 1);
      application.trace("<" + this + " SoundPlayer playButtonLinkClicked> e: " + e, 0);
      doPlayingStuff();
      dispatchEventPlayedByHand();
    }
    /**
     * Stores the point the sound has come to and stops the playing there.
     * @param e the click event of the pause button, null on a direct call
     */
    private function pausButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer pausButtonLinkClicked> called.", 1);
      application.trace("<" + this + " SoundPlayer pausButtonLinkClicked> e: " + e, 0);
      if (soundChannel != null)
      {
        pausePoint = soundChannel.position;
        dropSoundChannel();
      }
      else
      {
        pausePoint = 0;
      }
      pausButtonLink.visible = false;
      playButtonLink.visible = true;
      playing = false;
      dropTimeDisplayingTimer();
    }
    /**
     * Stops the playing on a click and dispatches the stopped by hand event.
     * @param e the click event of the stop button, null on a direct call
     */
    private function stopButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer stopButtonLinkClicked> called.", 1);
      application.trace("<" + this + " SoundPlayer stopButtonLinkClicked> e: " + e, 0);
      doTheStop();
      dispatchEventStoppedByHand();
    }
    /**
     * Stops the playing at the end of the sound and dispatches the stopped by end event.
     * @param e the sound complete event of the sound channel
     */
    private function soundComplete(e:Event):void
    {
      application.trace("<" + this + " SoundPlayer soundComplete> called.", 1);
      application.trace("<" + this + " SoundPlayer soundComplete> e: " + e, 0);
      doTheStop();
      dispatchEventStoppedByEnd();
    }
    /**
     * Creates the sound channel of this player and starts it at the point this player
     * has been paused or dragged to.
     */
    private function createSoundChannel():void
    {
      application.trace("<" + this + " SoundPlayer createSoundChannel> called.", 1);
      dropSoundChannel();
      soundChannel = application.getSoundManager().playSound(soundType, Math.max(pausePoint, 1000 * sampleFrom));
      if (soundChannel != null)
      {
        soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
        soundChannel.soundTransform = soundTransform;
      }
    }
    /**
     * Stops and frees up the sound channel of this player.
     */
    private function dropSoundChannel():void
    {
      application.trace("<" + this + " SoundPlayer dropSoundChannel> called.", 1);
      if (soundChannel != null)
      {
        soundChannel.stop();
        soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
        soundChannel = null;
      }
    }
    /**
     * Creates and starts the timer that displays the time of the playing.
     */
    private function createTimeDisplayingTimer():void
    {
      application.trace("<" + this + " SoundPlayer createTimeDisplayingTimer> called.", 1);
      dropTimeDisplayingTimer();
      timeDisplayingTimer = new Timer(application.getComponentsConfig().getTimeDisplayingTimerDelay());
      timeDisplayingTimer.addEventListener(TimerEvent.TIMER, timeDisplayingTimerHandler);
      timeDisplayingTimer.start();
    }
    /**
     * Stops and frees up the timer that displays the time of the playing.
     */
    private function dropTimeDisplayingTimer():void
    {
      application.trace("<" + this + " SoundPlayer dropTimeDisplayingTimer> called.", 1);
      if (timeDisplayingTimer != null)
      {
        timeDisplayingTimer.stop();
        timeDisplayingTimer.removeEventListener(TimerEvent.TIMER, timeDisplayingTimerHandler);
        timeDisplayingTimer = null;
      }
    }
    /**
     * Displays the time played so far and the time still to come, and moves the seek
     * icon to the point the playing has come to. A player without a sound channel has
     * nothing to play any more, so it is stopped.
     * @param e the timer event of the time displaying timer
     */
    private function timeDisplayingTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " SoundPlayer timeDisplayingTimerHandler> called.", 1);
      application.trace("<" + this + " SoundPlayer timeDisplayingTimerHandler> e: " + e, 0);
      if (soundChannel != null)
      {
        const progress:Number = soundChannel.position;
        const progressSecs:int = int(progress / 1000);
        remainingTimeTextLabel.setLabel("-" + application.getUtils().secondsToDisplayedTime(soundMaxSecs - progressSecs));
        progressTimeTextLabel.setLabel(application.getUtils().secondsToDisplayedTime(progressSecs));
        if (!seekIconIsDragged)
        {
          seekIcon.setCxy(Math.max(getSeekIconInix(), Math.min(getSeekIconInix() + getSeekIconDragWidth(), getSeekIconInix() + getSeekIconDragWidth() * progress / soundLengthMillis)), getSeekIconIniy());
        }
      }
      else
      {
        stopButtonLinkClicked();
      }
    }
    /**
     * Displays the time of a player standing at the beginning of its sound.
     */
    private function resetDisplayedTimes():void
    {
      application.trace("<" + this + " SoundPlayer resetDisplayedTimes> called.", 1);
      remainingTimeTextLabel.setLabel("-" + application.getUtils().secondsToDisplayedTime(soundMaxSecs));
      progressTimeTextLabel.setLabel(application.getUtils().secondsToDisplayedTime(0));
    }
    /**
     * Starts the dragging of the seek icon.
     * @param e the mouse down event of the seek icon
     */
    private function seekIconMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " SoundPlayer seekIconMouseDown> called.", 1);
      application.trace("<" + this + " SoundPlayer seekIconMouseDown> e: " + e, 0);
      seekIconIsDragged = true;
      seekIcon.startDrag(false, seekRect);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
    }
    /**
     * Stops the dragging of the seek icon and continues the playing at the point that
     * icon has been dragged to.
     * @param e the mouse up event of the stage
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      application.trace("<" + this + " SoundPlayer stageMouseUp> called.", 1);
      application.trace("<" + this + " SoundPlayer stageMouseUp> e: " + e, 0);
      seekIcon.stopDrag();
      seekIconIsDragged = false;
      pausePoint = soundLengthMillis * (seekIcon.x - getSeekIconInix()) / getSeekIconDragWidth();
      doPlayingStuff();
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
    }
    /**
     * Moves the seek icon back to the beginning of the sound.
     */
    private function seekIconToBegin():void
    {
      application.trace("<" + this + " SoundPlayer seekIconToBegin> called.", 1);
      seekIcon.setCxy(getSeekIconInix(), getSeekIconIniy());
      recreateSeekRect();
    }
    /**
     * Takes the area the seek icon can be dragged inside.
     */
    private function recreateSeekRect():void
    {
      application.trace("<" + this + " SoundPlayer recreateSeekRect> called.", 1);
      seekRect = new Rectangle(getSeekIconInix(), getSeekIconIniy(), getSeekIconDragWidth());
    }
    /**
     * Returns the x coordinate the seek icon stands at at the beginning of the sound.
     */
    private function getSeekIconInix():int
    {
      return 2 * application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
    }
    /**
     * Returns the y coordinate the seek icon stands at.
     */
    private function getSeekIconIniy():int
    {
      return application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) + 2 * application.getDynamicsConfig().getAppPadding();
    }
    /**
     * Returns the distance the seek icon travels from the beginning of the sound to the
     * end of it.
     */
    private function getSeekIconDragWidth():int
    {
      return getDw() - 4 * application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) - seekIcon.getDw();
    }
    /**
     * Positions and resizes everything standing on this player, and takes the height of it
     * from the state it stands in. The width is taken up to the smallest one this player
     * can stand in first: the buttons it is measured from can be resized under it. The stop
     * button stands at the right end of the row, the button of the sound in front of it and
     * the potmeter of that sound in front of that one, so the controls of the sound are the
     * last things the name of the sound can grow up to.
     * @param e the dimensions changed event of one of the elements, null on a direct call
     */
    private function reposResize(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer reposResize> called.", 1);
      application.trace("<" + this + " SoundPlayer reposResize> e: " + e, 0);
      if (getDw() < getMinDw())
      {
        super.setDw(getMinDw());
      }
      playButtonLink.setCxy(0, 0);
      pausButtonLink.setCxy(playButtonLink.getCx(), playButtonLink.getCy());
      stopButtonLink.setCxy(getDw() - stopButtonLink.getDw(), playButtonLink.getCy());
      soundMuteButtonLink.setCxy(stopButtonLink.getCx() - soundMuteButtonLink.getDw()
          , playButtonLink.getCy());
      // a potmeter is not as tall as a button is, so it stands in the middle of the row
      // of the buttons and not at the top of it
      soundVolumePotmeter.setCxy(soundMuteButtonLink.getCx() - soundVolumePotmeter.getDw()
          , playButtonLink.getCy() + (playButtonLink.getDh() - soundVolumePotmeter.getDh()) / 2);
      soundNameTextLabel.setCxy(playButtonLink.getCx(true), playButtonLink.getCy(false, false, true));
      resizeSoundNameTextLabel();
      progressTimeTextLabel.setCxy(playButtonLink.getCx(false, false, true), playButtonLink.getCy(true));
      reposRemainingTimeTextLabel();
      redrawSeekIcon();
      recreateSeekRect();
      seekIconToBegin();
      redrawBufferDraw();
      if (isPlaying())
      {
        super.setDh(2 * playButtonLink.getDh() - application.getDynamicsConfig().getAppPadding());
      }
      else
      {
        super.setDh(playButtonLink.getDh());
      }
      redrawShape();
    }
    /**
     * Keeps the name of the sound inside the room standing between the buttons. A playing
     * player carries the potmeter of the sound, the button of it and the stop button at the
     * right end of that row, so the name grows up to the first of those three, and a
     * stopped one has the whole row for itself.
     */
    private function resizeSoundNameTextLabel():void
    {
      application.trace("<" + this + " SoundPlayer resizeSoundNameTextLabel> called.", 1);
      const nameEndsAt:int = soundVolumePotmeter.visible ? soundVolumePotmeter.getCx()
          : getDw() - application.getDynamicsConfig().getAppPadding();
      soundNameTextLabel.setMaxWidth(nameEndsAt - playButtonLink.getCx(true), false);
    }
    /**
     * Positions the label of the remaining time to the right end of this player.
     * @param e the dimensions changed event of that label, null on a direct call
     */
    private function reposRemainingTimeTextLabel(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer reposRemainingTimeTextLabel> called.", 1);
      application.trace("<" + this + " SoundPlayer reposRemainingTimeTextLabel> e: " + e, 0);
      remainingTimeTextLabel.setCxy(getDw() - application.getDynamicsConfig().getAppPadding() - remainingTimeTextLabel.getDw(), progressTimeTextLabel.getCy());
    }
    /**
     * Draws the seek icon in the current bright font color of the application.
     * @param e the bright font color changed event of the application, null on a direct
     * call
     */
    private function redrawSeekIcon(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer redrawSeekIcon> called.", 1);
      application.trace("<" + this + " SoundPlayer redrawSeekIcon> e: " + e, 0);
      const textType:String = EnumTextTypes.TEXT_TYPE_BRIGHT();
      seekIcon.drawBitmapData(EnumIcons.potmeter(), textType, application.getDynamicsConfig().getTextFieldHeight(textType));
    }
    /**
     * Draws the line the seek icon travels along.
     * @param e the dark font color or line thickness changed event of the application,
     * null on a direct call
     */
    private function redrawBufferDraw(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer redrawBufferDraw> called.", 1);
      application.trace("<" + this + " SoundPlayer redrawBufferDraw> e: " + e, 0);
      bufferDrawColor = application.getDynamicsConfig().getAppFontColorDark();
      bufferDrawLineThickness = application.getDynamicsConfig().getAppLineThickness() * 2;
      bufferDraw.graphics.clear();
      bufferDraw.graphics.lineStyle(bufferDrawLineThickness, bufferDrawColor);
      bufferDraw.graphics.moveTo(seekIcon.getDw() / 2 + getSeekIconInix(), playButtonLink.getDh());
      bufferDraw.graphics.lineTo(seekIcon.getDw() / 2 + getSeekIconInix() + getSeekIconDragWidth(), playButtonLink.getDh());
    }
    /**
     * Draws the frame of this player in the current colors and radius of the application.
     * @param e the radius or background color changed event of the application, null on
     * a direct call
     */
    private function redrawShape(e:Event = null):void
    {
      application.trace("<" + this + " SoundPlayer redrawShape> called.", 1);
      application.trace("<" + this + " SoundPlayer redrawShape> e: " + e, 0);
      shapeBgFrame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorBright()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      shapeBgFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      shapeBgFrame.setDwh(getDw(), getDh());
      shapeBgFrame.drawRect();
    }
    /**
     * Takes the sound channel of this player onto the volume the potmeter of the sound
     * stands on and draws the icon telling what that sound is doing at the moment. A muted
     * player plays no sound at all. The sound volume of the application takes no part in
     * this: that one is the volume of the sound effects, and this player carries a volume
     * of its own.
     */
    private function displaySound():void
    {
      application.trace("<" + this + " SoundPlayer displaySound> called.", 1);
      soundTransform = new SoundTransform();
      soundTransform.volume = soundMuted ? 0 : getSoundVolume() / 100;
      if (soundChannel != null)
      {
        soundChannel.soundTransform = soundTransform;
      }
      soundMuteButtonLink.setIcon(getSoundIcon());
    }
    /**
     * Returns the icon the button of the sound has to carry: the one of the muting on a
     * muted player, and the one of the loudness the potmeter stands on otherwise, from the
     * silent speaker up to the loudest one.
     */
    private function getSoundIcon():String
    {
      application.trace("<" + this + " SoundPlayer getSoundIcon> called.", 1);
      if (isSoundMuted())
      {
        return EnumIcons.soundmuted();
      }
      const volume:int = getSoundVolume();
      if (volume <= SOUND_VOLUME_MIN)
      {
        return EnumIcons.soundzero();
      }
      if (volume < SOUND_VOLUME_LOW_BOUND)
      {
        return EnumIcons.soundlow();
      }
      if (volume < SOUND_VOLUME_MID_BOUND)
      {
        return EnumIcons.soundmid();
      }
      return EnumIcons.soundhigh();
    }
    /**
     * Takes this player onto the volume the potmeter of the sound has been dragged to: the
     * icon of the button of that sound follows the new value as well. The volume has been
     * set on this player itself, so the outside is told about it.
     * @param e the changed event of that potmeter
     */
    private function soundVolumePotmeterChanged(e:Event):void
    {
      application.trace("<" + this + " SoundPlayer soundVolumePotmeterChanged> called.", 1);
      application.trace("<" + this + " SoundPlayer soundVolumePotmeterChanged> e: " + e, 0);
      displaySound();
      dispatchEventChanged();
    }
    /**
     * Mutes this player on a click on the button of the sound, and unmutes a muted one:
     * that very button is the one carrying both of them. The muting has been set on this
     * player itself, so the outside is told about it.
     * @param e the click event of that button
     */
    private function soundMuteButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " SoundPlayer soundMuteButtonLinkClicked> called.", 1);
      application.trace("<" + this + " SoundPlayer soundMuteButtonLinkClicked> e: " + e, 0);
      setSoundMuted(!isSoundMuted());
      dispatchEventChanged();
    }
    /**
     * Dispatches the played by hand event of this player.
     */
    private function dispatchEventPlayedByHand():void
    {
      application.trace("<" + this + " SoundPlayer dispatchEventPlayedByHand> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventPlayedByHand);
    }
    /**
     * Dispatches the played by outside event of this player.
     */
    private function dispatchEventPlayedByOutside():void
    {
      application.trace("<" + this + " SoundPlayer dispatchEventPlayedByOutside> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventPlayedByOutside);
    }
    /**
     * Dispatches the stopped by hand event of this player.
     */
    private function dispatchEventStoppedByHand():void
    {
      application.trace("<" + this + " SoundPlayer dispatchEventStoppedByHand> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventStoppedByHand);
    }
    /**
     * Dispatches the stopped by end event of this player.
     */
    private function dispatchEventStoppedByEnd():void
    {
      application.trace("<" + this + " SoundPlayer dispatchEventStoppedByEnd> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventStoppedByEnd);
    }
    /**
     * Dispatches the changed event of this player: the volume or the muting of it has been
     * set on the controls of the sound standing on this player.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " SoundPlayer dispatchEventChanged> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventChanged);
    }
    /**
     * Stops the playing and frees all listeners, timers, events and references held by
     * this player.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " SoundPlayer destroy> called.", 1);
      application.trace("<" + this + " SoundPlayer destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      stop();
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawSeekIcon);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), redrawBufferDraw);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), redrawBufferDraw);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShape);
      seekIcon.removeEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      application.trace("<" + this + " SoundPlayer destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventPlayedByOutside.stopImmediatePropagation();
      eventPlayedByHand.stopImmediatePropagation();
      eventStoppedByEnd.stopImmediatePropagation();
      eventStoppedByHand.stopImmediatePropagation();
      eventChanged.stopImmediatePropagation();
      bufferDraw.graphics.clear();
      application.trace("<" + this + " SoundPlayer destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      soundType = null;
      soundName = null;
      soundLengthMillis = 0;
      soundLengthBytes = 0;
      soundMaxSecs = 0;
      shapeBgFrame = null;
      playButtonLink = null;
      pausButtonLink = null;
      soundVolumePotmeter = null;
      soundMuteButtonLink = null;
      stopButtonLink = null;
      soundNameTextLabel = null;
      seekIcon = null;
      seekRect = null;
      progressTimeTextLabel = null;
      remainingTimeTextLabel = null;
      bufferDraw = null;
      sampleFrom = 0;
      eventPlayedByOutside = null;
      eventPlayedByHand = null;
      eventStoppedByEnd = null;
      eventStoppedByHand = null;
      eventChanged = null;
      soundChannel = null;
      timeDisplayingTimer = null;
      bufferDrawColor = 0;
      bufferDrawLineThickness = 0;
      pausePoint = 0;
      playing = false;
      seekIconIsDragged = false;
      soundTransform = null;
      soundMuted = false;
    }
  }
}
