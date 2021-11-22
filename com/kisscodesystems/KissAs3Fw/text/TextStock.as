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
** TextStock.
** This will be the store of the displayable texts of the application.
** Single texts and lists can be stored.
** The lists contain the text codes.
** The this set of text codes or these text representations
** of the currend langCode can be returned.
** No destroy method, it is constructed one time and we are done.
*/
package com . kisscodesystems . KissAs3Fw . text
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . Event ;
  import flash . system . System ;
  public class TextStock
  {
// Reference to the Application object.
// Protected because we may add some new texts into it.
    protected var application : Application = null ;
// The special array contains the codes of the available languages in the app.
    protected var langCodes : Array = null ;
    protected var langIds : Array = null ;
// This object will store all of the texts.
// Protected because we may add some new texts into it.
    protected var texts : Object = null ;
// Other lists. Protected because in case of adding new languages, these have to be modified.
    protected var textCodesYesNo : Array = null ;
    protected var textCodesOkCancel : Array = null ;
    protected var textCodesBgImageAligns : Array = null ;
    protected var textCodesTextTypes : Array = null ;
    protected var textCodesWidgetsOrientations : Array = null ;
    protected var textCodesDisplayingStyles : Array = null ;
    protected var textCodesRoles : Array = null ;
    protected var textCodesWeekdays : Array = null ;
    protected var textCodesMonths : Array = null ;
    protected var textCodesWidgetModes : Array = null ;
// This is the actual lang code of this application.
    private var langCode : String = null ;
// This event must be dispatched when the code of the language is changed.
    private var eventLangCodeChanged : Event = null ;
/*
** Constructing the text stock object.
*/
    public function TextStock ( applicationRef : Application ) : void
    {
// This is necessary.
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
// Let's create this event object.
      eventLangCodeChanged = new Event ( application . EVENT_LANG_CODE_CHANGED ) ;
// Let's create the arrays of the lang codes.
      langCodes = [ application . getTexts ( ) . LANG_EN ] ;
      langIds = [ 1 ] ;
      textCodesYesNo = [ application . getTexts ( ) . YN_YES , application . getTexts ( ) . YN_NO ] ;
      textCodesOkCancel = [ application . getTexts ( ) . OC_OK , application . getTexts ( ) . OC_CANCEL ] ;
      textCodesBgImageAligns = [ application . getTexts ( ) . BACKGROUND_ALIGN_NONE , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 , application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ] ;
      textCodesTextTypes = [ application . getTexts ( ) . TEXT_TYPE_BRIGHT , application . getTexts ( ) . TEXT_TYPE_MID , application . getTexts ( ) . TEXT_TYPE_DARK ] ;
      textCodesWidgetsOrientations = [ application . getTexts ( ) . ORIENTATION_MANUAL , application . getTexts ( ) . ORIENTATION_VERTICAL , application . getTexts ( ) . ORIENTATION_HORIZONTAL ] ;
      textCodesDisplayingStyles = [ application . getTexts ( ) . DISPLAYING_STYLE_VIEW ] ;
      textCodesRoles = [ application . getTexts ( ) . g ] ;
      textCodesWeekdays = [ application . getTexts ( ) . WEEKDAY_MONDAY , application . getTexts ( ) . WEEKDAY_TUESDAY , application . getTexts ( ) . WEEKDAY_WEDNESDAY , application . getTexts ( ) . WEEKDAY_THURSDAY , application . getTexts ( ) . WEEKDAY_FRIDAY , application . getTexts ( ) . WEEKDAY_SATURDAY , application . getTexts ( ) . WEEKDAY_SUNDAY ] ;
      textCodesMonths = [ application . getTexts ( ) . MONTH_JAN , application . getTexts ( ) . MONTH_FEB , application . getTexts ( ) . MONTH_MAR , application . getTexts ( ) . MONTH_APR , application . getTexts ( ) . MONTH_MAY , application . getTexts ( ) . MONTH_JUN , application . getTexts ( ) . MONTH_JUL , application . getTexts ( ) . MONTH_AUG , application . getTexts ( ) . MONTH_SEP , application . getTexts ( ) . MONTH_OKT , application . getTexts ( ) . MONTH_NOV , application . getTexts ( ) . MONTH_DEC ] ;
      textCodesWidgetModes = [ application . getTexts ( ) . WIDGET_MODE_AUTOMATIC , application . getTexts ( ) . WIDGET_MODE_DESKTOP , application . getTexts ( ) . WIDGET_MODE_MOBILE ] ;
// Let the lang code be the english.
      langCode = langCodes [ 0 ] ;
// This is the object of the texts.
      texts = new Object ( ) ;
// Initializing
      textIni ( ) ;
    }
/*
** Initializing the texts.
*/
    private function textIni ( ) : void
    {
      texts [ langCodes [ 0 ] ] = [ "English" ] ;
      texts [ textCodesYesNo [ 0 ] ] = [ "Yes" ] ;
      texts [ textCodesYesNo [ 1 ] ] = [ "No" ] ;
      texts [ textCodesOkCancel [ 0 ] ] = [ "OK" ] ;
      texts [ textCodesOkCancel [ 1 ] ] = [ "Cancel" ] ;
      texts [ textCodesBgImageAligns [ 0 ] ] = [ "None" ] ;
      texts [ textCodesBgImageAligns [ 1 ] ] = [ "Center 1" ] ;
      texts [ textCodesBgImageAligns [ 2 ] ] = [ "Center 2" ] ;
      texts [ textCodesBgImageAligns [ 3 ] ] = [ "Center 3" ] ;
      texts [ textCodesBgImageAligns [ 4 ] ] = [ "Mosaic" ] ;
      texts [ textCodesTextTypes [ 0 ] ] = [ "Bright" ] ;
      texts [ textCodesTextTypes [ 1 ] ] = [ "Mid" ] ;
      texts [ textCodesTextTypes [ 2 ] ] = [ "Dark" ] ;
      texts [ textCodesWidgetsOrientations [ 0 ] ] = [ "Manual" ] ;
      texts [ textCodesWidgetsOrientations [ 1 ] ] = [ "Vertical" ] ;
      texts [ textCodesWidgetsOrientations [ 2 ] ] = [ "Horizontal" ] ;
      texts [ textCodesWidgetModes [ 0 ] ] = [ "Automatic" ] ;
      texts [ textCodesWidgetModes [ 1 ] ] = [ "Desktop" ] ;
      texts [ textCodesWidgetModes [ 2 ] ] = [ "Mobile" ] ;
      texts [ textCodesDisplayingStyles [ 0 ] ] = [ "View" ] ;
      texts [ textCodesRoles [ 0 ] ] = [ "Guest" ] ;
      texts [ textCodesWeekdays [ 0 ] ] = [ "Mon" ] ;
      texts [ textCodesWeekdays [ 1 ] ] = [ "Tue" ] ;
      texts [ textCodesWeekdays [ 2 ] ] = [ "Wed" ] ;
      texts [ textCodesWeekdays [ 3 ] ] = [ "Thu" ] ;
      texts [ textCodesWeekdays [ 4 ] ] = [ "Fri" ] ;
      texts [ textCodesWeekdays [ 5 ] ] = [ "Sat" ] ;
      texts [ textCodesWeekdays [ 6 ] ] = [ "Sun" ] ;
      texts [ textCodesMonths [ 0 ] ] = [ "Jan" ] ;
      texts [ textCodesMonths [ 1 ] ] = [ "Feb" ] ;
      texts [ textCodesMonths [ 2 ] ] = [ "Mar" ] ;
      texts [ textCodesMonths [ 3 ] ] = [ "Apr" ] ;
      texts [ textCodesMonths [ 4 ] ] = [ "May" ] ;
      texts [ textCodesMonths [ 5 ] ] = [ "Jun" ] ;
      texts [ textCodesMonths [ 6 ] ] = [ "Jul" ] ;
      texts [ textCodesMonths [ 7 ] ] = [ "Aug" ] ;
      texts [ textCodesMonths [ 8 ] ] = [ "Sep" ] ;
      texts [ textCodesMonths [ 9 ] ] = [ "Okt" ] ;
      texts [ textCodesMonths [ 10 ] ] = [ "Nov" ] ;
      texts [ textCodesMonths [ 11 ] ] = [ "Dec" ] ;
      texts [ application . getTexts ( ) . WIDGET_TYPE_GENERAL ] = [ "General widget type" ] ;
      texts [ application . getTexts ( ) . WIDGET_HEADER_GENERAL ] = [ "Widget" ] ;
      texts [ application . getTexts ( ) . LISTS_OF_THE_WIDGETS ] = [ "Jump to here:" ] ;
      texts [ application . getTexts ( ) . LISTS_OF_THE_CONTENTS_TO_MOVE_INTO ] = [ "Select the content to move your widget:" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_GENERAL ] = [ "General" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_LINING ] = [ "Lining" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_COLORING ] = [ "Coloring" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_IMAGING ] = [ "Imaging" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_FONTING ] = [ "Fonting" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_ABOUT ] = [ "About" ] ;
      texts [ application . getTexts ( ) . SETTING_LANGUAGE ] = [ "Language." ] ;
      texts [ application . getTexts ( ) . SETTING_DISPLAYING_STYLE ] = [ "Displaying style." ] ;
      texts [ application . getTexts ( ) . SETTING_NUM_OF_WIDGETCONTAINERS ] = [ "Max desktops." ] ;
      texts [ application . getTexts ( ) . SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS ] = [ "Do you really want to reduce the number of widget containers?" ] ;
      texts [ application . getTexts ( ) . SETTING_CURR_WIDGETCONTAINER ] = [ "Curr desktop." ] ;
      texts [ application . getTexts ( ) . SETTING_WIDGETS_ORIENTATION ] = [ "Widgets orientation." ] ;
      texts [ application . getTexts ( ) . SETTING_WIDGET_MODE ] = [ "Widget mode." ] ;
      texts [ application . getTexts ( ) . SETTING_LINE_THICKNESS ] = [ "Line thickness." ] ;
      texts [ application . getTexts ( ) . SETTING_MARGIN ] = [ "Margin." ] ;
      texts [ application . getTexts ( ) . SETTING_PADDING ] = [ "Padding." ] ;
      texts [ application . getTexts ( ) . SETTING_RADIUS ] = [ "Radius." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_BG_COLOR ] = [ "Background color." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FG_COLOR ] = [ "Foreground color." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_BLUR ] = [ "Background blur." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FILL_ALPHA ] = [ "Background fill alpha." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_ALIGN ] = [ "Background align." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_ALPHA ] = [ "Background alpha." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_LIVE ] = [ "Bg is live." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FIXED ] = [ "Bg is fixed." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_MOVEMENT ] = [ "Background move." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_FACE ] = [ "Font face." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_SIZE ] = [ "Font size." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_COLORS ] = [ "Font colors." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_BOLD ] = [ "Bold fonts." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_ITALIC ] = [ "Italic fonts." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_NORMAL ] = [ "Normal fonts." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_THICKNESS ] = [ "Font thickness." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_SKEWNESS ] = [ "Font skewness." ] ;
      texts [ application . getTexts ( ) . SETTING_SOUND_PLAYING_ON ] = [ "Soundeffects." ] ;
      texts [ application . getTexts ( ) . SETTING_SOUND_PLAYING_OFF ] = [ "Soundeffects." ] ;
      texts [ application . getTexts ( ) . DEFAULT_CONTENT ] = [ "Default content" ] ;
      texts [ application . getTexts ( ) . REQUIRED_PERMISSIONS_ALERT ] = [ "This application needs Camera, Storage and Network permissions.\nPlease, check your settings and grant these permissions to this application for proper working. Perhaps, you need to restart your application." ] ;
      texts [ application . getTexts ( ) . WATCH_TYPE_BASIC ] = [ "Basic" ] ;
      texts [ application . getTexts ( ) . WATCH_TYPE_DIGITAL ] = [ "Digital" ] ;
      texts [ application . getTexts ( ) . WATCH_TYPE_ANALOG ] = [ "Analog" ] ;
      texts [ application . getTexts ( ) . WATCH_TYPE_BINARY ] = [ "Binary" ] ;
      texts [ application . getTexts ( ) . COMPONENTS_USAGE ] = [
      "<p><b>Welcome to KissAs3Fw framework!</b></p>" 
        + application . EMPTY_HTML_PARAGRAPH 
      + "<p>The usage of this component set is readable below.<br/>"
      + "Partly, bacause the components are here which are displayed<br/>"
      + "on the basic application screen. Other components will be<br/>"
      + "described on the other widgets of KissAs3Dm application."
      + "</p>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<p>The Application is the main program, run in that specific window in front of you. "
      + "This contains a header and a body part. In the header, the following elements can be found:"
      + "</p>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<p>Menu button<br/>"
      + "<ul><li>to hold the basic user info and the application menu</li>" 
      + "</p>" 
      + "<p><b>Application name</b><br/>"
      + "<ul><li>a label to hold the name of this application</li>" 
      + "</p>" 
      + "<p><b>Watch</b><br/>"
      + "<ul><li>displays the current time of the client</li>" 
      + "<li>current date and timezone on the background</li>" 
      + "<li>seconds displaying can be set on or off</li>" 
      + "<li>basic, digital, analog and binary time displaying can be set</li>" 
      + "</p>" 
      + "<p>Settings button<br/>"
      + "<ul><li>opens a panel to customize the application</li>" 
      + "<li>language, displaying style, widget containers, widget align</li>" 
      + "<li>automatic or manual switch of mobile or desktop displaying</li>" 
      + "<li>every other attributes of the appearance</li>" 
      + "</p>" 
      + "<ul><b><u>And the main content<br/>(Application-Middleground-Widgets-ContentMultiple)</u></b>" 
      + "<li><u>Area to place Widgets into this.</u></li>" 
      + "<li>Supports multiple contents (widget containers) since version 1.5</li>" 
      + "<li>Simple switch between mobile and desktop appearance since version 1.9.</li>" 
      + "<li>Can be customized in the settings panel if that is available in the app.</li>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>ContentMultiple</b>" 
      + "<li><u>Content handler object (multiple pages).</u></li>" 
      + "<li>On the settings panel for example.</li>" 
      + "<li>Since version 1.5: in Widgets and in the main content.</li>" 
      + "<li>Content selecting: click on the Button bar.</li>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>ContentSingle</b>" 
      + "<li><u>Content handler object (1 page)</u></li>" 
      + "<li>Automatic positioning of the elements inside.</li>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>Icon, IconManager</b>" 
      + "<li>An icon can be specified to a label.</li>" 
      + "<li>This label can be anywhere, for example in the main menu.</li>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>Image</b>" 
      + "<li>An image object which can display a picture from embedded source or from outside (web)</li>" 
      + "<li>The example here is the background</li>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>Widget</b>" 
      + "<li><u>To handle content elements belong each other.</u></li>" 
      + "<li>Multiple content pages since version 1.5!</li>" 
      + "<li><i>     (built-in menu in every single Widget)</i></li>" 
      + "<li>Position: mouse down on the header area and drag</li>" 
      + "<li>Resize: mouse down on the edge of the widget and drag</li>" 
      + "<li>Other widget actions: by the buttons in the header.</li>" 
      + "</ul>" 
      + application . EMPTY_HTML_PARAGRAPH 
      + "<ul><b>XmlLister</b>" 
      + "<li>A ListPanel component that handles directly an xml based data. The application menu is displayed by using this component.</li>" 
      + "<li>The root object is &lt;items&gt; and there can be other &lt;item&gt; elements, in any other depths.</li>"
      + "<li>Possible attributes of the &lt;item&gt; are: opened (0 or 1), icon (string), value (string).</li>" 
      + "<li>The &lt;item&gt; can be opened or closed by mouse or tap if there are child &lt;item&gt; objects.</li>"
      + "</ul>" 
      + application . EMPTY_HTML_PARAGRAPH
      ] ;
      texts [ application . getTexts ( ) . MORE ] = [ "More" ] ;
      texts [ application . getTexts ( ) . SELECTED_FILE ] = [ "Selected: " ] ;
      texts [ application . getTexts ( ) . UPLOADED_FILE ] = [ "Uploaded: " ] ;
      texts [ application . getTexts ( ) . BROWSE ] = [ "browse.." ] ;
      texts [ application . getTexts ( ) . FILE_UPLOAD_IN_PROGRESS ] = [ "Uploading: " ] ;
      texts [ application . getTexts ( ) . ACTIVATE_CAMERA ] = [ "Camera" ] ;
      texts [ application . getTexts ( ) . RELEASE_CAMERA ] = [ "Release" ] ;
      texts [ application . getTexts ( ) . CAMERA_WIDE_RES ] = [ "16:9" ] ;
      texts [ application . getTexts ( ) . CAMERA_NORMAL_RES ] = [ "4:3" ] ;
      texts [ application . getTexts ( ) . CAMERA_SIZE ] = [ "Size:" ] ;
      texts [ application . getTexts ( ) . CAMERA_FPS ] = [ "Fps:" ] ;
      texts [ application . getTexts ( ) . CAMERA_QUALITY ] = [ "Quality:" ] ;
      texts [ application . getTexts ( ) . CAMERA_FILTER ] = [ "Filter:" ] ;
      texts [ application . getTexts ( ) . CAMERA_TAKE_PICTURE ] = [ "Take picture!" ] ;
      texts [ application . getTexts ( ) . REGISTER_BUTTON ] = [ "Register" ] ;
      texts [ application . getTexts ( ) . LOGOUT_BUTTON ] = [ "Logout" ] ;
      texts [ application . getTexts ( ) . PASSWORD_HEADER ] = [ "Password change" ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_CHANGE_SHOULD ] = [ "You should change your password." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_CHANGE_CAN ] = [ "You can change your password." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_CREATE_SHOULD ] = [ "You should create your new password." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_CREATE_CAN ] = [ "You can create your new password." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_IMHERE_SHOULD ] = [ "You should verify that you are here." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_HEADING_PW_IMHERE_CAN ] = [ "You can verify that you are here." ] ;
      texts [ application . getTexts ( ) . PASS_FORM_OLD_PASS ] = [ "Password:" ] ;
      texts [ application . getTexts ( ) . PASS_FORM_NEW_PASS ] = [ "New password:" ] ;
      texts [ application . getTexts ( ) . PASS_FORM_CON_PASS ] = [ "Confirmation:" ] ;
      texts [ application . getTexts ( ) . TODAY ] = [ "T" ] ;
      texts [ application . getTexts ( ) . RESET ] = [ "Reset" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_REALLY_DELETE_EXISTING_BGIMAGE ] = [ "If existing, the backdground image will be deleted.\nDo you want to proceed?" ] ;
      texts [ application . getTexts ( ) . WATCH_SHOW_SECONDS ] = [ "Show seconds" ] ;
      texts [ application . getTexts ( ) . WATCH_WITHOUT_SECONDS ] = [ "Without seconds" ] ;
      texts [ application . getTexts ( ) . CLEAR ] = [ "Clear" ] ;
      texts [ application . getTexts ( ) . DRAW ] = [ "Draw" ] ;
      texts [ application . getTexts ( ) . RUBBER ] = [ "Rubber" ] ;
      texts [ application . getTexts ( ) . REALLY_WANT_TO_CLEAR_DRAWN_CONTENT ] = [ "Do you really want to clear the drawn content?" ] ;
      texts [ application . getTexts ( ) . CAMERA_ON_MOBILE_DEVICES ] = [ "Mobile device?\nRotate to landscape view." ] ;
      texts [ application . getTexts ( ) . CAMERA_ON_MOBILE_DEVICES2 ] = [ "Rotate mobile device to landscape." ] ;
    }
/*
** Destroying this application.
*/
    public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventLangCodeChanged != null )
      {
        eventLangCodeChanged . stopImmediatePropagation ( ) ;
      }
