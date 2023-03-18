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
 ** PanelMenu.
 ** The panel of the menu which can be visible or not.
 ** Visible if the user clicks on the menu button.
 ** Contains a langSetter object if the settings panel is disabled.
 **
 ** MAIN FEATURES:
 ** - displays the menu (from xml)
 ** - sets the application language if the settings panel is disabled.
 ** - contains: profil photo
 **             name
 **             nickname
 **             role
 **             login time
 **             register button
 **             logout button
 **             the menu tree
 **             app language (if disabled in the settings menu)
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . LangSetter ;
  import com . kisscodesystems . KissAs3Fw . base . BasePanel ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . Image ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import com . kisscodesystems . KissAs3Fw . ui . XmlLister ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class PanelMenu extends BasePanel
  {
// Guest mode: the photo is not visible but the register button is visible.
    private var guestMode : Boolean = false ;
// Icon if specified
    private var profileIcon : String = "" ;
// Profile image
    private var profilePicPid : String = "" ;
    private var profilePicSid : String = "" ;
    private var profilePicUrl : String = "" ;
    private var profileImage : Image = null ;
// The full name and the nickname of the person.
    private var dataTextLabel : TextLabel = null ;
// The buttons of the menu.
    private var registerButtonText : ButtonText = null ;
    private var logoutButtonText : ButtonText = null ;
// These are enabled or disabled.
    private var registerButtonEnabled : Boolean = true ;
    private var logoutButtonEnabled : Boolean = true ;
// The lang setter object.
    private var langSetter : LangSetter = null ;
// The xml displayer object to display the menu.
    private var xmlLister : XmlLister = null ;
// The data to store and to display.
    private var fullname : String = "" ;
    private var nickname : String = "" ;
    private var role : String = "" ;
// Events to be dropped in case of register or logout.
    private var eventRegisterForm : Event = null ;
    private var eventLogout : Event = null ;
// Event of click on the profile photo
    private var profileClickEvent : Event = null ;
// To close it (Mobile mode: it fills almost all of the app area)
    private var buttonLinkClos : ButtonLink = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function PanelMenu ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Setting of the default content now.
      setDefaultContent ( ) ;
      contentMultiple . setElementsFix ( 0 , 2 ) ;
// To have these initial values.
      fullname = "" ;
      nickname = "" ;
      role = "" ;
// The events.
      eventRegisterForm = new Event ( application . EVENT_TO_CREATE_REG_FORM ) ;
      eventLogout = new Event ( application . EVENT_TO_LOGOUT ) ;
      profileClickEvent = new Event ( application . EVENT_PROFILE_IMAGE_CLICKED ) ;
// Creating the elements.
      createElements ( ) ;
// This is needed: the size of the xml lister depends on these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
    }
/*
** Drops all elements of the panel.
*/
    private function dropElements ( ) : void
    {
      dropProfileImage ( ) ;
      if ( dataTextLabel != null )
      {
        dataTextLabel . removeEventListener ( MouseEvent . CLICK , sendProfileImageClickEvent ) ;
        contentMultiple . removeFromContent ( 0 , dataTextLabel ) ;
        dataTextLabel = null ;
      }
      if ( registerButtonText != null )
      {
        contentMultiple . removeFromContent ( 0 , registerButtonText ) ;
        registerButtonText = null ;
      }
      if ( logoutButtonText != null )
      {
        contentMultiple . removeFromContent ( 0 , logoutButtonText ) ;
        logoutButtonText = null ;
      }
      if ( langSetter != null )
      {
        contentMultiple . removeFromContent ( 0 , langSetter ) ;
        langSetter = null ;
      }
      if ( xmlLister != null )
      {
        contentMultiple . removeFromContent ( 0 , xmlLister ) ;
        xmlLister = null ;
      }
      if ( buttonLinkClos != null )
      {
        contentMultiple . removeFromContent ( 0 , buttonLinkClos ) ;
        buttonLinkClos = null ;
      }
    }
/*
** The creation of the elements.
*/
    private function createElements ( ) : void
    {
// Drop all of the elements.
      dropElements ( ) ;
// In mobile mode, this can be very handy.
      buttonLinkClos = new ButtonLink ( application ) ;
      contentMultiple . addToContent ( 0 , buttonLinkClos , 0 ) ;
      buttonLinkClos . setIcon ( "close" ) ;
      buttonLinkClos . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , buttonLinkClosClick ) ;
// Name and nickname, and other data.
      dataTextLabel = new TextLabel ( application ) ;
      contentMultiple . addToContent ( 0 , dataTextLabel , 1 ) ;
      dataTextLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
      dataTextLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
// The name and nickname text label should act as the profile image.
      dataTextLabel . addEventListener ( MouseEvent . CLICK , sendProfileImageClickEvent ) ;
// Updates the content of this textfield
      updateWholeText ( ) ;
