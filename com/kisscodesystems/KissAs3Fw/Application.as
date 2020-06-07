/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . KissAs3FwMain
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** Application.
** This class is the main class of this framework.
** Every application built using this framework should extend this class.
** Has contained 42 classes initially and this is not an accident.
**
** Published       : 07.31.2017
**
** Current version : 1.8
**
** Developed by    : Jozsef Kiss
**                   KissCode Systems Kft
**                   <https://openso.kisscodesystems.com>
**
** Changelog       : 1.1 - 06.30.2017
**                   bugfixes and smaller improvements
**                   1.2 - 07.02.2017
**                   displayAsPassword is available in TextInput
**                   the scrolling works in the BaseScroll using the mouse wheel.
**                   1.3 - 07.05.2017
**                   the embedded arial font is in the demo propsDyn from now
**                   the content will be cached as a bitmap during its movement
**                   1.4 - 07.06.2017
**                   small improvements in the content moving
**                   1.5 - 07.09.2017
**                   multiple contents are available in widgets instead of ContentSingle
**                   multiple widget containers are also available (settings panel)
**                   small bugfix of content moving on mobile devices
**                   pixel stealing is improved in Color (mobile devices)
**                   the Checkbox is Switcher from now
**                   "about" tab on the settings panel
**                   1.6 - 07.31.2017
**                   several smaller improvements
**                   ButtonFile class is added to handle file browsing and uploading
**                   This works on desktop, webbrowser and on mobile devices.
**                   1.7 - 08.19.2017
**                   Camera object is added now.
**                   The File and FileReference can be set from outside in ButtonFile.
**                   1.8 - 04.01.2018
**                   Clock, Icon, Image and Timezone classes are added
**                   menu contains profile image, nickname, fullname, role, login time,
**                   and logout, register buttons
**                   background can display background images loaded from the internet.
**                   Tracer class
**                   several minor improvements
**
** MAIN FEATURES:
** - Contains the public (not static) constants for every part of the fw.
** - background , middleground , foreground layers
** - texts , textStock , propsApp and propsDyn variable holders
** - menuxml: the main menu of this application is here
** - uses customContextMenu to handle custom context menu items.
**
** - handles the menu selection
** - toSmartphone: easier to set up the application into smartphones
** - setApplicationName: sets a name to this application for you
** - custom context menu items are available to add and remove, and even handles
**   the events of clicks in case of single webpage opener menu items.
** - calculates and sets the font size if it is configured
**   ( propsDyn . getAppFontSize ( ) == 0 )
** - adds and closes widgets immediately
** - brightShadowToApply determines which drop shadow has to be applied
** - callContentSizeRecalc supports the automatic size recalculation of the contents
**
** NOTE!
** Please, be careful when develop an application.
** Consider everything in the view of grabage collecting.
** Your users do not want to feel your application to be slowed after a not too
** long time. If the memory usage of the application just grows and grows then
** it needs more and more resources to be operated.
** In this framework you will meet this thinking in the logic of all of the classes.
** You can test (and monitor) your compiled application with a tool that can
** view the actual memory usage and the current counts of your objects within your app.
**
** There are some if ( application != null ).
** These are necessary to be there because the grabage collecting will not happen
** immediately so there will be some function calls that we don't want actually.
** We can avoid the running of these functions by checking this condition.
**
** KissAs3Fw is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** Free Software Foundation, version 3.
**
** KissAs3Fw is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with KissAs3Fw. If not, see <http://www.gnu.org/licenses/>.
*/
package com . kisscodesystems . KissAs3Fw
{
  import com . kisscodesystems . KissAs3Fw . app . Background ;
  import com . kisscodesystems . KissAs3Fw . app . Foreground ;
  import com . kisscodesystems . KissAs3Fw . app . Middleground ;
  import com . kisscodesystems . KissAs3Fw . app . Tracer ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . prop . PropsApp ;
  import com . kisscodesystems . KissAs3Fw . prop . PropsDyn ;
  import com . kisscodesystems . KissAs3Fw . text . TextStock ;
  import com . kisscodesystems . KissAs3Fw . text . Texts ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonFile ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentSingle ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . display . DisplayObject ;
  import flash . display . StageAlign ;
  import flash . display . StageScaleMode ;
  import flash . events . ContextMenuEvent ;
  import flash . events . Event ;
  import flash . filesystem . File ;
  import flash . filters . DropShadowFilter ;
  import flash . globalization . DateTimeFormatter ;
  import flash . net . URLRequest ;
  import flash . net . navigateToURL ;
  import flash . ui . ContextMenu ;
  import flash . ui . ContextMenuItem ;
  public class Application extends BaseSprite
  {
// SOME VARS NEED TO BE HERE
    public const LENGTHS_PASS : Array = new Array ( 8 , 200 ) ;
    public const CHARS_PASS : String = "a-zA-Z0-9 .\\-\\,:;_*@?#áíűőüöúóéÁÍŰŐÜÖÚÓÉ" ;
// CONSTANTS
// The line thickness change event string.
    public const EVENT_LINE_THICKNESS_CHANGED : String = "EVENT_LINE_THICKNESS_CHANGED" ;
// The events of the margin, padding and radius change.
    public const EVENT_MARGIN_CHANGED : String = "EVENT_MARGIN_CHANGED" ;
    public const EVENT_PADDING_CHANGED : String = "EVENT_PADDING_CHANGED" ;
    public const EVENT_RADIUS_CHANGED : String = "EVENT_RADIUS_CHANGED" ;
// Event strings of the background color changing events.
    public const EVENT_BACKGROUND_BG_COLOR_CHANGED : String = "EVENT_BACKGROUND_BG_COLOR_CHANGED" ;
    public const EVENT_BACKGROUND_FG_COLOR_CHANGED : String = "EVENT_BACKGROUND_FG_COLOR_CHANGED" ;
// Event string of the changing of the fill alhpa.
    public const EVENT_BACKGROUND_FILL_ALPHA_CHANGED : String = "EVENT_BACKGROUND_FILL_ALPHA_CHANGED" ;
// The changing of the properties of background image.
    public const EVENT_BACKGROUND_IMAGE_CHANGED : String = "EVENT_BACKGROUND_IMAGE_CHANGED" ;
    public const EVENT_BACKGROUND_IMAGE_ALIGN_CHANGED : String = "EVENT_BACKGROUND_IMAGE_ALIGN_CHANGED" ;
    public const EVENT_BACKGROUND_IMAGE_ALPHA_CHANGED : String = "EVENT_BACKGROUND_IMAGE_ALPHA_CHANGED" ;
    public const EVENT_BACKGROUND_IMAGE_LIVE_CHANGED : String = "EVENT_BACKGROUND_IMAGE_LIVE_CHANGED" ;
// Event strings of the changing of the used textformats.
    public const EVENT_TEXT_FORMAT_BRIGHT_CHANGED : String = "EVENT_TEXT_FORMAT_BRIGHT_CHANGED" ;
    public const EVENT_TEXT_FORMAT_MID_CHANGED : String = "EVENT_TEXT_FORMAT_MID_CHANGED" ;
    public const EVENT_TEXT_FORMAT_DARK_CHANGED : String = "EVENT_TEXT_FORMAT_DARK_CHANGED" ;
// Event string constants of the coordinate and size changing events.
    public const EVENT_COORDINATES_CHANGED : String = "EVENT_COORDINATES_CHANGED" ;
    public const EVENT_SIZES_CHANGED : String = "EVENT_SIZES_CHANGED" ;
// When the elements of a contentsingle have been repositioned.
    public const EVENT_ELEMENTS_REPOSITIONED : String = "EVENT_ELEMENTS_REPOSITIONED" ;
// These are messages from a widget.
    public const EVENT_WIDGET_CLOSE_ME : String = "EVENT_WIDGET_CLOSE_ME" ;
    public const EVENT_WIDGET_CLOSED : String = "EVENT_WIDGET_CLOSED" ;
    public const EVENT_WIDGET_DRAG_START : String = "EVENT_WIDGET_DRAG_START" ;
    public const EVENT_WIDGET_DRAG_STOP : String = "EVENT_WIDGET_DRAG_STOP" ;
// Event string of the changing of the orientation of widgets or other UI elements.
    public const EVENT_ORIENTATIONS_CHANGED : String = "EVENT_ORIENTATIONS_CHANGED" ;
// Event string of the changing of the actual used language code of the application.
// Used in TextStock.
    public const EVENT_LANG_CODE_CHANGED : String = "EVENT_LANG_CODE_CHANGED" ;
// The displaying style or an attribute is changed.
    public const EVENT_STYLE_CHANGED : String = "EVENT_STYLE_CHANGED" ;
// When a base scroll notifies other objects about the changing of the content position.
    public const EVENT_CONTENT_POSITION_CHANGED : String = "EVENT_CONTENT_POSITION_CHANGED" ;
// The events of the cache begin and end
    public const EVENT_CONTENT_CACHE_BEGIN : String = "EVENT_CONTENT_CACHE_BEGIN" ;
// When a click event has occurred on the objects.
    public const EVENT_CLICK : String = "EVENT_CLICK" ;
// The value of the object has been changed.
    public const EVENT_CHANGED : String = "EVENT_CHANGED" ;
// The object has been closed.
    public const EVENT_CLOSED : String = "EVENT_CLOSED" ;
// The event of a camera is attached.
    public const EVENT_CAMERA_IS_ATTACHED : String = "EVENT_CAMERA_IS_ATTACHED" ;
// When a button file is for browse or cancel.
    public const EVENT_FILE_REFERENCE_BROWSE : String = "EVENT_FILE_REFERENCE_BROWSE" ;
    public const EVENT_FILE_REFERENCE_CANCEL : String = "EVENT_FILE_REFERENCE_CANCEL" ;
// The events of the file upload.
    public const EVENT_FILE_UPLOAD_DONE : String = "EVENT_FILE_UPLOAD_DONE" ;
    public const EVENT_FILE_UPLOAD_FAIL : String = "EVENT_FILE_UPLOAD_FAIL" ;
// A file is loaded.
    public const EVENT_FILE_LOADED : String = "EVENT_FILE_LOADED" ;
// The event string of the successfuly saving.
    public const EVENT_SAVED : String = "EVENT_SAVED" ;
// Events of the menu panel: register or logout.
    public const EVENT_TO_CREATE_REG_FORM : String = "EVENT_TO_CREATE_REG_FORM" ;
    public const EVENT_TO_LOGOUT : String = "EVENT_TO_LOGOUT" ;
// Event of the profil phptp click.
    public const EVENT_PROFILE_IMAGE_CLICKED : String = "EVENT_PROFILE_IMAGE_CLICKED" ;
// A user file is selected or cancelled.
    public const EVENT_USER_BACKGROUND_FILE_SELECTED : String = "EVENT_USER_BACKGROUND_FILE_SELECTED" ;
    public const EVENT_USER_BACKGROUND_FILE_CANCELLED : String = "EVENT_USER_BACKGROUND_FILE_CANCELLED" ;
// The user changes the password or creates a new one.
    public const EVENT_USER_PASSWORD_CHANGE_DO : String = "EVENT_USER_PASSWORD_CHANGE_DO" ;
    public const EVENT_USER_PASSWORD_CREATE_DO : String = "EVENT_USER_PASSWORD_CREATE_DO" ;
// Events of the reaching the bottom.
    public const BOTTOM_REACHED : String = "BOTTOM_REACHED" ;
// Empty html paragraph
    public const EMPTY_HTML_PARAGRAPH : String = "<p>&nbsp;</p>" ;
// Color constants
    public const COLOR_RGB_INPUT_ZEROS : String = "000000" ;
    public const COLOR_HEX_TO_NUMBER_STRING : String = "0x" ;
    public const COLOR_MAX_CHARS_RGB_INPUT : int = 6 ;
    public const COLOR_DRAWED_COLOR_ARRAY_DARK : Number = 0x000000 ;
    public const COLOR_DRAWED_COLOR_ARRAY_BRIGHT : Number = 0xffffff ;
    public const COLOR_DRAWED_ALPHA_ARRAY : Array = new Array ( "1" , "1" , "1" ) ;
    public const COLOR_DRAWED_RATIO_ARRAY : Array = new Array ( "5" , "126" , "250" ) ;
// This is the number where the color of the application changes from dark to bright.
// See the logic in brightShadowToApply.
    public const TEXT_BRIGHT_DARK_CHANGE_BOUND : int = 4 * 16 ;
// The enabled characters of the hexadecimal input
    public const TEXT_ENABLED_CHARS_HEX : String = "0-9a-fA-F" ;
// The types of the usable drawn buttons.
    public const DRAW_BUTTON_TYPE_SETTINGS : String = "DRAW_BUTTON_TYPE_SETTINGS" ;
    public const DRAW_BUTTON_TYPE_MENU : String = "DRAW_BUTTON_TYPE_MENU" ;
    public const DRAW_BUTTON_TYPE_WIDGET_MOVE : String = "DRAW_BUTTON_TYPE_WIDGET_MOVE" ;
    public const DRAW_BUTTON_TYPE_WIDGETS_PREV : String = "DRAW_BUTTON_TYPE_WIDGETS_PREV" ;
    public const DRAW_BUTTON_TYPE_WIDGETS_NEXT : String = "DRAW_BUTTON_TYPE_WIDGETS_NEXT" ;
    public const DRAW_BUTTON_TYPE_WIDGETS_LIST : String = "DRAW_BUTTON_TYPE_WIDGETS_LIST" ;
// The drop shadow object to the texts and other objects.
// These are the objects usable everywhere.
// Have to be initialized now!
    public const TEXT_DROP_SHADOW_ARRAY_DARK : Array = [ new DropShadowFilter ( 1 , 45 , 0x000000 , 1 , 1 , 1 , 1 , 2 ) ] ;
    public const TEXT_DROP_SHADOW_ARRAY_BRIGHT : Array = [ new DropShadowFilter ( 1 , 45 , 0xffffff , 1 , 1 , 1 , 1 , 2 ) ] ;
// This is the tracing level.
// 0: debug
// 1: info
// 2: warning
// 3: error
// 4: no tracing
// This framework uses 0 only, your application should use other tracing levels.
    protected var traceLevel : int = 1 ;
// The Tracer class to display developer messages.
    public var tracer : Tracer = null ;
// To trace
    private var dateTimeFormatter : DateTimeFormatter = new DateTimeFormatter ( "en-US" ) ;
// THE BACKGROUND AND THE FOREGROUND PLUS MIDDLEGROUND OF THIS APP:
// FOREGROUND: ALERTS AND LIST OF WIDGETS,
// MIDDLEGROUND: HEADER, FOOTER, WIDGETS AND THE SETTINGS AND MENU BUTTONS AND PANELS,
// BACKGROUND: BACKGROUND IMAGING, BACKGROUND COLORING.
// This is the whole background object.
    private var background : Background = null ;
// This contains header, footer and a widgets layer, the panel and buttons of settings and menu.
    private var middleground : Middleground = null ;
// This is the foreground layer, contains the alerts and informations layer.
    private var foreground : Foreground = null ;
// OTHER PROPERTIES.
// This holds all of the texts usable in this app.
    protected var texts : Texts = null ;
// The object of the stored texts.
    protected var textStock : TextStock = null ;
// The properties of this application.
    protected var propsApp : PropsApp = null ;
    protected var propsDyn : PropsDyn = null ;
// The menu items of this applicaiton.
    protected var menuxml : String = "" ;
// To hide unnecessary right click menu elements and to add new ones.
    private var customContextMenu : ContextMenu = null ;
    private var customContextLabels : Array = new Array ( ) ;
    private var customContextUrls : Array = new Array ( ) ;
    private var customContextHandlers : Array = new Array ( ) ;
// The file class is usable or not..
    private var fileClassIsUsable : Boolean = true ;
// URLs for later use.
    protected var urlNc : String = "" ;
    protected var urlSite : String = "" ;
    protected var urlFiles : String = "" ;
    protected var urlSubmit : String = "" ;
    protected var urlProfile : String = "" ;
/*
** The constructor, does the initialization of the whole application.
*/
    public function Application ( ) : void
    {
// Giving the reference to itself since this is the Application.
      super ( this ) ;
// To trace immediately
      dateTimeFormatter . setDateTimePattern ( "yyyy-MM-dd hh:mm:ss" ) ;
// Determining the usage of file or fileReference to use.
      try
      {
        new File ( ) ;
      }
      catch ( e : * )
      {
        fileClassIsUsable = false ;
      }
// The contextmenu will be changed and be prepared to hold additional items.
      customContextMenu = new ContextMenu ( ) ;
      customContextMenu . hideBuiltInItems ( ) ;
      contextMenu = customContextMenu ;
      customContextLabels = new Array ( ) ;
      customContextUrls = new Array ( ) ;
// The initialization of all of the components.
      texts = new Texts ( ) ;
      textStock = new TextStock ( application ) ;
      propsApp = new PropsApp ( ) ;
      propsDyn = new PropsDyn ( application ) ;
      getBaseEventDispatcher ( ) . setParentObject ( this ) ;
      application . trace ( "App started and initialized." , 1 ) ;
    }
/*
** Gets the urls.
*/
    public function getUrlNc ( ) : String
    {
      return urlNc ;
    }
    public function getUrlSite ( ) : String
    {
      return urlSite ;
    }
    public function getUrlFiles ( ) : String
    {
      return urlFiles ;
    }
    public function getUrlSubmit ( ) : String
    {
      return urlSubmit ;
    }
    public function getUrlProfile ( ) : String
    {
      return urlProfile ;
    }
/*
** The File class is usable or not.
*/
    public function getFileClassIsUsable ( ) : Boolean
    {
      return fileClassIsUsable ;
    }
/*
** The creation of the layers. Has to be called after the reinitialization
** of the texts textstock propsapp and propsdyn.
*/
    protected function createLayers ( ) : void
    {
      if ( background == null )
      {
        background = new Background ( application ) ;
        addChild ( background ) ;
      }
      if ( middleground == null )
      {
        middleground = new Middleground ( application ) ;
        addChild ( middleground ) ;
      }
      if ( foreground == null )
      {
        foreground = new Foreground ( application ) ;
        addChild ( foreground ) ;
      }
// Resizing this object now.
      setSizeFromStageSize ( ) ;
    }
/*
** This method will be called if the object is being added to the stage.
** A lot of initializing happens here because the stage is available
** from here.
*/
    override protected function addedToStage ( e : Event ) : void
    {
// Calling the addedToStage of parent.
      super . addedToStage ( e ) ;
// Some correction about the working mode of this application.
      stage . align = StageAlign . TOP_LEFT ;
      stage . scaleMode = StageScaleMode . NO_SCALE ;
// The event of the stage resizing has to be handled in this class.
// stage . addEventListener .. always has to be false , 0 , true !
      stage . addEventListener ( Event . RESIZE , stageResized , false , 0 , true ) ;
// Resizing this object now.
      setSizeFromStageSize ( ) ;
    }
    override protected function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
      }
      super . removedFromStage ( e ) ;
    }
