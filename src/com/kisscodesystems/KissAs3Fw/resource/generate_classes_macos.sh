#!/bin/bash

# $ ./generate_classes.sh

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

function generate_header()
{

  HTARGET=$1
  HCLASSNAME=$2
  HCLASSDESC=$3

  echo "/**" > $HTARGET
  echo " * This class is a part of the KissAs3Fw ActionScript framework." >> $HTARGET
  echo " * See the header comment lines of the" >> $HTARGET
  echo " * com.kisscodesystems.KissAs3Fw.Application" >> $HTARGET
  echo " * The whole framework is available at:" >> $HTARGET
  echo " * https://github.com/kisscodesystems/KissAs3Fw" >> $HTARGET
  echo " * Demo applications:" >> $HTARGET
  echo " * https://github.com/kisscodesystems/KissAs3Dm" >> $HTARGET
  echo " *" >> $HTARGET
  echo " * DESCRIPTION:" >> $HTARGET
  echo " * $HCLASSNAME." >> $HTARGET
  echo " * $HCLASSDESC." >> $HTARGET
  echo " * This class is generated so can be overwritten from outside." >> $HTARGET
  echo " */" >> $HTARGET

}

# The macos differences against generate_classes_linux.sh, everything else is the same:
#
# 1. BSD find keeps the start path exactly as it is given, so a base folder with a
#    trailing slash comes back as emoji//food/x.svg. The sed below folds those
#    doubled slashes, without it every emoji would land in a category named "".
# 2. sort orders by the collation table of the current locale, and the table of macos
#    is not the one of linux. sort_paths sorts the way the classes in the repository
#    were generated: the punctuation of a path is only a tie breaker, so circlefull
#    comes before circle. It gives the same order on every machine and in every locale.
#    Like sort_by_name of the linux script, it cuts the extension off the sort key, so
#    the order of the generated members does not depend on that extension either.
function sort_paths()
{
  awk '{ k = $0; sub(/\.[^.\/]*$/, "", k); gsub(/[_.]/, "", k); gsub("/", "", k);
         print k "\t" $0 }' | LC_ALL=C sort | cut -f 2-
}

function generate_textkeys()
{

  CLASSNAME2='TextKeys'
  CLASSDESC='Contains text keys already having in xml file'

  TARGET="../enum/Enum${CLASSNAME2}.as"

  LISTCOMMAND='grep "key=" label/KissAs3FwLabels.xml | sed "s/.*key=\"//" | sed "s/\">//"'

  generate_header "$TARGET" "Enum${CLASSNAME2}" "$CLASSDESC"

  echo 'package com.kisscodesystems.KissAs3Fw.enum' >> $TARGET
  echo '{' >> $TARGET

  echo "  public class Enum${CLASSNAME2}" >> $TARGET
  echo '  {' >> $TARGET

  for i in `eval "$LISTCOMMAND"`
  do
    echo "    public static function ${i}():String" >> $TARGET
    echo "    {" >> $TARGET
    echo "      return \"[${i}]\";" >> $TARGET
    echo "    }" >> $TARGET
  done

  echo "  }" >> $TARGET
  echo "}" >> $TARGET

}

