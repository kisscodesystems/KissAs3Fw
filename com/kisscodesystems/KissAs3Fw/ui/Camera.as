/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Dm
**
** DESCRIPTION:
** Camera.
** Catches one of the available camera devices.
**
** MAIN FEATURES:
** - get and release the camera
** - choosing between cameras if available
** - the quality and the size can be set
** - photo can be taken
** - the exact properties are to modify:
**   camera resolution: 1:1 , 4:3 , 16:9
**   camera width:      160 - 1280
**   camera fps:        10 - 42
**   camera quality:    42 - 100
**   camera filter:      0 - 16  : blur
**   (for taking a       0 - 1   : alpha channel
**    picture and not    0 - 1 - 2  : red channel
**    for outgoing       0 - 1 - 2  : green channel
**    stream)            0 - 1 - 2  : blue channel
**
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . display . BitmapData ;
  import flash . display . PNGEncoderOptions ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . events . StatusEvent ;
  import flash . filesystem . File ;
  import flash . filesystem . FileMode ;
  import flash . filesystem . FileStream ;
  import flash . filters . BlurFilter ;
  import flash . filters . ColorMatrixFilter ;
  import flash . geom . Matrix ;
  import flash . geom . Point ;
  import flash . geom . Rectangle ;
  import flash . media . Camera ;
  import flash . media . Video ;
  import flash . net . FileReference ;
  import flash . utils . ByteArray ;
  public class Camera extends BaseSprite
  {
// The resolutions available.
    private const RES_11 : String = "1:1" ;
    private const RES_43 : String = "4:3" ;
    private const RES_169 : String = "16:9" ;
// This will be the base of the increasing of the camera.
    private const WDELTA : int = 160 ;
// The sprite where the camera object can be appeared.
    private var bg : BaseSprite = null ;
// Msk for the better view of the cam.
    private var shapeBgMask : BaseShape = null ;
// To have a frame around the camera view.
    private var shapeBgFrame : BaseShape = null ;
// The sprite that is clickable.
    private var clickSprite : BaseSprite = null ;
// The linkbutton to activate the camera.
    private var cameraAttachButtonLink : ButtonLink = null ;
// The button link of releasing the camera
    private var cameraDetachButtonLink : ButtonLink = null ;
// The foreground or the settings can be displayed.
    private var fg : ContentSingle = null ;
// And the settings.
    private var resolutionListPicker : ListPicker = null ;
    private var sizeTextLabel : TextLabel = null ;
    private var sizePotmeter : Potmeter = null ;
    private var fpsTextLabel : TextLabel = null ;
    private var fpsPotmeter : Potmeter = null ;
    private var qualityTextLabel : TextLabel = null ;
    private var qualityPotmeter : Potmeter = null ;
    private var filterTextLabel : TextLabel = null ;
    private var filterPotmeterB : Potmeter = null ;
    private var filterPotmeterCR : Potmeter = null ;
    private var filterPotmeterCG : Potmeter = null ;
    private var filterPotmeterCB : Potmeter = null ;
    private var filterPotmeterCA : Potmeter = null ;
    private var takePicture : ButtonText = null ;
    private var pictureSaved : TextLabel = null ;
    private var cameraListPicker : ListPicker = null ;
// The button link of resetting the filters and all of the camera properties
    private var resetButtonLink : ButtonLink = null ;
// This will be the default filename to save the photo.
    private var filenameToSave : String = null ;
// The camera object.
    private var camera : flash . media . Camera = null ;
// The video object to display the view of the camera
    private var video : flash . media . Video = null ;
// The available sizes of the camera.
    private var cameraResolution : String = RES_43 ;
    private var cameraWidth : int = 2 * WDELTA ;
    private var cameraHeight : int = cameraWidth * 3 / 4 ;
// The available fps of the camera:
    private var cameraFps : int = 24 ;
// The quality of the Camera is:
    private var cameraQuality : int = 100 ;
// The applied filter objects:
    private var blurFilter : BlurFilter = null ;
    private var colorMatrixFilter : ColorMatrixFilter = null ;
// The available camera devices.
    private var cameraDevices : Array = null ;
// The properties of the saved byte array.
    private var savedPictureName : String = null ;
    private var savedPictureByteArray : ByteArray = null ;
    private var savedEvent : Event = null ;
// The file or fileReference objects.
    private var file : *= null ;
    private var fileReference : FileReference = null ;
// The sizes of the camera.
    private var resolutionsArray : Array = [ RES_11 , RES_43 , RES_169 ] ;
// The displaying of the last taken photo.
    private var photo : BaseSprite = null ;
// This will be accessible from the whole class.
    private var bitmapData : BitmapData = null ;
// Camera is attached event.
    private var cameraIsAttachedEvent : Event = null ;
// To the alert if necessary. (not)
    private var alertOK : Function = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Camera ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The actual size of this object.
      super . setswh ( cameraWidth , cameraHeight ) ;
// Name
      savedPictureName = "" ;
// Background sprite will contain the video and filter elements.
      bg = new BaseSprite ( application ) ;
      addChild ( bg ) ;
      bg . setswh ( getsw ( ) , getsh ( ) ) ;
// A mask is necessary to the background.
      shapeBgMask = new BaseShape ( application ) ;
      addChild ( shapeBgMask ) ;
      shapeBgMask . setdb ( false ) ;
      shapeBgMask . setdt ( 0 ) ;
      bg . mask = shapeBgMask ;
// A frame around the video.
      shapeBgFrame = new BaseShape ( application ) ;
      addChild ( shapeBgFrame ) ;
      shapeBgFrame . setdb ( true ) ;
      shapeBgFrame . setdt ( 1 ) ;
// The sprite to be clicked.
      clickSprite = new BaseSprite ( application ) ;
      addChild ( clickSprite ) ;
      clickSprite . addEventListener ( MouseEvent . MOUSE_DOWN , clickSpriteMouseDown ) ;
// The events are necessary to listen to.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , redrawShapes ) ;
// The event of the successfully saving.
      savedEvent = new Event ( application . EVENT_SAVED ) ;
// The event of the camrea attaching.
      cameraIsAttachedEvent = new Event ( application . EVENT_CAMERA_IS_ATTACHED ) ;
// And an initial redrawing.
      redrawShapes ( null ) ;
// Detecting the camera devices.
      cameraDevices = new Array ( ) ;
      for ( var i : int = 0 ; i < flash . media . Camera . names . length ; i ++ )
      {
        cameraDevices . push ( flash . media . Camera . names [ i ] ) ;
      }
// The attach button link! Using this results the camera be attached.
      cameraAttachButtonLink = new ButtonLink ( application ) ;
      addChild ( cameraAttachButtonLink ) ;
      cameraAttachButtonLink . setTextCode ( application . getTexts ( ) . ACTIVATE_CAMERA ) ;
      cameraAttachButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , attachCamera ) ;
