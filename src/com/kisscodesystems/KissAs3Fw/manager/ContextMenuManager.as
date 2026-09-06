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
 * ContextMenuManager.
 * Handles the context menu and stores the custom context menu elements.
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.events.ContextMenuEvent;
  import flash.net.navigateToURL;
  import flash.net.URLRequest;
  import flash.system.System;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
  public class ContextMenuManager
  {
    protected var application:Application = null;
    private var customContextMenu:ContextMenu = null;
    private var customContextLabels:Array = new Array();
    private var customContextUrls:Array = new Array();
    private var customContextHandlers:Array = new Array();
    /**
     * Constructs the context menu manager and installs the custom context menu.
     * @param applicationRef the application reference
     */
    public function ContextMenuManager(applicationRef:Application):void
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
      application.trace("<ContextMenuManager> called.", 1);
      application.trace("<ContextMenuManager> applicationRef: " + applicationRef, 0);
      customContextMenu = new ContextMenu();
      customContextMenu.hideBuiltInItems();
      application.contextMenu = customContextMenu;
      application.trace("<ContextMenuManager> constructed.", 1);
    }
    /**
     * Adds a new custom context menu item.
     * @param label the label of the menu item
     * @param url the url to navigate to when the item is clicked (used when handler is null)
     * @param handler the click handler of the item (if null, the item navigates to url)
     */
    public function addNewContextMenuItem(label:String, url:String, handler:Function):void
    {
      application.trace("<ContextMenuManager addNewContextMenuItem> called.", 1);
      application.trace("<ContextMenuManager addNewContextMenuItem> label: " + label, 0);
      application.trace("<ContextMenuManager addNewContextMenuItem> url: " + url, 0);
      application.trace("<ContextMenuManager addNewContextMenuItem> handler: " + handler, 0);
      if (customContextLabels.length >= 10)
      {
        application.trace("<ContextMenuManager addNewContextMenuItem> only 10 custom menu elements can be displayed.", 6);
        return;
      }
      if (customContextLabels.indexOf(label) != -1)
      {
        application.trace("<ContextMenuManager addNewContextMenuItem> only unique elements can be displayed.", 6);
        return;
      }
      customContextLabels.push(label);
      const newItem:ContextMenuItem = new ContextMenuItem(label);
      customContextMenu.customItems.push(newItem);
      if (handler == null)
      {
        customContextUrls.push(url);
        customContextHandlers.push(contextMenuUrlItemClicked);
        newItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuUrlItemClicked);
      }
      else
      {
        customContextUrls.push(null);
        customContextHandlers.push(handler);
        newItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
      }
    }
    /**
     * Removes the custom context menu item at the given index.
     * @param i the index of the menu item to be removed
     */
    public function removeContextMenuItem(i:int):void
    {
      application.trace("<ContextMenuManager removeContextMenuItem> called.", 1);
      application.trace("<ContextMenuManager removeContextMenuItem> i: " + i, 0);
      if (!(i < customContextLabels.length && i >= 0))
      {
        application.trace("<ContextMenuManager removeContextMenuItem> cannot remove context menu item at index: " + i, 6);
        return;
      }
      customContextLabels.splice(i, 1);
      customContextUrls.splice(i, 1);
      ContextMenuItem(customContextMenu.customItems[i]).removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Function(customContextHandlers[i]));
      customContextHandlers.splice(i, 1);
      customContextMenu.customItems.splice(i, 1);
    }
    /**
     * Navigates to the url stored for the clicked context menu item.
     * @param e the context menu event of the clicked item
     */
    private function contextMenuUrlItemClicked(e:ContextMenuEvent):void
    {
      application.trace("<ContextMenuManager contextMenuUrlItemClicked> called.", 1);
      application.trace("<ContextMenuManager contextMenuUrlItemClicked> e: " + e, 0);
      if (!customContextLabels || !customContextUrls)
      {
        application.trace("<ContextMenuManager contextMenuUrlItemClicked> missing arrays!", 6);
        return;
      }
      if (customContextLabels.indexOf(e.currentTarget.caption) == -1)
      {
        application.trace("<ContextMenuManager contextMenuUrlItemClicked> index is -1!", 6);
        return;
      }
      const urlToNavigate:String = customContextUrls[customContextLabels.indexOf(e.currentTarget.caption)];
      application.trace("<ContextMenuManager contextMenuUrlItemClicked> navigate to: " + urlToNavigate, 0);
      navigateToURL(new URLRequest(urlToNavigate), "_blank");
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<ContextMenuManager destroy> called.", 1);
      if (customContextMenu != null)
      {
        for (var i:int = 0; i < customContextMenu.customItems.length; i++)
        {
          ContextMenuItem(customContextMenu.customItems[i]).removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Function(customContextHandlers[i]));
        }
        customContextMenu.customItems.splice(0);
      }
      customContextLabels.splice(0);
      customContextUrls.splice(0);
      customContextHandlers.splice(0);
      application.contextMenu = null;
      customContextMenu = null;
      customContextLabels = null;
      customContextUrls = null;
      customContextHandlers = null;
      application = null;
    }
  }
}
