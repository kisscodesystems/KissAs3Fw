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
 * ImageUnitTest
 * Checks the Image component.
 *
 * MAIN FEATURES:
 * - the picture is given as a bitmap data, so nothing of this suite needs a network:
 *   a loading from an url arrives frames later and it can not be waited for here
 * - the box, the fitting into it, the resizing by hand, the square and the frame: the
 *   geometry of the drawing
 * - the fullscreen and the react feature of the base class of this component
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.ui.Image;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.display.BitmapData;
  public class ImageUnitTest extends BaseUnitTest
  {
    // the dimensions of the picture every assertion of this suite works on: a landscape
    // one of an aspect ratio of two, so a shrunk side is easy to count
    private const PICTURE_DW:int = 200;
    private const PICTURE_DH:int = 100;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function ImageUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Image";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      const image:Image = new Image(application);
      addTested(image);
      // a fresh object holds no picture and no url at all
      assertEquals("getUrl of a fresh image", "", image.getUrl());
      assertEquals("getNumOfPostData of a fresh image", 0, image.getNumOfPostData());
      assertFalse("isLoading of a fresh image", image.isLoading());
      assertFalse("isPictureLoaded of a fresh image", image.isPictureLoaded());
      assertNull("getBitmapData of a fresh image", image.getBitmapData());
      assertEquals("getBitmapDw of a fresh image", 0, image.getBitmapDw());
      assertEquals("getBitmapDh of a fresh image", 0, image.getBitmapDh());
      assertEquals("getBoxDw of a fresh image", 0, image.getBoxDw());
      assertEquals("getBoxDh of a fresh image", 0, image.getBoxDh());
      assertFalse("getFrame of a fresh image", image.getFrame());
      assertTrue("getFitToBox of a fresh image", image.getFitToBox());
      assertFalse("getResizable of a fresh image", image.getResizable());
      assertFalse("getInSquare of a fresh image", image.getInSquare());
      assertFalse("getFullscreenEnabled of a fresh image", image.getFullscreenEnabled());
      assertFalse("isFullscreenOpened of a fresh image", image.isFullscreenOpened());
      assertEquals("getDw of a fresh image", 0, image.getDw());
      assertEquals("getDh of a fresh image", 0, image.getDh());
      runPostDataTests(image);
      runLoadingTests(image);
      runPictureTests(image);
      runBoxTests(image);
      runResizableTests(image);
      runFrameTests(image);
      runFullscreenTests(image);
      runReactTests(image);
      // the base sprite assertions need a picture standing in it: a hidden object takes
      // its previous dimensions back, and those have to be the ones of that picture
      image.setFitToBox(true);
      image.setInSquare(false);
      image.setFrame(false);
      image.setDwh(0, 0);
      runBaseSpriteTests(image);
      removeTested(image);
    }
    /**
     * Checks the variables of the post request of the loading: they are taken in two
     * arrays that belong together, so a pair that does not match is refused.
     * @param image the object to be tested
     */
    private function runPostDataTests(image:Image):void
    {
      image.setPostData(["sid", "fileurl"], ["a-session-id", "a-file-url"]);
      assertEquals("getNumOfPostData after setPostData", 2, image.getNumOfPostData());
      image.setPostData(["sid", "fileurl"], ["a-session-id"]);
      assertEquals("more names than values are refused", 0, image.getNumOfPostData());
      image.setPostData(["sid"], ["a-session-id"]);
      assertEquals("getNumOfPostData after one variable", 1, image.getNumOfPostData());
      image.setPostData(null, null);
      assertEquals("the variables can be taken away", 0, image.getNumOfPostData());
    }
    /**
     * Checks the start of the loading. The picture of an url arrives frames later, so
     * nothing of it can be waited for here: the loading is started with a delay this run
     * never reaches, so it stays on its way while the state of it is asked about.
     * @param image the object to be tested
     */
    private function runLoadingTests(image:Image):void
    {
      image.loadUrl("");
      assertEquals("an empty url is refused", "", image.getUrl());
      assertFalse("an empty url starts no loading", image.isLoading());
      image.loadUrl(null);
      assertEquals("a null url is refused", "", image.getUrl());
      const url:String = "https://app1.kisscodesystems.com/kcsops/samples/sample_640x360.png";
      image.loadUrl(url, 60000);
      assertEquals("getUrl after loadUrl", url, image.getUrl());
      assertTrue("isLoading while the picture is on its way", image.isLoading());
      assertFalse("isPictureLoaded while the picture is on its way", image.isPictureLoaded());
      image.clear();
      assertFalse("isLoading after clear", image.isLoading());
      assertEquals("the url is kept by clear", url, image.getUrl());
    }
    /**
     * Checks the picture given as a bitmap data: it is displayed without a loading at
     * all, it can be dropped and it is copied, so the caller keeps its own one.
     * @param image the object to be tested
     */
    private function runPictureTests(image:Image):void
    {
      const bitmapData:BitmapData = new BitmapData(PICTURE_DW, PICTURE_DH, false, 0x808080);
      image.setBitmapData(bitmapData);
      assertTrue("isPictureLoaded after setBitmapData", image.isPictureLoaded());
      assertFalse("isLoading after setBitmapData", image.isLoading());
      assertEquals("the url is cleared by setBitmapData", "", image.getUrl());
      assertNotNull("getBitmapData after setBitmapData", image.getBitmapData());
      assertEquals("getBitmapDw after setBitmapData", PICTURE_DW, image.getBitmapDw());
      assertEquals("getBitmapDh after setBitmapData", PICTURE_DH, image.getBitmapDh());
      assertFalse("the picture is a copy of the one given", bitmapData === image.getBitmapData());
      // an unbounded object displays the picture in the dimensions it has arrived with
      assertEquals("getDw of the unbounded picture", PICTURE_DW, image.getDw());
      assertEquals("getDh of the unbounded picture", PICTURE_DH, image.getDh());
      bitmapData.dispose();
      image.clear();
      assertFalse("isPictureLoaded after clear", image.isPictureLoaded());
      assertNull("getBitmapData after clear", image.getBitmapData());
      assertEquals("getDw after clear", 0, image.getDw());
      assertEquals("getDh after clear", 0, image.getDh());
      image.setBitmapData(null);
      assertFalse("isPictureLoaded after setBitmapData(null)", image.isPictureLoaded());
      // every assertion below works on this very picture
      setTestPicture(image);
    }
    /**
     * Checks the box the picture is drawn inside: a picture that fits to it is shrunk
     * into it keeping its own aspect ratio, a picture that does not fit keeps its own
     * dimensions, and a picture standing in a square takes the greater side of it.
     * @param image the object to be tested
     */
    private function runBoxTests(image:Image):void
    {
      image.setDwh(100, 100);
      assertEquals("getBoxDw after setDwh", 100, image.getBoxDw());
      assertEquals("getBoxDh after setDwh", 100, image.getBoxDh());
      assertEquals("the picture is shrunk to the width of the box", 100, image.getDw());
      assertEquals("the height of the picture follows its own ratio", 50, image.getDh());
      image.setDh(40);
      assertEquals("getBoxDh after setDh", 40, image.getBoxDh());
      assertEquals("the height of the box is the one that shrinks now", 40, image.getDh());
      assertEquals("the width of the picture follows its own ratio", 80, image.getDw());
      image.setDw(400);
      assertEquals("getBoxDw after setDw", 400, image.getBoxDw());
      assertEquals("a box wider than the picture is not filled", 80, image.getDw());
      // a picture that does not fit to its box is drawn in its own dimensions
      image.setFitToBox(false);
      assertFalse("getFitToBox after setFitToBox(false)", image.getFitToBox());
      assertEquals("getDw of the picture that does not fit", PICTURE_DW, image.getDw());
      assertEquals("getDh of the picture that does not fit", PICTURE_DH, image.getDh());
      image.setFitToBox(true);
      assertEquals("getDw of the fitting picture again", 80, image.getDw());
      // a picture standing in a square takes the greater side of it in both directions
      image.setInSquare(true);
      assertTrue("getInSquare after setInSquare(true)", image.getInSquare());
      assertEquals("the square is as wide as the greater side of the picture", 80, image.getDw());
      assertEquals("the square is as tall as it is wide", image.getDw(), image.getDh());
      image.setInSquare(false);
      assertFalse("getInSquare after setInSquare(false)", image.getInSquare());
      assertEquals("the picture takes its own height back", 40, image.getDh());
    }
    /**
     * Checks the handle the box of the picture is resized by hand with: it is created and
     * dropped by the state of the feature, and it leaves the picture exactly the way it
     * has found it, because nothing but a drag of it changes that box.
     * @param image the object to be tested
     */
    private function runResizableTests(image:Image):void
    {
      const boxDw:int = image.getBoxDw();
      const boxDh:int = image.getBoxDh();
      image.setResizable(true);
      assertTrue("getResizable after setResizable(true)", image.getResizable());
      assertEquals("the handle leaves the width of the box alone", boxDw, image.getBoxDw());
      assertEquals("the handle leaves the height of the box alone", boxDh, image.getBoxDh());
      image.setResizable(true);
      assertTrue("a second setResizable(true) creates no second handle", image.getResizable());
      image.setResizable(false);
      assertFalse("getResizable after setResizable(false)", image.getResizable());
      image.setResizable(false);
      assertFalse("a second setResizable(false) drops nothing else", image.getResizable());
      assertEquals("the dropped handle leaves the box alone", boxDw, image.getBoxDw());
    }
    /**
     * Checks the frame around the picture: it takes one radius of the application on
     * every side, so the picture inside it is drawn smaller and this object grows.
     * @param image the object to be tested
     */
    private function runFrameTests(image:Image):void
    {
      const radius:int = application.getDynamicsConfig().getAppRadius();
      image.setFitToBox(false);
      const dwWithoutFrame:int = image.getDw();
      const dhWithoutFrame:int = image.getDh();
      image.setFrame(true);
      assertTrue("getFrame after setFrame(true)", image.getFrame());
      assertEquals("the frame takes one radius on both sides"
        , dwWithoutFrame + 2 * radius, image.getDw());
      assertEquals("the frame takes one radius above and under"
        , dhWithoutFrame + 2 * radius, image.getDh());
      // a picture that fits to its box is shrunk into it without the frame around it
      image.setFitToBox(true);
      image.setDwh(100 + 2 * radius, 100 + 2 * radius);
      assertEquals("the framed picture is shrunk into the box", 100 + 2 * radius, image.getDw());
      assertEquals("the framed picture keeps its own ratio", 50 + 2 * radius, image.getDh());
      image.setFrame(false);
      assertFalse("getFrame after setFrame(false)", image.getFrame());
      assertEquals("the whole box belongs to the picture again", 100 + 2 * radius, image.getDw());
    }
    /**
     * Checks the fullscreen of the picture: it can only be opened while the feature of it
     * is switched on and there is a picture at all, and the switching off of that feature
     * closes an opened one.
     * @param image the object to be tested
     */
    private function runFullscreenTests(image:Image):void
    {
      image.openFullscreen();
      assertFalse("openFullscreen does nothing while the feature is switched off"
        , image.isFullscreenOpened());
      image.setFullscreenEnabled(true);
      assertTrue("getFullscreenEnabled after setFullscreenEnabled(true)", image.getFullscreenEnabled());
      image.openFullscreen();
      assertTrue("isFullscreenOpened after openFullscreen", image.isFullscreenOpened());
      image.openFullscreen();
      assertTrue("an opened fullscreen stays opened after a second open", image.isFullscreenOpened());
      image.closeFullscreen();
      assertFalse("isFullscreenOpened after closeFullscreen", image.isFullscreenOpened());
      image.closeFullscreen();
      assertFalse("a closed fullscreen stays closed after a second close", image.isFullscreenOpened());
      image.openFullscreen();
      image.setFullscreenEnabled(false);
      assertFalse("getFullscreenEnabled after setFullscreenEnabled(false)", image.getFullscreenEnabled());
      assertFalse("the switching off closes the opened fullscreen", image.isFullscreenOpened());
      // an object holding no picture has nothing to be opened
      image.setFullscreenEnabled(true);
      image.clear();
      image.openFullscreen();
      assertFalse("openFullscreen does nothing without a picture", image.isFullscreenOpened());
      image.setFullscreenEnabled(false);
      setTestPicture(image);
    }
    /**
     * Checks the react feature this component takes from its base class: the dimensions
     * set here are the ones of the picture, and the react row stands under them.
     * @param image the object to be tested
     */
    private function runReactTests(image:Image):void
    {
      image.setFitToBox(false);
      image.setFrame(false);
      assertEquals("getContentDw is the width of the picture", PICTURE_DW, image.getContentDw());
      assertEquals("getContentDh is the height of the picture", PICTURE_DH, image.getContentDh());
      assertFalse("getReactEnabled of a picture nobody has reacted to", image.getReactEnabled());
      image.setReactEnabled(true);
      image.addHit("anna", EnumEmojis.hands_thumbsup(), new Date());
      assertEquals("a picture takes the hits of the emojis", 1, image.getNumOfHits());
      assertEquals("the picture keeps its own height", PICTURE_DH, image.getContentDh());
      assertTrue("the object grows by the react row", image.getDh() > image.getContentDh());
      image.clearHits();
      image.setReactEnabled(false);
      assertEquals("the object takes its own height back", PICTURE_DH, image.getDh());
    }
    /**
     * Gives the picture every assertion of this suite works on to the given object.
     * @param image the object to be tested
     */
    private function setTestPicture(image:Image):void
    {
      const bitmapData:BitmapData = new BitmapData(PICTURE_DW, PICTURE_DH, false, 0x808080);
      image.setBitmapData(bitmapData);
      bitmapData.dispose();
    }
  }
}
