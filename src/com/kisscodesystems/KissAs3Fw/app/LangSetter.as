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
 * LangSetter.
 * Sets the language of the application. It is a list picker holding the languages
 * the application is available in.
 *
 * MAIN FEATURES:
 * - a list picker object with the languages of the application in it
 * - picking a language changes the language of the whole application, so every text
 *   given by a text key is displayed in the newly picked language from that moment
 * - it stands on the settings panel, or on the menu panel when that one is disabled
 */
package com.kisscodesystems.KissAs3Fw.app
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.base.BaseSprite;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.ui.ListPicker;
  import flash.events.Event;
  public class LangSetter extends BaseSprite
  {
    // the list picker displaying the languages
    private var listPicker:ListPicker = null;
    /**
     * Constructs the language setter with the list picker it is built of.
     * @param applicationRef the main application reference
     */
    public function LangSetter(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " LangSetter> called.", 1);
      application.trace("<" + this + " LangSetter> applicationRef: " + applicationRef, 0);
      listPicker = new ListPicker(application);
      addChild(listPicker);
      listPicker.setNumOfElements(application.getComponentsConfig().getLangSetterMaxElements());
      listPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_CHANGED(), listPickerChanged);
      listPicker.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_DIMENSIONS_CHANGED(), listPickerDimensionsChanged);
      // another object may change the language as well, this one has to follow that
      application.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_LANG_CHANGED(), langChanged);
      // the languages are loaded right here on purpose: this object is usable from the
      // moment it exists, without anybody having to fill it up from the outside
      updateLangCodes();
      application.trace("<" + this + " LangSetter> constructed.", 1);
    }
    /**
     * Returns the index of the language that is displayed as the picked one, minus one
     * when there is no language picked at all.
     */
    public function getSelectedIndex():int
    {
      return listPicker != null ? listPicker.getSelectedIndex() : -1;
    }
    /**
     * Sets the language that is displayed as the picked one.
     * @param index the index of the language inside the list
     * @param fireChangedEvent whether the language of the application has to follow the
     *                         newly displayed one. It is false when the language has been
     *                         changed already and this object only displays that change
     */
    public function setSelectedIndex(index:int, fireChangedEvent:Boolean = true):void
    {
      application.trace("<" + this + " LangSetter setSelectedIndex> called.", 1);
      application.trace("<" + this + " LangSetter setSelectedIndex> index: " + index, 0);
      application.trace("<" + this + " LangSetter setSelectedIndex> fireChangedEvent: " + fireChangedEvent, 0);
      if (listPicker != null)
      {
        listPicker.setSelectedIndex(index, fireChangedEvent);
      }
    }
    /**
     * Reloads the languages the application is available in. More of them can be
     * added later on, so this one has to be reachable from the outside.
     */
    public function updateLangCodes():void
    {
      application.trace("<" + this + " LangSetter updateLangCodes> called.", 1);
      listPicker.setArrays(application.getLabelManager().getKeysLang(), application.getLabelManager().getKeysLang());
      langChanged(null);
    }
    /**
     * Enables or disables the list picker of this object as well.
     * @param e whether this object has to be enabled
     */
    override public function setEnabled(e:Boolean):void
    {
      application.trace("<" + this + " LangSetter setEnabled> called.", 1);
      application.trace("<" + this + " LangSetter setEnabled> e: " + e, 0);
      super.setEnabled(e);
      if (listPicker != null)
      {
        listPicker.setEnabled(getEnabled());
      }
    }
    /**
     * Sets the width of this object and of the list picker in it.
     * @param newdw the new width
     */
    override public function setDw(newdw:int):void
    {
      application.trace("<" + this + " LangSetter setDw> called.", 1);
      application.trace("<" + this + " LangSetter setDw> newdw: " + newdw, 0);
      if (getDw() != newdw)
      {
        super.setDw(newdw);
        listPicker.setDw(getDw());
      }
    }
    /**
     * The height of this object is the one of its list picker, so it cannot be set
     * from the outside: it depends on the number of the elements to be displayed.
     * @param newdh the new height
     */
    override public function setDh(newdh:int):void
    {
      application.trace("<" + this + " LangSetter setDh> called.", 1);
      application.trace("<" + this + " LangSetter setDh> newdh: " + newdh, 0);
      application.trace("<" + this + " LangSetter setDh> do nothing.", 1);
    }
    /**
     * The height of this object cannot be set from the outside, so the setDw above
     * has to be used instead of this one.
     * @param newdw the new width
     * @param newdh the new height
     */
    override public function setDwh(newdw:int, newdh:int):void
    {
      application.trace("<" + this + " LangSetter setDwh> called.", 1);
      application.trace("<" + this + " LangSetter setDwh> newdw: " + newdw, 0);
      application.trace("<" + this + " LangSetter setDwh> newdh: " + newdh, 0);
      application.trace("<" + this + " LangSetter setDwh> do nothing.", 1);
    }
    /**
     * The list picker has been resized, so this object takes its dimensions.
     * @param e the dimensions changed event of the list picker
     */
    private function listPickerDimensionsChanged(e:Event):void
    {
      application.trace("<" + this + " LangSetter listPickerDimensionsChanged> called.", 1);
      application.trace("<" + this + " LangSetter listPickerDimensionsChanged> e: " + e, 0);
      super.setDwh(listPicker.getDw(), listPicker.getDh());
    }
    /**
     * A language has been picked, so the whole application changes into it.
     * @param e the changed event of the list picker
     */
    private function listPickerChanged(e:Event):void
    {
      application.trace("<" + this + " LangSetter listPickerChanged> called.", 1);
      application.trace("<" + this + " LangSetter listPickerChanged> e: " + e, 0);
      // the value of the picked item is asked for instead of an index of a list of the
      // languages: such a list could hold another language on that very index by now
      const langCode:String = listPicker.getSelectedValue();
      if (langCode != "")
      {
        application.getLabelManager().setLang(langCode);
        if (application.getMiddleground() != null)
        {
          application.getMiddleground().closePanelSettings();
        }
      }
    }
    /**
     * The language of the application has been changed, this object displays that one.
     * @param e the language changed event
     */
    private function langChanged(e:Event):void
    {
      application.trace("<" + this + " LangSetter langChanged> called.", 1);
      application.trace("<" + this + " LangSetter langChanged> e: " + e, 0);
      // the language of the application is the new one already, so this is a silent
      // selection: a loud one would be taken as a language picked by the one using it
      listPicker.setSelectedIndex(application.getLabelManager().getKeysLang()
          .indexOf(application.getLabelManager().getLang()), false);
    }
    /**
     * Destroys this object and frees up everything.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " LangSetter destroy> called.", 1);
      application.trace("<" + this + " LangSetter destroy> 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher().", 0);
      application.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_LANG_CHANGED(), langChanged);
      application.trace("<" + this + " LangSetter destroy> 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      application.trace("<" + this + " LangSetter destroy> 3: calling the super destroy.", 0);
      // the step 4 is logged before the super destroy on purpose: that one clears the
      // application reference of this object, so nothing can be traced after it
      application.trace("<" + this + " LangSetter destroy> 4: every reference and value should be reset to null, 0 or false.", 0);
      super.destroy();
      listPicker = null;
    }
  }
}
