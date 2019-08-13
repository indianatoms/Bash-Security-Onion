# Bash-Security-Onion

File comparator make SQL query and check whether DB has changed. If the is a new paramter in db the mail is send to the user. Nullmailer is required

makeNetworkIF.sh – Automatic configuration of Network Interfaces in Openstack machines.
First I check if `ifconfig` output (OUTOUT) is different from `ifconfig -a`. If they are the same user is informed that “All network interfaces are configured”. If not I store all available NIC names to OUTPUT variable.
OUTPUT="$(ls /sys/class/net)"
Then I make array out of this NIC names:
IFS=' ' read -r -a array <<< ${OUTPUT}
Than in a loop I check if NIC name is present in /etc/sysconfig/network-scripts/. If there the name doesn’t exist  is given folder. I make a new configuration file for given NIC with following content.
BOOTPROTO=dhcp
DEVICE=<NIC NAME>
HWADDR=<NIC MAC address>
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
ZONE=public
At the end of the script I restart the network service – to update the interface configuration using command.
systemctl restart network.service
 
