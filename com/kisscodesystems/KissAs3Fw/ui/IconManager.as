package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import flash . display . Bitmap ;
  import flash . display . BitmapData ;
  import flash . geom . Matrix ;
  import flash . system . System ;
  public class IconManager
  {
    protected var application : Application = null ;
    [ Embed ( source = "../../../../../res/icons/copy.png" ) ]
    private var CopyClass : Class ;
    private var copyBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/list.png" ) ] protected var ListClass : Class ;
    protected var listBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/logout.png" ) ] protected var LogoutClass : Class ;
    protected var logoutBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/more.png" ) ] protected var MoreClass : Class ;
    protected var moreBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/watch.png" ) ] protected var WatchClass : Class ;
    protected var watchBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/downarrow1.png" ) ] protected var Downarrow1Class : Class ;
    protected var downarrow1Bitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/uparrow1.png" ) ] protected var Uparrow1Class : Class ;
    protected var uparrow1Bitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/starblank.png" ) ]
    private var StarblankClass : Class ;
    private var starblankBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/starfull.png" ) ]
    private var StarfullClass : Class ;
    private var starfullBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/starhalf.png" ) ]
    private var StarhalfClass : Class ;
    private var starhalfBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/plus.png" ) ]
    private var PlusClass : Class ;
    private var plusBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/minus.png" ) ]
    private var MinusClass : Class ;
    private var minusBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/minimize.png" ) ]
    private var MinimizeClass : Class ;
    private var minimizeBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/maximize.png" ) ]
    private var MaximizeClass : Class ;
    private var maximizeBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/leftarrow.png" ) ]
    private var LeftarrowClass : Class ;
    private var leftarrowBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/rightarrow.png" ) ]
    private var RightarrowClass : Class ;
    private var rightarrowBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/close.png" ) ]
    private var CloseClass : Class ;
    private var closeBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/menu.png" ) ]
    private var MenuClass : Class ;
    private var menuBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/settings.png" ) ]
    private var SettingsClass : Class ;
    private var settingsBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/ok.png" ) ]
    private var OkClass : Class ;
    private var okBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/cancel.png" ) ]
    private var CancelClass : Class ;
    private var cancelBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/folder.png" ) ]
    private var FolderClass : Class ;
    private var folderBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/file.png" ) ]
    private var FileClass : Class ;
    private var fileBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/potmeter.png" ) ]
    private var PotmeterClass : Class ;
    private var potmeterBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/ok1.png" ) ]
    private var Ok1Class : Class ;
    private var ok1Bitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/uparrow.png" ) ]
    private var UparrowClass : Class ;
    private var uparrowBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/downarrow.png" ) ]
    private var DownarrowClass : Class ;
    private var downarrowBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/info.png" ) ]
    private var InfoClass : Class ;
    private var infoBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/warning.png" ) ]
    private var WarningClass : Class ;
    private var warningBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/question.png" ) ]
    private var QuestionClass : Class ;
    private var questionBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/switchoff.png" ) ]
    private var SwitchoffClass : Class ;
    private var switchoffBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/switchon.png" ) ]
    private var SwitchonClass : Class ;
    private var switchonBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/playing.png" ) ]
    private var PlayingClass : Class ;
    private var playingBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/paused.png" ) ]
    private var PausedClass : Class ;
    private var pausedBitmap : Bitmap ;
    [ Embed ( source = "../../../../../res/icons/stopped.png" ) ]
    private var StoppedClass : Class ;
    private var stoppedBitmap : Bitmap ;
    public function IconManager ( applicationRef : Application ) : void
    {
      super ( ) ;
      if ( applicationRef != null )
      {
        application = applicationRef ;
      }
      else
      {
        System . exit ( 1 ) ;
      }
      copyBitmap = new CopyClass ( ) as Bitmap ;
      listBitmap = new ListClass ( ) as Bitmap ;
      logoutBitmap = new LogoutClass ( ) as Bitmap ;
      moreBitmap = new MoreClass ( ) as Bitmap ;
      watchBitmap = new WatchClass ( ) as Bitmap ;
      downarrow1Bitmap = new Downarrow1Class ( ) as Bitmap ;
      uparrow1Bitmap = new Uparrow1Class ( ) as Bitmap ;
      starblankBitmap = new StarblankClass ( ) as Bitmap ;
      starfullBitmap = new StarfullClass ( ) as Bitmap ;
      starhalfBitmap = new StarhalfClass ( ) as Bitmap ;
      plusBitmap = new PlusClass ( ) as Bitmap ;
      minusBitmap = new MinusClass ( ) as Bitmap ;
      minimizeBitmap = new MinimizeClass ( ) as Bitmap ;
      maximizeBitmap = new MaximizeClass ( ) as Bitmap ;
      leftarrowBitmap = new LeftarrowClass ( ) as Bitmap ;
      rightarrowBitmap = new RightarrowClass ( ) as Bitmap ;
      closeBitmap = new CloseClass ( ) as Bitmap ;
      menuBitmap = new MenuClass ( ) as Bitmap ;
      settingsBitmap = new SettingsClass ( ) as Bitmap ;
      okBitmap = new OkClass ( ) as Bitmap ;
      cancelBitmap = new CancelClass ( ) as Bitmap ;
      folderBitmap = new FolderClass ( ) as Bitmap ;
      fileBitmap = new FileClass ( ) as Bitmap ;
      potmeterBitmap = new PotmeterClass ( ) as Bitmap ;
      ok1Bitmap = new Ok1Class ( ) as Bitmap ;
      uparrowBitmap = new UparrowClass ( ) as Bitmap ;
      downarrowBitmap = new DownarrowClass ( ) as Bitmap ;
      infoBitmap = new InfoClass ( ) as Bitmap ;
      warningBitmap = new WarningClass ( ) as Bitmap ;
      questionBitmap = new QuestionClass ( ) as Bitmap ;
      switchoffBitmap = new SwitchoffClass ( ) as Bitmap ;
      switchonBitmap = new SwitchonClass ( ) as Bitmap ;
      playingBitmap = new PlayingClass ( ) as Bitmap ;
      pausedBitmap = new PausedClass ( ) as Bitmap ;
      stoppedBitmap = new StoppedClass ( ) as Bitmap ;
    }
    protected function transformBitmapData ( bitmap : Bitmap , textType : String , iconSize : int ) : BitmapData
    {
      var bitmapData : BitmapData = new BitmapData ( iconSize , iconSize , true , 0x00ffffff ) ;
      if ( bitmap != null )
      {
        var matrix : Matrix = new Matrix ( ) ;
        matrix . scale ( iconSize / bitmap . width , iconSize / bitmap . height ) ;
        bitmapData . draw ( bitmap . bitmapData , matrix , null , null , null , true ) ;
        var color : int = 0 ;
        if ( textType == application . getTexts ( ) . TEXT_TYPE_MID )
        {
          color = application . getPropsDyn ( ) . getAppFontColorMid ( ) ;
        }
        else if ( textType == application . getTexts ( ) . TEXT_TYPE_DARK )
        {
          color = application . getPropsDyn ( ) . getAppFontColorDark ( ) ;
        }
        else
        {
          color = application . getPropsDyn ( ) . getAppFontColorBright ( ) ;
        }
        for ( var i : int = 0 ; i < bitmapData . height ; i ++ )
        {
          for ( var j : int = 0 ; j < bitmapData . width ; j ++ )
          {
            bitmapData . setPixel ( i , j , color ) ;
          }
        }
      }
      return bitmapData ;
    }
    public function getNewBitmapData ( iconType : String , textType : String , iconSize : int ) : BitmapData
    {
      if ( iconType == "copy" )
      {
        return transformBitmapData ( copyBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "list" )
      {
        return transformBitmapData ( listBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "logout" )
      {
        return transformBitmapData ( logoutBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "more" )
      {
        return transformBitmapData ( moreBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "watch" )
      {
        return transformBitmapData ( watchBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "downarrow1" )
      {
        return transformBitmapData ( downarrow1Bitmap , textType , iconSize ) ;
      }
      else if ( iconType == "uparrow1" )
      {
        return transformBitmapData ( uparrow1Bitmap , textType , iconSize ) ;
      }
      else if ( iconType == "starblank" )
      {
        return transformBitmapData ( starblankBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "starfull" )
      {
        return transformBitmapData ( starfullBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "starhalf" )
      {
        return transformBitmapData ( starhalfBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "plus" )
      {
        return transformBitmapData ( plusBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "minus" )
      {
        return transformBitmapData ( minusBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "minimize" )
      {
        return transformBitmapData ( minimizeBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "maximize" )
      {
        return transformBitmapData ( maximizeBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "leftarrow" )
      {
        return transformBitmapData ( leftarrowBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "rightarrow" )
      {
        return transformBitmapData ( rightarrowBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "playing" )
      {
        return transformBitmapData ( playingBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "paused" )
      {
        return transformBitmapData ( pausedBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "stopped" )
      {
        return transformBitmapData ( stoppedBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "close" )
      {
        return transformBitmapData ( closeBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "menu" )
      {
        return transformBitmapData ( menuBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "settings" )
      {
        return transformBitmapData ( settingsBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "ok" )
      {
        return transformBitmapData ( okBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "cancel" )
      {
        return transformBitmapData ( cancelBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "file" )
      {
        return transformBitmapData ( fileBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "folder" )
      {
        return transformBitmapData ( folderBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "potmeter" )
      {
        return transformBitmapData ( potmeterBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "ok1" )
      {
        return transformBitmapData ( ok1Bitmap , textType , iconSize ) ;
      }
      else if ( iconType == "uparrow" )
      {
        return transformBitmapData ( uparrowBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "downarrow" )
      {
        return transformBitmapData ( downarrowBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "info" )
      {
        return transformBitmapData ( infoBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "warning" )
      {
        return transformBitmapData ( warningBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "question" )
      {
        return transformBitmapData ( questionBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "switchoff" )
      {
        return transformBitmapData ( switchoffBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "switchon" )
      {
        return transformBitmapData ( switchonBitmap , textType , iconSize ) ;
      }
      else if ( iconType == "dummy" )
      {
        return transformBitmapData ( null , textType , iconSize ) ;
      }
      return null ;
    }
  }
}
