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
 * EnumUnitTest
 * Checks every enum of the framework that is not a generated one.
 *
 * MAIN FEATURES:
 * - every member of every one of those enums is asked for its value here
 * - a value that is displayed has to be a text key the label manager knows a label for,
 *   and a value that is never displayed must not be a text key at all
 * - no two members of one enum can answer the very same value: such a pair would be a
 *   copy of the other one, and the two of them could never be told apart
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAppDisplayedProperties;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAppEnvs;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBackgroundAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseButtonStates;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Fw.enum.EnumCameraResolutions;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDisplayingStyles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumLanguages;
  import com.kisscodesystems.KissAs3Fw.enum.EnumMonths;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.enum.EnumRoles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWeekdays;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWidgetModes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumYesNo;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class EnumUnitTest extends BaseUnitTest
  {
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function EnumUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Enum";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      // the text key enums: every value of them is displayed somewhere, so every one of
      // them has to be a text key the label manager knows a label for
      checkTextKeys("EnumBackgroundAligns", [EnumBackgroundAligns.BACKGROUND_ALIGN_NONE()
        , EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER1(), EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER2()
        , EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER3(), EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC()]);
      checkTextKeys("EnumBoxFrames", [EnumBoxFrames.BOX_FRAME_FULL(), EnumBoxFrames.BOX_FRAME_HORIZONTAL()
        , EnumBoxFrames.BOX_FRAME_VERTICAL(), EnumBoxFrames.BOX_FRAME_NONE()]);
      // getEveryDisplayingStyle is the one list the label manager and the dynamics config
      // are both built from, so checking that very list checks every style of both of them
      checkTextKeys("EnumDisplayingStyles", EnumDisplayingStyles.getEveryDisplayingStyle());
      checkTextKeys("EnumLanguages", [EnumLanguages.EN(), EnumLanguages.HU()]);
      checkTextKeys("EnumMonths", [EnumMonths.MONTH_JAN(), EnumMonths.MONTH_FEB(), EnumMonths.MONTH_MAR()
        , EnumMonths.MONTH_APR(), EnumMonths.MONTH_MAY(), EnumMonths.MONTH_JUN(), EnumMonths.MONTH_JUL()
        , EnumMonths.MONTH_AUG(), EnumMonths.MONTH_SEP(), EnumMonths.MONTH_OKT(), EnumMonths.MONTH_NOV()
        , EnumMonths.MONTH_DEC()]);
      checkTextKeys("EnumOkCancel", [EnumOkCancel.OC_OK(), EnumOkCancel.OC_CANCEL()]);
      checkTextKeys("EnumOrientations", [EnumOrientations.ORIENTATION_MANUAL()
        , EnumOrientations.ORIENTATION_VERTICAL(), EnumOrientations.ORIENTATION_HORIZONTAL()
        , EnumOrientations.ORIENTATION_FLOW(), EnumOrientations.ORIENTATION_DOCK()]);
      checkTextKeys("EnumRoles", [EnumRoles.ROLE_GUEST()]);
      checkTextKeys("EnumTextTypes", [EnumTextTypes.TEXT_TYPE_BRIGHT(), EnumTextTypes.TEXT_TYPE_MID()
        , EnumTextTypes.TEXT_TYPE_DARK()]);
      checkTextKeys("EnumWeekdays", [EnumWeekdays.WEEKDAY_MONDAY(), EnumWeekdays.WEEKDAY_TUESDAY()
        , EnumWeekdays.WEEKDAY_WEDNESDAY(), EnumWeekdays.WEEKDAY_THURSDAY(), EnumWeekdays.WEEKDAY_FRIDAY()
        , EnumWeekdays.WEEKDAY_SATURDAY(), EnumWeekdays.WEEKDAY_SUNDAY()]);
      checkTextKeys("EnumWidgetModes", [EnumWidgetModes.WIDGET_MODE_AUTOMATIC()
        , EnumWidgetModes.WIDGET_MODE_DESKTOP(), EnumWidgetModes.WIDGET_MODE_MOBILE()]);
      checkTextKeys("EnumYesNo", [EnumYesNo.YN_YES(), EnumYesNo.YN_NO()]);
      // the plain value enums: none of them is ever displayed, so none of them can be a
      // text key, and a text key of them would be displayed between its own brackets
      checkValues("EnumAppDisplayedProperties", [EnumAppDisplayedProperties.appLineThickness()
        , EnumAppDisplayedProperties.appMargin(), EnumAppDisplayedProperties.appPadding()
        , EnumAppDisplayedProperties.appRadius(), EnumAppDisplayedProperties.appBoxCorner()
        , EnumAppDisplayedProperties.appBoxFrame(), EnumAppDisplayedProperties.appBackgroundColorRand()
        , EnumAppDisplayedProperties.appBackgroundColorToFont()
        , EnumAppDisplayedProperties.appBackgroundColorDark()
        , EnumAppDisplayedProperties.appBackgroundColorMid()
        , EnumAppDisplayedProperties.appBackgroundColorBright()
        , EnumAppDisplayedProperties.appBackgroundColorAlpha(), EnumAppDisplayedProperties.appBackgroundImage()
        , EnumAppDisplayedProperties.appBackgroundAlign(), EnumAppDisplayedProperties.appBackgroundAlpha()
        , EnumAppDisplayedProperties.appBackgroundBlur(), EnumAppDisplayedProperties.appBackgroundLive()
        , EnumAppDisplayedProperties.appFontFace(), EnumAppDisplayedProperties.appFontSize()
        , EnumAppDisplayedProperties.appFontColorBright(), EnumAppDisplayedProperties.appFontColorMid()
        , EnumAppDisplayedProperties.appFontColorDark(), EnumAppDisplayedProperties.appFontColorRand()
        , EnumAppDisplayedProperties.appFontColorToBackground(), EnumAppDisplayedProperties.appFontBold()
        , EnumAppDisplayedProperties.appFontItalic()]);
      checkValues("EnumAppEnvs", [EnumAppEnvs.appEnvDev(), EnumAppEnvs.appEnvTst(), EnumAppEnvs.appEnvPrd()]);
      checkValues("EnumCameraResolutions", EnumCameraResolutions.getEveryResolution());
      checkValues("EnumEvents", [EnumEvents.EVENT_STOP_SCROLL_TO_TARGET()
        , EnumEvents.EVENT_START_SCROLL_TO_TARGET(), EnumEvents.EVENT_CENTER_SCROLLING_START()
        , EnumEvents.EVENT_CENTER_SCROLLING_IN_PROGRESS(), EnumEvents.EVENT_CENTER_SCROLLING_END()
        , EnumEvents.EVENT_OUTER_FACTOR_CHANGED(), EnumEvents.EVENT_CONTENT_DW_CHANGED()
        , EnumEvents.EVENT_CONTENT_DH_CHANGED(), EnumEvents.EVENT_CONTENT_CX_CHANGED()
        , EnumEvents.EVENT_CONTENT_CY_CHANGED(), EnumEvents.EVENT_QUANTIZED_VERTICAL_CHANGED()
        , EnumEvents.EVENT_QUANTIZED_HORIZONTAL_CHANGED(), EnumEvents.EVENT_ENABLED_VERTICAL_CHANGED()
        , EnumEvents.EVENT_ENABLED_HORIZONTAL_CHANGED(), EnumEvents.EVENT_CONTENT_CACHE_BEGIN()
        , EnumEvents.EVENT_LEFT_REACHED(), EnumEvents.EVENT_RIGHT_REACHED(), EnumEvents.EVENT_TOP_REACHED()
        , EnumEvents.EVENT_BOTTOM_REACHED(), EnumEvents.EVENT_PLAYED_BY_HAND()
        , EnumEvents.EVENT_PLAYED_BY_OUTSIDE(), EnumEvents.EVENT_STOPPED_BY_END()
        , EnumEvents.EVENT_STOPPED_BY_HAND(), EnumEvents.EVENT_CHANGED(), EnumEvents.EVENT_CLEARED()
        , EnumEvents.EVENT_WATCH_CHANGED(), EnumEvents.EVENT_WATCH_REPOSITIONED()
        , EnumEvents.EVENT_TRACE_LEVEL_CHANGED(), EnumEvents.EVENT_OPENED(), EnumEvents.EVENT_CLOSED()
        , EnumEvents.EVENT_CLICK(), EnumEvents.EVENT_FILE_LOADED(), EnumEvents.EVENT_LANG_CHANGED()
        , EnumEvents.EVENT_COORDINATES_CHANGED(), EnumEvents.EVENT_WIDGET_CLOSE_ME()
        , EnumEvents.EVENT_WIDGET_CLOSED(), EnumEvents.EVENT_WIDGET_DRAG_START()
        , EnumEvents.EVENT_WIDGET_DRAG_STOP(), EnumEvents.EVENT_DIMENSIONS_CHANGED()
        , EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED()
        , EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), EnumEvents.EVENT_DISPLAYING_STYLE_CHANGED()
        , EnumEvents.EVENT_ELEMENTS_REPOSITIONED(), EnumEvents.EVENT_ORIENTATION_CHANGED()
        , EnumEvents.EVENT_WIDGET_MODE_CHANGED(), EnumEvents.EVENT_SOUND_VOLUME_CHANGED()
        , EnumEvents.EVENT_SOUND_PLAYING_CHANGED(), EnumEvents.EVENT_LINE_THICKNESS_CHANGED()
        , EnumEvents.EVENT_MARGIN_CHANGED(), EnumEvents.EVENT_PADDING_CHANGED()
        , EnumEvents.EVENT_RADIUS_CHANGED(), EnumEvents.EVENT_BOX_CORNER_CHANGED()
        , EnumEvents.EVENT_BOX_FRAME_CHANGED(), EnumEvents.EVENT_BACKGROUND_COLOR_RAND_CHANGED()
        , EnumEvents.EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED(), EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED()
        , EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED()
        , EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED()
        , EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED(), EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED()
        , EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED(), EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED()
        , EnumEvents.EVENT_FONT_FACE_CHANGED(), EnumEvents.EVENT_FONT_SIZE_CHANGED()
        , EnumEvents.EVENT_FONT_COLOR_RAND_CHANGED(), EnumEvents.EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED()
        , EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), EnumEvents.EVENT_FONT_COLOR_MID_CHANGED()
        , EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), EnumEvents.EVENT_FONT_BOLD_CHANGED()
        , EnumEvents.EVENT_FONT_ITALIC_CHANGED(), EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_START()
        , EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_STOP(), EnumEvents.EVENT_TO_CREATE_REG_FORM()
        , EnumEvents.EVENT_TO_LOGOUT(), EnumEvents.EVENT_PROFILE_IMAGE_CLICKED()
        , EnumEvents.EVENT_SAVED(), EnumEvents.EVENT_CAMERA_IS_ATTACHED()
        , EnumEvents.EVENT_CAMERA_IS_DETACHED(), EnumEvents.EVENT_SERVERS_CHANGED()]);
      // the numbered enums
      checkNumbers("EnumBaseButtonStates", [EnumBaseButtonStates.BASE_BUTTON_STATE_DEFAULT()
        , EnumBaseButtonStates.BASE_BUTTON_STATE_HIGHLIGHTED(), EnumBaseButtonStates.BASE_BUTTON_STATE_PUSHED()]);
      checkNumbers("EnumBaseShapeTypes", [EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED()
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT(), EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED()
        , EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE()]);
    }
    /**
     * Checks the values of one enum that is displayed. Every value of it has to be a text
     * key the label manager knows a label for in the current language, and no two of them
     * can be the same one.
     * @param enumName the name of the enum the values belong to
     * @param values the value of every member of that enum
     */
    private function checkTextKeys(enumName:String, values:Array):void
    {
      for (var i:int = 0; i < values.length; i++)
      {
        const value:String = String(values[i]);
        assertTrue(enumName + " " + value + " is a text key"
          , value.indexOf("[") == 0 && value.indexOf("]") == value.length - 1);
        assertTrue(enumName + " " + value + " has a label in the current language"
          , application.getLabelManager().getLabel(value) != "");
        assertEquals(enumName + " " + value + " stands in that enum once", i, values.indexOf(value));
      }
      values.splice(0);
    }
    /**
     * Checks the values of one enum that is never displayed. No value of it can be an
     * empty one or a text key, and no two of them can be the same one.
     * @param enumName the name of the enum the values belong to
     * @param values the value of every member of that enum
     */
    private function checkValues(enumName:String, values:Array):void
    {
      for (var i:int = 0; i < values.length; i++)
      {
        const value:String = String(values[i]);
        assertTrue(enumName + " " + value + " is not an empty value", value != "");
        assertFalse(enumName + " " + value + " is not a text key", value.indexOf("[") == 0);
        assertEquals(enumName + " " + value + " stands in that enum once", i, values.indexOf(value));
      }
      values.splice(0);
    }
    /**
     * Checks the values of one numbered enum: no two of them can be the same one.
     * @param enumName the name of the enum the values belong to
     * @param values the value of every member of that enum
     */
    private function checkNumbers(enumName:String, values:Array):void
    {
      for (var i:int = 0; i < values.length; i++)
      {
        assertEquals(enumName + " " + values[i] + " stands in that enum once", i, values.indexOf(values[i]));
      }
      values.splice(0);
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
    }
  }
}
