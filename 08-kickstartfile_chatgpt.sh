#!/bin/bash
#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth --enableshadow --passalgo=sha512

# Use graphical installation
graphical

# Run the Setup Agent on first boot
firstboot --enable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=rhel9.example.com

# Reboot after installation
reboot

# Root password
rootpw --iscrypted $6$RzM...   # Replace with encrypted root password

# System timezone
timezone America/New_York --isUtc

# Disk partitioning information
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
zerombr
clearpart --all --initlabel
autopart

# Package selection
%packages
@^minimal-environment
kexec-tools
%end

# Installation logging level
logging --level=info

# SELinux configuration
selinux --disabled

# Do not configure the X Window System
skipx

# Enable Firewall
firewall --enabled --ssh

# Display information about the installation
%post
echo "RHEL 9 installation complete."
%end