// 4: every reference and value should be resetted to null, 0 or false.
      langCodes = null ;
      langIds = null ;
      textCodesYesNo = null ;
      textCodesOkCancel = null ;
      textCodesBgImageAligns = null ;
      textCodesTextTypes = null ;
      textCodesWidgetsOrientations = null ;
      textCodesDisplayingStyles = null ;
      textCodesRoles = null ;
      textCodesWeekdays = null ;
      textCodesMonths = null ;
      textCodesWidgetModes = null ;
      langCode = null ;
      texts = null ;
      eventLangCodeChanged = null ;
// 3: calling the super destroy.
    }
/*
** Getting a single text.
*/
    public function getText ( textCode : String ) : String
    {
      var s : String = "" ;
      try
      {
        s = texts [ textCode ] [ langCodes . indexOf ( langCode ) ] ;
        if ( s == null )
        {
          s = "" ;
        }
      }
      catch ( e : * )
      {
        application . trace ( "unable to get string to " + textCode , 3 ) ;
      }
      return s ;
    }
/*
** Sets the language code of this application.
*/
    public function setLangCode ( newCode : String ) : void
    {
      if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) || langCode != newCode )
      {
// This is the current value.
        var langCodeOrig : String = langCode ;
// If the given new value is found in the array of languages
        if ( langCodes . indexOf ( newCode ) != - 1 )
        {
// Then this new value is usable.
          langCode = newCode ;
        }
        else
        {
// In this case, the first element of the langCodes array will be set.
          langCode = langCodes [ 0 ] ;
        }
// If the value is changed then this event has to be dispatched thru
// the Application. (Everyone will listen to that custom event dispatcher.)
        if ( langCode != langCodeOrig )
        {
          application . getBaseEventDispatcher ( ) . dispatchEvent ( eventLangCodeChanged ) ;
        }
      }
    }