/*
** Gets the menu items of the application.
*/
    public function getMenuxml ( ) : String
    {
      return menuxml ;
    }
/*
** Handles the event of the changing of the selected menu item.
** In this case, only an alert will be created.
** So here is the basic example of how to create an alert using this fw.
*/
    public function handleMenuSelect ( selectedItem : String ) : void
    {
// At first, we should have a message and a unique string.
      var messageString : String = selectedItem ;
      var uniqueString : String = "" + new Date ( ) . time ;
// Secondly, we should create a handler which will handle the closure of the alert.
      var close : Function = function ( e : Event ) : void
      {
// This will be happened by the removing of the event listener (important),
        getBaseEventDispatcher ( ) . removeEventListener ( e . type , close ) ;
// closing the alert using the message (every alert has to be unique message)
// (note: the e . type contains the getTexts ( ) . OC_OK string appended to the end so this has to be removed),
        getForeground ( ) . closeAlert ( e . type . substr ( 0 , e . type . length - getTexts ( ) . OC_OK . length ) ) ;
// and finally, this event has to be stopped.
        e . stopImmediatePropagation ( ) ;
      }
// Now the registration to the event listener
// (see? the OK is appended here too because the foreground will define
// the button with this custom event string to be dispatched)
      getBaseEventDispatcher ( ) . addEventListener ( uniqueString + getTexts ( ) . OC_OK , close ) ;
// And the alert creation itself.
      getForeground ( ) . createAlert ( messageString , uniqueString , true , false ) ;
    }
