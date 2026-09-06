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
 * SoundPlayerUnitTest
 * Checks the SoundPlayer component.
 *
 * MAIN FEATURES:
 * - the sound type, the sound name and the length values of the loaded sound
 * - a sound type that does not exist leaves the player unplayable
 * - the volume and the muting of the player: that volume belongs to the player alone,
 *   the sound volume of the application is the one of the sound effects
 * - the smallest width the player can be laid out in
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumSounds;
  import com.kisscodesystems.KissAs3Fw.ui.SoundPlayer;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class SoundPlayerUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function SoundPlayerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "SoundPlayer";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const soundPlayer:SoundPlayer = new SoundPlayer(application);
      addTested(soundPlayer);
      // a fresh player holds no sound at all
      assertEquals("getSoundType of a fresh player", "", soundPlayer.getSoundType());
      assertEquals("getSoundName of a fresh player", "", soundPlayer.getSoundName());
      assertFalse("isPlaying of a fresh player", soundPlayer.isPlaying());
      // the volume of a player belongs to that player alone: the sound volume of the
      // application is the one of the sound effects, so it does not touch this at all
      assertEquals("getSoundVolume of a fresh player"
        , application.getComponentsConfig().getSoundPlayerSoundVolume()
        , soundPlayer.getSoundVolume());
      assertFalse("isSoundMuted of a fresh player", soundPlayer.isSoundMuted());
      // a sound of the framework is found by the sound manager
      soundPlayer.setSoundTypeAndName(EnumSounds.button(), "The button sound");
      assertEquals("getSoundType after setSoundTypeAndName"
        , EnumSounds.button(), soundPlayer.getSoundType());
      assertEquals("getSoundName after setSoundTypeAndName"
        , "The button sound", soundPlayer.getSoundName());
      assertTrue("getSoundLengthMillis of a known sound", soundPlayer.getSoundLengthMillis() > 0);
      assertTrue("getSoundLengthBytes of a known sound", soundPlayer.getSoundLengthBytes() > 0);
      assertEquals("getSoundMaxSecs comes from the length"
        , int(soundPlayer.getSoundLengthMillis() / 1000), soundPlayer.getSoundMaxSecs());
      // a sound type that does not exist leaves the player silent, nothing can be played
      soundPlayer.setSoundTypeAndName("aSoundTypeThatDoesNotExist", "No such sound");
      assertEquals("getSoundType of an unknown sound"
        , "aSoundTypeThatDoesNotExist", soundPlayer.getSoundType());
      assertEquals("getSoundName of an unknown sound", "No such sound", soundPlayer.getSoundName());
      soundPlayer.play();
      assertFalse("isPlaying after a play of an unknown sound", soundPlayer.isPlaying());
      soundPlayer.pause();
      assertFalse("isPlaying after a pause of an unknown sound", soundPlayer.isPlaying());
      soundPlayer.stop();
      assertFalse("isPlaying after a stop of an unknown sound", soundPlayer.isPlaying());
      runSoundTests(soundPlayer);
      // only the width of a player can be set, and it is never narrower than seven buttons
      assertTrue("getMinDw is seven buttons of the playing", soundPlayer.getMinDw() > 0);
      const wideDw:int = soundPlayer.getMinDw() + 100;
      soundPlayer.setDw(wideDw);
      assertEquals("getDw after setDw", expectedDw(wideDw), soundPlayer.getDw());
      const dhBefore:int = soundPlayer.getDh();
      soundPlayer.setDh(500);
      assertEquals("getDh is not changed by setDh", dhBefore, soundPlayer.getDh());
      soundPlayer.setDwh(400, 500);
      assertEquals("getDw is not changed by setDwh", expectedDw(wideDw), soundPlayer.getDw());
      assertEquals("getDh is not changed by setDwh", dhBefore, soundPlayer.getDh());
      soundPlayer.setDw(1);
      assertEquals("a width under the smallest one is taken up to it"
        , expectedDw(soundPlayer.getMinDw()), soundPlayer.getDw());
      soundPlayer.setDw(wideDw);
      // a player makes no click sound, it has its own buttons for that
      soundPlayer.setSoundTypeClick(EnumSounds.button());
      runBaseSpriteTests(soundPlayer);
      removeTested(soundPlayer);
    }
    /**
     * Checks the controls of the sound of this component: the volume is refused outside
     * its own range, a muted player keeps the volume it stands on, and neither of the two
     * needs a sound that can really be played.
     * @param soundPlayer the object to be tested
     */
    private function runSoundTests(soundPlayer:SoundPlayer):void
    {
      const volumeBefore:int = soundPlayer.getSoundVolume();
      soundPlayer.setSoundVolume(40);
      assertEquals("getSoundVolume after setSoundVolume", 40, soundPlayer.getSoundVolume());
      soundPlayer.setSoundVolume(0);
      assertEquals("the smallest volume is taken", 0, soundPlayer.getSoundVolume());
      soundPlayer.setSoundVolume(100);
      assertEquals("the greatest volume is taken", 100, soundPlayer.getSoundVolume());
      soundPlayer.setSoundVolume(-1);
      assertEquals("a volume under the range is dropped", 100, soundPlayer.getSoundVolume());
      soundPlayer.setSoundVolume(101);
      assertEquals("a volume over the range is dropped", 100, soundPlayer.getSoundVolume());
      soundPlayer.setSoundVolume(70);
      soundPlayer.setSoundMuted(true);
      assertTrue("isSoundMuted after setSoundMuted(true)", soundPlayer.isSoundMuted());
      assertEquals("a muted player keeps the volume it stands on", 70, soundPlayer.getSoundVolume());
      soundPlayer.setSoundMuted(true);
      assertTrue("a second setSoundMuted(true) changes nothing", soundPlayer.isSoundMuted());
      soundPlayer.setSoundVolume(20);
      assertEquals("a volume can be given to a muted player", 20, soundPlayer.getSoundVolume());
      assertTrue("a volume given to a muted player leaves it muted", soundPlayer.isSoundMuted());
      soundPlayer.setSoundMuted(false);
      assertFalse("isSoundMuted after setSoundMuted(false)", soundPlayer.isSoundMuted());
      assertEquals("an unmuted player goes on with that volume", 20, soundPlayer.getSoundVolume());
      soundPlayer.setSoundMuted(false);
      assertFalse("a second setSoundMuted(false) changes nothing", soundPlayer.isSoundMuted());
      soundPlayer.setSoundVolume(volumeBefore);
    }
  }
}
