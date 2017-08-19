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
// The background images.
    protected var textCodesBgImagePics : Array = null ;
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
      textCodesYesNo = [ application . getTexts ( ) . YN_YES , application . getTexts ( ) . YN_NO ] ;
      textCodesOkCancel = [ application . getTexts ( ) . OC_OK , application . getTexts ( ) . OC_CANCEL ] ;
      textCodesBgImagePics = [ application . getTexts ( ) . BACKGROUND_IMAGE_BG1 ] ;
      textCodesBgImageAligns = [ application . getTexts ( ) . BACKGROUND_ALIGN_NONE , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER1 , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER2 , application . getTexts ( ) . BACKGROUND_ALIGN_CENTER3 , application . getTexts ( ) . BACKGROUND_ALIGN_MOSAIC ] ;
      textCodesTextTypes = [ application . getTexts ( ) . TEXT_TYPE_BRIGHT , application . getTexts ( ) . TEXT_TYPE_MID , application . getTexts ( ) . TEXT_TYPE_DARK ] ;
      textCodesWidgetsOrientations = [ application . getTexts ( ) . ORIENTATION_MANUAL , application . getTexts ( ) . ORIENTATION_VERTICAL , application . getTexts ( ) . ORIENTATION_HORIZONTAL ] ;
      textCodesDisplayingStyles = [ application . getTexts ( ) . DISPLAYING_STYLE_MODIFIED , application . getTexts ( ) . DISPLAYING_STYLE_BASIC ] ;
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
      texts [ textCodesBgImagePics [ 0 ] ] = [ "Background 1" ] ;
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
      texts [ textCodesDisplayingStyles [ 0 ] ] = [ "Modified" ] ;
      texts [ textCodesDisplayingStyles [ 1 ] ] = [ "Basic" ] ;
      texts [ application . getTexts ( ) . WIDGET_TYPE_GENERAL ] = [ "General widget type" ] ;
      texts [ application . getTexts ( ) . WIDGET_HEADER_GENERAL ] = [ "Widget" ] ;
      texts [ application . getTexts ( ) . LISTS_OF_THE_WIDGETS ] = [ "Click on the widget to navigate there:" ] ;
      texts [ application . getTexts ( ) . LISTS_OF_THE_CONTENTS_TO_MOVE_INTO ] = [ "Select the content to move your widget:" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_GENERAL ] = [ "General" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_LINING ] = [ "Lining" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_COLORING ] = [ "Coloring" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_IMAGING ] = [ "Imaging" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_FONTING ] = [ "Fonting" ] ;
      texts [ application . getTexts ( ) . SETTINGS_PANEL_ABOUT ] = [ "About" ] ;
      texts [ application . getTexts ( ) . SETTING_LANGUAGE ] = [ "Language." ] ;
      texts [ application . getTexts ( ) . SETTING_DISPLAYING_STYLE ] = [ "Displaying style." ] ;
      texts [ application . getTexts ( ) . SETTING_NUM_OF_WIDGETCONTAINERS ] = [ "Max containers." ] ;
      texts [ application . getTexts ( ) . SETTING_CURR_WIDGETCONTAINER ] = [ "Curr container." ] ;
      texts [ application . getTexts ( ) . SETTING_WIDGET_ORIENTATION ] = [ "Widgets orientation." ] ;
      texts [ application . getTexts ( ) . SETTING_LINE_THICKNESS ] = [ "Line thickness." ] ;
      texts [ application . getTexts ( ) . SETTING_MARGIN ] = [ "Margin." ] ;
      texts [ application . getTexts ( ) . SETTING_PADDING ] = [ "Padding." ] ;
      texts [ application . getTexts ( ) . SETTING_RADIUS ] = [ "Radiuses." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_BG_COLOR ] = [ "Background color." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FG_COLOR ] = [ "Foreground color." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FILL_ALPHA ] = [ "Background fill alpha." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_IMAGE ] = [ "Background image." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_ALIGN ] = [ "Background align." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_ALPHA ] = [ "Background alpha." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_LIVE ] = [ "Bg is live." ] ;
      texts [ application . getTexts ( ) . SETTING_BACKGROUND_FIXED ] = [ "Bg is fixed." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_FACE ] = [ "Font face." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_SIZE ] = [ "Font size." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_COLORS ] = [ "Font colors." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_BOLD ] = [ "Bold fonts." ] ;
      texts [ application . getTexts ( ) . SETTING_FONT_ITALIC ] = [ "Italic fonts." ] ;
      texts [ application . getTexts ( ) . DEFAULT_CONTENT ] = [ "Default content" ] ;
      texts [ application . getTexts ( ) . COMPONENTS_USAGE ] = [ "<p><b>Welcome to KissAs3Fw framework!</b></p>" + application . EMPTY_HTML_PARAGRAPH + "<p>The usage of this component set is readable below.</p>" + application . EMPTY_HTML_PARAGRAPH + "<p><i>If two rectangles can be found in each other then the content can be moved after a left mouse button down (on a clean area).</i></p>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b><u>Main content<br/>(Application-Middleground-Widgets-contentMultiple)</u></b>" + "<li><u>Area to place Widgets into this.</u></li>" + "<li>Supports multiple contents (widget containers) since version 1.5</li>" + "<li>Can be customized in the settings panel if that is available in the app.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ButtonBar</b>" + "<li><u>A set of ButtonLinks.</u></li>" + "<li>One can be active or none of the buttons.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ButtonDraw</b>" + "<li><u>A button object with drawed shape.</u></li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ButtonFile</b>" + "<li><u>File browser component.</u></li>" + "<li>Air context: the filesystem is viewed in an own browsable list.</li>" + "<li>Web context: we can choose a file from the file browser of the operating system.</li>" + "<li>(Decides automatically, try the demo applications in webbrowser and on android device, the same codebase has been built.)</li>" + "<li>Choosable files by FileFilter in both cases.</li>" + "<li>File or FileReference objects can be set from outside.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ButtonLink</b>" + "<li><u>A link object which is clickable.</u></li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ButtonText</b>" + "<li><u>Simple button object with displayed text.</u></li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>Camera</b>" + "<li><u>Camera view with settings.</u></li>" + "<li>Catching and releasing of the camera.</li>" + "<li>Chooses camera if multiple camera objects are available.</li>" + "<li>Takes and saves photos.</li>" + "<li>Can modify the camera view: size, fps, quality, aspect ratio, filters.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>Color</b>" + "<li><u>Color chooser panel.</u></li>" + "<li>Selecting the default color: click on the default color shape.</li>" + "<li>Get any color from the stage: mouse down on the temporary color shape and mouse drag.</li>" + "<li>Specify any color with RGB: type into the input field.</li>" + "<li>Selecting predefined color: click on the small rects or on the colored bar.</li>" + "<li>Double click on the aboves: commits the color immediately.</li>" + "<li>Color commit: click on the OK button.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ColorPicker</b>" + "<li><u>Selects a color with the Color object.</u></li>" + "<li>To get work: click on the colored shape.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ContentMultiple</b>" + "<li><u>Content handler object (multiple pages).</u></li>" + "<li>On the settings panel for example.</li>" + "<li>Since version 1.5: in Widgets and in the main content.</li>" + "<li>Content selecting: click on the Button bar.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ContentSingle</b>" + "<li><u>Content handler object (1 page)</u></li>" + "<li>Automatic positioning of the elements inside.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>List</b>" + "<li><u>A set of one or more selectable items.</u></li>" + "<li>Select: click on an item.</li>" + "<li>Position: mouse down on the list and drag.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>ListPicker</b>" + "<li><u>List having one selectable item, in one line.</u></li>" + "<li>(Like combobox.)</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>Potmet</b>" + "<li><u>Displays numbers between ranges.</u></li>" + "<li>Minimum maximum and increment values.</li>" + "<li>Precision can be set.</li>" + "<li>Value changing: click on potmet and drag.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>Switcher</b>" + "<li><u>Object with 2 states.</u></li>" + "<li>To visualize Boolean data (true or false: turned up or down)</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>TextArea</b>" + "<li><u>To edit multiline texts.</u></li>" + "<li>Position: mouse down on the text area and drag</li>" + "<li>Edit mode: click on the text.</li>" + "<li>Read mode: click elsewhere.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>TextBox</b>" + "<li><u>To display multiline texts.</u></li>" + "<li>Position: mouse down on the text area and drag</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>TextInput</b>" + "<li><u>Single line input field.</u></li>" + "<li>Password or default text displaying.</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>TextLabel</b>" + "<li><u>To display single line or multi line texts.</u></li>" + "<li>3 types (different font colors)</li>" + application . EMPTY_HTML_PARAGRAPH + "<ul><b>Widget</b>" + "<li><u>To handle content elements belong each other.</u></li>" + "<li>Multiple content pages since version 1.5!</li>" + "<li><i>     (built-in menu in every single Widget)</i></li>" + "<li>Position: mouse down on the header area and drag</li>" + "<li>Resize: mouse down on the edge of the widget and drag</li>" + "<li>Hide - unhide: click on the header area</li>" + "<li>Navigate: click on the = icon (on every widgets)</li>" + "<li>To jump to the previous or to next Widget: ^ or ˇ buttons.</li>" + "<li>Moving Widget into another widget container: > button.</li>" + "<li>Close: double click on the header label</li>" + "</ul>" + application . EMPTY_HTML_PARAGRAPH ] ;
      texts [ application . getTexts ( ) . SELECTED_FILE ] = [ "Selected file: " ] ;
      texts [ application . getTexts ( ) . UPLOADED_FILE ] = [ "Uploaded file: " ] ;
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
      texts [ application . getTexts ( ) . CAMERA_PICTURE_SAVED_WEB ] = [ "Picture is saved." ] ;
      texts [ application . getTexts ( ) . CAMERA_PICTURE_SAVED_AIR ] = [ "Pic in user dir." ] ;
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
      textCodesYesNo = null ;
      textCodesOkCancel = null ;
      textCodesBgImagePics = null ;
      textCodesBgImageAligns = null ;
      textCodesTextTypes = null ;
      textCodesWidgetsOrientations = null ;
      textCodesDisplayingStyles = null ;
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
      var s : String = texts [ textCode ] [ langCodes . indexOf ( langCode ) ] ;
      if ( s == null )
      {
        s = "" ;
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
    public function getTextCodesBgImagePics ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesBgImagePics . length ; i ++ )
      {
        array . push ( textCodesBgImagePics [ i ] ) ;
      }
      return array ;
    }
    public function getTextsBgImagePics ( ) : Array
    {
      var array : Array = new Array ( ) ;
      for ( var i : int = 0 ; i < textCodesBgImagePics . length ; i ++ )
      {
        array . push ( getText ( textCodesBgImagePics [ i ] ) ) ;
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
  }
}