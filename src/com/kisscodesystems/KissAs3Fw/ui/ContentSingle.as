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
 * ContentSingle.
 * A base scroll object and a base sprite behind it holding the elements of one content.
 *
 * MAIN FEATURES:
 * - one base sprite the elements have to be added into
 * - the base scroll object above it, masking and scrolling that base sprite
 * - automatic element repositioning driven by the
 *   orientation, the elementsFix and the cell indexes of the elements
 * - three automatic layouts: the cells of the vertical and the horizontal orientation,
 *   the rows of the flowing one, broken every time the width of this content has been
 *   filled up, and the strips of the docking one, taken at the sides of this content
 * - the room left between the elements and around them is counted in the margins of
 *   the application, so it follows every change of that margin
 * - an element can be aligned inside its own cell horizontally and vertically,
 *   the upper left corner of the cell being the default place of every element
 * - an element that does not count in the cell dimensions can be set to fill its
 *   own cell, taking the position and the dimensions of that whole cell
 * - the dimensions of the content are recalculated from the elements
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.app.Widgets;
  import com.kisscodesystems.KissAs3Fw.base.BaseEventDispatcher;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.base.BaseTextField;
  import com.kisscodesystems.KissAs3Fw.enum.EnumAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDocks;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.DisplayObject;
  import flash.events.Event;
  public class ContentSingle extends BaseSprite
  {
    private var baseSprite:BaseSprite = null;
    private var baseScroll:BaseScroll = null;
    private var elementsArray:Array = null;
    private var sizeConsidersArray:Array = null;
    private var cellIndexesArray:Array = null;
    private var alignsHorizontalArray:Array = null;
    private var alignsVerticalArray:Array = null;
    private var fillsArray:Array = null;
    private var docksArray:Array = null;
    private var orientation:String = null;
    private var elementsFix:int = -1;
    private var gapFactor:int = 1;
    private var eventElementsRepositioned:Event = null;
    private var reposElementsInProgress:Boolean = false;
    private var reposElementsPending:Boolean = false;
    public var enableScrollingFromOthers:Boolean = true;
    /**
     * Constructs the ContentSingle object and builds up its base scroll and base sprite.
     * @param applicationRef the main application reference
     */
    public function ContentSingle(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ContentSingle> called.", 1);
      application.trace("<" + this + " ContentSingle> applicationRef: " + applicationRef, 0);
      elementsArray = new Array();
      sizeConsidersArray = new Array();
      cellIndexesArray = new Array();
      alignsHorizontalArray = new Array();
      alignsVerticalArray = new Array();
      fillsArray = new Array();
      docksArray = new Array();
      eventElementsRepositioned = new Event(EnumEvents.EVENT_ELEMENTS_REPOSITIONED());
      orientation = EnumOrientations.ORIENTATION_VERTICAL();
      baseScroll = new BaseScroll(application);
      addChild(baseScroll);
      baseSprite = new BaseSprite(application);
      baseScroll.getContent().addChild(baseSprite);
      baseSprite.mask = baseScroll.getMask();
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CACHE_BEGIN(), cacheBeginContent);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CX_CHANGED(), reposContentX);
      baseScroll.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CONTENT_CY_CHANGED(), reposContentY);
      baseSprite.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), contentResized);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), contentResized);
      application.trace("<" + this + " ContentSingle> constructed.", 1);
    }
    /**
     * Returns the base scroll object of this content.
     */
    public function getBaseScroll():BaseScroll
    {
      return baseScroll;
    }
    /**
     * Returns the base sprite the elements of this content are added into.
     */
    public function getBaseSprite():BaseSprite
    {
      return baseSprite;
    }
    /**
     * Returns true if the elements of this content are positioned automatically. The
     * flowing and the docking layouts need no fix element count: they take the room of
     * this content instead of building the cells that count is needed for.
     */
    public function getAutomaticPositioning():Boolean
    {
      application.trace("<" + this + " ContentSingle getAutomaticPositioning> called.", 1);
      if (orientation == EnumOrientations.ORIENTATION_MANUAL())
      {
        return false;
      }
      if (orientation == EnumOrientations.ORIENTATION_FLOW()
        || orientation == EnumOrientations.ORIENTATION_DOCK())
      {
        return true;
      }
      return elementsFix > -1;
    }
    /**
     * Returns the number of the application margins this content leaves between its
     * elements and around them.
     */
    public function getGapFactor():int
    {
      return gapFactor;
    }
    /**
     * Sets the room this content leaves between its elements and around them, counted in
     * the margins of the application. A factor of one leaves one margin, which is what a
     * fresh content does, and a factor of zero joins the elements with no room between
     * them at all. The margin of the application stays the single measure behind it, so
     * this content follows every change of that margin whatever this factor is.
     * @param factor the number of the application margins to leave, zero or more
     */
    public function setGapFactor(factor:int):void
    {
      application.trace("<" + this + " ContentSingle setGapFactor> called.", 1);
      application.trace("<" + this + " ContentSingle setGapFactor> factor: " + factor, 0);
      if (factor >= 0 && gapFactor != factor)
      {
        gapFactor = factor;
        reposElements();
      }
    }
    /**
     * Returns the number of the elements placed into the fix row or column.
     */
    public function getElementsFix():int
    {
      return elementsFix;
    }
    /**
     * Sets the number of the elements placed into the fix row or column.
     * @param es the new number of the elements of the fix row or column
     */
    public function setElementsFix(es:int):void
    {
      application.trace("<" + this + " ContentSingle setElementsFix> called.", 1);
      application.trace("<" + this + " ContentSingle setElementsFix> es: " + es, 0);
      if (elementsFix != es)
      {
        elementsFix = es;
        reposElements();
      }
    }
    /**
     * Returns the orientation the elements of this content are positioned by.
     */
    public function getOrientation():String
    {
      return orientation;
    }
    /**
     * Sets the orientation the elements of this content are positioned by.
     * @param o the new orientation, an EnumOrientations value
     */
    public function setOrientation(o:String):void
    {
      application.trace("<" + this + " ContentSingle setOrientation> called.", 1);
      application.trace("<" + this + " ContentSingle setOrientation> o: " + o, 0);
      if (orientation != o)
      {
        if (o == EnumOrientations.ORIENTATION_VERTICAL()
          || o == EnumOrientations.ORIENTATION_HORIZONTAL()
          || o == EnumOrientations.ORIENTATION_FLOW()
          || o == EnumOrientations.ORIENTATION_DOCK()
          || o == EnumOrientations.ORIENTATION_MANUAL())
        {
          orientation = o;
          reposElements();
        }
      }
    }
    /**
     * Sets the x and y coordinates of the scrolled content
     * @param newCxContent the new x coordinate of the content
     * @param newCyContent the new y coordinate of the content
     * @param toDispatchEvents is it necessary to dispatch events to the outside
     */
    public function setContentPosition(newCxContent:int, newCyContent:int, toDispatchEvents:Boolean):void
    {
      application.trace("<" + this + " ContentSingle setContentPosition> called.", 1);
      application.trace("<" + this + " ContentSingle setContentPosition> newCxContent: " + newCxContent, 0);
      application.trace("<" + this + " ContentSingle setContentPosition> newCyContent: " + newCyContent, 0);
      application.trace("<" + this + " ContentSingle setContentPosition> toDispatchEvents: " + toDispatchEvents, 0);
      baseScroll.setContentPosition(newCxContent, newCyContent, toDispatchEvents);
    }
    /**
     * Returns the width of the scrolled content.
     */
    public function getDwContent():int
    {
      return baseScroll.getDwContent();
    }
    /**
     * Returns the height of the scrolled content.
     */
    public function getDhContent():int
    {
      return baseScroll.getDhContent();
    }
    /**
     * Sets the width and the height of the scrolled content.
     * @param newdw the new width of the content
     * @param newdh the new height of the content
     */
    public function setDwhContent(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ContentSingle setDwhContent> called.", 1);
      application.trace("<" + this + " ContentSingle setDwhContent> newdw: " + newdw, 0);
      application.trace("<" + this + " ContentSingle setDwhContent> newdh: " + newdh, 0);
      baseScroll.setDwhContent(newdw, newdh);
    }
    /**
     * Returns the cell index of the given element or -1 if it is not in this content.
     * @param displayObject the element the cell index is asked of
     */
    public function getCellIndex(displayObject:DisplayObject):int
    {
      application.trace("<" + this + " ContentSingle getCellIndex> called.", 1);
      application.trace("<" + this + " ContentSingle getCellIndex> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        return cellIndexesArray[index];
      }
      return -1;
    }
    /**
     * Changes the cell index of an element already added to this content.
     * @param displayObject the element the cell index has to be changed of
     * @param cellIndex the new cell index of that element
     */
    public function changeCellIndex(displayObject:DisplayObject, cellIndex:int):void
    {
      application.trace("<" + this + " ContentSingle changeCellIndex> called.", 1);
      application.trace("<" + this + " ContentSingle changeCellIndex> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle changeCellIndex> cellIndex: " + cellIndex, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        cellIndexesArray[index] = cellIndex;
        reposElements();
      }
    }
    /**
     * Returns the horizontal align of the given element inside its own cell, or null
     * when that element is not in this content.
     * @param displayObject the element the horizontal align is asked of
     */
    public function getElementAlignHorizontal(displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentSingle getElementAlignHorizontal> called.", 1);
      application.trace("<" + this + " ContentSingle getElementAlignHorizontal> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        return alignsHorizontalArray[index];
      }
      return null;
    }
    /**
     * Sets the horizontal align of an element already added to this content. The cell of
     * an element is as wide as the widest cell of its column, so a narrower element has
     * a free space inside that cell this align places it in. The elements sharing one
     * cell stand next to each other in a vertical content: there this align moves that
     * whole row of elements, so all of them are to be given the same one. In a flowing
     * content it moves the whole row inside the room that row has left empty at its end,
     * and in a docking content it places the element inside its own strip.
     * @param displayObject the element the horizontal align has to be set of
     * @param align the new horizontal align, a horizontal EnumAligns value
     */
    public function setElementAlignHorizontal(displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " ContentSingle setElementAlignHorizontal> called.", 1);
      application.trace("<" + this + " ContentSingle setElementAlignHorizontal> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle setElementAlignHorizontal> align: " + align, 0);
      if (align == EnumAligns.ALIGN_LEFT()
        || align == EnumAligns.ALIGN_CENTER()
        || align == EnumAligns.ALIGN_RIGHT())
      {
        const index:int = getIndexOfElement(displayObject);
        if (index > -1 && alignsHorizontalArray[index] != align)
        {
          alignsHorizontalArray[index] = align;
          reposElements();
        }
      }
    }
    /**
     * Returns the vertical align of the given element inside its own cell, or null when
     * that element is not in this content.
     * @param displayObject the element the vertical align is asked of
     */
    public function getElementAlignVertical(displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentSingle getElementAlignVertical> called.", 1);
      application.trace("<" + this + " ContentSingle getElementAlignVertical> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        return alignsVerticalArray[index];
      }
      return null;
    }
    /**
     * Sets the vertical align of an element already added to this content. The cell of an
     * element is as tall as the tallest cell of its row, so a lower element has a free
     * space inside that cell this align places it in. The elements sharing one cell stand
     * under each other in a horizontal content: there this align moves that whole column
     * of elements, so all of them are to be given the same one. A text label placed by
     * this align loses the padding it stands under the top of its cell by.
     * @param displayObject the element the vertical align has to be set of
     * @param align the new vertical align, a vertical EnumAligns value
     */
    public function setElementAlignVertical(displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " ContentSingle setElementAlignVertical> called.", 1);
      application.trace("<" + this + " ContentSingle setElementAlignVertical> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle setElementAlignVertical> align: " + align, 0);
      if (align == EnumAligns.ALIGN_TOP()
        || align == EnumAligns.ALIGN_MIDDLE()
        || align == EnumAligns.ALIGN_BOTTOM())
      {
        const index:int = getIndexOfElement(displayObject);
        if (index > -1 && alignsVerticalArray[index] != align)
        {
          alignsVerticalArray[index] = align;
          reposElements();
        }
      }
    }
    /**
     * Returns true when the given element has been set to fill its own cell.
     * @param displayObject the element the fill is asked of
     */
    public function getElementFill(displayObject:DisplayObject):Boolean
    {
      application.trace("<" + this + " ContentSingle getElementFill> called.", 1);
      application.trace("<" + this + " ContentSingle getElementFill> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        return fillsArray[index];
      }
      return false;
    }
    /**
     * Sets whether an element already added to this content fills its own cell. Such an
     * element takes the position and the dimensions of that whole cell, so neither the
     * aligns nor the elements sharing that cell move it. This works on an element that
     * does not count in the cell dimensions only, on one added with a false sizeConsider:
     * the dimensions of a cell come from the elements counting in it, and an element
     * sized by its own cell can not be one of them. Such an element is left out of those
     * dimensions completely, so a cell holding nothing else stays empty and the element
     * filling it takes the smallest size a component of this framework can have.
     * In a docking content this fill stretches the element across its own strip instead,
     * and the sizeConsider of it takes no part there at all.
     * @param displayObject the element the fill has to be set of
     * @param fill true when that element has to fill its own cell
     */
    public function setElementFill(displayObject:DisplayObject, fill:Boolean):void
    {
      application.trace("<" + this + " ContentSingle setElementFill> called.", 1);
      application.trace("<" + this + " ContentSingle setElementFill> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle setElementFill> fill: " + fill, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1 && fillsArray[index] != fill)
      {
        fillsArray[index] = fill;
        reposElements();
      }
    }
    /**
     * Returns the side the given element is docked to, or null when that element is not
     * in this content.
     * @param displayObject the element the dock is asked of
     */
    public function getElementDock(displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentSingle getElementDock> called.", 1);
      application.trace("<" + this + " ContentSingle getElementDock> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index > -1)
      {
        return docksArray[index];
      }
      return null;
    }
    /**
     * Sets the side an element already added to this content is docked to. This is the
     * layout of a docking content only, the other ones leave it alone. Every element
     * takes a strip of the room the elements added before it have left, and the element
     * of the center takes the whole of that room.
     * @param displayObject the element the dock has to be set of
     * @param dock the side to dock that element to, an EnumDocks value
     */
    public function setElementDock(displayObject:DisplayObject, dock:String):void
    {
      application.trace("<" + this + " ContentSingle setElementDock> called.", 1);
      application.trace("<" + this + " ContentSingle setElementDock> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle setElementDock> dock: " + dock, 0);
      if (dock == EnumDocks.DOCK_TOP()
        || dock == EnumDocks.DOCK_BOTTOM()
        || dock == EnumDocks.DOCK_LEFT()
        || dock == EnumDocks.DOCK_RIGHT()
        || dock == EnumDocks.DOCK_CENTER())
      {
        const index:int = getIndexOfElement(displayObject);
        if (index > -1 && docksArray[index] != dock)
        {
          docksArray[index] = dock;
          reposElements();
        }
      }
    }
    /**
     * Adds a new element into this content.
     * @param displayObject the element to be added
     * @param cellIndex the cell index of that element
     * @param sizeConsider true if the dimensions of that element count in the cell dimensions
     * @param to0 true if that element has to be added to the lowest depth
     */
    public function addToContent(displayObject:DisplayObject, cellIndex:int, sizeConsider:Boolean = true, to0:Boolean = false):void
    {
      application.trace("<" + this + " ContentSingle addToContent> called.", 1);
      application.trace("<" + this + " ContentSingle addToContent> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentSingle addToContent> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " ContentSingle addToContent> sizeConsider: " + sizeConsider, 0);
      application.trace("<" + this + " ContentSingle addToContent> to0: " + to0, 0);
      if (!baseSprite.contains(displayObject))
      {
        elementsArray.push(displayObject);
        sizeConsidersArray.push(sizeConsider);
        cellIndexesArray.push(cellIndex);
        alignsHorizontalArray.push(EnumAligns.ALIGN_LEFT());
        alignsVerticalArray.push(EnumAligns.ALIGN_TOP());
        fillsArray.push(false);
        docksArray.push(EnumDocks.DOCK_TOP());
        if (to0)
        {
          baseSprite.addChildAt(displayObject, 0);
        }
        else
        {
          baseSprite.addChild(displayObject);
        }
        const dispatcher:BaseEventDispatcher = getDispatcherOfElement(displayObject);
        if (dispatcher != null)
        {
          dispatcher.addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
        }
        reposElements();
      }
    }
    /**
     * Removes an element from this content without destroying it.
     * @param displayObject the element to be removed
     */
    public function removeFromContent(displayObject:DisplayObject):void
    {
      application.trace("<" + this + " ContentSingle removeFromContent> called.", 1);
      application.trace("<" + this + " ContentSingle removeFromContent> displayObject: " + displayObject, 0);
      const index:int = getIndexOfElement(displayObject);
      if (index != -1)
      {
        // the element may have been destroyed before this call, and a destroyed object
        // has no dispatcher any more. That dispatcher took the listener below with it,
        // so there is nothing left to remove, but the element still has to be dropped
        // out of the stores of this content
        const dispatcher:BaseEventDispatcher = getDispatcherOfElement(displayObject);
        if (dispatcher != null)
        {
          dispatcher.removeEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
        }
        if (baseSprite.contains(displayObject))
        {
          baseSprite.removeChild(displayObject);
        }
        cellIndexesArray.splice(index, 1);
        elementsArray.splice(index, 1);
        sizeConsidersArray.splice(index, 1);
        alignsHorizontalArray.splice(index, 1);
        alignsVerticalArray.splice(index, 1);
        fillsArray.splice(index, 1);
        docksArray.splice(index, 1);
        reposElements();
      }
    }
    /**
     * Recalculates the dimensions of this content from the elements it holds.
     */
    public function contentDimensionsRecalculation():void
    {
      application.trace("<" + this + " ContentSingle contentDimensionsRecalculation> called.", 1);
      const dimensions:Array = contentDimensionsRecalculationOnSprite(baseSprite);
      baseSprite.setDwh(dimensions[0], dimensions[1]);
    }
    /**
     * Sets the width of this content and of its base scroll.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ContentSingle setDw> called.", 1);
      application.trace("<" + this + " ContentSingle setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        baseScroll.setDw(getDw());
        containerResized();
      }
    }
    /**
     * Sets the height of this content and of its base scroll.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ContentSingle setDh> called.", 1);
      application.trace("<" + this + " ContentSingle setDh> newdh: " + newdh, 0);
      if (getDh() != newdh)
      {
        super.setDh(newdh);
        baseScroll.setDh(getDh());
        containerResized();
      }
    }
    /**
     * Sets the width and the height of this content and of its base scroll.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ContentSingle setDwh> called.", 1);
      application.trace("<" + this + " ContentSingle setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ContentSingle setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        baseScroll.setDwh(getDw(), getDh());
        containerResized();
      }
    }
    /**
     * Scrolls the content of this object to its bottom.
     */
    public function toBottom():void
    {
      application.trace("<" + this + " ContentSingle toBottom> called.", 1);
      if (baseScroll != null)
      {
        baseScroll.setContentPosition(baseScroll.getCxContent(), baseScroll.getDh() - baseScroll.getDhContent(), true);
      }
    }
    /**
     * Scrolls the content of this object to its top.
     */
    public function toTop():void
    {
      application.trace("<" + this + " ContentSingle toTop> called.", 1);
      if (baseScroll != null)
      {
        baseScroll.setContentPosition(baseScroll.getCxContent(), 0, true);
      }
    }
    /**
     * Scrolls the content of this object to its right.
     */
    public function toRight():void
    {
      application.trace("<" + this + " ContentSingle toRight> called.", 1);
      if (baseScroll != null)
      {
        baseScroll.setContentPosition(baseScroll.getDw() - baseScroll.getDwContent(), baseScroll.getCyContent(), true);
      }
    }
    /**
     * Scrolls the content of this object to its left.
     */
    public function toLeft():void
    {
      application.trace("<" + this + " ContentSingle toLeft> called.", 1);
      if (baseScroll != null)
      {
        baseScroll.setContentPosition(0, baseScroll.getCyContent(), true);
      }
    }
    /**
     * Returns the index the given element is stored at in the arrays of this content, or
     * -1 when that element is not in this content.
     * @param displayObject the element the index is asked of
     */
    private function getIndexOfElement(displayObject:DisplayObject):int
    {
      application.trace("<" + this + " ContentSingle getIndexOfElement> called.", 1);
      application.trace("<" + this + " ContentSingle getIndexOfElement> displayObject: " + displayObject, 0);
      if (displayObject != null && elementsArray != null)
      {
        return elementsArray.indexOf(displayObject);
      }
      return -1;
    }
    /**
     * Returns the event dispatcher of the given element, or null when that element has
     * none: it is neither a base sprite nor a base text field, or it has already been
     * destroyed.
     * @param displayObject the element the dispatcher is asked for
     */
    private function getDispatcherOfElement(displayObject:DisplayObject):BaseEventDispatcher
    {
      application.trace("<" + this + " ContentSingle getDispatcherOfElement> called.", 1);
      application.trace("<" + this + " ContentSingle getDispatcherOfElement> displayObject: " + displayObject, 0);
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
     * Repositions the content horizontally after the base scroll has been scrolled.
     * @param e the content x coordinate changed event
     */
    private function reposContentX(e:Event):void
    {
      application.trace("<" + this + " ContentSingle reposContentX> called.", 1);
      application.trace("<" + this + " ContentSingle reposContentX> e: " + e, 0);
      baseSprite.setCx(baseScroll.getCxContent());
    }
    /**
     * Repositions the content vertically after the base scroll has been scrolled.
     * @param e the content y coordinate changed event
     */
    private function reposContentY(e:Event):void
    {
      application.trace("<" + this + " ContentSingle reposContentY> called.", 1);
      application.trace("<" + this + " ContentSingle reposContentY> e: " + e, 0);
      baseSprite.setCy(baseScroll.getCyContent());
    }
    /**
     * Turns the bitmap caching of the content on before a scrolling begins.
     * @param e the content cache begin event
     */
    private function cacheBeginContent(e:Event):void
    {
      application.trace("<" + this + " ContentSingle cacheBeginContent> called.", 1);
      application.trace("<" + this + " ContentSingle cacheBeginContent> e: " + e, 0);
      baseSprite.cacheAsBitmap = true;
    }
    /**
     * Repositions the elements after the application margin has been changed.
     * @param e the margin changed event
     */
    private function marginChanged(e:Event):void
    {
      application.trace("<" + this + " ContentSingle marginChanged> called.", 1);
      application.trace("<" + this + " ContentSingle marginChanged> e: " + e, 0);
      reposElements();
    }
    /**
     * Repositions the elements after the application padding has been changed.
     * @param e the padding changed event
     */
    private function paddingChanged(e:Event):void
    {
      application.trace("<" + this + " ContentSingle paddingChanged> called.", 1);
      application.trace("<" + this + " ContentSingle paddingChanged> e: " + e, 0);
      reposElements();
    }
    /**
     * Refreshes the scrollable content dimensions after the content has been resized.
     * @param e the dimensions changed event
     */
    private function contentResized(e:Event):void
    {
      application.trace("<" + this + " ContentSingle contentResized> called.", 1);
      application.trace("<" + this + " ContentSingle contentResized> e: " + e, 0);
      const insideMobileWidgets:Boolean = !application.getDynamicsConfig().weAreInDesktopMode()
        && parent is ContentMultiple && parent.parent is Widgets;
      if (baseScroll != null)
      {
        if (insideMobileWidgets)
        {
          baseScroll.setDwhContent(1, 1);
        }
        else
        {
          baseScroll.setDwhContent(baseSprite.getDw(), baseSprite.getDh());
        }
      }
    }
    /**
     * Returns the width of the element stored at the given index.
     * @param index the index of the element in the elements array
     */
    private function getElementDw(index:int):int
    {
      application.trace("<" + this + " ContentSingle getElementDw> called.", 1);
      application.trace("<" + this + " ContentSingle getElementDw> index: " + index, 0);
      if (elementsArray[index] is BaseSprite)
      {
        return BaseSprite(elementsArray[index]).getDw();
      }
      else if (elementsArray[index] is BaseTextField)
      {
        return BaseTextField(elementsArray[index]).getDw();
      }
      else
      {
        return elementsArray[index].width;
      }
    }
    /**
     * Returns the height of the element stored at the given index.
     * @param index the index of the element in the elements array
     */
    private function getElementDh(index:int):int
    {
      application.trace("<" + this + " ContentSingle getElementDh> called.", 1);
      application.trace("<" + this + " ContentSingle getElementDh> index: " + index, 0);
      if (elementsArray[index] is BaseSprite)
      {
        return BaseSprite(elementsArray[index]).getDh();
      }
      else if (elementsArray[index] is BaseTextField)
      {
        return BaseTextField(elementsArray[index]).getDh();
      }
      else
      {
        return elementsArray[index].height;
      }
    }
    /**
     * Sets the width of the element stored at the given index. An element that takes no
     * width from the outside, a text button for one, keeps the width it has.
     * @param index the index of the element in the elements array
     * @param newdw the new width of that element
     */
    private function setElementDw(index:int, newdw:int):void
    {
      application.trace("<" + this + " ContentSingle setElementDw> called.", 1);
      application.trace("<" + this + " ContentSingle setElementDw> index: " + index, 0);
      application.trace("<" + this + " ContentSingle setElementDw> newdw: " + newdw, 0);
      if (elementsArray[index] is BaseSprite)
      {
        BaseSprite(elementsArray[index]).setDw(newdw);
      }
      else if (elementsArray[index] is BaseTextField)
      {
        BaseTextField(elementsArray[index]).setDw(newdw);
      }
      else
      {
        elementsArray[index].width = newdw;
      }
    }
    /**
     * Sets the height of the element stored at the given index. An element that takes no
     * height from the outside, a text button for one, keeps the height it has.
     * @param index the index of the element in the elements array
     * @param newdh the new height of that element
     */
    private function setElementDh(index:int, newdh:int):void
    {
      application.trace("<" + this + " ContentSingle setElementDh> called.", 1);
      application.trace("<" + this + " ContentSingle setElementDh> index: " + index, 0);
      application.trace("<" + this + " ContentSingle setElementDh> newdh: " + newdh, 0);
      if (elementsArray[index] is BaseSprite)
      {
        BaseSprite(elementsArray[index]).setDh(newdh);
      }
      else if (elementsArray[index] is BaseTextField)
      {
        BaseTextField(elementsArray[index]).setDh(newdh);
      }
      else
      {
        elementsArray[index].height = newdh;
      }
    }
    /**
     * Sets the dimensions of the element stored at the given index.
     * @param index the index of the element in the elements array
     * @param newdw the new width of that element
     * @param newdh the new height of that element
     */
    private function setElementDwh(index:int, newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ContentSingle setElementDwh> called.", 1);
      application.trace("<" + this + " ContentSingle setElementDwh> index: " + index, 0);
      application.trace("<" + this + " ContentSingle setElementDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ContentSingle setElementDwh> newdh: " + newdh, 0);
      if (elementsArray[index] is BaseSprite)
      {
        BaseSprite(elementsArray[index]).setDwh(newdw, newdh);
      }
      else if (elementsArray[index] is BaseTextField)
      {
        BaseTextField(elementsArray[index]).setDwh(newdw, newdh);
      }
      else
      {
        elementsArray[index].width = newdw;
        elementsArray[index].height = newdh;
      }
    }
    /**
     * Returns true when the element stored at the given index fills its own cell. The
     * fill of an element counting in the cell dimensions is refused here: the dimensions
     * of that cell would come from the very element they are given to.
     * @param index the index of the element in the elements array
     */
    private function isElementFilling(index:int):Boolean
    {
      application.trace("<" + this + " ContentSingle isElementFilling> called.", 1);
      application.trace("<" + this + " ContentSingle isElementFilling> index: " + index, 0);
      return fillsArray[index] && !sizeConsidersArray[index];
    }
    /**
     * Returns the offset an element has to be moved by inside its own cell to stand where
     * the given align tells. An element not smaller than its cell gets no offset at all.
     * @param align the align of that element, an EnumAligns value
     * @param freeSpace the space its cell has left empty on the axis of that align
     */
    private function getAlignOffset(align:String, freeSpace:int):int
    {
      application.trace("<" + this + " ContentSingle getAlignOffset> called.", 1);
      application.trace("<" + this + " ContentSingle getAlignOffset> align: " + align, 0);
      application.trace("<" + this + " ContentSingle getAlignOffset> freeSpace: " + freeSpace, 0);
      if (freeSpace > 0)
      {
        if (align == EnumAligns.ALIGN_CENTER() || align == EnumAligns.ALIGN_MIDDLE())
        {
          return int(freeSpace / 2);
        }
        if (align == EnumAligns.ALIGN_RIGHT() || align == EnumAligns.ALIGN_BOTTOM())
        {
          return freeSpace;
        }
      }
      return 0;
    }
    /**
     * Repositions every element of this content into its own cell, sizes the elements
     * filling their cells and dispatches the elements repositioned event afterwards.
     * Sizing an element makes that element dispatch a dimensions changed event, which
     * leads right back here, so a call arriving while this one is running is not run
     * inside it: it is remembered and run after it instead.
     * @param e the dimensions changed event of an element, null if it is called by hand
     */
    private function reposElements(e:Event = null):void
    {
      application.trace("<" + this + " ContentSingle reposElements> called.", 1);
      application.trace("<" + this + " ContentSingle reposElements> e: " + e, 0);
      if (reposElementsInProgress)
      {
        application.trace("<" + this + " ContentSingle reposElements> running already, this call is postponed.", 0);
        reposElementsPending = true;
        return;
      }
      reposElementsInProgress = true;
      reposElementsPending = false;
      if (getAutomaticPositioning())
      {
        if (orientation == EnumOrientations.ORIENTATION_FLOW())
        {
          reposElementsFlowing();
        }
        else if (orientation == EnumOrientations.ORIENTATION_DOCK())
        {
          reposElementsDocked();
        }
        else
        {
          reposElementsInCells();
        }
        updateCxyOfElements();
      }
      contentDimensionsRecalculation();
      reposElementsInProgress = false;
      getBaseEventDispatcher().dispatchEvent(eventElementsRepositioned);
      if (reposElementsPending)
      {
        reposElementsPending = false;
        reposElements();
      }
    }
    /**
     * Places every element of this content into its own cell. The cells stand in the
     * columns and the rows the orientation, the elementsFix and the cell indexes of the
     * elements describe, a column is as wide as the widest cell of it and a row is as
     * tall as the tallest one, and the aligns and the fills place the elements inside
     * their own cells.
     */
    private function reposElementsInCells():void
    {
      application.trace("<" + this + " ContentSingle reposElementsInCells> called.", 1);
      var i:int = 0;
      var a:int = 0;
      var b:int = 0;
      var maxCellIndex:int = 0;
      var cellIndex:int = 0;
      var columnIndex:int = 0;
      var rowIndex:int = 0;
      var runSize:int = 0;
      var crossSize:int = 0;
      var cellDw:int = 0;
      var cellDh:int = 0;
      var currx:int = 0;
      var curry:int = 0;
      const v:Boolean = orientation == EnumOrientations.ORIENTATION_VERTICAL();
      const h:Boolean = orientation == EnumOrientations.ORIENTATION_HORIZONTAL();
      // the greatest cell index tells how many columns and rows this content has
      for (i = 0; i < cellIndexesArray.length; i++)
      {
        if (maxCellIndex < cellIndexesArray[i])
        {
          maxCellIndex = cellIndexesArray[i];
        }
      }
      const elementsVar:int = Math.floor(maxCellIndex / (elementsFix + 1));
      if (v)
      {
        a = elementsFix;
        b = elementsVar;
      }
      else if (h)
      {
        a = elementsVar;
        b = elementsFix;
      }
      const columns:int = a + 1;
      // the elements sharing one cell stand next to each other in a vertical content
      // and under each other in a horizontal one, so the stacking axis of a cell is
      // filled by the sum of the sizes of the elements counting in that cell, and the
      // other axis of it by the greatest size of all of them. One walk of the elements
      // collects both of these for every cell, and a third store counts how much of a
      // cell the elements placed into it so far have consumed of its stacking axis.
      const cellRuns:Array = new Array();
      const cellCrosses:Array = new Array();
      const cellConsumeds:Array = new Array();
      for (i = 0; i <= maxCellIndex; i++)
      {
        cellRuns[i] = 0;
        cellCrosses[i] = 0;
        cellConsumeds[i] = 0;
      }
      for (i = 0; i < elementsArray.length; i++)
      {
        if (v)
        {
          runSize = getElementDw(i);
          crossSize = getElementDh(i);
        }
        else
        {
          runSize = getElementDh(i);
          crossSize = getElementDw(i);
        }
        if (sizeConsidersArray[i])
        {
          cellRuns[cellIndexesArray[i]] += runSize;
        }
        // an element sized by its own cell is left out of both of these stores: it would
        // pin the size of that cell to the size it has been given the pass before, so
        // that cell could never shrink again
        if (!isElementFilling(i) && cellCrosses[cellIndexesArray[i]] < crossSize)
        {
          cellCrosses[cellIndexesArray[i]] = crossSize;
        }
      }
      // a column is as wide as the widest cell standing in it and a row is as tall as
      // the tallest one, a column and a row holding no element at all staying empty
      const maxws:Array = new Array();
      const maxhs:Array = new Array();
      for (i = 0; i <= a; i++)
      {
        maxws[i] = 0;
      }
      for (i = 0; i <= b; i++)
      {
        maxhs[i] = 0;
      }
      for (i = 0; i < elementsArray.length; i++)
      {
        cellIndex = cellIndexesArray[i];
        if (v)
        {
          cellDw = cellRuns[cellIndex];
          cellDh = cellCrosses[cellIndex];
        }
        else
        {
          cellDw = cellCrosses[cellIndex];
          cellDh = cellRuns[cellIndex];
        }
        columnIndex = cellIndex % columns;
        rowIndex = Math.floor(cellIndex / columns);
        if (maxws[columnIndex] < cellDw)
        {
          maxws[columnIndex] = cellDw;
        }
        if (maxhs[rowIndex] < cellDh)
        {
          maxhs[rowIndex] = cellDh;
        }
      }
      // the coordinates of the upper left corner of every column and of every row
      const columnCxs:Array = new Array();
      const rowCys:Array = new Array();
      currx = getGap();
      for (i = 0; i <= a; i++)
      {
        columnCxs[i] = currx;
        currx += maxws[i] + getGap();
      }
      curry = getGap();
      for (i = 0; i <= b; i++)
      {
        rowCys[i] = curry;
        curry += maxhs[i] + getGap();
      }
      for (i = 0; i < elementsArray.length; i++)
      {
        cellIndex = cellIndexesArray[i];
        columnIndex = cellIndex % columns;
        rowIndex = Math.floor(cellIndex / columns);
        currx = columnCxs[columnIndex];
        curry = rowCys[rowIndex];
        // currx and curry stand in the upper left corner of the cell of this element,
        // which is where an element filling that whole cell has nothing else to do
        if (isElementFilling(i))
        {
          setElementDwh(i, maxws[columnIndex], maxhs[rowIndex]);
        }
        else
        {
          // the free space of the stacking axis belongs to the whole run of the
          // elements sharing this cell, on the other axis this element has the cell
          // for itself, and what the elements standing in front of it have consumed
          // of that cell is what it is moved by inside the run
          if (v)
          {
            currx += getAlignOffset(alignsHorizontalArray[i], maxws[columnIndex] - cellRuns[cellIndex]);
            currx += cellConsumeds[cellIndex];
            curry += getAlignOffset(alignsVerticalArray[i], maxhs[rowIndex] - getElementDh(i));
            if (sizeConsidersArray[i])
            {
              cellConsumeds[cellIndex] += getElementDw(i);
            }
          }
          else if (h)
          {
            currx += getAlignOffset(alignsHorizontalArray[i], maxws[columnIndex] - getElementDw(i));
            curry += getAlignOffset(alignsVerticalArray[i], maxhs[rowIndex] - cellRuns[cellIndex]);
            curry += cellConsumeds[cellIndex];
            if (sizeConsidersArray[i])
            {
              cellConsumeds[cellIndex] += getElementDh(i);
            }
          }
          // a label stands a padding under the top of its cell to be in one line with
          // the text of the element next to it, but a vertical align other than the
          // default one tells where that label has to stand, so it is left alone then
          if (elementsArray[i] is TextLabel && alignsVerticalArray[i] == EnumAligns.ALIGN_TOP())
          {
            curry += application.getDynamicsConfig().getAppPadding();
          }
        }
        elementsArray[i].x = currx;
        elementsArray[i].y = curry;
      }
    }
    /**
     * Places the elements of this content next to each other and breaks the row every
     * time the width of this content has been filled up. The cell indexes take no part
     * in this: the elements follow each other in the order they have been added in. A row
     * is as tall as the tallest element standing in it and the vertical align of an
     * element tells where it stands inside that row. A row that has not been filled up
     * has free space left at its end, and the horizontal align of an element moves that
     * whole row inside it, so the elements of one row are to be given the same one. The
     * fill of an element is left alone here, it needs a cell of its own.
     */
    private function reposElementsFlowing():void
    {
      application.trace("<" + this + " ContentSingle reposElementsFlowing> called.", 1);
      var i:int = 0;
      var rowIndex:int = 0;
      var currx:int = 0;
      var curry:int = 0;
      const gap:int = getGap();
      const widthToFill:int = getDw() - gap;
      // the row every element belongs to, the coordinate it stands at inside that row,
      // the height of every row, which is the tallest element standing in it, and the
      // room every row has left empty at its end
      const rowIndexes:Array = new Array();
      const elementCxs:Array = new Array();
      const rowDhs:Array = new Array();
      const rowFreeSpaces:Array = new Array();
      rowDhs.push(0);
      rowFreeSpaces.push(0);
      currx = gap;
      for (i = 0; i < elementsArray.length; i++)
      {
        // a row that holds an element already is broken when this one does not fit into
        // it any more, an empty row takes its element whether it fits or not
        if (currx > gap && currx + getElementDw(i) > widthToFill)
        {
          // the row that has just been closed kept everything up to the last gap of it
          rowFreeSpaces[rowIndex] = getDw() - currx;
          rowIndex++;
          rowDhs.push(0);
          rowFreeSpaces.push(0);
          currx = gap;
        }
        rowIndexes.push(rowIndex);
        elementCxs.push(currx);
        currx += getElementDw(i) + gap;
        if (rowDhs[rowIndex] < getElementDh(i))
        {
          rowDhs[rowIndex] = getElementDh(i);
        }
      }
      rowFreeSpaces[rowIndex] = getDw() - currx;
      // the coordinate of the top of every row
      const rowCys:Array = new Array();
      curry = gap;
      for (i = 0; i < rowDhs.length; i++)
      {
        rowCys.push(curry);
        curry += rowDhs[i] + gap;
      }
      for (i = 0; i < elementsArray.length; i++)
      {
        elementsArray[i].x = elementCxs[i]
          + getAlignOffset(alignsHorizontalArray[i], rowFreeSpaces[rowIndexes[i]]);
        elementsArray[i].y = rowCys[rowIndexes[i]]
          + getAlignOffset(alignsVerticalArray[i], rowDhs[rowIndexes[i]] - getElementDh(i));
      }
    }
    /**
     * Docks every element of this content to one of its sides, in the order the elements
     * have been added in: every one of them takes a strip of the room the elements before
     * it have left, and the element of the center stands in the room all of them have
     * left. A docked element keeps its own dimensions, so the strip it takes is as thick
     * as it is and the dock of it can be changed at any time. The fill of an element
     * stretches it across its own strip: to the width of the room when it is docked to
     * the top or to the bottom, to the height of that room when it is docked to the left
     * or to the right, and to the whole of it in the center. The sizeConsider of an
     * element takes no part here, it belongs to the cells of the other layouts, and an
     * element that is not stretched stands inside its own strip by its aligns.
     */
    private function reposElementsDocked():void
    {
      application.trace("<" + this + " ContentSingle reposElementsDocked> called.", 1);
      var i:int = 0;
      var stripDw:int = 0;
      var stripDh:int = 0;
      var currx:int = 0;
      var curry:int = 0;
      const gap:int = getGap();
      // the room the elements docked so far have left, gap by gap smaller than this
      // content on every side it has been docked at
      var roomCx:int = gap;
      var roomCy:int = gap;
      var roomDw:int = Math.max(0, getDw() - 2 * gap);
      var roomDh:int = Math.max(0, getDh() - 2 * gap);
      for (i = 0; i < elementsArray.length; i++)
      {
        if (docksArray[i] == EnumDocks.DOCK_LEFT() || docksArray[i] == EnumDocks.DOCK_RIGHT())
        {
          // the height of the room is given first and the width of that element is read
          // afterwards: the width it needs may well come from the height it has been
          // given, as it does with a label breaking its text into lines
          if (fillsArray[i])
          {
            setElementDh(i, roomDh);
          }
          stripDw = Math.min(getElementDw(i), roomDw);
          curry = roomCy + getAlignOffset(alignsVerticalArray[i], roomDh - getElementDh(i));
          if (docksArray[i] == EnumDocks.DOCK_LEFT())
          {
            currx = roomCx;
            roomCx += stripDw + gap;
          }
          else
          {
            currx = roomCx + roomDw - stripDw;
          }
          roomDw = Math.max(0, roomDw - stripDw - gap);
        }
        else if (docksArray[i] == EnumDocks.DOCK_CENTER())
        {
          if (fillsArray[i])
          {
            setElementDwh(i, roomDw, roomDh);
          }
          currx = roomCx + getAlignOffset(alignsHorizontalArray[i], roomDw - getElementDw(i));
          curry = roomCy + getAlignOffset(alignsVerticalArray[i], roomDh - getElementDh(i));
        }
        else
        {
          if (fillsArray[i])
          {
            setElementDw(i, roomDw);
          }
          stripDh = Math.min(getElementDh(i), roomDh);
          currx = roomCx + getAlignOffset(alignsHorizontalArray[i], roomDw - getElementDw(i));
          if (docksArray[i] == EnumDocks.DOCK_BOTTOM())
          {
            curry = roomCy + roomDh - stripDh;
          }
          else
          {
            curry = roomCy;
            roomCy += stripDh + gap;
          }
          roomDh = Math.max(0, roomDh - stripDh - gap);
        }
        elementsArray[i].x = currx;
        elementsArray[i].y = curry;
      }
    }
    /**
     * Reads the coordinates of every element of this content back into that element: the
     * layouts above set the x and the y of them directly.
     */
    private function updateCxyOfElements():void
    {
      application.trace("<" + this + " ContentSingle updateCxyOfElements> called.", 1);
      for (var i:int = 0; i < elementsArray.length; i++)
      {
        if (elementsArray[i] is BaseSprite)
        {
          BaseSprite(elementsArray[i]).updateCxy();
        }
        else if (elementsArray[i] is BaseTextField)
        {
          BaseTextField(elementsArray[i]).updateCxy();
        }
      }
    }
    /**
     * Repositions the elements after this content has been resized. The flowing and the
     * docking layouts are the ones taking the room of this content, so the cells of the
     * other two have nothing to do here.
     */
    private function containerResized():void
    {
      application.trace("<" + this + " ContentSingle containerResized> called.", 1);
      if (orientation == EnumOrientations.ORIENTATION_FLOW()
        || orientation == EnumOrientations.ORIENTATION_DOCK())
      {
        reposElements();
      }
    }
    /**
     * Returns the room this content leaves between its elements and around them.
     */
    private function getGap():int
    {
      return application.getDynamicsConfig().getAppMargin() * gapFactor;
    }
    /**
     * Returns the width and the height needed by the children of the given sprite.
     * @param sprite the sprite the needed dimensions are calculated of
     */
    private function contentDimensionsRecalculationOnSprite(sprite:BaseSprite):Array
    {
      application.trace("<" + this + " ContentSingle contentDimensionsRecalculationOnSprite> called.", 1);
      application.trace("<" + this + " ContentSingle contentDimensionsRecalculationOnSprite> sprite: " + sprite, 0);
      var maxw:int = 0;
      var maxh:int = 0;
      for (var i:int = 0; i < sprite.numChildren; i++)
      {
        const child:DisplayObject = sprite.getChildAt(i);
        var childRight:int = 0;
        var childBottom:int = 0;
        if (child is BaseSprite)
        {
          childRight = BaseSprite(child).getCx() + BaseSprite(child).getDw();
          childBottom = BaseSprite(child).getCy() + BaseSprite(child).getDh();
        }
        else if (child is BaseTextField)
        {
          childRight = BaseTextField(child).getCx() + BaseTextField(child).getDw();
          childBottom = BaseTextField(child).getCy() + BaseTextField(child).getDh();
        }
        else
        {
          childRight = child.x + child.width;
          childBottom = child.y + child.height;
        }
        if (maxw < childRight)
        {
          maxw = childRight;
        }
        if (maxh < childBottom)
        {
          maxh = childBottom;
        }
      }
      return [maxw, maxh];
    }
    /**
     * Frees all listeners, events and references held by this content.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ContentSingle destroy> called.", 1);
      application.trace("<" + this + " ContentSingle destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), marginChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_MODE_CHANGED(), contentResized);
      application.trace("<" + this + " ContentSingle destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventElementsRepositioned.stopImmediatePropagation();
      elementsArray.splice(0);
      sizeConsidersArray.splice(0);
      cellIndexesArray.splice(0);
      alignsHorizontalArray.splice(0);
      alignsVerticalArray.splice(0);
      fillsArray.splice(0);
      docksArray.splice(0);
      application.trace("<" + this + " ContentSingle destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      baseSprite = null;
      baseScroll = null;
      elementsArray = null;
      sizeConsidersArray = null;
      cellIndexesArray = null;
      alignsHorizontalArray = null;
      alignsVerticalArray = null;
      fillsArray = null;
      docksArray = null;
      orientation = null;
      elementsFix = 0;
      gapFactor = 0;
      eventElementsRepositioned = null;
      reposElementsInProgress = false;
      reposElementsPending = false;
      enableScrollingFromOthers = false;
    }
  }
}