// In guest mode, the profile image won't be used.
      profileImageRefresh ( ) ;
// The register button is needed for registration. (in guest mode of course)
      if ( guestMode )
      {
        registerButtonText = new ButtonText ( application ) ;
        contentMultiple . addToContent ( 0 , registerButtonText , 4 ) ;
        registerButtonText . setTextCode ( application . getTexts ( ) . REGISTER_BUTTON ) ;
        registerButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doRegisterSubmit ) ;
        registerButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
        registerButtonText . setIcon ( "register" ) ;
        if ( ! registerButtonEnabled )
        {
          registerButtonText . setEnabled ( false ) ;
        }
      }
// Logout button is essential.
      logoutButtonText = new ButtonText ( application ) ;
      contentMultiple . addToContent ( 0 , logoutButtonText , 4 ) ;
      logoutButtonText . setTextCode ( application . getTexts ( ) . LOGOUT_BUTTON ) ;
      logoutButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doLogoutSubmit ) ;
      logoutButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
      logoutButtonText . setIcon ( "logout" ) ;
      if ( ! logoutButtonEnabled )
      {
        logoutButtonText . setEnabled ( false ) ;
      }
// The lang setter if necessary.
      if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        langSetter = new LangSetter ( application ) ;
        contentMultiple . addToContent ( 0 , langSetter , 5 ) ;
        langSetter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
      }
// Displaying the menu.
      xmlLister = new XmlLister ( application ) ;
      contentMultiple . addToContent ( 0 , xmlLister , 6 , false ) ;
      xmlLister . setAlwaysDispatchSelectedEvent ( true ) ;
      xmlLister . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , xmlListerChanged ) ;
      xmlLister . setsw ( contentMultiple . getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) ) ;
      xmlLister . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
// Initially..
      resizeAll ( ) ;
    }
