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
 * EnumEvents.
 * The types of the events the objects of this framework dispatch. Every listener and
 * every dispatched event of this framework asks for its own type here.
 *
 * MAIN FEATURES:
 * - an event type is a plain string, so it is never displayed to anybody
 * - the values reporting a changed property of the application are dispatched on the
 *   dispatcher of the application, every other one on the dispatcher of the object
 */
package com.kisscodesystems.KissAs3Fw.enum
{
  public class EnumEvents
  {
    /**
     * Returns the type of the stop scroll to target event.
     */
    public static function EVENT_STOP_SCROLL_TO_TARGET():String
    {
      return "EVENT_STOP_SCROLL_TO_TARGET";
    }
    /**
     * Returns the type of the start scroll to target event.
     */
    public static function EVENT_START_SCROLL_TO_TARGET():String
    {
      return "EVENT_START_SCROLL_TO_TARGET";
    }
    /**
     * Returns the type of the center scrolling start event.
     */
    public static function EVENT_CENTER_SCROLLING_START():String
    {
      return "EVENT_CENTER_SCROLLING_START";
    }
    /**
     * Returns the type of the center scrolling in progress event.
     */
    public static function EVENT_CENTER_SCROLLING_IN_PROGRESS():String
    {
      return "EVENT_CENTER_SCROLLING_IN_PROGRESS";
    }
    /**
     * Returns the type of the center scrolling end event.
     */
    public static function EVENT_CENTER_SCROLLING_END():String
    {
      return "EVENT_CENTER_SCROLLING_END";
    }
    /**
     * Returns the type of the outer factor changed event.
     */
    public static function EVENT_OUTER_FACTOR_CHANGED():String
    {
      return "EVENT_OUTER_FACTOR_CHANGED";
    }
    /**
     * Returns the type of the content dw changed event.
     */
    public static function EVENT_CONTENT_DW_CHANGED():String
    {
      return "EVENT_CONTENT_DW_CHANGED";
    }
    /**
     * Returns the type of the content dh changed event.
     */
    public static function EVENT_CONTENT_DH_CHANGED():String
    {
      return "EVENT_CONTENT_DH_CHANGED";
    }
    /**
     * Returns the type of the content cx changed event.
     */
    public static function EVENT_CONTENT_CX_CHANGED():String
    {
      return "EVENT_CONTENT_CX_CHANGED";
    }
    /**
     * Returns the type of the content cy changed event.
     */
    public static function EVENT_CONTENT_CY_CHANGED():String
    {
      return "EVENT_CONTENT_CY_CHANGED";
    }
    /**
     * Returns the type of the quantized vertical changed event.
     */
    public static function EVENT_QUANTIZED_VERTICAL_CHANGED():String
    {
      return "EVENT_QUANTIZED_VERTICAL_CHANGED";
    }
    /**
     * Returns the type of the quantized horizontal changed event.
     */
    public static function EVENT_QUANTIZED_HORIZONTAL_CHANGED():String
    {
      return "EVENT_QUANTIZED_HORIZONTAL_CHANGED";
    }
    /**
     * Returns the type of the enabled vertical changed event.
     */
    public static function EVENT_ENABLED_VERTICAL_CHANGED():String
    {
      return "EVENT_ENABLED_VERTICAL_CHANGED";
    }
    /**
     * Returns the type of the enabled horizontal changed event.
     */
    public static function EVENT_ENABLED_HORIZONTAL_CHANGED():String
    {
      return "EVENT_ENABLED_HORIZONTAL_CHANGED";
    }
    /**
     * Returns the type of the content cache begin event.
     */
    public static function EVENT_CONTENT_CACHE_BEGIN():String
    {
      return "EVENT_CONTENT_CACHE_BEGIN";
    }
    /**
     * Returns the type of the left reached event.
     */
    public static function EVENT_LEFT_REACHED():String
    {
      return "EVENT_LEFT_REACHED";
    }
    /**
     * Returns the type of the right reached event.
     */
    public static function EVENT_RIGHT_REACHED():String
    {
      return "EVENT_RIGHT_REACHED";
    }
    /**
     * Returns the type of the top reached event.
     */
    public static function EVENT_TOP_REACHED():String
    {
      return "EVENT_TOP_REACHED";
    }
    /**
     * Returns the type of the bottom reached event.
     */
    public static function EVENT_BOTTOM_REACHED():String
    {
      return "EVENT_BOTTOM_REACHED";
    }
    /**
     * Returns the type of the played by hand event.
     */
    public static function EVENT_PLAYED_BY_HAND():String
    {
      return "EVENT_PLAYED_BY_HAND";
    }
    /**
     * Returns the type of the played by outside event.
     */
    public static function EVENT_PLAYED_BY_OUTSIDE():String
    {
      return "EVENT_PLAYED_BY_OUTSIDE";
    }
    /**
     * Returns the type of the stopped by end event.
     */
    public static function EVENT_STOPPED_BY_END():String
    {
      return "EVENT_STOPPED_BY_END";
    }
    /**
     * Returns the type of the stopped by hand event.
     */
    public static function EVENT_STOPPED_BY_HAND():String
    {
      return "EVENT_STOPPED_BY_HAND";
    }
    /**
     * Returns the type of the chapter changed event.
     */
    public static function EVENT_CHAPTER_CHANGED():String
    {
      return "EVENT_CHAPTER_CHANGED";
    }
    /**
     * Returns the type of the changed event.
     */
    public static function EVENT_CHANGED():String
    {
      return "EVENT_CHANGED";
    }
    /**
     * Returns the type of the cleared event.
     */
    public static function EVENT_CLEARED():String
    {
      return "EVENT_CLEARED";
    }
    /**
     * Returns the type of the watch changed event.
     */
    public static function EVENT_WATCH_CHANGED():String
    {
      return "EVENT_WATCH_CHANGED";
    }
    /**
     * Returns the type of the watch repositioned event.
     */
    public static function EVENT_WATCH_REPOSITIONED():String
    {
      return "EVENT_WATCH_REPOSITIONED";
    }
    /**
     * Returns the type of the trace level changed event.
     */
    public static function EVENT_TRACE_LEVEL_CHANGED():String
    {
      return "EVENT_TRACE_LEVEL_CHANGED";
    }
    /**
     * Returns the type of the opened event.
     */
    public static function EVENT_OPENED():String
    {
      return "EVENT_OPENED";
    }
    /**
     * Returns the type of the closed event.
     */
    public static function EVENT_CLOSED():String
    {
      return "EVENT_CLOSED";
    }
    /**
     * Returns the type of the click event.
     */
    public static function EVENT_CLICK():String
    {
      return "EVENT_CLICK";
    }
    /**
     * Returns the type of the file loaded event.
     */
    public static function EVENT_FILE_LOADED():String
    {
      return "EVENT_FILE_LOADED";
    }
    /**
     * Returns the type of the lang changed event.
     */
    public static function EVENT_LANG_CHANGED():String
    {
      return "EVENT_LANG_CHANGED";
    }
    /**
     * Returns the type of the coordinates changed event.
     */
    public static function EVENT_COORDINATES_CHANGED():String
    {
      return "EVENT_COORDINATES_CHANGED";
    }
    /**
     * Returns the type of the widget close me event.
     */
    public static function EVENT_WIDGET_CLOSE_ME():String
    {
      return "EVENT_WIDGET_CLOSE_ME";
    }
    /**
     * Returns the type of the widget closed event.
     */
    public static function EVENT_WIDGET_CLOSED():String
    {
      return "EVENT_WIDGET_CLOSED";
    }
    /**
     * Returns the type of the widget drag start event.
     */
    public static function EVENT_WIDGET_DRAG_START():String
    {
      return "EVENT_WIDGET_DRAG_START";
    }
    /**
     * Returns the type of the widget drag stop event.
     */
    public static function EVENT_WIDGET_DRAG_STOP():String
    {
      return "EVENT_WIDGET_DRAG_STOP";
    }
    /**
     * Returns the type of the dimensions changed event.
     */
    public static function EVENT_DIMENSIONS_CHANGED():String
    {
      return "EVENT_DIMENSIONS_CHANGED";
    }
    /**
     * Returns the type of the text format bright changed event.
     */
    public static function EVENT_TEXT_FORMAT_BRIGHT_CHANGED():String
    {
      return "EVENT_TEXT_FORMAT_BRIGHT_CHANGED";
    }
    /**
     * Returns the type of the text format mid changed event.
     */
    public static function EVENT_TEXT_FORMAT_MID_CHANGED():String
    {
      return "EVENT_TEXT_FORMAT_MID_CHANGED";
    }
    /**
     * Returns the type of the text format dark changed event.
     */
    public static function EVENT_TEXT_FORMAT_DARK_CHANGED():String
    {
      return "EVENT_TEXT_FORMAT_DARK_CHANGED";
    }
    /**
     * Returns the type of the displaying style changed event.
     */
    public static function EVENT_DISPLAYING_STYLE_CHANGED():String
    {
      return "EVENT_DISPLAYING_STYLE_CHANGED";
    }
    /**
     * Returns the type of the elements repositioned event.
     */
    public static function EVENT_ELEMENTS_REPOSITIONED():String
    {
      return "EVENT_ELEMENTS_REPOSITIONED";
    }
    /**
     * Returns the type of the orientation changed event.
     */
    public static function EVENT_ORIENTATION_CHANGED():String
    {
      return "EVENT_ORIENTATION_CHANGED";
    }
    /**
     * Returns the type of the widget mode changed event.
     */
    public static function EVENT_WIDGET_MODE_CHANGED():String
    {
      return "EVENT_WIDGET_MODE_CHANGED";
    }
    /**
     * Returns the type of the sound volume changed event.
     */
    public static function EVENT_SOUND_VOLUME_CHANGED():String
    {
      return "EVENT_SOUND_VOLUME_CHANGED";
    }
    /**
     * Returns the type of the sound playing changed event.
     */
    public static function EVENT_SOUND_PLAYING_CHANGED():String
    {
      return "EVENT_SOUND_PLAYING_CHANGED";
    }
    /**
     * Returns the type of the line thickness changed event.
     */
    public static function EVENT_LINE_THICKNESS_CHANGED():String
    {
      return "EVENT_LINE_THICKNESS_CHANGED";
    }
    /**
     * Returns the type of the margin changed event.
     */
    public static function EVENT_MARGIN_CHANGED():String
    {
      return "EVENT_MARGIN_CHANGED";
    }
    /**
     * Returns the type of the padding changed event.
     */
    public static function EVENT_PADDING_CHANGED():String
    {
      return "EVENT_PADDING_CHANGED";
    }
    /**
     * Returns the type of the radius changed event.
     */
    public static function EVENT_RADIUS_CHANGED():String
    {
      return "EVENT_RADIUS_CHANGED";
    }
    /**
     * Returns the type of the box corner changed event.
     */
    public static function EVENT_BOX_CORNER_CHANGED():String
    {
      return "EVENT_BOX_CORNER_CHANGED";
    }
    /**
     * Returns the type of the box frame changed event.
     */
    public static function EVENT_BOX_FRAME_CHANGED():String
    {
      return "EVENT_BOX_FRAME_CHANGED";
    }
    /**
     * Returns the type of the background color rand changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_RAND_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_RAND_CHANGED";
    }
    /**
     * Returns the type of the background color to font changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED";
    }
    /**
     * Returns the type of the background color dark changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_DARK_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_DARK_CHANGED";
    }
    /**
     * Returns the type of the background color mid changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_MID_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_MID_CHANGED";
    }
    /**
     * Returns the type of the background color bright changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED";
    }
    /**
     * Returns the type of the background color alpha changed event.
     */
    public static function EVENT_BACKGROUND_COLOR_ALPHA_CHANGED():String
    {
      return "EVENT_BACKGROUND_COLOR_ALPHA_CHANGED";
    }
    /**
     * Returns the type of the background image changed event.
     */
    public static function EVENT_BACKGROUND_IMAGE_CHANGED():String
    {
      return "EVENT_BACKGROUND_IMAGE_CHANGED";
    }
    /**
     * Returns the type of the background align changed event.
     */
    public static function EVENT_BACKGROUND_ALIGN_CHANGED():String
    {
      return "EVENT_BACKGROUND_ALIGN_CHANGED";
    }
    /**
     * Returns the type of the background alpha changed event.
     */
    public static function EVENT_BACKGROUND_ALPHA_CHANGED():String
    {
      return "EVENT_BACKGROUND_ALPHA_CHANGED";
    }
    /**
     * Returns the type of the background blur changed event.
     */
    public static function EVENT_BACKGROUND_BLUR_CHANGED():String
    {
      return "EVENT_BACKGROUND_BLUR_CHANGED";
    }
    /**
     * Returns the type of the background live changed event.
     */
    public static function EVENT_BACKGROUND_LIVE_CHANGED():String
    {
      return "EVENT_BACKGROUND_LIVE_CHANGED";
    }
    /**
     * Returns the type of the font face changed event.
     */
    public static function EVENT_FONT_FACE_CHANGED():String
    {
      return "EVENT_FONT_FACE_CHANGED";
    }
    /**
     * Returns the type of the font size changed event.
     */
    public static function EVENT_FONT_SIZE_CHANGED():String
    {
      return "EVENT_FONT_SIZE_CHANGED";
    }
    /**
     * Returns the type of the font color rand changed event.
     */
    public static function EVENT_FONT_COLOR_RAND_CHANGED():String
    {
      return "EVENT_FONT_COLOR_RAND_CHANGED";
    }
    /**
     * Returns the type of the font color to background changed event.
     */
    public static function EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED():String
    {
      return "EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED";
    }
    /**
     * Returns the type of the font color bright changed event.
     */
    public static function EVENT_FONT_COLOR_BRIGHT_CHANGED():String
    {
      return "EVENT_FONT_COLOR_BRIGHT_CHANGED";
    }
    /**
     * Returns the type of the font color mid changed event.
     */
    public static function EVENT_FONT_COLOR_MID_CHANGED():String
    {
      return "EVENT_FONT_COLOR_MID_CHANGED";
    }
    /**
     * Returns the type of the font color dark changed event.
     */
    public static function EVENT_FONT_COLOR_DARK_CHANGED():String
    {
      return "EVENT_FONT_COLOR_DARK_CHANGED";
    }
    /**
     * Returns the type of the font bold changed event.
     */
    public static function EVENT_FONT_BOLD_CHANGED():String
    {
      return "EVENT_FONT_BOLD_CHANGED";
    }
    /**
     * Returns the type of the font italic changed event.
     */
    public static function EVENT_FONT_ITALIC_CHANGED():String
    {
      return "EVENT_FONT_ITALIC_CHANGED";
    }
    /**
     * Returns the type of the color steal from stage start event.
     */
    public static function EVENT_COLOR_STEAL_FROM_STAGE_START():String
    {
      return "EVENT_COLOR_STEAL_FROM_STAGE_START";
    }
    /**
     * Returns the type of the color steal from stage stop event.
     */
    public static function EVENT_COLOR_STEAL_FROM_STAGE_STOP():String
    {
      return "EVENT_COLOR_STEAL_FROM_STAGE_STOP";
    }
    /**
     * Returns the type of the to create reg form event.
     */
    public static function EVENT_TO_CREATE_REG_FORM():String
    {
      return "EVENT_TO_CREATE_REG_FORM";
    }
    /**
     * Returns the type of the to logout event.
     */
    public static function EVENT_TO_LOGOUT():String
    {
      return "EVENT_TO_LOGOUT";
    }
    /**
     * Returns the type of the profile image clicked event.
     */
    public static function EVENT_PROFILE_IMAGE_CLICKED():String
    {
      return "EVENT_PROFILE_IMAGE_CLICKED";
    }
    /**
     * Returns the type of the event telling that something has been saved.
     */
    public static function EVENT_SAVED():String
    {
      return "EVENT_SAVED";
    }
    /**
     * Returns the type of the event telling that a camera has been attached.
     */
    public static function EVENT_CAMERA_IS_ATTACHED():String
    {
      return "EVENT_CAMERA_IS_ATTACHED";
    }
    /**
     * Returns the type of the event telling that a camera has been released.
     */
    public static function EVENT_CAMERA_IS_DETACHED():String
    {
      return "EVENT_CAMERA_IS_DETACHED";
    }
    /**
     * Returns the type of the event telling that the servers of the application have
     * changed: the list of them or the one in use alike.
     */
    public static function EVENT_SERVERS_CHANGED():String
    {
      return "EVENT_SERVERS_CHANGED";
    }
  }
}
