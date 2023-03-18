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
** Image.
** Can load external images.
** It can read images from outside.
** It can display image in a BaseSprite object or in fullscreen.
**
** MAIN FEATURES:
** - image to display from the internet
** - can display the image using a frame is requested
** - delayed if specified
** - can load thumb is specified
** - square can be defined to display and align the image
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . display . BitmapData ;
  import flash . display . Loader ;
  import flash . display . Sprite ;
  import flash . events . Event ;
  import flash . events . IOErrorEvent ;
  import flash . events . SecurityErrorEvent ;
  import flash . events . TimerEvent ;
  import flash . geom . Matrix ;
  import flash . net . URLRequest ;
  import flash . net . URLRequestMethod ;
  import flash . net . URLVariables ;
  import flash . utils . Timer ;
  public class Image extends BaseSprite
  {
// It uses a separate urlrequest and urlloader object since
// only a session id is enough to load an image.
    private var loader : Loader = null ;
    private var urlRequest : URLRequest = null ;
    private var urlVariables : URLVariables = null ;
// These will store the data of the picture.
    private var bitmapData : BitmapData = null ;
// If a resizing is needed.
    private var matrix : Matrix = null ;
// These are necessary to start the download process.
    private var serverId : String = "" ;
    private var sessionId : String = "" ;
    private var fileUrl : String = "" ;
// Temporary width and height data.
// Used during the calculation of the new sizes of the loaded image.
    private var tempWidth : int = 0 ;
    private var tempHeight : int = 0 ;
// This will throw after a loading.
    private var eventFileLoaded : Event = null ;
// A frame was requested or not, it will store that.
    private var frame : Boolean = false ;
// The painting will be happened to here.
    private var canvas : Sprite = null ;
// The background of the mage.
    private var background : BaseShape = null ;
// An invisible layer to the top
    private var foreground : BaseSprite = null ;
// The image can be resized or not.
    private var resizable : Boolean = true ;
// Thumb version of image is also possible.
    private var isThumb : Boolean = false ;
// Timer object to enable delay.
    private var timer : Timer = null ;
// Has to display the image in a square.
    private var inSquare : Boolean = false ;
// It is necessary to separate the elements to a predefined layer structure.
    private var layerBackground : BaseSprite = null ;
    private var layerImage : BaseSprite = null ;
    private var layerOthers : BaseSprite = null ;
// Elements to display image in fullscreen mode.
    private var fullscrButtonLinkToFullscreen : ButtonLink = null ;
    private var fullscrButtonLinkBack : ButtonLink = null ;
    private var fullscrStageBackground : BaseShape = null ;
    private var fullscrStageImage : BaseShape = null ;
    private var fullscrOrigX : int = 0 ;
    private var fullscrOrigY : int = 0 ;
    private var fullscrOrigW : int = 320 ;
    private var fullscrOrigH : int = 240 ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Image ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Let's add the layers
      layerBackground = new BaseSprite ( application ) ;
      addChild ( layerBackground ) ;
      layerImage = new BaseSprite ( application ) ;
      addChild ( layerImage ) ;
      layerOthers = new BaseSprite ( application ) ;
      addChild ( layerOthers ) ;
// The canvas to paint.
      canvas = new Sprite ( ) ;
      layerImage . addChild ( canvas ) ;
// A BaseSprite to the front.
      foreground = new BaseSprite ( application ) ;
      layerOthers . addChild ( foreground ) ;
// The event object needed to inform the outside world about loading.
      eventFileLoaded = new Event ( application . EVENT_FILE_LOADED ) ;
    }
/*
** inSquare set: has to be displayed and aligned in a regular square
*/
    public function getInSquare ( ) : Boolean
    {
      return inSquare ;
    }
    public function setInSquare ( b : Boolean ) : void
    {
      if ( b != inSquare )
      {
        inSquare = b ;
        repaintReposImage ( ) ;
      }
    }
/*
** The get and set of the resizable property.
*/
    public function getResizable ( ) : Boolean
    {
      return resizable ;
    }
    public function setResizable ( r : Boolean ) : void
    {
      if ( resizable != r )
      {
        resizable = r ;
        repaintReposImage ( ) ;
      }
    }
