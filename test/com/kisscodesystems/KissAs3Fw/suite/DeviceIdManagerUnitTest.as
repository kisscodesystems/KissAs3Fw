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
 * DeviceIdManagerUnitTest
 * Checks the DeviceIdManager of the framework.
 *
 * MAIN FEATURES:
 * - the identifier of the device outlives the manager holding it, so this suite builds
 *   manager after manager on the very same device: the second one has to answer the value
 *   the first one has created
 * - every manager of this suite is a DeviceIdManagerUnderTest standing at the bottom of
 *   this file: it keeps its value under a name of its own, so the run of the tests never
 *   touches the identifier the application itself is known by, and it opens the two
 *   places that value is kept in up, which is what the healing below is checked with
 * - the two places heal each other: the suite takes the value out of one of them and the
 *   next manager has to answer it from the other one and write the missing one again
 * - a payload that has been rewritten by anyone is thrown away instead of being answered
 * - the suite leaves the device the way it has found it: the value of the test manager is
 *   forgotten at the end of the run
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  public class DeviceIdManagerUnitTest extends BaseUnitTest
  {
    // the number of the characters one identifier is written with
    private const DEVICE_ID_CHARACTERS:int = 32;
    private var managerUnderTest:DeviceIdManagerUnderTest = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function DeviceIdManagerUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "DeviceIdManager";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      runApplicationManagerTests();
      // the device is left the way it has been found, before the first assertion and
      // after the last one alike: a run that has been broken off leaves a value behind
      forgetEverything();
      runCreatingTests();
      runKeepingTests();
      runHealingTests();
      runRewritingTests();
      runForgettingTests();
      forgetEverything();
    }
    /**
     * Checks the manager of the running application: the framework builds one for every
     * application, and this suite asks nothing of it, because asking would write the
     * identifier of this very test application onto this machine.
     */
    protected function runApplicationManagerTests():void
    {
      assertNotNull("the application has a manager of the identifier of the device"
        , application.getDeviceIdManager());
      // both of the properties that manager works with have to carry a value: a name that
      // is missing would keep every application under one and the same name
      assertTrue("the name the identifier is kept under is not empty"
        , application.getPropertiesConfig().getDeviceIdStoreName().length > 0);
      assertTrue("the secret the identifier is enciphered with is not empty"
        , application.getPropertiesConfig().getDeviceIdSecret().length > 0);
      assertFalse("the manager of the application knows nothing of the device before it is asked"
        , application.getDeviceIdManager().isNewDeviceId());
    }
    /**
     * Checks the creating of the identifier: the very first call is the one making it.
     */
    protected function runCreatingTests():void
    {
      managerUnderTest = new DeviceIdManagerUnderTest(application);
      assertFalse("the manager tells of no new identifier before it is asked"
        , managerUnderTest.isNewDeviceId());
      const deviceId:String = managerUnderTest.getDeviceId();
      assertEquals("the identifier is thirty-two characters long", DEVICE_ID_CHARACTERS
        , deviceId.length);
      assertTrue("the identifier is a hexadecimal one", isHexadecimal(deviceId));
      assertTrue("the manager tells that the identifier has been created in this run"
        , managerUnderTest.isNewDeviceId());
      assertEquals("the manager answers the very same identifier again", deviceId
        , managerUnderTest.getDeviceId());
      // both of the places hold it now, and neither of them holds it in the clear
      assertEquals("the encrypted local store holds the identifier", deviceId
        , managerUnderTest.getIdOfEncryptedLocalStore());
      assertEquals("the shared object holds the identifier", deviceId
        , managerUnderTest.getIdOfSharedObject());
      assertTrue("the shared object holds the identifier enciphered"
        , managerUnderTest.getPayloadOfSharedObjectAsHex().indexOf(deviceId) < 0);
    }
    /**
     * Checks the keeping of the identifier: a manager built after the one that has
     * created it answers that very value, and it tells that it is not a new one.
     */
    protected function runKeepingTests():void
    {
      const deviceId:String = managerUnderTest.getDeviceId();
      managerUnderTest.destroy();
      managerUnderTest = new DeviceIdManagerUnderTest(application);
      assertEquals("the manager built after the first one answers the same identifier"
        , deviceId, managerUnderTest.getDeviceId());
      assertFalse("that manager tells that the identifier is not a new one"
        , managerUnderTest.isNewDeviceId());
    }
    /**
     * Checks the healing of the two places the identifier is kept in: the one that has
     * been lost is written again from the one that is still there.
     */
    protected function runHealingTests():void
    {
      const deviceId:String = managerUnderTest.getDeviceId();
      // the shared object is lost, the encrypted local store carries the identifier
      managerUnderTest.removeFromSharedObjectForTesting();
      assertEquals("the shared object is empty after it has been taken away", ""
        , managerUnderTest.getIdOfSharedObject());
      managerUnderTest.destroy();
      managerUnderTest = new DeviceIdManagerUnderTest(application);
      assertEquals("the identifier is answered from the encrypted local store", deviceId
        , managerUnderTest.getDeviceId());
      assertFalse("that identifier is not a new one", managerUnderTest.isNewDeviceId());
      assertEquals("the shared object has been written again", deviceId
        , managerUnderTest.getIdOfSharedObject());
      // and the other way round: the encrypted local store is lost this time
      managerUnderTest.removeFromEncryptedLocalStoreForTesting();
      assertEquals("the encrypted local store is empty after it has been taken away", ""
        , managerUnderTest.getIdOfEncryptedLocalStore());
      managerUnderTest.destroy();
      managerUnderTest = new DeviceIdManagerUnderTest(application);
      assertEquals("the identifier is answered from the shared object", deviceId
        , managerUnderTest.getDeviceId());
      assertFalse("that identifier is not a new one either", managerUnderTest.isNewDeviceId());
      assertEquals("the encrypted local store has been written again", deviceId
        , managerUnderTest.getIdOfEncryptedLocalStore());
    }
    /**
     * Checks what a payload that has been rewritten by anyone gives: nothing at all, so
     * the manager creates a new identifier instead of answering a value it cannot trust.
     */
    protected function runRewritingTests():void
    {
      const deviceId:String = managerUnderTest.getDeviceId();
      managerUnderTest.rewriteOneByteOfSharedObjectForTesting();
      assertEquals("the shared object answers nothing after one byte of it has been rewritten"
        , "", managerUnderTest.getIdOfSharedObject());
      // the encrypted local store still carries it, so that rewritten payload is simply
      // written again: the identifier of the device stands
      managerUnderTest.destroy();
      managerUnderTest = new DeviceIdManagerUnderTest(application);
      assertEquals("the identifier stands, the rewritten payload is thrown away", deviceId
        , managerUnderTest.getDeviceId());
      assertEquals("the rewritten shared object has been written again", deviceId
        , managerUnderTest.getIdOfSharedObject());
    }
    /**
     * Checks the forgetting: both of the places are emptied and the next manager creates
     * an identifier of its own, another one than the one that has been forgotten.
     */
    protected function runForgettingTests():void
    {
      const deviceId:String = managerUnderTest.getDeviceId();
      managerUnderTest.forgetDeviceId();
      assertEquals("the encrypted local store is empty after the forgetting", ""
        , managerUnderTest.getIdOfEncryptedLocalStore());
      assertEquals("the shared object is empty after the forgetting", ""
        , managerUnderTest.getIdOfSharedObject());
      assertFalse("the manager tells of no new identifier after the forgetting"
        , managerUnderTest.isNewDeviceId());
      const newDeviceId:String = managerUnderTest.getDeviceId();
      assertEquals("the new identifier is thirty-two characters long", DEVICE_ID_CHARACTERS
        , newDeviceId.length);
      assertFalse("the new identifier is another one than the forgotten one"
        , newDeviceId == deviceId);
      assertTrue("the manager tells that this identifier has been created in this run"
        , managerUnderTest.isNewDeviceId());
    }
    /**
     * Takes the identifier of the test manager off this device and frees that manager.
     */
    protected function forgetEverything():void
    {
      if (managerUnderTest == null)
      {
        managerUnderTest = new DeviceIdManagerUnderTest(application);
      }
      managerUnderTest.forgetDeviceId();
      managerUnderTest.destroy();
      managerUnderTest = null;
    }
    /**
     * Tells whether the given string holds hexadecimal characters only.
     * @param text the string to be looked at
     */
    private function isHexadecimal(text:String):Boolean
    {
      if (text == null || text.length == 0)
      {
        return false;
      }
      return text.search(/^[0-9a-f]+$/) == 0;
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      if (managerUnderTest != null)
      {
        managerUnderTest.destroy();
      }
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      managerUnderTest = null;
    }
  }
}
import com.kisscodesystems.KissAs3Fw.Application;
import com.kisscodesystems.KissAs3Fw.manager.DeviceIdManager;
import flash.net.SharedObject;
import flash.utils.ByteArray;
/**
 * DeviceIdManagerUnderTest: the manager this suite talks to. It keeps its identifier
 * under a name of its own, so nothing of the run touches the value the test application
 * itself is known by, and it opens the two places that identifier is kept in up: the
 * suite reads them one by one, takes them away one by one and rewrites one of them, which
 * is what the healing and the throwing away of an untrusted payload are checked with.
 */
