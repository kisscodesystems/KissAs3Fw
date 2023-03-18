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
 ** BaseAlerter.
 ** This kind of object can create alert and confirm messages.
 **
 ** MAIN FEATURES:
 ** Can display messages:
 ** - alert
 ** - confirm
 */
package com . kisscodesystems . KissAs3Fw . base
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . events . Event ;
  public class BaseAlerter extends BaseSprite
  {
// To create the alert and the confirm dialogs, these will be the actions can be overridden.
    protected var alertOK : Function = null ;
    protected var confirmOK : Function = null ;
    protected var confirmCancel : Function = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function BaseAlerter ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
    }
/*
** To create confirm and alert easier.
*/
    protected function showConfirm ( messageString : String ) : void
    {
      var uniqueString : String = "" + new Date ( ) . time ;
      var okFunction : Function = null ;
      var cancelFunction : Function = null ;
      okFunction = function ( e : Event ) : void
      {
        application . getForeground ( ) . closeAlert ( uniqueString ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , okFunction ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , cancelFunction ) ;
        if ( confirmOK != null )
        {
          confirmOK ( ) ;
        }
        e . stopImmediatePropagation ( ) ;
      }
      cancelFunction = function ( e : Event ) : void
      {
        application . getForeground ( ) . closeAlert ( uniqueString ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , okFunction ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , cancelFunction ) ;
        if ( confirmCancel != null )
        {
          confirmCancel ( ) ;
        }
        e . stopImmediatePropagation ( ) ;
      }
      application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_OK , okFunction ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_CANCEL , cancelFunction ) ;
      application . getForeground ( ) . createAlert ( messageString , uniqueString , true , true ) ;
    }
    protected function showAlert ( messageString : String , fullscreen : Boolean = false ) : void
    {
      var uniqueString : String = "" + new Date ( ) . time ;
      var okFunction : Function = function ( e : Event ) : void
      {
        application . getForeground ( ) . closeAlert ( uniqueString ) ;
        application . getBaseEventDispatcher ( ) . removeEventListener ( e . type , okFunction ) ;
        if ( alertOK != null )
        {
          alertOK ( ) ;
        }
        e . stopImmediatePropagation ( ) ;
      }
      application . getBaseEventDispatcher ( ) . addEventListener ( uniqueString + application . getTexts ( ) . OC_OK , okFunction ) ;
      application . getForeground ( ) . createAlert ( messageString , uniqueString , true , false , false , fullscreen ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      alertOK = null ;
      confirmOK = null ;
      confirmCancel = null ;
    }
  }
}