// The foreground object, which is a content, will contain the necessary objects to modify the camera view.
      fg = new ContentSingle ( application ) ;
      addChild ( fg ) ;
      fg . setswh ( getsw ( ) , getsh ( ) ) ;
      fg . visible = false ;
      fg . setElementsFix ( 2 ) ;
// Creation of the elements to customize the camera view.
      cameraDetachButtonLink = new ButtonLink ( application ) ;
      fg . addToContent ( cameraDetachButtonLink , true , 0 ) ;
      cameraDetachButtonLink . setTextCode ( application . getTexts ( ) . RELEASE_CAMERA ) ;
      cameraDetachButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , detachCamera ) ;
      cameraDetachButtonLink . visible = false ;
      takePicture = new ButtonText ( application ) ;
      fg . addToContent ( takePicture , true , 2 ) ;
      takePicture . setTextCode ( application . getTexts ( ) . CAMERA_TAKE_PICTURE ) ;
      takePicture . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , takePictureClick ) ;
      takePicture . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , takePictureSizeChanged ) ;
      sizeTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( sizeTextLabel , false , 3 ) ;
      sizeTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_SIZE ) ;
      sizePotmeter = new Potmeter ( application ) ;
      fg . addToContent ( sizePotmeter , true , 4 ) ;
      sizePotmeter . setMinMaxIncValues ( 2 * WDELTA , 8 * WDELTA , WDELTA ) ;
      sizePotmeter . setCurValue ( cameraWidth ) ;
      sizePotmeter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , sizePotmeterChanged ) ;
      cameraListPicker = new ListPicker ( application ) ;
      fg . addToContent ( cameraListPicker , true , 5 ) ;
      cameraListPicker . setArrays ( cameraDevices , cameraDevices ) ;
      cameraListPicker . setSelectedIndex ( 0 ) ;
      cameraListPicker . setNumOfElements ( 5 ) ;
      cameraListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , cameraListPickerChanged ) ;
      takePictureSizeChanged ( null ) ;
      fpsTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( fpsTextLabel , false , 6 ) ;
      fpsTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_FPS ) ;
      fpsPotmeter = new Potmeter ( application ) ;
      fg . addToContent ( fpsPotmeter , true , 7 ) ;
      fpsPotmeter . setMinMaxIncValues ( 10 , 42 , 1 ) ;
      fpsPotmeter . setCurValue ( cameraFps ) ;
      fpsPotmeter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , fpsChanged ) ;
      resetButtonLink = new ButtonLink ( application ) ;
      fg . addToContent ( resetButtonLink , true , 8 ) ;
      resetButtonLink . setTextCode ( application . getTexts ( ) . RESET ) ;
      resetButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , resetCamera ) ;
      qualityTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( qualityTextLabel , false , 9 ) ;
      qualityTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_QUALITY ) ;
      qualityPotmeter = new Potmeter ( application ) ;
      fg . addToContent ( qualityPotmeter , true , 10 ) ;
      qualityPotmeter . setMinMaxIncValues ( 42 , 100 , 1 ) ;
      qualityPotmeter . setCurValue ( cameraQuality ) ;
      qualityPotmeter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , qualityChanged ) ;
      resolutionListPicker = new ListPicker ( application ) ;
      fg . addToContent ( resolutionListPicker , true , 11 ) ;
      resolutionListPicker . setArrays ( resolutionsArray , resolutionsArray ) ;
      resolutionListPicker . setNumOfElements ( resolutionsArray . length ) ;
      resolutionListPicker . setSelectedIndex ( resolutionsArray . indexOf ( cameraResolution ) ) ;
      resolutionListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , resolutionListPickerChanged ) ;
      filterTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( filterTextLabel , false , 12 ) ;
      filterTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_FILTER ) ;
      filterPotmeterB = new Potmeter ( application ) ;
      fg . addToContent ( filterPotmeterB , true , 13 ) ;
      filterPotmeterB . setMinMaxIncValues ( 0 , 16 , 1 ) ;
      filterPotmeterB . setCurValue ( 0 ) ;
      filterPotmeterB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmeterBChanged ) ;
      filterPotmeterCA = new Potmeter ( application ) ;
      fg . addToContent ( filterPotmeterCA , true , 14 ) ;
      filterPotmeterCA . setMinMaxIncValues ( 0 , 1 , 0.01 ) ;
      filterPotmeterCA . setCurValue ( 1 ) ;
      filterPotmeterCA . setDecimalPrecision ( 2 ) ;
      filterPotmeterCA . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmeterCChanged ) ;
      filterPotmeterCR = new Potmeter ( application ) ;
      fg . addToContent ( filterPotmeterCR , true , 14 ) ;
      filterPotmeterCR . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmeterCR . setCurValue ( 1 ) ;
      filterPotmeterCR . setDecimalPrecision ( 2 ) ;
      filterPotmeterCR . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmeterCChanged ) ;
      filterPotmeterCG = new Potmeter ( application ) ;
      fg . addToContent ( filterPotmeterCG , true , 14 ) ;
      filterPotmeterCG . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmeterCG . setCurValue ( 1 ) ;
      filterPotmeterCG . setDecimalPrecision ( 2 ) ;
      filterPotmeterCG . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmeterCChanged ) ;
      filterPotmeterCB = new Potmeter ( application ) ;
      fg . addToContent ( filterPotmeterCB , true , 14 ) ;
      filterPotmeterCB . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmeterCB . setCurValue ( 1 ) ;
      filterPotmeterCB . setDecimalPrecision ( 2 ) ;
      filterPotmeterCB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmeterCChanged ) ;
      filterPotmeterCB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeResolutionListPicker ) ;
      resizeResolutionListPicker ( null ) ;
    }
