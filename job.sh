#!/usr/bin/env bash

cd BuildBot

# Get rid of possible local changes
git reset --hard
git pull -s resolve

if [ -z "$UL_ONLY" ]
then
export UL_ONLY=false
fi

cd $WORKSPACE
. variables.sh

if [ $UL_ONLY = "false" ]
then
. BuildBot/build.sh
elif [ $UL_ONLY = "true" ]
then
. BuildBot/upload.sh
fi
