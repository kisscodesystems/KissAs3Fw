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
 * BaseList.
 * A column of text labels with a marking shape behind them.
 *
 * MAIN FEATURES:
 * - one text label per element, all of them of the same text type
 * - every element can be marked in two different strengths, or left unmarked
 * - the height is determined by the number of the elements, it can not be set from outside
 * - the elements are repositioned and remarked on every style change they depend on
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class BaseList extends BaseSprite
  {
    private var textLabelArray:Array = null;
    private var textMarkedArray:Array = null;
    private var textType:String = null;
    private var mark:BaseShape = null;
    /**
     * Constructs the BaseList object and creates the shape its elements are marked on.
     * @param applicationRef the main application reference
     */
    public function BaseList(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseList> called.", 1);
      application.trace("<" + this + " BaseList> applicationRef: " + applicationRef, 0);
      textLabelArray = new Array();
      textMarkedArray = new Array();
      mark = new BaseShape(application);
      addChild(mark);
      textType = EnumTextTypes.TEXT_TYPE_BRIGHT();
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundColorAlphaChanged);
      application.trace("<" + this + " BaseList> constructed.", 1);
    }
    /**
     * Returns the number of the elements of this list.
     */
    public function getNumOfElements():int
    {
      return textLabelArray.length;
    }
    /**
     * Creates or removes elements so that this list holds the given number of them.
     * @param numOfElements the number of the elements this list has to hold
     */
    public function setNumOfElements(numOfElements:int):void
    {
      application.trace("<" + this + " BaseList setNumOfElements> called.", 1);
      application.trace("<" + this + " BaseList setNumOfElements> numOfElements: " + numOfElements, 0);
      if (numOfElements >= 0)
      {
        if (textLabelArray.length < numOfElements)
        {
          while (textLabelArray.length < numOfElements)
          {
            addElement();
          }
          setHeight();
        }
        else if (textLabelArray.length > numOfElements)
        {
          removeElementsFromIndex(numOfElements);
          setHeight();
        }
      }
    }
    /**
     * Returns the text type of the elements of this list.
     */
    public function getTextType():String
    {
      return textType;
    }
    /**
     * Sets the text type of every element of this list.
     * @param newTextType the new text type, an EnumTextTypes value
     */
    public function setTextType(newTextType:String):void
    {
      application.trace("<" + this + " BaseList setTextType> called.", 1);
      application.trace("<" + this + " BaseList setTextType> newTextType: " + newTextType, 0);
      if (textType != newTextType)
      {
        textType = newTextType;
        for (var i:int = 0; i < textLabelArray.length; i++)
        {
          TextLabel(textLabelArray[i]).setType(newTextType);
        }
        // the new text type may come with a different text format, so the heights change
        setHeight();
      }
    }
    /**
     * Sets the label of the element of the given index, does nothing on an invalid index.
     * @param i the index of the element
     * @param newLabel the text code of the new label of that element
     * @param newIconType the icon type of that element, no icon on a null or an empty one
     * @param newTabcnt the number of the tabulators that element is indented by
     */
    public function setLabel(i:int, newLabel:String, newIconType:String = null, newTabcnt:int = 0):void
    {
      application.trace("<" + this + " BaseList setLabel> called.", 1);
      application.trace("<" + this + " BaseList setLabel> i: " + i, 0);
      application.trace("<" + this + " BaseList setLabel> newLabel: " + newLabel, 0);
      application.trace("<" + this + " BaseList setLabel> newIconType: " + newIconType, 0);
      application.trace("<" + this + " BaseList setLabel> newTabcnt: " + newTabcnt, 0);
      if (i > -1 && i < textLabelArray.length)
      {
        const textLabel:TextLabel = TextLabel(textLabelArray[i]);
        textLabel.setCx(newTabcnt * textLabel.getDh());
        textLabel.setLabel(newLabel);
        if (newIconType != null && newIconType != "")
        {
          textLabel.setIcon(newIconType);
        }
        else
        {
          textLabel.destIcon();
        }
      }
    }
    /**
     * Stores the marking state of the element of the given index, does nothing on an invalid
     * index or an invalid state. The markElements() has to be called to make it visible.
     * @param i the index of the element
     * @param marking the new marking state: 0 is unmarked, 1 and 2 are the two strengths
     */
    public function markElement(i:int, marking:int):void
    {
      application.trace("<" + this + " BaseList markElement> called.", 1);
      application.trace("<" + this + " BaseList markElement> i: " + i, 0);
      application.trace("<" + this + " BaseList markElement> marking: " + marking, 0);
      if (i > -1 && i < textLabelArray.length)
      {
        if (marking == 0 || marking == 1 || marking == 2)
        {
          textMarkedArray[i] = marking;
        }
      }
    }
    /**
     * Redraws the marking shape from the marking states of the elements.
     */
    public function markElements():void
    {
      application.trace("<" + this + " BaseList markElements> called.", 1);
      if (application != null)
      {
        mark.graphics.clear();
        mark.graphics.lineStyle(0, 0, 0);
        for (var i:int = 0; i < textMarkedArray.length; i++)
        {
          // an unmarked element leaves its own area of the marking shape blank
          if (textMarkedArray[i] == 1)
          {
            drawMark(Math.max(application.getComponentsConfig().getBaseListMarkMinAlpha1()
              , application.getDynamicsConfig().getAppBackgroundColorAlpha() * application.getComponentsConfig().getBaseListMarkAlpha1Factor()), i);
          }
          else if (textMarkedArray[i] == 2)
          {
            drawMark(Math.max(application.getComponentsConfig().getBaseListMarkMinAlpha2()
              , application.getDynamicsConfig().getAppBackgroundColorAlpha() * application.getComponentsConfig().getBaseListMarkAlpha2Factor()), i);
          }
        }
      }
    }
    /**
     * Sets the width of this list and of every element of it.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseList setDw> called.", 1);
      application.trace("<" + this + " BaseList setDw> newdw: " + newdw, 0);
      if (newdw != getDw())
      {
        for (var i:int = 0; i < textLabelArray.length; i++)
        {
          TextLabel(textLabelArray[i]).setMaxWidth(newdw, false);
        }
      }
      super.setDw(newdw);
    }
    /**
     * The height of this list comes from the number of its elements, so it does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseList setDh> called.", 1);
      application.trace("<" + this + " BaseList setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " BaseList setDh> do nothing.", 1);
    }
    /**
     * The height of this list comes from the number of its elements, so it does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseList setDwh> called.", 1);
      application.trace("<" + this + " BaseList setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseList setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " BaseList setDwh> do nothing.", 1);
    }
    /**
     * Remarks the elements after the dimensions of this list have been changed.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " BaseList doDimensionsChanged> called.", 1);
      markElements();
      super.doDimensionsChanged();
    }
    /**
     * Creates one new element at the end of this list and registers its listener.
     */
    private function addElement():void
    {
      application.trace("<" + this + " BaseList addElement> called.", 1);
      const textLabel:TextLabel = new TextLabel(application);
      addChild(textLabel);
      textLabel.setLabel("");
      textLabel.setType(textType);
      textLabel.setMaxWidth(getDw(), false);
      textLabel.setCxy(0, textLabelArray.length * application.getDynamicsConfig().getTextFieldHeight(textType));
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), textLabelResized);
      textLabelArray.push(textLabel);
      textMarkedArray.push(0);
    }
    /**
     * Destroys and removes every element standing from the given index to the end of this list.
     * @param index the index of the first element to be removed
     */
    private function removeElementsFromIndex(index:int):void
    {
      application.trace("<" + this + " BaseList removeElementsFromIndex> called.", 1);
      application.trace("<" + this + " BaseList removeElementsFromIndex> index: " + index, 0);
      for (var i:int = index; i < textLabelArray.length; i++)
      {
        if (textLabelArray[i] is TextLabel)
        {
          const textLabel:TextLabel = TextLabel(textLabelArray[i]);
          textLabel.destroy();
          if (contains(textLabel))
          {
            removeChild(textLabel);
          }
        }
        textLabelArray[i] = null;
        textMarkedArray[i] = null;
      }
      textLabelArray.splice(index);
      textMarkedArray.splice(index);
    }
    /**
     * Repositions and remarks the elements and sets the height of this list to the height
     * every element of it needs together.
     */
    private function setHeight():void
    {
      application.trace("<" + this + " BaseList setHeight> called.", 1);
      const textFieldHeight:int = application.getDynamicsConfig().getTextFieldHeight(textType);
      for (var i:int = 0; i < textLabelArray.length; i++)
      {
        TextLabel(textLabelArray[i]).setCy(i * textFieldHeight);
      }
      markElements();
      super.setDh(textLabelArray.length * textFieldHeight);
    }
    /**
     * Draws the marking of one element onto the marking shape.
     * @param a the alpha the marking of that element is drawn with
     * @param i the index of that element
     */
    private function drawMark(a:Number, i:int):void
    {
      application.trace("<" + this + " BaseList drawMark> called.", 1);
      application.trace("<" + this + " BaseList drawMark> a: " + a, 0);
      application.trace("<" + this + " BaseList drawMark> i: " + i, 0);
      const textLabel:TextLabel = TextLabel(textLabelArray[i]);
      const radius:int = application.getDynamicsConfig().getAppRadius();
      mark.graphics.beginFill(application.getDynamicsConfig().getAppBackgroundColorBright(), a);
      mark.graphics.drawRoundRect(0, textLabel.getCy(), textLabel.getDw(), textLabel.getDh(), radius, radius);
      mark.graphics.endFill();
    }
    /**
     * Recalculates the height of this list after one of its elements has been resized,
     * because a new text format gives every element a new height.
     * @param e the dimensions changed event of that element
     */
    private function textLabelResized(e:Event):void
    {
      application.trace("<" + this + " BaseList textLabelResized> called.", 1);
      application.trace("<" + this + " BaseList textLabelResized> e: " + e, 0);
      setHeight();
    }
    /**
     * Remarks the elements after the radius of the application has been changed.
     * @param e the radius changed event
     */
    private function radiusChanged(e:Event):void
    {
      application.trace("<" + this + " BaseList radiusChanged> called.", 1);
      application.trace("<" + this + " BaseList radiusChanged> e: " + e, 0);
      markElements();
    }
    /**
     * Remarks the elements after the bright background color has been changed.
     * @param e the bright background color changed event
     */
    private function backgroundColorBrightChanged(e:Event):void
    {
      application.trace("<" + this + " BaseList backgroundColorBrightChanged> called.", 1);
      application.trace("<" + this + " BaseList backgroundColorBrightChanged> e: " + e, 0);
      markElements();
    }
    /**
     * Remarks the elements after the alpha of the background colors has been changed.
     * @param e the background color alpha changed event
     */
    private function backgroundColorAlphaChanged(e:Event):void
    {
      application.trace("<" + this + " BaseList backgroundColorAlphaChanged> called.", 1);
      application.trace("<" + this + " BaseList backgroundColorAlphaChanged> e: " + e, 0);
      markElements();
    }
    /**
     * Frees all listeners and references held by this list.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseList destroy> called.", 1);
      application.trace("<" + this + " BaseList destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), radiusChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), backgroundColorBrightChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), backgroundColorAlphaChanged);
      application.trace("<" + this + " BaseList destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      textLabelArray.splice(0);
      textMarkedArray.splice(0);
      application.trace("<" + this + " BaseList destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textLabelArray = null;
      textMarkedArray = null;
      textType = null;
      mark = null;
    }
  }
}
