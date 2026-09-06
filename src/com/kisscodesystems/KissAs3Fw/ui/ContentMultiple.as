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
 * ContentMultiple.
 * A set of single contents with a button bar above them to navigate between them.
 *
 * MAIN FEATURES:
 * - one button bar holding one button per content
 * - a set of single content objects, only the active one is visible
 * - the -1 active index can be set to hide every content
 * - a content can be hidden from the button bar: it stays reachable by its index and
 *   by its label, but only from the inside of the application
 * - the newer contents go under the previous ones
 * - every content call is forwarded to the single content of the given index
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseScroll;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonBar;
  import com.kisscodesystems.KissAs3Fw.ui.ContentSingle;
  import flash.display.DisplayObject;
  import flash.events.Event;
  public class ContentMultiple extends BaseSprite
  {
    private var buttonBar:ButtonBar = null;
    private var contentSinglesArray:Array = null;
    /**
     * Constructs the ContentMultiple object and creates its button bar.
     * @param applicationRef the main application reference
     */
    public function ContentMultiple(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ContentMultiple> called.", 1);
      application.trace("<" + this + " ContentMultiple> applicationRef: " + applicationRef, 0);
      contentSinglesArray = new Array();
      buttonBar = new ButtonBar(application);
      addChild(buttonBar);
      buttonBar.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), buttonBarChanged);
      buttonBar.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonBarResized);
      application.trace("<" + this + " ContentMultiple> constructed.", 1);
    }
    /**
     * Returns the height taken by the button bar, zero if it is not visible.
     */
    public function getButtonBarCyAndHeight():int
    {
      application.trace("<" + this + " ContentMultiple getButtonBarCyAndHeight> called.", 1);
      if (buttonBar != null)
      {
        return buttonBar.visible ? buttonBar.getCy(true) : 0;
      }
      else
      {
        return 0;
      }
    }
    /**
     * Enables or disables this object and its button bar.
     * @param e true if this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " ContentMultiple setEnabled> called.", 1);
      application.trace("<" + this + " ContentMultiple setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (buttonBar != null)
      {
        buttonBar.setEnabled(getEnabled());
      }
    }
    /**
     * Returns the number of the single contents.
     */
    public function getNumOfContents():int
    {
      return contentSinglesArray.length;
    }
    /**
     * Returns the single content of the given index.
     * @param index the index of the single content
     */
    public function getContentSingle(index:int):ContentSingle
    {
      return ContentSingle(contentSinglesArray[index]);
    }
    /**
     * Returns the base scroll of the single content of the given index.
     * @param index the index of the single content
     */
    public function getBaseScroll(index:int):BaseScroll
    {
      application.trace("<" + this + " ContentMultiple getBaseScroll> called.", 1);
      application.trace("<" + this + " ContentMultiple getBaseScroll> index: " + index, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        return ContentSingle(contentSinglesArray[index]).getBaseScroll();
      }
      else
      {
        return null;
      }
    }
    /**
     * Returns the base sprite of the single content of the given index.
     * @param index the index of the single content
     */
    public function getBaseSprite(index:int):BaseSprite
    {
      application.trace("<" + this + " ContentMultiple getBaseSprite> called.", 1);
      application.trace("<" + this + " ContentMultiple getBaseSprite> index: " + index, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        return ContentSingle(contentSinglesArray[index]).getBaseSprite();
      }
      else
      {
        return null;
      }
    }
    /**
     * Returns the index of the active content.
     */
    public function getActiveIndex():int
    {
      return buttonBar.getActiveIndex();
    }
    /**
     * Makes the content of the given index the active one.
     * @param index the index of the content to be activated
     */
    public function setActiveIndex(index:int):void
    {
      application.trace("<" + this + " ContentMultiple setActiveIndex> called.", 1);
      application.trace("<" + this + " ContentMultiple setActiveIndex> index: " + index, 0);
      buttonBar.setActiveIndex(index);
    }
    /**
     * Returns the index of the content having the given label or -1 if there is no such content.
     * @param label the label the content is searched by
     */
    public function getContentIndexByLabel(label:String):int
    {
      return buttonBar.getIndexByLabel(label);
    }
    /**
     * Shows or hides the button bar and repositions everything afterwards.
     * @param v true if the button bar has to be visible
     */
    public function setButtonBarVisible(v:Boolean):void
    {
      application.trace("<" + this + " ContentMultiple setButtonBarVisible> called.", 1);
      application.trace("<" + this + " ContentMultiple setButtonBarVisible> v: " + v, 0);
      if (buttonBar.visible != v)
      {
        buttonBar.visible = v;
        buttonBarResized(null);
      }
    }
    /**
     * Returns true when the button of the content of the given index is shown on the
     * button bar, false when it is hidden or when there is no content of that index.
     * @param index the index of the single content
     */
    public function getContentButtonVisible(index:int):Boolean
    {
      return buttonBar.getButtonVisible(index);
    }
    /**
     * Shows or hides the button of the content of the given index. The content itself is
     * not touched: it stays the one that can be activated by its index and found by its
     * label, it only loses its own entry of the button bar, so the one using the
     * application can not navigate to it from there any more.
     * @param index the index of the single content
     * @param v true when the button of that content has to be shown on the button bar
     */
    public function setContentButtonVisible(index:int, v:Boolean):void
    {
      application.trace("<" + this + " ContentMultiple setContentButtonVisible> called.", 1);
      application.trace("<" + this + " ContentMultiple setContentButtonVisible> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setContentButtonVisible> v: " + v, 0);
      buttonBar.setButtonVisible(index, v);
    }
    /**
     * Creates the one and only default content and hides the button bar above it.
     */
    public function setDefaultContent():void
    {
      application.trace("<" + this + " ContentMultiple setDefaultContent> called.", 1);
      addContent(EnumTextKeys.DEFAULT_CONTENT());
      setActiveIndex(0);
      setButtonBarVisible(false);
    }
    /**
     * Creates a new single content and its button, returns -1 if the label is already in use.
     * @param label the label of the button of the new content
     * @param it the icon type of the button of the new content
     */
    public function addContent(label:String, it:String = ""):int
    {
      application.trace("<" + this + " ContentMultiple addContent> called.", 1);
      application.trace("<" + this + " ContentMultiple addContent> label: " + label, 0);
      application.trace("<" + this + " ContentMultiple addContent> it: " + it, 0);
      if (buttonBar.getIndexByLabel(label) == -1)
      {
        buttonBar.addButton(label, it);
        const contentSingle:ContentSingle = new ContentSingle(application);
        addChildAt(contentSingle, 0);
        contentSingle.visible = false;
        resizeContent(contentSingle);
        contentSinglesArray.push(contentSingle);
        return contentSinglesArray.length - 1;
      }
      else
      {
        return -1;
      }
    }
    /**
     * Creates a new single content whose button is hidden from the button bar, returns
     * -1 if the label is already in use. Such a content is reachable by its index and by
     * its label only, so the one using the application finds it when something inside
     * the application navigates there, and never on the button bar.
     * @param label the label of the new content, the name it can be looked up by
     */
    public function addHiddenContent(label:String):int
    {
      application.trace("<" + this + " ContentMultiple addHiddenContent> called.", 1);
      application.trace("<" + this + " ContentMultiple addHiddenContent> label: " + label, 0);
      const index:int = addContent(label);
      setContentButtonVisible(index, false);
      return index;
    }
    /**
     * Destroys and removes the single content of the given index and its button.
     * @param index the index of the content to be removed
     */
    public function removeContent(index:int):void
    {
      application.trace("<" + this + " ContentMultiple removeContent> called.", 1);
      application.trace("<" + this + " ContentMultiple removeContent> index: " + index, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        buttonBar.removeButton(index);
        const contentSingle:ContentSingle = ContentSingle(contentSinglesArray[index]);
        if (contentSingle != null)
        {
          contentSingle.destroy();
          if (contains(contentSingle))
          {
            removeChild(contentSingle);
          }
        }
        contentSinglesArray.splice(index, 1);
        // the button bar has already settled its active index, the visible content follows it
        setActiveContent(buttonBar.getActiveIndex());
      }
    }
    /**
     * Destroys and removes every single content and every button of the button bar.
     */
    public function removeAllContents():void
    {
      application.trace("<" + this + " ContentMultiple removeAllContents> called.", 1);
      buttonBar.removeAllButtons();
      for (var i:int = 0; i < contentSinglesArray.length; i++)
      {
        const contentSingle:ContentSingle = ContentSingle(contentSinglesArray[i]);
        if (contentSingle != null)
        {
          contentSingle.destroy();
          if (contains(contentSingle))
          {
            removeChild(contentSingle);
          }
        }
      }
      contentSinglesArray.splice(0);
    }
    /**
     * Returns the cell index of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the cell index is asked of
     */
    public function getCellIndex(index:int, displayObject:DisplayObject):int
    {
      application.trace("<" + this + " ContentMultiple getCellIndex> called.", 1);
      application.trace("<" + this + " ContentMultiple getCellIndex> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple getCellIndex> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getCellIndex(displayObject);
      }
      return -1;
    }
    /**
     * Changes the cell index of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the cell index has to be changed of
     * @param cellIndex the new cell index of that element
     */
    public function changeCellIndex(index:int, displayObject:DisplayObject, cellIndex:int):void
    {
      application.trace("<" + this + " ContentMultiple changeCellIndex> called.", 1);
      application.trace("<" + this + " ContentMultiple changeCellIndex> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple changeCellIndex> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple changeCellIndex> cellIndex: " + cellIndex, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).changeCellIndex(displayObject, cellIndex);
      }
    }
    /**
     * Returns the horizontal align of an element of the single content of the given
     * index, or null when that element is not in that content.
     * @param index the index of the single content
     * @param displayObject the element the horizontal align is asked of
     */
    public function getElementAlignHorizontal(index:int, displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentMultiple getElementAlignHorizontal> called.", 1);
      application.trace("<" + this + " ContentMultiple getElementAlignHorizontal> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple getElementAlignHorizontal> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getElementAlignHorizontal(displayObject);
      }
      return null;
    }
    /**
     * Sets the horizontal align of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the horizontal align has to be set of
     * @param align the new horizontal align, a horizontal EnumAligns value
     */
    public function setElementAlignHorizontal(index:int, displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " ContentMultiple setElementAlignHorizontal> called.", 1);
      application.trace("<" + this + " ContentMultiple setElementAlignHorizontal> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setElementAlignHorizontal> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple setElementAlignHorizontal> align: " + align, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).setElementAlignHorizontal(displayObject, align);
      }
    }
    /**
     * Returns the vertical align of an element of the single content of the given index,
     * or null when that element is not in that content.
     * @param index the index of the single content
     * @param displayObject the element the vertical align is asked of
     */
    public function getElementAlignVertical(index:int, displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentMultiple getElementAlignVertical> called.", 1);
      application.trace("<" + this + " ContentMultiple getElementAlignVertical> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple getElementAlignVertical> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getElementAlignVertical(displayObject);
      }
      return null;
    }
    /**
     * Sets the vertical align of an element of the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element the vertical align has to be set of
     * @param align the new vertical align, a vertical EnumAligns value
     */
    public function setElementAlignVertical(index:int, displayObject:DisplayObject, align:String):void
    {
      application.trace("<" + this + " ContentMultiple setElementAlignVertical> called.", 1);
      application.trace("<" + this + " ContentMultiple setElementAlignVertical> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setElementAlignVertical> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple setElementAlignVertical> align: " + align, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).setElementAlignVertical(displayObject, align);
      }
    }
    /**
     * Returns true when an element of the single content of the given index has been set
     * to fill its own cell.
     * @param index the index of the single content
     * @param displayObject the element the fill is asked of
     */
    public function getElementFill(index:int, displayObject:DisplayObject):Boolean
    {
      application.trace("<" + this + " ContentMultiple getElementFill> called.", 1);
      application.trace("<" + this + " ContentMultiple getElementFill> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple getElementFill> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getElementFill(displayObject);
      }
      return false;
    }
    /**
     * Sets whether an element of the single content of the given index fills its own cell.
     * @param index the index of the single content
     * @param displayObject the element the fill has to be set of
     * @param fill true when that element has to fill its own cell
     */
    public function setElementFill(index:int, displayObject:DisplayObject, fill:Boolean):void
    {
      application.trace("<" + this + " ContentMultiple setElementFill> called.", 1);
      application.trace("<" + this + " ContentMultiple setElementFill> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setElementFill> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple setElementFill> fill: " + fill, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).setElementFill(displayObject, fill);
      }
    }
    /**
     * Returns the side an element of the single content of the given index is docked to,
     * or null when that element is not in that content.
     * @param index the index of the single content
     * @param displayObject the element the dock is asked of
     */
    public function getElementDock(index:int, displayObject:DisplayObject):String
    {
      application.trace("<" + this + " ContentMultiple getElementDock> called.", 1);
      application.trace("<" + this + " ContentMultiple getElementDock> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple getElementDock> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getElementDock(displayObject);
      }
      return null;
    }
    /**
     * Sets the side an element of the single content of the given index is docked to.
     * @param index the index of the single content
     * @param displayObject the element the dock has to be set of
     * @param dock the side to dock that element to, an EnumDocks value
     */
    public function setElementDock(index:int, displayObject:DisplayObject, dock:String):void
    {
      application.trace("<" + this + " ContentMultiple setElementDock> called.", 1);
      application.trace("<" + this + " ContentMultiple setElementDock> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setElementDock> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple setElementDock> dock: " + dock, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).setElementDock(displayObject, dock);
      }
    }
    /**
     * Returns the number of the application margins the single content of the given index
     * leaves between its elements and around them, or zero for an index of no content.
     * @param index the index of the single content
     */
    public function getGapFactor(index:int):int
    {
      application.trace("<" + this + " ContentMultiple getGapFactor> called.", 1);
      application.trace("<" + this + " ContentMultiple getGapFactor> index: " + index, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        return ContentSingle(contentSinglesArray[index]).getGapFactor();
      }
      return 0;
    }
    /**
     * Sets the room the single content of the given index leaves between its elements and
     * around them, counted in the margins of the application.
     * @param index the index of the single content
     * @param factor the number of the application margins to leave, zero or more
     */
    public function setGapFactor(index:int, factor:int):void
    {
      application.trace("<" + this + " ContentMultiple setGapFactor> called.", 1);
      application.trace("<" + this + " ContentMultiple setGapFactor> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setGapFactor> factor: " + factor, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).setGapFactor(factor);
      }
    }
    /**
     * Adds a new element into the single content of the given index.
     * @param index the index of the single content
     * @param displayObject the element to be added
     * @param cellIndex the cell index of that element
     * @param sizeConsider true if the dimensions of that element count in the cell dimensions
     * @param to0 true if that element has to be added to the lowest depth
     */
    public function addToContent(index:int, displayObject:DisplayObject, cellIndex:int, sizeConsider:Boolean = true, to0:Boolean = false):void
    {
      application.trace("<" + this + " ContentMultiple addToContent> called.", 1);
      application.trace("<" + this + " ContentMultiple addToContent> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple addToContent> displayObject: " + displayObject, 0);
      application.trace("<" + this + " ContentMultiple addToContent> cellIndex: " + cellIndex, 0);
      application.trace("<" + this + " ContentMultiple addToContent> sizeConsider: " + sizeConsider, 0);
      application.trace("<" + this + " ContentMultiple addToContent> to0: " + to0, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).addToContent(displayObject, cellIndex, sizeConsider, to0);
      }
    }
    /**
     * Removes an element from the single content of the given index without destroying it.
     * @param index the index of the single content
     * @param displayObject the element to be removed
     */
    public function removeFromContent(index:int, displayObject:DisplayObject):void
    {
      application.trace("<" + this + " ContentMultiple removeFromContent> called.", 1);
      application.trace("<" + this + " ContentMultiple removeFromContent> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple removeFromContent> displayObject: " + displayObject, 0);
      if (index >= 0 && index < contentSinglesArray.length)
      {
        ContentSingle(contentSinglesArray[index]).removeFromContent(displayObject);
      }
    }
    /**
     * Sets the x and y coordinates of the scrolled content of the single content of the given
     * index.
     * @param index the index of the single content
     * @param newCxContent the new x coordinate of the content
     * @param newCyContent the new y coordinate of the content
     * @param toDispatchEvents is it necessary to dispatch events to the outside
     */
    public function setContentPosition(index:int, newCxContent:int, newCyContent:int, toDispatchEvents:Boolean):void
    {
      application.trace("<" + this + " ContentMultiple setContentPosition> called.", 1);
      application.trace("<" + this + " ContentMultiple setContentPosition> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setContentPosition> newCxContent: " + newCxContent, 0);
      application.trace("<" + this + " ContentMultiple setContentPosition> newCyContent: " + newCyContent, 0);
      application.trace("<" + this + " ContentMultiple setContentPosition> toDispatchEvents: " + toDispatchEvents, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        ContentSingle(contentSinglesArray[index]).setContentPosition(newCxContent, newCyContent, toDispatchEvents);
      }
    }
    /**
     * Returns the width of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     */
    public function getDwContent(index:int):int
    {
      application.trace("<" + this + " ContentMultiple getDwContent> called.", 1);
      application.trace("<" + this + " ContentMultiple getDwContent> index: " + index, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        return ContentSingle(contentSinglesArray[index]).getDwContent();
      }
      else
      {
        return 0;
      }
    }
    /**
     * Returns the height of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     */
    public function getDhContent(index:int):int
    {
      application.trace("<" + this + " ContentMultiple getDhContent> called.", 1);
      application.trace("<" + this + " ContentMultiple getDhContent> index: " + index, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        return ContentSingle(contentSinglesArray[index]).getDhContent();
      }
      else
      {
        return 0;
      }
    }
    /**
     * Sets the dimensions of the scrolled content of the single content of the given index.
     * @param index the index of the single content
     * @param newdw the new width of the content
     * @param newdh the new height of the content
     */
    public function setDwhContent(index:int, newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ContentMultiple setDwhContent> called.", 1);
      application.trace("<" + this + " ContentMultiple setDwhContent> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setDwhContent> newdw: " + newdw, 0);
      application.trace("<" + this + " ContentMultiple setDwhContent> newdh: " + newdh, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        ContentSingle(contentSinglesArray[index]).setDwhContent(newdw, newdh);
      }
    }
    /**
     * Returns the elements fix of the single content of the given index.
     * @param index the index of the single content
     */
    public function getElementsFix(index:int):int
    {
      application.trace("<" + this + " ContentMultiple getElementsFix> called.", 1);
      application.trace("<" + this + " ContentMultiple getElementsFix> index: " + index, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        return ContentSingle(contentSinglesArray[index]).getElementsFix();
      }
      else
      {
        return 0;
      }
    }
    /**
     * Sets the elements fix of the single content of the given index.
     * @param index the index of the single content
     * @param e the new number of the elements of the fix row or column
     */
    public function setElementsFix(index:int, e:int):void
    {
      application.trace("<" + this + " ContentMultiple setElementsFix> called.", 1);
      application.trace("<" + this + " ContentMultiple setElementsFix> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setElementsFix> e: " + e, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        ContentSingle(contentSinglesArray[index]).setElementsFix(e);
      }
    }
    /**
     * Sets the orientation of the single content of the given index.
     * @param index the index of the single content
     * @param o the new orientation, an EnumOrientations value
     */
    public function setOrientation(index:int, o:String):void
    {
      application.trace("<" + this + " ContentMultiple setOrientation> called.", 1);
      application.trace("<" + this + " ContentMultiple setOrientation> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setOrientation> o: " + o, 0);
      if (contentSinglesArray[index] is ContentSingle)
      {
        ContentSingle(contentSinglesArray[index]).setOrientation(o);
      }
    }
    /**
     * Frees the leading slot of the button of the given index up: the icon of it and the
     * emoji of it as well.
     * @param index the index of the button the leading slot is freed up of
     */
    public function destIcon(index:int):void
    {
      application.trace("<" + this + " ContentMultiple destIcon> called.", 1);
      application.trace("<" + this + " ContentMultiple destIcon> index: " + index, 0);
      if (buttonBar != null)
      {
        buttonBar.destIcon(index);
      }
    }
    /**
     * Sets the icon of the button of the given index.
     * @param index the index of the button the icon is set of
     * @param it the new icon type
     */
    public function setIcon(index:int, it:String):void
    {
      application.trace("<" + this + " ContentMultiple setIcon> called.", 1);
      application.trace("<" + this + " ContentMultiple setIcon> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setIcon> it: " + it, 0);
      if (buttonBar != null)
      {
        buttonBar.setIcon(index, it);
      }
    }
    /**
     * Sets the icon of the button of the given index if that button is not the active one.
     * @param index the index of the button the icon is set of
     * @param it the new icon type
     */
    public function setIconIfNotActive(index:int, it:String):void
    {
      application.trace("<" + this + " ContentMultiple setIconIfNotActive> called.", 1);
      application.trace("<" + this + " ContentMultiple setIconIfNotActive> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setIconIfNotActive> it: " + it, 0);
      if (buttonBar != null)
      {
        buttonBar.setIconIfNotActive(index, it);
      }
    }
    /**
     * Sets the emoji of the button of the given index. An emoji and an icon stand in the
     * very same slot of a button, so they are exclusive to each other.
     * @param index the index of the button the emoji is set of
     * @param et the new emoji type
     */
    public function setEmoji(index:int, et:String):void
    {
      application.trace("<" + this + " ContentMultiple setEmoji> called.", 1);
      application.trace("<" + this + " ContentMultiple setEmoji> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setEmoji> et: " + et, 0);
      if (buttonBar != null)
      {
        buttonBar.setEmoji(index, et);
      }
    }
    /**
     * Sets the emoji of the button of the given index if that button is not the active one.
     * @param index the index of the button the emoji is set of
     * @param et the new emoji type
     */
    public function setEmojiIfNotActive(index:int, et:String):void
    {
      application.trace("<" + this + " ContentMultiple setEmojiIfNotActive> called.", 1);
      application.trace("<" + this + " ContentMultiple setEmojiIfNotActive> index: " + index, 0);
      application.trace("<" + this + " ContentMultiple setEmojiIfNotActive> et: " + et, 0);
      if (buttonBar != null)
      {
        buttonBar.setEmojiIfNotActive(index, et);
      }
    }
    /**
     * Returns the width available for one single content.
     */
    public function getContentDw():int
    {
      return getDw();
    }
    /**
     * Returns the height available for one single content.
     */
    public function getContentDh():int
    {
      return getDh() - getButtonBarCyAndHeight();
    }
    /**
     * Sets the width of this object and resizes the button bar and every content.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ContentMultiple setDw> called.", 1);
      application.trace("<" + this + " ContentMultiple setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        resizeAllContents();
        buttonBar.setMaxWidth(getDw());
        buttonBarRepos();
      }
    }
    /**
     * Sets the height of this object and resizes every content.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ContentMultiple setDh> called.", 1);
      application.trace("<" + this + " ContentMultiple setDh> newdh: " + newdh, 0);
      if (getDh() != newdh)
      {
        super.setDh(newdh);
        resizeAllContents();
      }
    }
    /**
     * Sets the dimensions of this object and resizes the button bar and every content.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ContentMultiple setDwh> called.", 1);
      application.trace("<" + this + " ContentMultiple setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ContentMultiple setDwh> newdh: " + newdh, 0);
      if (getDw() != newdw || getDh() != newdh)
      {
        super.setDwh(newdw, newdh);
        resizeAllContents();
        buttonBar.setMaxWidth(getDw());
        buttonBarRepos();
      }
    }
    /**
     * Activates the selected content and forwards the changed event of the button bar.
     * @param e the changed event of the button bar
     */
    private function buttonBarChanged(e:Event):void
    {
      application.trace("<" + this + " ContentMultiple buttonBarChanged> called.", 1);
      application.trace("<" + this + " ContentMultiple buttonBarChanged> e: " + e, 0);
      setActiveContent(buttonBar.getActiveIndex());
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(e);
      }
    }
    /**
     * Repositions the button bar and resizes every content below it.
     * @param e the dimensions changed event of the button bar, null if it is called by hand
     */
    private function buttonBarResized(e:Event):void
    {
      application.trace("<" + this + " ContentMultiple buttonBarResized> called.", 1);
      application.trace("<" + this + " ContentMultiple buttonBarResized> e: " + e, 0);
      buttonBarRepos();
      resizeAllContents();
    }
    /**
     * Positions the button bar to the horizontal center of this object.
     */
    private function buttonBarRepos():void
    {
      application.trace("<" + this + " ContentMultiple buttonBarRepos> called.", 1);
      buttonBar.setCxy((getDw() - buttonBar.getDw()) / 2, 0);
    }
    /**
     * Makes the content of the given index the only visible one, -1 hides every content.
     * @param index the index of the content to be shown
     */
    private function setActiveContent(index:int):void
    {
      application.trace("<" + this + " ContentMultiple setActiveContent> called.", 1);
      application.trace("<" + this + " ContentMultiple setActiveContent> index: " + index, 0);
      if (index >= -1 && index < contentSinglesArray.length)
      {
        for (var i:int = 0; i < contentSinglesArray.length; i++)
        {
          ContentSingle(contentSinglesArray[i]).visible = false;
        }
        if (index != -1)
        {
          ContentSingle(contentSinglesArray[index]).visible = true;
        }
      }
    }
    /**
     * Repositions and resizes every single content.
     */
    private function resizeAllContents():void
    {
      application.trace("<" + this + " ContentMultiple resizeAllContents> called.", 1);
      for (var i:int = 0; i < contentSinglesArray.length; i++)
      {
        resizeContent(ContentSingle(contentSinglesArray[i]));
      }
    }
    /**
     * Repositions and resizes one single content to the area below the button bar.
     * @param content the single content to be repositioned and resized
     */
    private function resizeContent(content:ContentSingle):void
    {
      application.trace("<" + this + " ContentMultiple resizeContent> called.", 1);
      application.trace("<" + this + " ContentMultiple resizeContent> content: " + content, 0);
      content.setCxy(0, getButtonBarCyAndHeight());
      content.setDwh(getContentDw(), getContentDh());
    }
    /**
     * Frees all listeners and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ContentMultiple destroy> called.", 1);
      application.trace("<" + this + " ContentMultiple destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.trace("<" + this + " ContentMultiple destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      contentSinglesArray.splice(0);
      application.trace("<" + this + " ContentMultiple destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      buttonBar = null;
      contentSinglesArray = null;
    }
  }
}