/*
** Prepares the displaying of this application to smartphone friendly.
*/
    public function toSmartphone ( ) : void
    {
// By default: the app, dyn variables and the middleground have to be prepared.
      propsApp . toSmartphone ( ) ;
      propsDyn . toSmartphone ( ) ;
      middleground . toSmartphone ( ) ;
    }
/*
** Sets the name of the application.
** This writes a label onto the header area of the application.
*/
    protected function setApplicationName ( ) : void
    {
      if ( middleground != null )
      {
// The middleground dose this.
        middleground . setApplicationName ( ) ;
      }
    }
/*
** Adds new url item to the context menu.
** A label (the menu item) and the url to navigate onto can be specified.
** The third is the reference to a custom handler function, can be null.
*/
    public function addNewContextMenuItem ( label : String , url : String , handler : Function ) : void
    {
// Hardcoded, only 10 custom menu item should be added maximum.
// (Adobe allowes 15 at this moment.)
      if ( customContextLabels . length < 10 )
      {
// The label has to be unique!
        if ( customContextLabels . indexOf ( label ) == - 1 )
        {
// The label can be added immediately.
          customContextLabels . push ( label ) ;
// The creation of the custom context menu item.
          var newItem : ContextMenuItem = new ContextMenuItem ( label ) ;
// Adding this.
          customContextMenu . customItems . push ( newItem ) ;
// Null handler?
          if ( handler == null )
          {
// URL has to be pushed and a handler defined here as contextMenuUrlItemClicked.
// This will handle the click and will open a browser navigated to the given URL.
            customContextUrls . push ( url ) ;
            customContextHandlers . push ( contextMenuUrlItemClicked ) ;
// Phisically adding this.
            newItem . addEventListener ( ContextMenuEvent . MENU_ITEM_SELECT , contextMenuUrlItemClicked ) ;
          }
          else
          {
// Null url and the custom event handler have to be pushed.
// This handler function can be existing anywhere and can do anything.
            customContextUrls . push ( null ) ;
            customContextHandlers . push ( handler ) ;
// Phisically adding this.
            newItem . addEventListener ( ContextMenuEvent . MENU_ITEM_SELECT , handler ) ;
          }
        }
      }
    }
