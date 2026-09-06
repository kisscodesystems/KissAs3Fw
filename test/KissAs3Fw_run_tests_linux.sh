#!/bin/bash
#
# Runs the KissAs3Fw unit tests.
#
# Compiles the test application against the current framework sources, then runs it
# with adl. The application builds every component, checks it and writes a report.
#
# The application displays the summary of the run in its own window as well - the counts,
# the time it took, the exit code, the path of this report and the failed assertions - and
# it closes that window by itself a few seconds later. Those seconds are the reason this
# script takes a little longer than the run itself: SECONDS_TO_DISPLAY in
# test/com/kisscodesystems/KissAs3Fw/ApplicationUnitTest.as is the knob of it.
#
# ! On Linux: you have to have a valid license from harman: adt.lic !
# Without it adl prints the license banner and quits without running anything.
#
set -e
cd "$(dirname "$0")/.."
ROOT="$(pwd)"

# The folder of the air sdk. It can be given in the AIRSDK environment variable,
# otherwise it comes from .AIRSDK_HOME of the project root, and it is asked for
# once when there is no value stored there yet. See ./read_setting.sh.
source "$ROOT/read_setting.sh"
if [ -z "$AIRSDK" ]
then
  AIRSDK=$(read_setting AIRSDK_HOME "the folder of the air sdk, for example /home/myUser/AIRSDK_51.2.1")
fi
BUILD="$ROOT/build/testrun/as3"
RESULT="$BUILD/KissAs3Fw-results.txt"

rm -rf "$BUILD"
mkdir -p "$BUILD"

# 1. Compile the test application against the current sources.
"$AIRSDK/bin/mxmlc" +configname=air \
  -source-path="$ROOT/src" -source-path="$ROOT/test" \
  -output="$BUILD/ApplicationUnitTest.swf" \
  "$ROOT/test/com/kisscodesystems/KissAs3Fw/ApplicationUnitTest.as"

# 2. The descriptor has to sit next to the swf it points to. The application writes
#    its report next to that descriptor as well.
cp "$ROOT/test/KissAs3Fw-app.xml" "$BUILD/KissAs3Fw-app.xml"

# 3. Run it. The application quits by itself when the last suite is done.
set +e
timeout 300 "$AIRSDK/bin/adl" "$BUILD/KissAs3Fw-app.xml"
ADL_EXIT=$?
set -e

if [ ! -f "$RESULT" ]
then
  echo "No result file at $RESULT, the test application did not run (adl exit code: $ADL_EXIT)."
  exit 1
fi

cat "$RESULT"
exit "$ADL_EXIT"
