#!/bin/bash
# Purpose: Create backups of VM's
#
# Location: Stored on the host machine 192.168.1.222
# Directory: ~/
#
# Author: Chase Reidinger


# get list of vms
VM_LIST=$(vboxmanage list vms | grep -o '".*"' | sed 's/"//g')
VM_LIST_RUNNING=$(vboxmanage list runningvms | grep -o '".*"' | sed 's/"//g')

SNAPSHOT_STR="$(date +%F)-daily-shapshot"


#
# FUNCTIONS
#

# Shutdown any running vms
function shutdown_vms(){

	for VM in $@
	do
		echo "Shutting down vm: ${VM}"
		vboxmanage controlvm ${VM} poweroff
	done

	return 0
}

# Restart the vms after copying
function startup_vms(){

	for VM in $@
	do
		echo "Starting ${VM}"
		vboxmanage startvm ${VM} --type headless
		sleep 10
	done

	return 0
}

function snap_vms(){

	for VM in $@
	do
		echo "Takeing snapshot of ${VM}"
		vboxmanage snapshot ${VM} take $SNAPSHOT_STR
	done

	return 0
}



#
# MAIN SCRIPT SECTION
#
echo -e "Execute: ${0}\n"
	
	# If vms are found, continue, else exit
	if [ ! -z "$VM_LIST" ]
	then
		echo -e "VM List: \n${VM_LIST}"
	else
		echo -e "No VMs available \nExiting ${0}"
		echo -e "\n======================================\n"
		exit 1
	fi

	# if there are vms running... shutdown
	if [ ! -z "$VM_LIST_RUNNING" ]
	then
		echo -e "\nRunning VMs: \n${VM_LIST_RUNNING}"
		echo -e "\n======================================\n"
		echo -e "shutdown_vms()\n"
		shutdown_vms $VM_LIST_RUNNING
		echo -e "\n======================================\n"
	else 
		echo -e "\n======================================\n"
		echo -e "shutdown_vms()\n"
		echo "No VMs are currently running"
		echo -e "\n======================================\n"
	fi

	# take a snapshot of the vms
	echo -e "snap_vms()\n"
	snap_vms $VM_LIST
	echo -e "\n======================================\n"

	#restart vms when done
	echo -e "startup_vms()\n"
	startup_vms $VM_LIST
	echo -e "\n======================================\n"

echo -e "\nEnd: ${0}"
exit 0