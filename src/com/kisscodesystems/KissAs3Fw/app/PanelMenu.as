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
** PanelMenu.
** The panel of the menu which can be visible or not.
** Visible if the user clicks on the menu button.
** Contains a langSetter object if the settings panel is disabled.
**
** MAIN FEATURES:
** - displays the menu (from xml)
** - sets the application language if the settings panel is disabled.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . app . LangSetter ;
  import com . kisscodesystems . KissAs3Fw . base . BasePanel ;
  import com . kisscodesystems . KissAs3Fw . ui . XmlLister ;
  import flash . events . Event ;
  public class PanelMenu extends BasePanel
  {
// The lang setter object.
    private var langSetter : LangSetter = null ;
// The xml displayer object to display the menu.
    private var xmlLister : XmlLister = null ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function PanelMenu ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// Setting of the default content now.
      setDefaultContent ( ) ;
// The elements!
      if ( ! application . getPropsApp ( ) . getPanelSettingsEnabled ( ) )
      {
        langSetter = new LangSetter ( application ) ;
        contentMultiple . addToContent ( 0 , langSetter , true , 0 ) ;
        langSetter . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
      }
      xmlLister = new XmlLister ( application ) ;
      contentMultiple . addToContent ( 0 , xmlLister , true , 1 ) ;
      xmlLister . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , xmlListerChanged ) ;
      xmlLister . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , elementsResize ) ;
// This is needed: the size of the xml lister depends on these.
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
// Initially..
      resizeReposAll ( ) ;
    }
/*
** The line thickness of the application has been changed.
*/
    private function lineThicknessChanged ( e : Event ) : void
    {
// So we have to resize.
      resizeReposAll ( ) ;
    }
/*
** The margin of the application has been changed.
*/
    private function marginChanged ( e : Event ) : void
    {
// So we have to resize.
      resizeReposAll ( ) ;
    }
/*
** Overwritting the setting of the width.
*/
    override protected function doSizeChanged ( ) : void
    {
// Resize/repos all.
      resizeReposAll ( ) ;
    }
/*
** Override setEnabled: the xmllister and the langsetter have to be disabled or enabled.
*/
    override public function setEnabled ( e : Boolean ) : void
    {
      super . setEnabled ( e ) ;
      if ( xmlLister != null )
      {
        xmlLister . setEnabled ( getEnabled ( ) ) ;
      }
      if ( langSetter != null )
      {
        langSetter . setEnabled ( getEnabled ( ) ) ;
      }
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
** One of the elements has been resized.
*/
    private function elementsResize ( e : Event ) : void
    {
// Resize/repos all.
      resizeReposAll ( ) ;
    }
/*
** Resizibng and repositioning all of the elements.
*/
    private function resizeReposAll ( ) : void
    {
      if ( application != null )
      {
// The lang setter listpicker has to be repositioned and resized.
        if ( langSetter != null )
        {
          langSetter . setsw ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
        }
// The menu displaywer too.
        if ( xmlLister != null )
        {
          if ( langSetter != null )
          {
            xmlLister . setsw ( langSetter . getsw ( ) ) ;
          }
          else
          {
            xmlLister . setsw ( getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) - 2 * application . getPropsDyn ( ) . getAppLineThickness ( ) ) ;
          }
          xmlLister . setNumOfElements ( - 3 + Math . floor ( ( getsh ( ) - xmlLister . getcy ( ) - application . getPropsApp ( ) . getScrollMargin ( ) ) / application . getPropsDyn ( ) . getTextFieldHeight ( xmlLister . getTextType ( ) ) ) ) ;
        }
// Super!
        super . doSizeChanged ( ) ;
      }
    }
/*
** Update the menu.
*/
    public function updateMenuxml ( ) : void
    {
      xmlLister . setXmlAsString ( application . getMenuxml ( ) ) ;
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
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_LINE_THICKNESS_CHANGED , lineThicknessChanged ) ;
      application . getBaseEventDispatcher ( ) . removeEventListener ( application . EVENT_MARGIN_CHANGED , marginChanged ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      langSetter = null ;
      xmlLister = null ;
    }
  }
}