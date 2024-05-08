#!/bin/bash

# first check which interface is up:
ip addr show | grep "state UP" | awk -F ':' '{print $2}'

# Set network interface name
INTERFACE="enp1s0"

# Set static IP address, netmask, gateway, and DNS servers
IP_ADDRESS="10.81.75.165/24"
NETMASK="255.255.254.0"
GATEWAY="10.81.75.254"
DNS_SERVER="10.81.90.1"

# Create the NetworkManager connection profile
vi /etc/NetworkManager/system-connections/$INTERFACE
[connection]
id=$INTERFACE
uuid=your-uuid-here
type=ethernet
interface-name=$INTERFACE

[ipv4]
method=manual
address1=$IP_ADDRESS/$NETMASK,$GATEWAY;
dns=$DNS_SERVER;
EOF

# Restart NetworkManager to apply the changes
systemctl restart NetworkManager

# Verify network configuration
echo "Network configuration:"
nmcli connection show $INTERFACE
nmcli connection up $INTERFACE