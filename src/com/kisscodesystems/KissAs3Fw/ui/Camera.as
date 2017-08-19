/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3FwDemos
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
**   camera wide:    on  -  off (16:9 or 4:3)
**   camera width:   160 -  960
**   camera fps:     10  -  42
**   camera quality: 42  -  100
**   camera filter:  0   -  16 : blur
**                   0   -  1  : alpha channel
**                   0   -  2  : red channel
**                   0   -  2  : green channel
**                   0   -  2  : blue channel
**   (for taking a picture and not for outgoing stream)
**
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . Potmet ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
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
// The sprite where the camera object can be appeared.
    private var bg : BaseSprite = null ;
// Mask for the better view of the cam.
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
    private var wideSwitcher : Switcher = null ;
    private var sizeTextLabel : TextLabel = null ;
    private var sizePotmet : Potmet = null ;
    private var fpsTextLabel : TextLabel = null ;
    private var fpsPotmet : Potmet = null ;
    private var qualityTextLabel : TextLabel = null ;
    private var qualityPotmet : Potmet = null ;
    private var filterTextLabel : TextLabel = null ;
    private var filterPotmetB : Potmet = null ;
    private var filterPotmetCR : Potmet = null ;
    private var filterPotmetCG : Potmet = null ;
    private var filterPotmetCB : Potmet = null ;
    private var filterPotmetCA : Potmet = null ;
    private var takePicture : ButtonText = null ;
    private var pictureSaved : TextLabel = null ;
    private var cameraListPicker : ListPicker = null ;
// This will be the default filename to save the photo.
    private var filenameToSave : String = null ;
// The camera object.
    private var camera : flash . media . Camera = null ;
// The video object to display the view of the camera
    private var video : flash . media . Video = null ;
// The available sizes of the camera.
    private var cameraWide : Boolean = false ;
    private var cameraWidth : int = 320 ;
    private var cameraHeight : int = 240 ;
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
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Camera ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The actual size of this object.
      super . setswh ( cameraWidth , cameraHeight ) ;
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
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , redrawShapes ) ;
// The event of the successfully saving.
      savedEvent = new Event ( application . EVENT_SAVED ) ;
// And an initial redrawing.
      redrawShapes ( null ) ;
