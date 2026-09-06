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
 * Camera.
 * The picture of one camera device of the machine, with a photo taken of it, and the
 * microphone device the sound of the very same stream comes from.
 *
 * MAIN FEATURES:
 * - it grabs and releases the camera device on demand, and it tells the outside by
 *   an event of its own which of the two has happened
 * - the microphone device is grabbed and released together with the camera one, so the
 *   application around it feeds both the picture and the sound of one outgoing stream
 *   from this single object
 * - both of those devices can be muted on their own, and the sound of the microphone
 *   carries a gain of its own as well, so a quiet microphone is a step away from a
 *   silenced one: a muted picture is an empty one and a muted microphone hears nothing
 * - the mute and the gain belong to this object and not to the device, so a device that
 *   is picked while one of them is on is grabbed in that very state
 * - the loudness the microphone hears is displayed by a bar along the bottom of the
 *   picture, so the one talking sees that the sound really arrives
 * - the camera device, the microphone device, the aspect ratio, the width, the frames
 *   per second and the quality of the picture can be changed while the camera is
 *   running
 * - the picture can be blurred and every color channel of it can be multiplied, so
 *   the filters of the outgoing stream are seen before it is started
 * - one photo can be taken of it: that photo is kept as a png byte array, so the
 *   application around it can send it or write it wherever it wants to
 * - the photo standing over the picture carries a closer of its own, so the picture of
 *   the camera comes back by one single press on it: the bitmap data and the byte array
 *   of a photo that is closed or replaced by another one are freed up right away
 * - every one of these stands on a settings panel of its own as well, which is
 *   opened by a press on the picture, so this object is usable without a single
 *   element around it
 * - that panel is opened by a press on the picture and closed by a press anywhere
 *   outside this object, and both of those are reported by the changed event of it, so
 *   the one holding this object follows the panel the very way it follows every setting
 * - the dimensions of it come from the picture of the camera, so the ones given
 *   from the outside are dropped
 * - a camera is usable in landscape only: the picture of it is a landscape one
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseAlerter;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumCameraResolutions;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.BitmapData;
  import flash.display.PNGEncoderOptions;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.StatusEvent;
  import flash.events.TimerEvent;
  import flash.filters.BlurFilter;
  import flash.filters.ColorMatrixFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.media.Microphone;
  import flash.media.SoundTransform;
  import flash.media.Video;
  import flash.utils.ByteArray;
  import flash.utils.Timer;
  public class Camera extends BaseAlerter
  {
    // the sprite the picture of the camera is displayed on, the one every filter is
    // applied to, and the mask keeping that picture inside the rounded corners
    private var videoSprite:BaseSprite = null;
    private var maskShape:BaseShape = null;
    // the frame drawn around the picture and the transparent surface the press opening
    // the settings panel arrives on
    private var frameShape:BaseShape = null;
    private var clickSprite:BaseSprite = null;
    // the link grabbing the camera device, the one that is seen while there is no
    // picture at all
    private var attachButtonLink:ButtonLink = null;
    // the settings panel and every element standing on it
    private var settingsContent:ContentSingle = null;
    private var detachButtonLink:ButtonLink = null;
    private var takePictureButtonText:ButtonText = null;
    private var resetButtonLink:ButtonLink = null;
    private var deviceTextLabel:TextLabel = null;
    private var deviceListPicker:ListPicker = null;
    private var videoMuteButtonLink:ButtonLink = null;
    private var microphoneTextLabel:TextLabel = null;
    private var microphoneListPicker:ListPicker = null;
    private var soundMuteButtonLink:ButtonLink = null;
    private var soundVolumePotmeter:Potmeter = null;
    private var resolutionTextLabel:TextLabel = null;
    private var resolutionListPicker:ListPicker = null;
    private var widthTextLabel:TextLabel = null;
    private var widthPotmeter:Potmeter = null;
    private var fpsTextLabel:TextLabel = null;
    private var fpsPotmeter:Potmeter = null;
    private var qualityTextLabel:TextLabel = null;
    private var qualityPotmeter:Potmeter = null;
    private var blurTextLabel:TextLabel = null;
    private var blurPotmeter:Potmeter = null;
    private var colorsTextLabel:TextLabel = null;
    private var redPotmeter:Potmeter = null;
    private var greenPotmeter:Potmeter = null;
    private var bluePotmeter:Potmeter = null;
    private var alphaPotmeter:Potmeter = null;
    // the bar displaying the loudness the microphone hears at the moment and the timer
    // reading that loudness again and again: a device tells it while it is grabbed only
    private var soundLevelSprite:BaseSprite = null;
    private var soundLevelTimer:Timer = null;
    // the timer keeping the button of the photo out of reach for a while after a photo
    // has been taken: a camera needs a moment to be usable again
    private var takePictureTimer:Timer = null;
    // the photo that has been taken, the name of it and the closer dropping it, every
    // one of them displayed over the picture
    private var pictureSprite:BaseSprite = null;
    private var pictureNameTextLabel:TextLabel = null;
    private var pictureCloserButtonLink:ButtonLink = null;
    // the camera device and the video object displaying the picture of it
    private var camera:flash.media.Camera = null;
    private var video:Video = null;
    // the microphone device the sound of the outgoing stream comes from
    private var microphone:Microphone = null;
    // the names of every camera and every microphone device of the machine
    private var cameraDevices:Array = null;
    private var microphoneDevices:Array = null;
    // the properties of the picture of the camera
    private var cameraResolution:String = "";
    private var cameraWidth:int = 0;
    private var cameraHeight:int = 0;
    private var cameraFps:int = 0;
    private var cameraQuality:int = 0;
    private var resolutionFixed:Boolean = false;
    // The muting of the two devices and the gain the microphone is asked for. Both mutes
    // and that gain belong to this object and not to the devices, so a device that is
    // picked while one of them is on is grabbed in that very state.
    private var videoMuted:Boolean = false;
    private var soundMuted:Boolean = false;
    private var soundVolume:int = 0;
    // the filters of the picture and the values they are built of
    private var blurFilter:BlurFilter = null;
    private var colorMatrixFilter:ColorMatrixFilter = null;
    private var filterBlur:int = 0;
    private var filterRed:Number = 0;
    private var filterGreen:Number = 0;
    private var filterBlue:Number = 0;
    private var filterAlpha:Number = 0;
    // the photo of the camera: the bitmap data of it, the png byte array written from
    // that bitmap data and the name it has been taken under
    private var bitmapData:BitmapData = null;
    private var pictureByteArray:ByteArray = null;
    private var pictureName:String = "";
    private var eventCameraIsAttached:Event = null;
    private var eventCameraIsDetached:Event = null;
    private var eventChanged:Event = null;
    private var eventPictureTaken:Event = null;
    /**
     * Constructs the Camera object: creates the surface of the picture, the settings
     * panel of it and every element standing on that panel, and starts to follow the
     * appearance of the application. No device is grabbed here, neither the camera nor
     * the microphone one: the one using the application is the one allowing that.
     * @param applicationRef the main application reference
     */
    public function Camera(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Camera> called.", 1);
      application.trace("<" + this + " Camera> applicationRef: " + applicationRef, 0);
      cameraResolution = EnumCameraResolutions.CAMERA_RESOLUTION_43();
      cameraWidth = application.getComponentsConfig().getCameraWidthIni();
      cameraFps = application.getComponentsConfig().getCameraFpsIni();
      cameraQuality = application.getComponentsConfig().getCameraQualityIni();
      soundVolume = application.getComponentsConfig().getCameraSoundVolumeIni();
      filterBlur = application.getComponentsConfig().getCameraBlurMin();
      filterRed = application.getComponentsConfig().getCameraChannelIni();
      filterGreen = application.getComponentsConfig().getCameraChannelIni();
      filterBlue = application.getComponentsConfig().getCameraChannelIni();
      filterAlpha = application.getComponentsConfig().getCameraChannelIni();
      cameraHeight = EnumCameraResolutions.getHeightOfWidth(cameraResolution, cameraWidth);
      cameraDevices = new Array();
      const cameraNames:Array = flash.media.Camera.names;
      pushDeviceNames(cameraDevices, cameraNames);
      cameraNames.splice(0);
      microphoneDevices = new Array();
      const microphoneNames:Array = Microphone.names;
      pushDeviceNames(microphoneDevices, microphoneNames);
      microphoneNames.splice(0);
      eventCameraIsAttached = new Event(EnumEvents.EVENT_CAMERA_IS_ATTACHED());
      eventCameraIsDetached = new Event(EnumEvents.EVENT_CAMERA_IS_DETACHED());
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventPictureTaken = new Event(EnumEvents.EVENT_SAVED());
      videoSprite = new BaseSprite(application);
      addChild(videoSprite);
      maskShape = new BaseShape(application);
      addChild(maskShape);
      maskShape.setIsFilled(true);
      maskShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      videoSprite.mask = maskShape;
      frameShape = new BaseShape(application);
      addChild(frameShape);
      frameShape.setIsBright(true);
      frameShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      clickSprite = new BaseSprite(application);
      addChild(clickSprite);
      clickSprite.addEventListener(MouseEvent.MOUSE_DOWN, clickSpriteMouseDown);
      attachButtonLink = new ButtonLink(application);
      addChild(attachButtonLink);
      attachButtonLink.setLabel(EnumTextKeys.ACTIVATE_CAMERA());
      attachButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), attachButtonLinkClicked);
      createSettingsContent();
      // the bar of the loudness stands over everything else of this object, so it is
      // seen while the settings panel is opened as well
      soundLevelSprite = new BaseSprite(application);
      addChild(soundLevelSprite);
      soundLevelSprite.mouseEnabled = false;
      soundLevelSprite.mouseChildren = false;
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      displayVideoMuted();
      displaySound();
      reposResizeEverything();
      application.trace("<" + this + " Camera> constructed.", 1);
    }
    /**
     * Returns the camera device of this object, a null one when there is none grabbed at
     * the moment. It is the very object an outgoing stream is fed from.
     */
    public function getCamera():flash.media.Camera
    {
      return camera;
    }
    /**
     * Returns the microphone device of this object, a null one when there is none
     * grabbed at the moment. It is the very object the sound of an outgoing stream is
     * fed from.
     */
    public function getMicrophone():Microphone
    {
      return microphone;
    }
    /**
     * Tells whether there is a camera device grabbed by this object at the moment.
     */
    public function isCameraAttached():Boolean
    {
      return camera != null;
    }
    /**
     * Tells whether there is a microphone device grabbed by this object at the moment. A
     * machine holding no microphone at all leaves this object without one, so a grabbed
     * camera does not mean a grabbed microphone as well.
     */
    public function isMicrophoneAttached():Boolean
    {
      return microphone != null;
    }
    /**
     * Grabs the camera device the picker of the cameras stands on, starts to display the
     * picture of it and grabs the picked microphone device with it. The devices of the
     * machine are read again first: one of them can be plugged in or taken away while the
     * application is running. A machine holding no camera at all, a portrait screen and a
     * device that is muted or busy leave this object as it has been: the picture of a
     * camera is a landscape one, and a device nobody allows can not be grabbed.
     */
    public function attachCamera():void
    {
      application.trace("<" + this + " Camera attachCamera> called.", 1);
      if (isCameraAttached())
      {
        application.trace("<" + this + " Camera attachCamera> there is a camera device grabbed already.", 1);
        return;
      }
      refreshCameraDevices();
      if (cameraDevices.length < 1)
      {
        application.trace("<" + this + " Camera attachCamera> this machine holds no camera device at all!", 6);
        showAlert(EnumTextKeys.REQUIRED_PERMISSIONS_ALERT());
        return;
      }
      if (!weAreInLandscape())
      {
        application.trace("<" + this + " Camera attachCamera> a camera is usable in landscape only.", 1);
        showAlert(EnumTextKeys.CAMERA_IS_USABLE_IN_HORIZONTAL());
        return;
      }
      clearPicture();
      camera = flash.media.Camera.getCamera("" + deviceListPicker.getSelectedIndex());
      if (camera == null)
      {
        application.trace("<" + this + " Camera attachCamera> the picked device could not be grabbed, the default one comes.", 0);
        camera = flash.media.Camera.getCamera();
      }
      if (camera == null || camera.muted)
      {
        application.trace("<" + this + " Camera attachCamera> there is no camera device to be used!", 6);
        detachCamera();
        showAlert(EnumTextKeys.REQUIRED_PERMISSIONS_ALERT());
        return;
      }
      camera.setMode(cameraWidth, cameraHeight, cameraFps);
      camera.setQuality(0, cameraQuality);
      camera.addEventListener(StatusEvent.STATUS, cameraStatus);
      attachMicrophone();
      createVideo();
      attachButtonLink.setSpriteVisible(false);
      detachButtonLink.setSpriteVisible(true);
      refreshTakePictureButtonText();
      getBaseEventDispatcher().dispatchEvent(eventCameraIsAttached);
    }
    /**
     * Releases the camera device of this object together with the microphone one and
     * takes the picture of the camera away. A released device is usable by everything
     * else on the machine again.
     */
    public function detachCamera():void
    {
      application.trace("<" + this + " Camera detachCamera> called.", 1);
      const wasAttached:Boolean = isCameraAttached();
      dropVideo();
      if (camera != null)
      {
        camera.removeEventListener(StatusEvent.STATUS, cameraStatus);
        camera = null;
      }
      detachMicrophone();
      attachButtonLink.setSpriteVisible(true);
      attachButtonLink.toTheHighestDepth();
      detachButtonLink.setSpriteVisible(false);
      setSettingsVisible(false);
      refreshTakePictureButtonText();
      if (wasAttached)
      {
        getBaseEventDispatcher().dispatchEvent(eventCameraIsDetached);
      }
    }
    /**
     * Returns the name of every camera device of this machine. The array is a copy, so
     * the caller can do whatever it wants to with it.
     */
    public function getCameraDevices():Array
    {
      return cameraDevices.concat();
    }
    /**
     * Returns the name of every microphone device of this machine. The array is a copy,
     * so the caller can do whatever it wants to with it.
     */
    public function getMicrophoneDevices():Array
    {
      return microphoneDevices.concat();
    }
    /**
     * Returns the index of the camera device this object grabs, the one the picker of
     * the cameras stands on.
     */
    public function getSelectedDeviceIndex():int
    {
      return deviceListPicker.getSelectedIndex();
    }
    /**
     * Takes the camera device of the given index. A device that is grabbed at the moment
     * is released first, and the new one is grabbed in its place right away.
     * @param index the index of the device inside the devices of this machine
     */
    public function setSelectedDeviceIndex(index:int):void
    {
      application.trace("<" + this + " Camera setSelectedDeviceIndex> called.", 1);
      application.trace("<" + this + " Camera setSelectedDeviceIndex> index: " + index, 0);
      if (index < 0 || index >= cameraDevices.length)
      {
        application.trace("<" + this + " Camera setSelectedDeviceIndex> there is no device of this index!", 6);
        return;
      }
      deviceListPicker.setSelectedIndex(index, false);
      if (isCameraAttached())
      {
        detachCamera();
        attachCamera();
      }
    }
    /**
     * Tells whether the picture of the camera is muted at the moment.
     */
    public function isVideoMuted():Boolean
    {
      return videoMuted;
    }
    /**
     * Mutes or unmutes the picture of the camera: a muted one displays nothing at all and
     * the video object of it is freed up, while the device itself is kept grabbed, so the
     * picture comes back the moment it is unmuted. The mute belongs to this object and not
     * to the device, so a camera that is picked while it is on is grabbed muted as well,
     * and the icon of the button of the picture tells which of the two states is on.
     * @param b true when the picture has to be muted
     */
    public function setVideoMuted(b:Boolean):void
    {
      application.trace("<" + this + " Camera setVideoMuted> called.", 1);
      application.trace("<" + this + " Camera setVideoMuted> b: " + b, 0);
      if (videoMuted == b)
      {
        application.trace("<" + this + " Camera setVideoMuted> nothing to do.", 1);
        return;
      }
      videoMuted = b;
      if (videoMuted)
      {
        dropVideo();
      }
      else
      {
        createVideo();
      }
      displayVideoMuted();
      refreshTakePictureButtonText();
      dispatchEventChanged();
    }
    /**
     * Returns the index of the microphone device this object grabs, the one the picker of
     * the microphones stands on.
     */
    public function getSelectedMicrophoneIndex():int
    {
      return microphoneListPicker.getSelectedIndex();
    }
    /**
     * Takes the microphone device of the given index. The picture of the camera is left
     * alone: a device that is grabbed at the moment is released and the new one is
     * grabbed in its place right away, and the changed event of this object tells the
     * outside that the sound of the outgoing stream has to be fed from another device
     * from now on.
     * @param index the index of the device inside the microphones of this machine
     */
    public function setSelectedMicrophoneIndex(index:int):void
    {
      application.trace("<" + this + " Camera setSelectedMicrophoneIndex> called.", 1);
      application.trace("<" + this + " Camera setSelectedMicrophoneIndex> index: " + index, 0);
      if (index < 0 || index >= microphoneDevices.length)
      {
        application.trace("<" + this + " Camera setSelectedMicrophoneIndex> there is no device of this index!", 6);
        return;
      }
      microphoneListPicker.setSelectedIndex(index, false);
      if (isCameraAttached())
      {
        detachMicrophone();
        attachMicrophone();
        dispatchEventChanged();
      }
    }
    /**
     * Tells whether the microphone of this object is muted at the moment.
     */
    public function isSoundMuted():Boolean
    {
      return soundMuted;
    }
    /**
     * Mutes or unmutes the microphone of this object: a muted one is asked for the
     * quietest gain of the configuration, so it hears nothing at all and the outgoing
     * stream this object is fed into carries no sound. The gain the potmeter of the sound
     * stands on is kept, so an unmuted microphone goes on with that very gain, the mute
     * belongs to this object and not to the device, so a microphone that is picked while
     * it is on is grabbed muted as well, and the icon of the button of the sound tells
     * which of the two states is on.
     * @param b true when the microphone has to be muted
     */
    public function setSoundMuted(b:Boolean):void
    {
      application.trace("<" + this + " Camera setSoundMuted> called.", 1);
      application.trace("<" + this + " Camera setSoundMuted> b: " + b, 0);
      if (soundMuted == b)
      {
        application.trace("<" + this + " Camera setSoundMuted> nothing to do.", 1);
        return;
      }
      soundMuted = b;
      displaySound();
      dispatchEventChanged();
    }
    /**
     * Returns the gain the microphone of this object is asked for, a value between the
     * quietest and the loudest one of the configuration. A muted microphone keeps this
     * value: the mute above is the one telling whether it is really asked for at all.
     */
    public function getSoundVolume():int
    {
      return soundVolume;
    }
    /**
     * Takes the gain the microphone of this object has to be asked for and takes the
     * potmeter of the sound onto that value. A quieter microphone hears less of what is
     * said in front of it, so the sound of the outgoing stream this object is fed into is
     * a quieter one as well, and the icon of the button of the sound follows the new value
     * too. A value outside the range of the configuration is refused.
     * @param v the new gain of the microphone
     */
    public function setSoundVolume(v:int):void
    {
      application.trace("<" + this + " Camera setSoundVolume> called.", 1);
      application.trace("<" + this + " Camera setSoundVolume> v: " + v, 0);
      if (v < application.getComponentsConfig().getCameraSoundVolumeMin()
        || v > application.getComponentsConfig().getCameraSoundVolumeMax())
      {
        application.trace("<" + this + " Camera setSoundVolume> this is out of the range of a camera!", 6);
        return;
      }
      if (soundVolume == v)
      {
        application.trace("<" + this + " Camera setSoundVolume> nothing to do.", 1);
        return;
      }
      soundVolume = v;
      soundVolumePotmeter.setCurValue(soundVolume, false);
      displaySound();
      dispatchEventChanged();
    }
    /**
     * Returns the loudness the microphone of this object hears at the moment. It is
     * measured on the very same scale as the gain above, so it is a value between the
     * quietest and the loudest one of the configuration. An object holding no microphone at
     * all and a muted one hear nothing, and so does a device that is grabbed but has not
     * been asked about it yet: every one of these answers the quietest value. The bar of
     * the loudness reads this many times in one single second, so it is logged on the level
     * of the enter frame and of the mouse move handlers: a calling entry of it would flood
     * the logger.
     */
    public function getSoundLevel():int
    {
      application.trace("<" + this + " Camera getSoundLevel> called.", 0);
      const volumeMin:int = application.getComponentsConfig().getCameraSoundVolumeMin();
      if (microphone == null || soundMuted)
      {
        return volumeMin;
      }
      return Math.min(application.getComponentsConfig().getCameraSoundVolumeMax()
          , Math.max(volumeMin, int(microphone.activityLevel)));
    }
    /**
     * Returns the aspect ratio the picture of the camera is displayed in, an
     * EnumCameraResolutions value.
     */
    public function getCameraResolution():String
    {
      return cameraResolution;
    }
    /**
     * Takes the aspect ratio the picture of the camera has to be displayed in. The
     * height comes from that ratio and from the width, so the picture and this object
     * are resized by it.
     * @param resolution the new aspect ratio, an EnumCameraResolutions value
     */
    public function setCameraResolution(resolution:String):void
    {
      application.trace("<" + this + " Camera setCameraResolution> called.", 1);
      application.trace("<" + this + " Camera setCameraResolution> resolution: " + resolution, 0);
      if (EnumCameraResolutions.getEveryResolution().indexOf(resolution) < 0)
      {
        application.trace("<" + this + " Camera setCameraResolution> there is no such aspect ratio!", 6);
        return;
      }
      if (cameraResolution == resolution)
      {
        application.trace("<" + this + " Camera setCameraResolution> nothing to do.", 1);
        return;
      }
      cameraResolution = resolution;
      resolutionListPicker.setSelectedIndex(EnumCameraResolutions.getEveryResolution().indexOf(cameraResolution), false);
      applyCameraMode();
    }
    /**
     * Tells whether the aspect ratio of the picture of the camera can be changed by the
     * one using the application.
     */
    public function getResolutionFixed():Boolean
    {
      return resolutionFixed;
    }
    /**
     * Fixes the aspect ratio of the picture of the camera or lets it be changed again.
     * An application that displays the picture of a camera in one single shape of its
     * own fixes it, so the one using that application can not break that shape.
     * @param b true when that ratio has to be fixed
     */
    public function setResolutionFixed(b:Boolean):void
    {
      application.trace("<" + this + " Camera setResolutionFixed> called.", 1);
      application.trace("<" + this + " Camera setResolutionFixed> b: " + b, 0);
      resolutionFixed = b;
      resolutionListPicker.setEnabled(!resolutionFixed);
    }
    /**
     * Returns the width the picture of the camera is displayed in.
     */
    public function getCameraWidth():int
    {
      return cameraWidth;
    }
    /**
     * Takes the width the picture of the camera has to be displayed in. The height comes
     * from that width and from the aspect ratio, so the picture and this object are
     * resized by it. A width outside the range of the configuration is refused.
     * @param newWidth the new width of the picture
     */
    public function setCameraWidth(newWidth:int):void
    {
      application.trace("<" + this + " Camera setCameraWidth> called.", 1);
      application.trace("<" + this + " Camera setCameraWidth> newWidth: " + newWidth, 0);
      if (newWidth < application.getComponentsConfig().getCameraWidthMin()
        || newWidth > application.getComponentsConfig().getCameraWidthMax())
      {
        application.trace("<" + this + " Camera setCameraWidth> this width is out of the range of a camera!", 6);
        return;
      }
      if (cameraWidth == newWidth)
      {
        application.trace("<" + this + " Camera setCameraWidth> nothing to do.", 1);
        return;
      }
      cameraWidth = newWidth;
      widthPotmeter.setCurValue(cameraWidth, false);
      applyCameraMode();
    }
    /**
     * Returns the height the picture of the camera is displayed in: the one belonging to
     * the width of it in the current aspect ratio.
     */
    public function getCameraHeight():int
    {
      return cameraHeight;
    }
    /**
     * Returns the frames per second the camera is asked for.
     */
    public function getCameraFps():int
    {
      return cameraFps;
    }
    /**
     * Takes the frames per second the camera has to be asked for. The picture keeps its
     * dimensions, so it is not rebuilt at all. A value outside the range of the
     * configuration is refused.
     * @param newFps the new frames per second
     */
    public function setCameraFps(newFps:int):void
    {
      application.trace("<" + this + " Camera setCameraFps> called.", 1);
      application.trace("<" + this + " Camera setCameraFps> newFps: " + newFps, 0);
      if (newFps < application.getComponentsConfig().getCameraFpsMin()
        || newFps > application.getComponentsConfig().getCameraFpsMax())
      {
        application.trace("<" + this + " Camera setCameraFps> this is out of the range of a camera!", 6);
        return;
      }
      if (cameraFps == newFps)
      {
        application.trace("<" + this + " Camera setCameraFps> nothing to do.", 1);
        return;
      }
      cameraFps = newFps;
      fpsPotmeter.setCurValue(cameraFps, false);
      if (camera != null)
      {
        camera.setMode(cameraWidth, cameraHeight, cameraFps);
      }
      dispatchEventChanged();
    }
    /**
     * Returns the quality the camera is asked for.
     */
    public function getCameraQuality():int
    {
      return cameraQuality;
    }
    /**
     * Takes the quality the camera has to be asked for. The picture keeps its dimensions,
     * so it is not rebuilt at all. A value outside the range of the configuration is
     * refused.
     * @param newQuality the new quality
     */
    public function setCameraQuality(newQuality:int):void
    {
      application.trace("<" + this + " Camera setCameraQuality> called.", 1);
      application.trace("<" + this + " Camera setCameraQuality> newQuality: " + newQuality, 0);
      if (newQuality < application.getComponentsConfig().getCameraQualityMin()
        || newQuality > application.getComponentsConfig().getCameraQualityMax())
      {
        application.trace("<" + this + " Camera setCameraQuality> this is out of the range of a camera!", 6);
        return;
      }
      if (cameraQuality == newQuality)
      {
        application.trace("<" + this + " Camera setCameraQuality> nothing to do.", 1);
        return;
      }
      cameraQuality = newQuality;
      qualityPotmeter.setCurValue(cameraQuality, false);
      if (camera != null)
      {
        camera.setQuality(0, cameraQuality);
      }
      dispatchEventChanged();
    }
    /**
     * Returns the strength of the blur of the picture of the camera, a zero when that
     * picture is not blurred at all.
     */
    public function getFilterBlur():int
    {
      return filterBlur;
    }
    /**
     * Blurs the picture of the camera. The blur belongs to the picture and not to the
     * camera itself, so an outgoing stream carries the untouched picture.
     * @param newBlur the strength of the blur, a zero for no blur at all
     */
    public function setFilterBlur(newBlur:int):void
    {
      application.trace("<" + this + " Camera setFilterBlur> called.", 1);
      application.trace("<" + this + " Camera setFilterBlur> newBlur: " + newBlur, 0);
      if (newBlur < application.getComponentsConfig().getCameraBlurMin()
        || newBlur > application.getComponentsConfig().getCameraBlurMax())
      {
        application.trace("<" + this + " Camera setFilterBlur> this is out of the range of a camera!", 6);
        return;
      }
      if (filterBlur == newBlur)
      {
        application.trace("<" + this + " Camera setFilterBlur> nothing to do.", 1);
        return;
      }
      filterBlur = newBlur;
      blurPotmeter.setCurValue(filterBlur, false);
      applyFilters();
      dispatchEventChanged();
    }
    /**
     * Returns the value the red channel of the picture of the camera is multiplied by.
     */
    public function getFilterRed():Number
    {
      return filterRed;
    }
    /**
     * Multiplies the red channel of the picture of the camera by the given value.
     * @param n the new value of that channel
     */
    public function setFilterRed(n:Number):void
    {
      application.trace("<" + this + " Camera setFilterRed> called.", 1);
      application.trace("<" + this + " Camera setFilterRed> n: " + n, 0);
      if (!channelValueIsValid(n, application.getComponentsConfig().getCameraChannelMax()))
      {
        application.trace("<" + this + " Camera setFilterRed> this is out of the range of a channel!", 6);
        return;
      }
      filterRed = n;
      redPotmeter.setCurValue(filterRed, false);
      applyFilters();
      dispatchEventChanged();
    }
    /**
     * Returns the value the green channel of the picture of the camera is multiplied by.
     */
    public function getFilterGreen():Number
    {
      return filterGreen;
    }
    /**
     * Multiplies the green channel of the picture of the camera by the given value.
     * @param n the new value of that channel
     */
    public function setFilterGreen(n:Number):void
    {
      application.trace("<" + this + " Camera setFilterGreen> called.", 1);
      application.trace("<" + this + " Camera setFilterGreen> n: " + n, 0);
      if (!channelValueIsValid(n, application.getComponentsConfig().getCameraChannelMax()))
      {
        application.trace("<" + this + " Camera setFilterGreen> this is out of the range of a channel!", 6);
        return;
      }
      filterGreen = n;
      greenPotmeter.setCurValue(filterGreen, false);
      applyFilters();
      dispatchEventChanged();
    }
    /**
     * Returns the value the blue channel of the picture of the camera is multiplied by.
     */
    public function getFilterBlue():Number
    {
      return filterBlue;
    }
    /**
     * Multiplies the blue channel of the picture of the camera by the given value.
     * @param n the new value of that channel
     */
    public function setFilterBlue(n:Number):void
    {
      application.trace("<" + this + " Camera setFilterBlue> called.", 1);
      application.trace("<" + this + " Camera setFilterBlue> n: " + n, 0);
      if (!channelValueIsValid(n, application.getComponentsConfig().getCameraChannelMax()))
      {
        application.trace("<" + this + " Camera setFilterBlue> this is out of the range of a channel!", 6);
        return;
      }
      filterBlue = n;
      bluePotmeter.setCurValue(filterBlue, false);
      applyFilters();
      dispatchEventChanged();
    }
    /**
     * Returns the value the alpha channel of the picture of the camera is multiplied by.
     */
    public function getFilterAlpha():Number
    {
      return filterAlpha;
    }
    /**
     * Multiplies the alpha channel of the picture of the camera by the given value. A
     * picture that is not fully opaque takes the background of the application under it
     * into the photo as well, so that photo has no transparent pixel either way.
     * @param n the new value of that channel
     */
    public function setFilterAlpha(n:Number):void
    {
      application.trace("<" + this + " Camera setFilterAlpha> called.", 1);
      application.trace("<" + this + " Camera setFilterAlpha> n: " + n, 0);
      if (!channelValueIsValid(n, application.getComponentsConfig().getCameraChannelAlphaMax()))
      {
        application.trace("<" + this + " Camera setFilterAlpha> this is out of the range of a channel!", 6);
        return;
      }
      filterAlpha = n;
      alphaPotmeter.setCurValue(filterAlpha, false);
      applyFilters();
      dispatchEventChanged();
    }
    /**
     * Takes every property of the picture of the camera and of the sound of the
     * microphone back to the value the configuration of the application starts a brand new
     * camera with, and unmutes both of those devices. The two devices themselves and the
     * aspect ratio are kept: those tell what this object is working with at all.
     */
    public function resetSettings():void
    {
      application.trace("<" + this + " Camera resetSettings> called.", 1);
      setVideoMuted(false);
      setSoundMuted(false);
      setSoundVolume(application.getComponentsConfig().getCameraSoundVolumeIni());
      setCameraWidth(application.getComponentsConfig().getCameraWidthIni());
      setCameraFps(application.getComponentsConfig().getCameraFpsIni());
      setCameraQuality(application.getComponentsConfig().getCameraQualityIni());
      setFilterBlur(application.getComponentsConfig().getCameraBlurMin());
      setFilterRed(application.getComponentsConfig().getCameraChannelIni());
      setFilterGreen(application.getComponentsConfig().getCameraChannelIni());
      setFilterBlue(application.getComponentsConfig().getCameraChannelIni());
      setFilterAlpha(application.getComponentsConfig().getCameraChannelIni());
    }
    /**
     * Enables or disables this object. A disabled camera releases its device right away
     * and closes its own settings panel with it: a picture nobody is allowed to touch is
     * one that could never be stopped again. The link grabbing the device is disabled as
     * well, and so is every element of that panel, so a disabled camera holds nothing that
     * could be pressed or dragged at all. The button of the photo follows the device and
     * the delay of the previous photo as well: an enabled camera is not a ready one on its
     * own.
     * @param e true when this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Camera setEnabled> called.", 1);
      application.trace("<" + this + " Camera setEnabled> e: " + e, 0);
      if (getEnabled() && !e)
      {
        detachCamera();
      }
      super.setEnabled(e);
      clickSprite.mouseEnabled = getEnabled();
      settingsContent.mouseChildren = getEnabled();
      attachButtonLink.setEnabled(getEnabled());
      refreshTakePictureButtonText();
      if (pictureCloserButtonLink != null)
      {
        pictureCloserButtonLink.setEnabled(getEnabled());
      }
    }
    /**
     * Tells whether the settings panel of this object is displayed at the moment.
     */
    public function getSettingsVisible():Boolean
    {
      return settingsContent.visible;
    }
    /**
     * Displays the settings panel of this object over the picture of the camera, or takes
     * it away, and tells the outside about it. That panel is opened by a press on the
     * picture as well, and it is closed by a press anywhere outside this object, so the
     * one holding this object follows those two presses by the changed event of it.
     * @param b true when that panel has to be displayed
     */
    public function setSettingsVisible(b:Boolean):void
    {
      application.trace("<" + this + " Camera setSettingsVisible> called.", 1);
      application.trace("<" + this + " Camera setSettingsVisible> b: " + b, 0);
      if (getSettingsVisible() == b)
      {
        application.trace("<" + this + " Camera setSettingsVisible> nothing to do.", 1);
        return;
      }
      settingsContent.visible = b;
      if (stage != null)
      {
        if (b)
        {
          stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        }
        else
        {
          stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
        }
      }
      else
      {
        application.trace("<" + this + " Camera setSettingsVisible> there is no stage to be listened to.", 1);
      }
      dispatchEventChanged();
    }
    /**
     * Takes one photo of the picture of the camera: it is drawn into a bitmap data, that
     * bitmap data is written into a png byte array and it is displayed over the camera,
     * with the name it has been taken under. The camera device is released right after
     * that drawing, because the photo is the very thing that has been asked for, and the
     * photo is displayed over the released picture afterwards, so it covers the link
     * grabbing the device again: the closer of that photo is the one taking the picture of
     * the camera back. The button of the photo is taken out of reach for the delay the
     * configuration of the application tells: a camera that has just been released is not
     * one to be pressed again right away. An object holding no camera at all and one whose
     * picture is muted have nothing to take a photo of.
     */
    public function takePicture():void
    {
      application.trace("<" + this + " Camera takePicture> called.", 1);
      if (!isCameraAttached())
      {
        application.trace("<" + this + " Camera takePicture> there is no camera device to take a photo of!", 6);
        return;
      }
      if (videoMuted)
      {
        application.trace("<" + this + " Camera takePicture> the picture of the camera is muted!", 6);
        return;
      }
      clearPicture();
      bitmapData = new BitmapData(cameraWidth, cameraHeight, true, 0);
      // the mask, the frame, the settings panel and the bar of the loudness do not belong
      // to the photo, and the mask has to be taken off the picture as well: a masked
      // sprite is not drawn at all
      maskShape.visible = false;
      frameShape.visible = false;
      const settingsWereVisible:Boolean = getSettingsVisible();
      settingsContent.visible = false;
      soundLevelSprite.visible = false;
      videoSprite.mask = null;
      copyApplicationBackground();
      bitmapData.draw(this);
      maskShape.visible = true;
      frameShape.visible = true;
      settingsContent.visible = settingsWereVisible;
      soundLevelSprite.visible = true;
      videoSprite.mask = maskShape;
      pictureName = createPictureName();
      pictureByteArray = new ByteArray();
      bitmapData.encode(new Rectangle(0, 0, cameraWidth, cameraHeight)
          , new PNGEncoderOptions(false), pictureByteArray);
      detachCamera();
      showPicture();
      startTakePictureTimer();
      getBaseEventDispatcher().dispatchEvent(eventPictureTaken);
    }
    /**
     * Returns the name of the photo of this object, an empty string when there is no
     * photo at all. It is the moment the photo has been taken at, so a folder of the
     * photos of one camera stands in the order they have been taken in.
     */
    public function getPictureName():String
    {
      return pictureName;
    }
    /**
     * Returns the png byte array of the photo of this object, a null one when there is no
     * photo at all. The application around this object is the one writing it into a file
     * or sending it to a server: this object only takes it.
     */
    public function getPictureByteArray():ByteArray
    {
      return pictureByteArray;
    }
    /**
     * Returns the bitmap data of the photo of this object, a null one when there is no
     * photo at all.
     */
    public function getBitmapData():BitmapData
    {
      return bitmapData;
    }
    /**
     * Displays the photo of this object over the picture of the camera, with the name it
     * has been taken under standing in the bottom right corner of it and the closer
     * dropping it in the top right one. An object holding no photo at all has nothing to
     * display.
     */
    public function showPicture():void
    {
      application.trace("<" + this + " Camera showPicture> called.", 1);
      dropPictureObjects();
      if (bitmapData == null)
      {
        application.trace("<" + this + " Camera showPicture> there is no photo to be displayed.", 1);
        return;
      }
      pictureSprite = new BaseSprite(application);
      addChild(pictureSprite);
      pictureSprite.graphics.beginBitmapFill(bitmapData, null, false, true);
      pictureSprite.graphics.drawRect(0, 0, cameraWidth, cameraHeight);
      pictureSprite.graphics.endFill();
      pictureNameTextLabel = new TextLabel(application);
      addChild(pictureNameTextLabel);
      pictureNameTextLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      pictureNameTextLabel.setLabel(pictureName);
      pictureCloserButtonLink = new ButtonLink(application);
      addChild(pictureCloserButtonLink);
      pictureCloserButtonLink.setIcon(EnumIcons.close());
      pictureCloserButtonLink.setEnabled(getEnabled());
      pictureCloserButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), pictureCloserButtonLinkClicked);
      pictureCloserButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), pictureCloserResized);
      reposPictureObjects();
    }
    /**
     * Drops the photo of this object: the drawing of it, the closer of it, the bitmap
     * data, the png byte array and the name as well.
     */
    public function clearPicture():void
    {
      application.trace("<" + this + " Camera clearPicture> called.", 1);
      dropPictureObjects();
      if (bitmapData != null)
      {
        bitmapData.dispose();
        bitmapData = null;
      }
      if (pictureByteArray != null)
      {
        pictureByteArray.clear();
        pictureByteArray = null;
      }
      pictureName = "";
    }
    /**
     * The width of this object comes from the picture of the camera, so this does
     * nothing: the setCameraWidth is the one changing it.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Camera setDw> called.", 1);
      application.trace("<" + this + " Camera setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Camera setDw> do nothing.", 1);
    }
    /**
     * The height of this object comes from the picture of the camera, so this does
     * nothing: the width and the aspect ratio are the ones it is counted from.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Camera setDh> called.", 1);
      application.trace("<" + this + " Camera setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Camera setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the picture of the camera, so this does
     * nothing, see the setDw and the setDh above.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Camera setDwh> called.", 1);
      application.trace("<" + this + " Camera setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Camera setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Camera setDwh> do nothing.", 1);
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage,
     * asks the one using the application for the permission of the camera and of the
     * microphone and starts to follow the turning of the screen: a camera is usable in
     * landscape only.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Camera addedToStage> called.", 1);
      application.trace("<" + this + " Camera addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (stage != null)
      {
        stage.addEventListener(Event.RESIZE, stageResized);
      }
      application.askForCameraPermission();
      application.askForMicrophonePermission();
      reposResizeEverything();
    }
    /**
     * Closes the settings panel of this object, drops the timer of the button of the photo
     * and the one of the loudness of the microphone and stops following the turning of the
     * screen as soon as it leaves the stage, so that every listener is unregistered while
     * the stage is still reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Camera removedFromStage> called.", 1);
      application.trace("<" + this + " Camera removedFromStage> e: " + e, 0);
      setSettingsVisible(false);
      dropTakePictureTimer();
      dropSoundLevelTimer();
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
      }
      super.removedFromStage(e);
    }
    /**
     * Takes the button of the photo out of reach and starts the timer giving it back: a
     * camera needs a moment to be ready for the next photo. The timer of a photo that has
     * just been taken is dropped in front of the new one, so there is one single timer
     * running at any moment.
     */
    private function startTakePictureTimer():void
    {
      application.trace("<" + this + " Camera startTakePictureTimer> called.", 1);
      dropTakePictureTimer();
      takePictureTimer = new Timer(application.getComponentsConfig().getCameraTakePictureTimerDelay(), 1);
      takePictureTimer.addEventListener(TimerEvent.TIMER, takePictureTimerHandler);
      takePictureTimer.start();
      refreshTakePictureButtonText();
    }
    /**
     * Takes the button of the photo to the state it has to stand in: it is a pressable one
     * only when this object is enabled, when there is a camera device grabbed to be taken
     * a photo of, when the picture of that device is not muted and when the delay of the
     * previous photo has passed already. Every one of these four can change on its own, so
     * all of them are counted in one single place.
     */
    private function refreshTakePictureButtonText():void
    {
      application.trace("<" + this + " Camera refreshTakePictureButtonText> called.", 1);
      takePictureButtonText.setEnabled(getEnabled() && isCameraAttached() && !videoMuted
          && takePictureTimer == null);
    }
    /**
     * Gives the button of the photo back as soon as the delay of the previous photo has
     * passed.
     * @param e the timer event of that delay
     */
    private function takePictureTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " Camera takePictureTimerHandler> called.", 1);
      application.trace("<" + this + " Camera takePictureTimerHandler> e: " + e, 0);
      dropTakePictureTimer();
    }
    /**
     * Drops the timer of the button of the photo and gives that button back, unless this
     * whole object is a disabled one or it holds no camera device at all: nothing of a
     * disabled camera can be pressed, and a released device has nothing to be taken a
     * photo of. A timer that is still running would keep this object alive for the whole
     * delay of it, so it is dropped as soon as there is nothing left to be timed.
     */
    private function dropTakePictureTimer():void
    {
      application.trace("<" + this + " Camera dropTakePictureTimer> called.", 1);
      if (takePictureTimer != null)
      {
        takePictureTimer.stop();
        takePictureTimer.removeEventListener(TimerEvent.TIMER, takePictureTimerHandler);
        takePictureTimer = null;
        refreshTakePictureButtonText();
      }
    }
    /**
     * Builds the settings panel of this object: it stands in two columns of a name and an
     * element changing the property of that name, one property to a line, and the actions
     * of the camera fill the first line of it, the release of the devices in the column of
     * the names and the reset and the photo in the one of the elements. The picker of the
     * microphones stands right under the one of the cameras: those two are the devices this
     * object works with, and both of those rows carry the button muting their own device,
     * the one of the microphone with the potmeter of the gain of it next to it. The four
     * channels of the colors share one line: those four potmeters belong to one single
     * property, so they stand next to each other in the second column of it. It is not
     * displayed at first: a press on the picture is the one opening it.
     */
    private function createSettingsContent():void
    {
      application.trace("<" + this + " Camera createSettingsContent> called.", 1);
      settingsContent = new ContentSingle(application);
      addChild(settingsContent);
      settingsContent.visible = false;
      settingsContent.setOrientation(EnumOrientations.ORIENTATION_VERTICAL());
      settingsContent.setElementsFix(1);
      settingsContent.getBaseScroll().setEnabledHorizontal(false);
      settingsContent.enableScrollingFromOthers = false;
      detachButtonLink = new ButtonLink(application);
      settingsContent.addToContent(detachButtonLink, 0);
      detachButtonLink.setLabel(EnumTextKeys.RELEASE_CAMERA());
      detachButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), detachButtonLinkClicked);
      detachButtonLink.setSpriteVisible(false);
      resetButtonLink = new ButtonLink(application);
      settingsContent.addToContent(resetButtonLink, 1);
      resetButtonLink.setLabel(EnumTextKeys.RESET());
      resetButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), resetButtonLinkClicked);
      takePictureButtonText = new ButtonText(application);
      settingsContent.addToContent(takePictureButtonText, 1);
      takePictureButtonText.setLabel(EnumTextKeys.CAMERA_TAKE_PICTURE());
      takePictureButtonText.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), takePictureButtonTextClicked);
      deviceTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_DEVICE(), 2);
      deviceListPicker = new ListPicker(application);
      settingsContent.addToContent(deviceListPicker, 3);
      deviceListPicker.setNumOfElements(application.getComponentsConfig().getCameraDevicesMaxElements());
      deviceListPicker.setArrays(cameraDevices.concat(), cameraDevices.concat());
      deviceListPicker.setSelectedIndex(0, false);
      deviceListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), deviceChanged);
      videoMuteButtonLink = new ButtonLink(application);
      settingsContent.addToContent(videoMuteButtonLink, 3);
      videoMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), videoMuteButtonLinkClicked);
      microphoneTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_MICROPHONE(), 4);
      microphoneListPicker = new ListPicker(application);
      settingsContent.addToContent(microphoneListPicker, 5);
      microphoneListPicker.setNumOfElements(application.getComponentsConfig().getCameraDevicesMaxElements());
      microphoneListPicker.setArrays(microphoneDevices.concat(), microphoneDevices.concat());
      microphoneListPicker.setSelectedIndex(0, false);
      microphoneListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), microphoneChanged);
      soundMuteButtonLink = new ButtonLink(application);
      settingsContent.addToContent(soundMuteButtonLink, 5);
      soundMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), soundMuteButtonLinkClicked);
      soundVolumePotmeter = createSettingsPotmeter(5
          , application.getComponentsConfig().getCameraSoundVolumeMin()
          , application.getComponentsConfig().getCameraSoundVolumeMax()
          , application.getComponentsConfig().getCameraSoundVolumeInc(), 0, soundVolume, soundVolumeChanged);
      resolutionTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_RESOLUTION(), 6);
      resolutionListPicker = new ListPicker(application);
      settingsContent.addToContent(resolutionListPicker, 7);
      resolutionListPicker.setNumOfElements(EnumCameraResolutions.getEveryResolution().length);
      resolutionListPicker.setArrays(EnumCameraResolutions.getEveryResolution()
          , EnumCameraResolutions.getEveryResolution());
      resolutionListPicker.setSelectedIndex(EnumCameraResolutions.getEveryResolution().indexOf(cameraResolution), false);
      resolutionListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), resolutionChanged);
      widthTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_SIZE(), 8);
      widthPotmeter = createSettingsPotmeter(9, application.getComponentsConfig().getCameraWidthMin()
          , application.getComponentsConfig().getCameraWidthMax()
          , application.getComponentsConfig().getCameraWidthInc(), 0, cameraWidth, widthChanged);
      fpsTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_FPS(), 10);
      fpsPotmeter = createSettingsPotmeter(11, application.getComponentsConfig().getCameraFpsMin()
          , application.getComponentsConfig().getCameraFpsMax(), 1, 0, cameraFps, fpsChanged);
      qualityTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_QUALITY(), 12);
      qualityPotmeter = createSettingsPotmeter(13, application.getComponentsConfig().getCameraQualityMin()
          , application.getComponentsConfig().getCameraQualityMax(), 1, 0, cameraQuality, qualityChanged);
      blurTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_FILTER(), 14);
      blurPotmeter = createSettingsPotmeter(15, application.getComponentsConfig().getCameraBlurMin()
          , application.getComponentsConfig().getCameraBlurMax()
          , application.getComponentsConfig().getCameraBlurInc(), 0, filterBlur, blurChanged);
      colorsTextLabel = createSettingsTextLabel(EnumTextKeys.CAMERA_FILTER_COLORS(), 16);
      const channelMin:Number = application.getComponentsConfig().getCameraChannelMin();
      const channelMax:Number = application.getComponentsConfig().getCameraChannelMax();
      const channelInc:Number = application.getComponentsConfig().getCameraChannelInc();
      const channelPrecision:int = application.getComponentsConfig().getCameraChannelPrecision();
      redPotmeter = createSettingsPotmeter(17, channelMin, channelMax, channelInc
          , channelPrecision, filterRed, redChanged);
      greenPotmeter = createSettingsPotmeter(17, channelMin, channelMax, channelInc
          , channelPrecision, filterGreen, greenChanged);
      bluePotmeter = createSettingsPotmeter(17, channelMin, channelMax, channelInc
          , channelPrecision, filterBlue, blueChanged);
      alphaPotmeter = createSettingsPotmeter(17, channelMin
          , application.getComponentsConfig().getCameraChannelAlphaMax(), channelInc
          , channelPrecision, filterAlpha, alphaChanged);
      // the two rows of the devices are as wide as the four channels of the colors
      // together, so they follow every change of the width of those four, and the room
      // the pickers of them are left with follows the elements standing next to them
      redPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      greenPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      bluePotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      alphaPotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      videoMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      soundMuteButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
      soundVolumePotmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), settingsElementResized);
    }
    /**
     * Builds one name of the first column of the settings panel and returns it.
     * @param textKey the text key of that name
     * @param cellIndex the cell of the panel that name goes into
     */
    private function createSettingsTextLabel(textKey:String, cellIndex:int):TextLabel
    {
      application.trace("<" + this + " Camera createSettingsTextLabel> called.", 1);
      application.trace("<" + this + " Camera createSettingsTextLabel> textKey: " + textKey, 0);
      application.trace("<" + this + " Camera createSettingsTextLabel> cellIndex: " + cellIndex, 0);
      const textLabel:TextLabel = new TextLabel(application);
      settingsContent.addToContent(textLabel, cellIndex);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      textLabel.setLabel(textKey);
      return textLabel;
    }
    /**
     * Builds one potmeter of the second column of the settings panel and returns it.
     * @param cellIndex the cell of the panel that potmeter goes into
     * @param min the smallest value that can be asked for
     * @param max the greatest value that can be asked for
     * @param inc the step of that potmeter
     * @param precision the number of the decimals that potmeter works with
     * @param iniValue the value that potmeter starts on
     * @param changedHandler the handler of the changed event of that potmeter
     */
    private function createSettingsPotmeter(cellIndex:int, min:Number, max:Number, inc:Number
        , precision:int, iniValue:Number, changedHandler:Function):Potmeter
    {
      application.trace("<" + this + " Camera createSettingsPotmeter> called.", 1);
      application.trace("<" + this + " Camera createSettingsPotmeter> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> min: " + min, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> max: " + max, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> inc: " + inc, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> precision: " + precision, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> iniValue: " + iniValue, 0);
      application.trace("<" + this + " Camera createSettingsPotmeter> changedHandler: " + changedHandler, 0);
      const potmeter:Potmeter = new Potmeter(application);
      settingsContent.addToContent(potmeter, cellIndex);
      potmeter.setDecimalPrecision(precision);
      potmeter.setMinMaxIncValues(min, max, inc);
      potmeter.setCurValue(iniValue, false);
      potmeter.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), changedHandler);
      return potmeter;
    }
    /**
     * Tells whether the given value of one color channel can be asked for at all.
     * @param n the value of that channel
     * @param max the greatest value that channel can be multiplied by
     */
    private function channelValueIsValid(n:Number, max:Number):Boolean
    {
      return n >= application.getComponentsConfig().getCameraChannelMin() && n <= max;
    }
    /**
     * Tells whether the screen of the machine stands in landscape at the moment: a
     * camera is usable in that position only.
     */
    private function weAreInLandscape():Boolean
    {
      return stage != null && stage.stageWidth > stage.stageHeight;
    }
    /**
     * Takes the new dimensions and the new frames per second of the picture to the
     * camera device and to this object. The video object is rebuilt: it displays the
     * picture in the dimensions it has been created with.
     */
    private function applyCameraMode():void
    {
      application.trace("<" + this + " Camera applyCameraMode> called.", 1);
      cameraHeight = EnumCameraResolutions.getHeightOfWidth(cameraResolution, cameraWidth);
      dropVideo();
      if (camera != null)
      {
        camera.setMode(cameraWidth, cameraHeight, cameraFps);
        createVideo();
      }
      reposResizeEverything();
      dispatchEventChanged();
    }
    /**
     * Creates the video object displaying the picture of the camera device. An object
     * holding no device at all and one whose picture is muted display nothing, so neither
     * of them builds that object.
     */
    private function createVideo():void
    {
      application.trace("<" + this + " Camera createVideo> called.", 1);
      if (camera == null)
      {
        application.trace("<" + this + " Camera createVideo> there is no camera device to be displayed.", 1);
        return;
      }
      if (videoMuted)
      {
        application.trace("<" + this + " Camera createVideo> the picture of the camera is muted.", 1);
        return;
      }
      video = new Video();
      videoSprite.addChild(video);
      video.width = cameraWidth;
      video.height = cameraHeight;
      video.attachCamera(camera);
    }
    /**
     * Frees up the video object displaying the picture of the camera device.
     */
    private function dropVideo():void
    {
      application.trace("<" + this + " Camera dropVideo> called.", 1);
      if (video != null)
      {
        video.attachCamera(null);
        video.clear();
        if (videoSprite != null && videoSprite.contains(video))
        {
          videoSprite.removeChild(video);
        }
        video = null;
      }
    }
    /**
     * Builds the filters of the picture of the camera and applies them: the blur and the
     * color matrix as well, whichever of them is asked for at all. A picture that is not
     * blurred and whose channels are untouched carries no filter, so it costs nothing.
     */
    private function applyFilters():void
    {
      application.trace("<" + this + " Camera applyFilters> called.", 1);
      blurFilter = null;
      if (filterBlur > application.getComponentsConfig().getCameraBlurMin())
      {
        blurFilter = new BlurFilter(filterBlur, filterBlur / 2, 1);
      }
      colorMatrixFilter = null;
      const channelIni:Number = application.getComponentsConfig().getCameraChannelIni();
      if (filterRed != channelIni || filterGreen != channelIni
        || filterBlue != channelIni || filterAlpha != channelIni)
      {
        colorMatrixFilter = new ColorMatrixFilter([filterRed, 0, 0, 0, 0
          , 0, filterGreen, 0, 0, 0
          , 0, 0, filterBlue, 0, 0
          , 0, 0, 0, filterAlpha, 0]);
      }
      const filtersArray:Array = new Array();
      if (colorMatrixFilter != null)
      {
        filtersArray.push(colorMatrixFilter);
      }
      if (blurFilter != null)
      {
        filtersArray.push(blurFilter);
      }
      videoSprite.filters = filtersArray.length > 0 ? filtersArray : null;
    }
    /**
     * Returns the name the photo of this object is taken under: the moment of it, so a
     * folder of the photos of one camera stands in the order they have been taken in.
     */
    private function createPictureName():String
    {
      application.trace("<" + this + " Camera createPictureName> called.", 1);
      const date:Date = new Date();
      return application.getComponentsConfig().getCameraPictureNamePrefix()
        + "-D" + ("" + date.fullYear).substr(2, 2) + twoDigits(date.month + 1) + twoDigits(date.date)
        + "-T" + twoDigits(date.hours) + twoDigits(date.minutes) + twoDigits(date.seconds)
        + application.getComponentsConfig().getCameraPictureNameExtension();
    }
    /**
     * Returns the given number in two digits, with a leading zero when it is one digit
     * only: the name of a photo stands in one and the same length this way.
     * @param i the number to be written
     */
    private function twoDigits(i:int):String
    {
      return ("" + i).length < 2 ? "0" + i : "" + i;
    }
    /**
     * Draws the part of the background of the application that stands under this object
     * into the bitmap data of the photo. A picture whose alpha channel is multiplied is
     * not fully opaque, so the background is seen through it and it belongs to the photo
     * as well.
     */
    private function copyApplicationBackground():void
    {
      application.trace("<" + this + " Camera copyApplicationBackground> called.", 1);
      if (filterAlpha == application.getComponentsConfig().getCameraChannelIni()
        || bitmapData == null || application.getBackground() == null)
      {
        application.trace("<" + this + " Camera copyApplicationBackground> the picture is opaque, there is nothing to be copied.", 1);
        return;
      }
      const globalPoint:Point = localToGlobal(new Point(0, 0));
      const matrix:Matrix = new Matrix();
      matrix.translate(int(-globalPoint.x), int(-globalPoint.y));
      bitmapData.draw(application.getBackground(), matrix);
    }
    /**
     * Frees up the drawing of the photo and the name and the closer standing on it. The
     * bitmap data and the byte array of that photo are kept: it can be displayed again.
     */
    private function dropPictureObjects():void
    {
      application.trace("<" + this + " Camera dropPictureObjects> called.", 1);
      // every one of them follows the appearance of the application on listeners of its
      // own, so they have to be destroyed and not only dropped: a dropped one would be
      // held by those listeners for the whole life of the application, and a new photo
      // is taken through here every time
      if (pictureCloserButtonLink != null)
      {
        pictureCloserButtonLink.destroy();
        if (contains(pictureCloserButtonLink))
        {
          removeChild(pictureCloserButtonLink);
        }
        pictureCloserButtonLink = null;
      }
      if (pictureNameTextLabel != null)
      {
        pictureNameTextLabel.destroy();
        if (contains(pictureNameTextLabel))
        {
          removeChild(pictureNameTextLabel);
        }
        pictureNameTextLabel = null;
      }
      if (pictureSprite != null)
      {
        pictureSprite.graphics.clear();
        pictureSprite.destroy();
        if (contains(pictureSprite))
        {
          removeChild(pictureSprite);
        }
        pictureSprite = null;
      }
    }
    /**
     * Places the name of the photo into the bottom right corner of it and the closer of
     * that photo into the top right one. An object displaying no photo at all has
     * neither of them to be placed.
     */
    private function reposPictureObjects():void
    {
      application.trace("<" + this + " Camera reposPictureObjects> called.", 1);
      if (pictureNameTextLabel != null)
      {
        pictureNameTextLabel.setCxy(Math.max(0, cameraWidth - pictureNameTextLabel.getDw())
            , Math.max(0, cameraHeight - pictureNameTextLabel.getDh()));
      }
      if (pictureCloserButtonLink != null)
      {
        pictureCloserButtonLink.setCxy(Math.max(0, cameraWidth - pictureCloserButtonLink.getDw()), 0);
      }
    }
    /**
     * Takes the dimensions of the picture of the camera to this object and to everything
     * standing on it: the surface of that picture, the mask of it, the frame around it,
     * the surface of the press and the settings panel.
     */
    private function reposResizeEverything():void
    {
      application.trace("<" + this + " Camera reposResizeEverything> called.", 1);
      super.setDwh(cameraWidth, cameraHeight);
      videoSprite.setDwh(cameraWidth, cameraHeight);
      settingsContent.setDwh(cameraWidth, cameraHeight);
      resizeSettingsPickers();
      redrawShapes();
      drawSoundLevel();
      reposPictureObjects();
    }
    /**
     * Takes the width of the three pickers of the settings panel: every other element of
     * that panel is as wide as it needs to be, but a picker is exactly as wide as it is
     * told to be, and one that is never told stays invisible. The names of the camera and
     * of the microphone devices are long ones, so the two rows of the devices are as wide
     * as the four channels of the colors standing under them are together: those four are
     * the widest line of the second column, so those two rows fill that column right up to
     * its edge. The button muting the device of a row and the potmeter of the gain stand
     * next to the picker of it, so the room those elements take is what is left out of the
     * width of the picker itself, and a picker is never narrower than one single line of
     * the text. An aspect ratio is four characters at the most, so three lines of the text
     * are enough for the picker of those. The four channels are as wide as the values they
     * display, so they can be narrower than the pickers themselves are at the moment, and a
     * width of nothing at all is left alone: those potmeters are measured as soon as they
     * are rendered.
     */
    private function resizeSettingsPickers():void
    {
      application.trace("<" + this + " Camera resizeSettingsPickers> called.", 1);
      const colorsDw:int = redPotmeter.getDw() + greenPotmeter.getDw() + bluePotmeter.getDw()
          + alphaPotmeter.getDw();
      if (colorsDw > 0)
      {
        deviceListPicker.setDw(getDeviceRowPickerDw(colorsDw, videoMuteButtonLink.getDw()));
        microphoneListPicker.setDw(getDeviceRowPickerDw(colorsDw
            , soundMuteButtonLink.getDw() + soundVolumePotmeter.getDw()));
      }
      resolutionListPicker.setDw(3 * application.getDynamicsConfig()
          .getTextFieldHeight(resolutionListPicker.getTextType()));
    }
    /**
     * Returns the width the picker of one of the two rows of the devices is left with: the
     * width of that whole row without the room the elements standing next to that picker
     * take. A row whose elements are wider than the row itself would leave nothing at all
     * for the picker, so one single line of the text is kept for it whatever happens.
     * @param rowDw the width of the whole row
     * @param elementsDw the width of the elements standing next to that picker
     */
    private function getDeviceRowPickerDw(rowDw:int, elementsDw:int):int
    {
      application.trace("<" + this + " Camera getDeviceRowPickerDw> called.", 1);
      application.trace("<" + this + " Camera getDeviceRowPickerDw> rowDw: " + rowDw, 0);
      application.trace("<" + this + " Camera getDeviceRowPickerDw> elementsDw: " + elementsDw, 0);
      return Math.max(application.getDynamicsConfig()
          .getTextFieldHeight(deviceListPicker.getTextType()), rowDw - elementsDw);
    }
    /**
     * Grabs the microphone device the picker of the microphones stands on, so the sound
     * of the outgoing stream this object is fed into comes from that very device. The
     * microphones of the machine are read again first: one of them can be plugged in or
     * taken away while the application is running. A machine holding no microphone at all
     * and a device that is muted leave this object without one: the picture of a camera is
     * worth displaying on its own, so a sound nobody allows does not stop it. A device that
     * has been grabbed is taken onto the mute and the gain this object stands with right
     * away, so the one picked in the place of another one goes on in the very same state,
     * and the bar of the loudness starts to follow it.
     */
    private function attachMicrophone():void
    {
      application.trace("<" + this + " Camera attachMicrophone> called.", 1);
      refreshMicrophoneDevices();
      if (microphoneDevices.length < 1)
      {
        application.trace("<" + this + " Camera attachMicrophone> this machine holds no microphone device at all.", 1);
        return;
      }
      microphone = Microphone.getMicrophone(microphoneListPicker.getSelectedIndex());
      if (microphone == null)
      {
        application.trace("<" + this + " Camera attachMicrophone> the picked device could not be grabbed, the default one comes.", 0);
        microphone = Microphone.getMicrophone();
      }
      if (microphone == null || microphone.muted)
      {
        application.trace("<" + this + " Camera attachMicrophone> there is no microphone device to be used.", 1);
        microphone = null;
        return;
      }
      microphone.addEventListener(StatusEvent.STATUS, microphoneStatus);
      // a device tells the loudness it hears while it is being listened to only, and the
      // speakers of the machine are the ones it is played back through, so that playback
      // is asked for in a volume of nothing at all: without it this object would hear
      // itself, and without the loopback it could not display that loudness at all
      microphone.soundTransform = new SoundTransform(0);
      microphone.setLoopBack(true);
      displaySound();
      startSoundLevelTimer();
    }
    /**
     * Releases the microphone device of this object and stops the bar of the loudness with
     * it. A released device is usable by everything else on the machine again.
     */
    private function detachMicrophone():void
    {
      application.trace("<" + this + " Camera detachMicrophone> called.", 1);
      dropSoundLevelTimer();
      if (microphone != null)
      {
        microphone.setLoopBack(false);
        microphone.removeEventListener(StatusEvent.STATUS, microphoneStatus);
        microphone = null;
      }
      drawSoundLevel();
    }
    /**
     * Starts to read the loudness the microphone hears again and again: the bar of it is
     * drawn again at every one of those readings. The timer of the reading before is
     * dropped in front of the new one, so there is one single timer running at any moment.
     */
    private function startSoundLevelTimer():void
    {
      application.trace("<" + this + " Camera startSoundLevelTimer> called.", 1);
      dropSoundLevelTimer();
      soundLevelTimer = new Timer(application.getComponentsConfig().getCameraSoundLevelTimerDelay());
      soundLevelTimer.addEventListener(TimerEvent.TIMER, soundLevelTimerHandler);
      soundLevelTimer.start();
    }
    /**
     * Draws the bar of the loudness the microphone hears at the moment. This runs many
     * times in one single second, so it is logged on the level of the enter frame and of
     * the mouse move handlers: a calling entry of it would flood the logger.
     * @param e the timer event of that reading
     */
    private function soundLevelTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " Camera soundLevelTimerHandler> called.", 0);
      drawSoundLevel();
    }
    /**
     * Drops the timer reading the loudness the microphone hears. A timer that is still
     * running would keep this object alive for the whole life of the application, so it is
     * dropped as soon as there is no device left to be read.
     */
    private function dropSoundLevelTimer():void
    {
      application.trace("<" + this + " Camera dropSoundLevelTimer> called.", 1);
      if (soundLevelTimer != null)
      {
        soundLevelTimer.stop();
        soundLevelTimer.removeEventListener(TimerEvent.TIMER, soundLevelTimerHandler);
        soundLevelTimer = null;
      }
    }
    /**
     * Draws the bar of the loudness the microphone hears at the moment: it lies along the
     * bottom of the picture, it is as long a part of the width of that picture as the
     * loudness is of the loudest gain, and the very same share tells how opaque it is, so
     * a quiet word draws a short and faint bar and a loud one a long and strong bar. A
     * microphone hearing nothing at all draws no bar, and neither does one that is not
     * grabbed or is muted.
     */
    private function drawSoundLevel():void
    {
      application.trace("<" + this + " Camera drawSoundLevel> called.", 0);
      soundLevelSprite.graphics.clear();
      const volumeMin:int = application.getComponentsConfig().getCameraSoundVolumeMin();
      const volumeMax:int = application.getComponentsConfig().getCameraSoundVolumeMax();
      const level:int = getSoundLevel();
      if (level <= volumeMin || volumeMax <= volumeMin)
      {
        application.trace("<" + this + " Camera drawSoundLevel> there is no sound to be displayed.", 0);
        return;
      }
      const share:Number = (level - volumeMin) / (volumeMax - volumeMin);
      const barDh:int = Math.max(1, application.getDynamicsConfig().getAppPadding());
      soundLevelSprite.graphics.beginFill(application.getDynamicsConfig()
          .getAppBackgroundColorBright(), share);
      soundLevelSprite.graphics.drawRect(0, cameraHeight - barDh, int(cameraWidth * share), barDh);
      soundLevelSprite.graphics.endFill();
    }
    /**
     * Takes the microphone of this object onto the gain it has to be asked for: a muted one
     * is asked for the quietest gain of the configuration, so it hears nothing at all. The
     * icon of the button of the sound follows both of those, and so does the bar of the
     * loudness: a muted microphone displays no bar either.
     */
    private function displaySound():void
    {
      application.trace("<" + this + " Camera displaySound> called.", 1);
      if (microphone != null)
      {
        microphone.gain = soundMuted
            ? application.getComponentsConfig().getCameraSoundVolumeMin() : soundVolume;
      }
      soundMuteButtonLink.setIcon(getSoundIcon());
      drawSoundLevel();
    }
    /**
     * Returns the icon the button of the sound has to carry: the one of the muting on a
     * muted microphone, and the one of the loudness the potmeter of the gain stands on
     * otherwise, from the silent speaker up to the loudest one. The range of that potmeter
     * comes from the configuration, so the three thirds of it are the ones the icon changes
     * at.
     */
    private function getSoundIcon():String
    {
      application.trace("<" + this + " Camera getSoundIcon> called.", 1);
      if (soundMuted)
      {
        return EnumIcons.soundmuted();
      }
      const volumeMin:int = application.getComponentsConfig().getCameraSoundVolumeMin();
      const volumeMax:int = application.getComponentsConfig().getCameraSoundVolumeMax();
      if (soundVolume <= volumeMin)
      {
        return EnumIcons.soundzero();
      }
      if (soundVolume < volumeMin + (volumeMax - volumeMin) / 3)
      {
        return EnumIcons.soundlow();
      }
      if (soundVolume < volumeMin + 2 * (volumeMax - volumeMin) / 3)
      {
        return EnumIcons.soundmid();
      }
      return EnumIcons.soundhigh();
    }
    /**
     * Draws the icon the button of the picture has to carry: the crossed camera on a muted
     * picture and the plain one on a picture that is displayed.
     */
    private function displayVideoMuted():void
    {
      application.trace("<" + this + " Camera displayVideoMuted> called.", 1);
      videoMuteButtonLink.setIcon(videoMuted ? EnumIcons.cameracrossed() : EnumIcons.camera());
    }
    /**
     * Copies the names of the devices of one kind into the store this object keeps for
     * the whole life of it. The names come from the runtime in a fresh array every time
     * they are read, and the one reading them is the one freeing that array up.
     * @param devices the store of the names of the devices of that kind
     * @param names the names the runtime answered for the devices of that kind
     */
    private function pushDeviceNames(devices:Array, names:Array):void
    {
      application.trace("<" + this + " Camera pushDeviceNames> called.", 1);
      application.trace("<" + this + " Camera pushDeviceNames> devices: " + devices, 0);
      application.trace("<" + this + " Camera pushDeviceNames> names: " + names, 0);
      for (var i:int = 0; i < names.length; i++)
      {
        devices.push(names[i]);
      }
    }
    /**
     * Reads the camera devices of the machine again and offers the ones that are really
     * there on the picker of the cameras.
     */
    private function refreshCameraDevices():void
    {
      application.trace("<" + this + " Camera refreshCameraDevices> called.", 1);
      const namesNow:Array = flash.media.Camera.names;
      refreshDevices(cameraDevices, namesNow, deviceListPicker);
      namesNow.splice(0);
    }
    /**
     * Reads the microphone devices of the machine again and offers the ones that are
     * really there on the picker of the microphones.
     */
    private function refreshMicrophoneDevices():void
    {
      application.trace("<" + this + " Camera refreshMicrophoneDevices> called.", 1);
      const namesNow:Array = Microphone.names;
      refreshDevices(microphoneDevices, namesNow, microphoneListPicker);
      namesNow.splice(0);
    }
    /**
     * Offers the devices of one kind that are really there on the machine on the picker
     * of that kind. The device that has been picked so far is kept whenever it is still
     * among them, and nothing is touched at all while they are the very same devices:
     * refilling that picker would drop the selection of it.
     * @param devices the store of the names of the devices of that kind
     * @param names the names the runtime answered for the devices of that kind
     * @param picker the picker offering the devices of that kind
     */
    private function refreshDevices(devices:Array, names:Array, picker:ListPicker):void
    {
      application.trace("<" + this + " Camera refreshDevices> called.", 1);
      application.trace("<" + this + " Camera refreshDevices> devices: " + devices, 0);
      application.trace("<" + this + " Camera refreshDevices> names: " + names, 0);
      application.trace("<" + this + " Camera refreshDevices> picker: " + picker, 0);
      if (names.join("|") == devices.join("|"))
      {
        application.trace("<" + this + " Camera refreshDevices> these are the very same devices.", 1);
        return;
      }
      const deviceNameBefore:String = picker.getSelectedValue();
      devices.splice(0);
      pushDeviceNames(devices, names);
      picker.setArrays(devices.concat(), devices.concat());
      const indexToSelect:int = Math.max(0, devices.indexOf(deviceNameBefore));
      picker.setSelectedIndex(Math.min(devices.length - 1, indexToSelect), false);
    }
    /**
     * Draws the mask of the picture of the camera, the frame around it and the surface
     * the press opening the settings panel arrives on, in the current radius and colors
     * of the application.
     */
    private function redrawShapes():void
    {
      application.trace("<" + this + " Camera redrawShapes> called.", 1);
      const radius:int = application.getDynamicsConfig().getAppRadius();
      maskShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      maskShape.setRadius(radius);
      maskShape.setDwh(cameraWidth, cameraHeight);
      maskShape.drawRect();
      frameShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorBright()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      frameShape.setRadius(radius);
      frameShape.setDwh(cameraWidth, cameraHeight);
      frameShape.drawRect();
      clickSprite.graphics.clear();
      clickSprite.graphics.beginFill(0, 0);
      clickSprite.graphics.drawRect(0, 0, cameraWidth, cameraHeight);
      clickSprite.graphics.endFill();
    }
    /**
     * Takes the width of the two pickers of the settings panel again after the text
     * format of the application has been changed: both of them are given a width the
     * lines of that format are measured in.
     * @param e the mid text format changed event of the application
     */
    private function textFormatChanged(e:Event):void
    {
      application.trace("<" + this + " Camera textFormatChanged> called.", 1);
      application.trace("<" + this + " Camera textFormatChanged> e: " + e, 0);
      resizeSettingsPickers();
    }
    /**
     * Takes the width of the pickers of the devices again as soon as one of the elements
     * the two rows of them are measured from has been resized: those rows are as wide as
     * the four channels of the colors are together, and the room their own pickers are
     * left with follows the elements standing next to them. Every one of these is as wide
     * as the value or the icon it displays, so one more or one less character and a new
     * icon move the edge of a whole line.
     * @param e the dimensions changed event of one of those elements
     */
    private function settingsElementResized(e:Event):void
    {
      application.trace("<" + this + " Camera settingsElementResized> called.", 1);
      application.trace("<" + this + " Camera settingsElementResized> e: " + e, 0);
      resizeSettingsPickers();
    }
    /**
     * Places the closer of the photo into the top right corner again as soon as it has
     * been measured: the icon of a button is rendered after that button has been built,
     * so the width of it is known only afterwards.
     * @param e the dimensions changed event of that closer
     */
    private function pictureCloserResized(e:Event):void
    {
      application.trace("<" + this + " Camera pictureCloserResized> called.", 1);
      application.trace("<" + this + " Camera pictureCloserResized> e: " + e, 0);
      reposPictureObjects();
    }
    /**
     * Draws the shapes of this object and the bar of the loudness again after the
     * appearance of the application has been changed: they take the radius, the padding
     * and the colors of that appearance.
     * @param e the padding, radius or background color changed event of the application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " Camera appearanceChanged> called.", 1);
      application.trace("<" + this + " Camera appearanceChanged> e: " + e, 0);
      redrawShapes();
      drawSoundLevel();
    }
    /**
     * Releases the camera device as soon as the screen of the machine has been turned
     * into portrait: a camera is usable in landscape only.
     * @param e the resize event of the stage
     */
    private function stageResized(e:Event):void
    {
      application.trace("<" + this + " Camera stageResized> called.", 1);
      application.trace("<" + this + " Camera stageResized> e: " + e, 0);
      if (weAreInLandscape())
      {
        application.trace("<" + this + " Camera stageResized> the screen stands in landscape, there is nothing to do.", 1);
        return;
      }
      if (isCameraAttached())
      {
        showAlert(EnumTextKeys.CAMERA_IS_USABLE_IN_HORIZONTAL());
      }
      detachCamera();
    }
    /**
     * Opens the settings panel of this object on a press on the picture of the camera.
     * @param e the mouse down event of the surface of the press
     */
    private function clickSpriteMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Camera clickSpriteMouseDown> called.", 1);
      application.trace("<" + this + " Camera clickSpriteMouseDown> e: " + e, 0);
      setSettingsVisible(true);
    }
    /**
     * Closes the settings panel of this object as soon as a press has arrived outside of
     * it: everything standing on that panel is inside this object, so a press anywhere
     * else means that it is not being used any more.
     * @param e the mouse down event of the stage
     */
    private function stageMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Camera stageMouseDown> called.", 1);
      application.trace("<" + this + " Camera stageMouseDown> e: " + e, 0);
      if (mouseX > 0 && mouseX < getDw() && mouseY > 0 && mouseY < getDh())
      {
        application.trace("<" + this + " Camera stageMouseDown> the press has arrived onto this object.", 1);
        return;
      }
      setSettingsVisible(false);
    }
    /**
     * Grabs the camera device on a click on the link of it.
     * @param e the click event of that link
     */
    private function attachButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera attachButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera attachButtonLinkClicked> e: " + e, 0);
      attachCamera();
    }
    /**
     * Releases the camera device on a click on the link of it.
     * @param e the click event of that link
     */
    private function detachButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera detachButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera detachButtonLinkClicked> e: " + e, 0);
      detachCamera();
    }
    /**
     * Takes a photo of the picture of the camera on a click on the button of it.
     * @param e the click event of that button
     */
    private function takePictureButtonTextClicked(e:Event):void
    {
      application.trace("<" + this + " Camera takePictureButtonTextClicked> called.", 1);
      application.trace("<" + this + " Camera takePictureButtonTextClicked> e: " + e, 0);
      takePicture();
    }
    /**
     * Drops the photo of this object on a click on the closer of it and grabs the camera
     * device again: the one using the application is done with that photo, so the picture
     * of the camera comes back in the place of it, ready for the next one, and the bitmap
     * data and the byte array of the dropped photo are freed up right away. A device that
     * can not be grabbed again leaves this object with the link of it standing over the
     * free picture, the very state a camera holding nothing stands in.
     * @param e the click event of that closer
     */
    private function pictureCloserButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera pictureCloserButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera pictureCloserButtonLinkClicked> e: " + e, 0);
      clearPicture();
      attachCamera();
      dispatchEventChanged();
    }
    /**
     * Takes every property of the picture back to its own default on a click on the link
     * of the reset.
     * @param e the click event of that link
     */
    private function resetButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera resetButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera resetButtonLinkClicked> e: " + e, 0);
      resetSettings();
    }
    /**
     * Takes the camera device the picker of the cameras has been taken to.
     * @param e the changed event of that picker
     */
    private function deviceChanged(e:Event):void
    {
      application.trace("<" + this + " Camera deviceChanged> called.", 1);
      application.trace("<" + this + " Camera deviceChanged> e: " + e, 0);
      setSelectedDeviceIndex(deviceListPicker.getSelectedIndex());
    }
    /**
     * Takes the microphone device the picker of the microphones has been taken to.
     * @param e the changed event of that picker
     */
    private function microphoneChanged(e:Event):void
    {
      application.trace("<" + this + " Camera microphoneChanged> called.", 1);
      application.trace("<" + this + " Camera microphoneChanged> e: " + e, 0);
      setSelectedMicrophoneIndex(microphoneListPicker.getSelectedIndex());
    }
    /**
     * Mutes the picture of the camera on a click on the button of it, and unmutes a muted
     * one: that very button is the one carrying both of them.
     * @param e the click event of that button
     */
    private function videoMuteButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera videoMuteButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera videoMuteButtonLinkClicked> e: " + e, 0);
      setVideoMuted(!isVideoMuted());
    }
    /**
     * Mutes the microphone of this object on a click on the button of the sound, and
     * unmutes a muted one: that very button is the one carrying both of them.
     * @param e the click event of that button
     */
    private function soundMuteButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Camera soundMuteButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Camera soundMuteButtonLinkClicked> e: " + e, 0);
      setSoundMuted(!isSoundMuted());
    }
    /**
     * Takes the gain of the microphone the potmeter of the sound has been taken to.
     * @param e the changed event of that potmeter
     */
    private function soundVolumeChanged(e:Event):void
    {
      application.trace("<" + this + " Camera soundVolumeChanged> called.", 1);
      application.trace("<" + this + " Camera soundVolumeChanged> e: " + e, 0);
      setSoundVolume(int(soundVolumePotmeter.getCurValue()));
    }
    /**
     * Takes the aspect ratio the picker of the resolutions has been taken to.
     * @param e the changed event of that picker
     */
    private function resolutionChanged(e:Event):void
    {
      application.trace("<" + this + " Camera resolutionChanged> called.", 1);
      application.trace("<" + this + " Camera resolutionChanged> e: " + e, 0);
      setCameraResolution(resolutionListPicker.getSelectedValue());
    }
    /**
     * Takes the width the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function widthChanged(e:Event):void
    {
      application.trace("<" + this + " Camera widthChanged> called.", 1);
      application.trace("<" + this + " Camera widthChanged> e: " + e, 0);
      setCameraWidth(int(widthPotmeter.getCurValue()));
    }
    /**
     * Takes the frames per second the potmeter of them has been taken to.
     * @param e the changed event of that potmeter
     */
    private function fpsChanged(e:Event):void
    {
      application.trace("<" + this + " Camera fpsChanged> called.", 1);
      application.trace("<" + this + " Camera fpsChanged> e: " + e, 0);
      setCameraFps(int(fpsPotmeter.getCurValue()));
    }
    /**
     * Takes the quality the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function qualityChanged(e:Event):void
    {
      application.trace("<" + this + " Camera qualityChanged> called.", 1);
      application.trace("<" + this + " Camera qualityChanged> e: " + e, 0);
      setCameraQuality(int(qualityPotmeter.getCurValue()));
    }
    /**
     * Takes the blur the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function blurChanged(e:Event):void
    {
      application.trace("<" + this + " Camera blurChanged> called.", 1);
      application.trace("<" + this + " Camera blurChanged> e: " + e, 0);
      setFilterBlur(int(blurPotmeter.getCurValue()));
    }
    /**
     * Takes the value of the red channel the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function redChanged(e:Event):void
    {
      application.trace("<" + this + " Camera redChanged> called.", 1);
      application.trace("<" + this + " Camera redChanged> e: " + e, 0);
      setFilterRed(redPotmeter.getCurValue());
    }
    /**
     * Takes the value of the green channel the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function greenChanged(e:Event):void
    {
      application.trace("<" + this + " Camera greenChanged> called.", 1);
      application.trace("<" + this + " Camera greenChanged> e: " + e, 0);
      setFilterGreen(greenPotmeter.getCurValue());
    }
    /**
     * Takes the value of the blue channel the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function blueChanged(e:Event):void
    {
      application.trace("<" + this + " Camera blueChanged> called.", 1);
      application.trace("<" + this + " Camera blueChanged> e: " + e, 0);
      setFilterBlue(bluePotmeter.getCurValue());
    }
    /**
     * Takes the value of the alpha channel the potmeter of it has been taken to.
     * @param e the changed event of that potmeter
     */
    private function alphaChanged(e:Event):void
    {
      application.trace("<" + this + " Camera alphaChanged> called.", 1);
      application.trace("<" + this + " Camera alphaChanged> e: " + e, 0);
      setFilterAlpha(alphaPotmeter.getCurValue());
    }
    /**
     * Releases the camera device as soon as it tells that it is not usable any more: the
     * one using the application has taken the permission of it away.
     * @param e the status event of that device
     */
    private function cameraStatus(e:StatusEvent):void
    {
      application.trace("<" + this + " Camera cameraStatus> called.", 1);
      application.trace("<" + this + " Camera cameraStatus> e: " + e, 0);
      if (camera != null && !camera.muted)
      {
        application.trace("<" + this + " Camera cameraStatus> the camera device is usable.", 1);
        return;
      }
      detachCamera();
    }
    /**
     * Releases the microphone device as soon as it tells that it is not usable any more:
     * the one using the application has taken the permission of it away. The picture of
     * the camera is left alone, and the changed event tells the outside that the outgoing
     * stream carries no sound from now on.
     * @param e the status event of that device
     */
    private function microphoneStatus(e:StatusEvent):void
    {
      application.trace("<" + this + " Camera microphoneStatus> called.", 1);
      application.trace("<" + this + " Camera microphoneStatus> e: " + e, 0);
      if (microphone != null && !microphone.muted)
      {
        application.trace("<" + this + " Camera microphoneStatus> the microphone device is usable.", 1);
        return;
      }
      detachMicrophone();
      dispatchEventChanged();
    }
    /**
     * Dispatches the changed event of this object: one property of the picture of the
     * camera has been changed, whether by a row of the settings panel or from the
     * outside.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " Camera dispatchEventChanged> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventChanged);
    }
    /**
     * Releases the camera and the microphone device, drops both timers of this object and
     * frees all listeners, filters, events and references held by it.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Camera destroy> called.", 1);
      application.trace("<" + this + " Camera destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      dropTakePictureTimer();
      dropSoundLevelTimer();
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      clickSprite.removeEventListener(MouseEvent.MOUSE_DOWN, clickSpriteMouseDown);
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
      }
      application.trace("<" + this + " Camera destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      detachCamera();
      clearPicture();
      eventCameraIsAttached.stopImmediatePropagation();
      eventCameraIsDetached.stopImmediatePropagation();
      eventChanged.stopImmediatePropagation();
      eventPictureTaken.stopImmediatePropagation();
      videoSprite.filters = null;
      videoSprite.mask = null;
      clickSprite.graphics.clear();
      soundLevelSprite.graphics.clear();
      cameraDevices.splice(0);
      microphoneDevices.splice(0);
      application.trace("<" + this + " Camera destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      videoSprite = null;
      maskShape = null;
      frameShape = null;
      clickSprite = null;
      attachButtonLink = null;
      settingsContent = null;
      detachButtonLink = null;
      takePictureButtonText = null;
      resetButtonLink = null;
      deviceTextLabel = null;
      deviceListPicker = null;
      videoMuteButtonLink = null;
      microphoneTextLabel = null;
      microphoneListPicker = null;
      soundMuteButtonLink = null;
      soundVolumePotmeter = null;
      resolutionTextLabel = null;
      resolutionListPicker = null;
      widthTextLabel = null;
      widthPotmeter = null;
      fpsTextLabel = null;
      fpsPotmeter = null;
      qualityTextLabel = null;
      qualityPotmeter = null;
      blurTextLabel = null;
      blurPotmeter = null;
      colorsTextLabel = null;
      redPotmeter = null;
      greenPotmeter = null;
      bluePotmeter = null;
      alphaPotmeter = null;
      soundLevelSprite = null;
      soundLevelTimer = null;
      takePictureTimer = null;
      pictureSprite = null;
      pictureNameTextLabel = null;
      pictureCloserButtonLink = null;
      camera = null;
      video = null;
      microphone = null;
      cameraDevices = null;
      microphoneDevices = null;
      cameraResolution = null;
      cameraWidth = 0;
      cameraHeight = 0;
      cameraFps = 0;
      cameraQuality = 0;
      resolutionFixed = false;
      videoMuted = false;
      soundMuted = false;
      soundVolume = 0;
      blurFilter = null;
      colorMatrixFilter = null;
      filterBlur = 0;
      filterRed = 0;
      filterGreen = 0;
      filterBlue = 0;
      filterAlpha = 0;
      bitmapData = null;
      pictureByteArray = null;
      pictureName = null;
      eventCameraIsAttached = null;
      eventCameraIsDetached = null;
      eventChanged = null;
      eventPictureTaken = null;
    }
  }
}