/*
** Creates or destroys a frame around the image.
*/
    public function setFrame ( b : Boolean ) : void
    {
// Does the modification anyway.
      frame = b ;
      repaintReposImage ( ) ;
    }
/*
** Sets the ID of the file and session IDs to the server.
** Use as you want: the ID-s can be used as you implement the server side code.
*/
    public function setParamsAndLoadImage ( pId : String , sId : String , fUrl : String , thumb : Boolean = false , delayed : int = 0 ) : void
    {
// The ids.
      serverId = pId ;
      sessionId = sId ;
      fileUrl = fUrl ;
      isThumb = thumb ;
      if ( thumb )
      {
        frame = false ;
      }
// Lets begin.
      createTimer ( delayed ) ;
    }
/*
** Timer handler functions.
*/
    public function createTimer ( delayed : int ) : void
    {
      destroyTimer ( ) ;
      timer = new Timer ( delayed ) ;
      timer . addEventListener ( TimerEvent . TIMER , timerEvent ) ;
      timer . start ( ) ;
    }
    private function destroyTimer ( ) : void
    {
      if ( timer != null )
      {
        timer . stop ( ) ;
        timer . removeEventListener ( TimerEvent . TIMER , timerEvent ) ;
        timer = null ;
      }
    }
    private function timerEvent ( e : TimerEvent ) : void
    {
      if ( timer != null )
      {
        timer . stop ( ) ;
      }
      loadImage ( ) ;
    }
/*
** Clears the image.
*/
    public function canvasClear ( ) : void
    {
      if ( canvas != null )
      {
        canvas . graphics . clear ( ) ;
      }
      if ( foreground != null )
      {
        foreground . graphics . clear ( ) ;
      }
    }
    public function clear ( ) : void
    {
      canvasClear ( ) ;
      bitmapDataDispose ( ) ;
      bitmapData = new BitmapData ( 1 , 1 ) ;
      repaintReposImage ( ) ;
      destroyTimer ( ) ;
      resetImageLoading ( ) ;
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventFileLoaded ) ;
      }
      destroyFullscrToFullscrButtonLink ( ) ;
    }
/*
** Loads the image from the server after constructing the request.
** It will use the given file id and session id.
** url variables:
**   pid: server side ID (such as PHP session id)
**   sid: other backend side ID
**   fileurl: the whole url where the image will be loaded from
**   thumb: "y" or "n" value
*/
    private function loadImage ( ) : void
    {
// The loader has to be null.
// If not, a download is in progress.
      if ( fileUrl != null && fileUrl != "" )
      {
// Let's see if it has a cached object
        if ( isThumb && application . getThumbs ( ) [ fileUrl ] != undefined )
        {
// All of the tasks have to be done as in case of imageLoadSuccess!
          bitmapDataDispose ( ) ;
          bitmapData = BitmapData ( application . getThumbs ( ) [ fileUrl ] ) . clone ( ) ;
          repaintReposImage ( ) ;
          if ( getBaseEventDispatcher ( ) != null )
          {
            getBaseEventDispatcher ( ) . dispatchEvent ( eventFileLoaded ) ;
          }
          destroyTimer ( ) ;
          resetImageLoading ( ) ;
          destroyFullscrToFullscrButtonLink ( ) ;
        }
        else
        {
          if ( loader == null && sessionId != null && sessionId != "" )
          {
// Construction of the necessary objects.
            loader = new Loader ( ) ;
            urlRequest = new URLRequest ( ) ;
            urlVariables = new URLVariables ( ) ;
            urlVariables [ "pid" ] = serverId ;
            urlVariables [ "sid" ] = sessionId ;
            urlVariables [ "fileurl" ] = fileUrl ;
            urlVariables [ "thumb" ] = isThumb ? "y" : "n" ;
            urlRequest . data = urlVariables ;
            urlRequest . method = URLRequestMethod . POST ;
            urlRequest . url = application . getUrlFiles ( ) ;
// These events have to be registered!
            loader . contentLoaderInfo . addEventListener ( Event . INIT , imageLoadSuccess , false , 0 , true ) ;
            loader . contentLoaderInfo . addEventListener ( IOErrorEvent . IO_ERROR , imageLoadFail , false , 0 , true ) ;
            loader . contentLoaderInfo . addEventListener ( SecurityErrorEvent . SECURITY_ERROR , imageLoadFail , false , 0 , true ) ;
// Now the loading.
            loader . load ( urlRequest ) ;
          }
        }
      }
    }