/*
** Check for Camera permission immediately.
*/
    override protected function addedToStage ( e : Event ) : void
    {
// Calling the addedToStage of parent.
      super . addedToStage ( e ) ;
// And the camera permission
      application . askForCameraPermission ( ) ;
    }
/*
** The wide property of the camera has been changed.
** Destroys the camera view, does some modification and creates the camera again.
*/
    private function resolutionListPickerChanged ( e : Event ) : void
    {
      if ( resolutionListPicker != null )
      {
        destroyVideo ( ) ;
        cameraResolution = resolutionListPicker . getText ( ) ;
        calcSizeStuffs ( ) ;
        createVideo ( ) ;
      }
    }
/*
** The size of the resolutionListPicker will follow the sizes of the potmeters.
*/
    private function resizeResolutionListPicker ( e : Event ) : void
    {
      if ( resolutionListPicker != null && filterPotmeterCA != null )
      {
        resolutionListPicker . setsw ( filterPotmeterCA . getsw ( ) * 2 ) ;
      }
    }
/*
** The size of the camera is changed.
** Destroys the camera view, does some modification and creates the camera again.
*/
    private function sizePotmeterChanged ( e : Event ) : void
    {
      if ( sizePotmeter != null )
      {
        destroyVideo ( ) ;
        cameraWidth = sizePotmeter . getCurValue ( ) ;
        calcSizeStuffs ( ) ;
        createVideo ( ) ;
      }
    }
