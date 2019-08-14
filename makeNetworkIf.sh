#!/usr/bin/env bash
#
# Provides      : Automatical configuration od Network interfaces of Openstack machine
# 

OUTPUT1="$(ifconfig)"
OUTPUT2="$(ifconfig -a)"

#check wheather ifcofig is equalk to ifconfig -a
if [ "$OUTPUT1" == "$OUTPUT2" ]
    then
	#If they are the same that means that all NICs are configured
        echo "All network interfaces are cofigured"
    	exit 1
fi

#get all names of avaivable NICS (eth0/eht2/lo1)
OUTPUT="$(ls /sys/class/net)"
#put those names into array
IFS=' ' read -r -a array <<< ${OUTPUT}
#check all names
for index in "${!array[@]}"
do
	#check if given names exist in network-scripts
	OUTPUT2="$(ls /etc/sysconfig/network-scripts | grep ${array[index]})"
	if [ -z "$OUTPUT2" ]
	then
		#inform which intersaces are different
		echo "${array[index]}" 
		#reate a new config file for not configured interfaces
      		touch /etc/sysconfig/network-scripts/'ifcfg'-${array[$index]}
		#get MAC address
		OUTPUT="$(cat /sys/class/net/${array[$index]}/address)"
		echo "BOOTPROTO=dhcp
DEVICE=${array[$index]}
HWADDR=${OUTPUT}
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
ZONE=public" >> /etc/sysconfig/network-scripts/'ifcfg'-${array[$index]}
#put those informations into already crat4ed files.
	fi
done
#restart configuration
systemctl restart network.service
