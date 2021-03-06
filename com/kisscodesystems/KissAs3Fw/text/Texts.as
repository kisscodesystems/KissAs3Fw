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
** Texts.
** This will contain all of the language codes usable in this application.
** Language code means: a string that can be represented differently on different languages.
** These codes should start and end with specific strings that can be handled in the BaseTextField class.
*/
package com . kisscodesystems . KissAs3Fw . text
{
  public class Texts
  {
// The text code beginning and ending.
// Will be used in the displaying of the text in BaseTextField class.
    public const BTC : String = "btxtcd" ;
    public const ETC : String = "etxtcd" ;
// Language codes of this application.
    public const LANG_EN : String = BTC + "LANG_EN" + ETC ;
// Yes and No.
    public const YN_YES : String = BTC + "YN_YES" + ETC ;
    public const YN_NO : String = BTC + "YN_NO" + ETC ;
// Ok and Cancel.
    public const OC_OK : String = BTC + "OC_OK" + ETC ;
    public const OC_CANCEL : String = BTC + "OC_CANCEL" + ETC ;
// The names of background images.
    public const BACKGROUND_IMAGE_BG1 : String = BTC + "BACKGROUND_IMAGE_BG1" + ETC ;
// The types of aligning of the background picture.
    public const BACKGROUND_ALIGN_NONE : String = BTC + "BACKGROUND_ALIGN_NONE" + ETC ;
    public const BACKGROUND_ALIGN_CENTER1 : String = BTC + "BACKGROUND_ALIGN_CENTER1" + ETC ;
    public const BACKGROUND_ALIGN_CENTER2 : String = BTC + "BACKGROUND_ALIGN_CENTER2" + ETC ;
    public const BACKGROUND_ALIGN_CENTER3 : String = BTC + "BACKGROUND_ALIGN_CENTER3" + ETC ;
    public const BACKGROUND_ALIGN_MOSAIC : String = BTC + "BACKGROUND_ALIGN_MOSAIC" + ETC ;
// The types of the text types (formats) usable in this application.
    public const TEXT_TYPE_BRIGHT : String = BTC + "TEXT_TYPE_BRIGHT" + ETC ;
    public const TEXT_TYPE_MID : String = BTC + "TEXT_TYPE_MID" + ETC ;
    public const TEXT_TYPE_DARK : String = BTC + "TEXT_TYPE_DARK" + ETC ;
// The orientations of the widgets
    public const ORIENTATION_MANUAL : String = BTC + "ORIENTATION_MANUAL" + ETC ;
    public const ORIENTATION_VERTICAL : String = BTC + "ORIENTATION_VERTICAL" + ETC ;
    public const ORIENTATION_HORIZONTAL : String = BTC + "ORIENTATION_HORIZONTAL" + ETC ;
// The displayable styles by default.
    public const DISPLAYING_STYLE_BASIC : String = BTC + "DISPLAYING_STYLE_BASIC" + ETC ;
// Types of the widgets.
    public const WIDGET_TYPE_GENERAL : String = BTC + "WIDGET_TYPE_GENERAL" + ETC ;
// The headers of the widgets.
    public const WIDGET_HEADER_GENERAL : String = BTC + "WIDGET_HEADER_GENERAL" + ETC ;
// The list of the widgets.
    public const LISTS_OF_THE_WIDGETS : String = BTC + "LISTS_OF_THE_WIDGETS" + ETC ;
// The list of the contents.
    public const LISTS_OF_THE_CONTENTS_TO_MOVE_INTO : String = BTC + "LISTS_OF_THE_CONTENTS_TO_MOVE_INTO" + ETC ;
// Te panels of the settings.
    public const SETTINGS_PANEL_GENERAL : String = BTC + "SETTINGS_PANEL_GENERAL" + ETC ;
    public const SETTINGS_PANEL_LINING : String = BTC + "SETTINGS_PANEL_LINING" + ETC ;
    public const SETTINGS_PANEL_COLORING : String = BTC + "SETTINGS_PANEL_COLORING" + ETC ;
    public const SETTINGS_PANEL_IMAGING : String = BTC + "SETTINGS_PANEL_IMAGING" + ETC ;
    public const SETTINGS_PANEL_FONTING : String = BTC + "SETTINGS_PANEL_FONTING" + ETC ;
    public const SETTINGS_PANEL_ABOUT : String = BTC + "SETTINGS_PANEL_ABOUT" + ETC ;
// The labels of the settings.
    public const SETTING_LANGUAGE : String = BTC + "SETTING_LANGUAGE" + ETC ;
    public const SETTING_DISPLAYING_STYLE : String = BTC + "SETTING_DISPLAYING_STYLE" + ETC ;
    public const SETTING_NUM_OF_WIDGETCONTAINERS : String = BTC + "SETTING_NUM_OF_WIDGETCONTAINERS" + ETC ;
    public const SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS : String = BTC + "SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS" + ETC ;
    public const SETTING_CURR_WIDGETCONTAINER : String = BTC + "SETTING_CURR_WIDGETCONTAINER" + ETC ;
    public const SETTING_WIDGET_ORIENTATION : String = BTC + "SETTING_WIDGET_ORIENTATION" + ETC ;
    public const SETTING_LINE_THICKNESS : String = BTC + "SETTING_LINE_THICKNESS" + ETC ;
    public const SETTING_MARGIN : String = BTC + "SETTING_MARGIN" + ETC ;
    public const SETTING_PADDING : String = BTC + "SETTING_PADDING" + ETC ;
    public const SETTING_RADIUS : String = BTC + "SETTING_RADIUS" + ETC ;
    public const SETTING_BACKGROUND_BG_COLOR : String = BTC + "SETTING_BACKGROUND_BG_COLOR" + ETC ;
    public const SETTING_BACKGROUND_FG_COLOR : String = BTC + "SETTING_BACKGROUND_FG_COLOR" + ETC ;
    public const SETTING_BACKGROUND_FILL_ALPHA : String = BTC + "SETTING_BACKGROUND_FILL_ALPHA" + ETC ;
    public const SETTING_BACKGROUND_IMAGE : String = BTC + "SETTING_BACKGROUND_IMAGE" + ETC ;
    public const SETTING_BACKGROUND_ALIGN : String = BTC + "SETTING_BACKGROUND_ALIGN" + ETC ;
    public const SETTING_BACKGROUND_ALPHA : String = BTC + "SETTING_BACKGROUND_ALPHA" + ETC ;
    public const SETTING_BACKGROUND_LIVE : String = BTC + "SETTING_BACKGROUND_LIVE" + ETC ;
    public const SETTING_BACKGROUND_FIXED : String = BTC + "SETTING_BACKGROUND_FIXED" + ETC ;
    public const SETTING_FONT_FACE : String = BTC + "SETTING_FONT_FACE" + ETC ;
    public const SETTING_FONT_SIZE : String = BTC + "SETTING_FONT_SIZE" + ETC ;
    public const SETTING_FONT_COLORS : String = BTC + "SETTING_FONT_COLORS" + ETC ;
    public const SETTING_FONT_BOLD : String = BTC + "SETTING_FONT_BOLD" + ETC ;
    public const SETTING_FONT_ITALIC : String = BTC + "SETTING_FONT_ITALIC" + ETC ;
// The default content of the multiple content component.
    public const DEFAULT_CONTENT : String = BTC + "DEFAULT_CONTENT" + ETC ;
// The usage of the components.
    public const COMPONENTS_USAGE : String = BTC + "COMPONENTS_USAGE" + ETC ;
// The selected file and browse labels on the file button + the begin label of progress.
    public const SELECTED_FILE : String = BTC + "SELECTED_FILE" + ETC ;
    public const UPLOADED_FILE : String = BTC + "UPLOADED_FILE" + ETC ;
    public const BROWSE : String = BTC + "BROWSE" + ETC ;
    public const FILE_UPLOAD_IN_PROGRESS : String = BTC + "FILE_UPLOAD_IN_PROGRESS" + ETC ;
// Camera activate and release links.
    public const ACTIVATE_CAMERA : String = BTC + "ACTIVATE_CAMERA" + ETC ;
    public const RELEASE_CAMERA : String = BTC + "RELEASE_CAMERA" + ETC ;
    public const CAMERA_WIDE_RES : String = BTC + "CAMERA_WIDE_RES" + ETC ;
    public const CAMERA_NORMAL_RES : String = BTC + "CAMERA_NORMAL_RES" + ETC ;
    public const CAMERA_SIZE : String = BTC + "CAMERA_SIZE" + ETC ;
    public const CAMERA_FPS : String = BTC + "CAMERA_FPS" + ETC ;
    public const CAMERA_QUALITY : String = BTC + "CAMERA_QUALITY" + ETC ;
    public const CAMERA_FILTER : String = BTC + "CAMERA_FILTER" + ETC ;
    public const CAMERA_TAKE_PICTURE : String = BTC + "CAMERA_TAKE_PICTURE" + ETC ;
    public const TODAY : String = BTC + "TODAY" + ETC ;
// To the menu panel
    public const PROFILE_ROLE_LOGINTIME_SEP : String = BTC + "PROFILE_ROLE_LOGINTIME_SEP" + ETC ;
    public const REGISTER_BUTTON : String = BTC + "REGISTER_BUTTON" + ETC ;
    public const LOGOUT_BUTTON : String = BTC + "LOGOUT_BUTTON" + ETC ;
// The elements of the password change.
    public const CHANGE_PASSWORD_HEADER : String = BTC + "CHANGE_PASSWORD_HEADER" + ETC ;
    public const CHANGE_PASS_FORM_HEADING_CAN : String = BTC + "CHANGE_PASS_FORM_HEADING_CAN" + ETC ;
    public const CHANGE_PASS_FORM_HEADING_SHOULD : String = BTC + "CHANGE_PASS_FORM_HEADING_SHOULD" + ETC ;
    public const CHANGE_PASS_FORM_OLD_PASS : String = BTC + "CHANGE_PASS_FORM_OLD_PASS" + ETC ;
    public const CHANGE_PASS_FORM_NEW_PASS : String = BTC + "CHANGE_PASS_FORM_NEW_PASS" + ETC ;
    public const CHANGE_PASS_FORM_VERIFY_PASS : String = BTC + "CHANGE_PASS_FORM_VERIFY_PASS" + ETC ;
// Role texts
    public const g : String = BTC + "g" + ETC ;
// The days of the week.
    public const WEEKDAY_MONDAY : String = BTC + "WEEKDAY_MONDAY" + ETC ;
    public const WEEKDAY_TUESDAY : String = BTC + "WEEKDAY_TUESDAY" + ETC ;
    public const WEEKDAY_WEDNESDAY : String = BTC + "WEEKDAY_WEDNESDAY" + ETC ;
    public const WEEKDAY_THURSDAY : String = BTC + "WEEKDAY_THURSDAY" + ETC ;
    public const WEEKDAY_FRIDAY : String = BTC + "WEEKDAY_FRIDAY" + ETC ;
    public const WEEKDAY_SATURDAY : String = BTC + "WEEKDAY_SATURDAY" + ETC ;
    public const WEEKDAY_SUNDAY : String = BTC + "WEEKDAY_SUNDAY" + ETC ;
// The months of the year.
    public const MONTH_JAN : String = BTC + "MONTH_JAN" + ETC ;
    public const MONTH_FEB : String = BTC + "MONTH_FEB" + ETC ;
    public const MONTH_MAR : String = BTC + "MONTH_MAR" + ETC ;
    public const MONTH_APR : String = BTC + "MONTH_APR" + ETC ;
    public const MONTH_MAY : String = BTC + "MONTH_MAY" + ETC ;
    public const MONTH_JUN : String = BTC + "MONTH_JUN" + ETC ;
    public const MONTH_JUL : String = BTC + "MONTH_JUL" + ETC ;
    public const MONTH_AUG : String = BTC + "MONTH_AUG" + ETC ;
    public const MONTH_SEP : String = BTC + "MONTH_SEP" + ETC ;
    public const MONTH_OKT : String = BTC + "MONTH_OKT" + ETC ;
    public const MONTH_NOV : String = BTC + "MONTH_NOV" + ETC ;
    public const MONTH_DEC : String = BTC + "MONTH_DEC" + ETC ;
// Dateformats
    public const DF_VALUE_DMYT : String = "DD.Mon.YYYY HH24:MI:SS"
    public const DF_VALUE_MDYT : String = "Mon/DD/YYYY HH24:MI:SS"
    public const DF_VALUE_YMDT : String = "YYYY-MM-DD HH24:MI:SS"
    public const DF_LABEL_DMYT : String = "20.Dec.2012" ;
    public const DF_LABEL_MDYT : String = "Dec/20/2012" ;
    public const DF_LABEL_YMDT : String = "2012-12-20" ;
// To get date format values and labels.
    public function getDateFormatValues ( ) : Array
    {
      var array : Array = new Array ( ) ;
      array . push ( DF_VALUE_DMYT ) ;
      array . push ( DF_VALUE_MDYT ) ;
      array . push ( DF_VALUE_YMDT ) ;
      return array ;
    }
    public function getDateFormatLabels ( ) : Array
    {
      var array : Array = new Array ( ) ;
      array . push ( DF_LABEL_DMYT ) ;
      array . push ( DF_LABEL_MDYT ) ;
      array . push ( DF_LABEL_YMDT ) ;
      return array ;
    }
// The translations of the dateformats from database to as3!
    public function translateDateFormatFromDBtoAS ( df : String , timeNeeded : Boolean ) : String
    {
      if ( df != null )
      {
        var regExp : RegExp = new RegExp ( "_" , "g" ) ;
        return df . replace ( "d" , "dd" ) . replace ( "m" , "MM" ) . replace ( "Y" , "yyyy" ) . replace ( "T" , timeNeeded ? "hh:mm:ss" : "" ) . replace ( " " , timeNeeded ? " " : "" ) . replace ( regExp , "" ) ;
      }
      return "" ;
    }
  }
}