/*
** Gets the actual language code of this application.
*/
    public function getLangCode ( ) : String
    {
      return langCode ;
    }
/*
** Gets the actual language id of this application.
*/
    public function getLangId ( ) : int
    {
      if ( langCodes . indexOf ( langCode ) != - 1 )
      {
        return langIds [ langCodes . indexOf ( langCode ) ]
      }
      else
      {
        return - 1 ;
      }
    }
/*
** Gets the list (array) of the language ids in this app.
*/
    public function getLangIds ( ) : Array
    {
// This new array will be returned!
      var array : Array = new Array ( ) ;
// Ok, now let's add the elements of the array to the new one.
      for ( var i : int = 0 ; i < langIds . length ; i ++ )
      {
        array . push ( langIds [ i ] ) ;
      }
// Returning this.
      return array ;
    }
/*
** Gets the list (array) of the language codes in this app.
*/
    public function getLangCodes ( ) : Array
    {
// This new array will be returned!
      var array : Array = new Array ( ) ;
// Ok, now let's add the elements of the array to the new one.
      for ( var i : int = 0 ; i < langCodes . length ; i ++ )
      {
        array . push ( langCodes [ i ] ) ;
      }
// Returning this.
      return array ;
    }
/*
** Gets the list (array) of the texts of the language codes in this app.
*/
    public function getLangTexts ( ) : Array
    {
// This new array will be returned!
      var array : Array = new Array ( ) ;
// Ok, now let's add the elements of the array to the new one.
      for ( var i : int = 0 ; i < langCodes . length ; i ++ )
      {
        array . push ( getText ( langCodes [ i ] ) ) ;
      }
// Returning this.
      return array ;
    }