/*
** Gets the application background image uploaded by the user.
*/
    public function getAppBackgroundUserImage ( ) : ButtonFile
    {
      if ( middleground != null )
      {
        return middleground . getAppBackgroundUserImage ( ) ;
      }
      else
      {
        return null ;
      }
    }
/*
** Removes a custom context menu item specified by its index.
*/
    public function removeContextMenuItem ( i : int ) : void
    {
// A correct index value is expected.
      if ( i < customContextLabels . length && i > 0 )
      {
// The label and the url can be cleared by removing these from the arrays.
        customContextLabels . splice ( i , 1 ) ;
        customContextUrls . splice ( i , 1 ) ;
// The event listener (whatever is this) should be unregistered.
        ContextMenuItem ( customContextMenu . customItems [ i ] ) . removeEventListener ( ContextMenuEvent . MENU_ITEM_SELECT , Function ( customContextHandlers [ i ] ) ) ;
// Now the reference to the handler is also clearable.
        customContextHandlers . splice ( i , 1 ) ;
// Finally: the custom item itself can be cleared.
        customContextMenu . customItems . splice ( i , 1 ) ;
      }
    }
/*
** The event listener handles the clicks on the context menu items.
** This will open a browser and will navigate to the url.
*/
    private function contextMenuUrlItemClicked ( e : ContextMenuEvent ) : void
    {
// Just  abasic validation: the label given by this event has to be existing in the labels array.
      if ( customContextLabels . indexOf ( e . currentTarget . caption ) != - 1 )
      {
// Now the navigation ti the url with a new browser.
        navigateToURL ( new URLRequest ( customContextUrls [ customContextLabels . indexOf ( e . currentTarget . caption ) ] ) , "_blank" ) ;
      }
    }
