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
** Icon.
** Contains several embedded icon to display to the user.
**
** MAIN FEATURES:
** - embedded transparent icons.
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . events . Event ;
  public class Icon extends BaseSprite
  {
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Icon ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
    }
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
package com.thehobbypianist.ui
{
/*
*
     * ...
     * @author jozsef.kiss@thehobbypianist.com
    import com.thehobbypianist.custom.CustomSprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    public class Icon extends CustomSprite
    {
        private var type            :String;
        private var iconGlowFilter  :GlowFilter;
        private var matrix          :Matrix;
        private var bitmapData      :BitmapData;
        private var bitmapRef       :Bitmap;
        private var max             :int;
        private var loadedEvent     :Event;
        private var failedEvent     :Event;
        public function Icon()
        {
            type = "";
            max = 0;
        }
        override protected function addedToStage(e:Event):void
        {
            super.addedToStage(e);
            loadedEvent = new Event(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_SUCCESS);
            failedEvent = new Event(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_FAIL);
            stage.addEventListener(Preloader(root).getEvs().EVENT_ACTUAL_SKIN_CHANGED, actualSkinChanged, false, 0, true);
        }
        private function actualSkinChanged(e:Event):void
        {
            paint();
        }
        public function setType(s:String):void
        {
            type = s;
            paint();
        }
        private function paint(e:Event = null):void
        {
            if (stage != null && max != 0)
            {
                if (stage.hasEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_SUCCESS + type))
                    stage.removeEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_SUCCESS + type, paint);
                if (stage.hasEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_FAIL + type))
                    stage.removeEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_FAIL + type, noPaint);
                if (filters != null)
                    filters.splice(0);
                graphics.clear();
                matrix = new Matrix();
                bitmapData = new BitmapData(max, max);
                if (type == "user")
                    bitmapRef = Preloader(root).getIcs().getUser();
                else if (type == "userfema")
                    bitmapRef = Preloader(root).getIcs().getUserfema();
                else if (type == "ok")
                    bitmapRef = Preloader(root).getIcs().getOk();
                else if (type == "cancel")
                    bitmapRef = Preloader(root).getIcs().getCancel();
                else if (type == "login")
                    bitmapRef = Preloader(root).getIcs().getLogin();
                else if (type == "logout")
                    bitmapRef = Preloader(root).getIcs().getLogout();
                else if (type == "alert")
                    bitmapRef = Preloader(root).getIcs().getAlert();
                else if (type == "info")
                    bitmapRef = Preloader(root).getIcs().getInfo();
                else if (type == "confirm")
                    bitmapRef = Preloader(root).getIcs().getConfirm();
                else if (type == "arrowleft")
                    bitmapRef = Preloader(root).getIcs().getArrowleft();
                else if (type == "arrowright")
                    bitmapRef = Preloader(root).getIcs().getArrowright();
                if (bitmapRef != null)
                {
                    matrix.scale(max / bitmapRef.width, max / bitmapRef.height);
                    bitmapData.draw(bitmapRef.bitmapData, matrix, null, null, null, true);
                    graphics.beginBitmapFill(bitmapData, null, false, true);
                    graphics.drawRoundRect(0, 0, bitmapData.width, bitmapData.height, Preloader(root).getSks().getActualSkin().getRounded() * 2 / 3, Preloader(root).getSks().getActualSkin().getRounded() * 2 / 3);
                    filters = [Preloader(root).getSks().getActualSkin().getIconGlowFilter()];
                    setW(bitmapData.width);
                    setH(bitmapData.height);
                    if (stage != null)
                        stage.dispatchEvent(loadedEvent);
                }
                else
                {
                    stage.addEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_SUCCESS + type, paint, false, 0, true);
                    stage.addEventListener(Preloader(root).getEvs().EVENT_ICON_DOWNLOAD_FAIL + type, noPaint, false, 0, true);
                }
            }
        }
        private function noPaint(e:Event = null):void
        {
            if (stage != null)
                stage.dispatchEvent(failedEvent);
        }
        public function rescale(max:int):void
        {
            this.max = max;
            setW(max);
            setH(max);
            paint();
        }
    }
}
*/