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
 * Potmeter.
 * A numeric stepper that is dragged by the mouse instead of being typed into.
 * A rotating knob displays how far the current value stands between the minimum
 * and the maximum one, and a label next to it displays the value itself.
 *
 * MAIN FEATURES:
 * - the minimum, the maximum and the increment value can be specified
 * - the decimal precision of the displayed value can be specified too
 * - dragging upwards or to the right increases the value, the other way decreases it
 * - the number of the pixels one single increment needs comes from the range, so the
 *   whole range can always be dragged through
 * - a dragging takes this object above every other element of its parent, so the knob of
 *   it is never covered, and the end of that dragging puts it back onto the very depth it
 *   has come from
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class Potmeter extends BaseSprite
  {
    private var eventChanged:Event = null;
    private var background:BaseShape = null;
    private var spriteMover:BaseSprite = null;
    private var textLabel:TextLabel = null;
    private var sprite:BaseSprite = null;
    private var icon:Icon = null;
    private var minValue:Number = 0;
    private var maxValue:Number = 0;
    private var incValue:Number = 0;
    private var curValue:Number = 0;
    private var tmpValue:Number = 0;
    private var decimalPrecision:int = 2;
    // How many pixels have to be dragged to increase one single time.
    // At least one pixel per increment is calculated.
    private var pxsPerInc:int = 1;
    // The depth this object stands on inside its parent while it is not being dragged, a
    // minus one when there is no dragging going on at all. A drag takes it above every
    // other element of that parent, so the knob of it is never covered by them, and the
    // end of that drag puts it back onto the very depth it has come from: the lowest one
    // is the room of the background of the parent and not the one of this object.
    private var depthBeforeDragging:int = -1;
    /**
     * Constructs the Potmeter object: creates the background, the rotating knob, the
     * label of the current value and the invisible layer that takes the dragging.
     * @param applicationRef the main application reference
     */
    public function Potmeter(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Potmeter> called.", 1);
      application.trace("<" + this + " Potmeter> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      background = new BaseShape(application);
      addChild(background);
      sprite = new BaseSprite(application);
      addChild(sprite);
      icon = new Icon(application);
      sprite.addChild(icon);
      textLabel = new TextLabel(application);
      addChild(textLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resize);
      spriteMover = new BaseSprite(application);
      addChild(spriteMover);
      spriteMover.addEventListener(MouseEvent.MOUSE_DOWN, spriteMoverMouseDown, false, 0, true);
      spriteMover.mouseDownForScrollingEnabled = false;
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawBackground);
      resize();
      moverReset();
      application.trace("<" + this + " Potmeter> constructed.", 1);
    }
    /**
     * Returns the decimal precision the value of this object is displayed with.
     */
    public function getDecimalPrecision():int
    {
      return decimalPrecision;
    }
    /**
     * Sets the decimal precision the value of this object is displayed with. Only a
     * precision between zero and ten is taken.
     * @param i the number of the decimals to be displayed
     */
    public function setDecimalPrecision(i:int):void
    {
      application.trace("<" + this + " Potmeter setDecimalPrecision> called.", 1);
      application.trace("<" + this + " Potmeter setDecimalPrecision> i: " + i, 0);
      if (decimalPrecision != i && i >= 0 && i <= 10)
      {
        decimalPrecision = i;
        setCurValue(curValue);
      }
    }
    /**
     * Returns the current value of this object.
     */
    public function getCurValue():Number
    {
      return curValue;
    }
    /**
     * Sets the current value of this object and dispatches its changed event. A value
     * out of the range and a value that does not change anything are dropped.
     * @param n the new value
     * @param fireChangedEvent whether the changed event has to be dispatched. A value set
     *                         by the code of the application instead of the one using it
     *                         has to be a silent one: the caller knows the new value
     *                         already, and an event of it would be taken as a user action
     */
    public function setCurValue(n:Number, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " Potmeter setCurValue> called.", 1);
      application.trace("<" + this + " Potmeter setCurValue> n: " + n, 0);
      application.trace("<" + this + " Potmeter setCurValue> fireChangedEvent: " + fireChangedEvent, 0);
      const roundedValue:Number = roundToPrecision(n);
      if (n >= minValue && n <= maxValue && curValue != roundedValue)
      {
        curValue = roundedValue;
        tmpValue = curValue;
        updateDisplaying(curValue);
        if (fireChangedEvent && getBaseEventDispatcher() != null)
        {
          getBaseEventDispatcher().dispatchEvent(eventChanged);
        }
      }
    }
    /**
     * Returns the smallest value this object can take.
     */
    public function getMinValue():Number
    {
      return minValue;
    }
    /**
     * Returns the greatest value this object can take.
     */
    public function getMaxValue():Number
    {
      return maxValue;
    }
    /**
     * Returns the increment value one single step of this object means.
     */
    public function getIncValue():Number
    {
      return incValue;
    }
    /**
     * Sets the range and the increment value of this object. The difference of the
     * maximum and the minimum value has to be a multiply of the increment value,
     * every other setting is dropped, so the three getters above are the ones telling
     * what this object really stands with.
     * @param min the smallest value this object can take
     * @param max the greatest value this object can take
     * @param inc the increment value one single step means
     */
    public function setMinMaxIncValues(min:Number, max:Number, inc:Number):void
    {
      application.trace("<" + this + " Potmeter setMinMaxIncValues> called.", 1);
      application.trace("<" + this + " Potmeter setMinMaxIncValues> min: " + min, 0);
      application.trace("<" + this + " Potmeter setMinMaxIncValues> max: " + max, 0);
      application.trace("<" + this + " Potmeter setMinMaxIncValues> inc: " + inc, 0);
      if (min < max && inc > 0 && Math.floor((max - min) / inc) == (max - min) / inc)
      {
        minValue = min;
        maxValue = max;
        incValue = inc;
        calcPxsPerInc();
        if (curValue < minValue)
        {
          setCurValue(minValue);
        }
        else if (curValue > maxValue)
        {
          setCurValue(maxValue);
        }
        updateDisplaying(curValue);
      }
    }
    /**
     * The dimensions of this object come from its label and from the padding, so this
     * does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Potmeter setDw> called.", 1);
      application.trace("<" + this + " Potmeter setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Potmeter setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from its label and from the padding, so this
     * does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Potmeter setDh> called.", 1);
      application.trace("<" + this + " Potmeter setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Potmeter setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from its label and from the padding, so this
     * does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Potmeter setDwh> called.", 1);
      application.trace("<" + this + " Potmeter setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Potmeter setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Potmeter setDwh> do nothing.", 1);
    }
    /**
     * Renders this object in its initialized state and starts to listen to the mouse
     * releases of the stage, because the dragging has to stop wherever it happens.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Potmeter addedToStage> called.", 1);
      application.trace("<" + this + " Potmeter addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp, false, 0, true);
      }
      resize();
    }
    /**
     * Stops listening to the mouse releases of the stage when this object gets off it.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Potmeter removedFromStage> called.", 1);
      application.trace("<" + this + " Potmeter removedFromStage> e: " + e, 0);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      super.removedFromStage(e);
    }
    /**
     * Starts the dragging of this object when it is enabled.
     * @param e the mouse down event of the mover layer
     */
    private function spriteMoverMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Potmeter spriteMoverMouseDown> called.", 1);
      application.trace("<" + this + " Potmeter spriteMoverMouseDown> e: " + e, 0);
      if (getEnabled())
      {
        addEventListener(Event.ENTER_FRAME, updatePotmeter, false, 0, true);
        spriteMover.startDrag();
        keepDepth();
        toTheHighestDepth();
      }
    }
    /**
     * Closes the dragging as soon as the mouse has been released anywhere.
     * @param e the mouse up event of the stage
     */
    private function stageMouseUp(e:MouseEvent):void
    {
      application.trace("<" + this + " Potmeter stageMouseUp> called.", 1);
      application.trace("<" + this + " Potmeter stageMouseUp> e: " + e, 0);
      updateSizesByTextLabel();
      moverReset();
    }
    /**
     * Takes the value the current dragging means, kept inside the range of this
     * object, and displays it.
     * @param e the enter frame event of this object
     */
    private function updatePotmeter(e:Event):void
    {
      application.trace("<" + this + " Potmeter updatePotmeter> called.", 0);
      tmpValue = roundToPrecision(curValue
          - Math.round(spriteMover.y / pxsPerInc) * incValue
          + Math.round(spriteMover.x / pxsPerInc) * incValue);
      if (tmpValue < minValue)
      {
        tmpValue = minValue;
      }
      else if (tmpValue > maxValue)
      {
        tmpValue = maxValue;
      }
      application.trace("<" + this + " Potmeter updatePotmeter> tmpValue: " + tmpValue, 0);
      updateDisplaying(tmpValue);
    }
    /**
     * Stops the dragging, puts this object back onto the depth it has come from, takes the
     * dragged value and puts the mover layer back to its place. The depth is restored in
     * front of the value below, because the listeners of the changed event of it lay their
     * own elements out and they have to find this object standing where it belongs.
     */
    private function moverReset():void
    {
      application.trace("<" + this + " Potmeter moverReset> called.", 1);
      spriteMover.stopDrag();
      removeEventListener(Event.ENTER_FRAME, updatePotmeter);
      restoreDepth();
      if (getEnabled())
      {
        setCurValue(tmpValue);
      }
      spriteMover.x = 0;
      spriteMover.y = 0;
      updateShapes();
    }
    /**
     * Keeps the depth this object stands on inside its parent, so the end of the dragging
     * can put it back onto that very depth. An object that stands on no parent at all has
     * no depth to be kept.
     */
    private function keepDepth():void
    {
      application.trace("<" + this + " Potmeter keepDepth> called.", 1);
      depthBeforeDragging = parent != null ? parent.getChildIndex(this) : -1;
      application.trace("<" + this + " Potmeter keepDepth> depthBeforeDragging: " + depthBeforeDragging, 0);
    }
    /**
     * Puts this object back onto the depth it has stood on before the dragging. An object
     * that has not been dragged at all, one that stands on no parent any more and one whose
     * parent has lost elements since then stays exactly where it is.
     */
    private function restoreDepth():void
    {
      application.trace("<" + this + " Potmeter restoreDepth> called.", 1);
      if (depthBeforeDragging > -1 && parent != null
          && depthBeforeDragging < parent.numChildren)
      {
        parent.setChildIndex(this, depthBeforeDragging);
      }
      depthBeforeDragging = -1;
    }
    /**
     * Rounds the given value to the current decimal precision of this object.
     * @param value the value to be rounded
     */
    private function roundToPrecision(value:Number):Number
    {
      application.trace("<" + this + " Potmeter roundToPrecision> called.", 0);
      const multiplier:Number = Math.pow(10, decimalPrecision);
      return Math.round(value * multiplier) / multiplier;
    }
    /**
     * Redraws the knob and repositions everything after the text format or the
     * padding of the application has been changed.
     * @param e the dimensions changed event of the label, the mid text format or the
     * padding changed event of the application, null on a direct call
     */
    private function resize(e:Event = null):void
    {
      application.trace("<" + this + " Potmeter resize> called.", 1);
      application.trace("<" + this + " Potmeter resize> e: " + e, 0);
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(textLabel.getType());
      icon.drawBitmapData(EnumIcons.potmeter(), textLabel.getType(), tfh);
      icon.setCxy(-tfh / 2, -tfh / 2);
      sprite.setCxy(tfh / 2 + application.getDynamicsConfig().getAppPadding(), tfh / 2 + application.getDynamicsConfig().getAppPadding());
      reposTextLabel();
      updateShapes();
    }
    /**
     * Rotates the knob to the given value and displays that value on the label. The
     * decimal precision is not applied here, the caller has already applied it.
     * @param val the value to be displayed
     */
    private function updateDisplaying(val:Number):void
    {
      application.trace("<" + this + " Potmeter updateDisplaying> called.", 1);
      application.trace("<" + this + " Potmeter updateDisplaying> val: " + val, 0);
      if (maxValue > minValue)
      {
        const factor:Number = (val - minValue) / (maxValue - minValue);
        sprite.rotation = 240 * factor - 120;
      }
      textLabel.setLabel("" + val);
      reposTextLabel();
    }
    /**
     * Puts the label of the current value next to the knob, vertically centered.
     */
    private function reposTextLabel():void
    {
      application.trace("<" + this + " Potmeter reposTextLabel> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(textLabel.getType());
      textLabel.setCxy(tfh + padding, (tfh + 2 * padding - textLabel.getDh()) / 2);
      updateSizesByTextLabel();
    }
    /**
     * Sets the dimensions of this object to the room its label and its knob need.
     */
    private function updateSizesByTextLabel():void
    {
      application.trace("<" + this + " Potmeter updateSizesByTextLabel> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(textLabel.getType());
      super.setDwh(textLabel.getCx(true) + padding, tfh + 2 * padding);
    }
    /**
     * Redraws the transparent mover layer over the whole object and recalculates the
     * speed of the dragging.
     */
    private function updateShapes():void
    {
      application.trace("<" + this + " Potmeter updateShapes> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(textLabel.getType());
      spriteMover.graphics.clear();
      spriteMover.graphics.lineStyle(0, 0, 0);
      spriteMover.graphics.beginFill(0, 0);
      spriteMover.graphics.drawRect(0, 0, textLabel.getCx(true, false, true), tfh + 2 * padding);
      spriteMover.graphics.endFill();
      calcPxsPerInc();
      redrawBackground();
    }
    /**
     * Recalculates how many dragged pixels one single increment needs, so that the
     * whole range can be dragged through in three times the height of this object.
     */
    private function calcPxsPerInc():void
    {
      application.trace("<" + this + " Potmeter calcPxsPerInc> called.", 1);
      if (incValue > 0 && maxValue > minValue)
      {
        pxsPerInc = Math.max(1, Math.round(3 * getDh() / ((maxValue - minValue) / incValue)));
      }
      else
      {
        pxsPerInc = 1;
      }
      application.trace("<" + this + " Potmeter calcPxsPerInc> pxsPerInc: " + pxsPerInc, 0);
    }
    /**
     * Redraws the background of this object in the current colors, radius, box and
     * dimensions.
     * @param e the radius, box or background color changed event of the application,
     * null on a direct call
     */
    private function redrawBackground(e:Event = null):void
    {
      application.trace("<" + this + " Potmeter redrawBackground> called.", 1);
      application.trace("<" + this + " Potmeter redrawBackground> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const tfh:int = application.getDynamicsConfig().getTextFieldHeight(textLabel.getType());
      background.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorAlpha() / 2
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      background.setRadius(application.getDynamicsConfig().getAppRadius());
      background.setBox(application.getDynamicsConfig().getAppBoxCorner(), application.getDynamicsConfig().getAppBoxFrame());
      background.setDwh(textLabel.getCx(true, false, true), tfh + 2 * padding);
      background.drawRect();
    }
    /**
     * Frees all listeners, events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Potmeter destroy> called.", 1);
      application.trace("<" + this + " Potmeter destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawBackground);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawBackground);
      spriteMover.removeEventListener(MouseEvent.MOUSE_DOWN, spriteMoverMouseDown);
      removeEventListener(Event.ENTER_FRAME, updatePotmeter);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
      }
      application.trace("<" + this + " Potmeter destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " Potmeter destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      eventChanged = null;
      background = null;
      spriteMover = null;
      textLabel = null;
      sprite = null;
      icon = null;
      minValue = 0;
      maxValue = 0;
      incValue = 0;
      curValue = 0;
      tmpValue = 0;
      decimalPrecision = 0;
      pxsPerInc = 0;
      depthBeforeDragging = 0;
    }
  }
}
