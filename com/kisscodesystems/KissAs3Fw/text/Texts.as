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
// The orientations of the widgets
    public const WIDGET_MODE_AUTOMATIC : String = BTC + "WIDGET_MODE_AUTOMATIC" + ETC ;
    public const WIDGET_MODE_DESKTOP : String = BTC + "WIDGET_MODE_DESKTOP" + ETC ;
    public const WIDGET_MODE_MOBILE : String = BTC + "WIDGET_MODE_MOBILE" + ETC ;
// the watch
    public const WATCH_SHOW_SECONDS : String = BTC + "WATCH_SHOW_SECONDS" + ETC ;
    public const WATCH_WITHOUT_SECONDS : String = BTC + "WATCH_WITHOUT_SECONDS" + ETC ;
// The displayable styles by default.
    public const DISPLAYING_STYLE_VIEW : String = BTC + "DISPLAYING_STYLE_VIEW" + ETC ;
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
    public const SETTINGS_PANEL_REALLY_DELETE_EXISTING_BGIMAGE : String = BTC + "SETTINGS_PANEL_REALLY_DELETE_EXISTING_BGIMAGE" + ETC ;
// The labels of the settings.
    public const SETTING_LANGUAGE : String = BTC + "SETTING_LANGUAGE" + ETC ;
    public const SETTING_DISPLAYING_STYLE : String = BTC + "SETTING_DISPLAYING_STYLE" + ETC ;
    public const SETTING_NUM_OF_WIDGETCONTAINERS : String = BTC + "SETTING_NUM_OF_WIDGETCONTAINERS" + ETC ;
    public const SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS : String = BTC + "SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS" + ETC ;
    public const SETTING_CURR_WIDGETCONTAINER : String = BTC + "SETTING_CURR_WIDGETCONTAINER" + ETC ;
    public const SETTING_WIDGETS_ORIENTATION : String = BTC + "SETTING_WIDGETS_ORIENTATION" + ETC ;
    public const SETTING_WIDGET_MODE : String = BTC + "SETTING_WIDGET_MODE" + ETC ;
    public const SETTING_LINE_THICKNESS : String = BTC + "SETTING_LINE_THICKNESS" + ETC ;
    public const SETTING_MARGIN : String = BTC + "SETTING_MARGIN" + ETC ;
    public const SETTING_PADDING : String = BTC + "SETTING_PADDING" + ETC ;
    public const SETTING_RADIUS : String = BTC + "SETTING_RADIUS" + ETC ;
    public const SETTING_BACKGROUND_BG_COLOR : String = BTC + "SETTING_BACKGROUND_BG_COLOR" + ETC ;
    public const SETTING_BACKGROUND_FG_COLOR : String = BTC + "SETTING_BACKGROUND_FG_COLOR" + ETC ;
    public const SETTING_BACKGROUND_BLUR : String = BTC + "SETTING_BACKGROUND_BLUR" + ETC ;
    public const SETTING_BACKGROUND_FILL_ALPHA : String = BTC + "SETTING_BACKGROUND_FILL_ALPHA" + ETC ;
    public const SETTING_BACKGROUND_ALIGN : String = BTC + "SETTING_BACKGROUND_ALIGN" + ETC ;
    public const SETTING_BACKGROUND_ALPHA : String = BTC + "SETTING_BACKGROUND_ALPHA" + ETC ;
    public const SETTING_BACKGROUND_LIVE : String = BTC + "SETTING_BACKGROUND_LIVE" + ETC ;
    public const SETTING_BACKGROUND_FIXED : String = BTC + "SETTING_BACKGROUND_FIXED" + ETC ;
    public const SETTING_BACKGROUND_MOVEMENT : String = BTC + "SETTING_BACKGROUND_MOVEMENT" + ETC ;
    public const SETTING_FONT_FACE : String = BTC + "SETTING_FONT_FACE" + ETC ;
    public const SETTING_FONT_SIZE : String = BTC + "SETTING_FONT_SIZE" + ETC ;
    public const SETTING_FONT_COLORS : String = BTC + "SETTING_FONT_COLORS" + ETC ;
    public const SETTING_FONT_BOLD : String = BTC + "SETTING_FONT_BOLD" + ETC ;
    public const SETTING_FONT_ITALIC : String = BTC + "SETTING_FONT_ITALIC" + ETC ;
    public const SETTING_FONT_NORMAL : String = BTC + "SETTING_FONT_NORMAL" + ETC ;
    public const SETTING_FONT_SKEWNESS : String = BTC + "SETTING_FONT_SKEWNESS" + ETC ;
    public const SETTING_FONT_THICKNESS : String = BTC + "SETTING_FONT_THICKNESS" + ETC ;
    public const SETTING_SOUND_PLAYING_ON : String = BTC + "SETTING_SOUND_PLAYING_ON" + ETC ;
    public const SETTING_SOUND_PLAYING_OFF : String = BTC + "SETTING_SOUND_PLAYING_OFF" + ETC ;
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
    public const RESET : String = BTC + "RESET" + ETC ;
