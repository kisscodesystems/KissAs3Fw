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
 * ContentNotFound.
 * The dummy picture standing in the area of a content that could not be loaded.
 *
 * MAIN FEATURES:
 * - a surface of the current appearance of the application with a warning icon and
 *   the "content not found" text in the middle of it, in the language of the application
 * - the dimensions of it are the ones its owner gives it: the Image and the VideoPlayer
 *   put it into the very area their picture would have taken
 * - the text is broken into more lines when the given width is too narrow for it
 * - the smallest dimensions the text fits into are available for the owner, and a change
 *   of them (a new language, a new font size or padding) is reported by the changed event
 *   of this object, so an owner that has nothing to take those dimensions from follows it
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseShape;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class ContentNotFound extends BaseSprite
  {
    // the surface of the dummy picture and the text standing in the middle of it
    private var backShape:BaseShape = null;
    private var textLabel:TextLabel = null;
    // the dimensions the text takes in one single line, the room of the owner does not
    // count in them
    private var naturalTextDw:int = 0;
    private var naturalTextDh:int = 0;
    // true while the text is being laid out here: the text reports every one of those
    // steps as a change of its dimensions, and those reports must not start a new layout
    private var layoutRunning:Boolean = false;
    private var eventChanged:Event = null;
    /**
     * Constructs the ContentNotFound object: creates the surface and the text of it and
     * starts to follow the appearance of the application.
     * @param applicationRef the main application reference
     */
    public function ContentNotFound(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ContentNotFound> called.", 1);
      application.trace("<" + this + " ContentNotFound> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      backShape = new BaseShape(application);
      addChild(backShape);
      backShape.setIsFilled(true);
      backShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      textLabel = new TextLabel(application);
      addChild(textLabel);
      textLabel.setIcon(EnumIcons.warning());
      textLabel.setLabel(EnumTextKeys.CONTENT_NOT_FOUND());
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), textLabelResized);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), appearanceChanged);
      layout();
      application.trace("<" + this + " ContentNotFound> constructed.", 1);
    }
    /**
     * Returns the label of the text of this object: the icon and the text of it are
     * standing there.
     */
    public function getTextLabel():TextLabel
    {
      return textLabel;
    }
    /**
     * Returns the smallest width this object displays its text in one single line with:
     * the text and the padding of the application on both sides of it.
     */
    public function getMinDw():int
    {
      application.trace("<" + this + " ContentNotFound getMinDw> called.", 1);
      return naturalTextDw + 2 * application.getDynamicsConfig().getAppPadding();
    }
    /**
     * Returns the smallest height this object displays its text in one single line with,
     * see the getMinDw above.
     */
    public function getMinDh():int
    {
      application.trace("<" + this + " ContentNotFound getMinDh> called.", 1);
      return naturalTextDh + 2 * application.getDynamicsConfig().getAppPadding();
    }
    /**
     * Lays this object out again in the dimensions it has just been given.
     */
    override protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " ContentNotFound doDimensionsChanged> called.", 1);
      super.doDimensionsChanged();
      layout();
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " ContentNotFound addedToStage> called.", 1);
      application.trace("<" + this + " ContentNotFound addedToStage> e: " + e, 0);
      super.addedToStage(e);
      layout();
    }
    /**
     * This object registers nothing on the stage, so it only calls the super here.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " ContentNotFound removedFromStage> called.", 1);
      application.trace("<" + this + " ContentNotFound removedFromStage> e: " + e, 0);
      super.removedFromStage(e);
    }
    /**
     * Measures the text in one single line, breaks it into more lines when the width of
     * this object is too narrow for that, places it into the middle of this object and
     * draws the surface under it.
     */
    private function layout():void
    {
      application.trace("<" + this + " ContentNotFound layout> called.", 1);
      layoutRunning = true;
      const padding:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setMaxWidth(0, false);
      naturalTextDw = textLabel.getDw();
      naturalTextDh = textLabel.getDh();
      const room:int = getDw() - 2 * padding;
      if (room > 0 && naturalTextDw > room)
      {
        textLabel.setMaxWidth(room, true);
      }
      textLabel.setCxy(Math.max(padding, int((getDw() - textLabel.getDw()) / 2))
          , Math.max(padding, int((getDh() - textLabel.getDh()) / 2)));
      redrawBackShape();
      layoutRunning = false;
    }
    /**
     * Draws the surface of this object in the current colors and radius of the
     * application.
     */
    private function redrawBackShape():void
    {
      application.trace("<" + this + " ContentNotFound redrawBackShape> called.", 1);
      backShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorBright()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , application.getDynamicsConfig().getAppBackgroundColorAlpha()
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      backShape.setRadius(application.getDynamicsConfig().getAppRadius());
      backShape.setDwh(getDw(), getDh());
      backShape.drawRect();
    }
    /**
     * Lays this object out again and tells the owner when the smallest dimensions of it
     * have changed.
     */
    private function relayoutAndReport():void
    {
      application.trace("<" + this + " ContentNotFound relayoutAndReport> called.", 1);
      const oldMinDw:int = getMinDw();
      const oldMinDh:int = getMinDh();
      layout();
      if (oldMinDw != getMinDw() || oldMinDh != getMinDh())
      {
        dispatchEventChanged();
      }
    }
    /**
     * Follows a text that has taken new dimensions by itself: a new language or a new
     * font size gives it another one. The steps of the layout above are ignored here.
     * @param e the dimensions changed event of the label
     */
    private function textLabelResized(e:Event):void
    {
      application.trace("<" + this + " ContentNotFound textLabelResized> called.", 1);
      application.trace("<" + this + " ContentNotFound textLabelResized> e: " + e, 0);
      if (layoutRunning)
      {
        application.trace("<" + this + " ContentNotFound textLabelResized> it is the layout of this object.", 1);
        return;
      }
      relayoutAndReport();
    }
    /**
     * Lays this object out again after the padding of the application has been changed:
     * the smallest dimensions of it contain that padding.
     * @param e the padding changed event of the application
     */
    private function paddingChanged(e:Event):void
    {
      application.trace("<" + this + " ContentNotFound paddingChanged> called.", 1);
      application.trace("<" + this + " ContentNotFound paddingChanged> e: " + e, 0);
      relayoutAndReport();
    }
    /**
     * Draws the surface again after the appearance of the application has been changed.
     * @param e the radius or background color changed event of the application
     */
    private function appearanceChanged(e:Event):void
    {
      application.trace("<" + this + " ContentNotFound appearanceChanged> called.", 1);
      application.trace("<" + this + " ContentNotFound appearanceChanged> e: " + e, 0);
      redrawBackShape();
    }
    /**
     * Dispatches the changed event of this object: the smallest dimensions of it have
     * changed.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " ContentNotFound dispatchEventChanged> called.", 1);
      getBaseEventDispatcher().dispatchEvent(eventChanged);
    }
    /**
     * Frees every listener, event and reference held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ContentNotFound destroy> called.", 1);
      application.trace("<" + this + " ContentNotFound destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), appearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), appearanceChanged);
      application.trace("<" + this + " ContentNotFound destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " ContentNotFound destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      backShape = null;
      textLabel = null;
      naturalTextDw = 0;
      naturalTextDh = 0;
      layoutRunning = false;
      eventChanged = null;
    }
  }
}
