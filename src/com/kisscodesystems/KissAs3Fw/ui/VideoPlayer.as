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
 * VideoPlayer.
 * A player of one video of the outside world, built of the chapters it is cut into.
 *
 * MAIN FEATURES:
 * - the video arrives from an url over a plain progressive download, so it needs no
 *   streaming server and no net connection handling around it at all
 * - one video is a list of chapters: every chapter carries a name and an url of its
 *   own, and the player steps from one to the other by the two chapter buttons
 * - a chapter that is over takes the next one right away when the automatic
 *   continuation is switched on, so the whole video is played by one single click
 * - a chapter that is over with nothing to be continued with closes an opened fullscreen:
 *   a video of no chapter to follow and one whose continuation is switched off are both
 *   over for good, so that surface has nothing more to display
 * - the standard player buttons: play, pause, stop, and a seek icon to be dragged:
 *   the two chapter buttons stand at the two ends of the line of the controls and the
 *   four elements of the playing and of the sound stand in the middle of it
 * - the sound of the video is controlled by two of those four elements: a potmeter
 *   carrying the volume between zero and a hundred, and a button muting and unmuting
 *   that sound, so the video is silenced without the volume being dragged away
 * - that potmeter carries no frame of its own: it stands between the icons of the
 *   controls, and those icons are drawn onto the video with no frame either
 * - the icon of that button tells what the sound stands on: a muted video carries the
 *   icon of the muting, and an unmuted one the icon of the loudness it plays with, from
 *   the silent speaker up to the loudest one
 * - the group of those four elements is centered on the picture of the video itself, so
 *   it follows the dimensions that picture is really drawn with, and it never covers the
 *   two chapter buttons standing at the two ends of the line of the controls
 * - this player is never laid out narrower than the room the six elements of that line
 *   need next to each other: five of them carry one icon only and are as wide as they are
 *   tall, the sixth one is the potmeter of the sound, and the margin of the application
 *   stands between them, so a greater font size gives a wider player
 * - a video of one single chapter or of no chapter at all is never stepped, so the two
 *   chapter buttons are not displayed at all in that case
 * - every control of this player stands on the picture of the video itself: the two rows
 *   of the controls stand at the bottom of that picture and the two buttons of the picture
 *   in the two top corners of it, so nothing but the name of the chapter takes a room of
 *   its own away from the video
 * - the name of the chapter that is on stands under that picture, on the background of
 *   this player, broken into as many lines as the width of it asks for: it is the one row
 *   that is never drawn onto the video, so it is readable while the video is watched
 * - the controls standing on the picture build one single layer over the video and that
 *   layer is taken off it after a while: a press on the picture displays it and it
 *   disappears as soon as neither a press nor a move of the mouse has arrived onto that
 *   picture for the delay the configuration of the application tells, so nothing covers a
 *   video that is being watched
 * - a layer that is being used is never taken off the picture: an open list of the
 *   chapters and a seek icon that is being dragged both keep it standing there, and a
 *   press next to the video takes it off right away
 * - the time played so far, the time still to come and the part that has arrived so
 *   far are displayed continuously
 * - the length and the dimensions of a chapter come from the metadata of the file
 *   itself, so nobody has to tell them from the outside
 * - the very first frame of the chapter stands in the picture while nothing is playing,
 *   so that area is never empty: the stream of it is opened muted and it is paused on
 *   that frame, and the first click goes on with the playing from the very same point
 * - the box the picture is drawn inside is the dimensions this object is given: the
 *   picture is shrunk into that box keeping the aspect ratio it has arrived with, and
 *   this object is as low as that picture and the row of the name together, never lower
 *   than the room the controls standing on the picture need
 * - that box can be resized by hand as well: the handle of the bottom right corner of
 *   the picture is dragged, and the whole player follows that drag in real time
 * - a frame of the current appearance of the application can be drawn around it, and
 *   everything standing inside that frame keeps one padding of the application away
 *   from it, exactly the way the picture of an Image does
 * - the chapters of the video can be picked from a list of their names standing on the
 *   picture: the button opening that list stands in the corner opposite the one of the
 *   fullscreen, and the chapter that has been picked is played right away
 * - the video can be opened in fullscreen, on the top of everything: the controls, the
 *   displayed times and the seeking are taken onto that view as well, so a chapter is
 *   played there exactly the way it is played inside the box of this object
 * - a video of no chapter at all has nothing to be opened in fullscreen and no picture
 *   to be resized either, so the button of that fullscreen and the handle of the
 *   resizing are not displayed at all in that case, exactly the way the two chapter
 *   buttons and the one of the list of the chapters are not
 * - the elements of a fullscreen stand exactly the way they stand around the picture
 *   drawn inside the box of this player: the controls on that picture and the name of the
 *   chapter under it, so the very same layer is displayed and taken off the video there
 * - the name of the chapter of a fullscreen follows the picture of the video: it stands
 *   under the left edge of it and it is never broken wider than that picture, so it stays
 *   with the video wherever the stage leaves it standing
 * - it tells the outside by six events whether it has been played or stopped, whether
 *   that has been done by the user or by the application, and whether it stands on
 *   another chapter from now on
 * - the changed one of those six reports every state that is set on this player itself
 *   as well: the volume and the muting of the sound, the opening and the closing of the
 *   fullscreen, the ones of the list of the chapters and the layer of the controls that
 *   is displayed and taken off the video, so the one holding this player
 *   follows the buttons standing on it the very way it follows its own setters
 * - the volume of it belongs to this player alone: the sound volume of the application
 *   is the one of the sound effects, so it does not touch a player at all
 *
 * THE PRIVATE CLASSES OF THIS FILE:
 * - VideoPicture: the picture of the video, the stream carrying it and the preview
 *   picture standing in it while nothing is playing
 * - ChapterTitle: the name of the chapter standing under the picture of the video
 * - ChapterList: the list the chapters can be picked from and the button opening it
 * - SeekBar: the seek icon and the line it travels along, with the part of the chapter
 *   that has arrived so far drawn onto it
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseResizer;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  public class VideoPlayer extends BaseSprite
  {
    // The range and the increment value of the potmeter of the sound, and the two bounds
    // the icon of the button of that sound changes at: a volume under the first one is a
    // quiet video and one from the second one on is the loudest one.
    private const SOUND_VOLUME_MIN:int = 0;
    private const SOUND_VOLUME_MAX:int = 100;
    private const SOUND_VOLUME_INC:int = 1;
    private const SOUND_VOLUME_LOW_BOUND:int = 34;
    private const SOUND_VOLUME_MID_BOUND:int = 67;
    // The number of the elements standing next to each other in the first row of the
    // controls: the two chapter buttons, the play or the pause button, the stop button, the
    // button of the sound and the potmeter of it. Five of the six carry one icon only, so
    // every one of those is exactly as wide as it is tall.
    private const NUM_OF_CONTROLS:int = 6;
    // The greatest number of the passes one layout of the fullscreen is performed in: the
    // room of the picture of the video and the row of the name of the chapter are taken
    // from each other, so one pass can ask for another one, and a stage too small for the
    // two of them would ask for one forever. The picture stands in the dimensions of the
    // last pass from then on, and the next resize of the stage lays it out again.
    private const NUM_OF_FULLSCREEN_PASSES:int = 4;
    // The chapters of the video: the name, the url and the length of every one of them,
    // and the index of the one that stands in this player at the moment. A length of
    // zero means that the chapter has not been played yet: the metadata of the file is
    // the one telling it.
    private var chapterNames:Array = null;
    private var chapterUrls:Array = null;
    private var chapterSecs:Array = null;
    private var selectedChapterIndex:int = -1;
    private var autoContinue:Boolean = false;
    // The picture of the video: the stream carrying it, the video object displaying it,
    // the mask keeping it inside the rounded corners of the appearance that is on and
    // the preview picture standing in it while nothing is playing all belong to it.
    private var videoPicture:VideoPicture = null;
    // The dimensions of the picture: the box it is drawn inside and the ones it is
    // really drawn with. A side of the box of zero means that nobody has bounded this
    // object in that direction, and the dimensions the picture has arrived with are the
    // ones of the picture itself.
    private var boxDw:int = 0;
    private var boxDh:int = 0;
    private var videoDw:int = 0;
    private var videoDh:int = 0;
    // the frame around this player and the state telling whether it is drawn at all
    private var frameShape:BaseShape = null;
    private var frame:Boolean = false;
    // the handle the box of the picture is resized by hand with, a null when that
    // feature is switched off
    private var baseResizer:BaseResizer = null;
    // The fullscreen view of this player: the button opening and closing it, the surface
    // every element of the player is moved onto while it is opened and the black back of
    // that surface. Those two stand on the stage and not on this object, because a
    // fullscreen covers the whole application and not the room of this player.
    private var fullscreenEnabled:Boolean = false;
    private var fullscreenButtonLink:ButtonLink = null;
    private var fullscreenSprite:Sprite = null;
    private var fullscreenBackShape:Shape = null;
    // The state of the layout of that fullscreen: whether one pass of it is running at the
    // moment and whether one more has been asked for. The layout sets the width the name of
    // the chapter is broken along and it reads the height of that name, so it arrives at
    // itself over the dimensions changed event of the name: these two turn that arrival into
    // one more pass of the running layout instead of letting it recurse.
    private var fullscreenLayoutRunning:Boolean = false;
    private var fullscreenLayoutAgain:Boolean = false;
    // the list of the chapters of the video can be picked from, standing in the corner
    // of the picture opposite the one of the fullscreen, a null when that feature is
    // switched off
    private var chapterListEnabled:Boolean = false;
    private var chapterList:ChapterList = null;
    // The layer carrying every element that stands on the picture of the video: the
    // controls of the player, the two buttons of the picture and the list of the chapters.
    // It is one single surface, so the whole of it is displayed and taken off that picture
    // at once, and the timer below is the one taking it off after the inactivity the
    // configuration of the application tells. The elements are placed in the coordinates of
    // the surface this layer stands on, so the layer itself is never moved and never
    // resized: it is the visibility of it alone that is used.
    private var controlsSprite:BaseSprite = null;
    private var controlsTimer:Timer = null;
    // The name of the chapter this player stands on. It stands under the picture of the
    // video, on the background of this player, so it belongs to no layer that is taken off
    // that video: a name standing next to the picture never covers it.
    private var chapterTitle:ChapterTitle = null;
    // the buttons, the controls of the sound, the displayed times and the seek bar of the
    // player
    private var prevChapterButtonLink:ButtonLink = null;
    private var playButtonLink:ButtonLink = null;
    private var pausButtonLink:ButtonLink = null;
    private var stopButtonLink:ButtonLink = null;
    private var soundButtonLink:ButtonLink = null;
    private var soundPotmeter:Potmeter = null;
    private var nextChapterButtonLink:ButtonLink = null;
    private var progressTimeTextLabel:TextLabel = null;
    private var remainingTimeTextLabel:TextLabel = null;
    private var seekBar:SeekBar = null;
    // The line the controls stand along: the left edge and the width of it, taken by the
    // layout that is on. A fullscreen player draws that line along the whole stage and
    // not along the box of the picture, and the seek bar and the times are placed inside
    // it, whichever of the two layouts has been performed.
    private var controlsCx:int = 0;
    private var controlsDw:int = 0;
    private var controlsCy:int = 0;
    // the state of the playing: the seconds played so far and the ones that have arrived
    // over them are displayed by the timer below
    private var progressSecs:int = 0;
    private var bufferSecs:int = 0;
    private var timeDisplayingTimer:Timer = null;
    private var eventPlayedByOutside:Event = null;
    private var eventPlayedByHand:Event = null;
    private var eventStoppedByEnd:Event = null;
    private var eventStoppedByHand:Event = null;
    private var eventChanged:Event = null;
    private var eventChapterChanged:Event = null;
    /**
     * Constructs the VideoPlayer object: creates the picture, the frame, the buttons, the
     * controls of the sound, the name of the chapter, the displayed times and the seek bar
     * of it, and starts to follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function VideoPlayer(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " VideoPlayer> called.", 1);
      application.trace("<" + this + " VideoPlayer> applicationRef: " + applicationRef, 0);
      chapterNames = new Array();
      chapterUrls = new Array();
      chapterSecs = new Array();
      eventPlayedByHand = new Event(EnumEvents.EVENT_PLAYED_BY_HAND());
      eventPlayedByOutside = new Event(EnumEvents.EVENT_PLAYED_BY_OUTSIDE());
      eventStoppedByEnd = new Event(EnumEvents.EVENT_STOPPED_BY_END());
      eventStoppedByHand = new Event(EnumEvents.EVENT_STOPPED_BY_HAND());
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventChapterChanged = new Event(EnumEvents.EVENT_CHAPTER_CHANGED());
      frameShape = new BaseShape(application);
      addChild(frameShape);
      frameShape.setIsBright(true);
      frameShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      frameShape.visible = false;
      videoPicture = new VideoPicture(application);
      addChild(videoPicture);
      videoPicture.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), videoPictureChanged);
      videoPicture.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOPPED_BY_END(), videoPictureEnded);
      videoPicture.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLEARED(), videoPictureCleared);
      // the name of the chapter is created in front of the layer of the controls, so it
      // stands under that layer inside this object as well
      chapterTitle = new ChapterTitle(application);
      addChild(chapterTitle);
      chapterTitle.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), chapterTitleResized);
      // every control standing on the picture of the video is put onto one single layer, so
      // the whole of them is displayed and taken off that picture at once
      controlsSprite = new BaseSprite(application);
      addChild(controlsSprite);
      prevChapterButtonLink = createPlayerButtonLink(EnumIcons.leftarrow(), prevChapterButtonLinkClicked);
      playButtonLink = createPlayerButtonLink(EnumIcons.playing(), playButtonLinkClicked);
      pausButtonLink = createPlayerButtonLink(EnumIcons.paused(), pausButtonLinkClicked);
      stopButtonLink = createPlayerButtonLink(EnumIcons.stopped(), stopButtonLinkClicked);
      soundButtonLink = createPlayerButtonLink(EnumIcons.soundhigh(), soundButtonLinkClicked);
      soundPotmeter = new Potmeter(application);
      controlsSprite.addChild(soundPotmeter);
      // the potmeter of the sound stands between the icons of the controls, on the picture
      // of the video, so the frame of it is taken away: those icons carry no frame either
      soundPotmeter.setFrame(false);
      soundPotmeter.setDecimalPrecision(0);
      soundPotmeter.setMinMaxIncValues(SOUND_VOLUME_MIN, SOUND_VOLUME_MAX, SOUND_VOLUME_INC);
      // the volume the potmeter starts with comes from the configuration and not from the
      // user, so it is a silent set: the video is taken onto it by the displaySound below
      soundPotmeter.setCurValue(application.getComponentsConfig()
          .getVideoPlayerSoundVolume(), false);
      soundPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), soundPotmeterChanged);
      nextChapterButtonLink = createPlayerButtonLink(EnumIcons.rightarrow(), nextChapterButtonLinkClicked);
      // the layout of this player is measured from every control of it, so the two
      // listeners performing that layout are registered once all of them stand: the height
      // of a button is the one every element is placed by, and the width of the potmeter is
      // the one the smallest width of this player is taken from
      playButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), controlResized);
      soundPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), controlResized);
      seekBar = new SeekBar(application);
      controlsSprite.addChild(seekBar);
      seekBar.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), seekBarChanged);
      progressTimeTextLabel = new TextLabel(application);
      controlsSprite.addChild(progressTimeTextLabel);
      remainingTimeTextLabel = new TextLabel(application);
      controlsSprite.addChild(remainingTimeTextLabel);
      remainingTimeTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposRemainingTimeTextLabel);
      resetDisplayedTimes();
      displaySound();
      displayPlayerState();
      reposResize();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      application.trace("<" + this + " VideoPlayer> constructed.", 1);
    }
    /**
     * Returns the number of the chapters of the video of this player.
     */
    public function getNumOfChapters():int
    {
      return chapterNames.length;
    }
    /**
     * Takes the chapters of the video this player has to play: one name and one url per
     * chapter. A player playing something at the moment is stopped first, and the first
     * chapter of the new video is the one it stands on afterwards. The two arrays are
     * copied, so the caller can keep using its own ones.
     * @param names the names of the chapters, the ones to be displayed
     * @param urls the urls of the chapters, in the order of the names
     */
    public function setChapters(names:Array, urls:Array):void
    {
      application.trace("<" + this + " VideoPlayer setChapters> called.", 1);
      application.trace("<" + this + " VideoPlayer setChapters> names: " + names, 0);
      application.trace("<" + this + " VideoPlayer setChapters> urls: " + urls, 0);
      const prevIndex:int = selectedChapterIndex;
      dropChapters();
      if (names == null || urls == null || names.length != urls.length)
      {
        application.trace("<" + this + " VideoPlayer setChapters> the names and the urls do not belong together!", 6);
      }
      else
      {
        chapterNames = chapterNames.concat(names);
        chapterUrls = chapterUrls.concat(urls);
        for (var i:int = 0; i < chapterNames.length; i++)
        {
          chapterSecs.push(0);
        }
        selectedChapterIndex = chapterNames.length > 0 ? 0 : -1;
      }
      displaySelectedChapter();
      dispatchEventChanged();
      if (selectedChapterIndex != prevIndex)
      {
        dispatchEventChapterChanged();
      }
    }
    /**
     * Drops every chapter of this player: it holds no video at all afterwards. A player
     * playing something at the moment is stopped first.
     */
    public function clearChapters():void
    {
      application.trace("<" + this + " VideoPlayer clearChapters> called.", 1);
      const prevIndex:int = selectedChapterIndex;
      dropChapters();
      displaySelectedChapter();
      dispatchEventChanged();
      if (selectedChapterIndex != prevIndex)
      {
        dispatchEventChapterChanged();
      }
    }
    /**
     * Returns the name of the chapter of the given index, an empty string when there is
     * no chapter of that index at all.
     * @param index the index of the chapter inside the chapters of this player
     */
    public function getChapterName(index:int):String
    {
      application.trace("<" + this + " VideoPlayer getChapterName> called.", 1);
      application.trace("<" + this + " VideoPlayer getChapterName> index: " + index, 0);
      return hasChapterOfIndex(index) ? String(chapterNames[index]) : "";
    }
    /**
     * Returns the url of the chapter of the given index, an empty string when there is
     * no chapter of that index at all.
     * @param index the index of the chapter inside the chapters of this player
     */
    public function getChapterUrl(index:int):String
    {
      application.trace("<" + this + " VideoPlayer getChapterUrl> called.", 1);
      application.trace("<" + this + " VideoPlayer getChapterUrl> index: " + index, 0);
      return hasChapterOfIndex(index) ? String(chapterUrls[index]) : "";
    }
    /**
     * Returns the length of the chapter of the given index in seconds. A chapter that
     * has not been played yet answers a zero: the metadata of the file is the one telling
     * that length, and it arrives with the playing of it.
     * @param index the index of the chapter inside the chapters of this player
     */
    public function getChapterSecs(index:int):int
    {
      application.trace("<" + this + " VideoPlayer getChapterSecs> called.", 1);
      application.trace("<" + this + " VideoPlayer getChapterSecs> index: " + index, 0);
      return hasChapterOfIndex(index) ? int(chapterSecs[index]) : 0;
    }
    /**
     * Returns the length of the whole video in seconds: the lengths of every chapter
     * added up, the ones that are known at the moment.
     */
    public function getTotalSecs():int
    {
      application.trace("<" + this + " VideoPlayer getTotalSecs> called.", 1);
      var secs:int = 0;
      for (var i:int = 0; i < chapterSecs.length; i++)
      {
        secs += int(chapterSecs[i]);
      }
      return secs;
    }
    /**
     * Returns the index of the chapter this player stands on, a minus one when it holds
     * no chapter at all.
     */
    public function getSelectedChapterIndex():int
    {
      return selectedChapterIndex;
    }
    /**
     * Takes the chapter of the given index: this player steps onto it and it plays that
     * one from that moment on. A player that is playing something keeps playing, so the
     * new chapter is started right away, and an index outside the chapters is refused.
     * @param index the index of the chapter inside the chapters of this player
     */
    public function setSelectedChapterIndex(index:int):void
    {
      application.trace("<" + this + " VideoPlayer setSelectedChapterIndex> called.", 1);
      application.trace("<" + this + " VideoPlayer setSelectedChapterIndex> index: " + index, 0);
      if (!hasChapterOfIndex(index))
      {
        application.trace("<" + this + " VideoPlayer setSelectedChapterIndex> there is no chapter of this index!", 6);
        return;
      }
      if (selectedChapterIndex == index)
      {
        application.trace("<" + this + " VideoPlayer setSelectedChapterIndex> nothing to do.", 1);
        return;
      }
      const wasPlaying:Boolean = isPlaying();
      doTheStop();
      selectedChapterIndex = index;
      displaySelectedChapter();
      dispatchEventChanged();
      dispatchEventChapterChanged();
      if (wasPlaying)
      {
        doPlayingStuff();
      }
    }
    /**
     * Steps onto the chapter standing before the one this player is on. A player that is
     * on the first chapter has nothing to step onto.
     */
    public function prevChapter():void
    {
      application.trace("<" + this + " VideoPlayer prevChapter> called.", 1);
      setSelectedChapterIndex(selectedChapterIndex - 1);
    }
    /**
     * Steps onto the chapter standing after the one this player is on. A player that is
     * on the last chapter has nothing to step onto.
     */
    public function nextChapter():void
    {
      application.trace("<" + this + " VideoPlayer nextChapter> called.", 1);
      setSelectedChapterIndex(selectedChapterIndex + 1);
    }
    /**
     * Tells whether this player steps onto the next chapter by itself as soon as the one
     * it plays is over.
     */
    public function getAutoContinue():Boolean
    {
      return autoContinue;
    }
    /**
     * Tells this player whether it has to step onto the next chapter by itself as soon as
     * the one it plays is over: a whole video is played by one single click that way. A
     * player that has come to the end of the last chapter stops either way.
     * @param b true when the next chapter has to be taken automatically
     */
    public function setAutoContinue(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setAutoContinue> b: " + b, 0);
      autoContinue = b;
    }
    /**
     * Tells whether the first frame of the chapter stands in the picture of this player
     * while nothing is playing.
     */
    public function getPreview():Boolean
    {
      return videoPicture.getPreview();
    }
    /**
     * Tells this player whether it has to display the first frame of the chapter it stands
     * on while nothing is playing: the stream of that chapter is opened muted and it is
     * paused on that very frame, so the area of the picture is never empty, and the
     * playing goes on from that point on the first click. A player that is playing
     * something at the moment keeps playing: the preview picture of it arrives as soon as
     * that playing is over.
     * @param b true when there has to be a preview picture
     */
    public function setPreview(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setPreview> called.", 1);
      application.trace("<" + this + " VideoPlayer setPreview> b: " + b, 0);
      videoPicture.setPreview(b);
    }
    /**
     * Tells whether there is a frame around this player.
     */
    public function getFrame():Boolean
    {
      return frame;
    }
    /**
     * Draws a frame of the current appearance of the application around this player, or
     * takes that frame away. Everything standing inside that frame keeps one padding of
     * the application away from it, so a framed player takes that room from the picture
     * of the video and from the line of the controls as well.
     * @param b true when there has to be a frame
     */
    public function setFrame(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setFrame> called.", 1);
      application.trace("<" + this + " VideoPlayer setFrame> b: " + b, 0);
      if (frame == b)
      {
        application.trace("<" + this + " VideoPlayer setFrame> nothing to do.", 1);
        return;
      }
      frame = b;
      reposResize();
    }
    /**
     * Tells whether the box of the picture of this player can be resized by hand.
     */
    public function getResizable():Boolean
    {
      return baseResizer != null;
    }
    /**
     * Tells this player whether the box of the picture of it can be resized by hand. The
     * handle of that resizing stands in the bottom right corner of the picture, and the
     * box follows every pixel of a drag of it, so the whole player is laid out again in
     * real time, exactly the way a box coming from the outside does it. A video of no
     * chapter at all has no picture to be resized, so that handle is not displayed at all
     * in that case, however the feature is switched on: it appears as soon as this player
     * is given a chapter and it goes away with the last one of them.
     * @param b true when there has to be a handle to resize the box with
     */
    public function setResizable(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setResizable> called.", 1);
      application.trace("<" + this + " VideoPlayer setResizable> b: " + b, 0);
      if (b)
      {
        createResizer();
      }
      else
      {
        removeResizer();
      }
    }
    /**
     * Returns the volume the video of this player is played with, a value between zero and
     * a hundred: the potmeter of the sound is the one carrying it. It belongs to this
     * player alone, so the sound volume of the application does not touch it: that one is
     * the volume of the sound effects.
     */
    public function getSoundVolume():int
    {
      return int(soundPotmeter.getCurValue());
    }
    /**
     * Sets the volume the video of this player is played with and takes the potmeter of the
     * sound onto that value. Only a value inside the range is taken, so the getter above is
     * the one telling what this player really stands with, and the icon of the button of
     * the sound follows the new value as well.
     * @param v the new volume, a value between zero and a hundred
     */
    public function setSoundVolume(v:int):void
    {
      application.trace("<" + this + " VideoPlayer setSoundVolume> called.", 1);
      application.trace("<" + this + " VideoPlayer setSoundVolume> v: " + v, 0);
      soundPotmeter.setCurValue(v, false);
      displaySound();
    }
    /**
     * Tells whether the video of this player is muted at the moment.
     */
    public function isSoundMuted():Boolean
    {
      return videoPicture.isSoundMuted();
    }
    /**
     * Mutes or unmutes the video of this player. A muted one plays no sound at all and it
     * keeps the volume its potmeter stands on, so an unmuted one goes on with that very
     * volume, and the icon of the button of the sound tells which of the two states is on.
     * @param b true when the video has to be muted
     */
    public function setSoundMuted(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setSoundMuted> called.", 1);
      application.trace("<" + this + " VideoPlayer setSoundMuted> b: " + b, 0);
      videoPicture.setSoundMuted(b);
      displaySound();
    }
    /**
     * Tells whether this player is playing a chapter at the moment. A paused player is
     * playing as well: it stands somewhere inside its chapter.
     */
    public function isPlaying():Boolean
    {
      return videoPicture.isPlaying();
    }
    /**
     * Tells whether the playing of this player is paused at the moment.
     */
    public function isPaused():Boolean
    {
      return videoPicture.isPaused();
    }
    /**
     * Returns the seconds the chapter of this player has been played so far.
     */
    public function getProgressSecs():int
    {
      return progressSecs;
    }
    /**
     * Returns the width the picture of the video is drawn with.
     */
    public function getVideoDw():int
    {
      return videoDw;
    }
    /**
     * Returns the height the picture of the video is drawn with.
     */
    public function getVideoDh():int
    {
      return videoDh;
    }
    /**
     * Returns the width of the box the picture is drawn inside, a zero when nobody has
     * bounded this object in that direction.
     */
    public function getBoxDw():int
    {
      return boxDw;
    }
    /**
     * Returns the height of the box the picture is drawn inside, a zero when nobody has
     * bounded this object in that direction.
     */
    public function getBoxDh():int
    {
      return boxDh;
    }
    /**
     * Returns the smallest width this player is ever laid out in: the room the six elements
     * of the first row of the controls need next to each other, one margin of the
     * application away from each other, and the space the frame around them takes. The
     * height of a button of the player is the one five of those six are measured in and the
     * sixth is the potmeter of the sound, so a greater font size gives a wider player,
     * exactly the way a greater margin of the application does. A box narrower than this
     * leaves the picture of the video standing in the middle of this width.
     */
    public function getMinDw():int
    {
      return getMinContentDw() + 2 * getFrameDelta();
    }
    /**
     * Returns the lowest height this player is ever laid out in: the room the two rows of
     * the controls need on the picture of the video, one padding of the application over
     * and under them, the row of the name of the chapter under that picture and the space
     * the frame around them takes. A name broken into more lines gives a greater height,
     * exactly the way a greater font size does, and a box lower than this leaves the
     * picture of the video standing at the top of this height.
     */
    public function getMinDh():int
    {
      return getMinContentDh() + chapterTitle.getDh() + 2 * getFrameDelta();
    }
    /**
     * Tells whether the video of this player can be opened in fullscreen.
     */
    public function getFullscreenEnabled():Boolean
    {
      return fullscreenEnabled;
    }
    /**
     * Tells this player whether the video of it can be opened in fullscreen. The button
     * of that feature stands in the top right corner of the picture, and it is the very
     * same button that closes the fullscreen later, so it appears as soon as the feature
     * is switched on and an opened fullscreen is closed by the switching off of it. A
     * video of no chapter at all has nothing to be opened, so that button is not
     * displayed at all in that case, however the feature is switched on: it appears as
     * soon as this player is given a chapter and it goes away with the last one of them.
     * @param b true when the video can be opened in fullscreen
     */
    public function setFullscreenEnabled(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setFullscreenEnabled> called.", 1);
      application.trace("<" + this + " VideoPlayer setFullscreenEnabled> b: " + b, 0);
      if (fullscreenEnabled == b)
      {
        application.trace("<" + this + " VideoPlayer setFullscreenEnabled> nothing to do.", 1);
        return;
      }
      fullscreenEnabled = b;
      if (fullscreenEnabled)
      {
        createFullscreenButtonLink();
      }
      else
      {
        closeFullscreen();
        dropFullscreenButtonLink();
      }
      reposFullscreenButtonLink();
    }
    /**
     * Tells whether the video of this player is opened in fullscreen at the moment.
     */
    public function isFullscreenOpened():Boolean
    {
      return fullscreenSprite != null;
    }
    /**
     * Opens the video of this player in fullscreen and tells the outside about it: every
     * element of it is moved onto a black surface covering the whole stage, so the picture
     * is drawn in the greatest dimensions it fits that stage in and the controls, the
     * displayed times and the seeking work there exactly the way they work inside the box
     * of this object. The name of the chapter stands at the bottom of the picture of it
     * for a while as well. A player that is not on the stage, that is switched off, that
     * holds no chapter at all or whose fullscreen feature is switched off has nothing to
     * open: the button closing that fullscreen is a disabled button on a disabled player
     * as well, and it is the only element reachable over the surface of it.
     */
    public function openFullscreen():void
    {
      application.trace("<" + this + " VideoPlayer openFullscreen> called.", 1);
      if (!fullscreenEnabled || !hasAnyChapter() || !getEnabled() || stage == null)
      {
        application.trace("<" + this + " VideoPlayer openFullscreen> there is nothing to be opened in fullscreen.", 1);
        return;
      }
      if (isFullscreenOpened())
      {
        application.trace("<" + this + " VideoPlayer openFullscreen> the fullscreen is opened already.", 1);
        return;
      }
      // the list of the chapters is laid out from the picture of the video, and that
      // picture is drawn in other dimensions from now on, so the list is closed here
      closeChapterList();
      fullscreenSprite = new Sprite();
      stage.addChild(fullscreenSprite);
      fullscreenBackShape = new Shape();
      fullscreenSprite.addChild(fullscreenBackShape);
      // the elements of the player are the very same objects here: they are moved onto
      // the surface of the fullscreen and moved back onto this object on the closing of
      // it, so the stream, the seeking and the times of the playing are never touched
      moveElementsTo(fullscreenSprite);
      stage.addEventListener(Event.RESIZE, stageResized);
      displayFullscreenButtonLinkIcon();
      reposResize();
      dispatchEventChanged();
    }
    /**
     * Closes the fullscreen of this player and tells the outside about it: every element
     * of it is moved back onto this object and the surface of that fullscreen is freed up,
     * so the video goes on inside the box of this object from that moment on. A fullscreen
     * that is not opened at all has nothing to close.
     */
    public function closeFullscreen():void
    {
      application.trace("<" + this + " VideoPlayer closeFullscreen> called.", 1);
      if (!isFullscreenOpened())
      {
        application.trace("<" + this + " VideoPlayer closeFullscreen> there is no fullscreen to be closed.", 1);
        return;
      }
      // the picture of the video is drawn inside the box of this player again, so the list
      // of the chapters that has been laid out from the one of the fullscreen is closed
      closeChapterList();
      if (fullscreenSprite.stage != null)
      {
        fullscreenSprite.stage.removeEventListener(Event.RESIZE, stageResized);
      }
      // the surface is dropped in front of the moving below, so that the layout of a
      // fullscreen is never performed on the elements that stand on this object again
      const spriteToDrop:Sprite = fullscreenSprite;
      fullscreenSprite = null;
      fullscreenBackShape.graphics.clear();
      fullscreenBackShape = null;
      moveElementsTo(this);
      if (baseResizer != null)
      {
        // the handle of the resizing is the topmost element of this player: the elements
        // moved back above stand under it again this way
        addChild(baseResizer);
      }
      if (spriteToDrop.parent != null)
      {
        spriteToDrop.parent.removeChild(spriteToDrop);
      }
      displayFullscreenButtonLinkIcon();
      reposResize();
      dispatchEventChanged();
    }
    /**
     * Tells whether the chapters of the video can be picked from a list of their names.
     */
    public function getChapterListEnabled():Boolean
    {
      return chapterListEnabled;
    }
    /**
     * Tells this player whether the chapters of the video can be picked from a list of
     * their names. The button opening that list stands in the corner of the picture
     * opposite the one of the fullscreen, so it appears as soon as the feature is switched
     * on, and an open list is closed by the switching off of it. A video of one single
     * chapter or of no chapter at all has nothing to be picked, so that button is not
     * displayed at all in that case, exactly the way the two chapter buttons are not.
     * @param b true when the chapters can be picked from a list
     */
    public function setChapterListEnabled(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setChapterListEnabled> called.", 1);
      application.trace("<" + this + " VideoPlayer setChapterListEnabled> b: " + b, 0);
      if (chapterListEnabled == b)
      {
        application.trace("<" + this + " VideoPlayer setChapterListEnabled> nothing to do.", 1);
        return;
      }
      chapterListEnabled = b;
      if (chapterListEnabled)
      {
        createChapterList();
      }
      else
      {
        closeChapterList();
        dropChapterList();
      }
      reposChapterList();
    }
    /**
     * Tells whether the list of the chapters is open at the moment.
     */
    public function isChapterListOpened():Boolean
    {
      return chapterList != null && chapterList.isOpened();
    }
    /**
     * Opens the list of the chapters of the video: it is laid out from the dimensions the
     * picture is drawn with at the moment and it stands scrolled onto the chapter this
     * player is on, so the one that is playing is the one in the picture of that list. A
     * player that is switched off, one whose feature is switched off and one that has no
     * chapter to be picked at all have nothing to open, and so has a picture that is too
     * small to display one single name.
     */
    public function openChapterList():void
    {
      application.trace("<" + this + " VideoPlayer openChapterList> called.", 1);
      if (!chapterListEnabled || !getEnabled() || chapterList == null)
      {
        application.trace("<" + this + " VideoPlayer openChapterList> there is no list of the chapters to be opened.", 1);
        return;
      }
      // the list is laid out from the picture of the video before it is opened, so it is
      // the room of that picture that tells whether it can be displayed at all
      reposChapterList();
      chapterList.open();
    }
    /**
     * Closes the list of the chapters of the video and leaves the playing of this player
     * exactly the way it is. A list that is not open at all has nothing to close.
     */
    public function closeChapterList():void
    {
      application.trace("<" + this + " VideoPlayer closeChapterList> called.", 1);
      if (chapterList != null)
      {
        chapterList.close();
      }
    }
    /**
     * Tells whether the controls standing on the picture of the video are displayed at the
     * moment: the two rows of the controls and the two buttons of that picture build one
     * single layer, so one single state tells it. The name of the chapter stands under that
     * picture and never disappears with them.
     */
    public function getControlsVisible():Boolean
    {
      return controlsSprite.visible;
    }
    /**
     * Displays the layer of those controls over the picture of the video, or takes it off
     * that picture, and tells the outside about it. That layer is displayed by a press on
     * the picture as well, and it is taken off it by the inactivity of the mouse over the
     * video and by a press next to it, so the one holding this player follows every one of
     * those by the changed event of it. A layer that is taken off the picture closes the
     * list of the chapters: that list stands on the very same layer, so an open one would
     * come back with it.
     * @param b true when that layer has to be displayed
     */
    public function setControlsVisible(b:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setControlsVisible> called.", 1);
      application.trace("<" + this + " VideoPlayer setControlsVisible> b: " + b, 0);
      if (getControlsVisible() == b)
      {
        application.trace("<" + this + " VideoPlayer setControlsVisible> nothing to do.", 1);
        return;
      }
      controlsSprite.visible = b;
      if (b)
      {
        restartControlsTimer();
      }
      else
      {
        closeChapterList();
      }
      dispatchEventChanged();
    }
    /**
     * Starts the playing from the outside and dispatches the played by outside event. A
     * paused player goes on from the very point it stands at.
     */
    public function play():void
    {
      application.trace("<" + this + " VideoPlayer play> called.", 1);
      if (isPaused())
      {
        resumePlaying();
      }
      else
      {
        doPlayingStuff();
      }
      dispatchEventPlayedByOutside();
    }
    /**
     * Pauses the playing, so it can be continued from the very same point later.
     */
    public function pause():void
    {
      application.trace("<" + this + " VideoPlayer pause> called.", 1);
      pausePlaying();
    }
    /**
     * Stops the playing and takes this player back to the beginning of its chapter.
     */
    public function stop():void
    {
      application.trace("<" + this + " VideoPlayer stop> called.", 1);
      stopButtonLinkClicked();
    }
    /**
     * Enables or disables this player. A disabled one stops the playing first, it closes
     * the fullscreen of the video and the list of the chapters, it holds no handle of the
     * resizing that could be dragged, and an enabled one can only be played when there is
     * a chapter in it at all.
     * The fullscreen is closed because none of the buttons standing on it could be
     * pressed any more: the one closing it is a disabled button as well.
     * @param e true when this player has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " VideoPlayer setEnabled> called.", 1);
      application.trace("<" + this + " VideoPlayer setEnabled> e: " + e, 0);
      if (getEnabled() && !e)
      {
        doTheStop();
      }
      super.setEnabled(e);
      if (baseResizer != null)
      {
        baseResizer.setEnabled(getEnabled());
      }
      if (fullscreenButtonLink != null)
      {
        fullscreenButtonLink.setEnabled(getEnabled());
      }
      if (chapterList != null)
      {
        chapterList.setEnabled(getEnabled());
      }
      if (!getEnabled())
      {
        closeFullscreen();
        closeChapterList();
      }
      displayPlayerState();
    }
    /**
     * Sets the width of the box the picture is drawn inside. The picture keeps the aspect
     * ratio it has arrived with, so a box wider than it needs leaves it standing in the
     * middle of that box.
     * @param newdw the new width of the box
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " VideoPlayer setDw> called.", 1);
      application.trace("<" + this + " VideoPlayer setDw> newdw: " + newdw, 0);
      if (boxDw != newdw)
      {
        application.trace("<" + this + " VideoPlayer setDw> conditions OK.", 1);
        boxDw = newdw;
        reposResize();
      }
    }
    /**
     * Sets the height of the box the picture is drawn inside, see the setDw above. The
     * height of this object is that of the picture and that of the buttons under it, so a
     * box taller than the picture needs leaves this object as low as it has been.
     * @param newdh the new height of the box
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " VideoPlayer setDh> called.", 1);
      application.trace("<" + this + " VideoPlayer setDh> newdh: " + newdh, 0);
      if (boxDh != newdh)
      {
        application.trace("<" + this + " VideoPlayer setDh> conditions OK.", 1);
        boxDh = newdh;
        reposResize();
      }
    }
    /**
     * Sets the dimensions of the box the picture is drawn inside, see the setDw and the
     * setDh above.
     * @param newdw the new width of the box
     * @param newdh the new height of the box
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " VideoPlayer setDwh> called.", 1);
      application.trace("<" + this + " VideoPlayer setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " VideoPlayer setDwh> newdh: " + newdh, 0);
      if (boxDw != newdw || boxDh != newdh)
      {
        application.trace("<" + this + " VideoPlayer setDwh> conditions OK.", 1);
        boxDw = newdw;
        boxDh = newdh;
        reposResize();
      }
    }
    /**
     * A player plays a video of its own, so it plays no click sound at all: this does
     * nothing.
     * @param s the sound type of the click
     */
    override public function setSoundTypeClick(s:String):void
    {
      application.trace("<" + this + " VideoPlayer setSoundTypeClick> called.", 1);
      application.trace("<" + this + " VideoPlayer setSoundTypeClick> s: " + s, 0);
      application.trace("<" + this + " VideoPlayer setSoundTypeClick> do nothing.", 1);
    }
    /**
     * Renders this player in its initialized state as soon as it gets onto the stage. The
     * preview picture of the chapter is asked for by the picture of the video itself: it
     * gets onto the stage together with this player.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer addedToStage> called.", 1);
      application.trace("<" + this + " VideoPlayer addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove, false, 0, true);
      }
      // the controls stand on the picture of the video as soon as this player is rendered
      // and they leave that video alone after a while: a press on the picture is the one
      // taking them back onto it later
      setControlsVisible(true);
      createControlsTimer();
      reposResize();
    }
    /**
     * Closes the list of the chapters and the fullscreen of the video as soon as this
     * player leaves the stage, so that every listener registered on that stage is
     * unregistered and the surface of that fullscreen is taken off it while it is still
     * reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer removedFromStage> called.", 1);
      application.trace("<" + this + " VideoPlayer removedFromStage> e: " + e, 0);
      closeChapterList();
      closeFullscreen();
      dropControlsTimer();
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
      super.removedFromStage(e);
    }
    /**
     * Builds one button of the player: it stands on this object, it carries the given
     * icon and it calls the given handler on a click.
     * @param icon the icon of the button, an EnumIcons value
     * @param clickHandler the handler of the click event of that button
     */
    private function createPlayerButtonLink(icon:String, clickHandler:Function):ButtonLink
    {
      application.trace("<" + this + " VideoPlayer createPlayerButtonLink> called.", 1);
      application.trace("<" + this + " VideoPlayer createPlayerButtonLink> icon: " + icon, 0);
      application.trace("<" + this + " VideoPlayer createPlayerButtonLink> clickHandler: " + clickHandler, 0);
      const buttonLink:ButtonLink = new ButtonLink(application);
      controlsSprite.addChild(buttonLink);
      buttonLink.setIcon(icon);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), clickHandler);
      return buttonLink;
    }
    /**
     * Stops the playing and drops every chapter of this player. The outside is not told
     * about it here: the two public callers of this are the ones reporting the new state
     * of this player, so one single change is one single event.
     */
    private function dropChapters():void
    {
      application.trace("<" + this + " VideoPlayer dropChapters> called.", 1);
      doTheStop();
      chapterNames.splice(0);
      chapterUrls.splice(0);
      chapterSecs.splice(0);
      selectedChapterIndex = -1;
    }
    /**
     * Tells whether there is a chapter of the given index in this player at all.
     * @param index the index of the chapter inside the chapters of this player
     */
    private function hasChapterOfIndex(index:int):Boolean
    {
      return index > -1 && index < chapterNames.length;
    }
    /**
     * Tells whether there is a chapter to be stepped onto or to be picked from the list at
     * all: a video of one single chapter or of no chapter at all has none.
     */
    private function hasMoreChapters():Boolean
    {
      return getNumOfChapters() > 1;
    }
    /**
     * Tells whether this player holds a chapter at all: the features standing on the
     * picture of the video, the fullscreen and the handle of the resizing, have nothing
     * to work on without one.
     */
    private function hasAnyChapter():Boolean
    {
      return getNumOfChapters() > 0;
    }
    /**
     * Displays the chapter this player stands on: the name of it and the times of it. The
     * picture takes the url of that chapter, so it drops the dimensions and the preview
     * picture of the previous one and it asks for the new ones right away.
     */
    private function displaySelectedChapter():void
    {
      application.trace("<" + this + " VideoPlayer displaySelectedChapter> called.", 1);
      videoPicture.setUrl(getChapterUrl(selectedChapterIndex));
      chapterTitle.setName(selectedChapterIndex > -1
          ? getChapterName(selectedChapterIndex) : " ");
      seekBar.setChapterSecs(getChapterSecs(selectedChapterIndex));
      displayFullscreenButtonLink();
      displayResizer();
      displayChapterList();
      resetDisplayedTimes();
      displayPlayerState();
      reposResize();
    }
    /**
     * Positions everything again after the name of the chapter has taken new dimensions: a
     * name broken into more lines takes a higher row under the picture of the video, and
     * the height of this player holds the whole row of that name.
     * @param e the dimensions changed event of that name
     */
    private function chapterTitleResized(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer chapterTitleResized> called.", 1);
      application.trace("<" + this + " VideoPlayer chapterTitleResized> e: " + e, 0);
      reposResize();
    }
    /**
     * Enables and displays every button of the player the way the state of this player
     * asks for it: the play and the pause button take each other's place, the stop button
     * works while there is something to be stopped, and the two chapter buttons work
     * while there is a chapter to step onto in their direction. A video that is one
     * single chapter or no chapter at all is never stepped, so the two chapter buttons
     * are not displayed at all in that case. The two controls of the sound work whenever
     * this player is enabled at all: the volume of a video that is not playing yet is set
     * in advance this way.
     */
    private function displayPlayerState():void
    {
      application.trace("<" + this + " VideoPlayer displayPlayerState> called.", 1);
      const enabled:Boolean = getEnabled();
      const playing:Boolean = isPlaying();
      const paused:Boolean = isPaused();
      // the two of them stand on the very same place and they take each other's place,
      // so only the visibility of them is touched here: a sprite that is switched off by
      // the setSpriteVisible drops its own dimensions as well, and the buttons standing
      // next to them are placed by exactly those dimensions
      playButtonLink.visible = !playing || paused;
      pausButtonLink.visible = playing && !paused;
      playButtonLink.setEnabled(enabled && getChapterUrl(selectedChapterIndex) != "");
      pausButtonLink.setEnabled(enabled);
      stopButtonLink.setEnabled(enabled && playing);
      soundButtonLink.setEnabled(enabled);
      soundPotmeter.setEnabled(enabled);
      // there is nothing to step onto in a video of one single chapter or of no chapter
      // at all, so the two chapter buttons are taken away completely there: the elements
      // of the line of the controls are placed by the buttons of the playing, so this
      // does not touch the room the controls take
      const stepable:Boolean = hasMoreChapters();
      prevChapterButtonLink.setSpriteVisible(stepable);
      nextChapterButtonLink.setSpriteVisible(stepable);
      prevChapterButtonLink.setEnabled(enabled && selectedChapterIndex > 0);
      nextChapterButtonLink.setEnabled(enabled
          && selectedChapterIndex > -1 && selectedChapterIndex < getNumOfChapters() - 1);
    }
    /**
     * Starts the playing: takes the picture of the video to the beginning of the chapter
     * this player stands on and starts the timer that displays the time. A player holding
     * no chapter at all has nothing to play.
     */
    private function doPlayingStuff():void
    {
      application.trace("<" + this + " VideoPlayer doPlayingStuff> called.", 1);
      if (getChapterUrl(selectedChapterIndex) == "")
      {
        application.trace("<" + this + " VideoPlayer doPlayingStuff> there is no chapter to be played!", 6);
        return;
      }
      if (!videoPicture.startPlaying())
      {
        application.trace("<" + this + " VideoPlayer doPlayingStuff> there is nothing to be played.", 1);
        return;
      }
      progressSecs = 0;
      bufferSecs = 0;
      seekBar.setSeekable(true);
      displayPlayerState();
      createTimeDisplayingTimer();
    }
    /**
     * Stops the playing: drops the timer and takes this player back to the beginning of
     * its chapter, holding the first frame of it in the picture.
     */
    private function doTheStop():void
    {
      application.trace("<" + this + " VideoPlayer doTheStop> called.", 1);
      dropTimeDisplayingTimer();
      videoPicture.stopPlaying();
      progressSecs = 0;
      bufferSecs = 0;
      seekBar.setSeekable(false);
      seekBar.displayProgress(0, 0);
      resetDisplayedTimes();
      displayPlayerState();
    }
    /**
     * Continues the playing at the point this player has been paused at. A player that is
     * not paused at all has nothing to continue.
     */
    private function resumePlaying():void
    {
      application.trace("<" + this + " VideoPlayer resumePlaying> called.", 1);
      if (!videoPicture.resumePlaying())
      {
        application.trace("<" + this + " VideoPlayer resumePlaying> there is nothing to be continued.", 1);
        return;
      }
      displayPlayerState();
      createTimeDisplayingTimer();
    }
    /**
     * Pauses the playing at the point it has come to. A player that is not playing
     * anything or that is paused already has nothing to pause.
     */
    private function pausePlaying():void
    {
      application.trace("<" + this + " VideoPlayer pausePlaying> called.", 1);
      if (!videoPicture.pausePlaying())
      {
        application.trace("<" + this + " VideoPlayer pausePlaying> there is nothing to be paused.", 1);
        return;
      }
      dropTimeDisplayingTimer();
      displayPlayerState();
    }
    /**
     * Starts or continues the playing on a click and dispatches the played by hand event.
     * @param e the click event of the play button, null on a direct call
     */
    private function playButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " VideoPlayer playButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer playButtonLinkClicked> e: " + e, 0);
      if (isPaused())
      {
        resumePlaying();
      }
      else
      {
        doPlayingStuff();
      }
      dispatchEventPlayedByHand();
    }
    /**
     * Pauses the playing on a click.
     * @param e the click event of the pause button, null on a direct call
     */
    private function pausButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " VideoPlayer pausButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer pausButtonLinkClicked> e: " + e, 0);
      pausePlaying();
    }
    /**
     * Stops the playing on a click and dispatches the stopped by hand event.
     * @param e the click event of the stop button, null on a direct call
     */
    private function stopButtonLinkClicked(e:Event = null):void
    {
      application.trace("<" + this + " VideoPlayer stopButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer stopButtonLinkClicked> e: " + e, 0);
      doTheStop();
      dispatchEventStoppedByHand();
    }
    /**
     * Steps onto the chapter standing before this one on a click.
     * @param e the click event of that button
     */
    private function prevChapterButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer prevChapterButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer prevChapterButtonLinkClicked> e: " + e, 0);
      prevChapter();
    }
    /**
     * Steps onto the chapter standing after this one on a click.
     * @param e the click event of that button
     */
    private function nextChapterButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer nextChapterButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer nextChapterButtonLinkClicked> e: " + e, 0);
      nextChapter();
    }
    /**
     * Positions everything again after one of the controls has taken new dimensions: a new
     * font size gives every button another size, and the potmeter of the sound takes
     * another width with the number of the digits of its own value as well.
     * @param e the dimensions changed event of that control
     */
    private function controlResized(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer controlResized> called.", 1);
      application.trace("<" + this + " VideoPlayer controlResized> e: " + e, 0);
      reposResize();
    }
    /**
     * Takes the length and the dimensions of the chapter that is playing from the picture
     * of the video: they have arrived with the metadata of the file of it, so the picture
     * is drawn in those dimensions and the times of the chapter are known from now on.
     * @param e the changed event of the picture of the video
     */
    private function videoPictureChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer videoPictureChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer videoPictureChanged> e: " + e, 0);
      if (hasChapterOfIndex(selectedChapterIndex))
      {
        chapterSecs[selectedChapterIndex] = videoPicture.getMetaSecs();
      }
      seekBar.setChapterSecs(getChapterSecs(selectedChapterIndex));
      resetDisplayedTimes();
      reposResize();
      dispatchEventChanged();
    }
    /**
     * Stops the playing at the end of a chapter and dispatches the stopped by end event.
     * The next chapter is taken and started right away when the automatic continuation is
     * switched on and there is one to be taken at all. A video that can not be continued
     * closes the fullscreen it has been opened in: there is nothing more to be watched on
     * that surface, so this player is taken back into the box of its own.
     * @param e the stopped by end event of the picture of the video
     */
    private function videoPictureEnded(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer videoPictureEnded> called.", 1);
      application.trace("<" + this + " VideoPlayer videoPictureEnded> e: " + e, 0);
      const indexToContinue:int = selectedChapterIndex + 1;
      doTheStop();
      dispatchEventStoppedByEnd();
      if (!autoContinue || !hasChapterOfIndex(indexToContinue))
      {
        application.trace("<" + this + " VideoPlayer videoPictureEnded> there is no chapter to be continued with.", 1);
        closeFullscreen();
        return;
      }
      setSelectedChapterIndex(indexToContinue);
      doPlayingStuff();
      dispatchEventPlayedByOutside();
    }
    /**
     * Stops the playing of a chapter that can not be played at all: the picture of the
     * video has dropped the stream of it, so there is nothing left to be followed.
     * @param e the cleared event of the picture of the video
     */
    private function videoPictureCleared(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer videoPictureCleared> called.", 1);
      application.trace("<" + this + " VideoPlayer videoPictureCleared> e: " + e, 0);
      doTheStop();
    }
    /**
     * Creates and starts the timer that displays the time of the playing.
     */
    private function createTimeDisplayingTimer():void
    {
      application.trace("<" + this + " VideoPlayer createTimeDisplayingTimer> called.", 1);
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
      application.trace("<" + this + " VideoPlayer dropTimeDisplayingTimer> called.", 1);
      if (timeDisplayingTimer != null)
      {
        timeDisplayingTimer.stop();
        timeDisplayingTimer.removeEventListener(TimerEvent.TIMER, timeDisplayingTimerHandler);
        timeDisplayingTimer = null;
      }
    }
    /**
     * Displays the time played so far and the time still to come, and takes the seek bar
     * to the point the playing has come to. A player without a stream has nothing to play
     * any more, so it is stopped.
     * @param e the timer event of the time displaying timer
     */
    private function timeDisplayingTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " VideoPlayer timeDisplayingTimerHandler> called.", 1);
      application.trace("<" + this + " VideoPlayer timeDisplayingTimerHandler> e: " + e, 0);
      if (!videoPicture.hasTheStream())
      {
        application.trace("<" + this + " VideoPlayer timeDisplayingTimerHandler> there is no stream to be followed!", 6);
        stopButtonLinkClicked();
        return;
      }
      progressSecs = videoPicture.getStreamSecs();
      bufferSecs = videoPicture.getBufferSecs();
      displayTimes();
      seekBar.displayProgress(progressSecs, bufferSecs);
    }
    /**
     * Displays the time played so far and the time still to come.
     */
    private function displayTimes():void
    {
      application.trace("<" + this + " VideoPlayer displayTimes> called.", 1);
      const chapterSecsOfIt:int = getChapterSecs(selectedChapterIndex);
      progressTimeTextLabel.setLabel(application.getUtils().secondsToDisplayedTime(Math.max(0, progressSecs)));
      remainingTimeTextLabel.setLabel("-" + application.getUtils()
          .secondsToDisplayedTime(Math.max(0, chapterSecsOfIt - progressSecs)));
    }
    /**
     * Displays the time of a player standing at the beginning of its chapter.
     */
    private function resetDisplayedTimes():void
    {
      application.trace("<" + this + " VideoPlayer resetDisplayedTimes> called.", 1);
      progressSecs = 0;
      displayTimes();
    }
    /**
     * Positions the label of the remaining time to the end of the line of the controls.
     * @param e the dimensions changed event of that label, null on a direct call
     */
    private function reposRemainingTimeTextLabel(e:Event = null):void
    {
      application.trace("<" + this + " VideoPlayer reposRemainingTimeTextLabel> called.", 1);
      application.trace("<" + this + " VideoPlayer reposRemainingTimeTextLabel> e: " + e, 0);
      remainingTimeTextLabel.setCxy(controlsCx + controlsDw
          - remainingTimeTextLabel.getDw(), progressTimeTextLabel.getCy());
    }
    /**
     * Continues the playing at the point the seek bar has been dragged to.
     * @param e the changed event of the seek bar
     */
    private function seekBarChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer seekBarChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer seekBarChanged> e: " + e, 0);
      videoPicture.seekToSecs(seekBar.getSeekToSecs());
    }
    /**
     * Takes the video of this player onto the volume the potmeter of the sound stands on
     * and draws the icon telling what that sound is doing at the moment.
     */
    private function displaySound():void
    {
      application.trace("<" + this + " VideoPlayer displaySound> called.", 1);
      videoPicture.setSoundVolume(getSoundVolume());
      soundButtonLink.setIcon(getSoundIcon());
    }
    /**
     * Returns the icon the button of the sound has to carry: the one of the muting on a
     * muted video, and the one of the loudness the potmeter stands on otherwise, from the
     * silent speaker up to the loudest one.
     */
    private function getSoundIcon():String
    {
      application.trace("<" + this + " VideoPlayer getSoundIcon> called.", 1);
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
     * Takes the video of this player onto the volume the potmeter of the sound has been
     * dragged to: the icon of the button of that sound follows the new value as well.
     * @param e the changed event of that potmeter
     */
    private function soundPotmeterChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer soundPotmeterChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer soundPotmeterChanged> e: " + e, 0);
      displaySound();
      dispatchEventChanged();
    }
    /**
     * Mutes the video of this player on a click on the button of the sound, and unmutes a
     * muted one: that very button is the one carrying both of them.
     * @param e the click event of that button
     */
    private function soundButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer soundButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer soundButtonLinkClicked> e: " + e, 0);
      setSoundMuted(!isSoundMuted());
      dispatchEventChanged();
    }
    /**
     * Returns the room the buttons and the times of the player take on the picture of the
     * video: one row of a button and one row of a text under it.
     */
    private function getControlsDh():int
    {
      return 2 * playButtonLink.getDh() - 2 * application.getDynamicsConfig().getAppPadding();
    }
    /**
     * Returns the space every element of this player keeps away from the frame around
     * them: one padding of the application when there is a frame at all.
     */
    private function getFrameDelta():int
    {
      return frame ? application.getDynamicsConfig().getAppPadding() : 0;
    }
    /**
     * Returns the room the picture of the video can be drawn inside in the given
     * direction: the side of the box without the space the frame takes on the two ends
     * of it. A side of the box nobody has bounded gives no room at all.
     * @param boxSide the side of the box, a zero when it is not bounded at all
     */
    private function getRoom(boxSide:int):int
    {
      return Math.max(0, boxSide - 2 * getFrameDelta());
    }
    /**
     * Returns the width of the room every element of this player stands inside: the room
     * of the box of it, never narrower than the picture of the video itself and never
     * narrower than the line the controls of the player are laid out along either.
     */
    private function getContentDw():int
    {
      return Math.max(getMinContentDw()
          , Math.max(getVideoDwToDraw(), getRoom(boxDw)));
    }
    /**
     * Returns the height of the room every element of this player stands inside: the
     * height the picture of the video is drawn with, never lower than the room the
     * elements standing on that picture need. The box of the picture is a bound of it and
     * not a room to be filled, so a box taller than the picture needs leaves this player
     * exactly as low as that picture is drawn.
     */
    private function getContentDh():int
    {
      return Math.max(getMinContentDh(), getVideoDhToDraw());
    }
    /**
     * Returns the narrowest line the controls of this player can be laid out along: the six
     * elements of the first row of them next to each other, one margin of the application
     * away from each other. Five of those six carry one icon only, so the height of a button
     * is the room every one of them takes, and the sixth one is the potmeter of the sound:
     * that one is as wide as the value standing on it needs.
     */
    private function getMinContentDw():int
    {
      return (NUM_OF_CONTROLS - 1) * playButtonLink.getDh() + soundPotmeter.getDw()
          + (NUM_OF_CONTROLS - 1) * application.getDynamicsConfig().getAppMargin();
    }
    /**
     * Returns the lowest room the picture of the video is drawn inside: the two rows of the
     * controls standing on that picture, one padding of the application over and under
     * them. A greater font size gives a greater room, because the rows of the controls
     * follow it.
     */
    private function getMinContentDh():int
    {
      return getControlsDh() + 2 * application.getDynamicsConfig().getAppPadding();
    }
    /**
     * Returns the width of the line the name of the chapter and the controls of the player
     * are laid out along: the width of the picture of the video without one padding of the
     * application at the two ends of it and without the room of the handle of the resizing,
     * never narrower than the room the six elements of the first row of the controls need.
     * The dimensions the picture is really drawn with are the ones read here, so this
     * answers the line of a fullscreen exactly the way it answers the one drawn inside the
     * box of this player.
     */
    private function getLineDw():int
    {
      return Math.max(getMinContentDw(), videoDw - getResizerRoom()
          - 2 * application.getDynamicsConfig().getAppPadding());
    }
    /**
     * Returns the room the handle of the resizing takes at the end of the line of the
     * controls: that handle stands in the bottom right corner of the picture of the video,
     * so the element standing at that end of the line is kept away from it. A player that
     * carries no handle at all and an opened fullscreen give that room to the controls: the
     * handle belongs to the box of this player and not to the surface of a fullscreen.
     */
    private function getResizerRoom():int
    {
      return baseResizer != null && !isFullscreenOpened() ? baseResizer.getDw() : 0;
    }
    /**
     * Returns the width the picture of the video is drawn with: the one it has arrived
     * with, shrunk into the box of this object. The picture keeps its own aspect ratio,
     * so the side that does not fit that box is the one both sides come from, and a
     * picture nobody knows the dimensions of yet fills the whole box.
     */
    private function getVideoDwToDraw():int
    {
      application.trace("<" + this + " VideoPlayer getVideoDwToDraw> called.", 1);
      const metaDw:int = videoPicture.getMetaDw();
      const metaDh:int = videoPicture.getMetaDh();
      if (boxDw < 1 || boxDh < 1)
      {
        return metaDw;
      }
      const roomDw:int = getRoom(boxDw);
      if (metaDw < 1 || metaDh < 1)
      {
        return roomDw;
      }
      return Math.max(0, Math.min(roomDw, int(getRoom(boxDh) * metaDw / metaDh)));
    }
    /**
     * Returns the height the picture of the video is drawn with, see the getVideoDwToDraw
     * above.
     */
    private function getVideoDhToDraw():int
    {
      application.trace("<" + this + " VideoPlayer getVideoDhToDraw> called.", 1);
      const metaDw:int = videoPicture.getMetaDw();
      const metaDh:int = videoPicture.getMetaDh();
      if (boxDw < 1 || boxDh < 1)
      {
        return metaDh;
      }
      if (metaDw < 1 || metaDh < 1)
      {
        return getRoom(boxDh);
      }
      return Math.max(0, int(getVideoDwToDraw() * metaDh / metaDw));
    }
    /**
     * Positions and resizes everything standing on this player, keeping every one of them
     * one frame delta away from the frame around them: the picture of the video is drawn
     * inside the box of this object, in the middle of the line it is given, the controls of
     * the player stand on that very picture and the name of the chapter under it. The room
     * this object takes is the room of the picture and the row of that name, and the
     * picture is never drawn lower than the controls standing on it need. A player whose
     * video is opened in fullscreen is laid out by the method below instead: the elements of
     * it stand on the surface of that fullscreen and not on this object, and the dimensions
     * of this object are left the way they are, so the room it takes inside the application
     * does not change while the video covers the whole stage.
     */
    private function reposResize():void
    {
      application.trace("<" + this + " VideoPlayer reposResize> called.", 1);
      if (isFullscreenOpened())
      {
        reposResizeFullscreen();
        return;
      }
      const delta:int = getFrameDelta();
      videoDw = getVideoDwToDraw();
      videoDh = getVideoDhToDraw();
      const contentDw:int = getContentDw();
      // the name of the chapter is broken into lines in front of everything else, because
      // the height of this player holds the whole row of that name
      chapterTitle.setMaxWidth(contentDw);
      const contentDh:int = getContentDh();
      super.setDwh(contentDw + 2 * delta
          , contentDh + chapterTitle.getDh() + 2 * delta);
      videoPicture.setDwh(videoDw, videoDh);
      videoPicture.setCxy(delta + int((contentDw - videoDw) / 2), delta);
      // the name of the chapter stands right under the picture of the video, on the
      // background of this player: it is the one row that is not drawn onto the video
      chapterTitle.setCxy(delta, delta + contentDh);
      reposControlsOnThePicture(delta, delta, contentDw);
      redrawFrameShape();
      reposFullscreenButtonLink();
      reposChapterList();
      reposResizer();
    }
    /**
     * Lays the surface of the fullscreen out and performs one more pass of that layout as
     * long as it is asked for, at most as many passes as the constant of them tells. The
     * room the picture of the video is drawn inside is the stage without the row of the name
     * of the chapter, and the width that name is broken along is the width of that very
     * picture, so the two of them are taken from each other: a narrower name takes more
     * lines, more lines take a higher row, and a higher row leaves a lower picture behind.
     * The name arrives back here by the dimensions changed event of it, so that pull is a
     * loop this layout is never let recurse in: a pass arriving while another one is running
     * only marks that one more is needed, and the running one performs it. A stage that is
     * shrunk under the room the picture and the name both need is a stage the two of them
     * never agree on, so the number of the passes is bounded and the picture stands in the
     * dimensions of the last one from then on.
     */
    private function reposResizeFullscreen():void
    {
      application.trace("<" + this + " VideoPlayer reposResizeFullscreen> called.", 1);
      if (fullscreenLayoutRunning)
      {
        application.trace("<" + this + " VideoPlayer reposResizeFullscreen> one pass is running already, so one more is only marked.", 1);
        fullscreenLayoutAgain = true;
        return;
      }
      fullscreenLayoutRunning = true;
      var passes:int = 0;
      do
      {
        fullscreenLayoutAgain = false;
        reposResizeFullscreenOnePass();
        passes++;
      }
      while (fullscreenLayoutAgain && passes < NUM_OF_FULLSCREEN_PASSES);
      fullscreenLayoutRunning = false;
    }
    /**
     * Performs one single pass of the layout of the fullscreen: the picture of the video is
     * drawn in the greatest dimensions it fits the stage in, one padding of the application
     * away from the edges of it and one row of the name of the chapter left free under it,
     * and it is placed into the middle of the room that is left. The controls of the player
     * stand on that picture and the name of the chapter right under it, following the very
     * edges that picture is drawn between, so the name of a video standing in the middle of
     * a wide stage stands in the middle of it as well. A fullscreen that is not opened at
     * all has nothing to be laid out. The method above is the only one calling this: a pass
     * that breaks the name of the chapter into another number of lines asks that one for
     * one more pass.
     */
    private function reposResizeFullscreenOnePass():void
    {
      application.trace("<" + this + " VideoPlayer reposResizeFullscreenOnePass> called.", 1);
      if (!isFullscreenOpened() || stage == null)
      {
        application.trace("<" + this + " VideoPlayer reposResizeFullscreenOnePass> there is no fullscreen to be laid out.", 1);
        return;
      }
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const stageDw:int = stage.stageWidth;
      const stageDh:int = stage.stageHeight;
      fullscreenBackShape.graphics.clear();
      fullscreenBackShape.graphics.beginFill(0x000000, 1);
      fullscreenBackShape.graphics.drawRect(0, 0, stageDw, stageDh);
      fullscreenBackShape.graphics.endFill();
      // the picture keeps the aspect ratio it has arrived with here as well, so the side
      // that does not fit the room above the controls is the one both sides come from, and
      // a picture nobody knows the dimensions of yet fills that whole room
      const metaDw:int = videoPicture.getMetaDw();
      const metaDh:int = videoPicture.getMetaDh();
      const roomDw:int = Math.max(1, stageDw - 2 * padding);
      // The name of the chapter takes a row of its own under the picture here as well, so
      // the room that picture is drawn inside is the stage without that row. The height the
      // name stands with at this moment is the one reserved here and the width of it comes
      // from the picture below, so a name that has to be broken into another number of lines
      // asks the method above for one more pass of this layout.
      const roomDh:int = Math.max(1, stageDh - chapterTitle.getDh() - 2 * padding);
      const knownMeta:Boolean = metaDw > 0 && metaDh > 0;
      videoDw = knownMeta ? Math.max(1, Math.min(roomDw, int(roomDh * metaDw / metaDh))) : roomDw;
      videoDh = knownMeta ? Math.max(1, int(videoDw * metaDh / metaDw)) : roomDh;
      videoPicture.setDwh(videoDw, videoDh);
      videoPicture.setCxy(padding + int((roomDw - videoDw) / 2)
          , padding + int((roomDh - videoDh) / 2));
      // the name of the chapter follows the picture of the video: it stands under the left
      // edge of it and it is broken into as many lines as the width of that picture asks
      // for, so it is never wider than the video it belongs to and it never stands next to
      // it either
      chapterTitle.setMaxWidth(videoDw);
      chapterTitle.setCxy(videoPicture.getCx(), videoPicture.getCy(true));
      reposControlsOnThePicture(padding, padding, roomDw);
      reposFullscreenButtonLink();
      reposChapterList();
    }
    /**
     * Positions the controls of the player onto the picture of the video: the two rows of
     * them stand at the bottom of that picture, one padding of the application over and
     * under them. A picture too low to carry them takes them as high as the given room
     * begins, so they never leave that room, and one narrower than the line of them needs
     * carries them centered on itself, kept inside that very room: the room of this player
     * is never narrower than that line.
     * @param areaCx the x coordinate the room of the picture begins at
     * @param areaCy the y coordinate that room begins at
     * @param areaDw the width of that room
     */
    private function reposControlsOnThePicture(areaCx:int, areaCy:int, areaDw:int):void
    {
      application.trace("<" + this + " VideoPlayer reposControlsOnThePicture> called.", 1);
      application.trace("<" + this + " VideoPlayer reposControlsOnThePicture> areaCx: " + areaCx, 0);
      application.trace("<" + this + " VideoPlayer reposControlsOnThePicture> areaCy: " + areaCy, 0);
      application.trace("<" + this + " VideoPlayer reposControlsOnThePicture> areaDw: " + areaDw, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const lineDw:int = getLineDw();
      const lineCx:int = Math.max(areaCx, Math.min(videoPicture.getCx()
          + int((videoDw - lineDw) / 2), areaCx + areaDw - lineDw));
      const lineCy:int = Math.max(areaCy + padding
          , videoPicture.getCy(true) - padding - getControlsDh());
      reposControls(lineCx, lineDw, lineCy);
    }
    /**
     * Positions the controls of the player along the given line: the two chapter buttons
     * stand at the two ends of the first row of it, when there is a chapter to step onto
     * at all, and the four elements of the playing and of the sound in the middle of it,
     * the second row carries the times played and still to come, with the seek bar between
     * them. The line itself is kept, because the label of the remaining time is placed
     * inside it later on as well.
     * @param lineCx the x coordinate the line of the controls begins at
     * @param lineDw the width of that line
     * @param lineCy the y coordinate the first row of the controls stands at
     */
    private function reposControls(lineCx:int, lineDw:int, lineCy:int):void
    {
      application.trace("<" + this + " VideoPlayer reposControls> called.", 1);
      application.trace("<" + this + " VideoPlayer reposControls> lineCx: " + lineCx, 0);
      application.trace("<" + this + " VideoPlayer reposControls> lineDw: " + lineDw, 0);
      application.trace("<" + this + " VideoPlayer reposControls> lineCy: " + lineCy, 0);
      controlsCx = lineCx;
      controlsDw = lineDw;
      controlsCy = lineCy;
      prevChapterButtonLink.setCxy(lineCx, lineCy);
      nextChapterButtonLink.setCxy(lineCx + lineDw - nextChapterButtonLink.getDw(), lineCy);
      reposMiddleControls(lineCy);
      progressTimeTextLabel.setCxy(lineCx, playButtonLink.getCy(true));
      reposRemainingTimeTextLabel();
      // the seek bar takes the whole line and it keeps the room of the two displayed times
      // at the two ends of it by itself
      seekBar.setCxy(lineCx, playButtonLink.getCy(true));
      seekBar.setDw(lineDw);
    }
    /**
     * Positions the four elements standing in the middle of the first row of the controls
     * next to each other, one margin of the application away from each other: the play or
     * the pause button, the stop button, the button of the sound and the potmeter of it.
     * The group of them is centered on the picture of the video itself and not on the line
     * of the controls, so it follows the dimensions that picture is really drawn with, and
     * it is kept inside the room the two chapter buttons leave free at the two ends of that
     * line: a picture narrower than the group needs takes it as close to its own middle as
     * it fits. The potmeter is vertically centered on the buttons standing next to it.
     * @param lineCy the y coordinate the first row of the controls stands at
     */
    private function reposMiddleControls(lineCy:int):void
    {
      application.trace("<" + this + " VideoPlayer reposMiddleControls> called.", 1);
      application.trace("<" + this + " VideoPlayer reposMiddleControls> lineCy: " + lineCy, 0);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      // the play and the pause button stand on the very same place and they take each
      // other's place, so the group is as wide as one of them and the three elements
      // standing next to it
      const groupDw:int = playButtonLink.getDw() + stopButtonLink.getDw()
          + soundButtonLink.getDw() + soundPotmeter.getDw() + 3 * margin;
      const centeredCx:int = int((videoPicture.getCx() + videoPicture.getCx(true)) / 2)
          - int(groupDw / 2);
      // a chapter button that is not displayed at all holds no dimensions either, so the
      // room below is the whole line of the controls in that case
      const roomFromCx:int = prevChapterButtonLink.getCx(true);
      const roomToCx:int = nextChapterButtonLink.getCx();
      const groupCx:int = Math.max(roomFromCx, Math.min(centeredCx, roomToCx - groupDw));
      playButtonLink.setCxy(groupCx, lineCy);
      pausButtonLink.setCxy(playButtonLink.getCx(), playButtonLink.getCy());
      stopButtonLink.setCxy(playButtonLink.getCx(true) + margin, lineCy);
      soundButtonLink.setCxy(stopButtonLink.getCx(true) + margin, lineCy);
      soundPotmeter.setCxy(soundButtonLink.getCx(true) + margin
          , lineCy + int((soundButtonLink.getDh() - soundPotmeter.getDh()) / 2));
    }
    /**
     * Creates the handle the box of the picture is resized by hand with and places it
     * into the corner of that picture.
     */
    private function createResizer():void
    {
      application.trace("<" + this + " VideoPlayer createResizer> called.", 1);
      if (baseResizer != null)
      {
        application.trace("<" + this + " VideoPlayer createResizer> there is a handle already.", 1);
        return;
      }
      baseResizer = new BaseResizer(application);
      addChild(baseResizer);
      baseResizer.setEnabled(getEnabled());
      baseResizer.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), resizerChanged);
      baseResizer.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resizerResized);
      displayResizer();
      reposResizer();
    }
    /**
     * Frees up the handle the box of the picture is resized by hand with.
     */
    private function removeResizer():void
    {
      application.trace("<" + this + " VideoPlayer removeResizer> called.", 1);
      if (baseResizer != null)
      {
        // the handle follows the appearance of the application on listeners of its own,
        // so it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application
        baseResizer.destroy();
        if (contains(baseResizer))
        {
          removeChild(baseResizer);
        }
        baseResizer = null;
      }
    }
    /**
     * Places the handle of the resizing into the bottom right corner of the picture of
     * the video and tells it the box a drag of it has to start from. The corner of the
     * picture is the one it stands at and not the one of this whole player, because the
     * bottom right corner of that player is the place of the remaining time. A box nobody
     * has bounded is this player itself, so the drag starts from the dimensions it stands
     * in at the moment.
     */
    private function reposResizer():void
    {
      application.trace("<" + this + " VideoPlayer reposResizer> called.", 1);
      if (baseResizer != null)
      {
        baseResizer.setDimensions(boxDw > 0 ? boxDw : getDw(), boxDh > 0 ? boxDh : getDh());
        baseResizer.setCornerDimensions(videoPicture.getCx(true), videoPicture.getCy(true));
      }
    }
    /**
     * Displays the handle of the resizing the way the chapters of this player ask for it:
     * a video of no chapter at all has no picture to be resized, so that handle is taken
     * away completely there, exactly the way the button of the fullscreen is, however the
     * feature itself stays switched on. The handle of a player that carries a chapter
     * again appears again.
     */
    private function displayResizer():void
    {
      application.trace("<" + this + " VideoPlayer displayResizer> called.", 1);
      if (baseResizer == null)
      {
        application.trace("<" + this + " VideoPlayer displayResizer> there is no handle of the resizing at all.", 1);
        return;
      }
      baseResizer.setSpriteVisible(hasAnyChapter());
    }
    /**
     * Takes the box of the picture from the drag of the handle of the resizing.
     * @param e the changed event of that handle
     */
    private function resizerChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer resizerChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer resizerChanged> e: " + e, 0);
      setDwh(baseResizer.getDimensionDw(), baseResizer.getDimensionDh());
    }
    /**
     * Places the handle of the resizing again after it has taken new dimensions: a new
     * font size gives it another size.
     * @param e the dimensions changed event of that handle
     */
    private function resizerResized(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer resizerResized> called.", 1);
      application.trace("<" + this + " VideoPlayer resizerResized> e: " + e, 0);
      reposResizer();
    }
    /**
     * Creates the button opening and closing the fullscreen of the video and places it
     * into the corner of the picture.
     */
    private function createFullscreenButtonLink():void
    {
      application.trace("<" + this + " VideoPlayer createFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        application.trace("<" + this + " VideoPlayer createFullscreenButtonLink> there is a button already.", 1);
        return;
      }
      fullscreenButtonLink = new ButtonLink(application);
      controlsSprite.addChild(fullscreenButtonLink);
      fullscreenButtonLink.setEnabled(getEnabled());
      fullscreenButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), fullscreenButtonLinkClicked);
      fullscreenButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), fullscreenButtonLinkResized);
      displayFullscreenButtonLinkIcon();
      displayFullscreenButtonLink();
    }
    /**
     * Frees up the button opening and closing the fullscreen of the video.
     */
    private function dropFullscreenButtonLink():void
    {
      application.trace("<" + this + " VideoPlayer dropFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        // the button follows the appearance of the application on listeners of its own,
        // so it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application
        fullscreenButtonLink.destroy();
        if (fullscreenButtonLink.parent != null)
        {
          fullscreenButtonLink.parent.removeChild(fullscreenButtonLink);
        }
        fullscreenButtonLink = null;
      }
    }
    /**
     * Displays the button of the fullscreen the way the chapters of this player ask for
     * it: a video of no chapter at all has nothing to be opened in fullscreen, so that
     * button is taken away completely there, exactly the way the two chapter buttons and
     * the one of the list of the chapters are, and an opened fullscreen is closed right
     * away. The button of a player that carries a chapter again appears again.
     */
    private function displayFullscreenButtonLink():void
    {
      application.trace("<" + this + " VideoPlayer displayFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink == null)
      {
        application.trace("<" + this + " VideoPlayer displayFullscreenButtonLink> there is no button of the fullscreen at all.", 1);
        return;
      }
      // the fullscreen is closed in front of the hiding below, so that the button is taken
      // off the surface of that fullscreen and put back onto this object first
      const openable:Boolean = hasAnyChapter();
      if (!openable)
      {
        closeFullscreen();
      }
      fullscreenButtonLink.setSpriteVisible(openable);
    }
    /**
     * Draws the icon of the state the fullscreen of the video is in: an opened one is
     * closed by that very button, so it carries the icon of the closing from that moment
     * on.
     */
    private function displayFullscreenButtonLinkIcon():void
    {
      application.trace("<" + this + " VideoPlayer displayFullscreenButtonLinkIcon> called.", 1);
      if (fullscreenButtonLink != null)
      {
        fullscreenButtonLink.setIcon(isFullscreenOpened()
            ? EnumIcons.minimize() : EnumIcons.maximize());
      }
    }
    /**
     * Places the button of the fullscreen into the top right corner of the picture of the
     * video, whichever of the two layouts has drawn that picture.
     */
    private function reposFullscreenButtonLink():void
    {
      application.trace("<" + this + " VideoPlayer reposFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        fullscreenButtonLink.setCxy(videoPicture.getCx(true) - fullscreenButtonLink.getDw()
            , videoPicture.getCy());
      }
    }
    /**
     * Places the button of the fullscreen again after it has taken new dimensions: a new
     * font size gives it another size.
     * @param e the dimensions changed event of that button
     */
    private function fullscreenButtonLinkResized(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer fullscreenButtonLinkResized> called.", 1);
      application.trace("<" + this + " VideoPlayer fullscreenButtonLinkResized> e: " + e, 0);
      reposFullscreenButtonLink();
    }
    /**
     * Opens the video in fullscreen on a click on the button of it, and closes an opened
     * one: that very button is the one carrying both of them.
     * @param e the click event of that button
     */
    private function fullscreenButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer fullscreenButtonLinkClicked> called.", 1);
      application.trace("<" + this + " VideoPlayer fullscreenButtonLinkClicked> e: " + e, 0);
      if (isFullscreenOpened())
      {
        closeFullscreen();
        return;
      }
      openFullscreen();
    }
    /**
     * Builds the list of the chapters of the video can be picked from and puts the names
     * of them into it right away.
     */
    private function createChapterList():void
    {
      application.trace("<" + this + " VideoPlayer createChapterList> called.", 1);
      if (chapterList != null)
      {
        application.trace("<" + this + " VideoPlayer createChapterList> there is a list already.", 1);
        return;
      }
      chapterList = new ChapterList(application);
      controlsSprite.addChild(chapterList);
      chapterList.setEnabled(getEnabled());
      chapterList.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), chapterListChanged);
      chapterList.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OPENED(), chapterListOpenedOrClosed);
      chapterList.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), chapterListOpenedOrClosed);
      displayChapterList();
    }
    /**
     * Frees up the list of the chapters of the video.
     */
    private function dropChapterList():void
    {
      application.trace("<" + this + " VideoPlayer dropChapterList> called.", 1);
      if (chapterList != null)
      {
        // the list follows the appearance of the application on listeners of its own, so
        // it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application. It stands on the surface
        // of the fullscreen while that fullscreen is opened, so it is taken off the very
        // parent it has and not off this object.
        chapterList.destroy();
        if (chapterList.parent != null)
        {
          chapterList.parent.removeChild(chapterList);
        }
        chapterList = null;
      }
    }
    /**
     * Puts the names of the chapters into the list of them and marks the one this player
     * stands on. The arrays are copied, because that list keeps the very ones it is given.
     */
    private function displayChapterList():void
    {
      application.trace("<" + this + " VideoPlayer displayChapterList> called.", 1);
      if (chapterList == null)
      {
        application.trace("<" + this + " VideoPlayer displayChapterList> there is no list of the chapters at all.", 1);
        return;
      }
      chapterList.setChapters(chapterNames.concat(), chapterUrls.concat(), selectedChapterIndex);
    }
    /**
     * Places the list of the chapters onto the picture of the video and lays it out from
     * the dimensions that picture is drawn with at the moment, whichever of the two
     * layouts has drawn it. The room of the button of the fullscreen is left free at the
     * end of it, so the two features of the picture never cover each other, and the list
     * is never taller than the room standing over the controls of the player: the names to
     * be picked and those controls never cover each other either.
     */
    private function reposChapterList():void
    {
      application.trace("<" + this + " VideoPlayer reposChapterList> called.", 1);
      if (chapterList == null)
      {
        application.trace("<" + this + " VideoPlayer reposChapterList> there is no list of the chapters at all.", 1);
        return;
      }
      const endCx:int = fullscreenButtonLink != null
          ? fullscreenButtonLink.getCx() : videoPicture.getCx(true);
      chapterList.setCxy(videoPicture.getCx(), videoPicture.getCy());
      chapterList.setDwh(Math.max(0, endCx - videoPicture.getCx())
          , Math.max(0, controlsCy - videoPicture.getCy()));
    }
    /**
     * Plays the chapter that has been picked from the list of them: this player steps onto
     * that chapter and the playing of it begins right away. A player that is playing
     * something keeps playing, so the step is the one starting the new chapter there: only
     * a player standing still has to be started.
     * @param e the changed event of the list of the chapters
     */
    private function chapterListChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer chapterListChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer chapterListChanged> e: " + e, 0);
      setSelectedChapterIndex(chapterList.getPickedIndex());
      if (!isPlaying())
      {
        playButtonLinkClicked();
      }
    }
    /**
     * Tells the outside that the list of the chapters has been opened or closed: that list
     * is opened and closed by the button standing on the picture of the video as well, so
     * the one holding this player follows it by the changed event of this player.
     * @param e the opened or closed event of that list
     */
    private function chapterListOpenedOrClosed(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer chapterListOpenedOrClosed> called.", 1);
      application.trace("<" + this + " VideoPlayer chapterListOpenedOrClosed> e: " + e, 0);
      dispatchEventChanged();
    }
    /**
     * Lays the fullscreen of the video out again after the stage has been resized: the
     * picture and the controls of it are measured from that stage, so they take other
     * dimensions and other places with it.
     * @param e the resize event of the stage
     */
    private function stageResized(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer stageResized> called.", 1);
      application.trace("<" + this + " VideoPlayer stageResized> e: " + e, 0);
      reposResizeFullscreen();
    }
    /**
     * Displays the layer of the controls over the picture of the video on a press on that
     * picture, and takes it off the video on a press anywhere else: every control of that
     * layer stands on the picture, so a press next to it means that they are not being used
     * any more. A press on the picture starts the counting of the inactivity again, whether
     * that layer has been displayed by it or it has been standing there already.
     * @param e the mouse down event of the stage
     */
    private function stageMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " VideoPlayer stageMouseDown> called.", 1);
      application.trace("<" + this + " VideoPlayer stageMouseDown> e: " + e, 0);
      if (!mouseIsOnThePicture())
      {
        application.trace("<" + this + " VideoPlayer stageMouseDown> the press has arrived next to the picture.", 1);
        setControlsVisible(false);
        return;
      }
      setControlsVisible(true);
      restartControlsTimer();
    }
    /**
     * Starts the counting of the inactivity again on every move of the mouse over the
     * picture of the video: a video watched with the layer of the controls on it is one
     * being used at that very moment. A layer that is not displayed at all is not taken
     * back by a move of the mouse: it is a press that displays it.
     * @param e the mouse move event of the stage
     */
    private function stageMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " VideoPlayer stageMouseMove> called.", 0);
      application.trace("<" + this + " VideoPlayer stageMouseMove> e: " + e, 0);
      if (getControlsVisible() && mouseIsOnThePicture())
      {
        restartControlsTimer();
      }
    }
    /**
     * Tells whether the mouse stands on the picture of the video at the moment, whichever
     * of the two layouts has drawn that picture: the coordinates of the picture itself are
     * the ones read here, so the picture standing on the surface of a fullscreen is
     * answered exactly the way the one drawn inside the box of this player is. This is
     * asked on every move of the mouse over the stage, so it logs nothing at all: the lines
     * of it would flood the logger.
     */
    private function mouseIsOnThePicture():Boolean
    {
      return videoPicture.mouseX >= 0 && videoPicture.mouseX <= videoPicture.getDw()
          && videoPicture.mouseY >= 0 && videoPicture.mouseY <= videoPicture.getDh();
    }
    /**
     * Creates the timer taking the layer of the controls off the picture of the video and
     * starts it: that layer stands on the picture as long as the delay of the configuration
     * of the application tells, and every press and every move of the mouse over the video
     * starts that delay again. A player that is not on the stage has nothing to be timed: a
     * timer of an object nobody sees would only keep that object alive for the whole delay
     * of it.
     */
    private function createControlsTimer():void
    {
      application.trace("<" + this + " VideoPlayer createControlsTimer> called.", 1);
      // the timer of a player that is put back onto the stage is dropped in front of the
      // new one, so there is one single timer running at any moment
      dropControlsTimer();
      if (stage == null)
      {
        application.trace("<" + this + " VideoPlayer createControlsTimer> this player is not on the stage, so there is nothing to be timed.", 1);
        return;
      }
      controlsTimer = new Timer(application.getComponentsConfig()
          .getVideoPlayerControlsTimerDelay(), 1);
      controlsTimer.addEventListener(TimerEvent.TIMER, controlsTimerHandler);
      controlsTimer.start();
    }
    /**
     * Starts the counting of the inactivity again: the layer of the controls stands on the
     * picture of the video for the whole delay of the configuration from this moment on. A
     * player that is not on the stage holds no timer to be started at all.
     * This is called on every move of the mouse over the picture, so it logs on the debug
     * level only: a called line of the calling level would flood the logger.
     */
    private function restartControlsTimer():void
    {
      application.trace("<" + this + " VideoPlayer restartControlsTimer> called.", 0);
      if (controlsTimer != null)
      {
        controlsTimer.reset();
        controlsTimer.start();
      }
    }
    /**
     * Takes the layer of the controls off the picture of the video as soon as neither a
     * press nor a move of the mouse has arrived onto that picture for the whole delay of
     * the configuration of the application. A layer that is being used at that very moment
     * stays where it is and the counting is started again instead: an open list of the
     * chapters and a seek icon held by the hand are both elements being used.
     * @param e the timer event of the timer of that layer
     */
    private function controlsTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " VideoPlayer controlsTimerHandler> called.", 1);
      application.trace("<" + this + " VideoPlayer controlsTimerHandler> e: " + e, 0);
      if (isChapterListOpened() || seekBar.isDragged())
      {
        application.trace("<" + this + " VideoPlayer controlsTimerHandler> the layer of the controls is being used.", 1);
        restartControlsTimer();
        return;
      }
      setControlsVisible(false);
    }
    /**
     * Stops and frees up the timer taking the layer of the controls off the picture of the
     * video.
     */
    private function dropControlsTimer():void
    {
      application.trace("<" + this + " VideoPlayer dropControlsTimer> called.", 1);
      if (controlsTimer != null)
      {
        controlsTimer.stop();
        controlsTimer.removeEventListener(TimerEvent.TIMER, controlsTimerHandler);
        controlsTimer = null;
      }
    }
    /**
     * Moves the picture of the video, the name of the chapter and the layer of the controls
     * standing on that picture onto the given surface: every control of the player stands
     * on that one single layer, so those three objects are the whole of it. They are added
     * in the order they have to stand in, so the layer covers the picture and not the other
     * way round, and the frame of this player is left where it is: it belongs to the box of
     * the picture and not to the video itself.
     * @param container the surface those three objects have to be moved onto
     */
    private function moveElementsTo(container:DisplayObjectContainer):void
    {
      application.trace("<" + this + " VideoPlayer moveElementsTo> called.", 1);
      application.trace("<" + this + " VideoPlayer moveElementsTo> container: " + container, 0);
      container.addChild(videoPicture);
      container.addChild(chapterTitle);
      container.addChild(controlsSprite);
    }
    /**
     * Draws the frame of this player in the current colors and radius of the application,
     * or takes it away when there is no frame to be drawn at all.
     */
    private function redrawFrameShape():void
    {
      application.trace("<" + this + " VideoPlayer redrawFrameShape> called.", 1);
      frameShape.visible = frame;
      if (!frame)
      {
        application.trace("<" + this + " VideoPlayer redrawFrameShape> there is no frame to be drawn.", 1);
        return;
      }
      frameShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorBright()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      frameShape.setRadius(application.getDynamicsConfig().getAppRadius());
      frameShape.setDwh(getDw(), getDh());
      frameShape.drawRect();
    }
    /**
     * Draws and positions everything again after the appearance of the application has
     * been changed: the padding, the radius and the colors of it are the ones this player
     * is built of.
     * @param e the padding, radius or background color changed event of the application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " VideoPlayer appearanceChanged> called.", 1);
      application.trace("<" + this + " VideoPlayer appearanceChanged> e: " + e, 0);
      reposResize();
    }
    /**
     * Dispatches the played by hand event of this player.
     */
    private function dispatchEventPlayedByHand():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventPlayedByHand> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventPlayedByHand);
    }
    /**
     * Dispatches the played by outside event of this player.
     */
    private function dispatchEventPlayedByOutside():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventPlayedByOutside> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventPlayedByOutside);
    }
    /**
     * Dispatches the stopped by hand event of this player.
     */
    private function dispatchEventStoppedByHand():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventStoppedByHand> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventStoppedByHand);
    }
    /**
     * Dispatches the stopped by end event of this player.
     */
    private function dispatchEventStoppedByEnd():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventStoppedByEnd> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventStoppedByEnd);
    }
    /**
     * Dispatches the changed event of this player: the chapters, the chapter it stands on
     * or the metadata of that chapter has been changed.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventChanged> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventChanged);
    }
    /**
     * Dispatches the chapter changed event of this player: it stands on another chapter
     * from now on, whether it has been stepped by a click on it, by the outside or by the
     * automatic continuation at the end of a chapter.
     */
    private function dispatchEventChapterChanged():void
    {
      application.trace("<" + this + " VideoPlayer dispatchEventChapterChanged> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventChapterChanged);
    }
    /**
     * Stops the playing and frees all listeners, timers, events and references held by
     * this player.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " VideoPlayer destroy> called.", 1);
      application.trace("<" + this + " VideoPlayer destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
      application.trace("<" + this + " VideoPlayer destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      // the preview picture is switched off in front of the stop below, so that no stream
      // of it is opened while this player is being freed up
      videoPicture.setPreview(false);
      doTheStop();
      dropControlsTimer();
      // the fullscreen is closed here, so that every element of the player stands on this
      // object again: the super destroy below is the one freeing all of them up
      closeFullscreen();
      eventPlayedByOutside.stopImmediatePropagation();
      eventPlayedByHand.stopImmediatePropagation();
      eventStoppedByEnd.stopImmediatePropagation();
      eventStoppedByHand.stopImmediatePropagation();
      eventChanged.stopImmediatePropagation();
      eventChapterChanged.stopImmediatePropagation();
      chapterNames.splice(0);
      chapterUrls.splice(0);
      chapterSecs.splice(0);
      application.trace("<" + this + " VideoPlayer destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      chapterNames = null;
      chapterUrls = null;
      chapterSecs = null;
      selectedChapterIndex = 0;
      autoContinue = false;
      videoPicture = null;
      boxDw = 0;
      boxDh = 0;
      videoDw = 0;
      videoDh = 0;
      frameShape = null;
      frame = false;
      baseResizer = null;
      fullscreenEnabled = false;
      fullscreenButtonLink = null;
      fullscreenSprite = null;
      fullscreenBackShape = null;
      fullscreenLayoutRunning = false;
      fullscreenLayoutAgain = false;
      chapterListEnabled = false;
      chapterList = null;
      controlsSprite = null;
      controlsTimer = null;
      chapterTitle = null;
      prevChapterButtonLink = null;
      playButtonLink = null;
      pausButtonLink = null;
      stopButtonLink = null;
      soundButtonLink = null;
      soundPotmeter = null;
      nextChapterButtonLink = null;
      progressTimeTextLabel = null;
      remainingTimeTextLabel = null;
      seekBar = null;
      controlsCx = 0;
      controlsDw = 0;
      controlsCy = 0;
      progressSecs = 0;
      bufferSecs = 0;
      timeDisplayingTimer = null;
      eventPlayedByOutside = null;
      eventPlayedByHand = null;
      eventStoppedByEnd = null;
      eventStoppedByHand = null;
      eventChanged = null;
      eventChapterChanged = null;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.base.BaseShape;
import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
import com.kisscodesystems.KissAs3Fw.ui.Icon;
import com.kisscodesystems.KissAs3Fw.ui.ListPanel;
import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
import flash.display.Shape;
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.geom.Rectangle;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
/**
 * VideoPicture: the picture of the video of one VideoPlayer.
 * It carries the stream of one chapter, the video object the frames of it are drawn on
 * and the mask keeping that picture inside the rounded corners of the appearance that is
 * on. The first frame of the chapter is held in it while nothing is playing: the stream
 * is opened muted and it is paused on that very frame, so the playing goes on from the
 * same point without loading anything again. It tells the owner of it by three events
 * that the metadata of the file has arrived, that the chapter has come to its end and
 * that the chapter can not be played at all. The volume it plays with is the one of this
 * picture itself and not the sound volume of the application, and a muted picture plays
 * no sound at all.
 */
internal class VideoPicture extends BaseSprite
{
  // the codes of the stream this picture has to answer: the beginning and the end of a
  // chapter, and the two failures that leave it with nothing to play
  private const CODE_PLAY_START:String = "NetStream.Play.Start";
  private const CODE_PLAY_STOP:String = "NetStream.Play.Stop";
  private const CODE_PLAY_FAILED:String = "NetStream.Play.Failed";
  private const CODE_PLAY_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
  // the codes telling that the picture of the beginning of a chapter has arrived: the
  // buffer of it has been filled, or it has been flushed because the whole chapter is
  // shorter than that buffer
  private const CODE_BUFFER_FULL:String = "NetStream.Buffer.Full";
  private const CODE_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";
  // the url of the chapter this picture stands on, an empty string when it holds no
  // chapter at all
  private var url:String = "";
  // the stream of the video, the objects displaying it and the volume of it
  private var netConnection:NetConnection = null;
  private var netStream:NetStream = null;
  private var video:Video = null;
  private var pictureSprite:BaseSprite = null;
  private var maskShape:BaseShape = null;
  private var soundTransform:SoundTransform = null;
  // The volume of this picture, a value between zero and a hundred, and the state of the
  // muting of it. That volume belongs to this picture alone: the sound volume of the
  // application is the one of the sound effects, so it does not touch a picture at all.
  private var soundVolume:int = 100;
  private var soundMuted:Boolean = false;
  // The preview picture: the first frame of the chapter, standing in this picture while
  // nothing is playing. The stream above is the one holding it: it is paused on that very
  // frame, so the playing goes on from that point without loading anything again. A
  // chapter that has refused this once is never asked for it again, so a file that can not
  // be played at all is loaded one single time.
  private var preview:Boolean = true;
  private var previewLoading:Boolean = false;
  private var previewHeld:Boolean = false;
  private var previewFailed:Boolean = false;
  // the dimensions and the length of the chapter, taken from the metadata of the file of
  // it: zeros while that metadata has not arrived yet
  private var metaDw:int = 0;
  private var metaDh:int = 0;
  private var metaSecs:int = 0;
  // the state of the playing of the chapter
  private var playing:Boolean = false;
  private var paused:Boolean = false;
  private var eventChanged:Event = null;
  private var eventStoppedByEnd:Event = null;
  private var eventCleared:Event = null;
  /**
   * Constructs the VideoPicture object: creates the surface the frames of the video are
   * drawn on and the mask of it, and starts to follow the appearance and the sound volume
   * of the application.
   * @param applicationRef the main application reference
   */
  public function VideoPicture(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " VideoPicture> called.", 1);
    application.trace("<" + this + " VideoPicture> applicationRef: " + applicationRef, 0);
    eventChanged = new Event(EnumEvents.EVENT_CHANGED());
    eventStoppedByEnd = new Event(EnumEvents.EVENT_STOPPED_BY_END());
    eventCleared = new Event(EnumEvents.EVENT_CLEARED());
    pictureSprite = new BaseSprite(application);
    addChild(pictureSprite);
    maskShape = new BaseShape(application);
    addChild(maskShape);
    maskShape.setIsFilled(true);
    maskShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
    pictureSprite.mask = maskShape;
    soundVolumeChanged();
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
    application.trace("<" + this + " VideoPicture> constructed.", 1);
  }
  /**
   * Returns the url of the chapter this picture stands on.
   */
  public function getUrl():String
  {
    return url;
  }
  /**
   * Takes the chapter this picture has to carry: the stream, the metadata and the preview
   * picture of the previous one are dropped, and the preview picture of the new one is
   * asked for right away. A chapter that has refused that preview once is asked for it
   * again here, because this is another file from now on.
   * @param u the url of the new chapter, an empty string when there is no chapter at all
   */
  public function setUrl(u:String):void
  {
    application.trace("<" + this + " VideoPicture setUrl> called.", 1);
    application.trace("<" + this + " VideoPicture setUrl> u: " + u, 0);
    url = u;
    metaDw = 0;
    metaDh = 0;
    metaSecs = 0;
    previewFailed = false;
    dropPreview();
    loadPreview();
  }
  /**
   * Tells whether the first frame of the chapter stands in this picture while nothing is
   * playing.
   */
  public function getPreview():Boolean
  {
    return preview;
  }
  /**
   * Tells this picture whether it has to display the first frame of the chapter while
   * nothing is playing. A picture that is playing something keeps playing: the preview
   * picture of it arrives as soon as that playing is over.
   * @param b true when there has to be a preview picture
   */
  public function setPreview(b:Boolean):void
  {
    application.trace("<" + this + " VideoPicture setPreview> called.", 1);
    application.trace("<" + this + " VideoPicture setPreview> b: " + b, 0);
    if (preview == b)
    {
      application.trace("<" + this + " VideoPicture setPreview> nothing to do.", 1);
      return;
    }
    preview = b;
    if (playing)
    {
      application.trace("<" + this + " VideoPicture setPreview> this picture is playing, so it is not touched.", 1);
      return;
    }
    if (preview)
    {
      loadPreview();
    }
    else
    {
      dropPreview();
    }
  }
  /**
   * Returns the volume of this picture, a value between zero and a hundred.
   */
  public function getSoundVolume():int
  {
    return soundVolume;
  }
  /**
   * Sets the volume of this picture and takes the stream of it onto the new volume right
   * away. Only a value inside the range is taken, so the getter above is the one telling
   * what this picture really stands with.
   * @param v the new volume, a value between zero and a hundred
   */
  public function setSoundVolume(v:int):void
  {
    application.trace("<" + this + " VideoPicture setSoundVolume> called.", 1);
    application.trace("<" + this + " VideoPicture setSoundVolume> v: " + v, 0);
    if (soundVolume != v && v >= 0 && v <= 100)
    {
      soundVolume = v;
      soundVolumeChanged();
    }
  }
  /**
   * Tells whether this picture is muted at the moment.
   */
  public function isSoundMuted():Boolean
  {
    return soundMuted;
  }
  /**
   * Mutes or unmutes this picture and takes the stream of it onto the new volume right
   * away. A muted picture plays no sound at all and it keeps the volume it stands on, so
   * an unmuted one goes on with that very volume.
   * @param b true when this picture has to be muted
   */
  public function setSoundMuted(b:Boolean):void
  {
    application.trace("<" + this + " VideoPicture setSoundMuted> called.", 1);
    application.trace("<" + this + " VideoPicture setSoundMuted> b: " + b, 0);
    if (soundMuted != b)
    {
      soundMuted = b;
      soundVolumeChanged();
    }
  }
  /**
   * Returns the width the chapter has arrived with, a zero while the metadata of the file
   * of it has not arrived yet.
   */
  public function getMetaDw():int
  {
    return metaDw;
  }
  /**
   * Returns the height the chapter has arrived with, a zero while the metadata of the
   * file of it has not arrived yet.
   */
  public function getMetaDh():int
  {
    return metaDh;
  }
  /**
   * Returns the length of the chapter in seconds, a zero while the metadata of the file
   * of it has not arrived yet.
   */
  public function getMetaSecs():int
  {
    return metaSecs;
  }
  /**
   * Tells whether this picture is playing a chapter at the moment. A paused one is
   * playing as well: it stands somewhere inside its chapter.
   */
  public function isPlaying():Boolean
  {
    return playing;
  }
  /**
   * Tells whether the playing of this picture is paused at the moment.
   */
  public function isPaused():Boolean
  {
    return paused;
  }
  /**
   * Tells whether there is a stream in this picture at all.
   */
  public function hasTheStream():Boolean
  {
    return netStream != null;
  }
  /**
   * Returns the seconds the stream of this picture has been playing so far, a zero when
   * there is no stream at all.
   */
  public function getStreamSecs():int
  {
    application.trace("<" + this + " VideoPicture getStreamSecs> called.", 1);
    return netStream == null ? 0 : int(netStream.time);
  }
  /**
   * Returns the seconds of the chapter that have arrived over the point the playing
   * stands at, a zero when there is no stream at all.
   */
  public function getBufferSecs():int
  {
    application.trace("<" + this + " VideoPicture getBufferSecs> called.", 1);
    return netStream == null ? 0 : int(netStream.bufferLength);
  }
  /**
   * Starts the playing of the chapter this picture stands on and tells whether it has
   * been started at all. The stream holding the preview picture is only continued: it
   * stands on the very first frame of that chapter already, so nothing has to be loaded
   * again, and a picture without such a stream opens a new one and starts it.
   */
  public function startPlaying():Boolean
  {
    application.trace("<" + this + " VideoPicture startPlaying> called.", 1);
    if (url == "")
    {
      application.trace("<" + this + " VideoPicture startPlaying> there is no chapter to be played!", 6);
      return false;
    }
    if (previewHeld && netStream != null)
    {
      application.trace("<" + this + " VideoPicture startPlaying> the preview picture is the beginning of this chapter.", 1);
      previewHeld = false;
      netStream.resume();
      playing = true;
      paused = false;
      return true;
    }
    dropPreview();
    createNetStream();
    if (netStream == null)
    {
      application.trace("<" + this + " VideoPicture startPlaying> the stream of the video could not be created!", 6);
      return false;
    }
    createVideo();
    try
    {
      netStream.play(url);
    }
    catch (error:*)
    {
      application.trace("<" + this + " VideoPicture startPlaying> the video could not be started: " + error, 7);
      dropPreview();
      return false;
    }
    playing = true;
    paused = false;
    return true;
  }
  /**
   * Pauses the playing at the point it has come to and tells whether it has been paused
   * at all: a picture that is playing nothing or that is paused already has nothing to
   * pause.
   */
  public function pausePlaying():Boolean
  {
    application.trace("<" + this + " VideoPicture pausePlaying> called.", 1);
    if (netStream == null || paused)
    {
      application.trace("<" + this + " VideoPicture pausePlaying> there is nothing to be paused.", 1);
      return false;
    }
    netStream.pause();
    paused = true;
    return true;
  }
  /**
   * Continues the playing at the point this picture has been paused at and tells whether
   * it has been continued at all: a picture that is not paused has nothing to continue.
   */
  public function resumePlaying():Boolean
  {
    application.trace("<" + this + " VideoPicture resumePlaying> called.", 1);
    if (netStream == null || !paused)
    {
      application.trace("<" + this + " VideoPicture resumePlaying> there is nothing to be continued.", 1);
      return false;
    }
    netStream.resume();
    paused = false;
    return true;
  }
  /**
   * Stops the playing and takes this picture back to the beginning of its chapter,
   * holding the first frame of it. A picture that has no preview picture at all drops the
   * stream and the video object of it completely.
   */
  public function stopPlaying():void
  {
    application.trace("<" + this + " VideoPicture stopPlaying> called.", 1);
    playing = false;
    paused = false;
    keepPreview();
  }
  /**
   * Takes the playing to the given point of the chapter. A picture without a stream has
   * nothing to be seeked in.
   * @param secs the second of the chapter the playing has to go on from
   */
  public function seekToSecs(secs:int):void
  {
    application.trace("<" + this + " VideoPicture seekToSecs> called.", 1);
    application.trace("<" + this + " VideoPicture seekToSecs> secs: " + secs, 0);
    if (netStream == null)
    {
      application.trace("<" + this + " VideoPicture seekToSecs> there is nothing to be seeked in.", 1);
      return;
    }
    netStream.seek(secs);
  }
  /**
   * Sets the dimensions the picture of the video is drawn with: the video object and the
   * mask keeping it inside the rounded corners of the appearance take exactly the same
   * ones.
   * @param newdw the new width of the picture
   * @param newdh the new height of the picture
   */
  override public function setDwh(newdw:int, newdh:int):void
  {
    application.trace("<" + this + " VideoPicture setDwh> called.", 1);
    application.trace("<" + this + " VideoPicture setDwh> newdw: " + newdw, 0);
    application.trace("<" + this + " VideoPicture setDwh> newdh: " + newdh, 0);
    super.setDwh(newdw, newdh);
    pictureSprite.setDwh(getDw(), getDh());
    displayVideoDimensions();
    redrawMaskShape();
  }
  /**
   * Asks for the preview picture of the chapter as soon as this picture gets onto the
   * stage: the area of the video is never empty that way.
   * @param e the added to stage event
   */
  override protected function addedToStage(e:Event):void
  {
    application.trace("<" + this + " VideoPicture addedToStage> called.", 1);
    application.trace("<" + this + " VideoPicture addedToStage> e: " + e, 0);
    super.addedToStage(e);
    loadPreview();
  }
  /**
   * Takes the picture of this object to the state a picture that is playing nothing stands
   * in: the stream that is loading the preview picture is left alone, because it takes
   * that picture by itself as soon as the first frame has arrived, the one that has been
   * playing is paused on that very frame, and a picture of no preview picture at all drops
   * the stream and the video object of it completely.
   */
  private function keepPreview():void
  {
    application.trace("<" + this + " VideoPicture keepPreview> called.", 1);
    if (previewLoading)
    {
      application.trace("<" + this + " VideoPicture keepPreview> the preview picture is on its way already.", 1);
      return;
    }
    if (preview && netStream != null && video != null)
    {
      holdPreview();
      return;
    }
    dropPreview();
  }
  /**
   * Starts the loading of the preview picture of the chapter: the stream of it is opened
   * muted, and it is paused on the very first frame as soon as that frame has arrived, so
   * this picture carries it while nothing is playing. A picture that is playing something
   * has that frame already, and a chapter that has refused this once is never asked for it
   * again.
   */
  private function loadPreview():void
  {
    application.trace("<" + this + " VideoPicture loadPreview> called.", 1);
    if (!preview || previewFailed || previewLoading || previewHeld || playing)
    {
      application.trace("<" + this + " VideoPicture loadPreview> there is no preview picture to be loaded.", 1);
      return;
    }
    if (url == "")
    {
      application.trace("<" + this + " VideoPicture loadPreview> there is no chapter to be previewed.", 1);
      return;
    }
    createNetStream();
    if (netStream == null)
    {
      application.trace("<" + this + " VideoPicture loadPreview> the stream of the preview picture could not be created!", 6);
      previewFailed = true;
      return;
    }
    createVideo();
    // the first frame of a chapter arrives together with the sound of the beginning of
    // it, so the stream is muted until it stands on that frame: the volume of the
    // application is taken back by the holdPreview below
    netStream.soundTransform = new SoundTransform(0);
    try
    {
      netStream.play(url);
    }
    catch (error:*)
    {
      application.trace("<" + this + " VideoPicture loadPreview> the preview picture could not be loaded: " + error, 7);
      previewFailed = true;
      dropPreview();
      return;
    }
    previewLoading = true;
  }
  /**
   * Holds the first frame of the chapter in this picture: the stream of it is paused on
   * the beginning of that chapter, so that frame stands there until the playing is
   * started, and the volume of the application is taken back for that playing.
   */
  private function holdPreview():void
  {
    application.trace("<" + this + " VideoPicture holdPreview> called.", 1);
    if (netStream == null)
    {
      application.trace("<" + this + " VideoPicture holdPreview> there is no stream to be paused!", 6);
      return;
    }
    try
    {
      netStream.pause();
      netStream.seek(0);
    }
    catch (error:*)
    {
      application.trace("<" + this + " VideoPicture holdPreview> the stream could not be paused on the first frame: " + error, 7);
      previewFailed = true;
      dropPreview();
      return;
    }
    previewLoading = false;
    previewHeld = true;
    soundVolumeChanged();
  }
  /**
   * Drops the preview picture: the stream standing on the first frame of the chapter is
   * closed and the video object of it is taken away, so this area is empty again.
   */
  private function dropPreview():void
  {
    application.trace("<" + this + " VideoPicture dropPreview> called.", 1);
    previewLoading = false;
    previewHeld = false;
    dropNetStream();
    dropVideo();
  }
  /**
   * Creates the stream the video arrives on: a plain progressive download, so the
   * connection of it is opened to no server at all.
   */
  private function createNetStream():void
  {
    application.trace("<" + this + " VideoPicture createNetStream> called.", 1);
    dropNetStream();
    try
    {
      netConnection = new NetConnection();
      netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
      netConnection.connect(null);
      netStream = new NetStream(netConnection);
      netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
      netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncError);
      netStream.client = createNetStreamClient();
      netStream.bufferTime = application.getComponentsConfig().getVideoPlayerBufferTime();
      netStream.soundTransform = soundTransform;
    }
    catch (error:*)
    {
      application.trace("<" + this + " VideoPicture createNetStream> the stream of the video could not be created: " + error, 7);
      dropNetStream();
    }
  }
  /**
   * Stops and frees up the stream of the video and the connection of it.
   */
  private function dropNetStream():void
  {
    application.trace("<" + this + " VideoPicture dropNetStream> called.", 1);
    if (netStream != null)
    {
      netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
      netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncError);
      try
      {
        netStream.close();
      }
      catch (error:*)
      {
        application.trace("<" + this + " VideoPicture dropNetStream> there was no stream to be closed: " + error, 7);
      }
      netStream = null;
    }
    if (netConnection != null)
    {
      netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
      try
      {
        netConnection.close();
      }
      catch (error:*)
      {
        application.trace("<" + this + " VideoPicture dropNetStream> there was no connection to be closed: " + error, 7);
      }
      netConnection = null;
    }
  }
  /**
   * Builds the object the stream reports the data of the file to. Every callback of it
   * has to stand there, because the runtime raises an error on the ones it does not
   * find, and the metadata is the only one this picture really works with.
   */
  private function createNetStreamClient():Object
  {
    application.trace("<" + this + " VideoPicture createNetStreamClient> called.", 1);
    const client:Object = new Object();
    client.onMetaData = metaDataArrived;
    client.onCuePoint = fileDataIgnored;
    client.onPlayStatus = fileDataIgnored;
    client.onTextData = fileDataIgnored;
    client.onXMPData = fileDataIgnored;
    return client;
  }
  /**
   * Takes the length and the dimensions of the chapter from the metadata of the file of
   * it and tells the owner of this picture about them: it is the one drawing the video in
   * those dimensions.
   * @param info the metadata object of the file
   */
  private function metaDataArrived(info:Object):void
  {
    application.trace("<" + this + " VideoPicture metaDataArrived> called.", 1);
    application.trace("<" + this + " VideoPicture metaDataArrived> info: " + info, 0);
    if (info == null)
    {
      application.trace("<" + this + " VideoPicture metaDataArrived> this file carries no metadata at all!", 6);
      return;
    }
    metaDw = int(info.width);
    metaDh = int(info.height);
    metaSecs = int(info.duration);
    application.trace("<" + this + " VideoPicture metaDataArrived> the picture: " + metaDw + " x " + metaDh, 0);
    application.trace("<" + this + " VideoPicture metaDataArrived> the length: " + metaSecs, 0);
    dispatchEventChanged();
  }
  /**
   * Takes the data of the file this picture does not work with: the cue points, the play
   * status, the texts and the metadata of the publisher of it.
   * @param info the data object of the file
   */
  private function fileDataIgnored(info:Object):void
  {
    application.trace("<" + this + " VideoPicture fileDataIgnored> called.", 1);
    application.trace("<" + this + " VideoPicture fileDataIgnored> info: " + info, 0);
  }
  /**
   * Answers the reports of the stream and of the connection of it: the end of a chapter
   * and a file that can not be played at all are the two the owner of this picture is told
   * about. A stream that is loading the preview picture is not playing anything, so the
   * reports of it are answered by the previewStatus below.
   * @param e the net status event of the stream or of the connection
   */
  private function netStatus(e:NetStatusEvent):void
  {
    application.trace("<" + this + " VideoPicture netStatus> called.", 1);
    application.trace("<" + this + " VideoPicture netStatus> e: " + e, 0);
    const code:String = e.info == null ? "" : String(e.info.code);
    application.trace("<" + this + " VideoPicture netStatus> code: " + code, 0);
    if (code == CODE_PLAY_START)
    {
      application.trace("<" + this + " VideoPicture netStatus> the chapter has been started.", 1);
      return;
    }
    if (previewLoading)
    {
      previewStatus(code);
      return;
    }
    if (code == CODE_PLAY_STOP)
    {
      // the stream standing on the preview picture reports the end of the chapter as soon
      // as the whole file has arrived, and there is nothing to be ended there
      if (!playing)
      {
        application.trace("<" + this + " VideoPicture netStatus> there is nothing that could have come to an end.", 1);
        return;
      }
      dispatchEventStoppedByEnd();
      return;
    }
    if (code == CODE_PLAY_FAILED || code == CODE_PLAY_NOT_FOUND)
    {
      application.trace("<" + this + " VideoPicture netStatus> this chapter could not be played: " + url, 6);
      previewFailed = true;
      dropPreview();
      dispatchEventCleared();
    }
  }
  /**
   * Answers the reports of the stream while the preview picture is being loaded: the
   * first frame of the chapter stands in this picture as soon as the buffer of it has been
   * filled or flushed, and a chapter that can not be loaded at all is never previewed
   * again.
   * @param code the code of the net status event of the stream or of the connection
   */
  private function previewStatus(code:String):void
  {
    application.trace("<" + this + " VideoPicture previewStatus> called.", 1);
    application.trace("<" + this + " VideoPicture previewStatus> code: " + code, 0);
    if (code == CODE_BUFFER_FULL || code == CODE_BUFFER_FLUSH || code == CODE_PLAY_STOP)
    {
      holdPreview();
      return;
    }
    if (code == CODE_PLAY_FAILED || code == CODE_PLAY_NOT_FOUND)
    {
      application.trace("<" + this + " VideoPicture previewStatus> this chapter could not be previewed: " + url, 6);
      previewFailed = true;
      dropPreview();
    }
  }
  /**
   * Logs the error of a callback of the stream this picture does not answer: every one of
   * them stands on the client object above, so this is only the last resort.
   * @param e the async error event of the stream
   */
  private function asyncError(e:AsyncErrorEvent):void
  {
    application.trace("<" + this + " VideoPicture asyncError> called.", 1);
    application.trace("<" + this + " VideoPicture asyncError> e: " + e, 0);
    application.trace("<" + this + " VideoPicture asyncError> the stream has reported something nobody answers: " + e.text, 7);
  }
  /**
   * Creates the video object the picture of the stream is displayed on.
   */
  private function createVideo():void
  {
    application.trace("<" + this + " VideoPicture createVideo> called.", 1);
    dropVideo();
    if (netStream == null)
    {
      application.trace("<" + this + " VideoPicture createVideo> there is no stream to be displayed.", 1);
      return;
    }
    video = new Video();
    pictureSprite.addChild(video);
    video.smoothing = true;
    displayVideoDimensions();
    video.attachNetStream(netStream);
  }
  /**
   * Frees up the video object the picture of the stream is displayed on.
   */
  private function dropVideo():void
  {
    application.trace("<" + this + " VideoPicture dropVideo> called.", 1);
    if (video != null)
    {
      video.attachNetStream(null);
      video.clear();
      if (pictureSprite != null && pictureSprite.contains(video))
      {
        pictureSprite.removeChild(video);
      }
      video = null;
    }
  }
  /**
   * Draws the video object in the dimensions of this picture: a video object of no
   * dimensions at all would draw nothing, so the smallest of them is one single pixel.
   */
  private function displayVideoDimensions():void
  {
    application.trace("<" + this + " VideoPicture displayVideoDimensions> called.", 1);
    if (video != null)
    {
      video.width = Math.max(1, getDw());
      video.height = Math.max(1, getDh());
    }
  }
  /**
   * Draws the mask of the picture in the current colors and radius of the application,
   * over the very room that picture is drawn inside. That mask keeps the video inside the
   * rounded corners of the appearance that is on.
   */
  private function redrawMaskShape():void
  {
    application.trace("<" + this + " VideoPicture redrawMaskShape> called.", 1);
    maskShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorMid()
        , 0
        , application.getDynamicsConfig().getAppBackgroundColorBright());
    maskShape.setRadius(application.getDynamicsConfig().getAppRadius());
    maskShape.setDwh(getDw(), getDh());
    maskShape.drawRect();
  }
  /**
   * Draws the mask of the picture again after the appearance of the application has been
   * changed: the radius and the colors of it are the ones that mask is built of.
   * @param e the radius or background color changed event of the application
   */
  private function appearanceChanged(e:Event):void
  {
    application.trace("<" + this + " VideoPicture appearanceChanged> called.", 1);
    application.trace("<" + this + " VideoPicture appearanceChanged> e: " + e, 0);
    redrawMaskShape();
  }
  /**
   * Takes the volume of the stream of this picture from the volume of this picture itself:
   * a muted picture plays no sound at all, and the sound volume of the application takes no
   * part in this, because that one is the volume of the sound effects. The stream of a
   * preview picture that is being loaded is left muted, because the frame of the beginning
   * of the chapter arrives together with the sound of it: the holdPreview above is the one
   * calling this again as soon as that frame stands in this picture.
   */
  private function soundVolumeChanged():void
  {
    application.trace("<" + this + " VideoPicture soundVolumeChanged> called.", 1);
    soundTransform = new SoundTransform();
    soundTransform.volume = soundMuted ? 0 : soundVolume / 100;
    if (netStream != null && !previewLoading)
    {
      netStream.soundTransform = soundTransform;
    }
  }
  /**
   * Dispatches the changed event of this picture: the metadata of the file of the chapter
   * has arrived, so the dimensions and the length of it are known from now on.
   */
  private function dispatchEventChanged():void
  {
    application.trace("<" + this + " VideoPicture dispatchEventChanged> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventChanged);
  }
  /**
   * Dispatches the stopped by end event of this picture: the chapter has come to its end.
   */
  private function dispatchEventStoppedByEnd():void
  {
    application.trace("<" + this + " VideoPicture dispatchEventStoppedByEnd> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventStoppedByEnd);
  }
  /**
   * Dispatches the cleared event of this picture: the chapter can not be played at all,
   * so the stream of it has been dropped.
   */
  private function dispatchEventCleared():void
  {
    application.trace("<" + this + " VideoPicture dispatchEventCleared> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventCleared);
  }
  /**
   * Closes the stream of the video and frees all listeners, events and references held by
   * this picture.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " VideoPicture destroy> called.", 1);
    application.trace("<" + this + " VideoPicture destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
    application.trace("<" + this + " VideoPicture destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    // the preview picture is switched off in front of the drop below, so that no stream of
    // it is opened while this picture is being freed up
    preview = false;
    playing = false;
    paused = false;
    dropPreview();
    eventChanged.stopImmediatePropagation();
    eventStoppedByEnd.stopImmediatePropagation();
    eventCleared.stopImmediatePropagation();
    pictureSprite.mask = null;
    application.trace("<" + this + " VideoPicture destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    url = null;
    netConnection = null;
    netStream = null;
    video = null;
    pictureSprite = null;
    maskShape = null;
    soundTransform = null;
    soundVolume = 0;
    soundMuted = false;
    previewLoading = false;
    previewHeld = false;
    previewFailed = false;
    metaDw = 0;
    metaDh = 0;
    metaSecs = 0;
    eventChanged = null;
    eventStoppedByEnd = null;
    eventCleared = null;
  }
}
/**
 * ChapterTitle: the name of the chapter one VideoPlayer stands on.
 * It carries one label of that name, broken into as many lines as the width it is given
 * asks for, and the room this whole surface takes is the room of that label. The name
 * stands under the picture of the video, on the background of the player, so it covers no
 * video at all and it belongs to no layer that is taken off one: it is displayed as long as
 * the player stands on a chapter, and this object holds no timer of its own at all.
 */
internal class ChapterTitle extends BaseSprite
{
  private var textLabel:TextLabel = null;
  /**
   * Constructs the ChapterTitle object: creates the label of the name and starts to follow
   * the dimensions of it, because the room this whole surface takes is the room of that
   * label.
   * @param applicationRef the main application reference
   */
  public function ChapterTitle(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " ChapterTitle> called.", 1);
    application.trace("<" + this + " ChapterTitle> applicationRef: " + applicationRef, 0);
    textLabel = new TextLabel(application);
    addChild(textLabel);
    textLabel.setLabel(" ");
    textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), textLabelResized);
    textLabelResized();
    application.trace("<" + this + " ChapterTitle> constructed.", 1);
  }
  /**
   * Returns the name of the chapter standing in this object.
   */
  public function getName():String
  {
    return textLabel.getLabel();
  }
  /**
   * Takes the name of the chapter this object has to display.
   * @param n the new name of the chapter
   */
  public function setName(n:String):void
  {
    application.trace("<" + this + " ChapterTitle setName> called.", 1);
    application.trace("<" + this + " ChapterTitle setName> n: " + n, 0);
    textLabel.setLabel(n);
  }
  /**
   * Sets the width the name has to be kept inside: it is broken into as many lines as that
   * width asks for.
   * @param newWidth the maximum width of the name
   */
  public function setMaxWidth(newWidth:int):void
  {
    application.trace("<" + this + " ChapterTitle setMaxWidth> called.", 1);
    application.trace("<" + this + " ChapterTitle setMaxWidth> newWidth: " + newWidth, 0);
    textLabel.setMaxWidth(newWidth, true);
  }
  /**
   * Takes the dimensions of this surface from the label of the name: the picture of the
   * video and the controls of the player are placed by exactly those dimensions.
   * @param e the dimensions changed event of that label, null on a direct call
   */
  private function textLabelResized(e:Event = null):void
  {
    application.trace("<" + this + " ChapterTitle textLabelResized> called.", 1);
    application.trace("<" + this + " ChapterTitle textLabelResized> e: " + e, 0);
    setDwh(textLabel.getDw(), textLabel.getDh());
  }
  /**
   * Frees up the label and every reference held by this name.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " ChapterTitle destroy> called.", 1);
    application.trace("<" + this + " ChapterTitle destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.trace("<" + this + " ChapterTitle destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    application.trace("<" + this + " ChapterTitle destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    textLabel = null;
  }
}
/**
 * ChapterList: the list the chapters of the video of one VideoPlayer can be picked from.
 * It carries the button opening and closing that list, the back standing under it and the
 * list itself. The back is the one carrying the background of the names: it stands under
 * them, because a list of this framework draws the frame of its own scroll over its items
 * and not under them. A list that is open is closed by a click next to it as well, and it
 * tells the owner of it by three events that a new chapter has been picked and that it has
 * been opened or closed.
 */
internal class ChapterList extends BaseSprite
{
  private var buttonLink:ButtonLink = null;
  private var backShape:BaseShape = null;
  private var listPanel:ListPanel = null;
  // the number of the chapters in this list, the index of the one the player stands on and
  // the index of the one that has been picked last
  private var numOfChapters:int = 0;
  private var selectedIndex:int = -1;
  private var pickedIndex:int = -1;
  private var eventChanged:Event = null;
  private var eventOpened:Event = null;
  private var eventClosed:Event = null;
  /**
   * Constructs the ChapterList object: creates the button opening the list, the back of it
   * and the list itself. That list holds exactly one selected item, the very chapter the
   * player stands on, and it reports every click on an item of it, the one on that selected
   * chapter as well, because such a click closes the list and leaves the playing alone.
   * @param applicationRef the main application reference
   */
  public function ChapterList(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " ChapterList> called.", 1);
    application.trace("<" + this + " ChapterList> applicationRef: " + applicationRef, 0);
    eventChanged = new Event(EnumEvents.EVENT_CHANGED());
    eventOpened = new Event(EnumEvents.EVENT_OPENED());
    eventClosed = new Event(EnumEvents.EVENT_CLOSED());
    buttonLink = new ButtonLink(application);
    addChild(buttonLink);
    buttonLink.setIcon(EnumIcons.listing());
    buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), buttonLinkClicked);
    buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
    // the back of the list is added in front of the list itself, so it stands under it on
    // the screen: the names of the chapters could not be read over a moving picture
    backShape = new BaseShape(application);
    addChild(backShape);
    backShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
    backShape.visible = false;
    listPanel = new ListPanel(application);
    addChild(listPanel);
    listPanel.visible = false;
    listPanel.setMultiple(false);
    listPanel.setCanBeEmpty(false);
    listPanel.setAlwaysDispatchSelectedEvent(true);
    listPanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), listPanelChanged);
    application.trace("<" + this + " ChapterList> constructed.", 1);
  }
  /**
   * Returns the index of the chapter that has been picked from this list last.
   */
  public function getPickedIndex():int
  {
    return pickedIndex;
  }
  /**
   * Takes the chapters this list has to display and marks the one the player stands on,
   * silently: nobody has picked that chapter from the list. A video that has no chapter to
   * be picked at all is left with no button of the list either, and an open one is closed
   * right away.
   * @param names the names of the chapters, the ones to be displayed
   * @param urls the urls of the chapters, in the order of the names
   * @param index the index of the chapter the player stands on
   */
  public function setChapters(names:Array, urls:Array, index:int):void
  {
    application.trace("<" + this + " ChapterList setChapters> called.", 1);
    application.trace("<" + this + " ChapterList setChapters> names: " + names, 0);
    application.trace("<" + this + " ChapterList setChapters> urls: " + urls, 0);
    application.trace("<" + this + " ChapterList setChapters> index: " + index, 0);
    numOfChapters = names == null ? 0 : names.length;
    selectedIndex = index;
    listPanel.setArrays(names, urls);
    if (selectedIndex > -1)
    {
      listPanel.setSelectedIndexes([selectedIndex], false);
    }
    else
    {
      listPanel.clearSelectedIndexes();
    }
    // the button of the list is taken away completely and not only switched off, exactly
    // the way the two chapter buttons of a video that is never stepped are
    const pickable:Boolean = hasPickableChapters();
    buttonLink.setSpriteVisible(pickable);
    if (!pickable)
    {
      close();
    }
  }
  /**
   * Tells whether this list is open at the moment.
   */
  public function isOpened():Boolean
  {
    return listPanel != null && listPanel.visible;
  }
  /**
   * Opens this list: it stands scrolled onto the chapter the player is on, so the one that
   * is playing is the one in the picture of it. A list that is switched off, one that has
   * no chapter to be picked at all and one that is too small to display one single name
   * have nothing to open.
   */
  public function open():void
  {
    application.trace("<" + this + " ChapterList open> called.", 1);
    if (isOpened())
    {
      application.trace("<" + this + " ChapterList open> this list is open already.", 1);
      return;
    }
    if (!getEnabled())
    {
      application.trace("<" + this + " ChapterList open> this list is switched off.", 1);
      return;
    }
    if (!hasPickableChapters())
    {
      application.trace("<" + this + " ChapterList open> there is no chapter to be picked.", 1);
      return;
    }
    if (getPanelDw() < 1 || listPanel.getNumOfElements() < 1)
    {
      application.trace("<" + this + " ChapterList open> the picture of the video is too small to display this list.", 1);
      return;
    }
    listPanel.visible = true;
    backShape.visible = true;
    // the list stands on the chapter the player is on: a video of more chapters than it
    // displays at the same time is scrolled onto that chapter
    listPanel.setStartIndex(Math.min(numOfChapters - listPanel.getNumOfElements(), selectedIndex));
    if (stage != null)
    {
      stage.addEventListener(MouseEvent.MOUSE_DOWN, hasToClose, false, 0, true);
    }
    dispatchEventOpened();
  }
  /**
   * Closes this list and leaves the playing of the player exactly the way it is. A list
   * that is not open at all has nothing to close.
   */
  public function close():void
  {
    application.trace("<" + this + " ChapterList close> called.", 1);
    if (!isOpened())
    {
      application.trace("<" + this + " ChapterList close> there is no list to be closed.", 1);
      return;
    }
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToClose);
    }
    listPanel.visible = false;
    backShape.visible = false;
    dispatchEventClosed();
  }
  /**
   * Enables or disables this list: a disabled one can not be opened and no chapter of it
   * can be picked any more.
   * @param e true when this list has to be enabled
   */
  override public function setEnabled(e:Boolean):void
  {
    application.trace("<" + this + " ChapterList setEnabled> called.", 1);
    application.trace("<" + this + " ChapterList setEnabled> e: " + e, 0);
    super.setEnabled(e);
    buttonLink.setEnabled(getEnabled());
    listPanel.setEnabled(getEnabled());
    // the button and the list standing on this surface carry the look of a disabled object
    // themselves, so the surface itself is left untouched: two alphas over each other would
    // make them darker than every other disabled object of the application
    alpha = 1;
  }
  /**
   * Sets the room this list is laid out inside: the width of it is the one standing between
   * the button opening it and the end of that room, and the height is the one of the picture
   * of the video, so the list is never taller than that picture.
   * @param newdw the new width of that room
   * @param newdh the new height of that room
   */
  override public function setDwh(newdw:int, newdh:int):void
  {
    application.trace("<" + this + " ChapterList setDwh> called.", 1);
    application.trace("<" + this + " ChapterList setDwh> newdw: " + newdw, 0);
    application.trace("<" + this + " ChapterList setDwh> newdh: " + newdh, 0);
    super.setDwh(newdw, newdh);
    reposElements();
  }
  /**
   * Renders this list in its initialized state as soon as it gets onto the stage.
   * @param e the added to stage event
   */
  override protected function addedToStage(e:Event):void
  {
    application.trace("<" + this + " ChapterList addedToStage> called.", 1);
    application.trace("<" + this + " ChapterList addedToStage> e: " + e, 0);
    super.addedToStage(e);
    reposElements();
  }
  /**
   * Closes this list as soon as it leaves the stage, so that the listener watching the
   * clicks next to it is unregistered while that stage is still reachable.
   * @param e the removed from stage event
   */
  override protected function removedFromStage(e:Event):void
  {
    application.trace("<" + this + " ChapterList removedFromStage> called.", 1);
    application.trace("<" + this + " ChapterList removedFromStage> e: " + e, 0);
    close();
    super.removedFromStage(e);
  }
  /**
   * Tells whether there is a chapter to be picked from this list at all: a video of one
   * single chapter or of no chapter at all has none.
   */
  private function hasPickableChapters():Boolean
  {
    return numOfChapters > 1;
  }
  /**
   * Returns the width the names of the chapters are displayed inside: the room of this
   * object without the button opening it.
   */
  private function getPanelDw():int
  {
    return Math.max(0, getDw() - buttonLink.getCx(true));
  }
  /**
   * Returns the number of the chapters this list displays at the same time: as many of
   * them as the picture of the video holds, one padding of the application left under
   * them, so the list is always lower than that picture. A picture that is too small to
   * display one single name gives a zero.
   */
  private function getPanelNumOfElements():int
  {
    application.trace("<" + this + " ChapterList getPanelNumOfElements> called.", 1);
    // the list draws one padding around its items on every side, and one more of them is
    // the room it keeps away from the bottom of the picture
    const room:int = getDh() - 3 * application.getDynamicsConfig().getAppPadding();
    const itemDh:int = application.getDynamicsConfig().getTextFieldHeight(listPanel.getTextType());
    return room > 0 && itemDh > 0 ? int(room / itemDh) : 0;
  }
  /**
   * Places the button opening this list into the corner of it, places the names of the
   * chapters right next to that button and lays them out from the room this object is
   * given.
   */
  private function reposElements():void
  {
    application.trace("<" + this + " ChapterList reposElements> called.", 1);
    buttonLink.setCxy(0, 0);
    listPanel.setCxy(buttonLink.getCx(true), 0);
    listPanel.setDw(getPanelDw());
    listPanel.setNumOfElements(getPanelNumOfElements());
    redrawBackShape();
  }
  /**
   * Draws the back of this list onto the very room the names of the chapters take: it lets
   * a little of the picture of the video through and it keeps those names readable at the
   * same time.
   */
  private function redrawBackShape():void
  {
    application.trace("<" + this + " ChapterList redrawBackShape> called.", 1);
    backShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorMid()
        , application.getComponentsConfig().getVideoPlayerChapterListAlpha()
        , application.getDynamicsConfig().getAppBackgroundColorBright());
    backShape.setRadius(application.getDynamicsConfig().getAppRadius());
    backShape.setBox(application.getDynamicsConfig().getAppBoxCorner()
        , application.getDynamicsConfig().getAppBoxFrame());
    backShape.setDwh(listPanel.getDw(), listPanel.getDh());
    backShape.x = listPanel.getCx();
    backShape.y = listPanel.getCy();
    backShape.drawRect();
  }
  /**
   * Opens this list on a click on the button of it, and closes an open one: that very
   * button is the one carrying both of them.
   * @param e the click event of that button
   */
  private function buttonLinkClicked(e:Event):void
  {
    application.trace("<" + this + " ChapterList buttonLinkClicked> called.", 1);
    application.trace("<" + this + " ChapterList buttonLinkClicked> e: " + e, 0);
    if (isOpened())
    {
      close();
      return;
    }
    open();
  }
  /**
   * Lays this list out again after the button of it has taken new dimensions: a new font
   * size gives it another size, and the names of the chapters stand right next to it.
   * @param e the dimensions changed event of that button
   */
  private function buttonLinkResized(e:Event):void
  {
    application.trace("<" + this + " ChapterList buttonLinkResized> called.", 1);
    application.trace("<" + this + " ChapterList buttonLinkResized> e: " + e, 0);
    reposElements();
  }
  /**
   * Closes this list and tells the owner of it that another chapter has been picked. A
   * click on the chapter the player stands on already picks nothing new, so nothing is
   * reported there, exactly the way a click next to this list reports nothing.
   * @param e the changed event of the list of the names
   */
  private function listPanelChanged(e:Event):void
  {
    application.trace("<" + this + " ChapterList listPanelChanged> called.", 1);
    application.trace("<" + this + " ChapterList listPanelChanged> e: " + e, 0);
    pickedIndex = int(listPanel.getSelectedIndexes()[0]);
    close();
    if (pickedIndex == selectedIndex)
    {
      application.trace("<" + this + " ChapterList listPanelChanged> the player stands on that chapter already.", 1);
      return;
    }
    dispatchEventChanged();
  }
  /**
   * Closes this list as soon as the mouse has been pressed next to it: the playing of the
   * player is left exactly the way it is by that click.
   * @param e the mouse down event of the stage
   */
  private function hasToClose(e:MouseEvent):void
  {
    application.trace("<" + this + " ChapterList hasToClose> called.", 1);
    application.trace("<" + this + " ChapterList hasToClose> e: " + e, 0);
    if (!mouseIsOnTheList())
    {
      close();
    }
  }
  /**
   * Tells whether the mouse stands on the names of the chapters or on the button opening
   * them. That button belongs to this list as well: a click on it closes an open list by
   * the very button that has opened it and not by the listener above.
   */
  private function mouseIsOnTheList():Boolean
  {
    application.trace("<" + this + " ChapterList mouseIsOnTheList> called.", 1);
    return mouseIsOnTheSprite(listPanel) || mouseIsOnTheSprite(buttonLink);
  }
  /**
   * Tells whether the mouse stands inside the dimensions of the given object.
   * @param baseSprite the object the mouse is asked about
   */
  private function mouseIsOnTheSprite(baseSprite:BaseSprite):Boolean
  {
    application.trace("<" + this + " ChapterList mouseIsOnTheSprite> called.", 1);
    application.trace("<" + this + " ChapterList mouseIsOnTheSprite> baseSprite: " + baseSprite, 0);
    return baseSprite.mouseX >= 0 && baseSprite.mouseX <= baseSprite.getDw()
        && baseSprite.mouseY >= 0 && baseSprite.mouseY <= baseSprite.getDh();
  }
  /**
   * Dispatches the changed event of this list: another chapter has been picked from it.
   */
  private function dispatchEventChanged():void
  {
    application.trace("<" + this + " ChapterList dispatchEventChanged> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventChanged);
  }
  /**
   * Dispatches the opened event of this list: the button of it has been pressed or the
   * owner of it has opened it, so it stands over the picture of the video from now on.
   */
  private function dispatchEventOpened():void
  {
    application.trace("<" + this + " ChapterList dispatchEventOpened> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventOpened);
  }
  /**
   * Dispatches the closed event of this list: it has been closed by the button of it, by a
   * click next to it, by the picking of a chapter or by the owner of it.
   */
  private function dispatchEventClosed():void
  {
    application.trace("<" + this + " ChapterList dispatchEventClosed> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventClosed);
  }
  /**
   * Frees all listeners, events and references held by this list.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " ChapterList destroy> called.", 1);
    application.trace("<" + this + " ChapterList destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToClose);
    }
    application.trace("<" + this + " ChapterList destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    eventChanged.stopImmediatePropagation();
    eventOpened.stopImmediatePropagation();
    eventClosed.stopImmediatePropagation();
    application.trace("<" + this + " ChapterList destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    buttonLink = null;
    backShape = null;
    listPanel = null;
    numOfChapters = 0;
    selectedIndex = 0;
    pickedIndex = 0;
    eventChanged = null;
    eventOpened = null;
    eventClosed = null;
  }
}
/**
 * SeekBar: the seek bar of one VideoPlayer.
 * It carries the icon the playing is dragged with and the line that icon travels along:
 * the whole chapter is drawn in the dark font color of the application and the part of it
 * that has arrived so far in the bright one, so the one watching the video sees how much
 * of it is on the machine already. It keeps the room of the two displayed times at the two
 * ends of the line it is given, and it tells the owner of it by one single event that the
 * playing has to go on from another point of the chapter.
 */
internal class SeekBar extends BaseSprite
{
  private var seekIcon:Icon = null;
  private var bufferDraw:Shape = null;
  // the area the icon can be dragged inside and the state of that dragging
  private var seekRect:Rectangle = null;
  private var dragged:Boolean = false;
  private var seekable:Boolean = false;
  // the length of the chapter, the seconds played so far, the ones that have arrived over
  // them and the point the last drag has taken the playing to
  private var chapterSecs:int = 0;
  private var progressSecs:int = 0;
  private var bufferSecs:int = 0;
  private var seekToSecs:int = 0;
  private var eventChanged:Event = null;
  /**
   * Constructs the SeekBar object: creates the line and the icon of the seeking and starts
   * to follow the font colors, the font size and the line thickness of the application.
   * @param applicationRef the main application reference
   */
  public function SeekBar(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " SeekBar> called.", 1);
    application.trace("<" + this + " SeekBar> applicationRef: " + applicationRef, 0);
    eventChanged = new Event(EnumEvents.EVENT_CHANGED());
    bufferDraw = new Shape();
    addChild(bufferDraw);
    seekIcon = new Icon(application);
    addChild(seekIcon);
    seekIcon.mouseDownForScrollingEnabled = false;
    redrawSeekIcon();
    reposElements();
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawSeekIcon);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
    application.trace("<" + this + " SeekBar> constructed.", 1);
  }
  /**
   * Returns the length of the chapter this bar travels along in seconds, a zero while that
   * length is not known yet.
   */
  public function getChapterSecs():int
  {
    return chapterSecs;
  }
  /**
   * Takes the length of the chapter this bar travels along: the point of the icon and the
   * part of the chapter that has arrived so far are both counted from it.
   * @param secs the length of the chapter in seconds, a zero while it is not known yet
   */
  public function setChapterSecs(secs:int):void
  {
    application.trace("<" + this + " SeekBar setChapterSecs> called.", 1);
    application.trace("<" + this + " SeekBar setChapterSecs> secs: " + secs, 0);
    chapterSecs = secs;
    displayTheProgress();
  }
  /**
   * Tells whether the icon of this bar can be dragged at the moment.
   */
  public function getSeekable():Boolean
  {
    return seekable;
  }
  /**
   * Tells this bar whether the icon of it can be dragged: only a player that is playing
   * something has a point to be seeked to, so the dragging of one standing still is
   * stopped and switched off here.
   * @param b true when the icon can be dragged
   */
  public function setSeekable(b:Boolean):void
  {
    application.trace("<" + this + " SeekBar setSeekable> called.", 1);
    application.trace("<" + this + " SeekBar setSeekable> b: " + b, 0);
    seekable = b;
    if (seekable)
    {
      seekIcon.addEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
      return;
    }
    stopTheDragging();
    seekIcon.removeEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
  }
  /**
   * Returns the second of the chapter the last drag of the icon has taken the playing to.
   */
  public function getSeekToSecs():int
  {
    return seekToSecs;
  }
  /**
   * Tells whether the icon of this bar is being dragged at the moment.
   */
  public function isDragged():Boolean
  {
    return dragged;
  }
  /**
   * Displays the point the playing has come to: the icon is moved onto it and the part of
   * the chapter that has arrived so far is drawn again. An icon that is being dragged is
   * left where the hand holds it.
   * @param newProgressSecs the seconds of the chapter played so far
   * @param newBufferSecs the seconds that have arrived over the played ones
   */
  public function displayProgress(newProgressSecs:int, newBufferSecs:int):void
  {
    application.trace("<" + this + " SeekBar displayProgress> called.", 1);
    application.trace("<" + this + " SeekBar displayProgress> newProgressSecs: " + newProgressSecs, 0);
    application.trace("<" + this + " SeekBar displayProgress> newBufferSecs: " + newBufferSecs, 0);
    progressSecs = newProgressSecs;
    bufferSecs = newBufferSecs;
    displayTheProgress();
  }
  /**
   * Sets the width of the line the icon of this bar travels along: the room of the two
   * displayed times is kept at the two ends of it, so the icon never covers them.
   * @param newdw the new width of that line
   */
  override public function setDw(newdw:int):void
  {
    application.trace("<" + this + " SeekBar setDw> called.", 1);
    application.trace("<" + this + " SeekBar setDw> newdw: " + newdw, 0);
    super.setDw(newdw);
    reposElements();
  }
  /**
   * Renders this bar in its initialized state as soon as it gets onto the stage.
   * @param e the added to stage event
   */
  override protected function addedToStage(e:Event):void
  {
    application.trace("<" + this + " SeekBar addedToStage> called.", 1);
    application.trace("<" + this + " SeekBar addedToStage> e: " + e, 0);
    super.addedToStage(e);
    reposElements();
  }
  /**
   * Stops the dragging of the icon as soon as this bar leaves the stage, so that the
   * listener watching the end of that dragging is unregistered while the stage is still
   * reachable.
   * @param e the removed from stage event
   */
  override protected function removedFromStage(e:Event):void
  {
    application.trace("<" + this + " SeekBar removedFromStage> called.", 1);
    application.trace("<" + this + " SeekBar removedFromStage> e: " + e, 0);
    stopTheDragging();
    super.removedFromStage(e);
  }
  /**
   * Returns the x coordinate the icon stands at at the beginning of the chapter: the
   * beginning of this bar, with the room of the time played so far left in front of it.
   */
  private function getIconInix():int
  {
    return 2 * application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
  }
  /**
   * Returns the distance the icon travels from the beginning of the chapter to the end of
   * it: the width of this bar, with the room of the two displayed times left at the two
   * ends of it.
   */
  private function getIconDragWidth():int
  {
    return Math.max(0, getDw() - 4 * application.getDynamicsConfig()
        .getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) - seekIcon.getDw());
  }
  /**
   * Moves the icon onto the point the playing has come to and draws the part of the chapter
   * that has arrived so far. An icon that is being dragged is left where the hand holds it:
   * the point of the playing is the one following that hand and not the other way round.
   */
  private function displayTheProgress():void
  {
    application.trace("<" + this + " SeekBar displayTheProgress> called.", 1);
    if (!dragged)
    {
      moveIconToProgress();
    }
    redrawBufferDraw();
  }
  /**
   * Moves the icon onto the point the playing has come to. A chapter whose length is not
   * known yet takes that icon back to the beginning of this bar: there is nothing to count
   * the point of it from.
   */
  private function moveIconToProgress():void
  {
    application.trace("<" + this + " SeekBar moveIconToProgress> called.", 1);
    const inix:int = getIconInix();
    if (chapterSecs < 1)
    {
      application.trace("<" + this + " SeekBar moveIconToProgress> the length of this chapter is not known yet.", 1);
      seekIcon.setCxy(inix, 0);
      return;
    }
    const dragWidth:int = getIconDragWidth();
    seekIcon.setCxy(Math.max(inix, Math.min(inix + dragWidth
        , inix + dragWidth * progressSecs / chapterSecs)), 0);
  }
  /**
   * Lays this bar out: the height of it is the one of the icon, that icon stands on the
   * point the playing has come to and the area it can be dragged inside is taken again.
   */
  private function reposElements():void
  {
    application.trace("<" + this + " SeekBar reposElements> called.", 1);
    setDwh(getDw(), seekIcon.getDh());
    seekRect = new Rectangle(getIconInix(), 0, getIconDragWidth());
    displayTheProgress();
  }
  /**
   * Draws the icon of the seeking in the current bright font color of the application.
   * @param e the bright font color changed event of the application, null on a direct call
   */
  private function redrawSeekIcon(e:Event = null):void
  {
    application.trace("<" + this + " SeekBar redrawSeekIcon> called.", 1);
    application.trace("<" + this + " SeekBar redrawSeekIcon> e: " + e, 0);
    const textType:String = EnumTextTypes.TEXT_TYPE_BRIGHT();
    seekIcon.drawBitmapData(EnumIcons.potmeter(), textType
        , application.getDynamicsConfig().getTextFieldHeight(textType));
  }
  /**
   * Draws the line the icon travels along: the whole chapter in the dark font color of the
   * application and the part of it that has arrived so far in the bright one, so the one
   * watching the video sees how much of it is on the machine already.
   * @param e the font color or line thickness changed event of the application, null on a
   * direct call
   */
  private function redrawBufferDraw(e:Event = null):void
  {
    application.trace("<" + this + " SeekBar redrawBufferDraw> called.", 1);
    application.trace("<" + this + " SeekBar redrawBufferDraw> e: " + e, 0);
    const thickness:int = 2 * application.getDynamicsConfig().getAppLineThickness();
    const fromX:int = getIconInix() + seekIcon.getDw() / 2;
    const dragWidth:int = getIconDragWidth();
    bufferDraw.graphics.clear();
    bufferDraw.graphics.lineStyle(thickness, application.getDynamicsConfig().getAppFontColorDark());
    bufferDraw.graphics.moveTo(fromX, 0);
    bufferDraw.graphics.lineTo(fromX + dragWidth, 0);
    if (chapterSecs < 1)
    {
      application.trace("<" + this + " SeekBar redrawBufferDraw> the length of this chapter is not known yet.", 1);
      return;
    }
    const arrivedX:int = fromX + Math.min(dragWidth
        , dragWidth * (progressSecs + bufferSecs) / chapterSecs);
    bufferDraw.graphics.lineStyle(thickness, application.getDynamicsConfig().getAppFontColorBright());
    bufferDraw.graphics.moveTo(fromX, 0);
    bufferDraw.graphics.lineTo(arrivedX, 0);
  }
  /**
   * Draws the icon of the seeking in the new size and lays this bar out again after the
   * font size of the application has been changed: the room of the displayed times and the
   * size of that icon are both measured from it.
   * @param e the font size changed event of the application
   */
  private function fontSizeChanged(e:Event):void
  {
    application.trace("<" + this + " SeekBar fontSizeChanged> called.", 1);
    application.trace("<" + this + " SeekBar fontSizeChanged> e: " + e, 0);
    redrawSeekIcon();
    reposElements();
  }
  /**
   * Starts the dragging of the icon.
   * @param e the mouse down event of that icon
   */
  private function seekIconMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " SeekBar seekIconMouseDown> called.", 1);
    application.trace("<" + this + " SeekBar seekIconMouseDown> e: " + e, 0);
    dragged = true;
    seekIcon.startDrag(false, seekRect);
    if (stage != null)
    {
      stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
    }
  }
  /**
   * Stops the dragging of the icon and tells the owner of this bar the point the playing
   * has to go on from. A bar the icon can not travel along at all has nothing to be seeked
   * in.
   * @param e the mouse up event of the stage
   */
  private function stageMouseUp(e:MouseEvent):void
  {
    application.trace("<" + this + " SeekBar stageMouseUp> called.", 1);
    application.trace("<" + this + " SeekBar stageMouseUp> e: " + e, 0);
    stopTheDragging();
    const dragWidth:int = getIconDragWidth();
    if (dragWidth < 1)
    {
      application.trace("<" + this + " SeekBar stageMouseUp> there is nothing to be seeked in.", 1);
      return;
    }
    // the dragging moves the icon itself and not the coordinates this framework holds of
    // it, so the point it has been taken to is read from the icon
    seekToSecs = chapterSecs * (seekIcon.x - getIconInix()) / dragWidth;
    application.trace("<" + this + " SeekBar stageMouseUp> seekToSecs: " + seekToSecs, 0);
    dispatchEventChanged();
  }
  /**
   * Stops the dragging of the icon and unregisters the listener watching the end of it.
   */
  private function stopTheDragging():void
  {
    application.trace("<" + this + " SeekBar stopTheDragging> called.", 1);
    dragged = false;
    seekIcon.stopDrag();
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
    }
  }
  /**
   * Dispatches the changed event of this bar: the icon of it has been dragged onto another
   * point of the chapter.
   */
  private function dispatchEventChanged():void
  {
    application.trace("<" + this + " SeekBar dispatchEventChanged> called.", 1);
    getBaseEventDispatcher().dispatchEvent(eventChanged);
  }
  /**
   * Stops the dragging and frees all listeners, events and references held by this bar.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " SeekBar destroy> called.", 1);
    application.trace("<" + this + " SeekBar destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawSeekIcon);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), redrawBufferDraw);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
    seekIcon.removeEventListener(MouseEvent.MOUSE_DOWN, seekIconMouseDown);
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
    }
    application.trace("<" + this + " SeekBar destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    seekIcon.stopDrag();
    eventChanged.stopImmediatePropagation();
    bufferDraw.graphics.clear();
    application.trace("<" + this + " SeekBar destroy> calling the super destroy and clearing everything.", 0);
    super.destroy();
    seekIcon = null;
    bufferDraw = null;
    seekRect = null;
    dragged = false;
    seekable = false;
    chapterSecs = 0;
    progressSecs = 0;
    bufferSecs = 0;
    seekToSecs = 0;
    eventChanged = null;
  }
}
