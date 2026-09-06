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
 * DatePanel.
 * A panel that displays the days of one month in a calendar view, the DatePicker
 * is built of it. The first day of the week is always monday, because this panel
 * displays the number of the weeks as well.
 * Every element is created once, at the very beginning, and the days and the week
 * numbers that the current month does not need are hidden instead of being dropped.
 *
 * MAIN FEATURES:
 * - the year and the month can be stepped forwards and backwards, and the current
 *   date can be taken by one single click
 * - the hours and the minutes can be displayed and selected as well
 * - the selected day and the current day are painted onto the background
 * - the format of the displayed date comes from the components config
 */
package com.kisscodesystems.KissAs3Fw.ui
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.globalization.DateTimeFormatter;
  public class DatePanel extends BaseSprite
  {
    private var eventChanged:Event = null;
    private var currentDateObject:Date = null;
    private var hoursAndMinutes:Boolean = false;
    private var hoursLabelArray:Array = null;
    private var hoursValueArray:Array = null;
    private var hoursListPicker:ListPicker = null;
    private var minutesLabelArray:Array = null;
    private var minutesValueArray:Array = null;
    private var minutesListPicker:ListPicker = null;
    private var hmSepTextLabel:TextLabel = null;
    private var background:Shape = null;
    // The date format has to be an ActionScript 3 date time pattern.
    private var dateFormat:String = null;
    private var dateFormatter:DateTimeFormatter = null;
    private var firstButtonLink:ButtonLink = null;
    private var leftButtonLink:ButtonLink = null;
    private var dateTextLabel:TextLabel = null;
    private var rightButtonLink:ButtonLink = null;
    private var lastButtonLink:ButtonLink = null;
    private var todayButtonLink:ButtonLink = null;
    private var weekdaysCodesArray:Array = null;
    private var weekdaysElementsArray:Array = null;
    private var weeksElementsArray:Array = null;
    private var daysElementsArray:Array = null;
    // Every day and week number element is displayed in this width, so that the
    // columns of the calendar view line up under each other.
    private var allElementsW:int = 0;
    /**
     * Constructs the DatePanel object: creates the navigation buttons, the label of
     * the selected date, and every weekday, week number and day element of the
     * calendar view.
     * @param applicationRef the main application reference
     */
    public function DatePanel(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " DatePanel> called.", 1);
      application.trace("<" + this + " DatePanel> applicationRef: " + applicationRef, 0);
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      currentDateObject = new Date();
      dateFormatter = new DateTimeFormatter("en-US");
      weekdaysCodesArray = application.getLabelManager().getKeysWeekdays();
      hoursLabelArray = new Array();
      hoursValueArray = new Array();
      for (var i:int = 0; i < 24; i++)
      {
        hoursLabelArray.push(twoDigits(i));
        hoursValueArray.push(i);
      }
      minutesLabelArray = new Array();
      minutesValueArray = new Array();
      for (var j:int = 0; j < 60; j++)
      {
        minutesLabelArray.push(twoDigits(j));
        minutesValueArray.push(j);
      }
      // The background is the deepest layer, the days are painted onto it.
      background = new Shape();
      addChild(background);
      firstButtonLink = createNavigationButton(EnumIcons.doubleleftarrow(), firstButtonLinkClicked);
      leftButtonLink = createNavigationButton(EnumIcons.leftarrow(), leftButtonLinkClicked);
      dateTextLabel = new TextLabel(application);
      addChild(dateTextLabel);
      dateTextLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
      dateTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), dateTextLabelResized);
      rightButtonLink = createNavigationButton(EnumIcons.rightarrow(), rightButtonLinkClicked);
      lastButtonLink = createNavigationButton(EnumIcons.doublerightarrow(), lastButtonLinkClicked);
      todayButtonLink = new ButtonLink(application);
      addChild(todayButtonLink);
      todayButtonLink.setLabel(EnumTextKeys.TODAY());
      todayButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), objectsSizesChanged);
      todayButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), todayButtonLinkClicked);
      weekdaysElementsArray = new Array();
      for (var k:int = 0; k < weekdaysCodesArray.length; k++)
      {
        var weekdayLabel:TextLabel = new TextLabel(application);
        addChild(weekdayLabel);
        // the label is set before the listener is registered: setting it resizes that
        // label, and the listener repositions this panel of arrays that are built below
        weekdayLabel.setLabel(weekdaysCodesArray[k]);
        weekdayLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), objectsSizesChanged);
        weekdaysElementsArray.push(weekdayLabel);
      }
      daysElementsArray = new Array();
      for (var l:int = 1; l <= 31; l++)
      {
        var dayLabel:TextLabel = new TextLabel(application);
        addChild(dayLabel);
        dayLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
        dayLabel.setLabel(twoDigits(l));
        dayLabel.addEventListener(MouseEvent.CLICK, dayClicked, false, 0, true);
        dayLabel.addEventListener(MouseEvent.MOUSE_OVER, dayMouseOver, false, 0, true);
        dayLabel.addEventListener(MouseEvent.MOUSE_OUT, dayMouseOut, false, 0, true);
        dayLabel.addEventListener(MouseEvent.MOUSE_DOWN, dayMouseDown, false, 0, true);
        daysElementsArray.push(dayLabel);
      }
      weeksElementsArray = new Array();
      for (var m:int = 0; m < 6; m++)
      {
        var weekLabel:TextLabel = new TextLabel(application);
        addChild(weekLabel);
        weeksElementsArray.push(weekLabel);
      }
      setDateFormat(application.getComponentsConfig().getDatePanelDateFormat());
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
      reposElements();
      setSelectedDate(currentDateObject);
      application.trace("<" + this + " DatePanel> constructed.", 1);
    }
    /**
     * Returns the ActionScript 3 date time pattern the selected date is displayed by.
     */
    public function getDateFormat():String
    {
      return dateFormat;
    }
    /**
     * Sets the ActionScript 3 date time pattern the selected date is displayed by.
     * @param df the date time pattern to apply
     */
    public function setDateFormat(df:String):void
    {
      application.trace("<" + this + " DatePanel setDateFormat> called.", 1);
      application.trace("<" + this + " DatePanel setDateFormat> df: " + df, 0);
      dateFormat = df;
      dateFormatter.setDateTimePattern(dateFormat);
      dateDisplay();
    }
    /**
     * Tells whether the hours and the minutes can be selected on this panel.
     */
    public function getHoursAndMinutes():Boolean
    {
      return hoursAndMinutes;
    }
    /**
     * Sets whether the hours and the minutes can be selected on this panel. The two
     * pickers and the separator between them are created on demand and dropped as
     * soon as they are not needed any more.
     * @param v true when the hours and the minutes have to be selectable
     */
    public function setHoursAndMinutes(v:Boolean):void
    {
      application.trace("<" + this + " DatePanel setHoursAndMinutes> called.", 1);
      application.trace("<" + this + " DatePanel setHoursAndMinutes> v: " + v, 0);
      if (hoursAndMinutes != v)
      {
        hoursAndMinutes = v;
        if (hoursAndMinutes)
        {
          createElementsOfHoursAndMinutes();
          setDateFormat(application.getComponentsConfig().getDatePanelDateTimeFormat());
        }
        else
        {
          removeElementsOfHoursAndMinutes();
          setDateFormat(application.getComponentsConfig().getDatePanelDateFormat());
        }
        reposElements();
      }
    }
    /**
     * Returns the selected date as a yyyy-MM-dd string, extended by the selected
     * hours and minutes when those are selectable on this panel.
     */
    public function getSelectedDate():String
    {
      application.trace("<" + this + " DatePanel getSelectedDate> called.", 1);
      var theDate:String = currentDateObject.getFullYear()
          + "-" + twoDigits(currentDateObject.getMonth() + 1)
          + "-" + twoDigits(currentDateObject.getDate());
      if (hoursAndMinutes)
      {
        theDate += " " + twoDigits(currentDateObject.getHours()) + ":" + twoDigits(currentDateObject.getMinutes());
      }
      application.trace("<" + this + " DatePanel getSelectedDate> theDate: " + theDate, 0);
      return theDate;
    }
    /**
     * Selects the given date and repaints the whole calendar view. A null date means
     * the current one. The hours and the minutes are only taken when those are
     * selectable on this panel.
     * @param date the date to be selected
     */
    public function setSelectedDate(date:Date):void
    {
      application.trace("<" + this + " DatePanel setSelectedDate> called.", 1);
      application.trace("<" + this + " DatePanel setSelectedDate> date: " + date, 0);
      const dateToSelect:Date = date != null ? date : new Date();
      currentDateObject = new Date(dateToSelect.getFullYear()
          , dateToSelect.getMonth()
          , dateToSelect.getDate()
          , hoursAndMinutes ? dateToSelect.getHours() : 0
          , hoursAndMinutes ? dateToSelect.getMinutes() : 0);
      // the pickers take the hour and the minute of the date that has arrived, and not
      // the ones of the date object above: setting the picker of the hours dispatches
      // its changed event, and the handler of that event rewrites that date object
      if (hoursAndMinutes && hoursListPicker != null)
      {
        hoursListPicker.setSelectedIndex(dateToSelect.getHours());
      }
      if (hoursAndMinutes && minutesListPicker != null)
      {
        minutesListPicker.setSelectedIndex(dateToSelect.getMinutes());
      }
      reposDaysWeeksWeekdays();
      dateDisplay();
      paintDatesToBackground(true);
    }
    /**
     * Returns a copy of the selected date object.
     */
    public function getSelectedDateObject():Date
    {
      return new Date(currentDateObject.getTime());
    }
    /**
     * Returns the text the label of this panel displays the selected date by.
     */
    public function getDisplayedDate():String
    {
      return dateTextLabel.getBaseTextField().getText();
    }
    /**
     * Repositions the static content of this panel: the navigation buttons, the label
     * of the selected date and the pickers of the hours and the minutes. This has to
     * happen after the calendar view has been repositioned, because the width of this
     * panel comes from that view.
     */
    public function reposStaticContent():void
    {
      application.trace("<" + this + " DatePanel reposStaticContent> called.", 1);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      firstButtonLink.setCxy(lineThickness, lineThickness);
      leftButtonLink.setCxy(firstButtonLink.getCx(true) + lineThickness, firstButtonLink.getCy());
      lastButtonLink.setCxy(getDw() - lastButtonLink.getDw() - lineThickness, firstButtonLink.getCy());
      rightButtonLink.setCxy(lastButtonLink.getCx() - rightButtonLink.getDw() - lineThickness, lastButtonLink.getCy());
      reposDateTextLabel();
      if (hoursPickersAreAvailable())
      {
        hoursListPicker.setDw(firstButtonLink.getDh() * 2);
        hoursListPicker.setCxy((getDw() - 2 * lineThickness - 2 * hoursListPicker.getDw() - hmSepTextLabel.getDw()) / 2, firstButtonLink.getCy(true) + lineThickness);
        hmSepTextLabel.setCxy(hoursListPicker.getCx(true) + lineThickness, hoursListPicker.getCy() + padding);
        minutesListPicker.setDw(hoursListPicker.getDw());
        minutesListPicker.setCxy(hmSepTextLabel.getCx(true) + lineThickness, hoursListPicker.getCy());
        todayButtonLink.setCxy(firstButtonLink.getCx(), Math.max(hoursListPicker.getCy(true), minutesListPicker.getCy(true)) + lineThickness);
      }
      else
      {
        todayButtonLink.setCxy(firstButtonLink.getCx(), firstButtonLink.getCy(true) + lineThickness);
      }
    }
    /**
     * Enables or disables this panel together with every button and picker of it.
     * @param e true when this panel has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " DatePanel setEnabled> called.", 1);
      application.trace("<" + this + " DatePanel setEnabled> e: " + e, 0);
      super.setEnabled(e);
      firstButtonLink.setEnabled(e);
      leftButtonLink.setEnabled(e);
      rightButtonLink.setEnabled(e);
      lastButtonLink.setEnabled(e);
      todayButtonLink.setEnabled(e);
      if (hoursListPicker != null)
      {
        hoursListPicker.setEnabled(e);
      }
      if (minutesListPicker != null)
      {
        minutesListPicker.setEnabled(e);
      }
    }
    /**
     * The dimensions of this panel come from its calendar view, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " DatePanel setDw> called.", 1);
      application.trace("<" + this + " DatePanel setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " DatePanel setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this panel come from its calendar view, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " DatePanel setDh> called.", 1);
      application.trace("<" + this + " DatePanel setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " DatePanel setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this panel come from its calendar view, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " DatePanel setDwh> called.", 1);
      application.trace("<" + this + " DatePanel setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " DatePanel setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " DatePanel setDwh> do nothing.", 1);
    }
    /**
     * Renders this panel in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " DatePanel addedToStage> called.", 1);
      application.trace("<" + this + " DatePanel addedToStage> e: " + e, 0);
      super.addedToStage(e);
      reposElements();
    }
    /**
     * Creates one navigation button of this panel. The arrow of it is an icon, so the
     * button carries no label at all.
     * @param iconType the icon type of the arrow of that button
     * @param clickListener the listener of the click event of that button
     */
    private function createNavigationButton(iconType:String, clickListener:Function):ButtonLink
    {
      application.trace("<" + this + " DatePanel createNavigationButton> called.", 1);
      application.trace("<" + this + " DatePanel createNavigationButton> iconType: " + iconType, 0);
      const buttonLink:ButtonLink = new ButtonLink(application);
      addChild(buttonLink);
      buttonLink.setIcon(iconType);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), objectsSizesChanged);
      buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), clickListener);
      return buttonLink;
    }
    /**
     * Creates the pickers of the hours and the minutes and the separator between them.
     */
    private function createElementsOfHoursAndMinutes():void
    {
      application.trace("<" + this + " DatePanel createElementsOfHoursAndMinutes> called.", 1);
      if (hoursListPicker == null)
      {
        hoursListPicker = new ListPicker(application);
        addChild(hoursListPicker);
        hoursListPicker.setNumOfElements(4);
        hoursListPicker.setArrays(hoursLabelArray, hoursValueArray);
        hoursListPicker.setSelectedIndex(0);
        hoursListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), hoursOrMinutesResized);
        hoursListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), hoursOrMinutesChanged);
      }
      if (hmSepTextLabel == null)
      {
        hmSepTextLabel = new TextLabel(application);
        addChild(hmSepTextLabel);
        hmSepTextLabel.setType(EnumTextTypes.TEXT_TYPE_MID());
        hmSepTextLabel.setLabel(":");
      }
      if (minutesListPicker == null)
      {
        minutesListPicker = new ListPicker(application);
        addChild(minutesListPicker);
        minutesListPicker.setNumOfElements(4);
        minutesListPicker.setArrays(minutesLabelArray, minutesValueArray);
        minutesListPicker.setSelectedIndex(0);
        minutesListPicker.setAlwaysDispatchSelectedEvent(true);
        minutesListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), hoursOrMinutesResized);
        minutesListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), hoursOrMinutesChanged);
      }
    }
    /**
     * Destroys and drops the pickers of the hours and the minutes and the separator
     * between them.
     */
    private function removeElementsOfHoursAndMinutes():void
    {
      application.trace("<" + this + " DatePanel removeElementsOfHoursAndMinutes> called.", 1);
      if (hoursListPicker != null)
      {
        hoursListPicker.destroy();
        if (contains(hoursListPicker))
        {
          removeChild(hoursListPicker);
        }
        hoursListPicker = null;
      }
      if (hmSepTextLabel != null)
      {
        hmSepTextLabel.destroy();
        if (contains(hmSepTextLabel))
        {
          removeChild(hmSepTextLabel);
        }
        hmSepTextLabel = null;
      }
      if (minutesListPicker != null)
      {
        minutesListPicker.destroy();
        if (contains(minutesListPicker))
        {
          removeChild(minutesListPicker);
        }
        minutesListPicker = null;
      }
    }
    /**
     * Tells whether the hours and the minutes are selectable and every element of
     * them exists at the moment.
     */
    private function hoursPickersAreAvailable():Boolean
    {
      application.trace("<" + this + " DatePanel hoursPickersAreAvailable> called.", 1);
      return hoursAndMinutes && hoursListPicker != null && minutesListPicker != null && hmSepTextLabel != null;
    }
    /**
     * Returns the selected hour, zero when the hours are not selectable at all.
     */
    private function getSelectedHour():int
    {
      return hoursAndMinutes && hoursListPicker != null ? hoursListPicker.getSelectedIndex() : 0;
    }
    /**
     * Returns the selected minute, zero when the minutes are not selectable at all.
     */
    private function getSelectedMinute():int
    {
      return hoursAndMinutes && minutesListPicker != null ? minutesListPicker.getSelectedIndex() : 0;
    }
    /**
     * Creates a date of the given day, together with the selected hour and minute.
     * @param year the year of that date
     * @param month the month of that date, january is the zero
     * @param date the day of that date
     */
    private function createDate(year:int, month:int, date:int):Date
    {
      application.trace("<" + this + " DatePanel createDate> called.", 1);
      application.trace("<" + this + " DatePanel createDate> year: " + year, 0);
      application.trace("<" + this + " DatePanel createDate> month: " + month, 0);
      application.trace("<" + this + " DatePanel createDate> date: " + date, 0);
      return new Date(year, month, date, getSelectedHour(), getSelectedMinute());
    }
    /**
     * Steps the selected date by the given number of years and months.
     * @param yearDelta the number of the years to be stepped
     * @param monthDelta the number of the months to be stepped
     */
    private function stepSelectedDate(yearDelta:int, monthDelta:int):void
    {
      application.trace("<" + this + " DatePanel stepSelectedDate> called.", 1);
      application.trace("<" + this + " DatePanel stepSelectedDate> yearDelta: " + yearDelta, 0);
      application.trace("<" + this + " DatePanel stepSelectedDate> monthDelta: " + monthDelta, 0);
      setSelectedDate(createDate(currentDateObject.getFullYear() + yearDelta
          , currentDateObject.getMonth() + monthDelta
          , currentDateObject.getDate()));
    }
    /**
     * Steps one year backwards.
     * @param e the click event of the first button
     */
    private function firstButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " DatePanel firstButtonLinkClicked> called.", 1);
      application.trace("<" + this + " DatePanel firstButtonLinkClicked> e: " + e, 0);
      stepSelectedDate(-1, 0);
    }
    /**
     * Steps one month backwards.
     * @param e the click event of the left button
     */
    private function leftButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " DatePanel leftButtonLinkClicked> called.", 1);
      application.trace("<" + this + " DatePanel leftButtonLinkClicked> e: " + e, 0);
      stepSelectedDate(0, -1);
    }
    /**
     * Steps one month forwards.
     * @param e the click event of the right button
     */
    private function rightButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " DatePanel rightButtonLinkClicked> called.", 1);
      application.trace("<" + this + " DatePanel rightButtonLinkClicked> e: " + e, 0);
      stepSelectedDate(0, 1);
    }
    /**
     * Steps one year forwards.
     * @param e the click event of the last button
     */
    private function lastButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " DatePanel lastButtonLinkClicked> called.", 1);
      application.trace("<" + this + " DatePanel lastButtonLinkClicked> e: " + e, 0);
      stepSelectedDate(1, 0);
    }
    /**
     * Selects the current date and reports it to the outside world.
     * @param e the click event of the today button
     */
    private function todayButtonLinkClicked(e:Event):void
    {
      application.trace("<" + this + " DatePanel todayButtonLinkClicked> called.", 1);
      application.trace("<" + this + " DatePanel todayButtonLinkClicked> e: " + e, 0);
      setSelectedDate(new Date());
      dispatchSelectedChanged();
    }
    /**
     * Selects the clicked day of the displayed month and reports it to the outside
     * world.
     * @param e the click event of a day element
     */
    private function dayClicked(e:MouseEvent):void
    {
      application.trace("<" + this + " DatePanel dayClicked> called.", 1);
      application.trace("<" + this + " DatePanel dayClicked> e: " + e, 0);
      if (getEnabled() && isADayElement(e))
      {
        setSelectedDate(createDate(currentDateObject.getFullYear()
            , currentDateObject.getMonth()
            , int(TextLabel(e.target.parent).getLabel())));
        dispatchSelectedChanged();
      }
    }
    /**
     * Marks the day the mouse is over.
     * @param e the mouse over event of a day element
     */
    private function dayMouseOver(e:MouseEvent):void
    {
      application.trace("<" + this + " DatePanel dayMouseOver> called.", 1);
      application.trace("<" + this + " DatePanel dayMouseOver> e: " + e, 0);
      if (getEnabled() && isADayElement(e))
      {
        markADayElement(TextLabel(e.target.parent), application.getComponentsConfig().getDatePanelAlphaMouseOver());
      }
    }
    /**
     * Marks the day the mouse is pressed down on.
     * @param e the mouse down event of a day element
     */
    private function dayMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " DatePanel dayMouseDown> called.", 1);
      application.trace("<" + this + " DatePanel dayMouseDown> e: " + e, 0);
      if (getEnabled() && isADayElement(e))
      {
        markADayElement(TextLabel(e.target.parent), application.getComponentsConfig().getDatePanelAlphaMouseDown());
      }
    }
    /**
     * Drops the marking of the day the mouse has left.
     * @param e the mouse out event of a day element
     */
    private function dayMouseOut(e:MouseEvent):void
    {
      application.trace("<" + this + " DatePanel dayMouseOut> called.", 1);
      application.trace("<" + this + " DatePanel dayMouseOut> e: " + e, 0);
      if (getEnabled())
      {
        paintDatesToBackground(true);
      }
    }
    /**
     * Tells whether the given mouse event comes from a day element of this panel.
     * @param e the mouse event to be checked
     */
    private function isADayElement(e:MouseEvent):Boolean
    {
      application.trace("<" + this + " DatePanel isADayElement> called.", 1);
      return e != null && e.target != null && e.target.parent is TextLabel;
    }
    /**
     * Paints the given day element with the given alpha, together with the selected
     * and the current day.
     * @param textLabel the day element to be marked
     * @param fillAlpha the alpha of the marking
     */
    private function markADayElement(textLabel:TextLabel, fillAlpha:Number):void
    {
      application.trace("<" + this + " DatePanel markADayElement> called.", 1);
      application.trace("<" + this + " DatePanel markADayElement> textLabel: " + textLabel, 0);
      application.trace("<" + this + " DatePanel markADayElement> fillAlpha: " + fillAlpha, 0);
      background.graphics.clear();
      paintRect(textLabel, false, fillAlpha);
      paintDatesToBackground(false);
    }
    /**
     * Paints one single rectangle behind the given element. The graphics is not
     * cleared here, this only paints.
     * @param textLabel the element to be painted behind
     * @param border true when a border has to be drawn instead of a filling
     * @param fillAlpha the alpha of the filling
     */
    private function paintRect(textLabel:TextLabel, border:Boolean, fillAlpha:Number):void
    {
      application.trace("<" + this + " DatePanel paintRect> called.", 1);
      application.trace("<" + this + " DatePanel paintRect> textLabel: " + textLabel, 0);
      application.trace("<" + this + " DatePanel paintRect> border: " + border, 0);
      application.trace("<" + this + " DatePanel paintRect> fillAlpha: " + fillAlpha, 0);
      background.graphics.lineStyle(border ? application.getDynamicsConfig().getAppLineThickness() : 0
          , application.getDynamicsConfig().getAppFontColorDark()
          , border ? 1 : 0
          , true);
      background.graphics.beginFill(application.getDynamicsConfig().getAppFontColorDark(), fillAlpha);
      background.graphics.drawRect(textLabel.getCx(), textLabel.getCy(), textLabel.getDw(), textLabel.getDh());
      background.graphics.endFill();
    }
    /**
     * Paints the selected day and, when the displayed month is the current one, the
     * current day onto the background.
     * @param toClear true when the background has to be cleared first
     */
    private function paintDatesToBackground(toClear:Boolean):void
    {
      application.trace("<" + this + " DatePanel paintDatesToBackground> called.", 1);
      application.trace("<" + this + " DatePanel paintDatesToBackground> toClear: " + toClear, 0);
      if (toClear)
      {
        background.graphics.clear();
      }
      if (daysElementsArray[currentDateObject.getDate() - 1] is TextLabel)
      {
        paintRect(TextLabel(daysElementsArray[currentDateObject.getDate() - 1]), false, application.getComponentsConfig().getDatePanelAlphaMouseOver());
      }
      const today:Date = new Date();
      if (currentDateObject.getFullYear() == today.getFullYear() && currentDateObject.getMonth() == today.getMonth())
      {
        if (daysElementsArray[today.getDate() - 1] is TextLabel)
        {
          paintRect(TextLabel(daysElementsArray[today.getDate() - 1]), true, 0);
        }
      }
    }
    /**
     * Displays the selected date on the label of this panel and repaints the marked
     * days of the calendar view.
     */
    private function dateDisplay():void
    {
      application.trace("<" + this + " DatePanel dateDisplay> called.", 1);
      dateTextLabel.setLabel(dateFormatter.format(currentDateObject));
      paintDatesToBackground(false);
    }
    /**
     * Repositions every element of this panel.
     */
    private function reposElements():void
    {
      application.trace("<" + this + " DatePanel reposElements> called.", 1);
      reposDaysWeeksWeekdays();
      reposStaticContent();
    }
    /**
     * Repositions the calendar view of this panel: the weekdays, the days of the
     * displayed month and the numbers of the weeks. The days and the week numbers the
     * displayed month does not need are hidden, and the height of this panel comes
     * from the last displayed week.
     */
    private function reposDaysWeeksWeekdays():void
    {
      application.trace("<" + this + " DatePanel reposDaysWeeksWeekdays> called.", 1);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      // Every column of the calendar view is as wide as the widest weekday element.
      allElementsW = 0;
      for (var j:int = 0; j < weekdaysElementsArray.length; j++)
      {
        allElementsW = Math.max(allElementsW, TextLabel(weekdaysElementsArray[j]).getDw());
      }
      // These positions are essential, many further elements depend on them.
      const iniXweekdays:int = Math.max(allElementsW, firstButtonLink.getDw()) + 2 * lineThickness;
      const weekdaysY:int = (hoursPickersAreAvailable()
          ? Math.max(hoursListPicker.getCy(true), minutesListPicker.getCy(true))
          : firstButtonLink.getCy(true)) + lineThickness + padding;
      const iniYweeks:int = weekdaysY + firstButtonLink.getDh() - padding;
      const weeksX:int = firstButtonLink.getCx();
      // The weekdays are positioned first, the days line up under them.
      var lastWeekdayPos:int = 0;
      for (var i:int = 0; i < weekdaysElementsArray.length; i++)
      {
        TextLabel(weekdaysElementsArray[i]).setCxy(iniXweekdays + i * (allElementsW + lineThickness), weekdaysY);
        lastWeekdayPos = Math.max(lastWeekdayPos, TextLabel(weekdaysElementsArray[i]).getCx());
      }
      // The days of the displayed month, starting from the weekday the first day of
      // that month falls onto.
      var currentXdays:int = iniXweekdays + (allElementsW + lineThickness) * getFirstDayDelta();
      var currentYdays:int = iniYweeks;
      var weeksVisible:int = 0;
      for (var l:int = 0; l < daysElementsArray.length; l++)
      {
        var dayLabel:TextLabel = TextLabel(daysElementsArray[l]);
        dayLabel.setCxy(currentXdays, currentYdays);
        dayLabel.visible = l < getMonthLength();
        currentXdays += allElementsW + lineThickness;
        if (currentXdays > lastWeekdayPos)
        {
          currentXdays = iniXweekdays;
          currentYdays += dayLabel.getDh() + lineThickness;
          if (l < getMonthLength() - 1)
          {
            weeksVisible++;
          }
        }
      }
      // The numbers of the weeks are positioned into the very first column.
      for (var k:int = 0; k < weeksElementsArray.length; k++)
      {
        var weekLabel:TextLabel = TextLabel(weeksElementsArray[k]);
        weekLabel.setLabel(String(getCurrentWeek(new Date(currentDateObject.getFullYear(), currentDateObject.getMonth(), k * weekdaysCodesArray.length + 1))));
        weekLabel.setCxy(weeksX, iniYweeks + k * (weekLabel.getDh() + lineThickness));
        weekLabel.visible = k <= weeksVisible;
        if (k == weeksVisible)
        {
          super.setDwh(lastWeekdayPos + allElementsW + lineThickness, weekLabel.getCy(true) + lineThickness);
        }
      }
      paintDatesToBackground(true);
    }
    /**
     * Puts the label of the selected date into the middle of the header of this panel.
     */
    private function reposDateTextLabel():void
    {
      application.trace("<" + this + " DatePanel reposDateTextLabel> called.", 1);
      const lineThickness:int = application.getDynamicsConfig().getAppLineThickness();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      dateTextLabel.setCxy((getDw() - dateTextLabel.getDw()) / 2, lineThickness + padding);
    }
    /**
     * Returns the number of the weekday the first day of the displayed month falls
     * onto, counted from monday.
     */
    private function getFirstDayDelta():int
    {
      application.trace("<" + this + " DatePanel getFirstDayDelta> called.", 1);
      const firstDayOfTheMonth:Date = new Date(currentDateObject.getFullYear(), currentDateObject.getMonth(), 1);
      return (firstDayOfTheMonth.getDay() - 1 + weekdaysElementsArray.length) % weekdaysElementsArray.length;
    }
    /**
     * Returns the number of the week the given date falls into.
     * The first day of january on monday, tuesday, wednesday or thursday belongs to
     * the first week of that year, and on friday, saturday or sunday it belongs to
     * the last week of the previous one, so the first week starts on the next monday.
     * @param theDate the date the number of the week is calculated for
     */
    private function getCurrentWeek(theDate:Date):int
    {
      application.trace("<" + this + " DatePanel getCurrentWeek> called.", 1);
      application.trace("<" + this + " DatePanel getCurrentWeek> theDate: " + theDate, 0);
      const firstDateOfTheYear:Date = new Date(theDate.getFullYear(), 0, 1);
      const firstDayOfTheYear:int = (firstDateOfTheYear.getDay() + (weekdaysCodesArray.length - 1)) % weekdaysCodesArray.length;
      const firstDateOfThatWeek:Date = new Date(theDate.getFullYear(), 0, 1);
      while (firstDateOfThatWeek.getDay() != 1)
      {
        firstDateOfThatWeek.setDate(firstDateOfThatWeek.getDate() - 1);
      }
      var weekNumber:int = 1 - (firstDayOfTheYear < 3 ? 0 : 1);
      while (true)
      {
        firstDateOfThatWeek.setDate(firstDateOfThatWeek.getDate() + 1);
        if (firstDateOfThatWeek.getDay() == 1)
        {
          weekNumber++;
        }
        if (firstDateOfThatWeek.getTime() >= theDate.getTime())
        {
          break;
        }
      }
      if (weekNumber == 0)
      {
        return getCurrentWeek(new Date(firstDateOfThatWeek.getFullYear(), firstDateOfThatWeek.getMonth(), firstDateOfThatWeek.getDate() - 1));
      }
      application.trace("<" + this + " DatePanel getCurrentWeek> weekNumber: " + weekNumber, 0);
      return weekNumber;
    }
    /**
     * Tells whether the displayed year is a leap year.
     */
    private function isLeapYear():Boolean
    {
      application.trace("<" + this + " DatePanel isLeapYear> called.", 1);
      const year:int = currentDateObject.getFullYear();
      return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
    }
    /**
     * Returns the number of the days of the displayed month.
     */
    private function getMonthLength():int
    {
      application.trace("<" + this + " DatePanel getMonthLength> called.", 1);
      const month:int = currentDateObject.getMonth() + 1;
      var monthLength:int = 31;
      if (month == 2)
      {
        monthLength = isLeapYear() ? 29 : 28;
      }
      else if (month == 4 || month == 6 || month == 9 || month == 11)
      {
        monthLength = 30;
      }
      application.trace("<" + this + " DatePanel getMonthLength> monthLength: " + monthLength, 0);
      return monthLength;
    }
    /**
     * Returns the given number as a string of at least two digits.
     * @param i the number to be converted
     */
    private function twoDigits(i:int):String
    {
      return i < 10 ? "0" + i : "" + i;
    }
    /**
     * Repositions every element after one of them has been resized.
     * @param e the dimensions changed event of a button or of a weekday element
     */
    private function objectsSizesChanged(e:Event):void
    {
      application.trace("<" + this + " DatePanel objectsSizesChanged> called.", 1);
      application.trace("<" + this + " DatePanel objectsSizesChanged> e: " + e, 0);
      reposElements();
    }
    /**
     * Puts the label of the selected date back into the middle after it has been
     * resized.
     * @param e the dimensions changed event of that label
     */
    private function dateTextLabelResized(e:Event):void
    {
      application.trace("<" + this + " DatePanel dateTextLabelResized> called.", 1);
      application.trace("<" + this + " DatePanel dateTextLabelResized> e: " + e, 0);
      reposDateTextLabel();
    }
    /**
     * Repositions every element after one of the pickers of the hours and the minutes
     * has been resized.
     * @param e the dimensions changed event of that picker
     */
    private function hoursOrMinutesResized(e:Event):void
    {
      application.trace("<" + this + " DatePanel hoursOrMinutesResized> called.", 1);
      application.trace("<" + this + " DatePanel hoursOrMinutesResized> e: " + e, 0);
      reposElements();
    }
    /**
     * Takes the selected hour and minute into the selected date. Both pickers report
     * here, and neither of them dispatches the changed event of this panel: a set of
     * the selected date moves both of them, so a dispatch from here would report a
     * change that the outside world has asked for itself.
     * @param e the changed event of the picker of the hours or of the minutes
     */
    private function hoursOrMinutesChanged(e:Event):void
    {
      application.trace("<" + this + " DatePanel hoursOrMinutesChanged> called.", 1);
      application.trace("<" + this + " DatePanel hoursOrMinutesChanged> e: " + e, 0);
      refreshSelectedDateFromPickers();
    }
    /**
     * Takes the selected hour and minute into the selected date.
     */
    private function refreshSelectedDateFromPickers():void
    {
      application.trace("<" + this + " DatePanel refreshSelectedDateFromPickers> called.", 1);
      setSelectedDate(createDate(currentDateObject.getFullYear()
          , currentDateObject.getMonth()
          , currentDateObject.getDate()));
      dateDisplay();
    }
    /**
     * Repositions every element after the padding of the application has been changed.
     * @param e the padding changed event of the application
     */
    private function paddingChanged(e:Event):void
    {
      application.trace("<" + this + " DatePanel paddingChanged> called.", 1);
      application.trace("<" + this + " DatePanel paddingChanged> e: " + e, 0);
      reposElements();
    }
    /**
     * Repositions every element and repaints the marked days after the line thickness
     * of the application has been changed.
     * @param e the line thickness changed event of the application
     */
    private function lineThicknessChanged(e:Event):void
    {
      application.trace("<" + this + " DatePanel lineThicknessChanged> called.", 1);
      application.trace("<" + this + " DatePanel lineThicknessChanged> e: " + e, 0);
      reposElements();
      paintDatesToBackground(true);
    }
    /**
     * Repaints the marked days in the new color after the dark text format of the
     * application has been changed.
     * @param e the dark text format changed event of the application
     */
    private function textFormatDarkChanged(e:Event):void
    {
      application.trace("<" + this + " DatePanel textFormatDarkChanged> called.", 1);
      application.trace("<" + this + " DatePanel textFormatDarkChanged> e: " + e, 0);
      paintDatesToBackground(true);
    }
    /**
     * Dispatches the changed event of this panel.
     */
    private function dispatchSelectedChanged():void
    {
      application.trace("<" + this + " DatePanel dispatchSelectedChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Frees all listeners, events and references held by this panel.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " DatePanel destroy> called.", 1);
      application.trace("<" + this + " DatePanel destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), paddingChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LINE_THICKNESS_CHANGED(), lineThicknessChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
      for (var i:int = 0; i < daysElementsArray.length; i++)
      {
        var dayLabel:TextLabel = TextLabel(daysElementsArray[i]);
        dayLabel.removeEventListener(MouseEvent.CLICK, dayClicked);
        dayLabel.removeEventListener(MouseEvent.MOUSE_OVER, dayMouseOver);
        dayLabel.removeEventListener(MouseEvent.MOUSE_OUT, dayMouseOut);
        dayLabel.removeEventListener(MouseEvent.MOUSE_DOWN, dayMouseDown);
      }
      application.trace("<" + this + " DatePanel destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      background.graphics.clear();
      if (contains(background))
      {
        removeChild(background);
      }
      hoursLabelArray.splice(0);
      hoursValueArray.splice(0);
      minutesLabelArray.splice(0);
      minutesValueArray.splice(0);
      weekdaysCodesArray.splice(0);
      weekdaysElementsArray.splice(0);
      weeksElementsArray.splice(0);
      daysElementsArray.splice(0);
      application.trace("<" + this + " DatePanel destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      eventChanged = null;
      currentDateObject = null;
      hoursAndMinutes = false;
      hoursLabelArray = null;
      hoursValueArray = null;
      hoursListPicker = null;
      minutesLabelArray = null;
      minutesValueArray = null;
      minutesListPicker = null;
      hmSepTextLabel = null;
      background = null;
      dateFormat = null;
      dateFormatter = null;
      firstButtonLink = null;
      leftButtonLink = null;
      dateTextLabel = null;
      rightButtonLink = null;
      lastButtonLink = null;
      todayButtonLink = null;
      weekdaysCodesArray = null;
      weekdaysElementsArray = null;
      weeksElementsArray = null;
      daysElementsArray = null;
      allElementsW = 0;
    }
  }
}
