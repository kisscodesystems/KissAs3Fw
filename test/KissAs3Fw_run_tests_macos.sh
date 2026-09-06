#!/bin/bash
#
# Runs the KissAs3Fw unit tests.
#
# Compiles the test application against the current framework sources, then runs it
# with adl. The application builds every component, checks it and writes a report.
#
# ! On macOS: you have to have a valid license from harman: adt.lic !
# Without it adl prints the license banner and quits without running anything.
#
# The macos difference against KissAs3Fw_run_tests_linux.sh: macos has no timeout
# command, so run_with_timeout below does that job. Everything else is the same.
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
  AIRSDK=$(read_setting AIRSDK_HOME "the folder of the air sdk, for example /Users/myUser/AIRSDK_51.2.1")
fi
BUILD="$ROOT/build/testrun/as3"
RESULT="$BUILD/KissAs3Fw-results.txt"

# Starts the given command and kills it if it has not finished in time.
# The exit code is the one of the command, or 124 like the timeout of linux.
function run_with_timeout()
{
  RWT_SECONDS=$1
  shift
  "$@" &
  RWT_PID=$!
  RWT_WAITED=0
  while kill -0 "$RWT_PID" 2>/dev/null
  do
    if [ "$RWT_WAITED" -ge "$RWT_SECONDS" ]
    then
      kill -9 "$RWT_PID" 2>/dev/null
      wait "$RWT_PID" 2>/dev/null
      return 124
    fi
    sleep 1
    RWT_WAITED=$((RWT_WAITED + 1))
  done
  wait "$RWT_PID"
  return $?
}

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
run_with_timeout 300 "$AIRSDK/bin/adl" "$BUILD/KissAs3Fw-app.xml"
ADL_EXIT=$?
set -e

if [ ! -f "$RESULT" ]
then
  echo "No result file at $RESULT, the test application did not run (adl exit code: $ADL_EXIT)."
  exit 1
fi

cat "$RESULT"
exit "$ADL_EXIT"
