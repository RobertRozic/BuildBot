#!/usr/bin/env bash

cd BuildBot

# Get rid of possible local changes
git reset --hard
git pull -s resolve

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
