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
 * BaseAlerter.
 * The base class of every object that has to ask something before it does its work.
 *
 * MAIN FEATURES:
 * - it displays alert and confirm messages on the foreground of the application
 * - the answers arrive as events on the dispatcher of the application, so it keeps
 *   a note of every answer it is still waiting for
 * - an unanswered alert or confirm is freed up by the destroy of this object
 */
package com.kisscodesystems.KissAs3Fw.base
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.enum.EnumOkCancel;
  import flash.events.Event;
  public class BaseAlerter extends BaseSprite
  {
    protected var alertOK:Function = null;
    protected var confirmOK:Function = null;
    protected var confirmCancel:Function = null;
    private var pendingTypes:Array = null;
    private var pendingFunctions:Array = null;
    /**
     * Constructs the alerter object which is able to display alert and confirm messages.
     * @param applicationRef the application reference passed to the base sprite
     */
    public function BaseAlerter(applicationRef:Application):void
    {
      super(applicationRef);
      application.trace("<" + this + " BaseAlerter> called.", 1);
      application.trace("<" + this + " BaseAlerter> applicationRef: " + applicationRef, 0);
      pendingTypes = new Array();
      pendingFunctions = new Array();
      application.trace("<" + this + " BaseAlerter> constructed.", 1);
    }
    /**
     * Displays a confirm message and wires the ok and cancel handlers to the base event dispatcher.
     * @param messageString the message to be displayed in the confirm
     */
    protected function showConfirm(messageString:String):void
    {
      application.trace("<" + this + " BaseAlerter showConfirm> called.", 1);
      application.trace("<" + this + " BaseAlerter showConfirm> messageString: " + messageString, 0);
      const uniqueString:String = application.getUtils().getRandomGuid();
      const okType:String = uniqueString + EnumOkCancel.OC_OK();
      const cancelType:String = uniqueString + EnumOkCancel.OC_CANCEL();
      var okFunction:Function = null;
      var cancelFunction:Function = null;
      okFunction = function(e:Event):void
      {
        closeTheAlert(uniqueString);
        // both of the answers have to be unregistered by their own types, the one of the
        // event that has arrived would leave the other answer on the dispatcher forever
        clearPending(okType, okFunction);
        clearPending(cancelType, cancelFunction);
        if (confirmOK != null)
        {
          confirmOK();
        }
        e.stopImmediatePropagation();
      };
      cancelFunction = function(e:Event):void
      {
        closeTheAlert(uniqueString);
        clearPending(okType, okFunction);
        clearPending(cancelType, cancelFunction);
        if (confirmCancel != null)
        {
          confirmCancel();
        }
        e.stopImmediatePropagation();
      };
      addPending(okType, okFunction);
      addPending(cancelType, cancelFunction);
      if (application.getForeground() != null)
      {
        application.getForeground().createAlert(messageString, uniqueString, true, true);
      }
      else
      {
        application.trace("<" + this + " BaseAlerter showConfirm> there is no foreground to display the confirm on.", 6);
      }
    }
    /**
     * Displays an alert message and wires the ok handler to the base event dispatcher.
     * @param messageString the message to be displayed in the alert
     * @param fullscreen whether the alert should be displayed in fullscreen mode
     */
    protected function showAlert(messageString:String, fullscreen:Boolean = false):void
    {
      application.trace("<" + this + " BaseAlerter showAlert> called.", 1);
      application.trace("<" + this + " BaseAlerter showAlert> messageString: " + messageString, 0);
      application.trace("<" + this + " BaseAlerter showAlert> fullScreen: " + fullscreen, 0);
      const uniqueString:String = application.getUtils().getRandomGuid();
      const okType:String = uniqueString + EnumOkCancel.OC_OK();
      const okFunction:Function = function(e:Event):void
      {
        closeTheAlert(uniqueString);
        clearPending(okType, okFunction);
        if (alertOK != null)
        {
          alertOK();
        }
        e.stopImmediatePropagation();
      };
      addPending(okType, okFunction);
      if (application.getForeground() != null)
      {
        application.getForeground().createAlert(messageString, uniqueString, true, false, false, fullscreen);
      }
      else
      {
        application.trace("<" + this + " BaseAlerter showAlert> there is no foreground to display the alert on.", 6);
      }
    }
    /**
     * Closes the alert or the confirm belonging to the given unique string.
     * @param uniqueString the unique identifier of that alert or confirm
     */
    private function closeTheAlert(uniqueString:String):void
    {
      application.trace("<" + this + " BaseAlerter closeTheAlert> called.", 1);
      application.trace("<" + this + " BaseAlerter closeTheAlert> uniqueString: " + uniqueString, 0);
      if (application.getForeground() != null)
      {
        application.getForeground().closeAlert(uniqueString);
      }
    }
    /**
     * Registers one answer of an alert or of a confirm on the dispatcher of the application
     * and keeps a note of it, so that an unanswered one can be freed up by the destroy.
     * @param type the event type of that answer
     * @param answerFunction the function handling that answer
     */
    private function addPending(type:String, answerFunction:Function):void
    {
      application.trace("<" + this + " BaseAlerter addPending> called.", 1);
      application.trace("<" + this + " BaseAlerter addPending> type: " + type, 0);
      application.trace("<" + this + " BaseAlerter addPending> answerFunction: " + answerFunction, 0);
      pendingTypes.push(type);
      pendingFunctions.push(answerFunction);
      application.getBaseEventDispatcher().addEventListener(type, answerFunction);
    }
    /**
     * Unregisters one answer of an alert or of a confirm and drops the note of it.
     * @param type the event type of that answer
     * @param answerFunction the function handling that answer
     */
    private function clearPending(type:String, answerFunction:Function):void
    {
      application.trace("<" + this + " BaseAlerter clearPending> called.", 1);
      application.trace("<" + this + " BaseAlerter clearPending> type: " + type, 0);
      application.trace("<" + this + " BaseAlerter clearPending> answerFunction: " + answerFunction, 0);
      application.getBaseEventDispatcher().removeEventListener(type, answerFunction);
      const index:int = pendingTypes.indexOf(type);
      if (index > -1)
      {
        pendingTypes.splice(index, 1);
        pendingFunctions.splice(index, 1);
      }
    }
    /**
     * Frees up everything and destroys this object.
     */
    override public function destroy():void
    {
      application.trace("<" + this + " BaseAlerter destroy> called.", 1);
      application.trace("<" + this + " BaseAlerter destroy> unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()", 0);
      // an alert or a confirm that has never been answered still holds its own handlers on
      // the dispatcher of the application, and those handlers hold this object as well
      for (var i:int = pendingTypes.length - 1; i > -1; i--)
      {
        application.getBaseEventDispatcher().removeEventListener(String(pendingTypes[i]), Function(pendingFunctions[i]));
      }
      application.trace("<" + this + " BaseAlerter destroy> free up everything: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.", 0);
      pendingTypes.splice(0);
      pendingFunctions.splice(0);
      application.trace("<" + this + " BaseAlerter destroy> calling the super destroy and clearing everything.", 0);
      super.destroy();
      alertOK = null;
      confirmOK = null;
      confirmCancel = null;
      pendingTypes = null;
      pendingFunctions = null;
    }
  }
}
