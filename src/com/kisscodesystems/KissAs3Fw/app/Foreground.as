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
** Foreground.
** This is the object displays the alerts and informations.
**
** MAIN FEATURES:
** - Displays alerts (with OK or OK-CANCEL buttons)
** - Displays the list of the widgets.
** - newer alerts will go the bottom of the contents! (as expectable like in ContentMultiple)
** - invisible by default.
*/
package com . kisscodesystems . KissAs3Fw . app
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . base . BaseSprite ;
  import com . kisscodesystems . KissAs3Fw . ui . ButtonText ;
  import com . kisscodesystems . KissAs3Fw . ui . ContentMultiple ;
  import com . kisscodesystems . KissAs3Fw . ui . List ;
  import com . kisscodesystems . KissAs3Fw . ui . TextBox ;
  import com . kisscodesystems . KissAs3Fw . ui . TextLabel ;
  import flash . events . Event ;
  public class Foreground extends BaseSprite
  {
// The background of the elements.
    private var contentMultiple : ContentMultiple = null ;
// The list of the widgets.
    private var widgetsLabel : TextLabel = null ;
    private var widgetsList : List = null ;
    private var widgetListIndex : int = - 1 ;
/*
** Initializing this object. The not null app reference is necessary as usual.
*/
    public function Foreground ( applicationRef : Application ) : void
    {
// Let's store this reference to the Application object.
      super ( applicationRef ) ;
// The visible is false by default.
      visible = false ;
    }
/*
** Creating the multi content if it is not visible at this moment.
*/
    private function createContentMultiple ( ) : void
    {
      if ( contentMultiple == null )
      {
        setVisible ( true ) ;
        contentMultiple = new ContentMultiple ( application ) ;
        addChild ( contentMultiple ) ;
        contentMultiple . setswh ( getsw ( ) * application . getPropsApp ( ) . getPanelAlertWidthFactor ( ) , getsh ( ) * application . getPropsApp ( ) . getPanelAlertHeighthFactor ( ) ) ;
        reposContentMultiple ( ) ;
      }
    }
/*
** Sets the active index 0.
*/
    private function setActiveIndex0 ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setActiveIndex ( 0 ) ;
      }
    }