/*
** Sets the size of the camera from outside.
*/
    public function setCameraSize ( i : int ) : void
    {
      if ( sizePotmeter != null )
      {
        sizePotmeter . setCurValue ( i ) ;
      }
    }
/*
** The fps of the camera is changed.
** No need to destroy the current camera view.
*/
    private function fpsChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
        cameraFps = fpsPotmeter . getCurValue ( ) ;
        camera . setMode ( cameraWidth , cameraHeight , cameraFps ) ;
      }
    }
/*
** The quality of the camera is changed.
** No need to destroy the current camera view.
*/
    private function qualityChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
        cameraQuality = qualityPotmeter . getCurValue ( ) ;
        camera . setQuality ( 0 , cameraQuality ) ;
      }
    }
/*
** The filter of the camera is changed.
*/
    private function filterPotmeterBChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
// Let it be null!
        blurFilter = null ;
// Create only if the blur filter is needed.
        if ( filterPotmeterB . getCurValue ( ) > 0 )
        {
          blurFilter = new BlurFilter ( filterPotmeterB . getCurValue ( ) , filterPotmeterB . getCurValue ( ) / 2 , 1 ) ;
        }
// Has to refilter.
        applyFilters ( ) ;
      }
    }
    private function filterPotmeterCChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
// Let it be null!
        colorMatrixFilter = null ;
// Filtering if the filter is requested.
        if ( filterPotmeterCR . getCurValue ( ) != 1 || filterPotmeterCG . getCurValue ( ) != 1 || filterPotmeterCB . getCurValue ( ) != 1 || filterPotmeterCA . getCurValue ( ) != 1 )
        {
// This will be the matrix to be applied.
          var colorMatrixArray : Array = new Array ( ) ;
          var r : Number = filterPotmeterCR . getCurValue ( ) ;
          var g : Number = filterPotmeterCG . getCurValue ( ) ;
          var b : Number = filterPotmeterCB . getCurValue ( ) ;
          var a : Number = filterPotmeterCA . getCurValue ( ) ;
          colorMatrixArray = colorMatrixArray . concat ( [ r , 0 , 0 , 0 , 0 ] ) ;
          colorMatrixArray = colorMatrixArray . concat ( [ 0 , g , 0 , 0 , 0 ] ) ;
          colorMatrixArray = colorMatrixArray . concat ( [ 0 , 0 , b , 0 , 0 ] ) ;
          colorMatrixArray = colorMatrixArray . concat ( [ 0 , 0 , 0 , a , 0 ] ) ;
// Creating the filter itself using the matrix above.
          colorMatrixFilter = new ColorMatrixFilter ( colorMatrixArray ) ;
        }
// Has to refilter.
        applyFilters ( ) ;
      }
    }
/*
** The camera object has been changed by user selection.
*/
    private function cameraListPickerChanged ( e : Event ) : void
    {
// Has to be completely destroyed and recreated.
      detachCamera ( null ) ;
      attachCamera ( null ) ;
    }
/*
** All of the properties will be restored except some.
*/
    private function resetCamera ( e : Event ) : void
    {
      if ( fpsPotmeter != null )
      {
        fpsPotmeter . setCurValue ( 24 ) ;
      }
      if ( qualityPotmeter != null )
      {
        qualityPotmeter . setCurValue ( 100 ) ;
      }
      if ( filterPotmeterB != null )
      {
        filterPotmeterB . setCurValue ( 0 ) ;
      }
      if ( filterPotmeterCR != null )
      {
        filterPotmeterCR . setCurValue ( 1 ) ;
      }
      if ( filterPotmeterCG != null )
      {
        filterPotmeterCG . setCurValue ( 1 ) ;
      }
      if ( filterPotmeterCB != null )
      {
        filterPotmeterCB . setCurValue ( 1 ) ;
      }
      if ( filterPotmeterCA != null )
      {
        filterPotmeterCA . setCurValue ( 1 ) ;
      }
    }
