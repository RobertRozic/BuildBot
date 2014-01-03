#!/usr/bin/env bash

if [ $KERNEL_ONLY = "true" ]
then
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/boot.img -f $FOLDER -d $DESC -pb  $DH_PUB
else
  if [ $ROM_NAME = "cm_" ]
  then
    time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/cm-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
  elif [ $ROM_NAME = "omni_" ]
  then
    time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/omni-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
  fi
fi

echo -E $CL_GRN"Upload finished."$CL_RST
