#!/usr/bin/env bash

if [ $KERNEL_ONLY = "true" ]
then
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/boot.img -f $FOLDER -d $DESC -pb  $DH_PUB
else
  if [ $ROM_NAME = "cm" ]
  then
    time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/cm-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
  elif [ $ROM_NAME = "omni" ]
  then
    time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$JENKINS_BUILD_DIR/out/target/product/$DEVICE/omni-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
  fi
fi

echo -e $CL_GRN"Upload finished."$CL_RST