/*
** Apply the filters.
** If at least one of the filters is requested then the filter or filters
** will go into the filters array, otherwise the filters of bg will be null.
*/
    private function applyFilters ( ) : void
    {
      if ( blurFilter == null && colorMatrixFilter != null )
      {
        bg . filters = [ colorMatrixFilter ] ;
      }
      else if ( blurFilter != null && colorMatrixFilter == null )
      {
        bg . filters = [ blurFilter ] ;
      }
      else if ( blurFilter != null && colorMatrixFilter != null )
      {
        bg . filters = [ colorMatrixFilter , blurFilter ] ;
      }
      else
      {
        bg . filters = null ;
      }
    }
/*
** Clearing the camera view, the last picture if there is any, the bitmapdata and the byte array.
*/
    public function clearLastPicBitmapdDataByteArray ( ) : void
    {
      clearLastPicture ( ) ;
      if ( bitmapData != null )
      {
        bitmapData . dispose ( ) ;
        bitmapData = null ;
      }
      savedPictureName = "" ;
      savedPictureByteArray = null ;
    }
/*
** Gets the byte array of a taken picture.
*/
    public function getSavedPictureName ( ) : String
    {
      return savedPictureName ;
    }
/*
** Gets the byte array of a taken picture.
*/
    public function getSavedPictureByteArray ( ) : ByteArray
    {
      return savedPictureByteArray ;
    }
/*
** Taking and saving a picture.
*/
    private function takePictureClick ( e : Event ) : void
    {
      if ( camera != null )
      {
// This will be the bitmapdata to draw.
        clearLastPicBitmapdDataByteArray ( ) ;
        bitmapData = new BitmapData ( cameraWidth , cameraHeight , true , 0 ) ;
// Some property need to be invisible while taking the picture.
        shapeBgMask . visible = false ;
        shapeBgFrame . visible = false ;
        fg . visible = false ;
        bg . mask = null ;
// The relevant part of the stage background can be used.
        copyStagebg ( bitmapData ) ;
// Now the bitmapdata drawing from this whole object.
        bitmapData . draw ( this ) ;
// Let's make visible the necessary object again.
        shapeBgMask . visible = true ;
        shapeBgFrame . visible = true ;
        fg . visible = true ;
        bg . mask = shapeBgMask ;
// Ok, the sizes and the byte array have to be created now.
        var date : Date = new Date ( ) ;
        savedPictureName = "CamD" + ( ( "" + date . fullYear ) . substr ( 2 , 2 ) ) + getDateElement ( date . month + 1 ) + getDateElement ( date . date ) + "T" + getDateElement ( date . hours ) + getDateElement ( date . minutes ) + getDateElement ( date . seconds ) + ".png" ;
// Drawing the photo.
        showLastPicture ( ) ;
// The bytearray will contain the data of the picture to be saved.
        savedPictureByteArray = new ByteArray ( ) ;
// JPEG encoding will happen with 100% quality.
        bitmapData . encode ( new Rectangle ( 0 , 0 , cameraWidth , cameraHeight ) , new PNGEncoderOptions ( false ) , savedPictureByteArray ) ;
// And the file saving. There will be differences between air and web contexts.
/*
        if ( application . getFileClassIsUsable ( ) )
        {
          saveByteArrayFile ( ) ;
        }
        else
        {
          saveByteArrayFileReference ( ) ;
        }
*/
      }
// The button now has to be enabled again.
// If there are any previous problem then this will not be executed.
      takePicture . setEnabled ( true ) ;
    }
/*
** Display the last taken picture.
*/
    public function showLastPicture ( ) : void
    {
      clearLastPicture ( ) ;
      if ( bitmapData != null )
      {
// Drawing the photo..
        photo = new BaseSprite ( application ) ;
        addChild ( photo ) ;
        photo . graphics . clear ( ) ;
        photo . graphics . beginBitmapFill ( bitmapData , null , false , true ) ;
        photo . graphics . drawRect ( 0 , 0 , cameraWidth , cameraHeight ) ;
        photo . graphics . endFill ( ) ;
// ..and adding a label to display the filename.
        pictureSaved = new TextLabel ( application ) ;
        addChild ( pictureSaved ) ;
        pictureSaved . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
        pictureSaved . setTextCode ( savedPictureName ) ;
        pictureSavedRepos ( ) ;
// The camrea object will be detached.
        detachCamera ( null ) ;
      }
    }
/*
** The reposition of the saved filename.
*/
    private function pictureSavedRepos ( ) : void
    {
      if ( pictureSaved != null )
      {
        pictureSaved . setcxy ( Math . max ( 0 , cameraWidth - pictureSaved . getsw ( ) ) , Math . max ( 0 , cameraHeight - pictureSaved . getsh ( ) ) ) ;
      }
    }
