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
 * Image.
 * One picture loaded from the outside world and displayed inside a given box.
 *
 * MAIN FEATURES:
 * - the picture arrives from an url, with the variables of a post request when the
 *   server it comes from asks for them, and the loading can be delayed
 * - a bitmap data the application already holds can be given to it as well, so an
 *   embedded resource or a photo of a camera is displayed without a loading at all
 * - the loading tells the outside that it is over by one single event, whatever the
 *   result of it has been, so a caller waiting for the picture is never left alone
 * - the box the picture is drawn inside is the dimensions this object is given: a
 *   picture that fits to that box is shrunk into it keeping its own aspect ratio, while
 *   a picture nobody has given a box to is drawn in the dimensions it has arrived with
 * - the box can be resized by hand as well: the handle of the bottom right corner of
 *   the picture is dragged, and the picture follows that drag in real time
 * - the picture can be placed into the middle of a square, so a list of pictures of
 *   any aspect ratio stands in one and the same grid
 * - a frame of the current appearance of the application can be drawn around it
 * - the picture can be opened in fullscreen, on the top of everything: the opening and
 *   the closing of it are reported by the changed event of the BaseReact base class, so
 *   the one holding this object follows the button standing on the picture as well
 * - it extends the BaseReact, so emojis can be stuck onto it as soon as the react
 *   feature of it is switched on: the dimensions set here are the dimensions of the
 *   picture itself, the react row is placed under it by that base class
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseReact;
  import com.kisscodesystems.KissAs3Fw.base.BaseResizer;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.Loader;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.TimerEvent;
  import flash.geom.Matrix;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.utils.Timer;
  public class Image extends BaseReact
  {
    // the url the picture is loaded from and the variables posted with the request of
    // it: an empty store means a plain get request without any variable at all
    private var url:String = "";
    private var postNames:Array = null;
    private var postValues:Array = null;
    // the loading itself: the timer of the delay, the loader doing the work and the two
    // states of it the outside world can ask about
    private var loadDelayTimer:Timer = null;
    private var loader:Loader = null;
    private var loading:Boolean = false;
    private var pictureLoaded:Boolean = false;
    // the picture and the shape it is drawn onto
    private var bitmapData:BitmapData = null;
    private var pictureShape:Shape = null;
    // the frame around the picture and the state telling whether it is drawn at all
    private var frameShape:BaseShape = null;
    private var frame:Boolean = false;
    // The box the picture is drawn inside: the dimensions this object has been asked
    // for. The dimensions of this object are the ones of the drawn picture and not the
    // ones of that box, so the box is kept here on its own. A side of zero means that
    // nobody has bounded this object in that direction.
    private var boxDw:int = 0;
    private var boxDh:int = 0;
    private var fitToBox:Boolean = true;
    private var inSquare:Boolean = false;
    // the handle the box of the picture is resized by hand with, a null when that
    // feature is switched off
    private var baseResizer:BaseResizer = null;
    // The fullscreen viewer: the button opening it and the three elements it is built
    // of. Those three stand on the stage and not on this object, because a picture of
    // the fullscreen covers the whole application and not the room of this object.
    private var fullscreenEnabled:Boolean = false;
    private var fullscreenButtonLink:ButtonLink = null;
    private var fullscreenBackShape:Shape = null;
    private var fullscreenPictureShape:Shape = null;
    private var fullscreenCloseButtonLink:ButtonLink = null;
    private var eventFileLoaded:Event = null;
    /**
     * Constructs the Image object: creates the frame and the surface the picture is
     * drawn onto, and starts to follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function Image(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Image> called.", 1);
      application.trace("<" + this + " Image> applicationRef: " + applicationRef, 0);
      postNames = new Array();
      postValues = new Array();
      eventFileLoaded = new Event(EnumEvents.EVENT_FILE_LOADED());
      frameShape = new BaseShape(application);
      addChild(frameShape);
      frameShape.setIsBright(true);
      frameShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      frameShape.visible = false;
      pictureShape = new Shape();
      addChild(pictureShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), appearanceChanged);
      application.trace("<" + this + " Image> constructed.", 1);
    }
    /**
     * Returns the url the picture of this object has been asked for from, an empty
     * string when nothing has been asked for yet.
     */
    public function getUrl():String
    {
      return url;
    }
    /**
     * Returns the number of the variables posted with the request of the loading.
     */
    public function getNumOfPostData():int
    {
      return postNames.length;
    }
    /**
     * Takes the variables of the post request of the loading. A server asking for a
     * session or for the identifier of a file is talked to this way, and an object
     * carrying no variable at all sends a plain get request instead. The two arrays are
     * copied, so the caller can keep using its own ones.
     * @param names the names of the variables
     * @param values the values of the variables, in the order of the names
     */
    public function setPostData(names:Array, values:Array):void
    {
      application.trace("<" + this + " Image setPostData> called.", 1);
      application.trace("<" + this + " Image setPostData> names: " + names, 0);
      application.trace("<" + this + " Image setPostData> values: " + values, 0);
      postNames.splice(0);
      postValues.splice(0);
      if (names == null || values == null || names.length != values.length)
      {
        application.trace("<" + this + " Image setPostData> the names and the values do not belong together!", 6);
        return;
      }
      postNames = postNames.concat(names);
      postValues = postValues.concat(values);
    }
    /**
     * Loads the picture of the given url into this object. A loading that is still
     * running is dropped first, so the picture that arrives is always the one of the
     * last call. The delay is the time this object waits before it starts: a list of
     * pictures asks for its items one after the other this way, instead of starting
     * every one of them at the very same moment.
     * @param newUrl the url the picture has to be loaded from
     * @param delay the milliseconds the loading has to be started after
     */
    public function loadUrl(newUrl:String, delay:int = 0):void
    {
      application.trace("<" + this + " Image loadUrl> called.", 1);
      application.trace("<" + this + " Image loadUrl> newUrl: " + newUrl, 0);
      application.trace("<" + this + " Image loadUrl> delay: " + delay, 0);
      dropLoadDelayTimer();
      dropLoader();
      url = newUrl == null ? "" : newUrl;
      if (url == "")
      {
        application.trace("<" + this + " Image loadUrl> there is no url to load from!", 6);
        return;
      }
      loading = true;
      if (delay > 0)
      {
        loadDelayTimer = new Timer(delay, 1);
        loadDelayTimer.addEventListener(TimerEvent.TIMER, loadDelayTimerHandler);
        loadDelayTimer.start();
        return;
      }
      startLoading();
    }
    /**
     * Tells whether this object is loading a picture at the moment. The delay before a
     * loading counts as a loading as well: the picture of it is on its way.
     */
    public function isLoading():Boolean
    {
      return loading;
    }
    /**
     * Tells whether there is a picture in this object at the moment. A loading that has
     * failed leaves nothing behind, so this answers false after it.
     */
    public function isPictureLoaded():Boolean
    {
      return pictureLoaded;
    }
    /**
     * Returns the bitmap data of the picture of this object, a null one when there is no
     * picture in it at all.
     */
    public function getBitmapData():BitmapData
    {
      return bitmapData;
    }
    /**
     * Takes the given bitmap data as the picture of this object: an embedded resource, a
     * photo of a camera or anything else the application around it already holds is
     * displayed this way, without a loading at all. A loading that is still running is
     * dropped and the url is cleared, because the picture does not come from there any
     * more. The bitmap data is copied, so the caller keeps the ownership of its own one.
     * @param newBitmapData the picture to be displayed, a null one drops the picture
     */
    public function setBitmapData(newBitmapData:BitmapData):void
    {
      application.trace("<" + this + " Image setBitmapData> called.", 1);
      application.trace("<" + this + " Image setBitmapData> newBitmapData: " + newBitmapData, 0);
      dropLoadDelayTimer();
      dropLoader();
      dropPicture();
      loading = false;
      url = "";
      if (newBitmapData == null)
      {
        application.trace("<" + this + " Image setBitmapData> there is no picture to be displayed.", 1);
        closeFullscreen();
        dropFullscreenButtonLink();
        redrawEverything();
        dispatchEventFileLoaded();
        return;
      }
      bitmapData = newBitmapData.clone();
      pictureLoaded = true;
      if (fullscreenEnabled)
      {
        createFullscreenButtonLink();
      }
      redrawEverything();
      dispatchEventFileLoaded();
    }
    /**
     * Returns the width of the picture of this object, the original one it has arrived
     * from the outside world with.
     */
    public function getBitmapDw():int
    {
      return bitmapData == null ? 0 : bitmapData.width;
    }
    /**
     * Returns the height of the picture of this object, the original one it has arrived
     * from the outside world with.
     */
    public function getBitmapDh():int
    {
      return bitmapData == null ? 0 : bitmapData.height;
    }
    /**
     * Drops the picture of this object: the loading of it, the bitmap data and the
     * drawing as well, and it tells the outside that the content has changed. The url is
     * kept, so the very same picture can be asked for again.
     */
    public function clear():void
    {
      application.trace("<" + this + " Image clear> called.", 1);
      dropLoadDelayTimer();
      loading = false;
      dropLoader();
      dropPicture();
      closeFullscreen();
      dropFullscreenButtonLink();
      redrawEverything();
      dispatchEventFileLoaded();
    }
    /**
     * Tells whether there is a frame around the picture of this object.
     */
    public function getFrame():Boolean
    {
      return frame;
    }
    /**
     * Draws a frame of the current appearance of the application around the picture of
     * this object, or takes that frame away. A framed picture stands inside that frame,
     * so it is given one radius of the application less on every side.
     * @param b true when there has to be a frame
     */
    public function setFrame(b:Boolean):void
    {
      application.trace("<" + this + " Image setFrame> called.", 1);
      application.trace("<" + this + " Image setFrame> b: " + b, 0);
      if (frame != b)
      {
        application.trace("<" + this + " Image setFrame> conditions OK.", 1);
        frame = b;
        redrawEverything();
      }
    }
    /**
     * Tells whether the picture of this object is shrunk into the box it is given.
     */
    public function getFitToBox():Boolean
    {
      return fitToBox;
    }
    /**
     * Tells this object whether the picture of it has to be shrunk into the box it is
     * given. A picture that does not fit to that box is drawn in the dimensions it has
     * arrived with, whatever that box is.
     * @param b true when the picture has to be shrunk into the box
     */
    public function setFitToBox(b:Boolean):void
    {
      application.trace("<" + this + " Image setFitToBox> called.", 1);
      application.trace("<" + this + " Image setFitToBox> b: " + b, 0);
      if (fitToBox != b)
      {
        application.trace("<" + this + " Image setFitToBox> conditions OK.", 1);
        fitToBox = b;
        redrawEverything();
      }
    }
    /**
     * Tells whether the box of the picture of this object can be resized by hand.
     */
    public function getResizable():Boolean
    {
      return baseResizer != null;
    }
    /**
     * Tells this object whether the box of the picture of it can be resized by hand. The
     * handle of that resizing stands in the bottom right corner of the picture, and the
     * box follows every pixel of a drag of it, so the picture is shrunk into the new box
     * in real time, exactly the way a box coming from the outside does it.
     * @param b true when there has to be a handle to resize the box with
     */
    public function setResizable(b:Boolean):void
    {
      application.trace("<" + this + " Image setResizable> called.", 1);
      application.trace("<" + this + " Image setResizable> b: " + b, 0);
      if (b)
      {
        createResizer();
      }
      else
      {
        removeResizer();
      }
    }
    /**
     * Tells whether the picture of this object stands in the middle of a square.
     */
    public function getInSquare():Boolean
    {
      return inSquare;
    }
    /**
     * Tells this object whether the picture of it has to be placed into the middle of a
     * square. The side of that square is the greater side of the picture, so a list of
     * pictures of any aspect ratio stands in one and the same grid.
     * @param b true when the picture has to stand in the middle of a square
     */
    public function setInSquare(b:Boolean):void
    {
      application.trace("<" + this + " Image setInSquare> called.", 1);
      application.trace("<" + this + " Image setInSquare> b: " + b, 0);
      if (inSquare != b)
      {
        application.trace("<" + this + " Image setInSquare> conditions OK.", 1);
        inSquare = b;
        redrawEverything();
      }
    }
    /**
     * Returns the width of the box the picture of this object is drawn inside, a zero
     * when nobody has bounded this object in that direction.
     */
    public function getBoxDw():int
    {
      return boxDw;
    }
    /**
     * Returns the height of the box the picture of this object is drawn inside, a zero
     * when nobody has bounded this object in that direction.
     */
    public function getBoxDh():int
    {
      return boxDh;
    }
    /**
     * Tells whether the picture of this object can be opened in fullscreen.
     */
    public function getFullscreenEnabled():Boolean
    {
      return fullscreenEnabled;
    }
    /**
     * Tells this object whether the picture of it can be opened in fullscreen. The
     * button opening it stands in the top right corner of the picture, so it appears as
     * soon as there is a picture at all, and an opened fullscreen is closed by the
     * switching off of the feature itself.
     * @param b true when the picture can be opened in fullscreen
     */
    public function setFullscreenEnabled(b:Boolean):void
    {
      application.trace("<" + this + " Image setFullscreenEnabled> called.", 1);
      application.trace("<" + this + " Image setFullscreenEnabled> b: " + b, 0);
      if (fullscreenEnabled == b)
      {
        application.trace("<" + this + " Image setFullscreenEnabled> nothing to do.", 1);
        return;
      }
      fullscreenEnabled = b;
      if (fullscreenEnabled)
      {
        if (pictureLoaded)
        {
          createFullscreenButtonLink();
        }
      }
      else
      {
        closeFullscreen();
        dropFullscreenButtonLink();
      }
      reposFullscreenButtonLink();
    }
    /**
     * Tells whether the picture of this object is opened in fullscreen at the moment.
     */
    public function isFullscreenOpened():Boolean
    {
      return fullscreenBackShape != null;
    }
    /**
     * Opens the picture of this object in fullscreen and tells the outside about it: it is
     * drawn onto the middle of a black surface covering the whole stage, in the greatest
     * dimensions it fits that stage in. An object that holds no picture, that is not on
     * the stage or whose fullscreen feature is switched off has nothing to open.
     */
    public function openFullscreen():void
    {
      application.trace("<" + this + " Image openFullscreen> called.", 1);
      if (!fullscreenEnabled || !pictureLoaded || stage == null)
      {
        application.trace("<" + this + " Image openFullscreen> there is nothing to be opened in fullscreen.", 1);
        return;
      }
      if (isFullscreenOpened())
      {
        application.trace("<" + this + " Image openFullscreen> the fullscreen is opened already.", 1);
        return;
      }
      fullscreenBackShape = new Shape();
      stage.addChild(fullscreenBackShape);
      fullscreenPictureShape = new Shape();
      stage.addChild(fullscreenPictureShape);
      fullscreenCloseButtonLink = new ButtonLink(application);
      stage.addChild(fullscreenCloseButtonLink);
      fullscreenCloseButtonLink.setIcon(EnumIcons.minimize());
      fullscreenCloseButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), fullscreenCloseButtonLinkClicked);
      stage.addEventListener(Event.RESIZE, stageResized);
      redrawFullscreen();
      dispatchEventChanged();
    }
    /**
     * Closes the fullscreen of the picture of this object, frees up every element of it
     * and tells the outside about it. A fullscreen that is not opened at all has nothing
     * to close, so nothing is reported there either.
     */
    public function closeFullscreen():void
    {
      application.trace("<" + this + " Image closeFullscreen> called.", 1);
      const wasOpened:Boolean = isFullscreenOpened();
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
      }
      if (fullscreenCloseButtonLink != null)
      {
        // the button follows the appearance of the application on listeners of its own,
        // so it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application
        fullscreenCloseButtonLink.destroy();
        removeFromStage(fullscreenCloseButtonLink);
        fullscreenCloseButtonLink = null;
      }
      if (fullscreenPictureShape != null)
      {
        fullscreenPictureShape.graphics.clear();
        removeFromStage(fullscreenPictureShape);
        fullscreenPictureShape = null;
      }
      if (fullscreenBackShape != null)
      {
        fullscreenBackShape.graphics.clear();
        removeFromStage(fullscreenBackShape);
        fullscreenBackShape = null;
      }
      if (wasOpened)
      {
        dispatchEventChanged();
      }
    }
    /**
     * Enables or disables this object, and the button opening the fullscreen of the
     * picture and the handle of the resizing follow that state as well, so a disabled
     * object holds nothing that could be clicked or dragged at all.
     * @param e true when this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Image setEnabled> called.", 1);
      application.trace("<" + this + " Image setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (fullscreenButtonLink != null)
      {
        fullscreenButtonLink.setEnabled(getEnabled());
      }
      if (baseResizer != null)
      {
        baseResizer.setEnabled(getEnabled());
      }
      closeFullscreen();
    }
    /**
     * Sets the width of the box the picture of this object is drawn inside. The width of
     * this object itself is the one of that picture, so a box wider than the picture
     * leaves this object as narrow as it has been.
     * @param newdw the new width of the box
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Image setDw> called.", 1);
      application.trace("<" + this + " Image setDw> newdw: " + newdw, 0);
      if (boxDw != newdw)
      {
        application.trace("<" + this + " Image setDw> conditions OK.", 1);
        boxDw = newdw;
        redrawEverything();
      }
    }
    /**
     * Sets the height of the box the picture of this object is drawn inside, see the
     * setDw above.
     * @param newdh the new height of the box
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Image setDh> called.", 1);
      application.trace("<" + this + " Image setDh> newdh: " + newdh, 0);
      if (boxDh != newdh)
      {
        application.trace("<" + this + " Image setDh> conditions OK.", 1);
        boxDh = newdh;
        redrawEverything();
      }
    }
    /**
     * Sets the dimensions of the box the picture of this object is drawn inside, see the
     * setDw above.
     * @param newdw the new width of the box
     * @param newdh the new height of the box
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Image setDwh> called.", 1);
      application.trace("<" + this + " Image setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Image setDwh> newdh: " + newdh, 0);
      if (boxDw != newdw || boxDh != newdh)
      {
        application.trace("<" + this + " Image setDwh> conditions OK.", 1);
        boxDw = newdw;
        boxDh = newdh;
        redrawEverything();
      }
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Image addedToStage> called.", 1);
      application.trace("<" + this + " Image addedToStage> e: " + e, 0);
      super.addedToStage(e);
      redrawEverything();
    }
    /**
     * Closes the fullscreen of this object as soon as it leaves the stage, so that the
     * elements of that fullscreen are taken off the stage while it is still reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Image removedFromStage> called.", 1);
      application.trace("<" + this + " Image removedFromStage> e: " + e, 0);
      closeFullscreen();
      super.removedFromStage(e);
    }
    /**
     * Starts the loading as soon as the delay of it is over.
     * @param e the timer event of the timer of that delay
     */
    private function loadDelayTimerHandler(e:TimerEvent):void
    {
      application.trace("<" + this + " Image loadDelayTimerHandler> called.", 1);
      application.trace("<" + this + " Image loadDelayTimerHandler> e: " + e, 0);
      dropLoadDelayTimer();
      startLoading();
    }
    /**
     * Stops and frees up the timer of the delay of the loading.
     */
    private function dropLoadDelayTimer():void
    {
      application.trace("<" + this + " Image dropLoadDelayTimer> called.", 1);
      if (loadDelayTimer != null)
      {
        loadDelayTimer.stop();
        loadDelayTimer.removeEventListener(TimerEvent.TIMER, loadDelayTimerHandler);
        loadDelayTimer = null;
      }
    }
    /**
     * Sends the request of the picture: a post request when there are variables to be
     * sent with it and a plain get request otherwise.
     */
    private function startLoading():void
    {
      application.trace("<" + this + " Image startLoading> called.", 1);
      const urlRequest:URLRequest = new URLRequest(url);
      if (postNames.length > 0)
      {
        const urlVariables:URLVariables = new URLVariables();
        for (var i:int = 0; i < postNames.length; i++)
        {
          urlVariables[String(postNames[i])] = postValues[i];
        }
        urlRequest.data = urlVariables;
        urlRequest.method = URLRequestMethod.POST;
      }
      loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSucceeded, false, 0, true);
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailed, false, 0, true);
      loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailed, false, 0, true);
      try
      {
        loader.load(urlRequest);
      }
      catch (error:*)
      {
        application.trace("<" + this + " Image startLoading> the request of the picture could not be sent: " + error, 7);
        loadFailed(null);
      }
    }
    /**
     * Takes the picture that has arrived, draws it and tells the outside that the loading
     * is over. A picture that can not be drawn at all leaves this object empty, the way
     * a failed loading does.
     * @param e the complete event of the loader
     */
    private function loadSucceeded(e:Event):void
    {
      application.trace("<" + this + " Image loadSucceeded> called.", 1);
      application.trace("<" + this + " Image loadSucceeded> e: " + e, 0);
      dropPicture();
      try
      {
        bitmapData = new BitmapData(loader.content.width, loader.content.height);
        bitmapData.draw(loader.content);
        pictureLoaded = true;
      }
      catch (error:*)
      {
        application.trace("<" + this + " Image loadSucceeded> the picture could not be drawn: " + error, 7);
        dropPicture();
      }
      loading = false;
      dropLoader();
      if (pictureLoaded && fullscreenEnabled)
      {
        createFullscreenButtonLink();
      }
      redrawEverything();
      dispatchEventFileLoaded();
    }
    /**
     * Leaves this object empty after a loading that has failed and tells the outside that
     * the loading is over: the caller waiting for the picture is told that it does not
     * arrive at all.
     * @param e the error event of the loader, null when the request could not be sent
     */
    private function loadFailed(e:Event):void
    {
      application.trace("<" + this + " Image loadFailed> called.", 1);
      application.trace("<" + this + " Image loadFailed> e: " + e, 0);
      application.trace("<" + this + " Image loadFailed> the picture of this url could not be loaded: " + url, 6);
      // an error of the loader means that the loading is over already, so there is no
      // stream left to be closed by the drop below
      loading = false;
      dropLoader();
      dropPicture();
      closeFullscreen();
      dropFullscreenButtonLink();
      redrawEverything();
      dispatchEventFileLoaded();
    }
    /**
     * Stops and frees up the loader of the picture.
     */
    private function dropLoader():void
    {
      application.trace("<" + this + " Image dropLoader> called.", 1);
      if (loader != null)
      {
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadSucceeded);
        loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadFailed);
        loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailed);
        // a loading that is over holds no stream at all, and the closing of such a loader
        // throws, so only a loading that is still running is stopped here
        if (loading)
        {
          try
          {
            loader.close();
          }
          catch (error:*)
          {
            application.trace("<" + this + " Image dropLoader> there was no loading to be stopped: " + error, 7);
          }
        }
        loader = null;
      }
    }
    /**
     * Frees up the picture of this object: the bitmap data of it is disposed and this
     * object holds nothing from that moment on.
     */
    private function dropPicture():void
    {
      application.trace("<" + this + " Image dropPicture> called.", 1);
      if (bitmapData != null)
      {
        bitmapData.dispose();
        bitmapData = null;
      }
      pictureLoaded = false;
    }
    /**
     * Returns the room the picture can be drawn inside in the given direction: the side
     * of the box without the frame around it. A side of the box nobody has bounded gives
     * the picture the whole room it needs.
     * @param boxSide the side of the box, a zero when it is not bounded at all
     * @param pictureSide the side of the picture itself
     */
    private function getRoom(boxSide:int, pictureSide:int):int
    {
      application.trace("<" + this + " Image getRoom> called.", 1);
      application.trace("<" + this + " Image getRoom> boxSide: " + boxSide, 0);
      application.trace("<" + this + " Image getRoom> pictureSide: " + pictureSide, 0);
      if (boxSide < 1)
      {
        return pictureSide;
      }
      return Math.max(0, boxSide - 2 * getFrameDelta());
    }
    /**
     * Returns the width the picture is drawn with: the original width of it, shrunk into
     * the box of this object when that is asked for. The picture keeps its own aspect
     * ratio, so the side that does not fit that box is the one both sides come from.
     */
    private function getPictureDw():int
    {
      application.trace("<" + this + " Image getPictureDw> called.", 1);
      const bitmapDw:int = getBitmapDw();
      const bitmapDh:int = getBitmapDh();
      if (!fitToBox || bitmapDw < 1 || bitmapDh < 1)
      {
        return bitmapDw;
      }
      return Math.max(0, Math.min(bitmapDw, Math.min(getRoom(boxDw, bitmapDw)
          , int(getRoom(boxDh, bitmapDh) * bitmapDw / bitmapDh))));
    }
    /**
     * Returns the height the picture is drawn with, see the getPictureDw above.
     */
    private function getPictureDh():int
    {
      application.trace("<" + this + " Image getPictureDh> called.", 1);
      const bitmapDw:int = getBitmapDw();
      const bitmapDh:int = getBitmapDh();
      if (!fitToBox || bitmapDw < 1 || bitmapDh < 1)
      {
        return bitmapDh;
      }
      return int(getPictureDw() * bitmapDh / bitmapDw);
    }
    /**
     * Returns the room the frame takes on one side of the picture: one radius of the
     * application when there is a frame at all.
     */
    private function getFrameDelta():int
    {
      return frame ? application.getDynamicsConfig().getAppRadius() : 0;
    }
    /**
     * Draws the picture and the frame around it, places the button of the fullscreen and
     * takes the dimensions of this object from all of them. A picture standing in a
     * square is placed into the middle of that square, so the room around it belongs to
     * this object as well.
     */
    private function redrawEverything():void
    {
      application.trace("<" + this + " Image redrawEverything> called.", 1);
      const radius:int = application.getDynamicsConfig().getAppRadius();
      const frameDelta:int = getFrameDelta();
      const pictureDw:int = getPictureDw();
      const pictureDh:int = getPictureDh();
      var objectDw:int = pictureDw + 2 * frameDelta;
      var objectDh:int = pictureDh + 2 * frameDelta;
      if (inSquare)
      {
        const side:int = Math.max(objectDw, objectDh);
        objectDw = side;
        objectDh = side;
      }
      pictureShape.graphics.clear();
      if (bitmapData != null && pictureDw > 0 && pictureDh > 0)
      {
        const matrix:Matrix = new Matrix();
        matrix.scale(pictureDw / bitmapData.width, pictureDh / bitmapData.height);
        pictureShape.graphics.beginBitmapFill(bitmapData, matrix, false, true);
        pictureShape.graphics.drawRoundRect(0, 0, pictureDw, pictureDh, radius, radius);
        pictureShape.graphics.endFill();
      }
      pictureShape.x = int((objectDw - pictureDw) / 2);
      pictureShape.y = int((objectDh - pictureDh) / 2);
      frameShape.visible = frame;
      if (frame)
      {
        frameShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorBright()
            , application.getDynamicsConfig().getAppBackgroundColorMid()
            , application.getDynamicsConfig().getAppBackgroundColorDark()
            , application.getDynamicsConfig().getAppBackgroundColorAlpha()
            , application.getDynamicsConfig().getAppBackgroundColorBright());
        frameShape.setRadius(radius);
        frameShape.setDwh(objectDw, objectDh);
        frameShape.drawRect();
      }
      // these are the dimensions of the content: the react row and the picker of the base
      // class are placed under them
      super.setDwh(objectDw, objectDh);
      reposResizer();
      reposFullscreenButtonLink();
      redrawFullscreen();
    }
    /**
     * Creates the handle the box of the picture is resized by hand with and places it
     * into the corner of that picture.
     */
    private function createResizer():void
    {
      application.trace("<" + this + " Image createResizer> called.", 1);
      if (baseResizer != null)
      {
        application.trace("<" + this + " Image createResizer> there is a handle already.", 1);
        return;
      }
      baseResizer = new BaseResizer(application);
      addChild(baseResizer);
      baseResizer.setEnabled(getEnabled());
      baseResizer.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), resizerChanged);
      baseResizer.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resizerResized);
      reposResizer();
    }
    /**
     * Frees up the handle the box of the picture is resized by hand with.
     */
    private function removeResizer():void
    {
      application.trace("<" + this + " Image removeResizer> called.", 1);
      if (baseResizer != null)
      {
        // the handle follows the appearance of the application on listeners of its own,
        // so it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application
        baseResizer.destroy();
        if (contains(baseResizer))
        {
          removeChild(baseResizer);
        }
        baseResizer = null;
      }
    }
    /**
     * Places the handle of the resizing into the bottom right corner of the picture and
     * tells it the box a drag of it has to start from. A box nobody has bounded is the
     * picture itself, so the drag starts from the dimensions the picture is drawn with.
     */
    private function reposResizer():void
    {
      application.trace("<" + this + " Image reposResizer> called.", 1);
      if (baseResizer != null)
      {
        baseResizer.setDimensions(boxDw > 0 ? boxDw : getContentDw()
            , boxDh > 0 ? boxDh : getContentDh());
        baseResizer.setCornerDimensions(getContentDw(), getContentDh());
      }
    }
    /**
     * Takes the box of the picture from the drag of the handle of the resizing.
     * @param e the changed event of that handle
     */
    private function resizerChanged(e:Event):void
    {
      application.trace("<" + this + " Image resizerChanged> called.", 1);
      application.trace("<" + this + " Image resizerChanged> e: " + e, 0);
      setDwh(baseResizer.getDimensionDw(), baseResizer.getDimensionDh());
    }
    /**
     * Places the handle of the resizing again after it has taken new dimensions: a new
     * font size gives it another size.
     * @param e the dimensions changed event of that handle
     */
    private function resizerResized(e:Event):void
    {
      application.trace("<" + this + " Image resizerResized> called.", 1);
      application.trace("<" + this + " Image resizerResized> e: " + e, 0);
      reposResizer();
    }
    /**
     * Creates the button opening the fullscreen of the picture. There is nothing to be
     * opened in fullscreen until a picture has arrived, so this is called by the loading
     * as well and not by the switching on of the feature only.
     */
    private function createFullscreenButtonLink():void
    {
      application.trace("<" + this + " Image createFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        application.trace("<" + this + " Image createFullscreenButtonLink> there is a button already.", 1);
        return;
      }
      fullscreenButtonLink = new ButtonLink(application);
      addChild(fullscreenButtonLink);
      fullscreenButtonLink.setIcon(EnumIcons.maximize());
      fullscreenButtonLink.setEnabled(getEnabled());
      fullscreenButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), fullscreenButtonLinkClicked);
      fullscreenButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), fullscreenButtonLinkResized);
    }
    /**
     * Frees up the button opening the fullscreen of the picture.
     */
    private function dropFullscreenButtonLink():void
    {
      application.trace("<" + this + " Image dropFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        // the button follows the appearance of the application on listeners of its own,
        // so it has to be destroyed and not only dropped: a dropped one would be held by
        // those listeners for the whole life of the application
        fullscreenButtonLink.destroy();
        if (contains(fullscreenButtonLink))
        {
          removeChild(fullscreenButtonLink);
        }
        fullscreenButtonLink = null;
      }
    }
    /**
     * Places the button of the fullscreen into the top right corner of the picture.
     */
    private function reposFullscreenButtonLink():void
    {
      application.trace("<" + this + " Image reposFullscreenButtonLink> called.", 1);
      if (fullscreenButtonLink != null)
      {
        fullscreenButtonLink.setCxy(pictureShape.x + getPictureDw() - fullscreenButtonLink.getDw()
            , pictureShape.y);
      }
    }
    /**
     * Places the button of the fullscreen again after it has taken new dimensions: a new
     * font size gives it another width.
     * @param e the dimensions changed event of that button
     */
    private function fullscreenButtonLinkResized(e:Event):void
    {
      application.trace("<" + this + " Image fullscreenButtonLinkResized> called.", 1);
      application.trace("<" + this + " Image fullscreenButtonLinkResized> e: " + e, 0);
      reposFullscreenButtonLink();
    }
    /**
     * Opens the picture in fullscreen on a click on the button of it.
     * @param e the click event of that button
     */
    private function fullscreenButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Image fullscreenButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Image fullscreenButtonLinkClicked> e: " + e, 0);
      openFullscreen();
    }
    /**
     * Closes the fullscreen of the picture on a click on the button of it.
     * @param e the click event of that button
     */
    private function fullscreenCloseButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " Image fullscreenCloseButtonLinkClicked> called.", 1);
      application.trace("<" + this + " Image fullscreenCloseButtonLinkClicked> e: " + e, 0);
      closeFullscreen();
    }
    /**
     * Draws the fullscreen of the picture again after the stage has been resized: the
     * picture of it fills that stage, so it takes other dimensions with it.
     * @param e the resize event of the stage
     */
    private function stageResized(e:Event):void
    {
      application.trace("<" + this + " Image stageResized> called.", 1);
      application.trace("<" + this + " Image stageResized> e: " + e, 0);
      redrawFullscreen();
    }
    /**
     * Draws the fullscreen of the picture: the black surface covering the whole stage,
     * the picture in the middle of it in the greatest dimensions it fits that stage in,
     * and the button closing it in the top right corner of that picture. A fullscreen
     * that is not opened at all has nothing to be drawn.
     */
    private function redrawFullscreen():void
    {
      application.trace("<" + this + " Image redrawFullscreen> called.", 1);
      if (!isFullscreenOpened() || stage == null || bitmapData == null)
      {
        application.trace("<" + this + " Image redrawFullscreen> there is no fullscreen to be drawn.", 1);
        return;
      }
      const stageDw:int = stage.stageWidth;
      const stageDh:int = stage.stageHeight;
      fullscreenBackShape.graphics.clear();
      fullscreenBackShape.graphics.beginFill(0x000000, 1);
      fullscreenBackShape.graphics.drawRect(0, 0, stageDw, stageDh);
      fullscreenBackShape.graphics.endFill();
      // the picture keeps its own aspect ratio here as well, so the side that does not
      // fit the stage is the one both sides come from
      const pictureDw:int = Math.max(1, Math.min(bitmapData.width, Math.min(stageDw
          , int(stageDh * bitmapData.width / bitmapData.height))));
      const pictureDh:int = Math.max(1, int(pictureDw * bitmapData.height / bitmapData.width));
      const matrix:Matrix = new Matrix();
      matrix.scale(pictureDw / bitmapData.width, pictureDh / bitmapData.height);
      fullscreenPictureShape.graphics.clear();
      fullscreenPictureShape.graphics.beginBitmapFill(bitmapData, matrix, false, true);
      fullscreenPictureShape.graphics.drawRect(0, 0, pictureDw, pictureDh);
      fullscreenPictureShape.graphics.endFill();
      fullscreenPictureShape.x = int((stageDw - pictureDw) / 2);
      fullscreenPictureShape.y = int((stageDh - pictureDh) / 2);
      fullscreenCloseButtonLink.setCxy(fullscreenPictureShape.x + pictureDw - fullscreenCloseButtonLink.getDw()
          , fullscreenPictureShape.y);
    }
    /**
     * Takes the given element of the fullscreen off the stage.
     * @param displayObject the element to be taken off
     */
    private function removeFromStage(displayObject:DisplayObject):void
    {
      application.trace("<" + this + " Image removeFromStage> called.", 1);
      application.trace("<" + this + " Image removeFromStage> displayObject: " + displayObject, 0);
      if (stage != null && stage.contains(displayObject))
      {
        stage.removeChild(displayObject);
      }
    }
    /**
     * Draws everything again after the appearance of the application has been changed:
     * the frame and the picture take the radius and the colors of that appearance.
     * @param e the radius or background color changed event of the application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " Image appearanceChanged> called.", 1);
      application.trace("<" + this + " Image appearanceChanged> e: " + e, 0);
      redrawEverything();
    }
    /**
     * Dispatches the file loaded event of this object: the loading is over, whatever the
     * result of it has been.
     */
    private function dispatchEventFileLoaded():void
    {
      application.trace("<" + this + " Image dispatchEventFileLoaded> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventFileLoaded);
    }
    /**
     * Frees the loading, the picture, the fullscreen and every reference held by this
     * object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Image destroy> called.", 1);
      application.trace("<" + this + " Image destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), appearanceChanged);
      application.trace("<" + this + " Image destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      dropLoadDelayTimer();
      dropLoader();
      closeFullscreen();
      eventFileLoaded.stopImmediatePropagation();
      dropPicture();
      pictureShape.graphics.clear();
      postNames.splice(0);
      postValues.splice(0);
      application.trace("<" + this + " Image destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      url = null;
      postNames = null;
      postValues = null;
      loadDelayTimer = null;
      loader = null;
      loading = false;
      pictureLoaded = false;
      bitmapData = null;
      pictureShape = null;
      frameShape = null;
      frame = false;
      boxDw = 0;
      boxDh = 0;
      fitToBox = false;
      inSquare = false;
      baseResizer = null;
      fullscreenEnabled = false;
      fullscreenButtonLink = null;
      fullscreenBackShape = null;
      fullscreenPictureShape = null;
      fullscreenCloseButtonLink = null;
      eventFileLoaded = null;
    }
  }
}