// To the menu panel
    public const REGISTER_BUTTON : String = BTC + "REGISTER_BUTTON" + ETC ;
    public const LOGOUT_BUTTON : String = BTC + "LOGOUT_BUTTON" + ETC ;
// The elements of the password change.
    public const PASSWORD_HEADER : String = BTC + "PASSWORD_HEADER" + ETC ;
    public const PASS_FORM_HEADING_PW_CHANGE_SHOULD : String = BTC + "PASS_FORM_HEADING_PW_CHANGE_SHOULD" + ETC ;
    public const PASS_FORM_HEADING_PW_CREATE_SHOULD : String = BTC + "PASS_FORM_HEADING_PW_CREATE_SHOULD" + ETC ;
    public const PASS_FORM_HEADING_PW_IMHERE_SHOULD : String = BTC + "PASS_FORM_HEADING_PW_IMHERE_SHOULD" + ETC ;
    public const PASS_FORM_HEADING_PW_CHANGE_CAN : String = BTC + "PASS_FORM_HEADING_PW_CHANGE_CAN" + ETC ;
    public const PASS_FORM_HEADING_PW_CREATE_CAN : String = BTC + "PASS_FORM_HEADING_PW_CREATE_CAN" + ETC ;
    public const PASS_FORM_HEADING_PW_IMHERE_CAN : String = BTC + "PASS_FORM_HEADING_PW_IMHERE_CAN" + ETC ;
    public const PASS_FORM_OLD_PASS : String = BTC + "PASS_FORM_OLD_PASS" + ETC ;
    public const PASS_FORM_NEW_PASS : String = BTC + "PASS_FORM_NEW_PASS" + ETC ;
    public const PASS_FORM_CON_PASS : String = BTC + "PASS_FORM_CON_PASS" + ETC ;
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
// Watch types
    public const WATCH_TYPE_BASIC : String = BTC + "WATCH_TYPE_BASIC" + ETC ;
    public const WATCH_TYPE_DIGITAL : String = BTC + "WATCH_TYPE_DIGITAL" + ETC ;
    public const WATCH_TYPE_ANALOG : String = BTC + "WATCH_TYPE_ANALOG" + ETC ;
    public const WATCH_TYPE_BINARY : String = BTC + "WATCH_TYPE_BINARY" + ETC ;
// Others
    public const CLEAR : String = BTC + "CLEAR" + ETC ;
    public const DRAW : String = BTC + "DRAW" + ETC ;
    public const RUBBER : String = BTC + "RUBBER" + ETC ;
    public const REALLY_WANT_TO_CLEAR_DRAWN_CONTENT : String = BTC + "REALLY_WANT_TO_CLEAR_DRAWN_CONTENT" + ETC ;
    public const REQUIRED_PERMISSIONS_ALERT : String = BTC + "REQUIRED_PERMISSIONS_ALERT" + ETC ;
    public const MORE : String = BTC + "MORE" + ETC ;
    public const CAMERA_ON_MOBILE_DEVICES : String = BTC + "CAMERA_ON_MOBILE_DEVICES" + ETC ;
    public const CAMERA_ON_MOBILE_DEVICES2 : String = BTC + "CAMERA_ON_MOBILE_DEVICES2" + ETC ;
  }
}