/*
** Removes the last picture that was taken from the camrea.
*/
    public function clearLastPicture ( ) : void
    {
      if ( photo != null )
      {
        if ( contains ( photo ) )
        {
          removeChild ( photo ) ;
        }
        photo = null ;
      }
      if ( pictureSaved != null )
      {
        if ( contains ( pictureSaved ) )
        {
          removeChild ( pictureSaved ) ;
        }
        pictureSaved = null ;
      }
    }
/*
** Just for well formatting the fiename to save the picture.
*/
    private function getDateElement ( i : int ) : String
    {
      return ( ( "" + i ) . length == 1 ? "0" + i : "" + i ) ;
    }
/*
** The saved event will be dispatched.
*/
    private function dispatchSavedEvent ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && savedEvent != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( savedEvent ) ;
        if ( pictureSaved != null && getFileReference ( ) != null )
        {
          savedPictureName = getFileReference ( ) . name ;
          pictureSaved . setTextCode ( savedPictureName ) ;
          pictureSavedRepos ( ) ;
        }
      }
    }
/*
** Let the outside world have the informations about the last saved image.
*/
    public function getFileReference ( ) : *
    {
      if ( application . getFileClassIsUsable ( ) )
      {
        return file ;
      }
      else
      {
        return fileReference ;
      }
    }
/*
** The size of the take picture button has been changed.
*/
    private function takePictureSizeChanged ( e : Event ) : void
    {
      if ( cameraListPicker != null && cameraListPicker != null )
      {
// Resize the listpicker of the available camera devices.
        cameraListPicker . setsw ( takePicture . getsw ( ) ) ;
      }
    }
/*
** The background of the stage is copied.
*/
    private function copyStagebg ( bmd : BitmapData ) : void
    {
      if ( filterPotmeterCA . getCurValue ( ) != 1 )
      {
// If the alpha channel is not 1 then copy the area of the stage being under this
// camera object and draw this onto the BitmapData object given from argument.
        var point : Point = new Point ( 0 , 0 ) ;
        var matrix : Matrix = new Matrix ( ) ;
        matrix . translate ( int ( - localToGlobal ( point ) . x ) , int ( - localToGlobal ( point ) . y ) ) ;
        bmd . draw ( application . getBackground ( ) , matrix ) ;
      }
    }
/*
** The savings of the bytearray.
** air: saving into the documents directory
** web: saving where the user wants to
    private function saveByteArrayFile ( ) : void
    {
      file = File . userDirectory . resolvePath ( savedPictureName ) ;
      file . requestPermission ( ) ;
      var fileStream : FileStream = new FileStream ( ) ;
      fileStream . open ( File ( file ) , FileMode . WRITE ) ;
      fileStream . writeBytes ( savedPictureByteArray ) ;
      fileStream . close ( ) ;
      dispatchSavedEvent ( ) ;
    }
    private function saveByteArrayFileReference ( ) : void
    {
      fileReference = new FileReference ( ) ;
      fileReference . addEventListener ( Event . COMPLETE , savedFromFileReference ) ;
      fileReference . save ( savedPictureByteArray , savedPictureName ) ;
    }
    private function savedFromFileReference ( e : Event ) : void
    {
      fileReference . removeEventListener ( Event . COMPLETE , savedFromFileReference ) ;
      dispatchSavedEvent ( ) ;
    }
*/
/*
** Recalculating and resizing the camera.
** After changing the wide or width property.
*/
    private function calcSizeStuffs ( ) : void
    {
// The height depends on the width and the wide boolean property!
      calcCamHeight ( ) ;
// Setting the mode of the camera object.
      if ( camera != null )
      {
        camera . setMode ( cameraWidth , cameraHeight , cameraFps ) ;
      }
// This object has to be resized too.
      super . setswh ( cameraWidth , cameraHeight ) ;
// The shapes will be repainted.
      redrawShapes ( null ) ;
// The gb and the fg also have to be resized.
      bg . setswh ( cameraWidth , cameraHeight ) ;
      fg . setswh ( cameraWidth , cameraHeight ) ;
    }
