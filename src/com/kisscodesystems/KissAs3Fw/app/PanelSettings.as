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
 * PanelSettings.
 * The panel of the settings. It becomes visible when the one using the application
 * clicks on the button of the settings.
 *
 * MAIN FEATURES:
 * - the button bar of it holds three contents only: the settings of the application,
 *   the appearance of it and the about of this software
 * - the four contents describing that appearance are hidden from that bar: the
 *   appearance content is a menu of the links leading to them, and every one of them
 *   holds a link leading back to that menu
 * - every row of the settings content, the whole appearance and every content of that
 *   appearance can be switched off by the configuration of the application
 * - every content stands in two columns, the name of a setting on the left and the
 *   element changing that setting on the right
 * - it handles the language, the displaying style and the orientation of the widgets
 * - it handles the number of the widget containers and the active one of them
 * - every modifiable displayed property of the application can be changed on it
 * - the appearance content closes with two links giving that appearance back: one taking
 *   the default displaying style and one taking the default values of the current style
 * - the extenders of this framework can add their own background image handler to it
 * - it switches the application between the mobile and the desktop appearance
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BasePanel;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ColorPicker;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Fw.ui.Potmeter;
  import com.kisscodesystems.KissAs3Fw.ui.Switcher;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class PanelSettings extends BasePanel
  {
    // the identifiers of the contents of this panel: the first three ones stand on the
    // button bar of it, the other ones are hidden from that bar and they are reached by
    // the links of the appearance content only
    private var indexSettings:int = -1;
    private var indexAppearance:int = -1;
    private var indexAbout:int = -1;
    private var indexLining:int = -1;
    private var indexColoring:int = -1;
    private var indexImaging:int = -1;
    private var indexFonting:int = -1;
    // the part of the width of this panel a list picker gets when there is nothing
    // else to take its width from
    private const listPickerFAC:Number = 0.42;
    // the number of the items displayed in an opened list picker
    private const listPickerCNT:int = 5;
    // the number of the homepages of this software displayed on the about content
    private const homepagesCNT:int = 10;
    // langCode
    private var langCodeLAB:TextLabel = null;
    private var langCodeOBJ:LangSetter = null;
    // the number of the widget containers
    private var numOfWidgetcontainersLAB:TextLabel = null;
    private var numOfWidgetcontainersOBJ:ListPicker = null;
    private var numOfWidgetcontainersARR:Array = null;
    private var numOfWidgetcontainersOBJprevIndex:int = 0;
    // the confirm asking whether the widget containers that still hold widgets can be lost
    private var reduceUniqueString:String = "";
    private var reduceOkType:String = "";
    private var reduceCancelType:String = "";
    // the current widget container
    private var currWidgetcontainerLAB:TextLabel = null;
    private var currWidgetcontainerOBJ:ListPicker = null;
    private var currWidgetcontainerARR:Array = null;
    // appOrientation
    private var appOrientationLAB:TextLabel = null;
    private var appOrientationOBJ:ListPicker = null;
    // appWidgetMode
    private var appWidgetModeLAB:TextLabel = null;
    private var appWidgetModeOBJ:ListPicker = null;
    // sound
    private var appSoundVolumeOBJ:Potmeter = null;
    private const appSoundVolumeMIN:Number = 0;
    private const appSoundVolumeMAX:Number = 100;
    private const appSoundVolumeINC:Number = 1;
    private var appSoundPlayingOBJ:Switcher = null;
    // appLineThickness
    private var appLineThicknessLAB:TextLabel = null;
    private var appLineThicknessOBJ:Potmeter = null;
    private const appLineThicknessMIN:Number = 0;
    private const appLineThicknessMAX:Number = 5;
    private const appLineThicknessINC:Number = 1;
    // appMargin
    private var appMarginLAB:TextLabel = null;
    private var appMarginOBJ:Potmeter = null;
    private const appMarginMIN:Number = 0;
    private const appMarginMAX:Number = 20;
    private const appMarginINC:Number = 1;
    // appPadding
    private var appPaddingLAB:TextLabel = null;
    private var appPaddingOBJ:Potmeter = null;
    private const appPaddingMIN:Number = 0;
    private const appPaddingMAX:Number = 16;
    private const appPaddingINC:Number = 1;
    // appRadius
    private var appRadiusLAB:TextLabel = null;
    private var appRadiusOBJ:Potmeter = null;
    private const appRadiusMIN:Number = 0;
    private const appRadiusMAX:Number = 12;
    private const appRadiusINC:Number = 1;
    // appBoxCorner
    private var appBoxCornerLAB:TextLabel = null;
    private var appBoxCornerOBJ:Potmeter = null;
    private const appBoxCornerMIN:Number = 0;
    private const appBoxCornerMAX:Number = 22;
    private const appBoxCornerINC:Number = 1;
    // appBoxFrame
    private var appBoxFrameLAB:TextLabel = null;
    private var appBoxFrameOBJ:ListPicker = null;
    // the predefined displaying styles
    private var displayingStyleLAB:TextLabel = null;
    private var displayingStyleOBJ:ListPicker = null;
    // appBackgroundColorDark, Mid and Bright
    private var appBackgroundColorsLAB:TextLabel = null;
    private var appBackgroundColorDarkOBJ:ColorPicker = null;
    private var appBackgroundColorMidOBJ:ColorPicker = null;
    private var appBackgroundColorBrightOBJ:ColorPicker = null;
    // appBackgroundColorAlpha
    private var appBackgroundColorAlphaLAB:TextLabel = null;
    private var appBackgroundColorAlphaOBJ:Potmeter = null;
    private const appBackgroundColorAlphaMIN:Number = 0;
    private const appBackgroundColorAlphaMAX:Number = 1;
    private const appBackgroundColorAlphaINC:Number = 0.01;
    // appBackgroundColorRand
    private var appBackgroundColorRandLAB:TextLabel = null;
    private var appBackgroundColorRandOBJ:Switcher = null;
    // appBackgroundColorToFont
    private var appBackgroundColorToFontLAB:TextLabel = null;
    private var appBackgroundColorToFontOBJ:Switcher = null;
    // appBackgroundColorGetNewSchema
    private var appBackgroundColorGetNewSchema:ButtonLink = null;
    // appBackgroundImage
    private var appBackgroundImageVAL:TextLabel = null;
    // appBackgroundAlign
    private var appBackgroundAlignLAB:TextLabel = null;
    private var appBackgroundAlignOBJ:ListPicker = null;
    // appBackgroundAlpha
    private var appBackgroundAlphaLAB:TextLabel = null;
    private var appBackgroundAlphaOBJ:Potmeter = null;
    private const appBackgroundAlphaMIN:Number = 0;
    private const appBackgroundAlphaMAX:Number = 1;
    private const appBackgroundAlphaINC:Number = 0.01;
    // appBackgroundBlur
    private var appBackgroundBlurLAB:TextLabel = null;
    private var appBackgroundBlurOBJ:Potmeter = null;
    private const appBackgroundBlurMIN:Number = 0;
    private const appBackgroundBlurMAX:Number = 12;
    private const appBackgroundBlurINC:Number = 2;
    // appBackgroundLive
    private var appBackgroundLiveLAB:TextLabel = null;
    private var appBackgroundLiveOBJ:Switcher = null;
    // the background image handler of the extender applications
    private var userBgHandler:BaseSprite = null;
    // appFontFace
    private var appFontFaceLAB:TextLabel = null;
    private var appFontFaceOBJ:ListPicker = null;
    // appFontSize
    private var appFontSizeLAB:TextLabel = null;
    private var appFontSizeOBJ:ListPicker = null;
    // appFontColorBright, Mid and Dark
    private var appFontColorsLAB:TextLabel = null;
    private var appFontColorBrightOBJ:ColorPicker = null;
    private var appFontColorMidOBJ:ColorPicker = null;
    private var appFontColorDarkOBJ:ColorPicker = null;
    // appFontBold
    private var appFontBoldLAB:TextLabel = null;
    private var appFontBoldOBJ:Switcher = null;
    // appFontItalic
    private var appFontItalicLAB:TextLabel = null;
    private var appFontItalicOBJ:Switcher = null;
    // appFontColorRand
    private var appFontColorRandLAB:TextLabel = null;
    private var appFontColorRandOBJ:Switcher = null;
    // appFontColorToBackground
    private var appFontColorToBackgroundLAB:TextLabel = null;
    private var appFontColorToBackgroundOBJ:Switcher = null;
    // appFontColorGetNewSchema
    private var appFontColorGetNewSchema:ButtonLink = null;
    // the about content
    private var applicationNameLAB:TextLabel = null;
    private var applicationVersionLAB:TextLabel = null;
    private var applicationReleaseDateLAB:TextLabel = null;
    private var homepageLinksARR:Array = null;
    // the links of the appearance content leading to the hidden contents of it, and the
    // links of those contents leading back to that menu
    private var liningLinkOBJ:ButtonLink = null;
    private var coloringLinkOBJ:ButtonLink = null;
    private var imagingLinkOBJ:ButtonLink = null;
    private var fontingLinkOBJ:ButtonLink = null;
    private var defaultAppearanceLinkOBJ:ButtonLink = null;
    private var resetAppearanceLinkOBJ:ButtonLink = null;
    private var backLinksARR:Array = null;
    /**
     * Constructs the panel of the settings with every element standing on it.
     * @param applicationRef the main application reference
     */
    public function PanelSettings(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " PanelSettings> called.", 1);
      application.trace("<" + this + " PanelSettings> applicationRef: " + applicationRef, 0);
      numOfWidgetcontainersARR = new Array();
      for (var i:int = 1; i <= application.getComponentsConfig().getMaxNumOfWidgetcontainers(); i++)
      {
        numOfWidgetcontainersARR[i - 1] = i;
      }
      currWidgetcontainerARR = new Array();
      homepageLinksARR = new Array();
      backLinksARR = new Array();
      createElements();
      application.trace("<" + this + " PanelSettings> constructed.", 1);
    }
    /**
     * Returns the number of the contents of this panel, the hidden ones as well.
     */
    public function getNumOfContents():int
    {
      return contentMultiple.getNumOfContents();
    }
    /**
     * Returns the index of the content that is the displayed one right now.
     */
    public function getActiveContentIndex():int
    {
      return contentMultiple.getActiveIndex();
    }
    /**
     * Returns true when the content of the given text key has its own button on the
     * button bar of this panel, false when that content is one of the hidden ones or
     * when this panel has no content of that key at all.
     * @param textKey the text key the content has been created with
     */
    public function getContentButtonVisible(textKey:String):Boolean
    {
      application.trace("<" + this + " PanelSettings getContentButtonVisible> called.", 1);
      application.trace("<" + this + " PanelSettings getContentButtonVisible> textKey: " + textKey, 0);
      return contentMultiple.getContentButtonVisible(contentMultiple.getContentIndexByLabel(textKey));
    }
    /**
     * Displays the content of the given text key, one of the hidden ones as well: this
     * is the way anything outside of this panel can open it on the content of its own
     * choice. A key this panel has no content of changes nothing.
     * @param textKey the text key the content has been created with
     */
    public function showContent(textKey:String):void
    {
      application.trace("<" + this + " PanelSettings showContent> called.", 1);
      application.trace("<" + this + " PanelSettings showContent> textKey: " + textKey, 0);
      const index:int = contentMultiple.getContentIndexByLabel(textKey);
      if (index > -1)
      {
        contentMultiple.setActiveIndex(index);
      }
    }
    /**
     * Returns the displaying style that is the picked one right now.
     */
    public function getSelectedDisplayingStyleValue():String
    {
      application.trace("<" + this + " PanelSettings getSelectedDisplayingStyleValue> called.", 1);
      const value:String = selectedValueOf(displayingStyleOBJ);
      application.trace("<" + this + " PanelSettings getSelectedDisplayingStyleValue> value: " + value, 0);
      return value;
    }
    /**
     * Returns the widget container that is the active one right now.
     */
    public function getActiveWidgetContainer():int
    {
      application.trace("<" + this + " PanelSettings getActiveWidgetContainer> called.", 1);
      // an empty picker answers a negative index, and the first container is the active
      // one in that case: this value addresses a widget container in every case
      const index:int = currWidgetcontainerOBJ != null ? Math.max(0, currWidgetcontainerOBJ.getSelectedIndex()) : 0;
      application.trace("<" + this + " PanelSettings getActiveWidgetContainer> index: " + index, 0);
      return index;
    }
    /**
     * Sets the widget container that has to be the active one.
     * @param index the index of that widget container
     */
    public function setActiveWidgetContainer(index:int):void
    {
      application.trace("<" + this + " PanelSettings setActiveWidgetContainer> called.", 1);
      application.trace("<" + this + " PanelSettings setActiveWidgetContainer> index: " + index, 0);
      if (currWidgetcontainerOBJ != null)
      {
        currWidgetcontainerOBJ.setSelectedIndex(index);
      }
    }
    /**
     * Displays the given widget container as the picked one.
     * @param index the index of that widget container
     */
    public function showWidgetContainer(index:int):void
    {
      application.trace("<" + this + " PanelSettings showWidgetContainer> called.", 1);
      application.trace("<" + this + " PanelSettings showWidgetContainer> index: " + index, 0);
      if (currWidgetcontainerOBJ != null)
      {
        currWidgetcontainerOBJ.setSelectedIndex(index);
      }
    }
    /**
     * Returns the background image handler of the extender applications. It may be
     * needed from the outside as well, so it is reachable from there.
     */
    public function getUserBgHandler():BaseSprite
    {
      return userBgHandler;
    }
    /**
     * Adds the background image handler of the extender applications to the content of
     * the background image of this panel, next to the name of the image standing there.
     * @param baseSprite the object handling the uploaded background image
     */
    public function addUserBgHandler(baseSprite:BaseSprite):void
    {
      application.trace("<" + this + " PanelSettings addUserBgHandler> called.", 1);
      application.trace("<" + this + " PanelSettings addUserBgHandler> baseSprite: " + baseSprite, 0);
      if (contentMultiple != null && indexImaging > -1 && baseSprite != null)
      {
        userBgHandler = baseSprite;
        contentMultiple.addToContent(indexImaging, baseSprite, 3);
      }
    }
    /**
     * Sets whether the background image handler of the extender applications is displayed.
     * @param b whether that object has to be displayed
     */
    public function setUserBgHandlerVisible(b:Boolean):void
    {
      application.trace("<" + this + " PanelSettings setUserBgHandlerVisible> called.", 1);
      application.trace("<" + this + " PanelSettings setUserBgHandlerVisible> b: " + b, 0);
      if (userBgHandler != null)
      {
        userBgHandler.setSpriteVisible(b);
      }
    }
    /**
     * Sets the language of this application. The language setter of this panel is not
     * touched here: that one follows the language changed event of the application, so
     * it displays the new language whoever has asked for it.
     * @param langCode the language code this application has to switch to
     */
    public function setLangCode(langCode:String):void
    {
      application.trace("<" + this + " PanelSettings setLangCode> called.", 1);
      application.trace("<" + this + " PanelSettings setLangCode> langCode: " + langCode, 0);
      application.getLabelManager().setLang(langCode);
    }
    /**
     * Reloads the languages of this application. More of them can be added later on,
     * so this one has to be reachable from the outside.
     */
    public function updateLangCodes():void
    {
      application.trace("<" + this + " PanelSettings updateLangCodes> called.", 1);
      if (langCodeOBJ != null)
      {
        langCodeOBJ.updateLangCodes();
      }
    }
    /**
     * Reloads the displaying styles of this application. More of them can be added
     * later on, so this one has to be reachable from the outside.
     */
    public function updateDisplayingStyles():void
    {
      application.trace("<" + this + " PanelSettings updateDisplayingStyles> called.", 1);
      if (displayingStyleOBJ != null)
      {
        displayingStyleOBJ.setArrays(application.getLabelManager().getKeysDisplayingStyles()
            , application.getLabelManager().getKeysDisplayingStyles());
        // the style of the application is not changed by a new list of the styles: the
        // current one has to be displayed as the picked one again, and the first one is
        // only taken when that current style is not in the new list at all
        displayingStyleChangedOutside(null);
        if (displayingStyleOBJ.getSelectedIndex() < 0)
        {
          application.trace("<" + this + " PanelSettings updateDisplayingStyles> the current displaying style is not in the new list.", 6);
          displayingStyleOBJ.setSelectedIndex(0);
        }
      }
    }
    /**
     * Reloads the font faces of this application. More of them can be added later on,
     * so this one has to be reachable from the outside.
     */
    public function updateFontFaces():void
    {
      application.trace("<" + this + " PanelSettings updateFontFaces> called.", 1);
      if (appFontFaceOBJ != null)
      {
        appFontFaceOBJ.setArrays(application.getFontManager().getFontFaces(), application.getFontManager().getFontFaces());
        fontFaceChangedOutside(null);
      }
    }
    /**
     * Reloads the name, the version and the release date of this application on the
     * about content of this panel.
     */
    public function refreshAbout():void
    {
      application.trace("<" + this + " PanelSettings refreshAbout> called.", 1);
      if (applicationNameLAB != null)
      {
        applicationNameLAB.setLabel(application.getApplicationType() != ""
          ? application.getApplicationType() + " " + application.getPropertiesConfig().getApplicationName()
          : application.getPropertiesConfig().getApplicationName());
      }
      if (applicationVersionLAB != null)
      {
        applicationVersionLAB.setLabel(application.getPropertiesConfig().getApplicationVersion());
      }
      if (applicationReleaseDateLAB != null)
      {
        applicationReleaseDateLAB.setLabel(application.getPropertiesConfig().getApplicationReleaseDate());
      }
      refreshHomepageLinks();
    }
    /**
     * Enables or disables every element standing on this panel as well.
     * @param e whether this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " PanelSettings setEnabled> called.", 1);
      application.trace("<" + this + " PanelSettings setEnabled> e: " + e, 0);
      super.setEnabled(e);
      setEnabledOnListPickers();
      setEnabledOnPotmeters();
      setEnabledOnSwitchers();
      setEnabledOnColorPickers();
      setEnabledOnButtonLinks();
      if (langCodeOBJ != null)
      {
        langCodeOBJ.setEnabled(getEnabled());
      }
    }
    /**
     * Sets the width of this panel and gives the new one to the elements whose width
     * is calculated from the width of this panel.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " PanelSettings setDw> called.", 1);
      application.trace("<" + this + " PanelSettings setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        resizeListPickers();
        appBackgroundColorsOBJSizesChanged(null);
        appFontColorsOBJSizesChanged(null);
      }
    }
    /**
     * Sets both dimensions of this panel and gives the new width to the elements whose
     * width is calculated from the width of this panel.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " PanelSettings setDwh> called.", 1);
      application.trace("<" + this + " PanelSettings setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " PanelSettings setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        resizeListPickers();
        appBackgroundColorsOBJSizesChanged(null);
        appFontColorsOBJSizesChanged(null);
      }
    }
    /**
     * Builds every content of this panel and every element standing on them.
     */
    private function createElements():void
    {
      application.trace("<" + this + " PanelSettings createElements> called.", 1);
      createContents();
      createSettingsElements();
      createAppearanceElements();
      createAboutElements();
      createLiningElements();
      createColoringElements();
      createImagingElements();
      createFontingElements();
      displayEveryCurrentValue();
      resizeListPickers();
      appBackgroundAlignLABResized(null);
      // the listeners are registered at the very end on purpose: the values displayed
      // above must not be taken as changes made by the one using this application
      addListenersToElements();
      addListenersToApplication();
    }
    /**
     * Builds the contents of this panel. The three ones the button bar of it displays
     * come first, and the four contents of the appearance are hidden from that bar: the
     * links of the appearance content are the only way to them. The contents the
     * configuration of the application has switched off are left out of this panel, and
     * the index of every one of them stays negative.
     */
    private function createContents():void
    {
      application.trace("<" + this + " PanelSettings createContents> called.", 1);
      // the four hidden contents belong to the appearance, so all of them are gone with
      // that one: the links leading to them stand on that content and nowhere else
      const appearance:Boolean = application.getComponentsConfig().getPanelSettingsEnableAppearance();
      indexSettings = contentMultiple.addContent(EnumTextKeys.SETTINGS_PANEL_SETTINGS());
      if (appearance)
      {
        indexAppearance = contentMultiple.addContent(EnumTextKeys.SETTINGS_PANEL_APPEARANCE());
      }
      indexAbout = contentMultiple.addContent(EnumTextKeys.SETTINGS_PANEL_ABOUT());
      if (appearance && application.getComponentsConfig().getPanelSettingsEnableLining())
      {
        indexLining = contentMultiple.addHiddenContent(EnumTextKeys.SETTINGS_PANEL_LINING());
      }
      if (appearance && application.getComponentsConfig().getPanelSettingsEnableColoring())
      {
        indexColoring = contentMultiple.addHiddenContent(EnumTextKeys.SETTINGS_PANEL_COLORING());
      }
      if (appearance && application.getComponentsConfig().getPanelSettingsEnableImaging())
      {
        indexImaging = contentMultiple.addHiddenContent(EnumTextKeys.SETTINGS_PANEL_IMAGING());
      }
      if (appearance && application.getComponentsConfig().getPanelSettingsEnableFonting())
      {
        indexFonting = contentMultiple.addHiddenContent(EnumTextKeys.SETTINGS_PANEL_FONTING());
      }
      // a content of the settings stands in two columns, the name of a setting on the
      // left and the element changing it on the right, and the appearance and the about
      // contents are lists of one single column. The negative index of a content that
      // has been left out above addresses no content at all, so it changes nothing here
      contentMultiple.setElementsFix(indexSettings, 1);
      contentMultiple.setElementsFix(indexAppearance, 0);
      contentMultiple.setElementsFix(indexAbout, 0);
      contentMultiple.setElementsFix(indexLining, 1);
      contentMultiple.setElementsFix(indexColoring, 1);
      contentMultiple.setElementsFix(indexImaging, 1);
      contentMultiple.setElementsFix(indexFonting, 1);
      contentMultiple.setActiveIndex(indexSettings);
    }
    /**
     * Builds the elements of the settings content of this panel: the ones the one using
     * the application is looking for when the settings are opened. The rows the
     * configuration of the application has switched off are left out of it.
     */
    private function createSettingsElements():void
    {
      application.trace("<" + this + " PanelSettings createSettingsElements> called.", 1);
      // the rows of this content follow each other, so their cell indexes are counted:
      // the name of a setting takes the left cell of a row and its element the right one
      var curr:int = 0;
      // the language setter always stands on this panel: this is the only place of it
      langCodeLAB = createLabel(indexSettings, curr, EnumTextKeys.SETTING_LANGUAGE());
      curr++;
      langCodeOBJ = new LangSetter(application);
      contentMultiple.addToContent(indexSettings, langCodeOBJ, curr);
      curr++;
      // the number of the widget containers and the active one of them go together: one
      // container of the two is meaningless without the other
      if (application.getComponentsConfig().getPanelSettingsEnableDesktops())
      {
        numOfWidgetcontainersLAB = createLabel(indexSettings, curr, EnumTextKeys.SETTING_NUM_OF_WIDGETCONTAINERS());
        curr++;
        numOfWidgetcontainersOBJ = new ListPicker(application);
        contentMultiple.addToContent(indexSettings, numOfWidgetcontainersOBJ, curr);
        curr++;
        numOfWidgetcontainersOBJ.setNumOfElements(listPickerCNT);
        numOfWidgetcontainersOBJ.setArrays(numOfWidgetcontainersARR, numOfWidgetcontainersARR);
        numOfWidgetcontainersOBJ.setSelectedIndex(0);
        currWidgetcontainerLAB = createLabel(indexSettings, curr, EnumTextKeys.SETTING_CURR_WIDGETCONTAINER());
        curr++;
        currWidgetcontainerOBJ = new ListPicker(application);
        contentMultiple.addToContent(indexSettings, currWidgetcontainerOBJ, curr);
        curr++;
        currWidgetcontainerOBJ.setNumOfElements(listPickerCNT);
        setArraysCurrWidgetcontainerOBJ();
        currWidgetcontainerOBJ.setSelectedIndex(0);
      }
      if (application.getComponentsConfig().getPanelSettingsEnableOrientation())
      {
        appOrientationLAB = createLabel(indexSettings, curr, EnumTextKeys.SETTING_ORIENTATION());
        curr++;
        appOrientationOBJ = new ListPicker(application);
        contentMultiple.addToContent(indexSettings, appOrientationOBJ, curr);
        curr++;
        appOrientationOBJ.setNumOfElements(listPickerCNT);
        appOrientationOBJ.setArrays(application.getLabelManager().getKeysOrientations()
            , application.getLabelManager().getKeysOrientations());
      }
      if (application.getComponentsConfig().getPanelSettingsEnableWidgetMode())
      {
        appWidgetModeLAB = createLabel(indexSettings, curr, EnumTextKeys.SETTING_WIDGET_MODE());
        curr++;
        appWidgetModeOBJ = new ListPicker(application);
        contentMultiple.addToContent(indexSettings, appWidgetModeOBJ, curr);
        curr++;
        appWidgetModeOBJ.setNumOfElements(application.getLabelManager().getKeysWidgetModes().length);
        appWidgetModeOBJ.setArrays(application.getLabelManager().getKeysWidgetModes()
            , application.getLabelManager().getKeysWidgetModes());
      }
      // the playing of the sound and the volume of it go together: a volume that cannot
      // be heard is meaningless
      if (application.getComponentsConfig().getPanelSettingsEnableSound())
      {
        // the switcher of the sound carries the name of its own row, so it stands in the
        // column of the names, and the volume of that sound takes the place of an element
        appSoundPlayingOBJ = new Switcher(application);
        contentMultiple.addToContent(indexSettings, appSoundPlayingOBJ, curr);
        curr++;
        appSoundPlayingOBJ.setLabels(EnumTextKeys.SETTING_SOUND_PLAYING_ON(), EnumTextKeys.SETTING_SOUND_PLAYING_OFF());
        appSoundVolumeOBJ = new Potmeter(application);
        contentMultiple.addToContent(indexSettings, appSoundVolumeOBJ, curr);
        appSoundVolumeOBJ.setMinMaxIncValues(appSoundVolumeMIN, appSoundVolumeMAX, appSoundVolumeINC);
      }
    }
    /**
     * Builds the appearance content of this panel: a menu of the links leading to the
     * contents that are hidden from the button bar, and the two links giving the
     * appearance of the application back. The first one of those two takes the default
     * displaying style back, the second one takes the default values of the current
     * style. One cell is left empty above them on purpose: it keeps them one row away
     * from the menu standing above them. A link of a content the configuration of the
     * application has left out is left out as well: that content cannot be reached
     * anyway, and the two links of the default appearance can be switched off together.
     */
    private function createAppearanceElements():void
    {
      application.trace("<" + this + " PanelSettings createAppearanceElements> called.", 1);
      if (indexAppearance < 0)
      {
        application.trace("<" + this + " PanelSettings createAppearanceElements> the appearance is switched off.", 0);
        return;
      }
      // the links of this menu follow each other, so their cell indexes are counted:
      // this content is a list of one single column, so every one of them takes a row
      var curr:int = 0;
      if (indexLining > -1)
      {
        liningLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_LINING());
        curr++;
      }
      if (indexColoring > -1)
      {
        coloringLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_COLORING());
        curr++;
      }
      if (indexImaging > -1)
      {
        imagingLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_IMAGING());
        curr++;
      }
      if (indexFonting > -1)
      {
        fontingLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_FONTING());
        curr++;
      }
      if (application.getComponentsConfig().getPanelSettingsEnableDefaultAppearance())
      {
        // the empty row above this link is skipped when there is no menu above it at
        // all: that row would be an empty one at the very top of this content
        if (curr > 0)
        {
          curr++;
        }
        defaultAppearanceLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_DEFAULT_APPEARANCE());
        curr++;
        resetAppearanceLinkOBJ = createLink(indexAppearance, curr, EnumTextKeys.SETTINGS_PANEL_RESET_APPEARANCE());
      }
    }
    /**
     * Builds the elements of the lines and spacing content of this panel. It is one of
     * the hidden ones, so the first row of it is the link leading back to the appearance
     * menu and the settings of it follow that link.
     */
    private function createLiningElements():void
    {
      application.trace("<" + this + " PanelSettings createLiningElements> called.", 1);
      if (indexLining < 0)
      {
        application.trace("<" + this + " PanelSettings createLiningElements> the lines and spacing are switched off.", 0);
        return;
      }
      createBackLink(indexLining);
      appLineThicknessLAB = createLabel(indexLining, 2, EnumTextKeys.SETTING_LINE_THICKNESS());
      appLineThicknessOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexLining, appLineThicknessOBJ, 3);
      appLineThicknessOBJ.setMinMaxIncValues(appLineThicknessMIN, appLineThicknessMAX, appLineThicknessINC);
      appMarginLAB = createLabel(indexLining, 4, EnumTextKeys.SETTING_MARGIN());
      appMarginOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexLining, appMarginOBJ, 5);
      appMarginOBJ.setMinMaxIncValues(appMarginMIN, appMarginMAX, appMarginINC);
      appPaddingLAB = createLabel(indexLining, 6, EnumTextKeys.SETTING_PADDING());
      appPaddingOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexLining, appPaddingOBJ, 7);
      appPaddingOBJ.setMinMaxIncValues(appPaddingMIN, appPaddingMAX, appPaddingINC);
      appRadiusLAB = createLabel(indexLining, 8, EnumTextKeys.SETTING_RADIUS());
      appRadiusOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexLining, appRadiusOBJ, 9);
      appRadiusOBJ.setMinMaxIncValues(appRadiusMIN, appRadiusMAX, appRadiusINC);
      appBoxCornerLAB = createLabel(indexLining, 10, EnumTextKeys.SETTING_BOX_CORNER());
      appBoxCornerOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexLining, appBoxCornerOBJ, 11);
      appBoxCornerOBJ.setMinMaxIncValues(appBoxCornerMIN, appBoxCornerMAX, appBoxCornerINC);
      appBoxFrameLAB = createLabel(indexLining, 12, EnumTextKeys.SETTING_BOX_FRAME());
      appBoxFrameOBJ = new ListPicker(application);
      contentMultiple.addToContent(indexLining, appBoxFrameOBJ, 13);
      appBoxFrameOBJ.setNumOfElements(application.getLabelManager().getKeysBoxFrames().length);
      appBoxFrameOBJ.setArrays(application.getLabelManager().getKeysBoxFrames()
          , application.getLabelManager().getKeysBoxFrames());
    }
    /**
     * Builds the elements of the coloring content of this panel. It is one of the hidden
     * ones, so the first row of it is the link leading back to the appearance menu. The
     * link asking for a new color schema closes the content: it is an action and not a
     * setting, so it stands in the column of the names, at the left edge of the rows.
     */
    private function createColoringElements():void
    {
      application.trace("<" + this + " PanelSettings createColoringElements> called.", 1);
      if (indexColoring < 0)
      {
        application.trace("<" + this + " PanelSettings createColoringElements> the colors are switched off.", 0);
        return;
      }
      createBackLink(indexColoring);
      displayingStyleLAB = createLabel(indexColoring, 2, EnumTextKeys.SETTING_DISPLAYING_STYLE());
      displayingStyleOBJ = new ListPicker(application);
      contentMultiple.addToContent(indexColoring, displayingStyleOBJ, 3);
      displayingStyleOBJ.setNumOfElements(listPickerCNT);
      updateDisplayingStyles();
      appBackgroundColorsLAB = createLabel(indexColoring, 4, EnumTextKeys.SETTING_BACKGROUND_COLORS());
      // the three color pickers share one cell, so they stand next to each other
      appBackgroundColorBrightOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorBrightOBJ, 5);
      appBackgroundColorMidOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorMidOBJ, 5);
      appBackgroundColorDarkOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorDarkOBJ, 5);
      appBackgroundColorAlphaLAB = createLabel(indexColoring, 6, EnumTextKeys.SETTING_BACKGROUND_COLOR_ALPHA());
      appBackgroundColorAlphaOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorAlphaOBJ, 7);
      appBackgroundColorAlphaOBJ.setMinMaxIncValues(appBackgroundColorAlphaMIN, appBackgroundColorAlphaMAX, appBackgroundColorAlphaINC);
      appBackgroundColorRandLAB = createLabel(indexColoring, 8, EnumTextKeys.SETTING_BACKGROUND_COLOR_RANDOMNESS());
      appBackgroundColorRandOBJ = new Switcher(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorRandOBJ, 9);
      appBackgroundColorRandOBJ.setLabels(EnumTextKeys.SETTING_BACKGROUND_COLOR_RANDOM()
          , EnumTextKeys.SETTING_BACKGROUND_COLOR_NORMAL());
      appBackgroundColorToFontLAB = createLabel(indexColoring, 10, EnumTextKeys.SETTING_BACKGROUND_COLOR_TO_FONT());
      appBackgroundColorToFontOBJ = new Switcher(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorToFontOBJ, 11);
      appBackgroundColorToFontOBJ.setLabels(EnumTextKeys.SETTING_FONT_COLOR_CHANGE()
          , EnumTextKeys.SETTING_FONT_COLOR_REMAIN());
      appBackgroundColorGetNewSchema = new ButtonLink(application);
      contentMultiple.addToContent(indexColoring, appBackgroundColorGetNewSchema, 12);
      appBackgroundColorGetNewSchema.setLabel(EnumTextKeys.SETTING_GET_NEW_BACKGROUND_COLORSCHEMA());
    }
    /**
     * Builds the elements of the background image content of this panel. It is one of
     * the hidden ones, so the first row of it is the link leading back to the appearance
     * menu. The name of the image stands in the second row and the cell of the index 3
     * next to it is left empty on purpose: the background image handler of the extender
     * applications goes in there. The row of the cells 4 and 5 is left empty as well: it
     * keeps every setting below one row away from that name.
     */
    private function createImagingElements():void
    {
      application.trace("<" + this + " PanelSettings createImagingElements> called.", 1);
      if (indexImaging < 0)
      {
        application.trace("<" + this + " PanelSettings createImagingElements> the background image is switched off.", 0);
        return;
      }
      createBackLink(indexImaging);
      appBackgroundImageVAL = new TextLabel(application);
      contentMultiple.addToContent(indexImaging, appBackgroundImageVAL, 2);
      appBackgroundImageVAL.setType(EnumTextTypes.TEXT_TYPE_MID());
      appBackgroundAlignLAB = createLabel(indexImaging, 6, EnumTextKeys.SETTING_BACKGROUND_ALIGN());
      appBackgroundAlignOBJ = new ListPicker(application);
      contentMultiple.addToContent(indexImaging, appBackgroundAlignOBJ, 7);
      appBackgroundAlignOBJ.setNumOfElements(listPickerCNT);
      appBackgroundAlignOBJ.setArrays(application.getLabelManager().getKeysBgImageAligns()
          , application.getLabelManager().getKeysBgImageAligns());
      appBackgroundAlphaLAB = createLabel(indexImaging, 8, EnumTextKeys.SETTING_BACKGROUND_ALPHA());
      appBackgroundAlphaOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexImaging, appBackgroundAlphaOBJ, 9);
      appBackgroundAlphaOBJ.setMinMaxIncValues(appBackgroundAlphaMIN, appBackgroundAlphaMAX, appBackgroundAlphaINC);
      appBackgroundBlurLAB = createLabel(indexImaging, 10, EnumTextKeys.SETTING_BACKGROUND_BLUR());
      appBackgroundBlurOBJ = new Potmeter(application);
      contentMultiple.addToContent(indexImaging, appBackgroundBlurOBJ, 11);
      appBackgroundBlurOBJ.setMinMaxIncValues(appBackgroundBlurMIN, appBackgroundBlurMAX, appBackgroundBlurINC);
      appBackgroundLiveLAB = createLabel(indexImaging, 12, EnumTextKeys.SETTING_BACKGROUND_MOVEMENT());
      appBackgroundLiveOBJ = new Switcher(application);
      contentMultiple.addToContent(indexImaging, appBackgroundLiveOBJ, 13);
      appBackgroundLiveOBJ.setLabels(EnumTextKeys.SETTING_BACKGROUND_LIVE(), EnumTextKeys.SETTING_BACKGROUND_FIXED());
    }
    /**
     * Builds the elements of the fonting content of this panel. It is one of the hidden
     * ones, so the first row of it is the link leading back to the appearance menu, and
     * the link asking for a new color schema closes it at the left edge of the rows.
     */
    private function createFontingElements():void
    {
      application.trace("<" + this + " PanelSettings createFontingElements> called.", 1);
      if (indexFonting < 0)
      {
        application.trace("<" + this + " PanelSettings createFontingElements> the fonts are switched off.", 0);
        return;
      }
      createBackLink(indexFonting);
      appFontFaceLAB = createLabel(indexFonting, 2, EnumTextKeys.SETTING_FONT_FACE());
      appFontFaceOBJ = new ListPicker(application);
      contentMultiple.addToContent(indexFonting, appFontFaceOBJ, 3);
      appFontFaceOBJ.setNumOfElements(listPickerCNT);
      updateFontFaces();
      appFontSizeLAB = createLabel(indexFonting, 4, EnumTextKeys.SETTING_FONT_SIZE());
      appFontSizeOBJ = new ListPicker(application);
      contentMultiple.addToContent(indexFonting, appFontSizeOBJ, 5);
      appFontSizeOBJ.setNumOfElements(listPickerCNT);
      appFontSizeOBJ.setArrays(application.getFontManager().getFontSizes(), application.getFontManager().getFontSizes());
      appFontColorsLAB = createLabel(indexFonting, 6, EnumTextKeys.SETTING_FONT_COLORS());
      // the three color pickers share one cell, so they stand next to each other
      appFontColorBrightOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexFonting, appFontColorBrightOBJ, 7);
      appFontColorMidOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexFonting, appFontColorMidOBJ, 7);
      appFontColorDarkOBJ = new ColorPicker(application);
      contentMultiple.addToContent(indexFonting, appFontColorDarkOBJ, 7);
      appFontBoldLAB = createLabel(indexFonting, 8, EnumTextKeys.SETTING_FONT_THICKNESS());
      appFontBoldOBJ = new Switcher(application);
      contentMultiple.addToContent(indexFonting, appFontBoldOBJ, 9);
      appFontBoldOBJ.setLabels(EnumTextKeys.SETTING_FONT_BOLD(), EnumTextKeys.SETTING_FONT_NORMAL());
      appFontItalicLAB = createLabel(indexFonting, 10, EnumTextKeys.SETTING_FONT_SKEWNESS());
      appFontItalicOBJ = new Switcher(application);
      contentMultiple.addToContent(indexFonting, appFontItalicOBJ, 11);
      appFontItalicOBJ.setLabels(EnumTextKeys.SETTING_FONT_ITALIC(), EnumTextKeys.SETTING_FONT_NORMAL());
      appFontColorRandLAB = createLabel(indexFonting, 12, EnumTextKeys.SETTING_FONT_COLOR_RANDOMNESS());
      appFontColorRandOBJ = new Switcher(application);
      contentMultiple.addToContent(indexFonting, appFontColorRandOBJ, 13);
      appFontColorRandOBJ.setLabels(EnumTextKeys.SETTING_FONT_COLOR_RANDOM(), EnumTextKeys.SETTING_FONT_COLOR_NORMAL());
      appFontColorToBackgroundLAB = createLabel(indexFonting, 14, EnumTextKeys.SETTING_FONT_COLOR_TO_BACKGROUND());
      appFontColorToBackgroundOBJ = new Switcher(application);
      contentMultiple.addToContent(indexFonting, appFontColorToBackgroundOBJ, 15);
      appFontColorToBackgroundOBJ.setLabels(EnumTextKeys.SETTING_BACKGROUND_COLOR_CHANGE()
          , EnumTextKeys.SETTING_BACKGROUND_COLOR_REMAIN());
      appFontColorGetNewSchema = new ButtonLink(application);
      contentMultiple.addToContent(indexFonting, appFontColorGetNewSchema, 16);
      appFontColorGetNewSchema.setLabel(EnumTextKeys.SETTING_GET_NEW_FONT_COLORSCHEMA());
    }
    /**
     * Builds the elements of the about content of this panel.
     */
    private function createAboutElements():void
    {
      application.trace("<" + this + " PanelSettings createAboutElements> called.", 1);
      applicationNameLAB = new TextLabel(application);
      contentMultiple.addToContent(indexAbout, applicationNameLAB, 0);
      applicationNameLAB.setType(EnumTextTypes.TEXT_TYPE_BRIGHT());
      applicationVersionLAB = new TextLabel(application);
      contentMultiple.addToContent(indexAbout, applicationVersionLAB, 1);
      applicationVersionLAB.setType(EnumTextTypes.TEXT_TYPE_MID());
      applicationReleaseDateLAB = new TextLabel(application);
      contentMultiple.addToContent(indexAbout, applicationReleaseDateLAB, 2);
      applicationReleaseDateLAB.setType(EnumTextTypes.TEXT_TYPE_MID());
      refreshAbout();
      const homepages:int = Math.min(homepagesCNT, application.getPropertiesConfig().getApplicationSoftwareHomepageTxt().length);
      for (var i:int = 0; i < homepages; i++)
      {
        const buttonLink:ButtonLink = new ButtonLink(application);
        contentMultiple.addToContent(indexAbout, buttonLink, 5 + i);
        // the links are kept on purpose: a disabled panel must not have a clickable
        // link on it, and the homepages may be refreshed later on as well
        homepageLinksARR.push(buttonLink);
      }
      refreshHomepageLinks();
    }
    /**
     * Displays the current homepage of this software on every link of the about content.
     * The properties of this application may be loaded after this panel has been built,
     * so this one is called again by the refreshAbout of it.
     */
    private function refreshHomepageLinks():void
    {
      application.trace("<" + this + " PanelSettings refreshHomepageLinks> called.", 1);
      if (homepageLinksARR == null)
      {
        return;
      }
      const txts:Array = application.getPropertiesConfig().getApplicationSoftwareHomepageTxt();
      const urls:Array = application.getPropertiesConfig().getApplicationSoftwareHomepageUrl();
      for (var i:int = 0; i < homepageLinksARR.length; i++)
      {
        const buttonLink:ButtonLink = ButtonLink(homepageLinksARR[i]);
        // a link the properties of this application do not know anymore is emptied and
        // hidden: an empty clickable row would take the one using it nowhere
        const hasHomepage:Boolean = i < txts.length && i < urls.length;
        buttonLink.setLabel(hasHomepage ? txts[i] : "");
        buttonLink.setUrl(hasHomepage ? urls[i] : "");
        buttonLink.setSpriteVisible(hasHomepage);
      }
    }
    /**
     * Builds one label of this panel. Every one of them names the setting standing next
     * to it, so it is aligned to the middle of its own row: a row of a taller element,
     * of the three color pickers for one, would leave it hanging at the top of that row.
     * @param index the index of the content the label goes into
     * @param cellIndex the cell of that content the label goes into
     * @param textKey the text key of the label
     */
    private function createLabel(index:int, cellIndex:int, textKey:String):TextLabel
    {
      application.trace("<" + this + " PanelSettings createLabel> called.", 1);
      application.trace("<" + this + " PanelSettings createLabel> index: " + index, 0);
      application.trace("<" + this + " PanelSettings createLabel> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " PanelSettings createLabel> textKey: " + textKey, 0);
      const textLabel:TextLabel = new TextLabel(application);
      contentMultiple.addToContent(index, textLabel, cellIndex);
      textLabel.setLabel(textKey);
      contentMultiple.setElementAlignVertical(index, textLabel, EnumAligns.ALIGN_MIDDLE());
      return textLabel;
    }
    /**
     * Builds one link of this panel.
     * @param index the index of the content the link goes into
     * @param cellIndex the cell of that content the link goes into
     * @param textKey the text key of the link
     */
    private function createLink(index:int, cellIndex:int, textKey:String):ButtonLink
    {
      application.trace("<" + this + " PanelSettings createLink> called.", 1);
      application.trace("<" + this + " PanelSettings createLink> index: " + index, 0);
      application.trace("<" + this + " PanelSettings createLink> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " PanelSettings createLink> textKey: " + textKey, 0);
      const buttonLink:ButtonLink = new ButtonLink(application);
      contentMultiple.addToContent(index, buttonLink, cellIndex);
      buttonLink.setLabel(textKey);
      return buttonLink;
    }
    /**
     * Builds the link of one hidden content leading back to the appearance menu. It
     * stands in the first row of that content, above every setting standing on it. Every
     * one of these links is kept: this panel has no button of its own to navigate with,
     * so the only way out of a hidden content is one of them.
     * @param index the index of the hidden content
     */
    private function createBackLink(index:int):void
    {
      application.trace("<" + this + " PanelSettings createBackLink> called.", 1);
      application.trace("<" + this + " PanelSettings createBackLink> index: " + index, 0);
      backLinksARR.push(createLink(index, 0, EnumTextKeys.SETTINGS_PANEL_BACK()));
    }
    /**
     * Displays the current value of every displayed property of the application.
     */
    private function displayEveryCurrentValue():void
    {
      application.trace("<" + this + " PanelSettings displayEveryCurrentValue> called.", 1);
      displayingStyleChangedOutside(null);
      orientationChangedOutside(null);
      widgetModeChangedOutside(null);
      soundVolumeChangedOutside(null);
      soundPlayingChangedOutside(null);
      lineThicknessChangedOutside(null);
      marginChangedOutside(null);
      paddingChangedOutside(null);
      radiusChangedOutside(null);
      boxCornerChangedOutside(null);
      boxFrameChangedOutside(null);
      backgroundColorDarkChangedOutside(null);
      backgroundColorMidChangedOutside(null);
      backgroundColorBrightChangedOutside(null);
      backgroundFillAlphaChangedOutside(null);
      backgroundColorRandChangedOutside(null);
      backgroundColorToFontChangedOutside(null);
      backgroundImageChangedOutside(null);
      backgroundAlignChangedOutside(null);
      backgroundAlphaChangedOutside(null);
      backgroundBlurChangedOutside(null);
      backgroundLiveChangedOutside(null);
      fontFaceChangedOutside(null);
      fontSizeChangedOutside(null);
      fontColorBrightChangedOutside(null);
      fontColorMidChangedOutside(null);
      fontColorDarkChangedOutside(null);
      fontColorRandChangedOutside(null);
      fontColorToBackgroundChangedOutside(null);
      fontBoldChangedOutside(null);
      fontItalicChangedOutside(null);
    }
    /**
     * Registers the listeners watching the elements of this panel. The elements the
     * configuration of the application has left out are skipped.
     */
    private function addListenersToElements():void
    {
      application.trace("<" + this + " PanelSettings addListenersToElements> called.", 1);
      if (numOfWidgetcontainersOBJ != null)
      {
        numOfWidgetcontainersOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), numOfWidgetcontainersOBJChanged);
      }
      if (currWidgetcontainerOBJ != null)
      {
        currWidgetcontainerOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), currWidgetcontainerOBJChanged);
      }
      if (appOrientationOBJ != null)
      {
        appOrientationOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appOrientationOBJChanged);
      }
      if (appWidgetModeOBJ != null)
      {
        appWidgetModeOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appWidgetModeOBJChanged);
      }
      if (appSoundPlayingOBJ != null)
      {
        appSoundVolumeOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appSoundVolumeOBJchanged);
        appSoundPlayingOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), appSoundPlayingOBJresized);
        appSoundPlayingOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appSoundPlayingOBJchanged);
      }
      // the elements of the four hidden contents are built as whole groups, so the index
      // of a content answers whether every element of that group is standing there
      if (indexLining > -1)
      {
        appLineThicknessOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appLineThicknessOBJchanged);
        appMarginOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appMarginOBJchanged);
        appPaddingOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appPaddingOBJchanged);
        appRadiusOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appRadiusOBJchanged);
        appBoxCornerOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBoxCornerOBJchanged);
        appBoxFrameOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBoxFrameOBJchanged);
      }
      if (indexColoring > -1)
      {
        displayingStyleOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), displayingStyleOBJChanged);
        addListenersToColorPicker(appBackgroundColorDarkOBJ, appBackgroundColorDarkOBJChanged, appBackgroundColorsOBJSizesChanged);
        addListenersToColorPicker(appBackgroundColorMidOBJ, appBackgroundColorMidOBJChanged, appBackgroundColorsOBJSizesChanged);
        addListenersToColorPicker(appBackgroundColorBrightOBJ, appBackgroundColorBrightOBJChanged, appBackgroundColorsOBJSizesChanged);
        appBackgroundColorAlphaOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundColorAlphaOBJchanged);
        appBackgroundColorRandOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundColorRandOBJChanged);
        appBackgroundColorToFontOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundColorToFontOBJChanged);
        appBackgroundColorGetNewSchema.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), getNewRandomBackgroundColorSchema);
      }
      if (indexImaging > -1)
      {
        appBackgroundAlignLAB.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), appBackgroundAlignLABResized);
        appBackgroundAlignOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundAlignOBJChanged);
        appBackgroundAlphaOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundAlphaOBJchanged);
        appBackgroundBlurOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundBlurOBJchanged);
        appBackgroundLiveOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appBackgroundLiveOBJChanged);
      }
      if (indexFonting > -1)
      {
        addListenersToColorPicker(appFontColorBrightOBJ, appFontColorBrightOBJChanged, appFontColorsOBJSizesChanged);
        addListenersToColorPicker(appFontColorMidOBJ, appFontColorMidOBJChanged, appFontColorsOBJSizesChanged);
        addListenersToColorPicker(appFontColorDarkOBJ, appFontColorDarkOBJChanged, appFontColorsOBJSizesChanged);
        appFontFaceOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontFaceOBJChanged);
        appFontSizeOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontSizeOBJChanged);
        appFontColorRandOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontColorRandOBJChanged);
        appFontColorToBackgroundOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontColorToBackgroundOBJChanged);
        appFontColorGetNewSchema.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), getNewRandomFontColorSchema);
        appFontBoldOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontBoldOBJChanged);
        appFontItalicOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), appFontItalicOBJChanged);
      }
      if (liningLinkOBJ != null)
      {
        liningLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), liningLinkClicked);
      }
      if (coloringLinkOBJ != null)
      {
        coloringLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), coloringLinkClicked);
      }
      if (imagingLinkOBJ != null)
      {
        imagingLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), imagingLinkClicked);
      }
      if (fontingLinkOBJ != null)
      {
        fontingLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), fontingLinkClicked);
      }
      if (defaultAppearanceLinkOBJ != null)
      {
        defaultAppearanceLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), defaultAppearanceLinkClicked);
      }
      if (resetAppearanceLinkOBJ != null)
      {
        resetAppearanceLinkOBJ.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), resetAppearanceLinkClicked);
      }
      // every link leading back leads to the very same menu, so all of them are answered
      // by one single handler
      for (var i:int = 0; i < backLinksARR.length; i++)
      {
        ButtonLink(backLinksARR[i]).getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), backLinkClicked);
      }
    }
    /**
     * Registers every listener one color picker of this panel needs.
     * @param colorPicker the color picker to watch
     * @param changedListener the function handling the changing of the color
     * @param sizesChangedListener the function handling the resizing of the picker
     */
    private function addListenersToColorPicker(colorPicker:ColorPicker, changedListener:Function, sizesChangedListener:Function):void
    {
      application.trace("<" + this + " PanelSettings addListenersToColorPicker> called.", 1);
      application.trace("<" + this + " PanelSettings addListenersToColorPicker> colorPicker: " + colorPicker, 0);
      application.trace("<" + this + " PanelSettings addListenersToColorPicker> changedListener: " + changedListener, 0);
      application.trace("<" + this + " PanelSettings addListenersToColorPicker> sizesChangedListener: " + sizesChangedListener, 0);
      colorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), changedListener);
      colorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_START(), colorStealStart);
      colorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_STOP(), colorStealStop);
      colorPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), sizesChangedListener);
    }
    /**
     * Registers the listeners watching the displayed properties of the application:
     * any other object may change one of them at any time.
     */
    private function addListenersToApplication():void
    {
      application.trace("<" + this + " PanelSettings addListenersToApplication> called.", 1);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_ORIENTATION_CHANGED(), orientationChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), widgetModeChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_SOUND_PLAYING_CHANGED(), soundPlayingChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_SOUND_VOLUME_CHANGED(), soundVolumeChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), boxCornerChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), boxFrameChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DISPLAYING_STYLE_CHANGED(), displayingStyleChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_RAND_CHANGED(), backgroundColorRandChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED(), backgroundColorToFontChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorDarkChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorMidChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundFillAlphaChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED(), backgroundImageChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED(), backgroundAlignChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED(), backgroundAlphaChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED(), backgroundBlurChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED(), backgroundLiveChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_FACE_CHANGED(), fontFaceChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_RAND_CHANGED(), fontColorRandChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED(), fontColorToBackgroundChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), fontColorBrightChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_MID_CHANGED(), fontColorMidChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), fontColorDarkChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_BOLD_CHANGED(), fontBoldChangedOutside);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_ITALIC_CHANGED(), fontItalicChangedOutside);
    }
    /**
     * Unregisters the listeners watching the displayed properties of the application.
     */
    private function removeListenersFromApplication():void
    {
      application.trace("<" + this + " PanelSettings removeListenersFromApplication> called.", 1);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_ORIENTATION_CHANGED(), orientationChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), widgetModeChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_SOUND_PLAYING_CHANGED(), soundPlayingChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_SOUND_VOLUME_CHANGED(), soundVolumeChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), boxCornerChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), boxFrameChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_DISPLAYING_STYLE_CHANGED(), displayingStyleChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_RAND_CHANGED(), backgroundColorRandChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_TO_FONT_CHANGED(), backgroundColorToFontChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorDarkChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorMidChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundFillAlphaChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_IMAGE_CHANGED(), backgroundImageChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_ALIGN_CHANGED(), backgroundAlignChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_ALPHA_CHANGED(), backgroundAlphaChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_BLUR_CHANGED(), backgroundBlurChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_LIVE_CHANGED(), backgroundLiveChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_FACE_CHANGED(), fontFaceChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_RAND_CHANGED(), fontColorRandChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_TO_BACKGROUND_CHANGED(), fontColorToBackgroundChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), fontColorBrightChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_MID_CHANGED(), fontColorMidChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_DARK_CHANGED(), fontColorDarkChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_BOLD_CHANGED(), fontBoldChangedOutside);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_ITALIC_CHANGED(), fontItalicChangedOutside);
    }
    /**
     * Enables or disables every list picker of this panel.
     */
    private function setEnabledOnListPickers():void
    {
      application.trace("<" + this + " PanelSettings setEnabledOnListPickers> called.", 1);
      const listPickers:Array = [numOfWidgetcontainersOBJ, currWidgetcontainerOBJ, appOrientationOBJ
        , appWidgetModeOBJ, appBoxFrameOBJ, displayingStyleOBJ, appBackgroundAlignOBJ, appFontFaceOBJ, appFontSizeOBJ];
      for (var i:int = 0; i < listPickers.length; i++)
      {
        if (listPickers[i] != null)
        {
          ListPicker(listPickers[i]).setEnabled(getEnabled());
        }
      }
      listPickers.splice(0);
    }
    /**
     * Enables or disables every potmeter of this panel.
     */
    private function setEnabledOnPotmeters():void
    {
      application.trace("<" + this + " PanelSettings setEnabledOnPotmeters> called.", 1);
      const potmeters:Array = [appSoundVolumeOBJ, appLineThicknessOBJ, appMarginOBJ, appPaddingOBJ, appRadiusOBJ
        , appBoxCornerOBJ, appBackgroundColorAlphaOBJ, appBackgroundAlphaOBJ, appBackgroundBlurOBJ];
      for (var i:int = 0; i < potmeters.length; i++)
      {
        if (potmeters[i] != null)
        {
          Potmeter(potmeters[i]).setEnabled(getEnabled());
        }
      }
      potmeters.splice(0);
    }
    /**
     * Enables or disables every switcher of this panel.
     */
    private function setEnabledOnSwitchers():void
    {
      application.trace("<" + this + " PanelSettings setEnabledOnSwitchers> called.", 1);
      const switchers:Array = [appSoundPlayingOBJ, appBackgroundColorRandOBJ, appBackgroundColorToFontOBJ
        , appBackgroundLiveOBJ, appFontColorRandOBJ, appFontColorToBackgroundOBJ, appFontBoldOBJ, appFontItalicOBJ];
      for (var i:int = 0; i < switchers.length; i++)
      {
        if (switchers[i] != null)
        {
          Switcher(switchers[i]).setEnabled(getEnabled());
        }
      }
      switchers.splice(0);
    }
    /**
     * Enables or disables every color picker of this panel.
     */
    private function setEnabledOnColorPickers():void
    {
      application.trace("<" + this + " PanelSettings setEnabledOnColorPickers> called.", 1);
      const colorPickers:Array = [appBackgroundColorDarkOBJ, appBackgroundColorMidOBJ, appBackgroundColorBrightOBJ
        , appFontColorDarkOBJ, appFontColorMidOBJ, appFontColorBrightOBJ];
      for (var i:int = 0; i < colorPickers.length; i++)
      {
        if (colorPickers[i] != null)
        {
          ColorPicker(colorPickers[i]).setEnabled(getEnabled());
        }
      }
      colorPickers.splice(0);
    }
    /**
     * Enables or disables every button link of this panel: the ones navigating between
     * the contents, the two ones asking for a new color schema and the homepages of this
     * software on the about content as well.
     */
    private function setEnabledOnButtonLinks():void
    {
      application.trace("<" + this + " PanelSettings setEnabledOnButtonLinks> called.", 1);
      const buttonLinks:Array = [appBackgroundColorGetNewSchema, appFontColorGetNewSchema
        , liningLinkOBJ, coloringLinkOBJ, imagingLinkOBJ, fontingLinkOBJ, defaultAppearanceLinkOBJ
        , resetAppearanceLinkOBJ];
      if (backLinksARR != null)
      {
        for (var k:int = 0; k < backLinksARR.length; k++)
        {
          buttonLinks.push(backLinksARR[k]);
        }
      }
      if (homepageLinksARR != null)
      {
        for (var i:int = 0; i < homepageLinksARR.length; i++)
        {
          buttonLinks.push(homepageLinksARR[i]);
        }
      }
      for (var j:int = 0; j < buttonLinks.length; j++)
      {
        if (buttonLinks[j] != null)
        {
          ButtonLink(buttonLinks[j]).setEnabled(getEnabled());
        }
      }
      buttonLinks.splice(0);
    }
    /**
     * Fills the list of the widget containers up. It depends on the number of the
     * widget containers picked by the one using this application.
     */
    private function setArraysCurrWidgetcontainerOBJ():void
    {
      application.trace("<" + this + " PanelSettings setArraysCurrWidgetcontainerOBJ> called.", 1);
      if (currWidgetcontainerOBJ == null)
      {
        return;
      }
      currWidgetcontainerARR.splice(0);
      const numOfWidgetcontainers:int = getNumOfWidgetcontainers();
      for (var i:int = 1; i <= numOfWidgetcontainers; i++)
      {
        currWidgetcontainerARR[i - 1] = i;
      }
      currWidgetcontainerOBJ.setArrays(currWidgetcontainerARR, currWidgetcontainerARR);
    }
    /**
     * Returns the number of the widget containers this application has right now. The
     * picker of that number knows it when this panel displays one, otherwise the widget
     * holder itself is the one to ask, and there is always at least one container.
     */
    private function getNumOfWidgetcontainers():int
    {
      application.trace("<" + this + " PanelSettings getNumOfWidgetcontainers> called.", 1);
      var num:int = 1;
      if (numOfWidgetcontainersOBJ != null)
      {
        num = numOfWidgetcontainersOBJ.getSelectedIndex() + 1;
      }
      else if (application.getMiddleground() != null)
      {
        num = application.getMiddleground().getWidgets().getNumOfContents();
      }
      num = Math.max(1, num);
      application.trace("<" + this + " PanelSettings getNumOfWidgetcontainers> num: " + num, 0);
      return num;
    }
    /**
     * A color picker has started to steal a pixel from the stage, so this panel has to get
     * out of the way. The background is stopped by the color panel itself.
     * @param e the color steal start event of that color picker
     */
    private function colorStealStart(e:Event):void
    {
      application.trace("<" + this + " PanelSettings colorStealStart> called.", 1);
      application.trace("<" + this + " PanelSettings colorStealStart> e: " + e, 0);
      visible = false;
    }
    /**
     * The stealing of the pixel is over, so this panel comes back.
     * @param e the color steal stop event of that color picker
     */
    private function colorStealStop(e:Event):void
    {
      application.trace("<" + this + " PanelSettings colorStealStop> called.", 1);
      application.trace("<" + this + " PanelSettings colorStealStop> e: " + e, 0);
      visible = true;
    }
    /**
     * Asks for a new random font color schema.
     * @param e the click event of the button asking for it
     */
    private function getNewRandomFontColorSchema(e:Event):void
    {
      application.trace("<" + this + " PanelSettings getNewRandomFontColorSchema> called.", 1);
      application.trace("<" + this + " PanelSettings getNewRandomFontColorSchema> e: " + e, 0);
      application.getDynamicsConfig().getNewRandomFontColorSchema();
    }
    /**
     * Asks for a new random background color schema.
     * @param e the click event of the button asking for it
     */
    private function getNewRandomBackgroundColorSchema(e:Event):void
    {
      application.trace("<" + this + " PanelSettings getNewRandomBackgroundColorSchema> called.", 1);
      application.trace("<" + this + " PanelSettings getNewRandomBackgroundColorSchema> e: " + e, 0);
      application.getDynamicsConfig().getNewRandomBackgroundColorSchema();
    }
    /**
     * The link of the lines and spacing has been clicked on the appearance menu.
     * @param e the click event of that link
     */
    private function liningLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings liningLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings liningLinkClicked> e: " + e, 0);
      contentMultiple.setActiveIndex(indexLining);
    }
    /**
     * The link of the colors has been clicked on the appearance menu.
     * @param e the click event of that link
     */
    private function coloringLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings coloringLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings coloringLinkClicked> e: " + e, 0);
      contentMultiple.setActiveIndex(indexColoring);
    }
    /**
     * The link of the background image has been clicked on the appearance menu.
     * @param e the click event of that link
     */
    private function imagingLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings imagingLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings imagingLinkClicked> e: " + e, 0);
      contentMultiple.setActiveIndex(indexImaging);
    }
    /**
     * The link of the fonts has been clicked on the appearance menu.
     * @param e the click event of that link
     */
    private function fontingLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontingLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings fontingLinkClicked> e: " + e, 0);
      contentMultiple.setActiveIndex(indexFonting);
    }
    /**
     * A link leading back has been clicked on one of the hidden contents, so the
     * appearance menu comes again. Every one of those links leads here.
     * @param e the click event of that link
     */
    private function backLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings backLinkClicked> e: " + e, 0);
      contentMultiple.setActiveIndex(indexAppearance);
    }
    /**
     * The link of the default appearance has been clicked, so the default displaying
     * style becomes the current one again and takes every default value of it back. It is
     * the way out of an appearance the one using the application cannot read at all: a
     * font color of the color of the background leaves nothing readable behind, and the
     * settings of the appearance are lost with the rest of the application.
     * @param e the click event of that link
     */
    private function defaultAppearanceLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings defaultAppearanceLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings defaultAppearanceLinkClicked> e: " + e, 0);
      application.getDynamicsConfig().setDefaultDisplayingStyle();
    }
    /**
     * The link of the resetting has been clicked, so every displayed property of the
     * application takes the default value of the current displaying style back. The
     * settings standing on this panel write the values of that very style, so this is the
     * way back from an appearance that has been changed value by value, without leaving
     * the style the one using the application has picked.
     * @param e the click event of that link
     */
    private function resetAppearanceLinkClicked(e:Event):void
    {
      application.trace("<" + this + " PanelSettings resetAppearanceLinkClicked> called.", 1);
      application.trace("<" + this + " PanelSettings resetAppearanceLinkClicked> e: " + e, 0);
      application.getDynamicsConfig().resetCurrentDisplayingStyle();
    }
    /**
     * The displaying style has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function displayingStyleChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings displayingStyleChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings displayingStyleChangedOutside> e: " + e, 0);
      if (displayingStyleOBJ != null)
      {
        const index:int = displayingStyleOBJ.getArrayValues().indexOf(application.getDynamicsConfig().getCurrentDisplayingStyle());
        if (index > -1)
        {
          displayingStyleOBJ.setSelectedIndex(index, false);
        }
      }
    }
    /**
     * The orientation of the widgets has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function orientationChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings orientationChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings orientationChangedOutside> e: " + e, 0);
      if (appOrientationOBJ != null)
      {
        appOrientationOBJ.setSelectedIndex(application.getLabelManager().getKeysOrientations()
            .indexOf(application.getDynamicsConfig().getAppOrientation()), false);
      }
    }
    /**
     * The mode of the widgets has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function widgetModeChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings widgetModeChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings widgetModeChangedOutside> e: " + e, 0);
      if (appWidgetModeOBJ != null)
      {
        appWidgetModeOBJ.setSelectedIndex(application.getLabelManager().getKeysWidgetModes()
            .indexOf(application.getDynamicsConfig().getAppWidgetMode()), false);
      }
    }
    /**
     * The volume of the sounds has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function soundVolumeChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings soundVolumeChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings soundVolumeChangedOutside> e: " + e, 0);
      if (appSoundVolumeOBJ != null)
      {
        appSoundVolumeOBJ.setCurValue(application.getDynamicsConfig().getAppSoundVolume(), false);
      }
    }
    /**
     * The playing of the sounds has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function soundPlayingChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings soundPlayingChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings soundPlayingChangedOutside> e: " + e, 0);
      if (appSoundPlayingOBJ != null)
      {
        appSoundPlayingOBJ.setOn(application.getDynamicsConfig().getAppSoundPlaying(), false);
      }
    }
    /**
     * The line thickness has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function lineThicknessChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings lineThicknessChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings lineThicknessChangedOutside> e: " + e, 0);
      if (appLineThicknessOBJ != null)
      {
        appLineThicknessOBJ.setCurValue(application.getDynamicsConfig().getAppLineThickness(), false);
      }
    }
    /**
     * The margin has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function marginChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings marginChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings marginChangedOutside> e: " + e, 0);
      if (appMarginOBJ != null)
      {
        appMarginOBJ.setCurValue(application.getDynamicsConfig().getAppMargin(), false);
      }
    }
    /**
     * The padding has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function paddingChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings paddingChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings paddingChangedOutside> e: " + e, 0);
      if (appPaddingOBJ != null)
      {
        appPaddingOBJ.setCurValue(application.getDynamicsConfig().getAppPadding(), false);
      }
    }
    /**
     * The radius has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function radiusChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings radiusChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings radiusChangedOutside> e: " + e, 0);
      if (appRadiusOBJ != null)
      {
        appRadiusOBJ.setCurValue(application.getDynamicsConfig().getAppRadius(), false);
      }
    }
    /**
     * The corner of the box has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function boxCornerChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings boxCornerChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings boxCornerChangedOutside> e: " + e, 0);
      if (appBoxCornerOBJ != null)
      {
        appBoxCornerOBJ.setCurValue(application.getDynamicsConfig().getAppBoxCorner(), false);
      }
    }
    /**
     * The frame of the box has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function boxFrameChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings boxFrameChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings boxFrameChangedOutside> e: " + e, 0);
      if (appBoxFrameOBJ != null)
      {
        appBoxFrameOBJ.setSelectedIndex(application.getLabelManager().getKeysBoxFrames()
            .indexOf(application.getDynamicsConfig().getAppBoxFrame()), false);
      }
    }
    /**
     * The dark background color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundColorDarkChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundColorDarkChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundColorDarkChangedOutside> e: " + e, 0);
      if (appBackgroundColorDarkOBJ != null)
      {
        appBackgroundColorDarkOBJ.setRGBColor(application.getDynamicsConfig().getAppBackgroundColorDark().toString(16), false);
      }
    }
    /**
     * The mid background color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundColorMidChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundColorMidChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundColorMidChangedOutside> e: " + e, 0);
      if (appBackgroundColorMidOBJ != null)
      {
        appBackgroundColorMidOBJ.setRGBColor(application.getDynamicsConfig().getAppBackgroundColorMid().toString(16), false);
      }
    }
    /**
     * The bright background color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundColorBrightChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundColorBrightChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundColorBrightChangedOutside> e: " + e, 0);
      if (appBackgroundColorBrightOBJ != null)
      {
        appBackgroundColorBrightOBJ.setRGBColor(application.getDynamicsConfig().getAppBackgroundColorBright().toString(16), false);
      }
    }
    /**
     * The alpha of the background color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundFillAlphaChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundFillAlphaChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundFillAlphaChangedOutside> e: " + e, 0);
      if (appBackgroundColorAlphaOBJ != null)
      {
        appBackgroundColorAlphaOBJ.setCurValue(application.getDynamicsConfig().getAppBackgroundColorAlpha(), false);
      }
    }
    /**
     * The randomness of the background color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundColorRandChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundColorRandChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundColorRandChangedOutside> e: " + e, 0);
      if (appBackgroundColorRandOBJ != null)
      {
        appBackgroundColorRandOBJ.setOn(application.getDynamicsConfig().getAppBackgroundColorRand(), false);
      }
    }
    /**
     * Whether the font colors follow the background colors has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundColorToFontChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundColorToFontChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundColorToFontChangedOutside> e: " + e, 0);
      if (appBackgroundColorToFontOBJ != null)
      {
        appBackgroundColorToFontOBJ.setOn(application.getDynamicsConfig().getAppBackgroundColorToFont(), false);
      }
    }
    /**
     * The background image has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundImageChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundImageChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundImageChangedOutside> e: " + e, 0);
      if (appBackgroundImageVAL != null)
      {
        // the file name of the image is the one telling anything to the one using this
        // application: the style displaying the embedded background has no file at all,
        // and that one falls back to the name of the style itself
        const file:String = application.getDynamicsConfig().getAppBackgroundImageFile();
        appBackgroundImageVAL.setLabel(file == "" ? application.getDynamicsConfig().getAppBackgroundImage() : file);
      }
    }
    /**
     * The align of the background image has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundAlignChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundAlignChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundAlignChangedOutside> e: " + e, 0);
      if (appBackgroundAlignOBJ != null)
      {
        appBackgroundAlignOBJ.setSelectedIndex(application.getLabelManager().getKeysBgImageAligns()
            .indexOf(application.getDynamicsConfig().getAppBackgroundAlign()), false);
      }
    }
    /**
     * The alpha of the background image has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundAlphaChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundAlphaChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundAlphaChangedOutside> e: " + e, 0);
      if (appBackgroundAlphaOBJ != null)
      {
        appBackgroundAlphaOBJ.setCurValue(application.getDynamicsConfig().getAppBackgroundAlpha(), false);
      }
    }
    /**
     * The blur of the background image has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundBlurChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundBlurChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundBlurChangedOutside> e: " + e, 0);
      if (appBackgroundBlurOBJ != null)
      {
        appBackgroundBlurOBJ.setCurValue(application.getDynamicsConfig().getAppBackgroundBlur(), false);
      }
    }
    /**
     * The live property of the background has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function backgroundLiveChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings backgroundLiveChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings backgroundLiveChangedOutside> e: " + e, 0);
      if (appBackgroundLiveOBJ != null)
      {
        appBackgroundLiveOBJ.setOn(application.getDynamicsConfig().getAppBackgroundLive(), false);
      }
    }
    /**
     * The font face has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontFaceChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontFaceChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontFaceChangedOutside> e: " + e, 0);
      if (appFontFaceOBJ != null)
      {
        appFontFaceOBJ.setSelectedIndex(application.getFontManager().getFontFaces()
            .indexOf(application.getDynamicsConfig().getAppFontFace()), false);
      }
    }
    /**
     * The font size has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontSizeChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontSizeChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontSizeChangedOutside> e: " + e, 0);
      if (appFontSizeOBJ != null)
      {
        appFontSizeOBJ.setSelectedIndex(application.getFontManager().getFontSizes()
            .indexOf(application.getDynamicsConfig().getAppFontSize()), false);
      }
    }
    /**
     * The bright font color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontColorBrightChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontColorBrightChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontColorBrightChangedOutside> e: " + e, 0);
      if (appFontColorBrightOBJ != null)
      {
        appFontColorBrightOBJ.setRGBColor(application.getDynamicsConfig().getAppFontColorBright().toString(16), false);
      }
    }
    /**
     * The mid font color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontColorMidChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontColorMidChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontColorMidChangedOutside> e: " + e, 0);
      if (appFontColorMidOBJ != null)
      {
        appFontColorMidOBJ.setRGBColor(application.getDynamicsConfig().getAppFontColorMid().toString(16), false);
      }
    }
    /**
     * The dark font color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontColorDarkChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontColorDarkChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontColorDarkChangedOutside> e: " + e, 0);
      if (appFontColorDarkOBJ != null)
      {
        appFontColorDarkOBJ.setRGBColor(application.getDynamicsConfig().getAppFontColorDark().toString(16), false);
      }
    }
    /**
     * The randomness of the font color has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontColorRandChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontColorRandChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontColorRandChangedOutside> e: " + e, 0);
      if (appFontColorRandOBJ != null)
      {
        appFontColorRandOBJ.setOn(application.getDynamicsConfig().getAppFontColorRand(), false);
      }
    }
    /**
     * Whether the background colors follow the font colors has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontColorToBackgroundChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontColorToBackgroundChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontColorToBackgroundChangedOutside> e: " + e, 0);
      if (appFontColorToBackgroundOBJ != null)
      {
        appFontColorToBackgroundOBJ.setOn(application.getDynamicsConfig().getAppFontColorToBackground(), false);
      }
    }
    /**
     * The boldness of the font has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontBoldChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontBoldChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontBoldChangedOutside> e: " + e, 0);
      if (appFontBoldOBJ != null)
      {
        appFontBoldOBJ.setOn(application.getDynamicsConfig().getAppFontBold(), false);
      }
    }
    /**
     * The skewness of the font has been changed by another object.
     * @param e the event of that changing, or null when it is called by hand
     */
    private function fontItalicChangedOutside(e:Event):void
    {
      application.trace("<" + this + " PanelSettings fontItalicChangedOutside> called.", 1);
      application.trace("<" + this + " PanelSettings fontItalicChangedOutside> e: " + e, 0);
      if (appFontItalicOBJ != null)
      {
        appFontItalicOBJ.setOn(application.getDynamicsConfig().getAppFontItalic(), false);
      }
    }
    /**
     * Another displaying style has been picked.
     * @param e the changed event of the list picker of the displaying styles
     */
    private function displayingStyleOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings displayingStyleOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings displayingStyleOBJChanged> e: " + e, 0);
      const displayingStyle:String = getSelectedDisplayingStyleValue();
      if (displayingStyle != "")
      {
        application.getDynamicsConfig().setCurrentDisplayingStyle(displayingStyle);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().closePanelSettings();
        }
      }
    }
    /**
     * Another number of the widget containers has been picked. Losing a container that
     * still holds widgets has to be confirmed first.
     * @param e the changed event of the list picker of the number of the containers
     */
    private function numOfWidgetcontainersOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings numOfWidgetcontainersOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings numOfWidgetcontainersOBJChanged> e: " + e, 0);
      if (numOfWidgetcontainersOBJ == null || application.getMiddleground() == null)
      {
        return;
      }
      if (application.getMiddleground().getWidgets().getNumOfContents() <= numOfWidgetcontainersOBJ.getSelectedIndex() + 1)
      {
        changeMaxWidgetContainers();
        return;
      }
      askToReduceWidgetContainers();
    }
    /**
     * Asks the one using this application whether the widget containers that still hold
     * widgets can be lost. There is no confirm to ask that question on without the
     * foreground, and the containers are kept in that case.
     */
    private function askToReduceWidgetContainers():void
    {
      application.trace("<" + this + " PanelSettings askToReduceWidgetContainers> called.", 1);
      // a question that is still unanswered is closed first: the answers of it would be
      // overwritten below and would stay on the dispatcher of the application forever
      closeReduceWidgetContainers();
      if (application.getForeground() == null)
      {
        application.trace("<" + this + " PanelSettings askToReduceWidgetContainers> there is no foreground to ask this question on.", 6);
        numOfWidgetcontainersOBJ.setSelectedIndex(numOfWidgetcontainersOBJprevIndex, false);
        return;
      }
      // the two answers of the confirm are remembered here on purpose: they live on the
      // dispatcher of the application, which outlives this panel, so this panel has to be
      // able to unregister them even when it is destroyed before the answer arrives
      reduceUniqueString = application.getUtils().getRandomGuid();
      reduceOkType = reduceUniqueString + EnumOkCancel.OC_OK();
      reduceCancelType = reduceUniqueString + EnumOkCancel.OC_CANCEL();
      application.getBaseEventDispatcher().addEventListener(reduceOkType, reduceWidgetContainersConfirmed);
      application.getBaseEventDispatcher().addEventListener(reduceCancelType, reduceWidgetContainersCancelled);
      application.getForeground().createAlert(EnumTextKeys.SETTING_REALLY_REDUCE_NUM_OF_WIDGET_CONTAINERS()
          , reduceUniqueString, true, true);
    }
    /**
     * The losing of the widget containers has been confirmed, so the number of them
     * becomes the newly picked one.
     * @param e the ok event of the confirm
     */
    private function reduceWidgetContainersConfirmed(e:Event):void
    {
      application.trace("<" + this + " PanelSettings reduceWidgetContainersConfirmed> called.", 1);
      application.trace("<" + this + " PanelSettings reduceWidgetContainersConfirmed> e: " + e, 0);
      closeReduceWidgetContainers();
      changeMaxWidgetContainers();
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().openPanelSettings();
      }
      e.stopImmediatePropagation();
    }
    /**
     * The losing of the widget containers has been cancelled, so the number of them goes
     * back to the previous one.
     * @param e the cancel event of the confirm
     */
    private function reduceWidgetContainersCancelled(e:Event):void
    {
      application.trace("<" + this + " PanelSettings reduceWidgetContainersCancelled> called.", 1);
      application.trace("<" + this + " PanelSettings reduceWidgetContainersCancelled> e: " + e, 0);
      closeReduceWidgetContainers();
      // the picked value goes back to the previous one silently, otherwise the handler of
      // that picker would ask this very question again right away
      if (numOfWidgetcontainersOBJ != null)
      {
        numOfWidgetcontainersOBJ.setSelectedIndex(numOfWidgetcontainersOBJprevIndex, false);
      }
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().openPanelSettings();
      }
      e.stopImmediatePropagation();
    }
    /**
     * Closes the confirm of the losing of the widget containers and unregisters both
     * answers of it. Both of them have to go: the one of the event that has arrived
     * would leave the other answer on the dispatcher of the application.
     */
    private function closeReduceWidgetContainers():void
    {
      application.trace("<" + this + " PanelSettings closeReduceWidgetContainers> called.", 1);
      if (reduceUniqueString == "")
      {
        application.trace("<" + this + " PanelSettings closeReduceWidgetContainers> there is no confirm to be closed.", 0);
        return;
      }
      application.getBaseEventDispatcher().removeEventListener(reduceOkType, reduceWidgetContainersConfirmed);
      application.getBaseEventDispatcher().removeEventListener(reduceCancelType, reduceWidgetContainersCancelled);
      if (application.getForeground() != null)
      {
        application.getForeground().closeAlert(reduceUniqueString);
      }
      reduceUniqueString = "";
      reduceOkType = "";
      reduceCancelType = "";
    }
    /**
     * Adds or removes widget containers until there are exactly as many of them as
     * the one using this application has picked.
     */
    private function changeMaxWidgetContainers():void
    {
      application.trace("<" + this + " PanelSettings changeMaxWidgetContainers> called.", 1);
      // the picker of the current container and the one of the orientation are optional
      // elements of this panel, so they are handled one by one below: the number of the
      // containers has to be changeable without either one of them
      if (numOfWidgetcontainersOBJ == null || application.getMiddleground() == null)
      {
        return;
      }
      const wanted:int = numOfWidgetcontainersOBJ.getSelectedIndex() + 1;
      while (application.getMiddleground().getWidgets().getNumOfContents() > wanted)
      {
        application.getMiddleground().getWidgets().removeWidgetContainer();
      }
      while (application.getMiddleground().getWidgets().getNumOfContents() < wanted)
      {
        application.getMiddleground().getWidgets().addWidgetContainer();
      }
      numOfWidgetcontainersOBJprevIndex = numOfWidgetcontainersOBJ.getSelectedIndex();
      // the list of the containers is rebuilt silently, otherwise the handler of it
      // would take the application to another container
      setArraysCurrWidgetcontainerOBJ();
      if (currWidgetcontainerOBJ != null)
      {
        currWidgetcontainerOBJ.setSelectedIndex(numOfWidgetcontainersOBJ.getSelectedIndex(), false);
        displayOrientationOfWidgetContainer(currWidgetcontainerOBJ.getSelectedIndex());
      }
      application.getMiddleground().getWidgets().changeButtonMoveVisibleOnAllWidgets();
    }
    /**
     * Displays the orientation of the given widget container as the picked one. Every
     * container has an orientation of its own, so the displayed one has to follow the
     * active container, and that following is not a change made by the one using this
     * application: it is a value that has been set already.
     * @param index the index of the widget container the orientation is taken from
     */
    private function displayOrientationOfWidgetContainer(index:int):void
    {
      application.trace("<" + this + " PanelSettings displayOrientationOfWidgetContainer> called.", 1);
      application.trace("<" + this + " PanelSettings displayOrientationOfWidgetContainer> index: " + index, 0);
      if (appOrientationOBJ != null && application.getMiddleground() != null)
      {
        appOrientationOBJ.setSelectedIndex(application.getLabelManager().getKeysOrientations()
            .indexOf(application.getMiddleground().getWidgets().getWidgetOrientation(index)), false);
      }
    }
    /**
     * Another widget container has been picked, so the application goes to that one.
     * @param e the changed event of the list picker of the widget containers
     */
    private function currWidgetcontainerOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings currWidgetcontainerOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings currWidgetcontainerOBJChanged> e: " + e, 0);
      if (currWidgetcontainerOBJ != null && application.getMiddleground() != null)
      {
        application.getMiddleground().getWidgets().setActiveWidgetContainer(currWidgetcontainerOBJ.getSelectedIndex());
        displayOrientationOfWidgetContainer(currWidgetcontainerOBJ.getSelectedIndex());
      }
    }
    /**
     * Another orientation of the widgets has been picked.
     * @param e the changed event of the list picker of the orientations
     */
    private function appOrientationOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appOrientationOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appOrientationOBJChanged> e: " + e, 0);
      const orientation:String = selectedValueOf(appOrientationOBJ);
      if (orientation != "")
      {
        application.getDynamicsConfig().setAppOrientation(orientation);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().closePanelSettings();
        }
      }
    }
    /**
     * Another mode of the widgets has been picked.
     * @param e the changed event of the list picker of the widget modes
     */
    private function appWidgetModeOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appWidgetModeOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appWidgetModeOBJChanged> e: " + e, 0);
      const widgetMode:String = selectedValueOf(appWidgetModeOBJ);
      if (widgetMode != "")
      {
        application.getDynamicsConfig().setAppWidgetMode(widgetMode);
        application.setFontSizeFromStage();
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().closePanelSettings();
        }
      }
    }
    /**
     * The volume of the sounds has been changed on this panel.
     * @param e the changed event of the potmeter of the volume
     */
    private function appSoundVolumeOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appSoundVolumeOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appSoundVolumeOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppSoundVolume(int(appSoundVolumeOBJ.getCurValue()));
    }
    /**
     * The playing of the sounds has been switched on this panel.
     * @param e the changed event of the switcher of the playing
     */
    private function appSoundPlayingOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appSoundPlayingOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appSoundPlayingOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppSoundPlaying(appSoundPlayingOBJ.getOn());
    }
    /**
     * The line thickness has been changed on this panel.
     * @param e the changed event of the potmeter of the line thickness
     */
    private function appLineThicknessOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appLineThicknessOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appLineThicknessOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppLineThickness(int(appLineThicknessOBJ.getCurValue()));
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().getWidgets().goToTheActualWidget();
      }
    }
    /**
     * The margin has been changed on this panel.
     * @param e the changed event of the potmeter of the margin
     */
    private function appMarginOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appMarginOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appMarginOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppMargin(int(appMarginOBJ.getCurValue()));
    }
    /**
     * The padding has been changed on this panel.
     * @param e the changed event of the potmeter of the padding
     */
    private function appPaddingOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appPaddingOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appPaddingOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppPadding(int(appPaddingOBJ.getCurValue()));
    }
    /**
     * The radius has been changed on this panel.
     * @param e the changed event of the potmeter of the radius
     */
    private function appRadiusOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appRadiusOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appRadiusOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppRadius(int(appRadiusOBJ.getCurValue()));
    }
    /**
     * The corner of the box has been changed on this panel.
     * @param e the changed event of the potmeter of the box corner
     */
    private function appBoxCornerOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBoxCornerOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBoxCornerOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBoxCorner(int(appBoxCornerOBJ.getCurValue()));
    }
    /**
     * Another frame of the box has been picked on this panel.
     * @param e the changed event of the list picker of the box frames
     */
    private function appBoxFrameOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBoxFrameOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBoxFrameOBJchanged> e: " + e, 0);
      const boxFrame:String = selectedValueOf(appBoxFrameOBJ);
      if (boxFrame != "")
      {
        application.getDynamicsConfig().setAppBoxFrame(boxFrame);
      }
    }
    /**
     * The dark background color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appBackgroundColorDarkOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorDarkOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorDarkOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorDark(colorToNumber(appBackgroundColorDarkOBJ.getRGBColor()));
    }
    /**
     * The mid background color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appBackgroundColorMidOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorMidOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorMidOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorMid(colorToNumber(appBackgroundColorMidOBJ.getRGBColor()));
    }
    /**
     * The bright background color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appBackgroundColorBrightOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorBrightOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorBrightOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorBright(colorToNumber(appBackgroundColorBrightOBJ.getRGBColor()));
    }
    /**
     * The alpha of the background color has been changed on this panel.
     * @param e the changed event of the potmeter of that alpha
     */
    private function appBackgroundColorAlphaOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorAlphaOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorAlphaOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorAlpha(appBackgroundColorAlphaOBJ.getCurValue());
    }
    /**
     * The randomness of the background color has been switched on this panel.
     * @param e the changed event of the switcher of that randomness
     */
    private function appBackgroundColorRandOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorRandOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorRandOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorRand(appBackgroundColorRandOBJ.getOn());
    }
    /**
     * Whether the font colors follow the background colors has been switched on this panel.
     * @param e the changed event of the switcher of that property
     */
    private function appBackgroundColorToFontOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorToFontOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorToFontOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundColorToFont(appBackgroundColorToFontOBJ.getOn());
    }
    /**
     * Another align of the background image has been picked on this panel.
     * @param e the changed event of the list picker of the aligns
     */
    private function appBackgroundAlignOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundAlignOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundAlignOBJChanged> e: " + e, 0);
      const backgroundAlign:String = selectedValueOf(appBackgroundAlignOBJ);
      if (backgroundAlign != "")
      {
        application.getDynamicsConfig().setAppBackgroundAlign(backgroundAlign);
      }
    }
    /**
     * The alpha of the background image has been changed on this panel.
     * @param e the changed event of the potmeter of that alpha
     */
    private function appBackgroundAlphaOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundAlphaOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundAlphaOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundAlpha(appBackgroundAlphaOBJ.getCurValue());
    }
    /**
     * The blur of the background image has been changed on this panel.
     * @param e the changed event of the potmeter of that blur
     */
    private function appBackgroundBlurOBJchanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundBlurOBJchanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundBlurOBJchanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundBlur(int(appBackgroundBlurOBJ.getCurValue()));
    }
    /**
     * The live property of the background has been switched on this panel.
     * @param e the changed event of the switcher of that property
     */
    private function appBackgroundLiveOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundLiveOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundLiveOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppBackgroundLive(appBackgroundLiveOBJ.getOn());
    }
    /**
     * Another font face has been picked on this panel.
     * @param e the changed event of the list picker of the font faces
     */
    private function appFontFaceOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontFaceOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontFaceOBJChanged> e: " + e, 0);
      const fontFace:String = selectedValueOf(appFontFaceOBJ);
      if (fontFace != "")
      {
        application.getDynamicsConfig().setAppFontFace(fontFace);
      }
    }
    /**
     * Another font size has been picked on this panel.
     * @param e the changed event of the list picker of the font sizes
     */
    private function appFontSizeOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontSizeOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontSizeOBJChanged> e: " + e, 0);
      const fontSize:String = selectedValueOf(appFontSizeOBJ);
      if (fontSize != "")
      {
        application.getDynamicsConfig().setAppFontSize(int(fontSize));
      }
    }
    /**
     * The bright font color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appFontColorBrightOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorBrightOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorBrightOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontColorBright(colorToNumber(appFontColorBrightOBJ.getRGBColor()));
    }
    /**
     * The mid font color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appFontColorMidOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorMidOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorMidOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontColorMid(colorToNumber(appFontColorMidOBJ.getRGBColor()));
    }
    /**
     * The dark font color has been changed on this panel.
     * @param e the changed event of the color picker of that color
     */
    private function appFontColorDarkOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorDarkOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorDarkOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontColorDark(colorToNumber(appFontColorDarkOBJ.getRGBColor()));
    }
    /**
     * The randomness of the font color has been switched on this panel.
     * @param e the changed event of the switcher of that randomness
     */
    private function appFontColorRandOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorRandOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorRandOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontColorRand(appFontColorRandOBJ.getOn());
    }
    /**
     * Whether the background colors follow the font colors has been switched on this panel.
     * @param e the changed event of the switcher of that property
     */
    private function appFontColorToBackgroundOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorToBackgroundOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorToBackgroundOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontColorToBackground(appFontColorToBackgroundOBJ.getOn());
    }
    /**
     * The boldness of the font has been switched on this panel.
     * @param e the changed event of the switcher of the boldness
     */
    private function appFontBoldOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontBoldOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontBoldOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontBold(appFontBoldOBJ.getOn());
    }
    /**
     * The skewness of the font has been switched on this panel.
     * @param e the changed event of the switcher of the skewness
     */
    private function appFontItalicOBJChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontItalicOBJChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontItalicOBJChanged> e: " + e, 0);
      application.getDynamicsConfig().setAppFontItalic(appFontItalicOBJ.getOn());
    }
    /**
     * Returns the value picked in the given list picker, an empty string when there is no
     * such picker or nothing picked in it. Every handler of this panel asks for a picked
     * value through this one: a value read by an index of the caller could belong to
     * another item or to no item at all, and an empty value is dropped by the handlers.
     * @param listPicker the list picker the picked value is asked of
     */
    private function selectedValueOf(listPicker:ListPicker):String
    {
      application.trace("<" + this + " PanelSettings selectedValueOf> called.", 1);
      application.trace("<" + this + " PanelSettings selectedValueOf> listPicker: " + listPicker, 0);
      const value:String = listPicker != null ? listPicker.getSelectedValue() : "";
      application.trace("<" + this + " PanelSettings selectedValueOf> value: " + value, 0);
      return value;
    }
    /**
     * Builds the number of a color of the hexadecimal string of it.
     * @param rgbColor the hexadecimal string of that color
     */
    private function colorToNumber(rgbColor:String):Number
    {
      application.trace("<" + this + " PanelSettings colorToNumber> called.", 1);
      application.trace("<" + this + " PanelSettings colorToNumber> rgbColor: " + rgbColor, 0);
      const color:Number = Number(application.getComponentsConfig().getColorHexToNumberString() + rgbColor);
      application.trace("<" + this + " PanelSettings colorToNumber> color: " + color, 0);
      return color;
    }
    /**
     * Gives every list picker of the general content the width of the switcher of
     * the sound: that one is the widest element standing on that content. A part of the
     * width of this panel is taken instead while that switcher has no width of its own
     * yet, and when the configuration of the application has switched it off for good.
     */
    private function resizeListPickers():void
    {
      application.trace("<" + this + " PanelSettings resizeListPickers> called.", 1);
      const soundDw:int = appSoundPlayingOBJ != null ? appSoundPlayingOBJ.getDw() : 0;
      const dw:int = soundDw > 0 ? soundDw : getDw() * listPickerFAC;
      const listPickers:Array = [langCodeOBJ, numOfWidgetcontainersOBJ, currWidgetcontainerOBJ
        , appOrientationOBJ, appWidgetModeOBJ, appBoxFrameOBJ];
      for (var i:int = 0; i < listPickers.length; i++)
      {
        if (listPickers[i] != null)
        {
          BaseSprite(listPickers[i]).setDw(dw);
        }
      }
      listPickers.splice(0);
    }
    /**
     * The label of the align of the background image has been resized, so the list
     * picker above it takes the new width.
     * @param e the dimensions changed event of that label, or null when it is called by hand
     */
    private function appBackgroundAlignLABResized(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundAlignLABResized> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundAlignLABResized> e: " + e, 0);
      if (appBackgroundAlignOBJ != null && appBackgroundAlignLAB != null)
      {
        appBackgroundAlignOBJ.setDw(appBackgroundAlignLAB.getDw());
      }
    }
    /**
     * The color pickers of the font colors have been resized, so the list pickers
     * standing above them take the width of the whole row of them.
     * @param e the dimensions changed event of one of those pickers, or null when it
     *          is called by hand
     */
    private function appFontColorsOBJSizesChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appFontColorsOBJSizesChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appFontColorsOBJSizesChanged> e: " + e, 0);
      if (appFontFaceOBJ != null)
      {
        appFontFaceOBJ.setDw(appFontColorBrightOBJ != null && appFontColorDarkOBJ != null
          ? appFontColorDarkOBJ.getCx(true) - appFontColorBrightOBJ.getCx()
          : getDw() * listPickerFAC);
      }
      if (appFontSizeOBJ != null)
      {
        appFontSizeOBJ.setDw(appFontFaceOBJ != null ? appFontFaceOBJ.getDw() : getDw() * listPickerFAC);
      }
    }
    /**
     * The color pickers of the background colors have been resized, so the list picker
     * standing above them takes the width of the whole row of them.
     * @param e the dimensions changed event of one of those pickers, or null when it
     *          is called by hand
     */
    private function appBackgroundColorsOBJSizesChanged(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appBackgroundColorsOBJSizesChanged> called.", 1);
      application.trace("<" + this + " PanelSettings appBackgroundColorsOBJSizesChanged> e: " + e, 0);
      if (displayingStyleOBJ != null)
      {
        displayingStyleOBJ.setDw(appBackgroundColorBrightOBJ != null && appBackgroundColorDarkOBJ != null
          ? appBackgroundColorDarkOBJ.getCx(true) - appBackgroundColorBrightOBJ.getCx()
          : getDw() * listPickerFAC);
      }
    }
    /**
     * The switcher of the sound has been resized, so every list picker of the general
     * content takes the new width.
     * @param e the dimensions changed event of that switcher
     */
    private function appSoundPlayingOBJresized(e:Event):void
    {
      application.trace("<" + this + " PanelSettings appSoundPlayingOBJresized> called.", 1);
      application.trace("<" + this + " PanelSettings appSoundPlayingOBJresized> e: " + e, 0);
      resizeListPickers();
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " PanelSettings destroy> called.", 1);
      application.trace("<" + this + " PanelSettings destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      removeListenersFromApplication();
      // an unanswered confirm would leave both of its answers on the dispatcher of the
      // application, and those answers work with the elements freed up below
      closeReduceWidgetContainers();
      application.trace("<" + this + " PanelSettings destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      numOfWidgetcontainersARR.splice(0);
      currWidgetcontainerARR.splice(0);
      homepageLinksARR.splice(0);
      backLinksARR.splice(0);
      application.trace("<" + this + " PanelSettings destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " PanelSettings destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      indexSettings = -1;
      indexAppearance = -1;
      indexAbout = -1;
      indexLining = -1;
      indexColoring = -1;
      indexImaging = -1;
      indexFonting = -1;
      langCodeLAB = null;
      langCodeOBJ = null;
      numOfWidgetcontainersLAB = null;
      numOfWidgetcontainersOBJ = null;
      numOfWidgetcontainersARR = null;
      numOfWidgetcontainersOBJprevIndex = 0;
      reduceUniqueString = "";
      reduceOkType = "";
      reduceCancelType = "";
      currWidgetcontainerLAB = null;
      currWidgetcontainerOBJ = null;
      currWidgetcontainerARR = null;
      appOrientationLAB = null;
      appOrientationOBJ = null;
      appWidgetModeLAB = null;
      appWidgetModeOBJ = null;
      appSoundVolumeOBJ = null;
      appSoundPlayingOBJ = null;
      appLineThicknessLAB = null;
      appLineThicknessOBJ = null;
      appMarginLAB = null;
      appMarginOBJ = null;
      appPaddingLAB = null;
      appPaddingOBJ = null;
      appRadiusLAB = null;
      appRadiusOBJ = null;
      appBoxCornerLAB = null;
      appBoxCornerOBJ = null;
      appBoxFrameLAB = null;
      appBoxFrameOBJ = null;
      displayingStyleLAB = null;
      displayingStyleOBJ = null;
      appBackgroundColorsLAB = null;
      appBackgroundColorDarkOBJ = null;
      appBackgroundColorMidOBJ = null;
      appBackgroundColorBrightOBJ = null;
      appBackgroundColorAlphaLAB = null;
      appBackgroundColorAlphaOBJ = null;
      appBackgroundColorRandLAB = null;
      appBackgroundColorRandOBJ = null;
      appBackgroundColorToFontLAB = null;
      appBackgroundColorToFontOBJ = null;
      appBackgroundColorGetNewSchema = null;
      appBackgroundImageVAL = null;
      appBackgroundAlignLAB = null;
      appBackgroundAlignOBJ = null;
      appBackgroundAlphaLAB = null;
      appBackgroundAlphaOBJ = null;
      appBackgroundBlurLAB = null;
      appBackgroundBlurOBJ = null;
      appBackgroundLiveLAB = null;
      appBackgroundLiveOBJ = null;
      userBgHandler = null;
      appFontFaceLAB = null;
      appFontFaceOBJ = null;
      appFontSizeLAB = null;
      appFontSizeOBJ = null;
      appFontColorsLAB = null;
      appFontColorBrightOBJ = null;
      appFontColorMidOBJ = null;
      appFontColorDarkOBJ = null;
      appFontBoldLAB = null;
      appFontBoldOBJ = null;
      appFontItalicLAB = null;
      appFontItalicOBJ = null;
      appFontColorRandLAB = null;
      appFontColorRandOBJ = null;
      appFontColorToBackgroundLAB = null;
      appFontColorToBackgroundOBJ = null;
      appFontColorGetNewSchema = null;
      applicationNameLAB = null;
      applicationVersionLAB = null;
      applicationReleaseDateLAB = null;
      homepageLinksARR = null;
      liningLinkOBJ = null;
      coloringLinkOBJ = null;
      imagingLinkOBJ = null;
      fontingLinkOBJ = null;
      defaultAppearanceLinkOBJ = null;
      resetAppearanceLinkOBJ = null;
      backLinksARR = null;
    }
  }
}
