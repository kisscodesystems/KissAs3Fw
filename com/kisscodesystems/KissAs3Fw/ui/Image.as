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
    private var canvas : BaseShape = null ;
// The background of the mage.
    private var background : BaseShape = null ;
// The image can be resized or not.
    private var resizable : Boolean = true ;
// Thumb version of image is also possible.
    private var isThumb : Boolean = false ;
// Timer object to enable delay.
    private var timer : Timer = null ;
// Has to display the image in a square.
    private var inSquare : Boolean = false ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Image ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// The canvas to paint.
      canvas = new BaseShape ( application ) ;
      addChild ( canvas ) ;
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
    public function setParamsAndLoadImage ( pId : String , sId : String , fUrl : String , delayed : int = 0 , thumb : Boolean = false ) : void
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
    public function clear ( ) : void
    {
      graphics . clear ( ) ;
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
      if ( loader == null && sessionId != null && sessionId != "" && fileUrl != null && fileUrl != "" )
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
      }
      catch ( e : * )
      {
        bitmapData = new BitmapData ( 1 , 1 ) ;
      }
// The loader objects are not necessary any more.
      resetImageLoading ( ) ;
// The image is ready to be painted.
      repaintReposImage ( ) ;
// An event has to be dispatched!
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventFileLoaded ) ;
      }
// Timer has to be stopped.
      destroyTimer ( ) ;
    }
/*
** IOError or SecurityError occurred.
*/
    private function imageLoadFail ( e : * ) : void
    {
      bitmapDataDispose ( ) ;
      bitmapData = new BitmapData ( 1 , 1 ) ;
      resetImageLoading ( ) ;
      repaintReposImage ( ) ;
      destroyTimer ( ) ;
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
      if ( canvas != null )
      {
        canvas . graphics . clear ( ) ;
        if ( bitmapData != null )
        {
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
      }
      if ( frame )
      {
        if ( background == null )
        {
          background = new BaseShape ( application ) ;
          addChild ( background ) ;
          background . setdb ( true ) ;
          background . setdt ( 1 ) ;
          addListeners ( ) ;
        }
        background . setccac ( application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillBgColor ( ) , application . getPropsDyn ( ) . getAppBackgroundFillAlpha ( ) , application . getPropsDyn ( ) . getAppBackgroundFillFgColor ( ) ) ;
        background . setsr ( radius ) ;
        background . setswh ( getsw ( ) , getsh ( ) ) ;
        background . drawRect ( ) ;
      }
      else
      {
        if ( background != null )
        {
          resetListeners ( ) ;
          removeChild ( background ) ;
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
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , resize ) ;
    }
/*
** Resets the listener: no registers for
*/
    private function resetListeners ( ) : void
    {
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_RADIUS_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_BGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_FGCOLOR_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_BACKGROUND_FILL_ALPHA_CHANGED , resize ) ;
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
      if ( eventFileLoaded != null )
      {
        eventFileLoaded . stopImmediatePropagation ( ) ;
      }
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
    }
  }
}
