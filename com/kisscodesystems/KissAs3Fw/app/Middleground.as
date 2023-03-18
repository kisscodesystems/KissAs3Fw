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
** Middleground.
** The info and widgets, the panel of the menu and the settings are here.
**
** MAIN FEATURES:
** - holds the
**     info
**     , widgets
**     , settings button
**     , settings panel
**     , menu button
**     , menu panel
**     , application name textfield
**     , watch
**     , terms and conditions buttonlink
**     , privacy policy buttonlink
** - followes the size of the application (stage)
** - can be not visible: a blur filter will be applied at this time.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import com . kisscodesystems . KissAs3Fw . ui . Watch ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . display . BitmapData ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . geom . Matrix ;
  import flash . text . TextField ;
  public class Middleground extends BaseSprite
  {
// This is the objext of the widgets.
// Every widget used in this application will be added to there.
    private var widgets : Widgets = null ;
// The height of the the widgetsh.
    private var widgetsh : int = 0 ;
// The height of the info will be calculated here.
    private var infoh : int = 0 ;
// The stuffs of the menu if enabled.
    private var buttonTextMenu : ButtonText = null ;
    private var panelMenu : PanelMenu = null ;
// The stuffs of the settings if enabled.
    private var buttonTextSettings : ButtonText = null ;
    private var panelSettings : PanelSettings = null ;
// The watch to display the current (client) time
    private var watch : Watch = null ;
// The label to display the name of the application.
    private var applicationName : TextLabel = null ;
// This object should be blured or not.
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Middleground ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Let's add these layers!
      widgets = new Widgets ( application ) ;
      addChild ( widgets ) ;
      widgets . addWidgetContainer ( ) ;
// The name of this application will be displayed here.
      applicationName = new TextLabel ( application ) ;
      addChild ( applicationName ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WATCH_REPOSITIONED , appNameReSize ) ;
// The best layer to watch is above the application name.
      if ( application . getPropsApp ( ) . getWatchEnabled ( ) )
      {
        watch = new Watch ( application ) ;
        addChild ( watch ) ;
        watch . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , watchSizesChanged ) ;
      }
// The buttons and the panels of the settings and menu.
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonTextMenu = new ButtonText ( application ) ;
        addChild ( buttonTextMenu ) ;
        buttonTextMenu . setIcon ( "menu" ) ;
        buttonTextMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonTextMenuClick ) ;
      }
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonTextSettings = new ButtonText ( application ) ;
        addChild ( buttonTextSettings ) ;
        buttonTextSettings . setIcon ( "settings" ) ;
        buttonTextSettings . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonTextSettingsClick ) ;
      }
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        panelMenu = new PanelMenu ( application ) ;
        addChild ( panelMenu ) ;
        panelMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLOSED , panelMenuClosed ) ;
        panelMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , panelMenuHandler ) ;
      }
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings = new PanelSettings ( application ) ;
        addChild ( panelSettings ) ;
        panelSettings . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLOSED , panelSettingsClosed ) ;
      }
// Registering onto the events which can modify this object.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_WIDGET_MODE_CHANGED , stuffsChanged ) ;
    }
/*
** Adds an object after initialization to handle user bg upload.
*/
    public function addUserBgHandler ( baseSprite : BaseSprite ) : void
    {
      if ( panelSettings != null )
      {
        panelSettings . addUserBgHandler ( baseSprite ) ;
      }
    }
/*
** When the watch is resized then it is necessary to reposition.
*/
    public function watchSizesChanged ( e : Event ) : void
    {
      if ( watch != null )
      {
        watch . setcxy ( ( buttonTextSettings != null ? buttonTextSettings . getcx ( ) : getsw ( ) ) - watch . getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      }
    }
/*
** Sets the name of the application, and the other text codes.
*/
    public function setApplicationNameWithIcon ( iconName : String ) : void
    {
      if ( application != null && applicationName != null )
      {
        if ( application . getApplicationType ( ) != "" )
        {
          applicationName . setTextCode ( application . getApplicationType ( ) + " " + application . getPropsApp ( ) . getApplicationName ( ) ) ;
        }
        else
        {
          applicationName . setTextCode ( application . getPropsApp ( ) . getApplicationName ( ) ) ;
        }
        if ( iconName != null && iconName != "" )
        {
          applicationName . setIcon ( iconName ) ;
        }
        else
        {
          applicationName . destIcon ( ) ;
        }
      }
      if ( panelSettings != null )
      {
        panelSettings . refreshAbout ( ) ;
      }
      middlegroundRePosSize ( ) ;
    }
/*
 ** Gets the active widget container.
*/
    public function getActiveWidgetContainer ( ) : int
    {
      if ( panelSettings != null )
      {
        return panelSettings . getActiveWidgetContainer ( ) ;
      }
      else
      {
        return 0 ;
      }
    }
/*
** Gets the event of the changing of the menu.
*/
    private function panelMenuHandler ( e : Event ) : void
    {
      if ( panelMenu . getSelectedItem ( ) != "" )
      {
        application . handleMenuSelect ( panelMenu . getSelectedItem ( ) ) ;
      }
    }
/*
** Gets the application background image uploaded by the user.
*/
    public function getUserBgHandler ( ) : BaseSprite
    {
      if ( panelSettings != null )
      {
        return panelSettings . getUserBgHandler ( ) ;
      }
      else
      {
        return null ;
      }
    }
/*
** Override this setEnabled meghod: the buttons will be enabled or disabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( buttonTextMenu != null )
      {
        buttonTextMenu . setEnabled ( getEnabled ( ) ) ;
      }
      if ( buttonTextSettings != null )
      {
        buttonTextSettings . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** Sets its clear property instead of visible (always has to be visible).
** The setVisible of the Foreground should be called instead of this!
*/
    public function setVisible ( b : Boolean ) : void
    {
      visible = b ;
    }
/*
** Sets the lang code.
*/
    public function setLangCode ( langCode : String ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setLangCode ( langCode ) ;
      }
    }
