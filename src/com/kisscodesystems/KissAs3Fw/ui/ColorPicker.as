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
 * ColorPicker.
 * A button displaying a color that opens a ColorPanel below it.
 *
 * MAIN FEATURES:
 * - dispatches the changed event of the color, and on a click on the displayed color as well
 * - forwards the start and the stop of the stealing of a pixel of the stage
 * - the closed picker is as tall as its own label, the open one is as tall as its panel
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseOpen;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ColorPanel;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class ColorPicker extends BaseOpen
  {
    private var baseSprite:BaseSprite = null;
    private var color:ColorPanel = null;
    private var textType:String = null;
    private var colorStealInProgress:Boolean = false;
    private var eventChanged:Event = null;
    private var eventColorStealFromStageStart:Event = null;
    private var eventColorStealFromStageStop:Event = null;
    /**
     * Constructs the ColorPicker object and builds up its color panel and the sprite
     * displaying the color of it.
     * @param applicationRef the main application reference
     */
    public function ColorPicker(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ColorPicker> called.", 1);
      application.trace("<" + this + " ColorPicker> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventColorStealFromStageStart = new Event(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_START());
      eventColorStealFromStageStop = new Event(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_STOP());
      // there is no text to display on this picker, this type is the one its size comes from
      textType = EnumTextTypes.TEXT_TYPE_MID();
      color = new ColorPanel(application);
      contentSprite.addChild(color);
      color.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), colorChanged);
      color.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), colorResized);
      color.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_START(), colorStealStart);
      color.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_COLOR_STEAL_FROM_STAGE_STOP(), colorStealStop);
      contentSprite.setDwh(color.getDw(), color.getDh());
      baseSprite = new BaseSprite(application);
      // this sprite goes above the foreground sprite of the working button on purpose: a click
      // on the displayed color has to dispatch the changed event instead of opening the panel
      baseWorkingButton.addChild(baseSprite);
      resize();
      baseSprite.addEventListener(MouseEvent.ROLL_OUT, baseSpriteRollOut);
      baseSprite.addEventListener(MouseEvent.MOUSE_DOWN, baseSpriteMouseDown);
      baseSprite.addEventListener(MouseEvent.CLICK, baseSpriteClick);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ColorPicker> constructed.", 1);
    }
    /**
     * Returns the text type the size of this picker comes from.
     */
    public function getTextType():String
    {
      return textType;
    }
    /**
     * Returns the committed color of the panel of this picker as a six character rgb string.
     */
    public function getRGBColor():String
    {
      return color.getRGBColor();
    }
    /**
     * Commits the given color in the panel of this picker.
     * @param newRgbColor the new color as a six character rgb string
     * @param fireChangedEvent whether the changed event has to be dispatched. A color set
     *                         by the code of the application instead of the one using it
     *                         has to be a silent one: the caller knows the new color
     *                         already, and an event of it would be taken as a user action
     */
    public function setRGBColor(newRgbColor:String, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " ColorPicker setRGBColor> called.", 1);
      application.trace("<" + this + " ColorPicker setRGBColor> newRgbColor: " + newRgbColor, 0);
      application.trace("<" + this + " ColorPicker setRGBColor> fireChangedEvent: " + fireChangedEvent, 0);
      color.setRGBColor(newRgbColor, fireChangedEvent);
      if (!fireChangedEvent)
      {
        // the changed event of the panel is the one repainting the displayed color, and
        // that event has not been dispatched, so it is repainted here
        baseSpriteColorPos();
      }
    }
    /**
     * Sets the enabled state of this picker and of the panel of it as well.
     * @param b whether this picker is enabled
     */
    override public function setEnabled(b:Boolean):void
    {
      application.trace("<" + this + " ColorPicker setEnabled> called.", 1);
      application.trace("<" + this + " ColorPicker setEnabled> b: " + b, 0);
      super.setEnabled(b);
      color.setEnabled(getEnabled());
    }
    /**
     * Opens this picker: it becomes as large as its panel.
     */
    override public function open():void
    {
      application.trace("<" + this + " ColorPicker open> called.", 1);
      super.setDwh(contentSprite.getDw(), contentSprite.getDh());
      super.open();
    }
    /**
     * Closes this picker: it takes the size of its own button back.
     */
    override public function close():void
    {
      application.trace("<" + this + " ColorPicker close> called.", 1);
      super.close();
      resizeToClosed();
    }
    /**
     * The dimensions of this picker come from its own button or from its open panel, so this
     * does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ColorPicker setDw> called.", 1);
      application.trace("<" + this + " ColorPicker setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " ColorPicker setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this picker come from its own button or from its open panel, so this
     * does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ColorPicker setDh> called.", 1);
      application.trace("<" + this + " ColorPicker setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ColorPicker setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this picker come from its own button or from its open panel, so this
     * does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ColorPicker setDwh> called.", 1);
      application.trace("<" + this + " ColorPicker setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ColorPicker setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ColorPicker setDwh> do nothing.", 1);
    }
    /**
     * Decides whether this picker has to be closed by a press on the stage: it must stay open
     * as long as the stealing of a pixel of that stage is in progress.
     * @param e the mouse event of the stage
     */
    override protected function hasToCloseByMouse(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPicker hasToCloseByMouse> called.", 1);
      application.trace("<" + this + " ColorPicker hasToCloseByMouse> e: " + e, 0);
      if (!colorStealInProgress)
      {
        super.hasToCloseByMouse(e);
      }
    }
    /**
     * Forwards the start of the stealing of a pixel of the stage to the outside world.
     * @param e the color steal from stage start event of the panel
     */
    private function colorStealStart(e:Event):void
    {
      application.trace("<" + this + " ColorPicker colorStealStart> called.", 1);
      application.trace("<" + this + " ColorPicker colorStealStart> e: " + e, 0);
      colorStealInProgress = true;
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventColorStealFromStageStart);
      }
    }
    /**
     * Forwards the stop of the stealing of a pixel of the stage to the outside world.
     * @param e the color steal from stage stop event of the panel
     */
    private function colorStealStop(e:Event):void
    {
      application.trace("<" + this + " ColorPicker colorStealStop> called.", 1);
      application.trace("<" + this + " ColorPicker colorStealStop> e: " + e, 0);
      colorStealInProgress = false;
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventColorStealFromStageStop);
      }
    }
    /**
     * Closes this picker and displays the color that has been committed in the panel of it.
     * @param e the changed event of the panel
     */
    private function colorChanged(e:Event):void
    {
      application.trace("<" + this + " ColorPicker colorChanged> called.", 1);
      application.trace("<" + this + " ColorPicker colorChanged> e: " + e, 0);
      close();
      dispatchEventChanged();
      baseSpriteColorPos();
    }
    /**
     * Takes the dimensions of the resized panel, and the size of it as well when the panel is
     * the open one at the moment.
     * @param e the dimensions changed event of the panel
     */
    private function colorResized(e:Event):void
    {
      application.trace("<" + this + " ColorPicker colorResized> called.", 1);
      application.trace("<" + this + " ColorPicker colorResized> e: " + e, 0);
      contentSprite.setDwh(color.getDw(), color.getDh());
      if (isOpened())
      {
        super.setDwh(color.getDw(), color.getDh());
      }
    }
    /**
     * Takes the size of the own button of this picker back after the text format or the
     * padding has been changed, but only while the panel is closed, because an open panel
     * owns the dimensions.
     * @param e the text format mid changed event or the padding changed event
     */
    private function resize(e:Event = null):void
    {
      application.trace("<" + this + " ColorPicker resize> called.", 1);
      application.trace("<" + this + " ColorPicker resize> e: " + e, 0);
      if (application != null && !isOpened())
      {
        resizeToClosed();
        baseSpriteColorPos();
      }
    }
    /**
     * Sets the dimensions of this picker to the ones its own button needs.
     */
    private function resizeToClosed():void
    {
      application.trace("<" + this + " ColorPicker resizeToClosed> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      const textFieldHeight:int = application.getDynamicsConfig().getTextFieldHeight(textType);
      super.setDwh(2 * textFieldHeight + 2 * padding, textFieldHeight + 2 * padding);
    }
    /**
     * Repositions, resizes and fills the sprite displaying the committed color.
     */
    private function baseSpriteColorPos():void
    {
      application.trace("<" + this + " ColorPicker baseSpriteColorPos> called.", 1);
      baseSprite.setDwh(getDh() / 2, getDh() / 2);
      baseSprite.setCxy(getDh() / 4, getDh() / 4);
      baseSprite.graphics.clear();
      baseSprite.graphics.lineStyle(0, 0, 0);
      baseSprite.graphics.beginFill(Number(application.getComponentsConfig().getColorHexToNumberString() + getRGBColor()), 1);
      baseSprite.graphics.drawRect(0, 0, baseSprite.getDw(), baseSprite.getDh());
      baseSprite.graphics.endFill();
    }
    /**
     * Takes the blur of the displayed color back after the mouse has left it.
     * @param e the roll out event of the sprite of the displayed color
     */
    private function baseSpriteRollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPicker baseSpriteRollOut> called.", 1);
      application.trace("<" + this + " ColorPicker baseSpriteRollOut> e: " + e, 0);
      setBaseSpriteBlurred(false);
    }
    /**
     * Blurs the displayed color while it is being pressed.
     * @param e the mouse down event of the sprite of the displayed color
     */
    private function baseSpriteMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPicker baseSpriteMouseDown> called.", 1);
      application.trace("<" + this + " ColorPicker baseSpriteMouseDown> e: " + e, 0);
      if (getEnabled())
      {
        setBaseSpriteBlurred(true);
      }
    }
    /**
     * Dispatches the changed event of this picker after a click on the displayed color.
     * @param e the click event of the sprite of the displayed color
     */
    private function baseSpriteClick(e:MouseEvent):void
    {
      application.trace("<" + this + " ColorPicker baseSpriteClick> called.", 1);
      application.trace("<" + this + " ColorPicker baseSpriteClick> e: " + e, 0);
      setBaseSpriteBlurred(false);
      if (getEnabled())
      {
        dispatchEventChanged();
      }
    }
    /**
     * Sets or clears the blur filter of the sprite displaying the committed color.
     * @param blurred whether that sprite has to be a blurred one
     */
    private function setBaseSpriteBlurred(blurred:Boolean):void
    {
      application.trace("<" + this + " ColorPicker setBaseSpriteBlurred> called.", 1);
      application.trace("<" + this + " ColorPicker setBaseSpriteBlurred> blurred: " + blurred, 0);
      baseSprite.filters = blurred ? [application.getComponentsConfig().getBlurFilterColorPickerColor()] : null;
    }
    /**
     * Dispatches the changed event of this picker, even when the color is the very same one.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " ColorPicker dispatchEventChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Frees all listeners, events and references held by this picker.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ColorPicker destroy> called.", 1);
      application.trace("<" + this + " ColorPicker destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      baseSprite.removeEventListener(MouseEvent.ROLL_OUT, baseSpriteRollOut);
      baseSprite.removeEventListener(MouseEvent.MOUSE_DOWN, baseSpriteMouseDown);
      baseSprite.removeEventListener(MouseEvent.CLICK, baseSpriteClick);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), resize);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ColorPicker destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      eventColorStealFromStageStart.stopImmediatePropagation();
      eventColorStealFromStageStop.stopImmediatePropagation();
      application.trace("<" + this + " ColorPicker destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " ColorPicker destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      baseSprite = null;
      color = null;
      textType = null;
      colorStealInProgress = false;
      eventChanged = null;
      eventColorStealFromStageStart = null;
      eventColorStealFromStageStop = null;
    }
  }
}
