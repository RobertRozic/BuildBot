#!/usr/bin/env bash

cd BuildBot

# Get rid of possible local changes
git reset --hard
git pull -s resolve

# Upload only
if [ -z "$UL_ONLY" ]
then
export UL_ONLY=false
fi

cd $WORKSPACE
. BuildBot/variables.sh

if [ $UL_ONLY = "false" ]
then
. BuildBot/build.sh
else
. BuildBot/upload.sh
fi
