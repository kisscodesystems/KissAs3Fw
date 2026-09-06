package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  public class BaseScroll extends BaseSprite
  {
    private var shapeFrame:BaseShape = null;
    private var centerNavigation:CenterNavigation = null;
    private var topNavigation:TopNavigation = null;
    private var bottomNavigation:BottomNavigation = null;
    private var leftNavigation:LeftNavigation = null;
    private var rightNavigation:RightNavigation = null;
    private var resizeSprite:BaseSprite = null;
    // True while the resizer of this scroll is being dragged by the one using it: the
    // position of that resizer comes from the mouse right then and not from the corner
    // of this scroll, so it must not be put back to that corner until the drag is over.
    private var resizerDragging:Boolean = false;
    private var scrollMaskSprite:BaseSprite = null;
    private var dwContent:int = 0;
    private var dhContent:int = 0;
    private var cxContent:Number = 0;
    private var cyContent:Number = 0;
    private var cxContentSaved:Number = 0;
    private var cyContentSaved:Number = 0;
    private var eventContentDwChanged:Event = null;
    private var eventContentDhChanged:Event = null;
    private var eventContentCxChanged:Event = null;
    private var eventContentCyChanged:Event = null;
    private var isEnabledHorizontal:Boolean = true;
    private var isEnabledVertical:Boolean = true;
    private var isQuantizedHorizontal:Boolean = false;
    private var isQuantizedVertical:Boolean = false;
    private var isCenterOnly:Boolean = false;
    private var eventEnabledVerticalChanged:Event = null;
    private var eventEnabledHorizontalChanged:Event = null;
    private var eventQuantizedVerticalChanged:Event = null;
    private var eventQuantizedHorizontalChanged:Event = null;
    private var isScrolled:Boolean = false;
    private var eventContentCacheBegin:Event = null;
    private var eventTopReached:Event = null;
    private var eventBottomReached:Event = null;
    private var eventLeftReached:Event = null;
    private var eventRightReached:Event = null;
    private var dummyContent:BaseShape = null;
    private var content:BaseSprite = null;
    private var cxContentTarget:int = 0;
    private var cyContentTarget:int = 0;
    private var shapeFrameBackgroundAlpha:Number = 0;
    /**
     * Constructs the scroll: builds the frame shape, the five navigations and the optional dummy content, then registers every listener.
     * @param applicationRef the application reference passed to the base sprite
     * @param addDummyContent whether a dummy content shape should be created and added
     */
    public function BaseScroll(applicationRef:Application, addDummyContent:Boolean = false):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseScroll> called.", 1);
      application.trace("<" + this + " BaseScroll> applicationRef: " + applicationRef, 0);
      application.trace("<" + this + " BaseScroll> addDummyContent: " + addDummyContent, 0);
      if (addDummyContent)
      {
        dummyContent = new BaseShape(application);
        addChild(dummyContent);
        dummyContent.x = 0;
        dummyContent.y = 0;
        dummyContent.setIsBright(true);
        dummyContent.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      }
      eventContentDwChanged = new Event(EnumEvents.EVENT_CONTENT_DW_CHANGED());
      eventContentDhChanged = new Event(EnumEvents.EVENT_CONTENT_DH_CHANGED());
      eventContentCxChanged = new Event(EnumEvents.EVENT_CONTENT_CX_CHANGED());
      eventContentCyChanged = new Event(EnumEvents.EVENT_CONTENT_CY_CHANGED());
      eventEnabledVerticalChanged = new Event(EnumEvents.EVENT_ENABLED_VERTICAL_CHANGED());
      eventEnabledHorizontalChanged = new Event(EnumEvents.EVENT_ENABLED_HORIZONTAL_CHANGED());
      eventQuantizedVerticalChanged = new Event(EnumEvents.EVENT_QUANTIZED_VERTICAL_CHANGED());
      eventQuantizedHorizontalChanged = new Event(EnumEvents.EVENT_QUANTIZED_HORIZONTAL_CHANGED());
      eventContentCacheBegin = new Event(EnumEvents.EVENT_CONTENT_CACHE_BEGIN());
      eventTopReached = new Event(EnumEvents.EVENT_TOP_REACHED());
      eventBottomReached = new Event(EnumEvents.EVENT_BOTTOM_REACHED());
      eventLeftReached = new Event(EnumEvents.EVENT_LEFT_REACHED());
      eventRightReached = new Event(EnumEvents.EVENT_RIGHT_REACHED());
      shapeFrame = new BaseShape(application);
      addChild(shapeFrame);
      shapeFrame.x = 0;
      shapeFrame.y = 0;
      shapeFrame.setIsBright(false);
      shapeFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_FLAT());
      scrollMaskSprite = new BaseSprite(application);
      addChild(scrollMaskSprite);
      centerNavigation = new CenterNavigation(application);
      addChild(centerNavigation);
      centerNavigation.setScrollRef(this);
      centerNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CENTER_SCROLLING_START(), centerScrollingStart);
      centerNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CENTER_SCROLLING_IN_PROGRESS(), centerScrollingInProgress);
      centerNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CENTER_SCROLLING_END(), centerScrollingEnd);
      centerNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_START_SCROLL_TO_TARGET(), centerStartScrollToTarget);
      centerNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET(), stopScrollToTarget);
      content = new BaseSprite(application);
      addChild(content);
      topNavigation = new TopNavigation(application);
      addChild(topNavigation);
      topNavigation.setScrollRef(this);
      topNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OUTER_FACTOR_CHANGED(), topScrolling);
      topNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET(), stopScrollToTarget);
      bottomNavigation = new BottomNavigation(application);
      addChild(bottomNavigation);
      bottomNavigation.setScrollRef(this);
      bottomNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OUTER_FACTOR_CHANGED(), bottomScrolling);
      bottomNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET(), stopScrollToTarget);
      leftNavigation = new LeftNavigation(application);
      addChild(leftNavigation);
      leftNavigation.setScrollRef(this);
      leftNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OUTER_FACTOR_CHANGED(), leftScrolling);
      leftNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET(), stopScrollToTarget);
      rightNavigation = new RightNavigation(application);
      addChild(rightNavigation);
      rightNavigation.setScrollRef(this);
      rightNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_OUTER_FACTOR_CHANGED(), rightScrolling);
      rightNavigation.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET(), stopScrollToTarget);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), boxChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), boxChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
      application.trace("<" + this + " BaseScroll> constructed.", 1);
    }
    /**
     * Returns the sprite the scrolled content of this scroll is put into.
     */
    public function getContent():BaseSprite
    {
      return content;
    }
    /**
     * Starts the dragging of the content from the outside, as if the center area of this
     * scroll had been pressed.
     * @param e the mouse down event to start the dragging with
     */
    public function mouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseScroll mouseDown> called.", 1);
      application.trace("<" + this + " BaseScroll mouseDown> e: " + e, 0);
      centerNavigation.mouseDown(e);
    }
    /**
     * Shows or hides the top navigation bar of this scroll.
     * @param b true when that bar has to be hidden
     */
    public function hideNavigationTop(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll hideNavigationTop> called.", 1);
      application.trace("<" + this + " BaseScroll hideNavigationTop> b: " + b, 0);
      topNavigation.hideNavigation(b);
    }
    /**
     * Tells whether the top navigation bar of this scroll is a hidden one.
     */
    public function isHiddenNavigationTop():Boolean
    {
      return topNavigation.isHiddenNavigation();
    }
    /**
     * Shows or hides the bottom navigation bar of this scroll.
     * @param b true when that bar has to be hidden
     */
    public function hideNavigationBottom(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll hideNavigationBottom> called.", 1);
      application.trace("<" + this + " BaseScroll hideNavigationBottom> b: " + b, 0);
      bottomNavigation.hideNavigation(b);
    }
    /**
     * Tells whether the bottom navigation bar of this scroll is a hidden one.
     */
    public function isHiddenNavigationBottom():Boolean
    {
      return bottomNavigation.isHiddenNavigation();
    }
    /**
     * Shows or hides the left navigation bar of this scroll.
     * @param b true when that bar has to be hidden
     */
    public function hideNavigationLeft(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll hideNavigationLeft> called.", 1);
      application.trace("<" + this + " BaseScroll hideNavigationLeft> b: " + b, 0);
      leftNavigation.hideNavigation(b);
    }
    /**
     * Tells whether the left navigation bar of this scroll is a hidden one.
     */
    public function isHiddenNavigationLeft():Boolean
    {
      return leftNavigation.isHiddenNavigation();
    }
    /**
     * Shows or hides the right navigation bar of this scroll.
     * @param b true when that bar has to be hidden
     */
    public function hideNavigationRight(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll hideNavigationRight> called.", 1);
      application.trace("<" + this + " BaseScroll hideNavigationRight> b: " + b, 0);
      rightNavigation.hideNavigation(b);
    }
    /**
     * Tells whether the right navigation bar of this scroll is a hidden one.
     */
    public function isHiddenNavigationRight():Boolean
    {
      return rightNavigation.isHiddenNavigation();
    }
    /**
     * Tells whether this scroll is a center only one.
     */
    public function getCenterOnly():Boolean
    {
      return isCenterOnly;
    }
    /**
     * Turns this scroll into a center only one, or gives its navigation bars back.
     * The center area of a center only scroll covers the whole surface of it instead of
     * the middle of it, and the four navigation bars are hidden and are let through by
     * the mouse, so the content can be grabbed anywhere and the wheel scrolls it above
     * any point of it: the margins the bars have taken away from that content are gone,
     * and nothing is lost of the scrolling itself.
     * @param b true when this scroll has to be a center only one
     */
    public function setCenterOnly(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setCenterOnly> called.", 1);
      application.trace("<" + this + " BaseScroll setCenterOnly> b: " + b, 0);
      if (isCenterOnly != b)
      {
        application.trace("<" + this + " BaseScroll setCenterOnly> conditions OK.", 1);
        isCenterOnly = b;
        topNavigation.coverByCenter(b);
        bottomNavigation.coverByCenter(b);
        leftNavigation.coverByCenter(b);
        rightNavigation.coverByCenter(b);
        centerNavigation.setFull(b);
      }
    }
    /**
     * Returns the horizontal position of the content as a factor of the scrollable width.
     */
    public function calcFactorToBeSetH():Number
    {
      return cxContent / (getDw() - dwContent);
    }
    /**
     * Returns the vertical position of the content as a factor of the scrollable height.
     */
    public function calcFactorToBeSetV():Number
    {
      return cyContent / (getDh() - dhContent);
    }
    /**
     * Sets the shape type of the frame of this scroll and redraws that frame.
     * @param t the new base shape type
     */
    public function setShapeFrameType(t:int):void
    {
      application.trace("<" + this + " BaseScroll setShapeFrameType> called.", 1);
      application.trace("<" + this + " BaseScroll setShapeFrameType> t: " + t, 0);
      shapeFrame.setType(t);
      redrawFrameShape();
    }
    /**
     * Tells whether the frame of this scroll is a displayed one.
     */
    public function getShapeFrameVisible():Boolean
    {
      return shapeFrame.visible;
    }
    /**
     * Shows or hides the frame of this scroll. A hidden frame means no line and no
     * background at all: the content of this scroll stands on whatever is behind it.
     * @param b true when the frame has to be displayed
     */
    public function setShapeFrameVisible(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setShapeFrameVisible> b: " + b, 0);
      shapeFrame.visible = b;
    }
    /**
     * Sets the background alpha of the frame of this scroll and redraws that frame.
     * @param a the new background alpha
     */
    public function setShapeFrameBackgroundAlpha(a:Number):void
    {
      application.trace("<" + this + " BaseScroll setShapeFrameBackgroundAlpha> called.", 1);
      application.trace("<" + this + " BaseScroll setShapeFrameBackgroundAlpha> a: " + a, 0);
      shapeFrameBackgroundAlpha = a;
      redrawFrameShape();
    }
    /**
     * Turns the bottom-right resizer handle on or off by creating or removing the resizer sprite.
     * @param b true to make the component resizable, false to remove the resizer
     */
    public function setResizable(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setResizable> called.", 1);
      application.trace("<" + this + " BaseScroll setResizable> b: " + b, 0);
      if (resizeSprite != null && !b)
      {
        removeResizer();
      }
      else if (resizeSprite == null && b)
      {
        createResizer();
      }
    }
    /**
     * Returns the mask object.
     */
    public function getMask():BaseSprite
    {
      return scrollMaskSprite;
    }
    /**
     * Returns the mover object of the center navigation.
     */
    public function getMover():BaseSprite
    {
      return centerNavigation.getMover();
    }
    /**
     * Returns whether the resizer handle is currently present.
     */
    public function getResizable():Boolean
    {
      return resizeSprite != null;
    }
    /**
     * Sets the content width, dispatches the change event and repaints the dummy content.
     * @param newdw the new content width
     */
    public function setDwContent(newdw:int):void
    {
      application.trace("<" + this + " BaseScroll setDwContent> called.", 1);
      application.trace("<" + this + " BaseScroll setDwContent> newdw: " + newdw, 0);
      if (dwContent != newdw)
      {
        stopScrollToTarget();
        dwContent = newdw;
        getBaseEventDispatcher().dispatchEvent(eventContentDwChanged);
        repaintDummyContent();
      }
    }
    /**
     * Sets the content height, dispatches the change event and repaints the dummy content.
     * @param newdh the new content height
     */
    public function setDhContent(newdh:int):void
    {
      application.trace("<" + this + " BaseScroll setDhContent> called.", 1);
      application.trace("<" + this + " BaseScroll setDhContent> newdh: " + newdh, 0);
      if (dhContent != newdh)
      {
        stopScrollToTarget();
        dhContent = newdh;
        getBaseEventDispatcher().dispatchEvent(eventContentDhChanged);
        repaintDummyContent();
      }
    }
    /**
     * Sets the content width and height together, dispatches the change events and repaints the dummy content.
     * @param newdw the new content width
     * @param newdh the new content height
     */
    public function setDwhContent(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseScroll setDwhContent> called.", 1);
      application.trace("<" + this + " BaseScroll setDwhContent> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseScroll setDwhContent> newdh: " + newdh, 0);
      if (dwContent != newdw || dhContent != newdh)
      {
        stopScrollToTarget();
        dwContent = newdw;
        dhContent = newdh;
        getBaseEventDispatcher().dispatchEvent(eventContentDwChanged);
        getBaseEventDispatcher().dispatchEvent(eventContentDhChanged);
        repaintDummyContent();
      }
    }
    /**
     * Returns the current content x.
     */
    public function getCxContent():int
    {
      return cxContent;
    }
    /**
     * Returns the current content y.
     */
    public function getCyContent():int
    {
      return cyContent;
    }
    /**
     * Returns the current content width.
     */
    public function getDwContent():int
    {
      return dwContent;
    }
    /**
     * Returns the current content height.
     */
    public function getDhContent():int
    {
      return dhContent;
    }
    /**
     * Returns whether vertical scrolling is enabled.
     */
    public function getEnabledVertical():Boolean
    {
      return isEnabledVertical;
    }
    /**
     * Returns whether horizontal scrolling is enabled.
     */
    public function getEnabledHorizontal():Boolean
    {
      return isEnabledHorizontal;
    }
    /**
     * Enables or disables horizontal scrolling, resetting the scroll state and dispatching the change event.
     * @param b true to enable horizontal scrolling, false to disable it
     */
    public function setEnabledHorizontal(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setEnabledHorizontal> called.", 1);
      application.trace("<" + this + " BaseScroll setEnabledHorizontal> b: " + b, 0);
      if (isEnabledHorizontal && !b)
      {
        resetAll();
        isEnabledHorizontal = false;
        application.trace("<" + this + " BaseScroll setEnabledHorizontal> enabledHorizontal set to false", 0);
        getBaseEventDispatcher().dispatchEvent(eventEnabledHorizontalChanged);
      }
      else if (!isEnabledHorizontal && b)
      {
        resetAll();
        isEnabledHorizontal = true;
        application.trace("<" + this + " BaseScroll setEnabledHorizontal> enabledHorizontal set to true", 0);
        getBaseEventDispatcher().dispatchEvent(eventEnabledHorizontalChanged);
      }
    }
    /**
     * Enables or disables vertical scrolling, resetting the scroll state and dispatching the change event.
     * @param b true to enable vertical scrolling, false to disable it
     */
    public function setEnabledVertical(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setEnabledVertical> called.", 1);
      application.trace("<" + this + " BaseScroll setEnabledVertical> b: " + b, 0);
      if (isEnabledVertical && !b)
      {
        resetAll();
        isEnabledVertical = false;
        application.trace("<" + this + " BaseScroll setEnabledVertical> enabledVertical set to false", 0);
        getBaseEventDispatcher().dispatchEvent(eventEnabledVerticalChanged);
      }
      else if (!isEnabledVertical && b)
      {
        resetAll();
        isEnabledVertical = true;
        application.trace("<" + this + " BaseScroll setEnabledVertical> enabledVertical set to true", 0);
        getBaseEventDispatcher().dispatchEvent(eventEnabledVerticalChanged);
      }
    }
    /**
     * Sets the enabled state of the component, resets the scroll and adjusts the alpha accordingly.
     * @param e true to enable the component, false to disable it
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setEnabled> called.", 1);
      application.trace("<" + this + " BaseScroll setEnabled> e: " + e, 0);
      super.setEnabled(e);
      resetAll();
      alpha = e ? 1 : application.getComponentsConfig().getDisabledAlpha();
    }
    /**
     * Returns whether vertical scrolling is quantized (page snapped).
     */
    public function getQuantizedVertical():Boolean
    {
      return isQuantizedVertical;
    }
    /**
     * Returns whether horizontal scrolling is quantized (page snapped).
     */
    public function getQuantizedHorizontal():Boolean
    {
      return isQuantizedHorizontal;
    }
    /**
     * Turns horizontal quantized (page snapped) scrolling on or off, resetting the scroll and dispatching the change event.
     * @param b true to quantize horizontal scrolling, false to scroll freely
     */
    public function setQuantizedHorizontal(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setQuantizedHorizontal> called.", 1);
      application.trace("<" + this + " BaseScroll setQuantizedHorizontal> b: " + b, 0);
      if (isQuantizedHorizontal && !b)
      {
        resetAll();
        isQuantizedHorizontal = false;
        application.trace("<" + this + " BaseScroll setQuantizedHorizontal> quantizedHorizontal set to false", 0);
        getBaseEventDispatcher().dispatchEvent(eventQuantizedHorizontalChanged);
      }
      else if (!isQuantizedHorizontal && b)
      {
        resetAll();
        isQuantizedHorizontal = true;
        application.trace("<" + this + " BaseScroll setQuantizedHorizontal> quantizedHorizontal set to true", 0);
        getBaseEventDispatcher().dispatchEvent(eventQuantizedHorizontalChanged);
      }
    }
    /**
     * Turns vertical quantized (page snapped) scrolling on or off, resetting the scroll and dispatching the change event.
     * @param b true to quantize vertical scrolling, false to scroll freely
     */
    public function setQuantizedVertical(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setQuantizedVertical> called.", 1);
      application.trace("<" + this + " BaseScroll setQuantizedVertical> b: " + b, 0);
      if (isQuantizedVertical && !b)
      {
        resetAll();
        isQuantizedVertical = false;
        application.trace("<" + this + " BaseScroll setQuantizedVertical> quantizedVertical set to false", 0);
        getBaseEventDispatcher().dispatchEvent(eventQuantizedVerticalChanged);
      }
      else if (!isQuantizedVertical && b)
      {
        resetAll();
        isQuantizedVertical = true;
        application.trace("<" + this + " BaseScroll setQuantizedVertical> quantizedVertical set to true", 0);
        getBaseEventDispatcher().dispatchEvent(eventQuantizedVerticalChanged);
      }
    }
    /**
     * Tells whether this scroll has anything to be scrolled at all: a content that is
     * bigger than this object in a direction that is enabled. A content that fits into
     * this object stays where it is, so a drag on it belongs to the closest outer
     * content that can be scrolled instead of to this one.
     */
    public function hasSomethingToScroll():Boolean
    {
      return (isEnabledHorizontal && dwContent > getDw()) || (isEnabledVertical && dhContent > getDh());
    }
    /**
     * Returns whether a scrolling drag is currently in progress.
     */
    public function getScrolled():Boolean
    {
      return isScrolled;
    }
    /**
     * Sets whether a scrolling drag is currently in progress.
     * @param b the new scrolled state
     */
    public function setScrolled(b:Boolean):void
    {
      application.trace("<" + this + " BaseScroll setScrolled> called.", 1);
      application.trace("<" + this + " BaseScroll setScrolled> b: " + b, 0);
      isScrolled = b;
    }
    /**
     * Removes the stage mouse listeners when the component is removed from the stage.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseScroll removedFromStage> called.", 1);
      application.trace("<" + this + " BaseScroll removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
      resizerDragging = false;
      super.removedFromStage(e);
    }
    /**
     * Reacts to a dimension change by stopping any scroll, redrawing the frame and repositioning the resizer.
     * Every new size is followed by that resizer, wherever it comes from, so the corner of it
     * stays the corner of this scroll: the drag of the resizer itself is the only exception,
     * because the position of it comes from the mouse while it is going on.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " BaseScroll doDimensionsChanged> called.", 1);
      stopScrollToTarget();
      super.doDimensionsChanged();
      redrawFrameShape();
      if (!resizerDragging)
      {
        reposResizer();
      }
      redrawReposScrollMaskSprite();
    }
    /**
     * Handles a bright text format change by resizing, repositioning and repainting the resizer.
     * @param e the text format bright changed event
     */
    private function textFormatBrightChanged(e:Event):void
    {
      application.trace("<" + this + " BaseScroll textFormatBrightChanged> called.", 1);
      application.trace("<" + this + " BaseScroll textFormatBrightChanged> e: " + e, 0);
      resizeResizer();
      reposResizer();
      repaintResizer();
    }
    /**
     * Resizes the resizer sprite to the current bright text field height.
     */
    private function resizeResizer():void
    {
      application.trace("<" + this + " BaseScroll resizeResizer> called.", 1);
      if (resizeSprite != null)
      {
        const textFieldHeight:int = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
        resizeSprite.setDw(textFieldHeight);
        resizeSprite.setDh(textFieldHeight);
      }
    }
    /**
     * Repositions the resizer sprite to the bottom right corner of the component.
     */
    private function reposResizer():void
    {
      application.trace("<" + this + " BaseScroll reposResizer> called.", 1);
      if (resizeSprite != null)
      {
        resizeSprite.setCx(getDw() - resizeSprite.getDw());
        resizeSprite.setCy(getDh() - resizeSprite.getDh());
      }
    }
    /**
     * Redraws the diagonal lines of the resizer handle.
     */
    private function repaintResizer():void
    {
      application.trace("<" + this + " BaseScroll repaintResizer> called.", 1);
      if (resizeSprite != null)
      {
        const drawDelta:int = 3 * application.getDynamicsConfig().getAppLineThickness();
        resizeSprite.graphics.clear();
        resizeSprite.graphics.beginFill(0, 0);
        resizeSprite.graphics.drawRect(0, 0, resizeSprite.getDw(), resizeSprite.getDh());
        resizeSprite.graphics.endFill();
        resizeSprite.graphics.lineStyle(application.getDynamicsConfig().getAppLineThickness(), application.getDynamicsConfig().getAppBackgroundColorDark());
        resizeSprite.graphics.moveTo(0 + drawDelta, resizeSprite.getDh() - drawDelta);
        resizeSprite.graphics.lineTo(resizeSprite.getDw() - drawDelta, drawDelta);
        resizeSprite.graphics.moveTo(resizeSprite.getDw() / 2 + drawDelta, resizeSprite.getDh() - drawDelta);
        resizeSprite.graphics.lineTo(resizeSprite.getDw() - drawDelta, resizeSprite.getDh() / 2 + drawDelta);
      }
    }
    /**
     * Creates the resizer sprite (if needed) and lays it out.
     * That resizer keeps every press that happens on it: it resizes this scroll by being
     * dragged, and the scrolling of the content this scroll stands in would take that
     * dragging away, because only one single object can be dragged by the mouse at a time.
     */
    private function createResizer():void
    {
      application.trace("<" + this + " BaseScroll createResizer> called.", 1);
      if (resizeSprite == null)
      {
        resizeSprite = new BaseSprite(application);
        addChild(resizeSprite);
        resizeSprite.mouseDownForScrollingEnabled = false;
        resizeSprite.addEventListener(MouseEvent.MOUSE_DOWN, resizeSpriteMouseDown);
      }
      resizeResizer();
      reposResizer();
      repaintResizer();
    }
    /**
     * Destroys and removes the resizer sprite together with its listener.
     */
    private function removeResizer():void
    {
      application.trace("<" + this + " BaseScroll removeResizer> called.", 1);
      if (resizeSprite != null)
      {
        resizeSprite.removeEventListener(MouseEvent.MOUSE_DOWN, resizeSpriteMouseDown);
        resizeSprite.destroy();
        if (contains(resizeSprite))
        {
          removeChild(resizeSprite);
        }
        resizeSprite = null;
      }
      resizerDragging = false;
    }
    /**
     * Starts dragging the resizer within the allowed bounds and hooks the stage mouse listeners.
     * @param e the mouse down event
     */
    private function resizeSpriteMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseScroll resizeSpriteMouseDown> called.", 1);
      application.trace("<" + this + " BaseScroll resizeSpriteMouseDown> e: " + e, 0);
      if (resizeSprite != null && stage != null)
      {
        resizerDragging = true;
        const globalCurrentCoordinates:Point = localToGlobal(new Point(resizeSprite.x, resizeSprite.y));
        const diffW:int = resizeSprite.x - application.getComponentsConfig().getScrollSizeMinWidth();
        const diffH:int = resizeSprite.y - application.getComponentsConfig().getScrollSizeMinHeight();
        const bounds:Rectangle = new Rectangle(
          application.getComponentsConfig().getScrollSizeMinWidth(),
          application.getComponentsConfig().getScrollSizeMinHeight(),
          stage.stageWidth - globalCurrentCoordinates.x + diffW - resizeSprite.getDw(),
          stage.stageHeight - globalCurrentCoordinates.y + diffH - resizeSprite.getDh());
        resizeSprite.startDrag(false, bounds);
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
    }
    /**
     * Applies the dragged resizer position as the new component dimensions.
     * @param e the mouse move event
     */
    private function stageMouseMove(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseScroll stageMouseMove> called.", 0);
      application.trace("<" + this + " BaseScroll stageMouseMove> e: " + e, 0);
      if (resizeSprite != null)
      {
        resizeSprite.updateCxy();
        application.trace("<" + this + " BaseScroll stageMouseMove> resizeSprite.getCx(true): " + resizeSprite.getCx(true), 0);
        application.trace("<" + this + " BaseScroll stageMouseMove> resizeSprite.getCy(true): " + resizeSprite.getCy(true), 0);
        super.setDwh(resizeSprite.getCx(true), resizeSprite.getCy(true));
        application.trace("<" + this + " BaseScroll stageMouseMove> getDw(): " + getDw(), 0);
        application.trace("<" + this + " BaseScroll stageMouseMove> getDh(): " + getDh(), 0);
      }
    }
    /**
     * Stops dragging the resizer, applies the final size and removes the stage mouse listeners.
     * @param e the mouse up event
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseScroll stageMouseUp> called.", 1);
      application.trace("<" + this + " BaseScroll stageMouseUp> e: " + e, 0);
      if (resizeSprite != null)
      {
        resizeSprite.stopDrag();
      }
      resizerDragging = false;
      stageMouseMove(null);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
    }
    /**
     * Dispatches the content cache begin event.
     */
    private function dispatchEventCacheBegin():void
    {
      application.trace("<" + this + " BaseScroll dispatchEventCacheBegin> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventContentCacheBegin);
    }
    /**
     * Calculates the target content coordinates from the center navigation deltas, honoring enabled and quantized axes.
     * The deltas are the pixels the dragging of the content covered in its very last frame,
     * so they are the speed the content has been thrown with. The target is the place that
     * speed carries the content to, so it is measured from the place the content is standing
     * at right now: a target of the bare speed would throw the content to the beginning or
     * to the end of itself, wherever it was dragged from.
     */
    private function calcTargetCoordinates():void
    {
      application.trace("<" + this + " BaseScroll calcTargetCoordinates> called.", 1);
      const deltax:int = centerNavigation.getDeltaX();
      const deltay:int = centerNavigation.getDeltaY();
      cxContentTarget = isEnabledHorizontal ? cxContent + deltax * Math.abs(deltax) : 0;
      cyContentTarget = isEnabledVertical ? cyContent + deltay * Math.abs(deltay) : 0;
      if (isQuantizedHorizontal) cxContentTarget = Math.round(cxContentTarget / getDw()) * getDw();
      if (isQuantizedVertical) cyContentTarget = Math.round(cyContentTarget / getDh()) * getDh();
    }
    /**
     * Saves the current content coordinates at the start of a center scrolling drag.
     * @param e the center scrolling start event
     */
    private function centerScrollingStart(e:Event):void
    {
      application.trace("<" + this + " BaseScroll centerScrollingStart> called.", 1);
      application.trace("<" + this + " BaseScroll centerScrollingStart> e: " + e, 0);
      cxContentSaved = cxContent;
      cyContentSaved = cyContent;
    }
    /**
     * Throws the vertical and horizontal edge events if an edge has been reached.
     */
    private function throwEdgeEventsIfNecessary():void
    {
      application.trace("<" + this + " BaseScroll throwEdgeEventsIfNecessary> called.", 1);
      throwVerticalEdgeEventsIfNecessary();
      throwHorizontalEdgeEventsIfNecessary();
    }
    /**
     * Dispatches the right or left reached event when the horizontal edge is hit.
     */
    private function throwHorizontalEdgeEventsIfNecessary():void
    {
      application.trace("<" + this + " BaseScroll throwHorizontalEdgeEventsIfNecessary> called.", 1);
      if (cxContent == getDw() - dwContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventRightReached);
      }
      else if (cxContent == 0)
      {
        getBaseEventDispatcher().dispatchEvent(eventLeftReached);
      }
    }
    /**
     * Dispatches the bottom or top reached event when the vertical edge is hit.
     */
    private function throwVerticalEdgeEventsIfNecessary():void
    {
      application.trace("<" + this + " BaseScroll throwVerticalEdgeEventsIfNecessary> called.", 1);
      if (cyContent == getDh() - dhContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventBottomReached);
      }
      else if (cyContent == 0)
      {
        getBaseEventDispatcher().dispatchEvent(eventTopReached);
      }
    }
    /**
     * Applies the ongoing center drag to the content coordinates, dispatching change and edge events and refreshing the side bars.
     * @param e the center scrolling in progress event
     */
    private function centerScrollingInProgress(e:Event):void
    {
      setContentPosition(cxContentSaved + centerNavigation.getCenterScrollingDeltaX(), cyContentSaved + centerNavigation.getCenterScrollingDeltaY(), true);
    }
    /**
     * Sets the x and y coordinates of the scrolled content
     * @param newCxContent the new x coordinate of the content
     * @param newCyContent the new y coordinate of the content
     * @param toDispatchEvents is it necessary to dispatch events to the outside
     */
    public function setContentPosition(newCxContent:int, newCyContent:int, toDispatchEvents:Boolean):void
    {
      application.trace("<" + this + " BaseScroll centerScrollingInProgress> called.", 1);
      application.trace("<" + this + " BaseScroll centerScrollingInProgress> newCxContent: " + newCxContent, 0);
      application.trace("<" + this + " BaseScroll centerScrollingInProgress> newCyContent: " + newCyContent, 0);
      application.trace("<" + this + " BaseScroll centerScrollingInProgress> toDispatchEvents: " + toDispatchEvents, 0);
      const cxContentPrev:Number = cxContent;
      // the content can be scrolled between the right edge and zero, but a content that is
      // not wider than this object has nothing to be scrolled, so it stays at zero: without
      // the lower zero the positive difference would push it away from the left edge
      cxContent = isEnabledHorizontal ? Math.max(Math.min(newCxContent, 0), Math.min(0, getDw() - dwContent)) : 0;
      if (isEnabledHorizontal && isQuantizedHorizontal)
      {
        if (cxContent != getDw() - dwContent)
        {
          cxContent = Math.round(cxContent / getDw()) * getDw();
        }
      }
      if (toDispatchEvents && cxContentPrev != cxContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventContentCxChanged);
      }
      const cyContentPrev:Number = cyContent;
      // the same the other way round: a content that is not taller than this object stays
      // at the top edge instead of being pushed down by the positive difference
      cyContent = isEnabledVertical ? Math.max(Math.min(newCyContent, 0), Math.min(0, getDh() - dhContent)) : 0;
      if (isEnabledVertical && isQuantizedVertical)
      {
        if (cyContent != getDh() - dhContent)
        {
          cyContent = Math.round(cyContent / getDh()) * getDh();
        }
      }
      if (toDispatchEvents && cyContentPrev != cyContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventContentCyChanged);
      }
      throwEdgeEventsIfNecessary();
      const factorToBeSetH:Number = calcFactorToBeSetH();
      bottomNavigation.refreshOuterFactorFromOutside(factorToBeSetH);
      topNavigation.refreshOuterFactorFromOutside(factorToBeSetH);
      const factorToBeSetV:Number = calcFactorToBeSetV();
      rightNavigation.refreshOuterFactorFromOutside(factorToBeSetV);
      leftNavigation.refreshOuterFactorFromOutside(factorToBeSetV);
      reposDummyContent();
    }
    /**
     * Handles the end of a center scrolling drag.
     * @param e the center scrolling end event
     */
    private function centerScrollingEnd(e:Event):void
    {
      application.trace("<" + this + " BaseScroll centerScrollingEnd> called.", 1);
      application.trace("<" + this + " BaseScroll centerScrollingEnd> e: " + e, 0);
    }
    /**
     * Starts the animated scroll to the calculated target by attaching the enter frame handler.
     * @param e the start scroll to target event
     */
    private function centerStartScrollToTarget(e:Event):void
    {
      application.trace("<" + this + " BaseScroll centerStartScrollToTarget> called.", 1);
      application.trace("<" + this + " BaseScroll centerStartScrollToTarget> e: " + e, 0);
      calcTargetCoordinates();
      dispatchEventCacheBegin();
      addEventListener(Event.ENTER_FRAME, enterFrameMoveContent);
    }
    /**
     * Stops the animated scroll and pins the target to the current content coordinates.
     * @param e the stop scroll to target event (optional)
     */
    private function stopScrollToTarget(e:Event = null):void
    {
      application.trace("<" + this + " BaseScroll stopScrollToTarget> called.", 1);
      application.trace("<" + this + " BaseScroll stopScrollToTarget> e: " + e, 0);
      removeEventListener(Event.ENTER_FRAME, enterFrameMoveContent);
      cxContentTarget = cxContent;
      cyContentTarget = cyContent;
    }
    /**
     * Eases the content towards the target coordinates each frame, clamping to bounds and stopping when reached.
     * @param e the enter frame event
     */
    private function enterFrameMoveContent(e:Event):void
    {
      application.trace("<" + this + " BaseScroll enterFrameMoveContent> called.", 0);
      application.trace("<" + this + " BaseScroll enterFrameMoveContent> e: " + e, 0);
      const cxContentPrev:Number = cxContent;
      const cyContentPrev:Number = cyContent;
      cxContent += (cxContentTarget - cxContent) / application.getComponentsConfig().getWeightScrollContent();
      cyContent += (cyContentTarget - cyContent) / application.getComponentsConfig().getWeightScrollContent();
      var shouldStop:Boolean = false;
      if (Math.round(cxContent) == cxContentTarget && Math.round(cyContent) == cyContentTarget)
      {
        cxContent = cxContentTarget;
        cyContent = cyContentTarget;
        shouldStop = true;
      }
      if (cxContent < getDw() - dwContent)
      {
        cxContent = getDw() - dwContent;
        shouldStop = true;
      }
      if (cxContent > 0)
      {
        cxContent = 0;
        shouldStop = true;
      }
      if (cyContent < getDh() - dhContent)
      {
        cyContent = getDh() - dhContent;
        shouldStop = true;
      }
      if (cyContent > 0)
      {
        cyContent = 0;
        shouldStop = true;
      }
      // the content is told to follow this scroll only when it really has to: a scroll that
      // stands where it has been asked to stand must not move whatever is standing in it,
      // and the one holding the widgets of a container is moved by the widget layer itself
      // in mobile mode, so a needless event of it would take those widgets away
      if (cxContentPrev != cxContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventContentCxChanged);
      }
      if (cyContentPrev != cyContent)
      {
        getBaseEventDispatcher().dispatchEvent(eventContentCyChanged);
      }
      throwEdgeEventsIfNecessary();
      const factorToBeSetH:Number = calcFactorToBeSetH();
      bottomNavigation.refreshOuterFactorFromOutside(factorToBeSetH);
      topNavigation.refreshOuterFactorFromOutside(factorToBeSetH);
      const factorToBeSetV:Number = calcFactorToBeSetV();
      rightNavigation.refreshOuterFactorFromOutside(factorToBeSetV);
      leftNavigation.refreshOuterFactorFromOutside(factorToBeSetV);
      reposDummyXContent();
      reposDummyYContent();
      if (shouldStop)
      {
        stopScrollToTarget();
      }
    }
    /**
     * Resets all scrolling state and the side bar factors back to the origin.
     */
    private function resetAll():void
    {
      application.trace("<" + this + " BaseScroll resetAll> called.", 1);
      stopScrollToTarget();
      cxContent = 0;
      cyContent = 0;
      cxContentTarget = 0;
      cyContentTarget = 0;
      bottomNavigation.refreshOuterFactorFromOutside(0);
      topNavigation.refreshOuterFactorFromOutside(0);
      rightNavigation.refreshOuterFactorFromOutside(0);
      leftNavigation.refreshOuterFactorFromOutside(0);
      reposDummyContent();
    }
    /**
     * Scrolls horizontally from the top side bar factor and syncs the bottom side bar.
     * @param e the outer factor changed event
     */
    private function topScrolling(e:Event):void
    {
      application.trace("<" + this + " BaseScroll topScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll topScrolling> e: " + e, 0);
      horizontalScrolling(topNavigation.getOuterFactor());
      bottomNavigation.refreshOuterFactorFromOutside(calcFactorToBeSetH());
    }
    /**
     * Scrolls horizontally from the bottom side bar factor and syncs the top side bar.
     * @param e the outer factor changed event
     */
    private function bottomScrolling(e:Event):void
    {
      application.trace("<" + this + " BaseScroll bottomScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll bottomScrolling> e: " + e, 0);
      horizontalScrolling(bottomNavigation.getOuterFactor());
      topNavigation.refreshOuterFactorFromOutside(calcFactorToBeSetH());
    }
    /**
     * Scrolls vertically from the left side bar factor and syncs the right side bar.
     * @param e the outer factor changed event
     */
    private function leftScrolling(e:Event):void
    {
      application.trace("<" + this + " BaseScroll leftScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll leftScrolling> e: " + e, 0);
      verticalScrolling(leftNavigation.getOuterFactor());
      rightNavigation.refreshOuterFactorFromOutside(calcFactorToBeSetV());
    }
    /**
     * Scrolls vertically from the right side bar factor and syncs the left side bar.
     * @param e the outer factor changed event
     */
    private function rightScrolling(e:Event):void
    {
      application.trace("<" + this + " BaseScroll rightScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll rightScrolling> e: " + e, 0);
      verticalScrolling(rightNavigation.getOuterFactor());
      leftNavigation.refreshOuterFactorFromOutside(calcFactorToBeSetV());
    }
    /**
     * Snaps a scroll factor to the nearest page boundary.
     * @param originalFactor the raw factor to quantize
     * @param size the visible size of the axis
     * @param contentSize the total content size of the axis
     */
    private function quantizeFactor(originalFactor:Number, size:int, contentSize:int):Number
    {
      application.trace("<" + this + " BaseScroll quantizeFactor> called.", 1);
      application.trace("<" + this + " BaseScroll quantizeFactor> originalFactor: " + originalFactor, 0);
      application.trace("<" + this + " BaseScroll quantizeFactor> size: " + size, 0);
      application.trace("<" + this + " BaseScroll quantizeFactor> contentSize: " + contentSize, 0);
      const factorPerPage:Number = size / (contentSize - size);
      return Math.round(originalFactor / factorPerPage) * factorPerPage;
    }
    /**
     * Sets the horizontal content coordinate from a factor, dispatching the change and edge events.
     * @param factor the horizontal scroll factor
     */
    private function horizontalScrolling(factor:Number):void
    {
      application.trace("<" + this + " BaseScroll horizontalScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll horizontalScrolling> factor: " + factor, 0);
      // a content that is not wider than this object has nothing to be scrolled, so it
      // stays at the left edge: the factor of the side bar means nothing there, and the
      // positive difference would push that content away from that edge
      if (dwContent <= getDw())
      {
        cxContent = 0;
      }
      else if (isQuantizedHorizontal)
      {
        cxContent = Math.max(Math.min(-quantizeFactor(factor, getDw(), dwContent) * (dwContent - getDw()), 0), getDw() - dwContent);
      }
      else
      {
        cxContent = Math.max(Math.min(-factor * (dwContent - getDw()), 0), getDw() - dwContent);
      }
      getBaseEventDispatcher().dispatchEvent(eventContentCxChanged);
      throwHorizontalEdgeEventsIfNecessary();
      reposDummyXContent();
    }
    /**
     * Sets the vertical content coordinate from a factor, dispatching the change and edge events.
     * @param factor the vertical scroll factor
     */
    private function verticalScrolling(factor:Number):void
    {
      application.trace("<" + this + " BaseScroll verticalScrolling> called.", 1);
      application.trace("<" + this + " BaseScroll verticalScrolling> factor: " + factor, 0);
      // the same the other way round: a content that is not taller than this object stays
      // at the top edge instead of being pushed down by the positive difference
      if (dhContent <= getDh())
      {
        cyContent = 0;
      }
      else if (isQuantizedVertical)
      {
        cyContent = Math.max(Math.min(-quantizeFactor(factor, getDh(), dhContent) * (dhContent - getDh()), 0), getDh() - dhContent);
      }
      else
      {
        cyContent = Math.max(Math.min(-factor * (dhContent - getDh()), 0), getDh() - dhContent);
      }
      getBaseEventDispatcher().dispatchEvent(eventContentCyChanged);
      throwVerticalEdgeEventsIfNecessary();
      reposDummyYContent();
    }
    /**
     * Handles a line thickness change by redrawing the frame and the mask, and repainting the resizer.
     * @param e the line thickness changed event
     */
    private function lineThicknessChanged(e:Event):void
    {
      application.trace("<" + this + " BaseScroll lineThicknessChanged> called.", 1);
      application.trace("<" + this + " BaseScroll lineThicknessChanged> e: " + e, 0);
      redrawFrameShape();
      redrawReposScrollMaskSprite();
      repaintResizer();
    }
    /**
     * Handles a box corner or frame change by redrawing the frame.
     * @param e the box changed event
     */
    private function boxChanged(e:Event):void
    {
      application.trace("<" + this + " BaseScroll boxChanged> called.", 1);
      application.trace("<" + this + " BaseScroll boxChanged> e: " + e, 0);
      redrawFrameShape();
    }
    /**
     * Handles a radius change by redrawing the frame.
     * @param e the radius changed event
     */
    private function radiusChanged(e:Event):void
    {
      application.trace("<" + this + " BaseScroll radiusChanged> called.", 1);
      application.trace("<" + this + " BaseScroll radiusChanged> e: " + e, 0);
      redrawFrameShape();
      redrawReposScrollMaskSprite();
    }
    /**
     * Handles a background color change by redrawing the frame and repainting the resizer.
     * @param e the background color changed event
     */
    private function backgroundColorsChanged(e:Event):void
    {
      application.trace("<" + this + " BaseScroll backgroundColorsChanged> called.", 1);
      application.trace("<" + this + " BaseScroll backgroundColorsChanged> e: " + e, 0);
      redrawFrameShape();
      repaintResizer();
    }
    /**
     * Redraws the frame shape with the current colors, radius, box and dimensions.
     */
    private function redrawFrameShape():void
    {
      application.trace("<" + this + " BaseScroll redrawFrameShape> called.", 1);
      shapeFrame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , shapeFrameBackgroundAlpha
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      shapeFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      shapeFrame.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
      shapeFrame.setDwh(getDw(), getDh());
      shapeFrame.drawRect();
    }
    /**
     * Redraws the mask of this scroll.
     * It is inset by the line thickness on every side, so the frame line around it stays visible.
     */
    private function redrawReposScrollMaskSprite():void
    {
      application.trace("<" + this + " BaseScroll redrawReposScrollMaskSprite> called.", 1);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      scrollMaskSprite.setCxy(lineThickness, lineThickness);
      scrollMaskSprite.setDwh(getDw() - 2 * lineThickness, getDh() - 2 * lineThickness);
      scrollMaskSprite.graphics.clear();
      scrollMaskSprite.graphics.beginFill(0, 0);
      scrollMaskSprite.graphics.drawRoundRect(0, 0, scrollMaskSprite.getDw(), scrollMaskSprite.getDh(), application.getDynamicsConfig().getAppRadius());
      scrollMaskSprite.graphics.endFill();
    }
    /**
     * Repaints the dummy content shape with the current colors, radius, box and content dimensions.
     */
    private function repaintDummyContent():void
    {
      application.trace("<" + this + " BaseScroll repaintDummyContent> called.", 1);
      if (dummyContent != null)
      {
        dummyContent.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
            , application.getDynamicsConfig().getAppBackgroundColorDark()
            , application.getDynamicsConfig().getAppBackgroundColorMid()
            , 0
            , application.getDynamicsConfig().getAppBackgroundColorBright());
        dummyContent.setRadius(application.getDynamicsConfig().getAppRadius());
        dummyContent.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
        dummyContent.setDwh(getDwContent(), getDhContent());
        dummyContent.drawRect();
      }
    }
    /**
     * Repositions the dummy content along the horizontal axis to the current content coordinate.
     */
    private function reposDummyXContent():void
    {
      application.trace("<" + this + " BaseScroll reposDummyXContent> called.", 1);
      if (dummyContent != null)
      {
        dummyContent.x = cxContent;
      }
    }
    /**
     * Repositions the dummy content along the vertical axis to the current content coordinate.
     */
    private function reposDummyYContent():void
    {
      application.trace("<" + this + " BaseScroll reposDummyYContent> called.", 1);
      if (dummyContent != null)
      {
        dummyContent.y = cyContent;
      }
    }
    /**
     * Repositions the dummy content along both axes.
     */
    private function reposDummyContent():void
    {
      application.trace("<" + this + " BaseScroll reposDummyContent> called.", 1);
      reposDummyXContent();
      reposDummyYContent();
    }
    /**
     * Frees all listeners, events and references held by this scroll.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseScroll destroy> called.", 1);
      application.trace("<" + this + " BaseScroll destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), boxChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), boxChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorsChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
      if (resizeSprite != null)
      {
        resizeSprite.removeEventListener(MouseEvent.MOUSE_DOWN, resizeSpriteMouseDown);
      }
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
      }
      removeEventListener(Event.ENTER_FRAME, enterFrameMoveContent);
      application.trace("<" + this + " BaseScroll destroy> remove every child object if there are any (necessary only in BaseScroll).", 0);
      application.trace("<" + this + " BaseScroll destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventContentDwChanged.stopImmediatePropagation();
      eventContentDhChanged.stopImmediatePropagation();
      eventContentCxChanged.stopImmediatePropagation();
      eventContentCyChanged.stopImmediatePropagation();
      eventEnabledVerticalChanged.stopImmediatePropagation();
      eventEnabledHorizontalChanged.stopImmediatePropagation();
      eventQuantizedVerticalChanged.stopImmediatePropagation();
      eventQuantizedHorizontalChanged.stopImmediatePropagation();
      eventContentCacheBegin.stopImmediatePropagation();
      eventTopReached.stopImmediatePropagation();
      eventBottomReached.stopImmediatePropagation();
      eventLeftReached.stopImmediatePropagation();
      eventRightReached.stopImmediatePropagation();
      application.trace("<" + this + " BaseScroll destroy> calling the super destroy (necessary only not in BaseScroll) and clearing everything.", 0);
      super.destroy();
      shapeFrame = null;
      centerNavigation = null;
      topNavigation = null;
      bottomNavigation = null;
      leftNavigation = null;
      rightNavigation = null;
      resizeSprite = null;
      resizerDragging = false;
      scrollMaskSprite = null;
      dwContent = 0;
      dhContent = 0;
      cxContent = 0;
      cyContent = 0;
      cxContentSaved = 0;
      cyContentSaved = 0;
      eventContentDwChanged = null;
      eventContentDhChanged = null;
      eventContentCxChanged = null;
      eventContentCyChanged = null;
      isEnabledHorizontal = false;
      isEnabledVertical = false;
      isQuantizedHorizontal = false;
      isQuantizedVertical = false;
      isCenterOnly = false;
      eventEnabledVerticalChanged = null;
      eventEnabledHorizontalChanged = null;
      eventQuantizedVerticalChanged = null;
      eventQuantizedHorizontalChanged = null;
      isScrolled = false;
      eventContentCacheBegin = null;
      eventTopReached = null;
      eventBottomReached = null;
      eventLeftReached = null;
      eventRightReached = null;
      dummyContent = null;
      content = null;
      cxContentTarget = 0;
      cyContentTarget = 0;
      shapeFrameBackgroundAlpha = 0;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
/** Navigation: base of the scroll's navigation helpers; manages the draggable spriteMover and its mouse handling. */
internal class Navigation extends BaseSprite
{
  protected var scroll:BaseScroll = null;
  protected var textFieldHeight:int = 1;
  protected var spriteMover:BaseSprite = null;
  protected var prevMoverX:int = 0;
  protected var prevMoverY:int = 0;
  protected var deltaX:int = 0;
  protected var deltaY:int = 0;
  protected var moverDragging:Boolean = false;
  protected var eventStartScrollToTarget:Event = null;
  protected var eventStopScrollToTarget:Event = null;
  /**
   * Constructs the navigation: builds the draggable mover and its scroll-to-target events, then hooks the mouse over listener.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function Navigation(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " Navigation> called.", 1);
    application.trace("<" + this + " Navigation> applicationRef: " + applicationRef, 0);
    updateTextFieldHeight();
    eventStartScrollToTarget = new Event(EnumEvents.EVENT_START_SCROLL_TO_TARGET());
    eventStopScrollToTarget = new Event(EnumEvents.EVENT_STOP_SCROLL_TO_TARGET());
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
    spriteMover = new BaseSprite(application);
    addChild(spriteMover);
    spriteMover.addEventListener(MouseEvent.MOUSE_OVER, spriteMoverMouseOver);
    application.trace("<" + this + " Navigation> constructed.", 1);
  }
  /**
   * Returns the horizontal drag delta captured for the scroll-to-target animation.
   */
  public function getDeltaX():int
  {
    return deltaX;
  }
  /**
   * Returns the vertical drag delta captured for the scroll-to-target animation.
   */
  public function getDeltaY():int
  {
    return deltaY;
  }
  /**
   * Stores the scroll reference and listens for its dimension changes.
   * @param scrollRef the owning scroll to bind to
   */
  public function setScrollRef(scrollRef:BaseScroll):void
  {
    application.trace("<" + this + " Navigation setScrollRef> called.", 1);
    application.trace("<" + this + " Navigation setScrollRef> scrollRef: " + scrollRef, 0);
    scroll = scrollRef;
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), scrollDimensionsChanged);
    scrollDimensionsChanged(null);
  }
  /**
   * Saves the previous mover position each frame while dragging.
   * @param e the enter frame event
   */
  protected function enterFrameSaveSpriteMoverPos(e:Event):void
  {
    application.trace("<" + this + " Navigation enterFrameSaveSpriteMoverPos> called.", 0);
    application.trace("<" + this + " Navigation enterFrameSaveSpriteMoverPos> e: " + e, 0);
    prevMoverX = spriteMover.x;
    prevMoverY = spriteMover.y;
  }
  /**
   * Moves the draggable mover to the top of the child display list.
   */
  protected function moverToTheHighestDepth():void
  {
    application.trace("<" + this + " Navigation moverToTheHighestDepth> called.", 1);
    setChildIndex(spriteMover, numChildren - 1);
  }
  /**
   * Recalculates the dimensions of the navigation; overridden by subclasses.
   * @param e the triggering event
   */
  protected function setNewDimensions(e:Event):void
  {
    application.trace("<" + this + " Navigation setNewDimensions> called.", 1);
    application.trace("<" + this + " Navigation setNewDimensions> e: " + e, 0);
  }
  /**
   * Recalculates the coordinates of the navigation; overridden by subclasses.
   * @param e the triggering event
   */
  protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " Navigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " Navigation setNewCoordinates> e: " + e, 0);
  }
  /**
   * Recomputes the text field height and refreshes dimensions and coordinates when the font size changes.
   * @param e the font size changed event
   */
  protected function fontSizeChanged(e:Event):void
  {
    application.trace("<" + this + " Navigation fontSizeChanged> called.", 1);
    application.trace("<" + this + " Navigation fontSizeChanged> e: " + e, 0);
    updateTextFieldHeight();
    setNewDimensions(e);
    setNewCoordinates(e);
  }
  /**
   * Updates the cached bright text field height from the dynamics config.
   */
  protected function updateTextFieldHeight():void
  {
    application.trace("<" + this + " Navigation updateTextFieldHeight> called.", 1);
    textFieldHeight = application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT());
  }
  /**
   * Arms the drag listeners on first mouse over so the mover becomes interactive.
   * @param e the mouse over event
   */
  protected function spriteMoverMouseOver(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation spriteMoverMouseOver> called.", 1);
    application.trace("<" + this + " Navigation spriteMoverMouseOver> e: " + e, 0);
    if (e == null)
    {
      return;
    }
    if (spriteMover.hasEventListener(MouseEvent.MOUSE_WHEEL))
    {
      return;
    }
    spriteMover.removeEventListener(MouseEvent.MOUSE_OVER, spriteMoverMouseOver);
    spriteMover.addEventListener(MouseEvent.MOUSE_OUT, spriteMoverMouseOut);
    spriteMover.addEventListener(MouseEvent.MOUSE_DOWN, spriteMoverMouseDown);
    spriteMover.addEventListener(MouseEvent.MOUSE_WHEEL, spriteMoverMouseWheel);
    if (e != null)
    {
      e.updateAfterEvent();
    }
  }
  /**
   * Disarms the drag listeners when the pointer leaves the mover without a button held.
   * @param e the mouse out event
   */
  protected function spriteMoverMouseOut(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation spriteMoverMouseOut> called.", 1);
    application.trace("<" + this + " Navigation spriteMoverMouseOut> e: " + e, 0);
    if (e == null)
    {
      return;
    }
    if (e.buttonDown)
    {
      return;
    }
    spriteMover.addEventListener(MouseEvent.MOUSE_OVER, spriteMoverMouseOver);
    spriteMover.removeEventListener(MouseEvent.MOUSE_OUT, spriteMoverMouseOut);
    spriteMover.removeEventListener(MouseEvent.MOUSE_DOWN, spriteMoverMouseDown);
    spriteMover.removeEventListener(MouseEvent.MOUSE_WHEEL, spriteMoverMouseWheel);
    if (e != null)
    {
      e.updateAfterEvent();
    }
  }
  /**
   * Removes the stage mouse listeners when the navigation is removed from the stage.
   * @param e the removed from stage event
   */
  override protected function removedFromStage(e:Event):void
  {
    application.trace("<" + this + " Navigation removedFromStage> called.", 1);
    application.trace("<" + this + " Navigation removedFromStage> e: " + e, 0);
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpSpriteMover);
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveSpriteMover);
    }
    super.removedFromStage(e);
  }
  /**
   * Begins a mover drag, hooking the stage listeners and marking the scroll as scrolled.
   * @param e the mouse down event
   */
  protected function spriteMoverMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation spriteMoverMouseDown> called.", 1);
    application.trace("<" + this + " Navigation spriteMoverMouseDown> e: " + e, 0);
    getBaseEventDispatcher().dispatchEvent(eventStopScrollToTarget);
    resetScrollToTarget();
    if (!scroll.getScrolled())
    {
      scroll.setScrolled(true);
      moverDragging = true;
      addEventListener(Event.ENTER_FRAME, enterFrameSaveSpriteMoverPos);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpSpriteMover);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveSpriteMover);
      }
      if (scroll.alpha == 1)
      {
        spriteMover.startDrag();
      }
    }
  }
  /**
   * Ends a mover drag, dispatches the scroll-to-target start event when free scrolling moved the mover, and repositions it.
   * @param e the mouse up event
   */
  protected function stageMouseUpSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation stageMouseUpSpriteMover> called.", 1);
    application.trace("<" + this + " Navigation stageMouseUpSpriteMover> e: " + e, 0);
    scroll.setScrolled(false);
    moverDragging = false;
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpSpriteMover);
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveSpriteMover);
    }
    removeEventListener(Event.ENTER_FRAME, enterFrameSaveSpriteMoverPos);
    if ((spriteMover.x != prevMoverX || spriteMover.y != prevMoverY)
     && !scroll.getQuantizedHorizontal() && !scroll.getQuantizedVertical()
    )
    {
      deltaX = spriteMover.x - prevMoverX;
      deltaY = spriteMover.y - prevMoverY;
      getBaseEventDispatcher().dispatchEvent(eventStartScrollToTarget);
    }
    spriteMoverRepos();
    if (e != null)
    {
      e.updateAfterEvent();
    }
  }
  /**
   * Handles a mover drag move; overridden by subclasses to apply scrolling.
   * @param e the mouse move event
   */
  protected function stageMouseMoveSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation stageMouseMoveSpriteMover> called.", 0);
    application.trace("<" + this + " Navigation stageMouseMoveSpriteMover> e: " + e, 0);
    if (e != null)
    {
      e.updateAfterEvent();
    }
  }
  /**
   * Stops the mover drag and snaps the mover back to the origin.
   */
  protected function spriteMoverRepos():void
  {
    application.trace("<" + this + " Navigation spriteMoverRepos> called.", 1);
    spriteMover.stopDrag();
    spriteMover.updateCxy();
    spriteMover.setCxy(0, 0);
  }
  /**
   * Handles a mover mouse wheel; overridden by subclasses.
   * @param e the mouse wheel event
   */
  protected function spriteMoverMouseWheel(e:MouseEvent):void
  {
    application.trace("<" + this + " Navigation spriteMoverMouseWheel> called.", 1);
    application.trace("<" + this + " Navigation spriteMoverMouseWheel> e: " + e, 0);
  }
  /**
   * Clears the captured drag deltas used for the scroll-to-target animation.
   */
  private function resetScrollToTarget():void
  {
    application.trace("<" + this + " Navigation resetScrollToTarget> called.", 1);
    deltaX = 0;
    deltaY = 0;
  }
  /**
   * Recalculates the navigation dimensions and coordinates when the scroll dimensions change.
   * @param e the dimensions changed event
   */
  private function scrollDimensionsChanged(e:Event):void
  {
    application.trace("<" + this + " Navigation scrollDimensionsChanged> called.", 1);
    application.trace("<" + this + " Navigation scrollDimensionsChanged> e: " + e, 0);
    setNewDimensions(e);
    setNewCoordinates(e);
  }
  /**
   * Frees all listeners, events and references held by this navigation.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " Navigation destroy> called.", 1);
    application.trace("<" + this + " Navigation destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), fontSizeChanged);
    spriteMover.removeEventListener(MouseEvent.MOUSE_OVER, spriteMoverMouseOver);
    spriteMover.removeEventListener(MouseEvent.MOUSE_OUT, spriteMoverMouseOut);
    spriteMover.removeEventListener(MouseEvent.MOUSE_DOWN, spriteMoverMouseDown);
    spriteMover.removeEventListener(MouseEvent.MOUSE_WHEEL, spriteMoverMouseWheel);
    scroll.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), scrollDimensionsChanged);
    removeEventListener(Event.ENTER_FRAME, enterFrameSaveSpriteMoverPos);
    if (stage != null)
    {
      stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpSpriteMover);
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveSpriteMover);
    }
    application.trace("<" + this + " Navigation destroy> remove every child object if there are any (necessary only in Navigation).", 0);
    application.trace("<" + this + " Navigation destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    spriteMover.stopDrag();
    eventStartScrollToTarget.stopImmediatePropagation();
    eventStopScrollToTarget.stopImmediatePropagation();
    application.trace("<" + this + " Navigation destroy> calling the super destroy (necessary only not in Navigation) and clearing everything.", 0);
    super.destroy();
    scroll = null;
    textFieldHeight = 0;
    spriteMover = null;
    prevMoverX = 0;
    prevMoverY = 0;
    deltaX = 0;
    deltaY = 0;
    eventStartScrollToTarget = null;
    eventStopScrollToTarget = null;
  }
}
/** SideNavigation: base of the side bars; manages the fill/mask/cover sprites, the outer factor and the page icons. */
internal class SideNavigation extends Navigation
{
  protected var isNaturalScrolling:Boolean = false;
  protected var numOfIcons:int = 0;
  protected var spriteFill:BaseSprite = null;
  protected var spriteMask:BaseSprite = null;
  protected var spriteCover:BaseSprite = null;
  protected var innerFillGradientSize:int = 0;
  protected var innerFactor:Number = 1;
  protected var outerFactor:Number = 0; // 0 -> 1. 0: content coordinate is 0 -> 1: content coordinate is size - contentSize
  protected var eventOuterFactorChanged:Event = null;
  protected var savedFillPos:Number = 0;
  protected var factorPerRowOrCol:Number = 0;
  protected var circleR:int = 1;
  protected var circleX:int = 1;
  protected var circleY:int = 1;
  /**
   * Constructs the side bar: builds the fill, mask and cover sprites, wires the color listeners and resets the outer factor.
   * @param applicationRef the application reference passed to the base sprite
   * @param isNaturalScrolling whether the bar scrolls in the natural (inverted) direction
   */
  public function SideNavigation(applicationRef:Application, isNaturalScrolling:Boolean):void
  {
    super(applicationRef);
    application.trace("<" + this + " SideNavigation> called.", 1);
    application.trace("<" + this + " SideNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " SideNavigation> isNaturalScrolling: " + isNaturalScrolling, 0);
    this.isNaturalScrolling = isNaturalScrolling;
    eventOuterFactorChanged = new Event(EnumEvents.EVENT_OUTER_FACTOR_CHANGED());
    spriteFill = new BaseSprite(application);
    addChild(spriteFill);
    spriteMask = new BaseSprite(application);
    addChild(spriteMask);
    spriteFill.mask = spriteMask;
    spriteCover = new BaseSprite(application);
    addChild(spriteCover);
    moverToTheHighestDepth();
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorDarkChanged);
    application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChanged);
    refreshOuterFactorFromOutside(0);
    application.trace("<" + this + " SideNavigation> constructed.", 1);
  }
  /**
   * Shows or hides this bar by the alpha of its fill and cover sprites, so that it keeps
   * taking the mouse even while it is not displayed.
   * @param b true when this bar has to be hidden
   */
  public function hideNavigation(b:Boolean):void
  {
    application.trace("<" + this + " SideNavigation hideNavigation> called.", 1);
    application.trace("<" + this + " SideNavigation hideNavigation> b: " + b, 0);
    spriteFill.alpha = b ? 0 : 1;
    spriteCover.alpha = b ? 0 : 1;
  }
  /**
   * Tells whether this bar is a hidden one.
   */
  public function isHiddenNavigation():Boolean
  {
    return spriteFill.alpha == 0;
  }
  /**
   * Hides this bar and lets the mouse through it, or gives it back to the mouse.
   * The center area of the scroll is standing over the whole surface of it while this bar
   * is covered, and a bar of a zero alpha would still take every press of that area away
   * from it, because the mouse is stopped by the topmost object it finds under itself and
   * an alpha of zero is not an answer to it: only a hidden or a mouse free object is let
   * through, so this bar has to give the mouse up as well and not only its drawing.
   * @param b true when this bar is covered by the center area of the scroll
   */
  public function coverByCenter(b:Boolean):void
  {
    application.trace("<" + this + " SideNavigation coverByCenter> called.", 1);
    application.trace("<" + this + " SideNavigation coverByCenter> b: " + b, 0);
    hideNavigation(b);
    mouseEnabled = !b;
    mouseChildren = !b;
  }
  /**
   * Sets the outer factor from an external source, unless the mover of this bar is being
   * dragged right now. The saved fill position is the origin that drag is measured from, and
   * the mover keeps the offset it has collected since the drag began, so an outside change
   * of that origin would add the old offset to a new base: the bar would jump to an end and
   * would stay pinned there until the drag is dragged back over its whole collected distance.
   * @param newOuterFactor the new outer factor
   */
  public function refreshOuterFactorFromOutside(newOuterFactor:Number):void
  {
    application.trace("<" + this + " SideNavigation refreshOuterFactorFromOutside> called.", 1);
    application.trace("<" + this + " SideNavigation refreshOuterFactorFromOutside> newOuterFactor: " + newOuterFactor, 0);
    if (moverDragging)
    {
      application.trace("<" + this + " SideNavigation refreshOuterFactorFromOutside> the mover is being dragged, not touching the origin of it.", 1);
      return;
    }
    outerFactor = Math.max(0, Math.min(1, newOuterFactor));
    resaveFillPos();
  }
  /**
   * Returns the current outer factor.
   */
  public function getOuterFactor():Number
  {
    return outerFactor;
  }
  /**
   * Recreates the page icons when the enabled state changes.
   * @param e the enabled changed event
   */
  protected function isEnabledChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation isEnabledChanged> called.", 1);
    application.trace("<" + this + " SideNavigation isEnabledChanged> e: " + e, 0);
    recreateIcons();
  }
  /**
   * Recreates the page icons when the quantized state changes.
   * @param e the quantized changed event
   */
  protected function isQuantizedChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation isQuantizedChanged> called.", 1);
    application.trace("<" + this + " SideNavigation isQuantizedChanged> e: " + e, 0);
    recreateIcons();
  }
  /**
   * Recalculates the factor represented by a single row or column; overridden by subclasses.
   */
  protected function recalcFactorPerRowOrCol():void
  {
    application.trace("<" + this + " SideNavigation recalcFactorPerRowOrCol> called.", 1);
  }
  /**
   * Updates the text field height and refreshes the outer factor and the per row or column factor.
   */
  override protected function updateTextFieldHeight():void
  {
    application.trace("<" + this + " SideNavigation updateTextFieldHeight> called.", 1);
    super.updateTextFieldHeight();
    refreshOuterFactorFromOutside(outerFactor);
    recalcFactorPerRowOrCol();
  }
  /**
   * Clamps and stores the outer factor, then dispatches the outer factor changed event.
   * @param newOuterFactor the new outer factor
   */
  protected function refreshOuterFactor(newOuterFactor:Number):void
  {
    application.trace("<" + this + " SideNavigation refreshOuterFactor> called.", 1);
    application.trace("<" + this + " SideNavigation refreshOuterFactor> newOuterFactor: " + newOuterFactor, 0);
    outerFactor = Math.max(0, Math.min(1, newOuterFactor));
    getBaseEventDispatcher().dispatchEvent(eventOuterFactorChanged);
  }
  /**
   * Saves the fill sprite position from the outer factor; overridden by subclasses.
   */
  protected function resaveFillPos():void
  {
    application.trace("<" + this + " SideNavigation resaveFillPos> called.", 1);
  }
  /**
   * Recalculates the inner factor; overridden by subclasses.
   */
  protected function recalcInnerFactor():void
  {
    application.trace("<" + this + " SideNavigation recalcInnerFactor> called.", 1);
  }
  /**
   * Redraws the gradient fill; overridden by subclasses.
   * @param e the triggering event
   */
  protected function redrawFill(e:Event):void
  {
    application.trace("<" + this + " SideNavigation redrawFill> called.", 1);
    application.trace("<" + this + " SideNavigation redrawFill> e: " + e, 0);
  }
  /**
   * Redraws the fill and refreshes the outer factor when the dimensions change.
   * @param e the triggering event
   */
  override protected function setNewDimensions(e:Event):void
  {
    application.trace("<" + this + " SideNavigation setNewDimensions> called.", 1);
    application.trace("<" + this + " SideNavigation setNewDimensions> e: " + e, 0);
    super.setNewDimensions(e);
    redrawFill(e);
    refreshOuterFactorFromOutside(outerFactor);
  }
  /**
   * Redraws the fill and recalculates the inner factor when the font size changes.
   * @param e the font size changed event
   */
  override protected function fontSizeChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation fontSizeChanged> called.", 1);
    application.trace("<" + this + " SideNavigation fontSizeChanged> e: " + e, 0);
    super.fontSizeChanged(e);
    redrawFill(e);
    recalcInnerFactor();
  }
  /**
   * Recreates the page icons: clears the mask and cover graphics and prepares their line styles.
   */
  protected function recreateIcons():void
  {
    application.trace("<" + this + " SideNavigation recreateIcons> called.", 1);
    circleR = textFieldHeight * 0.225;
    circleX = textFieldHeight / 2;
    circleY = textFieldHeight / 2;
    spriteMask.graphics.clear();
    spriteCover.graphics.clear();
    spriteMask.graphics.lineStyle(application.getDynamicsConfig().getAppLineThickness(), application.getDynamicsConfig().getAppBackgroundColorDark());
    spriteCover.graphics.lineStyle(application.getDynamicsConfig().getAppLineThickness(), application.getDynamicsConfig().getAppBackgroundColorDark(), 0.5);
  }
  /**
   * Returns the number of pages that fit the content for the given axis size.
   * @param size the visible size of the axis
   * @param contentSize the total content size of the axis
   */
  protected function calcPagesCount(size:int, contentSize:int):int
  {
    application.trace("<" + this + " SideNavigation calcPagesCount> called.", 1);
    application.trace("<" + this + " SideNavigation calcPagesCount> size: " + size, 0);
    application.trace("<" + this + " SideNavigation calcPagesCount> contentSize: " + contentSize, 0);
    return Math.max(contentSize % size == 0 ? contentSize / size : Math.floor(contentSize / size) + 1, 0);
  }
  /**
   * Calculates and stores the number of page icons to display based on the enabled and quantized state.
   * @param size the visible size of the axis
   * @param contentSize the total content size of the axis
   * @param isEnabled whether the axis scrolling is enabled
   * @param isQuantized whether the axis scrolling is quantized
   */
  protected function calcNumOfIcons(size:int, contentSize:int, isEnabled:Boolean, isQuantized:Boolean):void
  {
    application.trace("<" + this + " SideNavigation calcNumOfIcons> called.", 1);
    application.trace("<" + this + " SideNavigation calcNumOfIcons> size: " + size, 0);
    application.trace("<" + this + " SideNavigation calcNumOfIcons> contentSize: " + contentSize, 0);
    application.trace("<" + this + " SideNavigation calcNumOfIcons> isEnabled: " + isEnabled, 0);
    application.trace("<" + this + " SideNavigation calcNumOfIcons> isQuantized: " + isQuantized, 0);
    var num:int = 0;
    if (isEnabled)
    {
      const pagesCount:int = calcPagesCount(size, contentSize);
      if (isQuantized)
      {
        num = pagesCount;
      }
      else
      {
        num = Math.max(Math.min(pagesCount, Math.floor((size - 2 * textFieldHeight) / textFieldHeight)), 1);
      }
    }
    else
    {
      num = 0;
    }
    numOfIcons = num;
    application.trace("<" + this + " SideNavigation calcNumOfIcons> numOfIcons: " + numOfIcons, 0);
  }
  /**
   * Returns the position of the icon at the given index within the navigation area.
   * @param i the icon index
   * @param size the visible size of the axis
   */
  protected function calcIconPosByIndexToNavigationArea(i:int, size:int):int
  {
    application.trace("<" + this + " SideNavigation calcIconPosByIndexToNavigationArea> called.", 1);
    application.trace("<" + this + " SideNavigation calcIconPosByIndexToNavigationArea> i: " + i, 0);
    application.trace("<" + this + " SideNavigation calcIconPosByIndexToNavigationArea> size: " + size, 0);
    if (i < 0 || i > numOfIcons)
    {
      application.trace("<" + this + " SideNavigation calcIconPosByIndexToNavigationArea> invalid index!", 6);
      return 0;
    }
    var delta:Number = textFieldHeight;
    var firstCoordinate:int = Math.floor((size - textFieldHeight * numOfIcons) / 2);
    if (firstCoordinate < textFieldHeight)
    {
      firstCoordinate = textFieldHeight;
      if (numOfIcons > 1)
      {
        delta = (size - 3 * textFieldHeight) / (numOfIcons - 1);
      }
    }
    const pos:int = firstCoordinate + delta * i - textFieldHeight;
    application.trace("<" + this + " SideNavigation calcIconPosByIndexToNavigationArea> pos: " + pos, 0);
    return pos;
  }
  /**
   * Scrolls the content by the mouse wheel, honoring the natural scrolling direction.
   * @param e the mouse wheel event
   */
  override protected function spriteMoverMouseWheel(e:MouseEvent):void
  {
    application.trace("<" + this + " SideNavigation spriteMoverMouseWheel> called.", 1);
    application.trace("<" + this + " SideNavigation spriteMoverMouseWheel> e: " + e, 0);
    super.spriteMoverMouseWheel(e);
    if (scroll.alpha == 1)
    {
      const p:Boolean = ((e.delta > 0 && !isNaturalScrolling) || (e.delta < 0 && isNaturalScrolling));
      const factorDelta:Number = factorPerRowOrCol * (p ? 1 : -1) * Math.abs(e.delta);
      refreshOuterFactor(outerFactor + factorDelta);
      resaveFillPos();
    }
  }
  /**
   * Recreates the page icons when the bright background color changes.
   * @param e the background color bright changed event
   */
  private function backgroundColorBrightChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation backgroundColorBrightChanged> called.", 1);
    application.trace("<" + this + " SideNavigation backgroundColorBrightChanged> e: " + e, 0);
    redrawFill(e);
  }
  /**
   * Recreates the page icons when the line thickness changes.
   * @param e the line thickness changed event
   */
  private function lineThicknessChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation lineThicknessChanged> called.", 1);
    application.trace("<" + this + " SideNavigation lineThicknessChanged> e: " + e, 0);
    recreateIcons();
  }
  /**
   * Recreates the page icons when the dark background color changes.
   * @param e the background color dark changed event
   */
  private function backgroundColorDarkChanged(e:Event):void
  {
    application.trace("<" + this + " SideNavigation backgroundColorDarkChanged> called.", 1);
    application.trace("<" + this + " SideNavigation backgroundColorDarkChanged> e: " + e, 0);
    recreateIcons();
  }
  /**
   * Frees all listeners, events and references held by this side navigation.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " SideNavigation destroy> called.", 1);
    application.trace("<" + this + " SideNavigation destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), backgroundColorDarkChanged);
    application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChanged);
    application.trace("<" + this + " SideNavigation destroy> remove every child object if there are any (necessary only in SideNavigation).", 0);
    application.trace("<" + this + " SideNavigation destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    eventOuterFactorChanged.stopImmediatePropagation();
    application.trace("<" + this + " SideNavigation destroy> calling the super destroy (necessary only not in SideNavigation) and clearing everything.", 0);
    super.destroy();
    isNaturalScrolling = false;
    numOfIcons = 0;
    spriteFill = null;
    spriteMask = null;
    spriteCover = null;
    innerFillGradientSize = 0;
    innerFactor = 1;
    outerFactor = 0;
    eventOuterFactorChanged = null;
    savedFillPos = 0;
    factorPerRowOrCol = 0;
    circleR = 0;
    circleX = 0;
    circleY = 0;
  }
}
/** HorizontalNavigation: side bar that scrolls the content horizontally. */
internal class HorizontalNavigation extends SideNavigation
{
  /**
   * Constructs the horizontal side bar.
   * @param applicationRef the application reference passed to the base sprite
   * @param isNaturalScrolling whether the bar scrolls in the natural (inverted) direction
   */
  public function HorizontalNavigation(applicationRef:Application, isNaturalScrolling:Boolean):void
  {
    super(applicationRef, isNaturalScrolling);
    application.trace("<" + this + " HorizontalNavigation> called.", 1);
    application.trace("<" + this + " HorizontalNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " HorizontalNavigation> isNaturalScrolling: " + isNaturalScrolling, 0);
    application.trace("<" + this + " HorizontalNavigation> constructed.", 1);
  }
  /**
   * Binds to the scroll and listens for its horizontal content, quantized and enabled changes.
   * @param scrollRef the owning scroll to bind to
   */
  override public function setScrollRef(scrollRef:BaseScroll):void
  {
    application.trace("<" + this + " HorizontalNavigation setScrollRef> called.", 1);
    application.trace("<" + this + " HorizontalNavigation setScrollRef> scrollRef: " + scrollRef, 0);
    super.setScrollRef(scrollRef);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_DW_CHANGED(), contentDwChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CX_CHANGED(), contentCxChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_QUANTIZED_HORIZONTAL_CHANGED(), isQuantizedChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_ENABLED_HORIZONTAL_CHANGED(), isEnabledChanged);
  }
  /**
   * Recalculates the factor represented by a single column from the content width.
   */
  override protected function recalcFactorPerRowOrCol():void
  {
    application.trace("<" + this + " HorizontalNavigation recalcFactorPerRowOrCol> called.", 1);
    if (scroll != null)
    {
      factorPerRowOrCol = textFieldHeight / scroll.getDwContent();
    }
  }
  /**
   * Positions the fill sprite horizontally from the outer factor and saves that position.
   */
  override protected function resaveFillPos():void
  {
    application.trace("<" + this + " HorizontalNavigation resaveFillPos> called.", 1);
    if (spriteFill != null)
    {
      const A:int = getDw() - innerFillGradientSize;
      spriteFill.x = isNaturalScrolling ? A - outerFactor * A : outerFactor * A;
      savedFillPos = spriteFill.x;
    }
  }
  /**
   * Recreates the icons and recalculates the per column factor when the content width changes.
   * @param e the content width changed event
   */
  protected function contentDwChanged(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation contentDwChanged> called.", 1);
    application.trace("<" + this + " HorizontalNavigation contentDwChanged> e: " + e, 0);
    recreateIcons();
    recalcFactorPerRowOrCol();
  }
  /**
   * Handles a horizontal content coordinate change.
   * @param e the content cx changed event
   */
  protected function contentCxChanged(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation contentCxChanged> called.", 1);
    application.trace("<" + this + " HorizontalNavigation contentCxChanged> e: " + e, 0);
  }
  /**
   * Toggles the visibility of the bar sprites with the horizontal enabled state.
   * @param e the enabled changed event
   */
  override protected function isEnabledChanged(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation isEnabledChanged> called.", 1);
    application.trace("<" + this + " HorizontalNavigation isEnabledChanged> e: " + e, 0);
    super.isEnabledChanged(e);
    spriteFill.visible = scroll.getEnabledHorizontal();
    spriteCover.visible = scroll.getEnabledHorizontal();
    spriteMask.visible = scroll.getEnabledHorizontal();
    spriteMover.visible = scroll.getEnabledHorizontal();
  }
  /**
   * Handles a horizontal quantized change.
   * @param e the quantized changed event
   */
  override protected function isQuantizedChanged(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation isQuantizedChanged> called.", 1);
    application.trace("<" + this + " HorizontalNavigation isQuantizedChanged> e: " + e, 0);
    super.isQuantizedChanged(e);
  }
  /**
   * Lays out the bar dimensions, recreates icons and redraws the transparent mover hit area.
   * @param e the triggering event
   */
  override protected function setNewDimensions(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation setNewDimensions> called.", 1);
    application.trace("<" + this + " HorizontalNavigation setNewDimensions> e: " + e, 0);
    setDwh(scroll.getDw() - 2 * textFieldHeight, textFieldHeight);
    innerFillGradientSize = getDw() / 2;
    super.setNewDimensions(e);
    recreateIcons();
    spriteMover.graphics.clear();
    spriteMover.graphics.beginFill(0x000000, 0);
    spriteMover.graphics.drawRect(0, 0, getDw(), getDh());
    spriteMover.graphics.endFill();
    recalcInnerFactor();
  }
  /**
   * Recreates the horizontal page icons on the mask and cover graphics.
   */
  override protected function recreateIcons():void
  {
    application.trace("<" + this + " HorizontalNavigation recreateIcons> called.", 1);
    super.recreateIcons();
    calcNumOfIcons(scroll.getDw(), scroll.getDwContent(), scroll.getEnabledHorizontal(), scroll.getQuantizedHorizontal());
    for (var j:int = 0; j < numOfIcons; j++)
    {
      const posHorizontal:int = calcIconPosByIndexToNavigationArea(j, scroll.getDw());
      spriteMask.graphics.beginFill(0, 0);
      spriteMask.graphics.drawCircle(posHorizontal + circleX, circleY, circleR);
      spriteMask.graphics.endFill();
      spriteCover.graphics.drawCircle(posHorizontal + circleX, circleY, circleR);
    }
  }
  /**
   * Redraws the horizontal radial gradient fill.
   * @param e the triggering event
   */
  override protected function redrawFill(e:Event):void
  {
    application.trace("<" + this + " HorizontalNavigation redrawFill> called.", 1);
    application.trace("<" + this + " HorizontalNavigation redrawFill> e: " + e, 0);
    super.redrawFill(e);
    const colorArray:Array = [application.getDynamicsConfig().getAppBackgroundColorBright(), application.getDynamicsConfig().getAppBackgroundColorBright()];
    const alphaArray:Array = [1, 0];
    const ratioArray:Array = [0, 255];
    const matrixHorizontal:Matrix = new Matrix();
    matrixHorizontal.createGradientBox(innerFillGradientSize, textFieldHeight, 0, 0, 0);
    spriteFill.graphics.clear();
    spriteFill.graphics.beginGradientFill(GradientType.RADIAL, colorArray, alphaArray, ratioArray, matrixHorizontal, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
    spriteFill.graphics.drawRect(0, 0, innerFillGradientSize, textFieldHeight);
    spriteFill.graphics.endFill();
  }
  /**
   * Recalculates the inner factor from the horizontal gradient size.
   */
  override protected function recalcInnerFactor():void
  {
    application.trace("<" + this + " HorizontalNavigation recalcInnerFactor> called.", 1);
    innerFactor = (getDw() - innerFillGradientSize) / getDw();
  }
  /**
   * Applies the horizontal mover drag to the fill position and refreshes the outer factor.
   * @param e the mouse move event
   */
  override protected function stageMouseMoveSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " HorizontalNavigation stageMouseMoveSpriteMover> called.", 1);
    application.trace("<" + this + " HorizontalNavigation stageMouseMoveSpriteMover> e: " + e, 0);
    super.stageMouseMoveSpriteMover(e);
    const A:int = getDw() - innerFillGradientSize;
    const modifiedX:Number = savedFillPos + innerFactor * spriteMover.x;
    spriteFill.x = Math.max(Math.min(modifiedX, A), 0);
    refreshOuterFactor(isNaturalScrolling ? 1 - spriteFill.x / A : spriteFill.x / A);
  }
  /**
   * Resaves the fill position before ending the horizontal mover drag.
   * @param e the mouse up event
   */
  override protected function stageMouseUpSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " HorizontalNavigation stageMouseUpSpriteMover> called.", 1);
    application.trace("<" + this + " HorizontalNavigation stageMouseUpSpriteMover> e: " + e, 0);
    resaveFillPos();
    super.stageMouseUpSpriteMover(e);
  }
}
/** TopNavigation: horizontal side bar placed at the top. */
internal class TopNavigation extends HorizontalNavigation
{
  /**
   * Constructs the top side bar with natural scrolling.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function TopNavigation(applicationRef:Application):void
  {
    super(applicationRef, true);
    application.trace("<" + this + " TopNavigation> called.", 1);
    application.trace("<" + this + " TopNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " TopNavigation> constructed.", 1);
  }
  /**
   * Positions the top bar at the top edge of the scroll.
   * @param e the triggering event
   */
  override protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " TopNavigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " TopNavigation setNewCoordinates> e: " + e, 0);
    super.setNewCoordinates(e);
    setCxy(textFieldHeight, 0);
  }
}
/** BottomNavigation: horizontal side bar placed at the bottom. */
internal class BottomNavigation extends HorizontalNavigation
{
  /**
   * Constructs the bottom side bar without natural scrolling.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function BottomNavigation(applicationRef:Application):void
  {
    super(applicationRef, false);
    application.trace("<" + this + " BottomNavigation> called.", 1);
    application.trace("<" + this + " BottomNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " BottomNavigation> constructed.", 1);
  }
  /**
   * Positions the bottom bar at the bottom edge of the scroll.
   * @param e the triggering event
   */
  override protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " BottomNavigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " BottomNavigation setNewCoordinates> e: " + e, 0);
    super.setNewCoordinates(e);
    setCxy(textFieldHeight, scroll.getDh() - textFieldHeight);
  }
}
/** VerticalNavigation: side bar that scrolls the content vertically. */
internal class VerticalNavigation extends SideNavigation
{
  /**
   * Constructs the vertical side bar.
   * @param applicationRef the application reference passed to the base sprite
   * @param isNaturalScrolling whether the bar scrolls in the natural (inverted) direction
   */
  public function VerticalNavigation(applicationRef:Application, isNaturalScrolling:Boolean):void
  {
    super(applicationRef, isNaturalScrolling);
    application.trace("<" + this + " VerticalNavigation> called.", 1);
    application.trace("<" + this + " VerticalNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " VerticalNavigation> isNaturalScrolling: " + isNaturalScrolling, 0);
    application.trace("<" + this + " VerticalNavigation> constructed.", 1);
  }
  /**
   * Binds to the scroll and listens for its vertical content, quantized and enabled changes.
   * @param scrollRef the owning scroll to bind to
   */
  override public function setScrollRef(scrollRef:BaseScroll):void
  {
    application.trace("<" + this + " VerticalNavigation setScrollRef> called.", 1);
    application.trace("<" + this + " VerticalNavigation setScrollRef> scrollRef: " + scrollRef, 0);
    super.setScrollRef(scrollRef);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_DH_CHANGED(), contentDhChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CY_CHANGED(), contentCyChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_QUANTIZED_VERTICAL_CHANGED(), isQuantizedChanged);
    scroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_ENABLED_VERTICAL_CHANGED(), isEnabledChanged);
  }
  /**
   * Recalculates the factor represented by a single row from the content height.
   */
  override protected function recalcFactorPerRowOrCol():void
  {
    application.trace("<" + this + " VerticalNavigation recalcFactorPerRowOrCol> called.", 1);
    if (scroll != null)
    {
      factorPerRowOrCol = textFieldHeight / scroll.getDhContent();
    }
  }
  /**
   * Positions the fill sprite vertically from the outer factor and saves that position.
   */
  override protected function resaveFillPos():void
  {
    application.trace("<" + this + " VerticalNavigation resaveFillPos> called.", 1);
    if (spriteFill != null)
    {
      const A:int = getDh() - innerFillGradientSize;
      spriteFill.y = isNaturalScrolling ? A - outerFactor * A : outerFactor * A;
      savedFillPos = spriteFill.y;
    }
  }
  /**
   * Recreates the icons and recalculates the per row factor when the content height changes.
   * @param e the content height changed event
   */
  protected function contentDhChanged(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation contentDhChanged> called.", 1);
    application.trace("<" + this + " VerticalNavigation contentDhChanged> e: " + e, 0);
    recreateIcons();
    recalcFactorPerRowOrCol();
  }
  /**
   * Handles a vertical content coordinate change.
   * @param e the content cy changed event
   */
  protected function contentCyChanged(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation contentCyChanged> called.", 1);
    application.trace("<" + this + " VerticalNavigation contentCyChanged> e: " + e, 0);
  }
  /**
   * Toggles the visibility of the bar sprites with the vertical enabled state.
   * @param e the enabled changed event
   */
  override protected function isEnabledChanged(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation isEnabledChanged> called.", 1);
    application.trace("<" + this + " VerticalNavigation isEnabledChanged> e: " + e, 0);
    super.isEnabledChanged(e);
    spriteFill.visible = scroll.getEnabledVertical();
    spriteCover.visible = scroll.getEnabledVertical();
    spriteMask.visible = scroll.getEnabledVertical();
    spriteMover.visible = scroll.getEnabledVertical();
  }
  /**
   * Handles a vertical quantized change.
   * @param e the quantized changed event
   */
  override protected function isQuantizedChanged(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation isQuantizedChanged> called.", 1);
    application.trace("<" + this + " VerticalNavigation isQuantizedChanged> e: " + e, 0);
    super.isQuantizedChanged(e);
  }
  /**
   * Lays out the bar dimensions, recreates icons and redraws the transparent mover hit area.
   * @param e the triggering event
   */
  override protected function setNewDimensions(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation setNewDimensions> called.", 1);
    application.trace("<" + this + " VerticalNavigation setNewDimensions> e: " + e, 0);
    setDwh(textFieldHeight, scroll.getDh() - 2 * textFieldHeight);
    innerFillGradientSize = getDh() / 2;
    super.setNewDimensions(e);
    recreateIcons();
    spriteMover.graphics.clear();
    spriteMover.graphics.beginFill(0x000000, 0);
    spriteMover.graphics.drawRect(0, 0, getDw(), getDh());
    spriteMover.graphics.endFill();
    recalcInnerFactor();
  }
  /**
   * Recreates the vertical page icons on the mask and cover graphics.
   */
  override protected function recreateIcons():void
  {
    application.trace("<" + this + " VerticalNavigation recreateIcons> called.", 1);
    super.recreateIcons();
    calcNumOfIcons(scroll.getDh(), scroll.getDhContent(), scroll.getEnabledVertical(), scroll.getQuantizedVertical());
    for (var i:int = 0; i < numOfIcons; i++)
    {
      const posVertical:int = calcIconPosByIndexToNavigationArea(i, scroll.getDh());
      spriteMask.graphics.beginFill(0, 0);
      spriteMask.graphics.drawCircle(circleX, posVertical + circleY, circleR);
      spriteMask.graphics.endFill();
      spriteCover.graphics.drawCircle(circleX, posVertical + circleY, circleR);
    }
  }
  /**
   * Redraws the vertical radial gradient fill.
   * @param e the triggering event
   */
  override protected function redrawFill(e:Event):void
  {
    application.trace("<" + this + " VerticalNavigation redrawFill> called.", 1);
    application.trace("<" + this + " VerticalNavigation redrawFill> e: " + e, 0);
    super.redrawFill(e);
    const colorArray:Array = [application.getDynamicsConfig().getAppBackgroundColorBright(), application.getDynamicsConfig().getAppBackgroundColorBright()];
    const alphaArray:Array = [1, 0];
    const ratioArray:Array = [0, 255];
    const matrixVertical:Matrix = new Matrix();
    matrixVertical.createGradientBox(textFieldHeight, innerFillGradientSize, 0, 0, 0);
    spriteFill.graphics.clear();
    spriteFill.graphics.beginGradientFill(GradientType.RADIAL, colorArray, alphaArray, ratioArray, matrixVertical, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
    spriteFill.graphics.drawRect(0, 0, textFieldHeight, innerFillGradientSize);
    spriteFill.graphics.endFill();
  }
  /**
   * Recalculates the inner factor from the vertical gradient size.
   */
  override protected function recalcInnerFactor():void
  {
    application.trace("<" + this + " VerticalNavigation recalcInnerFactor> called.", 1);
    innerFactor = (getDh() - innerFillGradientSize) / getDh();
  }
  /**
   * Applies the vertical mover drag to the fill position and refreshes the outer factor.
   * @param e the mouse move event
   */
  override protected function stageMouseMoveSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " VerticalNavigation stageMouseMoveSpriteMover> called.", 1);
    application.trace("<" + this + " VerticalNavigation stageMouseMoveSpriteMover> e: " + e, 0);
    super.stageMouseMoveSpriteMover(e);
    const A:int = getDh() - innerFillGradientSize;
    const modifiedY:Number = savedFillPos + innerFactor * spriteMover.y;
    spriteFill.y = Math.max(Math.min(modifiedY, A), 0);
    refreshOuterFactor(isNaturalScrolling ? 1 - spriteFill.y / A : spriteFill.y / A);
  }
  /**
   * Resaves the fill position before ending the vertical mover drag.
   * @param e the mouse up event
   */
  override protected function stageMouseUpSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " VerticalNavigation stageMouseUpSpriteMover> called.", 1);
    application.trace("<" + this + " VerticalNavigation stageMouseUpSpriteMover> e: " + e, 0);
    resaveFillPos();
    super.stageMouseUpSpriteMover(e);
  }
}
/** LeftNavigation: vertical side bar placed at the left. */
internal class LeftNavigation extends VerticalNavigation
{
  /**
   * Constructs the left side bar with natural scrolling.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function LeftNavigation(applicationRef:Application):void
  {
    super(applicationRef, true);
    application.trace("<" + this + " LeftNavigation> called.", 1);
    application.trace("<" + this + " LeftNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " LeftNavigation> constructed.", 1);
  }
  /**
   * Positions the left bar at the left edge of the scroll.
   * @param e the triggering event
   */
  override protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " LeftNavigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " LeftNavigation setNewCoordinates> e: " + e, 0);
    super.setNewCoordinates(e);
    setCxy(0, textFieldHeight);
  }
}
/** RightNavigation: vertical side bar placed at the right. */
internal class RightNavigation extends VerticalNavigation
{
  /**
   * Constructs the right side bar without natural scrolling.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function RightNavigation(applicationRef:Application):void
  {
    super(applicationRef, false);
    application.trace("<" + this + " RightNavigation> called.", 1);
    application.trace("<" + this + " RightNavigation> applicationRef: " + applicationRef, 0);
    application.trace("<" + this + " RightNavigation> constructed.", 1);
  }
  /**
   * Positions the right bar at the right edge of the scroll.
   * @param e the triggering event
   */
  override protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " RightNavigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " RightNavigation setNewCoordinates> e: " + e, 0);
    super.setNewCoordinates(e);
    setCxy(scroll.getDw() - textFieldHeight, textFieldHeight);
  }
}
/** CenterNavigation: the center drag area that scrolls the content by dragging. */
internal class CenterNavigation extends Navigation
{
  private var eventCenterScrollingStart:Event = null;
  private var eventCenterScrollingInProgress:Event = null;
  private var eventCenterScrollingEnd:Event = null;
  private var isFull:Boolean = false;
  /**
   * Constructs the center drag area and its scrolling events.
   * @param applicationRef the application reference passed to the base sprite
   */
  public function CenterNavigation(applicationRef:Application):void
  {
    super(applicationRef);
    application.trace("<" + this + " CenterNavigation> called.", 1);
    application.trace("<" + this + " CenterNavigation> applicationRef: " + applicationRef, 0);
    moverToTheHighestDepth();
    eventCenterScrollingStart = new Event(EnumEvents.EVENT_CENTER_SCROLLING_START());
    eventCenterScrollingInProgress = new Event(EnumEvents.EVENT_CENTER_SCROLLING_IN_PROGRESS());
    eventCenterScrollingEnd = new Event(EnumEvents.EVENT_CENTER_SCROLLING_END());
    application.trace("<" + this + " CenterNavigation> constructed.", 1);
  }
  /**
   * Returns the mover object.
   */
  public function getMover():BaseSprite
  {
    return spriteMover;
  }
  /**
   * Returns the horizontal center scrolling delta from the mover position.
   */
  public function getCenterScrollingDeltaX():int
  {
    return spriteMover.x;
  }
  /**
   * Returns the vertical center scrolling delta from the mover position.
   */
  public function getCenterScrollingDeltaY():int
  {
    return spriteMover.y;
  }
  /**
   * Makes this area cover the whole surface of the scroll, or takes it back into the middle
   * of it, and lays it out again in that new state.
   * @param b true when this area has to cover the whole scroll
   */
  public function setFull(b:Boolean):void
  {
    application.trace("<" + this + " CenterNavigation setFull> called.", 1);
    application.trace("<" + this + " CenterNavigation setFull> b: " + b, 0);
    if (isFull != b)
    {
      application.trace("<" + this + " CenterNavigation setFull> conditions OK.", 1);
      isFull = b;
      setNewDimensions(null);
      setNewCoordinates(null);
    }
  }
  /**
   * Positions the center drag area inside the frame.
   * @param e the triggering event
   */
  override protected function setNewCoordinates(e:Event):void
  {
    application.trace("<" + this + " CenterNavigation setNewCoordinates> called.", 1);
    application.trace("<" + this + " CenterNavigation setNewCoordinates> e: " + e, 0);
    super.setNewCoordinates(e);
    setCxy(getMargin(), getMargin());
  }
  /**
   * Lays out the center drag area and redraws its transparent mover hit area.
   * @param e the triggering event
   */
  override protected function setNewDimensions(e:Event):void
  {
    application.trace("<" + this + " CenterNavigation setNewDimensions> called.", 1);
    application.trace("<" + this + " CenterNavigation setNewDimensions> e: " + e, 0);
    application.trace("<" + this + " CenterNavigation setNewDimensions> with textFieldHeight: " + textFieldHeight, 0);
    const margin:int = getMargin();
    setDwh(scroll.getDw() - 2 * margin, scroll.getDh() - 2 * margin);
    super.setNewDimensions(e);
    spriteMover.graphics.clear();
    spriteMover.graphics.beginFill(0x000000, 0);
    spriteMover.graphics.drawRect(0, 0, getDw(), getDh());
    spriteMover.graphics.endFill();
  }
  /**
   * Starts the dragging of the content from the outside, as if this area had been pressed.
   * @param e the mouse down event to start the dragging with
   */
  public function mouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " CenterNavigation mouseDown> called.", 1);
    application.trace("<" + this + " CenterNavigation mouseDown> e: " + e, 0);
    spriteMoverMouseDown(e);
  }
  /**
   * Starts the mover drag and dispatches the center scrolling start event.
   * @param e the mouse down event
   */
  override protected function spriteMoverMouseDown(e:MouseEvent):void
  {
    application.trace("<" + this + " CenterNavigation spriteMoverMouseDown> called.", 1);
    application.trace("<" + this + " CenterNavigation spriteMoverMouseDown> e: " + e, 0);
    // a scroll that is enabled in no direction at all has nothing to be dragged. This is
    // not only the press of this area: every element standing on a scrolled surface hands
    // its own presses over to that surface, and the widgets of a container in mobile mode
    // are moved by the widget layer itself instead of by the scroll of that container
    if (!scroll.getEnabledHorizontal() && !scroll.getEnabledVertical())
    {
      application.trace("<" + this + " CenterNavigation spriteMoverMouseDown> this scroll is scrolled in no direction.", 1);
      return;
    }
    super.spriteMoverMouseDown(e);
    getBaseEventDispatcher().dispatchEvent(eventCenterScrollingStart);
  }
  /**
   * Dispatches the center scrolling in progress event while dragging.
   * @param e the mouse move event
   */
  override protected function stageMouseMoveSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " CenterNavigation stageMouseMoveSpriteMover> called.", 1);
    application.trace("<" + this + " CenterNavigation stageMouseMoveSpriteMover> e: " + e, 0);
    super.stageMouseMoveSpriteMover(e);
    getBaseEventDispatcher().dispatchEvent(eventCenterScrollingInProgress);
  }
  /**
   * Dispatches the center scrolling end event when the drag ends.
   * @param e the mouse up event
   */
  override protected function stageMouseUpSpriteMover(e:MouseEvent):void
  {
    application.trace("<" + this + " CenterNavigation stageMouseUpSpriteMover> called.", 1);
    application.trace("<" + this + " CenterNavigation stageMouseUpSpriteMover> e: " + e, 0);
    super.stageMouseUpSpriteMover(e);
    getBaseEventDispatcher().dispatchEvent(eventCenterScrollingEnd);
  }
  /**
   * Scrolls the content of a center only scroll by the wheel. Such a scroll has no navigation
   * bar the wheel could be turned over, so this area takes that duty over as well: it scrolls
   * the vertical direction whenever that one is enabled, and the horizontal one when it is
   * the only direction left. A scroll that has its bars keeps the wheel of them.
   * @param e the mouse wheel event
   */
  override protected function spriteMoverMouseWheel(e:MouseEvent):void
  {
    application.trace("<" + this + " CenterNavigation spriteMoverMouseWheel> called.", 1);
    application.trace("<" + this + " CenterNavigation spriteMoverMouseWheel> e: " + e, 0);
    super.spriteMoverMouseWheel(e);
    if (isFull && e != null && scroll.alpha == 1)
    {
      application.trace("<" + this + " CenterNavigation spriteMoverMouseWheel> conditions OK.", 1);
      // a wheel turned upwards carries the content towards its beginning, exactly as the top
      // and the left bar do, and one single turn of it covers one row of that content
      const delta:int = textFieldHeight * e.delta;
      getBaseEventDispatcher().dispatchEvent(eventStopScrollToTarget);
      if (scroll.getEnabledVertical())
      {
        scroll.setContentPosition(scroll.getCxContent(), scroll.getCyContent() + delta, true);
      }
      else if (scroll.getEnabledHorizontal())
      {
        scroll.setContentPosition(scroll.getCxContent() + delta, scroll.getCyContent(), true);
      }
      e.updateAfterEvent();
    }
  }
  /**
   * Returns the room this area leaves for one navigation bar of the scroll on one side: none
   * at all in the center only state, where there is no bar to leave any room for.
   */
  private function getMargin():int
  {
    return isFull ? 0 : textFieldHeight;
  }
  /**
   * Frees all events and references held by this center navigation.
   */
  override public function destroy():void
  {
    application.trace("<" + this + " CenterNavigation destroy> called.", 1);
    application.trace("<" + this + " CenterNavigation destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
    application.trace("<" + this + " CenterNavigation destroy> remove every child object if there are any (necessary only in CenterNavigation).", 0);
    application.trace("<" + this + " CenterNavigation destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
    eventCenterScrollingStart.stopImmediatePropagation();
    eventCenterScrollingInProgress.stopImmediatePropagation();
    eventCenterScrollingEnd.stopImmediatePropagation();
    application.trace("<" + this + " CenterNavigation destroy> calling the super destroy (necessary only not in CenterNavigation) and clearing everything.", 0);
    super.destroy();
    eventCenterScrollingStart = null;
    eventCenterScrollingInProgress = null;
    eventCenterScrollingEnd = null;
    isFull = false;
  }
}