/*
** Sets the aspect ratio to a constant value or clears it.
*/
    public function setCameraAspectRatioTo11 ( ) : void
    {
      if ( resolutionListPicker != null )
      {
        resolutionListPicker . setSelectedIndex ( resolutionsArray . indexOf ( RES_11 ) ) ;
        resolutionListPicker . setEnabled ( false ) ;
      }
    }
    public function setCameraAspectRatioTo43 ( ) : void
    {
      if ( resolutionListPicker != null )
      {
        resolutionListPicker . setSelectedIndex ( resolutionsArray . indexOf ( RES_43 ) ) ;
        resolutionListPicker . setEnabled ( false ) ;
      }
    }
    public function setCameraAspectRatioTo169 ( ) : void
    {
      if ( resolutionListPicker != null )
      {
        resolutionListPicker . setSelectedIndex ( resolutionsArray . indexOf ( RES_169 ) ) ;
        resolutionListPicker . setEnabled ( false ) ;
      }
    }
    public function setCameraAspectRatioToAny ( ) : void
    {
      if ( resolutionListPicker != null )
      {
        resolutionListPicker . setEnabled ( true ) ;
      }
    }
/*
** Redraws the shapes. The clickable sprite too.
*/
    private function redrawShapes ( e : Event ) : void
    {
      if ( application != null )
      {
        shapeBgMask . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeBgMask . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeBgMask . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeBgMask . drawRect ( ) ;
        shapeBgFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        shapeBgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius ( ) ) ;
        shapeBgFrame . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeBgFrame . drawRect ( ) ;
        clickSprite . graphics . clear ( ) ;
        clickSprite . graphics . beginFill ( 0 , 0 ) ;
        clickSprite . graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
        clickSprite . graphics . endFill ( ) ;
      }
    }
/*
** The mouse is down on the background so the foreground has to be visible.
*/
    private function clickSpriteMouseDown ( e : MouseEvent ) : void
    {
      if ( ! isCameraInUse ( ) )
      {
        fg . visible = true ;
        fg . getBaseScroll ( ) . doRollOver ( ) ;
// Listen to the closing.
        if ( stage != null )
        {
          stage . addEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
        }
      }
    }
/*
** Listen to the mouse down event.
** If the mouse is not over the object then the fg has to be not visible.
*/
    private function stageMouseDown ( e : MouseEvent ) : void
    {
      if ( ! ( mouseX > 0 && mouseX < getsw ( ) && mouseY > 0 && mouseY < getsh ( ) ) )
      {
        if ( stage != null )
        {
          stage . removeEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
        }
        fg . visible = false ;
      }
    }
/*
** Calculates the height of the camera.
*/
    private function calcCamHeight ( ) : void
    {
      if ( cameraResolution == RES_43 )
      {
        cameraHeight = int ( cameraWidth * 3 / 4 ) ;
      }
      else if ( cameraResolution == RES_169 )
      {
        cameraHeight = int ( cameraWidth * 9 / 16 ) ;
      }
      else
      {
        cameraHeight = cameraWidth ;
      }
    }
/*
** Gets the camera object to use for example in a stream.
*/
    public function getCamera ( ) : flash . media . Camera
    {
      return camera ;
    }
/*
** Attaches the camera.
*/
    private function attachCamera ( e : Event ) : void
    {
// Both have to be null!
      if ( camera == null && video == null && cameraListPicker != null )
      {
// It would be good to disappear.
        clearLastPicture ( ) ;
// Getting the camera object marked by the cameraListPicker.
        camera = flash . media . Camera . getCamera ( String ( cameraListPicker . getSelectedIndex ( ) ) ) ;
// Null means that the previous operation was not successful so the default camera object will be used.
        if ( camera == null )
        {
          camera = flash . media . Camera . getCamera ( ) ;
        }
// Now new hope that we have got a valid reference to a camera.
        if ( camera != null && ! camera . muted )
        {
// Mode and quality settings.
          camera . setMode ( cameraWidth , cameraHeight , cameraFps ) ;
          camera . setQuality ( 0 , cameraQuality ) ;
// We have to know that the user or the system allows to use this device.
          camera . addEventListener ( StatusEvent . STATUS , permissionHandler ) ;
// We need a video object to display the view of the cam.
          createVideo ( ) ;
// The visibility of the linkbutton objects has to be changed!
          cameraAttachButtonLink . visible = false ;
          cameraDetachButtonLink . visible = true ;
// An event has to be dispatched now.
          if ( getBaseEventDispatcher ( ) != null )
          {
            getBaseEventDispatcher ( ) . dispatchEvent ( cameraIsAttachedEvent ) ;
          }
        }
        else
        {
// Alert to the user to check its settings.
          showAlert ( application . getTexts ( ) . REQUIRED_PERMISSIONS_ALERT ) ;
// Just to be sure.
          detachCamera ( null ) ;
        }
      }
    }
