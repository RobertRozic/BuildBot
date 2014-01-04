#!/usr/bin/env bash

# DevHost informations : Nickname, password and upload folder
if [ -z "$DH_PASSWORD" ] || [ -z "$DH_USER" ]
then
  echo  -e $CL_YLW"DevHost Password or user not specified."$CL_RST
  echo  -e $CL_YLW"Upload skipped!"$CL_RST
  export UPLOAD="false"
  exit 0
else
  export UPLOAD="true"
  case $DEVICE in 
  "codina")
    export FOLDER="26295"
    ;;
  "codinap")
    export FOLDER="29956"
    ;;
  "janice")
    export FOLDER="26296"
    ;;
  *)
    echo  -e $CL_YLW"Device upload not supported."$CL_RST
    echo  -e $CL_YLW"Upload skipped!"$CL_RST
    export UPLOAD="false"
    exit 0
  esac
fi

# Start upload
if [ $SINGLE_PACKAGE = "true" ]
then
  if [ $KERNEL_ONLY = "true" ]
  then
    export UL_PATH="$WORKSPACE/$ROM_NAME/out/target/product/$DEVICE/boot.img"
  else
    export UL_PATH=`find -name $PACKAGE_NAME`
  fi
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $UL_PATH -f $FOLDER -d $DESC -pb  $DH_PUB
else
  time devhost -u $DH_USER -p $DH_PASSWORD upload  $WORKSPACE/$ROM_NAME/out/target/product/$DEVICE/$ROM_NAME-*.zip -f $FOLDER -d $DESC -pb  $DH_PUB
fi

# Check if upload is finished corectly
if [ "0" -ne "$?" ]
then
  echo -e $CL_RED"Upload failed."$CL_RST
  exit 1
fi
