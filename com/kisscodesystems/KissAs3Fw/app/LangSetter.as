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
** LangSetter.
** Sets the language of the application.
** Basically it is a listpicker object with the available languages.
**
** MAIN FEATURES:
** - contains a listpicker object with the languages of the capplication.
** - changing its value causes the language changing of the app and the
**   texts specified by a text code will be automatically changed into the
**   new text value according to the changed language code.
** - on the settings panel, or if it does not exist, on the menu panel.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPicker ;
  import flash . events . Event ;
  public class LangSetter extends BaseSprite
  {
// The list picker to use to display the languages.
    private var listPicker : ListPicker = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function LangSetter ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// The listPicker.
      listPicker = new ListPicker ( application ) ;
      addChild ( listPicker ) ;
      listPicker . setNumOfElements ( application . getPropsApp ( ) . getLangSetterMaxElements ( ) ) ;
// The event listeners registered to the changing of this object.
      listPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , listPickerChanged ) ;
      listPicker . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , listPickerSizesChanged ) ;
// If the lang code is changed then this object has to be updated.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LANG_CODE_CHANGED , langCodeChanged ) ;
    }
/*
** The list is resized.
*/
    private function listPickerSizesChanged ( e : Event ) : void
    {
      super . setswh ( listPicker . getsw ( ) , listPicker . getsh ( ) ) ;
    }
/*
** Overriding the setsw setsh and setswh functions.
** setsh and setswh: should be out of order!
** The sh depends on the number of elements to be displayed.
*/
    override public function setsw ( newsw : int ) : void
    {
      if ( getsw ( ) != newsw )
      {
        super . setsw ( newsw ) ;
        listPicker . setsw ( getsw ( ) ) ;
      }
    }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newsw : int , newsh : int ) : void { }
/*
** Sets the selected index.
*/
    public function setSelectedIndex ( i : int ) : void
    {
      if ( listPicker != null )
      {
        listPicker . setSelectedIndex ( i ) ;
      }
    }
/*
** Override this.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( listPicker != null )
      {
        listPicker . setEnabled ( getEnabled ( ) ) ;
      }
    }
/*
** The changing event of the listpicker.
*/
    private function listPickerChanged ( e : Event ) : void
    {
      application . getTextStock ( ) . setLangCode ( application . getTextStock ( ) . getLangCodes ( ) [ listPicker . getSelectedIndex ( ) ] ) ;
      application . getMiddleground ( ) . closePanelSettings ( ) ;
    }
/*
** Updates the language codes available in this application.
*/
    public function updateLangCodes ( ) : void
    {
      listPicker . setArrays ( application . getTextStock ( ) . getLangCodes ( ) , application . getTextStock ( ) . getLangCodes ( ) ) ;
      langCodeChanged ( null ) ;
    }
/*
** To be updated if another object changes the lang code of the application.
*/
    public function langCodeChanged ( e : Event ) : void
    {
      listPicker . setSelectedIndex ( application . getTextStock ( ) . getLangCodes ( ) . indexOf ( application . getTextStock ( ) . getLangCode ( ) ) ) ;
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LANG_CODE_CHANGED , langCodeChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      listPicker = null ;
    }
  }
}