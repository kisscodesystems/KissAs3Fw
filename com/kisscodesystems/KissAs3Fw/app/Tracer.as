/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** Tracer.
** Sometimes it is necessary to display messages directly on the application.
** This class supports the tracing of debug messages without building a debugger app
** and without using debugger flash player.
** You can find a "Tracer" button to read and show/hide debug messages.
** To post a debug message just use: application.trace("your message here")
**
** MAIN FEATURES:
** - Displays developer messages.
** - Filter regexp
** - Clear all messages
** - Hide / unhide the tracer elements
** - Pauses further messages
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import flash . display . Shape ;
  import flash . display . Sprite ;
  import flash . events . Event ;
  import flash . events . KeyboardEvent ;
  import flash . events . MouseEvent ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  import flash . text . TextFieldType ;
  import flash . text . TextFormat ;
  import flash . ui . Keyboard ;
  public class Tracer extends Sprite
  {
    private const FILLCOLOR : Number = 0x000000 ;
    private const FILLALPHA : Number = 0.7 ;
    private const TEXTCOLOR : Number = 0xbbbbbb ;
    private const LINKCOLOR : Number = 0xdddddd ;
    private const FONT_SIZE : Number = 16 ;
    private var backgroundShape : Shape = null ;
    private var textFormat : TextFormat = null ;
    private var linkVisibBack : Shape = null ;
    private var linkVisibText : TextField = null ;
    private var linkVisibFore : Sprite = null ;
    private var linkClearBack : Shape = null ;
    private var linkClearText : TextField = null ;
    private var linkClearFore : Sprite = null ;
    private var filteTextField : TextField ;
    private var traceTextField : TextField ;
    private var traceString : String = "" ;
    private var filteredString : String = "" ;
    private var regexp : RegExp = null ;
    private var paused : Boolean = false ;
    public function Tracer ( ) : void
    {
      super ( ) ;
      addEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      addEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
      textFormat = new TextFormat ( ) ;
      textFormat . size = FONT_SIZE ;
    }
    private function addedToStage ( e : Event ) : void
    {
      stage . addEventListener ( Event . RESIZE , stageResized ) ;
    }
    private function removedFromStage ( e : Event ) : void
    {
      if ( stage != null )
      {
        stage . removeEventListener ( Event . RESIZE , stageResized ) ;
      }
    }
    private function stageResized ( e : Event ) : void
    {
      resizeReposElements ( ) ;
    }
    public function trace ( message : String ) : void
    {
      if ( backgroundShape == null )
      {
        createElements ( ) ;
        resizeReposElements ( ) ;
        setVisible ( false ) ;
      }
      if ( traceTextField != null && filteTextField != null )
      {
        if ( ! paused )
        {
          traceString += message + "\n" ;
          if ( filteTextField . text == "" )
          {
            traceTextField . appendText ( message + "\n" ) ;
            scrollToBottom ( ) ;
          }
          else
          {
            filterTraces ( ) ;
          }
        }
      }
    }
    private function scrollToBottom ( ) : void
    {
      if ( traceTextField != null )
      {
        traceTextField . scrollV = traceTextField . maxScrollV ;
      }
    }
    private function keyUp ( e : KeyboardEvent ) : void
    {
      if ( e != null && filteTextField != null )
      {
        if ( e . keyCode == Keyboard . ENTER || e . keyCode == Keyboard . NUMPAD_ENTER )
        {
          regexp = new RegExp ( filteTextField . text ) ;
          filterTraces ( ) ;
        }
        else if ( e . keyCode == Keyboard . ESCAPE )
        {
          paused = ! paused ;
        }
      }
    }
    private function filterTraces ( ) : void
    {
      filteredString = "" ;
      var arr : Array = new Array ( ) ;
      arr = traceString . split ( "\n" ) ;
      for ( var i : int = 0 ; i < arr . length ; i ++ )
      {
        if ( regexp . test ( arr [ i ] ) )
        {
          if ( filteredString == "" )
          {
            filteredString = arr [ i ] ;
          }
          else
          {
            filteredString += "\n" + arr [ i ] ;
          }
        }
      }
      traceTextField . text = filteredString ;
      scrollToBottom ( ) ;
    }
    private function createElements ( ) : void
    {
      backgroundShape = new Shape ( ) ;
      addChild ( backgroundShape ) ;
      traceTextField = new TextField ( ) ;
      addChild ( traceTextField ) ;
      traceTextField . text = "" ;
      traceTextField . x = 0 ;
      traceTextField . y = 0 ;
      traceTextField . selectable = true ;
      traceTextField . multiline = true ;
      traceTextField . wordWrap = true ;
      traceTextField . textColor = TEXTCOLOR ;
      traceTextField . border = true ;
      traceTextField . borderColor = LINKCOLOR ;
      traceTextField . defaultTextFormat = textFormat ;
      filteTextField = new TextField ( ) ;
      addChild ( filteTextField ) ;
      filteTextField . text = "" ;
      filteTextField . selectable = true ;
      filteTextField . multiline = false ;
      filteTextField . type = TextFieldType . INPUT ;
      filteTextField . textColor = TEXTCOLOR ;
      filteTextField . border = true ;
      filteTextField . borderColor = LINKCOLOR ;
      filteTextField . addEventListener ( KeyboardEvent . KEY_UP , keyUp ) ;
      filteTextField . defaultTextFormat = textFormat ;
      linkClearBack = new Shape ( ) ;
      addChild ( linkClearBack ) ;
      linkClearText = new TextField ( ) ;
      addChild ( linkClearText ) ;
      linkClearText . text = "Clear" ;
      linkClearText . x = 0 ;
      linkClearText . y = 0 ;
      linkClearText . selectable = false ;
      linkClearText . autoSize = TextFieldAutoSize . LEFT ;
      linkClearText . textColor = LINKCOLOR ;
      linkClearText . border = true ;
      linkClearText . borderColor = LINKCOLOR ;
      linkClearText . defaultTextFormat = textFormat ;
      linkClearFore = new Sprite ( ) ;
      addChild ( linkClearFore ) ;
      linkClearFore . addEventListener ( MouseEvent . CLICK , linkClearForeClicked ) ;
      linkClearFore . useHandCursor = true ;
      linkVisibBack = new Shape ( ) ;
      addChild ( linkVisibBack ) ;
      linkVisibText = new TextField ( ) ;
      addChild ( linkVisibText ) ;
      linkVisibText . text = "Traces" ;
      linkVisibText . x = 0 ;
      linkVisibText . y = 0 ;
      linkVisibText . selectable = false ;
      linkVisibText . autoSize = TextFieldAutoSize . LEFT ;
      linkVisibText . textColor = LINKCOLOR ;
      linkVisibText . border = true ;
      linkVisibText . borderColor = LINKCOLOR ;
      linkVisibText . defaultTextFormat = textFormat ;
      linkVisibFore = new Sprite ( ) ;
      addChild ( linkVisibFore ) ;
      linkVisibFore . addEventListener ( MouseEvent . CLICK , linkVisibForeClicked ) ;
      linkVisibFore . useHandCursor = true ;
    }
    private function resizeReposElements ( ) : void
    {
      if ( stage != null )
      {
        if ( backgroundShape != null )
        {
          backgroundShape . graphics . clear ( ) ;
          backgroundShape . x = 0 ;
          backgroundShape . y = 0 ;
          backgroundShape . graphics . beginFill ( FILLCOLOR , FILLALPHA ) ;
          backgroundShape . graphics . drawRect ( 0 , 0 , stage . stageWidth , stage . stageHeight ) ;
          backgroundShape . graphics . endFill ( ) ;
        }
        if ( linkVisibText != null )
        {
          linkVisibText . x = stage . stageWidth - linkVisibText . width ;
          linkVisibText . y = stage . stageHeight - linkVisibText . height ;
          if ( linkVisibFore != null )
          {
            linkVisibFore . graphics . clear ( ) ;
            linkVisibFore . x = linkVisibText . x ;
            linkVisibFore . y = linkVisibText . y ;
            linkVisibFore . graphics . beginFill ( FILLCOLOR , 0 ) ;
            linkVisibFore . graphics . drawRect ( 0 , 0 , linkVisibText . width , linkVisibText . height ) ;
            linkVisibFore . graphics . endFill ( ) ;
          }
          if ( linkVisibBack != null )
          {
            linkVisibBack . graphics . clear ( ) ;
            linkVisibBack . x = linkVisibText . x ;
            linkVisibBack . y = linkVisibText . y ;
            linkVisibBack . graphics . beginFill ( FILLCOLOR , FILLALPHA ) ;
            linkVisibBack . graphics . drawRect ( 0 , 0 , linkVisibText . width , linkVisibText . height ) ;
            linkVisibBack . graphics . endFill ( ) ;
          }
          if ( traceTextField != null )
          {
            traceTextField . width = stage . stageWidth ;
            traceTextField . height = stage . stageHeight - linkVisibText . height ;
            scrollToBottom ( ) ;
          }
          if ( linkClearText != null )
          {
            linkClearText . x = stage . stageWidth - linkVisibText . width - linkClearText . width ;
            linkClearText . y = linkVisibText . y ;
            if ( linkClearFore != null )
            {
              linkClearFore . graphics . clear ( ) ;
              linkClearFore . x = linkClearText . x ;
              linkClearFore . y = linkClearText . y ;
              linkClearFore . graphics . beginFill ( FILLCOLOR , 0 ) ;
              linkClearFore . graphics . drawRect ( 0 , 0 , linkClearText . width , linkClearText . height ) ;
              linkClearFore . graphics . endFill ( ) ;
            }
            if ( linkClearBack != null )
            {
              linkClearBack . graphics . clear ( ) ;
              linkClearBack . x = linkClearText . x ;
              linkClearBack . y = linkClearText . y ;
              linkClearBack . graphics . beginFill ( FILLCOLOR , FILLALPHA ) ;
              linkClearBack . graphics . drawRect ( 0 , 0 , linkClearText . width , linkClearText . height ) ;
              linkClearBack . graphics . endFill ( ) ;
            }
            if ( filteTextField != null )
            {
              filteTextField . x = 0 ;
              filteTextField . y = linkClearText . y ;
              filteTextField . width = linkClearText . x ;
              filteTextField . height = linkClearText . height ;
            }
          }
        }
      }
    }
    private function linkVisibForeClicked ( e : MouseEvent ) : void
    {
      if ( backgroundShape != null )
      {
        setVisible ( ! backgroundShape . visible ) ;
      }
      else
      {
        setVisible ( false ) ;
      }
    }
    private function linkClearForeClicked ( e : MouseEvent ) : void
    {
      if ( traceTextField != null )
      {
        traceTextField . text = "" ;
      }
      traceString = "" ;
      filteredString = "" ;
    }
    private function setVisible ( v : Boolean ) : void
    {
      if ( backgroundShape != null )
      {
        backgroundShape . visible = v ;
      }
      if ( traceTextField != null )
      {
        traceTextField . visible = v ;
      }
      if ( filteTextField != null )
      {
        filteTextField . visible = v ;
      }
      if ( linkClearBack != null && linkClearText != null && linkClearFore != null )
      {
        linkClearBack . visible = v ;
        linkClearText . visible = v ;
        linkClearFore . visible = v ;
      }
    }
  }
}
