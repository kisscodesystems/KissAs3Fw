/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** Foreground.
** This is the object displays the alerts and informations.
**
** MAIN FEATURES:
** - Displays alerts (with OK or OK-CANCEL buttons)
** - Displays the list of the widgets.
** - newer alerts will go the bottom of the contents! (as expectable like in ContentMultiple)
** - invisible by default.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonFile ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPanel ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import com . kisscodesystems . KissAs3Fw . ui . TextBox ;
  import com . kisscodesystems . KissAs3Fw . ui . TextInput ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import com . kisscodesystems . KissAs3Fw . ui . Widget ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  public class Foreground extends BaseSprite
  {
// The background of the elements.
    private var contentMultiple : ContentMultiple = null ;
// The list of the widgets.
    private var widgetsLabel : TextLabel = null ;
    private var widgetsList : ListPanel = null ;
// The list of the widgets! (on any widget container.)
    private var widgetListIndex : int = - 1 ;
// The list of the widget container to move the widget into.
    private var widgetMoveIndex : int = - 1 ;
// The index of the password change form.
    private var passwordChangeIndex : int = - 1 ;
// The widget to be moved.
    private var widgetToBeMoved : Widget = null ;
    private var contentsLabel : TextLabel = null ;
    private var contentsListPicker : ListPicker = null ;
// The login form to be displayed.
    private var passFormHeading : TextLabel = null ;
    private var passCurrentPassTextLabel : TextLabel = null ;
    private var passCurrentPassTextInput : TextInput = null ;
    private var passNewPass1TextLabel : TextLabel = null ;
    private var passNewPass1TextInput : TextInput = null ;
    private var passNewPass2TextLabel : TextLabel = null ;
    private var passNewPass2TextInput : TextInput = null ;
    private var passSubmitButtonText : ButtonText = null ;
    private var passCancelOrLogoutButtonLink : ButtonLink = null ;
// These are events to be able to listen to during password changing.
    private var eventUserPasswordChangeDo : Event = null ;
    private var eventUserPasswordCreateDo : Event = null ;
    private var eventUserPasswordImhereDo : Event = null ;
    private var eventUserPasswordLogout : Event = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Foreground ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// The visible is false by default.
      visible = false ;
// The events to be thrown.
      eventUserPasswordChangeDo = new Event ( application . EVENT_USER_PASSWORD_CHANGE_DO ) ;
      eventUserPasswordCreateDo = new Event ( application . EVENT_USER_PASSWORD_CREATE_DO ) ;
      eventUserPasswordImhereDo = new Event ( application . EVENT_USER_PASSWORD_IMHERE_DO ) ;
      eventUserPasswordLogout = new Event ( application . EVENT_TO_LOGOUT ) ;
    }
/*
** Creating the multi content if it is not visible at this moment.
*/
    private function createContentMultiple ( fullscreen : Boolean = false ) : void
    {
      if ( contentMultiple == null )
      {
        setVisible ( true ) ;
        contentMultiple = new ContentMultiple ( application ) ;
        addChild ( contentMultiple ) ;
        contentMultiple . setButtonBarVisible ( false ) ;
      }
      if ( fullscreen )
      {
        contentMultiple . setswh ( getsw ( ) , getsh ( ) ) ;
      }
      else
      {
        contentMultiple . setswh ( getsw ( ) * ( application . getPropsDyn ( ) . weAreInDesktopMode ( ) ? 1 / 2 : 4 / 5 ) , getsh ( ) * 1 / 2 ) ;
      }
      reposContentMultiple ( ) ;
    }
/*
** Clicked elsewhere?
*/
    private function clickedElsewhere ( ) : Boolean
    {
      return ! ( mouseX > contentMultiple . getcx ( ) && mouseX < contentMultiple . getcxsw ( ) && mouseY > contentMultiple . getcy ( ) && mouseY < contentMultiple . getcysh ( ) )
    }
/*
** Sets the active index 0.
*/
    private function setActiveIndex0 ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setActiveIndex ( 0 ) ;
      }
    }
/*
** Sets the active index to a specified.
*/
    private function setActiveIndex ( index : int ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setActiveIndex ( index ) ;
      }
    }
