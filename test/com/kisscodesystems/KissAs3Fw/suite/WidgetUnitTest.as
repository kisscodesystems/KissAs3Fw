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
 * WidgetUnitTest
 * Checks the Widget component.
 *
 * MAIN FEATURES:
 * - the identifiers, the header and the type of a widget, the write once ones as well
 * - the dimensions, which are taken in desktop mode only and never below the minimums
 * - the minimized state, where the height of the header is the height of the whole widget
 * - the fullscreen property, which is kept by the widget and displayed by the widget layer,
 *   and the roll over that asks for it back
 * - every call forwarded to the content multiple standing inside the widget
 * - the header buttons, the submenu of them and the info content
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEmojis;
  import com.kisscodesystems.KissAs3Fw.enum.EnumEvents;
  import com.kisscodesystems.KissAs3Fw.enum.EnumIcons;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOrientations;
  import com.kisscodesystems.KissAs3Fw.enum.EnumWidgetModes;
  import com.kisscodesystems.KissAs3Fw.ui.TextLabel;
  import com.kisscodesystems.KissAs3Fw.ui.Widget;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.events.Event;
  import flash.events.MouseEvent;
  public class WidgetUnitTest extends BaseUnitTest
  {
    private var closedCount:int = 0;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function WidgetUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Widget";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      closedCount = 0;
      // the setters of the dimensions of a widget return without doing anything at all when
      // the application does not stand in desktop mode, so that mode has to be taken first
      const origWidgetMode:String = application.getDynamicsConfig().getAppWidgetMode();
      application.getDynamicsConfig().setAppWidgetMode(EnumWidgetModes.WIDGET_MODE_DESKTOP());
      const minw:int = application.getComponentsConfig().getWidgetSizeMinWidth();
      const minh:int = application.getComponentsConfig().getWidgetSizeMinHeight();
      const margin:int = application.getDynamicsConfig().getAppMargin();
      const widget:Widget = new Widget(application);
      addTested(widget);
      widget.getBaseEventDispatcher().addEventListener(EnumEvents.EVENT_WIDGET_CLOSED(), widgetClosed);
      assertNotNull("the dispatcher of the content", widget.getContentBaseEventDispatcher());
      assertFalse("a new widget is not minimized", widget.getHidden());
      // the identifiers of the widget
      widget.setContentId(3);
      assertEquals("getContentId after setContentId", 3, widget.getContentId());
      widget.setContentId(4);
      assertEquals("setContentId can be called again", 4, widget.getContentId());
      assertEquals("the widget id of a new widget", -1, widget.getWidgetId());
      widget.setWidgetId(17);
      assertEquals("getWidgetId after setWidgetId", 17, widget.getWidgetId());
      widget.setWidgetId(18);
      assertEquals("setWidgetId is a write once setter", 17, widget.getWidgetId());
      assertNull("the type of a new widget", widget.getWidgetType());
      widget.setWidgetType("theTypeOfThisWidget");
      assertEquals("getWidgetType after setWidgetType", "theTypeOfThisWidget", widget.getWidgetType());
      widget.setWidgetType("anotherType");
      assertEquals("setWidgetType is a write once setter", "theTypeOfThisWidget", widget.getWidgetType());
      assertNull("the header of a new widget", widget.getWidgetHeader());
      widget.setWidgetHeaderCode("theHeaderOfThisWidget");
      assertEquals("getWidgetHeader after setWidgetHeaderCode"
        , "theHeaderOfThisWidget", widget.getWidgetHeader());
      widget.setWidgetHeaderCode("anotherHeader");
      assertEquals("setWidgetHeaderCode is a write once setter"
        , "theHeaderOfThisWidget", widget.getWidgetHeader());
      widget.setWidgetHeaderIcon(EnumIcons.info());
      widget.setWidgetHeaderEmoji(EnumEmojis.computer_desktop_computer());
      // the dimensions, which never go below the minimums of a widget
      widget.setDwh(400, 300);
      assertEquals("getDw after setDwh", 400, widget.getDw());
      assertEquals("getDh after setDwh", 300, widget.getDh());
      widget.setDw(500);
      assertEquals("getDw after setDw", 500, widget.getDw());
      widget.setDh(350);
      assertEquals("getDh after setDh", 350, widget.getDh());
      widget.setDw(1);
      assertEquals("the width never goes below the minimal one", minw, widget.getDw());
      widget.setDh(1);
      assertEquals("the height never goes below the minimal one", minh, widget.getDh());
      widget.setDwh(1, 1);
      assertEquals("the width of setDwh never goes below the minimal one", minw, widget.getDw());
      assertEquals("the height of setDwh never goes below the minimal one", minh, widget.getDh());
      widget.setDwh(400, 300);
      // the content of the widget: the button bar stands above it and it gets what is left
      widget.setDefaultContent();
      assertEquals("the active index of the default content", 0, widget.getActiveIndex());
      assertEquals("no button bar above the default content", 0, widget.getButtonBarCyAndHeight());
      assertTrue("the content is narrower than the widget", widget.getContentDw() < widget.getDw());
      assertTrue("the content is lower than the widget", widget.getContentDh() < widget.getDh());
      assertTrue("the content stands inside the widget", widget.getContentCx() > 0);
      assertTrue("the content stands below the header of the widget", widget.getContentCy() > 0);
      // the default content above stands at the index zero, so the contents added here
      // follow it, and it has hidden the button bar, which has to be asked back
      const first:int = widget.addContent("theFirstContent");
      assertEquals("the index of the first added content", 1, first);
      const second:int = widget.addContent("theSecondContent", EnumIcons.info());
      assertEquals("the index of the second added content", 2, second);
      assertEquals("an already used label gives minus one", -1, widget.addContent("theFirstContent"));
      assertEquals("the button bar hidden by the default content stays hidden"
        , 0, widget.getButtonBarCyAndHeight());
      widget.setButtonBarVisible(true);
      assertTrue("the button bar takes the top of the content", widget.getButtonBarCyAndHeight() > 0);
      widget.setActiveContent(1);
      assertEquals("getActiveIndex after setActiveContent", 1, widget.getActiveIndex());
      // the scroll of a content comes back, so an extender widget can switch the scrolling
      // of it off when it holds the objects that are scrolled themselves
      assertNotNull("the base scroll of an added content", widget.getBaseScroll(first));
      assertTrue("that scroll is enabled by default"
        , widget.getBaseScroll(first).getEnabledVertical());
      widget.getBaseScroll(first).setEnabledVertical(false);
      assertFalse("that scroll can be switched off"
        , widget.getBaseScroll(first).getEnabledVertical());
      widget.getBaseScroll(first).setEnabledVertical(true);
      widget.setIcon(0, EnumIcons.ok1());
      widget.setIconIfNotActive(0, EnumIcons.cancel());
      widget.destIcon(0);
      // an emoji stands in the very same slot an icon does, so it must not break the
      // active content either
      widget.setEmoji(0, EnumEmojis.hands_thumbsup());
      widget.setEmojiIfNotActive(0, EnumEmojis.hearts_heart());
      widget.setEmojiIfNotActive(2, EnumEmojis.hearts_heart());
      assertEquals("the active content survives the emoji changes", 1, widget.getActiveIndex());
      widget.setButtonBarVisible(false);
      assertEquals("no button bar when it is not visible", 0, widget.getButtonBarCyAndHeight());
      widget.setButtonBarVisible(true);
      assertTrue("the button bar is back", widget.getButtonBarCyAndHeight() > 0);
      // a content of this widget that is hidden from the button bar above it
      const hidden:int = widget.addHiddenContent("theHiddenContent");
      assertEquals("the index of the hidden content", 3, hidden);
      assertFalse("the button of the hidden content is not on the bar"
        , widget.getContentButtonVisible(hidden));
      assertTrue("the buttons of the other contents are on the bar"
        , widget.getContentButtonVisible(1));
      assertEquals("an already used label gives minus one for a hidden content"
        , -1, widget.addHiddenContent("theFirstContent"));
      widget.setActiveContent(hidden);
      assertEquals("the hidden content can be activated from the inside"
        , hidden, widget.getActiveIndex());
      widget.setContentButtonVisible(hidden, true);
      assertTrue("getContentButtonVisible after setContentButtonVisible"
        , widget.getContentButtonVisible(hidden));
      widget.removeContent(hidden);
      widget.setActiveContent(1);
      // the elements of one single content of the widget
      widget.setOrientation(1, EnumOrientations.ORIENTATION_VERTICAL());
      widget.setElementsFix(1, 2);
      assertEquals("getElementsFix after setElementsFix", 2, widget.getElementsFix(1));
      const textLabel:TextLabel = new TextLabel(application);
      textLabel.setLabel("theElementOfTheContent");
      widget.addToContent(1, textLabel, 0);
      assertEquals("getCellIndex of the added element", 0, widget.getCellIndex(1, textLabel));
      widget.changeCellIndex(1, textLabel, 1);
      assertEquals("getCellIndex after changeCellIndex", 1, widget.getCellIndex(1, textLabel));
      assertTrue("the content of the elements has a width", widget.getDwContent(1) > 0);
      assertTrue("the content of the elements has a height", widget.getDhContent(1) > 0);
      widget.setDwhContent(1, 600, 500);
      assertEquals("getDwContent after setDwhContent", 600, widget.getDwContent(1));
      assertEquals("getDhContent after setDwhContent", 500, widget.getDhContent(1));
      widget.setContentPosition(1, -20, -30, false);
      widget.removeFromContent(1, textLabel);
      assertEquals("getCellIndex of the removed element", -1, widget.getCellIndex(1, textLabel));
      textLabel.destroy();
      // an out of range index reaches no content at all and must not break anything
      assertEquals("getCellIndex of an out of range index", -1, widget.getCellIndex(99, textLabel));
      assertEquals("getElementsFix of an out of range index", 0, widget.getElementsFix(99));
      assertEquals("getDwContent of an out of range index", 0, widget.getDwContent(99));
      assertEquals("getDhContent of an out of range index", 0, widget.getDhContent(99));
      // removing the active content leaves this widget with no active content at all, the
      // very same way the button bar and the multiple content below it do: choosing the
      // next one to display is left to the owner of the widget
      widget.removeContent(1);
      assertEquals("the active index after the removal of the active content"
        , -1, widget.getActiveIndex());
      // the info content replaces the content of the widget and then gives it back
      widget.setInfoContent("theInfoOfThisWidget");
      // a widget carrying an info content stands with its own content displayed, and the
      // two of them can be swapped from the outside, exactly as the info button does it
      assertFalse("getInfoContentVisible after setInfoContent", widget.getInfoContentVisible());
      widget.setInfoContentVisible(true);
      assertTrue("getInfoContentVisible after setInfoContentVisible(true)"
        , widget.getInfoContentVisible());
      widget.setInfoContentVisible(false);
      assertFalse("getInfoContentVisible after setInfoContentVisible(false)"
        , widget.getInfoContentVisible());
      widget.clearInfoContent();
      // a widget holding no info content at all displays none of it and cannot be asked
      // to display it either
      assertFalse("getInfoContentVisible after clearInfoContent", widget.getInfoContentVisible());
      widget.setInfoContentVisible(true);
      assertFalse("getInfoContentVisible without any info content", widget.getInfoContentVisible());
      widget.setInfoContent("<b>theHtmlInfoOfThisWidget</b>", true);
      widget.clearInfoContent();
      // the buttons of the header of the widget
      widget.setButtonsVisible(true, true, true);
      widget.setButtonsVisible(false, false, false);
      widget.setButtonMoveVisible(false);
      widget.setButtonMoveVisible(true);
      widget.setButtonClosVisible(false);
      widget.setButtonClosVisible(true);
      widget.setButtonMoveEventPossible(false);
      widget.setButtonMoveEventPossible(true);
      widget.setButtonClosEventPossible(false);
      widget.setButtonClosEventPossible(true);
      // the submenu of the header, which holds one row per navigation button of the widget
      assertFalse("the submenu of a new widget is closed", widget.getMenuOpen());
      widget.setMenuOpen(true);
      assertTrue("getMenuOpen after setMenuOpen(true)", widget.getMenuOpen());
      widget.setMenuOpen(true);
      assertTrue("setMenuOpen can be called with the very same value", widget.getMenuOpen());
      widget.setMenuOpen(false);
      assertFalse("getMenuOpen after setMenuOpen(false)", widget.getMenuOpen());
      // the minimized widget is as tall as its own header only
      widget.setDwh(400, 300);
      const dhBeforeHiding:int = widget.getDh();
      widget.setHidden(true);
      assertTrue("getHidden after setHidden(true)", widget.getHidden());
      assertTrue("the minimized widget is lower than the open one", widget.getDh() < dhBeforeHiding);
      widget.setDwh(450, 300);
      assertEquals("the width of a minimized widget can be set", 450, widget.getDw());
      widget.setDh(1);
      assertTrue("the height of a minimized widget is left alone", widget.getDh() < dhBeforeHiding);
      widget.setHidden(false);
      assertFalse("getHidden after setHidden(false)", widget.getHidden());
      assertEquals("the height of the restored widget", dhBeforeHiding, widget.getDh());
      // the widget stands outside of any single content here, so there is nothing to take
      assertEquals("no width from a missing parent content", 0, widget.getDwFromParentContent());
      assertEquals("no height from a missing parent content", 0, widget.getDhFromParentContent());
      // a widget dragged out of the visible area has to be moved back into it
      widget.setCxy(-100, -100);
      widget.safePlace();
      assertEquals("the x coordinate after safePlace"
        , application.getComponentsConfig().getWidgetsMargin(), widget.getCx());
      assertEquals("the y coordinate after safePlace"
        , application.getComponentsConfig().getWidgetsMargin(), widget.getCy());
      // the sizes of the three modes of a widget
      widget.setIniSizes();
      assertTrue("the initialization width is a positive one", widget.getDw() > 0);
      assertTrue("the initialization height is a positive one", widget.getDh() > 0);
      widget.setDesktopSizes();
      widget.setMobileSizes();
      assertFalse("the mobile sizes restore the minimized widget", widget.getHidden());
      // the fullscreen of a widget, which is a property that is kept and displayed by the
      // widget layer holding that widget: this one stands outside of every widget layer, so
      // the property itself is all it takes here
      assertFalse("a new widget stands in no fullscreen", widget.getIsWidgetInFullscreen());
      assertFalse("a new widget is displayed in no fullscreen either"
        , widget.getIsWidgetDisplayedInFullscreen());
      widget.setIsWidgetInFullscreen(true);
      assertTrue("getIsWidgetInFullscreen after setIsWidgetInFullscreen(true)"
        , widget.getIsWidgetInFullscreen());
      widget.setIsWidgetInFullscreen(true);
      assertTrue("setIsWidgetInFullscreen can be called with the very same value"
        , widget.getIsWidgetInFullscreen());
      // the kept property alone does not fill the content: it is the widget layer that
      // displays a widget in fullscreen, and this one stands in no widget layer at all
      assertFalse("a widget of a desktop mode does not fill the whole content it stands in"
        , widget.isFillingTheWholeContent());
      // a widget filling the whole content it stands in takes both of its dimensions from
      // that content, so it can be sized by neither of its setters
      widget.setHidden(true);
      widget.setFullscreenSizes();
      assertFalse("the fullscreen sizes restore the minimized widget", widget.getHidden());
      assertTrue("getIsWidgetDisplayedInFullscreen after setFullscreenSizes"
        , widget.getIsWidgetDisplayedInFullscreen());
      assertTrue("isFillingTheWholeContent after setFullscreenSizes"
        , widget.isFillingTheWholeContent());
      const dwInFullscreen:int = widget.getDw();
      const dhInFullscreen:int = widget.getDh();
      widget.setDwh(dwInFullscreen + 100, dhInFullscreen + 100);
      assertEquals("the width of a fullscreen widget is not set by setDwh"
        , dwInFullscreen, widget.getDw());
      assertEquals("the height of a fullscreen widget is not set by setDwh"
        , dhInFullscreen, widget.getDh());
      widget.setDw(dwInFullscreen + 100);
      assertEquals("the width of a fullscreen widget is not set by setDw"
        , dwInFullscreen, widget.getDw());
      widget.setDh(dhInFullscreen + 100);
      assertEquals("the height of a fullscreen widget is not set by setDh"
        , dhInFullscreen, widget.getDh());
      // and the very corner of that content is the safe place of such a widget
      widget.setCxy(-100, -100);
      widget.safePlace();
      assertEquals("the x coordinate of a fullscreen widget after safePlace", 0, widget.getCx());
      assertEquals("the y coordinate of a fullscreen widget after safePlace", 0, widget.getCy());
      // the desktop sizes take this widget back among the widgets of its own container,
      // whatever that kept property says
      widget.setDesktopSizes();
      assertFalse("getIsWidgetDisplayedInFullscreen after setDesktopSizes"
        , widget.getIsWidgetDisplayedInFullscreen());
      assertFalse("isFillingTheWholeContent after setDesktopSizes"
        , widget.isFillingTheWholeContent());
      widget.setDwh(400, 300);
      assertEquals("the width of a widget standing in no fullscreen any more", 400, widget.getDw());
      // the pointer coming over a widget that has been left in fullscreen asks the widget
      // layer for that fullscreen back, and it is answered by the layer holding that
      // widget: this one stands in none of them, so nothing at all happens to it here
      widget.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
      widget.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      assertFalse("the roll over of a widget standing in no widget layer displays no fullscreen"
        , widget.getIsWidgetDisplayedInFullscreen());
      assertEquals("that roll over leaves the width of the widget alone", 400, widget.getDw());
      widget.setIsWidgetInFullscreen(false);
      assertFalse("getIsWidgetInFullscreen after setIsWidgetInFullscreen(false)"
        , widget.getIsWidgetInFullscreen());
      // the closing of the widget is dispatched to the widget layer
      assertTrue("onClose lets this widget be closed", widget.onClose());
      assertEquals("the closed event has been dispatched once", 1, closedCount);
      widget.setDwh(400, 300);
      widget.setHidden(false);
      runBaseSpriteTests(widget);
      widget.getBaseEventDispatcher().removeEventListener(EnumEvents.EVENT_WIDGET_CLOSED(), widgetClosed);
      removeTested(widget);
      application.getDynamicsConfig().setAppWidgetMode(origWidgetMode);
    }
    /**
     * Counts the closed events dispatched by the tested object.
     * @param e the widget closed event
     */
    private function widgetClosed(e:Event):void
    {
      closedCount++;
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      closedCount = 0;
    }
  }
}