/*
** Recalculates the number of visible elements and width of the menu.
*/
    private function recalcMenu ( ) : void
    {
      if ( application != null && application . getMiddleground ( ) != null )
      {
        if ( xmlLister != null )
        {
          var numOfElements : int = Math . max ( 2 , Math . floor ( ( application . getMiddleground ( ) . getPanelMenuHeight ( ) - xmlLister . getcy ( ) - 2 * application . getPropsApp ( ) . getScrollMargin ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) / application . getPropsDyn ( ) . getTextFieldHeight ( xmlLister . getTextType ( ) ) ) ) ;
          xmlLister . setNumOfElements ( numOfElements ) ;
          xmlLister . setsw ( application . getMiddleground ( ) . getPanelWidth ( ) - 4 * application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        }
      }
    }
/*
** Resizes the lang setter if exists.
*/
    private function resizeLangSetter ( ) : void
    {
      if ( application != null && application . getMiddleground ( ) != null )
      {
        if ( langSetter != null )
        {
          langSetter . setsw ( application . getMiddleground ( ) . getPanelWidth ( ) - langSetter . getcx ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        }
      }
    }
/*
** Resizing and repositioning all of the elements.
*/
    private function resizeAll ( ) : void
    {
      resizeLangSetter ( ) ;
      recalcMenu ( ) ;
    }
/*
** Set data to display.
*/
    public function setLoginDataToDisplay ( g : Boolean , i : String , p : String , s : String , u : String , f : String , n : String , r : String ) : void
    {
      guestMode = g ;
      profileIcon = i ;
      profilePicPid = p ;
      profilePicSid = s ;
      profilePicUrl = u ;
      fullname = f ;
      nickname = n ;
      role = setRoleCode ( r ) ;
      createElements ( ) ;
    }
/*
** Updates the role only.
*/
    public function updateRole ( r : String ) : void
    {
      role = setRoleCode ( r ) ;
      updateWholeText ( ) ;
    }
/*
** To create the text code from the outside data.
*/
    private function setRoleCode ( r : String ) : String
    {
      return application . getTexts ( ) . BTC + r + application . getTexts ( ) . ETC ;
    }
/*
** Updates the whole text.
*/
    private function updateWholeText ( ) : void
    {
      if ( dataTextLabel != null )
      {
        if ( fullname != "" )
        {
          dataTextLabel . setTextCode ( " " + fullname + "\n \"" + nickname + "\"" + "\n\n " + role ) ;
          dataTextLabel . setIcon ( profileIcon ) ;
        }
        else
        {
          dataTextLabel . setTextCode ( " " ) ;
          dataTextLabel . setIcon ( "dummy" ) ;
        }
      }
    }
/*
** Sets only the profile image to display.
*/
    public function setProfilePicUrlToDisplay ( p : String ) : void
    {
      profilePicUrl = p ;
      profileImageRefresh ( ) ;
    }
/*
** The buttons has to be set sometimes.
*/
    public function setEnabledLogoutButton ( b : Boolean ) : void
    {
      logoutButtonEnabled = b ;
      if ( logoutButtonText != null )
      {
        logoutButtonText . setEnabled ( b ) ;
      }
    }
    public function setEnabledRegisterButton ( b : Boolean ) : void
    {
      registerButtonEnabled = b ;
      if ( registerButtonText != null )
      {
        registerButtonText . setEnabled ( b ) ;
      }
    }
/*
** Drops the profile image only.
*/
    private function dropProfileImage ( ) : void
    {
      if ( profileImage != null )
      {
        profileImage . removeEventListener ( MouseEvent . CLICK , sendProfileImageClickEvent ) ;
        contentMultiple . removeFromContent ( 0 , profileImage ) ;
        profileImage = null ;
      }
    }
/*
** The profile image will be reloaded (re-created).
*/
    public function profileImageRefresh ( ) : void
    {
      dropProfileImage ( ) ;
      if ( ! guestMode && profilePicSid != "" && profilePicUrl != "" )
      {
        profileImage = new Image ( application ) ;
        contentMultiple . addToContent ( 0 , profileImage , 2 ) ;
        profileImage . setswh ( getsw ( ) / 2 , getsw ( ) / 2 ) ;
        profileImage . setsw ( 5 * ( application . getPropsDyn ( ) . getAppFontSize ( ) == 0 ? application . calcFontSizeFromStageSize ( ) : application . getPropsDyn ( ) . getAppFontSize ( ) ) ) ;
        profileImage . setParamsAndLoadImage ( profilePicPid , profilePicSid , profilePicUrl ) ;
        profileImage . addEventListener ( MouseEvent . CLICK , sendProfileImageClickEvent ) ;
      }
    }
/*
** Closes the panel menu
*/
    private function buttonLinkClosClick ( e : Event = null ) : void
    {
      application . getMiddleground ( ) . closePanelMenu ( ) ;
    }
/*
** Drop events about the registration or the logout.
*/
    private function doRegisterSubmit ( e : Event ) : void
    {
      if ( application . getBaseEventDispatcher ( ) != null && guestMode )
      {
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventRegisterForm ) ;
      }
    }
    private function doLogoutSubmit ( e : Event ) : void
    {
      if ( application . getBaseEventDispatcher ( ) != null )
      {
        application . getBaseEventDispatcher ( ) . dispatchEvent ( eventLogout ) ;
      }
    }
/*
** One of the elements has been resized.
*/
    private function elementsResize ( e : Event ) : void
    {
// Resize/repos all.
      resizeAll ( ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
// So we have to resize.
      resizeAll ( ) ;
    }
/*
** The padding of the application has been changed.
*/
    private function paddingChanged ( e : Event ) : void
    {
// So we have to resize.
      resizeAll ( ) ;
    }
/*
** The xml lister has been changed.
*/
    private function xmlListerChanged ( e : Event ) : void
    {
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( e ) ;
      }
    }
/*
** Gets the active menu item.
*/
    public function getSelectedItem ( ) : String
    {
      return xmlLister . getSelectedItem ( ) ;
    }
/*
** Update the menu.
*/
    public function updateMenuxml ( ) : void
    {
      if ( xmlLister != null )
      {
        xmlLister . setXmlAsString ( application . getMenuxml ( ) ) ;
      }
    }
/*
** Overwritting the setting of the width.
*/
    override protected function doSizeChanged ( ) : void
    {
// Resize/repos all.
      resizeAll ( ) ;
    }
/*
** When a click event occurs on the profile image.
*/
    private function sendProfileImageClickEvent ( e : MouseEvent ) : void
    {
      if ( application != null && application . getBaseEventDispatcher ( ) != null && profileClickEvent != null )
      {
        application . getBaseEventDispatcher ( ) . dispatchEvent ( profileClickEvent ) ;
      }
    }
/*
** This would be in a public function because more languages are available to add later.
*/
    public function updateLangCodes ( ) : void
    {
      if ( langSetter != null )
      {
        langSetter . updateLangCodes ( ) ;
      }
    }
/*
** Override setEnabled: the xmllister and the langsetter have to be disabled or enabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( profileImage != null )
      {
        profileImage . setEnabled ( getEnabled ( ) ) ;
      }
      if ( registerButtonText != null )
      {
        registerButtonText . setEnabled ( getEnabled ( ) ) ;
      }
      if ( logoutButtonText != null )
      {
        logoutButtonText . setEnabled ( getEnabled ( ) ) ;
      }
      if ( langSetter != null )
      {
        langSetter . setEnabled ( getEnabled ( ) ) ;
      }
      if ( xmlLister != null )
      {
        xmlLister . setEnabled ( getEnabled ( ) ) ;
      }
      if ( buttonLinkClos != null )
      {
        buttonLinkClos . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , paddingChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      langSetter = null ;
      xmlLister = null ;
      buttonLinkClos = null ;
    }
  }
}