# Writes the destroy method of the manager class being generated, and the small helper
# that method needs when the embedded resources are bitmaps. It reads the variables
# generate_class has set up, and it has to be called as the last one of the generators
# of the methods: the destroy method closes the class in the coding standards.
#
# An icon and a sound is instantiated into a field of its own, so every one of them has
# to be released one by one. A bitmap carries a bitmap data that is not freed up by the
# garbage collector, that one is disposed explicitly. A sound holds no such resource and
# close() throws an error on an embedded one, so those fields are only dropped. The
# emojis are one embedded blob instead, and the object reading it frees up what it built.
function generate_destroy()
{

  if [[ $ASCLASS == "Bitmap" ]]
  then
    echo "    /**" >> $TARGET
    echo "     * Disposes the bitmap data of the given bitmap." >> $TARGET
    echo "     * @param bitmap the bitmap the data of which has to be freed up" >> $TARGET
    echo "     */" >> $TARGET
    echo "    protected function disposeBitmap(bitmap:Bitmap):void" >> $TARGET
    echo "    {" >> $TARGET
    echo "      if (bitmap != null && bitmap.bitmapData != null)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        bitmap.bitmapData.dispose();" >> $TARGET
    echo "      }" >> $TARGET
    echo "    }" >> $TARGET
  fi

  echo "    /**" >> $TARGET
  echo "     * Destroys this object and frees up everything." >> $TARGET
  echo "     */" >> $TARGET
  echo "    public function destroy():void" >> $TARGET
  echo "    {" >> $TARGET
  echo "      application.trace(\"<$CLASSNAME destroy> called.\", 1);" >> $TARGET

  if [[ $BLOB != "" ]]
  then
    echo "      if (drawings != null)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        drawings.destroy();" >> $TARGET
    echo "      }" >> $TARGET
  else
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/.*\///g")
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      if [[ $ASCLASS == "Bitmap" ]]
      then
        echo "      disposeBitmap(${i}$ASCLASS);" >> $TARGET
      fi
      echo "      ${i}$ASCLASS = null;" >> $TARGET
    done
  fi

  if [[ $FOLDERNAME == "emoji" ]]
  then
    echo "      emojiNames = null;" >> $TARGET
    echo "      emojiDrawings = null;" >> $TARGET
    echo "      drawings = null;" >> $TARGET
  fi

  echo "      files = null;" >> $TARGET
  echo "      application = null;" >> $TARGET
  echo "    }" >> $TARGET

}