/*
** Lang codes can be added -> it may be necessary to update the list.
*/
    public function setElementsOfLangCodesOBJ ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setElementsOfLangCodesOBJ ( ) ;
      }
      else if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        panelMenu . updateLangCodes ( ) ;
      }
    }
/*
** Displaying styles can be added -> it may be necessary to update the list.
*/
    public function setElementsOfDisplayingStylesOBJ ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setElementsOfDisplayingStylesOBJ ( ) ;
      }
    }
/*
** Sets the active container.
*/
    public function setActiveWidgetContainer ( i : int ) : void
    {
      if ( panelSettings != null )
      {
        panelSettings . setActiveWidgetContainer ( i ) ;
      }
    }
/*
** Shows the actual widget container.
*/
    public function showWidgetContainer ( i : int ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . showWidgetContainer ( i ) ;
      }
    }
/*
** Updates the menuxml.
*/
    public function updateMenuxml ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        panelMenu . updateMenuxml ( ) ;
      }
    }
/*
** The textformat of the mid text type has been changed.
*/
    private function stuffsChanged ( e : Event ) : void
    {
      middlegroundRePosSize ( ) ;
    }
/*
** Sets the visible of the menu and settings button.
*/
    public function setVisibleButtonTextMenu ( v : Boolean ) : void
    {
      panelMenuClosed ( null ) ;
      buttonTextMenu . setEnabled ( v ) ;
    }
    public function setVisibleButtonTextSettings ( v : Boolean ) : void
    {
      panelSettingsClosed ( null ) ;
      buttonTextSettings . setEnabled ( v ) ;
    }
/*
** The menu and the settings button has been clicked.
*/
    private function buttonTextMenuClick ( e : Event ) : void
    {
      openPanelMenu ( ) ;
    }
    public function openPanelMenu ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonTextMenu . visible = false ;
        panelMenu . open ( ) ;
      }
    }
    public function closePanelMenu ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonTextMenu . visible = true ;
        buttonTextMenu . setEnabled ( true ) ;
        panelMenu . close ( ) ;
      }
    }
    private function buttonTextSettingsClick ( e : Event ) : void
    {
      openPanelSettings ( ) ;
    }
    public function openPanelSettings ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonTextSettings . visible = false ;
        panelSettings . open ( ) ;
      }
    }
    public function closePanelSettings ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonTextSettings . visible = true ;
        buttonTextSettings . setEnabled ( true ) ;
        panelSettings . close ( ) ;
      }
    }
/*
** The panel settings user background image.
*/
    public function setUserBgHandlerVisible ( b : Boolean ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setUserBgHandlerVisible ( b ) ;
      }
    }
/*
** The buttons has to be set sometimes.
*/
    public function setEnabledLogoutButton ( b : Boolean ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        panelMenu . setEnabledLogoutButton ( b ) ;
      }
    }
    public function setEnabledRegisterButton ( b : Boolean ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        panelMenu . setEnabledRegisterButton ( b ) ;
      }
    }
/*
** The menu or the settings panel has been closed.
*/
    private function panelMenuClosed ( e : Event ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonTextMenu . visible = true ;
        buttonTextMenu . setEnabled ( true ) ;
      }
    }
    private function panelSettingsClosed ( e : Event ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonTextSettings . visible = true ;
        buttonTextSettings . setEnabled ( true ) ;
      }
    }
