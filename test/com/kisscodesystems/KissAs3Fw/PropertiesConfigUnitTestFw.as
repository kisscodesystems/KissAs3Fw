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
 * PropertiesConfigUnitTestFw
 * The properties config of the application that runs the unit test suites of the framework.
 *
 * MAIN FEATURES:
 * - it is the very properties config of the framework, with one single value changed: the
 *   keeping of the state is switched off
 * - with it on, a state saved when the window of a run loses the focus would be restored
 *   by the next run, and a suite would meet a language or a displaying style that an
 *   earlier run has left behind
 * - the keeping itself is checked by calling the saveState and the restoreState of the
 *   application directly, see com.kisscodesystems.KissAs3Fw.suite.StateManagerUnitTest
 */
package com.kisscodesystems.KissAs3Fw
{
  import com.kisscodesystems.KissAs3Fw.config.PropertiesConfig;
  public class PropertiesConfigUnitTestFw extends PropertiesConfig
  {
    /**
     * Constructs the properties config of the test application.
     * @param applicationRef the main application reference
     */
    public function PropertiesConfigUnitTestFw(applicationRef:Application):void
    {
      super(applicationRef);
    }
    /**
     * Reads every value of the framework, then switches the keeping of the state off.
     */
    override protected function readValuesFromConfigXml():void
    {
      super.readValuesFromConfigXml();
      stateKeepingEnabled = false;
    }
  }
}
