#! /bin/bash

currnetdir=$PWD
logfile=$currnetdir/network_config.log
ipaddress=$(echo $1 | awk -F '/' '{print $1}') 
netmask=$(echo $1 | awk -F '/' '{print $2}')
gateway=$2 
dnsserverip=$3

Print2Log()
{
    msg=$1
    echo "[date +%x_%H:%M:%S:%3N] ${msg}" >>$logfile
}

usage="\n\t Wrong option Given, Usage: sh $0 $1 $2 $3
       \n\t Example: sh $0 ipaddress/netmask gateway dnsserverip\n
       \n\t sh $0 10.81.75.171/23 10.81.75.254 10.80.91.1"

       if [[ -z $1 ]]; then
           echo -ne "$usage" | tee -a $logfile
           exit 1
       fi
       if [[ -z $2 ]]; then
           echo -ne "$usage" | tee -a $logfile
           exit 1
       fi
       if [[ -z $3 ]]; then
           echo -ne "$usage" | tee -a $logfile
           exit 1
       fi

# first check which interface is up:
interface=$(ip addr show | grep "state UP" | awk -F ': ' '{print $2}'| head -1)
echo "$interface" 

if [ -n "$interface" ]; then
    echo "The first active network interface is: $interface" 
else
    echo "No active network interface found."
    exit 1
fi

# Set network interface name
interface="$interface"

# Define the file path
file="/etc/NetworkManager/system-connections/$interface.nmconnection"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File $file not found."
    exit 1
fi 

search_string="nameserver $dnsserverip"

file_path="/etc/resolv.conf"

if ! grep -qF "$search_string" "$file_path"; then
    # If the string is not present, add it to the file
    echo -e "$search_string" >> "$file_path"
    echo "String added to the file"
else
    echo "String already present in the file"
fi

id=$(nmcli con show $interface | grep connection.id | awk -F ' ' '{print $NF}')
uuid=$(nmcli con show $interface | grep connection.uuid | awk -F ' ' '{print $NF}')
type=$(nmcli con show $interface | grep connection.type | awk -F ' ' '{print $NF}' | awk -F '-' '{print $NF}')
interface_name=$(nmcli con show $interface | grep connection.interface-name | awk -F ' ' '{print $NF}')

echo -e "[connection]\nid=$id\nuuid=$uuid\ntype=$type\ninterface-name=$interface_name\n\n[ethernet]\n\n[ipv4]\nmethod=manual\naddress=$ipaddress/$netmask,$gateway" >/etc/NetworkManager/system-connections/$interface.nmconnection

systemctl restart NetworkManager
nmcli connection down $interface && nmcli connection up $interface