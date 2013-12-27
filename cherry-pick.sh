#!/usr/bin/env bash

if [ "$REPO_BRANCH" = "cm-10.1" ]
	then

	echo "Cherrypicking Oliver patches - android_frameworks_av"
	cd frameworks/av
	git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/21/46421/3
	git cherry-pick FETCH_HEAD
# Use TeamCanjica frameworks_native until we fix buffers 
#	cd ..
#	echo "Cherrypicking Oliver patches - android_frameworks_native"
#	cd native
#	git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/20/46420/1
#	git cherry-pick FETCH_HEAD
	cd ../..
	echo "Cherrypicking Oliver patches - android_system_core"
	cd system/core
	git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/32/45032/3
	git cherry-pick FETCH_HEAD
	cd ../..

fi

if [ "$REPO_BRANCH" = "cm-10.2" ] || [ "$REPO_BRANCH" = "omni-4.3" ]
	then

	echo "Cherrypicking Oliver patches - android_system_core"
	cd system/core
	git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/34/52034/2
	git cherry-pick FETCH_HEAD
	cd ../..
        
	if [ "$REPO_BRANCH" = "cm-10.2" ]
		then

		echo "Cherrypicking Oliver patches - android_frameworks_av"
		cd frameworks/av
		git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/32/52032/3
		git cherry-pick FETCH_HEAD
		cd ..

		echo "Cherrypicking Oliver patches - android_frameworks_native"
		cd native
		git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/33/52033/5
		git cherry-pick FETCH_HEAD
		cd ../..
                
		else
                
		echo "Cherrypicking multiwindow - android_frameworks_base"
		cd frameworks/base
		git fetch https://gerrit.omnirom.org/android_frameworks_base refs/changes/53/53/19
		git cherry-pick FETCH_HEAD
		cd ../..

	fi

fi
 
if [ "$REPO_BRANCH" = "cm-11.0" ] || [ "$REPO_BRANCH" = "omni-4.4" ]
	then

	echo "Cherrypicking ART fix"
	cd art
	git fetch https://github.com/cernekee/android_art monitor-stack-v1
	git cherry-pick fc2ac71d0d9e147c607bff9371fe2ef25d8470af
	cd ..
                
	if [ "$REPO_BRANCH" = "cm-11.0" ]
		then

		echo "Cherrypicking older recoveries compatibility, not merged yet"
		cd build
		git fetch http://review.cyanogenmod.org/CyanogenMod/android_build refs/changes/59/53559/4
		git cherry-pick FETCH_HEAD
		cd ..

	fi

fi

check_result "Cherrypicking failed"
echo "Cherrypicking Complete"
