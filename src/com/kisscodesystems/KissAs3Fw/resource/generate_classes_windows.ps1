# The windows version of generate_classes.sh, it writes exactly the same classes.
#
# > powershell -ExecutionPolicy Bypass -File .\generate_classes.ps1
#
# Run this if the followings have been changed:
# - icons added or removed
# - sounds added or removed
# - emojis added or removed
# - label xml has changed
# This will regenerate the classes:
# - manager/EmojiManager.as
# - manager/IconManager.as
# - manager/SoundManager.as
# - enum/EnumEmojis.as
# - enum/EnumIcons.as
# - enum/EnumSounds.as
# - enum/EnumTextKeys.as

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

# The files are collected into memory and written out at the very end, so that
# every line ends with a single \n and no byte order mark is put in front of them.
# Set-Target is the > of the shell, Add-Target is the >> and Add-TargetPart is the echo -n.
$script:targets = @{}

function Set-Target([string] $path, [string] $text)
{
  $script:targets[$path] = [System.Text.StringBuilder]::new()
  [void]$script:targets[$path].Append($text).Append("`n")
}

function Add-Target([string] $path, [string] $text)
{
  [void]$script:targets[$path].Append($text).Append("`n")
}

function Add-TargetPart([string] $path, [string] $text)
{
  [void]$script:targets[$path].Append($text)
}

function Save-Targets()
{
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  foreach ($path in $script:targets.Keys)
  {
    $full = [System.IO.Path]::GetFullPath((Join-Path (Get-Location).Path $path))
    [System.IO.File]::WriteAllText($full, $script:targets[$path].ToString(), $utf8NoBom)
  }
}

# The sort of the shell runs under a utf-8 locale, where the punctuation of a name is
# only a tie breaker and not a character of its own. Sorting circlefull before circle
# comes from that rule. This reproduces the very same order on every machine.
#
# The extension is cut off the sort key as well, the way the shell scripts do it, so the
# order of the generated members does not depend on which extension the resources of a
# folder happen to have.
function Sort-LikeTheShell([string[]] $items)
{
  $list = [System.Collections.Generic.List[string]]::new()
  foreach ($item in $items)
  {
    [void]$list.Add($item)
  }
  $list.Sort([System.Comparison[string]] {
    param([string] $a, [string] $b)
    $keyA = ($a -replace '\.[^./]*$', '') -replace '[_./]', ''
    $keyB = ($b -replace '\.[^./]*$', '') -replace '[_./]', ''
    $result = [string]::CompareOrdinal($keyA, $keyB)
    if ($result -eq 0)
    {
      $result = [string]::CompareOrdinal($a, $b)
    }
    return $result
  })
  return $list.ToArray()
}

# The list the shell gets from: find "$BASE" -name "*.$FILEEXT" | sort
# with the base folder already cut off the front of every path.
function Get-ResourceFiles([string] $folderName, [string] $fileExt)
{
  $root = (Get-Item -LiteralPath $folderName).FullName
  $items = @()
  foreach ($file in (Get-ChildItem -LiteralPath $folderName -Recurse -File))
  {
    if ($file.Name.EndsWith("." + $fileExt))
    {
      $items += ($file.FullName.Substring($root.Length + 1) -replace '\\', '/')
    }
  }
  return (Sort-LikeTheShell $items)
}

# The list the shell gets from: find "$BASE" -type d | sort
# The base folder itself becomes an empty name there and is skipped, so it is left out here.
function Get-ResourceDirectories([string] $folderName)
{
  $root = (Get-Item -LiteralPath $folderName).FullName
  $items = @()
  foreach ($directory in (Get-ChildItem -LiteralPath $folderName -Recurse -Directory))
  {
    $items += ($directory.FullName.Substring($root.Length + 1) -replace '\\', '/')
  }
  return (Sort-LikeTheShell $items)
}

# The basename of a resource path without its extension: the sed pipe of the shell.
function Get-ResourceName([string] $relativePath, [string] $fileExt)
{
  return (($relativePath -replace '.*/', '') -replace ('\.' + $fileExt), '')
}

# Runs the SVG to KVG1 converter of the framework over a resource folder. The interpreter
# is called python3 on some machines and python on others, so both names are tried.
function Invoke-SvgToKvg([string] $sourceFolder, [string] $targetFile)
{
  $python = Get-Command python3 -ErrorAction SilentlyContinue
  if ($null -eq $python)
  {
    $python = Get-Command python -ErrorAction SilentlyContinue
  }
  if ($null -eq $python)
  {
    Write-Output "python3 is needed to build the emoji blob!"
    exit 1
  }
  & $python.Path "./svg_to_kvg.py" $sourceFolder $targetFile
  if ($LASTEXITCODE -ne 0)
  {
    exit 1
  }
}