internal class DeviceIdManagerUnderTest extends DeviceIdManager
{
  // the name of the value of this manager: another one than the name of any application
  public static const STORE_NAME:String = "KissAs3UtDeviceIdUnderTest";
  // the name of the value inside the shared object, the one the manager writes
  private const SHARED_OBJECT_VALUE_NAME:String = "deviceId";
  /**
   * Constructs the manager under test. The name of the value is rewritten here, after the
   * constructor of the manager has taken the one of the application: nothing is read from
   * the device and nothing is written onto it before the identifier is asked for, so this
   * manager works with this name from its very first call on.
   * @param applicationRef the main application reference
   */
  public function DeviceIdManagerUnderTest(applicationRef:Application):void
  {
    super(applicationRef);
    storeName = STORE_NAME;
  }
  /**
   * Returns the identifier held by the encrypted local store at this moment, the empty
   * string when there is none.
   */
  public function getIdOfEncryptedLocalStore():String
  {
    return readFromEncryptedLocalStore();
  }
  /**
   * Returns the identifier held by the shared object at this moment, the empty string
   * when there is none.
   */
  public function getIdOfSharedObject():String
  {
    return readFromSharedObject();
  }
  /**
   * Returns the payload standing in the shared object as a hexadecimal string, so the
   * suite can look for the identifier inside it.
   */
  public function getPayloadOfSharedObjectAsHex():String
  {
    const sharedObject:SharedObject = openSharedObject();
    if (sharedObject == null)
    {
      return "";
    }
    const payload:ByteArray = sharedObject.data[SHARED_OBJECT_VALUE_NAME] as ByteArray;
    var hex:String = "";
    if (payload != null)
    {
      hex = crypto.bytesToHex(payload);
    }
    sharedObject.close();
    return hex;
  }
  /**
   * Takes the identifier out of the encrypted local store and leaves the shared object
   * as it stands.
   */
  public function removeFromEncryptedLocalStoreForTesting():void
  {
    removeFromEncryptedLocalStore();
  }
  /**
   * Takes the identifier out of the shared object and leaves the encrypted local store
   * as it stands.
   */
  public function removeFromSharedObjectForTesting():void
  {
    removeFromSharedObject();
  }
  /**
   * Rewrites one single byte of the payload standing in the shared object: that is the
   * payload nobody may trust from then on.
   */
  public function rewriteOneByteOfSharedObjectForTesting():void
  {
    const sharedObject:SharedObject = openSharedObject();
    if (sharedObject == null)
    {
      return;
    }
    const payload:ByteArray = sharedObject.data[SHARED_OBJECT_VALUE_NAME] as ByteArray;
    if (payload != null && payload.length > 0)
    {
      payload[payload.length - 1] = payload[payload.length - 1] ^ 0x01;
      sharedObject.data[SHARED_OBJECT_VALUE_NAME] = payload;
      sharedObject.flush();
    }
    sharedObject.close();
  }
}
