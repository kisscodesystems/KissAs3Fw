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
 * DynamicsConfig.
 * The properties the user can change while the application is running.
 *
 * MAIN FEATURES:
 * - changing a value dispatches its own event on application.getBaseEventDispatcher()
 * - every value has a starting default coded into this class
 * - the defaults can be overwritten from the embedded configuration xml,
 *   resource/config/KissAs3FwDynamicsConfig.xml
 * - an application brings its own values in a small class extending this one:
 *   that class embeds its own xml and overrides readValuesFromConfigXml to call
 *   the super and then applyConfigXml with it, so the application values are
 *   applied on top of the framework ones and stay in an xml, not in the code
 * - the xml only has to hold the values it wants to change
 * - a class extending this one is still possible, it has to assign the protected
 *   variables after the super call, because the xml is applied by that super call
 * - the values of every displayed property stand together in the displaying styles: the
 *   framework holds the default one alone, that very style is built of the values above
 *   and it displays the embedded background image: a hundred pixels wide mosaic tile
 *   repeated over the whole stage, the one picture this framework carries of its own
 * - an application extending this class overrides iniDisplayingStyles and describes every
 *   further style of its own there, on top of that default one
 * - the background image of such a style is a file of the backgrounds folder of the
 *   framework server, so switching the style loads that file and repaints the application
 *   with the colors taken from it
 * - the settings of the application write the values of the current style one by one, so
 *   every style keeps the values it has been described with in an array of its own as
 *   well: resetDisplayingStyleOf is the way back to those very values
 */
