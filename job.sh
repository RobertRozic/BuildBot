#!/usr/bin/env bash

cd $WORKSPACE

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
. build.sh
elif [ $UL_ONLY = "true" ]
then
cd $WORKSPACE
. BuildBot/variables.sh
. BuildBot/upload.sh
fi
