#!/bin/bash
# Purpose: Shutdown all Virtualbox VMS
#
# Location: Stored on the host machine 192.168.1.222
# Directory: ~/
#
# Author: Chase Reidinger


# list the vms
# grab only the txt between ""
# remove the ""
VMS_RUNNING=$(vboxmanage list runningvms | grep -o '".*"'| sed 's/"//g')

# Shud down each VM
function shutdown_vms(){

	# for each vm in the list -> shutdown
	for VM in $@
	do
		echo "Shutting down VM: ${VM}"
		vboxmanage controlvm ${VM} poweroff
	done

	return 0
}


echo -e "Start ${0}\n"

if [ ! -z "${VMS_RUNNING}" ]
then
	echo -e "List running VMS: \n ${VMS_RUNNING}\n"
else
	echo -e "No Virtually Machines are running."
	echo -e "\nEnd ${0}"
	exit 0
fi

echo -e "\n======================================\n"
echo -e "\nExecuting shutdown_vms()\n"

shutdown_vms $VMS_RUNNING

echo -e "\nEnd ${0}"
exit 0