/*
** Similar to the language codes and texts,
** The functions below give the correct array according to the request.
*/
    public function getTextCodesYesNo ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesYesNo . length ; i ++ )
      {
        array . push ( textCodesYesNo [ i ] ) ;
      }
      return array ;
    }
    public function getTextsYesNo ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesYesNo . length ; i ++ )
      {
        array . push ( getText ( textCodesYesNo [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesOkCancel ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesOkCancel . length ; i ++ )
      {
        array . push ( textCodesOkCancel [ i ] ) ;
      }
      return array ;
    }
    public function getTextsOkCancel ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesOkCancel . length ; i ++ )
      {
        array . push ( getText ( textCodesOkCancel [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesBgImageAligns ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesBgImageAligns . length ; i ++ )
      {
        array . push ( textCodesBgImageAligns [ i ] ) ;
      }
      return array ;
    }
    public function getTextsBgImageAligns ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesBgImageAligns . length ; i ++ )
      {
        array . push ( getText ( textCodesBgImageAligns [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesTextTypes ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesTextTypes . length ; i ++ )
      {
        array . push ( textCodesTextTypes [ i ] ) ;
      }
      return array ;
    }
    public function getTextsTextTypes ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesTextTypes . length ; i ++ )
      {
        array . push ( getText ( textCodesTextTypes [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesWidgetsOrientations ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWidgetsOrientations . length ; i ++ )
      {
        array . push ( textCodesWidgetsOrientations [ i ] ) ;
      }
      return array ;
    }
    public function getTextsWidgetsOrientations ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWidgetsOrientations . length ; i ++ )
      {
        array . push ( getText ( textCodesWidgetsOrientations [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesWidgetModes ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWidgetModes . length ; i ++ )
      {
        array . push ( textCodesWidgetModes [ i ] ) ;
      }
      return array ;
    }
    public function getTextsWidgetModes ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWidgetModes . length ; i ++ )
      {
        array . push ( getText ( textCodesWidgetModes [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesDisplayingStyles ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesDisplayingStyles . length ; i ++ )
      {
        array . push ( textCodesDisplayingStyles [ i ] ) ;
      }
      return array ;
    }
    public function getTextsDisplayingStyles ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesDisplayingStyles . length ; i ++ )
      {
        array . push ( getText ( textCodesDisplayingStyles [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesRoles ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesRoles . length ; i ++ )
      {
        array . push ( textCodesRoles [ i ] ) ;
      }
      return array ;
    }
    public function getTextsRoles ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesRoles . length ; i ++ )
      {
        array . push ( getText ( textCodesRoles [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesWeekdays ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWeekdays . length ; i ++ )
      {
        array . push ( textCodesWeekdays [ i ] ) ;
      }
      return array ;
    }
    public function getTextsWeekdays ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesWeekdays . length ; i ++ )
      {
        array . push ( getText ( textCodesWeekdays [ i ] ) ) ;
      }
      return array ;
    }
    public function getTextCodesMonths ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesMonths . length ; i ++ )
      {
        array . push ( textCodesMonths [ i ] ) ;
      }
      return array ;
    }
    public function getTextsMonths ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesMonths . length ; i ++ )
      {
        array . push ( getText ( textCodesMonths [ i ] ) ) ;
      }
      return array ;
    }
  }
}
