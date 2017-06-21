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
** ButtonText.
** The standard button object with label.
**
** MAIN FEATURES:
** - button with text label, works as the base working button.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseWorkingButton ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  public class ButtonText extends BaseWorkingButton
  {
// This will be the label of the button.
    private var textLabel : TextLabel = null ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ButtonText ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The label of the button.
      textLabel = new TextLabel ( application ) ;
      contentSprite . addChild ( textLabel ) ;
      textLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_MID ) ;
      labelRepos ( ) ;
      textLabel . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , resize ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
    }
/*
** click + disabled!
*/
    override protected function baseWorkingButtonClick ( ) : void
    {
      setEnabled ( false ) ;
      super . baseWorkingButtonClick ( ) ;
    }
/*
** On changing of the padding.
*/
    private function resize ( e : Event ) : void
    {
      if ( application != null )
      {
        super . setswh ( textLabel . getsw ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) , textLabel . getsh ( ) + 2 * application . getPropsDyn ( ) . getAppPadding ( ) ) ;
        labelRepos ( ) ;
      }
    }
/*
** The set size methods have to have no effects.
*/
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Sets the label of the button.
*/
    public function setTextCode ( newTextCode : String ) : void
    {
      textLabel . setTextCode ( newTextCode ) ;
    }
/*
** Repositioning the label if necessary.
*/
    private function labelRepos ( ) : void
    {
      textLabel . setcxy ( application . getPropsDyn ( ) . getAppPadding ( ) , application . getPropsDyn ( ) . getAppPadding ( ) ) ;
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_PADDING_CHANGED , resize ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      textLabel = null ;
    }
  }
}