/*
** Creates a new alert.
*/
    public function createAlert ( messageString : String , uniqueString : String , eventOK : Boolean , eventCANCEL : Boolean , prio : Boolean = false , fullscreen : Boolean = false ) : void
    {
      if ( messageString != null && eventOK )
      {
// Creating the content multiple if it does not exist.
        createContentMultiple ( fullscreen ) ;
        var index : int = contentMultiple . addContent ( uniqueString ) ;
        if ( index > - 1 )
        {
          contentMultiple . setElementsFix ( index , 0 ) ;
          var textBox : TextBox = new TextBox ( application ) ;
          contentMultiple . addToContent ( index , textBox , true , 0 ) ;
          textBox . setTextCode ( messageString ) ;
          textBox . setWordWrap ( true ) ;
          var buttonOK : ButtonText = new ButtonText ( application ) ;
          contentMultiple . addToContent ( index , buttonOK , true , 1 ) ;
          buttonOK . setTextCode ( application . getTexts ( ) . OC_OK ) ;
          buttonOK . setCustomEventString ( uniqueString + application . getTexts ( ) . OC_OK ) ;
          buttonOK . setIcon ( "ok" ) ;
          var buttonCANCEL : ButtonText = null ;
          if ( eventCANCEL )
          {
            buttonCANCEL = new ButtonText ( application ) ;
            contentMultiple . addToContent ( index , buttonCANCEL , true , 1 ) ;
            buttonCANCEL . setTextCode ( application . getTexts ( ) . OC_CANCEL ) ;
            buttonCANCEL . setCustomEventString ( uniqueString + application . getTexts ( ) . OC_CANCEL ) ;
            buttonCANCEL . setIcon ( "cancel" ) ;
          }
          textBox . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          textBox . setswh ( contentMultiple . getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , contentMultiple . getsh ( ) - 3 * application . getPropsDyn ( ) . getAppMargin ( ) - buttonOK . getsh ( ) ) ;
          if ( eventCANCEL )
          {
            buttonOK . setcxy ( ( contentMultiple . getsw ( ) - buttonOK . getsw ( ) - buttonCANCEL . getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) / 2 , textBox . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
            buttonCANCEL . setcxy ( buttonOK . getcxsw ( ) + application . getPropsDyn ( ) . getAppMargin ( ) , buttonOK . getcy ( ) ) ;
            application . getSoundManager ( ) . playSound ( "confirm" ) ;
          }
          else
          {
            buttonOK . setcxy ( ( contentMultiple . getsw ( ) - buttonOK . getsw ( ) ) / 2 , textBox . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
            application . getSoundManager ( ) . playSound ( "message" ) ;
          }
          if ( prio )
          {
            setActiveIndex ( index ) ;
          }
          else
          {
            setActiveIndex0 ( ) ;
          }
        }
      }
    }
/*
** Closes an alert found by the message string given before.
** Not removing the elements one-by-one because we don't have the references to them,
** so just let the content does this for us.
*/
    public function closeAlert ( uniqueString : String ) : void
    {
      var index : int = contentMultiple . getContentIndexByLabel ( uniqueString ) ;
      if ( index != - 1 )
      {
        contentMultiple . removeContent ( index ) ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
/*
** Creates the list of the widgets.
*/
    public function createWidgetsList ( ) : void
    {
// Creating the content multiple is it does not exist.
      createContentMultiple ( ) ;
      if ( widgetListIndex == - 1 )
      {
        widgetListIndex = contentMultiple . addContent ( application . getTexts ( ) . LISTS_OF_THE_WIDGETS ) ;
        contentMultiple . setElementsFix ( widgetListIndex , 0 ) ;
        widgetsLabel = new TextLabel ( application ) ;
        contentMultiple . addToContent ( widgetListIndex , widgetsLabel , false , 0 ) ;
        widgetsLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
        widgetsLabel . setTextCode ( application . getTexts ( ) . LISTS_OF_THE_WIDGETS ) ;
        widgetsLabel . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList = new ListPanel ( application ) ;
        contentMultiple . addToContent ( widgetListIndex , widgetsList , true , 1 ) ;
        widgetsList . setsw ( contentMultiple . getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList . setcxy ( widgetsLabel . getcx ( ) , widgetsLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , goToTheWidget ) ;
        widgetsList . setMultiple ( false ) ;
        widgetsList . setArrays ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetHeaders ( ) , application . getMiddleground ( ) . getWidgets ( ) . getWidgetIds ( ) ) ;
        widgetsList . setNumOfElements ( Math . max ( 1 , Math . floor ( ( contentMultiple . getsh ( ) - ( widgetsLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 + application . getPropsDyn ( ) . getAppPadding ( ) * 2 + application . getPropsApp ( ) . getScrollMargin ( ) ) ) / application . getPropsDyn ( ) . getTextFieldHeight ( widgetsList . getTextType ( ) ) ) ) ) ;
        setActiveIndex0 ( ) ;
        if ( stage != null )
        {
          stage . addEventListener ( MouseEvent . MOUSE_DOWN , cancelWidgetsList ) ;
        }
      }
    }
/*
** Goes to the specific widget.
*/
    private function goToTheWidget ( e : Event ) : void
    {
      var targetWidget : Widget = application . getMiddleground ( ) . getWidgets ( ) . getWidgetByHeader ( widgetsList . getArrayLabels ( ) [ widgetsList . getSelectedIndexes ( ) [ 0 ] ] ) ;
      application . getMiddleground ( ) . getWidgets ( ) . goToTheWidget ( targetWidget ) ;
      if ( application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        application . getMiddleground ( ) . showWidgetContainer ( targetWidget . getContentId ( ) ) ;
      }
      closeWidgetsList ( ) ;
      e . stopImmediatePropagation ( ) ;
    }
/*
** Automatic removal of the window if the user clicks elsewhere.
*/
    private function cancelWidgetsList ( e : MouseEvent ) : void
    {
      if ( clickedElsewhere ( ) )
      {
        closeWidgetsList ( ) ;
      }
    }
/*
** Destroys the list of the widgets.
*/
    public function closeWidgetsList ( ) : void
    {
      if ( widgetListIndex != - 1 )
      {
        if ( stage != null )
        {
          stage . removeEventListener ( MouseEvent . MOUSE_DOWN , cancelWidgetsList ) ;
        }
        widgetsLabel . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetListIndex , widgetsLabel ) ;
        widgetsLabel = null ;
        widgetsList . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetListIndex , widgetsList ) ;
        widgetsList = null ;
        contentMultiple . removeContent ( widgetListIndex ) ;
        widgetListIndex = - 1 ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
/*
** Creates the listpicker of the contents.
*/
    public function createContentsList ( widget : Widget ) : void
    {
// Creating the content multiple is it does not exist.
      createContentMultiple ( ) ;
      if ( widgetMoveIndex == - 1 )
      {
        widgetToBeMoved = widget ;
        widgetMoveIndex = contentMultiple . addContent ( application . getTexts ( ) . LISTS_OF_THE_CONTENTS_TO_MOVE_INTO ) ;
        contentMultiple . setElementsFix ( widgetMoveIndex , 0 ) ;
        contentsLabel = new TextLabel ( application ) ;
        contentMultiple . addToContent ( widgetMoveIndex , contentsLabel , false , 0 ) ;
        contentsLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
        contentsLabel . setTextCode ( application . getTexts ( ) . LISTS_OF_THE_CONTENTS_TO_MOVE_INTO ) ;
        contentsLabel . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        contentsListPicker = new ListPicker ( application ) ;
        contentMultiple . addToContent ( widgetMoveIndex , contentsListPicker , true , 1 ) ;
        contentsListPicker . setsw ( contentsLabel . getsw ( ) ) ;
        var array : Array = new Array ( ) ;
        for ( var i : int = 0 ; i < application . getMiddleground ( ) . getWidgets ( ) . getNumOfContents ( ) ; i ++ )
        {
          array . push ( i + 1 ) ;
        }
        contentsListPicker . setArrays ( array , array ) ;
        contentsListPicker . setNumOfElements ( 5 ) ;
        contentsListPicker . setSelectedIndex ( widget . getContentId ( ) ) ;
        contentsListPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , moveToTheContent ) ;
        setActiveIndex0 ( ) ;
        if ( stage != null )
        {
          stage . addEventListener ( MouseEvent . MOUSE_DOWN , cancelMoveListPicker ) ;
        }
      }
    }
/*
** Moves the widget to the specific content.
*/
    private function moveToTheContent ( e : Event ) : void
    {
      application . getMiddleground ( ) . getWidgets ( ) . moveWidgetFromContent ( widgetToBeMoved . getContentId ( ) , contentsListPicker . getSelectedIndex ( ) , widgetToBeMoved , true ) ;
      closeContentsList ( ) ;
      e . stopImmediatePropagation ( ) ;
    }
/*
** Automatic removal of the window if the user clicks elsewhere.
*/
    private function cancelMoveListPicker ( e : MouseEvent ) : void
    {
      if ( clickedElsewhere ( ) )
      {
        closeContentsList ( ) ;
      }
    }
/*
** Destroys the listpicker of the contents.
*/
    public function closeContentsList ( ) : void
    {
      if ( widgetMoveIndex != - 1 )
      {
        if ( stage != null )
        {
          stage . removeEventListener ( MouseEvent . MOUSE_DOWN , cancelMoveListPicker ) ;
        }
        contentsLabel . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetMoveIndex , contentsLabel ) ;
        contentsLabel = null ;
        contentsListPicker . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetMoveIndex , contentsListPicker ) ;
        contentsListPicker = null ;
        contentMultiple . removeContent ( widgetMoveIndex ) ;
        widgetMoveIndex = - 1 ;
        widgetToBeMoved = null ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
/*
** Creates the password form.
** Mandatory: true  - Logout is the other option, **            false - Cancel is available to close the form
** currentPassword: true  - current password has to be given
**                  false - cannot be given
** newPassword: true  - the new password and its confirm have to be given
**              false - cannot be given
*/
    public function createPasswordForm ( mandatory : Boolean , currentPassword : Boolean , newPassword : Boolean ) : void
    {
// Destroy it if existing.
      closePasswordForm ( ) ;
// Creating the content multiple is it does not exist.
      createContentMultiple ( ) ;
      if ( passwordChangeIndex == - 1 )
      {
// All of the elements of the password changing form.
        passwordChangeIndex = contentMultiple . addContent ( application . getTexts ( ) . PASSWORD_HEADER ) ;
        contentMultiple . setElementsFix ( passwordChangeIndex , 1 ) ;
        passFormHeading = new TextLabel ( application ) ;
        contentMultiple . addToContent ( passwordChangeIndex , passFormHeading , false , 0 , false ) ;
        if ( mandatory )
        {
          if ( currentPassword )
          {
            if ( newPassword )
            {
              passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_CHANGE_SHOULD ) ;
            }
            else
            {
              passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_IMHERE_SHOULD ) ;
            }
          }
          else
          {
            passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_CREATE_SHOULD ) ;
          }
        }
        else
        {
          if ( currentPassword )
          {
            if ( newPassword )
            {
              passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_CHANGE_CAN ) ;
            }
            else
            {
              passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_IMHERE_CAN ) ;
            }
          }
          else
          {
            passFormHeading . setTextCode ( application . getTexts ( ) . PASS_FORM_HEADING_PW_CREATE_CAN ) ;
          }
        }
        var w : int = 0 ;
        if ( currentPassword )
        {
          passCurrentPassTextLabel = new TextLabel ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passCurrentPassTextLabel , false , 4 ) ;
          passCurrentPassTextLabel . setTextCode ( application . getTexts ( ) . PASS_FORM_OLD_PASS ) ;
          if ( passCurrentPassTextLabel . getsw ( ) > w )
          {
            w = passCurrentPassTextLabel . getsw ( ) ;
          }
        }
        if ( newPassword )
        {
          passNewPass1TextLabel = new TextLabel ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passNewPass1TextLabel , false , 6 ) ;
          passNewPass1TextLabel . setTextCode ( application . getTexts ( ) . PASS_FORM_NEW_PASS ) ;
          if ( passNewPass1TextLabel . getsw ( ) > w )
          {
            w = passNewPass1TextLabel . getsw ( ) ;
          }
          passNewPass2TextLabel = new TextLabel ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passNewPass2TextLabel , false , 8 ) ;
          passNewPass2TextLabel . setTextCode ( application . getTexts ( ) . PASS_FORM_CON_PASS ) ;
          if ( passNewPass2TextLabel . getsw ( ) > w )
          {
            w = passNewPass2TextLabel . getsw ( ) ;
          }
        }
        w = contentMultiple . getsw ( ) - w - 3 * application . getPropsDyn ( ) . getAppPadding ( ) ;
        if ( currentPassword )
        {
          passCurrentPassTextInput = new TextInput ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passCurrentPassTextInput , true , 5 ) ;
          passCurrentPassTextInput . setMinChars ( application . LENGTHS_PASS [ 0 ] ) ;
          passCurrentPassTextInput . setMaxChars ( application . LENGTHS_PASS [ 1 ] ) ;
          passCurrentPassTextInput . setRestrict ( application . CHARS_PASS ) ;
          passCurrentPassTextInput . setDisplayAsPassword ( true ) ;
          passCurrentPassTextInput . setsw ( w ) ;
        }
        if ( newPassword )
        {
          passNewPass1TextInput = new TextInput ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passNewPass1TextInput , true , 7 ) ;
          passNewPass1TextInput . setMinChars ( application . LENGTHS_PASS [ 0 ] ) ;
          passNewPass1TextInput . setMaxChars ( application . LENGTHS_PASS [ 1 ] ) ;
          passNewPass1TextInput . setRestrict ( application . CHARS_PASS ) ;
          passNewPass1TextInput . setDisplayAsPassword ( true ) ;
          passNewPass1TextInput . setsw ( w ) ;
          passNewPass2TextInput = new TextInput ( application ) ;
          contentMultiple . addToContent ( passwordChangeIndex , passNewPass2TextInput , true , 9 ) ;
          passNewPass2TextInput . setMinChars ( application . LENGTHS_PASS [ 0 ] ) ;
          passNewPass2TextInput . setMaxChars ( application . LENGTHS_PASS [ 1 ] ) ;
          passNewPass2TextInput . setRestrict ( application . CHARS_PASS ) ;
          passNewPass2TextInput . setDisplayAsPassword ( true ) ;
          passNewPass2TextInput . setsw ( w ) ;
        }
        passSubmitButtonText = new ButtonText ( application ) ;
        contentMultiple . addToContent ( passwordChangeIndex , passSubmitButtonText , true , 13 ) ;
        passSubmitButtonText . setTextCode ( application . getTexts ( ) . OC_OK ) ;
        passSubmitButtonText . setIcon ( "ok1" ) ;
        if ( currentPassword )
        {
          if ( newPassword )
          {
            passSubmitButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doPassChSubmit ) ;
          }
          else
          {
            passSubmitButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doPassIhSubmit ) ;
          }
        }
        else
        {
          passSubmitButtonText . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doPassCrSubmit ) ;
        }
        passCancelOrLogoutButtonLink = new ButtonLink ( application ) ;
        contentMultiple . addToContent ( passwordChangeIndex , passCancelOrLogoutButtonLink , true , 13 ) ;
