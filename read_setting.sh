#!/bin/bash

# The values telling where the tools and the files of this project are on this
# very computer - the java executable, the folder of the air sdk and so on - are
# not in the scripts of the project: they are different on every computer, so
# every one of them is stored in a file of its own in the project root, named
# after the setting itself. The value of JAVA is the first line of .JAVA, the
# value of AIRSDK_HOME is the first line of .AIRSDK_HOME, and so on.
# These files are in .gitignore: they belong to this computer only.
#
# This file is not run, it is sourced by the scripts needing those values:
# source ./read_setting.sh
#
# read_setting NAME DESCRIPTION
# It prints the value of the setting called NAME. When there is no value stored
# for it yet, then it asks for one and stores it, so it is asked only once.
# The DESCRIPTION is the sentence telling the user what is being asked for.
# It returns 1 when there is no usable value, and the caller has to stop then.
read_setting()
{
  local name="$1"
  local description="$2"
  # This file is in the project root, so the settings are next to it, whatever
  # the working directory of the caller is.
  local root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  local file="$root/.$name"
  local value=""
  if [[ -f $file ]]
  then
    value=`head -n 1 "$file"`
  fi
  if [[ $value != "" ]]
  then
    echo "$value"
    return 0
  fi
  # Everything said to the user goes to the error output, so the value printed
  # by this function stays the value alone.
  echo " " >&2
  echo "The $name of this project is not known yet." >&2
  # It is not enough that /dev/tty is there: it can not be opened at all when
  # this runs with no terminal behind it, from cron or from a pipeline.
  if ! (: < /dev/tty) 2> /dev/null
  then
    echo "There is no terminal to ask for it on." >&2
    echo "Please, write it into $file yourself!" >&2
    return 1
  fi
  echo "Please, give $description!" >&2
  while [[ $value == "" ]]
  do
    read -r -p "$name=" value < /dev/tty
    # An empty answer is the way to give this up.
    if [[ $value == "" ]]
    then
      echo "There is no $name, so this can not go on." >&2
      return 1
    fi
    # A path starting with a tilde is written by hand more often than not.
    value="${value/#\~/$HOME}"
    if [[ ! -e $value ]]
    then
      echo "There is nothing at $value, please, give the right one!" >&2
      value=""
    fi
  done
  echo "$value" > "$file"
  echo "It has been stored in $file, so you are asked for it only once." >&2
  echo "$value"
  return 0
}
