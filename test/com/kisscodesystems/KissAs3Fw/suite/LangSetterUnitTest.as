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
 * LangSetterUnitTest
 * Checks the LangSetter of the framework.
 *
 * MAIN FEATURES:
 * - it displays every language the application is available in
 * - only its width can be set, the height comes from the list picker in it
 * - picking a language changes the language of the whole application
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.LangSetter;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class LangSetterUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function LangSetterUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "LangSetter";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const langBefore:String = application.getLabelManager().getLang();
      const langSetter:LangSetter = new LangSetter(application);
      addTested(langSetter);
      assertTrue("the languages of the application are there"
        , application.getLabelManager().getKeysLang().length > 0);
      // a fresh object displays the current language of the application already: nobody
      // has to fill it up from the outside to make it usable
      assertEquals("getSelectedIndex of a fresh LangSetter"
        , application.getLabelManager().getKeysLang().indexOf(application.getLabelManager().getLang())
        , langSetter.getSelectedIndex());
      // the languages can be reloaded, and that reload keeps the current one picked
      langSetter.updateLangCodes();
      assertEquals("getSelectedIndex after updateLangCodes"
        , application.getLabelManager().getKeysLang().indexOf(application.getLabelManager().getLang())
        , langSetter.getSelectedIndex());
      // the width is given to the list picker, so this object takes it as well
      langSetter.setDw(300);
      assertEquals("getDw after setDw", expectedDw(300), langSetter.getDw());
      // the height cannot be set from the outside: it comes from the list picker
      const dhBefore:int = langSetter.getDh();
      langSetter.setDh(1234);
      assertEquals("getDh after setDh does nothing", dhBefore, langSetter.getDh());
      const dwBefore:int = langSetter.getDw();
      langSetter.setDwh(456, 1234);
      assertEquals("getDw after setDwh does nothing", dwBefore, langSetter.getDw());
      assertEquals("getDh after setDwh does nothing", dhBefore, langSetter.getDh());
      // picking a language keeps the application on one of the known ones. The picker
      // only fires when the index really changes, so both ends of the list are tried
      const keys:Array = application.getLabelManager().getKeysLang();
      langSetter.setSelectedIndex(keys.length - 1);
      langSetter.setSelectedIndex(0);
      assertTrue("the language of the application is a known one"
        , keys.indexOf(application.getLabelManager().getLang()) > -1);
      // a silent selection only displays another language: the application stays on the
      // one it is on, which is how this object follows a language changed somewhere else
      const langNow:String = application.getLabelManager().getLang();
      langSetter.setSelectedIndex(keys.length - 1, false);
      assertEquals("getSelectedIndex after a silent setSelectedIndex"
        , keys.length - 1, langSetter.getSelectedIndex());
      assertEquals("the language of the application after a silent setSelectedIndex"
        , langNow, application.getLabelManager().getLang());
      keys.splice(0);
      // the enabled state reaches the list picker as well
      langSetter.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", langSetter.getEnabled());
      langSetter.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", langSetter.getEnabled());
      runBaseSpriteTests(langSetter);
      removeTested(langSetter);
      // the language of the application is put back to the one it has been started with
      application.getLabelManager().setLang(langBefore);
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
