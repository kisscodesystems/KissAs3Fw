WHAT ARE THE generate_classes SCRIPTS FOR?

  generate_classes_linux.sh
  generate_classes_macos.sh
  generate_classes_windows.ps1

The three scripts do the very same thing, one of them is for every operating system.
Run the one of your system from this folder after you have changed anything here:

  icon/     an icon has been added or removed
  sound/    a sound has been added or removed
  emoji/    an emoji has been added or removed (the emojis are SVG files)
  label/    a text key has been added to or removed from the label xml

They rewrite the classes that embed and list those resources:

  ../manager/IconManager.as     ../enum/EnumIcons.as
  ../manager/SoundManager.as    ../enum/EnumSounds.as
  ../manager/EmojiManager.as    ../enum/EnumEmojis.as
                                ../enum/EnumTextKeys.as

The emoji folder is handled one step differently. ActionScript can display neither an
SVG nor an FXG, so the scripts first call svg_to_kvg.py, which flattens every emoji SVG
of that folder into emoji/emojis.kvg: one blob of the drawing commands the runtime does
understand. EmojiManager embeds that single blob instead of nine hundred files, and
util/VectorDrawings.as draws an emoji out of it at whatever size it is asked for. That
is why the emojis stay sharp at any size while an icon, still a png, does not.

So a python3 of any recent version has to be on the path to run these scripts. The
format of the blob is written down in the header comment lines of svg_to_kvg.py, and
emoji/readme.txt tells where the drawings come from.

Every one of those classes is written from scratch, so never edit them by hand:
the next run throws your changes away. The header of those classes says this too.
The same holds for emoji/emojis.kvg: it is built from the SVG files next to it.

The three scripts write exactly the same bytes, so it does not matter which one of
them has been run, and the classes stay the same until a resource really changes.

HOW TO RUN

  linux:    $ ./generate_classes_linux.sh
  macos:    $ ./generate_classes_macos.sh
  windows:  > powershell -ExecutionPolicy Bypass -File .\generate_classes_windows.ps1
