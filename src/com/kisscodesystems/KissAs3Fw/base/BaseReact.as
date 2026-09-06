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
 * BaseReact.
 * A base sprite the users of the application can stick emojis onto, the way the
 * reactions of a chat message work. Every object that has a content of its own and
 * wants to be reacted to extends this class instead of the base sprite.
 *
 * MAIN FEATURES:
 * - the react feature is switched off by default, then this object is a plain base sprite
 * - switched on, a button under the content of this object opens the emoji picker
 * - the picker opens on the most common emojis, then it holds every emoji of the emoji
 *   manager, grouped by its categories, one content is built up only when it is opened
 *   for the first time
 * - the opened picker turns the react row into a search field, and the very first
 *   character typed into it displays the matching emojis in a search content of its own
 * - the picked emojis are displayed in buttons carrying the number of their hits,
 *   in a descending order by that number
 * - one hit stores the name of the user, the type of the emoji and the current date
 * - one user hits one emoji once, hitting it again takes that hit back
 * - the dimensions of this object hold its content, the reactions and the opened
 *   picker as well, so the setDw, setDh and setDwh calls of the extending class set
 *   the dimensions of the content and not the dimensions of the whole object
 * - the react feature is never switched on by a default coming from a config, because
 *   the button and the label objects the react row is built of are objects that could
 *   react themselves: they would build their own react rows endlessly
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBaseShapeTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.ui.ButtonLink;
  import com.kisscodesystems.KissAs3Fw.ui.ContentMultiple;
  import com.kisscodesystems.KissAs3Fw.ui.Icon;
  import com.kisscodesystems.KissAs3Fw.ui.TextInput;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  public class BaseReact extends BaseSprite
  {
    private var reactEnabled:Boolean = false;
    private var contentDw:int = 0;
    private var contentDh:int = 0;
    // one element is an object having a username, an emojiType and a date property
    private var hitsArray:Array = null;
    private var reactSprite:BaseSprite = null;
    private var addButtonLink:ButtonLink = null;
    private var searchTextInput:TextInput = null;
    private var reactionButtonLinksArray:Array = null;
    private var pickerContentMultiple:ContentMultiple = null;
    private var pickerContentNamesArray:Array = null;
    private var pickerIconsArray:Array = null;
    private var pickerFilledIndex:int = -1;
    private var pickerCommonIndex:int = -1;
    private var pickerSearchIndex:int = -1;
    private var pickerIndexBeforeSearch:int = -1;
    // the mouse position the press on an emoji of the picker has been started from: a
    // press that travels farther than the click gap scrolls that picker instead
    private var origMouseX:int = 0;
    private var origMouseY:int = 0;
    private var tooltipSprite:BaseSprite = null;
    private var tooltipShape:BaseShape = null;
    private var tooltipBaseTextField:BaseTextField = null;
    private var eventChanged:Event = null;
    private var eventOpened:Event = null;
    private var eventClosed:Event = null;
    /**
     * Constructs the BaseReact object. The react feature is switched off at this
     * point, so nothing is created but the stores of this object.
     * @param applicationRef the main application reference
     */
    public function BaseReact(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseReact> called.", 1);
      application.trace("<" + this + " BaseReact> applicationRef: " + applicationRef, 0);
      hitsArray = new Array();
      reactionButtonLinksArray = new Array();
      pickerContentNamesArray = new Array();
      pickerIconsArray = new Array();
      eventChanged = new Event(EnumEvents.EVENT_CHANGED());
      eventOpened = new Event(EnumEvents.EVENT_OPENED());
      eventClosed = new Event(EnumEvents.EVENT_CLOSED());
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_PADDING_CHANGED(), applicationAppearanceChanged);
      application.trace("<" + this + " BaseReact> constructed.", 1);
    }
    /**
     * Tells whether this object can be reacted to at the moment.
     */
    public function getReactEnabled():Boolean
    {
      return reactEnabled;
    }
    /**
     * Switches the react feature of this object on or off. Switched off, every object
     * of the react row and of the picker is freed up, but the hits themselves are kept,
     * so they are displayed again as soon as this feature is switched back on.
     * @param b true when this object has to be reacted to
     */
    public function setReactEnabled(b:Boolean):void
    {
      application.trace("<" + this + " BaseReact setReactEnabled> called.", 1);
      application.trace("<" + this + " BaseReact setReactEnabled> b: " + b, 0);
      if (reactEnabled != b)
      {
        application.trace("<" + this + " BaseReact setReactEnabled> conditions OK.", 1);
        reactEnabled = b;
        if (reactEnabled)
        {
          createReactObjects();
        }
        else
        {
          destroyReactObjects();
        }
        reposResizeEverything();
      }
    }
    /**
     * Returns the number of every hit this object has taken.
     */
    public function getNumOfHits():int
    {
      return hitsArray.length;
    }
    /**
     * Returns a copy of the hits this object has taken. One element of it is an object
     * having a username, an emojiType and a date property.
     */
    public function getHits():Array
    {
      return hitsArray.concat();
    }
    /**
     * Returns the number of the hits of one single emoji.
     * @param emojiType the type of the emoji, an EnumEmojis value
     */
    public function getNumOfHitsOfEmoji(emojiType:String):int
    {
      application.trace("<" + this + " BaseReact getNumOfHitsOfEmoji> called.", 1);
      application.trace("<" + this + " BaseReact getNumOfHitsOfEmoji> emojiType: " + emojiType, 0);
      var numOfHits:int = 0;
      for (var i:int = 0; i < hitsArray.length; i++)
      {
        if (hitsArray[i].emojiType == emojiType)
        {
          numOfHits++;
        }
      }
      application.trace("<" + this + " BaseReact getNumOfHitsOfEmoji> numOfHits: " + numOfHits, 0);
      return numOfHits;
    }
    /**
     * Returns the types of the emojis this object has taken a hit of, in a descending
     * order by the number of their hits.
     */
    public function getEmojiTypesByHits():Array
    {
      application.trace("<" + this + " BaseReact getEmojiTypesByHits> called.", 1);
      const hitsPerEmojiTypeArray:Array = getHitsPerEmojiTypeArray();
      const emojiTypesArray:Array = new Array();
      for (var i:int = 0; i < hitsPerEmojiTypeArray.length; i++)
      {
        emojiTypesArray.push(hitsPerEmojiTypeArray[i].emojiType);
      }
      return emojiTypesArray;
    }
    /**
     * Tells whether the given user has already hit the given emoji on this object.
     * @param username the name of the user
     * @param emojiType the type of the emoji, an EnumEmojis value
     */
    public function hasHitOfUser(username:String, emojiType:String):Boolean
    {
      application.trace("<" + this + " BaseReact hasHitOfUser> called.", 1);
      application.trace("<" + this + " BaseReact hasHitOfUser> username: " + username, 0);
      application.trace("<" + this + " BaseReact hasHitOfUser> emojiType: " + emojiType, 0);
      for (var i:int = 0; i < hitsArray.length; i++)
      {
        if (hitsArray[i].username == username && hitsArray[i].emojiType == emojiType)
        {
          return true;
        }
      }
      return false;
    }
    /**
     * Stores one hit on this object and displays it. This is the way the hits taken
     * earlier are loaded back from the outside, so it does not dispatch the changed
     * event of this object. The hits of one user and one emoji are stored once.
     * @param username the name of the user the hit belongs to
     * @param emojiType the type of the hit emoji, an EnumEmojis value
     * @param date the moment the hit has been taken at
     */
    public function addHit(username:String, emojiType:String, date:Date):void
    {
      application.trace("<" + this + " BaseReact addHit> called.", 1);
      application.trace("<" + this + " BaseReact addHit> username: " + username, 0);
      application.trace("<" + this + " BaseReact addHit> emojiType: " + emojiType, 0);
      application.trace("<" + this + " BaseReact addHit> date: " + date, 0);
      if (emojiType == null || emojiType == "")
      {
        application.trace("<" + this + " BaseReact addHit> emojiType is empty!", 6);
        return;
      }
      if (hasHitOfUser(username, emojiType))
      {
        application.trace("<" + this + " BaseReact addHit> this user has already hit this emoji.", 0);
        return;
      }
      hitsArray.push({username: username, emojiType: emojiType, date: date});
      updateReactionButtonLinks();
      reposResizeEverything();
    }
    /**
     * Drops the hit of the given user and emoji. It does not dispatch the changed event
     * of this object, see the addHit method.
     * @param username the name of the user the hit belongs to
     * @param emojiType the type of the hit emoji, an EnumEmojis value
     */
    public function removeHit(username:String, emojiType:String):void
    {
      application.trace("<" + this + " BaseReact removeHit> called.", 1);
      application.trace("<" + this + " BaseReact removeHit> username: " + username, 0);
      application.trace("<" + this + " BaseReact removeHit> emojiType: " + emojiType, 0);
      for (var i:int = hitsArray.length - 1; i >= 0; i--)
      {
        if (hitsArray[i].username == username && hitsArray[i].emojiType == emojiType)
        {
          hitsArray.splice(i, 1);
        }
      }
      updateReactionButtonLinks();
      reposResizeEverything();
    }
    /**
     * Drops every hit of this object. It does not dispatch the changed event of this
     * object, see the addHit method.
     */
    public function clearHits():void
    {
      application.trace("<" + this + " BaseReact clearHits> called.", 1);
      hitsArray.splice(0);
      updateReactionButtonLinks();
      reposResizeEverything();
    }
    /**
     * Tells whether the emoji picker of this object is opened at the moment.
     */
    public function isPickerOpened():Boolean
    {
      application.trace("<" + this + " BaseReact isPickerOpened> called.", 1);
      const opened:Boolean = pickerContentMultiple != null && pickerContentMultiple.visible;
      application.trace("<" + this + " BaseReact isPickerOpened> opened: " + opened, 0);
      return opened;
    }
    /**
     * Opens the emoji picker of this object, building it up at the very first call.
     * The picker is placed under the react row, so this object grows by its dimensions.
     */
    public function openPicker():void
    {
      application.trace("<" + this + " BaseReact openPicker> called.", 1);
      if (!reactEnabled)
      {
        application.trace("<" + this + " BaseReact openPicker> the react feature is switched off!", 6);
        return;
      }
      createPickerContentMultiple();
      pickerContentMultiple.visible = true;
      if (stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, hasToClosePickerByMouse, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, hasToClosePickerByKeyboard, false, 0, true);
      }
      reposResizeEverything();
      toBeVisible();
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventOpened);
      }
    }
    /**
     * Closes the emoji picker of this object, so this object takes the room of its
     * content and of its react row only.
     */
    public function closePicker():void
    {
      application.trace("<" + this + " BaseReact closePicker> called.", 1);
      if (!isPickerOpened())
      {
        application.trace("<" + this + " BaseReact closePicker> the picker is not opened.", 1);
        return;
      }
      removeStageListeners();
      hideTooltip();
      // the search is over as soon as the picker is closed, so the content that was
      // opened before it comes back and the field of it is emptied
      if (pickerContentMultiple.getActiveIndex() == pickerSearchIndex)
      {
        pickerContentMultiple.setActiveIndex(getPickerIndexAfterSearch());
      }
      clearSearch();
      pickerContentMultiple.visible = false;
      reposResizeEverything();
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventClosed);
      }
    }
    /**
     * Enables or disables this object and every object of its react row and picker.
     * @param e true when this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " BaseReact setEnabled> called.", 1);
      application.trace("<" + this + " BaseReact setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (addButtonLink != null)
      {
        addButtonLink.setEnabled(getEnabled());
      }
      if (searchTextInput != null)
      {
        searchTextInput.setEnabled(getEnabled());
      }
      for (var i:int = 0; i < reactionButtonLinksArray.length; i++)
      {
        ButtonLink(reactionButtonLinksArray[i]).setEnabled(getEnabled());
      }
      if (pickerContentMultiple != null)
      {
        pickerContentMultiple.setEnabled(getEnabled());
      }
    }
    /**
     * Sets the width of the content of this object. The width of this object itself is
     * the widest of that content, of the react row and of the opened picker.
     * @param newdw the new width of the content
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " BaseReact setDw> called.", 1);
      application.trace("<" + this + " BaseReact setDw> newdw: " + newdw, 0);
      if (contentDw != newdw)
      {
        application.trace("<" + this + " BaseReact setDw> conditions OK.", 1);
        contentDw = newdw;
        reposResizeEverything();
      }
    }
    /**
     * Sets the height of the content of this object. The height of this object itself
     * holds that content, the react row and the opened picker as well.
     * @param newdh the new height of the content
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " BaseReact setDh> called.", 1);
      application.trace("<" + this + " BaseReact setDh> newdh: " + newdh, 0);
      if (contentDh != newdh)
      {
        application.trace("<" + this + " BaseReact setDh> conditions OK.", 1);
        contentDh = newdh;
        reposResizeEverything();
      }
    }
    /**
     * Sets the dimensions of the content of this object, see the setDw and the setDh.
     * @param newdw the new width of the content
     * @param newdh the new height of the content
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " BaseReact setDwh> called.", 1);
      application.trace("<" + this + " BaseReact setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " BaseReact setDwh> newdh: " + newdh, 0);
      if (contentDw != newdw || contentDh != newdh)
      {
        application.trace("<" + this + " BaseReact setDwh> conditions OK.", 1);
        contentDw = newdw;
        contentDh = newdh;
        reposResizeEverything();
      }
    }
    /**
     * Returns the width of the content of this object, the value the extending class
     * has set as its own width.
     */
    public function getContentDw():int
    {
      return contentDw;
    }
    /**
     * Returns the height of the content of this object, the value the extending class
     * has set as its own height.
     */
    public function getContentDh():int
    {
      return contentDh;
    }
    /**
     * Renders this object in its initialized state as soon as it gets onto the stage
     * and registers the close triggers of an already opened picker.
     * @param e the added to stage event
     */
    override protected function addedToStage(e:Event):void
    {
      application.trace("<" + this + " BaseReact addedToStage> called.", 1);
      application.trace("<" + this + " BaseReact addedToStage> e: " + e, 0);
      super.addedToStage(e);
      if (isPickerOpened() && stage != null)
      {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, hasToClosePickerByMouse, false, 0, true);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, hasToClosePickerByKeyboard, false, 0, true);
      }
      reposResizeEverything();
    }
    /**
     * Closes the picker of this object as soon as it leaves the stage, so that the
     * close triggers are unregistered while the stage is still reachable.
     * @param e the removed from stage event
     */
    override protected function removedFromStage(e:Event):void
    {
      application.trace("<" + this + " BaseReact removedFromStage> called.", 1);
      application.trace("<" + this + " BaseReact removedFromStage> e: " + e, 0);
      closePicker();
      super.removedFromStage(e);
    }
    /**
     * Dispatches the changed event of this object: a hit has been taken or taken back by
     * the one using the application, or the extender of this class has changed a state of
     * its own the outside has to follow.
     */
    protected function dispatchEventChanged():void
    {
      application.trace("<" + this + " BaseReact dispatchEventChanged> called.", 1);
      if (getBaseEventDispatcher() != null)
      {
        getBaseEventDispatcher().dispatchEvent(eventChanged);
      }
    }
    /**
     * Creates the react row of this object: the button opening the picker, the buttons
     * of the hits taken so far and the search field of the picker.
     */
    private function createReactObjects():void
    {
      application.trace("<" + this + " BaseReact createReactObjects> called.", 1);
      if (reactSprite == null)
      {
        reactSprite = new BaseSprite(application);
        addChild(reactSprite);
        addButtonLink = new ButtonLink(application);
        reactSprite.addChild(addButtonLink);
        addButtonLink.setIcon(EnumIcons.emojiplus());
        addButtonLink.setEnabled(getEnabled());
        addButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), addButtonLinkClick);
        addButtonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
        searchTextInput = new TextInput(application);
        reactSprite.addChild(searchTextInput);
        searchTextInput.setHint(EnumTextKeys.SEARCH());
        searchTextInput.setEnabled(getEnabled());
        searchTextInput.visible = false;
        // the changed event of an input comes on the enter key only, but a search has to
        // follow every single character, so the key up events of it are taken instead
        searchTextInput.getBaseEventDispatcher().addEventListener(KeyboardEvent.KEY_UP, searchTextInputKeyUp);
        // the delete icon of the field empties it without any key at all
        searchTextInput.getBaseEventDispatcher().addEventListener(MouseEvent.CLICK, searchTextInputClick);
        searchTextInput.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
      }
      updateReactionButtonLinks();
    }
    /**
     * Frees up the whole react row and the picker of this object.
     */
    private function destroyReactObjects():void
    {
      application.trace("<" + this + " BaseReact destroyReactObjects> called.", 1);
      closePicker();
      destroyPickerContentMultiple();
      if (reactSprite != null)
      {
        // the base sprite destroy frees up the buttons standing in this sprite as well
        reactSprite.destroy();
        if (contains(reactSprite))
        {
          removeChild(reactSprite);
        }
        reactSprite = null;
      }
      addButtonLink = null;
      searchTextInput = null;
      reactionButtonLinksArray.splice(0);
    }
    /**
     * Creates one button per hit emoji, in a descending order by the number of the hits
     * of that emoji. The number of the buttons is maximized by the components config:
     * the button opening the picker tells how many emojis are not displayed.
     */
    private function updateReactionButtonLinks():void
    {
      application.trace("<" + this + " BaseReact updateReactionButtonLinks> called.", 1);
      clearReactionButtonLinks();
      if (reactSprite == null)
      {
        application.trace("<" + this + " BaseReact updateReactionButtonLinks> there is no react row.", 1);
        return;
      }
      const hitsPerEmojiTypeArray:Array = getHitsPerEmojiTypeArray();
      const maxNumOfEmojis:int = application.getComponentsConfig().getReactMaxNumOfEmojis();
      const numOfButtons:int = Math.min(hitsPerEmojiTypeArray.length, maxNumOfEmojis);
      for (var i:int = 0; i < numOfButtons; i++)
      {
        const buttonLink:ButtonLink = new ButtonLink(application);
        reactSprite.addChild(buttonLink);
        buttonLink.setValue(hitsPerEmojiTypeArray[i].emojiType);
        buttonLink.setEmoji(String(hitsPerEmojiTypeArray[i].emojiType));
        buttonLink.setLabel("" + hitsPerEmojiTypeArray[i].hits);
        buttonLink.setEnabled(getEnabled());
        buttonLink.setEventDispatcherObjectToThis();
        buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CLICK(), reactionButtonLinkClick);
        buttonLink.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), buttonLinkResized);
        reactionButtonLinksArray.push(buttonLink);
      }
      const numOfHiddenEmojis:int = hitsPerEmojiTypeArray.length - numOfButtons;
      addButtonLink.setLabel(numOfHiddenEmojis > 0 ? "+" + numOfHiddenEmojis : "");
      if (numOfHiddenEmojis > 0)
      {
        application.trace("<" + this + " BaseReact updateReactionButtonLinks> not displayed emojis: " + numOfHiddenEmojis, 0);
      }
    }
    /**
     * Frees up every button of the hit emojis.
     */
    private function clearReactionButtonLinks():void
    {
      application.trace("<" + this + " BaseReact clearReactionButtonLinks> called.", 1);
      for (var i:int = 0; i < reactionButtonLinksArray.length; i++)
      {
        const buttonLink:ButtonLink = ButtonLink(reactionButtonLinksArray[i]);
        buttonLink.destroy();
        if (reactSprite != null && reactSprite.contains(buttonLink))
        {
          reactSprite.removeChild(buttonLink);
        }
      }
      reactionButtonLinksArray.splice(0);
    }
    /**
     * Returns the hit emojis of this object in objects having an emojiType and a hits
     * property, in a descending order by that number of hits.
     */
    private function getHitsPerEmojiTypeArray():Array
    {
      application.trace("<" + this + " BaseReact getHitsPerEmojiTypeArray> called.", 1);
      const numOfHitsPerEmojiType:Array = new Array();
      const hitsPerEmojiTypeArray:Array = new Array();
      var emojiType:String = "";
      for (var i:int = 0; i < hitsArray.length; i++)
      {
        emojiType = String(hitsArray[i].emojiType);
        if (numOfHitsPerEmojiType[emojiType] == undefined)
        {
          numOfHitsPerEmojiType[emojiType] = 0;
        }
        numOfHitsPerEmojiType[emojiType]++;
      }
      for (emojiType in numOfHitsPerEmojiType)
      {
        hitsPerEmojiTypeArray.push({emojiType: emojiType, hits: int(numOfHitsPerEmojiType[emojiType])});
      }
      hitsPerEmojiTypeArray.sortOn("hits", Array.NUMERIC | Array.DESCENDING);
      return hitsPerEmojiTypeArray;
    }
    /**
     * Opens the emoji picker of this object.
     * @param e the click event of the button standing in front of the react row
     */
    private function addButtonLinkClick(e:Event):void
    {
      application.trace("<" + this + " BaseReact addButtonLinkClick> called.", 1);
      application.trace("<" + this + " BaseReact addButtonLinkClick> e: " + e, 0);
      if (isPickerOpened())
      {
        closePicker();
      }
      else
      {
        openPicker();
      }
    }
    /**
     * Takes the hit of the current user back from the emoji of the clicked button, or
     * hits that emoji when that user has not hit it yet.
     * @param e the click event of one button of the react row
     */
    private function reactionButtonLinkClick(e:Event):void
    {
      application.trace("<" + this + " BaseReact reactionButtonLinkClick> called.", 1);
      application.trace("<" + this + " BaseReact reactionButtonLinkClick> e: " + e, 0);
      const buttonLink:ButtonLink = ButtonLink(BaseEventDispatcher(e.target).getParentObject());
      if (buttonLink != null)
      {
        hitEmojiByTheUser(String(buttonLink.getValue()));
      }
    }
    /**
     * Builds the emoji picker of this object up: one content for the most common emojis,
     * one per emoji category and one more for the hits of the search, every one of them
     * filled only when it is opened for the first time. The common emojis stand in the
     * very first content and the hits of the search in the last one, so that the index of
     * a content is the index of its own name in the content names array.
     */
    private function createPickerContentMultiple():void
    {
      application.trace("<" + this + " BaseReact createPickerContentMultiple> called.", 1);
      if (pickerContentMultiple != null)
      {
        application.trace("<" + this + " BaseReact createPickerContentMultiple> the picker is already there.", 1);
        return;
      }
      pickerContentMultiple = new ContentMultiple(application);
      addChild(pickerContentMultiple);
      pickerContentMultiple.setEnabled(getEnabled());
      pickerContentMultiple.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), pickerContentChanged);
      pickerContentNamesArray = application.getEmojiManager().getCategoryList();
      pickerContentNamesArray.sort();
      // The most common emojis open the picker, so their name is put in front of the sorted
      // categories: that content is no category of the emoji manager, the emojis of it come
      // from the getCommonEmojisArray below.
      pickerContentNamesArray.unshift(EnumTextKeys.COMMON());
      pickerCommonIndex = 0;
      application.trace("<" + this + " BaseReact createPickerContentMultiple> pickerCommonIndex: " + pickerCommonIndex, 0);
      for (var i:int = 0; i < pickerContentNamesArray.length; i++)
      {
        // the emojis are positioned into a grid by the content itself, the number of the
        // columns of that grid is set by the resizePickerContentMultiple
        pickerContentMultiple.setOrientation(pickerContentMultiple.addContent(String(pickerContentNamesArray[i])),
          EnumOrientations.ORIENTATION_VERTICAL());
      }
      pickerSearchIndex = pickerContentMultiple.addContent(EnumTextKeys.SEARCH());
      application.trace("<" + this + " BaseReact createPickerContentMultiple> pickerSearchIndex: " + pickerSearchIndex, 0);
      if (pickerSearchIndex > -1)
      {
        pickerContentMultiple.setOrientation(pickerSearchIndex, EnumOrientations.ORIENTATION_VERTICAL());
      }
      else
      {
        application.trace("<" + this + " BaseReact createPickerContentMultiple> there is an emoji category named "
          + EnumTextKeys.SEARCH() + ", so this picker has no search content at all!", 6);
      }
      // the emojis of a content of this picker are wrapped into as many rows as they need,
      // so no content of it ever grows wider than the picker itself
      for (i = 0; i < pickerContentMultiple.getNumOfContents(); i++)
      {
        const baseScroll:BaseScroll = pickerContentMultiple.getBaseScroll(i);
        if (baseScroll != null)
        {
          baseScroll.setEnabledHorizontal(false);
        }
      }
      resizePickerContentMultiple();
      pickerContentMultiple.setActiveIndex(0);
    }
    /**
     * Frees up the emoji picker of this object.
     */
    private function destroyPickerContentMultiple():void
    {
      application.trace("<" + this + " BaseReact destroyPickerContentMultiple> called.", 1);
      clearPickerIcons();
      destroyTooltip();
      if (pickerContentMultiple != null)
      {
        // the base sprite destroy frees up the contents of this picker as well
        pickerContentMultiple.destroy();
        if (contains(pickerContentMultiple))
        {
          removeChild(pickerContentMultiple);
        }
        pickerContentMultiple = null;
      }
      pickerContentNamesArray.splice(0);
      pickerCommonIndex = -1;
      pickerSearchIndex = -1;
      pickerIndexBeforeSearch = -1;
    }
    /**
     * Sets the dimensions of the picker to the number of the emoji columns and rows the
     * components config asks for, and tells every content of it how many emojis fit into
     * that width. The height of the button bar of the picker is known after its width
     * has been set, so the height is set in a second round.
     */
    private function resizePickerContentMultiple():void
    {
      application.trace("<" + this + " BaseReact resizePickerContentMultiple> called.", 1);
      if (pickerContentMultiple == null)
      {
        application.trace("<" + this + " BaseReact resizePickerContentMultiple> there is no picker.", 1);
        return;
      }
      const cellSize:int = getPickerCellSize();
      const dw:int = int(application.getComponentsConfig().getReactPickerNumOfColumns() * cellSize / 2);
      const dh:int = application.getComponentsConfig().getReactPickerNumOfRows() * cellSize;
      pickerContentMultiple.setDwh(dw, dh);
      pickerContentMultiple.setDwh(dw, dh + pickerContentMultiple.getButtonBarCyAndHeight());
      const elementsFix:int = int((dw - application.getDynamicsConfig().getAppMargin()) / cellSize);
      application.trace("<" + this + " BaseReact resizePickerContentMultiple> elementsFix: " + elementsFix, 0);
      for (var i:int = 0; i < pickerContentMultiple.getNumOfContents(); i++)
      {
        pickerContentMultiple.setElementsFix(i, elementsFix);
      }
    }
    /**
     * Fills the content of the picker that has just been opened and drops the text of
     * the search field as soon as a category is opened by hand.
     * @param e the changed event of the picker
     */
    private function pickerContentChanged(e:Event):void
    {
      application.trace("<" + this + " BaseReact pickerContentChanged> called.", 1);
      application.trace("<" + this + " BaseReact pickerContentChanged> e: " + e, 0);
      const index:int = pickerContentMultiple.getActiveIndex();
      if (index != pickerSearchIndex)
      {
        clearSearch();
      }
      fillPickerContent(index);
    }
    /**
     * Returns the types of the most common emojis: the ones a reaction is given with the
     * most often, in the order the very first content of the picker displays them in.
     * Every one of them stands in a category of the emoji manager as well, that content
     * only collects them onto one page.
     */
    private function getCommonEmojisArray():Array
    {
      application.trace("<" + this + " BaseReact getCommonEmojisArray> called.", 1);
      return [EnumEmojis.hands_thumbsup(), EnumEmojis.labels_plus1(), EnumEmojis.symbols_white_check_mark()
          , EnumEmojis.labels_ok(), EnumEmojis.labels_yes(), EnumEmojis.labels_no(), EnumEmojis.labels_nice()
          , EnumEmojis.labels_cool(), EnumEmojis.labels_top(), EnumEmojis.labels_ty_thank_you()
          , EnumEmojis.hands_thumbsdown(), EnumEmojis.hands_clap(), EnumEmojis.hands_crossed_fingers()
          , EnumEmojis.hands_ok_hand(), EnumEmojis.hands_muscle(), EnumEmojis.hands_pray()
          , EnumEmojis.hands_wave(), EnumEmojis.hands_v(), EnumEmojis.smileys_smile(), EnumEmojis.smileys_grin()
          , EnumEmojis.smileys_joy(), EnumEmojis.smileys_wink(), EnumEmojis.smileys_heart_eyes()
          , EnumEmojis.smileys_thinking_face(), EnumEmojis.smileys_eyes(), EnumEmojis.smileys_100_one_hundred()
          , EnumEmojis.smileys_sparkles(), EnumEmojis.hearts_heart(), EnumEmojis.objects_objects_tada()
          , EnumEmojis.objects_fire(), EnumEmojis.objects_pill(), EnumEmojis.read_book()
          , EnumEmojis.vehicles_rocket(), EnumEmojis.food_beer()];
    }
    /**
     * Drops the emojis displayed by the picker so far and creates the emojis of the
     * given content, positioning them into a grid.
     * @param index the index of the content to be filled
     */
    private function fillPickerContent(index:int):void
    {
      application.trace("<" + this + " BaseReact fillPickerContent> called.", 1);
      application.trace("<" + this + " BaseReact fillPickerContent> index: " + index, 0);
      clearPickerIcons();
      const searching:Boolean = index > -1 && index == pickerSearchIndex;
      const common:Boolean = index > -1 && index == pickerCommonIndex;
      if (!searching && (index < 0 || index >= pickerContentNamesArray.length))
      {
        application.trace("<" + this + " BaseReact fillPickerContent> there is no such content!", 6);
        return;
      }
      const emojisArray:Array = searching ? getMatchingEmojisArray()
        : common ? getCommonEmojisArray() : application.getEmojiManager().getEmojiList(String(pickerContentNamesArray[index]));
      const emojiSize:int = getPickerEmojiSize();
      // a content holds hundreds of emojis and it positions every element of itself
      // again after every single addToContent call, so it is left alone while it is
      // filled up and it positions the whole grid once at the end
      pickerContentMultiple.setOrientation(index, EnumOrientations.ORIENTATION_MANUAL());
      for (var i:int = 0; i < emojisArray.length; i++)
      {
        const icon:Icon = new Icon(application);
        icon.drawEmojiBitmapData(String(emojisArray[i]), emojiSize);
        icon.setValue(emojisArray[i]);
        icon.alpha = application.getComponentsConfig().getReactEmojiAlphaMouseOut();
        icon.addEventListener(MouseEvent.ROLL_OVER, pickerIconRollOver, false, 0, true);
        icon.addEventListener(MouseEvent.ROLL_OUT, pickerIconRollOut, false, 0, true);
        icon.addEventListener(MouseEvent.MOUSE_DOWN, pickerIconMouseDown, false, 0, true);
        icon.addEventListener(MouseEvent.CLICK, pickerIconClick, false, 0, true);
        pickerContentMultiple.addToContent(index, icon, i);
        pickerIconsArray.push(icon);
      }
      pickerContentMultiple.setOrientation(index, EnumOrientations.ORIENTATION_VERTICAL());
      pickerFilledIndex = index;
      application.trace("<" + this + " BaseReact fillPickerContent> number of the emojis: " + emojisArray.length, 0);
    }
    /**
     * Frees up every emoji displayed by the picker so far.
     */
    private function clearPickerIcons():void
    {
      application.trace("<" + this + " BaseReact clearPickerIcons> called.", 1);
      // the emoji the tooltip belongs to is about to go
      hideTooltip();
      if (pickerContentMultiple != null && pickerFilledIndex > -1)
      {
        // the content is left alone while it is emptied, the fillPickerContent gives
        // the orientation of it back as soon as it is filled up again
        pickerContentMultiple.setOrientation(pickerFilledIndex, EnumOrientations.ORIENTATION_MANUAL());
      }
      for (var i:int = 0; i < pickerIconsArray.length; i++)
      {
        const icon:Icon = Icon(pickerIconsArray[i]);
        icon.removeEventListener(MouseEvent.ROLL_OVER, pickerIconRollOver);
        icon.removeEventListener(MouseEvent.ROLL_OUT, pickerIconRollOut);
        icon.removeEventListener(MouseEvent.MOUSE_DOWN, pickerIconMouseDown);
        icon.removeEventListener(MouseEvent.CLICK, pickerIconClick);
        // the emoji is taken out of the content first, because that content reaches the
        // event dispatcher of it, which is not there any more after the destroy call
        if (pickerContentMultiple != null && pickerFilledIndex > -1)
        {
          pickerContentMultiple.removeFromContent(pickerFilledIndex, icon);
        }
        icon.destroy();
      }
      pickerIconsArray.splice(0);
      pickerFilledIndex = -1;
    }
    /**
     * Searches the emojis again after a character has been typed into the search field
     * or one has been deleted from it.
     * @param e the key up event of the search field
     */
    private function searchTextInputKeyUp(e:KeyboardEvent):void
    {
      application.trace("<" + this + " BaseReact searchTextInputKeyUp> called.", 1);
      application.trace("<" + this + " BaseReact searchTextInputKeyUp> e: " + e, 0);
      searchTheEmojis();
    }
    /**
     * Searches the emojis again after the whole text of the search field has been
     * dropped by the delete icon of it.
     * @param e the click event of the delete icon of the search field
     */
    private function searchTextInputClick(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact searchTextInputClick> called.", 1);
      application.trace("<" + this + " BaseReact searchTextInputClick> e: " + e, 0);
      searchTheEmojis();
    }
    /**
     * Displays the emojis matching the text of the search field, from the very first
     * character typed into it. Emptying that field brings the content that was opened
     * before the search back.
     */
    private function searchTheEmojis():void
    {
      application.trace("<" + this + " BaseReact searchTheEmojis> called.", 1);
      if (pickerContentMultiple == null || pickerSearchIndex < 0)
      {
        application.trace("<" + this + " BaseReact searchTheEmojis> there is no search content at all!", 6);
        return;
      }
      if (searchTextInput.getText() != "")
      {
        if (pickerContentMultiple.getActiveIndex() != pickerSearchIndex)
        {
          // the content standing here is opened again as soon as the search is over, and
          // the activation below dispatches the changed event of the picker, which fills
          // the search content up
          pickerIndexBeforeSearch = pickerContentMultiple.getActiveIndex();
          pickerContentMultiple.setActiveIndex(pickerSearchIndex);
        }
        else
        {
          fillPickerContent(pickerSearchIndex);
        }
      }
      else if (pickerContentMultiple.getActiveIndex() == pickerSearchIndex)
      {
        pickerContentMultiple.setActiveIndex(getPickerIndexAfterSearch());
      }
    }
    /**
     * Returns the types of the emojis whose name holds the text of the search field. The
     * name of an emoji begins with the name of its category, so a whole category is
     * found by its very name as well. The number of the displayed hits is maximized by
     * the components config.
     */
    private function getMatchingEmojisArray():Array
    {
      application.trace("<" + this + " BaseReact getMatchingEmojisArray> called.", 1);
      const matchingEmojisArray:Array = new Array();
      const searchText:String = searchTextInput == null ? "" : searchTextInput.getText().toLowerCase();
      application.trace("<" + this + " BaseReact getMatchingEmojisArray> searchText: " + searchText, 0);
      if (searchText == "")
      {
        return matchingEmojisArray;
      }
      const maxNumOfHits:int = application.getComponentsConfig().getReactPickerMaxNumOfHits();
      var numOfMatches:int = 0;
      for (var i:int = 0; i < pickerContentNamesArray.length; i++)
      {
        if (i == pickerCommonIndex)
        {
          // every common emoji stands in a category below as well, it would be found twice
          continue;
        }
        const emojisArray:Array = application.getEmojiManager().getEmojiList(String(pickerContentNamesArray[i]));
        for (var j:int = 0; j < emojisArray.length; j++)
        {
          if (String(emojisArray[j]).toLowerCase().indexOf(searchText) > -1)
          {
            numOfMatches++;
            if (matchingEmojisArray.length < maxNumOfHits)
            {
              matchingEmojisArray.push(emojisArray[j]);
            }
          }
        }
      }
      application.trace("<" + this + " BaseReact getMatchingEmojisArray> numOfMatches: " + numOfMatches, 0);
      if (numOfMatches > matchingEmojisArray.length)
      {
        application.trace("<" + this + " BaseReact getMatchingEmojisArray> not displayed matches: "
          + (numOfMatches - matchingEmojisArray.length), 0);
      }
      return matchingEmojisArray;
    }
    /**
     * Returns the index of the content the picker has to display as soon as the search
     * is over: the one that was opened before it, or the very first one.
     */
    private function getPickerIndexAfterSearch():int
    {
      application.trace("<" + this + " BaseReact getPickerIndexAfterSearch> called.", 1);
      const index:int = pickerIndexBeforeSearch > -1 ? pickerIndexBeforeSearch : 0;
      application.trace("<" + this + " BaseReact getPickerIndexAfterSearch> index: " + index, 0);
      return index;
    }
    /**
     * Empties the search field and forgets the content that was opened before the
     * search, so the next one starts from a clean state.
     */
    private function clearSearch():void
    {
      application.trace("<" + this + " BaseReact clearSearch> called.", 1);
      if (searchTextInput != null && searchTextInput.getText() != "")
      {
        searchTextInput.setLabel("");
      }
      pickerIndexBeforeSearch = -1;
    }
    /**
     * Highlights the emoji the mouse has been moved over and tells the name of it in a
     * tooltip.
     * @param e the roll over event of one emoji of the picker
     */
    private function pickerIconRollOver(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact pickerIconRollOver> called.", 1);
      application.trace("<" + this + " BaseReact pickerIconRollOver> e: " + e, 0);
      const icon:Icon = Icon(e.currentTarget);
      icon.alpha = 1;
      showTooltip(String(icon.getValue()));
    }
    /**
     * Takes the highlight and the tooltip of the emoji the mouse has been moved away
     * from.
     * @param e the roll out event of one emoji of the picker
     */
    private function pickerIconRollOut(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact pickerIconRollOut> called.", 1);
      application.trace("<" + this + " BaseReact pickerIconRollOut> e: " + e, 0);
      Icon(e.currentTarget).alpha = application.getComponentsConfig().getReactEmojiAlphaMouseOut();
      hideTooltip();
    }
    /**
     * Stores the position the press on an emoji has been started from, so that a swipe
     * can be told from a click afterwards, and drops the tooltip: that press either
     * scrolls the picker or picks the emoji, and neither of them needs a name.
     * @param e the mouse down event of one emoji of the picker
     */
    private function pickerIconMouseDown(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact pickerIconMouseDown> called.", 1);
      application.trace("<" + this + " BaseReact pickerIconMouseDown> e: " + e, 0);
      origMouseX = int(mouseX);
      origMouseY = int(mouseY);
      hideTooltip();
    }
    /**
     * Hits the emoji that has been clicked in the picker and closes that picker.
     * @param e the click event of one emoji of the picker
     */
    private function pickerIconClick(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact pickerIconClick> called.", 1);
      application.trace("<" + this + " BaseReact pickerIconClick> e: " + e, 0);
      if (getEnabled() && mouseHasNotTravelled())
      {
        hitEmojiByTheUser(String(Icon(e.currentTarget).getValue()));
        closePicker();
      }
    }
    /**
     * Tells whether the mouse has stayed at the very place it has been pressed down at.
     * A mouse that has travelled farther than the click gap of the application has
     * scrolled the picker: the emoji under it has moved along with it, so it reports a
     * click of its own that is a swipe in fact.
     */
    private function mouseHasNotTravelled():Boolean
    {
      application.trace("<" + this + " BaseReact mouseHasNotTravelled> called.", 1);
      const clickGap:int = application.getComponentsConfig().getClickGap();
      const notTravelled:Boolean = Math.abs(origMouseX - int(mouseX)) < clickGap
        && Math.abs(origMouseY - int(mouseY)) < clickGap;
      application.trace("<" + this + " BaseReact mouseHasNotTravelled> notTravelled: " + notTravelled, 0);
      return notTravelled;
    }
    /**
     * Builds the tooltip of the emojis up. It is a plain sprite standing over everything
     * else of this object, and it takes no mouse event at all, so that the emoji under
     * it keeps hearing the mouse.
     */
    private function createTooltip():void
    {
      application.trace("<" + this + " BaseReact createTooltip> called.", 1);
      if (tooltipSprite != null)
      {
        application.trace("<" + this + " BaseReact createTooltip> the tooltip is already there.", 1);
        return;
      }
      tooltipSprite = new BaseSprite(application);
      addChild(tooltipSprite);
      tooltipSprite.mouseEnabled = false;
      tooltipSprite.mouseChildren = false;
      tooltipShape = new BaseShape(application);
      tooltipSprite.addChild(tooltipShape);
      tooltipShape.setIsBright(false);
      tooltipShape.setType(EnumBaseShapeTypes.BASE_SHAPE_TYPE_NOT_PRESSED());
      tooltipBaseTextField = new BaseTextField(application);
      tooltipSprite.addChild(tooltipBaseTextField);
      tooltipBaseTextField.setType(EnumTextTypes.TEXT_TYPE_MID());
      tooltipBaseTextField.setAutoSizeLeft();
    }
    /**
     * Displays the name of the emoji the mouse stands over, over every other object of
     * this one.
     * @param emojiType the type of the emoji, an EnumEmojis value
     */
    private function showTooltip(emojiType:String):void
    {
      application.trace("<" + this + " BaseReact showTooltip> called.", 1);
      application.trace("<" + this + " BaseReact showTooltip> emojiType: " + emojiType, 0);
      createTooltip();
      const padding:int = application.getDynamicsConfig().getAppPadding();
      tooltipBaseTextField.setLabel(emojiType);
      tooltipBaseTextField.setCxy(padding, padding);
      const dw:int = tooltipBaseTextField.getDw() + 2 * padding;
      const dh:int = tooltipBaseTextField.getDh() + 2 * padding;
      tooltipSprite.setDwh(dw, dh);
      tooltipShape.setColorsAndAlpha(application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorDark()
        , application.getDynamicsConfig().getAppBackgroundColorMid()
        , application.getDynamicsConfig().getAppBackgroundColorAlpha()
        , application.getDynamicsConfig().getAppBackgroundColorBright());
      tooltipShape.setRadius(application.getDynamicsConfig().getAppRadius());
      tooltipShape.setDwh(dw, dh);
      tooltipShape.drawRect();
      reposTooltip();
      tooltipSprite.visible = true;
      // the picker has been built after the tooltip when the react feature was switched
      // off and back on in the meantime, so the tooltip is lifted over everything again
      setChildIndex(tooltipSprite, numChildren - 1);
    }
    /**
     * Positions the tooltip over the mouse pointer, but inside the picker: an emoji of
     * the very first row has no room above it, so its name stands under the pointer.
     */
    private function reposTooltip():void
    {
      application.trace("<" + this + " BaseReact reposTooltip> called.", 1);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      var cx:int = int(mouseX) - tooltipSprite.getDw() / 2;
      var cy:int = int(mouseY) - tooltipSprite.getDh() - margin;
      if (pickerContentMultiple != null)
      {
        cx = Math.max(pickerContentMultiple.getCx()
          , Math.min(cx, pickerContentMultiple.getCx(true) - tooltipSprite.getDw()));
        if (cy < pickerContentMultiple.getCy())
        {
          cy = int(mouseY) + margin;
        }
      }
      tooltipSprite.setCxy(cx, cy);
    }
    /**
     * Hides the tooltip of the emojis.
     */
    private function hideTooltip():void
    {
      application.trace("<" + this + " BaseReact hideTooltip> called.", 1);
      if (tooltipSprite != null)
      {
        tooltipSprite.visible = false;
      }
    }
    /**
     * Frees up the tooltip of the emojis.
     */
    private function destroyTooltip():void
    {
      application.trace("<" + this + " BaseReact destroyTooltip> called.", 1);
      if (tooltipSprite != null)
      {
        // the base sprite destroy frees up the shape and the text field of the tooltip
        tooltipSprite.destroy();
        if (contains(tooltipSprite))
        {
          removeChild(tooltipSprite);
        }
        tooltipSprite = null;
      }
      tooltipShape = null;
      tooltipBaseTextField = null;
    }
    /**
     * Hits the given emoji in the name of the current user, or takes that hit back when
     * that user has already hit it, and dispatches the changed event of this object.
     * @param emojiType the type of the emoji, an EnumEmojis value
     */
    private function hitEmojiByTheUser(emojiType:String):void
    {
      application.trace("<" + this + " BaseReact hitEmojiByTheUser> called.", 1);
      application.trace("<" + this + " BaseReact hitEmojiByTheUser> emojiType: " + emojiType, 0);
      const username:String = application.getUser().getUsername();
      if (hasHitOfUser(username, emojiType))
      {
        removeHit(username, emojiType);
      }
      else
      {
        addHit(username, emojiType, new Date());
      }
      dispatchEventChanged();
    }
    /**
     * Closes the picker when the mouse has been pressed anywhere else.
     * @param e the mouse down event of the stage
     */
    private function hasToClosePickerByMouse(e:MouseEvent):void
    {
      application.trace("<" + this + " BaseReact hasToClosePickerByMouse> called.", 1);
      application.trace("<" + this + " BaseReact hasToClosePickerByMouse> e: " + e, 0);
      if (!mouseIsOnThePickerOrOnTheRow())
      {
        closePicker();
      }
    }
    /**
     * Closes the picker when the tab or the escape key has been pressed.
     * @param e the key down event of the stage
     */
    private function hasToClosePickerByKeyboard(e:KeyboardEvent):void
    {
      application.trace("<" + this + " BaseReact hasToClosePickerByKeyboard> called.", 1);
      application.trace("<" + this + " BaseReact hasToClosePickerByKeyboard> e: " + e, 0);
      if (e.keyCode == Keyboard.TAB || e.keyCode == Keyboard.ESCAPE)
      {
        closePicker();
      }
    }
    /**
     * Tells whether the mouse pointer stands over the picker or over the react row of
     * this object. That row holds the search field of the picker and the very button
     * that opens and closes it, so a press on it must not close anything.
     */
    private function mouseIsOnThePickerOrOnTheRow():Boolean
    {
      application.trace("<" + this + " BaseReact mouseIsOnThePickerOrOnTheRow> called.", 1);
      if (pickerContentMultiple != null
        && mouseX >= pickerContentMultiple.getCx() && mouseX <= pickerContentMultiple.getCx(true)
        && mouseY >= pickerContentMultiple.getCy() && mouseY <= pickerContentMultiple.getCy(true))
      {
        return true;
      }
      return reactSprite != null
        && mouseX >= reactSprite.getCx() && mouseX <= reactSprite.getCx(true)
        && mouseY >= reactSprite.getCy() && mouseY <= reactSprite.getCy(true);
    }
    /**
     * Stops following the appearance of the application.
     */
    private function removeApplicationListeners():void
    {
      application.trace("<" + this + " BaseReact removeApplicationListeners> called.", 1);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_FONT_SIZE_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_TEXT_FORMAT_MID_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_MARGIN_CHANGED(), applicationAppearanceChanged);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_PADDING_CHANGED(), applicationAppearanceChanged);
    }
    /**
     * Unregisters the close triggers of the picker from the stage.
     */
    private function removeStageListeners():void
    {
      application.trace("<" + this + " BaseReact removeStageListeners> called.", 1);
      if (stage != null)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, hasToClosePickerByMouse);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, hasToClosePickerByKeyboard);
      }
    }
    /**
     * Returns the size of one emoji of the picker, calculated from the current mid text
     * height of the application.
     */
    private function getPickerEmojiSize():int
    {
      application.trace("<" + this + " BaseReact getPickerEmojiSize> called.", 1);
      const emojiSize:int = int(application.getComponentsConfig().getReactPickerEmojiSizeFactor()
          * application.getDynamicsConfig().getTextFieldHeight(EnumTextTypes.TEXT_TYPE_MID()));
      application.trace("<" + this + " BaseReact getPickerEmojiSize> emojiSize: " + emojiSize, 0);
      return emojiSize;
    }
    /**
     * Returns the size of one cell of the emoji grid of the picker: one emoji and the
     * margin standing after it.
     */
    private function getPickerCellSize():int
    {
      return getPickerEmojiSize() + application.getDynamicsConfig().getAppMargin();
    }
    /**
     * Draws the react row and the picker of this object again after the appearance of
     * the application has been changed, because both of them are sized by the font
     * size and by the margin of it.
     * @param e the font size, text format, margin or padding changed event of the
     * application
     */
    private function applicationAppearanceChanged(e:Event):void
    {
      application.trace("<" + this + " BaseReact applicationAppearanceChanged> called.", 1);
      application.trace("<" + this + " BaseReact applicationAppearanceChanged> e: " + e, 0);
      if (pickerFilledIndex > -1)
      {
        // the emojis of the opened category have to be drawn in the new size
        fillPickerContent(pickerContentMultiple.getActiveIndex());
      }
      resizePickerContentMultiple();
      reposResizeEverything();
    }
    /**
     * Positions the react row again after one of its buttons has taken a new size.
     * @param e the dimensions changed event of one button of the react row
     */
    private function buttonLinkResized(e:Event):void
    {
      application.trace("<" + this + " BaseReact buttonLinkResized> called.", 1);
      application.trace("<" + this + " BaseReact buttonLinkResized> e: " + e, 0);
      reposResizeEverything();
    }
    /**
     * Positions the react row under the content of this object and the picker under
     * that row, and takes the dimensions of this object from all of them.
     */
    private function reposResizeEverything():void
    {
      application.trace("<" + this + " BaseReact reposResizeEverything> called.", 1);
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const pickerOpened:Boolean = isPickerOpened();
      var pickerDw:int = 0;
      var pickerDh:int = 0;
      if (pickerOpened)
      {
        // the dimensions of the picker are taken before the react row is positioned,
        // because the search field of that row reaches the right edge of the picker
        pickerDw = pickerContentMultiple.getDw();
        pickerDh = pickerContentMultiple.getDh() + margin;
      }
      var reactDw:int = 0;
      var reactDh:int = 0;
      if (reactSprite != null)
      {
        // the elements of the row touch each other: every one of them carries a padding
        // of its own inside, so a gap between them would only take room
        addButtonLink.setCxy(0, 0);
        var currx:int = addButtonLink.getDw();
        reactDh = addButtonLink.getDh();
        // the opened picker takes the room of the reactions over for its search field
        searchTextInput.visible = pickerOpened;
        for (var i:int = 0; i < reactionButtonLinksArray.length; i++)
        {
          const buttonLink:ButtonLink = ButtonLink(reactionButtonLinksArray[i]);
          buttonLink.visible = !pickerOpened;
          if (!pickerOpened)
          {
            buttonLink.setCxy(currx, 0);
            currx += buttonLink.getDw();
            reactDh = Math.max(reactDh, buttonLink.getDh());
          }
        }
        if (pickerOpened)
        {
          searchTextInput.setCxy(currx, 0);
          searchTextInput.setDw(pickerDw - currx);
          currx += searchTextInput.getDw();
          reactDh = Math.max(reactDh, searchTextInput.getDh());
        }
        reactDw = currx;
        reactSprite.setCxy(0, contentDh + margin);
        reactSprite.setDwh(reactDw, reactDh);
        reactDh += margin;
      }
      if (pickerOpened)
      {
        // the height of the react row already carries the margin standing under it, so
        // the picker needs no margin of its own on top of that
        pickerContentMultiple.setCxy(0, contentDh + reactDh);
      }
      super.setDwh(Math.max(contentDw, Math.max(reactDw, pickerDw)), contentDh + reactDh + pickerDh);
    }
    /**
     * Frees all listeners, events and references held by this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseReact destroy> called.", 1);
      application.trace("<" + this + " BaseReact destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      removeApplicationListeners();
      removeStageListeners();
      for (var i:int = 0; i < pickerIconsArray.length; i++)
      {
        const icon:Icon = Icon(pickerIconsArray[i]);
        icon.removeEventListener(MouseEvent.ROLL_OVER, pickerIconRollOver);
        icon.removeEventListener(MouseEvent.ROLL_OUT, pickerIconRollOut);
        icon.removeEventListener(MouseEvent.MOUSE_DOWN, pickerIconMouseDown);
        icon.removeEventListener(MouseEvent.CLICK, pickerIconClick);
      }
      application.trace("<" + this + " BaseReact destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      eventChanged.stopImmediatePropagation();
      eventOpened.stopImmediatePropagation();
      eventClosed.stopImmediatePropagation();
      hitsArray.splice(0);
      reactionButtonLinksArray.splice(0);
      pickerContentNamesArray.splice(0);
      pickerIconsArray.splice(0);
      application.trace("<" + this + " BaseReact destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      reactEnabled = false;
      contentDw = 0;
      contentDh = 0;
      hitsArray = null;
      reactSprite = null;
      addButtonLink = null;
      searchTextInput = null;
      reactionButtonLinksArray = null;
      pickerContentMultiple = null;
      pickerContentNamesArray = null;
      pickerIconsArray = null;
      pickerFilledIndex = 0;
      pickerCommonIndex = 0;
      pickerSearchIndex = 0;
      pickerIndexBeforeSearch = 0;
      origMouseX = 0;
      origMouseY = 0;
      tooltipSprite = null;
      tooltipShape = null;
      tooltipBaseTextField = null;
      eventChanged = null;
      eventOpened = null;
      eventClosed = null;
    }
  }
}
