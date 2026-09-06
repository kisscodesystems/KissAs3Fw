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
 * DatePicker.
 * A button displaying the selected date, with a DatePanel that opens below it.
 *
 * MAIN FEATURES:
 * - the label of the button is the selected date, formatted by the panel, and it
 *   carries the calendar icon that names this picker
 * - that label stands with the date from the very first moment: a brand new picker
 *   displays the current date, the one its panel has selected while it was built
 * - the panel opens on a click and closes as soon as a date has been selected
 * - the closed picker is as tall as its label, the open one is as tall as its panel
 * - the hours and the minutes can be made selectable as well, and the format of the
 *   displayed date can be given from the outside
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseOpen;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.DatePanel;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  public class DatePicker extends BaseOpen
  {
    private var textLabel:TextLabel = null;
    private var datePanel:DatePanel = null;
    private var eventChanged:Event = null;
    // The width of the closed picker has to be stored, because the open one takes the
    // width of its panel and has to give it back on closing.
    private var closedWidth:int = 0;
    /**
     * Constructs the DatePicker object and builds up its label and its panel.
     * @param applicationRef the main application reference
     */
    public function DatePicker(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " DatePicker> called.", 1);
      application.trace("<" + this + " DatePicker> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      textLabel = new TextLabel(application);
      baseWorkingButton.getContentSprite().addChild(textLabel);
      textLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      // the icon names what this picker offers, and it stays there for its whole life:
      // the label of it is rewritten on every selection, but that leaves the icon alone.
      // The type and the icon are given before the first positioning on purpose, so that
      // the label is measured with everything it displays already on it
      textLabel.setIcon(EnumIcons.calendar());
      reposResizeLabel();
      datePanel = new DatePanel(application);
      contentSprite.addChild(datePanel);
      datePanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), selectedItemChanged);
      datePanel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), datePanelResized);
      textLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), resize);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      contentSprite.setDwh(datePanel.getDw(), datePanel.getDh());
      // the panel has selected the current date while it was being built, so the label of
      // this picker is filled with that very date right away: it is displayed from the
      // first moment on, and not only from the first selection
      displaySelectedDate();
      application.trace("<" + this + " DatePicker> constructed.", 1);
    }
    /**
     * Returns the ActionScript 3 date time pattern the panel displays the selected
     * date by.
     */
    public function getDateFormat():String
    {
      return datePanel.getDateFormat();
    }
    /**
     * Sets the ActionScript 3 date time pattern the panel displays the selected date by,
     * and takes the label of this picker to that new pattern as well.
     * @param df the date time pattern to apply
     */
    public function setDateFormat(df:String):void
    {
      application.trace("<" + this + " DatePicker setDateFormat> called.", 1);
      application.trace("<" + this + " DatePicker setDateFormat> df: " + df, 0);
      datePanel.setDateFormat(df);
      displaySelectedDate();
    }
    /**
     * Returns the displayed text of the label of this picker.
     */
    public function getText():String
    {
      return textLabel.getBaseTextField().getText();
    }
    /**
     * Returns the label of this picker, which is the selected date as the panel of it
     * has formatted it.
     */
    public function getDisplayedDate():String
    {
      return textLabel.getLabel();
    }
    /**
     * Returns the selected date as a yyyy-MM-dd string, extended by the selected
     * hours and minutes when those are selectable on the panel.
     */
    public function getSelectedDate():String
    {
      return datePanel.getSelectedDate();
    }
    /**
     * Selects the given date on the panel and dispatches the changed event of this
     * picker, which the panel itself would not do.
     * @param date the date to be selected
     */
    public function setSelectedDate(date:Date):void
    {
      application.trace("<" + this + " DatePicker setSelectedDate> called.", 1);
      application.trace("<" + this + " DatePicker setSelectedDate> date: " + date, 0);
      datePanel.setSelectedDate(date);
      displaySelectedDate();
      dispatchEventChanged();
    }
    /**
     * Returns a copy of the selected date object.
     */
    public function getSelectedDateObject():Date
    {
      return datePanel.getSelectedDateObject();
    }
    /**
     * Tells whether the hours and the minutes can be selected on the panel.
     */
    public function getHoursAndMinutes():Boolean
    {
      return datePanel.getHoursAndMinutes();
    }
    /**
     * Sets whether the hours and the minutes can be selected on the panel. The panel takes
     * the date time pattern carrying the time on that switch, so the label of this picker
     * is rewritten by it.
     * @param v true when the hours and the minutes have to be selectable
     */
    public function setHoursAndMinutes(v:Boolean):void
    {
      application.trace("<" + this + " DatePicker setHoursAndMinutes> called.", 1);
      application.trace("<" + this + " DatePicker setHoursAndMinutes> v: " + v, 0);
      datePanel.setHoursAndMinutes(v);
      // that switch takes another date time pattern in the panel, so the date standing on
      // the label of this picker is written by that new pattern from now on
      displaySelectedDate();
    }
    /**
     * Opens the panel of this picker and takes the dimensions of it.
     */
    override public function open():void
    {
      application.trace("<" + this + " DatePicker open> called.", 1);
      super.setDwh(contentSprite.getDw(), contentSprite.getDh());
      super.open();
    }
    /**
     * Closes the panel of this picker and takes the dimensions of its label back.
     */
    override public function close():void
    {
      application.trace("<" + this + " DatePicker close> called.", 1);
      super.close();
      dhToLabel();
      if (closedWidth > 0)
      {
        super.setDw(closedWidth);
      }
    }
    /**
     * Sets the width of this picker and of its label.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " DatePicker setDw> called.", 1);
      application.trace("<" + this + " DatePicker setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        closedWidth = newdw;
        super.setDw(newdw);
        reposResizeLabel();
      }
    }
    /**
     * The height of this picker comes from its label or from its open panel, so this
     * does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " DatePicker setDh> called.", 1);
      application.trace("<" + this + " DatePicker setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " DatePicker setDh> do nothing.", 1);
    }
    /**
     * The height of this picker comes from its label or from its open panel, so this
     * does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " DatePicker setDwh> called.", 1);
      application.trace("<" + this + " DatePicker setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " DatePicker setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " DatePicker setDwh> do nothing.", 1);
    }
    /**
     * Renders this picker in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " DatePicker addedToStage> called.", 1);
      application.trace("<" + this + " DatePicker addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (!isOpened())
      {
        dhToLabel();
        reposResizeLabel();
      }
    }
    /**
     * Closes the panel and displays the date that has been selected.
     * @param e the changed event of the panel
     */
    private function selectedItemChanged(e:Event):void
    {
      application.trace("<" + this + " DatePicker selectedItemChanged> called.", 1);
      application.trace("<" + this + " DatePicker selectedItemChanged> e: " + e, 0);
      close();
      displaySelectedDate();
      dispatchEventChanged();
    }
    /**
     * Takes the dimensions of the resized panel, and the dimensions of this picker as
     * well when the panel is the open one at the moment.
     * @param e the dimensions changed event of the panel
     */
    private function datePanelResized(e:Event):void
    {
      application.trace("<" + this + " DatePicker datePanelResized> called.", 1);
      application.trace("<" + this + " DatePicker datePanelResized> e: " + e, 0);
      contentSprite.setDwh(datePanel.getDw(), datePanel.getDh());
      if (isOpened())
      {
        super.setDwh(datePanel.getDw(), datePanel.getDh());
      }
    }
    /**
     * Takes the height of the label back after the label or the padding has been
     * changed, but only while the panel is closed, because an open panel owns the
     * dimensions.
     * @param e the dimensions changed event of the label or the padding changed event
     * of the application
     */
    private function resize(e:Event):void
    {
      application.trace("<" + this + " DatePicker resize> called.", 1);
      application.trace("<" + this + " DatePicker resize> e: " + e, 0);
      if (!isOpened())
      {
        dhToLabel();
        reposResizeLabel();
      }
    }
    /**
     * Displays the selected date on the label of this picker, formatted the way the panel of
     * it has formatted it. Every call rewriting that date or the pattern of it ends here:
     * that label is the one and only place the selected date is read from.
     */
    private function displaySelectedDate():void
    {
      application.trace("<" + this + " DatePicker displaySelectedDate> called.", 1);
      textLabel.setLabel(datePanel.getDisplayedDate());
    }
    /**
     * Sets the height of this picker to the height its label needs.
     */
    private function dhToLabel():void
    {
      application.trace("<" + this + " DatePicker dhToLabel> called.", 1);
      super.setDh(textLabel.getDh() + 2 * application.getDynamicsConfig().getAppPadding());
    }
    /**
     * Repositions and resizes the label of this picker inside the button of it.
     */
    private function reposResizeLabel():void
    {
      application.trace("<" + this + " DatePicker reposResizeLabel> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      textLabel.setMaxWidth(getDw() - 2 * padding, false);
      textLabel.setCxy(padding, padding);
    }
    /**
     * Dispatches the changed event of this picker.
     */
    private function dispatchEventChanged():void
    {
      application.trace("<" + this + " DatePicker dispatchEventChanged> called.", 1);
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
      application.trace("<" + this + " DatePicker destroy> called.", 1);
      application.trace("<" + this + " DatePicker destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), resize);
      application.trace("<" + this + " DatePicker destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      application.trace("<" + this + " DatePicker destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      textLabel = null;
      datePanel = null;
      eventChanged = null;
      closedWidth = 0;
    }
  }
}
