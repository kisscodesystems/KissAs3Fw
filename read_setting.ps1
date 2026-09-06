# The values telling where the tools and the files of this project are on this
# very computer - the java executable, the folder of the air sdk and so on - are
# not in the scripts of the project: they are different on every computer, so
# every one of them is stored in a file of its own in the project root, named
# after the setting itself. The value of JAVA is the first line of .JAVA, the
# value of AIRSDK_HOME is the first line of .AIRSDK_HOME, and so on.
# These files are in .gitignore: they belong to this computer only.
#
# This file is not run, it is dot sourced by the scripts needing those values:
# . "$root\read_setting.ps1"

# This file is in the project root, so the settings are next to it, whatever the
# working directory of the caller is.
$SETTINGS_ROOT = (Resolve-Path -LiteralPath $PSScriptRoot).Path

# Read-Setting NAME DESCRIPTION
# It returns the value of the setting called NAME. When there is no value stored
# for it yet, then it asks for one and stores it, so it is asked only once.
# The DESCRIPTION is the sentence telling the user what is being asked for.
# It stops the whole script when there is no usable value.
function Read-Setting([string]$Name, [string]$Description)
{
  $file = Join-Path $SETTINGS_ROOT ".$Name"
  $value = ''
  if (Test-Path -LiteralPath $file)
  {
    $firstLine = Get-Content -LiteralPath $file -TotalCount 1
    if ($null -ne $firstLine)
    {
      $value = $firstLine.Trim()
    }
  }
  if ($value -ne '')
  {
    return $value
  }
  # Everything said to the user is written by Write-Host, so the value returned
  # by this function stays the value alone.
  Write-Host " "
  Write-Host "The $Name of this project is not known yet."
  Write-Host "Please, give $Description!"
  while ($value -eq '')
  {
    $value = (Read-Host $Name).Trim()
    # An empty answer is the way to give this up.
    if ($value -eq '')
    {
      Write-Host "There is no $Name, so this can not go on."
      exit 1
    }
    if (-not (Test-Path -LiteralPath $value))
    {
      Write-Host "There is nothing at $value, please, give the right one!"
      $value = ''
    }
  }
  Set-Content -LiteralPath $file -Value $value
  Write-Host "It has been stored in $file, so you are asked for it only once."
  return $value
}
