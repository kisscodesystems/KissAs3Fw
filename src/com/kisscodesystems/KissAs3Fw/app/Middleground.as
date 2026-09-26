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
 * Middleground.
 * The middle layer of the application: the widgets, the panel of the menu and
 * the panel of the settings are standing on it.
 *
 * MAIN FEATURES:
 * - holds the widgets, the menu button and panel, the settings button and panel,
 *   the name of the application and the watch
 * - the menu, the settings and the watch are optional, the configuration of the
 *   application tells which one of them is needed
 * - it follows the size of the application, so it follows the size of the stage
 * - it becomes invisible while the foreground is displaying something
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonText;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Fw.ui.Watch;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import flash.events.Event;
  public class Middleground extends BaseSprite
  {
    // the holder of every widget of this application
    private var widgets:Widgets = null;
    // the height the widgets have room in
    private var widgetsDh:int = 0;
    // the button and the panel of the menu, when the menu is enabled
    private var buttonTextMenu:ButtonText = null;
    private var panelMenu:PanelMenu = null;
    // the button and the panel of the settings, when the settings are enabled
    private var buttonTextSettings:ButtonText = null;
    private var panelSettings:PanelSettings = null;
    // the watch displaying the current time of the client, when the watch is enabled
    private var watch:Watch = null;
    // the label displaying the name of this application
    private var applicationName:TextLabel = null;
    /**
     * Constructs the middleground with the widgets and with every optional element
     * the configuration of this application asks for.
     * @param applicationRef the main application reference
     */
    public function Middleground(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Middleground> called.", 1);
      application.trace("<" + this + " Middleground> applicationRef: " + applicationRef, 0);
      widgets = new Widgets(application);
      addChild(widgets);
      widgets.addWidgetContainer();
      applicationName = new TextLabel(application);
      addChild(applicationName);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WATCH_REPOSITIONED(), appNameResize);
      // the watch stands above the name of the application
      if (application.getComponentsConfig().getWatchEnabled())
      {
        watch = new Watch(application);
        addChild(watch);
        watch.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), watchDimensionsChanged);
      }
      if (application.getComponentsConfig().getPanelMenuEnabled())
      {
        buttonTextMenu = new ButtonText(application);
        addChild(buttonTextMenu);
        buttonTextMenu.setIcon(EnumIcons.menu());
        buttonTextMenu.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), buttonTextMenuClick);
      }
      if (application.getComponentsConfig().getPanelSettingsEnabled())
      {
        buttonTextSettings = new ButtonText(application);
        addChild(buttonTextSettings);
        buttonTextSettings.setIcon(EnumIcons.settings());
        buttonTextSettings.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), buttonTextSettingsClick);
      }
      // the panels are added after the buttons on purpose: an opened panel has to
      // cover the button that has opened it
      if (application.getComponentsConfig().getPanelMenuEnabled())
      {
        panelMenu = new PanelMenu(application);
        addChild(panelMenu);
        panelMenu.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), panelMenuClosed);
        panelMenu.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), panelMenuHandler);
      }
      if (application.getComponentsConfig().getPanelSettingsEnabled())
      {
        panelSettings = new PanelSettings(application);
        addChild(panelSettings);
        panelSettings.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLOSED(), panelSettingsClosed);
      }
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), stuffsChanged);
      application.trace("<" + this + " Middleground> constructed.", 1);
    }
    /**
     * Returns the holder of every widget of this application.
     */
    public function getWidgets():Widgets
    {
      return widgets;
    }
    /**
     * Returns the height the widgets have room in.
     */
    public function getWidgetsDh():int
    {
      return widgetsDh;
    }
    /**
     * Returns the watch of this application, or null when the watch is disabled.
     */
    public function getWatch():Watch
    {
      return watch;
    }
    /**
     * Returns the width of the menu and of the settings panel. In desktop mode it is
     * calculated from the font size, in mobile mode the panel fills the whole width.
     */
    public function getPanelWidth():int
    {
      application.trace("<" + this + " Middleground getPanelWidth> called.", 1);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      var panelWidth:int = getDw() - 2 * margin;
      if (application.getDynamicsConfig().weAreInDesktopMode())
      {
        panelWidth = application.getFontSizeInUse() * 20 + margin * 8 + application.getDynamicsConfig().getAppPadding() * 8;
      }
      application.trace("<" + this + " Middleground getPanelWidth> panelWidth: " + panelWidth, 0);
      return panelWidth;
    }
    /**
     * Returns the height of the panel of the menu.
     */
    public function getPanelMenuHeight():int
    {
      application.trace("<" + this + " Middleground getPanelMenuHeight> called.", 1);
      var panelMenuHeight:int = getDh();
      if (buttonTextMenu != null)
      {
        panelMenuHeight = getDh() - buttonTextMenu.getCy() - application.getDynamicsConfig().getAppMargin();
      }
      application.trace("<" + this + " Middleground getPanelMenuHeight> panelMenuHeight: " + panelMenuHeight, 0);
      return panelMenuHeight;
    }
    /**
     * Returns the height of the panel of the settings.
     */
    public function getPanelSettingsHeight():int
    {
      application.trace("<" + this + " Middleground getPanelSettingsHeight> called.", 1);
      var panelSettingsHeight:int = getDh();
      if (buttonTextSettings != null)
      {
        panelSettingsHeight = getDh() - buttonTextSettings.getCy(true) - 2 * application.getDynamicsConfig().getAppMargin();
      }
      application.trace("<" + this + " Middleground getPanelSettingsHeight> panelSettingsHeight: " + panelSettingsHeight, 0);
      return panelSettingsHeight;
    }
    /**
     * Sets the name of this application on the label displaying it, with an icon
     * in front of it when an icon is asked for.
     * @param iconName the icon to be displayed, an empty one means no icon at all
     */
    public function setApplicationNameWithIcon(iconName:String):void
    {
      application.trace("<" + this + " Middleground setApplicationNameWithIcon> called.", 1);
      application.trace("<" + this + " Middleground setApplicationNameWithIcon> iconName: " + iconName, 0);
      if (applicationName != null)
      {
        applicationName.setLabel(application.getApplicationType() != ""
          ? application.getApplicationType() + " " + application.getPropertiesConfig().getApplicationName()
          : application.getPropertiesConfig().getApplicationName());
        if (iconName != null && iconName != "")
        {
          applicationName.setIcon(iconName);
        }
        else
        {
          applicationName.destIcon();
        }
      }
      if (panelSettings != null)
      {
        panelSettings.refreshAbout();
      }
      middlegroundRePosSize();
    }
    /**
     * Enables or disables the menu and the settings button of this object as well.
     * @param e whether this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " Middleground setEnabled> called.", 1);
      application.trace("<" + this + " Middleground setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (buttonTextMenu != null)
      {
        buttonTextMenu.setEnabled(getEnabled());
      }
      if (buttonTextSettings != null)
      {
        buttonTextSettings.setEnabled(getEnabled());
      }
    }
    /**
     * Sets whether this object is displayed. The setVisible of the foreground has to
     * be called instead of this one: that one keeps the two layers in sync.
     * @param b whether this object has to be displayed
     */
    public function setVisible(b:Boolean):void
    {
      application.trace("<" + this + " Middleground setVisible> called.", 1);
      application.trace("<" + this + " Middleground setVisible> b: " + b, 0);
      visible = b;
    }
    /**
     * Sets whether the button opening the menu is usable.
     * @param v whether that button has to be usable
     */
    public function setVisibleButtonTextMenu(v:Boolean):void
    {
      application.trace("<" + this + " Middleground setVisibleButtonTextMenu> called.", 1);
      application.trace("<" + this + " Middleground setVisibleButtonTextMenu> v: " + v, 0);
      panelMenuClosed(null);
      if (buttonTextMenu != null)
      {
        buttonTextMenu.setEnabled(v);
      }
    }
    /**
     * Sets whether the button opening the settings is usable.
     * @param v whether that button has to be usable
     */
    public function setVisibleButtonTextSettings(v:Boolean):void
    {
      application.trace("<" + this + " Middleground setVisibleButtonTextSettings> called.", 1);
      application.trace("<" + this + " Middleground setVisibleButtonTextSettings> v: " + v, 0);
      panelSettingsClosed(null);
      if (buttonTextSettings != null)
      {
        buttonTextSettings.setEnabled(v);
      }
    }
    /**
     * Opens the panel of the menu.
     */
    public function openPanelMenu():void
    {
      application.trace("<" + this + " Middleground openPanelMenu> called.", 1);
      if (panelMenu != null)
      {
        buttonTextMenu.visible = false;
        panelMenu.open();
      }
    }
    /**
     * Closes the panel of the menu.
     */
    public function closePanelMenu():void
    {
      application.trace("<" + this + " Middleground closePanelMenu> called.", 1);
      if (panelMenu != null)
      {
        buttonTextMenu.visible = true;
        buttonTextMenu.setEnabled(true);
        panelMenu.close();
      }
    }
    /**
     * Opens the panel of the settings.
     */
    public function openPanelSettings():void
    {
      application.trace("<" + this + " Middleground openPanelSettings> called.", 1);
      if (panelSettings != null)
      {
        buttonTextSettings.visible = false;
        panelSettings.open();
      }
    }
    /**
     * Closes the panel of the settings.
     */
    public function closePanelSettings():void
    {
      application.trace("<" + this + " Middleground closePanelSettings> called.", 1);
      if (panelSettings != null)
      {
        buttonTextSettings.visible = true;
        buttonTextSettings.setEnabled(true);
        panelSettings.close();
      }
    }
    /**
     * Sets the language of this application. Every panel displaying that language follows
     * it through the language changed event, so it can be set without any of them.
     * @param langCode the language code this application has to switch to
     */
    public function setLangCode(langCode:String):void
    {
      application.trace("<" + this + " Middleground setLangCode> called.", 1);
      application.trace("<" + this + " Middleground setLangCode> langCode: " + langCode, 0);
      if (panelSettings != null)
      {
        panelSettings.setLangCode(langCode);
      }
      else
      {
        application.getLabelManager().setLang(langCode);
      }
    }
    /**
     * Reloads the languages of this application. More of them can be added later on.
     */
    public function updateLangCodes():void
    {
      application.trace("<" + this + " Middleground updateLangCodes> called.", 1);
      if (panelSettings != null)
      {
        panelSettings.updateLangCodes();
      }
    }
    /**
     * Reloads the displaying styles of this application. More of them can be added later on.
     */
    public function updateDisplayingStyles():void
    {
      application.trace("<" + this + " Middleground updateDisplayingStyles> called.", 1);
      if (panelSettings != null)
      {
        panelSettings.updateDisplayingStyles();
      }
    }
    /**
     * Reloads the menu of this application from the xml of it.
     */
    public function updateMenuxml():void
    {
      application.trace("<" + this + " Middleground updateMenuxml> called.", 1);
      if (panelMenu != null)
      {
        panelMenu.updateMenuxml();
      }
    }
    /**
     * Returns the widget container that is the active one right now.
     */
    public function getActiveWidgetContainer():int
    {
      application.trace("<" + this + " Middleground getActiveWidgetContainer> called.", 1);
      const index:int = panelSettings != null ? panelSettings.getActiveWidgetContainer() : 0;
      application.trace("<" + this + " Middleground getActiveWidgetContainer> index: " + index, 0);
      return index;
    }
    /**
     * Sets the widget container that has to be the active one.
     * @param index the index of that widget container
     */
    public function setActiveWidgetContainer(index:int):void
    {
      application.trace("<" + this + " Middleground setActiveWidgetContainer> called.", 1);
      application.trace("<" + this + " Middleground setActiveWidgetContainer> index: " + index, 0);
      if (panelSettings != null)
      {
        panelSettings.setActiveWidgetContainer(index);
      }
    }
    /**
     * Displays the given widget container on the panel of the settings.
     * @param index the index of that widget container
     */
    public function showWidgetContainer(index:int):void
    {
      application.trace("<" + this + " Middleground showWidgetContainer> called.", 1);
      application.trace("<" + this + " Middleground showWidgetContainer> index: " + index, 0);
      if (panelSettings != null)
      {
        panelSettings.showWidgetContainer(index);
      }
    }
    /**
     * Returns the object handling the background image uploaded by the one using
     * this application, or null when there is no such object.
     */
    public function getUserBgHandler():BaseSprite
    {
      application.trace("<" + this + " Middleground getUserBgHandler> called.", 1);
      const baseSprite:BaseSprite = panelSettings != null ? panelSettings.getUserBgHandler() : null;
      application.trace("<" + this + " Middleground getUserBgHandler> baseSprite: " + baseSprite, 0);
      return baseSprite;
    }
    /**
     * Adds the object handling the background image uploaded by the one using this
     * application. Such an object is built by the extenders of this framework.
     * @param baseSprite the object to be added
     */
    public function addUserBgHandler(baseSprite:BaseSprite):void
    {
      application.trace("<" + this + " Middleground addUserBgHandler> called.", 1);
      application.trace("<" + this + " Middleground addUserBgHandler> baseSprite: " + baseSprite, 0);
      if (panelSettings != null)
      {
        panelSettings.addUserBgHandler(baseSprite);
      }
    }
    /**
     * Sets whether the object handling the uploaded background image is displayed.
     * @param b whether that object has to be displayed
     */
    public function setUserBgHandlerVisible(b:Boolean):void
    {
      application.trace("<" + this + " Middleground setUserBgHandlerVisible> called.", 1);
      application.trace("<" + this + " Middleground setUserBgHandlerVisible> b: " + b, 0);
      if (panelSettings != null)
      {
        panelSettings.setUserBgHandlerVisible(b);
      }
    }
    /**
     * Adds a widget into the given widget container.
     * @param contentId the index of that widget container
     * @param widget the widget to be added
     */
    public function addWidget(contentId:int, widget:Widget):void
    {
      application.trace("<" + this + " Middleground addWidget> called.", 1);
      application.trace("<" + this + " Middleground addWidget> contentId: " + contentId, 0);
      application.trace("<" + this + " Middleground addWidget> widget: " + widget, 0);
      if (widgets != null)
      {
        widgets.addWidget(contentId, widget);
      }
    }
    /**
     * Closes a widget of this application.
     * @param widget the widget to be closed
     */
    public function closeWidget(widget:Widget):void
    {
      application.trace("<" + this + " Middleground closeWidget> called.", 1);
      application.trace("<" + this + " Middleground closeWidget> widget: " + widget, 0);
      if (widgets != null)
      {
        widgets.closeWidget(widget);
      }
    }
    /**
     * Resizes and repositions everything standing on this object. It has to be
     * reachable from the outside as well: the widget mode changing needs it.
     */
    public function middlegroundRePosSize():void
    {
      application.trace("<" + this + " Middleground middlegroundRePosSize> called.", 1);
      if (application == null)
      {
        return;
      }
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      widgetsDh = getDh();
      if (panelSettings != null)
      {
        buttonTextSettings.setCxy(getDw() - margin - buttonTextSettings.getDw(), margin);
        panelSettings.setDwh(getPanelWidth(), getPanelSettingsHeight());
        panelSettings.setCxy(getDw() - margin - panelSettings.getDw(), getDh() - getPanelSettingsHeight() - margin);
        widgetsDh = getDh() - buttonTextSettings.getCy(true);
      }
      watchDimensionsChanged(null);
      if (panelMenu != null)
      {
        buttonTextMenu.setCxy(margin, margin);
        panelMenu.setDwh(getPanelWidth(), getPanelMenuHeight());
        panelMenu.setCxy(buttonTextMenu.getCx(), buttonTextMenu.getCy());
        widgetsDh = getDh() - buttonTextMenu.getCy(true);
      }
      if (buttonTextMenu != null)
      {
        applicationName.setCxy(buttonTextMenu.getCx(true) + margin, buttonTextMenu.getCy() + padding);
      }
      else if (watch != null)
      {
        applicationName.setCxy(margin, watch.getCy() + padding);
      }
      else if (buttonTextSettings != null)
      {
        applicationName.setCxy(margin, buttonTextSettings.getCy() + padding);
      }
      else
      {
        applicationName.setCxy(margin, margin);
      }
      appNameResize(null);
      if (panelSettings == null && watch == null && panelMenu == null)
      {
        // there is nothing above the widgets but the name of this application
        widgetsDh = getDh() - (applicationName.getLabel() == "" ? 0 : applicationName.getDh());
      }
      widgets.widgetsRePosSize();
    }
    /**
     * Resizes and repositions everything after the dimensions of this object have
     * been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " Middleground doDimensionsChanged> called.", 1);
      middlegroundRePosSize();
      super.doDimensionsChanged();
    }
    /**
     * The watch has been resized, so it has to be repositioned as well. It stands in
     * the top right corner, in front of the button of the settings when there is one.
     * @param e the dimensions changed event of the watch, or null when it is called by hand
     */
    private function watchDimensionsChanged(e:Event):void
    {
      application.trace("<" + this + " Middleground watchDimensionsChanged> called.", 1);
      application.trace("<" + this + " Middleground watchDimensionsChanged> e: " + e, 0);
      if (watch != null)
      {
        const margin:int = application.getDynamicsConfig().getAppMargin();
        const rightEdge:int = buttonTextSettings != null ? buttonTextSettings.getCx() : getDw();
        watch.setCxy(rightEdge - watch.getDw() - margin, margin);
      }
    }
    /**
     * Gives the name of this application the width that is free in front of it.
     * @param e the event asking for the resizing, or null when it is called by hand
     */
    private function appNameResize(e:Event):void
    {
      application.trace("<" + this + " Middleground appNameResize> called.", 1);
      application.trace("<" + this + " Middleground appNameResize> e: " + e, 0);
      if (applicationName == null)
      {
        return;
      }
      const margin:int = application.getDynamicsConfig().getAppMargin();
      if (watch != null)
      {
        applicationName.setMaxWidth(watch.getCx() + watch.getShapeFgFrameX() - applicationName.getCx() - margin, false);
      }
      else
      {
        applicationName.setMaxWidth(getDw() - 4 * applicationName.getDh()
          - 4 * application.getDynamicsConfig().getAppPadding() - 2 * margin, false);
      }
    }
    /**
     * One of the displayed properties of the application has been changed, so
     * everything standing on this object has to follow it.
     * @param e the event of the property that has been changed
     */
    private function stuffsChanged(e:Event):void
    {
      application.trace("<" + this + " Middleground stuffsChanged> called.", 1);
      application.trace("<" + this + " Middleground stuffsChanged> e: " + e, 0);
      middlegroundRePosSize();
    }
    /**
     * The button of the menu has been clicked.
     * @param e the click event of that button
     */
    private function buttonTextMenuClick(e:Event):void
    {
      application.trace("<" + this + " Middleground buttonTextMenuClick> called.", 1);
      application.trace("<" + this + " Middleground buttonTextMenuClick> e: " + e, 0);
      openPanelMenu();
    }
    /**
     * The button of the settings has been clicked.
     * @param e the click event of that button
     */
    private function buttonTextSettingsClick(e:Event):void
    {
      application.trace("<" + this + " Middleground buttonTextSettingsClick> called.", 1);
      application.trace("<" + this + " Middleground buttonTextSettingsClick> e: " + e, 0);
      openPanelSettings();
    }
    /**
     * An item of the menu has been picked, so the application handles that one.
     * @param e the changed event of the panel of the menu
     */
    private function panelMenuHandler(e:Event):void
    {
      application.trace("<" + this + " Middleground panelMenuHandler> called.", 1);
      application.trace("<" + this + " Middleground panelMenuHandler> e: " + e, 0);
      if (panelMenu.getSelectedItem() != "")
      {
        application.handleMenuSelect(panelMenu.getSelectedItem());
      }
    }
    /**
     * The panel of the menu has been closed, so its button becomes usable again.
     * @param e the closed event of that panel, or null when it is called by hand
     */
    private function panelMenuClosed(e:Event):void
    {
      application.trace("<" + this + " Middleground panelMenuClosed> called.", 1);
      application.trace("<" + this + " Middleground panelMenuClosed> e: " + e, 0);
      if (buttonTextMenu != null)
      {
        buttonTextMenu.visible = true;
        buttonTextMenu.setEnabled(true);
      }
    }
    /**
     * The panel of the settings has been closed, so its button becomes usable again.
     * @param e the closed event of that panel, or null when it is called by hand
     */
    private function panelSettingsClosed(e:Event):void
    {
      application.trace("<" + this + " Middleground panelSettingsClosed> called.", 1);
      application.trace("<" + this + " Middleground panelSettingsClosed> e: " + e, 0);
      if (buttonTextSettings != null)
      {
        buttonTextSettings.visible = true;
        buttonTextSettings.setEnabled(true);
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Middleground destroy> called.", 1);
      application.trace("<" + this + " Middleground destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WATCH_REPOSITIONED(), appNameResize);
      application.trace("<" + this + " Middleground destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " Middleground destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " Middleground destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      widgets = null;
      widgetsDh = 0;
      buttonTextMenu = null;
      panelMenu = null;
      buttonTextSettings = null;
      panelSettings = null;
      watch = null;
      applicationName = null;
    }
  }
}
