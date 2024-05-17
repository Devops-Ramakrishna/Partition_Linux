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

# Define the file path
FILE="/etc/NetworkManager/system-connections/$INTERFACE.nmconnection"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File $FILE not found."
    exit 1
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Read the IP configuration from the input file
IP_ADDRESS=$(awk -F'=' '/IP_ADDRESS/ {print $2}' "$1")
NETMASK=$(awk -F'=' '/NETMASK/ {print $2}' "$1")
GATEWAY=$(awk -F'=' '/GATEWAY/ {print $2}' "$1")
DNS_SERVER=$(awk -F'=' '/DNS_SERVER/ {print $2}' "$1")

# Update the network configuration file
sed -i '/^\[ipv4\]$/!b;n;s/method=auto/method=manual/;n;caddress1='"$IP_ADDRESS"'\ndns='"$DNS_SERVER"'' "$FILE"

echo "Entries updated in $FILE."

# Restart NetworkManager to apply the changes
systemctl restart NetworkManager

# Verify network configuration
echo "Network configuration:"
nmcli connection show
nmcli connection up $INTERFACE
