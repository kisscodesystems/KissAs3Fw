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
** Middleground.
** The header, footer and widgets, the panel of the menu and the settings are here.
**
** MAIN FEATURES:
** - holds the header , footer , widgets , settings button , settings panel , menu button , menu panel , application name textfield
** - followes the size of the application (stage)
** - can be not visible: a blur filter will be applied at this time.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseShape ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonDraw ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . display . BitmapData ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . filters . BlurFilter ;
  import flash . geom . Matrix ;
  import flash . text . TextField ;
  public class Middleground extends BaseSprite
  {
// This is the objext of the widgets.
// Every widget used in this application will be added to there.
    private var widgets : Widgets = null ;
// This is the header and footer base shape objects.
    private var footer : Footer = null ;
    private var header : Header = null ;
// The height of the the widgetsh.
    private var widgetsh : int = 0 ;
// The height of the footer and the header will be calculated here.
    private var headerh : int = 0 ;
    private var footerh : int = 0 ;
// The stuffs of the menu if enabled.
    private var buttonDrawMenu : ButtonDraw = null ;
    private var panelMenu : PanelMenu = null ;
// The stuffs of the settings if enabled.
    private var buttonDrawSettings : ButtonDraw = null ;
    private var panelSettings : PanelSettings = null ;
// The label to display the name of the application.
    private var textLabelApplicationName : TextLabel = null ;
// This object should be blured or not.
// (visible1: not blured, not visible1: blur filter should be applied.)
    private var visible1 : Boolean = true ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Middleground ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
      filters = null ;
// Let's add these layers!
      widgets = new Widgets ( application ) ;
      addChild ( widgets ) ;
      footer = new Footer ( application ) ;
      addChild ( footer ) ;
      header = new Header ( application ) ;
      addChild ( header ) ;
      createApplicationNameTextField ( ) ;
// The buttons and the panels of the settings and menu.
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonDrawMenu = new ButtonDraw ( application ) ;
        addChild ( buttonDrawMenu ) ;
        buttonDrawMenu . setButtonType ( application . DRAW_BUTTON_TYPE_MENU ) ;
        buttonDrawMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawMenuClick ) ;
        panelMenu = new PanelMenu ( application ) ;
        addChild ( panelMenu ) ;
        panelMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLOSED , panelMenuClosed ) ;
        panelMenu . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , panelMenuHandler ) ;
      }
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonDrawSettings = new ButtonDraw ( application ) ;
        addChild ( buttonDrawSettings ) ;
        buttonDrawSettings . setButtonType ( application . DRAW_BUTTON_TYPE_SETTINGS ) ;
        buttonDrawSettings . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonDrawSettingsClick ) ;
        panelSettings = new PanelSettings ( application ) ;
        addChild ( panelSettings ) ;
        panelSettings . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLOSED , panelSettingsClosed ) ;
      }
// Registering onto the events which can modify this object.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_TEXT_FORMAT_MID_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , stuffsChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , stuffsChanged ) ;
    }
/*
** Sets the name of the application.
** This writes a label into the header of the application.
*/
    private function createApplicationNameTextField ( ) : void
    {
      textLabelApplicationName = new TextLabel ( application ) ;
      addChild ( textLabelApplicationName ) ;
      textLabelApplicationName . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      textLabelApplicationName . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeReposApplicationName ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , resizeReposApplicationName ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resizeReposApplicationName ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resizeReposApplicationName ) ;
    }
    public function setApplicationName ( ) : void
    {
      if ( application != null )
      {
        textLabelApplicationName . setTextCode ( application . getPropsApp ( ) . getApplicationName ( ) ) ;
        resizeReposApplicationName ( ) ;
      }
    }
    private function resizeReposApplicationName ( e : Event = null ) : void
    {
      if ( application != null )
      {
        if ( textLabelApplicationName != null )
        {
          textLabelApplicationName . setMaxWidth ( getsw ( ) - 4 * textLabelApplicationName . getsh ( ) - 4 * application . getPropsDyn ( ) . getAppPadding ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , false ) ;
          textLabelApplicationName . setcxy ( ( getsw ( ) - textLabelApplicationName . getsw ( ) ) / 2 , 2 * application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        }
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
** Sets the smartphone mode.
** Currently: the panel settings and the widgets objects support this.
*/
    public function toSmartphone ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . toSmartphone ( ) ;
      }
      widgets . toSmartphone ( ) ;
      reposResizeStuffs ( ) ;
    }
/*
** Override this setEnabled meghod: the buttons will be enabled or disabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( buttonDrawMenu != null )
      {
        buttonDrawMenu . setEnabled ( getEnabled ( ) ) ;
      }
      if ( buttonDrawSettings != null )
      {
        buttonDrawSettings . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** Sets its clear property instead of visible (always has to be visible).
** If this is not visible then a filter should be applied.
** The setVisible of the Foreground should be called instead of this!
*/
    public function setVisible ( b : Boolean ) : void
    {
      if ( visible1 != b )
      {
        visible1 = b ;
        if ( visible1 )
        {
          filters = null ;
        }
        else
        {
          filters = [ application . getPropsApp ( ) . getBlurFilterBackMiddle ( ) ] ;
        }
      }
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
** Sets the orientation of the widgets in this app.
*/
    public function setWidgetsOrientation ( widgetOrientation : String ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setWidgetsOrientation ( widgetOrientation ) ;
      }
    }
/*
** Sets the predefined displaying styles.
*/
    public function setDisplayingStyle ( styleName : String ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setDisplayingStyleByListpicker ( styleName ) ;
      }
      else
      {
        application . getPropsDyn ( ) . setDisplayingStyle ( styleName ) ;
      }
    }
