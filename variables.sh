#!/usr/bin/env bash

# Rom name
if [ $REPO_BRANCH = "omni-4.3" ] || [ $REPO_BRANCH = "omni-4.4" ]
then
  ROM_NAME="omni_"
else
  ROM_NAME="cm_"
fi

# Debug level
if [ $DBG = "true" ]
then
  DEBUG=eng
else
  DEBUG=userdebug
fi

# Device name to build
if [ $DEVICE = "codina" ]
then
  export LUNCH="$ROM_NAME$DEVICE-$DEBUG"
  export FOLDER=26295
elif [ $DEVICE = "janice" ]
then
  export LUNCH="$ROM_NAME$DEVICE-$DEBUG"
  export FOLDER=26296
else
  echo Device not specified or unsupported
  exit 1
fi

# Clean directory before building
if [ -z "$CLEAN" ]
then
  echo CLEAN not specified
  exit 1
fi

# Branch to sync and build
if [ -z "$REPO_BRANCH" ]
then
  echo REPO_BRANCH not specified
  exit 1
fi

# Lunch
if [ -z "$LUNCH" ]
then
  echo LUNCH not specified
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

# Single package
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
  SYNC_PROTO=https
fi

# Public upload
if [ -z "$PUBLIC" ]
then
  export PUBLIC="0"
fi