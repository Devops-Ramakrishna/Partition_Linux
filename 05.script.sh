#!/bin/bash

# This script creates disk partitions after installing RHEL 9 on the server.

# Make sure to run this script with root privileges.

# Displaying available disks
echo "Available disks:"
lsblk

# Prompting user to select a disk
echo "Please enter the disk you want to partition (e.g. sda):"
read disk

# Displaying current partition table
echo "Current partition table of /dev/$disk:"
fdisk -l /dev/$disk

# Prompting user to confirm disk selection
echo "WARNING: All data on /dev/$disk will be lost. Do you want to continue? (y/n)"
read confirm

# Checking user confirmation
if [ "$confirm" != "y" ]; then
  echo "Partitioning cancelled."
  exit 1
fi

# Partitioning disk
echo "Creating partitions on /dev/$disk..."
(echo n; echo p; echo 1; echo ; echo +200G; echo n; echo p; echo 2; echo ; echo +250G; echo n; echo p; echo 3; echo ; echo ; echo t; echo 1; echo 8e; echo w) | fdisk /dev/$disk

# Formatting partitions
echo "Formatting partitions..."
mkfs.ext4 /dev/${disk}1
mkfs.ext4 /dev/${disk}2
mkfs.ext4 /dev/${disk}3

# Creating mount points
echo "Creating mount points..."
mkdir /mnt/part1
mkdir /mnt/part2
mkdir /mnt/part3

# Mounting partitions
echo "Mounting partitions..."
mount /dev/${disk}1 /mnt/part1
mount /dev/${disk}2 /mnt/part2
mount /dev/${disk}3 /mnt/part3

# Adding partitions to /etc/fstab
echo "Adding partitions to /etc/fstab..."
echo "/dev/${disk}1 /mnt/part1 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/${disk}2 /mnt/part2 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/${disk}3 /mnt/part3 ext4 defaults 0 0" >> /etc/fstab

echo "Disk partitioning completed."