/*
** Happens when the stage has been resized.
*/
    private function stageResized ( e : Event ) : void
    {
// We will have new sizes to this app.
      setSizeFromStageSize ( ) ;
// New font size has to be calculated if necessary.
      if ( propsDyn . getAppFontSize ( ) == 0 )
      {
        propsDyn . setFontSize ( calcFontSizeFromStageSize ( ) ) ;
      }
    }
/*
** Calculating the font size from the stage.
*/
    public function calcFontSizeFromStageSize ( ) : int
    {
// The new font size will be calculated if the stage is existing.
      if ( stage != null )
      {
        return int ( getsw ( ) * getPropsApp ( ) . getFontSizeFactor ( ) ) ;
      }
      else
      {
        return 12 ;
      }
    }
/*
** Setting the size of the components of these object
** according to the actual size of the stage.
*/
    private function setSizeFromStageSize ( ) : void
    {
// Obviously, the stage object is needed because some of its properties.
      if ( stage != null )
      {
// Setting the width and height of this object (minimum the min sizes are needed).
        super . setswh ( Math . max ( propsApp . getAppSizeMinWidth ( ) , stage . stageWidth ) , Math . max ( propsApp . getAppSizeMinHeight ( ) , stage . stageHeight ) ) ;
// Setting the width and height of the background, middleground and foreground objects.
        if ( background != null )
        {
          background . setswh ( getsw ( ) , getsh ( ) ) ;
        }
        if ( middleground != null )
        {
          middleground . setswh ( getsw ( ) , getsh ( ) ) ;
        }
        if ( foreground != null )
        {
          foreground . setswh ( getsw ( ) , getsh ( ) ) ;
        }
      }
    }
