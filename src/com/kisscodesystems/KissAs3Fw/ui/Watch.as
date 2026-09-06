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
 * Watch.
 * A watch that displays the current time. It is useful especially in full screen,
 * where the clock of the operating system can not be seen.
 *
 * MAIN FEATURES:
 * - four kinds of displaying: basic, digital, analog and binary
 * - the digital and the binary watches are assembled of little sprites, the alpha
 *   of those draws the current digit, and the analog one is drawn of rotated lines
 * - a panel opens on a click, it displays the date, the timezone and the weekday,
 *   and the kind of the watch and the displaying of the seconds can be set there
 * - that panel can be opened and closed from the outside as well, and the opened and
 *   the closed events of it are dispatched onto the dispatcher of this watch, so the
 *   content this panel opens onto can step out of the way of it
 * - the watch changed and the watch repositioned events are dispatched onto the
 *   dispatcher of this watch and onto the one of the application as well, so that the
 *   state of it can be saved outside and one single watch can be listened to as well
 * - only the currently displayed watch is updated, to save processor time
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
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import com.kisscodesystems.KissAs3Fw.ui.Switcher;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  public class Watch extends BaseSprite
  {
    private var eventWatchChanged:Event = null;
    private var eventWatchRepositioned:Event = null;
    private var eventOpened:Event = null;
    private var eventClosed:Event = null;
    private var timer:Timer = null;
    // The transparent layer the click that opens the panel happens on.
    private var spriteFg:BaseSprite = null;
    // The panel and the frame behind it.
    private var spriteBg:BaseSprite = null;
    private var shapeBgFrame:BaseShape = null;
    // The watch itself and the frame behind it.
    private var spriteWatch:BaseSprite = null;
    private var shapeFgFrame:BaseShape = null;
    // The elements of the panel.
    private var timeTextLabel:TextLabel = null;
    private var timezoneTextLabel:TextLabel = null;
    private var dateTextLabel:TextLabel = null;
    private var watchTypeListPicker:ListPicker = null;
    private var secondsSwitcher:Switcher = null;
    private var keysWeekdays:Array = null;
    private var keysWatchTypes:Array = null;
    // The four layers of the watch, one of them is visible at a time.
    private var basicTimeTextLabel:TextLabel = null;
    private var digitalTimeBaseSprite:BaseSprite = null;
    private var analogTimeBaseSprite:BaseSprite = null;
    private var binaryTimeBaseSprite:BaseSprite = null;
    // The elements of the digital watch.
    private var digitalH1:BaseSprite = null;
    private var digitalH2:BaseSprite = null;
    private var digitalM1:BaseSprite = null;
    private var digitalM2:BaseSprite = null;
    private var digitalS1:BaseSprite = null;
    private var digitalS2:BaseSprite = null;
    private var digitalC1:BaseSprite = null;
    private var digitalC2:BaseSprite = null;
    private var digitalElementsObject:Object = null;
    // Which piece of a digital digit is visible in which number, from e1 to e7.
    private var digitalSegmentsArray:Array = null;
    // The elements of the analog watch.
    private var analogH:BaseSprite = null;
    private var analogM:BaseSprite = null;
    private var analogS:BaseSprite = null;
    // The elements of the binary watch.
    private var binaryH1:BaseSprite = null;
    private var binaryH2:BaseSprite = null;
    private var binaryM1:BaseSprite = null;
    private var binaryM2:BaseSprite = null;
    private var binaryS1:BaseSprite = null;
    private var binaryS2:BaseSprite = null;
    private var binaryElementsObject:Object = null;
    // The sizes every watch displaying is drawn by.
    private var digitThickness:int = 1;
    private var binaryDigitDelta:int = 1;
    private var margin:int = 1;
    private var rectWidth:int = 1;
    private var allwBinary:int = 0;
    private var allwDigital:int = 0;
    private var watchType:String = "";
    /**
     * Constructs the Watch object: creates the panel of it, the four layers of the
     * watch itself and the timer that updates the displaying in every second.
     * @param applicationRef the main application reference
     */
    public function Watch(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " Watch> called.", 1);
      application.trace("<" + this + " Watch> applicationRef: " + applicationRef, 0);
      eventWatchChanged = new Event(EnumEvents.EVENT_WATCH_CHANGED());
      eventWatchRepositioned = new Event(EnumEvents.EVENT_WATCH_REPOSITIONED());
      eventOpened = new Event(EnumEvents.EVENT_OPENED());
      eventClosed = new Event(EnumEvents.EVENT_CLOSED());
      // the sunday of the weekday keys stands first, so the day index of a date object
      // points to its own weekday without any shifting
      keysWeekdays = application.getLabelManager().getKeysWeekdaysFromSunday();
      keysWatchTypes = application.getLabelManager().getKeysWatchTypes();
      digitalSegmentsArray = ["1110111", "0010010", "1011101", "1011011", "0111010"
          , "1101011", "1101111", "1010010", "1111111", "1111011"];
      watchType = EnumTextKeys.WATCH_TYPE_BASIC();
      shapeBgFrame = new BaseShape(application);
      addChild(shapeBgFrame);
      shapeBgFrame.setIsBright(true);
      shapeBgFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_PRESSED());
      shapeBgFrame.visible = false;
      spriteBg = new BaseSprite(application);
      addChild(spriteBg);
      spriteBg.visible = false;
      timeTextLabel = new TextLabel(application);
      spriteBg.addChild(timeTextLabel);
      timezoneTextLabel = new TextLabel(application);
      spriteBg.addChild(timezoneTextLabel);
      dateTextLabel = new TextLabel(application);
      spriteBg.addChild(dateTextLabel);
      watchTypeListPicker = new ListPicker(application);
      spriteBg.addChild(watchTypeListPicker);
      watchTypeListPicker.setArrays(keysWatchTypes, keysWatchTypes);
      watchTypeListPicker.setNumOfElements(4);
      secondsSwitcher = new Switcher(application);
      spriteBg.addChild(secondsSwitcher);
      secondsSwitcher.setLabels(EnumTextKeys.WATCH_SHOW_SECONDS(), EnumTextKeys.WATCH_WITHOUT_SECONDS());
      shapeFgFrame = new BaseShape(application);
      addChild(shapeFgFrame);
      shapeFgFrame.setIsBright(true);
      shapeFgFrame.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      spriteWatch = new BaseSprite(application);
      addChild(spriteWatch);
      spriteFg = new BaseSprite(application);
      addChild(spriteFg);
      createFrame();
      spriteFg.addEventListener(MouseEvent.CLICK, spriteFgClick, false, 0, true);
      watchTypeListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), watchTypeListPickerChanged);
      watchTypeListPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      secondsSwitcher.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), secondsSwitcherChanged);
      secondsSwitcher.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      timeTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      timezoneTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      dateTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      basicTimeTextLabel.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), reposElements);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), fontColorChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), reposElements);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), reposElements);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), reposElements);
      watchTypeListPicker.setSelectedIndex(keysWatchTypes.indexOf(watchType));
      secondsSwitcher.setOn(true, false);
      reposElements();
      timer = new Timer(application.getComponentsConfig().getWatchTimerDelay());
      timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
      timer.start();
      application.trace("<" + this + " Watch> constructed.", 1);
    }
    /**
     * Returns the kind of the watch that is displayed at the moment.
     */
    public function getWatchType():String
    {
      return watchType;
    }
    /**
     * Sets the kind of the watch to be displayed. Only one of the four watch type text
     * keys is taken, everything else is dropped.
     * @param t the text key of the kind of the watch
     */
    public function setWatchType(t:String):void
    {
      application.trace("<" + this + " Watch setWatchType> called.", 1);
      application.trace("<" + this + " Watch setWatchType> t: " + t, 0);
      if (watchType != t && keysWatchTypes.indexOf(t) >= 0)
      {
        watchTypeListPicker.setSelectedIndex(keysWatchTypes.indexOf(t));
      }
    }
    /**
     * Tells whether the seconds are displayed on the watch.
     */
    public function getWatchSecs():Boolean
    {
      return secondsSwitcher.getOn();
    }
    /**
     * Sets whether the seconds have to be displayed on the watch.
     * @param secs true when the seconds have to be displayed
     */
    public function setWatchSecs(secs:Boolean):void
    {
      application.trace("<" + this + " Watch setWatchSecs> called.", 1);
      application.trace("<" + this + " Watch setWatchSecs> secs: " + secs, 0);
      secondsSwitcher.setOn(secs);
    }
    /**
     * Returns the x coordinate of the frame of the watch itself, which is the left
     * edge of the displayed watch inside this object.
     */
    public function getShapeFgFrameX():int
    {
      return shapeFgFrame.x;
    }
    /**
     * Tells whether the panel of this watch is open at the moment.
     */
    public function isOpened():Boolean
    {
      return shapeBgFrame.visible;
    }
    /**
     * Opens the panel of this watch, where the further information is displayed and the
     * state of the watch can be set, and dispatches the opened event of it. An open panel
     * makes this object as tall as the watch and that panel together, so the content
     * around it hears the new dimensions of it right away. A disabled watch is not opened
     * at all and an open one has nothing to open.
     */
    public function open():void
    {
      application.trace("<" + this + " Watch open> called.", 1);
      if (!getEnabled() || shapeBgFrame.visible)
      {
        application.trace("<" + this + " Watch open> there is no panel to be opened.", 1);
        return;
      }
      shapeBgFrame.visible = true;
      spriteBg.visible = true;
      reposElements();
      update();
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown, false, 0, true);
      }
      dropOpenedEvent();
    }
    /**
     * Closes the panel of this watch and dispatches the closed event of it. A panel that
     * is not open at all has nothing to close, but the stage listener of it is dropped in
     * that case as well, because a watch that has never been opened carries none.
     */
    public function close():void
    {
      application.trace("<" + this + " Watch close> called.", 1);
      const wasOpened:Boolean = shapeBgFrame.visible;
      closeBackground();
      if (wasOpened)
      {
        dropClosedEvent();
      }
    }
    /**
     * Enables or disables the switcher of the seconds of this watch, and closes the
     * panel of it as soon as it is disabled: a disabled watch is not to be opened at
     * all, so an open panel of it has to go away right away.
     * @param b true when this watch has to be enabled
     */
    override public function setEnabled(b:Boolean):void
    {
      application.trace("<" + this + " Watch setEnabled> called.", 1);
      application.trace("<" + this + " Watch setEnabled> b: " + b, 0);
      super.setEnabled(b);
      secondsSwitcher.setEnabled(b);
      if (!b)
      {
        close();
      }
    }
    /**
     * The dimensions of this watch come from its own elements, so this does nothing.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " Watch setDw> called.", 1);
      application.trace("<" + this + " Watch setDw> newdw: " + newdw, 0);
      application.trace("<" + this + " Watch setDw> do nothing.", 1);
    }
    /**
     * The dimensions of this watch come from its own elements, so this does nothing.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " Watch setDh> called.", 1);
      application.trace("<" + this + " Watch setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " Watch setDh> do nothing.", 1);
    }
    /**
     * The dimensions of this watch come from its own elements, so this does nothing.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " Watch setDwh> called.", 1);
      application.trace("<" + this + " Watch setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " Watch setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " Watch setDwh> do nothing.", 1);
    }
    /**
     * Renders this watch in its initialized state as soon as it gets onto the stage.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " Watch addedToStage> called.", 1);
      application.trace("<" + this + " Watch addedToStage> e: " + e, 0);
      super.addedToStage(e);
      reposElements();
    }
    /**
     * Closes the panel of this watch when it gets off the stage, so that the stage
     * listener of that panel is removed as well.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " Watch removedFromStage> called.", 1);
      application.trace("<" + this + " Watch removedFromStage> e: " + e, 0);
      closeBackground();
      super.removedFromStage(e);
    }
    /**
     * Creates the four layers of the watch, one for every kind of displaying.
     */
    private function createFrame():void
    {
      application.trace("<" + this + " Watch createFrame> called.", 1);
      basicTimeTextLabel = new TextLabel(application);
      spriteWatch.addChild(basicTimeTextLabel);
      basicTimeTextLabel.setLabel(" ");
      basicTimeTextLabel.setIcon(EnumIcons.watch());
      digitalTimeBaseSprite = new BaseSprite(application);
      spriteWatch.addChild(digitalTimeBaseSprite);
      digitalElementsObject = new Object();
      digitalH1 = createDigitalElement("digitalH1");
      digitalH2 = createDigitalElement("digitalH2");
      digitalC1 = createDigitalElement("");
      digitalM1 = createDigitalElement("digitalM1");
      digitalM2 = createDigitalElement("digitalM2");
      digitalC2 = createDigitalElement("");
      digitalS1 = createDigitalElement("digitalS1");
      digitalS2 = createDigitalElement("digitalS2");
      analogTimeBaseSprite = new BaseSprite(application);
      spriteWatch.addChild(analogTimeBaseSprite);
      analogH = new BaseSprite(application);
      analogTimeBaseSprite.addChild(analogH);
      analogM = new BaseSprite(application);
      analogTimeBaseSprite.addChild(analogM);
      analogS = new BaseSprite(application);
      analogTimeBaseSprite.addChild(analogS);
      binaryTimeBaseSprite = new BaseSprite(application);
      spriteWatch.addChild(binaryTimeBaseSprite);
      binaryElementsObject = new Object();
      binaryH1 = createBinaryElement("binaryH1");
      binaryH2 = createBinaryElement("binaryH2");
      binaryM1 = createBinaryElement("binaryM1");
      binaryM2 = createBinaryElement("binaryM2");
      binaryS1 = createBinaryElement("binaryS1");
      binaryS2 = createBinaryElement("binaryS2");
      setWatchLayersVisible();
    }
    /**
     * Creates one element of the digital watch, together with the place its pieces are
     * held in. An element with no name is a colon, that has no pieces at all.
     * @param name the name of the place of the pieces of that element
     */
    private function createDigitalElement(name:String):BaseSprite
    {
      application.trace("<" + this + " Watch createDigitalElement> called.", 1);
      application.trace("<" + this + " Watch createDigitalElement> name: " + name, 0);
      const element:BaseSprite = new BaseSprite(application);
      digitalTimeBaseSprite.addChild(element);
      if (name != "")
      {
        digitalElementsObject[name] = new Object();
      }
      return element;
    }
    /**
     * Creates one element of the binary watch, together with the place its dots are
     * held in.
     * @param name the name of the place of the dots of that element
     */
    private function createBinaryElement(name:String):BaseSprite
    {
      application.trace("<" + this + " Watch createBinaryElement> called.", 1);
      application.trace("<" + this + " Watch createBinaryElement> name: " + name, 0);
      const element:BaseSprite = new BaseSprite(application);
      binaryTimeBaseSprite.addChild(element);
      binaryElementsObject[name] = new Object();
      return element;
    }
    /**
     * Displays the layer of the current kind of the watch and hides the other three.
     */
    private function setWatchLayersVisible():void
    {
      application.trace("<" + this + " Watch setWatchLayersVisible> called.", 1);
      basicTimeTextLabel.visible = watchType == EnumTextKeys.WATCH_TYPE_BASIC();
      digitalTimeBaseSprite.visible = watchType == EnumTextKeys.WATCH_TYPE_DIGITAL();
      analogTimeBaseSprite.visible = watchType == EnumTextKeys.WATCH_TYPE_ANALOG();
      binaryTimeBaseSprite.visible = watchType == EnumTextKeys.WATCH_TYPE_BINARY();
    }
    /**
     * Takes the new kind of the watch and reports the change to the outside world.
     * @param e the changed event of the picker of the kind of the watch
     */
    private function watchTypeListPickerChanged(e:Event):void
    {
      application.trace("<" + this + " Watch watchTypeListPickerChanged> called.", 1);
      application.trace("<" + this + " Watch watchTypeListPickerChanged> e: " + e, 0);
      watchType = watchTypeListPicker.getSelectedValue();
      reposElements();
      setWatchLayersVisible();
      update();
      dropWatchChangedEvent();
    }
    /**
     * Updates the displaying at once and reports the change to the outside world.
     * @param e the changed event of the switcher of the seconds
     */
    private function secondsSwitcherChanged(e:Event):void
    {
      application.trace("<" + this + " Watch secondsSwitcherChanged> called.", 1);
      application.trace("<" + this + " Watch secondsSwitcherChanged> e: " + e, 0);
      reposElements();
      update();
      dropWatchChangedEvent();
    }
    /**
     * Opens the panel of this watch, where the further information is displayed and
     * the state of the watch can be set. A disabled watch is not opened at all: the
     * transparent layer of the click is a child of this object, so it hears the clicks
     * even while this object itself takes none of them.
     * @param e the click event of the transparent layer above this watch
     */
    private function spriteFgClick(e:MouseEvent):void
    {
      application.trace("<" + this + " Watch spriteFgClick> called.", 1);
      application.trace("<" + this + " Watch spriteFgClick> e: " + e, 0);
      open();
    }
    /**
     * Closes the panel of this watch as soon as the mouse has been pressed down
     * outside of it.
     * @param e the mouse down event of the stage
     */
    private function stageMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " Watch stageMouseDown> called.", 1);
      application.trace("<" + this + " Watch stageMouseDown> e: " + e, 0);
      if (!(mouseX >= 0 && mouseX <= getDw() && mouseY >= 0 && mouseY <= getDh()))
      {
        close();
      }
    }
    /**
     * Closes the panel of this watch without dispatching the closed event of it and takes
     * the dimensions of the closed state right away: an open panel makes this object as
     * tall as the watch and that panel together, so the content around it has to hear the
     * new and smaller dimensions of it as soon as that panel is gone. The closing that is
     * asked for is the one of the close method above, this silent one belongs to the watch
     * that is taken off the stage, where there is nobody left to be told about it.
     */
    private function closeBackground():void
    {
      application.trace("<" + this + " Watch closeBackground> called.", 1);
      if (shapeBgFrame.visible)
      {
        shapeBgFrame.visible = false;
        spriteBg.visible = false;
        reposElements();
      }
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
      }
    }
    /**
     * Updates the displayed watch in every second, and the panel of it as well while
     * that panel is open.
     * @param e the timer event of the timer of this watch
     */
    private function timerHandler(e:TimerEvent):void
    {
      //application.trace("<" + this + " Watch timerHandler> called.", 0);
      if (shapeBgFrame.visible)
      {
        update();
      }
      else
      {
        updateWatch(new Date());
      }
    }
    /**
     * Updates the displayed watch and, while the panel is open, the time, the timezone
     * and the date displayed on that panel.
     */
    private function update():void
    {
      application.trace("<" + this + " Watch update> called.", 1);
      const date:Date = new Date();
      updateWatch(date);
      if (spriteBg.visible)
      {
        timeTextLabel.setLabel(date.getHours()
            + " : " + twoDigits(date.getMinutes())
            + " : " + twoDigits(date.getSeconds()));
        timezoneTextLabel.setLabel("( " + getTimezoneString(date) + " )");
        dateTextLabel.setLabel(keysWeekdays[date.getDay()]
            + ",  " + date.getFullYear()
            + " - " + twoDigits(date.getMonth() + 1)
            + " - " + twoDigits(date.getDate()));
      }
    }
    /**
     * Returns the current timezone of the given date in the UTC +hh:mm form.
     * The timezone offset is the number of the minutes that has to be added to the
     * local time to get the UTC one, so a positive offset means a timezone that is
     * behind the UTC.
     * @param date the date the timezone is taken from
     */
    private function getTimezoneString(date:Date):String
    {
      application.trace("<" + this + " Watch getTimezoneString> called.", 1);
      const tzo:Number = date.getTimezoneOffset();
      if (tzo == 0)
      {
        return "UTC";
      }
      const tzoAbs:Number = Math.abs(tzo);
      return "UTC " + (tzo < 0 ? "+" : "-") + twoDigits(int(tzoAbs / 60)) + ":" + twoDigits(int(tzoAbs % 60));
    }
    /**
     * Updates the currently displayed watch only, the other three are not visible, so
     * updating those would only cost processor time.
     * @param date the date the current time is taken from
     */
    private function updateWatch(date:Date):void
    {
      //application.trace("<" + this + " Watch updateWatch> called.", 1);
      const h:int = date.getHours();
      const m:int = date.getMinutes();
      const s:int = date.getSeconds();
      const temph:String = twoDigits(h);
      const tempm:String = twoDigits(m);
      const temps:String = twoDigits(s);
      const secondsAreOn:Boolean = secondsSwitcher.getOn();
      if (watchType == EnumTextKeys.WATCH_TYPE_BASIC() && basicTimeTextLabel.visible)
      {
        basicTimeTextLabel.setLabel("" + h + " : " + tempm + (secondsAreOn ? " : " + temps : ""));
      }
      else if (watchType == EnumTextKeys.WATCH_TYPE_DIGITAL() && digitalTimeBaseSprite.visible)
      {
        writeDigit("digitalH1", temph.substr(0, 1));
        writeDigit("digitalH2", temph.substr(1, 1));
        writeDigit("digitalM1", tempm.substr(0, 1));
        writeDigit("digitalM2", tempm.substr(1, 1));
        digitalC2.alpha = secondsAreOn && s % 2 == 0 ? 1 : 0;
        writeDigit("digitalS1", secondsAreOn ? temps.substr(0, 1) : "hide");
        writeDigit("digitalS2", secondsAreOn ? temps.substr(1, 1) : "hide");
      }
      else if (watchType == EnumTextKeys.WATCH_TYPE_ANALOG() && analogTimeBaseSprite.visible)
      {
        spinTime(analogH, h, 12);
        spinTime(analogM, m, 60);
        spinTime(analogS, secondsAreOn ? s : -1, 60);
      }
      else if (watchType == EnumTextKeys.WATCH_TYPE_BINARY() && binaryTimeBaseSprite.visible)
      {
        writeDots("binaryH1", temph.substr(0, 1));
        writeDots("binaryH2", temph.substr(1, 1));
        writeDots("binaryM1", tempm.substr(0, 1));
        writeDots("binaryM2", tempm.substr(1, 1));
        writeDots("binaryS1", secondsAreOn ? temps.substr(0, 1) : "hide");
        writeDots("binaryS2", secondsAreOn ? temps.substr(1, 1) : "hide");
      }
    }
    /**
     * Repositions every element of this watch and of its panel, and takes the
     * dimensions the whole thing needs.
     * @param e the dimensions changed event of an element of the panel, or the font
     * size, text format or padding changed event of the application, null on a direct
     * call
     */
    private function reposElements(e:Event = null):void
    {
      application.trace("<" + this + " Watch reposElements> called.", 1);
      application.trace("<" + this + " Watch reposElements> e: " + e, 0);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      timeTextLabel.setCxy(padding, padding);
      timezoneTextLabel.setCxy(timeTextLabel.getCx(), timeTextLabel.getCy(true) + padding);
      dateTextLabel.setCxy(timezoneTextLabel.getCx(), timezoneTextLabel.getCy(true) + padding);
      var max:int = 0;
      max = Math.max(max, timeTextLabel.getDw());
      max = Math.max(max, timezoneTextLabel.getDw());
      max = Math.max(max, dateTextLabel.getDw());
      max = Math.max(max, secondsSwitcher.getDw());
      watchTypeListPicker.setDw(max);
      watchTypeListPicker.setCxy(dateTextLabel.getCx(), dateTextLabel.getCy(true) + padding);
      secondsSwitcher.setCxy(dateTextLabel.getCx(), watchTypeListPicker.getCy(true) + padding);
      if (spriteBg.visible)
      {
        super.setDwh(max + 2 * padding, secondsSwitcher.getDh() + secondsSwitcher.getCy(true) + padding);
      }
      else
      {
        super.setDwh(max + 2 * padding, secondsSwitcher.getDh());
      }
      calcWidthHeightPositions();
      if (watchType == EnumTextKeys.WATCH_TYPE_DIGITAL())
      {
        shapeFgFrame.setDwh(allwDigital + 2 * padding, secondsSwitcher.getDh());
      }
      else if (watchType == EnumTextKeys.WATCH_TYPE_ANALOG())
      {
        shapeFgFrame.setDwh(secondsSwitcher.getDh(), secondsSwitcher.getDh());
      }
      else if (watchType == EnumTextKeys.WATCH_TYPE_BINARY())
      {
        shapeFgFrame.setDwh(allwBinary + 4 * padding, secondsSwitcher.getDh());
      }
      else
      {
        shapeFgFrame.setDwh(basicTimeTextLabel.getDw() + 2 * padding, secondsSwitcher.getDh());
      }
      shapeBgFrame.setDwh(getDw(), secondsSwitcher.getCy(true) + padding);
      redrawReposShapes();
      basicTimeTextLabelRepos();
      update();
      dropWatchRepositionedEvent();
    }
    /**
     * Puts the label of the basic watch into the middle of the frame of the watch.
     */
    private function basicTimeTextLabelRepos():void
    {
      application.trace("<" + this + " Watch basicTimeTextLabelRepos> called.", 1);
      basicTimeTextLabel.setCxy((shapeFgFrame.getDw() - basicTimeTextLabel.getDw()) / 2, application.getDynamicsConfig().getAppPadding());
    }
    /**
     * Redraws the frame of the watch and the frame of the panel in the current colors
     * and radius, and repositions everything that stands on those frames.
     * @param e the radius, box or background color changed event of the application,
     * null on a direct call
     */
    private function redrawReposShapes(e:Event = null):void
    {
      application.trace("<" + this + " Watch redrawReposShapes> called.", 1);
      application.trace("<" + this + " Watch redrawReposShapes> e: " + e, 0);
      shapeFgFrame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , 0
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      shapeFgFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      shapeFgFrame.drawRect();
      shapeFgFrame.x = getDw() - shapeFgFrame.getDw();
      shapeFgFrame.y = 0;
      spriteFg.graphics.clear();
      spriteFg.graphics.beginFill(0, 0);
      spriteFg.graphics.drawRect(0, 0, shapeFgFrame.getDw(), shapeFgFrame.getDh());
      spriteFg.graphics.endFill();
      spriteFg.x = shapeFgFrame.x;
      spriteFg.y = shapeFgFrame.y;
      spriteWatch.x = shapeFgFrame.x;
      spriteWatch.y = shapeFgFrame.y;
      const colorAlpha:Number = application.getDynamicsConfig().getAppBackgroundColorAlpha();
      shapeBgFrame.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorDark()
          , application.getDynamicsConfig().getAppBackgroundColorMid()
          , colorAlpha + (1 - colorAlpha) * 3 / 4
          , application.getDynamicsConfig().getAppBackgroundColorBright());
      shapeBgFrame.setRadius(application.getDynamicsConfig().getAppRadius());
      shapeBgFrame.drawRect();
      shapeBgFrame.x = 0;
      shapeBgFrame.y = secondsSwitcher.getDh();
      spriteBg.setCxy(shapeBgFrame.x, shapeBgFrame.y);
      fontColorChanged();
    }
    /**
     * Repaints every drawn watch in the new font color and applies the drop shadow
     * that belongs to that color.
     * @param e the bright font color changed event of the application, null on a
     * direct call
     */
    private function fontColorChanged(e:Event = null):void
    {
      application.trace("<" + this + " Watch fontColorChanged> called.", 1);
      application.trace("<" + this + " Watch fontColorChanged> e: " + e, 0);
      paintDigital();
      paintAnalog();
      paintBinary();
      update();
      setDropShadowFilter(application.getDynamicsConfig().getAppFontColorBright());
    }
    /**
     * Applies the bright or the dark drop shadow onto the drawn watches, whichever
     * belongs to the given font color.
     * @param color the current bright font color of the application
     */
    private function setDropShadowFilter(color:Number):void
    {
      application.trace("<" + this + " Watch setDropShadowFilter> called.", 1);
      application.trace("<" + this + " Watch setDropShadowFilter> color: " + color, 0);
      const dropShadowArray:Array = application.getUtils().brightShadowToApply(color.toString(16))
          ? application.getComponentsConfig().getTextDropShadowArrayBright()
          : application.getComponentsConfig().getTextDropShadowArrayDark();
      analogTimeBaseSprite.filters = dropShadowArray;
      digitalTimeBaseSprite.filters = dropShadowArray;
      binaryTimeBaseSprite.filters = dropShadowArray;
    }
    /**
     * Recalculates every size the watches are drawn by, from the current font size and
     * padding of the application.
     */
    private function calcWidthHeightPositions():void
    {
      application.trace("<" + this + " Watch calcWidthHeightPositions> called.", 1);
      const padding:int = application.getDynamicsConfig().getAppPadding();
      var size:int = application.getDynamicsConfig().getAppFontSize();
      if (size == 0)
      {
        size = application.calcFontSizeFromStageSize();
      }
      if (size < 31)
      {
        digitThickness = 3;
        binaryDigitDelta = 2;
      }
      else if (size < 51)
      {
        digitThickness = 5;
        binaryDigitDelta = 4;
      }
      else
      {
        digitThickness = 7;
        binaryDigitDelta = 6;
      }
      margin = digitThickness * 2;
      rectWidth = (application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_BRIGHT()) + 2 * padding - 2 * margin) / 2;
      if (secondsSwitcher.getOn())
      {
        allwBinary = 6 * rectWidth;
        allwDigital = 6 * rectWidth + 2 * digitThickness + 7 * margin;
      }
      else
      {
        allwBinary = 4 * rectWidth;
        allwDigital = 4 * rectWidth + digitThickness + 4 * margin;
      }
      application.trace("<" + this + " Watch calcWidthHeightPositions> rectWidth: " + rectWidth, 0);
      application.trace("<" + this + " Watch calcWidthHeightPositions> allwDigital: " + allwDigital, 0);
      application.trace("<" + this + " Watch calcWidthHeightPositions> allwBinary: " + allwBinary, 0);
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
     * Returns the index of the given single digit, minus one when the given string is
     * not a single digit at all.
     * @param number the string to be looked up
     */
    private function getDigitIndex(number:String):int
    {
      return number != null && number.length == 1 ? "0123456789".indexOf(number) : -1;
    }
    /**
     * Displays the given digit on the given element of the digital watch.
     * A digital digit is assembled of little pieces as:
     *   +-e1-+
     * e2|    |e3
     *   +-e4-+
     * e5|    |e6
     *   +-e7-+
     * The alpha of these pieces draws the given number, a string that is not a single
     * digit hides every piece of that element.
     * @param bs the name of the element of the digital watch
     * @param number the digit to be displayed, "hide" to hide the whole element
     */
    private function writeDigit(bs:String, number:String):void
    {
      //application.trace("<" + this + " Watch writeDigit> called.", 1);
      //application.trace("<" + this + " Watch writeDigit> bs: " + bs, 0);
      //application.trace("<" + this + " Watch writeDigit> number: " + number, 0);
      const digitIndex:int = getDigitIndex(number);
      const segments:String = digitIndex >= 0 ? String(digitalSegmentsArray[digitIndex]) : "0000000";
      for (var i:int = 0; i < segments.length; i++)
      {
        setAlphaToPiece(digitalElementsObject[bs]["e" + (i + 1)], segments.charAt(i) == "1" ? 1 : 0);
      }
    }
    /**
     * Draws one colon of the digital watch.
     * @param bs the element of the digital watch that colon is drawn into
     */
    private function makeDigitalColon(bs:BaseSprite):void
    {
      application.trace("<" + this + " Watch makeDigitalColon> called.", 1);
      const fontColor:Number = application.getDynamicsConfig().getAppFontColorBright();
      const gap:int = (rectWidth * 2 - digitThickness * 2) / 3;
      bs.graphics.clear();
      bs.graphics.lineStyle(1, fontColor, 1);
      drawDigitalColonDot(bs, gap);
      drawDigitalColonDot(bs, gap * 2 + digitThickness);
    }
    /**
     * Draws one single dot of a colon of the digital watch.
     * @param bs the element of the digital watch that dot is drawn into
     * @param newcy the y coordinate that dot is drawn at
     */
    private function drawDigitalColonDot(bs:BaseSprite, newcy:int):void
    {
      application.trace("<" + this + " Watch drawDigitalColonDot> called.", 1);
      application.trace("<" + this + " Watch drawDigitalColonDot> newcy: " + newcy, 0);
      bs.graphics.beginFill(application.getDynamicsConfig().getAppFontColorBright(), 1);
      bs.graphics.moveTo(0, newcy);
      bs.graphics.lineTo(digitThickness, newcy);
      bs.graphics.lineTo(digitThickness, newcy + digitThickness);
      bs.graphics.lineTo(0, newcy + digitThickness);
      bs.graphics.lineTo(0, newcy);
      bs.graphics.endFill();
    }
    /**
     * Draws one single piece of a digit of the digital watch.
     * @param bs the piece to be drawn
     */
    private function makeDigitalDigitPiece(bs:BaseSprite):void
    {
      application.trace("<" + this + " Watch makeDigitalDigitPiece> called.", 1);
      const fontColor:Number = application.getDynamicsConfig().getAppFontColorBright();
      bs.graphics.clear();
      bs.graphics.lineStyle(1, fontColor, 1);
      bs.graphics.beginFill(fontColor, 1);
      bs.graphics.moveTo(0, digitThickness / 2);
      bs.graphics.lineTo(digitThickness / 2, 0);
      bs.graphics.lineTo(rectWidth - digitThickness / 2, 0);
      bs.graphics.lineTo(rectWidth, digitThickness / 2);
      bs.graphics.lineTo(rectWidth - digitThickness / 2, digitThickness);
      bs.graphics.lineTo(digitThickness / 2, digitThickness);
      bs.graphics.lineTo(0, digitThickness / 2);
      bs.graphics.endFill();
    }
    /**
     * Rebuilds the seven pieces of one digit of the digital watch in the current sizes
     * and color, dropping the previous ones first.
     * @param bsBaseSprite the element of the digital watch to be rebuilt
     * @param bsString the name of the place the pieces of that element are held in
     */
    private function makeDigitalDigit(bsBaseSprite:BaseSprite, bsString:String):void
    {
      application.trace("<" + this + " Watch makeDigitalDigit> called.", 1);
      application.trace("<" + this + " Watch makeDigitalDigit> bsString: " + bsString, 0);
      removePieces(bsBaseSprite, digitalElementsObject[bsString], 7);
      const halfThickness:int = digitThickness / 2;
      createDigitalPiece(bsBaseSprite, bsString, "e1", 0, 0, 0);
      createDigitalPiece(bsBaseSprite, bsString, "e2", 90, digitThickness, 0);
      createDigitalPiece(bsBaseSprite, bsString, "e3", 90, rectWidth, 0);
      createDigitalPiece(bsBaseSprite, bsString, "e4", 0, 0, rectWidth - halfThickness - 1);
      createDigitalPiece(bsBaseSprite, bsString, "e5", 90, digitThickness, rectWidth - halfThickness - 1);
      createDigitalPiece(bsBaseSprite, bsString, "e6", 90, rectWidth, rectWidth - halfThickness - 1);
      createDigitalPiece(bsBaseSprite, bsString, "e7", 0, 0, rectWidth * 2 - digitThickness - 2);
    }
    /**
     * Creates one single piece of a digit of the digital watch.
     * @param bsBaseSprite the element of the digital watch that piece belongs to
     * @param bsString the name of the place the pieces of that element are held in
     * @param key the name of that piece
     * @param newRotation the rotation of that piece
     * @param newcx the x coordinate of that piece
     * @param newcy the y coordinate of that piece
     */
    private function createDigitalPiece(bsBaseSprite:BaseSprite, bsString:String, key:String, newRotation:int, newcx:int, newcy:int):void
    {
      application.trace("<" + this + " Watch createDigitalPiece> called.", 1);
      application.trace("<" + this + " Watch createDigitalPiece> bsString: " + bsString, 0);
      application.trace("<" + this + " Watch createDigitalPiece> key: " + key, 0);
      const piece:BaseSprite = new BaseSprite(application);
      bsBaseSprite.addChild(piece);
      makeDigitalDigitPiece(piece);
      piece.rotation = newRotation;
      piece.x = newcx;
      piece.y = newcy;
      piece.alpha = 0;
      digitalElementsObject[bsString][key] = piece;
    }
    /**
     * Rebuilds and repositions the whole digital watch.
     */
    private function paintDigital():void
    {
      application.trace("<" + this + " Watch paintDigital> called.", 1);
      calcWidthHeightPositions();
      makeDigitalDigit(digitalH1, "digitalH1");
      makeDigitalDigit(digitalH2, "digitalH2");
      makeDigitalColon(digitalC1);
      makeDigitalDigit(digitalM1, "digitalM1");
      makeDigitalDigit(digitalM2, "digitalM2");
      makeDigitalColon(digitalC2);
      makeDigitalDigit(digitalS1, "digitalS1");
      makeDigitalDigit(digitalS2, "digitalS2");
      digitalH1.x = int((shapeFgFrame.getDw() - allwDigital) / 2);
      digitalH1.y = margin + digitThickness / 2;
      digitalH2.x = digitalH1.x + rectWidth + margin;
      digitalH2.y = digitalH1.y;
      digitalC1.x = digitalH2.x + rectWidth + margin;
      digitalC1.y = digitalH1.y;
      digitalM1.x = digitalC1.x + digitThickness + margin;
      digitalM1.y = digitalH1.y;
      digitalM2.x = digitalM1.x + rectWidth + margin;
      digitalM2.y = digitalH1.y;
      digitalC2.x = digitalM2.x + rectWidth + margin;
      digitalC2.y = digitalH1.y;
      digitalS1.x = digitalC2.x + digitThickness + margin;
      digitalS1.y = digitalH1.y;
      digitalS2.x = digitalS1.x + rectWidth + margin;
      digitalS2.y = digitalH1.y;
    }
    /**
     * Rotates one pointer of the analog watch to the given time, and hides that
     * pointer when a negative time is given.
     * @param bs the pointer to be rotated
     * @param time the time that pointer has to display
     * @param max the time one whole turn of that pointer means
     */
    private function spinTime(bs:BaseSprite, time:int, max:int):void
    {
      application.trace("<" + this + " Watch spinTime> called.", 1);
      application.trace("<" + this + " Watch spinTime> time: " + time, 0);
      application.trace("<" + this + " Watch spinTime> max: " + max, 0);
      if (max > 0 && time >= 0)
      {
        bs.rotation = time / max * 360;
        bs.alpha = 1;
      }
      else
      {
        bs.alpha = 0;
      }
    }
    /**
     * Rebuilds and repositions the whole analog watch: its frame and its three
     * pointers.
     */
    private function paintAnalog():void
    {
      application.trace("<" + this + " Watch paintAnalog> called.", 1);
      calcWidthHeightPositions();
      const fontColor:Number = application.getDynamicsConfig().getAppFontColorBright();
      drawAnalogPointer(analogH, 4, shapeFgFrame.getDh() / 4);
      drawAnalogPointer(analogM, 3, shapeFgFrame.getDh() / 3);
      drawAnalogPointer(analogS, 2, shapeFgFrame.getDh() / 3);
    }
    /**
     * Draws one pointer of the analog watch into the middle of the frame of it.
     * @param bs the pointer to be drawn
     * @param thickness the thickness of that pointer
     * @param length the length of that pointer
     */
    private function drawAnalogPointer(bs:BaseSprite, thickness:int, length:int):void
    {
      application.trace("<" + this + " Watch drawAnalogPointer> called.", 1);
      application.trace("<" + this + " Watch drawAnalogPointer> thickness: " + thickness, 0);
      application.trace("<" + this + " Watch drawAnalogPointer> length: " + length, 0);
      bs.graphics.clear();
      bs.graphics.lineStyle(thickness, application.getDynamicsConfig().getAppFontColorBright(), 1, true);
      bs.graphics.moveTo(0, 0);
      bs.graphics.lineTo(0, -length);
      bs.x = shapeFgFrame.getDw() / 2;
      bs.y = shapeFgFrame.getDh() / 2;
    }
    /**
     * Displays the given digit on the given element of the binary watch.
     * A binary digit is assembled of four filled dots, e1 to e4, and of the four
     * circles around them, e5 to e8. The four dots are the four bits of the digit,
     * e1 is the greatest one, and a string that is not a single digit hides every dot
     * and circle of that element.
     * @param bs the name of the element of the binary watch
     * @param number the digit to be displayed, "hide" to hide the whole element
     */
    private function writeDots(bs:String, number:String):void
    {
      application.trace("<" + this + " Watch writeDots> called.", 1);
      application.trace("<" + this + " Watch writeDots> bs: " + bs, 0);
      application.trace("<" + this + " Watch writeDots> number: " + number, 0);
      const digitIndex:int = getDigitIndex(number);
      if (digitIndex >= 0)
      {
        setAlphaToPiece(binaryElementsObject[bs]["e1"], (digitIndex & 8) != 0 ? 1 : 0);
        setAlphaToPiece(binaryElementsObject[bs]["e2"], (digitIndex & 4) != 0 ? 1 : 0);
        setAlphaToPiece(binaryElementsObject[bs]["e3"], (digitIndex & 2) != 0 ? 1 : 0);
        setAlphaToPiece(binaryElementsObject[bs]["e4"], (digitIndex & 1) != 0 ? 1 : 0);
        setVisibleAllCircles(bs);
      }
      else
      {
        for (var i:int = 1; i <= 8; i++)
        {
          setAlphaToPiece(binaryElementsObject[bs]["e" + i], 0);
        }
      }
    }
    /**
     * Displays every circle of the given element of the binary watch.
     * @param bs the name of the element of the binary watch
     */
    private function setVisibleAllCircles(bs:String):void
    {
      application.trace("<" + this + " Watch setVisibleAllCircles> called.", 1);
      application.trace("<" + this + " Watch setVisibleAllCircles> bs: " + bs, 0);
      if (BaseSprite(binaryElementsObject[bs]["e8"]).alpha == 0)
      {
        for (var i:int = 5; i <= 8; i++)
        {
          setAlphaToPiece(binaryElementsObject[bs]["e" + i], 1);
        }
      }
    }
    /**
     * Sets the alpha of one piece of a drawn watch, when that piece exists at all.
     * @param o the piece the alpha is set on
     * @param a the alpha to be set
     */
    private function setAlphaToPiece(o:Object, a:Number):void
    {
      if (o is BaseSprite)
      {
        BaseSprite(o).alpha = a;
      }
    }
    /**
     * Draws one dot or one circle of the binary watch.
     * @param bs the dot or circle to be drawn
     * @param toFill true for a filled dot, false for a circle around one
     */
    private function makeBinaryDot(bs:BaseSprite, toFill:Boolean):void
    {
      application.trace("<" + this + " Watch makeBinaryDot> called.", 1);
      application.trace("<" + this + " Watch makeBinaryDot> toFill: " + toFill, 0);
      const fontColor:Number = application.getDynamicsConfig().getAppFontColorBright();
      bs.graphics.clear();
      bs.graphics.lineStyle(1, fontColor, 1, true);
      if (toFill)
      {
        bs.graphics.beginFill(fontColor, 1);
      }
      bs.graphics.drawRect(rectWidth / 4, 0, digitThickness * 2, digitThickness);
      if (toFill)
      {
        bs.graphics.endFill();
      }
    }
    /**
     * Rebuilds the dots and the circles of one digit of the binary watch in the
     * current sizes and color, dropping the previous ones first. The two greatest bits
     * are only built when that digit can really reach them.
     * @param bsBaseSprite the element of the binary watch to be rebuilt
     * @param bsString the name of the place the dots of that element are held in
     * @param visible1 true when the greatest bit is needed by that digit
     * @param visible2 true when the second greatest bit is needed by that digit
     */
    private function makeBinaryDigit(bsBaseSprite:BaseSprite, bsString:String, visible1:Boolean, visible2:Boolean):void
    {
      application.trace("<" + this + " Watch makeBinaryDigit> called.", 1);
      application.trace("<" + this + " Watch makeBinaryDigit> bsString: " + bsString, 0);
      application.trace("<" + this + " Watch makeBinaryDigit> visible1: " + visible1, 0);
      application.trace("<" + this + " Watch makeBinaryDigit> visible2: " + visible2, 0);
      removePieces(bsBaseSprite, binaryElementsObject[bsString], 8);
      createBinaryDot(bsBaseSprite, bsString, "e1", true, 0, visible1, 0);
      createBinaryDot(bsBaseSprite, bsString, "e2", true, 1, visible2, 0);
      createBinaryDot(bsBaseSprite, bsString, "e3", true, 2, true, 0);
      createBinaryDot(bsBaseSprite, bsString, "e4", true, 3, true, 0);
      createBinaryDot(bsBaseSprite, bsString, "e5", false, 0, visible1, 1);
      createBinaryDot(bsBaseSprite, bsString, "e6", false, 1, visible2, 1);
      createBinaryDot(bsBaseSprite, bsString, "e7", false, 2, true, 1);
      createBinaryDot(bsBaseSprite, bsString, "e8", false, 3, true, 1);
    }
    /**
     * Creates one dot or one circle of a digit of the binary watch, or leaves that
     * place empty when that bit is not needed by that digit.
     * @param bsBaseSprite the element of the binary watch that dot belongs to
     * @param bsString the name of the place the dots of that element are held in
     * @param key the name of that dot
     * @param toFill true for a filled dot, false for a circle around one
     * @param row the index of the bit that dot displays, the greatest one is the zero
     * @param isNeeded false when that place has to be left empty
     * @param newAlpha the alpha that dot starts with
     */
    private function createBinaryDot(bsBaseSprite:BaseSprite, bsString:String, key:String, toFill:Boolean, row:int, isNeeded:Boolean, newAlpha:Number):void
    {
      application.trace("<" + this + " Watch createBinaryDot> called.", 1);
      application.trace("<" + this + " Watch createBinaryDot> bsString: " + bsString, 0);
      application.trace("<" + this + " Watch createBinaryDot> key: " + key, 0);
      application.trace("<" + this + " Watch createBinaryDot> isNeeded: " + isNeeded, 0);
      if (!isNeeded)
      {
        binaryElementsObject[bsString][key] = null;
        return;
      }
      const dot:BaseSprite = new BaseSprite(application);
      bsBaseSprite.addChild(dot);
      makeBinaryDot(dot, toFill);
      dot.x = 0;
      dot.y = row * digitThickness + row * binaryDigitDelta;
      dot.alpha = newAlpha;
      binaryElementsObject[bsString][key] = dot;
    }
    /**
     * Rebuilds and repositions the whole binary watch.
     */
    private function paintBinary():void
    {
      application.trace("<" + this + " Watch paintBinary> called.", 1);
      calcWidthHeightPositions();
      makeBinaryDigit(binaryH1, "binaryH1", false, false);
      makeBinaryDigit(binaryH2, "binaryH2", true, true);
      makeBinaryDigit(binaryM1, "binaryM1", false, true);
      makeBinaryDigit(binaryM2, "binaryM2", true, true);
      makeBinaryDigit(binaryS1, "binaryS1", false, true);
      makeBinaryDigit(binaryS2, "binaryS2", true, true);
      binaryH1.x = int((shapeFgFrame.getDw() - allwBinary) / 2);
      binaryH1.y = int((shapeFgFrame.getDh() - 4 * digitThickness - 3 * binaryDigitDelta) / 2);
      binaryH2.x = binaryH1.x + rectWidth;
      binaryH2.y = binaryH1.y;
      binaryM1.x = binaryH2.x + rectWidth;
      binaryM1.y = binaryH1.y;
      binaryM2.x = binaryM1.x + rectWidth;
      binaryM2.y = binaryH1.y;
      binaryS1.x = binaryM2.x + rectWidth;
      binaryS1.y = binaryH1.y;
      binaryS2.x = binaryS1.x + rectWidth;
      binaryS2.y = binaryH1.y;
    }
    /**
     * Destroys and drops every piece of one element of a drawn watch.
     * @param bsBaseSprite the element of that watch
     * @param pieces the place the pieces of that element are held in
     * @param numOfPieces the number of the pieces of that element
     */
    private function removePieces(bsBaseSprite:BaseSprite, pieces:Object, numOfPieces:int):void
    {
      application.trace("<" + this + " Watch removePieces> called.", 1);
      application.trace("<" + this + " Watch removePieces> numOfPieces: " + numOfPieces, 0);
      for (var i:int = 1; i <= numOfPieces; i++)
      {
        var key:String = "e" + i;
        if (pieces[key] is BaseSprite)
        {
          var piece:BaseSprite = BaseSprite(pieces[key]);
          piece.destroy();
          if (bsBaseSprite.contains(piece))
          {
            bsBaseSprite.removeChild(piece);
          }
        }
        pieces[key] = null;
      }
    }
    /**
     * Dispatches the watch changed event onto the dispatcher of this watch and onto the
     * one of the application as well. The one of the application is the place the state
     * of this watch can be saved from wherever it stands, and the one of this watch is
     * the place a listener of this very object hears it on: an application holding more
     * than one watch can not tell the watches apart on the shared dispatcher.
     */
    private function dropWatchChangedEvent():void
    {
      application.trace("<" + this + " Watch dropWatchChangedEvent> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventWatchChanged);
      }
      if (application.getBaseEventDispatcher() != null)
      {
        application.getBaseEventDispatcher().dispatchEvent(eventWatchChanged);
      }
    }
    /**
     * Dispatches the watch repositioned event onto the dispatcher of this watch and onto
     * the one of the application as well, so that the elements around this watch can
     * follow its new dimensions whichever of the two they listen to.
     */
    private function dropWatchRepositionedEvent():void
    {
      application.trace("<" + this + " Watch dropWatchRepositionedEvent> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventWatchRepositioned);
      }
      if (application.getBaseEventDispatcher() != null)
      {
        application.getBaseEventDispatcher().dispatchEvent(eventWatchRepositioned);
      }
    }
    /**
     * Dispatches the opened event of the panel of this watch onto the dispatcher of it.
     */
    private function dropOpenedEvent():void
    {
      application.trace("<" + this + " Watch dropOpenedEvent> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventOpened);
      }
    }
    /**
     * Dispatches the closed event of the panel of this watch onto the dispatcher of it.
     */
    private function dropClosedEvent():void
    {
      application.trace("<" + this + " Watch dropClosedEvent> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventClosed);
      }
    }
    /**
     * Frees all listeners, events and references held by this watch.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " Watch destroy> called.", 1);
      application.trace("<" + this + " Watch destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_RADIUS_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_CORNER_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BOX_FRAME_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_DARK_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_MID_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_BRIGHT_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_BACKGROUND_COLOR_ALPHA_CHANGED(), redrawReposShapes);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_COLOR_BRIGHT_CHANGED(), fontColorChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), reposElements);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), reposElements);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), reposElements);
      spriteFg.removeEventListener(MouseEvent.CLICK, spriteFgClick);
      timer.removeEventListener(TimerEvent.TIMER, timerHandler);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
      }
      application.trace("<" + this + " Watch destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventWatchChanged.stopImmediatePropagation();
      eventWatchRepositioned.stopImmediatePropagation();
      eventOpened.stopImmediatePropagation();
      eventClosed.stopImmediatePropagation();
      timer.stop();
      analogTimeBaseSprite.filters = null;
      digitalTimeBaseSprite.filters = null;
      binaryTimeBaseSprite.filters = null;
      keysWeekdays.splice(0);
      keysWatchTypes.splice(0);
      digitalSegmentsArray.splice(0);
      application.trace("<" + this + " Watch destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      eventWatchChanged = null;
      eventWatchRepositioned = null;
      eventOpened = null;
      eventClosed = null;
      timer = null;
      spriteFg = null;
      spriteBg = null;
      shapeBgFrame = null;
      spriteWatch = null;
      shapeFgFrame = null;
      timeTextLabel = null;
      timezoneTextLabel = null;
      dateTextLabel = null;
      watchTypeListPicker = null;
      secondsSwitcher = null;
      keysWeekdays = null;
      keysWatchTypes = null;
      basicTimeTextLabel = null;
      digitalTimeBaseSprite = null;
      analogTimeBaseSprite = null;
      binaryTimeBaseSprite = null;
      digitalH1 = null;
      digitalH2 = null;
      digitalM1 = null;
      digitalM2 = null;
      digitalS1 = null;
      digitalS2 = null;
      digitalC1 = null;
      digitalC2 = null;
      digitalElementsObject = null;
      digitalSegmentsArray = null;
      analogH = null;
      analogM = null;
      analogS = null;
      binaryH1 = null;
      binaryH2 = null;
      binaryM1 = null;
      binaryM2 = null;
      binaryS1 = null;
      binaryS2 = null;
      binaryElementsObject = null;
      digitThickness = 0;
      binaryDigitDelta = 0;
      margin = 0;
      rectWidth = 0;
      allwBinary = 0;
      allwDigital = 0;
      watchType = null;
    }
  }
}