// The button link object has to be prepared here: the label and the action.
        if ( mandatory )
        {
          passCancelOrLogoutButtonLink . setTextCode ( application . getTexts ( ) . LOGOUT_BUTTON ) ;
          passCancelOrLogoutButtonLink . setIcon ( "logout" ) ;
          passCancelOrLogoutButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , doLogoutSubmit ) ;
        }
        else
        {
          passCancelOrLogoutButtonLink . setTextCode ( application . getTexts ( ) . OC_CANCEL ) ;
          passCancelOrLogoutButtonLink . setIcon ( "cancel" ) ;
          passCancelOrLogoutButtonLink . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CLICK , destroyPasswordForm ) ;
        }
        setActiveIndex0 ( ) ;
        application . getSoundManager ( ) . playSound ( "screenlock" ) ;
      }
    }
    public function setEnabledCancelOrLogoutButtonLink ( b : Boolean ) : void
    {
      if ( passCancelOrLogoutButtonLink != null )
      {
        passCancelOrLogoutButtonLink . setEnabled ( b ) ;
      }
    }
    public function setEnabledSubmitButtonText ( b : Boolean ) : void
    {
      if ( passSubmitButtonText != null )
      {
        passSubmitButtonText . setEnabled ( b ) ;
      }
    }
/*
** Throw the events.
*/
    private function doLogoutSubmit ( e : Event ) : void
    {
      setEnabledCancelOrLogoutButtonLink ( false ) ;
      setEnabledSubmitButtonText ( false ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventUserPasswordLogout ) ;
    }
    private function doPassChSubmit ( e : Event ) : void
    {
      setEnabledCancelOrLogoutButtonLink ( false ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventUserPasswordChangeDo ) ;
    }
    private function doPassCrSubmit ( e : Event ) : void
    {
      setEnabledCancelOrLogoutButtonLink ( false ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventUserPasswordCreateDo ) ;
    }
    private function doPassIhSubmit ( e : Event ) : void
    {
      setEnabledCancelOrLogoutButtonLink ( false ) ;
      application . getBaseEventDispatcher ( ) . dispatchEvent ( eventUserPasswordImhereDo ) ;
    }
    private function destroyPasswordForm ( e : Event ) : void
    {
      if ( passwordChangeIndex != - 1 )
      {
        passFormHeading . destroy ( ) ;
        contentMultiple . removeFromContent ( passwordChangeIndex , passFormHeading ) ;
        passFormHeading = null ;
        if ( passCurrentPassTextLabel != null )
        {
          passCurrentPassTextLabel . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passCurrentPassTextLabel ) ;
          passCurrentPassTextLabel = null ;
        }
        if ( passCurrentPassTextInput != null )
        {
          passCurrentPassTextInput . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passCurrentPassTextInput ) ;
          passCurrentPassTextInput = null ;
        }
        if ( passNewPass1TextLabel != null )
        {
          passNewPass1TextLabel . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passNewPass1TextLabel ) ;
          passNewPass1TextLabel = null ;
        }
        if ( passNewPass1TextInput != null )
        {
          passNewPass1TextInput . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passNewPass1TextInput ) ;
          passNewPass1TextInput = null ;
        }
        if ( passNewPass2TextLabel != null )
        {
          passNewPass2TextLabel . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passNewPass2TextLabel ) ;
          passNewPass2TextLabel = null ;
        }
        if ( passNewPass2TextInput != null )
        {
          passNewPass2TextInput . destroy ( ) ;
          contentMultiple . removeFromContent ( passwordChangeIndex , passNewPass2TextInput ) ;
          passNewPass2TextInput = null ;
        }
        passSubmitButtonText . destroy ( ) ;
        contentMultiple . removeFromContent ( passwordChangeIndex , passSubmitButtonText ) ;
        passSubmitButtonText = null ;
        passCancelOrLogoutButtonLink . destroy ( ) ;
        contentMultiple . removeFromContent ( passwordChangeIndex , passCancelOrLogoutButtonLink ) ;
        passCancelOrLogoutButtonLink = null ;
        contentMultiple . removeContent ( passwordChangeIndex ) ;
        passwordChangeIndex = - 1 ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
    public function getPasswordCurrent ( ) : String
    {
      if ( passCurrentPassTextInput != null )
      {
        if ( passCurrentPassTextInput . getTextIsAtLeastLength ( ) )
        {
          return passCurrentPassTextInput . getText ( ) ;
        }
      }
      return "" ;
    }
    public function getPasswordNew ( ) : String
    {
      if ( passNewPass1TextInput != null && isVerifiedAndGoodPasswords ( ) )
      {
        return passNewPass1TextInput . getText ( ) ;
      }
      return "" ;
    }
    private function isVerifiedAndGoodPasswords ( ) : Boolean
    {
      if ( passNewPass1TextInput != null && passNewPass2TextInput != null )
      {
        if ( passNewPass1TextInput . getTextIsAtLeastLength ( ) && passNewPass2TextInput . getTextIsAtLeastLength ( ) )
        {
          if ( passNewPass1TextInput . getText ( ) == passNewPass2TextInput . getText ( ) )
          {
            return true ;
          }
        }
      }
      return false ;
    }
    public function closePasswordForm ( ) : void
    {
      destroyPasswordForm ( null ) ;
    }
    public function resetPasswordForm ( ) : void
    {
      setEnabledCancelOrLogoutButtonLink ( true ) ;
      setEnabledSubmitButtonText ( true ) ;
      if ( passNewPass1TextInput != null )
      {
        passNewPass1TextInput . setTextCode ( "" ) ;
      }
      if ( passNewPass2TextInput != null )
      {
        passNewPass2TextInput . setTextCode ( "" ) ;
      }
      if ( passCurrentPassTextInput != null )
      {
        passCurrentPassTextInput . setTextCode ( "" ) ;
        passCurrentPassTextInput . toFocus ( ) ;
      }
      else if ( passNewPass1TextInput != null )
      {
        passNewPass1TextInput . toFocus ( ) ;
      }
    }
    public function setActivePasswordForm ( ) : void
    {
      if ( passwordChangeIndex != - 1 && contentMultiple != null )
      {
        contentMultiple . setActiveIndex ( contentMultiple . getContentIndexByLabel ( application . getTexts ( ) . PASSWORD_HEADER ) ) ;
      }
    }
