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
 * ButtonBar.
 * A horizontal row of button links, one of them standing as the active one.
 *
 * MAIN FEATURES:
 * - the buttons are positioned next to each other, in the order they were added in
 * - one button is the active one, it is drawn flat, and the changed event is
 *   dispatched every time another one becomes the active one
 * - a button can be hidden from the bar: it keeps its index, its label and its place
 *   in the order of the buttons, but it is left out of the row and it can not be
 *   activated by a click any more, only from the inside of the application
 * - the buttons under the mouse are drawn by one single mover layer of the scroll
 *   standing above them, so a drag scrolls the bar instead of pressing a button
 * - that mover layer covers the whole bar, because the scroll of it is a center only
 *   one: there is no navigation bar taking a margin of it away from the buttons
 * - a bar wider than its maximum width can be scrolled horizontally, by a drag or by
 *   the wheel above any point of it
 * - a drag on a bar that has nothing to be scrolled scrolls the surface it stands on
 * - the dimensions come from the buttons, they can not be set from the outside
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class ButtonBar extends BaseSprite
  {
    private var buttonLinksArray:Array = null;
    private var baseScroll:BaseScroll = null;
    private var content:BaseSprite = null;
    private var activeIndex:int = -1;
    private var eventChanged:Event = null;
    private var maxWidth:int = 0;
    private var origMouseX:int = 0;
    private var origMouseY:int = 0;
    /**
     * Constructs the ButtonBar object: creates the scrolled content the buttons stand
     * in and the horizontal scroll above it, and starts to follow the appearance of the
     * application.
     * @param applicationRef the main application reference
     */
    public function ButtonBar(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ButtonBar> called.", 1);
      application.trace("<" + this + " ButtonBar> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      buttonLinksArray = new Array();
      content = new BaseSprite(application);
      addChild(content);
      baseScroll = new BaseScroll(application);
      addChild(baseScroll);
      content.mask = baseScroll.getMask();
      baseScroll.getMover().addEventListener(MouseEvent.ROLL_OVER, moverRollOver);
      baseScroll.getMover().addEventListener(MouseEvent.ROLL_OUT, moverRollOut);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CX_CHANGED(), reposContent);
      baseScroll.setEnabledVertical(false);
      baseScroll.setCenterOnly(true);
      content.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), contentResized);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.trace("<" + this + " ButtonBar> constructed.", 1);
    }
    /**
     * Returns the index of the button carrying the given label, -1 when there is no
     * such button on this bar.
     * @param label the label the button is searched by
     */
    public function getIndexByLabel(label:String):int
    {
      application.trace("<" + this + " ButtonBar getIndexByLabel> called.", 1);
      application.trace("<" + this + " ButtonBar getIndexByLabel> label: " + label, 0);
      var index:int = -1;
      for (var i:int = 0; i < buttonLinksArray.length; i++)
      {
        if (ButtonLink(buttonLinksArray[i]).getLabel() == label)
        {
          index = i;
          break;
        }
      }
      application.trace("<" + this + " ButtonBar getIndexByLabel> index: " + index, 0);
      return index;
    }
    /**
     * Returns the index of the active button, -1 when there is none.
     */
    public function getActiveIndex():int
    {
      return activeIndex;
    }
    /**
     * Makes the button of the given index the active one and dispatches the changed
     * event of this bar. The -1 index leaves this bar without an active button.
     * @param index the index of the button to be activated
     * @param fireChangedEvent true when the changed event has to be dispatched as well
     */
    public function setActiveIndex(index:int, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ButtonBar setActiveIndex> called.", 1);
      application.trace("<" + this + " ButtonBar setActiveIndex> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setActiveIndex> fireChangedEvent: " + fireChangedEvent, 0);
      if (index >= -1 && index < buttonLinksArray.length)
      {
        if (activeIndex != index)
        {
          application.trace("<" + this + " ButtonBar setActiveIndex> conditions OK.", 1);
          activeIndex = index;
          setType(activeIndex, EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
          if (fireChangedEvent)
          {
            getBaseEventDispatcher().dispatchEvent(eventChanged);
          }
        }
      }
    }
    /**
     * Returns the label of the active button, an empty string when there is none.
     */
    public function getActiveLabel():String
    {
      application.trace("<" + this + " ButtonBar getActiveLabel> called.", 1);
      if (activeIndex == -1)
      {
        return "";
      }
      else
      {
        return ButtonLink(buttonLinksArray[activeIndex]).getLabel();
      }
    }
    /**
     * Returns the width this bar is kept inside, zero when it is not maximized at all.
     */
    public function getMaxWidth():int
    {
      return maxWidth;
    }
    /**
     * Sets the width this bar has to be kept inside. A bar holding more buttons than
     * that width can take is scrolled horizontally.
     * @param w the maximum width of this bar, zero when it is not maximized
     */
    public function setMaxWidth(w:int):void
    {
      application.trace("<" + this + " ButtonBar setMaxWidth> called.", 1);
      application.trace("<" + this + " ButtonBar setMaxWidth> w: " + w, 0);
      if (maxWidth != w)
      {
        application.trace("<" + this + " ButtonBar setMaxWidth> conditions OK.", 1);
        maxWidth = w;
        reposButtons();
      }
    }
    /**
     * Creates a new button at the end of this bar.
     * @param label the label of the new button
     * @param it the icon type of the new button, an EnumIcons value
     */
    public function addButton(label:String, it:String = ""):void
    {
      application.trace("<" + this + " ButtonBar addButton> called.", 1);
      application.trace("<" + this + " ButtonBar addButton> label: " + label, 0);
      application.trace("<" + this + " ButtonBar addButton> it: " + it, 0);
      const buttonLink:ButtonLink = new ButtonLink(application);
      content.addChildAt(buttonLink, 0);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
      buttonLink.setLabel(label);
      if (it != "")
      {
        buttonLink.setIcon(it);
      }
      buttonLinksArray.push(buttonLink);
      reposButtons();
    }
    /**
     * Destroys and removes the button of the given index. The active index follows the
     * button it belongs to.
     * @param i the index of the button to be removed
     */
    public function removeButton(i:int):void
    {
      application.trace("<" + this + " ButtonBar removeButton> called.", 1);
      application.trace("<" + this + " ButtonBar removeButton> i: " + i, 0);
      if (i >= 0 && i < buttonLinksArray.length)
      {
        application.trace("<" + this + " ButtonBar removeButton> conditions OK.", 1);
        destroyButtonLink(ButtonLink(buttonLinksArray[i]));
        buttonLinksArray.splice(i, 1);
        // the active index has to follow the button it belongs to
        if (buttonLinksArray.length == 0 || i == activeIndex)
        {
          activeIndex = -1;
        }
        else if (i < activeIndex)
        {
          activeIndex--;
          setType(activeIndex, EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
          getBaseEventDispatcher().dispatchEvent(eventChanged);
        }
        reposButtons();
      }
    }
    /**
     * Destroys and removes every button of this bar.
     */
    public function removeAllButtons():void
    {
      application.trace("<" + this + " ButtonBar removeAllButtons> called.", 1);
      for (var i:int = 0; i < buttonLinksArray.length; i++)
      {
        destroyButtonLink(ButtonLink(buttonLinksArray[i]));
      }
      buttonLinksArray.splice(0);
      // an index of a bar without buttons would point to nothing
      activeIndex = -1;
      reposButtons();
    }
    /**
     * Frees the leading slot of the button of the given index up: the icon of it and the
     * emoji of it as well.
     * @param index the index of the button the leading slot is freed up of
     */
    public function destIcon(index:int):void
    {
      application.trace("<" + this + " ButtonBar destIcon> called.", 1);
      application.trace("<" + this + " ButtonBar destIcon> index: " + index, 0);
      if (index < buttonLinksArray.length)
      {
        if (buttonLinksArray[index] is ButtonLink)
        {
          ButtonLink(buttonLinksArray[index]).destIcon();
        }
      }
    }
    /**
     * Sets the icon of the button of the given index.
     * @param index the index of the button the icon is set of
     * @param it the new icon type, an EnumIcons value
     */
    public function setIcon(index:int, it:String):void
    {
      application.trace("<" + this + " ButtonBar setIcon> called.", 1);
      application.trace("<" + this + " ButtonBar setIcon> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setIcon> it: " + it, 0);
      if (index < buttonLinksArray.length)
      {
        if (buttonLinksArray[index] is ButtonLink)
        {
          ButtonLink(buttonLinksArray[index]).setIcon(it);
        }
      }
    }
    /**
     * Sets the icon of the button of the given index, but only when that button is not
     * the active one.
     * @param index the index of the button the icon is set of
     * @param it the new icon type, an EnumIcons value
     */
    public function setIconIfNotActive(index:int, it:String):void
    {
      application.trace("<" + this + " ButtonBar setIconIfNotActive> called.", 1);
      application.trace("<" + this + " ButtonBar setIconIfNotActive> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setIconIfNotActive> it: " + it, 0);
      if (index < buttonLinksArray.length)
      {
        if (buttonLinksArray[index] is ButtonLink)
        {
          if (activeIndex != index)
          {
            ButtonLink(buttonLinksArray[index]).setIcon(it);
          }
        }
      }
    }
    /**
     * Sets the emoji of the button of the given index. An emoji and an icon stand in the
     * very same slot of a button, so they are exclusive to each other.
     * @param index the index of the button the emoji is set of
     * @param et the new emoji type, an EnumEmojis value
     */
    public function setEmoji(index:int, et:String):void
    {
      application.trace("<" + this + " ButtonBar setEmoji> called.", 1);
      application.trace("<" + this + " ButtonBar setEmoji> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setEmoji> et: " + et, 0);
      if (index < buttonLinksArray.length)
      {
        if (buttonLinksArray[index] is ButtonLink)
        {
          ButtonLink(buttonLinksArray[index]).setEmoji(et);
        }
      }
    }
    /**
     * Sets the emoji of the button of the given index, but only when that button is not
     * the active one.
     * @param index the index of the button the emoji is set of
     * @param et the new emoji type, an EnumEmojis value
     */
    public function setEmojiIfNotActive(index:int, et:String):void
    {
      application.trace("<" + this + " ButtonBar setEmojiIfNotActive> called.", 1);
      application.trace("<" + this + " ButtonBar setEmojiIfNotActive> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setEmojiIfNotActive> et: " + et, 0);
      if (index < buttonLinksArray.length)
      {
        if (buttonLinksArray[index] is ButtonLink)
        {
          if (activeIndex != index)
          {
            ButtonLink(buttonLinksArray[index]).setEmoji(et);
          }
        }
      }
    }
    /**
     * Returns true when the button of the given index is shown on this bar, false when
     * it is hidden or when there is no button of that index at all.
     * @param index the index of the button the visibility is asked of
     */
    public function getButtonVisible(index:int):Boolean
    {
      application.trace("<" + this + " ButtonBar getButtonVisible> called.", 1);
      application.trace("<" + this + " ButtonBar getButtonVisible> index: " + index, 0);
      if (index >= 0 && index < buttonLinksArray.length)
      {
        return ButtonLink(buttonLinksArray[index]).visible;
      }
      else
      {
        return false;
      }
    }
    /**
     * Shows or hides the button of the given index. A hidden button is left out of the
     * row, so this bar looks like the one that button has never been added to, but that
     * button keeps its index, its label and its place in the order of the buttons.
     * No repositioning is needed here: the visibility of a button changes its dimensions
     * as well, and the dimensions changed event of it repositions the whole row.
     * @param index the index of the button to be shown or hidden
     * @param v true when that button has to be shown on this bar
     */
    public function setButtonVisible(index:int, v:Boolean):void
    {
      application.trace("<" + this + " ButtonBar setButtonVisible> called.", 1);
      application.trace("<" + this + " ButtonBar setButtonVisible> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setButtonVisible> v: " + v, 0);
      if (index >= 0 && index < buttonLinksArray.length)
      {
        ButtonLink(buttonLinksArray[index]).setSpriteVisible(v);
      }
    }
    /**
     * The dimensions of this bar come from the buttons of it, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ButtonBar setDw> called.", 1);
      application.trace("<" + this + " ButtonBar setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonBar setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this bar come from the buttons of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ButtonBar setDh> called.", 1);
      application.trace("<" + this + " ButtonBar setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonBar setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this bar come from the buttons of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ButtonBar setDwh> called.", 1);
      application.trace("<" + this + " ButtonBar setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonBar setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonBar setDwh> do nothing.", 1);
    }
    /**
     * Renders this bar in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " ButtonBar addedToStage> called.", 1);
      application.trace("<" + this + " ButtonBar addedToStage> e: " + e, 0);
      super.addedToStage(e);
      reposButtons();
    }
    /**
     * Frees one button of this bar up, listener and display object as well.
     * @param buttonLink the button to be freed up
     */
    private function destroyButtonLink(buttonLink:ButtonLink):void
    {
      application.trace("<" + this + " ButtonBar destroyButtonLink> called.", 1);
      application.trace("<" + this + " ButtonBar destroyButtonLink> buttonLink: " + buttonLink, 0);
      if (buttonLink != null)
      {
        buttonLink.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
        buttonLink.destroy();
        if (content.contains(buttonLink))
        {
          content.removeChild(buttonLink);
        }
      }
    }
    /**
     * Positions the buttons next to each other and takes the dimensions of this bar and
     * of its content from them.
     */
    private function reposButtons():void
    {
      application.trace("<" + this + " ButtonBar reposButtons> called.", 1);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      // the hidden buttons are left out of the row: the ones behind such a button step
      // into its place, so the bar of the visible buttons is a continuous row again
      var lastVisibleButtonLink:ButtonLink = null;
      for (var i:int = 0; i < buttonLinksArray.length; i++)
      {
        const buttonLink:ButtonLink = ButtonLink(buttonLinksArray[i]);
        if (buttonLink.visible)
        {
          if (lastVisibleButtonLink == null)
          {
            buttonLink.setCxy(2 * lineThickness + 2 * padding, 2 * lineThickness + padding);
          }
          else
          {
            buttonLink.setCxy(lastVisibleButtonLink.getCx(true) + lineThickness, lastVisibleButtonLink.getCy());
          }
          lastVisibleButtonLink = buttonLink;
        }
      }
      // the dimensions come from the last visible button, and a bar of no visible button
      // at all takes no room, so the objects below it grow into the height it leaves
      if (lastVisibleButtonLink == null)
      {
        content.setDwh(0, 0);
        super.setDwh(0, 0);
      }
      else
      {
        content.setDwh(lastVisibleButtonLink.getCx(true) + 2 * lineThickness + 2 * padding
            , lastVisibleButtonLink.getDh() + 4 * lineThickness + 2 * padding);
        if (maxWidth == 0)
        {
          super.setDwh(content.getDw(), content.getDh());
        }
        else
        {
          super.setDwh(Math.min(content.getDw(), maxWidth), content.getDh());
        }
      }
      baseScroll.setDwh(getDw(), getDh());
      // the mover layer of the scroll covers this whole bar, so it decides what a drag on it
      // does: the presses of a bar that can be scrolled belong to that bar, and the ones of a
      // bar that fits into its own width are handed over to the closest scrolled surface
      // around it, which would be left with a hole of the size of this bar otherwise
      baseScroll.getMover().mouseDownForScrollingEnabled = content.getDw() <= getDw();
    }
    /**
     * Draws one single button of this bar with the given shape type, the active one of it
     * flat and every other one without any type at all.
     * That flat drawing is the mark of the active button: it is the one background of the
     * bar that is standing there all the time, so the one using the application sees which
     * button of it is the active one without pointing at anything. The active button holds
     * that mark whatever the mouse does above it, it is only given up when another button
     * becomes the active one, so the answer of this bar to a click is the mark stepping
     * over to the button that has been clicked, and nothing else.
     * @param index the index of the button to be drawn, -1 for none of them
     * @param type the shape type of that button, an EnumBaseShapeTypes value
     */
    private function setType(index:int, type:int):void
    {
      application.trace("<" + this + " ButtonBar setType> called.", 1);
      application.trace("<" + this + " ButtonBar setType> index: " + index, 0);
      application.trace("<" + this + " ButtonBar setType> type: " + type, 0);
      for (var i:int = 0; i < buttonLinksArray.length; i++)
      {
        const buttonLink:ButtonLink = ButtonLink(buttonLinksArray[i]);
        if (i == activeIndex)
        {
          buttonLink.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
        }
        else if (i == index)
        {
          buttonLink.setType(type);
        }
        else
        {
          buttonLink.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE());
        }
      }
    }
    /**
     * Returns the index of the button the mouse stands over, -1 when it stands over
     * none of them.
     */
    private function getActualElementIndexByMouse():int
    {
      application.trace("<" + this + " ButtonBar getActualElementIndexByMouse> called.", 0);
      var index:int = -1;
      for (var i:int = 0; i < buttonLinksArray.length; i++)
      {
        const buttonLink:ButtonLink = ButtonLink(buttonLinksArray[i]);
        // a hidden button is not standing in the row at all, and it keeps the coordinates
        // it had before it was hidden, so it would take the clicks of the ones around it
        if (buttonLink.visible && content.mouseX > buttonLink.getCx() && content.mouseX < buttonLink.getCx(true))
        {
          index = i;
          break;
        }
      }
      application.trace("<" + this + " ButtonBar getActualElementIndexByMouse> index: " + index, 0);
      return index;
    }
    /**
     * Starts to follow the mouse as soon as it comes over the mover layer of the scroll.
     * @param e the roll over event of that mover layer
     */
    private function moverRollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonBar moverRollOver> called.", 1);
      application.trace("<" + this + " ButtonBar moverRollOver> e: " + e, 0);
      if (getEnabled())
      {
        baseScroll.getMover().addEventListener(MouseEvent.MOUSE_MOVE, moverMouseMove);
        baseScroll.getMover().addEventListener(MouseEvent.MOUSE_DOWN, moverMouseDown);
        baseScroll.getMover().addEventListener(MouseEvent.CLICK, moverMouseClick);
      }
    }
    /**
     * Stops following the mouse and drops the drawing of the button it stood over.
     * @param e the roll out event of the mover layer of the scroll
     */
    private function moverRollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonBar moverRollOut> called.", 1);
      application.trace("<" + this + " ButtonBar moverRollOut> e: " + e, 0);
      baseScroll.getMover().removeEventListener(MouseEvent.MOUSE_MOVE, moverMouseMove);
      baseScroll.getMover().removeEventListener(MouseEvent.MOUSE_DOWN, moverMouseDown);
      baseScroll.getMover().removeEventListener(MouseEvent.CLICK, moverMouseClick);
      setType(-1, EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE());
    }
    /**
     * Draws the button the mouse stands over. A button of a bar being dragged is not
     * drawn at all, because that drag scrolls this bar instead of pressing it.
     * @param e the mouse move event of the mover layer of the scroll
     */
    private function moverMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonBar moverMouseMove> called.", 0);
      application.trace("<" + this + " ButtonBar moverMouseMove> e: " + e, 0);
      if (getEnabled())
      {
        setType(getActualElementIndexByMouse(), e.buttonDown ? EnumBaseShapeTypes.BASE_SHAPE_TYPE_NONE() : EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      }
    }
    /**
     * Draws the button the mouse has been pressed down over and stores the position of
     * that press, so that a drag can be told from a click afterwards.
     * @param e the mouse down event of the mover layer of the scroll
     */
    private function moverMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonBar moverMouseDown> called.", 1);
      application.trace("<" + this + " ButtonBar moverMouseDown> e: " + e, 0);
      if (getEnabled())
      {
        origMouseX = int(mouseX);
        origMouseY = int(mouseY);
        setType(getActualElementIndexByMouse(), EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      }
    }
    /**
     * Activates the button that has been clicked. A mouse that has travelled farther
     * than the click gap of the application has scrolled this bar instead.
     * @param e the click event of the mover layer of the scroll
     */
    private function moverMouseClick(e:MouseEvent):void
    {
      application.trace("<" + this + " ButtonBar moverMouseClick> called.", 1);
      application.trace("<" + this + " ButtonBar moverMouseClick> e: " + e, 0);
      if (getEnabled() && Math.abs(origMouseX - int(mouseX)) < application.getComponentsConfig().getClickGap()
        && Math.abs(origMouseY - int(mouseY)) < application.getComponentsConfig().getClickGap())
      {
        const index:int = getActualElementIndexByMouse();
        if (index != -1)
        {
          setActiveIndex(index);
        }
      }
    }
    /**
     * Positions the scrolled content of this bar after it has been scrolled.
     * @param e the content x coordinate changed event of the scroll
     */
    private function reposContent(e:Event):void
    {
      application.trace("<" + this + " ButtonBar reposContent> called.", 1);
      application.trace("<" + this + " ButtonBar reposContent> e: " + e, 0);
      content.setCxy(baseScroll.getCxContent(), baseScroll.getCyContent());
    }
    /**
     * Tells the scroll how wide the whole row of the buttons is.
     * @param e the dimensions changed event of the content
     */
    private function contentResized(e:Event):void
    {
      application.trace("<" + this + " ButtonBar contentResized> called.", 1);
      application.trace("<" + this + " ButtonBar contentResized> e: " + e, 0);
      baseScroll.setDwhContent(content.getDw(), content.getDh());
    }
    /**
     * Positions the buttons again after one of them has taken a new size.
     * @param e the dimensions changed event of that button
     */
    private function buttonLinkResized(e:Event):void
    {
      application.trace("<" + this + " ButtonBar buttonLinkResized> called.", 1);
      application.trace("<" + this + " ButtonBar buttonLinkResized> e: " + e, 0);
      reposButtons();
    }
    /**
     * Positions the buttons again after the appearance of the application has been
     * changed: the gaps between them are taken from the line thickness and the padding.
     * @param e the line thickness or padding changed event of the application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " ButtonBar appearanceChanged> called.", 1);
      application.trace("<" + this + " ButtonBar appearanceChanged> e: " + e, 0);
      reposButtons();
    }
    /**
     * Frees all listeners, events and references held by this bar.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ButtonBar destroy> called.", 1);
      application.trace("<" + this + " ButtonBar destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      baseScroll.getMover().removeEventListener(MouseEvent.ROLL_OVER, moverRollOver);
      baseScroll.getMover().removeEventListener(MouseEvent.ROLL_OUT, moverRollOut);
      baseScroll.getMover().removeEventListener(MouseEvent.MOUSE_MOVE, moverMouseMove);
      baseScroll.getMover().removeEventListener(MouseEvent.MOUSE_DOWN, moverMouseDown);
      baseScroll.getMover().removeEventListener(MouseEvent.CLICK, moverMouseClick);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), appearanceChanged);
      application.trace("<" + this + " ButtonBar destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      buttonLinksArray.splice(0);
      application.trace("<" + this + " ButtonBar destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      buttonLinksArray = null;
      baseScroll = null;
      content = null;
      activeIndex = 0;
      eventChanged = null;
      maxWidth = 0;
      origMouseX = 0;
      origMouseY = 0;
    }
  }
}
