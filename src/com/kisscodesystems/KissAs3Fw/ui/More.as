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
 * More.
 * An openable panel that holds a set of other user interface elements.
 * Useful when there are many buttons and these buttons would take too much
 * room if all of them were displayed all the time.
 *
 * MAIN FEATURES:
 * - opens and closes a panel of other elements, such as buttons and links
 * - the elements standing in that panel can be counted and asked for one by one
 * - the panel repositions its elements and resizes itself automatically when one
 *   of its elements resizes and when an element has been added or removed
 * - a frame is drawn around the open panel
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseEventDispatcher;
  import com.kisscodesystems.KissAs3Fw.base.BaseOpen;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.DisplayObject;
  import flash.events.Event;
  public class More extends BaseOpen
  {
    private var textLabel:TextLabel = null;
    private var shapeBgFrame:BaseShape = null;
    /**
     * Constructs the More object: creates the label of its button and the frame of
     * its panel, then subscribes to the values it displays itself from.
     * @param applicationRef the main application reference
     */
    public function More(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " More> called.", 1);
      application.trace("<" + this + " More> applicationRef: " + applicationRef, 0);
      textLabel = new TextLabel(application);
      baseWorkingButton.getContentSprite().addChild(textLabel);
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resizeLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      textLabel.setLabel(EnumTextKeys.MORE());
      textLabel.setIcon(EnumIcons.more());
      shapeBgFrame = new BaseShape(application);
      addChild(shapeBgFrame);
      shapeBgFrame.setIsBright(false);
      shapeBgFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      shapeBgFrame.visible = false;
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resizeContent);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShape);
      application.trace("<" + this + " More> constructed.", 1);
    }
    /**
     * Returns the label object displayed on the button of this panel.
     */
    public function getTextLabel():TextLabel
    {
      return textLabel;
    }
    /**
     * Returns the number of the elements standing in the panel of this object.
     */
    public function getNumOfElements():int
    {
      return contentSprite != null ? contentSprite.numChildren : 0;
    }
    /**
     * Returns the element of the given index of the panel of this object, or null when
     * there is no element of that index in it at all. The elements stand in the order
     * they have been added in.
     * @param index the index of the element that is asked for
     */
    public function getElementAt(index:int):DisplayObject
    {
      application.trace("<" + this + " More getElementAt> called.", 1);
      application.trace("<" + this + " More getElementAt> index: " + index, 0);
      if (index < 0 || index >= getNumOfElements())
      {
        application.trace("<" + this + " More getElementAt> there is no element of this index in the panel.", 1);
        return null;
      }
      return contentSprite.getChildAt(index);
    }
    /**
     * Adds an element into the panel of this object and starts to follow its resizing.
     * @param displayObject the element to be added
     */
    public function addToContent(displayObject:DisplayObject):void
    {
      application.trace("<" + this + " More addToContent> called.", 1);
      application.trace("<" + this + " More addToContent> displayObject: " + displayObject, 0);
      if (contentSprite != null && displayObject != null && !contentSprite.contains(displayObject))
      {
        contentSprite.addChild(displayObject);
        const dispatcher:BaseEventDispatcher = getDispatcherOfElement(displayObject);
        if (dispatcher != null)
        {
          dispatcher.addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resizeContent);
        }
        resizeContent();
      }
    }
    /**
     * Removes an element from the panel of this object. The element itself is not
     * destroyed here, because it has been created outside of this object.
     * @param displayObject the element to be removed
     */
    public function removeFromContent(displayObject:DisplayObject):void
    {
      application.trace("<" + this + " More removeFromContent> called.", 1);
      application.trace("<" + this + " More removeFromContent> displayObject: " + displayObject, 0);
      if (contentSprite != null && displayObject != null && contentSprite.contains(displayObject))
      {
        // the element may have been destroyed before this call, and a destroyed object
        // has no dispatcher any more. That dispatcher took the listener below with it,
        // so there is nothing left to remove, but the element still has to be dropped
        // out of the panel of this object
        const dispatcher:BaseEventDispatcher = getDispatcherOfElement(displayObject);
        if (dispatcher != null)
        {
          dispatcher.removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resizeContent);
        }
        contentSprite.removeChild(displayObject);
        resizeContent();
      }
    }
    /**
     * Opens the panel of this object: takes the dimensions of the panel and displays
     * the frame around it.
     */
    override public function open():void
    {
      application.trace("<" + this + " More open> called.", 1);
      super.open();
      resizeContent();
      shapeBgFrame.visible = true;
    }
    /**
     * Closes the panel of this object: hides the frame and takes the dimensions of
     * the label back.
     */
    override public function close():void
    {
      application.trace("<" + this + " More close> called.", 1);
      super.close();
      shapeBgFrame.visible = false;
      resizeLabel();
    }
    /**
     * The dimensions of this object come from its label or from its open panel, so
     * this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " More setDw> called.", 1);
      application.trace("<" + this + " More setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " More setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from its label or from its open panel, so
     * this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " More setDh> called.", 1);
      application.trace("<" + this + " More setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " More setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from its label or from its open panel, so
     * this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " More setDwh> called.", 1);
      application.trace("<" + this + " More setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " More setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " More setDwh> do nothing.", 1);
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " More addedToStage> called.", 1);
      application.trace("<" + this + " More addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resizeContent();
    }
    /**
     * Returns the event dispatcher of the given element, or null when that element has
     * none: it is neither a base sprite nor a base text field, or it has already been
     * destroyed.
     * @param displayObject the element the dispatcher is asked for
     */
    private function getDispatcherOfElement(displayObject:DisplayObject):BaseEventDispatcher
    {
      application.trace("<" + this + " More getDispatcherOfElement> called.", 1);
      application.trace("<" + this + " More getDispatcherOfElement> displayObject: " + displayObject, 0);
      if (displayObject is BaseSprite)
      {
        return BaseSprite(displayObject).getBaseEventDispatcher();
      }
      if (displayObject is BaseTextField)
      {
        return BaseTextField(displayObject).getBaseEventDispatcher();
      }
      return null;
    }
    /**
     * Repositions the label inside the button and takes its dimensions when the panel
     * of this object is closed.
     * @param e the dimensions changed event of the label, null on a direct call
     */
    private function resizeLabel(e:Event = null):void
    {
      application.trace("<" + this + " More resizeLabel> called.", 1);
      application.trace("<" + this + " More resizeLabel> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setCxy(padding, padding);
      if (!isOpened())
      {
        super.setDwh(textLabel.getCx(true, false, true), textLabel.getCy(true, false, true));
      }
    }
    /**
     * Repositions every element of the panel under each other and resizes the panel
     * and this object to the room they need.
     * @param e the dimensions changed event of an element or the padding changed
     * event of the application, null on a direct call
     */
    private function resizeContent(e:Event = null):void
    {
      application.trace("<" + this + " More resizeContent> called.", 1);
      application.trace("<" + this + " More resizeContent> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      var maxw:int = 0;
      var allh:int = padding;
      for (var i:int = 0; i < contentSprite.numChildren; i++)
      {
        var child:DisplayObject = contentSprite.getChildAt(i);
        maxw = Math.max(maxw, getChildDw(child));
        setChildCxy(child, padding, allh);
        allh += getChildDh(child) + padding;
      }
      maxw += 2 * padding;
      contentSprite.setDwh(maxw, allh);
      if (isOpened())
      {
        super.setDwh(maxw, allh);
        redrawShape();
      }
      resizeLabel();
    }
    /**
     * Returns the width of an element of the panel.
     * @param child the element of the panel
     */
    private function getChildDw(child:DisplayObject):int
    {
      application.trace("<" + this + " More getChildDw> called.", 1);
      application.trace("<" + this + " More getChildDw> child: " + child, 0);
      var childDw:int = child.width;
      if (child is BaseSprite)
      {
        childDw = BaseSprite(child).getDw();
      }
      else if (child is BaseTextField)
      {
        childDw = BaseTextField(child).getDw();
      }
      application.trace("<" + this + " More getChildDw> childDw: " + childDw, 0);
      return childDw;
    }
    /**
     * Returns the height of an element of the panel.
     * @param child the element of the panel
     */
    private function getChildDh(child:DisplayObject):int
    {
      application.trace("<" + this + " More getChildDh> called.", 1);
      application.trace("<" + this + " More getChildDh> child: " + child, 0);
      var childDh:int = child.height;
      if (child is BaseSprite)
      {
        childDh = BaseSprite(child).getDh();
      }
      else if (child is BaseTextField)
      {
        childDh = BaseTextField(child).getDh();
      }
      application.trace("<" + this + " More getChildDh> childDh: " + childDh, 0);
      return childDh;
    }
    /**
     * Moves an element of the panel to the given coordinates.
     * @param child the element of the panel
     * @param newcx the new x coordinate
     * @param newcy the new y coordinate
     */
    private function setChildCxy(child:DisplayObject, newcx:int, newcy:int):void
    {
      application.trace("<" + this + " More setChildCxy> called.", 1);
      application.trace("<" + this + " More setChildCxy> child: " + child, 0);
      application.trace("<" + this + " More setChildCxy> newcx: " + newcx, 0);
      application.trace("<" + this + " More setChildCxy> newcy: " + newcy, 0);
      if (child is BaseSprite)
      {
        BaseSprite(child).setCxy(newcx, newcy);
      }
      else if (child is BaseTextField)
      {
        BaseTextField(child).setCxy(newcx, newcy);
      }
      else
      {
        child.x = newcx;
        child.y = newcy;
      }
    }
    /**
     * Redraws the frame of the panel of this object in the current colors, radius and
     * dimensions.
     * @param e the radius or background color changed event of the application, null
     * on a direct call
     */
    private function redrawShape(e:Event = null):void
    {
      application.trace("<" + this + " More redrawShape> called.", 1);
      application.trace("<" + this + " More redrawShape> e: " + e, 0);
      shapeBgFrame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      shapeBgFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      shapeBgFrame.setDwh(getDw(), getDh());
      shapeBgFrame.drawRect();
    }
    /**
     * Frees all listeners, events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " More destroy> called.", 1);
      application.trace("<" + this + " More destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resizeContent);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawShape);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawShape);
      application.trace("<" + this + " More destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textLabel = null;
      shapeBgFrame = null;
    }
  }
}
