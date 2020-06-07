/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3FwDemos
**
** DESCRIPTION:
** Voter.
** This can be used to make or display voting.
** Uses stars to visualize the rating.
**
** MAIN FEATURES:
** - one click to vote
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  public class Voter extends BaseSprite
  {
/*
** The constructor doing the initialization of this object as usual.
*/
    public function Voter ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
    }
/*
** Override of destroy.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
    }
  }
}
/*
   package com.jocisystems.frameworkflash.ui
   {
   import com.jocisystems.frameworkflash.custom.base._CustomSprite;
   import com.jocisystems.frameworkflash.custom.base._CustomTimer;
   import com.jocisystems.frameworkflash.ui.base._Background;
   import com.jocisystems.frameworkflash.ui.base._Glass;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   public class _Watch extends _CustomSprite
   {
   private var _background             :_Background;
   private var _dateLabel              :_Label;
   private var _timezoneLabel          :_Label;
   private var _glass                  :_Glass;
   private var _h1                     :_CustomSprite;
   private var _h2                     :_CustomSprite;
   private var _m1                     :_CustomSprite;
   private var _m2                     :_CustomSprite;
   private var _s1                     :_CustomSprite;
   private var _s2                     :_CustomSprite;
   private var _c1                     :_CustomSprite;
   private var _c2                     :_CustomSprite;
   private var _elementsArray          :Array;
   private var _digitThickness         :int;
   private var _margin                 :int;
   private var _rectWidth              :int;
   private var _customTimer            :_CustomTimer;
   private var _date                   :Date;
   private var _year                   :String;
   private var _month                  :String;
   private var _day                    :String;
   private var _temps                  :String;
   private var _tempm                  :String;
   private var _temph                  :String;
   private var _now0                   :int;
   private var _now1                   :int;
   private var _watchw                 :int;
   private var _prevGetTimer           :int;
   private var _getTimer               :int;
   private var _serverUTCDate          :Date;
   private var _timezoneOffset         :int;
   private var _timezoneOffsetStr      :String;
   public function _Watch()  { super(); }
   override public function _init():void
   {
   super._init();
   _reset();
   if (stage != null)
   {
   _watchw = 1;
   _elementsArray = new Array(12);
   _elementsArray["_h1"] = new Array(7);
   _elementsArray["_h2"] = new Array(7);
   _elementsArray["_m1"] = new Array(7);
   _elementsArray["_m2"] = new Array(7);
   _elementsArray["_s1"] = new Array(7);
   _elementsArray["_s2"] = new Array(7);
   _date = new Date();
   _timezoneOffset = -_date.getTimezoneOffset();
   _timezoneOffsetStr = Main(root)._getGeneralSettings()._L_TIME_ZONE_OFFSET_SYS;
   _serverUTCDate = new Date(_date.getUTCFullYear(), _date.getUTCMonth(), _date.getUTCDate(), _date.getUTCHours(), _date.getUTCMinutes(), _date.getUTCSeconds(), _date.getUTCMilliseconds());
   _customTimer = new _CustomTimer(1000);
   _digitThickness = Main(root)._getGeneralSettings()._WATCH_DIGIT_THICKNESS;
   _margin = Main(root)._getGeneralSettings()._WATCH_MARGIN;
  _background = new _Background();
  addChild(_background); _background._init();
  _background.visible = false;
  _dateLabel = new _Label();
  _background.addChild(_dateLabel); _dateLabel._init();
  _dateLabel._setText(" ");
  _dateLabel._setTextType(Main(root)._getGeneralSettings()._G_TEXT_TYPE_COMPONENT);
  _timezoneLabel = new _Label();
  _background.addChild(_timezoneLabel); _timezoneLabel._init();
  _timezoneLabel._setText(" ");
  _timezoneLabel._setTextType(Main(root)._getGeneralSettings()._G_TEXT_TYPE_COMPONENT);
  _h1 = new _CustomSprite();
  addChild(_h1); _h1._init();
  _h2 = new _CustomSprite();
  addChild(_h2); _h2._init();
  _c1 = new _CustomSprite();
  addChild(_c1); _c1._init();
  _m1 = new _CustomSprite();
  addChild(_m1); _m1._init();
  _m2 = new _CustomSprite();
  addChild(_m2); _m2._init();
  _c2 = new _CustomSprite();
  addChild(_c2); _c2._init();
  _s1 = new _CustomSprite();
  addChild(_s1); _s1._init();
  _s2 = new _CustomSprite();
  addChild(_s2); _s2._init();
  _glass = new _Glass();
  addChild(_glass); _glass._init();
  stage.addEventListener(Main(root)._getGeneralSettings()._EVENT_ACTUAL_STYLE_CHANGED, _paint);
  _paint();
  addEventListener(MouseEvent.ROLL_OVER, _onRollOver);
  addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
  _prevGetTimer = getTimer();
  if (_customTimer != null)
  {
    _customTimer.addEventListener(TimerEvent.TIMER, _watchWork);
    _customTimer.start();
  }
  }
  }
  private function _reset():void
  {
    _digitThickness = undefined;
    _margin = undefined;
    _rectWidth = undefined;
    _customTimer = null;
    _date = null;
    _year = null;
    _month = null;
    _day = null;
    _temps = null;
    _tempm = null;
    _temph = null;
    _now0 = undefined;
    _now1 = undefined;
    _background = null;
    _dateLabel = null;
    _timezoneLabel = null;
    _h1 = null;
    _h2 = null;
    _m1 = null;
    _m2 = null;
    _s1 = null;
    _s2 = null;
    _c1 = null;
    _c2 = null;
    _elementsArray = null;
    _watchw = undefined;
  }
  private function _paint(e:Event = null):void
  {
    if (stage != null && _date != null)
    {
      _timezoneOffsetStr = Main(root)._getTextSettings()._getTimezones()[Main(root)._getStyleSettings()._getActualStyle()._getTimeZone()].offset
        if (_timezoneOffsetStr == Main(root)._getGeneralSettings()._L_TIME_ZONE_OFFSET_SYS)
        {
          _timezoneOffset = -_date.getTimezoneOffset();
        }
        else
        {
          _timezoneOffset = (_timezoneOffsetStr.substr(0, 1) == Main(root)._getGeneralSettings()._TIME_ZONE_OFFSET_PLUS ? 1 : -1)
            * (int(_timezoneOffsetStr.substr(1, 2)) * 60 + int(_timezoneOffsetStr.substr(3, 2)));
        }
    }
    _calcWidthHeightPositions();
    _makeDigit(_h1, "_h1");
    _makeDigit(_h2, "_h2");
    _makeColon(_c1);
    _c1.alpha = 0;
    _makeDigit(_m1, "_m1");
    _makeDigit(_m2, "_m2");
    _makeColon(_c2);
    _c2.alpha = 0;
    _makeDigit(_s1, "_s1");
    _makeDigit(_s2, "_s2");
    if (_background.visible)
    {
      if (Main(root)._getStyleSettings()._getActualStyle()._getComponentDropShadow())
      {
        _setDropShadowFilter(Number(Main(root)._getStyleSettings()._getActualStyle()._getComponentTF().color));
      }
      else
      {
        _clearDropShadowFilter();
      }
    }
    else
    {
      if (Main(root)._getStyleSettings()._getActualStyle()._getSimpleDropShadow())
      {
        _setDropShadowFilter(Number(Main(root)._getStyleSettings()._getActualStyle()._getSimpleTF().color));
      }
      else
      {
        _clearDropShadowFilter();
      }
    }
  }
  private function _calcWidthHeightPositions():void
  {
    if (_dateLabel != null && _glass != null && _timezoneLabel != null && _background != null && _h1 != null && _h2 != null && _c1 != null && _m1 != null && _m2 != null && _c2 != null && _s1 != null && _s2 != null)
    {
      _setH(Main(root)._getStyleSettings()._getActualStyle()._getSimpleTextFieldHeight() + 2 * Main(root)._getStyleSettings()._getActualStyle()._getComponentPadding());
      _rectWidth  = (_getH() - 4 * _margin) / 2;
      _background._setH(_getH() * 3);
      _background._move(0, 0);
      _watchw = _rectWidth * 6 + _digitThickness * 2 + 7 * _margin + 2 * Main(root)._getStyleSettings()._getActualStyle()._getComponentPadding();
      _setW(Math.max(_watchw, _dateLabel._getW(), _timezoneLabel._getW()));
      _glass._setW(_getW());
      _glass._setH(_getH());
      _glass._move(0, 0);
      _background._setW(_getW());
      _timezoneLabel._move((_getW() - _timezoneLabel._getW()) / 2, _getH());
      _dateLabel._move((_getW() - _dateLabel._getW()) / 2, _getH() * 2);
      _h1.x = Math.max(Main(root)._getStyleSettings()._getActualStyle()._getComponentPadding(), (_getW() - _watchw) / 2);
      _h1.y = 2 * _margin;
      _h2.x = _h1.x + _rectWidth + _margin;
      _h2.y = _h1.y;
      _c1.x = _h2.x + _rectWidth + _margin;
      _c1.y = _h1.y;
      _m1.x = _c1.x + _digitThickness + _margin;
      _m1.y = _h1.y;
      _m2.x = _m1.x + _rectWidth + _margin;
      _m2.y = _h1.y;
      _c2.x = _m2.x + _rectWidth + _margin;
      _c2.y = _h1.y;
      _s1.x = _c2.x + _digitThickness + _margin;
      _s1.y = _h1.y;
      _s2.x = _s1.x + _rectWidth + _margin;
      _s2.y = _h1.y;
    }
  }
  private function _setDropShadowFilter(color:Number):void
  {
    if (stage != null && _h1 != null && _h2 != null && _c1 != null && _m1 != null && _m2 != null && _c2 != null && _s1 != null && _s2 != null)
    {
      if (color > Main(root)._getGeneralSettings()._TEXT_LIGHT_DARK_CHANGE_BOUND)
      {
        _h1.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _h2.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _c1.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _m1.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _m2.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _c2.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _s1.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
        _s2.filters = [Main(root)._getGeneralSettings()._TEXT_DARK_DROP_SHADOW];
      }
      else
      {
        _h1.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _h2.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _c1.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _m1.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _m2.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _c2.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _s1.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
        _s2.filters = [Main(root)._getGeneralSettings()._TEXT_LIGHT_DROP_SHADOW];
      }
    }
  }
  private function _clearDropShadowFilter():void
  {
    if (_h1 != null && _h2 != null && _c1 != null && _m1 != null && _m2 != null && _c2 != null && _s1 != null && _s2 != null)
    {
      _h1.filters = undefined;
      _h2.filters = undefined;
      _c1.filters = undefined;
      _m1.filters = undefined;
      _m2.filters = undefined;
      _c2.filters = undefined;
      _s1.filters = undefined;
      _s2.filters = undefined;
    }
  }
  private function _watchWork(e:TimerEvent):void
  {
    if (stage != null && _date != null && _serverUTCDate != null)
    {
      _getTimer = getTimer();
      _serverUTCDate.setMilliseconds(_serverUTCDate.getMilliseconds() + _getTimer - _prevGetTimer);
      _date.setFullYear(_serverUTCDate.getFullYear(), _serverUTCDate.getMonth(), _serverUTCDate.getDate());
      _date.setHours(_serverUTCDate.getHours(), _serverUTCDate.getMinutes() + _timezoneOffset, _serverUTCDate.getSeconds(), _serverUTCDate.getMilliseconds());
      _prevGetTimer = _getTimer;
      _temps = String(_date.getSeconds());
      if (_temps.length == 1) _temps = "0" + _temps;
      _tempm = String(_date.getMinutes());
      if (_tempm.length == 1) _tempm = "0" + _tempm;
      _temph = String(_date.getHours());
      if (_temph.length == 1) _temph = "0" + _temph;
      _witeDigit("_h1", _temph.substr(0, 1));
      _witeDigit("_h2", _temph.substr(1, 1));
      _witeDigit("_m1", _tempm.substr(0, 1));
      _witeDigit("_m2", _tempm.substr(1, 1));
      _disappearColon2();
      _witeDigit("_s1", _temps.substr(0, 1));
      _witeDigit("_s2", _temps.substr(1, 1));
      if (_c1.alpha == 0)
      {
        _c1.alpha = 1;
      }
      _year = String(_date.getFullYear());
      _month = String(_date.getMonth() + 1);
      if (_month.length == 1) _month = "0" + _month;
      _day = String(_date.getDate());
      if (_day.length == 1) _day = "0" + _day;
      if (_dateLabel != null)
      {
        _dateLabel._setText(Main(root)._getStyleSettings()._getActualStyle()._getDateFormat()
            .replace(Main(root)._getGeneralSettings()._DATE_FORMAT_YYYY, _year)
            .replace(Main(root)._getGeneralSettings()._DATE_FORMAT_MM, _month)
            .replace(Main(root)._getGeneralSettings()._DATE_FORMAT_DD, _day));
      }
      if (_timezoneLabel != null)
      {
        _timezoneLabel._setText(Main(root)._getTextSettings()._getTimezones()[Main(root)._getStyleSettings()._getActualStyle()._getTimeZone()].description);
      }
      _calcWidthHeightPositions();
    }
  }
  private function _onRollOut(e:MouseEvent):void
  {
    if (_background != null)
    {
      _background.visible = false;
      _paint();
    }
  }
  private function _onRollOver(e:MouseEvent):void
  {
    if (_background != null)
    {
      _setHighestDepth();
      _background.visible = true;
      _paint();
    }
  }
  private function _disappearColon2():void
  {
    _c2.alpha = 1;
    _now0 = getTimer();
    _now1 = 0;
    if (!_c2.hasEventListener(Event.ENTER_FRAME))
    {
      _c2.addEventListener(Event.ENTER_FRAME, _onEnterFrameColon2);
    }
  }
  private function _onEnterFrameColon2(e:Event):void
  {
    _now1 = getTimer();
    if (_now1 - _now0 > 500)
    {
      if (_c2 != null)
      {
        _c2.removeEventListener(Event.ENTER_FRAME, _onEnterFrameColon2);
        _c2.alpha = 0;
      }
    }
  }
  private function _makeColon(cs:_CustomSprite):void
  {
    if (stage != null && cs != null && _background != null)
    {
      cs.graphics.clear();
      cs.graphics.beginFill(_background.visible ? Main(root)._getStyleSettings()._getActualStyle()._getComponentFontColor() : Main(root)._getStyleSettings()._getActualStyle()._getSimpleFontColor(), 1);
      cs.graphics.moveTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3);
      cs.graphics.lineTo(_digitThickness, (_rectWidth * 2 - _digitThickness * 2) / 3);
      cs.graphics.lineTo(_digitThickness, (_rectWidth * 2 - _digitThickness * 2) / 3 + _digitThickness);
      cs.graphics.lineTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3 + _digitThickness);
      cs.graphics.lineTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3);
      cs.graphics.endFill();
      cs.graphics.beginFill(_background.visible ? Main(root)._getStyleSettings()._getActualStyle()._getComponentFontColor() : Main(root)._getStyleSettings()._getActualStyle()._getSimpleFontColor(), 1);
      cs.graphics.moveTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3 * 2 + _digitThickness);
      cs.graphics.lineTo(_digitThickness, (_rectWidth * 2 - _digitThickness * 2) / 3 * 2 + _digitThickness);
      cs.graphics.lineTo(_digitThickness, (_rectWidth * 2 - _digitThickness * 2) / 3 * 2 + _digitThickness + _digitThickness);
      cs.graphics.lineTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3 * 2 + _digitThickness + _digitThickness);
      cs.graphics.lineTo(0, (_rectWidth * 2 - _digitThickness * 2) / 3 * 2 + _digitThickness);
      cs.graphics.endFill();
    }
  }
  private function _makeDigitPiece(cs:_CustomSprite):void
  {
    if (stage != null && cs != null && _background != null)
    {
      cs.graphics.clear();
      cs.graphics.beginFill(_background.visible ? Main(root)._getStyleSettings()._getActualStyle()._getComponentFontColor() : Main(root)._getStyleSettings()._getActualStyle()._getSimpleFontColor(), 1);
      cs.graphics.moveTo(0, _digitThickness / 2);
      cs.graphics.lineTo(_digitThickness / 2, 0);
      cs.graphics.lineTo(_rectWidth - _digitThickness / 2, 0);
      cs.graphics.lineTo(_rectWidth, _digitThickness / 2);
      cs.graphics.lineTo(_rectWidth - _digitThickness / 2, _digitThickness);
      cs.graphics.lineTo(_digitThickness / 2, _digitThickness);
      cs.graphics.lineTo(0, _digitThickness / 2);
      cs.graphics.endFill();
    }
  }
  private function _makeDigit(cs_:_CustomSprite, cs:String, disappearOnly:Boolean = false):void
  {
    if (_elementsArray[cs]["e1"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e1"]);
      _elementsArray[cs]["e1"] = null;
    }
    if (_elementsArray[cs]["e2"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e2"]);
      _elementsArray[cs]["e2"] = null;
    }
    if (_elementsArray[cs]["e3"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e3"]);
      _elementsArray[cs]["e3"] = null;
    }
    if (_elementsArray[cs]["e4"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e4"]);
      _elementsArray[cs]["e4"] = null;
    }
    if (_elementsArray[cs]["e5"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e5"]);
      _elementsArray[cs]["e5"] = null;
    }
    if (_elementsArray[cs]["e6"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e6"]);
      _elementsArray[cs]["e6"] = null;
    }
    if (_elementsArray[cs]["e7"] != null)
    {
      cs_.removeChild(_elementsArray[cs]["e7"]);
      _elementsArray[cs]["e7"] = null;
    }
    if (!disappearOnly)
    {
      _elementsArray[cs]["e1"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e1"]);
      _makeDigitPiece(_elementsArray[cs]["e1"]);
      _elementsArray[cs]["e1"].x = 0;
      _elementsArray[cs]["e1"].y = 0;
      _elementsArray[cs]["e2"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e2"]);
      _makeDigitPiece(_elementsArray[cs]["e2"]);
      _elementsArray[cs]["e2"].rotation = 90;
      _elementsArray[cs]["e2"].x = _digitThickness;
      _elementsArray[cs]["e2"].y = 0;
      _elementsArray[cs]["e3"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e3"]);
      _makeDigitPiece(_elementsArray[cs]["e3"]);
      _elementsArray[cs]["e3"].rotation = 90;
      _elementsArray[cs]["e3"].x = _rectWidth;
      _elementsArray[cs]["e3"].y = 0;
      _elementsArray[cs]["e4"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e4"]);
      _makeDigitPiece(_elementsArray[cs]["e4"]);
      _elementsArray[cs]["e4"].x = 0;
      _elementsArray[cs]["e4"].y = _rectWidth - _digitThickness / 2 - 1;
      _elementsArray[cs]["e5"]= new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e5"]);
      _makeDigitPiece(_elementsArray[cs]["e5"]);
      _elementsArray[cs]["e5"].rotation = 90;
      _elementsArray[cs]["e5"].x = _digitThickness;
      _elementsArray[cs]["e5"].y = _rectWidth - _digitThickness / 2 - 1;
      _elementsArray[cs]["e6"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e6"]);
      _makeDigitPiece(_elementsArray[cs]["e6"]);
      _elementsArray[cs]["e6"].rotation = 90;
      _elementsArray[cs]["e6"].x = _rectWidth;
      _elementsArray[cs]["e6"].y = _rectWidth - _digitThickness / 2 - 1;
      _elementsArray[cs]["e7"] = new _CustomSprite();
      cs_.addChild(_elementsArray[cs]["e7"]);
      _makeDigitPiece(_elementsArray[cs]["e7"]);
      _elementsArray[cs]["e7"].x = 0;
      _elementsArray[cs]["e7"].y = _rectWidth * 2 - _digitThickness - 2;
      _CustomSprite(_elementsArray[cs]["e1"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e2"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e3"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e4"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e6"]).alpha = 0;
      _CustomSprite(_elementsArray[cs]["e7"]).alpha = 0;
    }
  }
  private function _witeDigit(cs:String, number:String):void
  {
    switch (number)
    {
      case "0":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "1":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 0;
        break;
      case "2":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "3":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "4":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 0;
        break;
      case "5":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "6":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "7":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 0;
        break;
      case "8":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      case "9":
        _CustomSprite(_elementsArray[cs]["e1"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e2"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e3"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e4"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e5"]).alpha = 0;
        _CustomSprite(_elementsArray[cs]["e6"]).alpha = 1;
        _CustomSprite(_elementsArray[cs]["e7"]).alpha = 1;
        break;
      default:
        break;
    }
  }
  override public function _dest():void
  {
    stage.removeEventListener(Main(root)._getGeneralSettings()._EVENT_ACTUAL_STYLE_CHANGED, _paint);
    removeEventListener(MouseEvent.ROLL_OVER, _onRollOver);
    removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
    if (_customTimer != null)
    {
      _customTimer.stop();
      _customTimer.removeEventListener(TimerEvent.TIMER, _watchWork);
    }
    if (_c2 != null)
      _c2.removeEventListener(Event.ENTER_FRAME, _onEnterFrameColon2);
    if (_background != null)
    {
      if (_dateLabel != null)
        _background.removeChild(_dateLabel);
      if (_timezoneLabel != null)
        _background.removeChild(_timezoneLabel);
      removeChild(_background);
    }
    _makeDigit(_h1, "_h1", true);
    _makeDigit(_h2, "_h2", true);
    _makeDigit(_m1, "_m1", true);
    _makeDigit(_m2, "_m2", true);
    _makeDigit(_s1, "_s1", true);
    _makeDigit(_s2, "_s2", true);
    if (_h1 != null)
      removeChild(_h1);
    if (_h2 != null)
      removeChild(_h2);
    if (_m1 != null)
      removeChild(_m1);
    if (_m2 != null)
      removeChild(_m2);
    if (_s1 != null)
      removeChild(_s1);
    if (_s2 != null)
      removeChild(_s2);
    if (_c1 != null)
      removeChild(_c1);
    if (_c2 != null)
      removeChild(_c2);
    _reset();
    super._dest();
  }
  }
}
*/