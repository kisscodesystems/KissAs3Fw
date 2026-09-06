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
 * Switcher.
 * A button link standing in one of two states, an on and an off one.
 *
 * MAIN FEATURES:
 * - one click switches this object over to the other state
 * - the two states carry a name of their own, so the state can be read and set by the
 *   very words the application thinks in
 * - both states have an icon and a label of their own
 * - the changed event is dispatched on every switch, and it can be left out when the
 *   state is set from the outside
 * - the label, the icon and the url of the button link are driven by the states, so
 *   they can not be set from the outside
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import flash.events.Event;
  public class Switcher extends ButtonLink
  {
    private var stateOn:String = "on";
    private var stateOff:String = "off";
    private var iconOn:String = "";
    private var iconOff:String = "";
    private var labelOn:String = "";
    private var labelOff:String = "";
    private var objectState:String = "";
    private var eventChanged:Event = null;
    /**
     * Constructs the Switcher object standing in its off state, with the switch icons
     * of the framework on it.
     * @param applicationRef the main application reference
     */
    public function Switcher(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Switcher> called.", 1);
      application.trace("<" + this + " Switcher> applicationRef: " + applicationRef, 0);
      iconOn = EnumIcons.switchon();
      iconOff = EnumIcons.switchoff();
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      super.setIcon(iconOff);
      objectState = stateOff;
      setLabels("", "");
      actualizeLabel();
      application.trace("<" + this + " Switcher> constructed.", 1);
    }
    /**
     * Returns the name of the state this object stands in at the moment.
     */
    public function getObjectState():String
    {
      return objectState;
    }
    /**
     * Switches this object over to the given state and displays the icon and the label
     * of it. Nothing happens when this object already stands in that very state.
     * @param newState the name of the new state
     * @param fireChangedEvent true when the changed event has to be dispatched as well
     */
    public function setObjectState(newState:String, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " Switcher setObjectState> called.", 1);
      application.trace("<" + this + " Switcher setObjectState> newState: " + newState, 0);
      application.trace("<" + this + " Switcher setObjectState> fireChangedEvent: " + fireChangedEvent, 0);
      if (newState == stateOff)
      {
        if (objectState != "" + stateOff)
        {
          super.setIcon(iconOff);
          objectState = "" + stateOff;
          actualizeLabel();
          if (fireChangedEvent)
          {
            getBaseEventDispatcher().dispatchEvent(eventChanged);
          }
        }
      }
      else
      {
        if (objectState != "" + stateOn)
        {
          super.setIcon(iconOn);
          objectState = "" + stateOn;
          actualizeLabel();
          if (fireChangedEvent)
          {
            getBaseEventDispatcher().dispatchEvent(eventChanged);
          }
        }
      }
    }
    /**
     * Tells whether this object stands in its on state at the moment.
     */
    public function getOn():Boolean
    {
      return objectState == stateOn;
    }
    /**
     * Switches this object over to its on or off state.
     * @param on true when this object has to stand in its on state
     * @param fireChangedEvent true when the changed event has to be dispatched as well
     */
    public function setOn(on:Boolean, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " Switcher setOn> called.", 1);
      application.trace("<" + this + " Switcher setOn> on: " + on, 0);
      application.trace("<" + this + " Switcher setOn> fireChangedEvent: " + fireChangedEvent, 0);
      setObjectState(on ? stateOn : stateOff, fireChangedEvent);
    }
    /**
     * Sets the names of the two states of this object. The state this object stands in
     * is kept, it takes its new name.
     * @param stateOn the name of the on state
     * @param stateOff the name of the off state
     */
    public function setStates(stateOn:String, stateOff:String):void
    {
      application.trace("<" + this + " Switcher setStates> called.", 1);
      application.trace("<" + this + " Switcher setStates> stateOn: " + stateOn, 0);
      application.trace("<" + this + " Switcher setStates> stateOff: " + stateOff, 0);
      objectState = "" + (objectState == this.stateOn ? stateOn : stateOff);
      this.stateOn = "" + stateOn;
      this.stateOff = "" + stateOff;
    }
    /**
     * Sets the icons of the two states of this object and displays the one of the
     * current state.
     * @param iconOn the icon of the on state, an EnumIcons value
     * @param iconOff the icon of the off state, an EnumIcons value
     */
    public function setIcons(iconOn:String, iconOff:String):void
    {
      application.trace("<" + this + " Switcher setIcons> called.", 1);
      application.trace("<" + this + " Switcher setIcons> iconOn: " + iconOn, 0);
      application.trace("<" + this + " Switcher setIcons> iconOff: " + iconOff, 0);
      this.iconOn = "" + iconOn;
      this.iconOff = "" + iconOff;
      super.setIcon(stateOn == objectState ? this.iconOn : this.iconOff);
    }
    /**
     * Sets the labels of the two states of this object and displays the one of the
     * current state.
     * @param labelOn the label of the on state
     * @param labelOff the label of the off state
     */
    public function setLabels(labelOn:String, labelOff:String):void
    {
      application.trace("<" + this + " Switcher setLabels> called.", 1);
      application.trace("<" + this + " Switcher setLabels> labelOn: " + labelOn, 0);
      application.trace("<" + this + " Switcher setLabels> labelOff: " + labelOff, 0);
      this.labelOn = labelOn;
      this.labelOff = labelOff;
      actualizeLabel();
    }
    /**
     * The dimensions of this object come from the label of it, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Switcher setDw> called.", 1);
      application.trace("<" + this + " Switcher setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Switcher setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the label of it, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Switcher setDh> called.", 1);
      application.trace("<" + this + " Switcher setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Switcher setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this object come from the label of it, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Switcher setDwh> called.", 1);
      application.trace("<" + this + " Switcher setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Switcher setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Switcher setDwh> do nothing.", 1);
    }
    /**
     * The icon of this object is driven by the state it stands in, so this does
     * nothing. The icons of the two states are set by the setIcons.
     * @param iconType the type of the icon
     */
    override public function setIcon(iconType:String):void
    {
      application.trace("<" + this + " Switcher setIcon> called.", 1);
      application.trace("<" + this + " Switcher setIcon> iconType: " + iconType, 0);
      application.trace("<" + this + " Switcher setIcon> do nothing.", 1);
    }
    /**
     * The icon of this object is driven by the state it stands in, so this does nothing.
     */
    override public function destIcon():void
    {
      application.trace("<" + this + " Switcher destIcon> called.", 1);
      application.trace("<" + this + " Switcher destIcon> do nothing.", 1);
    }
    /**
     * The label of this object is driven by the state it stands in, so this does
     * nothing. The labels of the two states are set by the setLabels.
     * @param newLabel the new label
     */
    override public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " Switcher setLabel> called.", 1);
      application.trace("<" + this + " Switcher setLabel> newLabel: " + newLabel, 0);
      application.trace("<" + this + " Switcher setLabel> do nothing.", 1);
    }
    /**
     * A switcher switches a state over instead of opening a web page, so this does
     * nothing.
     * @param s the url
     */
    override public function setUrl(s:String):void
    {
      application.trace("<" + this + " Switcher setUrl> called.", 1);
      application.trace("<" + this + " Switcher setUrl> s: " + s, 0);
      application.trace("<" + this + " Switcher setUrl> do nothing.", 1);
    }
    /**
     * A switcher opens no web page at all, so this does nothing.
     * @param arrAttrs the names of the data
     * @param arrVals the values of the data
     */
    override public function setPostData(arrAttrs:Array, arrVals:Array):void
    {
      application.trace("<" + this + " Switcher setPostData> called.", 1);
      application.trace("<" + this + " Switcher setPostData> arrAttrs: " + arrAttrs, 0);
      application.trace("<" + this + " Switcher setPostData> arrVals: " + arrVals, 0);
      application.trace("<" + this + " Switcher setPostData> do nothing.", 1);
    }
    /**
     * Switches this object over to its other state on a click and dispatches the
     * changed event of it.
     */
    override protected function baseWorkingButtonClick():void
    {
      application.trace("<" + this + " Switcher baseWorkingButtonClick> called.", 1);
      if (objectState == stateOn)
      {
        super.setIcon(iconOff);
        objectState = "" + stateOff;
      }
      else
      {
        super.setIcon(iconOn);
        objectState = "" + stateOn;
      }
      actualizeLabel();
      getBaseEventDispatcher().dispatchEvent(eventChanged);
      super.baseWorkingButtonClick();
    }
    /**
     * Displays the label of the state this object stands in.
     */
    private function actualizeLabel():void
    {
      application.trace("<" + this + " Switcher actualizeLabel> called.", 1);
      super.setLabel(objectState == stateOn ? labelOn : labelOff);
    }
    /**
     * Frees all events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Switcher destroy> called.", 1);
      application.trace("<" + this + " Switcher destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.trace("<" + this + " Switcher destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " Switcher destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      stateOn = null;
      stateOff = null;
      iconOn = null;
      iconOff = null;
      labelOn = null;
      labelOff = null;
      objectState = null;
      eventChanged = null;
    }
  }
}