/*
** The Response code is OK so we have the data of the picture.
*/
    private function imageLoadSuccess ( e : Event ) : void
    {
// Let's destroy it first if it is existing.
      bitmapDataDispose ( ) ;
// New bitmapdata object having the size of the content.
      try
      {
        bitmapData = new BitmapData ( e . target . content . width , e . target . content . height ) ;
        bitmapData . draw ( e . target . content ) ;
        if ( getsw ( ) == 0 && getsh ( ) == 0 )
        {
          super . setswh ( e . target . content . width , e . target . content . height ) ;
        }
      }
      catch ( e : * )
      {
        bitmapData = new BitmapData ( 1 , 1 ) ;
      }
// Cache it if it is a thumb
      if ( isThumb )
      {
        application . getThumbs ( ) [ fileUrl ] = bitmapData . clone ( ) ;
      }
// The image is ready to be painted.
      repaintReposImage ( ) ;
// An event has to be dispatched!
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventFileLoaded ) ;
      }
// fullscreen button if it is not a thumb.
      if ( isThumb )
      {
        destroyFullscrToFullscrButtonLink ( ) ;
      }
      else
      {
        createFullscrButtonLinkToFullscreen ( ) ;
      }
// Timer has to be stopped.
      destroyTimer ( ) ;
// The loader objects are not necessary any more.
      resetImageLoading ( ) ;
    }
/*
** IOError or SecurityError occurred.
*/
    private function imageLoadFail ( e : * ) : void
    {
      bitmapDataDispose ( ) ;
      bitmapData = new BitmapData ( 1 , 1 ) ;
      repaintReposImage ( ) ;
      destroyTimer ( ) ;
      resetImageLoading ( ) ;
    }
/*
** The image loader objects can be released.
*/
    private function resetImageLoading ( ) : void
    {
      if ( loader != null )
      {
        if ( loader . contentLoaderInfo != null )
        {
          loader . contentLoaderInfo . removeEventListener ( Event . INIT , imageLoadSuccess ) ;
          loader . contentLoaderInfo . removeEventListener ( IOErrorEvent . IO_ERROR , imageLoadFail ) ;
          loader . contentLoaderInfo . removeEventListener ( SecurityErrorEvent . SECURITY_ERROR , imageLoadFail ) ;
        }
        loader = null ;
      }
      urlRequest = null ;
      urlVariables = null ;
    }
/*
** We should free the memory area of a previously loaded image.
*/
    private function bitmapDataDispose ( ) : void
    {
      if ( bitmapData != null )
      {
        bitmapData . dispose ( ) ;
        bitmapData = null ;
      }
    }
/*
** When the radius changes.
*/
    private function resize ( e : Event ) : void
    {
      repaintReposImage ( ) ;
    }
