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
      super . setswh ( iconSize , iconSize ) ;
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
    }
  }
}