/*
** The set size methods have to have no effects.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Adds a widget into the widgets (located in the middleground).
*/
    public function addWidget ( contentId : int , widget : Widget ) : void
    {
      middleground . addWidget ( contentId , widget ) ;
    }
/*
** Closes a widget (located in the middleground).
*/
    public function closeWidget ( widget : Widget ) : void
    {
      middleground . closeWidget ( widget ) ;
    }
/*
** Gets the background object.
*/
    public function getBackground ( ) : Background
    {
      return background ;
    }
/*
** Gets the middleground object.
*/
    public function getMiddleground ( ) : Middleground
    {
      return middleground ;
    }
/*
** Gets the foreground object.
*/
    public function getForeground ( ) : Foreground
    {
      return foreground ;
    }
/*
** Gets the texts object.
*/
    public function getTexts ( ) : Texts
    {
      return texts ;
    }
/*
** Gets the textStock object.
*/
    public function getTextStock ( ) : TextStock
    {
      return textStock ;
    }
/*
** Gets the properties.
*/
    public function getPropsApp ( ) : PropsApp
    {
      return propsApp ;
    }
    public function getPropsDyn ( ) : PropsDyn
    {
      return propsDyn ;
    }
/*
** For displaying the color.
*/
    public function colorToString ( color : Number ) : String
    {
      var tempString : String = COLOR_RGB_INPUT_ZEROS + color . toString ( 16 ) ;
      return ( tempString . substr ( tempString . length - 6 ) . toUpperCase ( ) ) ;
    }
