#!/bin/bash

# first check which interface is up:
INTERFACE=$(ip addr show | grep "state UP" | awk -F ': ' '{print $2}'| head -1)
echo "$INTERFACE"

if [ -n "$INTERFACE" ]; then
    echo "The first active network interface is: $INTERFACE"
else
    echo "No active network interface found."
    exit 1
fi

# Set network interface name
INTERFACE="$INTERFACE"

# Set static IP address, netmask, gateway, and DNS servers
IP_ADDRESS="10.81.75.165/24"
NETMASK="255.255.254.0"
GATEWAY="10.81.75.254"
DNS_SERVER="10.81.90.1"

# Define the file path
FILE="/etc/NetworkManager/system-connections/$INTERFACE.nmconnection"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File $FILE not found."
    exit 1
fi

# Create the NetworkManager connection profile
# vi /etc/NetworkManager/system-connections/$INTERFACE

#The script checks if the file exists and then uses sed to modify the content of the file by changing the method under [ipv4] to manual 
# and adding the address1 and dns entries with the provided IP configuration.

# Check if the entries already exist in the file
if grep -q "method=manual" "$FILE"; then
    echo "Entries already exist in $FILE. Skipping addition."
else
    # Modify the file content
    sed -i '/^\[ipv4\]$/!b;n;cmethod=manual\naddress1='"$IP_ADDRESS","$NETMASK","$GATEWAY"'\ndns='"$DNS_SERVER"'' "$FILE"
    echo "Entries added to $FILE."
fi

#sed -i '/^\[ipv4\]$/!b;n;cmethod=manual\naddress1='"$IP_ADDRESS","$NETMASK","$GATEWAY"'\ndns='"$DNS_SERVER"'' "$FILE"
# echo "File $FILE has been updated with the new IP configuration:"

# Restart NetworkManager to apply the changes
systemctl restart NetworkManager

# Verify network configuration
echo "Network configuration:"
nmcli connection show $INTERFACE
nmcli connection up $INTERFACE