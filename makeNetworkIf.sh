#!/usr/bin/env bash
#
# Provides      : Automatical configuration od Network interfaces of Openstack machine
# 

OUTPUT1="$(ifconfig)"
OUTPUT2="$(ifconfig -a)"

if [ "$OUTPUT1" == "$OUTPUT2" ]
    then
        echo "All network interfaces are cofigured"
    	exit 1
fi

OUTPUT="$(ls /sys/class/net)"

IFS=' ' read -r -a array <<< ${OUTPUT}

for index in "${!array[@]}"
do
	OUTPUT2="$(ls /etc/sysconfig/network-scripts | grep ${array[index]})"
	if [ -z "$OUTPUT2" ]
	then
		echo "${array[index]}"
      		touch /etc/sysconfig/network-scripts/'ifcfg'-${array[$index]}
		OUTPUT="$(cat /sys/class/net/${array[$index]}/address)"
		echo "${OUTPUT}"		
		echo "BOOTPROTO=dhcp
DEVICE=${array[$index]}
HWADDR=${OUTPUT}
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
ZONE=public" >> /etc/sysconfig/network-scripts/'ifcfg'-${array[$index]}

	fi
done
systemctl restart network.service
