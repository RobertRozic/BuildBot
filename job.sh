#!/usr/bin/env bash

cd BuildBot

# Get rid of possible local changes
git reset --hard
git pull -s resolve

# Setting variables
cd $WORKSPACE
. BuildBot/variables.sh

# Starting build script
if [ $UL_ONLY = "false" ]
then
  . BuildBot/build.sh
fi

# Upload
if [ $UPLOAD = "true" ]
then
  echo -e $CL_BLU"Uploading..."$CL_RST
  . $WORKSPACE/BuildBot/upload.sh
  if [ "0" -ne "$?" ]
  then
  echo -e $CL_GRN"Upload finished."$CL_RST
  exit 1
  fi
fi
