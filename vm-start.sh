#!/bin/bash
# Purpose: Start all Virtualbox VMs
#
# Location: Stored on the host machine 192.168.1.222
# Directory: ~/
#
# Author: Chase Reidinger

# Get the list of vs
VMS=$(vboxmanage list vms | grep -o '".*"' | sed 's/"//g' )

function start_vms(){

	#for each vms -> start
	for VM in $@
	do
		vboxmanage startvm ${VM} --type headless
		# need a delay between starting VMs otherwise some will not launch
		echo -e "	Sleep 5 seconds between startup\n"
		sleep 5
	done

}


echo -e "Start ${0}\n"

if [ ! -z "${VMS}" ]
then
	echo -e "List Virtual Machines: \n${VMS}"
else
	echo "No Virtual Machines found"
	exit 0
fi


echo -e "\n======================================\n"
echo -e "Executing start_vms()\n"

start_vms $VMS

echo -e "\nEnd ${0}"
exit 0