/*
** The bright or the dark shadow should be applied to the specific color?
*/
    public function brightShadowToApply ( color : String ) : Boolean
    {
// Bright is false by default!
      var bright : Boolean = false ;
// This will be the color, correcting first to be sure this has 6 digits.
      var tempString : String = COLOR_RGB_INPUT_ZEROS + color ;
      tempString = tempString . substr ( tempString . length - 6 ) . toUpperCase ( ) ;
// Bright if all of the 1-2 and 3-4 and 5-6 numbers are less than the bound!
      if ( Number ( COLOR_HEX_TO_NUMBER_STRING + tempString . substr ( 0 , 2 ) ) < TEXT_BRIGHT_DARK_CHANGE_BOUND && Number ( COLOR_HEX_TO_NUMBER_STRING + tempString . substr ( 2 , 2 ) ) < TEXT_BRIGHT_DARK_CHANGE_BOUND && Number ( COLOR_HEX_TO_NUMBER_STRING + tempString . substr ( 4 , 2 ) ) < TEXT_BRIGHT_DARK_CHANGE_BOUND )
      {
        bright = true ;
      }
// Now the return of the bright result.
      return bright ;
    }
/*
** Calling of the recalculation of the contents if the object or its parent is ContentSingle.
*/
    public function callContentSizeRecalc ( theObject : DisplayObject ) : void
    {
// At first: the parent object is defined as the object itself.
      var parentObject : DisplayObject = theObject ;
// Then a loop is needed until this reference is not null:
      while ( parentObject != null )
      {
// Calling the content size recalculation if that object is an instance of the ContentSingle.
        if ( parentObject is ContentSingle )
        {
          ContentSingle ( parentObject ) . contentSizeRecalc ( ) ;
        }
// Let's replace this reference to its own parent.
        parentObject = parentObject . parent ;
      }
    }