/*
** Creating the video object using the selected camera.
*/
    private function createVideo ( ) : void
    {
      if ( camera != null && bg != null )
      {
        video = new flash . media . Video ( ) ;
        video . width = cameraWidth ;
        video . height = cameraHeight ;
        video . attachCamera ( camera ) ;
        bg . addChild ( video ) ;
      }
    }
/*
** Handles the permission events.
** Detaching if something is not good.
*/
    private function permissionHandler ( e : Event ) : void
    {
      if ( camera != null && ! camera . muted )
      {
// Camera is ready
      }
      else
      {
// No camera, just to be sure, detach it.
        detachCamera ( null ) ;
      }
    }
/*
** Clears the camera.
*/
    public function clearCamera ( ) : void
    {
      detachCamera ( null ) ;
    }
/*
** Detaches the camera.
*/
    private function detachCamera ( e : Event ) : void
    {
// The video object has to be destroyed.
      destroyVideo ( ) ;
// The camera also has to be null.
      if ( camera != null )
      {
        camera . removeEventListener ( StatusEvent . STATUS , permissionHandler ) ;
        camera = null ;
      }
// The button link visibility will be changed.
      if ( cameraAttachButtonLink != null )
      {
        cameraAttachButtonLink . visible = true ;
        setChildIndex ( cameraAttachButtonLink , numChildren - 1 ) ;
      }
      if ( cameraDetachButtonLink != null )
      {
        cameraDetachButtonLink . visible = false ;
      }
// The foreground has to disappear.
      if ( fg != null )
      {
        fg . visible = false ;
      }
    }
/*
** We are going to destroy the video object and release the used camera.
*/
    private function destroyVideo ( ) : void
    {
      if ( video != null )
      {
        video . attachCamera ( null ) ;
        if ( bg != null )
        {
          bg . removeChild ( video ) ;
        }
        video = null ;
      }
    }
/*
** Is the camera in use?
*/
    public function isCameraInUse ( ) : Boolean
    {
      return camera == null ;
    }
/*
** Overriding the sizer methods.
** (to do nothing.)
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** To create alert easier.
*/
    protected function showAlert ( messageString : String , fullscreen : Boolean = false ) : void
    {
      var uniqueString : String = "" + new Date ( ) . time ;
      var okFunction : Function = function ( e : Event ) : void
      {
        application . getForeground ( ) . closeAlert ( uniqueString ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , okFunction ) ;
        if ( alertOK != null )
        {
          alertOK ( ) ;
        }
        e . stopImmediatePropagation ( ) ;
      }
      application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_OK , okFunction ) ;
      application . getForeground ( ) . createAlert ( messageString , uniqueString , true , false , false , fullscreen ) ;
    }
/*
** Override of destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
      }
/*
      if ( fileReference != null )
      {
        fileReference . removeEventListener ( Event . COMPLETE , savedFromFileReference ) ;
      }
*/
      if ( clickSprite != null )
      {
        clickSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , clickSpriteMouseDown ) ;
      }
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , redrawShapes ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      detachCamera ( null ) ;
      if ( savedEvent != null )
      {
        savedEvent . stopImmediatePropagation ( ) ;
      }
      clearLastPicBitmapdDataByteArray ( ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      bg = null ;
      shapeBgMask = null ;
      shapeBgFrame = null ;
      clickSprite = null ;
      cameraAttachButtonLink = null ;
      cameraDetachButtonLink = null ;
      fg = null ;
      resolutionListPicker = null ;
      sizeTextLabel = null ;
      sizePotmeter = null ;
      fpsTextLabel = null ;
      fpsPotmeter = null ;
      qualityTextLabel = null ;
      qualityPotmeter = null ;
      filterTextLabel = null ;
      filterPotmeterB = null ;
      filterPotmeterCR = null ;
      filterPotmeterCG = null ;
      filterPotmeterCB = null ;
      filterPotmeterCA = null ;
      resetButtonLink = null ;
      takePicture = null ;
      pictureSaved = null ;
      cameraListPicker = null ;
      filenameToSave = null ;
      camera = null ;
      video = null ;
      cameraResolution = null ;
      cameraWidth = 0 ;
      cameraHeight = 0 ;
      cameraFps = 0 ;
      cameraQuality = 0 ;
      blurFilter = null ;
      colorMatrixFilter = null ;
      cameraDevices = null ;
      savedPictureName = null ;
      savedPictureByteArray = null ;
      savedEvent = null ;
      file = null ;
      fileReference = null ;
      resolutionsArray = null ;
      photo = null ;
      bitmapData = null ;
      cameraIsAttachedEvent = null ;
    }
  }
}
