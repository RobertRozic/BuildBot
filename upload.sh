#!/usr/bin/env bash

if [ $PUBLIC = "true" ]
then
  export DH_PUB=1
else
  export DH_PUB=0
fi

if [ -z "$DESC" ]
then
  DESC=None
fi

if [ -z "$DH_PASSWORD" ] || [ -z "$DH_USER" ]
then
  echo DevHost Password or user not specified.
  echo Upload will be skipped
  export UPLOAD=false
fi

if [ $UPLOAD != "false" ]
then

  if [ $ROM_NAME = "cm_" ]
  then
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/cm-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB

  else
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/$REPO_BRANCH*.zip -f $FOLDER -d $DESC -pb  $DH_PUB

fi
