# Runs the KissAs3Fw unit tests.
#
# > powershell -ExecutionPolicy Bypass -File .\KissAs3Fw_run_tests_windows.ps1
#
# Compiles the test application against the current framework sources, then runs it
# with adl. The application builds every component, checks it and writes a report.
#
# The path of the air sdk can be given in the AIRSDK environment variable.

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Join-Path $PSScriptRoot '..')
$root = (Get-Location).Path

# The folder of the air sdk. It can be given in the AIRSDK environment variable,
# otherwise it comes from .AIRSDK_HOME of the project root, and it is asked for
# once when there is no value stored there yet. See .\read_setting.ps1.
. (Join-Path $root 'read_setting.ps1')
$airsdk = if ($env:AIRSDK) { $env:AIRSDK } else { Read-Setting 'AIRSDK_HOME' 'the folder of the air sdk, for example C:\AIRSDK_51.2.1' }
$build = Join-Path $root 'build\testrun\as3'
$result = Join-Path $build 'KissAs3Fw-results.txt'

if (Test-Path -LiteralPath $build)
{
  Remove-Item -LiteralPath $build -Recurse -Force
}
New-Item -ItemType Directory -Path $build -Force | Out-Null

# 1. Compile the test application against the current sources.
& (Join-Path $airsdk 'bin\mxmlc.bat') '+configname=air' `
  "-source-path=$root\src" "-source-path=$root\test" `
  "-output=$build\ApplicationUnitTest.swf" `
  "$root\test\com\kisscodesystems\KissAs3Fw\ApplicationUnitTest.as"
if ($LASTEXITCODE -ne 0)
{
  Write-Output "The test application could not be compiled."
  exit 1
}

# 2. The descriptor has to sit next to the swf it points to. The application writes
#    its report next to that descriptor as well.
Copy-Item -LiteralPath (Join-Path $root 'test\KissAs3Fw-app.xml') -Destination (Join-Path $build 'KissAs3Fw-app.xml')

# 3. Run it. The application quits by itself when the last suite is done.
$adl = Start-Process -FilePath (Join-Path $airsdk 'bin\adl.exe') `
  -ArgumentList (Join-Path $build 'KissAs3Fw-app.xml') -NoNewWindow -PassThru
if (-not $adl.WaitForExit(300000))
{
  $adl.Kill()
  Write-Output "The test application did not finish in 300 seconds, it has been killed."
}
$adlExit = $adl.ExitCode

if (-not (Test-Path -LiteralPath $result))
{
  Write-Output "No result file at $result, the test application did not run (adl exit code: $adlExit)."
  exit 1
}

Get-Content -LiteralPath $result
exit $adlExit