package com.kisscodesystems.KissAs3Fw.config
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseConfigValues;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAppDisplayedProperties;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBackgroundAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDisplayingStyles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWidgetModes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.ui.Image;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.filters.BlurFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.system.System;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.utils.ByteArray;
  public class DynamicsConfig
  {
    [Embed(source = "../resource/config/KissAs3FwDynamicsConfig.xml", mimeType = "application/octet-stream")]
    private var EmbeddedConfig:Class;
    private var embeddedConfigByteArray:ByteArray = new EmbeddedConfig() as ByteArray;
    protected var application:Application = null;
    private var bitmapData:BitmapData = null;
    // the picture the displayed background is derived from: it is scaled down once when it
    // arrives and it carries no blur, so changing the blur only has to redraw from it
    // instead of loading that picture again
    private var sourceBitmapData:BitmapData = null;
    protected var image:Image = null;
    private var appOrientation:String = "";
    private var appWidgetMode:String = "";
    private var appSoundVolume:int = 66;
    private var appSoundPlaying:Boolean = true;
    protected var appLineThickness:int = 1;
    protected var appMargin:int = 12;
    protected var appPadding:int = 9;
    protected var appRadius:int = 6;
    protected var appBoxCorner:int = 9;
    protected var appBoxFrame:String = "";
    protected var appBackgroundColorRand:Boolean = false;
    protected var appBackgroundColorToFont:Boolean = false;
    protected var appBackgroundColorDark:Number = 0xC7C7C7;
    protected var appBackgroundColorMid:Number = 0x090909;
    protected var appBackgroundColorBright:Number = 0x050505;
    protected var appBackgroundColorAlpha:Number = 0.16;
    protected var appBackgroundImage:String = "";
    protected var appBackgroundAlign:String = "";
    protected var appBackgroundAlpha:Number = 1;
    protected var appBackgroundBlur:int = 0;
    protected var appBackgroundLive:Boolean = true;
    protected var appFontFace:String = "FreeSans";
    protected var appFontSize:int = 0;
    protected var appFontColorRand:Boolean = false;
    protected var appFontColorToBackground:Boolean = false;
    protected var appFontColorBright:Number = 0xFEFEFE;
    protected var appFontColorMid:Number = 0xF9F9F9;
    protected var appFontColorDark:Number = 0x373737;
    protected var appFontBold:Boolean = false;
    protected var appFontItalic:Boolean = false;
    private var textFormatBright:TextFormat = null;
    private var textFormatMid:TextFormat = null;
    private var textFormatDark:TextFormat = null;
    private var textFieldHeightBright:int = 0;
    private var textFieldHeightMid:int = 0;
    private var textFieldHeightDark:int = 0;
    private var textFieldHeightBrightCorrection:int = 0;
    private var textFieldHeightMidCorrection:int = 0;
    private var textFieldHeightDarkCorrection:int = 0;
    private var eventAppOrientationChanged:Event = null;
    private var eventAppWidgetModeChanged:Event = null;
    private var eventAppSoundVolumeChanged:Event = null;
    private var eventAppSoundPlayingChanged:Event = null;
    private var eventAppLineThicknessChanged:Event = null;
    private var eventAppMarginChanged:Event = null;
    private var eventAppPaddingChanged:Event = null;
    private var eventAppRadiusChanged:Event = null;
    private var eventAppBoxCornerChanged:Event = null;
    private var eventAppBoxFrameChanged:Event = null;
    private var eventAppBackgroundColorRandChanged:Event = null;
    private var eventAppBackgroundColorToFontChanged:Event = null;
    private var eventAppBackgroundColorDarkChanged:Event = null;
    private var eventAppBackgroundColorMidChanged:Event = null;
    private var eventAppBackgroundColorBrightChanged:Event = null;
    private var eventAppBackgroundColorAlphaChanged:Event = null;
    protected var eventAppBackgroundImageChanged:Event = null;
    private var eventAppBackgroundAlignChanged:Event = null;
    private var eventAppBackgroundAlphaChanged:Event = null;
    private var eventAppBackgroundBlurChanged:Event = null;
    private var eventAppBackgroundLiveChanged:Event = null;
    private var eventAppFontFaceChanged:Event = null;
    private var eventAppFontSizeChanged:Event = null;
    private var eventAppFontColorRandChanged:Event = null;
    private var eventAppFontColorToBackgroundChanged:Event = null;
    private var eventAppFontColorBrightChanged:Event = null;
    private var eventAppFontColorMidChanged:Event = null;
    private var eventAppFontColorDarkChanged:Event = null;
    private var eventAppFontBoldChanged:Event = null;
    private var eventAppFontItalicChanged:Event = null;
    private var eventTextFormatBrightChanged:Event = null;
    private var eventTextFormatMidChanged:Event = null;
    private var eventTextFormatDarkChanged:Event = null;
    protected var appDisplayingStyles:Object = new Object();
    protected var appDisplayingStyleDefaults:Object = new Object();
    protected var currentDisplayingStyle:String = "";
    private var eventDisplayingStyleChanged:Event = null;
    protected var appBackgroundImages:Array = new Array();
    protected var styleChangingInProgress:Boolean = false;
    private var stealPixelBitmapData:BitmapData = null;
    /**
     * Constructs the dynamics config and applies the embedded configuration xml onto it.
     * @param applicationRef the main application reference
     */
    public function DynamicsConfig(applicationRef:Application):void
    {
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " DynamicsConfig> called.", 1);
      application.trace("<" + this + " DynamicsConfig> applicationRef: " + applicationRef, 0);
      stealPixelBitmapData = new BitmapData(1, 1);
      eventDisplayingStyleChanged = new Event(EnumEvents.EVENT_DISPLAYING_STYLE_CHANGED());
      eventAppOrientationChanged = new Event(EnumEvents.EVENT_ORIENTATION_CHANGED());
      eventAppWidgetModeChanged = new Event(EnumEvents.EVENT_WIDGET_MODE_CHANGED());
      eventAppSoundVolumeChanged = new Event(EnumEvents.EVENT_SOUND_VOLUME_CHANGED());
      eventAppSoundPlayingChanged = new Event(EnumEvents.EVENT_SOUND_PLAYING_CHANGED());
      eventAppLineThicknessChanged = new Event(EnumEvents.EVENT_LINE_THICKNESS_CHANGED());
      eventAppMarginChanged = new Event(EnumEvents.EVENT_MARGIN_CHANGED());
      eventAppPaddingChanged = new Event(EnumEvents.EVENT_PADDING_CHANGED());
      eventAppRadiusChanged = new Event(EnumEvents.EVENT_RADIUS_CHANGED());
      eventAppBoxCornerChanged = new Event(EnumEvents.EVENT_BOX_CORNER_CHANGED());
      eventAppBoxFrameChanged = new Event(EnumEvents.EVENT_BOX_FRAME_CHANGED());
      eventAppBackgroundColorRandChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_RAND_CHANGED());
      eventAppBackgroundColorToFontChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED());
      eventAppBackgroundColorDarkChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED());
      eventAppBackgroundColorMidChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED());
      eventAppBackgroundColorBrightChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED());
      eventAppBackgroundColorAlphaChanged = new Event(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED());
      eventAppBackgroundImageChanged = new Event(EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED());
      eventAppBackgroundAlignChanged = new Event(EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED());
      eventAppBackgroundAlphaChanged = new Event(EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED());
      eventAppBackgroundBlurChanged = new Event(EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED());
      eventAppBackgroundLiveChanged = new Event(EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED());
      eventAppFontFaceChanged = new Event(EnumEvents.EVENT_FONT_FACE_CHANGED());
      eventAppFontSizeChanged = new Event(EnumEvents.EVENT_FONT_SIZE_CHANGED());
      eventAppFontColorRandChanged = new Event(EnumEvents.EVENT_FONT_COLOR_RAND_CHANGED());
      eventAppFontColorToBackgroundChanged = new Event(EnumEvents.EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED());
      eventAppFontColorBrightChanged = new Event(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED());
      eventAppFontColorMidChanged = new Event(EnumEvents.EVENT_FONT_COLOR_MID_CHANGED());
      eventAppFontColorDarkChanged = new Event(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED());
      eventAppFontBoldChanged = new Event(EnumEvents.EVENT_FONT_BOLD_CHANGED());
      eventAppFontItalicChanged = new Event(EnumEvents.EVENT_FONT_ITALIC_CHANGED());
      eventTextFormatBrightChanged = new Event(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED());
      eventTextFormatMidChanged = new Event(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED());
      eventTextFormatDarkChanged = new Event(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED());
      appBackgroundAlign = EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC();
      appBoxFrame = EnumBoxFrames.BOX_FRAME_FULL();
      currentDisplayingStyle = EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT();
      readValuesFromConfigXml();
      appBackgroundImage = currentDisplayingStyle;
      appBackgroundImages[currentDisplayingStyle] = null;
      iniDefaultFace(appFontSize == 0);
      iniDisplayingStyles();
      application.trace("<" + this + " DynamicsConfig> constructed.", 1);
    }
    /**
     * Applies the embedded framework configuration xml onto the default values.
     */
    protected function readValuesFromConfigXml():void
    {
      application.trace("<" + this + " DynamicsConfig readValuesFromConfigXml> called.", 1);
      applyConfigXml(embeddedConfigByteArray.toString());
      embeddedConfigByteArray.clear();
      embeddedConfigByteArray = null;
    }
    /**
     * Overwrites the current values with the ones found in the given configuration xml.
     * A class extending this one applies its own embedded xml on top of the framework
     * one by overriding readValuesFromConfigXml, calling the super and then this.
     * @param configXmlString the content of a configuration xml file
     */
    protected function applyConfigXml(configXmlString:String):void
    {
      application.trace("<" + this + " DynamicsConfig applyConfigXml> called.", 1);
      application.trace("<" + this + " DynamicsConfig applyConfigXml> configXmlString: " + configXmlString, 0);
      const values:BaseConfigValues = new BaseConfigValues(application, configXmlString);
      appLineThickness = values.getInt("appLineThickness", appLineThickness);
      appMargin = values.getInt("appMargin", appMargin);
      appPadding = values.getInt("appPadding", appPadding);
      appRadius = values.getInt("appRadius", appRadius);
      appBoxCorner = values.getInt("appBoxCorner", appBoxCorner);
      appBoxFrame = values.getString("appBoxFrame", appBoxFrame);
      appBackgroundColorRand = values.getBoolean("appBackgroundColorRand", appBackgroundColorRand);
      appBackgroundColorToFont = values.getBoolean("appBackgroundColorToFont", appBackgroundColorToFont);
      appBackgroundColorDark = values.getColor("appBackgroundColorDark", appBackgroundColorDark);
      appBackgroundColorMid = values.getColor("appBackgroundColorMid", appBackgroundColorMid);
      appBackgroundColorBright = values.getColor("appBackgroundColorBright", appBackgroundColorBright);
      appBackgroundColorAlpha = values.getNumber("appBackgroundColorAlpha", appBackgroundColorAlpha);
      appBackgroundAlign = values.getString("appBackgroundAlign", appBackgroundAlign);
      appBackgroundAlpha = values.getNumber("appBackgroundAlpha", appBackgroundAlpha);
      appBackgroundBlur = values.getInt("appBackgroundBlur", appBackgroundBlur);
      appBackgroundLive = values.getBoolean("appBackgroundLive", appBackgroundLive);
      appFontFace = values.getString("appFontFace", appFontFace);
      appFontSize = values.getInt("appFontSize", appFontSize);
      appFontColorRand = values.getBoolean("appFontColorRand", appFontColorRand);
      appFontColorToBackground = values.getBoolean("appFontColorToBackground", appFontColorToBackground);
      appFontColorBright = values.getColor("appFontColorBright", appFontColorBright);
      appFontColorMid = values.getColor("appFontColorMid", appFontColorMid);
      appFontColorDark = values.getColor("appFontColorDark", appFontColorDark);
      appFontBold = values.getBoolean("appFontBold", appFontBold);
      appFontItalic = values.getBoolean("appFontItalic", appFontItalic);
      values.destroy();
    }
    protected function iniDefaultFace(fontSizeFromStage:Boolean = true):void
    {
      application.trace("<" + this + " DynamicsConfig iniDefaultFace> called.", 1);
      application.trace("<" + this + " DynamicsConfig iniDefaultFace> fontSizeFromStage: " + fontSizeFromStage, 0);
      // a zero font size is the marker of the calculated one, so it is kept as it is: only
      // the text formats below take the size calculated of the current size of the stage,
      // and the application follows every later size of that stage through the
      // setFontSizeFromStage of it. An application configured with a real font size keeps
      // that very one, there is nothing to calculate for it.
      const size:int = fontSizeFromStage ? application.calcFontSizeFromStageSize() : appFontSize;
      application.trace("<" + this + " DynamicsConfig iniDefaultFace> size: " + size, 0);
      appDisplayingStyles[currentDisplayingStyle] = new Array();
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appLineThickness()] = appLineThickness;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appMargin()] = appMargin;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appPadding()] = appPadding;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appRadius()] = appRadius;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxCorner()] = appBoxCorner;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxFrame()] = appBoxFrame;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()] = appBackgroundColorRand;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()] = appBackgroundColorToFont;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorDark()] = application.getUtils().colorToString(appBackgroundColorDark);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorMid()] = application.getUtils().colorToString(appBackgroundColorMid);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorBright()] = application.getUtils().colorToString(appBackgroundColorBright);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorAlpha()] = appBackgroundColorAlpha;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundImage()] = currentDisplayingStyle;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlign()] = appBackgroundAlign;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlpha()] = appBackgroundAlpha;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundBlur()] = appBackgroundBlur;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundLive()] = appBackgroundLive;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontFace()] = appFontFace;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontSize()] = appFontSize;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorBright()] = application.getUtils().colorToString(appFontColorBright);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorMid()] = application.getUtils().colorToString(appFontColorMid);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorDark()] = application.getUtils().colorToString(appFontColorDark);
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()] = appFontColorRand;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()] = appFontColorToBackground;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontBold()] = appFontBold;
      appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontItalic()] = appFontItalic;
      // the values above are the ones this style has been described with, so they are the
      // default ones of it as well: the settings of the application overwrite the array
      // built above value by value, and this copy is the one they can be taken back from
      appDisplayingStyleDefaults[currentDisplayingStyle] = copyDisplayingStyle(appDisplayingStyles[currentDisplayingStyle] as Array);
      textFormatBright = new TextFormat(appFontFace, size, appFontColorBright, appFontBold, appFontItalic);
      textFormatMid = new TextFormat(appFontFace, size, appFontColorMid, appFontBold, appFontItalic);
      textFormatDark = new TextFormat(appFontFace, size, appFontColorDark, appFontBold, appFontItalic);
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID());
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_DARK());
      setAppFontFace(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontFace()]);
      setAppFontSize(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontSize()]);
      setAppOrientation(EnumOrientations.ORIENTATION_HORIZONTAL());
      setAppWidgetMode(EnumWidgetModes.WIDGET_MODE_AUTOMATIC());
    }
    /**
     * Builds every displaying style of this application besides the default one. The
     * framework holds the default style alone: that very one is built of the values above
     * and it is the only style displaying the embedded background image instead of a
     * picture of the framework server. An application extending this class overrides this
     * one and describes the styles of its own here, every one of them with an
     * addDisplayingStyle call and the setDisplayingStyleColors and
     * setDisplayingStyleShaping calls belonging to it.
     */
    protected function iniDisplayingStyles():void
    {
      application.trace("<" + this + " DynamicsConfig iniDisplayingStyles> called.", 1);
      application.trace("<" + this + " DynamicsConfig iniDisplayingStyles> the extenders of this class describe their own displaying styles here.", 0);
    }
    public function setCurrentDisplayingStyle(newDisplayingStyle:String):void
    {
      application.trace("<" + this + " DynamicsConfig setCurrentDisplayingStyle> called.", 1);
      application.trace("<" + this + " DynamicsConfig setCurrentDisplayingStyle> newDisplayingStyle: " + newDisplayingStyle, 0);
      if (currentDisplayingStyle == newDisplayingStyle)
      {
        application.trace("<" + this + " DynamicsConfig setCurrentDisplayingStyle> same values!", 6);
        return;
      }
      application.trace("<" + this + " DynamicsConfig setCurrentDisplayingStyle> newDisplayingStyle is different.", 0);
      if (appDisplayingStyles[newDisplayingStyle] != undefined)
      {
        application.trace("<" + this + " DynamicsConfig setCurrentDisplayingStyle> newDisplayingStyle is existing.", 0);
        currentDisplayingStyle = newDisplayingStyle;
      }
      else
      {
        application.trace("Failed to set up non-existing displaying style: " + newDisplayingStyle);
        currentDisplayingStyle = EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT();
      }
      applyCurrentDisplayingStyle();
    }
    /**
     * Gives every displayed property of this application the value the current
     * displaying style describes. The style itself is not touched, so this is the way
     * back to it after those properties have been changed one by one.
     */
    public function applyCurrentDisplayingStyle():void
    {
      application.trace("<" + this + " DynamicsConfig applyCurrentDisplayingStyle> called.", 1);
      styleChangingInProgress = true;
      setAppLineThickness(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appLineThickness()]);
      setAppMargin(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appMargin()]);
      setAppPadding(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appPadding()]);
      setAppRadius(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appRadius()]);
      setAppBoxCorner(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxCorner()]);
      setAppBoxFrame(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxFrame()]);
      if (!appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()] && !appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()])
      {
        setAppBackgroundColorDark(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorDark()]));
        setAppBackgroundColorMid(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorMid()]));
        setAppBackgroundColorBright(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorBright()]));
      }
      setAppBackgroundColorAlpha(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorAlpha()]);
      setAppBackgroundAlign(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlign()]);
      setAppBackgroundAlpha(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlpha()]);
      setAppBackgroundBlur(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundBlur()]);
      setAppBackgroundLive(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundLive()]);
      setAppFontFace(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontFace()]);
      setAppFontSize(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontSize()]);
      if (!appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()] && !appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
      {
        setAppFontColorBright(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorBright()]));
        setAppFontColorMid(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorMid()]));
        setAppFontColorDark(Number(application.getComponentsConfig().getColorHexToNumberString() + appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorDark()]));
      }
      setAppFontBold(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontBold()]);
      setAppFontItalic(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontItalic()]);
      setAppBackgroundImage();
      if (eventDisplayingStyleChanged != null)
      {
        application.getBaseEventDispatcher().dispatchEvent(eventDisplayingStyleChanged);
      }
      displayingStyleHasChanged();
      styleChangingInProgress = false;
    }
    /**
     * Gives every value of the current displaying style back to the default one of it and
     * repaints the application with those values. The settings of the application write
     * the values of the current style one by one, so applyCurrentDisplayingStyle alone
     * would only apply the changed values again: this is the one way back to the style as
     * the framework or the extender application has described it.
     */
    public function resetCurrentDisplayingStyle():void
    {
      application.trace("<" + this + " DynamicsConfig resetCurrentDisplayingStyle> called.", 1);
      resetDisplayingStyleOf(currentDisplayingStyle);
      // the four color modes are applied by the loading of the background image only, and
      // that image is the very same one after a resetting, so they are applied here by
      // hand: the colors of the style are only given back when all the four of them are
      // standing on their own default values again
      applyCurrentDisplayingStyleColorModes();
      applyCurrentDisplayingStyle();
    }
    /**
     * Makes the default displaying style the current one again and gives every value of
     * it back to the default one of it. The default style is the one this application
     * starts in, so this is the way out of an appearance the one using the application
     * cannot read at all: a font color of the color of the background leaves nothing
     * readable behind, and the settings of the appearance are lost with the rest of it.
     */
    public function setDefaultDisplayingStyle():void
    {
      application.trace("<" + this + " DynamicsConfig setDefaultDisplayingStyle> called.", 1);
      currentDisplayingStyle = EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT();
      resetCurrentDisplayingStyle();
    }
    /**
     * Gives every value of the displaying style of the given text key back to the default
     * one of it: the value the style has been described with. The style is not applied by
     * this, so the appearance of the application only changes when that style is the
     * current one and it is applied afterwards. A style this application does not know at
     * all changes nothing.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     */
    public function resetDisplayingStyleOf(styleKey:String):void
    {
      application.trace("<" + this + " DynamicsConfig resetDisplayingStyleOf> called.", 1);
      application.trace("<" + this + " DynamicsConfig resetDisplayingStyleOf> styleKey: " + styleKey, 0);
      const style:Array = getDisplayingStyleOf(styleKey);
      if (style == null)
      {
        return;
      }
      const defaults:Array = appDisplayingStyleDefaults[styleKey] as Array;
      if (defaults == null)
      {
        application.trace("<" + this + " DynamicsConfig resetDisplayingStyleOf> there are no default values of the key " + styleKey + "!", 6);
        return;
      }
      for (var propertyKey:String in defaults)
      {
        style[propertyKey] = defaults[propertyKey];
      }
    }
    /**
     * Adds a new displaying style to this application. The new style starts as a copy of
     * the default one, so the caller only has to change the properties differing from it.
     * The values the new style is described with are kept as the default ones of it as
     * well, the very values resetDisplayingStyleOf gives it back later on. The panel of
     * the settings displays the new style as soon as the label manager knows the text key
     * of it as well.
     * @param styleKey the text key of the new style, an EnumDisplayingStyles value
     * @param backgroundFile the background image of the new style: a file name of the
     *        backgrounds folder of the framework server, or a whole url of its own. An
     *        empty string gives the new style no background image at all.
     */
    public function addDisplayingStyle(styleKey:String, backgroundFile:String):void
    {
      application.trace("<" + this + " DynamicsConfig addDisplayingStyle> called.", 1);
      application.trace("<" + this + " DynamicsConfig addDisplayingStyle> styleKey: " + styleKey, 0);
      application.trace("<" + this + " DynamicsConfig addDisplayingStyle> backgroundFile: " + backgroundFile, 0);
      const defaultStyle:Array = appDisplayingStyles[EnumDisplayingStyles.DISPLAYING_STYLE_DEFAULT()] as Array;
      if (defaultStyle == null)
      {
        application.trace("<" + this + " DynamicsConfig addDisplayingStyle> the default style has not been built yet!", 6);
        return;
      }
      const newStyle:Array = copyDisplayingStyle(defaultStyle);
      // the background image property of a style holds the text key of that very style:
      // that key is the one the file of the image is registered by in appBackgroundImages
      newStyle[EnumAppDisplayedProperties.appBackgroundImage()] = styleKey;
      appDisplayingStyles[styleKey] = newStyle;
      appDisplayingStyleDefaults[styleKey] = copyDisplayingStyle(newStyle);
      appBackgroundImages[styleKey] = backgroundFile;
    }
    /**
     * Sets the colors of one displaying style. Every one of them is a six character long
     * hexadecimal string, the very form a style keeps its colors in. These are the values
     * the style is described with, so they become the default colors of it as well. A
     * style this application does not know at all changes nothing.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     * @param backgroundColorDark the color of the lines and of the first fill of the boxes
     * @param backgroundColorMid the color of the second fill of the boxes
     * @param backgroundColorBright the color of the highlights of the boxes
     * @param fontColorBright the color of the bright texts
     * @param fontColorMid the color of the mid texts
     * @param fontColorDark the color of the dark texts
     */
    public function setDisplayingStyleColors(styleKey:String, backgroundColorDark:String, backgroundColorMid:String, backgroundColorBright:String, fontColorBright:String, fontColorMid:String, fontColorDark:String):void
    {
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> called.", 1);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> styleKey: " + styleKey, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> backgroundColorDark: " + backgroundColorDark, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> backgroundColorMid: " + backgroundColorMid, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> backgroundColorBright: " + backgroundColorBright, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> fontColorBright: " + fontColorBright, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> fontColorMid: " + fontColorMid, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleColors> fontColorDark: " + fontColorDark, 0);
      if (getDisplayingStyleOf(styleKey) == null)
      {
        return;
      }
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBackgroundColorDark(), backgroundColorDark);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBackgroundColorMid(), backgroundColorMid);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBackgroundColorBright(), backgroundColorBright);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appFontColorBright(), fontColorBright);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appFontColorMid(), fontColorMid);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appFontColorDark(), fontColorDark);
    }
    /**
     * Sets the shaping of one displaying style: the way the background image of it lies
     * on the stage and the way the boxes of the application are drawn over that image.
     * These are the values the style is described with, so they become the default shaping
     * of it as well. A style this application does not know at all changes nothing.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     * @param backgroundAlign the align of the background image, an EnumBackgroundAligns value
     * @param backgroundBlur the blur the background image is displayed with
     * @param boxFrame the frame of the boxes, an EnumBoxFrames value
     * @param lineThickness the thickness of the lines
     * @param radius the radius of the rounded corners
     * @param boxCorner the size of the cut corners of the boxes
     */
    public function setDisplayingStyleShaping(styleKey:String, backgroundAlign:String, backgroundBlur:int, boxFrame:String, lineThickness:int, radius:int, boxCorner:int):void
    {
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> called.", 1);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> styleKey: " + styleKey, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> backgroundAlign: " + backgroundAlign, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> backgroundBlur: " + backgroundBlur, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> boxFrame: " + boxFrame, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> lineThickness: " + lineThickness, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> radius: " + radius, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleShaping> boxCorner: " + boxCorner, 0);
      if (getDisplayingStyleOf(styleKey) == null)
      {
        return;
      }
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBackgroundAlign(), backgroundAlign);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBackgroundBlur(), backgroundBlur);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBoxFrame(), boxFrame);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appLineThickness(), lineThickness);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appRadius(), radius);
      setDisplayingStyleProperty(styleKey, EnumAppDisplayedProperties.appBoxCorner(), boxCorner);
    }
    public function weAreInDesktopMode():Boolean
    {
      application.trace("<" + this + " DynamicsConfig weAreInDesktopMode> called.", 1);
      const val:Boolean = appWidgetMode == EnumWidgetModes.WIDGET_MODE_DESKTOP() || (appWidgetMode == EnumWidgetModes.WIDGET_MODE_AUTOMATIC() && application.getDw() > application.getDh());
      application.trace("<" + this + " DynamicsConfig weAreInDesktopMode> " + val, 0);
      return val;
    }
    public function getCurrentDisplayingStyle():String
    {
      return currentDisplayingStyle;
    }
    /**
     * Tells whether this application holds a displaying style of the given text key.
     * Switching to a style this answers false for falls back to the default one, so this
     * is the way to tell a style the panel of the settings offers from a style that is
     * really there.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     */
    public function hasDisplayingStyle(styleKey:String):Boolean
    {
      return appDisplayingStyles[styleKey] != undefined;
    }
    private function setTextFieldHeight(textType:String):void
    {
      application.trace("<" + this + " DynamicsConfig setTextFieldHeight> called.", 1);
      application.trace("<" + this + " DynamicsConfig setTextFieldHeight> textType: " + textType, 0);
      const textField:TextField = new TextField();
      if (textType == EnumTextTypes.TEXT_TYPE_BRIGHT())
      {
        textField.defaultTextFormat = textFormatBright;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_MID())
      {
        textField.defaultTextFormat = textFormatMid;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        textField.defaultTextFormat = textFormatDark;
      }
      textField.autoSize = TextFieldAutoSize.LEFT;
      textField.text = "fÁ";
      textField.setTextFormat(textField.defaultTextFormat);
      if (textType == EnumTextTypes.TEXT_TYPE_BRIGHT())
      {
        textFieldHeightBright = textField.height;
        textFieldHeightBrightCorrection = textFieldHeightBright / 10;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_MID())
      {
        textFieldHeightMid = textField.height;
        textFieldHeightMidCorrection = textFieldHeightMid / 10;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        textFieldHeightDark = textField.height;
        textFieldHeightDarkCorrection = textFieldHeightDark / 10;
      }
      application.trace("<" + this + " DynamicsConfig setTextFieldHeight> textFieldHeightBright: " + textFieldHeightBright, 0);
      application.trace("<" + this + " DynamicsConfig setTextFieldHeight> textFieldHeightMid: " + textFieldHeightMid, 0);
      application.trace("<" + this + " DynamicsConfig setTextFieldHeight> textFieldHeightDark: " + textFieldHeightDark, 0);
    }
    private function setAllTextFieldHeights():void
    {
      application.trace("<" + this + " DynamicsConfig setAllTextFieldHeights> called.", 1);
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID());
      setTextFieldHeight(EnumTextTypes.TEXT_TYPE_DARK());
    }
    public function setAllFontSizes(i:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAllFontSizes> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAllFontSizes> i: " + i, 0);
      textFormatBright.size = i;
      textFormatMid.size = i;
      textFormatDark.size = i;
      setAllTextFieldHeights();
      application.getBaseEventDispatcher().dispatchEvent(eventAppFontSizeChanged);
      application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
      application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
      application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
      saveDisplaying();
    }
    public function getTextFieldHeight(textType:String = ""):int
    {
      application.trace("<" + this + " DynamicsConfig getTextFieldHeight> called.", 1);
      application.trace("<" + this + " DynamicsConfig getTextFieldHeight> textType: " + textType, 0);
      var val:int = 0;
      if (textType == EnumTextTypes.TEXT_TYPE_MID())
      {
        val = textFieldHeightMid;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        val = textFieldHeightDark;
      }
      else
      {
        val = textFieldHeightBright;
      }
      application.trace("<" + this + " DynamicsConfig getTextFieldHeight> " + val, 0);
      return val;
    }
    public function getTextFieldHeightCorrection(textType:String = ""):int
    {
      application.trace("<" + this + " DynamicsConfig getTextFieldHeightCorrection> called.", 1);
      application.trace("<" + this + " DynamicsConfig getTextFieldHeightCorrection> textType: " + textType, 0);
      var val:int = 0;
      if (textType == EnumTextTypes.TEXT_TYPE_MID())
      {
        val = textFieldHeightMidCorrection;
      }
      else if (textType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        val = textFieldHeightDarkCorrection;
      }
      else
      {
        val = textFieldHeightBrightCorrection;
      }
      application.trace("<" + this + " DynamicsConfig getTextFieldHeightCorrection> " + val, 0);
      return val;
    }
    private function getRandomPixelFromBg():Number
    {
      application.trace("<" + this + " DynamicsConfig getRandomPixelFromBg> called.", 1);
      var n:Number = 0;
      if (bitmapData != null)
      {
        const rx:int = Math.round(Math.random() * bitmapData.width);
        const ry:int = Math.round(Math.random() * bitmapData.height);
        n = bitmapData.getPixel(rx, ry);
      }
      else
      {
        n = Math.round(Math.random() * application.getComponentsConfig().getColorToCalcComplementer());
      }
      application.trace("<" + this + " DynamicsConfig getRandomPixelFromBg> random px is: " + n, 0);
      return n;
    }
    public function getNewRandomBackgroundColorSchema(cb:Number = -1, cm:Number = -1, cd:Number = -1, toSave:Boolean = true):void
    {
      application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> called.", 1);
      application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> cb: " + cb, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> cm: " + cm, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> cd: " + cd, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> toSave: " + toSave, 0);
      if (!appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()] || !appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
      {
        application.trace("<" + this + " DynamicsConfig getNewRandomBackgroundColorSchema> get.", 0);
        const newBackgroundColorBright:Number = cb == -1 ? getRandomPixelFromBg() : cb;
        const newBackgroundColorMid:Number = cm == -1 ? getRandomPixelFromBg() : cm;
        const newBackgroundColorDark:Number = cd == -1 ? getRandomPixelFromBg() : cd;
        appBackgroundColorBright = newBackgroundColorBright;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorBright()] = application.getUtils().colorToString(appBackgroundColorBright);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorBrightChanged);
        appBackgroundColorMid = newBackgroundColorMid;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorMid()] = application.getUtils().colorToString(appBackgroundColorMid);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorMidChanged);
        appBackgroundColorDark = newBackgroundColorDark;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorDark()] = application.getUtils().colorToString(appBackgroundColorDark);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorDarkChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
        {
          getNewRandomFontColorSchema(application.getComponentsConfig().getColorToCalcComplementer() - newBackgroundColorBright, application.getComponentsConfig().getColorToCalcComplementer() - newBackgroundColorMid, application.getComponentsConfig().getColorToCalcComplementer() - newBackgroundColorDark, false);
        }
        if (toSave)
        {
          saveDisplaying();
        }
      }
    }
    public function getNewRandomFontColorSchema(cb:Number = -1, cm:Number = -1, cd:Number = -1, toSave:Boolean = true):void
    {
      application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> called.", 1);
      application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> cb: " + cb, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> cm: " + cm, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> cd: " + cd, 0);
      application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> toSave: " + toSave, 0);
      if (!appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()] || !appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
      {
        application.trace("<" + this + " DynamicsConfig getNewRandomFontColorSchema> get.", 0);
        const newFontColorBright:Number = cb == -1 ? getRandomPixelFromBg() : cb;
        const newFontColorMid:Number = cm == -1 ? getRandomPixelFromBg() : cm;
        const newFontColorDark:Number = cd == -1 ? getRandomPixelFromBg() : cd;
        appFontColorBright = newFontColorBright;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorBright()] = application.getUtils().colorToString(appFontColorBright);
        textFormatBright.color = appFontColorBright;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorBrightChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        appFontColorMid = newFontColorMid;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorMid()] = application.getUtils().colorToString(appFontColorMid);
        textFormatMid.color = appFontColorMid;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorMidChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        appFontColorDark = newFontColorDark;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorDark()] = application.getUtils().colorToString(appFontColorDark);
        textFormatDark.color = appFontColorDark;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorDarkChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()])
        {
          getNewRandomBackgroundColorSchema(application.getComponentsConfig().getColorToCalcComplementer() - newFontColorBright, application.getComponentsConfig().getColorToCalcComplementer() - newFontColorMid, application.getComponentsConfig().getColorToCalcComplementer() - newFontColorDark, false);
        }
        if (toSave)
        {
          saveDisplaying();
        }
      }
    }
    public function getAppOrientation():String
    {
      return appOrientation;
    }
    public function setAppOrientation(newOrientation:String):void
    {
      application.trace("<" + this + " DynamicsConfig setAppOrientation> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppOrientation> newOrientation: " + newOrientation, 0);
      if (appOrientation != newOrientation)
      {
        application.trace("<" + this + " DynamicsConfig setAppOrientation> changing.", 0);
        if (newOrientation == EnumOrientations.ORIENTATION_VERTICAL())
        {
          appOrientation = EnumOrientations.ORIENTATION_VERTICAL();
        }
        else if (newOrientation == EnumOrientations.ORIENTATION_HORIZONTAL())
        {
          appOrientation = EnumOrientations.ORIENTATION_HORIZONTAL();
        }
        else
        {
          appOrientation = EnumOrientations.ORIENTATION_MANUAL();
        }
        application.getBaseEventDispatcher().dispatchEvent(eventAppOrientationChanged);
      }
    }
    private function changeAppOrientationIfManual():void
    {
      application.trace("<" + this + " DynamicsConfig changeAppOrientationIfManual> called.", 1);
      if (appOrientation == EnumOrientations.ORIENTATION_MANUAL())
      {
        application.trace("<" + this + " DynamicsConfig changeAppOrientationIfManual> changing.", 0);
        setAppOrientation(EnumOrientations.ORIENTATION_VERTICAL());
      }
    }
    public function getAppWidgetMode():String
    {
      return appWidgetMode;
    }
    public function setAppWidgetMode(newWidgetMode:String):void
    {
      application.trace("<" + this + " DynamicsConfig setAppWidgetMode> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppWidgetMode> newWidgetMode: " + newWidgetMode, 0);
      if (appWidgetMode != newWidgetMode)
      {
        application.trace("<" + this + " DynamicsConfig setAppWidgetMode> changing.", 0);
        if (newWidgetMode == EnumWidgetModes.WIDGET_MODE_DESKTOP())
        {
          appWidgetMode = EnumWidgetModes.WIDGET_MODE_DESKTOP();
        }
        else if (newWidgetMode == EnumWidgetModes.WIDGET_MODE_MOBILE())
        {
          appWidgetMode = EnumWidgetModes.WIDGET_MODE_MOBILE();
          setAppBackgroundLive(false);
          changeAppOrientationIfManual();
        }
        else
        {
          appWidgetMode = EnumWidgetModes.WIDGET_MODE_AUTOMATIC();
          changeAppOrientationIfManual();
        }
        application.getBaseEventDispatcher().dispatchEvent(eventAppWidgetModeChanged);
      }
    }
    public function getAppSoundVolume():int
    {
      return appSoundVolume;
    }
    public function setAppSoundVolume(newSoundVolume:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppSoundVolume> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppSoundVolume> newSoundVolume: " + newSoundVolume, 0);
      if (appSoundVolume != newSoundVolume)
      {
        application.trace("<" + this + " DynamicsConfig setAppSoundVolume> changing.", 0);
        appSoundVolume = newSoundVolume;
        application.getBaseEventDispatcher().dispatchEvent(eventAppSoundVolumeChanged);
      }
    }
    public function getAppSoundPlaying():Boolean
    {
      return appSoundPlaying;
    }
    public function setAppSoundPlaying(newSoundPlaying:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppSoundPlaying> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppSoundPlaying> newSoundPlaying: " + newSoundPlaying, 0);
      if (appSoundPlaying != newSoundPlaying)
      {
        application.trace("<" + this + " DynamicsConfig setAppSoundPlaying> changing.", 0);
        appSoundPlaying = newSoundPlaying;
        application.getBaseEventDispatcher().dispatchEvent(eventAppSoundPlayingChanged);
      }
    }
    public function getAppLineThickness():int
    {
      return appLineThickness;
    }
    public function setAppLineThickness(newLineThickness:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppLineThickness> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppLineThickness> newLineThickness: " + newLineThickness, 0);
      if (appLineThickness != newLineThickness)
      {
        application.trace("<" + this + " DynamicsConfig setAppLineThickness> changing.", 0);
        appLineThickness = newLineThickness;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appLineThickness()] = appLineThickness;
        application.getBaseEventDispatcher().dispatchEvent(eventAppLineThicknessChanged);
        saveDisplaying();
      }
    }
    public function getAppMargin():int
    {
      return appMargin;
    }
    public function setAppMargin(newMargin:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppMargin> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppMargin> newMargin: " + newMargin, 0);
      if (appMargin != newMargin)
      {
        application.trace("<" + this + " DynamicsConfig setAppMargin> changing.", 0);
        appMargin = newMargin;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appMargin()] = appMargin;
        application.getBaseEventDispatcher().dispatchEvent(eventAppMarginChanged);
        saveDisplaying();
      }
    }
    public function getAppPadding():int
    {
      return appPadding;
    }
    public function setAppPadding(newPadding:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppPadding> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppPadding> newPadding: " + newPadding, 0);
      if (appPadding != newPadding)
      {
        application.trace("<" + this + " DynamicsConfig setAppPadding> changing.", 0);
        appPadding = newPadding;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appPadding()] = appPadding;
        application.getBaseEventDispatcher().dispatchEvent(eventAppPaddingChanged);
        saveDisplaying();
      }
    }
    public function getAppRadius():int
    {
      return appRadius;
    }
    public function setAppRadius(newRadius:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppRadius> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppRadius> newRadius: " + newRadius, 0);
      if (appRadius != newRadius)
      {
        application.trace("<" + this + " DynamicsConfig setAppRadius> changing.", 0);
        appRadius = newRadius;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appRadius()] = appRadius;
        application.getBaseEventDispatcher().dispatchEvent(eventAppRadiusChanged);
        saveDisplaying();
      }
    }
    public function getAppBoxCorner():int
    {
      return appBoxCorner;
    }
    public function setAppBoxCorner(newBoxCorner:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBoxCorner> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBoxCorner> newBoxCorner: " + newBoxCorner, 0);
      if (appBoxCorner != newBoxCorner)
      {
        application.trace("<" + this + " DynamicsConfig setAppBoxCorner> changing.", 0);
        appBoxCorner = newBoxCorner;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxCorner()] = appBoxCorner;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBoxCornerChanged);
        saveDisplaying();
      }
    }
    public function getAppBoxFrame():String
    {
      return appBoxFrame;
    }
    public function setAppBoxFrame(newBoxFrame:String):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBoxFrame> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBoxFrame> newBoxFrame: " + newBoxFrame, 0);
      if (appBoxFrame != newBoxFrame)
      {
        application.trace("<" + this + " DynamicsConfig setAppBoxFrame> changing.", 0);
        if (newBoxFrame == EnumBoxFrames.BOX_FRAME_FULL()
            || newBoxFrame == EnumBoxFrames.BOX_FRAME_HORIZONTAL()
            || newBoxFrame == EnumBoxFrames.BOX_FRAME_VERTICAL()
            || newBoxFrame == EnumBoxFrames.BOX_FRAME_NONE())
        {
          application.trace("<" + this + " DynamicsConfig setAppBoxFrame> changing..", 0);
          appBoxFrame = newBoxFrame;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBoxFrame()] = appBoxFrame;
          application.getBaseEventDispatcher().dispatchEvent(eventAppBoxFrameChanged);
          saveDisplaying();
        }
      }
    }
    public function getAppBackgroundColorRand():Boolean
    {
      return appBackgroundColorRand;
    }
    public function setAppBackgroundColorRand(newBackgroundColorRand:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorRand> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorRand> newBackgroundColorRand: " + newBackgroundColorRand, 0);
      if (appBackgroundColorRand != newBackgroundColorRand)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorRand> changing.", 0);
        if (newBackgroundColorRand && appFontColorRand)
        {
          appFontColorRand = false;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()] = appFontColorRand;
          application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorRandChanged);
        }
        appBackgroundColorRand = newBackgroundColorRand;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()] = appBackgroundColorRand;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorRandChanged);
        if (appBackgroundColorRand)
        {
          getNewRandomBackgroundColorSchema(-1, -1, -1, false);
        }
        saveDisplaying();
      }
    }
    public function getAppBackgroundColorToFont():Boolean
    {
      return appBackgroundColorToFont;
    }
    public function setAppBackgroundColorToFont(newBackgroundColorToFont:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorToFont> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorToFont> newBackgroundColorToFont: " + newBackgroundColorToFont, 0);
      if (appBackgroundColorToFont != newBackgroundColorToFont)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorToFont> changing.", 0);
        if (newBackgroundColorToFont && appFontColorToBackground)
        {
          appFontColorToBackground = false;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()] = appFontColorToBackground;
          application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorToBackgroundChanged);
        }
        appBackgroundColorToFont = newBackgroundColorToFont;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()] = appBackgroundColorToFont;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorToFontChanged);
        if (appBackgroundColorToFont)
        {
          getNewRandomFontColorSchema(application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorBright, application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorMid, application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorDark, false);
        }
        saveDisplaying();
      }
    }
    public function getAppBackgroundColorDark():Number
    {
      return appBackgroundColorDark;
    }
    public function setAppBackgroundColorDark(newBackgroundColorDark:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorDark> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorDark> newBackgroundColorDark: " + newBackgroundColorDark, 0);
      if (appBackgroundColorDark != newBackgroundColorDark)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorDark> changing.", 0);
        appBackgroundColorDark = newBackgroundColorDark;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorDark()] = application.getUtils().colorToString(appBackgroundColorDark);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorDarkChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
        {
          appFontColorDark = application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorDark;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorDark()] = application.getUtils().colorToString(appFontColorDark);
          textFormatDark.color = appFontColorDark;
          application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorDarkChanged);
          application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppBackgroundColorMid():Number
    {
      return appBackgroundColorMid;
    }
    public function setAppBackgroundColorMid(newBackgroundColorMid:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorMid> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorMid> newBackgroundColorMid: " + newBackgroundColorMid, 0);
      if (appBackgroundColorMid != newBackgroundColorMid)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorMid> changing.", 0);
        appBackgroundColorMid = newBackgroundColorMid;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorMid()] = application.getUtils().colorToString(appBackgroundColorMid);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorMidChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
        {
          appFontColorMid = application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorMid;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorMid()] = application.getUtils().colorToString(appFontColorMid);
          textFormatMid.color = appFontColorMid;
          application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorMidChanged);
          application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppBackgroundColorBright():Number
    {
      return appBackgroundColorBright;
    }
    public function setAppBackgroundColorBright(newBackgroundColorBright:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorBright> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorBright> newBoxFrame: " + newBackgroundColorBright, 0);
      if (appBackgroundColorBright != newBackgroundColorBright)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorBright> changing.", 0);
        appBackgroundColorBright = newBackgroundColorBright;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorBright()] = application.getUtils().colorToString(appBackgroundColorBright);
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorBrightChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()])
        {
          appFontColorBright = application.getComponentsConfig().getColorToCalcComplementer() - appBackgroundColorBright;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorBright()] = application.getUtils().colorToString(appFontColorBright);
          textFormatBright.color = appFontColorBright;
          application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorBrightChanged);
          application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppBackgroundColorAlpha():Number
    {
      return appBackgroundColorAlpha;
    }
    public function setAppBackgroundColorAlpha(newColorAlpha:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorAlpha> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundColorAlpha> newBoxFrame: " + newColorAlpha, 0);
      if (appBackgroundColorAlpha != newColorAlpha)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundColorAlpha> changing.", 0);
        appBackgroundColorAlpha = newColorAlpha;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorAlpha()] = appBackgroundColorAlpha;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorAlphaChanged);
        saveDisplaying();
      }
    }
    public function getAppBackgroundImage():String
    {
      return appBackgroundImage;
    }
    /**
     * Returns the file name of the background image of the current displaying style, or
     * an empty string when that style displays the embedded background or no background
     * at all. A style registered with a whole url of its own answers the file name on the
     * end of that url, so this is the value to be displayed to the one using this
     * application.
     */
    public function getAppBackgroundImageFile():String
    {
      application.trace("<" + this + " DynamicsConfig getAppBackgroundImageFile> called.", 1);
      const file:String = appBackgroundImages[appBackgroundImage] as String;
      if (file == null || file == "")
      {
        application.trace("<" + this + " DynamicsConfig getAppBackgroundImageFile> the current style has no background image file.", 0);
        return "";
      }
      return file.substring(file.lastIndexOf("/") + 1);
    }
    public function changeBgImage(style:String, bgurl:String):void
    {
      application.trace("<" + this + " DynamicsConfig changeBgImage> called.", 1);
      application.trace("<" + this + " DynamicsConfig changeBgImage> style: " + style, 0);
      application.trace("<" + this + " DynamicsConfig changeBgImage> bgurl: " + bgurl, 0);
      appBackgroundImages[style] = bgurl;
    }
    public function setAppBackgroundImage(force:Boolean = false):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundImage> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundImage> force: " + force, 0);
      if (force || appBackgroundImage != appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundImage()])
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundImage> set.", 0);
        appBackgroundImage = appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundImage()];
        disposeBitmapData();
        if (appBackgroundImages[appBackgroundImage] == null)
        {
          drawBitmapDataFromSource(application.getBackgroundManager().getEmbeddedBackgroundBitmap().bitmapData);
          dispatchEventAppBackgroundImageChanged();
        }
        else if (appBackgroundImages[appBackgroundImage] == "")
        {
          createEmptyBitmapData();
          dispatchEventAppBackgroundImageChanged();
        }
        else
        {
          destImage();
          image = new Image(application);
          image.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FILE_LOADED(), imageLoaded);
          loadImage();
        }
      }
    }
    private function dispatchEventAppBackgroundImageChanged():void
    {
      application.trace("<" + this + " DynamicsConfig dispatchEventAppBackgroundImageChanged> called.", 1);
      applyCurrentDisplayingStyleColorModes();
      if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()])
      {
        getNewRandomFontColorSchema();
      }
      if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()])
      {
        getNewRandomBackgroundColorSchema();
      }
      if (application != null && application.getBaseEventDispatcher() != null && eventAppBackgroundImageChanged != null)
      {
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundImageChanged);
      }
    }
    private function disposeBitmapData():void
    {
      application.trace("<" + this + " DynamicsConfig disposeBitmapData> called.", 1);
      if (bitmapData != null)
      {
        bitmapData.dispose();
        bitmapData = null;
      }
    }
    /**
     * Frees the picture the displayed background is derived from.
     */
    private function disposeSourceBitmapData():void
    {
      application.trace("<" + this + " DynamicsConfig disposeSourceBitmapData> called.", 1);
      if (sourceBitmapData != null)
      {
        sourceBitmapData.dispose();
        sourceBitmapData = null;
      }
    }
    private function destImage():void
    {
      application.trace("<" + this + " DynamicsConfig destImage> called.", 1);
      if (image != null)
      {
        image.destroy();
        image = null;
      }
    }
    public function getBitmapData():BitmapData
    {
      return bitmapData;
    }
    private function imageLoaded(e:Event):void
    {
      application.trace("<" + this + " DynamicsConfig imageLoaded> called.", 1);
      application.trace("<" + this + " DynamicsConfig imageLoaded> e: " + e, 0);
      if (application != null)
      {
        if (image != null)
        {
          if (image.getBitmapData() != null)
          {
            drawBitmapDataFromSource(image.getBitmapData());
          }
          else
          {
            createEmptyBitmapData();
          }
          // the picture has been copied into the bitmap data of this config, so the image
          // that has loaded it is freed right here instead of on the next style change: it
          // holds a copy of that picture in the size it has arrived in
          destImage();
        }
        dispatchEventAppBackgroundImageChanged();
      }
    }
    public function getAppBackgroundAlign():String
    {
      return appBackgroundAlign;
    }
    public function setAppBackgroundAlign(newBackgroundAlign:String):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundAlign> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundAlign> newBackgroundAlign: " + newBackgroundAlign, 0);
      if (appBackgroundAlign != newBackgroundAlign)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundAlign> changing.", 0);
        if (newBackgroundAlign == EnumBackgroundAligns.BACKGROUND_ALIGN_NONE() || newBackgroundAlign == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER1() || newBackgroundAlign == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER2() || newBackgroundAlign == EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER3() || newBackgroundAlign == EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC())
        {
          application.trace("<" + this + " DynamicsConfig setAppBackgroundAlign> changing..", 0);
          appBackgroundAlign = newBackgroundAlign;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlign()] = appBackgroundAlign;
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundAlignChanged);
          saveDisplaying();
        }
      }
    }
    public function getAppBackgroundAlpha():Number
    {
      return appBackgroundAlpha;
    }
    public function setAppBackgroundAlpha(newAppBackgroundAlpha:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundAlpha> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundAlpha> newAppBackgroundAlpha: " + newAppBackgroundAlpha, 0);
      if (appBackgroundAlpha != newAppBackgroundAlpha)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundAlpha> changing.", 0);
        appBackgroundAlpha = newAppBackgroundAlpha;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundAlpha()] = appBackgroundAlpha;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundAlphaChanged);
        saveDisplaying();
      }
    }
    public function getAppBackgroundBlur():int
    {
      return appBackgroundBlur;
    }
    public function setAppBackgroundBlur(newAppBackgroundBlur:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundBlur> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundBlur> newAppBackgroundBlur: " + newAppBackgroundBlur, 0);
      if (appBackgroundBlur != newAppBackgroundBlur)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundBlur> changing.", 0);
        appBackgroundBlur = newAppBackgroundBlur;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundBlur()] = appBackgroundBlur;
        // the kept picture carries no blur, so the new one is drawn out of it: the loading
        // of the background image is never repeated for a changed blur
        drawBitmapDataFromSourceBitmapData();
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundBlurChanged);
        saveDisplaying();
      }
    }
    /**
     * Draws the background image of this config from the given picture. The picture is
     * scaled down to the background image cap of the components config first, so a photo
     * of many megapixels does not hold its whole size in the memory: the background paints
     * it scaled to the stage anyway. The blur is applied on that scaled picture, so the
     * strength of it counts in the pixels that are really displayed.
     * @param srcBitmapData the picture the background image is drawn from
     */
    private function drawBitmapDataFromSource(srcBitmapData:BitmapData):void
    {
      application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSource> called.", 1);
      application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSource> srcBitmapData: " + srcBitmapData, 0);
      disposeSourceBitmapData();
      try
      {
        sourceBitmapData = getScaledBitmapData(srcBitmapData);
      }
      catch (e:*)
      {
        application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSource> the picture could not be taken: " + e, 7);
        createEmptyBitmapData();
        return;
      }
      drawBitmapDataFromSourceBitmapData();
    }
    /**
     * Draws the displayed background out of the picture this config keeps, applying the
     * blur of the current displaying style on it. The kept picture carries no blur, so
     * changing that blur only has to call this one again.
     */
    private function drawBitmapDataFromSourceBitmapData():void
    {
      application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSourceBitmapData> called.", 1);
      disposeBitmapData();
      if (sourceBitmapData == null)
      {
        application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSourceBitmapData> there is no picture to draw from.", 0);
        createEmptyBitmapData();
        return;
      }
      try
      {
        bitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, false);
        if (appBackgroundBlur > 0 && appBackgroundBlur < 13)
        {
          bitmapData.applyFilter(sourceBitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(0, 0), new BlurFilter(appBackgroundBlur, appBackgroundBlur, appBackgroundBlur));
        }
        else
        {
          bitmapData.draw(sourceBitmapData);
        }
      }
      catch (e:*)
      {
        application.trace("<" + this + " DynamicsConfig drawBitmapDataFromSourceBitmapData> the background image could not be drawn: " + e, 7);
        createEmptyBitmapData();
      }
    }
    /**
     * Returns the given picture drawn into a bitmap data of its own, scaled down when its
     * larger side is over the background image cap of the components config. The mosaic
     * align repeats the picture at its own size over the whole stage, so a mosaic one is
     * never scaled: shrinking that would shrink the tiles of it as well.
     * @param srcBitmapData the picture the background image is drawn from
     */
    private function getScaledBitmapData(srcBitmapData:BitmapData):BitmapData
    {
      application.trace("<" + this + " DynamicsConfig getScaledBitmapData> called.", 1);
      application.trace("<" + this + " DynamicsConfig getScaledBitmapData> srcBitmapData: " + srcBitmapData, 0);
      const maxSize:int = application.getComponentsConfig().getBackgroundImageMaxSize();
      const largerSide:int = srcBitmapData.width > srcBitmapData.height ? srcBitmapData.width : srcBitmapData.height;
      const toBeScaled:Boolean = maxSize > 0 && largerSide > maxSize
          && appBackgroundAlign != EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC();
      if (!toBeScaled)
      {
        application.trace("<" + this + " DynamicsConfig getScaledBitmapData> the picture is kept in its own size.", 0);
        const sameBitmapData:BitmapData = new BitmapData(srcBitmapData.width, srcBitmapData.height, false);
        sameBitmapData.draw(srcBitmapData);
        return sameBitmapData;
      }
      const scale:Number = maxSize / largerSide;
      const newWidth:int = Math.max(1, Math.round(srcBitmapData.width * scale));
      const newHeight:int = Math.max(1, Math.round(srcBitmapData.height * scale));
      application.trace("<" + this + " DynamicsConfig getScaledBitmapData> scaling " + srcBitmapData.width + "x" + srcBitmapData.height + " down to " + newWidth + "x" + newHeight, 0);
      const matrix:Matrix = new Matrix();
      matrix.scale(scale, scale);
      const newBitmapData:BitmapData = new BitmapData(newWidth, newHeight, false);
      // the smoothing is the one keeping a picture of many megapixels clean while it loses
      // the most of its pixels here
      newBitmapData.draw(srcBitmapData, matrix, null, null, null, true);
      return newBitmapData;
    }
    private function createEmptyBitmapData():void
    {
      application.trace("<" + this + " DynamicsConfig createEmptyBitmapData> called.", 1);
      disposeSourceBitmapData();
      bitmapData = new BitmapData(1, 1, false);
    }
    public function getAppBackgroundLive():Boolean
    {
      return appBackgroundLive;
    }
    public function setAppBackgroundLive(newBackgroundLive:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppBackgroundLive> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppBackgroundLive> newBackgroundLive: " + newBackgroundLive, 0);
      if (appBackgroundLive != newBackgroundLive)
      {
        application.trace("<" + this + " DynamicsConfig setAppBackgroundLive> changing.", 0);
        appBackgroundLive = newBackgroundLive;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundLive()] = appBackgroundLive;
        application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundLiveChanged);
        saveDisplaying();
      }
    }
    public function getAppFontFace():String
    {
      return appFontFace;
    }
    public function setAppFontFace(newFontFace:String):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontFace> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontFace> newFontFace: " + newFontFace, 0);
      if (appFontFace != newFontFace)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontFace> changing.", 0);
        appFontFace = newFontFace;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontFace()] = appFontFace;
        textFormatBright.font = appFontFace;
        textFormatMid.font = appFontFace;
        textFormatDark.font = appFontFace;
        setAllTextFieldHeights();
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontFaceChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        saveDisplaying();
      }
    }
    public function getAppFontSize():int
    {
      return appFontSize;
    }
    public function setAppFontSize(newFontSize:int):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontSize> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontSize> newFontSize: " + newFontSize, 0);
      if (appFontSize != newFontSize || newFontSize == 0)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontSize> changing.", 0);
        if (newFontSize > 0)
        {
          appFontSize = newFontSize;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontSize()] = appFontSize;
          setAllFontSizes(appFontSize);
        }
        else
        {
          appFontSize = 0;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontSize()] = appFontSize;
          setAllFontSizes(application.calcFontSizeFromStageSize());
        }
      }
    }
    public function getAppFontColorBright():Number
    {
      return appFontColorBright;
    }
    public function setAppFontColorBright(newFontColorBright:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontColorBright> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontColorBright> newFontColorBright: " + newFontColorBright, 0);
      if (appFontColorBright != newFontColorBright)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontColorBright> changing.", 0);
        appFontColorBright = newFontColorBright;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorBright()] = application.getUtils().colorToString(appFontColorBright);
        textFormatBright.color = appFontColorBright;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorBrightChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()])
        {
          appBackgroundColorBright = application.getComponentsConfig().getColorToCalcComplementer() - appFontColorBright;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorBright()] = application.getUtils().colorToString(appBackgroundColorBright);
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorBrightChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppFontColorMid():Number
    {
      return appFontColorMid;
    }
    public function setAppFontColorMid(newFontColorMid:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontColorMid> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontColorMid> newFontColorMid: " + newFontColorMid, 0);
      if (appFontColorMid != newFontColorMid)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontColorMid> changing.", 0);
        appFontColorMid = newFontColorMid;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorMid()] = application.getUtils().colorToString(appFontColorMid);
        textFormatMid.color = appFontColorMid;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorMidChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()])
        {
          appBackgroundColorMid = application.getComponentsConfig().getColorToCalcComplementer() - appFontColorMid;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorMid()] = application.getUtils().colorToString(appBackgroundColorMid);
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorMidChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppFontColorDark():Number
    {
      return appFontColorDark;
    }
    public function setAppFontColorDark(newFontColorDark:Number):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontColorDark> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontColorDark> newFontColorDark: " + newFontColorDark, 0);
      if (appFontColorDark != newFontColorDark)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontColorDark> changing.", 0);
        appFontColorDark = newFontColorDark;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorDark()] = application.getUtils().colorToString(appFontColorDark);
        textFormatDark.color = appFontColorDark;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorDarkChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        if (appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()])
        {
          appBackgroundColorDark = application.getComponentsConfig().getColorToCalcComplementer() - appFontColorDark;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorDark()] = application.getUtils().colorToString(appBackgroundColorDark);
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorDarkChanged);
        }
        saveDisplaying();
      }
    }
    public function getAppFontColorRand():Boolean
    {
      return appFontColorRand;
    }
    public function setAppFontColorRand(newFontColorRand:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontColorRand> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontColorRand> newFontColorRand: " + newFontColorRand, 0);
      if (appFontColorRand != newFontColorRand)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontColorRand> changing.", 0);
        if (newFontColorRand && appBackgroundColorRand)
        {
          appBackgroundColorRand = false;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()] = appBackgroundColorRand;
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorRandChanged);
        }
        appFontColorRand = newFontColorRand;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()] = appFontColorRand;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorRandChanged);
        if (appFontColorRand)
        {
          getNewRandomFontColorSchema(-1, -1, -1, false);
        }
        saveDisplaying();
      }
    }
    public function getAppFontColorToBackground():Boolean
    {
      return appFontColorToBackground;
    }
    public function setAppFontColorToBackground(newFontColorToBackground:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontColorToBackground> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontColorToBackground> newFontColorToBackground: " + newFontColorToBackground, 0);
      if (appFontColorToBackground != newFontColorToBackground)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontColorToBackground> changing.", 0);
        if (newFontColorToBackground && appBackgroundColorToFont)
        {
          appBackgroundColorToFont = false;
          appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()] = appBackgroundColorToFont;
          application.getBaseEventDispatcher().dispatchEvent(eventAppBackgroundColorToFontChanged);
        }
        appFontColorToBackground = newFontColorToBackground;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()] = appFontColorToBackground;
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontColorToBackgroundChanged);
        if (appFontColorToBackground)
        {
          getNewRandomBackgroundColorSchema(application.getComponentsConfig().getColorToCalcComplementer() - appFontColorBright, application.getComponentsConfig().getColorToCalcComplementer() - appFontColorMid, application.getComponentsConfig().getColorToCalcComplementer() - appFontColorDark, false);
        }
        saveDisplaying();
      }
    }
    public function getAppFontBold():Boolean
    {
      return appFontBold;
    }
    public function setAppFontBold(newFontBold:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontBold> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontBold> newFontBold: " + newFontBold, 0);
      if (appFontBold != newFontBold)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontBold> changing.", 0);
        appFontBold = newFontBold;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontBold()] = appFontBold;
        textFormatBright.bold = appFontBold;
        textFormatMid.bold = appFontBold;
        textFormatDark.bold = appFontBold;
        setAllTextFieldHeights();
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontBoldChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        saveDisplaying();
      }
    }
    public function getAppFontItalic():Boolean
    {
      return appFontItalic;
    }
    public function setAppFontItalic(newFontItalic:Boolean):void
    {
      application.trace("<" + this + " DynamicsConfig setAppFontItalic> called.", 1);
      application.trace("<" + this + " DynamicsConfig setAppFontItalic> newFontItalic: " + newFontItalic, 0);
      if (appFontItalic != newFontItalic)
      {
        application.trace("<" + this + " DynamicsConfig setAppFontItalic> changing.", 0);
        appFontItalic = newFontItalic;
        appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontItalic()] = appFontItalic;
        textFormatBright.italic = appFontItalic;
        textFormatMid.italic = appFontItalic;
        textFormatDark.italic = appFontItalic;
        setAllTextFieldHeights();
        application.getBaseEventDispatcher().dispatchEvent(eventAppFontItalicChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatBrightChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatMidChanged);
        application.getBaseEventDispatcher().dispatchEvent(eventTextFormatDarkChanged);
        saveDisplaying();
      }
    }
    public function getTextFormatBright():TextFormat
    {
      return textFormatBright;
    }
    public function getTextFormatMid():TextFormat
    {
      return textFormatMid;
    }
    public function getTextFormatDark():TextFormat
    {
      return textFormatDark;
    }
    /**
     * Loads the background image of the current displaying style into the image of this
     * config. The styles register their images by file name, so the backgrounds folder of
     * the framework server is put in front of that name; a style bringing a whole url of
     * its own is loaded from that url as it is.
     */
    protected function loadImage():void
    {
      application.trace("<" + this + " DynamicsConfig loadImage> called.", 1);
      if (image == null)
      {
        application.trace("<" + this + " DynamicsConfig loadImage> there is no image to load into!", 6);
        return;
      }
      const url:String = getBackgroundImageUrl();
      if (url == "")
      {
        application.trace("<" + this + " DynamicsConfig loadImage> the current style has no background image to load!", 6);
        return;
      }
      image.loadUrl(url);
    }
    protected function saveDisplaying():void
    {
      application.trace("<" + this + " DynamicsConfig saveDisplaying> called.", 1);
    }
    protected function displayingStyleHasChanged():void
    {
      application.trace("<" + this + " DynamicsConfig displayingStyleHasChanged> called.", 1);
    }
    /**
     * Returns the properties of the displaying style of the given text key, or null when
     * this application has no style of that key at all.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     */
    private function getDisplayingStyleOf(styleKey:String):Array
    {
      application.trace("<" + this + " DynamicsConfig getDisplayingStyleOf> called.", 1);
      application.trace("<" + this + " DynamicsConfig getDisplayingStyleOf> styleKey: " + styleKey, 0);
      const style:Array = appDisplayingStyles[styleKey] as Array;
      if (style == null)
      {
        application.trace("<" + this + " DynamicsConfig getDisplayingStyleOf> there is no displaying style of the key " + styleKey + "!", 6);
      }
      return style;
    }
    /**
     * Sets one property of one displaying style, in the values of that style and in the
     * default values of it as well. setDisplayingStyleColors and setDisplayingStyleShaping
     * are the callers of it: they carry the very values a style is described with, so
     * those values are the ones the resetting of that style has to give back.
     * @param styleKey the text key of the style, an EnumDisplayingStyles value
     * @param propertyKey the text key of the property, an EnumAppDisplayedProperties value
     * @param value the new value of that property
     */
    private function setDisplayingStyleProperty(styleKey:String, propertyKey:String, value:*):void
    {
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleProperty> called.", 1);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleProperty> styleKey: " + styleKey, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleProperty> propertyKey: " + propertyKey, 0);
      application.trace("<" + this + " DynamicsConfig setDisplayingStyleProperty> value: " + value, 0);
      const style:Array = appDisplayingStyles[styleKey] as Array;
      if (style != null)
      {
        style[propertyKey] = value;
      }
      const defaults:Array = appDisplayingStyleDefaults[styleKey] as Array;
      if (defaults != null)
      {
        defaults[propertyKey] = value;
      }
    }
    /**
     * Returns a copy of the properties of one displaying style. A style holds its values
     * by the text keys of them, so the copy is built value by value: a style and the
     * default values of it are two arrays of their own and never one shared reference.
     * @param style the properties of the style to copy
     */
    private function copyDisplayingStyle(style:Array):Array
    {
      application.trace("<" + this + " DynamicsConfig copyDisplayingStyle> called.", 1);
      application.trace("<" + this + " DynamicsConfig copyDisplayingStyle> style: " + style, 0);
      const copy:Array = new Array();
      for (var propertyKey:String in style)
      {
        copy[propertyKey] = style[propertyKey];
      }
      return copy;
    }
    /**
     * Gives the four color modes of the application the values the current displaying
     * style describes: the two ones painting a random color schema and the two ones
     * deriving the colors of the texts from the colors of the background and back. They
     * stand outside applyCurrentDisplayingStyle on purpose: a mode painting the colors of
     * a background image can only be applied once that very image is there, so the
     * loading of it is the one applying them on a style switch.
     */
    private function applyCurrentDisplayingStyleColorModes():void
    {
      application.trace("<" + this + " DynamicsConfig applyCurrentDisplayingStyleColorModes> called.", 1);
      setAppBackgroundColorRand(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorRand()]);
      setAppBackgroundColorToFont(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appBackgroundColorToFont()]);
      setAppFontColorRand(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorRand()]);
      setAppFontColorToBackground(appDisplayingStyles[currentDisplayingStyle][EnumAppDisplayedProperties.appFontColorToBackground()]);
    }
    /**
     * Returns the whole url the background image of the current displaying style is
     * loaded from, or an empty string when that style has no image file at all.
     */
    private function getBackgroundImageUrl():String
    {
      application.trace("<" + this + " DynamicsConfig getBackgroundImageUrl> called.", 1);
      const file:String = appBackgroundImages[appBackgroundImage] as String;
      if (file == null || file == "")
      {
        return "";
      }
      if (file.indexOf("://") > -1)
      {
        application.trace("<" + this + " DynamicsConfig getBackgroundImageUrl> the style brings a whole url of its own.", 0);
        return file;
      }
      if (application.getUrlRequestManager() == null)
      {
        application.trace("<" + this + " DynamicsConfig getBackgroundImageUrl> the url request manager is not ready yet!", 6);
        return "";
      }
      return application.getUrlRequestManager().getUrlBackgrounds() + file;
    }
    /**
     * Destroys this object and frees up everything. The background image and the bitmap
     * data drawn from it are freed up by the two methods handling them already.
     */
    public function destroy():void
    {
      application.trace("<" + this + " DynamicsConfig destroy> called.", 1);
      eventAppOrientationChanged.stopImmediatePropagation();
      eventAppWidgetModeChanged.stopImmediatePropagation();
      eventAppSoundVolumeChanged.stopImmediatePropagation();
      eventAppSoundPlayingChanged.stopImmediatePropagation();
      eventAppLineThicknessChanged.stopImmediatePropagation();
      eventAppMarginChanged.stopImmediatePropagation();
      eventAppPaddingChanged.stopImmediatePropagation();
      eventAppRadiusChanged.stopImmediatePropagation();
      eventAppBoxCornerChanged.stopImmediatePropagation();
      eventAppBoxFrameChanged.stopImmediatePropagation();
      eventAppBackgroundColorRandChanged.stopImmediatePropagation();
      eventAppBackgroundColorToFontChanged.stopImmediatePropagation();
      eventAppBackgroundColorDarkChanged.stopImmediatePropagation();
      eventAppBackgroundColorMidChanged.stopImmediatePropagation();
      eventAppBackgroundColorBrightChanged.stopImmediatePropagation();
      eventAppBackgroundColorAlphaChanged.stopImmediatePropagation();
      eventAppBackgroundImageChanged.stopImmediatePropagation();
      eventAppBackgroundAlignChanged.stopImmediatePropagation();
      eventAppBackgroundAlphaChanged.stopImmediatePropagation();
      eventAppBackgroundBlurChanged.stopImmediatePropagation();
      eventAppBackgroundLiveChanged.stopImmediatePropagation();
      eventAppFontFaceChanged.stopImmediatePropagation();
      eventAppFontSizeChanged.stopImmediatePropagation();
      eventAppFontColorRandChanged.stopImmediatePropagation();
      eventAppFontColorToBackgroundChanged.stopImmediatePropagation();
      eventAppFontColorBrightChanged.stopImmediatePropagation();
      eventAppFontColorMidChanged.stopImmediatePropagation();
      eventAppFontColorDarkChanged.stopImmediatePropagation();
      eventAppFontBoldChanged.stopImmediatePropagation();
      eventAppFontItalicChanged.stopImmediatePropagation();
      eventTextFormatBrightChanged.stopImmediatePropagation();
      eventTextFormatMidChanged.stopImmediatePropagation();
      eventTextFormatDarkChanged.stopImmediatePropagation();
      eventDisplayingStyleChanged.stopImmediatePropagation();
      destImage();
      disposeBitmapData();
      disposeSourceBitmapData();
      if (stealPixelBitmapData != null)
      {
        stealPixelBitmapData.dispose();
      }
      if (embeddedConfigByteArray != null)
      {
        embeddedConfigByteArray.clear();
      }
      if (appBackgroundImages != null)
      {
        appBackgroundImages.splice(0);
      }
      EmbeddedConfig = null;
      embeddedConfigByteArray = null;
      appOrientation = null;
      appWidgetMode = null;
      appSoundVolume = 0;
      appSoundPlaying = false;
      appLineThickness = 0;
      appMargin = 0;
      appPadding = 0;
      appRadius = 0;
      appBoxCorner = 0;
      appBoxFrame = null;
      appBackgroundColorRand = false;
      appBackgroundColorToFont = false;
      appBackgroundColorDark = 0;
      appBackgroundColorMid = 0;
      appBackgroundColorBright = 0;
      appBackgroundColorAlpha = 0;
      appBackgroundImage = null;
      appBackgroundAlign = null;
      appBackgroundAlpha = 0;
      appBackgroundBlur = 0;
      appBackgroundLive = false;
      appFontFace = null;
      appFontSize = 0;
      appFontColorRand = false;
      appFontColorToBackground = false;
      appFontColorBright = 0;
      appFontColorMid = 0;
      appFontColorDark = 0;
      appFontBold = false;
      appFontItalic = false;
      textFormatBright = null;
      textFormatMid = null;
      textFormatDark = null;
      textFieldHeightBright = 0;
      textFieldHeightMid = 0;
      textFieldHeightDark = 0;
      textFieldHeightBrightCorrection = 0;
      textFieldHeightMidCorrection = 0;
      textFieldHeightDarkCorrection = 0;
      eventAppOrientationChanged = null;
      eventAppWidgetModeChanged = null;
      eventAppSoundVolumeChanged = null;
      eventAppSoundPlayingChanged = null;
      eventAppLineThicknessChanged = null;
      eventAppMarginChanged = null;
      eventAppPaddingChanged = null;
      eventAppRadiusChanged = null;
      eventAppBoxCornerChanged = null;
      eventAppBoxFrameChanged = null;
      eventAppBackgroundColorRandChanged = null;
      eventAppBackgroundColorToFontChanged = null;
      eventAppBackgroundColorDarkChanged = null;
      eventAppBackgroundColorMidChanged = null;
      eventAppBackgroundColorBrightChanged = null;
      eventAppBackgroundColorAlphaChanged = null;
      eventAppBackgroundImageChanged = null;
      eventAppBackgroundAlignChanged = null;
      eventAppBackgroundAlphaChanged = null;
      eventAppBackgroundBlurChanged = null;
      eventAppBackgroundLiveChanged = null;
      eventAppFontFaceChanged = null;
      eventAppFontSizeChanged = null;
      eventAppFontColorRandChanged = null;
      eventAppFontColorToBackgroundChanged = null;
      eventAppFontColorBrightChanged = null;
      eventAppFontColorMidChanged = null;
      eventAppFontColorDarkChanged = null;
      eventAppFontBoldChanged = null;
      eventAppFontItalicChanged = null;
      eventTextFormatBrightChanged = null;
      eventTextFormatMidChanged = null;
      eventTextFormatDarkChanged = null;
      appDisplayingStyles = null;
      appDisplayingStyleDefaults = null;
      currentDisplayingStyle = null;
      eventDisplayingStyleChanged = null;
      appBackgroundImages = null;
      styleChangingInProgress = false;
      stealPixelBitmapData = null;
      application = null;
    }
  }
}
