package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import flash . display . BitmapData ;
  public class Icon extends BaseSprite
  {
    private var bitmapData : BitmapData = null ;
    public function Icon ( applicationRef : Application ) : void
    {
      super ( applicationRef ) ;
    }
    public function drawBitmapData ( iconType : String , textType : String , iconSize : int ) : void
    {
      destBitmapData ( ) ;
      bitmapData = application . getIconManager ( ) . getNewBitmapData ( iconType , textType , iconSize ) ;
      if ( bitmapData != null )
      {
        graphics . beginFill ( 0 , 0 ) ;
        graphics . drawRect ( 0 , 0 , iconSize , iconSize ) ;
        graphics . endFill ( ) ;
        graphics . beginBitmapFill ( bitmapData , null , false , true ) ;
        graphics . drawRect ( 0 , 0 , iconSize , iconSize ) ;
        graphics . endFill ( ) ;
      }
      filters = undefined ;
      if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
      {
        setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorMid ( ) ) ;
      }
      else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
      {
        setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorDark ( ) ) ;
      }
      else
      {
        setDropShadowFilter ( application . getPropsDyn ( ) . getAppFontColorBright ( ) ) ;
      }
      super . setswh ( iconSize , iconSize ) ;
    }
    private function setDropShadowFilter ( color : Number ) : void
    {
      if ( application . brightShadowToApply ( color . toString ( 16 ) ) )
      {
        filters = application . TEXT_DROP_SHADOW_ARRAY_BRIGHT ;
      }
      else
      {
        filters = application . TEXT_DROP_SHADOW_ARRAY_DARK ;
      }
    }
    public function destBitmapData ( ) : void
    {
      graphics . clear ( ) ;
      if ( bitmapData != null )
      {
        bitmapData . dispose ( ) ;
        bitmapData = null ;
      }
    }
    override public function setsw ( newsw : int ) : void { }
    override public function setsh ( newsh : int ) : void { }
    override public function setswh ( newesw : int , newsh : int ) : void { }
    override public function destroy ( ) : void
    {
      destBitmapData ( ) ;
      super . destroy ( ) ;
      filters = undefined ;
    }
  }
}