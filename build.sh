#!/usr/bin/env bash

# Fix libraries
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

# CCache
export USE_CCACHE=1
export PATH=~/bin:$PATH
export PATH="$PATH:/opt/local/bin/:$WORKSPACE/$ROM_NAME/prebuilts/misc/$(uname|awk '{print tolower($0)}')-x86/ccache"
export CCACHE_DIR=~/.ccache

# Install Repo if not installed
REPO=$(which repo)
if [ -z "$REPO" ]
then
  mkdir -p ~/bin
  curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
  chmod a+x ~/bin/repo
fi

# Build directory
export JENKINS_BUILD_DIR="$ROM_NAME"
mkdir -p $JENKINS_BUILD_DIR
cd $JENKINS_BUILD_DIR

# Syncing
if [ $SYNC = "true" ]
then
  rm -rf .repo/manifests*
  rm -f .repo/local_manifests/dyn-*.xml
  repo init -u $SYNC_PROTO://github.com/TeamCanjica/android.git -b $REPO_BRANCH
  echo -e $CL_BLU"Syncing..."$CL_RST
  repo sync -f -d -c > /dev/null
  echo -e $CL_GRN"Sync complete."$CL_RST
fi

# Cherrypicking
if [ $CHERRYPICK_COMMITS = "true" ]
then
  . $WORKSPACE/BuildBot/cherry-pick.sh
fi

# Get prebuilts
if [ $ROM_NAME = "cm_" ]
then
  ./vendor/cm/get-prebuilts
fi

# Set environment and lunch
. build/envsetup.sh
lunch $LUNCH

# CCache max size
if [ ! "$(ccache -s|grep -E 'max cache size'|awk '{print $4}')" = "50.0" ]
then
  ccache -M 50G
fi

# Clean
if [ $CLEAN = "true" ]
then
  echo -e $CL_BLU"Cleaning..."$CL_RST
  make clobber
  echo -e $CL_GRN"Clean complete!"$CL_RST
else
  echo -e $CL_YLW"Cleaning skipped, removing only last built package."$CL_RST
  rm -f out/target/product/$DEVICE/cm-*
fi

# Kernel only
if [ $KERNEL_ONLY = "true" ]
then
  echo -e $CL_BLU"Building kernel only..."$CL_RST
  time mka bootimage
  echo -e $CL_GRN"Kernel build finished!"$CL_RST
	if [ $UPLOAD != "false" ]
    then
	  . $WORKSPACE/BuildBot/upload.sh
    fi
  exit 0
fi

# Single package
if [ $SINGLE_PACKAGE = "true" ]
then
  if [ $PACKAGE_NAME = "" ]
  then
    echo -e $CL_RED"Package name not specified!"$CL_RST
    exit 1
  else
    echo -e $CL_BLU"Building single package only: $PACKAGE_NAME"$CL_RST
    time mka $PACKAGE_NAME
    echo -e $CL_GRN"Package build finished!"$CL_RST
# TODO: Rework upload.sh to upload single package
#	 if [ $UPLOAD != "false" ]
#    then
#	   . $WORKSPACE/BuildBot/upload.sh
#    fi
    exit 0
  fi
fi

# Start build
echo -e $CL_CYN"Building..."$CL_RST
time make -j6 bacon

# Upload
if [ $UPLOAD = "true" ]
then
  echo -e $CL_BLU"Uploading..."$CL_RST
  . $WORKSPACE/BuildBot/upload.sh
fi
