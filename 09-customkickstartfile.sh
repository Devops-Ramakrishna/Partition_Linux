#!/bin/bash

# Kickstart file for RHEL 9.3

# System authorization information
auth --enableshadow --passalgo=sha512

# Install OS
install
cdrom

# System language
lang en_US.UTF-8

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System timezone
timezone --utc Asia/Kolkata

# Root password
rootpw --plaintext cpeinfra

# Network information
network  --bootproto=dhcp --device=ens192 --ipv6=auto --activate
network  --hostname=rhel9.example.com

# Reboot after installation
reboot

# Disk partitioning information
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
zerombr
clearpart --all --initlabel
autopart

# Package selection
%packages
@^minimal-environment
@cockpit
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