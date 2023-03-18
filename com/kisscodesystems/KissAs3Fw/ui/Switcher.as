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
 ** Switcher.
 ** 2 state is available, on and off states.
 **
 ** MAIN FUNCTIONS:
 ** - "on" and "off" outputs.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonLink ;
  import flash . events . Event ;
  public class Switcher extends ButtonLink
  {
// The states and the used icons.
    public var STATE_ON : String = "on" ;
    public var STATE_OFF : String = "off" ;
    private var ICON_ON : String = "switchon" ;
    private var ICON_OFF : String = "switchoff" ;
// The current states have to be initialized.
    private var objectState : String = STATE_OFF ;
    private var textCodeAsc : String = "" ;
    private var textCodeDesc : String = "" ;
// The event object to be dispatched.
    private var eventChanged : Event = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Switcher ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// This event will trigger the change of the selection to the outside world.
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// The icons and state is the initial.
      setIcon ( ICON_OFF ) ;
      setTextCodes ( " " , " " ) ;
      objectState = STATE_OFF ;
      setTextCodes ( "" , "" ) ;
      actualizeTextCode ( ) ;
    }
/*
** The icons of the states can be set from outside.
*/ 
    public function setIcons ( iconOn : String , iconOff : String ) : void
    {
      ICON_ON = "" + iconOn ;
      ICON_OFF = "" + iconOff ;
      setIcon ( STATE_ON == objectState ? ICON_ON : ICON_OFF ) ;
    }
/*
** The states can be set from outside.
*/ 
    public function setStates ( stateOn : String , stateOff : String ) : void
    {
      objectState = "" + ( objectState == STATE_ON ? stateOn : stateOff ) ;
      STATE_ON = "" + stateOn ;
      STATE_OFF = "" + stateOff ;
    }
/*
** Sets the state from outside.
*/
    public function setObjectState ( newState : String ) : void
    {
      if ( newState == STATE_OFF )
      {
        if ( objectState != "" + STATE_OFF )
        {
          setIcon ( ICON_OFF ) ;
          objectState = "" + STATE_OFF ;
          actualizeTextCode ( ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
        }
      }
      else
      {
        if ( objectState != "" + STATE_ON )
        {
          setIcon ( ICON_ON ) ;
          objectState = "" + STATE_ON ;
          actualizeTextCode ( ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
        }
      }
    }
/*
** This is the current state.
*/
    public function getObjectState ( ) : String
    {
      return objectState ;
    }
/*
** The text codes to display.
** To the asc and desc states, separatedly
*/
    public function setTextCodes ( tcAsc : String , tcDesc : String ) : void
    {
      textCodeAsc = tcAsc ;
      textCodeDesc = tcDesc ;
      actualizeTextCode ( ) ;
    }
/*
** To actualize the text code by the current objectState.
*/
    private function actualizeTextCode ( ) : void
    {
      if ( objectState == STATE_ON )
      {
        setTextCode ( textCodeAsc ) ;
      }
      else
      {
        setTextCode ( textCodeDesc ) ;
      }
    }
/*
** This will be called when the button is clicked.
*/
    override protected function baseWorkingButtonClick ( ) : void
    {
      if ( objectState == STATE_ON )
      {
        setIcon ( ICON_OFF ) ;
        objectState = "" + STATE_OFF ;
      }
      else
      {
        setIcon ( ICON_ON ) ;
        objectState = "" + STATE_ON ;
      }
      actualizeTextCode ( ) ;
      getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
      super . baseWorkingButtonClick ( ) ;
    }
/*
** Up or not?
*/
    public function getUp ( ) : Boolean
    {
      return objectState == STATE_ON ;
    }
/*
** Set up (or down).
*/
    public function setUp ( u : Boolean ) : void
    {
      setObjectState ( u ? STATE_ON : STATE_OFF ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      STATE_ON = null ;
      STATE_OFF = null ;
      ICON_ON = null ;
      ICON_OFF = null ;
// The current states have to be initialized.
      objectState = STATE_ON ;
      textCodeAsc = null ;
      textCodeDesc = null ;
      eventChanged = null ;
    }
  }
}