/*
** Creates a new alert.
*/
    public function createAlert ( messageString : String , eventStringOK : Boolean , eventStringCANCEL : Boolean ) : void
    {
      if ( messageString != null && eventStringOK )
      {
// Creating the content multiple is it does not exist.
        createContentMultiple ( ) ;
        var index : int = contentMultiple . addContent ( messageString ) ;
        contentMultiple . setElementsFix ( index , 0 ) ;
        contentMultiple . setButtonBarVisible ( false ) ;
        var textBox : TextBox = new TextBox ( application ) ;
        contentMultiple . addToContent ( index , textBox , true , 0 ) ;
        textBox . setTextCode ( messageString ) ;
        textBox . setWordWrap ( true ) ;
        var buttonOK : ButtonText = new ButtonText ( application ) ;
        contentMultiple . addToContent ( index , buttonOK , true , 1 ) ;
        buttonOK . setTextCode ( application . getTexts ( ) . OC_OK ) ;
        buttonOK . setCustomEventString ( messageString + application . getTexts ( ) . OC_OK ) ;
        var buttonCANCEL : ButtonText = null ;
        if ( eventStringCANCEL )
        {
          buttonCANCEL = new ButtonText ( application ) ;
          contentMultiple . addToContent ( index , buttonCANCEL , true , 1 ) ;
          buttonCANCEL . setTextCode ( application . getTexts ( ) . OC_CANCEL ) ;
          buttonCANCEL . setCustomEventString ( messageString + application . getTexts ( ) . OC_CANCEL ) ;
        }
        textBox . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        textBox . setswh ( contentMultiple . getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) , contentMultiple . getsh ( ) - 3 * application . getPropsDyn ( ) . getAppMargin ( ) - buttonOK . getsh ( ) ) ;
        if ( eventStringCANCEL )
        {
          buttonOK . setcxy ( ( contentMultiple . getsw ( ) - buttonOK . getsw ( ) - buttonCANCEL . getsw ( ) - application . getPropsDyn ( ) . getAppMargin ( ) ) / 2 , textBox . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
          buttonCANCEL . setcxy ( buttonOK . getcxsw ( ) + application . getPropsDyn ( ) . getAppMargin ( ) , buttonOK . getcy ( ) ) ;
        }
        else
        {
          buttonOK . setcxy ( ( contentMultiple . getsw ( ) - buttonOK . getsw ( ) ) / 2 , textBox . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        }
        setActiveIndex0 ( ) ;
      }
    }
/*
** Closes an alert found by the message string given before.
** Not removing the elements one-by-one because we don't have the references to them,
** so just let the content does this for us.
*/
    public function closeAlert ( messageString : String ) : void
    {
      var index : int = contentMultiple . getContentIndexByLabel ( messageString ) ;
      if ( index != - 1 )
      {
        contentMultiple . removeContent ( index ) ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
/*
** Creates the list of the widgets.
*/
    public function createWidgetsList ( ) : void
    {
// Creating the content multiple is it does not exist.
      createContentMultiple ( ) ;
      if ( widgetListIndex == - 1 )
      {
        widgetListIndex = contentMultiple . addContent ( application . getTexts ( ) . LISTS_OF_THE_WIDGETS ) ;
        contentMultiple . setElementsFix ( widgetListIndex , 0 ) ;
        contentMultiple . setButtonBarVisible ( false ) ;
        widgetsLabel = new TextLabel ( application ) ;
        contentMultiple . addToContent ( widgetListIndex , widgetsLabel , false , 0 ) ;
        widgetsLabel . setTextType ( application . getTexts ( ) . TEXT_TYPE_DARK ) ;
        widgetsLabel . setTextCode ( application . getTexts ( ) . LISTS_OF_THE_WIDGETS ) ;
        widgetsLabel . setcxy ( application . getPropsDyn ( ) . getAppMargin ( ) , application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList = new List ( application ) ;
        contentMultiple . addToContent ( widgetListIndex , widgetsList , true , 1 ) ;
        widgetsList . setsw ( contentMultiple . getsw ( ) - 2 * application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList . setcxy ( widgetsLabel . getcx ( ) , widgetsLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) ) ;
        widgetsList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , goToTheWidget ) ;
        widgetsList . setMultiple ( false ) ;
        widgetsList . setArrays ( application . getMiddleground ( ) . getWidgets ( ) . getWidgetHeaders ( ) , application . getMiddleground ( ) . getWidgets ( ) . getWidgetIds ( ) ) ;
        widgetsList . setNumOfElements ( Math . max ( 1 , Math . floor ( ( contentMultiple . getsh ( ) - ( widgetsLabel . getcysh ( ) + application . getPropsDyn ( ) . getAppMargin ( ) * 2 + application . getPropsDyn ( ) . getAppPadding ( ) * 2 + application . getPropsApp ( ) . getScrollMargin ( ) ) ) / application . getPropsDyn ( ) . getTextFieldHeight ( widgetsList . getTextType ( ) ) ) ) ) ;
        setActiveIndex0 ( ) ;
      }
    }
/*
** Goes to the specific widget.
*/
    private function goToTheWidget ( e : Event ) : void
    {
      application . getMiddleground ( ) . getWidgets ( ) . goToTheWidget ( widgetsList . getSelectedIndexes ( ) [ 0 ] ) ;
      closeWidgetsList ( ) ;
      e . stopImmediatePropagation ( ) ;
    }
/*
** Destroys the list of the widgets.
*/
    public function closeWidgetsList ( ) : void
    {
      if ( widgetListIndex != - 1 )
      {
        widgetsLabel . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetListIndex , widgetsLabel ) ;
        widgetsLabel = null ;
        widgetsList . destroy ( ) ;
        contentMultiple . removeFromContent ( widgetListIndex , widgetsList ) ;
        widgetsList = null ;
        contentMultiple . removeContent ( widgetListIndex ) ;
        widgetListIndex = - 1 ;
      }
      setVisibleFalseIfNoMoreObjects ( ) ;
    }
/*
** This is the method runs after the changing of the size of this object.
** If this has happened then the
*/
    override protected function doSizeChanged ( ) : void
    {
// Let's repaint it with an empty.
      foregroundRedraw ( ) ;
// The content has to be resized and repositioned.
      reposContentMultiple ( ) ;
// Super!
      super . doSizeChanged ( ) ;
    }
/*
** Repos and resize the elements.
*/
    private function reposContentMultiple ( ) : void
    {
      if ( contentMultiple != null )
      {
        contentMultiple . setcxy ( ( getsw ( ) - contentMultiple . getsw ( ) ) / 2 , ( getsh ( ) - contentMultiple . getsh ( ) ) / 2 ) ;
      }
    }
/*
** The multiple content object sould be removed ahd the visible should be false if no more contents.
*/
    private function setVisibleFalseIfNoMoreObjects ( ) : void
    {
      if ( contentMultiple != null )
      {
        if ( contentMultiple . getNumOfContents ( ) == 0 )
        {
          contentMultiple . destroy ( ) ;
          removeChild ( contentMultiple ) ;
          contentMultiple = null ;
          setVisible ( false ) ;
        }
      }
    }
/*
** Redrawing the foreground in the correct size.
*/
    protected function foregroundRedraw ( ) : void
    {
      graphics . clear ( ) ;
      graphics . lineStyle ( 0 , 0 , 0 ) ;
      graphics . beginFill ( 0 , 0 ) ;
      graphics . drawRect ( 0 , 0 , getsw ( ) , getsh ( ) ) ;
      graphics . endFill ( ) ;
    }
/*
** Sets its visible.
** If this is visible then the background should not be accessible.
*/
    private function setVisible ( b : Boolean ) : void
    {
      if ( visible != b )
      {
        visible = b ;
        application . getMiddleground ( ) . setVisible ( ! visible ) ;
      }
    }
/*
** Destroying this application.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      contentMultiple = null ;
      widgetsLabel = null ;
      widgetsList = null ;
      widgetListIndex = 0 ;
    }
  }
}