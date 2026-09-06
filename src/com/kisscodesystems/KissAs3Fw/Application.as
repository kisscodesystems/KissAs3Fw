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
 * Application.
 * The root object of every application built on this framework. Every other object
 * of it holds a reference to this one and reaches everything through it.
 *
 * MAIN FEATURES:
 * - it builds every configuration and every manager of the framework, and the
 *   extenders of it replace any one of those with their own by overriding the
 *   initialize method belonging to it
 * - it is the sink of the tracing: every object of the framework logs into the trace
 *   method of this one, and the tracer displays the collected messages frame by frame
 * - it follows the size of the stage, so every object standing on it can follow that
 * - the three layers of a displayed application are built by the createLayers: the
 *   background, the middleground holding the widgets and the panels, and the
 *   foreground displaying the alerts
 */

package com.kisscodesystems.KissAs3Fw
{
  import com.kisscodesystems.KissAs3Fw.app.Background;
  import com.kisscodesystems.KissAs3Fw.app.Foreground;
  import com.kisscodesystems.KissAs3Fw.app.Middleground;
  import com.kisscodesystems.KissAs3Fw.app.Tracer;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.config.ComponentsConfig;
  import com.kisscodesystems.KissAs3Fw.config.DynamicsConfig;
  import com.kisscodesystems.KissAs3Fw.config.PropertiesConfig;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAppEnvs;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Fw.manager.BackgroundManager;
  import com.kisscodesystems.KissAs3Fw.manager.CacheManager;
  import com.kisscodesystems.KissAs3Fw.manager.ContextMenuManager;
  import com.kisscodesystems.KissAs3Fw.manager.DeviceIdManager;
  import com.kisscodesystems.KissAs3Fw.manager.EmojiManager;
  import com.kisscodesystems.KissAs3Fw.manager.FontManager;
  import com.kisscodesystems.KissAs3Fw.manager.IconManager;
  import com.kisscodesystems.KissAs3Fw.manager.LabelManager;
  import com.kisscodesystems.KissAs3Fw.manager.NetConnectionManager;
  import com.kisscodesystems.KissAs3Fw.manager.ServerManager;
  import com.kisscodesystems.KissAs3Fw.manager.SoundManager;
  import com.kisscodesystems.KissAs3Fw.manager.UrlRequestManager;
  import com.kisscodesystems.KissAs3Fw.manager.WidgetManager;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import com.kisscodesystems.KissAs3Fw.user.User;
  import com.kisscodesystems.KissAs3Fw.util.Utils;
  import flash.display.DisplayObject;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.globalization.DateTimeFormatter;
  import flash.media.Camera;
  import flash.media.Microphone;
  public class Application extends BaseSprite
  {
    /**
     * TRACING LEVELS:
     * 0: framework debug
     * 1: framework info
     * 2: spare
     * 3: application debug
     * 4: application info
     * 5: spare
     * 6: any warning (errors in logic of application)
     * 7: any exception (errors in catch codes)
     * 8: spare
     * 9: no logging
     */
    // The environment this application is running in. A production one traces nothing.
    protected var appEnv:String = EnumAppEnvs.appEnvPrd();
    // The longest message the tracer displays, the longer ones are shortened to this.
    protected var traceMaxLength:int = 1000;
    // The permission of the camera and of the microphone is a device permission, and it
    // is asked for once only: the answer that has been given stands until this
    // application is started again, so asking a second time would change nothing.
    private var askedForCameraPermission:Boolean = false;
    private var askedForMicrophonePermission:Boolean = false;
    // The scroll of the content that is being dragged at the moment. Every parent of a
    // pressed object hands that very same press over as well, so this is the one keeping
    // the drag until the mouse is released: see the scrolling starter below.
    private var scrollingBaseScroll:BaseScroll = null;
    protected var utils:Utils = null;
    protected var propertiesConfig:PropertiesConfig = null;
    protected var componentsConfig:ComponentsConfig = null;
    protected var dynamicsConfig:DynamicsConfig = null;
    protected var backgroundManager:BackgroundManager = null;
    protected var cacheManager:CacheManager = null;
    protected var contextMenuManager:ContextMenuManager = null;
    protected var deviceIdManager:DeviceIdManager = null;
    protected var fontManager:FontManager = null;
    protected var emojiManager:EmojiManager = null;
    protected var iconManager:IconManager = null;
    protected var soundManager:SoundManager = null;
    protected var labelManager:LabelManager = null;
    protected var widgetManager:WidgetManager = null;
    protected var serverManager:ServerManager = null;
    protected var urlRequestManager:UrlRequestManager = null;
    protected var netConnectionManager:NetConnectionManager = null;
    protected var user:User = null;
    // The three layers of the displayed application. They are built by createLayers only,
    // so an application that draws everything on its own never gets any of them.
    protected var background:Background = null;
    protected var middleground:Middleground = null;
    protected var foreground:Foreground = null;
    // The type of the application, it stands in front of the name of it when it is not empty.
    protected var applicationType:String = "";
    // The menu of the application as an xml string, the panel of the menu displays it.
    protected var menuxml:String = "";
    // The number of the messages one single source may display inside one frame. The messages
    // of that source above this number are counted only: see the trace method below.
    private const TRACESPERSOURCE:int = 2;
    // The number of the messages one single frame may display at most, whatever they come from.
    private const MAXTRACESPERFRAME:int = 200;
    // The messages of a sampled source are reported with this in front of them.
    private const SUPPRESSEDMARGIN:String = "   ... ";
    // The font size answered while there is no stage to calculate one of.
    private const FONT_SIZE_WITHOUT_STAGE:int = 20;
    // The master switch of the tracing: when false, no trace reaches the tracer at all.
    private var traceIsEnabled:Boolean = true;
    // The re-entrancy latch of the tracing: true while a trace is being processed.
    // The tracer and its elements are tracing as well, so without this latch the very
    // first trace would recurse endlessly: through the still null tracer while it is
    // being constructed, and later through the textbox and the scroll of the tracer
    // while the message is being appended and scrolled to.
    private var inTrace:Boolean = false;
    private var tracesToDisplay:Array = null;
    private var tracesPerSource:Object = null;
    private var tracesSuppressed:int = 0;
    private var tracer:Tracer = null;
    // The lowest level of the messages to be displayed. Set it through setTraceLevel only:
    // that method keeps the master switch of the tracing above in sync with this level.
    private var traceLevel:int = 9;
    private var dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");
    // The font size calculated of the size of the stage the last time.
    private var lastCalculatedFontSize:int = 0;
    /**
     * Constructs the application: it builds every configuration and every manager of the
     * framework first, and then it asks the extender of this class for the objects of it.
     */
    public function Application():void
    {
      try
      {
        super(this);
        initialize();
        createObjects();
        application.trace("<Application> constructed.", 1);
      }
      catch (e:Error)
      {
        this.trace("<Application> main error: " + e.getStackTrace(), 7);
      }
    }
    /**
     * Returns the helper methods of the framework.
     */
    public function getUtils():Utils
    {
      return utils;
    }
    /**
     * Returns the properties of this application: the name, the version and the like.
     */
    public function getPropertiesConfig():PropertiesConfig
    {
      return propertiesConfig;
    }
    /**
     * Returns the values every component of the framework is built of.
     */
    public function getComponentsConfig():ComponentsConfig
    {
      return componentsConfig;
    }
    /**
     * Returns the displayed properties of this application, the ones that can be changed.
     */
    public function getDynamicsConfig():DynamicsConfig
    {
      return dynamicsConfig;
    }
    /**
     * Returns the manager of the embedded background images.
     */
    public function getBackgroundManager():BackgroundManager
    {
      return backgroundManager;
    }
    /**
     * Returns the manager of the cached files.
     */
    public function getCacheManager():CacheManager
    {
      return cacheManager;
    }
    /**
     * Returns the manager of the context menu.
     */
    public function getContextMenuManager():ContextMenuManager
    {
      return contextMenuManager;
    }
    /**
     * Returns the manager of the identifier of the device this application is running on.
     */
    public function getDeviceIdManager():DeviceIdManager
    {
      return deviceIdManager;
    }
    /**
     * Returns the manager of the embedded fonts.
     */
    public function getFontManager():FontManager
    {
      return fontManager;
    }
    /**
     * Returns the manager of the embedded emojis.
     */
    public function getEmojiManager():EmojiManager
    {
      return emojiManager;
    }
    /**
     * Returns the manager of the embedded icons.
     */
    public function getIconManager():IconManager
    {
      return iconManager;
    }
    /**
     * Returns the manager of the embedded sounds.
     */
    public function getSoundManager():SoundManager
    {
      return soundManager;
    }
    /**
     * Returns the manager of the labels: every displayed text comes from there.
     */
    public function getLabelManager():LabelManager
    {
      return labelManager;
    }
    /**
     * Returns the manager of the widgets.
     */
    public function getWidgetManager():WidgetManager
    {
      return widgetManager;
    }
    /**
     * Returns the manager of the servers of this application.
     */
    public function getServerManager():ServerManager
    {
      return serverManager;
    }
    /**
     * Returns the manager of the url requests.
     */
    public function getUrlRequestManager():UrlRequestManager
    {
      return urlRequestManager;
    }
    /**
     * Returns the manager of the net connection.
     */
    public function getNetConnectionManager():NetConnectionManager
    {
      return netConnectionManager;
    }
    /**
     * Returns the one using this application.
     */
    public function getUser():User
    {
      return user;
    }
    /**
     * Returns the bottom layer of this application, or null when there is none of it.
     */
    public function getBackground():Background
    {
      return background;
    }
    /**
     * Returns the middle layer of this application, or null when there is none of it.
     */
    public function getMiddleground():Middleground
    {
      return middleground;
    }
    /**
     * Returns the top layer of this application, or null when there is none of it.
     */
    public function getForeground():Foreground
    {
      return foreground;
    }
    /**
     * Returns the type of this application: it stands in front of the name of it.
     */
    public function getApplicationType():String
    {
      return applicationType;
    }
    /**
     * Returns the menu of this application as an xml string.
     */
    public function getMenuxml():String
    {
      return menuxml;
    }
    /**
     * Returns the lowest level of the messages to be displayed by the tracer of this application.
     */
    public function getTraceLevel():int
    {
      return traceLevel;
    }
    /**
     * Sets the lowest level of the messages to be displayed by the tracer of this application
     * and turns the tracing itself on or off accordingly. Level nine means no logging at all,
     * so it switches the tracing off and no tracer is created for it at all. See the tracing
     * levels above. Any level out of the range is corrected to the closest allowed one.
     * @param newTraceLevel the lowest level of the messages to be displayed, from zero to nine
     */
    public function setTraceLevel(newTraceLevel:int):void
    {
      application.trace("<Application setTraceLevel> called.", 1);
      application.trace("<Application setTraceLevel> newTraceLevel: " + newTraceLevel, 0);
      const level:int = Math.max(0, Math.min(9, newTraceLevel));
      if (traceLevel != level)
      {
        traceLevel = level;
        traceIsEnabled = traceLevel < 9;
      // The tracer displays the level it is showing the messages of, so it has to hear every change
      // of that level, whoever it comes from: from the buttons of that tracer or from this code.
        getBaseEventDispatcher().dispatchEvent(new Event(EnumEvents.EVENT_TRACE_LEVEL_CHANGED()));
      }
    }
    /**
     * Collects one message for the tracer of this application when that application is not a
     * production one and the level of the message is high enough. The tracing is a tool of the
     * developing and of the testing only: a production application drops every message it is
     * given, whatever level it stands on, and never creates a tracer at all.
     * The message is not displayed right here, only stored, and it is stored only while the
     * source of it has not filled this frame up yet.
     * A single burst of this framework produces thousands of messages inside one frame: one
     * swipe of a scrolled surface logs the same handful of methods hundreds of times, with
     * different coordinates only. Neither a human nor a text field can follow that, so every
     * source is sampled instead: the first messages of it are kept and the rest of them are
     * counted only, and the whole batch is handed over to the tracer on the next frame, see the
     * enterFrameDisplayTraces method below.
     * @param message the message to be displayed
     * @param level the level of that message, from zero to nine
     */
    public function trace(message:Object, level:int = 0):void
    {
      // The environment of the application decides this before anything else does: a released
      // application traces nothing at all, so it carries no tracer and no message of one.
      if (appEnv == EnumAppEnvs.appEnvPrd())
      {
        return;
      }
      if (!traceIsEnabled || inTrace)
      {
        return;
      }
      if (level < 0 || level > 9 || level < traceLevel)
      {
        return;
      }
      // These are created on demand: the super call of this class logs already, and the tracer keeps
      // nothing of this application, so it can be created at any moment, even by the very first
      // message of a failing initialization.
      if (tracesToDisplay == null)
      {
        tracesToDisplay = new Array();
        tracesPerSource = new Object();
      }
      const source:String = sourceOfMessage("" + message);
      const sourceCount:int = int(tracesPerSource[source]) + 1;
      tracesPerSource[source] = sourceCount;
      if (sourceCount <= TRACESPERSOURCE && tracesToDisplay.length < MAXTRACESPERFRAME)
      {
        tracesToDisplay.push(messageToDisplay(message, level));
      }
      else
      {
        tracesSuppressed++;
      }
      // a listener that is registered already is not registered twice by this call
      addEventListener(Event.ENTER_FRAME, enterFrameDisplayTraces);
    }
    /**
     * Brings the tracer of this application in front of everything else. Every object that
     * is added later on covers it, so it has to be brought up again and again.
     */
    public function tracerUp():void
    {
      if (tracer != null)
      {
        setChildIndex(tracer, numChildren - 1);
      }
    }
    /**
     * Opens the tracer of this application, creating it first when no message has reached it yet.
     * The level of the tracing can be set on the buttons of that tracer, and level nine means
     * that no message is ever collected, so the one debugging still has to be able to bring the
     * tracer onto the screen to leave that level behind.
     */
    public function tracerOpen():void
    {
      createTracerIfNecessary();
      tracerUp();
      tracer.open();
    }
    /**
     * Tells whether a bright shadow is needed behind a text of the given color: a dark
     * text needs a bright one to stay readable above a dark background.
     * @param color the color of that text as a hexadecimal string
     */
    public function brightShadowToApply(color:String):Boolean
    {
      application.trace("<Application brightShadowToApply> called.", 1);
      application.trace("<Application brightShadowToApply> color: " + color, 0);
      // the color arrives as a hexadecimal string of any length, so it is filled up with
      // zeros first and the six characters of the three components are taken of the end
      const padded:String = getComponentsConfig().getColorRgbInputZeros() + color;
      const rgb:String = padded.substr(padded.length - 6).toUpperCase();
      const bound:int = getComponentsConfig().getTextBrightDarkChangeBound();
      const bright:Boolean = componentOfColor(rgb, 0) < bound
        && componentOfColor(rgb, 2) < bound
        && componentOfColor(rgb, 4) < bound;
      application.trace("<Application brightShadowToApply> bright: " + bright, 0);
      return bright;
    }
    /**
     * Returns the font size belonging to the current size of the stage, kept between the
     * smallest and the biggest allowed one. An even number is answered: an odd font size
     * would make the halves of the elements built of it land on half pixels.
     */
    public function calcFontSizeFromStageSize():int
    {
      application.trace("<Application calcFontSizeFromStageSize> called.", 1);
      if (stage == null || getDynamicsConfig() == null || getComponentsConfig() == null)
      {
        application.trace("<Application calcFontSizeFromStageSize> there is nothing to calculate of yet.", 0);
        return FONT_SIZE_WITHOUT_STAGE;
      }
      const factor:Number = getDynamicsConfig().weAreInDesktopMode()
        ? getComponentsConfig().getFontSizeFactorDesktop()
        : getComponentsConfig().getFontSizeFactorMobile();
      var size:int = getDw() * factor;
      // an odd font size would make the halves of the elements built of it land on half
      // pixels, so the closest even one above it is answered instead
      if (size % 2 == 1)
      {
        size++;
      }
      if (size > getComponentsConfig().getMaxFontSize())
      {
        size = getComponentsConfig().getMaxFontSize();
      }
      if (size < getComponentsConfig().getMinFontSize())
      {
        size = getComponentsConfig().getMinFontSize();
      }
      application.trace("<Application calcFontSizeFromStageSize> size: " + size, 0);
      return size;
    }
    /**
     * Gives every text of this application the font size belonging to the current size
     * of the stage. It does nothing when the font size is a fixed one.
     */
    public function setFontSizeFromStage():void
    {
      application.trace("<Application setFontSizeFromStage> called.", 1);
      if (getDynamicsConfig().getAppFontSize() != 0)
      {
        application.trace("<Application setFontSizeFromStage> the font size is a fixed one.", 0);
        return;
      }
      const size:int = calcFontSizeFromStageSize();
      if (lastCalculatedFontSize != size)
      {
        lastCalculatedFontSize = size;
        getDynamicsConfig().setAllFontSizes(size);
      }
    }
    /**
     * Sets the name of this application with an icon in front of it on the middleground.
     * @param iconName the icon to be displayed, an empty one means no icon at all
     */
    public function setApplicationNameWithIcon(iconName:String):void
    {
      application.trace("<Application setApplicationNameWithIcon> called.", 1);
      application.trace("<Application setApplicationNameWithIcon> iconName: " + iconName, 0);
      if (middleground != null)
      {
        middleground.setApplicationNameWithIcon(iconName);
      }
    }
    /**
     * Adds a widget into the given widget container of the middleground.
     * @param contentId the index of that widget container
     * @param widget the widget to be added
     */
    public function addWidget(contentId:int, widget:Widget):void
    {
      application.trace("<Application addWidget> called.", 1);
      application.trace("<Application addWidget> contentId: " + contentId, 0);
      application.trace("<Application addWidget> widget: " + widget, 0);
      if (middleground != null)
      {
        middleground.addWidget(contentId, widget);
      }
      else
      {
        this.trace("<Application addWidget> there is no middleground to add the widget into!", 6);
      }
    }
    /**
     * Closes a widget of the middleground.
     * @param widget the widget to be closed
     */
    public function closeWidget(widget:Widget):void
    {
      application.trace("<Application closeWidget> called.", 1);
      application.trace("<Application closeWidget> widget: " + widget, 0);
      if (middleground != null)
      {
        middleground.closeWidget(widget);
      }
      else
      {
        this.trace("<Application closeWidget> there is no middleground to close the widget of!", 6);
      }
    }
    /**
     * Handles the menu item that has been picked on the panel of the menu. The framework
     * itself only displays the picked item, the extenders of it do the work belonging to it.
     * @param selectedItem the menu item that has been picked
     */
    public function handleMenuSelect(selectedItem:String):void
    {
      application.trace("<Application handleMenuSelect> called.", 1);
      application.trace("<Application handleMenuSelect> selectedItem: " + selectedItem, 0);
      if (getForeground() == null)
      {
        application.trace("<Application handleMenuSelect> there is no foreground to display the answer on.", 6);
        return;
      }
      const uniqueString:String = getUtils().getRandomGuid();
      const okType:String = uniqueString + EnumOkCancel.OC_OK();
      const okFunction:Function = function(e:Event):void
      {
        getBaseEventDispatcher().removeEventListener(okType, okFunction);
        getForeground().closeAlert(uniqueString);
        e.stopImmediatePropagation();
      };
      // the ok is appended to the unique string here as well: the foreground gives
      // exactly this event string to the button of the answer
      getBaseEventDispatcher().addEventListener(okType, okFunction);
      getForeground().createAlert(selectedItem, uniqueString, true, false);
    }
    /**
     * Recalculates the dimensions of the content of every parent of the given object.
     * @param theObject the object the walking of the parents is started from
     */
    public function callContentSizeRecalc(theObject:DisplayObject):void
    {
      application.trace("<Application callContentSizeRecalc> called.", 1);
      application.trace("<Application callContentSizeRecalc> theObject: " + theObject, 0);
      callContentDimensionsRecalculation(theObject);
    }
    /**
     * Recalculates the dimensions of the content of every parent of the given object and
     * tells about every one of them it has performed that on.
     * @param theObject the object the walking of the parents is started from
     */
    public function callContentDimensionsRecalculation(theObject:DisplayObject):void
    {
      application.trace("<Application callContentDimensionsRecalculation> called.", 1);
      application.trace("<Application callContentDimensionsRecalculation> theObject: " + theObject, 0);
      var parentObject:DisplayObject = theObject;
      while (parentObject != null)
      {
        if (parentObject is ContentSingle)
        {
          ContentSingle(parentObject).contentDimensionsRecalculation();
          application.trace("<Application callContentDimensionsRecalculation> contentDimensionsRecalculation is performed on: " + ContentSingle(parentObject), 0);
        }
        parentObject = parentObject.parent;
      }
    }
    /**
     * Finds the closest scrolled surface above the given object and starts the scrolling
     * of it. An element standing on a scrolled surface has to be draggable together
     * with that surface.
     * A content that has nothing to be scrolled is walked past: the drag of it belongs to
     * the closest outer content that can be scrolled instead. And a drag that is running
     * already is never taken away from the content it has been started on, because every
     * parent of the pressed object hands that very same press over as well, and only one
     * single object can be dragged by the mouse at a time: the last starter would win, so
     * an outer content would take the drag away from the inner one it belongs to.
     * @param starterObject the object the walking of the parents is started from
     */
    public function findFirstParentContentSingleAndStartScrolling(starterObject:DisplayObject):void
    {
      application.trace("<Application findFirstParentContentSingleAndStartScrolling> called.", 1);
      application.trace("<Application findFirstParentContentSingleAndStartScrolling> starterObject: " + starterObject, 0);
      if (scrollingBaseScroll != null && scrollingBaseScroll.getScrolled())
      {
        application.trace("<Application findFirstParentContentSingleAndStartScrolling> a content is being dragged already.", 0);
        return;
      }
      if (starterObject != null)
      {
        var parentObject:DisplayObject = starterObject.parent;
        while (parentObject != null)
        {
          if (parentObject is ContentSingle && ContentSingle(parentObject).enableScrollingFromOthers
            && ContentSingle(parentObject).getBaseScroll().hasSomethingToScroll())
          {
            scrollingBaseScroll = ContentSingle(parentObject).getBaseScroll();
            scrollingBaseScroll.mouseDown(null);
            application.trace("<Application findFirstParentContentSingleAndStartScrolling> mouseDown is performed on: " + ContentSingle(parentObject), 0);
            break;
          }
          parentObject = parentObject.parent;
        }
      }
    }
    /**
     * Finds the closest button above the given object and takes the mouse pointer off it.
     * A button that is covered by something else never hears that the pointer has left it.
     * @param starterObject the object the walking of the parents is started from
     */
    public function findFirstParentButtonAndPerformOnRollOut(starterObject:DisplayObject):void
    {
      application.trace("<Application findFirstParentButtonAndPerformOnRollOut> called.", 1);
      application.trace("<Application findFirstParentButtonAndPerformOnRollOut> starterObject: " + starterObject, 0);
      if (starterObject != null)
      {
        var parentObject:DisplayObject = starterObject.parent;
        while (parentObject != null)
        {
          if (parentObject is ButtonText)
          {
            ButtonText(parentObject).onRollOut();
            application.trace("<Application findFirstParentButtonAndPerformOnRollOut> onRollOut is performed on: " + ButtonText(parentObject), 0);
            break;
          }
          else if (parentObject is ButtonLink)
          {
            ButtonLink(parentObject).onRollOut();
            application.trace("<Application findFirstParentButtonAndPerformOnRollOut> onRollOut is performed on: " + ButtonLink(parentObject), 0);
            break;
          }
          parentObject = parentObject.parent;
        }
      }
    }
    /**
     * Asks the one using this application for the permission of the camera. The asking
     * happens once only: the answer that has been given stands until this application
     * is started again, so asking a second time would change nothing.
     */
    public function askForCameraPermission():void
    {
      application.trace("<Application askForCameraPermission> called.", 1);
      if (askedForCameraPermission)
      {
        application.trace("<Application askForCameraPermission> the permission of the camera has been asked for already.", 0);
        return;
      }
      askedForCameraPermission = true;
      Camera.permissionManager.requestPermission();
    }
    /**
     * Asks the one using this application for the permission of the microphone. The
     * asking happens once only, see the askForCameraPermission above.
     */
    public function askForMicrophonePermission():void
    {
      application.trace("<Application askForMicrophonePermission> called.", 1);
      if (askedForMicrophonePermission)
      {
        application.trace("<Application askForMicrophonePermission> the permission of the microphone has been asked for already.", 0);
        return;
      }
      askedForMicrophonePermission = true;
      Microphone.permissionManager.requestPermission();
    }
    /**
     * The width of this application is the one of the stage, so it cannot be set from
     * the outside: see the setSizeFromStageSize below.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<Application setDw> called.", 1);
      application.trace("<Application setDw> newdw: " + newdw, 0);
      application.trace("<Application setDw> do nothing.", 1);
    }
    /**
     * The height of this application is the one of the stage, so it cannot be set from
     * the outside: see the setSizeFromStageSize below.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<Application setDh> called.", 1);
      application.trace("<Application setDh> newdh: " + newdh, 0);
      application.trace("<Application setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this application are the ones of the stage, so they cannot be set
     * from the outside: see the setSizeFromStageSize below.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<Application setDwh> called.", 1);
      application.trace("<Application setDwh> newdw: " + newdw, 0);
      application.trace("<Application setDwh> newdh: " + newdh, 0);
      application.trace("<Application setDwh> do nothing.", 1);
    }
    /**
     * The extenders of this class build every object of their own here.
     */
    protected function createObjects():void
    {
      application.trace("<Application createObjects> called.", 1);
    }
    /**
     * Builds the three layers of the displayed application. It is not called by the
     * initialize of this class on purpose: an application drawing everything on its
     * own does not need any of them, so every extender asks for them by itself.
     */
    protected function createLayers():void
    {
      application.trace("<Application createLayers> called.", 1);
      if (background == null)
      {
        background = new Background(this);
        addChild(background);
      }
      if (middleground == null)
      {
        middleground = new Middleground(this);
        addChild(middleground);
      }
      if (foreground == null)
      {
        foreground = new Foreground(this);
        addChild(foreground);
      }
      setSizeFromStageSize();
    }
    /**
     * The stage has been resized, so this application and every layer of it take the new
     * size of it. The extenders of this class follow that resizing here as well, they only
     * have to call this super.
     * The window of a desktop application is resized right after it has been opened: the
     * size the descriptor of it asks for is the size of the whole window, and the chrome
     * of that window is taken out of it by the window manager. So this is not a rare event
     * that happens when the one using the application drags the corner of the window: it
     * always happens, and an application that does not follow it keeps the height it was
     * started with, one title bar taller than the room it really has.
     * @param e the resize event of the stage
     */
    protected function stageResized(e:Event):void
    {
      application.trace("<Application stageResized> called.", 1);
      application.trace("<Application stageResized> e: " + e, 0);
      setSizeFromStageSize();
    }
    /**
     * Gives this application and every layer of it the current size of the stage, kept
     * above the smallest size this framework is usable on.
     */
    protected function setSizeFromStageSize():void
    {
      application.trace("<Application setSizeFromStageSize> called.", 1);
      if (stage == null)
      {
        this.trace("<Application setSizeFromStageSize> stage is null!", 6);
        return;
      }
      super.setDwh(Math.max(getComponentsConfig().getAppSizeMinWidth(), stage.stageWidth), Math.max(getComponentsConfig().getAppSizeMinHeight(), stage.stageHeight));
      if (background != null)
      {
        background.setDwh(getDw(), getDh());
      }
      if (middleground != null)
      {
        middleground.setDwh(getDw(), getDh());
      }
      if (foreground != null)
      {
        foreground.setDwh(getDw(), getDh());
      }
    }
    /**
     * Prepares the stage of this application and takes the size of it.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<Application addedToStage> called.", 1);
      application.trace("<Application addedToStage> e: " + e, 0);
      super.addedToStage(e);
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
      setSizeFromStageSize();
    }
    /**
     * Drops the listener of the resizing of the stage.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<Application removedFromStage> called.", 1);
      application.trace("<Application removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
      }
      super.removedFromStage(e);
    }
    /**
     * Prepares this application itself: its dispatcher tells this object as its source.
     */
    protected function initializeApp():void
    {
      application.trace("<Application initializeApp> called.", 1);
      getBaseEventDispatcher().setParentObject(this);
    }
    /**
     * Builds the helper methods of the framework.
     */
    protected function initializeUtils():void
    {
      application.trace("<Application initializeUtils> called.", 1);
      utils = new Utils(this);
    }
    /**
     * Builds the properties of this application.
     */
    protected function initializePropertiesConfig():void
    {
      application.trace("<Application initializePropertiesConfig> called.", 1);
      propertiesConfig = new PropertiesConfig(this);
    }
    /**
     * Builds the values every component of the framework is built of.
     */
    protected function initializeComponentsConfig():void
    {
      application.trace("<Application initializeComponentsConfig> called.", 1);
      componentsConfig = new ComponentsConfig(this);
    }
    /**
     * Builds the displayed properties of this application.
     */
    protected function initializeDynamicsConfig():void
    {
      application.trace("<Application initializeDynamicsConfig> called.", 1);
      dynamicsConfig = new DynamicsConfig(this);
    }
    /**
     * Builds the manager of the embedded background images.
     */
    protected function initializeBackgroundManager():void
    {
      application.trace("<Application initializeBackgroundManager> called.", 1);
      backgroundManager = new BackgroundManager(this);
    }
    /**
     * Builds the manager of the cached files.
     */
    protected function initializeCacheManager():void
    {
      application.trace("<Application initializeCacheManager> called.", 1);
      cacheManager = new CacheManager(this);
    }
    /**
     * Builds the manager of the context menu.
     */
    protected function initializeContextMenuManager():void
    {
      application.trace("<Application initializeContextMenuManager> called.", 1);
      contextMenuManager = new ContextMenuManager(this);
    }
    /**
     * Builds the manager of the identifier of the device. It asks the name and the secret
     * of that identifier from the properties of the application, so it stands after them.
     */
    protected function initializeDeviceIdManager():void
    {
      application.trace("<Application initializeDeviceIdManager> called.", 1);
      deviceIdManager = new DeviceIdManager(this);
    }
    /**
     * Builds the manager of the embedded fonts.
     */
    protected function initializeFontManager():void
    {
      application.trace("<Application initializeFontManager> called.", 1);
      fontManager = new FontManager(this);
    }
    /**
     * Builds the manager of the embedded emojis.
     */
    protected function initializeEmojiManager():void
    {
      application.trace("<Application initializeEmojiManager> called.", 1);
      emojiManager = new EmojiManager(this);
    }
    /**
     * Builds the manager of the embedded icons.
     */
    protected function initializeIconManager():void
    {
      application.trace("<Application initializeIconManager> called.", 1);
      iconManager = new IconManager(this);
    }
    /**
     * Builds the manager of the embedded sounds.
     */
    protected function initializeSoundManager():void
    {
      application.trace("<Application initializeSoundManager> called.", 1);
      soundManager = new SoundManager(this);
    }
    /**
     * Builds the manager of the labels.
     */
    protected function initializeLabelManager():void
    {
      application.trace("<Application initializeLabelManager> called.", 1);
      labelManager = new LabelManager(this);
    }
    /**
     * Builds the manager of the widgets.
     */
    protected function initializeWidgetManager():void
    {
      application.trace("<Application initializeWidgetManager> called.", 1);
      widgetManager = new WidgetManager(this);
    }
    /**
     * Builds the manager of the servers of this application. It stands before the managers
     * talking to those servers, because the connections of theirs are built of the very
     * servers it holds.
     */
    protected function initializeServerManager():void
    {
      application.trace("<Application initializeServerManager> called.", 1);
      serverManager = new ServerManager(this);
    }
    /**
     * Builds the manager of the url requests.
     */
    protected function initializeUrlRequestManager():void
    {
      application.trace("<Application initializeUrlRequestManager> called.", 1);
      urlRequestManager = new UrlRequestManager(this);
    }
    /**
     * Builds the manager of the net connection.
     */
    protected function initializeNetConnectionManager():void
    {
      application.trace("<Application initializeNetConnectionManager> called.", 1);
      netConnectionManager = new NetConnectionManager(this);
    }
    /**
     * Builds the one using this application.
     */
    protected function initializeUser():void
    {
      application.trace("<Application initializeUser> called.", 1);
      user = new User(this);
    }
    /**
     * Builds every configuration and every manager of the framework, in the order they
     * are needed in: every one of them may use the ones standing above it.
     */
    private function initialize():void
    {
      application.trace("<Application initialize> called.", 1);
      initializeApp();
      initializeUtils();
      initializePropertiesConfig();
      initializeComponentsConfig();
      initializeDynamicsConfig();
      initializeBackgroundManager();
      initializeCacheManager();
      initializeContextMenuManager();
      initializeDeviceIdManager();
      initializeFontManager();
      initializeEmojiManager();
      initializeIconManager();
      initializeSoundManager();
      initializeLabelManager();
      initializeWidgetManager();
      initializeServerManager();
      initializeUrlRequestManager();
      initializeNetConnectionManager();
      initializeUser();
      // the addresses of the active servers are asked over http, so the refreshing of
      // them is started when the manager carrying that request stands as well
      if (serverManager != null)
      {
        serverManager.startRefreshingServers();
      }
    }
    /**
     * Returns the value of one component of a color.
     * @param rgb the six characters of the three components as a hexadecimal string
     * @param index the position that component starts at, so zero, two or four
     */
    private function componentOfColor(rgb:String, index:int):int
    {
      application.trace("<Application componentOfColor> called.", 1);
      application.trace("<Application componentOfColor> rgb: " + rgb, 0);
      application.trace("<Application componentOfColor> index: " + index, 0);
      return Number(getComponentsConfig().getColorHexToNumberString() + rgb.substr(index, 2));
    }
    // NOTE: none of the methods of the tracing below calls the trace of this class, and
    // that is on purpose: they are the sink every message is written into, so a message
    // of them would describe the displaying of the messages and recurse endlessly. The
    // same holds for the Tracer object itself, see the header comment lines of that one.
    /**
     * Returns the source of the given message: the object and the method that logged it. Every
     * message of this framework starts with those between angle brackets, and the messages
     * sharing them are the repeated ones to be counted instead of being displayed one by one.
     * @param message the message the source is taken from
     */
    private function sourceOfMessage(message:String):String
    {
      const closing:int = message.indexOf(">");
      return closing == -1 ? message : message.substring(0, closing + 1);
    }
    /**
     * Returns the given message with its timestamp and its level in front of it, shortened when
     * it is a longer one than allowed.
     * @param message the message to be displayed
     * @param level the level of that message
     */
    private function messageToDisplay(message:Object, level:int):String
    {
      dateTimeFormatter.setDateTimePattern("yyyy-MM-dd hh:mm:ss");
      const messageToWrite:String = "" + message;
      const shortened:String = messageToWrite.length < traceMaxLength ? messageToWrite
        : messageToWrite.substring(0, traceMaxLength - 3) + "...";
      return dateTimeFormatter.format(new Date()) + " ( " + level + (level >= 3 ? "!" : " ")
        + " ) |   " + shortened;
    }
    /**
     * Hands every message collected since the previous frame over to the tracer in one single
     * step, creating that tracer when the first messages have arrived. The sources that were
     * sampled report the number of the messages of them that are not displayed, so a burst
     * stays visible as a burst instead of disappearing without a word.
     * Tracing is suppressed while this runs: the methods called below log as well, and their
     * messages would describe the displaying of the messages.
     * @param e the enter frame event
     */
    private function enterFrameDisplayTraces(e:Event):void
    {
      removeEventListener(Event.ENTER_FRAME, enterFrameDisplayTraces);
      if (tracesToDisplay == null || tracesToDisplay.length == 0)
      {
        return;
      }
      inTrace = true;
      try
      {
        for (var source:String in tracesPerSource)
        {
          if (int(tracesPerSource[source]) > TRACESPERSOURCE)
          {
            tracesToDisplay.push(SUPPRESSEDMARGIN + source + " and "
              + (int(tracesPerSource[source]) - TRACESPERSOURCE) + " more messages of this source");
          }
        }
        if (tracesSuppressed > 0)
        {
          tracesToDisplay.push(SUPPRESSEDMARGIN + tracesSuppressed
            + " messages are not displayed from this frame");
        }
      // The messages do not open the tracer, they only bring the button of it onto the screen: the
      // one debugging is the one deciding when the log covers the application.
        createTracerIfNecessary();
        tracerUp();
        tracer.trace(tracesToDisplay);
      }
      finally
      {
        tracesToDisplay.splice(0, tracesToDisplay.length);
        tracesPerSource = new Object();
        tracesSuppressed = 0;
        inTrace = false;
      }
    }
    /**
     * Creates the tracer of this application when it does not exist yet. A created tracer
     * displays the button of itself only: the log behind that button stays closed until it is
     * asked for.
     */
    private function createTracerIfNecessary():void
    {
      if (tracer == null)
      {
        tracer = new Tracer(this);
        addChild(tracer);
      }
    }
    /**
     * Destroys every helper object of this application: the helper methods, the configs, the
     * managers and the user, in the opposite order of the one they have been built in, so
     * that nothing is freed up before the objects reading it are.
     *
     * This one traces nothing at all, and it is the only method of this class that does not:
     * it runs after the super destroy, and that call has already cleared the very application
     * reference every trace of this class goes through.
     */
    private function destroyHelperObjects():void
    {
      if (user != null)
      {
        user.destroy();
      }
      if (netConnectionManager != null)
      {
        netConnectionManager.destroy();
      }
      if (urlRequestManager != null)
      {
        urlRequestManager.destroy();
      }
      if (serverManager != null)
      {
        serverManager.destroy();
      }
      if (widgetManager != null)
      {
        widgetManager.destroy();
      }
      if (labelManager != null)
      {
        labelManager.destroy();
      }
      if (soundManager != null)
      {
        soundManager.destroy();
      }
      if (iconManager != null)
      {
        iconManager.destroy();
      }
      if (emojiManager != null)
      {
        emojiManager.destroy();
      }
      if (fontManager != null)
      {
        fontManager.destroy();
      }
      if (deviceIdManager != null)
      {
        deviceIdManager.destroy();
      }
      if (contextMenuManager != null)
      {
        contextMenuManager.destroy();
      }
      if (cacheManager != null)
      {
        cacheManager.destroy();
      }
      if (backgroundManager != null)
      {
        backgroundManager.destroy();
      }
      if (dynamicsConfig != null)
      {
        dynamicsConfig.destroy();
      }
      if (componentsConfig != null)
      {
        componentsConfig.destroy();
      }
      if (propertiesConfig != null)
      {
        propertiesConfig.destroy();
      }
      if (utils != null)
      {
        utils.destroy();
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<Application destroy> called.", 1);
      application.trace("<Application destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      removeEventListener(Event.ENTER_FRAME, enterFrameDisplayTraces);
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
      }
      application.trace("<Application destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      if (tracesToDisplay != null)
      {
        tracesToDisplay.splice(0, tracesToDisplay.length);
      }
      // the tracer is not a BaseSprite, so the super destroy below removes it from the display
      // list but cannot free it up: it has to be destroyed here, while it still has its stage
      if (tracer != null)
      {
        tracer.destroy();
        if (contains(tracer))
        {
          removeChild(tracer);
        }
      }
      application.trace("<Application destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<Application destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      // The helper objects are freed up after the super destroy, because that one tears the
      // display list down and a child being destroyed still reads the values of the configs
      // and of the managers. The logging is switched off in front of them on purpose: all of
      // them do trace, they carry their own references of this application so those messages
      // would arrive, and a message arriving now would build a new tracer into an application
      // that has just been emptied. This is why this flag is not reset among the ones below.
      traceIsEnabled = false;
      destroyHelperObjects();
      inTrace = false;
      traceLevel = 0;
      tracesToDisplay = null;
      tracesPerSource = null;
      tracesSuppressed = 0;
      tracer = null;
      appEnv = null;
      utils = null;
      propertiesConfig = null;
      componentsConfig = null;
      dynamicsConfig = null;
      backgroundManager = null;
      cacheManager = null;
      contextMenuManager = null;
      deviceIdManager = null;
      fontManager = null;
      emojiManager = null;
      iconManager = null;
      soundManager = null;
      labelManager = null;
      widgetManager = null;
      serverManager = null;
      urlRequestManager = null;
      netConnectionManager = null;
      user = null;
      background = null;
      middleground = null;
      foreground = null;
      applicationType = "";
      menuxml = "";
      lastCalculatedFontSize = 0;
      scrollingBaseScroll = null;
    }
  }
}
