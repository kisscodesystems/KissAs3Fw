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
 * Utils.
 * Set of utility functions.
 */
package com.kisscodesystems.KissAs3Fw.util
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.system.System;
  public class Utils
  {
    protected var application:Application = null;
    public function Utils(applicationRef:Application):void
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
    }
    public function getSumOfDigits(theInt:int):int
    {
      var sum:int = 0;
      const str:String = "" + theInt;
      const max:int = str.length;
      for (var i:int = 0; i < max; i++)
      {
        sum += parseInt(str.substr(i, 1));
      }
      return sum;
    }
    public function isValidInt(theInt:int):Boolean
    {
      if (theInt > 9)
      {
        var tempInt:String = "" + theInt;
        tempInt = tempInt.substr(0, tempInt.length - 1);
        const tempInt2:int = getSumOfDigits(parseInt(tempInt)) % 10;
        return theInt == parseInt(tempInt) * 10 + tempInt2;
      }
      return false;
    }
    public function brightShadowToApply(color:String):Boolean
    {
      // the bound comes from the config: it is the very value that decides whether the
      // application counts as a dark one, so it must not be coded into this class
      const TEXT_BRIGHT_DARK_CHANGE_BOUND:int = application.getComponentsConfig().getTextBrightDarkChangeBound();
      var bright:Boolean = false;
      var tempString:String = application.getComponentsConfig().getColorRgbInputZeros() + color;
      tempString = tempString.substr(tempString.length - 6).toUpperCase();
      if (Number(application.getComponentsConfig().getColorHexToNumberString() + tempString.substr(0, 2)) < TEXT_BRIGHT_DARK_CHANGE_BOUND && Number(application.getComponentsConfig().getColorHexToNumberString() + tempString.substr(2, 2)) < TEXT_BRIGHT_DARK_CHANGE_BOUND && Number(application.getComponentsConfig().getColorHexToNumberString() + tempString.substr(4, 2)) < TEXT_BRIGHT_DARK_CHANGE_BOUND)
      {
        bright = true;
      }
      return bright;
    }
    public function colorToString(color:Number):String
    {
      const tempString:String = application.getComponentsConfig().getColorRgbInputZeros() + color.toString(16);
      return (tempString.substr(tempString.length - 6).toUpperCase());
    }
    public function secondsToDisplayedTime(s:int):String
    {
      const hours:int = Math.floor(s / 3600);
      const minutes:int = Math.floor((s - 3600 * hours) / 60);
      const seconds:int = s - 60 * minutes - 3600 * hours;
      return "" + (hours == 0 ? "" : hours + ":") + (hours == 0 ? minutes : (minutes <= 9 ? "0" : "") + minutes) + ":" + (seconds <= 9 ? "0" : "") + seconds;
    }
    public function trim(str:String):String
    {
      if (str == null)
      {
        return "";
      }
      else
      {
        return str.replace(/^\s+|\s+$/g, "");
      }
    }
    public function createShortText(s:String):String
    {
      if (s == null)
      {
        return "";
      }
      const limit:int = application.getComponentsConfig().getShortTextLimit();
      if (s.length <= limit)
      {
        return "" + s;
      }
      // the text is cut at the last whole word that still fits into the limit, and
      // at the limit itself when there is no space to cut it at
      const lastSpacePos:int = s.lastIndexOf(" ", limit);
      const ending:String = application.getComponentsConfig().getShortTextEnding();
      if (lastSpacePos == -1)
      {
        return s.substr(0, limit) + ending;
      }
      return s.substr(0, lastSpacePos) + ending;
    }
    public function getDateFromTime(t:String):Date
    {
      var date:Date = null;
      if (t == null)
      {
        date = new Date();
        return date;
      }
      else
      {
        const orig:String = trim(t);
        var yyyy:String = "";
        var mm:String = "";
        var dd:String = "";
        var hh24:String = "";
        var mi:String = "";
        var ss:String = "";
        if (t.length >= 4)
        {
          yyyy = t.substr(0, 4);
        }
        if (t.length >= 7)
        {
          mm = t.substr(5, 2);
        }
        if (t.length >= 10)
        {
          dd = t.substr(8, 2);
        }
        if (t.length >= 13)
        {
          hh24 = t.substr(11, 2);
        }
        if (t.length >= 16)
        {
          mi = t.substr(14, 2);
        }
        if (t.length >= 19)
        {
          ss = t.substr(17, 2);
        }
        date = new Date(parseInt(yyyy), mm == "" ? 0 : parseInt(mm) - 1, dd == "" ? 0 : parseInt(dd), hh24 == "" ? 0 : parseInt(hh24), mi == "" ? 0 : parseInt(mi), ss == "" ? 0 : parseInt(ss));
        return date;
      }
    }
    public function getRandomInt(i1:int, i2:int):int
    {
      const randomInt:int = i1 + Math.round(Math.random() * (i2 - i1));
      return randomInt;
    }
    public function getRandomGuid():String
    {
      var result:String = "";
      const chars:String = "83b50fd74a9e21c6";
      for (var i:int = 0; i < 36; i++)
      {
        if (i == 8 || i == 13 || i == 18 || i == 23)
        {
          result += "-";
        }
        else
        {
          result += chars.charAt(Math.floor(Math.random() * 16));
        }
      }
      return result;
    }

    /**
     * Frees every reference held by this utility object.
     */
    public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      // 4: every reference and value should be reset to null, 0 or false.
      application = null;
    }
  }
}
