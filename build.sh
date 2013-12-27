#!/usr/bin/env bash

. variables.sh

# Colorization fix in Jenkins
export CL_RED="\"\033[31m\""
export CL_GRN="\"\033[32m\""
export CL_YLW="\"\033[33m\""
export CL_BLU="\"\033[34m\""
export CL_MAG="\"\033[35m\""
export CL_CYN="\"\033[36m\""
export CL_RST="\"\033[0m\""

cd $WORKSPACE

export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

export USE_CCACHE=1
export CCACHE_NLEVELS=4
export BUILD_WITH_COLORS=1

REPO=$(which repo)
if [ -z "$REPO" ]
then
  mkdir -p ~/bin
  curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
  chmod a+x ~/bin/repo
fi

if [[ "$REPO_BRANCH" =~ "jellybean" || $REPO_BRANCH =~ "cm-10" ]]; 
then 
   JENKINS_BUILD_DIR=jellybean
else
   JENKINS_BUILD_DIR=$REPO_BRANCH
fi

mkdir -p $JENKINS_BUILD_DIR
cd $JENKINS_BUILD_DIR

if [ $SYNC = "true" ]
then
    rm -rf .repo/manifests*
    rm -f .repo/local_manifests/dyn-*.xml
    repo init -u $SYNC_PROTO://github.com/TeamCanjica/android.git -b $REPO_BRANCH
    check_result "repo init failed."
fi

# Make sure ccache is in PATH
export PATH="$PATH:/opt/local/bin/:$PWD/prebuilts/misc/$(uname|awk '{print tolower($0)}')-x86/ccache"
export CCACHE_DIR=~/.ccache

if [ -f ~/.jenkins_profile ]
then
  . ~/.jenkins_profile
fi

if [ $SINGLE_PACKAGE = "false" ]
then

mkdir -p .repo/local_manifests
rm -f .repo/local_manifest.xml

echo Manifest:
cat .repo/manifest.xml

fi

if [ $SYNC = "true" ]
then
  echo Syncing...
  repo sync -f -d -c > /dev/null
  check_result "repo sync failed."
  echo Sync complete.
fi

if [ "$CHERRYPICK_COMMITS" = "true" ]
then
  . cherry-pick.sh
  check_result "Cherrypicking failed"
fi

if [ -f $WORKSPACE/BuildBot/$REPO_BRANCH-setup.sh ]
then
  $WORKSPACE/BuildBot/$REPO_BRANCH-setup.sh
else
  if [ -f $WORKSPACE/BuildBot/$REPO_BRANCH-setup.sh ]
  then
    $WORKSPACE/BuildBot/cm-setup.sh
  fi 
fi

. build/envsetup.sh

lunch $LUNCH
check_result "lunch failed."

if [ ! "$(ccache -s|grep -E 'max cache size'|awk '{print $4}')" = "50.0" ]
then
  ccache -M 50G
fi

LAST_CLEAN=0
if [ -f .clean ]
then
  LAST_CLEAN=$(date -r .clean +%s)
fi
TIME_SINCE_LAST_CLEAN=$(expr $(date +%s) - $LAST_CLEAN)
# convert this to hours
TIME_SINCE_LAST_CLEAN=$(expr $TIME_SINCE_LAST_CLEAN / 60 / 60)
if [ $TIME_SINCE_LAST_CLEAN -gt "24" -o $CLEAN = "true" ]
then
  echo "Cleaning!"
  touch .clean
  make clobber
else
  echo "Skipping clean: $TIME_SINCE_LAST_CLEAN hours since last clean."
fi

if [ $KERNEL_ONLY = "true" ]
then
  echo "Building kernel only"
  time mka bootimage
  echo "Kernel build finished"
  exit 0
fi

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
# TODO: Make single package upload script
#	. package_upload.sh
    exit 0
  fi
fi

time make -j6 bacon
check_result "Build failed."

# Upload
. upload.sh
