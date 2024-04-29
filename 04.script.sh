#!/bin/bash

# Define variables
DISK="/dev/sda"  # Change this to the appropriate disk, e.g., /dev/sdb
PARTITION1="${DISK}1"  # Define partition 1
PARTITION2="${DISK}2"  # Define partition 2

# Partition the disk
parted -s $DISK mklabel gpt  # Create a GPT partition table
parted -s $DISK mkpart primary ext4 1MiB 50%  # Create partition 1
parted -s $DISK mkpart primary ext4 50% 100%  # Create partition 2

# Format the partitions
mkfs.xfs $PARTITION1  # Format partition 1 as ext4
mkfs.xfs $PARTITION2  # Format partition 2 as ext4

# Mount the partitions
mkdir /mnt/partition1  # Create a mount point for partition 1
mkdir /mnt/partition2  # Create a mount point for partition 2
mount $PARTITION1 /mnt/partition1  # Mount partition 1
mount $PARTITION2 /mnt/partition2  # Mount partition 2

# Optional: Update /etc/fstab for automatic mounting on boot
echo "$PARTITION1 /mnt/partition1 xfs defaults 0 0" >> /etc/fstab
echo "$PARTITION2 /mnt/partition2 xfs defaults 0 0" >> /etc/fstab

# Output confirmation
echo "Partitioning and mounting completed successfully."