#!/usr/bin/env bash

# Colorization fix in Jenkins
export CL_RED="\"\033[31m\""
export CL_GRN="\"\033[32m\""
export CL_YLW="\"\033[33m\""
export CL_BLU="\"\033[34m\""
export CL_MAG="\"\033[35m\""
export CL_CYN="\"\033[36m\""
export CL_RST="\"\033[0m\""
export BUILD_WITH_COLORS=1

echo -e $CL_BLU"*************************************************"$CL_RST 
echo -e $CL_BLU"*   _____                                       *"$CL_RST      
echo -e $CL_BLU"*  /__   \___  __ _ _ __ ___                    *"$CL_RST      
echo -e $CL_BLU"*    / /\/ _ \/ _' | '_ ' _ \                   *"$CL_RST      
echo -e $CL_BLU"*   / / |  __/ (_| | | | | | |                  *"$CL_RST      
echo -e $CL_BLU"*   \/   \___|\__,_|_| |_| |_|                  *"$CL_RST                                        
echo -e $CL_BLU"*               ___             _ _             *"$CL_RST
echo -e $CL_BLU"*              / __\__ _ _ __  (_|_) ___ __ _   *"$CL_RST
echo -e $CL_BLU"*             / /  / _' | '_ \ | | |/ __/ _' |  *"$CL_RST
echo -e $CL_BLU"*            / /__| (_| | | | || | | (_| (_| |  *"$CL_RST
echo -e $CL_BLU"*            \____/\__,_|_| |_|/ |_|\___\__,_|  *"$CL_RST
echo -e $CL_BLU"*                            |__/               *"$CL_RST
echo -e $CL_BLU"*************************************************"$CL_RST

# Branch to sync and build
if [ -z "$REPO_BRANCH" ]
then
  echo -e $CL_RED"REPO_BRANCH not specified"$CL_RST
  exit 1
fi

# Rom name and build directory
case $REPO_BRANCH in
"cm-"*)
  export ROM_NAME="cm"
  ;;
"omni-"*)
  export ROM_NAME="omni"
  ;;
*)
  echo  -e $CL_RED"ROM not supported. Define ROM name in variables.sh."$CL_RST
  exit 1
  ;;
esac

# Device name to build
if [ -z "$DEVICE" ]
then
  echo  -e $CL_RED"DEVICE not specified"$CL_RST
  exit 1
fi

# Debug level
if [ $DBG = "true" ]
then
  export DEBUG="eng"
else
  export DEBUG="userdebug"
fi

# Lunch
export LUNCH=""$ROM_NAME"_"$DEVICE"-"$DEBUG""

# DevHost informations : Nickname, password and upload folder
if [ -z "$DH_PASSWORD" ] || [ -z "$DH_USER" ]
then
  echo  -e $CL_YLW"DevHost Password or user not specified."$CL_RST
  echo  -e $CL_YLW"Upload will be skipped"$CL_RST
  export UPLOAD="false"
else
  export UPLOAD="true"
  case $REPO_BRANCH in 
  "codina")
    export FOLDER="26295"
    ;;
  "codinap")
    export FOLDER="26296"
    ;;
  "janice")
    export FOLDER="26296"
    ;;
  *)
    echo  -e $CL_YLW"Device upload not supported"$CL_RST
    export UPLOAD="false"
  esac
fi

# Clean directory before building
if [ -z "$CLEAN" ]
then
  echo -e $CL_RED"CLEAN not specified"$CL_RST
  exit 1
fi

#DEFAULT VALUES
# Kernel only
if [ -z "$KERNEL_ONLY" ]
then
  export KERNEL_ONLY="false"
fi

# Single package
if [ -z "$SINGLE_PACKAGE" ]
then
  export SINGLE_PACKAGE="false"
fi

# Cherrypicking
if [ -z "$CHERRYPICK_COMMITS" ]
then
  export CHERRYPICK_COMMITS="true"
fi

# Sync
if [ -z "$SYNC" ]
then
  export SYNC="true"
fi

# Sync protocol
if [ -z "$SYNC_PROTO" ]
then
  export SYNC_PROTO="https"
fi

# Upload description
if [ -z "$DESC" ]
then
  export DESC="None"
fi

# Public upload
if [ -z "$PUBLIC" ]
then
  export PUBLIC="false"
fi

if [ $PUBLIC = "true" ]
then
  export DH_PUB="1"
else
  export DH_PUB="0"
fi
