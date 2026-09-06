/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 * https://github.com/kisscodesystems/KissAs3Mp
 * DESCRIPTION:
 * WidgetManager.
 * Opens and handles the widgets in this application.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  public class WidgetManager
  {
    protected var application:Application = null;
    /**
     * Constructs the widget manager.
     * @param applicationRef the application reference
     */
    public function WidgetManager(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<WidgetManager> called.", 1);
      application.trace("<WidgetManager> applicationRef: " + applicationRef, 0);
      application.trace("<WidgetManager> constructed.", 1);
    }
    /**
     * Handles the selection of a widget menu item.
     * @param selectedItem the selected menu item
     */
    public function handleMenuSelect(selectedItem:String):void
    {
      application.trace("<WidgetManager handleMenuSelect> called.", 1);
      application.trace("<WidgetManager handleMenuSelect> selectedItem: " + selectedItem, 0);
      if (application.getMiddleground() != null)
      {
        application.getMiddleground().closePanelMenu();
      }
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<WidgetManager destroy> called.", 1);
      application = null;
    }
  }
}