/*
** The image can be repainted here.
** Very similar to the center1 painging of the background.
*/
    private function repaintReposImage ( ) : void
    {
      var radius : int = application . getPropsDyn ( ) . getAppRadius ( ) ;
      if ( canvas != null && foreground != null && bitmapData != null )
      {
        canvas . graphics . clear ( ) ;
        foreground . graphics . clear ( ) ;
        var deltaWidth : int = 0 ;
        var deltaHeight : int = 0 ;
        if ( frame )
        {
          deltaWidth = 2 * radius ;
          deltaHeight = 2 * radius ;
        }
        matrix = new Matrix ( ) ;
        tempWidth = bitmapData . width ;
        tempHeight = bitmapData . height ;
        if ( resizable )
        {
          if ( getsw ( ) - deltaWidth < tempWidth )
          {
            tempHeight = Math . round ( ( getsw ( ) - deltaWidth ) / tempWidth * tempHeight ) ;
            tempWidth = getsw ( ) - deltaWidth ;
          }
          if ( getsh ( ) - deltaHeight < tempHeight )
          {
            tempWidth = Math . round ( ( getsh ( ) - deltaHeight ) / tempHeight * tempWidth ) ;
            tempHeight = getsh ( ) - deltaHeight ;
          }
        }
        matrix . scale ( tempWidth / bitmapData . width , tempHeight / bitmapData . height ) ;
        canvas . graphics . clear ( ) ;
        canvas . graphics . beginBitmapFill ( bitmapData , matrix , false , true ) ;
        canvas . graphics . drawRoundRect ( 0 , 0 , tempWidth , tempHeight , radius , radius ) ;
        canvas . graphics . endFill ( ) ;
        if ( frame )
        {
          canvas . x = radius ;
          canvas . y = radius ;
        }
        else
        {
          canvas . x = 0 ;
          canvas . y = 0 ;
          foreground . graphics . clear ( ) ;
          foreground . graphics . beginFill ( 0 , 0 ) ;
          foreground . graphics . drawRoundRect ( 0 , 0 , tempWidth , tempHeight , radius , radius ) ;
          foreground . graphics . endFill ( ) ;
        }
        if ( inSquare )
        {
          if ( getsw ( ) > getsh ( ) )
          {
            canvas . x = int ( ( getsw ( ) - tempWidth ) / 2 ) ;
            canvas . y = 0 ;
            super . setswh ( getsw ( ) , getsw ( ) ) ;
          }
          else
          {
            canvas . x = 0 ;
            canvas . y = int ( ( getsh ( ) - tempHeight ) / 2 ) ;
            super . setswh ( getsh ( ) , getsh ( ) ) ;
          }
        }
        else
        {
          super . setswh ( tempWidth + deltaWidth , tempHeight + deltaHeight ) ;
        }
      }
      if ( frame )
      {
        if ( background == null )
        {
          background = new BaseShape ( application ) ;
          layerBackground . addChild ( background ) ;
          background . setdb ( true ) ;
          background . setdt ( 1 ) ;
          addListeners ( ) ;
        }
        background . setcccac ( application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorDark ( ) , application . getPropsDyn ( ) . getAppBackgroundColorMid ( ) , application . getPropsDyn ( ) . getAppBackgroundColorAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundColorBright ( ) ) ;
        background . setsr ( radius ) ;
        background . setswh ( getsw ( ) , getsh ( ) ) ;
        background . drawRect ( ) ;
        if ( foreground != null )
        {
          foreground . graphics . clear ( ) ;
          foreground . graphics . beginFill ( 0 , 0 ) ;
          foreground . graphics . drawRoundRect ( 0 , 0 , getsw ( ) , getsh ( ) , radius , radius ) ;
          foreground . graphics . endFill ( ) ;
        }
      }
      else
      {
        if ( background != null )
        {
          resetListeners ( ) ;
          layerBackground . removeChild ( background ) ;
          background = null ;
        }
      }
    }
/*
** It can be necessary to copy this image so the bitmapdata is accessible from outside.
*/
    public function getBitmapData ( ) : BitmapData
    {
      return bitmapData ;
    }
/*
** Overriding the setsw setsh and setswh functions.
** With the changing of the size, the repaint is also necessary.
** The resizable property has to be true to be able to do these.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw && resizable )
      {
        super . setsw ( newsw ) ;
        repaintReposImage ( ) ;
      }
    }
    override public function setsh ( newsh : int ) : void
    {
      if ( getsh ( ) != newsh && resizable )
      {
        super . setsh ( newsh ) ;
        repaintReposImage ( ) ;
      }
    }
    override public function setswh ( newsw : int , newsh : int ) : void
    {
      if ( ( getsw ( ) != newsw || getsh ( ) != newsh ) && resizable )
      {
        super . setswh ( newsw , newsh ) ;
        repaintReposImage ( ) ;
      }
    }
/*
** Adds the listeners if necessary (be called)
*/
    private function addListeners ( ) : void
    {
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , resize ) ;
    }
