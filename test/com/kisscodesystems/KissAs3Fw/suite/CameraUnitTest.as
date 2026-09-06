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
 * CameraUnitTest
 * Checks the Camera component.
 *
 * MAIN FEATURES:
 * - the dimensions of the picture: the aspect ratio and the width it is counted from
 * - every property of the picture is refused outside the range of the configuration
 * - the photo, the settings panel and the dimensions this component drops
 * - the camera device itself is only grabbed on a machine holding none at all: a
 *   machine that holds one would be asked for the permission of it by a test run,
 *   and a device that is refused raises an alert nobody is there to answer
 * - the microphone device is picked but never grabbed either: it is grabbed together
 *   with the camera one only
 * - the muting of the two devices and the gain of the microphone: both mutes are kept by
 *   this component itself, so they stand whether there is a device grabbed or not
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumCameraResolutions;
  import com.kisscodesystems.KissAs3Fw.ui.Camera;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class CameraUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function CameraUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Camera";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      runResolutionEnumTests();
      const camera:Camera = new Camera(application);
      addTested(camera);
      // a fresh camera holds no device and no photo at all, and it stands in the values
      // the configuration of the application starts a camera with
      assertNull("getCamera of a fresh camera", camera.getCamera());
      assertFalse("isCameraAttached of a fresh camera", camera.isCameraAttached());
      assertNull("getMicrophone of a fresh camera", camera.getMicrophone());
      assertFalse("isMicrophoneAttached of a fresh camera", camera.isMicrophoneAttached());
      // both pickers of the devices stand on the first one of them, and on nothing at all
      // when this machine holds no device of that kind
      assertEquals("getSelectedDeviceIndex of a fresh camera"
        , camera.getCameraDevices().length > 0 ? 0 : -1, camera.getSelectedDeviceIndex());
      assertEquals("getSelectedMicrophoneIndex of a fresh camera"
        , camera.getMicrophoneDevices().length > 0 ? 0 : -1, camera.getSelectedMicrophoneIndex());
      assertEquals("getCameraResolution of a fresh camera"
        , EnumCameraResolutions.CAMERA_RESOLUTION_43(), camera.getCameraResolution());
      assertEquals("getCameraWidth of a fresh camera"
        , application.getComponentsConfig().getCameraWidthIni(), camera.getCameraWidth());
      assertEquals("getCameraFps of a fresh camera"
        , application.getComponentsConfig().getCameraFpsIni(), camera.getCameraFps());
      assertEquals("getCameraQuality of a fresh camera"
        , application.getComponentsConfig().getCameraQualityIni(), camera.getCameraQuality());
      assertEquals("getFilterBlur of a fresh camera"
        , application.getComponentsConfig().getCameraBlurMin(), camera.getFilterBlur());
      assertEqualsNumber("getFilterRed of a fresh camera"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterRed());
      assertEqualsNumber("getFilterGreen of a fresh camera"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterGreen());
      assertEqualsNumber("getFilterBlue of a fresh camera"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterBlue());
      assertEqualsNumber("getFilterAlpha of a fresh camera"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterAlpha());
      assertFalse("isVideoMuted of a fresh camera", camera.isVideoMuted());
      assertFalse("isSoundMuted of a fresh camera", camera.isSoundMuted());
      assertEquals("getSoundVolume of a fresh camera"
        , application.getComponentsConfig().getCameraSoundVolumeIni(), camera.getSoundVolume());
      assertEquals("getSoundLevel of a fresh camera"
        , application.getComponentsConfig().getCameraSoundVolumeMin(), camera.getSoundLevel());
      assertFalse("getResolutionFixed of a fresh camera", camera.getResolutionFixed());
      assertFalse("getSettingsVisible of a fresh camera", camera.getSettingsVisible());
      assertEquals("getPictureName of a fresh camera", "", camera.getPictureName());
      assertNull("getPictureByteArray of a fresh camera", camera.getPictureByteArray());
      assertNull("getBitmapData of a fresh camera", camera.getBitmapData());
      runDeviceTests(camera);
      runMicrophoneTests(camera);
      runMuteTests(camera);
      runDimensionsTests(camera);
      runFpsAndQualityTests(camera);
      runFilterTests(camera);
      runResetTests(camera);
      runSettingsPanelTests(camera);
      runPictureTests(camera);
      runEnabledTests(camera);
      runBaseSpriteTests(camera);
      removeTested(camera);
    }
    /**
     * Checks the enum of the aspect ratios: the height belonging to one width is counted
     * from the two numbers of the ratio itself, and a ratio nobody knows answers a square.
     */
    private function runResolutionEnumTests():void
    {
      const everyResolution:Array = EnumCameraResolutions.getEveryResolution();
      assertEquals("the number of the aspect ratios", 3, everyResolution.length);
      assertEquals("the square ratio comes first"
        , EnumCameraResolutions.CAMERA_RESOLUTION_11(), everyResolution[0]);
      assertEquals("the widescreen ratio comes last"
        , EnumCameraResolutions.CAMERA_RESOLUTION_169(), everyResolution[2]);
      everyResolution.splice(0);
      assertEquals("the height of a square picture", 640
        , EnumCameraResolutions.getHeightOfWidth(EnumCameraResolutions.CAMERA_RESOLUTION_11(), 640));
      assertEquals("the height of a television picture", 480
        , EnumCameraResolutions.getHeightOfWidth(EnumCameraResolutions.CAMERA_RESOLUTION_43(), 640));
      assertEquals("the height of a widescreen picture", 360
        , EnumCameraResolutions.getHeightOfWidth(EnumCameraResolutions.CAMERA_RESOLUTION_169(), 640));
      assertEquals("an unknown ratio answers a square", 640
        , EnumCameraResolutions.getHeightOfWidth("no such ratio", 640));
      assertEquals("a null ratio answers a square", 640
        , EnumCameraResolutions.getHeightOfWidth(null, 640));
      assertEquals("a ratio of a zero side answers a square", 640
        , EnumCameraResolutions.getHeightOfWidth("0:3", 640));
    }
    /**
     * Checks the camera devices of the machine: the names of them are handed out in a
     * copy, an index outside of them is refused, and the device is only grabbed on a
     * machine holding none at all, see the header comment lines of this suite.
     * @param camera the object to be tested
     */
    private function runDeviceTests(camera:Camera):void
    {
      const cameraDevices:Array = camera.getCameraDevices();
      for (var i:int = 0; i < cameraDevices.length; i++)
      {
        assertTrue("the name of the device of the index " + i + " is not an empty one"
          , String(cameraDevices[i]) != "");
      }
      const numOfDevices:int = cameraDevices.length;
      cameraDevices.splice(0);
      assertEquals("getCameraDevices returns a copy", numOfDevices, camera.getCameraDevices().length);
      const indexBefore:int = camera.getSelectedDeviceIndex();
      camera.setSelectedDeviceIndex(-1);
      assertEquals("a device index below the first one is refused"
        , indexBefore, camera.getSelectedDeviceIndex());
      camera.setSelectedDeviceIndex(numOfDevices);
      assertEquals("a device index above the last one is refused"
        , indexBefore, camera.getSelectedDeviceIndex());
      camera.detachCamera();
      assertFalse("detachCamera does nothing without a device", camera.isCameraAttached());
      if (camera.getCameraDevices().length > 0)
      {
        application.trace("<" + this + " CameraUnitTest runDeviceTests> this machine holds a camera device, so it is not grabbed here.", 1);
        return;
      }
      camera.attachCamera();
      assertFalse("attachCamera does nothing on a machine holding no device", camera.isCameraAttached());
      assertNull("getCamera after an attach that could not happen", camera.getCamera());
    }
    /**
     * Checks the microphone devices of the machine: the names of them are handed out in a
     * copy, an index outside of them is refused and one inside them is taken. No device is
     * grabbed at all: the microphone follows the camera, and the camera is left alone here,
     * see the header comment lines of this suite.
     * @param camera the object to be tested
     */
    private function runMicrophoneTests(camera:Camera):void
    {
      const microphoneDevices:Array = camera.getMicrophoneDevices();
      for (var i:int = 0; i < microphoneDevices.length; i++)
      {
        assertTrue("the name of the microphone of the index " + i + " is not an empty one"
          , String(microphoneDevices[i]) != "");
      }
      const numOfDevices:int = microphoneDevices.length;
      microphoneDevices.splice(0);
      assertEquals("getMicrophoneDevices returns a copy", numOfDevices
        , camera.getMicrophoneDevices().length);
      const indexBefore:int = camera.getSelectedMicrophoneIndex();
      camera.setSelectedMicrophoneIndex(-1);
      assertEquals("a microphone index below the first one is refused"
        , indexBefore, camera.getSelectedMicrophoneIndex());
      camera.setSelectedMicrophoneIndex(numOfDevices);
      assertEquals("a microphone index above the last one is refused"
        , indexBefore, camera.getSelectedMicrophoneIndex());
      camera.setSelectedMicrophoneIndex(numOfDevices - 1);
      assertEquals("the last microphone of the machine is taken"
        , numOfDevices > 0 ? numOfDevices - 1 : indexBefore, camera.getSelectedMicrophoneIndex());
      camera.setSelectedMicrophoneIndex(0);
      assertEquals("the first microphone of the machine is taken back"
        , indexBefore, camera.getSelectedMicrophoneIndex());
      assertNull("no microphone is grabbed without a camera", camera.getMicrophone());
      assertFalse("isMicrophoneAttached without a camera", camera.isMicrophoneAttached());
    }
    /**
     * Checks the muting of the two devices and the gain of the microphone: both mutes are
     * kept by this component itself, so they can be switched without a device grabbed at
     * all, a gain outside the range of the configuration is refused, and the loudness this
     * component hears is the quietest value while there is no microphone grabbed or it is
     * muted.
     * @param camera the object to be tested
     */
    private function runMuteTests(camera:Camera):void
    {
      const volumeMin:int = application.getComponentsConfig().getCameraSoundVolumeMin();
      const volumeMax:int = application.getComponentsConfig().getCameraSoundVolumeMax();
      const volumeIni:int = application.getComponentsConfig().getCameraSoundVolumeIni();
      camera.setVideoMuted(true);
      assertTrue("isVideoMuted after setVideoMuted(true)", camera.isVideoMuted());
      assertFalse("a muted picture grabs no camera device on its own", camera.isCameraAttached());
      camera.takePicture();
      assertEquals("takePicture does nothing while the picture is muted", "", camera.getPictureName());
      camera.setVideoMuted(false);
      assertFalse("isVideoMuted after setVideoMuted(false)", camera.isVideoMuted());
      camera.setSoundMuted(true);
      assertTrue("isSoundMuted after setSoundMuted(true)", camera.isSoundMuted());
      assertEquals("a muted microphone hears nothing", volumeMin, camera.getSoundLevel());
      assertEquals("the gain is kept by the muting", volumeIni, camera.getSoundVolume());
      camera.setSoundMuted(false);
      assertFalse("isSoundMuted after setSoundMuted(false)", camera.isSoundMuted());
      camera.setSoundVolume(volumeMin - 1);
      assertTrue("a gain below the quietest one is refused", camera.getSoundVolume() >= volumeMin);
      camera.setSoundVolume(volumeMax + 1);
      assertTrue("a gain above the loudest one is refused", camera.getSoundVolume() <= volumeMax);
      camera.setSoundVolume(volumeMax);
      assertEquals("getSoundVolume after setSoundVolume", volumeMax, camera.getSoundVolume());
      assertEquals("a camera holding no microphone hears nothing", volumeMin, camera.getSoundLevel());
      camera.setSoundVolume(volumeIni);
    }
    /**
     * Checks the dimensions of the picture: the height is counted from the width and from
     * the aspect ratio, both of them reach this object itself, and a width outside the
     * range of the configuration is refused.
     * @param camera the object to be tested
     */
    private function runDimensionsTests(camera:Camera):void
    {
      const widthMin:int = application.getComponentsConfig().getCameraWidthMin();
      const widthMax:int = application.getComponentsConfig().getCameraWidthMax();
      assertEquals("getCameraHeight comes from the width and the ratio"
        , EnumCameraResolutions.getHeightOfWidth(camera.getCameraResolution(), camera.getCameraWidth())
        , camera.getCameraHeight());
      assertEquals("getDw is the width of the picture", camera.getCameraWidth(), camera.getDw());
      assertEquals("getDh is the height of the picture", camera.getCameraHeight(), camera.getDh());
      camera.setCameraResolution(EnumCameraResolutions.CAMERA_RESOLUTION_169());
      assertEquals("getCameraResolution after setCameraResolution"
        , EnumCameraResolutions.CAMERA_RESOLUTION_169(), camera.getCameraResolution());
      assertEquals("the height follows the widescreen ratio"
        , EnumCameraResolutions.getHeightOfWidth(EnumCameraResolutions.CAMERA_RESOLUTION_169()
          , camera.getCameraWidth()), camera.getCameraHeight());
      assertEquals("this object follows that height", camera.getCameraHeight(), camera.getDh());
      camera.setCameraResolution("no such ratio");
      assertEquals("an unknown aspect ratio is refused"
        , EnumCameraResolutions.CAMERA_RESOLUTION_169(), camera.getCameraResolution());
      camera.setCameraWidth(widthMin - 1);
      assertTrue("a width below the smallest one is refused", camera.getCameraWidth() >= widthMin);
      camera.setCameraWidth(widthMax + 1);
      assertTrue("a width above the greatest one is refused", camera.getCameraWidth() <= widthMax);
      camera.setCameraWidth(widthMin);
      assertEquals("getCameraWidth after setCameraWidth", widthMin, camera.getCameraWidth());
      assertEquals("this object follows that width", widthMin, camera.getDw());
      camera.setCameraResolution(EnumCameraResolutions.CAMERA_RESOLUTION_11());
      assertEquals("a square picture is as tall as it is wide", camera.getDw(), camera.getDh());
      camera.setCameraResolution(EnumCameraResolutions.CAMERA_RESOLUTION_43());
      // the aspect ratio can be fixed, so the one using the application can not break the
      // shape the application displays that picture in
      camera.setResolutionFixed(true);
      assertTrue("getResolutionFixed after setResolutionFixed(true)", camera.getResolutionFixed());
      camera.setResolutionFixed(false);
      assertFalse("getResolutionFixed after setResolutionFixed(false)", camera.getResolutionFixed());
      // the dimensions of this object come from the picture, so the ones given are dropped
      const dwBefore:int = camera.getDw();
      const dhBefore:int = camera.getDh();
      camera.setDw(dwBefore + 100);
      assertEquals("getDw is not changed by setDw", dwBefore, camera.getDw());
      camera.setDh(dhBefore + 100);
      assertEquals("getDh is not changed by setDh", dhBefore, camera.getDh());
      camera.setDwh(dwBefore + 100, dhBefore + 100);
      assertEquals("getDw is not changed by setDwh", dwBefore, camera.getDw());
      assertEquals("getDh is not changed by setDwh", dhBefore, camera.getDh());
    }
    /**
     * Checks the frames per second and the quality of the picture: both of them are
     * refused outside the range of the configuration, and neither of them touches the
     * dimensions of the picture.
     * @param camera the object to be tested
     */
    private function runFpsAndQualityTests(camera:Camera):void
    {
      const fpsMin:int = application.getComponentsConfig().getCameraFpsMin();
      const fpsMax:int = application.getComponentsConfig().getCameraFpsMax();
      const qualityMin:int = application.getComponentsConfig().getCameraQualityMin();
      const qualityMax:int = application.getComponentsConfig().getCameraQualityMax();
      const dwBefore:int = camera.getDw();
      camera.setCameraFps(fpsMin - 1);
      assertTrue("a value below the fewest frames per second is refused", camera.getCameraFps() >= fpsMin);
      camera.setCameraFps(fpsMax + 1);
      assertTrue("a value above the most frames per second is refused", camera.getCameraFps() <= fpsMax);
      camera.setCameraFps(fpsMin);
      assertEquals("getCameraFps after setCameraFps", fpsMin, camera.getCameraFps());
      camera.setCameraQuality(qualityMin - 1);
      assertTrue("a value below the worst quality is refused", camera.getCameraQuality() >= qualityMin);
      camera.setCameraQuality(qualityMax + 1);
      assertTrue("a value above the best quality is refused", camera.getCameraQuality() <= qualityMax);
      camera.setCameraQuality(qualityMin);
      assertEquals("getCameraQuality after setCameraQuality", qualityMin, camera.getCameraQuality());
      assertEquals("neither of them touches the dimensions of the picture", dwBefore, camera.getDw());
    }
    /**
     * Checks the filters of the picture: the blur and the four color channels of it, every
     * one of them refused outside the range of the configuration.
     * @param camera the object to be tested
     */
    private function runFilterTests(camera:Camera):void
    {
      const blurMin:int = application.getComponentsConfig().getCameraBlurMin();
      const blurMax:int = application.getComponentsConfig().getCameraBlurMax();
      const channelMin:Number = application.getComponentsConfig().getCameraChannelMin();
      const channelMax:Number = application.getComponentsConfig().getCameraChannelMax();
      const channelAlphaMax:Number = application.getComponentsConfig().getCameraChannelAlphaMax();
      camera.setFilterBlur(blurMin - 1);
      assertTrue("a blur below the weakest one is refused", camera.getFilterBlur() >= blurMin);
      camera.setFilterBlur(blurMax + 1);
      assertTrue("a blur above the strongest one is refused", camera.getFilterBlur() <= blurMax);
      camera.setFilterBlur(blurMax);
      assertEquals("getFilterBlur after setFilterBlur", blurMax, camera.getFilterBlur());
      camera.setFilterRed(channelMax + 1);
      assertTrue("a red channel above the greatest one is refused", camera.getFilterRed() <= channelMax);
      camera.setFilterRed(channelMin - 1);
      assertTrue("a red channel below the smallest one is refused", camera.getFilterRed() >= channelMin);
      camera.setFilterRed(channelMax);
      assertEqualsNumber("getFilterRed after setFilterRed", channelMax, camera.getFilterRed());
      camera.setFilterGreen(channelMax + 1);
      assertTrue("a green channel above the greatest one is refused", camera.getFilterGreen() <= channelMax);
      camera.setFilterGreen(channelMin);
      assertEqualsNumber("getFilterGreen after setFilterGreen", channelMin, camera.getFilterGreen());
      camera.setFilterBlue(channelMax + 1);
      assertTrue("a blue channel above the greatest one is refused", camera.getFilterBlue() <= channelMax);
      camera.setFilterBlue(channelMin);
      assertEqualsNumber("getFilterBlue after setFilterBlue", channelMin, camera.getFilterBlue());
      // the alpha channel has a smaller range than the color ones: a picture can not be
      // more opaque than the one that has arrived
      camera.setFilterAlpha(channelAlphaMax + 1);
      assertTrue("an alpha channel above the greatest one is refused"
        , camera.getFilterAlpha() <= channelAlphaMax);
      camera.setFilterAlpha(channelMin);
      assertEqualsNumber("getFilterAlpha after setFilterAlpha", channelMin, camera.getFilterAlpha());
    }
    /**
     * Checks the reset of the settings: every property of the picture and of the sound
     * goes back to the value the configuration of the application starts a camera with and
     * both devices are unmuted, while the aspect ratio and the devices are kept.
     * @param camera the object to be tested
     */
    private function runResetTests(camera:Camera):void
    {
      const resolutionBefore:String = camera.getCameraResolution();
      camera.setVideoMuted(true);
      camera.setSoundMuted(true);
      camera.setSoundVolume(application.getComponentsConfig().getCameraSoundVolumeMax());
      camera.resetSettings();
      assertFalse("isVideoMuted after resetSettings", camera.isVideoMuted());
      assertFalse("isSoundMuted after resetSettings", camera.isSoundMuted());
      assertEquals("getSoundVolume after resetSettings"
        , application.getComponentsConfig().getCameraSoundVolumeIni(), camera.getSoundVolume());
      assertEquals("getCameraWidth after resetSettings"
        , application.getComponentsConfig().getCameraWidthIni(), camera.getCameraWidth());
      assertEquals("getCameraFps after resetSettings"
        , application.getComponentsConfig().getCameraFpsIni(), camera.getCameraFps());
      assertEquals("getCameraQuality after resetSettings"
        , application.getComponentsConfig().getCameraQualityIni(), camera.getCameraQuality());
      assertEquals("getFilterBlur after resetSettings"
        , application.getComponentsConfig().getCameraBlurMin(), camera.getFilterBlur());
      assertEqualsNumber("getFilterRed after resetSettings"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterRed());
      assertEqualsNumber("getFilterGreen after resetSettings"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterGreen());
      assertEqualsNumber("getFilterBlue after resetSettings"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterBlue());
      assertEqualsNumber("getFilterAlpha after resetSettings"
        , application.getComponentsConfig().getCameraChannelIni(), camera.getFilterAlpha());
      assertEquals("the aspect ratio is kept by resetSettings", resolutionBefore, camera.getCameraResolution());
    }
    /**
     * Checks the settings panel of this component: it stands over the picture of the
     * camera and it is opened and closed on demand.
     * @param camera the object to be tested
     */
    private function runSettingsPanelTests(camera:Camera):void
    {
      camera.setSettingsVisible(true);
      assertTrue("getSettingsVisible after setSettingsVisible(true)", camera.getSettingsVisible());
      camera.setSettingsVisible(false);
      assertFalse("getSettingsVisible after setSettingsVisible(false)", camera.getSettingsVisible());
    }
    /**
     * Checks the enabling of this component: a disabled camera releases its device and
     * closes its own settings panel, and an enabled one takes neither of the two back.
     * @param camera the object to be tested
     */
    private function runEnabledTests(camera:Camera):void
    {
      assertTrue("getEnabled of a fresh camera", camera.getEnabled());
      camera.setSettingsVisible(true);
      camera.setEnabled(false);
      assertFalse("getEnabled after setEnabled(false)", camera.getEnabled());
      assertFalse("setEnabled(false) closes the settings panel", camera.getSettingsVisible());
      assertFalse("setEnabled(false) releases the camera device", camera.isCameraAttached());
      camera.setEnabled(true);
      assertTrue("getEnabled after setEnabled(true)", camera.getEnabled());
      assertFalse("setEnabled(true) leaves the settings panel closed", camera.getSettingsVisible());
      assertFalse("setEnabled(true) grabs no camera device", camera.isCameraAttached());
    }
    /**
     * Checks the photo of this component: there is nothing to be taken, displayed or
     * dropped without a camera device grabbed at all.
     * @param camera the object to be tested
     */
    private function runPictureTests(camera:Camera):void
    {
      camera.takePicture();
      assertEquals("takePicture does nothing without a camera device", "", camera.getPictureName());
      assertNull("there is no byte array without a photo", camera.getPictureByteArray());
      assertNull("there is no bitmap data without a photo", camera.getBitmapData());
      camera.showPicture();
      assertNull("showPicture does nothing without a photo", camera.getBitmapData());
      camera.clearPicture();
      assertEquals("clearPicture leaves no name behind", "", camera.getPictureName());
      assertNull("clearPicture frees the byte array of the photo up", camera.getPictureByteArray());
      assertNull("clearPicture frees the bitmap data of the photo up", camera.getBitmapData());
    }
  }
}
