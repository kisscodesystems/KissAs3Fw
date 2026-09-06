/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 *
 * DESCRIPTION:
 * PanelMenu.
 * The panel of the menu. It becomes visible when the one using the application
 * clicks on the button of the menu.
 *
 * MAIN FEATURES:
 * - it displays the menu of the application, built of an xml
 * - it holds nothing else: everything the one using the application can set stands on
 *   the panel of the settings, and the language setter of it is always there
 * - only the menu itself is scrolled on it, and only vertically: everything else has
 *   the room it needs, so the panel itself is never scrolled
 * - the button of the logout is not built here: an application that logs the one using
 *   it in and out builds that button of its own and dispatches EVENT_TO_LOGOUT with it
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BasePanel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.XmlLister;
  import flash.events.Event;
  public class PanelMenu extends BasePanel
  {
    // the number of the menu items displayed at the very least
    private const MENU_MIN_ELEMENTS:int = 2;
    // the object displaying the menu itself
    private var xmlLister:XmlLister = null;
    // this panel almost fills the whole application in mobile mode, so it needs a
    // button of its own to be closed with
    private var buttonLinkClos:ButtonLink = null;
    /**
     * Constructs the panel of the menu with every element standing on it.
     * @param applicationRef the main application reference
     */
    public function PanelMenu(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " PanelMenu> called.", 1);
      application.trace("<" + this + " PanelMenu> applicationRef: " + applicationRef, 0);
      setDefaultContent();
      contentMultiple.setElementsFix(0, 2);
      // the menu of this panel is the only object that is scrolled on it, and the number
      // of the items it displays is calculated to the room it has got, so the panel itself
      // has nothing to be scrolled: both directions of its content are switched off, and
      // a press on any element of it is never turned into the scrolling of that content
      contentMultiple.getBaseScroll(0).setEnabledHorizontal(false);
      contentMultiple.getBaseScroll(0).setEnabledVertical(false);
      contentMultiple.getContentSingle(0).enableScrollingFromOthers = false;
      createElements();
      // the size of the object displaying the menu depends on these two
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), stuffsChanged);
      application.trace("<" + this + " PanelMenu> constructed.", 1);
    }
    /**
     * Returns the menu item that is the picked one right now.
     */
    public function getSelectedItem():String
    {
      application.trace("<" + this + " PanelMenu getSelectedItem> called.", 1);
      const selectedItem:String = xmlLister.getSelectedItem();
      application.trace("<" + this + " PanelMenu getSelectedItem> selectedItem: " + selectedItem, 0);
      return selectedItem;
    }
    /**
     * Reloads the menu of this application from the xml of it.
     */
    public function updateMenuxml():void
    {
      application.trace("<" + this + " PanelMenu updateMenuxml> called.", 1);
      if (xmlLister != null)
      {
        xmlLister.setXmlAsString(application.getMenuxml());
      }
    }
    /**
     * Enables or disables every element standing on this panel as well.
     * @param e whether this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " PanelMenu setEnabled> called.", 1);
      application.trace("<" + this + " PanelMenu setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (xmlLister != null)
      {
        xmlLister.setEnabled(getEnabled());
      }
      if (buttonLinkClos != null)
      {
        buttonLinkClos.setEnabled(getEnabled());
      }
    }
    /**
     * Resizes and repositions everything after the dimensions of this panel have
     * been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " PanelMenu doDimensionsChanged> called.", 1);
      recalcMenu();
      super.doDimensionsChanged();
    }
    /**
     * Builds every element of this panel: the closing button and the menu itself.
     */
    private function createElements():void
    {
      application.trace("<" + this + " PanelMenu createElements> called.", 1);
      // in mobile mode this panel covers almost everything, so a closing button helps
      buttonLinkClos = new ButtonLink(application);
      contentMultiple.addToContent(0, buttonLinkClos, 0);
      buttonLinkClos.setIcon(EnumIcons.close());
      buttonLinkClos.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), buttonLinkClosClick);
      xmlLister = new XmlLister(application);
      // the content of this panel holds three elements per row, so the menu goes into the
      // first column of the row that follows the one of the closing button: it is far
      // wider than one single column, so it takes that whole row on its own
      contentMultiple.addToContent(0, xmlLister, 3, false);
      xmlLister.setAlwaysDispatchSelectedEvent(true);
      xmlLister.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), xmlListerChanged);
      xmlLister.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), elementsResize);
      xmlLister.setDw(contentMultiple.getDw() - 2 * application.getDynamicsConfig().getAppMargin());
      recalcMenu();
    }
    /**
     * Recalculates the number of the displayed menu items and the width of the menu.
     */
    private function recalcMenu():void
    {
      application.trace("<" + this + " PanelMenu recalcMenu> called.", 1);
      if (application == null || application.getMiddleground() == null || xmlLister == null)
      {
        return;
      }
      const usedHeight:int = xmlLister.getCy()
        + 2 * application.getComponentsConfig().getScrollMargin()
        + 2 * application.getDynamicsConfig().getAppMargin()
        + 2 * application.getDynamicsConfig().getAppPadding();
      const numOfElements:int = Math.max(MENU_MIN_ELEMENTS
        , Math.floor((application.getMiddleground().getPanelMenuHeight() - usedHeight)
          / application.getDynamicsConfig().getTextFieldHeight(xmlLister.getTextType())));
      xmlLister.setNumOfElements(numOfElements);
      xmlLister.setDw(application.getMiddleground().getPanelWidth() - 4 * application.getDynamicsConfig().getAppMargin());
    }
    /**
     * One of the elements of this panel has been resized.
     * @param e the dimensions changed event of that element
     */
    private function elementsResize(e:Event):void
    {
      application.trace("<" + this + " PanelMenu elementsResize> called.", 1);
      application.trace("<" + this + " PanelMenu elementsResize> e: " + e, 0);
      recalcMenu();
    }
    /**
     * The margin or the padding of the application has been changed.
     * @param e the event of the property that has been changed
     */
    private function stuffsChanged(e:Event):void
    {
      application.trace("<" + this + " PanelMenu stuffsChanged> called.", 1);
      application.trace("<" + this + " PanelMenu stuffsChanged> e: " + e, 0);
      recalcMenu();
    }
    /**
     * The closing button of this panel has been clicked.
     * @param e the click event of that button
     */
    private function buttonLinkClosClick(e:Event):void
    {
      application.trace("<" + this + " PanelMenu buttonLinkClosClick> called.", 1);
      application.trace("<" + this + " PanelMenu buttonLinkClosClick> e: " + e, 0);
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().closePanelMenu();
      }
    }
    /**
     * A menu item has been picked, so everybody watching this panel gets to know it.
     * @param e the changed event of the object displaying the menu
     */
    private function xmlListerChanged(e:Event):void
    {
      application.trace("<" + this + " PanelMenu xmlListerChanged> called.", 1);
      application.trace("<" + this + " PanelMenu xmlListerChanged> e: " + e, 0);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(e);
      }
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " PanelMenu destroy> called.", 1);
      application.trace("<" + this + " PanelMenu destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), stuffsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), stuffsChanged);
      application.trace("<" + this + " PanelMenu destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " PanelMenu destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      xmlLister = null;
      buttonLinkClos = null;
    }
  }
}
