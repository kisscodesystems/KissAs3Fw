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
** TextLabel.
** Not scrollable text. Can be multiline if maxWidth has been set.
**
** MAIN FEATURES:
** - the text code is displayed and will be changed automatically if the lang code is changed.
** - multiline text displaying is enabled.
** - maxWidth can be set. (useful for example in base list.)
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseTextField ;
  import flash . text . TextField ;
  import flash . text . TextFieldAutoSize ;
  public class TextLabel extends BaseTextField
  {
// The maximum width of the label.
    private var maxWidth : int = 0 ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function TextLabel ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// Changing these text properties.
      selectable = false ;
      autoSize = TextFieldAutoSize . LEFT ;
// The text type is bright by default.
      setTextType ( application . getTexts ( ) . TEXT_TYPE_BRIGHT ) ;
    }
/*
** Sets the maximum width of the label.
** If the displayed text is longer than this value then multiple lines
** of the text will be displayed.
*/
    public function setMaxWidth ( newWidth : int , allowMultiline : Boolean ) : void
    {
      if ( newWidth >= 0 && newWidth != maxWidth )
      {
        maxWidth = newWidth ;
        if ( maxWidth != 0 )
        {
          if ( allowMultiline )
          {
            autoSize = TextFieldAutoSize . LEFT ;
            wordWrap = true ;
            multiline = true ;
            width = maxWidth ;
          }
          else
          {
            autoSize = TextFieldAutoSize . NONE ;
            wordWrap = false ;
            multiline = false ;
            width = maxWidth ;
            height = application . getPropsDyn ( ) . getTextFieldHeight ( getTextType ( ) ) ;
          }
        }
        else
        {
          autoSize = TextFieldAutoSize . LEFT ;
          wordWrap = false ;
          multiline = false ;
        }
        super . setswh ( width , height ) ;
      }
    }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      maxWidth = 0 ;
    }
  }
}