/*
** Trims the string.
*/
    public function trim ( str : String ) : String
    {
      if ( str == null )
      {
        return "" ;
      }
      else
      {
        return str . replace ( "/^\s+|\s+$/g" , "" ) ;
      }
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      while ( customContextMenu . customItems . length > 0 )
      {
        removeContextMenuItem ( 0 ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      background = null ;
      middleground = null ;
      foreground = null ;
      texts = null ;
      textStock = null ;
      propsApp = null ;
      propsDyn = null ;
      menuxml = "" ;
      customContextMenu = null ;
      customContextLabels = null ;
      customContextUrls = null ;
      customContextHandlers = null ;
      fileClassIsUsable = false ;
      urlSite = null ;
      urlFiles = null ;
      urlSubmit = null ;
    }
/*
** Tracing developer messages.
** The logic of the filtering is here and not in the tracer class.
*/
    public function trace ( message : String , level : int ) : void
    {
      if ( level >= 0 && level <= 3 )
      {
        if ( level >= traceLevel )
        {
          if ( tracer == null )
          {
            tracer = new Tracer ( ) ;
            addChild ( tracer ) ;
          }
          else
          {
            tracerUp ( ) ;
          }
          tracer . trace ( dateTimeFormatter . format ( new Date ( ) ) + " ( " + level + ( level >= 2 ? "!" : " " ) + " ) |   " + message ) ;
        }
      }
    }
    public function tracerUp ( ) : void
    {
      if ( tracer != null )
      {
        setChildIndex ( tracer , numChildren - 1 ) ;
      }
    }
  }
}