/*
** Backgrounds images can be added -> it may be necessary to update the list.
*/
    public function setElementsOfBackgroundImageOBJ ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        panelSettings . setElementsOfBackgroundImageOBJ ( ) ;
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
      reposResizeStuffs ( ) ;
    }
/*
** The menu and the settings button has been clicked.
*/
    private function buttonDrawMenuClick ( e : Event ) : void
    {
      openPanelMenu ( ) ;
    }
    public function openPanelMenu ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonDrawMenu . visible = false ;
        panelMenu . open ( ) ;
      }
    }
    private function buttonDrawSettingsClick ( e : Event ) : void
    {
      openPanelSettings ( ) ;
    }
    public function openPanelSettings ( ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonDrawSettings . visible = false ;
        panelSettings . open ( ) ;
      }
    }
/*
** The menu or the settings panel has been closed.
*/
    private function panelMenuClosed ( e : Event ) : void
    {
      if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
      {
        buttonDrawMenu . visible = true ;
        buttonDrawMenu . setEnabled ( true ) ;
      }
    }
    private function panelSettingsClosed ( e : Event ) : void
    {
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        buttonDrawSettings . visible = true ;
        buttonDrawSettings . setEnabled ( true ) ;
      }
    }
/*
** The resizing and repositioning of stuffs of menu and settings.
*/
    private function reposResizeStuffs ( ) : void
    {
      if ( application != null )
      {
        if ( application . getPropsApp ( ) . getHeaderHeightMidLines ( ) == 0 )
        {
          headerh = 0 ;
        }
        else
        {
          headerh = application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) * application . getPropsApp ( ) . getHeaderHeightMidLines ( ) + 4 * application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ;
        }
        if ( application . getPropsApp ( ) . getFooterHeightMidLines ( ) == 0 )
        {
          footerh = 0 ;
        }
        else
        {
          footerh = application . getPropsDyn ( ) . getTextFieldHeight ( application . getTexts ( ) . TEXT_TYPE_MID ) * application . getPropsApp ( ) . getFooterHeightMidLines ( ) + 4 * application . getPropsDyn ( ) . getAppPadding ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ;
        }
        widgetsh = getsh ( ) - headerh - footerh ;
        header . headerRePosSize ( ) ;
        footer . footerRePosSize ( ) ;
        widgets . widgetsRePosSize ( ) ;
        if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
        {
          panelSettings . setswh ( getsw ( ) * application . getPropsApp ( ) . getPanelSettingsWidthFactor ( ) , getsh ( ) * application . getPropsApp ( ) . getPanelSettingsHeightFactor ( ) ) ;
          if ( application . getPropsApp ( ) . getHeaderHeightMidLines ( ) > 0 )
          {
            buttonDrawSettings . setcxy ( header . getcxsw ( ) - buttonDrawSettings . getsw ( ) - application . getPropsDyn ( ) . getAppPadding ( ) - application . getPropsDyn ( ) . getAppMargin ( ) , header . getcysh ( ) - buttonDrawSettings . getsh ( ) - application . getPropsDyn ( ) . getAppPadding ( ) ) ;
            panelSettings . setcxy ( buttonDrawSettings . getcxswap ( ) - panelSettings . getsw ( ) , buttonDrawSettings . getcyshamap ( ) ) ;
          }
          else
          {
            buttonDrawSettings . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) - buttonDrawSettings . getsw ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
            panelSettings . setcxy ( getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) - panelSettings . getsw ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          }
        }
        if ( application . getPropsApp ( ) . getPanelMenuEnabled ( ) )
        {
          if ( application . getPropsApp ( ) . getHeaderHeightMidLines ( ) > 0 )
          {
            buttonDrawMenu . setcxy ( header . getcxamap ( ) , header . getcysh ( ) - buttonDrawMenu . getsh ( ) - application . getPropsDyn ( ) . getAppPadding ( ) ) ;
          }
          else
          {
            buttonDrawMenu . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          }
          panelMenu . setswh ( getsw ( ) * application . getPropsApp ( ) . getPanelMenuWidthFactor ( ) , getsh ( ) * application . getPropsApp ( ) . getPanelMenuHeighthFactor ( ) ) ;
          panelMenu . setcxy ( buttonDrawMenu . getcx ( ) , buttonDrawMenu . getcy ( ) ) ;
        }
      }
    }
/*
** Gets the header height.
*/
    public function getHeaderh ( ) : int
    {
      return headerh ;
    }
/*
** Gets the footer height.
*/
    public function getFooterh ( ) : int
    {
      return footerh ;
    }
/*
** Gets the widgets height.
*/
    public function getWidgetsh ( ) : int
    {
      return widgetsh ;
    }
/*
** Gets the header.
*/
    public function getHeader ( ) : Header
    {
      return header ;
    }
/*
** Gets the footer.
*/
    public function getFooter ( ) : Footer
    {
      return footer ;
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
    public function addWidget ( widget : Widget ) : void
    {
      widgets . addWidget ( widget ) ;
    }
/*
** Closes a widget.
*/
    public function closeWidget ( widget : Widget ) : void
    {
      widgets . closeWidget ( widget ) ;
    }
/*
** This is the method runs after the changing of the size of this object.
*/
    override protected function doSizeChanged ( ) : void
    {
// All of the shapes have to be repainted.
      reposResizeStuffs ( ) ;
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
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , resizeReposApplicationName ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resizeReposApplicationName ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_SIZES_CHANGED , resizeReposApplicationName ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      widgets = null ;
      footer = null ;
      header = null ;
      widgetsh = 0 ;
      headerh = 0 ;
      footerh = 0 ;
      buttonDrawMenu = null ;
      panelMenu = null ;
      buttonDrawSettings = null ;
      panelSettings = null ;
      textLabelApplicationName = null ;
      visible1 = true ;
    }
  }
}