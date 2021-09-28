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
 ** Marker.
 ** 2 state is available, marked and unmarked states.
 **
 ** MAIN FUNCTIONS:
 ** - "marked" and "unmarked" outputs.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . Switcher ;
  public class Marker extends Switcher
  {
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Marker ( applicationRef : Application ) : void
    {
      super ( applicationRef ) ;
      STATE_ON = "marked" ;
      STATE_OFF = "unmarked" ;
      ICON_ON = "starfull" ;
      ICON_OFF = "starblank" ;
    }
  }
}