function generate_class()
{

  FOLDERNAME=$1
  CLASSNAME=''
  CLASSDESC=''
  ASCLASS=''
  FILEEXT=''
  BLOB=''

  if [[ $FOLDERNAME == "icon" ]]
  then
    CLASSNAME='IconManager'
    CLASSNAME2='Icons'
    CLASSDESC2='Contains the icon names that can be used'
    CLASSDESC='Handles icons that can be used on labels'
    ASCLASS='Bitmap'
    FILEEXT='png'
  elif [[ $FOLDERNAME == "emoji" ]]
  then
    CLASSNAME='EmojiManager'
    CLASSNAME2='Emojis'
    CLASSDESC2='Contains the emoji names that can be used'
    CLASSDESC='Handles emojis that can be used on objects when available'
    ASCLASS='VectorDrawings'
    FILEEXT='svg'
    BLOB='emojis'
  elif [[ $FOLDERNAME == "sound" ]]
  then
    CLASSNAME='SoundManager'
    CLASSNAME2='Sounds'
    CLASSDESC2='Contains the sound names that can be used'
    CLASSDESC='Handles embedded sounds'
    ASCLASS='Sound'
    FILEEXT='mp3'
  else
    echo "icon or emoji or sound can be used as parameter!"
    exit 1
  fi

  BASE="../resource/${FOLDERNAME}/"
  FOLDERDELTA="../resource/$FOLDERNAME"
  # The extension is cut off the sort key, so the order of the generated members
  # does not depend on which extension the resources of a folder happen to have.
  LISTCOMMAND='find "$BASE" -name "*.$FILEEXT" | sed "s|//*|/|g" | sort_paths'
  LIST2COMMAND='find "$BASE" -type d | sed "s|//*|/|g" | sort_paths'
  TARGET="../manager/${CLASSNAME}.as"
  TARGET2="../enum/Enum${CLASSNAME2}.as"

  # The emojis are vector drawings and ActionScript can display neither an SVG nor
  # an FXG, so every one of them is flattened into one blob of the drawing commands
  # the runtime does understand, before the manager embedding that blob is written.
  # See resource/svg_to_kvg.py and util/VectorDrawings.as
  if [[ $BLOB != "" ]]
  then
    python3 ./svg_to_kvg.py "$BASE" "${BASE}${BLOB}.kvg" || exit 1
  fi

  generate_header "$TARGET" "$CLASSNAME" "$CLASSDESC"

  echo 'package com.kisscodesystems.KissAs3Fw.manager' >> $TARGET
  echo '{' >> $TARGET
  echo '  import com.kisscodesystems.KissAs3Fw.Application;' >> $TARGET
  generate_header "$TARGET2" "Enum${CLASSNAME2}" "$CLASSDESC2"
  echo 'package com.kisscodesystems.KissAs3Fw.enum' >> $TARGET2
  echo '{' >> $TARGET2

  if [[ $FOLDERNAME == "icon" ]]
  then
    echo '  import com.kisscodesystems.KissAs3Fw.enum.EnumTextTypes;' >> $TARGET
  fi

  if [[ $FOLDERNAME == "icon" ]]
  then
    echo '  import flash.display.Bitmap;' >> $TARGET
    echo '  import flash.display.BitmapData;' >> $TARGET
    echo '  import flash.geom.Matrix;' >> $TARGET
  elif [[ $FOLDERNAME == "emoji" ]]
  then
    echo '  import com.kisscodesystems.KissAs3Fw.util.VectorDrawings;' >> $TARGET
    echo '  import flash.display.BitmapData;' >> $TARGET
  elif [[ $FOLDERNAME == "sound" ]]
  then
    echo '  import flash.media.Sound;' >> $TARGET
    echo '  import flash.media.SoundChannel;' >> $TARGET
    echo '  import flash.media.SoundTransform;' >> $TARGET
  fi

  echo '  import flash.system.System;' >> $TARGET

  if [[ $BLOB != "" ]]
  then
    echo '  import flash.utils.ByteArray;' >> $TARGET
  fi
  echo "  public class $CLASSNAME" >> $TARGET
  echo '  {' >> $TARGET
  echo '    protected var application:Application = null;' >> $TARGET
  echo "  public class Enum${CLASSNAME2}" >> $TARGET2
  echo '  {' >> $TARGET2

  if [[ $FOLDERNAME == "emoji" ]]
  then
    echo '    protected var emojiNames:Array = new Array();' >> $TARGET
    echo '    protected var emojiDrawings:Array = new Array();' >> $TARGET
    echo '    protected var drawings:VectorDrawings = null;' >> $TARGET
  fi

  for i in `eval "$LISTCOMMAND"`
  do
    i=${i/$BASE/}
    i=$(echo "$i" | sed "s/.*\///g")
    i=$(echo "$i" | sed "s/\.$FILEEXT//g")
    if [[ $BLOB == "" ]]
    then
      echo "    private var ${i}$ASCLASS:$ASCLASS;" >> $TARGET
    fi
    echo "    public static function ${i}():String" >> $TARGET2
    echo "    {" >> $TARGET2
    echo "      return \"${i}\";" >> $TARGET2
    echo "    }" >> $TARGET2
  done

  echo "    private var files:${CLASSNAME}Files = new ${CLASSNAME}Files();" >> $TARGET
  
  echo "    public function $CLASSNAME(applicationRef:Application):void" >> $TARGET
  echo "    {" >> $TARGET
  echo "      super();" >> $TARGET
  echo "      if (applicationRef != null)" >> $TARGET
  echo "      {" >> $TARGET
  echo "        application = applicationRef;" >> $TARGET
  echo "      }" >> $TARGET
  echo "      else" >> $TARGET
  echo "      {" >> $TARGET
  echo "        System.exit(1);" >> $TARGET
  echo "      }" >> $TARGET

  if [[ $FOLDERNAME == "emoji" ]]
  then
    for i in `eval "$LIST2COMMAND"`
    do
      i=${i/$BASE/}
      category_name=$(echo "$i" | sed "s/\/.*//g")
      if [[ $category_name != "" ]]
      then
        echo "      emojiNames[\"$category_name\"] = new Array();" >> $TARGET
      fi
    done
  fi

  if [[ $BLOB != "" ]]
  then
    echo "      drawings = new $ASCLASS(application, new files.${BLOB}Class() as ByteArray);" >> $TARGET
  else
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      i=$(echo "$i" | sed "s/.*\///g")
      echo "      ${i}$ASCLASS = new files.${i}Class() as $ASCLASS;" >> $TARGET
    done
  fi

  if [[ $FOLDERNAME == "emoji" ]]
  then
    echo "      pushEmojiNames();" >> $TARGET
    echo "      markEmojiDrawings();" >> $TARGET
  fi

  echo "      application.trace(\"<$CLASSNAME> constructed.\", 1);" >> $TARGET
  echo "    }" >> $TARGET

  if [[ $FOLDERNAME == "emoji" ]]
  then
    echo "    private function pushEmojiNames():void" >> $TARGET
    echo "    {" >> $TARGET
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      j=$i
      i=$(echo "$i" | sed "s/.*\///g")
      category_name=$(echo "$j" | sed "s/\/.*//g")
      emoji_name=$i
      echo "      emojiNames[\"$category_name\"].push(\"$emoji_name\");" >> $TARGET
    done
    echo "    }" >> $TARGET
    echo "    private function markEmojiDrawings():void" >> $TARGET
    echo "    {" >> $TARGET
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      j=$i
      i=$(echo "$i" | sed "s/.*\///g")
      category_name=$(echo "$j" | sed "s/\/.*//g")
      emoji_name=$i
      echo "      emojiDrawings[\"$emoji_name\"] = drawings;" >> $TARGET
    done
    echo "    }" >> $TARGET
  fi

  if [[ $FOLDERNAME == "icon" ]] 
  then
    echo "    protected function transformBitmapData(bitmap:Bitmap, textType:String, iconSize:int):BitmapData" >> $TARGET
    echo "    {" >> $TARGET
    echo "      var bitmapData:BitmapData = new BitmapData(iconSize, iconSize, true, 0x00ffffff);" >> $TARGET
    echo "      if (bitmap != null)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        var matrix:Matrix = new Matrix();" >> $TARGET
    echo "        matrix.scale(iconSize / bitmap.width, iconSize / bitmap.height);" >> $TARGET
    echo "        bitmapData.draw(bitmap.bitmapData, matrix, null, null, null, true);" >> $TARGET
    echo "        var color:int = 0;" >> $TARGET
    echo '        if (textType == EnumTextTypes.TEXT_TYPE_MID())' >> $TARGET
    echo "        {" >> $TARGET
    echo "          color = application.getDynamicsConfig().getAppFontColorMid();" >> $TARGET
    echo "        }" >> $TARGET
    echo '        else if (textType == EnumTextTypes.TEXT_TYPE_DARK())' >> $TARGET
    echo "        {" >> $TARGET
    echo "          color = application.getDynamicsConfig().getAppFontColorDark();" >> $TARGET
    echo "        }" >> $TARGET
    echo "        else" >> $TARGET
    echo "        {" >> $TARGET
    echo "          color = application.getDynamicsConfig().getAppFontColorBright();" >> $TARGET
    echo "        }" >> $TARGET
    echo "        for ( var i:int = 0; i < bitmapData.height; i++)" >> $TARGET
    echo "        {" >> $TARGET
    echo "          for ( var j:int = 0; j < bitmapData.width; j++)" >> $TARGET
    echo "          {" >> $TARGET
    echo "            bitmapData.setPixel(i, j, color);" >> $TARGET
    echo "          }" >> $TARGET
    echo "        }" >> $TARGET
    echo "      }" >> $TARGET
    echo "      return bitmapData;" >> $TARGET
    echo "    }" >> $TARGET
    echo "    public function getNewBitmapData(iconType:String, textType:String, iconSize:int):BitmapData" >> $TARGET
    echo "    {" >> $TARGET
    echo -n "      " >> $TARGET 
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/.*\///g")
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      echo "if (iconType == \"${i}\") return transformBitmapData(${i}Bitmap, textType, iconSize);" >> $TARGET
      echo -n "      else " >> $TARGET
    done
    echo "return null;" >> $TARGET
    echo "    }" >> $TARGET
  elif [[ $FOLDERNAME == "emoji" ]]
  then
    echo "    public function getCategoryList():Array" >> $TARGET
    echo "    {" >> $TARGET
    echo "      var categoryList:Array = new Array();" >> $TARGET
    echo "      for (var key:String in emojiNames)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        categoryList.push(key);" >> $TARGET
    echo "      }" >> $TARGET
    echo "      return categoryList;" >> $TARGET
    echo "    }" >> $TARGET
    echo "    public function getEmojiList(category:String):Array" >> $TARGET
    echo "    {" >> $TARGET
    echo "      if (emojiNames[category] == undefined) return new Array();" >> $TARGET
    echo "      var emojiList:Array = new Array();" >> $TARGET
    echo "      for (var i:int = 0; i < emojiNames[category].length; i++)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        emojiList.push(emojiNames[category][i]);" >> $TARGET
    echo "      }" >> $TARGET
    echo "      return emojiList;" >> $TARGET
    echo "    }" >> $TARGET
    echo "    public function getNewBitmapData(emojiType:String, emojiSize:int = 32):BitmapData" >> $TARGET
    echo "    {" >> $TARGET
    echo "      var vectorDrawings:$ASCLASS = emojiDrawings[emojiType] as $ASCLASS;" >> $TARGET
    echo "      if (vectorDrawings == null)" >> $TARGET
    echo "      {" >> $TARGET
    echo "        return new BitmapData(emojiSize, emojiSize, true, 0x00ffffff);" >> $TARGET
    echo "      }" >> $TARGET
    echo "      return vectorDrawings.getNewBitmapData(emojiType, emojiSize);" >> $TARGET
    echo "    }" >> $TARGET
  elif [[ $FOLDERNAME == "sound" ]]
  then
    echo "    public function playSound(soundType:String, startTime:Number = 0):SoundChannel" >> $TARGET
    echo "    {" >> $TARGET
    echo "      var soundChannel:SoundChannel = null;" >> $TARGET
    echo "      if (application.getDynamicsConfig().getAppSoundPlaying())" >> $TARGET
    echo "      {" >> $TARGET
    echo "        var soundTransform:SoundTransform = new SoundTransform();" >> $TARGET
    echo "        soundTransform.volume = application.getDynamicsConfig().getAppSoundVolume() / 100;" >> $TARGET
    echo -n "        " >> $TARGET 
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/.*\///g")
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      echo "if (soundType == \"${i}\") soundChannel = ${i}Sound.play(startTime);" >> $TARGET
      echo -n "        else " >> $TARGET
    done
    echo "soundChannel = null;" >> $TARGET
    echo "        if (soundChannel != null)" >> $TARGET
    echo "        {" >> $TARGET
    echo "          soundChannel.soundTransform = soundTransform;" >> $TARGET
    echo "        }" >> $TARGET
    echo "      }" >> $TARGET
    echo "      return soundChannel;" >> $TARGET
    echo "    }" >> $TARGET
    echo "    public function getSound(soundType:String):Sound" >> $TARGET
    echo "    {" >> $TARGET
    echo -n "      " >> $TARGET 
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      i=$(echo "$i" | sed "s/.*\///g")
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      echo "if (soundType == \"${i}\") return ${i}Sound;" >> $TARGET
      echo -n "      else " >> $TARGET
    done
    echo "return null;" >> $TARGET
    echo "    }" >> $TARGET
  fi

  generate_destroy

  echo "  }" >> $TARGET
  echo "}" >> $TARGET
  echo "  }" >> $TARGET2
  echo "}" >> $TARGET2
  echo "class ${CLASSNAME}Files" >> $TARGET
  echo '{' >> $TARGET

  if [[ $BLOB != "" ]]
  then
    echo "  [Embed(source = \"$FOLDERDELTA/${BLOB}.kvg\", mimeType = \"application/octet-stream\")]" >> $TARGET
    echo "  public var ${BLOB}Class:Class;" >> $TARGET
  else
    for i in `eval "$LISTCOMMAND"`
    do
      i=${i/$BASE/}
      echo "  [Embed(source = \"$FOLDERDELTA/$i\")]" >> $TARGET
      i=$(echo "$i" | sed "s/.*\///g")
      i=$(echo "$i" | sed "s/\.$FILEEXT//g")
      echo "  public var ${i}Class:Class;" >> $TARGET
    done
  fi
  echo "  public function ${CLASSNAME}Files():void {}" >> $TARGET
  echo '}' >> $TARGET

}

generate_class icon
generate_class sound
generate_class emoji

generate_textkeys