/*
** This is the method runs after the changing of the size of this object.
** If this has happened then the
*/
    override protected function doSizeChanged ( ) : void
    {
// Let's repaint it with an empty.
      foregroundRedraw ( ) ;
// The content has to be resized and repositioned.
      reposContentMultiple ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** Repos and resize the elements.
*/
    private function reposContentMultiple ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setcxy ( ( getsw ( ) - contentMultiple . getsw ( ) ) / 2 , ( getsh ( ) - contentMultiple . getsh ( ) ) / 2 ) ;
      }
    }
/*
** The multiple content object sould be removed ahd the visible should be false if no more contents.
*/
    private function setVisibleFalseIfNoMoreObjects ( ) : void
    {
      if ( contentMultiple != null )
      {
        if ( contentMultiple . getNumOfContents ( ) == 0 )
        {
          contentMultiple . destroy ( ) ;
          removeChild ( contentMultiple ) ;
          contentMultiple = null ;
          setVisible ( false ) ;
        }
      }
    }
/*
** Redrawing the foreground in the correct size.
*/
    protected function foregroundRedraw ( ) : void
    {
      graphics . clear ( ) ;
      graphics . lineStyle ( 0 , 0 , 0 ) ;
      graphics . beginFill ( 0 , 0 ) ;
      graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
      graphics . endFill ( ) ;
    }
