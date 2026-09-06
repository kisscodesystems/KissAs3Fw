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
 * VideoPlayerUnitTest
 * Checks the VideoPlayer component.
 *
 * MAIN FEATURES:
 * - the chapters of the video: the arrays of them, the lengths that are not known yet
 *   and the stepping from one chapter to the other
 * - the chapter changed event: every step onto another chapter is reported once and a
 *   call that steps nowhere at all is reported by nothing
 * - the box the picture is drawn inside, the resizing of it by hand and the dimensions
 *   this component takes of it
 * - the sound of the video: the volume of it, the range that volume is kept inside and
 *   the muting that leaves that volume exactly where it stands
 * - the smallest width this player can be laid out in: a box narrower than that leaves
 *   this component as wide as its own controls need
 * - the states of the playing: a player is started, paused, continued and stopped here
 * - the preview picture: the switch of it and the box of the picture it leaves alone
 * - the fullscreen of the video: the switch and the states of it, the dimensions of the
 *   picture it draws and the room of this player it leaves the way it has been
 * - the list of the chapters: the switch and the states of it, the picture that is too
 *   small to hold it and the video that has no chapter to be picked from it
 * - the file of the chapter is a local one that does not exist at all: the states of
 *   the playing are the ones checked here, and a test run reaches no network
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.VideoPlayer;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  public class VideoPlayerUnitTest extends BaseUnitTest
  {
    // the chapters every test below works on: the files of them do not exist at all, so
    // a test run asks no server for anything
    private const CHAPTER_NAMES:Array = ["The opening", "The middle of it", "The closing"];
    private const CHAPTER_URLS:Array = ["aVideoThatDoesNotExist1.flv"
      , "aVideoThatDoesNotExist2.flv", "aVideoThatDoesNotExist3.flv"];
    // the number of the chapter changed events the tested player has dispatched so far
    private var chapterChangedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function VideoPlayerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "VideoPlayer";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      chapterChangedCount = 0;
      const videoPlayer:VideoPlayer = new VideoPlayer(application);
      addTested(videoPlayer);
      videoPlayer.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHAPTER_CHANGED(), videoPlayerChapterChanged);
      // a fresh player holds no chapter at all and it plays nothing
      assertEquals("getNumOfChapters of a fresh player", 0, videoPlayer.getNumOfChapters());
      assertEquals("getSelectedChapterIndex of a fresh player", -1
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("getChapterName of a fresh player", "", videoPlayer.getChapterName(0));
      assertEquals("getChapterUrl of a fresh player", "", videoPlayer.getChapterUrl(0));
      assertEquals("getChapterSecs of a fresh player", 0, videoPlayer.getChapterSecs(0));
      assertEquals("getTotalSecs of a fresh player", 0, videoPlayer.getTotalSecs());
      assertFalse("isPlaying of a fresh player", videoPlayer.isPlaying());
      assertFalse("isPaused of a fresh player", videoPlayer.isPaused());
      assertEquals("getProgressSecs of a fresh player", 0, videoPlayer.getProgressSecs());
      assertFalse("getAutoContinue of a fresh player", videoPlayer.getAutoContinue());
      assertFalse("getFrame of a fresh player", videoPlayer.getFrame());
      assertFalse("getResizable of a fresh player", videoPlayer.getResizable());
      assertTrue("getPreview of a fresh player", videoPlayer.getPreview());
      assertFalse("getFullscreenEnabled of a fresh player", videoPlayer.getFullscreenEnabled());
      assertFalse("isFullscreenOpened of a fresh player", videoPlayer.isFullscreenOpened());
      assertFalse("getChapterListEnabled of a fresh player"
        , videoPlayer.getChapterListEnabled());
      assertFalse("isChapterListOpened of a fresh player", videoPlayer.isChapterListOpened());
      assertEquals("getSoundVolume of a fresh player"
        , application.getComponentsConfig().getVideoPlayerSoundVolume()
        , videoPlayer.getSoundVolume());
      assertFalse("isSoundMuted of a fresh player", videoPlayer.isSoundMuted());
      assertTrue("getMinDw of a fresh player is a positive one", videoPlayer.getMinDw() > 0);
      assertEquals("getBoxDw of a fresh player", 0, videoPlayer.getBoxDw());
      assertEquals("getBoxDh of a fresh player", 0, videoPlayer.getBoxDh());
      assertEquals("getVideoDw of a fresh player", 0, videoPlayer.getVideoDw());
      assertEquals("getVideoDh of a fresh player", 0, videoPlayer.getVideoDh());
      runChapterTests(videoPlayer);
      runNavigationTests(videoPlayer);
      runDimensionsTests(videoPlayer);
      runResizableTests(videoPlayer);
      runPreviewTests(videoPlayer);
      runSoundTests(videoPlayer);
      runFrameAndContinueTests(videoPlayer);
      runPlayingTests(videoPlayer);
      runFullscreenTests(videoPlayer);
      runChapterListTests(videoPlayer);
      runEnabledTests(videoPlayer);
      runEmptyPlayerTests(videoPlayer);
      runBaseSpriteTests(videoPlayer);
      removeTested(videoPlayer);
    }
    /**
     * Checks the chapters of the video: two arrays that do not belong together are
     * refused, the ones that do are copied, and the length of a chapter that has not been
     * played yet is not known at all.
     * @param videoPlayer the object to be tested
     */
    private function runChapterTests(videoPlayer:VideoPlayer):void
    {
      videoPlayer.setChapters(null, null);
      assertEquals("two null arrays leave no chapter behind", 0, videoPlayer.getNumOfChapters());
      videoPlayer.setChapters(CHAPTER_NAMES.concat(), ["only one url"]);
      assertEquals("two arrays of a different length are refused", 0
        , videoPlayer.getNumOfChapters());
      assertEquals("a player that has got no chapter at all reports no chapter change", 0
        , chapterChangedCount);
      const names:Array = CHAPTER_NAMES.concat();
      const urls:Array = CHAPTER_URLS.concat();
      videoPlayer.setChapters(names, urls);
      assertEquals("getNumOfChapters after setChapters", CHAPTER_NAMES.length
        , videoPlayer.getNumOfChapters());
      assertEquals("one chapter changed event after setChapters", 1, chapterChangedCount);
      // the arrays are copied, so the ones of the caller can be used further on
      names.splice(0);
      urls.splice(0);
      assertEquals("the arrays of the chapters are copied", CHAPTER_NAMES.length
        , videoPlayer.getNumOfChapters());
      assertEquals("the first chapter is the one this player stands on", 0
        , videoPlayer.getSelectedChapterIndex());
      for (var i:int = 0; i < CHAPTER_NAMES.length; i++)
      {
        assertEquals("getChapterName of the index " + i, CHAPTER_NAMES[i]
          , videoPlayer.getChapterName(i));
        assertEquals("getChapterUrl of the index " + i, CHAPTER_URLS[i]
          , videoPlayer.getChapterUrl(i));
        assertEquals("the length of the chapter of the index " + i + " is not known yet", 0
          , videoPlayer.getChapterSecs(i));
      }
      assertEquals("getChapterName below the first chapter", "", videoPlayer.getChapterName(-1));
      assertEquals("getChapterName above the last chapter", ""
        , videoPlayer.getChapterName(CHAPTER_NAMES.length));
      assertEquals("getChapterUrl above the last chapter", ""
        , videoPlayer.getChapterUrl(CHAPTER_NAMES.length));
      assertEquals("getChapterSecs above the last chapter", 0
        , videoPlayer.getChapterSecs(CHAPTER_NAMES.length));
      assertEquals("getTotalSecs of a video nobody has played yet", 0, videoPlayer.getTotalSecs());
    }
    /**
     * Checks the stepping from one chapter to the other: an index outside the chapters is
     * refused, and the two ends of the video have nothing to step onto.
     * @param videoPlayer the object to be tested
     */
    private function runNavigationTests(videoPlayer:VideoPlayer):void
    {
      const lastIndex:int = CHAPTER_NAMES.length - 1;
      const countBefore:int = chapterChangedCount;
      videoPlayer.setSelectedChapterIndex(1);
      assertEquals("getSelectedChapterIndex after setSelectedChapterIndex", 1
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("one chapter changed event after setSelectedChapterIndex", countBefore + 1
        , chapterChangedCount);
      videoPlayer.setSelectedChapterIndex(-1);
      assertEquals("an index below the first chapter is refused", 1
        , videoPlayer.getSelectedChapterIndex());
      videoPlayer.setSelectedChapterIndex(CHAPTER_NAMES.length);
      assertEquals("an index above the last chapter is refused", 1
        , videoPlayer.getSelectedChapterIndex());
      videoPlayer.setSelectedChapterIndex(1);
      assertEquals("the very same index leaves this player where it stands", 1
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("a call that steps nowhere reports no chapter change", countBefore + 1
        , chapterChangedCount);
      videoPlayer.prevChapter();
      assertEquals("getSelectedChapterIndex after prevChapter", 0
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("one chapter changed event after prevChapter", countBefore + 2
        , chapterChangedCount);
      videoPlayer.prevChapter();
      assertEquals("the first chapter has nothing to step back onto", 0
        , videoPlayer.getSelectedChapterIndex());
      for (var i:int = 0; i < lastIndex; i++)
      {
        videoPlayer.nextChapter();
      }
      assertEquals("getSelectedChapterIndex after nextChapter", lastIndex
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("every step onto the next chapter is reported once"
        , countBefore + 2 + lastIndex, chapterChangedCount);
      videoPlayer.nextChapter();
      assertEquals("the last chapter has nothing to step onto", lastIndex
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("the two ends of the video report no chapter change"
        , countBefore + 2 + lastIndex, chapterChangedCount);
      videoPlayer.setSelectedChapterIndex(0);
    }
    /**
     * Checks the box the picture is drawn inside: a picture nobody knows the dimensions
     * of yet fills the whole box, and the height of this object holds the buttons of the
     * player as well.
     * @param videoPlayer the object to be tested
     */
    private function runDimensionsTests(videoPlayer:VideoPlayer):void
    {
      videoPlayer.setDwh(320, 180);
      assertEquals("getBoxDw after setDwh", 320, videoPlayer.getBoxDw());
      assertEquals("getBoxDh after setDwh", 180, videoPlayer.getBoxDh());
      assertEquals("a picture of unknown dimensions is as wide as the box", 320
        , videoPlayer.getVideoDw());
      assertEquals("a picture of unknown dimensions is as tall as the box", 180
        , videoPlayer.getVideoDh());
      assertEquals("getDw is the width of the box"
        , expectedDw(Math.max(320, videoPlayer.getMinDw())), videoPlayer.getDw());
      // a box narrower than the controls of the player need leaves that player as wide as
      // its own smallest width, and the picture inside it follows the box the way it does
      videoPlayer.setDwh(1, 1);
      assertEquals("a box narrower than the controls need gives the smallest width"
        , expectedDw(videoPlayer.getMinDw()), videoPlayer.getDw());
      assertTrue("getDh holds the buttons of the player as well"
        , videoPlayer.getDh() > videoPlayer.getVideoDh());
      videoPlayer.setDw(400);
      assertEquals("getBoxDw after setDw", 400, videoPlayer.getBoxDw());
      assertEquals("the picture follows the width of the box", 400, videoPlayer.getVideoDw());
      videoPlayer.setDh(200);
      assertEquals("getBoxDh after setDh", 200, videoPlayer.getBoxDh());
      assertEquals("the picture follows the height of the box", 200, videoPlayer.getVideoDh());
      // a player nobody has bounded holds no picture at all until one arrives
      videoPlayer.setDwh(0, 0);
      assertEquals("getBoxDw of an unbounded player", 0, videoPlayer.getBoxDw());
      assertEquals("getBoxDh of an unbounded player", 0, videoPlayer.getBoxDh());
      assertEquals("there is no picture to be drawn without a box", 0, videoPlayer.getVideoDw());
      assertEquals("there is no picture to be drawn without a box", 0, videoPlayer.getVideoDh());
      videoPlayer.setDwh(320, 180);
    }
    /**
     * Checks the handle the box of the picture is resized by hand with: it is created and
     * dropped by the state of the feature, it is not displayed at all while this player
     * holds no chapter, and it leaves this player exactly the way it has found it, because
     * nothing but a drag of it changes that box.
     * @param videoPlayer the object to be tested
     */
    private function runResizableTests(videoPlayer:VideoPlayer):void
    {
      const boxDw:int = videoPlayer.getBoxDw();
      const boxDh:int = videoPlayer.getBoxDh();
      videoPlayer.setResizable(true);
      assertTrue("getResizable after setResizable(true)", videoPlayer.getResizable());
      assertEquals("the handle leaves the width of the box alone", boxDw, videoPlayer.getBoxDw());
      assertEquals("the handle leaves the height of the box alone", boxDh, videoPlayer.getBoxDh());
      videoPlayer.setResizable(true);
      assertTrue("a second setResizable(true) creates no second handle", videoPlayer.getResizable());
      videoPlayer.setResizable(false);
      assertFalse("getResizable after setResizable(false)", videoPlayer.getResizable());
      videoPlayer.setResizable(false);
      assertFalse("a second setResizable(false) drops nothing else", videoPlayer.getResizable());
      assertEquals("the dropped handle leaves the box alone", boxDw, videoPlayer.getBoxDw());
      // a video of no chapter at all has no picture to be resized, so the handle of it is
      // taken away completely there, however the feature itself stays switched on: it
      // comes back with the chapters
      videoPlayer.setResizable(true);
      videoPlayer.clearChapters();
      assertTrue("the dropping of the chapters leaves the feature of the handle switched on"
        , videoPlayer.getResizable());
      assertEquals("the hidden handle leaves the width of the box alone", boxDw
        , videoPlayer.getBoxDw());
      assertEquals("the hidden handle leaves the height of the box alone", boxDh
        , videoPlayer.getBoxDh());
      videoPlayer.setChapters(CHAPTER_NAMES.concat(), CHAPTER_URLS.concat());
      assertTrue("the chapters that have arrived take the handle back"
        , videoPlayer.getResizable());
      assertEquals("the handle that is back leaves the box alone", boxDw
        , videoPlayer.getBoxDw());
      videoPlayer.setResizable(false);
    }
    /**
     * Checks the preview picture of this player: the switch of it can be turned both ways
     * at any time, and neither of those touches the box of the picture or the state of the
     * playing. The file of the chapter does not exist at all, so no frame of it can arrive
     * here: it is the switch itself that is checked.
     * @param videoPlayer the object to be tested
     */
    private function runPreviewTests(videoPlayer:VideoPlayer):void
    {
      const boxDw:int = videoPlayer.getBoxDw();
      const boxDh:int = videoPlayer.getBoxDh();
      videoPlayer.setPreview(false);
      assertFalse("getPreview after setPreview(false)", videoPlayer.getPreview());
      videoPlayer.setPreview(false);
      assertFalse("a second setPreview(false) drops nothing else", videoPlayer.getPreview());
      assertFalse("the preview picture starts nothing at all", videoPlayer.isPlaying());
      videoPlayer.setPreview(true);
      assertTrue("getPreview after setPreview(true)", videoPlayer.getPreview());
      videoPlayer.setPreview(true);
      assertTrue("a second setPreview(true) loads no second picture", videoPlayer.getPreview());
      assertFalse("the preview picture is no playing", videoPlayer.isPlaying());
      assertEquals("the preview picture leaves the width of the box alone", boxDw
        , videoPlayer.getBoxDw());
      assertEquals("the preview picture leaves the height of the box alone", boxDh
        , videoPlayer.getBoxDh());
    }
    /**
     * Checks the sound of the video: the volume of it is kept inside its range, a value out
     * of that range is dropped, and the muting leaves that volume exactly where it stands,
     * so an unmuted player goes on with the very same value. The file of the chapter does
     * not exist at all, so there is nothing to be heard here: it is the state of the two
     * controls that is checked.
     * @param videoPlayer the object to be tested
     */
    private function runSoundTests(videoPlayer:VideoPlayer):void
    {
      const volumeBefore:int = videoPlayer.getSoundVolume();
      videoPlayer.setSoundVolume(40);
      assertEquals("getSoundVolume after setSoundVolume", 40, videoPlayer.getSoundVolume());
      videoPlayer.setSoundVolume(0);
      assertEquals("the smallest volume is taken", 0, videoPlayer.getSoundVolume());
      videoPlayer.setSoundVolume(100);
      assertEquals("the greatest volume is taken", 100, videoPlayer.getSoundVolume());
      videoPlayer.setSoundVolume(-1);
      assertEquals("a volume under the range is dropped", 100, videoPlayer.getSoundVolume());
      videoPlayer.setSoundVolume(101);
      assertEquals("a volume over the range is dropped", 100, videoPlayer.getSoundVolume());
      videoPlayer.setSoundVolume(70);
      videoPlayer.setSoundMuted(true);
      assertTrue("isSoundMuted after setSoundMuted(true)", videoPlayer.isSoundMuted());
      assertEquals("the muting leaves the volume exactly where it stands", 70
        , videoPlayer.getSoundVolume());
      videoPlayer.setSoundMuted(true);
      assertTrue("a second setSoundMuted(true) changes nothing", videoPlayer.isSoundMuted());
      // the volume of a muted player is set in advance: it is the value the unmuting goes
      // on with
      videoPlayer.setSoundVolume(20);
      assertEquals("the volume of a muted player is taken as well", 20
        , videoPlayer.getSoundVolume());
      assertTrue("a volume given to a muted player leaves it muted", videoPlayer.isSoundMuted());
      videoPlayer.setSoundMuted(false);
      assertFalse("isSoundMuted after setSoundMuted(false)", videoPlayer.isSoundMuted());
      assertEquals("the unmuting goes on with the volume that has been set", 20
        , videoPlayer.getSoundVolume());
      videoPlayer.setSoundMuted(false);
      assertFalse("a second setSoundMuted(false) changes nothing", videoPlayer.isSoundMuted());
      assertFalse("the sound of this player starts nothing at all", videoPlayer.isPlaying());
      videoPlayer.setSoundVolume(volumeBefore);
    }
    /**
     * Checks the frame around this player and the automatic continuation of the chapters.
     * The room the frame takes is taken from everything standing inside it and not from
     * this player itself, so a framed player is exactly as big as an unframed one.
     * @param videoPlayer the object to be tested
     */
    private function runFrameAndContinueTests(videoPlayer:VideoPlayer):void
    {
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const dhOfNoFrame:int = videoPlayer.getDh();
      videoPlayer.setFrame(true);
      assertTrue("getFrame after setFrame(true)", videoPlayer.getFrame());
      assertEquals("the frame takes one padding from the two sides of the picture"
        , 320 - 2 * padding, videoPlayer.getVideoDw());
      assertEquals("the frame takes one padding from the top and the bottom of the picture"
        , 180 - 2 * padding, videoPlayer.getVideoDh());
      assertEquals("a framed player is as wide as the box it is given"
        , expectedDw(Math.max(320, videoPlayer.getMinDw())), videoPlayer.getDw());
      assertEquals("the frame takes no room from this player at all"
        , dhOfNoFrame, videoPlayer.getDh());
      videoPlayer.setFrame(true);
      assertTrue("setFrame(true) twice changes nothing", videoPlayer.getFrame());
      videoPlayer.setFrame(false);
      assertFalse("getFrame after setFrame(false)", videoPlayer.getFrame());
      assertEquals("the picture of a player of no frame fills the whole box", 320
        , videoPlayer.getVideoDw());
      assertEquals("this player stands in its old dimensions with the frame gone"
        , dhOfNoFrame, videoPlayer.getDh());
      videoPlayer.setAutoContinue(true);
      assertTrue("getAutoContinue after setAutoContinue(true)", videoPlayer.getAutoContinue());
      videoPlayer.setAutoContinue(false);
      assertFalse("getAutoContinue after setAutoContinue(false)", videoPlayer.getAutoContinue());
    }
    /**
     * Checks the states of the playing: a player is started, paused, continued and
     * stopped here, and a paused one is playing as well.
     * @param videoPlayer the object to be tested
     */
    private function runPlayingTests(videoPlayer:VideoPlayer):void
    {
      videoPlayer.play();
      assertTrue("isPlaying after play", videoPlayer.isPlaying());
      assertFalse("isPaused after play", videoPlayer.isPaused());
      videoPlayer.pause();
      assertTrue("isPaused after pause", videoPlayer.isPaused());
      assertTrue("a paused player is playing as well", videoPlayer.isPlaying());
      videoPlayer.pause();
      assertTrue("a second pause changes nothing", videoPlayer.isPaused());
      videoPlayer.play();
      assertFalse("isPaused after the play of a paused player", videoPlayer.isPaused());
      assertTrue("isPlaying after the play of a paused player", videoPlayer.isPlaying());
      videoPlayer.stop();
      assertFalse("isPlaying after stop", videoPlayer.isPlaying());
      assertFalse("isPaused after stop", videoPlayer.isPaused());
      assertEquals("getProgressSecs after stop", 0, videoPlayer.getProgressSecs());
      // a chapter that is taken while this player is playing is started right away
      videoPlayer.play();
      videoPlayer.nextChapter();
      assertEquals("the next chapter is the one this player stands on", 1
        , videoPlayer.getSelectedChapterIndex());
      assertTrue("a player that is playing keeps playing on the new chapter"
        , videoPlayer.isPlaying());
      videoPlayer.stop();
      videoPlayer.setSelectedChapterIndex(0);
      assertFalse("a player that is stopped stays stopped on the new chapter"
        , videoPlayer.isPlaying());
      // a player makes no click sound, it has its own buttons for that
      videoPlayer.setSoundTypeClick("aSoundTypeThatDoesNotExist");
    }
    /**
     * Checks the fullscreen of the video: it can only be opened while the feature of it
     * is switched on, this player holds a chapter and it stands on the stage, the picture
     * of it is measured from that stage instead of the box, and the room this player takes
     * inside the application is left the way it has been, so the closing of it takes
     * everything back exactly where it has been standing.
     * @param videoPlayer the object to be tested
     */
    private function runFullscreenTests(videoPlayer:VideoPlayer):void
    {
      const dwBefore:int = videoPlayer.getDw();
      const dhBefore:int = videoPlayer.getDh();
      const videoDwBefore:int = videoPlayer.getVideoDw();
      const videoDhBefore:int = videoPlayer.getVideoDh();
      videoPlayer.openFullscreen();
      assertFalse("openFullscreen does nothing while the feature is switched off"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.setFullscreenEnabled(true);
      assertTrue("getFullscreenEnabled after setFullscreenEnabled(true)"
        , videoPlayer.getFullscreenEnabled());
      videoPlayer.setFullscreenEnabled(true);
      assertTrue("a second setFullscreenEnabled(true) creates no second button"
        , videoPlayer.getFullscreenEnabled());
      videoPlayer.openFullscreen();
      assertTrue("isFullscreenOpened after openFullscreen", videoPlayer.isFullscreenOpened());
      videoPlayer.openFullscreen();
      assertTrue("an opened fullscreen stays opened after a second open"
        , videoPlayer.isFullscreenOpened());
      assertTrue("the picture of a fullscreen is wider than the box of this player"
        , videoPlayer.getVideoDw() > videoDwBefore);
      assertTrue("the picture of a fullscreen is taller than the box of this player"
        , videoPlayer.getVideoDh() > videoDhBefore);
      assertEquals("an opened fullscreen leaves the width of this player alone", dwBefore
        , videoPlayer.getDw());
      assertEquals("an opened fullscreen leaves the height of this player alone", dhBefore
        , videoPlayer.getDh());
      videoPlayer.closeFullscreen();
      assertFalse("isFullscreenOpened after closeFullscreen", videoPlayer.isFullscreenOpened());
      videoPlayer.closeFullscreen();
      assertFalse("a closed fullscreen stays closed after a second close"
        , videoPlayer.isFullscreenOpened());
      assertEquals("the picture is drawn inside the box of this player again", videoDwBefore
        , videoPlayer.getVideoDw());
      assertEquals("this player stands in its old dimensions again", dhBefore
        , videoPlayer.getDh());
      // a player that is switched off closes the fullscreen of the video and it opens no
      // new one either: none of the buttons standing on it could be pressed any more
      videoPlayer.openFullscreen();
      videoPlayer.setEnabled(false);
      assertFalse("the switching off of this player closes the opened fullscreen"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.openFullscreen();
      assertFalse("openFullscreen does nothing on a player that is switched off"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.setEnabled(true);
      videoPlayer.openFullscreen();
      videoPlayer.setFullscreenEnabled(false);
      assertFalse("getFullscreenEnabled after setFullscreenEnabled(false)"
        , videoPlayer.getFullscreenEnabled());
      assertFalse("the switching off of the feature closes the opened fullscreen"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.setFullscreenEnabled(false);
      assertFalse("a second setFullscreenEnabled(false) drops nothing else"
        , videoPlayer.getFullscreenEnabled());
      assertEquals("the closed fullscreen leaves the box of the picture alone", videoDwBefore
        , videoPlayer.getVideoDw());
      // a video of no chapter at all has nothing to be opened in fullscreen: the button of
      // that feature is taken away completely there, however the feature itself stays
      // switched on, so it comes back with the chapters
      videoPlayer.setFullscreenEnabled(true);
      videoPlayer.openFullscreen();
      videoPlayer.clearChapters();
      assertFalse("the dropping of the chapters closes the opened fullscreen"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.openFullscreen();
      assertFalse("there is no fullscreen to be opened without a chapter"
        , videoPlayer.isFullscreenOpened());
      assertTrue("the dropping of the chapters leaves the feature switched on"
        , videoPlayer.getFullscreenEnabled());
      videoPlayer.setChapters(CHAPTER_NAMES.concat(), CHAPTER_URLS.concat());
      videoPlayer.openFullscreen();
      assertTrue("the chapters that have arrived can be opened in fullscreen again"
        , videoPlayer.isFullscreenOpened());
      videoPlayer.closeFullscreen();
      videoPlayer.setFullscreenEnabled(false);
      // a player that is not on the stage has no fullscreen to be opened at all
      const offStagePlayer:VideoPlayer = new VideoPlayer(application);
      offStagePlayer.setFullscreenEnabled(true);
      offStagePlayer.openFullscreen();
      assertFalse("openFullscreen does nothing off the stage"
        , offStagePlayer.isFullscreenOpened());
      offStagePlayer.destroy();
    }
    /**
     * Checks the list the chapters of the video are picked from: it is opened and closed
     * by the states of the feature and of this player, a picture that is too small to
     * display one single name holds no list at all, and a video that has no chapter to be
     * picked closes an open one right away.
     * @param videoPlayer the object to be tested
     */
    private function runChapterListTests(videoPlayer:VideoPlayer):void
    {
      videoPlayer.openChapterList();
      assertFalse("openChapterList does nothing while the feature is switched off"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setChapterListEnabled(true);
      assertTrue("getChapterListEnabled after setChapterListEnabled(true)"
        , videoPlayer.getChapterListEnabled());
      videoPlayer.setChapterListEnabled(true);
      assertTrue("a second setChapterListEnabled(true) creates no second list"
        , videoPlayer.getChapterListEnabled());
      videoPlayer.openChapterList();
      assertTrue("isChapterListOpened after openChapterList"
        , videoPlayer.isChapterListOpened());
      videoPlayer.openChapterList();
      assertTrue("an open list stays open after a second open"
        , videoPlayer.isChapterListOpened());
      videoPlayer.closeChapterList();
      assertFalse("isChapterListOpened after closeChapterList"
        , videoPlayer.isChapterListOpened());
      videoPlayer.closeChapterList();
      assertFalse("a closed list stays closed after a second close"
        , videoPlayer.isChapterListOpened());
      // the list stands inside the picture of the video, so a picture that is not even as
      // tall as one single name of a chapter holds no list at all
      const boxDw:int = videoPlayer.getBoxDw();
      const boxDh:int = videoPlayer.getBoxDh();
      videoPlayer.setDwh(boxDw, 1);
      videoPlayer.openChapterList();
      assertFalse("a picture that is too small displays no list of the chapters"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setDwh(boxDw, boxDh);
      // a player that is switched off closes the list and it opens no new one either
      videoPlayer.openChapterList();
      videoPlayer.setEnabled(false);
      assertFalse("the switching off of this player closes the open list"
        , videoPlayer.isChapterListOpened());
      videoPlayer.openChapterList();
      assertFalse("openChapterList does nothing on a player that is switched off"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setEnabled(true);
      // the fullscreen draws the picture of the video in other dimensions, so the list
      // that has been laid out from the old one is closed by both of those two
      videoPlayer.setFullscreenEnabled(true);
      videoPlayer.openChapterList();
      videoPlayer.openFullscreen();
      assertFalse("the opening of the fullscreen closes the list of the chapters"
        , videoPlayer.isChapterListOpened());
      videoPlayer.openChapterList();
      assertTrue("the list of the chapters is opened on the fullscreen as well"
        , videoPlayer.isChapterListOpened());
      videoPlayer.closeFullscreen();
      assertFalse("the closing of the fullscreen closes the list of the chapters"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setFullscreenEnabled(false);
      // a video that has no chapter to be picked has no list to be opened either
      videoPlayer.openChapterList();
      videoPlayer.clearChapters();
      assertFalse("the dropping of the chapters closes the open list"
        , videoPlayer.isChapterListOpened());
      videoPlayer.openChapterList();
      assertFalse("there is no list to be opened without a chapter"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setChapters(CHAPTER_NAMES.concat(), CHAPTER_URLS.concat());
      videoPlayer.openChapterList();
      assertTrue("the chapters that have arrived can be picked again"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setChapterListEnabled(false);
      assertFalse("getChapterListEnabled after setChapterListEnabled(false)"
        , videoPlayer.getChapterListEnabled());
      assertFalse("the switching off of the feature closes the open list"
        , videoPlayer.isChapterListOpened());
      videoPlayer.setChapterListEnabled(false);
      assertFalse("a second setChapterListEnabled(false) drops nothing else"
        , videoPlayer.getChapterListEnabled());
      assertEquals("the dropped list leaves the box of the picture alone", boxDw
        , videoPlayer.getBoxDw());
    }
    /**
     * Checks the switching off of this player: it stops the playing first, and it can be
     * played again as soon as it is switched back on.
     * @param videoPlayer the object to be tested
     */
    private function runEnabledTests(videoPlayer:VideoPlayer):void
    {
      videoPlayer.play();
      assertTrue("isPlaying before the switching off", videoPlayer.isPlaying());
      videoPlayer.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", videoPlayer.getEnabled());
      assertFalse("a player that is switched off stops the playing", videoPlayer.isPlaying());
      videoPlayer.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", videoPlayer.getEnabled());
      videoPlayer.play();
      assertTrue("a player that is switched back on can be played again", videoPlayer.isPlaying());
      videoPlayer.stop();
    }
    /**
     * Checks a player whose chapters have been dropped: there is nothing to be played,
     * paused or stopped in it any more.
     * @param videoPlayer the object to be tested
     */
    private function runEmptyPlayerTests(videoPlayer:VideoPlayer):void
    {
      const countBefore:int = chapterChangedCount;
      videoPlayer.clearChapters();
      assertEquals("getNumOfChapters after clearChapters", 0, videoPlayer.getNumOfChapters());
      assertEquals("getSelectedChapterIndex after clearChapters", -1
        , videoPlayer.getSelectedChapterIndex());
      assertEquals("one chapter changed event after clearChapters", countBefore + 1
        , chapterChangedCount);
      assertEquals("getTotalSecs after clearChapters", 0, videoPlayer.getTotalSecs());
      videoPlayer.play();
      assertFalse("there is nothing to be played without a chapter", videoPlayer.isPlaying());
      videoPlayer.pause();
      assertFalse("there is nothing to be paused without a chapter", videoPlayer.isPaused());
      videoPlayer.stop();
      assertFalse("there is nothing to be stopped without a chapter", videoPlayer.isPlaying());
      videoPlayer.prevChapter();
      assertEquals("there is no chapter to step back onto", -1
        , videoPlayer.getSelectedChapterIndex());
      videoPlayer.nextChapter();
      assertEquals("there is no chapter to step onto", -1, videoPlayer.getSelectedChapterIndex());
      assertEquals("a player holding no chapter reports no chapter change", countBefore + 1
        , chapterChangedCount);
    }
    /**
     * Counts the chapter changed events of the tested player.
     * @param e the chapter changed event of that player
     */
    private function videoPlayerChapterChanged(e:Event):void
    {
      chapterChangedCount++;
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
      chapterChangedCount = 0;
    }
  }
}
