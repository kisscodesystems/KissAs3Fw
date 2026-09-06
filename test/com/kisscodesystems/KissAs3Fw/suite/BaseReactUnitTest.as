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
 * BaseReactUnitTest
 * Checks the BaseReact base class.
 *
 * MAIN FEATURES:
 * - the hits are stored, counted, ordered and dropped
 * - one user hits one emoji once only
 * - the react feature and the emoji picker can be switched on and off
 * - the dimensions of the content and of the whole object are separated
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseReact;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class BaseReactUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BaseReactUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "BaseReact";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const baseReact:BaseReact = new BaseReact(application);
      addTested(baseReact);
      const thumbsup:String = EnumEmojis.hands_thumbsup();
      const heart:String = EnumEmojis.hearts_heart();
      // a fresh object does not react at all
      assertFalse("getReactEnabled of a fresh BaseReact", baseReact.getReactEnabled());
      assertEquals("getNumOfHits of a fresh BaseReact", 0, baseReact.getNumOfHits());
      assertEquals("getHits of a fresh BaseReact", 0, baseReact.getHits().length);
      assertEquals("getEmojiTypesByHits of a fresh BaseReact", 0, baseReact.getEmojiTypesByHits().length);
      assertFalse("isPickerOpened of a fresh BaseReact", baseReact.isPickerOpened());
      // the content takes the whole object while it does not react
      baseReact.setDwh(240, 120);
      assertEquals("getContentDw after setDwh", 240, baseReact.getContentDw());
      assertEquals("getContentDh after setDwh", 120, baseReact.getContentDh());
      assertEquals("getDw after setDwh", expectedDw(240), baseReact.getDw());
      assertEquals("getDh after setDwh", expectedDh(120), baseReact.getDh());
      baseReact.setDw(260);
      assertEquals("getContentDw after setDw", 260, baseReact.getContentDw());
      assertEquals("getDw after setDw", expectedDw(260), baseReact.getDw());
      baseReact.setDh(140);
      assertEquals("getContentDh after setDh", 140, baseReact.getContentDh());
      assertEquals("getDh after setDh", expectedDh(140), baseReact.getDh());
      // the hits are stored, one user hits one emoji once only
      baseReact.addHit("anna", thumbsup, new Date());
      assertEquals("getNumOfHits after the first hit", 1, baseReact.getNumOfHits());
      baseReact.addHit("anna", thumbsup, new Date());
      assertEquals("the same user hits the same emoji once only", 1, baseReact.getNumOfHits());
      baseReact.addHit("bela", thumbsup, new Date());
      baseReact.addHit("anna", heart, new Date());
      assertEquals("getNumOfHits after three hits", 3, baseReact.getNumOfHits());
      assertEquals("getNumOfHitsOfEmoji of the twice hit emoji", 2, baseReact.getNumOfHitsOfEmoji(thumbsup));
      assertEquals("getNumOfHitsOfEmoji of the once hit emoji", 1, baseReact.getNumOfHitsOfEmoji(heart));
      assertEquals("getNumOfHitsOfEmoji of an emoji nobody has hit", 0, baseReact.getNumOfHitsOfEmoji(EnumEmojis.food_pizza()));
      assertTrue("hasHitOfUser of a user who has hit", baseReact.hasHitOfUser("anna", thumbsup));
      assertFalse("hasHitOfUser of a user who has not hit", baseReact.hasHitOfUser("cili", thumbsup));
      // an empty emoji type is not stored at all
      baseReact.addHit("anna", "", new Date());
      assertEquals("an empty emoji type is not stored", 3, baseReact.getNumOfHits());
      // the emojis come in a descending order by the number of their hits
      const emojiTypesArray:Array = baseReact.getEmojiTypesByHits();
      assertEquals("number of the hit emoji types", 2, emojiTypesArray.length);
      assertEquals("the most hit emoji comes first", thumbsup, emojiTypesArray[0]);
      assertEquals("the least hit emoji comes last", heart, emojiTypesArray[1]);
      // the hits are handed out in a copy, holding the user, the emoji and the date
      const hitsArray:Array = baseReact.getHits();
      assertEquals("getHits returns every hit", 3, hitsArray.length);
      assertEquals("the username is stored", "anna", hitsArray[0].username);
      assertEquals("the emoji type is stored", thumbsup, hitsArray[0].emojiType);
      assertNotNull("the date is stored", hitsArray[0].date);
      hitsArray.splice(0);
      assertEquals("getHits returns a copy", 3, baseReact.getNumOfHits());
      // the picker can not be opened while the react feature is switched off
      baseReact.openPicker();
      assertFalse("openPicker does nothing while the react feature is switched off", baseReact.isPickerOpened());
      // switched on, the react row is displayed under the content of this object
      baseReact.setReactEnabled(true);
      assertTrue("getReactEnabled after setReactEnabled(true)", baseReact.getReactEnabled());
      assertEquals("the content keeps its own height", 140, baseReact.getContentDh());
      assertTrue("the object grows by the react row", baseReact.getDh() > baseReact.getContentDh());
      assertEquals("the hits are kept", 3, baseReact.getNumOfHits());
      // the picker opens and closes, the object grows by it and takes its height back
      const dhClosed:int = baseReact.getDh();
      baseReact.openPicker();
      assertTrue("isPickerOpened after openPicker", baseReact.isPickerOpened());
      assertTrue("the object grows by the opened picker", baseReact.getDh() > dhClosed);
      baseReact.closePicker();
      assertFalse("isPickerOpened after closePicker", baseReact.isPickerOpened());
      assertEquals("the object takes its previous height back", dhClosed, baseReact.getDh());
      baseReact.closePicker();
      assertFalse("a closed picker stays closed after a second close", baseReact.isPickerOpened());
      // the enabled state reaches the buttons of the react row as well
      baseReact.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", baseReact.getEnabled());
      baseReact.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", baseReact.getEnabled());
      // switching the feature off frees the react row up but keeps the hits
      baseReact.setReactEnabled(false);
      assertFalse("getReactEnabled after setReactEnabled(false)", baseReact.getReactEnabled());
      assertEquals("the hits are kept after switching the feature off", 3, baseReact.getNumOfHits());
      assertEquals("the object takes the height of its content back", expectedDh(140), baseReact.getDh());
      // the hits can be dropped one by one and all at once
      baseReact.removeHit("anna", thumbsup);
      assertEquals("getNumOfHits after removeHit", 2, baseReact.getNumOfHits());
      assertFalse("hasHitOfUser after removeHit", baseReact.hasHitOfUser("anna", thumbsup));
      baseReact.clearHits();
      assertEquals("getNumOfHits after clearHits", 0, baseReact.getNumOfHits());
      assertEquals("getEmojiTypesByHits after clearHits", 0, baseReact.getEmojiTypesByHits().length);
      runBaseSpriteTests(baseReact);
      removeTested(baseReact);
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
    }
  }
}
