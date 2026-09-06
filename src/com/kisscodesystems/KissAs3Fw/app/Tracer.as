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
 * Tracer
 * Displays the messages of the application on top of everything else, behind a button
 * standing in the bottom right corner of the stage.
 *
 * MAIN FEATURES:
 * - the messages are numbered, capped at the newest ones and filterable by a text or a pattern
 * - the log follows its own end until the one reading it scrolls away from that end
 * - the logging can be paused and the collected messages can be dropped
 * - the level of the tracing is set on the buttons of this tracer, without a new build
 *
 * WHY THIS CLASS IS BUILT OF FLASH PRIMITIVES ONLY:
 * This is the one class of the framework that may not be built of the components of that
 * framework. Every one of those components logs, so a tracer made of them would describe its
 * own layout, its own scrolling and its own rollovers to itself: the messages of the tracer
 * would bury the messages of the application. A latch in the application cannot help with
 * that, because the tracer answers its own mouse and stage events in a later frame, long
 * after the trace call that fed it has returned.
 * So this class extends flash.display.Sprite instead of BaseSprite, it is built of a shape, of
 * sprites and of text fields, and it is the single class of this framework that never calls
 * application.trace: see the logging rules of the framework. It holds every value it
 * displays itself instead of reading the utils or the configs of the application, because every
 * getter of those logs as well, which also means that a tracer can be created at any moment,
 * even before those configs exist, and can display the messages of a failing initialization.
 * The level of the tracing is the single thing of that application this class does touch, and
 * it may: reading that level costs no message at all, and setting it happens on a click of the
 * one debugging, so the two messages of that setting are a wanted mark in the log, not a flood.
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFieldType;
  import flash.text.TextFormat;
  public class Tracer extends Sprite
  {
    private const ATTRDELIM:String = "&";
    private const ATTRMARGIN:String = "   | ";
    private const BACKGROUNDALPHA:Number = 0.88;
    private const BACKGROUNDCOLOR:uint = 0x101010;
    private const BUTTONCOLOR:uint = 0x303030;
    private const BUTTONCOLORACTIVE:uint = 0x006400;
    private const BUTTONCOLOROVER:uint = 0x585858;
    private const CLEARLABEL:String = "Clear";
    private const DEFAULTHEIGHT:int = 600;
    private const DEFAULTWIDTH:int = 800;
    private const DIGITGAP:int = 1;
    private const FIELDBACKGROUNDCOLOR:uint = 0x202020;
    private const FIELDBORDERCOLOR:uint = 0x606060;
    private const FILTERMAXCHARS:int = 100;
    private const FONTNAME:String = "_typewriter";
    private const FONTSIZE:int = 12;
    private const LEVELCOUNT:int = 10;
    private const LINENUMDELIM:String = ": ";
    private const MARGIN:int = 4;
    private const MAXLINES:int = 2000;
    private const NETWORKATTRDELIM:String = ">";
    private const PADDING:int = 8;
    private const PAUSELABELNO:String = "Paused";
    private const PAUSELABELYES:String = "Logging";
    private const ROWHEIGHT:int = 22;
    private const TEXTCOLOR:uint = 0xe8e8e8;
    private const TRACERLABEL:String = "Tracer";
    private const TRIMCHUNK:int = 200;
    private var application:Application = null;
    private var backgroundShape:Shape = null;
    private var logField:TextField = null;
    private var filterField:TextField = null;
    private var levelButtons:Array = null;
    private var pauseButton:Sprite = null;
    private var clearButton:Sprite = null;
    private var tracerButton:Sprite = null;
    private var traceLines:Array = null;
    private var filterRegExp:RegExp = null;
    private var lineNumber:int = 0;
    private var dragStartScrollV:int = 0;
    private var dragStartY:Number = 0;
    private var dragging:Boolean = false;
    private var following:Boolean = true;
    private var opened:Boolean = false;
    private var paused:Boolean = false;
    /**
     * Constructs the tracer object with every element of it. Nothing here needs the stage or
     * any part of the application, so this object can be created at any moment of the life of
     * that application.
     * @param applicationRef the main application reference, the level of the tracing of which
     * this tracer displays and sets. Nothing else of it is ever touched, see the header comment
     * lines above
     */
    public function Tracer(applicationRef:Application):void
    {
      super();
      application = applicationRef;
      traceLines = new Array();
      createElements();
      layoutElements();
      showOpenedElements();
      addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
// This listener is not a weak referenced one on purpose: this tracer lives as long as the
// application it belongs to, and a weakly held one of these could be collected at any moment,
// leaving the displayed level behind the real one without a word.
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TRACE_LEVEL_CHANGED(),
        traceLevelChanged, false, 0, false);
    }
    /**
     * Displays every message collected by the application since the previous frame, numbered
     * and broken into their attributes when they carry any. A paused tracer drops them all.
     * The whole batch is written in one single step on purpose: this field measures and lays
     * its complete text out again for every write it is given, so writing the messages one by
     * one costs minutes when the application produces thousands of them.
     * @param messages the messages to be displayed, already formatted by the application
     */
    public function trace(messages:Array):void
    {
      if (paused || logField == null)
      {
        return;
      }
      const newLines:Array = new Array();
      for (var i:int = 0; i < messages.length; i++)
      {
        var lines:Array = collectLines(String(messages[i]));
        for (var j:int = 0; j < lines.length; j++)
        {
          newLines.push(lines[j]);
        }
      }
      if (newLines.length > 0)
      {
        appendLines(newLines);
      }
    }
    /**
     * Drops every message collected so far and starts the numbering of the lines again.
     */
    public function clear():void
    {
      traceLines.splice(0, traceLines.length);
      lineNumber = 0;
      following = true;
      refreshText();
    }
    /**
     * Displays the log and every element belonging to it. The button of this tracer stays
     * visible either way, that is the one bringing the log back.
     */
    public function open():void
    {
      opened = true;
      layoutElements();
      showOpenedElements();
      scrollToEnd();
    }
    /**
     * Hides the log and every element belonging to it, leaving the button of this tracer only.
     */
    public function close():void
    {
      opened = false;
      showOpenedElements();
    }
    /**
     * Tells whether the log of this tracer is displayed right now.
     */
    public function isOpened():Boolean
    {
      return opened;
    }
    /**
     * Tells whether this tracer drops the messages it is given.
     */
    public function getPaused():Boolean
    {
      return paused;
    }
    /**
     * Sets whether this tracer drops the messages it is given.
     * @param b true to drop every message from now on
     */
    public function setPaused(b:Boolean):void
    {
      paused = b;
      setButtonLabel(pauseButton, paused ? PAUSELABELNO : PAUSELABELYES);
      layoutElements();
    }
    /**
     * Returns the text or the pattern the displayed lines are filtered by.
     */
    public function getFilter():String
    {
      return filterField == null ? "" : filterField.text;
    }
    /**
     * Sets the text or the pattern the displayed lines are filtered by. An empty one displays
     * every line collected.
     * @param newFilter the text or the pattern to filter the lines by
     */
    public function setFilter(newFilter:String):void
    {
      filterField.text = newFilter;
      buildFilterRegExp();
      refreshText();
    }
    /**
     * Returns the number of the lines this tracer keeps right now.
     */
    public function getLineCount():int
    {
      return traceLines.length;
    }
    /**
     * Builds every element of this tracer. The log is not selectable on purpose: dragging it
     * scrolls it instead of selecting its text, the way every other scrollable surface of this
     * framework behaves.
     */
    private function createElements():void
    {
      backgroundShape = new Shape();
      addChild(backgroundShape);
      logField = new TextField();
      addChild(logField);
      logField.defaultTextFormat = new TextFormat(FONTNAME, FONTSIZE, TEXTCOLOR);
      logField.type = TextFieldType.DYNAMIC;
      logField.multiline = true;
      logField.wordWrap = true;
      logField.selectable = false;
      logField.mouseWheelEnabled = false;
      logField.addEventListener(MouseEvent.MOUSE_DOWN, logMouseDown, false, 0, true);
      logField.addEventListener(MouseEvent.MOUSE_WHEEL, logMouseWheel, false, 0, true);
      filterField = new TextField();
      addChild(filterField);
      filterField.defaultTextFormat = new TextFormat(FONTNAME, FONTSIZE, TEXTCOLOR);
      filterField.type = TextFieldType.INPUT;
      filterField.maxChars = FILTERMAXCHARS;
      filterField.background = true;
      filterField.backgroundColor = FIELDBACKGROUNDCOLOR;
      filterField.border = true;
      filterField.borderColor = FIELDBORDERCOLOR;
      filterField.addEventListener(Event.CHANGE, filterChanged, false, 0, true);
      levelButtons = new Array();
      for (var level:int = 0; level < LEVELCOUNT; level++)
      {
        levelButtons.push(createButton("" + level, levelClicked));
      }
      pauseButton = createButton(PAUSELABELYES, pauseClicked);
      clearButton = createButton(CLEARLABEL, clearClicked);
      tracerButton = createButton(TRACERLABEL, tracerClicked);
      refreshLevelButtons();
    }
    /**
     * Builds one button of this tracer: a drawn sprite carrying a label that lets the clicks
     * through to that sprite.
     * @param label the text of the button
     * @param clickListener the listener the click of the button is reported to
     */
    private function createButton(label:String, clickListener:Function):Sprite
    {
      const button:Sprite = new Sprite();
      addChild(button);
      button.buttonMode = true;
      button.useHandCursor = true;
      const labelField:TextField = new TextField();
      button.addChild(labelField);
      labelField.defaultTextFormat = new TextFormat(FONTNAME, FONTSIZE, TEXTCOLOR);
      labelField.autoSize = TextFieldAutoSize.LEFT;
      labelField.selectable = false;
      labelField.mouseEnabled = false;
      labelField.text = label;
      button.addEventListener(MouseEvent.CLICK, clickListener, false, 0, true);
      button.addEventListener(MouseEvent.ROLL_OVER, buttonRollOver, false, 0, true);
      button.addEventListener(MouseEvent.ROLL_OUT, buttonRollOut, false, 0, true);
      paintButton(button, BUTTONCOLOR);
      return button;
    }
    /**
     * Draws the background of one button around its label and centers that label in it.
     * @param button the button to be drawn
     * @param color the background color of the button
     */
    private function paintButton(button:Sprite, color:uint):void
    {
      const labelField:TextField = TextField(button.getChildAt(0));
      const drawnWidth:int = buttonWidth(button);
      labelField.x = PADDING;
      labelField.y = (ROWHEIGHT - labelField.height) / 2;
      button.graphics.clear();
      if (isActiveLevelButton(button))
      {
        // the rect around the level the messages are displayed from
        button.graphics.lineStyle(1, TEXTCOLOR);
      }
      button.graphics.beginFill(color, 1);
      button.graphics.drawRect(0.5, 0.5, drawnWidth - 1, ROWHEIGHT - 1);
      button.graphics.endFill();
      button.graphics.lineStyle();
    }
    /**
     * Tells whether the given button is the one of the level the messages are displayed from.
     * @param button the button to be checked
     */
    private function isActiveLevelButton(button:Sprite):Boolean
    {
      return levelButtons != null && application != null
        && levelButtons.indexOf(button) == application.getTraceLevel();
    }
    /**
     * Returns the color one button stands in while the mouse is not over it.
     * @param button the button the color belongs to
     */
    private function colorOfButton(button:Sprite):uint
    {
      return isActiveLevelButton(button) ? BUTTONCOLORACTIVE : BUTTONCOLOR;
    }
    /**
     * Draws every level button again, so that the one of the level being displayed is the
     * marked one.
     */
    private function refreshLevelButtons():void
    {
      for (var level:int = 0; level < levelButtons.length; level++)
      {
        paintButton(Sprite(levelButtons[level]), colorOfButton(Sprite(levelButtons[level])));
      }
    }
    /**
     * Replaces the label of one button and draws that button around the new text.
     * @param button the button the label belongs to
     * @param label the new text of the button
     */
    private function setButtonLabel(button:Sprite, label:String):void
    {
      TextField(button.getChildAt(0)).text = label;
      paintButton(button, BUTTONCOLOR);
    }
    /**
     * Returns the width of one button, the drawn background of it included.
     * @param button the button to be measured
     */
    private function buttonWidth(button:Sprite):int
    {
      return TextField(button.getChildAt(0)).width + 2 * PADDING;
    }
    /**
     * Lays every element out inside the dimensions of the stage, or inside the default ones
     * while this object is not standing on that stage yet. The button of this tracer goes to
     * the bottom right corner, the other buttons and the filter stand in one row next to it
     * and the log takes the whole surface above that row.
     */
    private function layoutElements():void
    {
      const areaWidth:int = stage == null ? DEFAULTWIDTH : stage.stageWidth;
      const areaHeight:int = stage == null ? DEFAULTHEIGHT : stage.stageHeight;
      const rowY:int = areaHeight - MARGIN - ROWHEIGHT;
      backgroundShape.graphics.clear();
      backgroundShape.graphics.beginFill(BACKGROUNDCOLOR, BACKGROUNDALPHA);
      backgroundShape.graphics.drawRect(0, 0, areaWidth, areaHeight);
      backgroundShape.graphics.endFill();
      tracerButton.x = areaWidth - MARGIN - buttonWidth(tracerButton);
      tracerButton.y = rowY;
      clearButton.x = tracerButton.x - MARGIN - buttonWidth(clearButton);
      clearButton.y = rowY;
      pauseButton.x = clearButton.x - MARGIN - buttonWidth(pauseButton);
      pauseButton.y = rowY;
      // the levels stand in one tight group of their own, right in front of the pause button
      var levelX:int = pauseButton.x - MARGIN;
      for (var level:int = LEVELCOUNT - 1; level >= 0; level--)
      {
        const levelButton:Sprite = Sprite(levelButtons[level]);
        levelX -= buttonWidth(levelButton);
        levelButton.x = levelX;
        levelButton.y = rowY;
        levelX -= DIGITGAP;
      }
      filterField.x = MARGIN;
      filterField.y = rowY;
      filterField.width = Math.max(0, levelX - 2 * MARGIN);
      filterField.height = ROWHEIGHT;
      logField.x = MARGIN;
      logField.y = MARGIN;
      logField.width = Math.max(0, areaWidth - 2 * MARGIN);
      logField.height = Math.max(0, rowY - 2 * MARGIN);
      if (following)
      {
        scrollToEnd();
      }
    }
    /**
     * Displays or hides every element that belongs to the log itself. The button of this
     * tracer is left out of this on purpose: that one is always visible.
     */
    private function showOpenedElements():void
    {
      backgroundShape.visible = opened;
      logField.visible = opened;
      filterField.visible = opened;
      pauseButton.visible = opened;
      clearButton.visible = opened;
      for (var level:int = 0; level < levelButtons.length; level++)
      {
        Sprite(levelButtons[level]).visible = opened;
      }
    }
    /**
     * Breaks one message into the numbered lines it is displayed as. A message carrying
     * attributes gets one line per attribute. Both delimiters have to stand in that message
     * for this: a message carrying an attribute delimiter only, an && of a logged condition
     * for example, has no attributes to be broken into and stays one single line.
     * @param message the message to be broken into lines
     */
    private function collectLines(message:String):Array
    {
      const lines:Array = new Array();
      const parts:Array = message.split(NETWORKATTRDELIM);
      if (message.indexOf(ATTRDELIM) == -1 || parts.length < 2)
      {
        lines.push(++lineNumber + LINENUMDELIM + message);
        return lines;
      }
      lines.push(++lineNumber + LINENUMDELIM + parts[0] + NETWORKATTRDELIM);
      const attributes:Array = String(parts[1]).split(ATTRDELIM);
      for (var i:int = 0; i < attributes.length; i++)
      {
        lines.push(++lineNumber + LINENUMDELIM + ATTRMARGIN + trim(String(attributes[i])));
      }
      return lines;
    }
    /**
     * Returns the given text without the whitespace standing at the two ends of it. The utils
     * of the application do this as well, but that object logs and this one may not.
     * @param text the text to be trimmed
     */
    private function trim(text:String):String
    {
      return text.replace(/^\s+|\s+$/g, "");
    }
    /**
     * Adds the given lines to the ones kept already and displays them. Only the newest lines
     * are kept: the oldest ones are dropped in one chunk instead of one by one, because every
     * such drop costs the whole text to be written again.
     * @param newLines the lines to be added
     */
    private function appendLines(newLines:Array):void
    {
      for (var i:int = 0; i < newLines.length; i++)
      {
        traceLines.push(newLines[i]);
      }
      if (traceLines.length > MAXLINES || filterRegExp != null)
      {
        if (traceLines.length > MAXLINES)
        {
          traceLines.splice(0, traceLines.length - MAXLINES + TRIMCHUNK);
        }
        refreshText();
        return;
      }
      logField.appendText(newLines.join("\n") + "\n");
      if (following)
      {
        scrollToEnd();
      }
    }
    /**
     * Writes every line to be displayed again, the filter of this tracer applied to them.
     */
    private function refreshText():void
    {
      const lines:Array = new Array();
      for (var i:int = 0; i < traceLines.length; i++)
      {
        if (filterRegExp == null || filterRegExp.test(traceLines[i]))
        {
          lines.push(traceLines[i]);
        }
      }
      logField.text = lines.length == 0 ? "" : lines.join("\n") + "\n";
      if (following)
      {
        scrollToEnd();
      }
    }
    /**
     * Builds the pattern the displayed lines are filtered by from the text of the filter
     * field. A text that is not a valid pattern is looked for as it is: this tracer cannot
     * report such an error to itself, and a half typed pattern may not break the filtering.
     */
    private function buildFilterRegExp():void
    {
      const filter:String = filterField.text;
      if (filter == "")
      {
        filterRegExp = null;
        return;
      }
      try
      {
        filterRegExp = new RegExp(filter);
      }
      catch (e:Error)
      {
        filterRegExp = new RegExp(filter.replace(/[\\\^\$\.\|\?\*\+\(\)\[\]\{\}]/g, "\\$&"));
      }
    }
    /**
     * Scrolls the log to its newest line.
     */
    private function scrollToEnd():void
    {
      logField.scrollV = logField.maxScrollV;
    }
    /**
     * Decides whether the log has to follow its own end from now on. A log standing at that
     * end follows it, a log that has been scrolled away from it stays where it is: the newest
     * line may not be jumped to under the hands of the one reading an older one.
     */
    private function refreshFollowing():void
    {
      following = logField.scrollV >= logField.maxScrollV;
    }
    /**
     * Returns the height of one displayed line, needed to turn a dragged distance into
     * scrolled lines.
     */
    private function lineHeight():Number
    {
      if (logField.numLines > 0)
      {
        return logField.getLineMetrics(0).height;
      }
      return FONTSIZE + MARGIN;
    }
    /**
     * Handles the added to stage event: lays every element out inside the dimensions of that
     * stage and starts listening to the resizing of it.
     * @param e the added to stage event
     */
    private function addedToStage(e:Event):void
    {
      layoutElements();
      if (stage != null)
      {
        stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
      }
    }
    /**
     * Handles the removed from stage event: stops listening to that stage.
     * @param e the removed from stage event
     */
    private function removedFromStage(e:Event):void
    {
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, logMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, logMouseUp);
      }
      dragging = false;
    }
    /**
     * Handles the resizing of the stage: lays every element out inside the new dimensions.
     * @param e the resize event
     */
    private function stageResized(e:Event):void
    {
      layoutElements();
    }
    /**
     * Handles the mouse wheel over the log: scrolls it.
     * @param e the mouse wheel event
     */
    private function logMouseWheel(e:MouseEvent):void
    {
      logField.scrollV -= e.delta;
      refreshFollowing();
    }
    /**
     * Handles the mouse down over the log: starts the dragging of it.
     * @param e the mouse down event
     */
    private function logMouseDown(e:MouseEvent):void
    {
      dragging = true;
      dragStartY = e.stageY;
      dragStartScrollV = logField.scrollV;
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, logMouseMove, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, logMouseUp, false, 0, true);
      }
    }
    /**
     * Handles the dragging of the log: scrolls it with the dragged distance.
     * @param e the mouse move event
     */
    private function logMouseMove(e:MouseEvent):void
    {
      if (dragging)
      {
        logField.scrollV = dragStartScrollV - Math.round((e.stageY - dragStartY) / lineHeight());
        refreshFollowing();
      }
    }
    /**
     * Handles the end of the dragging of the log.
     * @param e the mouse up event
     */
    private function logMouseUp(e:MouseEvent):void
    {
      dragging = false;
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, logMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, logMouseUp);
      }
    }
    /**
     * Handles the change of the filter field: filters the displayed lines.
     * @param e the change event
     */
    private function filterChanged(e:Event):void
    {
      buildFilterRegExp();
      refreshText();
    }
    /**
     * Handles the click on one of the level buttons: sets the level of the tracing of the
     * application to the clicked one. The buttons are drawn again by the change of that level,
     * whether it is this click or the application itself that has changed it.
     * @param e the click event
     */
    private function levelClicked(e:MouseEvent):void
    {
      const level:int = levelButtons.indexOf(e.currentTarget);
      if (level >= 0)
      {
        application.setTraceLevel(level);
      }
    }
    /**
     * Handles the change of the level of the tracing: marks the button of the new level.
     * @param e the trace level changed event
     */
    private function traceLevelChanged(e:Event):void
    {
      refreshLevelButtons();
    }
    /**
     * Handles the click on the pause button: turns the logging off and on.
     * @param e the click event
     */
    private function pauseClicked(e:MouseEvent):void
    {
      setPaused(!paused);
    }
    /**
     * Handles the click on the clear button: drops every message collected so far.
     * @param e the click event
     */
    private function clearClicked(e:MouseEvent):void
    {
      clear();
    }
    /**
     * Handles the click on the button of this tracer: displays and hides the log.
     * @param e the click event
     */
    private function tracerClicked(e:MouseEvent):void
    {
      if (opened)
      {
        close();
      }
      else
      {
        open();
      }
    }
    /**
     * Handles the roll over on a button: lights that button up.
     * @param e the roll over event
     */
    private function buttonRollOver(e:MouseEvent):void
    {
      paintButton(Sprite(e.currentTarget), BUTTONCOLOROVER);
    }
    /**
     * Handles the roll out on a button: takes the light of that button back.
     * @param e the roll out event
     */
    private function buttonRollOut(e:MouseEvent):void
    {
      paintButton(Sprite(e.currentTarget), colorOfButton(Sprite(e.currentTarget)));
    }
    /**
     * Removes every listener registered on one button of this tracer.
     * @param button the button the listeners belong to
     * @param clickListener the listener the click of the button was reported to
     */
    private function removeButtonListeners(button:Sprite, clickListener:Function):void
    {
      button.removeEventListener(MouseEvent.CLICK, clickListener);
      button.removeEventListener(MouseEvent.ROLL_OVER, buttonRollOver);
      button.removeEventListener(MouseEvent.ROLL_OUT, buttonRollOut);
    }
    /**
     * Frees up this tracer. There is no super destroy to be called here: this class extends
     * flash.display.Sprite, and every child of it is a flash primitive that is removed and
     * released below instead of being destroyed.
     */
    public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      application.getBaseEventDispatcher().removeEventListener(
        EnumEvents.EVENT_TRACE_LEVEL_CHANGED(), traceLevelChanged);
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
      removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
      logField.removeEventListener(MouseEvent.MOUSE_DOWN, logMouseDown);
      logField.removeEventListener(MouseEvent.MOUSE_WHEEL, logMouseWheel);
      filterField.removeEventListener(Event.CHANGE, filterChanged);
      for (var level:int = 0; level < levelButtons.length; level++)
      {
        removeButtonListeners(Sprite(levelButtons[level]), levelClicked);
      }
      removeButtonListeners(pauseButton, pauseClicked);
      removeButtonListeners(clearButton, clearClicked);
      removeButtonListeners(tracerButton, tracerClicked);
      if (stage != null)
      {
        stage.removeEventListener(Event.RESIZE, stageResized);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, logMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, logMouseUp);
      }
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      traceLines.splice(0, traceLines.length);
      for (level = 0; level < levelButtons.length; level++)
      {
        Sprite(levelButtons[level]).graphics.clear();
      }
      levelButtons.splice(0, levelButtons.length);
      backgroundShape.graphics.clear();
      pauseButton.graphics.clear();
      clearButton.graphics.clear();
      tracerButton.graphics.clear();
      logField.text = "";
      filterField.text = "";
      while (numChildren > 0)
      {
        removeChildAt(0);
      }
      // 3: calling the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      application = null;
      backgroundShape = null;
      logField = null;
      filterField = null;
      levelButtons = null;
      pauseButton = null;
      clearButton = null;
      tracerButton = null;
      traceLines = null;
      filterRegExp = null;
      lineNumber = 0;
      dragStartScrollV = 0;
      dragStartY = 0;
      dragging = false;
      following = false;
      opened = false;
      paused = false;
    }
  }
}