# The first folder of a resource path: the category of an emoji.
function Get-CategoryName([string] $relativePath)
{
  return ($relativePath -replace '/.*', '')
}

# The header comment block every generated class starts with.
function Write-Header([string] $path, [string] $className, [string] $classDesc)
{
  Set-Target $path "/**"
  Add-Target $path " * This class is a part of the KissAs3Fw ActionScript framework."
  Add-Target $path " * See the header comment lines of the"
  Add-Target $path " * com.kisscodesystems.KissAs3Fw.Application"
  Add-Target $path " * The whole framework is available at:"
  Add-Target $path " * https://github.com/kisscodesystems/KissAs3Fw"
  Add-Target $path " * Demo applications:"
  Add-Target $path " * https://github.com/kisscodesystems/KissAs3Dm"
  Add-Target $path " *"
  Add-Target $path " * DESCRIPTION:"
  Add-Target $path " * $className."
  Add-Target $path " * $classDesc."
  Add-Target $path " * This class is generated so can be overwritten from outside."
  Add-Target $path " */"
}

function Invoke-GenerateTextkeys()
{
  $className2 = 'TextKeys'
  $classDesc = 'Contains text keys already having in xml file'

  $target = "../enum/Enum${className2}.as"

  $keys = @()
  foreach ($line in (Get-Content -LiteralPath 'label/KissAs3FwLabels.xml'))
  {
    if ($line -match 'key=')
    {
      $key = $line -replace '.*key="', ''
      $key = [regex]::new('">').Replace($key, '', 1)
      foreach ($token in ($key -split '\s+'))
      {
        if ($token -ne '')
        {
          $keys += $token
        }
      }
    }
  }

  Write-Header $target "Enum${className2}" $classDesc

  Add-Target $target 'package com.kisscodesystems.KissAs3Fw.enum'
  Add-Target $target '{'

  Add-Target $target "  public class Enum${className2}"
  Add-Target $target '  {'

  foreach ($i in $keys)
  {
    Add-Target $target "    public static function ${i}():String"
    Add-Target $target "    {"
    Add-Target $target "      return `"[${i}]`";"
    Add-Target $target "    }"
  }

  Add-Target $target "  }"
  Add-Target $target "}"
}

# Writes the destroy method of the manager class being generated, and the small helper that
# method needs when the embedded resources are bitmaps. It has to be called as the last one
# of the generators of the methods: the destroy method closes the class in the coding
# standards.
#
# An icon and a sound is instantiated into a field of its own, so every one of them has to
# be released one by one. A bitmap carries a bitmap data that is not freed up by the garbage
# collector, that one is disposed explicitly. A sound holds no such resource and close()
# throws an error on an embedded one, so those fields are only dropped. The emojis are one
# embedded blob instead, and the object reading it frees up what it built.
function Write-Destroy([string] $target, [string] $className, [string] $asClass, [string] $folderName, [string[]] $list, [string] $fileExt, [string] $blob)
{
  if ($asClass -eq "Bitmap")
  {
    Add-Target $target "    /**"
    Add-Target $target "     * Disposes the bitmap data of the given bitmap."
    Add-Target $target "     * @param bitmap the bitmap the data of which has to be freed up"
    Add-Target $target "     */"
    Add-Target $target "    protected function disposeBitmap(bitmap:Bitmap):void"
    Add-Target $target "    {"
    Add-Target $target "      if (bitmap != null && bitmap.bitmapData != null)"
    Add-Target $target "      {"
    Add-Target $target "        bitmap.bitmapData.dispose();"
    Add-Target $target "      }"
    Add-Target $target "    }"
  }

  Add-Target $target "    /**"
  Add-Target $target "     * Destroys this object and frees up everything."
  Add-Target $target "     */"
  Add-Target $target "    public function destroy():void"
  Add-Target $target "    {"
  Add-Target $target "      application.trace(`"<$className destroy> called.`", 1);"

  if ($blob -ne "")
  {
    Add-Target $target "      if (drawings != null)"
    Add-Target $target "      {"
    Add-Target $target "        drawings.destroy();"
    Add-Target $target "      }"
  }
  else
  {
    foreach ($path in $list)
    {
      $i = Get-ResourceName $path $fileExt
      if ($asClass -eq "Bitmap")
      {
        Add-Target $target "      disposeBitmap(${i}$asClass);"
      }
      Add-Target $target "      ${i}$asClass = null;"
    }
  }

  if ($folderName -eq "emoji")
  {
    Add-Target $target "      emojiNames = null;"
    Add-Target $target "      emojiDrawings = null;"
    Add-Target $target "      drawings = null;"
  }

  Add-Target $target "      files = null;"
  Add-Target $target "      application = null;"
  Add-Target $target "    }"
}

