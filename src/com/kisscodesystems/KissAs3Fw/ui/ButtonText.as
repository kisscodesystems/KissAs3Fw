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
 * ButtonText.
 * The standard button object with a label on it.
 *
 * MAIN FEATURES:
 * - a button with a text label, it works as the base working button does
 * - an icon can be displayed in front of that label
 * - the dimensions come from the label and from the padding of the application
 * - the button disables itself for the time of the work it starts on a click
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseWorkingButton;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumSounds;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class ButtonText extends BaseWorkingButton
  {
    protected var textLabel:TextLabel = null;
    /**
     * Constructs the ButtonText object: creates the label of it and starts to follow
     * the size of that label and the padding of the application.
     * @param applicationRef the main application reference
     */
    public function ButtonText(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " ButtonText> called.", 1);
      application.trace("<" + this + " ButtonText> applicationRef: " + applicationRef, 0);
      textLabel = new TextLabel(application);
      contentSprite.addChild(textLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      textLabel.setLabel(" ");
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resize);
      labelRepos();
      textLabel.setLabel("");
      setSoundTypeClick(EnumSounds.button());
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ButtonText> constructed.", 1);
    }
    /**
     * Returns the text or the text key this button displays.
     */
    public function getLabel():String
    {
      return textLabel.getLabel();
    }
    /**
     * Sets the text of this button.
     * @param newLabel the new text or text key of this button
     */
    public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " ButtonText setLabel> called.", 1);
      application.trace("<" + this + " ButtonText setLabel> newLabel: " + newLabel, 0);
      textLabel.setLabel(newLabel);
    }
    /**
     * Displays the given icon in front of the label of this button.
     * @param iconType the type of the icon to be displayed, an EnumIcons value
     */
    public function setIcon(iconType:String):void
    {
      application.trace("<" + this + " ButtonText setIcon> called.", 1);
      application.trace("<" + this + " ButtonText setIcon> iconType: " + iconType, 0);
      textLabel.setIcon(iconType);
    }
    /**
     * Enables or disables this button. An enabled button standing under the mouse
     * displays itself as a button the mouse has just been moved over.
     * @param e true when this button has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " ButtonText setEnabled> called.", 1);
      application.trace("<" + this + " ButtonText setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (e && mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height)
      {
        if (application.getDynamicsConfig().weAreInDesktopMode())
        {
          application.trace("<" + this + " ButtonText setEnabled> performing rollOver.", 0);
          rollOver(null);
        }
      }
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " ButtonText setDw> called.", 1);
      application.trace("<" + this + " ButtonText setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonText setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " ButtonText setDh> called.", 1);
      application.trace("<" + this + " ButtonText setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonText setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this button come from the label of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " ButtonText setDwh> called.", 1);
      application.trace("<" + this + " ButtonText setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " ButtonText setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " ButtonText setDwh> do nothing.", 1);
    }
    /**
     * Renders this button in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " ButtonText addedToStage> called.", 1);
      application.trace("<" + this + " ButtonText addedToStage> e: " + e, 0);
      super.addedToStage(e);
      resize();
    }
    /**
     * Takes the dimensions of this button from the label standing on it and positions
     * that label into the middle of it.
     * @param e the dimensions changed event of the label or the padding changed event
     * of the application, null on a direct call
     */
    protected function resize(e:Event = null):void
    {
      application.trace("<" + this + " ButtonText resize> called.", 1);
      application.trace("<" + this + " ButtonText resize> e: " + e, 0);
      const p:int = application.getDynamicsConfig().getAppPadding();
      super.setDwh(textLabel.getDw() + 2 * p, textLabel.getDh() + 2 * p);
      labelRepos();
    }
    /**
     * Disables this button for the time of the work it has just started, then hands the
     * click over to the base working button.
     */
    override protected function baseWorkingButtonClick():void
    {
      application.trace("<" + this + " ButtonText baseWorkingButtonClick> called.", 1);
      setEnabled(false);
      super.baseWorkingButtonClick();
    }
    /**
     * Positions the label of this button, leaving the padding of the application around it.
     */
    private function labelRepos():void
    {
      application.trace("<" + this + " ButtonText labelRepos> called.", 1);
      const p:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setCxy(p, p);
    }
    /**
     * Frees all listeners and references held by this button.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " ButtonText destroy> called.", 1);
      application.trace("<" + this + " ButtonText destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " ButtonText destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " ButtonText destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textLabel = null;
    }
  }
}