// Detecting the camera devices.
      cameraDevices = new Array ( ) ;
      for ( var i : int = 0 ; i < flash . media . Camera . names . length ; i ++ )
      {
        cameraDevices . push ( "Cam " + flash . media . Camera . names [ i ] ) ;
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
      sizePotmet = new Potmet ( application ) ;
      fg . addToContent ( sizePotmet , true , 4 ) ;
      sizePotmet . setMinMaxIncValues ( 160 , 960 , 160 ) ;
      sizePotmet . setCurValue ( cameraWidth ) ;
      sizePotmet . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , sizeChanged ) ;
      cameraListPicker = new ListPicker ( application ) ;
      fg . addToContent ( cameraListPicker , true , 5 ) ;
      cameraListPicker . setArrays ( cameraDevices , cameraDevices ) ;
      cameraListPicker . setSelectedIndex ( 0 ) ;
      cameraListPicker . setNumOfElements ( 5 ) ;
      cameraListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , cameraChanged ) ;
      takePictureSizeChanged ( null ) ;
      fpsTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( fpsTextLabel , false , 6 ) ;
      fpsTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_FPS ) ;
      fpsPotmet = new Potmet ( application ) ;
      fg . addToContent ( fpsPotmet , true , 7 ) ;
      fpsPotmet . setMinMaxIncValues ( 10 , 42 , 1 ) ;
      fpsPotmet . setCurValue ( cameraFps ) ;
      fpsPotmet . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , fpsChanged ) ;
      pictureSaved = new TextLabel ( application ) ;
      fg . addToContent ( pictureSaved , false , 8 ) ;
      pictureSaved . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      qualityTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( qualityTextLabel , false , 9 ) ;
      qualityTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_QUALITY ) ;
      qualityPotmet = new Potmet ( application ) ;
      fg . addToContent ( qualityPotmet , true , 10 ) ;
      qualityPotmet . setMinMaxIncValues ( 42 , 100 , 1 ) ;
      qualityPotmet . setCurValue ( cameraQuality ) ;
      qualityPotmet . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , qualityChanged ) ;
      wideSwitcher = new Switcher ( application ) ;
      fg . addToContent ( wideSwitcher , true , 11 ) ;
      wideSwitcher . setTextCodes ( application . getTexts ( ) . CAMERA_WIDE_RES , application . getTexts ( ) . CAMERA_NORMAL_RES ) ;
      wideSwitcher . setUp ( cameraWide ) ;
      wideSwitcher . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , wideSwitcherChanged ) ;
      filterTextLabel = new TextLabel ( application ) ;
      fg . addToContent ( filterTextLabel , false , 12 ) ;
      filterTextLabel . setTextCode ( application . getTexts ( ) . CAMERA_FILTER ) ;
      filterPotmetB = new Potmet ( application ) ;
      fg . addToContent ( filterPotmetB , true , 13 ) ;
      filterPotmetB . setMinMaxIncValues ( 0 , 16 , 1 ) ;
      filterPotmetB . setCurValue ( 0 ) ;
      filterPotmetB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmetBChanged ) ;
      filterPotmetCA = new Potmet ( application ) ;
      fg . addToContent ( filterPotmetCA , true , 14 ) ;
      filterPotmetCA . setMinMaxIncValues ( 0 , 1 , 0.01 ) ;
      filterPotmetCA . setCurValue ( 1 ) ;
      filterPotmetCA . setDecimalPrecision ( 2 ) ;
      filterPotmetCA . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmetCChanged ) ;
      filterPotmetCR = new Potmet ( application ) ;
      fg . addToContent ( filterPotmetCR , true , 14 ) ;
      filterPotmetCR . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmetCR . setCurValue ( 1 ) ;
      filterPotmetCR . setDecimalPrecision ( 2 ) ;
      filterPotmetCR . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmetCChanged ) ;
      filterPotmetCG = new Potmet ( application ) ;
      fg . addToContent ( filterPotmetCG , true , 14 ) ;
      filterPotmetCG . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmetCG . setCurValue ( 1 ) ;
      filterPotmetCG . setDecimalPrecision ( 2 ) ;
      filterPotmetCG . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmetCChanged ) ;
      filterPotmetCB = new Potmet ( application ) ;
      fg . addToContent ( filterPotmetCB , true , 14 ) ;
      filterPotmetCB . setMinMaxIncValues ( 0 , 2 , 0.01 ) ;
      filterPotmetCB . setCurValue ( 1 ) ;
      filterPotmetCB . setDecimalPrecision ( 2 ) ;
      filterPotmetCB . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , filterPotmetCChanged ) ;
    }
/*
** The wide property of the camera has been changed.
** Destroys the camera view, does some modification and creates the camera again.
*/
    private function wideSwitcherChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
        destroyVideo ( ) ;
        cameraWide = wideSwitcher . getUp ( ) ;
        calcSizeStuffs ( ) ;
        createVideo ( ) ;
      }
    }
/*
** The size of the camera is changed.
** Destroys the camera view, does some modification and creates the camera again.
*/
    private function sizeChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
        destroyVideo ( ) ;
        cameraWidth = sizePotmet . getCurValue ( ) ;
        calcSizeStuffs ( ) ;
        createVideo ( ) ;
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
        cameraFps = fpsPotmet . getCurValue ( ) ;
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
        cameraQuality = qualityPotmet . getCurValue ( ) ;
        camera . setQuality ( 0 , cameraQuality ) ;
      }
    }
/*
** The filter of the camera is changed.
*/
    private function filterPotmetBChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
