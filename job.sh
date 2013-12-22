#!/usr/bin/env bash

if [ -z "$HOME" ]
then
  echo HOME not in environment, guessing...
  export HOME=$(awk -F: -v v="$USER" '{if ($1==v) print $6}' /etc/passwd)
fi

cd $WORKSPACE
mkdir -p ../android
cd ../android
export WORKSPACE=$PWD

if [ ! -d BuildBot ]
then
  git clone git://github.com/Rox-/BuildBot.git
fi

cd BuildBot
## Get rid of possible local changes
git reset --hard
git pull -s resolve

if [ -z "$UL_ONLY" ]
then
export UL_ONLY=false
fi

if [ $UL_ONLY = "false" ]
then
exec ./build.sh
elif [ $UL_ONLY = "true" ]
then
exec ./variables.sh
exec ./upload.sh
fi
