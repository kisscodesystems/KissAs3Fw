package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import flash.events.Event;
  // import flash.events.MouseEvent;
  import flash.system.System;
  import flash.text.AntiAliasType;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  public class BaseTextField extends TextField
  {
    protected var application:Application = null;
    private var cx:int = 0;
    private var cy:int = 0;
    private var dw:int = 0;
    private var dh:int = 0;
    private var eventCoordinatesChanged:Event = null;
    private var eventDimensionsChanged:Event = null;
    private var baseEventDispatcher:BaseEventDispatcher = null;
    private var type:String = "";
    private var label:String = "";
    private var constructedText:String = "";
    private var isHtml:Boolean = false;
    // whether the text keys standing in the label are looked up at all: a text of the
    // outside world can carry brackets of its own, the array literals of a source code
    // for example, and those are no text keys, so the caller displaying such a text
    // switches this off and the label is displayed exactly the way it has arrived
    private var textKeysEnabled:Boolean = true;
    private var minChars:int = 0;
    public var mouseDownForScrollingEnabled:Boolean = true;
    /**
    * Constructs the base textfield: stores the application, creates the event objects, resets the values and registers the stage listeners.
    * @param applicationRef the application reference this textfield belongs to
    */
    public function BaseTextField(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " BaseTextField> called.", 1);
      application.trace("<" + this + " BaseTextField> applicationRef: " + applicationRef, 0);
      baseEventDispatcher = new BaseEventDispatcher();
      eventCoordinatesChanged = new Event(EnumEvents.EVENT_COORDINATES_CHANGED());
      eventDimensionsChanged = new Event(EnumEvents.EVENT_DIMENSIONS_CHANGED());
      allReset();
      addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
      antiAliasType = AntiAliasType.ADVANCED;
      setType(EnumTextTypes.TEXT_TYPE_BRIGHT());
      application.trace("<" + this + " BaseTextField> constructed.", 1);
    }
    /**
     * Returns the base event dispatcher of this textfield.
     */
    public function getBaseEventDispatcher():BaseEventDispatcher
    {
      return baseEventDispatcher;
    }
    /**
     * Sets the text type, subscribes to the matching text format change event and reapplies the format.
     * @param newType the new text type to set
     */
    public function setType(newType:String):void
    {
      application.trace("<" + this + " BaseTextField setType> called.", 1);
      application.trace("<" + this + " BaseTextField setType> newType: " + newType, 0);
      if (newType == EnumTextTypes.TEXT_TYPE_MID())
      {
        if (type != EnumTextTypes.TEXT_TYPE_MID())
        {
          application.trace("<" + this + " BaseTextField setType> newTextType is set.", 0);
          type = EnumTextTypes.TEXT_TYPE_MID();
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
          textFormatApply();
        }
      }
      else if (newType == EnumTextTypes.TEXT_TYPE_DARK())
      {
        if (type != EnumTextTypes.TEXT_TYPE_DARK())
        {
          application.trace("<" + this + " BaseTextField setType> newTextType is set.", 0);
          type = EnumTextTypes.TEXT_TYPE_DARK();
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
          textFormatApply();
        }
      }
      else
      {
        if (type != EnumTextTypes.TEXT_TYPE_BRIGHT())
        {
          application.trace("<" + this + " BaseTextField setType> newTextType is set.", 0);
          type = EnumTextTypes.TEXT_TYPE_BRIGHT();
          application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
          application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
          textFormatApply();
        }
      }
    }
    /**
     * Sets the x coordinate of the textfield and notifies about the coordinate change.
     * @param newcx the new x coordinate to set
     */
    public function setCx(newcx:int):void
    {
      application.trace("<" + this + " BaseTextField setCx> called.", 1);
      application.trace("<" + this + " BaseTextField setCx> newcx: " + newcx, 0);
      if (cx != newcx)
      {
        application.trace("<" + this + " BaseTextField setCx> conditions OK.", 1);
        cx = newcx;
        x = cx;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the y coordinate of the textfield and notifies about the coordinate change.
     * @param newcy the new y coordinate to set
     */
    public function setCy(newcy:int):void
    {
      application.trace("<" + this + " BaseTextField setCy> called.", 1);
      application.trace("<" + this + " BaseTextField setCy> newcy: " + newcy, 0);
      if (cy != newcy)
      {
        application.trace("<" + this + " BaseTextField setCy> conditions OK.", 1);
        cy = newcy;
        y = cy;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the x and y coordinates of the textfield and notifies about the coordinate change.
     * @param newcx the new x coordinate to set
     * @param newcy the new y coordinate to set
     */
    public function setCxy(newcx:int, newcy:int):void
    {
      application.trace("<" + this + " BaseTextField setCxy> called.", 1);
      application.trace("<" + this + " BaseTextField setCxy> newcx: " + newcx, 0);
      application.trace("<" + this + " BaseTextField setCxy> newcy: " + newcy, 0);
      if (cx != newcx || cy != newcy)
      {
        application.trace("<" + this + " BaseTextField setCxy> conditions OK.", 1);
        cx = newcx;
        cy = newcy;
        x = cx;
        y = cy;
        doCoordinatesChanged();
        dispatchEventCoordinatesChanged();
      }
    }
    /**
     * Sets the width of the textfield and notifies about the dimension change.
     * @param newdw the new width to set
     */
    public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseTextField setDw> called.", 1);
      application.trace("<" + this + " BaseTextField setDw> newdw: " + newdw, 0);
      if (dw != Math.max(newdw, application.getComponentsConfig().getBaseMinw()))
      {
        application.trace("<" + this + " BaseTextField setDw> conditions OK.", 1);
        dw = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
    }
    /**
     * Sets the height of the textfield and notifies about the dimension change.
     * @param newdh the new height to set
     */
    public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseTextField setDh> called.", 1);
      application.trace("<" + this + " BaseTextField setDh> newdh: " + newdh, 0);
      if (dh != Math.max(newdh, application.getComponentsConfig().getBaseMinh()))
      {
        application.trace("<" + this + " BaseTextField setDh> conditions OK.", 1);
        dh = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
    }
    /**
     * Sets the width and height of the textfield and notifies about the dimension change.
     * @param newdw the new width to set
     * @param newdh the new height to set
     * @param toSetDimensions whether the actual width and height should also be set
     */
    public function setDwh(newdw:int, newdh:int, toSetDimensions:Boolean = false):void
    {
      application.trace("<" + this + " BaseTextField setDwh> called.", 1);
      application.trace("<" + this + " BaseTextField setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseTextField setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " BaseTextField setDwh> toSetDimensions: " + toSetDimensions, 0);
      if (dw != Math.max(newdw, application.getComponentsConfig().getBaseMinw())
          || dh != Math.max(newdh, application.getComponentsConfig().getBaseMinh()))
      {
        application.trace("<" + this + " BaseTextField setDwh> conditions OK.", 1);
        dw = Math.max(newdw, application.getComponentsConfig().getBaseMinw());
        dh = Math.max(newdh, application.getComponentsConfig().getBaseMinh());
        if (toSetDimensions)
        {
          width = dw;
          height = dh;
        }
        doDimensionsChanged();
        dispatchEventDimensionsChanged();
      }
    }
    /**
     * Reads back the current x and y into the stored coordinates and reapplies them.
     */
    public function updateCxy():void
    {
      application.trace("<" + this + " BaseTextField updateCxy> called.", 1);
      cx = int(x);
      cy = int(y);
      x = cx;
      y = cy;
    }
    /**
     * Returns the x coordinate optionally extended with the width, the app margin and the app padding.
     * @param wNeeded whether the width should be added to the coordinate
     * @param mNeeded whether the app margin should be added to the coordinate
     * @param pNeeded whether the app padding should be added to the coordinate
     */
    public function getCx(wNeeded:Boolean = false, mNeeded:Boolean = false, pNeeded:Boolean = false):int
    {
      application.trace("<" + this + " BaseTextField getCx> called.", 1);
      application.trace("<" + this + " BaseTextField getCx> wNeeded: " + wNeeded, 0);
      application.trace("<" + this + " BaseTextField getCx> mNeeded: " + mNeeded, 0);
      application.trace("<" + this + " BaseTextField getCx> pNeeded: " + pNeeded, 0);
      var val:int = cx;
      if (wNeeded)
      {
        val += dw;
      }
      if (mNeeded)
      {
        val += application.getDynamicsConfig().getAppMargin();
      }
      if (pNeeded)
      {
        val += application.getDynamicsConfig().getAppPadding();
      }
      application.trace("<" + this + " BaseTextField getCx> cx (" + wNeeded + " " + mNeeded + " " + pNeeded + "): " + val, 0);
      return val;
    }
    /**
     * Returns the y coordinate optionally extended with the height, the app margin and the app padding.
     * @param hNeeded whether the height should be added to the coordinate
     * @param mNeeded whether the app margin should be added to the coordinate
     * @param pNeeded whether the app padding should be added to the coordinate
     */
    public function getCy(hNeeded:Boolean = false, mNeeded:Boolean = false, pNeeded:Boolean = false):int
    {
      application.trace("<" + this + " BaseTextField getCy> called.", 1);
      application.trace("<" + this + " BaseTextField getCy> hNeeded: " + hNeeded, 0);
      application.trace("<" + this + " BaseTextField getCy> mNeeded: " + mNeeded, 0);
      application.trace("<" + this + " BaseTextField getCy> pNeeded: " + pNeeded, 0);
      var val:int = cy;
      if (hNeeded)
      {
        val += dh;
      }
      if (mNeeded)
      {
        val += application.getDynamicsConfig().getAppMargin();
      }
      if (pNeeded)
      {
        val += application.getDynamicsConfig().getAppPadding();
      }
      application.trace("<" + this + " BaseTextField getCy> cy (" + hNeeded + " " + mNeeded + " " + pNeeded + "): " + val, 0);
      return val;
    }
    /**
     * Returns the width of the textfield.
     */
    public function getDw():int
    {
      return dw;
    }
    /**
     * Returns the height of the textfield.
     */
    public function getDh():int
    {
      return dh;
    }
    /**
     * Turns auto sizing off and refreshes the dimensions and the text format.
     */
    public function setAutoSizeNone():void
    {
      application.trace("<" + this + " BaseTextField setAutoSizeNone> called.", 1);
      if (autoSize != TextFieldAutoSize.NONE)
      {
        autoSize = TextFieldAutoSize.NONE;
        setDwh(width, height, true);
        textFormatApply();
      }
    }
    /**
     * Sets left auto sizing and refreshes the dimensions and the text format.
     */
    public function setAutoSizeLeft():void
    {
      application.trace("<" + this + " BaseTextField setAutoSizeLeft> called.", 1);
      if (autoSize != TextFieldAutoSize.LEFT)
      {
        autoSize = TextFieldAutoSize.LEFT;
        setDwh(width, height);
        textFormatApply();
      }
    }
    /**
     * Sets right auto sizing and refreshes the dimensions and the text format.
     */
    public function setAutoSizeRight():void
    {
      application.trace("<" + this + " BaseTextField setAutoSizeRight> called.", 1);
      if (autoSize != TextFieldAutoSize.RIGHT)
      {
        autoSize = TextFieldAutoSize.RIGHT;
        setDwh(width, height);
        textFormatApply();
      }
    }
    /**
     * Sets center auto sizing and refreshes the dimensions and the text format.
     */
    public function setAutoSizeCenter():void
    {
      application.trace("<" + this + " BaseTextField setAutoSizeCenter> called.", 1);
      if (autoSize != TextFieldAutoSize.CENTER)
      {
        autoSize = TextFieldAutoSize.CENTER;
        setDwh(width, height);
        textFormatApply();
      }
    }
    /**
     * Returns whether the trimmed text is at least the required minimum length.
     */
    public function getTextIsAtLeastLength():Boolean
    {
      application.trace("<" + this + " BaseTextField getTextIsAtLeastLength> called.", 1);
      const isOk:Boolean = application.getUtils().trim(text).length >= minChars;
      application.trace("<" + this + " BaseTextField getTextIsAtLeastLength> isOk: " + isOk, 0);
      return isOk;
    }
    /**
     * Sets whether the text is displayed as a password.
     * @param b whether the text should be displayed as a password
     */
    public function setDisplayAsPassword(b:Boolean):void
    {
      application.trace("<" + this + " BaseTextField setDisplayAsPassword> called.", 1);
      application.trace("<" + this + " BaseTextField setDisplayAsPassword> b: " + b, 0);
      displayAsPassword = b;
    }
    /**
     * Returns whether the textfield renders its content as html.
     */
    public function getHtml():Boolean
    {
      return isHtml;
    }
    /**
     * Sets whether the textfield renders its content as html and redisplays the text.
     * @param b whether the content should be rendered as html
     */
    public function setHtml(b:Boolean):void
    {
      application.trace("<" + this + " BaseTextField setHtml> called.", 1);
      application.trace("<" + this + " BaseTextField setHtml> b: " + b, 0);
      if (isHtml != b)
      {
        isHtml = b;
        displayText();
      }
    }
    /**
     * Returns whether the text keys standing in the label are looked up.
     */
    public function getTextKeysEnabled():Boolean
    {
      return textKeysEnabled;
    }
    /**
     * Switches the looking up of the text keys of the label on and off and displays the
     * text again: a textfield that is switched off draws the brackets of its label as
     * they are, and it follows the language of the application no more either, because
     * there is no key of it to be looked up in that language.
     * @param b whether the text keys have to be looked up
     */
    public function setTextKeysEnabled(b:Boolean):void
    {
      application.trace("<" + this + " BaseTextField setTextKeysEnabled> called.", 1);
      application.trace("<" + this + " BaseTextField setTextKeysEnabled> b: " + b, 0);
      if (textKeysEnabled != b)
      {
        textKeysEnabled = b;
        constructText();
        displayText();
        followLangChanged();
      }
    }
    /**
     * Returns whether word wrapping is enabled.
     */
    public function getWordWrap():Boolean
    {
      return wordWrap;
    }
    /**
     * Sets whether word wrapping is enabled and redisplays the text.
     * @param b whether word wrapping should be enabled
     */
    public function setWordWrap(b:Boolean):void
    {
      application.trace("<" + this + " BaseTextField setWordWrap> called.", 1);
      application.trace("<" + this + " BaseTextField setWordWrap> b: " + b, 0);
      if (wordWrap != b)
      {
        wordWrap = b;
        displayText();
      }
    }
    /**
     * Sets the minimum number of characters required.
     * @param i the new minimum number of characters
     */
    public function setMinChars(i:int):void
    {
      application.trace("<" + this + " BaseTextField setMinChars> called.", 1);
      application.trace("<" + this + " BaseTextField setMinChars> i: " + i, 0);
      if (minChars != i)
      {
        minChars = i;
      }
    }
    /**
     * Sets the maximum number of characters allowed.
     * @param i the new maximum number of characters
     */
    public function setMaxChars(i:int):void
    {
      application.trace("<" + this + " BaseTextField setMaxChars> called.", 1);
      application.trace("<" + this + " BaseTextField setMaxChars> i: " + i, 0);
      if (maxChars != i)
      {
        maxChars = i;
      }
    }
    /**
     * Sets the set of characters the textfield accepts.
     * @param s the restrict string to apply
     */
    public function setRestrict(s:String):void
    {
      application.trace("<" + this + " BaseTextField setRestrict> called.", 1);
      application.trace("<" + this + " BaseTextField setRestrict> s: " + s, 0);
      if (restrict != s)
      {
        restrict = s;
      }
    }
    /**
     * Returns the label of the textfield.
     */
    public function getLabel():String
    {
      return label;
    }
    /**
     * Returns the plain text of the textfield.
     */
    public function getText():String
    {
      return text;
    }
    /**
     * Returns the html text of the textfield.
     */
    public function getHtmlText():String
    {
      return htmlText;
    }
    /**
     * Converts the current text to upper case.
     */
    public function setTextToUpperCase():void
    {
      application.trace("<" + this + " BaseTextField setTextToUpperCase> called.", 1);
      text = text.toLocaleUpperCase();
    }
    /**
     * Converts the current text to lower case.
     */
    public function setTextToLowerCase():void
    {
      application.trace("<" + this + " BaseTextField setTextToLowerCase> called.", 1);
      text = text.toLocaleLowerCase();
    }
    /**
     * Returns the text type of the textfield.
     */
    public function getType():String
    {
      return type;
    }
    /**
     * Sets the label, constructs and displays the text and manages the language change subscription.
     * @param newLabel the new label to set
     */
    public function setLabel(newLabel:String):void
    {
      application.trace("<" + this + " BaseTextField setLabel> called.", 1);
      application.trace("<" + this + " BaseTextField setLabel> newLabel: " + newLabel, 0);
      if (label != newLabel || newLabel == "")
      {
        application.trace("<" + this + " BaseTextField setLabel> label will be changed.", 0);
        label = newLabel;
        constructText();
        displayText();
        followLangChanged();
      }
    }
    /**
     * Handles the added to stage event by recalculating the content dimensions.
     * @param e the added to stage event
     */
    protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BaseTextField addedToStage> called.", 1);
      application.trace("<" + this + " BaseTextField addedToStage> e: " + e, 0);
      application.callContentDimensionsRecalculation(this);
      // addEventListener ( MouseEvent . MOUSE_DOWN , mouseDownForScrolling , false , 0, true) ;
    }
    /**
     * Handles the removed from stage event by recalculating the content dimensions.
     * @param e the removed from stage event
     */
    protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseTextField removedFromStage> called.", 1);
      application.trace("<" + this + " BaseTextField removedFromStage> e: " + e, 0);
      application.callContentDimensionsRecalculation(this);
      // removeEventListener ( MouseEvent . MOUSE_DOWN , mouseDownForScrolling ) ;
    }
    /**
     * Dispatches the dimensions changed event through the base event dispatcher.
     */
    protected function dispatchEventDimensionsChanged():void
    {
      application.trace("<" + this + " BaseTextField dispatchEventDimensionsChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventDimensionsChanged);
      }
    }
    /**
     * Dispatches the coordinates changed event through the base event dispatcher.
     */
    protected function dispatchEventCoordinatesChanged():void
    {
      application.trace("<" + this + " BaseTextField dispatchEventCoordinatesChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventCoordinatesChanged);
      }
    }
    /**
     * Recalculates the content dimensions after a coordinate change.
     */
    protected function doCoordinatesChanged():void
    {
      application.trace("<" + this + " BaseTextField doCoordinatesChanged> called.", 1);
      application.callContentDimensionsRecalculation(this);
    }
    /**
     * Recalculates the content dimensions after a dimension change.
     */
    protected function doDimensionsChanged():void
    {
      application.trace("<" + this + " BaseTextField doDimensionsChanged> called.", 1);
      application.callContentDimensionsRecalculation(this);
    }
    /**
     * Applies the text format and drop shadow that belong to the current type and refreshes the dimensions.
     */
    protected function textFormatApply():void
    {
      application.trace("<" + this + " BaseTextField textFormatApply> called.", 1);
      clearDropShadowFilter();
      if (type == EnumTextTypes.TEXT_TYPE_MID())
      {
        defaultTextFormat = application.getDynamicsConfig().getTextFormatMid();
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorMid());
      }
      else if (type == EnumTextTypes.TEXT_TYPE_DARK())
      {
        defaultTextFormat = application.getDynamicsConfig().getTextFormatDark();
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorDark());
      }
      else
      {
        defaultTextFormat = application.getDynamicsConfig().getTextFormatBright();
        setDropShadowFilter(application.getDynamicsConfig().getAppFontColorBright());
      }
      embedFonts = application.getFontManager().getFontIsEmbedded(defaultTextFormat.font);
      if (isHtml)
      {
        htmlText = constructedText;
      }
      else
      {
        setTextFormat(defaultTextFormat);
      }
      if (autoSize == TextFieldAutoSize.NONE && !multiline)
      {
        height = application.getDynamicsConfig().getTextFieldHeight(type);
      }
      setDwh(width, height, true);
      application.trace("<" + this + " BaseTextField textFormatApply> textFormat is applied.", 1);
    }
    /**
     * Reapplies the text format when the bright text format changes.
     * @param e the text format changed event
     */
    private function textFormatBrightChanged(e:Event):void
    {
      application.trace("<" + this + " BaseTextField textFormatBrightChanged> called.", 1);
      application.trace("<" + this + " BaseTextField textFormatBrightChanged> e: " + e, 0);
      textFormatApply();
    }
    /**
     * Reapplies the text format when the mid text format changes.
     * @param e the text format changed event
     */
    private function textFormatMidChanged(e:Event):void
    {
      application.trace("<" + this + " BaseTextField textFormatMidChanged> called.", 1);
      application.trace("<" + this + " BaseTextField textFormatMidChanged> e: " + e, 0);
      textFormatApply();
    }
    /**
     * Reapplies the text format when the dark text format changes.
     * @param e the text format changed event
     */
    private function textFormatDarkChanged(e:Event):void
    {
      application.trace("<" + this + " BaseTextField textFormatDarkChanged> called.", 1);
      application.trace("<" + this + " BaseTextField textFormatDarkChanged> e: " + e, 0);
      textFormatApply();
    }
    /**
     * Displays the constructed text as html or plain text and reapplies the format.
     */
    private function displayText():void
    {
      application.trace("<" + this + " BaseTextField displayText> called.", 1);
      if (isHtml)
      {
        htmlText = constructedText == null ? "" : constructedText;
      }
      else
      {
        text = constructedText == null ? "" : constructedText;
      }
      textFormatApply();
    }
    /**
     * Removes any drop shadow filter from the textfield.
     */
    private function clearDropShadowFilter():void
    {
      application.trace("<" + this + " BaseTextField clearDropShadowFilter> called.", 1);
      filters = null;
    }
    /**
     * Applies a bright or dark drop shadow filter depending on the given color.
     * @param color the color the drop shadow is chosen for
     */
    private function setDropShadowFilter(color:Number):void
    {
      application.trace("<" + this + " BaseTextField setDropShadowFilter> called.", 1);
      application.trace("<" + this + " BaseTextField setDropShadowFilter> color: " + color, 0);
      if (application.getUtils().brightShadowToApply(color.toString(16)))
      {
        filters = application.getComponentsConfig().getTextDropShadowArrayBright();
      }
      else
      {
        filters = application.getComponentsConfig().getTextDropShadowArrayDark();
      }
    }
    /**
     * Returns whether the given string contains a text key delimited by brackets.
     * @param string the string to check for a text key
     */
    private function containsTextKey(string:String):Boolean
    {
      application.trace("<" + this + " BaseTextField containsTextKey> called.", 1);
      application.trace("<" + this + " BaseTextField containsTextKey> string: " + string, 0);
      if (string != null)
      {
        const index1:int = string.indexOf("[");
        const index2:int = string.indexOf("]");
        const contains:Boolean = index1 != -1 && index2 != -1 && index1 < index2;
        application.trace("<" + this + " BaseTextField containsTextKey> contains: " + contains, 0);
        return contains;
      }
      else
      {
        application.trace("<" + this + " BaseTextField containsTextKey> does not contain.", 0);
        return false;
      }
    }
    /**
     * Returns whether the label holds a text key to be looked up: a textfield whose
     * looking up is switched off holds none at all.
     */
    private function hasTextKey():Boolean
    {
      return textKeysEnabled && containsTextKey(label);
    }
    /**
     * Registers the listener of the language of the application while there is a text key
     * to be looked up, and unregisters it when there is none: a label of no key at all is
     * the very same text in every language.
     */
    private function followLangChanged():void
    {
      application.trace("<" + this + " BaseTextField followLangChanged> called.", 1);
      if (hasTextKey())
      {
        application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LANG_CHANGED(), langCodeChanged);
      }
      else
      {
        application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LANG_CHANGED(), langCodeChanged);
      }
    }
    /**
     * Builds the displayed text from the label by resolving every embedded text key.
     */
    private function constructText():void
    {
      application.trace("<" + this + " BaseTextField constructText> called.", 1);
      constructedText = label;
      application.trace("<" + this + " BaseTextField constructText> base: " + constructedText, 0);
      if (hasTextKey())
      {
        application.trace("<" + this + " BaseTextField constructText> contains textKey.", 0);
        var textKeyBeginIndex:int = 0;
        var textKeyEndIndex:int = 0;
        var aTextKey:String = "";
        var aTextText:String = "";
        var iteration:int = 0;
        const maxIterations:int = application.getComponentsConfig().getTextFieldMaxKeys();
        while (containsTextKey(constructedText) && iteration < maxIterations)
        {
          application.trace("<" + this + " BaseTextField constructText> iteration: " + iteration, 0);
          textKeyBeginIndex = constructedText.indexOf("[");
          application.trace("<" + this + " BaseTextField constructText> " + iteration + " textKeyBeginIndex: " + textKeyBeginIndex, 0);
          textKeyEndIndex = constructedText.indexOf("]", textKeyBeginIndex) + 1;
          application.trace("<" + this + " BaseTextField constructText> " + iteration + " textKeyEndIndex: " + textKeyEndIndex, 0);
          aTextKey = constructedText.substring(textKeyBeginIndex, textKeyEndIndex);
          application.trace("<" + this + " BaseTextField constructText> " + iteration + " aTextKey: " + aTextKey, 0);
          aTextText = application.getLabelManager().getLabel(aTextKey);
          application.trace("<" + this + " BaseTextField constructText> " + iteration + " aTextText: " + aTextText, 0);
          constructedText = constructedText.replace(aTextKey, aTextText);
          application.trace("<" + this + " BaseTextField constructText> " + iteration + " constructedText now is: " + constructedText, 0);
          iteration++;
        }
        textKeyBeginIndex = 0;
        textKeyEndIndex = 0;
        aTextKey = null;
        aTextText = null;
      }
      application.trace("<" + this + " BaseTextField constructText> constructedText: " + constructedText, 0);
    }
    /**
     * Rebuilds and redisplays the text when the language changes.
     * @param e the language changed event
     */
    private function langCodeChanged(e:Event):void
    {
      application.trace("<" + this + " BaseTextField langCodeChanged> called.", 1);
      application.trace("<" + this + " BaseTextField langCodeChanged> e: " + e, 0);
      constructText();
      displayText();
    }
    /**
     * Forces the garbage collector to run several times.
     */
    private function systemGc():void
    {
      application.trace("<" + this + " BaseTextField systemGc> called.", 1);
      for (var i:int = 0; i < 10; i++)
      {
        System.gc();
      }
    }
    /**
     * Resets the coordinates and dimensions to zero.
     */
    private function allReset():void
    {
      application.trace("<" + this + " BaseTextField allReset> called.", 1);
      cx = 0;
      cy = 0;
      dw = 0;
      dh = 0;
      x = cx;
      y = cy;
      width = dw;
      height = dh;
    }
    /**
     * Unregisters the listeners, frees every resource and resets every reference of the textfield.
     */
    public function destroy():void
    {
      application.trace("<" + this + " BaseTextField destroy> called.", 1);
      application.trace("<" + this + " BaseTextField destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
      removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LANG_CHANGED(), langCodeChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), textFormatMidChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_BRIGHT_CHANGED(), textFormatBrightChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_DARK_CHANGED(), textFormatDarkChanged);
      application.trace("<" + this + " BaseTextField destroy> remove every child object if there are any (necessary only in BaseTextField).", 0);
      application.trace("<" + this + " BaseTextField destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventCoordinatesChanged.stopImmediatePropagation();
      eventDimensionsChanged.stopImmediatePropagation();
      baseEventDispatcher.destroy();
      application.trace("<" + this + " BaseTextField destroy> calling the super destroy (necessary only not in BaseTextField) and clearing everything.", 0);
      systemGc();
      allReset();
      label = null;
      constructedText = null;
      isHtml = false;
      textKeysEnabled = true;
      minChars = 0;
      filters = null;
      text = "";
      htmlText = "";
      mouseDownForScrollingEnabled = false;
      type = null;
      eventCoordinatesChanged = null;
      eventDimensionsChanged = null;
      baseEventDispatcher = null;
      application = null;
    }
  }
}

