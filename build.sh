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

# Fix libraries
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

# CCache
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

# Install Repo if not installed
REPO=$(which repo)
if [ -z "$REPO" ]
then
  mkdir -p ~/bin
  curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
  chmod a+x ~/bin/repo
fi

export JENKINS_BUILD_DIR="$ROM_NAME"
mkdir -p $JENKINS_BUILD_DIR
cd $JENKINS_BUILD_DIR

# Syncing
if [ $SYNC = "true" ]
then
  rm -rf .repo/manifests*
  rm -f .repo/local_manifests/dyn-*.xml
  repo init -u $SYNC_PROTO://github.com/TeamCanjica/android.git -b $REPO_BRANCH
  check_result "repo init failed."
  echo "Syncing..."
  repo sync -f -d -c > /dev/null
  check_result "repo sync failed."
  echo "Sync complete."
fi

# Cherrypicking
if [ $CHERRYPICK_COMMITS = "true" ]
then
  . BuildBot/cherry-pick.sh
  check_result "Cherrypicking failed"
fi

# Get prebuilts
if [ $ROM_NAME = "cm_" ]
then
  ./vendor/cm/get-prebuilts
fi

# Set environment and lunch
. build/envsetup.sh
lunch $LUNCH
check_result "lunch failed."

# CCache max size
ccache -M 50G

# Clean
if [ $CLEAN = "true" ]
then
  echo "Cleaning!"
  make clobber
else
  echo "Cleaning skipped, removing only last built package."
  rm out/target/product/$DEVICE/cm-*
fi

# Kernel only
if [ $KERNEL_ONLY = "true" ]
then
  echo "Building kernel only"
  time mka bootimage
  echo "Kernel build finished"
	if [ $UPLOAD != "false" ]
    then
	  . BuildBot/upload.sh
    fi
  exit 0
fi

# Single package
if [ $SINGLE_PACKAGE = "true" ]
then
  if [ $PACKAGE_NAME = "" ]
  then
    echo "Package name not specified..."
    exit 1
  else
    echo "Building single package only: $PACKAGE_NAME"
    time mka $PACKAGE_NAME
    echo "Package build finished"
# TODO: Rework upload.sh to upload single package
#	 if [ $UPLOAD != "false" ]
#    then
#	   . BuildBot/upload.sh
#    fi
    exit 0
  fi
fi

# Start build
time make -j6 bacon
check_result "Build failed."

# Upload
if [ $UPLOAD != "false" ]
then
  echo "Starting upload"
  . BuildBot/upload.sh
fi
