#!/usr/bin/env bash

if [ $ROM_NAME = "cm_" ]
then
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/cm-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
then
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/omni-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
fi