/*
** Get this sizes: sometimes it is needed to be public.
*/
    public function getPanelWidth ( ) : int
    {
      return application . getPropsDyn ( ) . weAreInDesktopMode ( ) ? ( ( application . getPropsDyn ( ) . getAppFontSize ( ) == 0 ? application . calcFontSizeFromStageSize ( ) : application . getPropsDyn ( ) . getAppFontSize ( ) ) + 10 ) * 10 + application . getPropsDyn ( ) . getAppMargin ( ) * 8 + application . getPropsDyn ( ) . getAppPadding ( ) * 8 : getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getPanelMenuHeight ( ) : int
    {
      return getsh ( ) - buttonTextMenu . getcy ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
    public function getPanelSettingsHeight ( ) : int
    {
      return getsh ( ) - buttonTextSettings . getcysh ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) ;
    }
/*
** Reference to the watch.
*/
    public function getWatch ( ) : Watch
    {
      return watch ;
    }
/*
** The resizing and repositioning of stuffs of menu and settings.
** Should be public because the widget mode changing needs this.
*/
    public function middlegroundRePosSize ( ) : void
    {
      if ( application != null )
      {
        widgetsh = getsh ( ) ;
        if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
        {
          buttonTextSettings . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) - buttonTextSettings . getsw ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          panelSettings . setswh ( getPanelWidth ( ) , getPanelSettingsHeight ( ) ) ;
          panelSettings . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) - panelSettings . getsw ( ) , getsh ( ) - getPanelSettingsHeight ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          widgetsh = getsh ( ) - buttonTextSettings . getcysh ( ) ;
        }
        watchSizesChanged ( null ) ;
        if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
        {
          buttonTextMenu . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          panelMenu . setswh ( getPanelWidth ( ) , getPanelMenuHeight ( ) ) ;
          panelMenu . setcxy ( buttonTextMenu . getcx ( ) , buttonTextMenu . getcy ( ) ) ;
          widgetsh = getsh ( ) - buttonTextMenu . getcysh ( ) ;
        }
        if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
        {
          applicationName . setcxy ( buttonTextMenu . getcxsw ( ) + application . getPropsDyn ( ) . getAppMargin ( ) , buttonTextMenu . getcy ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        }
        else if ( application . getPropsApp ( ) . getWatchEnabled ( ) )
        {
          applicationName . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , watch . getcy ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        }
        else if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
        {
          applicationName . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , buttonTextSettings . getcy ( ) + application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        }
        else
        {
          applicationName . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        }
        appNameReSize ( null ) ;
        if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) && ! application . getPropsApp ( ) . getWatchEnabled ( ) && ! application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
        {
          widgetsh = getsh ( ) - ( applicationName . getTextCode ( ) == "" ? 0 : applicationName . getsh ( ) ) ;
        }
        widgets . widgetsRePosSize ( ) ;
      }
    }
/*
** Repos only the app name.
*/
    private function appNameReSize ( e : Event ) : void
    {
      if ( applicationName != null )
      {
        if ( watch != null )
        {
          applicationName . setMaxWidth ( watch . getcx ( ) + watch . getShapeFgFrameX ( ) - applicationName . getcx ( ) - application . getPropsDyn ( ) . getAppMargin ( ) , false ) ;
        }
        else
        {
          applicationName . setMaxWidth ( getsw ( ) - 4 * applicationName . getsh ( ) - 4 * application . getPropsDyn ( ) . getAppPadding ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , false ) ;
        }
      }
    }
/*
** Gets the widgets height.
*/
    public function getWidgetsh ( ) : int
    {
      return widgetsh ;
    }
/*
** Gets the widgets.
*/
    public function getWidgets ( ) : Widgets
    {
      return widgets ;
    }
/*
** Adds a widget into the widgets.
*/
    public function addWidget ( contentId : int , widget : Widget ) : void
    {
      if ( widgets != null )
      {
        widgets . addWidget ( contentId , widget ) ;
      }
    }
/*
** Closes a widget.
*/
    public function closeWidget ( widget : Widget ) : void
    {
      if ( widgets != null )
      {
        widgets . closeWidget ( widget ) ;
      }
    }
/*
 ** Sets only the profile image to display.
*/
    public function setProfilePicUrlToDisplay ( p : String ) : void
    {
      if ( panelMenu != null )
      {
        panelMenu . setProfilePicUrlToDisplay ( p ) ;
      }
    }
/*
** Sets the data of the menu panel.
*/
    public function setLoginDataToDisplay ( g : Boolean , i : String , p : String , s : String , u : String , f : String , n : String , r : String ) : void
    {
      if ( panelMenu != null )
      {
        panelMenu . setLoginDataToDisplay ( g , i , p , s , u , f , n , r ) ;
      }
    }
/*
** Updates the role only.
*/
    public function updateRole ( r : String ) : void
    {
      if ( panelMenu != null )
      {
        panelMenu . updateRole ( r ) ;
      }
    }
/*
** This is the method runs after the changing of the size of this object.
*/
    override protected function doSizeChanged ( ) : void
    {
// All of the shapes have to be repainted.
      middlegroundRePosSize ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WIDGET_MODE_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_WATCH_REPOSITIONED , appNameReSize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      widgets = null ;
      widgetsh = 0 ;
      buttonTextMenu = null ;
      panelMenu = null ;
      buttonTextSettings = null ;
      panelSettings = null ;
      applicationName = null ;
    }
  }
}