/*
** Resets the listener: no registers for
*/
    private function resetListeners ( ) : void
    {
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_DARK_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_MID_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_COLOR_ALPHA_CHANGED , resize ) ;
    }
/*
** To display fullscreen and go back.
*/
    private function destroyFullscrToFullscrButtonLink ( ) : void
    {
      if ( fullscrButtonLinkToFullscreen != null )
      {
        fullscrButtonLinkToFullscreen . destroy ( ) ;
        if ( layerOthers != null && layerOthers . contains ( fullscrButtonLinkToFullscreen ) )
        {
          layerOthers . removeChild ( fullscrButtonLinkToFullscreen ) ;
        }
        fullscrButtonLinkToFullscreen = null ;
      }
    }
    private function destroyFullscrStageElements ( ) : void
    {
      if ( stage != null )
      {
        if ( fullscrButtonLinkBack != null )
        {
          fullscrButtonLinkBack . destroy ( ) ;
          if ( stage . contains ( fullscrButtonLinkBack ) )
          {
            stage . removeChild ( fullscrButtonLinkBack ) ;
          }
          fullscrButtonLinkBack = null ;
        }
        if ( fullscrStageBackground != null )
        {
          fullscrStageBackground . destroy ( ) ;
          fullscrStageBackground . graphics . clear ( ) ;
          if ( stage . contains ( fullscrStageBackground ) )
          {
            stage . removeChild ( fullscrStageBackground ) ;
          }
          fullscrStageBackground = null ;
        }
        if ( fullscrStageImage != null )
        {
          fullscrStageImage . destroy ( ) ;
          fullscrStageImage . graphics . clear ( ) ;
          if ( stage . contains ( fullscrStageImage ) )
          {
            stage . removeChild ( fullscrStageImage ) ;
          }
          fullscrStageImage = null ;
        }
      }
    }
    private function createFullscrButtonLinkToFullscreen ( ) : void
    {
      if ( fullscrButtonLinkToFullscreen == null )
      {
        fullscrButtonLinkToFullscreen = new ButtonLink ( application ) ;
        layerOthers . addChild ( fullscrButtonLinkToFullscreen ) ;
        fullscrButtonLinkToFullscreen . setIcon ( "maximize" ) ;
        fullscrButtonLinkToFullscreen . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , toFullscreen ) ;
        fullscrButtonLinkToFullscreen . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , fullscrButtonLinkToFullscreenResized ) ;
      }
      reposFullscrButtonLinkToFullscreen ( ) ;
    }
    private function toFullscreen ( e : Event ) : void
    {
      if ( canvas != null && stage != null && layerImage != null )
      {
        fullscrOrigX = canvas . x ;
        fullscrOrigY = canvas . y ;
        fullscrOrigW = canvas . width ;
        fullscrOrigH = canvas . height ;
        if ( fullscrStageBackground == null )
        {
          fullscrStageBackground = new BaseShape ( application ) ;
          stage . addChild ( fullscrStageBackground ) ;
        }
        if ( fullscrStageImage == null )
        {
          fullscrStageImage = new BaseShape ( application ) ;
          stage . addChild ( fullscrStageImage ) ;
        }
        if ( fullscrButtonLinkBack == null )
        {
          fullscrButtonLinkBack = new ButtonLink ( application ) ;
          stage . addChild ( fullscrButtonLinkBack ) ;
          fullscrButtonLinkBack . setIcon ( "minimize" ) ;
          fullscrButtonLinkBack . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , fromFullscreen ) ;
        }
        stage . addEventListener ( Event . RESIZE , stageResized ) ;
        reposImageFullscreen ( ) ;
      }
    }
    private function stageResized ( e : Event ) : void
    {
      reposImageFullscreen ( ) ;
    }
    private function fromFullscreen ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
        destroyFullscrStageElements ( ) ;
      }
    }
    private function reposImageFullscreen ( ) : void
    {
      if ( stage != null )
      {
        if ( fullscrStageBackground != null )
        {
          fullscrStageBackground . graphics . clear ( ) ;
          fullscrStageBackground . graphics . beginFill ( 0x000000 , 1 ) ;
          fullscrStageBackground . graphics . moveTo ( 0 , 0 ) ;
          fullscrStageBackground . graphics . drawRect ( 0 , 0 , stage . stageWidth , stage . stageHeight ) ;
        }
        if ( fullscrStageImage != null && bitmapData != null )
        {
          var matrix : Matrix = new Matrix ( ) ;
          var tempWidth : int = bitmapData . width ;
          var tempHeight : int = bitmapData . height ;
          if ( stage . stageWidth < tempWidth )
          {
            tempHeight = Math . round ( ( stage . stageWidth ) / tempWidth * tempHeight ) ;
            tempWidth = stage . stageWidth ;
          }
          if ( stage . stageHeight < tempHeight )
          {
            tempWidth = Math . round ( ( stage . stageHeight ) / tempHeight * tempWidth ) ;
            tempHeight = stage . stageHeight ;
          }
          matrix . scale ( tempWidth / bitmapData . width , tempHeight / bitmapData . height ) ;
          fullscrStageImage . graphics . clear ( ) ;
          fullscrStageImage . graphics . beginBitmapFill ( bitmapData , matrix , false , true ) ;
          fullscrStageImage . graphics . drawRect ( 0 , 0 , tempWidth , tempHeight ) ;
          fullscrStageImage . graphics . endFill ( ) ;
          fullscrStageImage . x = ( stage . stageWidth - tempWidth ) / 2 ;
          fullscrStageImage . y = ( stage . stageHeight - tempHeight ) / 2 ;
        }
        reposFullscrButtonLinkBack ( ) ;
      }
    }
    private function fullscrButtonLinkToFullscreenResized ( e : Event ) : void
    {
      reposFullscrButtonLinkToFullscreen ( ) ;
    }
    private function reposFullscrButtonLinkToFullscreen ( ) : void
    {
      if ( canvas != null && fullscrButtonLinkToFullscreen != null )
      {
        fullscrButtonLinkToFullscreen . setcxy ( canvas . x + canvas . width - fullscrButtonLinkToFullscreen . getsw ( ) ,
            canvas . y ) ;
      }
    }
    private function reposFullscrButtonLinkBack ( ) : void
    {
      if ( fullscrStageImage != null && fullscrButtonLinkBack != null )
      {
        fullscrButtonLinkBack . setcxy ( fullscrStageImage . x + fullscrStageImage . width - fullscrButtonLinkBack . getsw ( ) ,
            fullscrStageImage . y ) ;
      }
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      resetListeners ( ) ;
      resetImageLoading ( ) ;
      destroyTimer ( ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      bitmapDataDispose ( ) ;
      canvasClear ( ) ;
      if ( eventFileLoaded != null )
      {
        eventFileLoaded . stopImmediatePropagation ( ) ;
      }
      destroyFullscrToFullscrButtonLink ( ) ;
      destroyFullscrStageElements ( ) ;
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      loader = null ;
      urlRequest = null ;
      urlVariables = null ;
      bitmapData = null ;
      matrix = null ;
      serverId = null ;
      sessionId = null ;
      fileUrl = null ;
      tempWidth = 0 ;
      tempHeight = 0 ;
      eventFileLoaded = null ;
      frame = false ;
      canvas = null ;
      background = null ;
      resizable = false ;
      isThumb = false ;
      inSquare = false ;
      layerBackground = null ;
      layerImage = null ;
      layerOthers = null ;
      fullscrButtonLinkToFullscreen = null ;
      fullscrButtonLinkBack = null ;
      fullscrStageBackground = null ;
      fullscrStageImage = null ;
      fullscrOrigX = 0 ;
      fullscrOrigY = 0 ;
      fullscrOrigW = 0 ;
      fullscrOrigH = 0 ;
    }
  }
}
