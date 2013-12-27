BuildBot
========

First starting on Jenkins
Execute shell :
      git clone https://github.com/Rox-/BuildBot.git
      
After that : 
Execute shell:
      export DH_USER=****
      export DH_PASSWORD=****
      
      $WORKSPACE/BuildBot/job.sh
      
Parameters:

      Choice - DEVICE
      Choice - REPO_BRANCH
      Bool   - CLEAN
      Bool   - DBG
      Bool   - CHERRYPICK_COMMITS*
      Bool   - PUBLIC*
      Bool   - UL_ONLY*
      Bool   - SYNC*
      Bool   - KERNEL_ONLY*
      Bool   - SINGLE_PACKAGE*
      Text   - DESC *
      Choice - SYNC_PROTO*

*If not selected, default values are used
