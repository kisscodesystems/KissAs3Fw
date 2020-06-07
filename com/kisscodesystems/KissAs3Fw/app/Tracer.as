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
** Tracer.
** Sometimes it is necessary to display messages directly on the application.
** This class supports the tracing of debug messages without building a debugger app
** and without using debugger flash player.
**
** MAIN FEATURES:
** - Displays developer messages.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import flash . display . Shape ;
  import flash . display . Sprite ;
  import flash . events . Event ;
  import flash . events . MouseEvent ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  public class Tracer extends Sprite
  {
    private const MARGIN : int = 10 ;
    private const FILLCOLOR : Number = 0x000000 ;
    private const FILLALPHA : Number = 0.7 ;
    private const TEXTCOLOR : Number = 0xbbbbbb ;
    private const LINKCOLOR : Number = 0xdddddd ;
    private var linkBack : Shape = null ;
    private var linkText : TextField = null ;
    private var linkFore : Sprite = null ;
    private var background : Shape = null ;
    private var textfield : TextField ;
    public function Tracer ( ) : void
    {
      super ( ) ;
      addEventListener ( Event . ADDED_TO_STAGE , addedToStage ) ;
      addEventListener ( Event . REMOVED_FROM_STAGE , removedFromStage ) ;
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
      if ( background == null )
      {
        createElements ( ) ;
        resizeReposElements ( ) ;
        setVisible ( false ) ;
      }
      if ( textfield != null )
      {
        textfield . appendText ( message + "\n" ) ;
        scrollToBottom ( ) ;
      }
    }
    private function scrollToBottom ( ) : void
    {
      if ( textfield != null )
      {
        textfield . scrollV = textfield . maxScrollV ;
      }
    }
    private function createElements ( ) : void
    {
      background = new Shape ( ) ;
      addChild ( background ) ;
      textfield = new TextField ( ) ;
      addChild ( textfield ) ;
      textfield . text = "" ;
      textfield . x = MARGIN ;
      textfield . y = MARGIN ;
      textfield . selectable = true ;
      textfield . multiline = true ;
      textfield . textColor = TEXTCOLOR ;
      textfield . border = true ;
      textfield . borderColor = LINKCOLOR ;
      linkBack = new Shape ( ) ;
      addChild ( linkBack ) ;
      linkText = new TextField ( ) ;
      addChild ( linkText ) ;
      linkText . text = "Traces" ;
      linkText . x = MARGIN ;
      linkText . y = MARGIN ;
      linkText . selectable = false ;
      linkText . autoSize = TextFieldAutoSize . LEFT ;
      linkText . textColor = LINKCOLOR ;
      linkText . border = true ;
      linkText . borderColor = LINKCOLOR ;
      linkFore = new Sprite ( ) ;
      addChild ( linkFore ) ;
      linkFore . addEventListener ( MouseEvent . CLICK , linkForeClicked ) ;
      linkFore . useHandCursor = true ;
    }
    private function resizeReposElements ( ) : void
    {
      if ( stage != null )
      {
        if ( background != null )
        {
          background . graphics . clear ( ) ;
          background . x = MARGIN ;
          background . y = MARGIN ;
          background . graphics . beginFill ( FILLCOLOR , FILLALPHA ) ;
          background . graphics . drawRect ( 0 , 0 , stage . stageWidth - 2 * MARGIN , stage . stageHeight - 2 * MARGIN ) ;
          background . graphics . endFill ( ) ;
        }
        if ( textfield != null )
        {
          textfield . width = stage . stageWidth - 2 * MARGIN ;
          textfield . height = stage . stageHeight - 2 * MARGIN ;
          scrollToBottom ( ) ;
        }
        if ( linkText != null )
        {
          linkText . x = stage . stageWidth - MARGIN - linkText . width ;
          linkText . y = stage . stageHeight - MARGIN - linkText . height ;
          if ( linkFore != null )
          {
            linkFore . graphics . clear ( ) ;
            linkFore . x = linkText . x ;
            linkFore . y = linkText . y ;
            linkFore . graphics . beginFill ( FILLCOLOR , 0 ) ;
            linkFore . graphics . drawRect ( 0 , 0 , linkText . width , linkText . height ) ;
            linkFore . graphics . endFill ( ) ;
          }
          if ( linkBack != null )
          {
            linkBack . graphics . clear ( ) ;
            linkBack . x = linkText . x ;
            linkBack . y = linkText . y ;
            linkBack . graphics . beginFill ( FILLCOLOR , FILLALPHA ) ;
            linkBack . graphics . drawRect ( 0 , 0 , linkText . width , linkText . height ) ;
            linkBack . graphics . endFill ( ) ;
          }
        }
      }
    }
    private function linkForeClicked ( e : MouseEvent ) : void
    {
      if ( background != null )
      {
        setVisible ( ! background . visible ) ;
      }
      else
      {
        setVisible ( false ) ;
      }
    }
    private function setVisible ( v : Boolean ) : void
    {
      if ( background != null )
      {
        background . visible = v ;
      }
      if ( textfield != null )
      {
        textfield . visible = v ;
      }
    }
  }
}
