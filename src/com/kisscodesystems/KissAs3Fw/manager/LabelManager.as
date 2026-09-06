/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 * https://github.com/kisscodesystems/KissAs3Mp
 * DESCRIPTION:
 * LabelManager.
 * This is the store of the displayable labels of the application.
 * - single labels and lists of label keys can be stored
 * - the labels come from the language xml file embedded below
 * - the xml is validated against http://app1.kisscodesystems.com/kcsops/KissAs3FwLabels.xsd
 */
package com.kisscodesystems.KissAs3Fw.manager
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBackgroundAligns;
  import com.kisscodesystems.KissAs3Fw.enum.EnumBoxFrames;
  import com.kisscodesystems.KissAs3Fw.enum.EnumDisplayingStyles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumLanguages;
  import com.kisscodesystems.KissAs3Fw.enum.EnumMonths;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import com.kisscodesystems.KissAs3Fw.enum.EnumRoles;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextKeys;
  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWeekdays;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWidgetModes;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.enum.EnumYesNo;
  import flash.events.Event;
  import flash.system.System;
  import flash.utils.ByteArray;
  public class LabelManager
  {
    [Embed(source = "../resource/label/KissAs3FwLabels.xml" , mimeType = "application/octet-stream")]
    private var EmbeddedLabels:Class;
    private var embeddedLabelsByteArray:ByteArray = new EmbeddedLabels() as ByteArray;
    private var embeddedLabelsString:String = embeddedLabelsByteArray.toString();
    private var xmlLabels:XML = null;
    protected var application:Application = null;
    protected var labels:Array = new Array();
    protected var langs:Array = new Array();
    protected var keys:Array = new Array();
    private var lang:String = null;
    private var eventLangChanged:Event = null;
    protected var keysYesNo:Array = null;
    protected var keysOkCancel:Array = null;
    protected var keysBgImageAligns:Array = null;
    protected var keysBoxFrames:Array = null;
    protected var keysTextTypes:Array = null;
    protected var keysOrientations:Array = null;
    protected var keysDisplayingStyles:Array = null;
    protected var keysRoles:Array = null;
    protected var keysWeekdays:Array = null;
    // The weekdays of this array start with sunday, so the day index of a date object
    // points to its own weekday in it.
    protected var keysWeekdaysFromSunday:Array = null;
    protected var keysMonths:Array = null;
    protected var keysWidgetModes:Array = null;
    protected var keysWatchTypes:Array = null;
    /**
     * Constructs the label manager, sets the default language and parses the embedded labels.
     * @param applicationRef the application reference
     */
    public function LabelManager(applicationRef:Application):void
    {
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " LabelManager> called.", 1);
      application.trace("<" + this + " LabelManager> applicationRef: " + applicationRef, 0);
      eventLangChanged = new Event(EnumEvents.EVENT_LANG_CHANGED());
      setLangToDefault();
      setKeyArraysToDefault();
      parseLabels();
      application.trace("<" + this + " LabelManager> constructed.", 1);
    }
    /**
     * Sets the current language and dispatches the language changed event when it changes.
     * @param newLang the new language key
     */
    public function setLang(newLang:String):void
    {
      application.trace("<" + this + " LabelManager setLang> called.", 1);
      application.trace("<" + this + " LabelManager setLang> newLang: " + newLang, 0);
      // the language is set again even when it is the same one while there is no panel
      // of the settings: the object asking for it has no other way to be refreshed
      if (application.getComponentsConfig().getPanelSettingsEnabled() && lang == newLang)
      {
        application.trace("<" + this + " LabelManager setLang> this is the current language already.", 0);
        return;
      }
      const langOrig:String = lang;
      // an unknown language is answered with the first known one
      lang = langs.indexOf(newLang) != -1 ? newLang : langs[0];
      if (lang != langOrig)
      {
        application.trace("<" + this + " LabelManager setLang> the language has been changed to: " + lang, 0);
        application.getBaseEventDispatcher().dispatchEvent(eventLangChanged);
      }
    }
    /**
     * Returns the current language key.
     */
    public function getLang():String
    {
      return lang;
    }
    /**
     * Returns the label of the given key in the current language.
     * @param key the key of the label
     */
    public function getLabel(key:String):String
    {
      application.trace("<" + this + " LabelManager getLabel> called.", 1);
      application.trace("<" + this + " LabelManager getLabel> key: " + key, 0);
      var s:String = "";
      try
      {
        s = labels[key][lang];
        if (s == null)
        {
          s = "";
        }
      }
      catch (e:*)
      {
        s = "";
        application.trace("<" + this + " LabelManager getLabel> unable to get string to " + key + " in language " + lang, 7);
      }
      return s;
    }
    /**
     * Returns a copy of the available language keys.
     */
    public function getKeysLang():Array
    {
      return langs.concat();
    }
    /**
     * Returns the labels of the available language keys in the current language.
     */
    public function getLabelsLang():Array
    {
      return getLabelsFromKeysArray(langs);
    }
    /**
     * Returns a copy of the yes/no keys.
     */
    public function getKeysYesNo():Array
    {
      return keysYesNo.concat();
    }
    /**
     * Returns the labels of the yes/no keys in the current language.
     */
    public function getLabelsYesNo():Array
    {
      return getLabelsFromKeysArray(keysYesNo);
    }
    /**
     * Returns a copy of the ok/cancel keys.
     */
    public function getKeysOkCancel():Array
    {
      return keysOkCancel.concat();
    }
    /**
     * Returns the labels of the ok/cancel keys in the current language.
     */
    public function getLabelsOkCancel():Array
    {
      return getLabelsFromKeysArray(keysOkCancel);
    }
    /**
     * Returns a copy of the background image align keys.
     */
    public function getKeysBgImageAligns():Array
    {
      return keysBgImageAligns.concat();
    }
    /**
     * Returns the labels of the background image align keys in the current language.
     */
    public function getLabelsBgImageAligns():Array
    {
      return getLabelsFromKeysArray(keysBgImageAligns);
    }
    /**
     * Returns a copy of the box frame keys.
     */
    public function getKeysBoxFrames():Array
    {
      return keysBoxFrames.concat();
    }
    /**
     * Returns the labels of the box frame keys in the current language.
     */
    public function getLabelsBoxFrames():Array
    {
      return getLabelsFromKeysArray(keysBoxFrames);
    }
    /**
     * Returns a copy of the text type keys.
     */
    public function getKeysTextTypes():Array
    {
      return keysTextTypes.concat();
    }
    /**
     * Returns the labels of the text type keys in the current language.
     */
    public function getLabelsTextTypes():Array
    {
      return getLabelsFromKeysArray(keysTextTypes);
    }
    /**
     * Returns a copy of the widgets orientation keys.
     */
    public function getKeysOrientations():Array
    {
      return keysOrientations.concat();
    }
    /**
     * Returns the labels of the widgets orientation keys in the current language.
     */
    public function getLabelsOrientations():Array
    {
      return getLabelsFromKeysArray(keysOrientations);
    }
    /**
     * Returns a copy of the displaying style keys.
     */
    public function getKeysDisplayingStyles():Array
    {
      return keysDisplayingStyles.concat();
    }
    /**
     * Returns the labels of the displaying style keys in the current language.
     */
    public function getLabelsDisplayingStyles():Array
    {
      return getLabelsFromKeysArray(keysDisplayingStyles);
    }
    /**
     * Returns a copy of the role keys.
     */
    public function getKeysRoles():Array
    {
      return keysRoles.concat();
    }
    /**
     * Returns the labels of the role keys in the current language.
     */
    public function getLabelsRoles():Array
    {
      return getLabelsFromKeysArray(keysRoles);
    }
    /**
     * Returns a copy of the weekday keys.
     */
    public function getKeysWeekdays():Array
    {
      return keysWeekdays.concat();
    }
    /**
     * Returns the labels of the weekday keys in the current language.
     */
    public function getLabelsWeekdays():Array
    {
      return getLabelsFromKeysArray(keysWeekdays);
    }
    /**
     * Returns a copy of the weekday keys, starting with sunday. The day index of a date
     * object points to its own weekday in this array, so no shifting is needed at all.
     */
    public function getKeysWeekdaysFromSunday():Array
    {
      return keysWeekdaysFromSunday.concat();
    }
    /**
     * Returns the labels of the weekday keys in the current language, starting with sunday.
     */
    public function getLabelsWeekdaysFromSunday():Array
    {
      return getLabelsFromKeysArray(keysWeekdaysFromSunday);
    }
    /**
     * Returns a copy of the month keys.
     */
    public function getKeysMonths():Array
    {
      return keysMonths.concat();
    }
    /**
     * Returns the labels of the month keys in the current language.
     */
    public function getLabelsMonths():Array
    {
      return getLabelsFromKeysArray(keysMonths);
    }
    /**
     * Returns a copy of the widget mode keys.
     */
    public function getKeysWidgetModes():Array
    {
      return keysWidgetModes.concat();
    }
    /**
     * Returns the labels of the widget mode keys in the current language.
     */
    public function getLabelsWidgetModes():Array
    {
      return getLabelsFromKeysArray(keysWidgetModes);
    }
    /**
     * Returns a copy of the watch type keys, in the order the Watch displays them.
     */
    public function getKeysWatchTypes():Array
    {
      return keysWatchTypes.concat();
    }
    /**
     * Returns the labels of the watch type keys in the current language.
     */
    public function getLabelsWatchTypes():Array
    {
      return getLabelsFromKeysArray(keysWatchTypes);
    }
    /**
     * Sets the current language to the default one.
     */
    protected function setLangToDefault():void
    {
      application.trace("<" + this + " LabelManager setLangToDefault> called.", 1);
      lang = EnumLanguages.EN();
      application.trace("<" + this + " LabelManager setLangToDefault> now lang is: " + lang, 0);
    }
    /**
     * Parses the given label xml into the keys, langs and labels stores.
     * @param aXml the label xml to parse
     */
    protected function getLabelsFromXml(aXml:XML):void
    {
      application.trace("<" + this + " LabelManager getLabelsFromXml> called.", 1);
      application.trace("<" + this + " LabelManager getLabelsFromXml> aXml: " + aXml, 0);
      /*
          <labelgroup name="Labels of KissAs3Fw">        a
            <labels key="HU">                              b
              <label lang="EN">Hungarian</label>             c
            </labels>
          </labelgroup>
      */
      const aXmlList:XMLList = new XMLList(aXml.children());
      application.trace("<" + this + " LabelManager getLabelsFromXml> Parsing labels: " + aXml.@name, 0);
      application.trace("<" + this + " LabelManager getLabelsFromXml> Count of labels: " + aXmlList.length(), 0);
      var key:String = "";
      var lang:String = "";
      var label:String = "";
      var bXmlList:XMLList = null;
      var iteration:int = 0;
      for each (var bXml:XML in aXmlList)
      {
        key = "[" + bXml.@key + "]";
        if (iteration == 0)
        {
          application.trace("<" + this + " LabelManager getLabelsFromXml> key: " + key, 0);
        }
        if (keys.indexOf(key) == -1)
        {
          keys.push(key);
        }
        if (labels[key] == undefined)
        {
          labels[key] = new Array();
        }
        bXmlList = bXml.children();
        for each (var cXml:XML in bXmlList)
        {
          lang = "[" + cXml.@lang + "]";
          if (iteration == 0)
          {
            application.trace("<" + this + " LabelManager getLabelsFromXml>   lang: " + lang, 0);
          }
          if (langs.indexOf(lang) == -1)
          {
            langs.push(lang);
          }
          label = cXml.text();
          if (iteration == 0)
          {
            application.trace("<" + this + " LabelManager getLabelsFromXml>   ->label: " + label, 0);
          }
          labels[key][lang] = label;
        }
        iteration ++;
      }
      application.trace("<" + this + " LabelManager getLabelsFromXml> parsing done.", 0);
      checkParsedLabels();
    }
    /**
     * Returns the labels belonging to the given keys array in the current language.
     * @param keys the array of label keys
     */
    protected function getLabelsFromKeysArray(keys:Array):Array
    {
      application.trace("<" + this + " LabelManager getLabelsFromKeysArray> called.", 1);
      application.trace("<" + this + " LabelManager getLabelsFromKeysArray> keys: " + keys, 0);
      const l:Array = new Array();
      if (keys != null)
      {
        for (var i:int = 0; i < keys.length; i++)
        {
          try
          {
            l.push(labels[keys[i]][lang]);
          }
          catch (e:*)
          {
            l.push("");
          }
        }
      }
      return l;
    }
    /**
     * Sets every key array to its default set of enum values. An application extending
     * this class overrides this one, calls the super and then assigns the arrays it
     * brings values of its own to: the displaying styles of that application are named
     * in an enum of its own, so this is the place their keys are offered from.
     */
    protected function setKeyArraysToDefault():void
    {
      application.trace("<" + this + " LabelManager setKeyArraysToDefault> called.", 1);
      keysYesNo = [EnumYesNo.YN_YES(), EnumYesNo.YN_NO()];
      keysOkCancel = [EnumOkCancel.OC_OK(), EnumOkCancel.OC_CANCEL()];
      keysBgImageAligns = [EnumBackgroundAligns.BACKGROUND_ALIGN_NONE(), EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER1(), EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER2(), EnumBackgroundAligns.BACKGROUND_ALIGN_CENTER3(), EnumBackgroundAligns.BACKGROUND_ALIGN_MOSAIC()];
      keysBoxFrames = [EnumBoxFrames.BOX_FRAME_FULL(), EnumBoxFrames.BOX_FRAME_HORIZONTAL(), EnumBoxFrames.BOX_FRAME_VERTICAL(), EnumBoxFrames.BOX_FRAME_NONE()];
      keysTextTypes = [EnumTextTypes.TEXT_TYPE_BRIGHT(), EnumTextTypes.TEXT_TYPE_MID(), EnumTextTypes.TEXT_TYPE_DARK()];
      keysOrientations = [EnumOrientations.ORIENTATION_MANUAL(), EnumOrientations.ORIENTATION_VERTICAL(), EnumOrientations.ORIENTATION_HORIZONTAL()];
      keysDisplayingStyles = EnumDisplayingStyles.getEveryDisplayingStyle();
      keysRoles = [EnumRoles.ROLE_GUEST()];
      keysWeekdays = [EnumWeekdays.WEEKDAY_MONDAY(), EnumWeekdays.WEEKDAY_TUESDAY(), EnumWeekdays.WEEKDAY_WEDNESDAY(), EnumWeekdays.WEEKDAY_THURSDAY(), EnumWeekdays.WEEKDAY_FRIDAY(), EnumWeekdays.WEEKDAY_SATURDAY(), EnumWeekdays.WEEKDAY_SUNDAY()];
      keysWeekdaysFromSunday = [EnumWeekdays.WEEKDAY_SUNDAY(), EnumWeekdays.WEEKDAY_MONDAY(), EnumWeekdays.WEEKDAY_TUESDAY(), EnumWeekdays.WEEKDAY_WEDNESDAY(), EnumWeekdays.WEEKDAY_THURSDAY(), EnumWeekdays.WEEKDAY_FRIDAY(), EnumWeekdays.WEEKDAY_SATURDAY()];
      keysMonths = [EnumMonths.MONTH_JAN(), EnumMonths.MONTH_FEB(), EnumMonths.MONTH_MAR(), EnumMonths.MONTH_APR(), EnumMonths.MONTH_MAY(), EnumMonths.MONTH_JUN(), EnumMonths.MONTH_JUL(), EnumMonths.MONTH_AUG(), EnumMonths.MONTH_SEP(), EnumMonths.MONTH_OKT(), EnumMonths.MONTH_NOV(), EnumMonths.MONTH_DEC()];
      keysWidgetModes = [EnumWidgetModes.WIDGET_MODE_AUTOMATIC(), EnumWidgetModes.WIDGET_MODE_DESKTOP(), EnumWidgetModes.WIDGET_MODE_MOBILE()];
      keysWatchTypes = [EnumTextKeys.WATCH_TYPE_BASIC(), EnumTextKeys.WATCH_TYPE_DIGITAL(), EnumTextKeys.WATCH_TYPE_ANALOG(), EnumTextKeys.WATCH_TYPE_BINARY()];
    }
    /**
     * Parses the embedded label xml string.
     */
    private function parseLabels():void
    {
      application.trace("<" + this + " LabelManager parseLabels> called.", 1);
      try
      {
        xmlLabels = new XML(embeddedLabelsString);
        getLabelsFromXml(xmlLabels);
      }
      catch (e:*)
      {
        application.trace("<" + this + " LabelManager parseLabels> Unable to parse label xml: " + e, 7);
      }
    }
    /**
     * Checks the parsed labels and logs the undefined or empty ones.
     */
    private function checkParsedLabels():void
    {
      application.trace("<" + this + " LabelManager checkParsedLabels> called.", 1);
      for (var i:int = 0; i < keys.length; i++)
      {
        for (var j:int = 0; j < langs.length; j++)
        {
          if (labels[keys[i]] == undefined)
          {
            application.trace("<" + this + " LabelManager checkParsedLabels> Undefined label found. key: " + keys[i], 6);
          }
          else
          {
            if (labels[keys[i]][langs[j]] == undefined)
            {
              application.trace("<" + this + " LabelManager checkParsedLabels> Undefined label found. key: " + keys[i] + ", lang: " + langs[j], 6);
            }
            if (labels[keys[i]][langs[j]] == "")
            {
              application.trace("<" + this + " LabelManager checkParsedLabels> Empty label found. key: " + keys[i] + ", lang: " + langs[j], 6);
            }
          }
        }
      }
      application.trace("<" + this + " LabelManager checkParsedLabels> checking done.", 0);
    }
    /**
     * Frees up everything and destroys this object.
     */
    public function destroy():void
    {
      application.trace("<" + this + " LabelManager destroy> called.", 1);
      eventLangChanged.stopImmediatePropagation();
      embeddedLabelsByteArray.clear();
      xmlLabels = null;
      embeddedLabelsByteArray = null;
      embeddedLabelsString = null;
      labels = null;
      langs = null;
      keys = null;
      lang = null;
      eventLangChanged = null;
      keysYesNo = null;
      keysOkCancel = null;
      keysBgImageAligns = null;
      keysBoxFrames = null;
      keysTextTypes = null;
      keysOrientations = null;
      keysDisplayingStyles = null;
      keysRoles = null;
      keysWeekdays = null;
      keysWeekdaysFromSunday = null;
      keysMonths = null;
      keysWidgetModes = null;
      keysWatchTypes = null;
      application = null;
    }
  }
}