function Invoke-GenerateClass([string] $folderName)
{
  $className = ''
  $className2 = ''
  $classDesc = ''
  $asClass = ''
  $fileExt = ''
  $blob = ''

  if ($folderName -eq "icon")
  {
    $className = 'IconManager'
    $className2 = 'Icons'
    $classDesc2 = 'Contains the icon names that can be used'
    $classDesc = 'Handles icons that can be used on labels'
    $asClass = 'Bitmap'
    $fileExt = 'png'
  }
  elseif ($folderName -eq "emoji")
  {
    $className = 'EmojiManager'
    $className2 = 'Emojis'
    $classDesc2 = 'Contains the emoji names that can be used'
    $classDesc = 'Handles emojis that can be used on objects when available'
    $asClass = 'VectorDrawings'
    $fileExt = 'svg'
    $blob = 'emojis'
  }
  elseif ($folderName -eq "sound")
  {
    $className = 'SoundManager'
    $className2 = 'Sounds'
    $classDesc2 = 'Contains the sound names that can be used'
    $classDesc = 'Handles embedded sounds'
    $asClass = 'Sound'
    $fileExt = 'mp3'
  }
  else
  {
    Write-Output "icon or emoji or sound can be used as parameter!"
    exit 1
  }

  $folderDelta = "../resource/$folderName"

  # The emojis are vector drawings and ActionScript can display neither an SVG nor an
  # FXG, so every one of them is flattened into one blob of the drawing commands the
  # runtime does understand, before the manager embedding that blob is written.
  # See resource/svg_to_kvg.py and util/VectorDrawings.as
  if ($blob -ne "")
  {
    Invoke-SvgToKvg $folderName "$folderName/$blob.kvg"
  }

  $list = Get-ResourceFiles $folderName $fileExt
  $list2 = Get-ResourceDirectories $folderName
  $target = "../manager/${className}.as"
  $target2 = "../enum/Enum${className2}.as"

  Write-Header $target $className $classDesc

  Add-Target $target 'package com.kisscodesystems.KissAs3Fw.manager'
  Add-Target $target '{'
  Add-Target $target '  import com.kisscodesystems.KissAs3Fw.Application;'
  Write-Header $target2 "Enum${className2}" $classDesc2
  Add-Target $target2 'package com.kisscodesystems.KissAs3Fw.enum'
  Add-Target $target2 '{'

  if ($folderName -eq "icon")
  {
    Add-Target $target '  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;'
  }

  if ($folderName -eq "icon")
  {
    Add-Target $target '  import flash.display.Bitmap;'
    Add-Target $target '  import flash.display.BitmapData;'
    Add-Target $target '  import flash.geom.Matrix;'
  }
  elseif ($folderName -eq "emoji")
  {
    Add-Target $target '  import com.kisscodesystems.KissAs3Fw.util.VectorDrawings;'
    Add-Target $target '  import flash.display.BitmapData;'
  }
  elseif ($folderName -eq "sound")
  {
    Add-Target $target '  import flash.media.Sound;'
    Add-Target $target '  import flash.media.SoundChannel;'
    Add-Target $target '  import flash.media.SoundTransform;'
  }

  Add-Target $target '  import flash.system.System;'

  if ($blob -ne "")
  {
    Add-Target $target '  import flash.utils.ByteArray;'
  }
  Add-Target $target "  public class $className"
  Add-Target $target '  {'
  Add-Target $target '    protected var application:Application = null;'
  Add-Target $target2 "  public class Enum${className2}"
  Add-Target $target2 '  {'

  if ($folderName -eq "emoji")
  {
    Add-Target $target '    protected var emojiNames:Array = new Array();'
    Add-Target $target '    protected var emojiDrawings:Array = new Array();'
    Add-Target $target '    protected var drawings:VectorDrawings = null;'
  }

  foreach ($path in $list)
  {
    $i = Get-ResourceName $path $fileExt
    if ($blob -eq "")
    {
      Add-Target $target "    private var ${i}${asClass}:$asClass;"
    }
    Add-Target $target2 "    public static function ${i}():String"
    Add-Target $target2 "    {"
    Add-Target $target2 "      return `"${i}`";"
    Add-Target $target2 "    }"
  }

  Add-Target $target "    private var files:${className}Files = new ${className}Files();"

  Add-Target $target "    public function $className(applicationRef:Application):void"
  Add-Target $target "    {"
  Add-Target $target "      super();"
  Add-Target $target "      if (applicationRef != null)"
  Add-Target $target "      {"
  Add-Target $target "        application = applicationRef;"
  Add-Target $target "      }"
  Add-Target $target "      else"
  Add-Target $target "      {"
  Add-Target $target "        System.exit(1);"
  Add-Target $target "      }"

  if ($folderName -eq "emoji")
  {
    foreach ($path in $list2)
    {
      $categoryName = Get-CategoryName $path
      if ($categoryName -ne "")
      {
        Add-Target $target "      emojiNames[`"$categoryName`"] = new Array();"
      }
    }
  }

  if ($blob -ne "")
  {
    Add-Target $target "      drawings = new $asClass(application, new files.${blob}Class() as ByteArray);"
  }
  else
  {
    foreach ($path in $list)
    {
      $i = Get-ResourceName $path $fileExt
      Add-Target $target "      ${i}$asClass = new files.${i}Class() as $asClass;"
    }
  }

  if ($folderName -eq "emoji")
  {
    Add-Target $target "      pushEmojiNames();"
    Add-Target $target "      markEmojiDrawings();"
  }

  Add-Target $target "      application.trace(`"<$className> constructed.`", 1);"
  Add-Target $target "    }"

  if ($folderName -eq "emoji")
  {
    Add-Target $target "    private function pushEmojiNames():void"
    Add-Target $target "    {"
    foreach ($path in $list)
    {
      $emojiName = Get-ResourceName $path $fileExt
      $categoryName = Get-CategoryName $path
      Add-Target $target "      emojiNames[`"$categoryName`"].push(`"$emojiName`");"
    }
    Add-Target $target "    }"
    Add-Target $target "    private function markEmojiDrawings():void"
    Add-Target $target "    {"
    foreach ($path in $list)
    {
      $emojiName = Get-ResourceName $path $fileExt
      Add-Target $target "      emojiDrawings[`"$emojiName`"] = drawings;"
    }
    Add-Target $target "    }"
  }

  if ($folderName -eq "icon")
  {
    Add-Target $target "    protected function transformBitmapData(bitmap:Bitmap, textType:String, iconSize:int):BitmapData"
    Add-Target $target "    {"
    Add-Target $target "      var bitmapData:BitmapData = new BitmapData(iconSize, iconSize, true, 0x00ffffff);"
    Add-Target $target "      if (bitmap != null)"
    Add-Target $target "      {"
    Add-Target $target "        var matrix:Matrix = new Matrix();"
    Add-Target $target "        matrix.scale(iconSize / bitmap.width, iconSize / bitmap.height);"
    Add-Target $target "        bitmapData.draw(bitmap.bitmapData, matrix, null, null, null, true);"
    Add-Target $target "        var color:int = 0;"
    Add-Target $target '        if (textType == EnumTextTypes.TEXT_TYPE_MID())'
    Add-Target $target "        {"
    Add-Target $target "          color = application.getDynamicsConfig().getAppFontColorMid();"
    Add-Target $target "        }"
    Add-Target $target '        else if (textType == EnumTextTypes.TEXT_TYPE_DARK())'
    Add-Target $target "        {"
    Add-Target $target "          color = application.getDynamicsConfig().getAppFontColorDark();"
    Add-Target $target "        }"
    Add-Target $target "        else"
    Add-Target $target "        {"
    Add-Target $target "          color = application.getDynamicsConfig().getAppFontColorBright();"
    Add-Target $target "        }"
    Add-Target $target "        for ( var i:int = 0; i < bitmapData.height; i++)"
    Add-Target $target "        {"
    Add-Target $target "          for ( var j:int = 0; j < bitmapData.width; j++)"
    Add-Target $target "          {"
    Add-Target $target "            bitmapData.setPixel(i, j, color);"
    Add-Target $target "          }"
    Add-Target $target "        }"
    Add-Target $target "      }"
    Add-Target $target "      return bitmapData;"
    Add-Target $target "    }"
    Add-Target $target "    public function getNewBitmapData(iconType:String, textType:String, iconSize:int):BitmapData"
    Add-Target $target "    {"
    Add-TargetPart $target "      "
    foreach ($path in $list)
    {
      $i = Get-ResourceName $path $fileExt
      Add-Target $target "if (iconType == `"${i}`") return transformBitmapData(${i}Bitmap, textType, iconSize);"
      Add-TargetPart $target "      else "
    }
    Add-Target $target "return null;"
    Add-Target $target "    }"
  }
  elseif ($folderName -eq "emoji")
  {
    Add-Target $target "    public function getCategoryList():Array"
    Add-Target $target "    {"
    Add-Target $target "      var categoryList:Array = new Array();"
    Add-Target $target "      for (var key:String in emojiNames)"
    Add-Target $target "      {"
    Add-Target $target "        categoryList.push(key);"
    Add-Target $target "      }"
    Add-Target $target "      return categoryList;"
    Add-Target $target "    }"
    Add-Target $target "    public function getEmojiList(category:String):Array"
    Add-Target $target "    {"
    Add-Target $target "      if (emojiNames[category] == undefined) return new Array();"
    Add-Target $target "      var emojiList:Array = new Array();"
    Add-Target $target "      for (var i:int = 0; i < emojiNames[category].length; i++)"
    Add-Target $target "      {"
    Add-Target $target "        emojiList.push(emojiNames[category][i]);"
    Add-Target $target "      }"
    Add-Target $target "      return emojiList;"
    Add-Target $target "    }"
    Add-Target $target "    public function getNewBitmapData(emojiType:String, emojiSize:int = 32):BitmapData"
    Add-Target $target "    {"
    Add-Target $target "      var vectorDrawings:$asClass = emojiDrawings[emojiType] as $asClass;"
    Add-Target $target "      if (vectorDrawings == null)"
    Add-Target $target "      {"
    Add-Target $target "        return new BitmapData(emojiSize, emojiSize, true, 0x00ffffff);"
    Add-Target $target "      }"
    Add-Target $target "      return vectorDrawings.getNewBitmapData(emojiType, emojiSize);"
    Add-Target $target "    }"
  }
  elseif ($folderName -eq "sound")
  {
    Add-Target $target "    public function playSound(soundType:String, startTime:Number = 0):SoundChannel"
    Add-Target $target "    {"
    Add-Target $target "      var soundChannel:SoundChannel = null;"
    Add-Target $target "      if (application.getDynamicsConfig().getAppSoundPlaying())"
    Add-Target $target "      {"
    Add-Target $target "        var soundTransform:SoundTransform = new SoundTransform();"
    Add-Target $target "        soundTransform.volume = application.getDynamicsConfig().getAppSoundVolume() / 100;"
    Add-TargetPart $target "        "
    foreach ($path in $list)
    {
      $i = Get-ResourceName $path $fileExt
      Add-Target $target "if (soundType == `"${i}`") soundChannel = ${i}Sound.play(startTime);"
      Add-TargetPart $target "        else "
    }
    Add-Target $target "soundChannel = null;"
    Add-Target $target "        if (soundChannel != null)"
    Add-Target $target "        {"
    Add-Target $target "          soundChannel.soundTransform = soundTransform;"
    Add-Target $target "        }"
    Add-Target $target "      }"
    Add-Target $target "      return soundChannel;"
    Add-Target $target "    }"
    Add-Target $target "    public function getSound(soundType:String):Sound"
    Add-Target $target "    {"
    Add-TargetPart $target "      "
    foreach ($path in $list)
    {
      $i = Get-ResourceName $path $fileExt
      Add-Target $target "if (soundType == `"${i}`") return ${i}Sound;"
      Add-TargetPart $target "      else "
    }
    Add-Target $target "return null;"
    Add-Target $target "    }"
  }

  Write-Destroy $target $className $asClass $folderName $list $fileExt $blob

  Add-Target $target "  }"
  Add-Target $target "}"
  Add-Target $target2 "  }"
  Add-Target $target2 "}"
  Add-Target $target "class ${className}Files"
  Add-Target $target '{'

  if ($blob -ne "")
  {
    Add-Target $target "  [Embed(source = `"$folderDelta/$blob.kvg`", mimeType = `"application/octet-stream`")]"
    Add-Target $target "  public var ${blob}Class:Class;"
  }
  else
  {
    foreach ($path in $list)
    {
      Add-Target $target "  [Embed(source = `"$folderDelta/$path`")]"
      $i = Get-ResourceName $path $fileExt
      Add-Target $target "  public var ${i}Class:Class;"
    }
  }
  Add-Target $target "  public function ${className}Files():void {}"
  Add-Target $target '}'
}

Invoke-GenerateClass icon
Invoke-GenerateClass sound
Invoke-GenerateClass emoji

Invoke-GenerateTextkeys

Save-Targets
