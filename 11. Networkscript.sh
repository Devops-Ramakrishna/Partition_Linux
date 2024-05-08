#! /bin/bash

# Set network interface name
INTERFACE="ens192"

# Set IP address, netmask, and gateway
IP_ADDRESS="192.168.1.100"
NETMASK="255.255.255.0"
GATEWAY="192.168.1.1"

# Set DNS servers
DNS_SERVERS="8.8.8.8 8.8.4.4"

# Configure network interface
nmcli connection add type ethernet ifname $INTERFACE ip4 $IP_ADDRESS/24 gw4 $GATEWAY
nmcli connection modify $INTERFACE ipv4.dns "$DNS_SERVERS"
nmcli connection up $INTERFACE

# Verify network configuration
echo "Network configuration:"
nmcli connection show $INTERFACE