/*
** Sets its visible.
** If this is visible then the background should not be accessible.
*/
    private function setVisible ( b : Boolean ) : void
    {
      visible = b ;
      application . getMiddleground ( ) . setVisible ( ! visible ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      if ( stage != null )
      {
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , cancelWidgetsList ) ;
        stage . removeEventListener ( MouseEvent . MOUSE_DOWN , cancelMoveListPicker ) ;
      }
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventUserPasswordChangeDo != null )
      {
        eventUserPasswordChangeDo . stopImmediatePropagation ( ) ;
      }
      if ( eventUserPasswordCreateDo != null )
      {
        eventUserPasswordCreateDo . stopImmediatePropagation ( ) ;
      }
      if ( eventUserPasswordImhereDo != null )
      {
        eventUserPasswordImhereDo . stopImmediatePropagation ( ) ;
      }
      if ( eventUserPasswordLogout != null )
      {
        eventUserPasswordLogout . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      contentMultiple = null ;
      widgetsLabel = null ;
      widgetsList = null ;
      widgetListIndex = 0 ;
      widgetMoveIndex = 0 ;
      passwordChangeIndex = 0 ;
      widgetToBeMoved = null ;
      contentsLabel = null ;
      contentsListPicker = null ;
      passFormHeading = null ;
      passCurrentPassTextLabel = null ;
      passCurrentPassTextInput = null ;
      passNewPass1TextLabel = null ;
      passNewPass1TextInput = null ;
      passNewPass2TextLabel = null ;
      passNewPass2TextInput = null ;
      passSubmitButtonText = null ;
      passCancelOrLogoutButtonLink = null ;
      eventUserPasswordChangeDo = null ;
      eventUserPasswordCreateDo = null ;
      eventUserPasswordImhereDo = null ;
    }
  }
}