// Let it be null!
        blurFilter = null ;
// Create only if the blur filter is needed.
        if ( filterPotmetB . getCurValue ( ) > 0 )
        {
          blurFilter = new BlurFilter ( filterPotmetB . getCurValue ( ) , filterPotmetB . getCurValue ( ) / 2 , 1 ) ;
        }
// Has to refilter.
        applyFilters ( ) ;
      }
    }
    private function filterPotmetCChanged ( e : Event ) : void
    {
      if ( camera != null )
      {
// Let it be null!
        colorMatrixFilter = null ;
// Filtering if the filter is requested.
        if ( filterPotmetCR . getCurValue ( ) != 1 || filterPotmetCG . getCurValue ( ) != 1 || filterPotmetCB . getCurValue ( ) != 1 || filterPotmetCA . getCurValue ( ) != 1 )
        {
// This will be the matrix to be applied.
          var colorMatrixArray : Array = new Array ( ) ;
          var r : Number = filterPotmetCR . getCurValue ( ) ;
          var g : Number = filterPotmetCG . getCurValue ( ) ;
          var b : Number = filterPotmetCB . getCurValue ( ) ;
          var a : Number = filterPotmetCA . getCurValue ( ) ;
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
    private function cameraChanged ( e : Event ) : void
    {
// Has to be completely destroyed and recreated.
      detachCamera ( null ) ;
      attachCamera ( null ) ;
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
** Taking and saving a picture.
*/
    private function takePictureClick ( e : Event ) : void
    {
      pictureSaved . setTextCode ( "" ) ;
      if ( camera != null )
      {
// This will be the bitmapdata to draw.
        var bitmapData : BitmapData = new BitmapData ( cameraWidth , cameraHeight , true , 0 ) ;
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
        savedPictureName = "CamD" + date . fullYear + date . month + date . date + "T" + date . hours + date . minutes + date . seconds + ".png" ;
        savedPictureByteArray = new ByteArray ( ) ;
// JPEG encoding will happen with 100% quality.
        bitmapData . encode ( new Rectangle ( 0 , 0 , cameraWidth , cameraHeight ) , new PNGEncoderOptions ( false ) , savedPictureByteArray ) ;
// And the file saving. There will be differences between air and web contects.
        if ( application . getFileClassIsUsable ( ) )
        {
          saveByteArrayFile ( ) ;
        }
        else
        {
          saveByteArrayFileReference ( ) ;
        }
// Free the memory area of the bitmapdata used.
        bitmapData . dispose ( ) ;
      }
// The button now has to be enabled again.
      takePicture . setEnabled ( true ) ;
    }
/*
** The saved event will be dispatched.
*/
    private function dispatchSavedEvent ( ) : void
    {
      if ( getBaseEventDispatcher ( ) != null && savedEvent != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( savedEvent ) ;
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
    private function copyStagebg ( bitmapData : BitmapData ) : void
    {
      if ( filterPotmetCA . getCurValue ( ) != 1 )
      {
// If the alpha channel is not 1 then copy the area of the stage being under this
// camera object and draw this onto the bitmapData object given from argument.
        var point : Point = new Point ( 0 , 0 ) ;
        var matrix : Matrix = new Matrix ( ) ;
        matrix . translate ( int ( - localToGlobal ( point ) . x ) , int ( - localToGlobal ( point ) . y ) ) ;
        bitmapData . draw ( application . getBackground ( ) , matrix ) ;
      }
    }
/*
** The savings of the bytearray.
** air: saving into the documents directory
** web: saving where the user wants to
*/
    private function saveByteArrayFile ( ) : void
    {
      file = File . documentsDirectory . resolvePath ( savedPictureName ) ;
      var fileStream : FileStream = new FileStream ( ) ;
      fileStream . open ( File ( file ) , FileMode . WRITE ) ;
      fileStream . writeBytes ( savedPictureByteArray ) ;
      fileStream . close ( ) ;
      pictureSaved . setTextCode ( application . getTexts ( ) . CAMERA_PICTURE_SAVED_AIR ) ;
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
      pictureSaved . setTextCode ( application . getTexts ( ) . CAMERA_PICTURE_SAVED_WEB ) ;
      dispatchSavedEvent ( ) ;
    }
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
      bg . setswh ( getsw ( ) , getsh ( ) ) ;
      fg . setswh ( getsw ( ) , getsh ( ) ) ;
    }
/*
** Redraws the shapes. The clickable sprite too.
*/
    private function redrawShapes ( e : Event ) : void
    {
      if ( application != null )
      {
        shapeBgMask . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeBgMask . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
        shapeBgMask . setswh ( getsw ( ) , getsh ( ) ) ;
        shapeBgMask . drawRect ( ) ;
        shapeBgFrame . setccac ( application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundBgColor ( ) , 0 , application . getPropsDyn ( ) . getAppBackgroundFgColor ( ) ) ;
        shapeBgFrame . setsr ( application . getPropsDyn ( ) . getAppRadius1 ( ) ) ;
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
        pictureSaved . setTextCode ( "" ) ;
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
      cameraHeight = int ( cameraWide ? ( cameraWidth * 9 / 16 ) : ( cameraWidth * 3 / 4 ) ) ;
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
      if ( camera == null && video == null )
      {
// Getting the camera object marked by the cameraListPicker.
        camera = flash . media . Camera . getCamera ( String ( cameraListPicker . getSelectedIndex ( ) ) ) ;
// Null means that the previous operation was not successful so the default camera object will be used.
        if ( camera == null )
        {
          camera = flash . media . Camera . getCamera ( ) ;
        }
// Now ew hope that we have got a valid reference to a camera.
        if ( camera != null )
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
        }
        else
        {
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
      video = new flash . media . Video ( ) ;
      video . width = cameraWidth ;
      video . height = cameraHeight ;
      video . attachCamera ( camera ) ;
      bg . addChild ( video ) ;
    }
/*
** Handles the permission events.
** Detaching if something is not good.
*/
    private function permissionHandler ( e : Event ) : void
    {
      if ( camera != null )
      {
        if ( camera . muted )
        {
          detachCamera ( null ) ;
        }
      }
      else
      {
        detachCamera ( null ) ;
      }
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
      cameraAttachButtonLink . visible = true ;
      cameraDetachButtonLink . visible = false ;
// The foreground has to disappear.
      fg . visible = false ;
    }
/*
** We are going to destroy the video object and release the used camera.
*/
    private function destroyVideo ( ) : void
    {
      if ( video != null )
      {
        video . attachCamera ( null ) ;
        bg . removeChild ( video ) ;
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
** Override of destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , stageMouseDown ) ;
      }
      fileReference . removeEventListener ( Event . COMPLETE , savedFromFileReference ) ;
      clickSprite . removeEventListener ( MouseEvent . MOUSE_DOWN , clickSpriteMouseDown ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_BG_COLOR_CHANGED , redrawShapes ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FG_COLOR_CHANGED , redrawShapes ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      detachCamera ( null ) ;
      if ( savedEvent != null )
      {
        savedEvent . stopImmediatePropagation ( ) ;
      }
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
      wideSwitcher = null ;
      sizeTextLabel = null ;
      sizePotmet = null ;
      fpsTextLabel = null ;
      fpsPotmet = null ;
      qualityTextLabel = null ;
      qualityPotmet = null ;
      filterTextLabel = null ;
      filterPotmetB = null ;
      filterPotmetCR = null ;
      filterPotmetCG = null ;
      filterPotmetCB = null ;
      filterPotmetCA = null ;
      takePicture = null ;
      pictureSaved = null ;
      cameraListPicker = null ;
      filenameToSave = null ;
      camera = null ;
      video = null ;
      cameraWide = false ;
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
    }
  }
}