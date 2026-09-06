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
 * BackgroundUnitTest
 * Checks the Background of the framework.
 *
 * MAIN FEATURES:
 * - the background is built of three layers and it follows the size given to it
 * - the pixel stealing of a color object fixes the moving background image where it
 *   stands, and the image only goes back to the origin when it cannot move at all
 * - it is a base sprite, so every base sprite assertion holds on it
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Background;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.display.DisplayObject;
  public class BackgroundUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function BackgroundUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Background";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const background:Background = new Background(application);
      addTested(background);
      // the three layers of the background are all there
      assertEquals("the number of the layers of a fresh Background", 3, background.numChildren);
      // the background takes the dimensions it is given
      background.setDwh(640, 480);
      assertEquals("getDw after setDwh", expectedDw(640), background.getDw());
      assertEquals("getDh after setDwh", expectedDh(480), background.getDh());
      background.setDw(800);
      assertEquals("getDw after setDw", expectedDw(800), background.getDw());
      background.setDh(600);
      assertEquals("getDh after setDh", expectedDh(600), background.getDh());
      // the pixel stealing of a color object fixes the background image exactly where it
      // stands: the snapshot the stolen colors are read from is taken from that very view
      const backgroundImageShape:DisplayObject = background.getChildAt(1);
      backgroundImageShape.x = -20;
      backgroundImageShape.y = -30;
      background.stealPixel(true);
      assertEquals("the x of the background image during a pixel stealing", -20, backgroundImageShape.x);
      assertEquals("the y of the background image during a pixel stealing", -30, backgroundImageShape.y);
      // an image that cannot move at all is taken back to the origin instead
      const backgroundLiveBefore:Boolean = application.getDynamicsConfig().getAppBackgroundLive();
      application.getDynamicsConfig().setAppBackgroundLive(false);
      background.stealPixel(false);
      assertEquals("the x of the background image after a pixel stealing", 0, backgroundImageShape.x);
      assertEquals("the y of the background image after a pixel stealing", 0, backgroundImageShape.y);
      application.getDynamicsConfig().setAppBackgroundLive(backgroundLiveBefore);
      runBaseSpriteTests(background);
      removeTested(background);
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
