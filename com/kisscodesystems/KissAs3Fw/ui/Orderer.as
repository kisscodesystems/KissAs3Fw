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
 ** Orderer.
 ** 2 state is available, a and d states.
 **
 ** MAIN FUNCTIONS:
 ** - asc and desc, "a" and "d" outputs.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . Switcher ;
  public class Orderer extends Switcher
  {
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Orderer ( applicationRef : Application ) : void
    {
      super ( applicationRef ) ;
      STATE_ON = "asc" ;
      STATE_OFF = "desc" ;
      ICON_ON = "uparrow1" ;
      ICON_OFF = "downarrow1" ;
    }
  }
}