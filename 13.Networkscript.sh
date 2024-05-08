#!/bin/bash

# Check which interfaces are up
INTERFACES=$(ip addr show | awk '/state UP/ {print $2}')

if [ -z "$INTERFACES" ]; then
    echo "No active network interfaces found."
    exit 1
fi

# Display the list of active interfaces for selection
echo "Active network interfaces:"
echo "$INTERFACES"

# Prompt the user to select an interface
read -p "Enter the interface name for network configuration: " SELECTED_INTERFACE

# Check if the selected interface is valid
if ! echo "$INTERFACES" | grep -qw "$SELECTED_INTERFACE"; then
    echo "Invalid interface selected."
    exit 1
fi

# Set network interface name
INTERFACE="$SELECTED_INTERFACE"


# Prompt the user to modify the IP address, netmask, and gateway
#read -p "Enter the new IP address (current: $IP_ADDRESS): " NEW_IP_ADDRESS
#read -p "Enter the new netmask (current: $NETMASK): " NEW_NETMASK
#read -p "Enter the new gateway (current: $GATEWAY): " NEW_GATEWAY
#read -p "Enter the new gateway (current: $DNS_SERVER): " DNS_SERVER

# Define the file path
FILE="/etc/NetworkManager/system-connections/$INTERFACE.nmconnection"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File $FILE not found."
    exit 1
fi

# Remove existing IP configuration entries
sed -i '/^address1=/d' "$FILE"
sed -i '/^dns=/d' "$FILE"

# Set static IP address, netmask, gateway, and DNS servers
IP_ADDRESS="192.168.19.135/24"
NETMASK="255.255.255.0"
GATEWAY="192.168.19.2"
DNS_SERVER="8.8.8.8,8.8.4.4"

# Create the NetworkManager connection profile
# vi /etc/NetworkManager/system-connections/$INTERFACE

sed -i '/^\[ipv4\]$/!b;n;cmethod=manual\naddress1='"$IP_ADDRESS","$NETMASK","$GATEWAY"'\ndns='"$DNS_SERVERS"'' "$FILE"
echo "Entries updated in $FILE."

# Check if the entries already exist in the file
if grep -q "method=manual" "$FILE"; then
    echo "Entries already exist in $FILE. Skipping addition."
else
     Modify the file content
     sed -i '/^\[ipv4\]$/!b;n;cmethod=manual\naddress1='"$IP_ADDRESS","$NETMASK","$GATEWAY"'\ndns='"$DNS_SERVER"'' "$FILE"
     echo "Entries added to $FILE."
fi

# Restart NetworkManager to apply the changes
systemctl restart NetworkManager

# Verify network configuration
echo "Network configuration:"
nmcli connection show $INTERFACE
nmcli connection up $INTERFACE
