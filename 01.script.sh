#! /bin/bash

# Start the %post section

%post

# Within the %post section, you can include commands to create partitions, logical volumes, and filesystems as needed. 
# Here is an example of creating partitions using fdisk:

fdisk /dev/sda <<EOF
n
p
1

+20G
t
1
8e
w
EOF

# You can then format the partitions with the desired filesystem type. 
# For example, formatting a partition as ext4:

mkfs.ext4 /dev/sda1

# If you are using LVM, you can create volume groups and logical volumes. 
# Here is an example:

pvcreate /dev/sda1
vgcreate myvg /dev/sda1
lvcreate -n mylv -L +20G myvg

# you can mount the partitions and logical volumes to the desired mount points:

mkdir /mypartition
mount /dev/myvg/mylv /mypartition

# make it permanent in /etc/fstab

echo "/dev/myvg/mylv /mypartition   xfs  defaults 1 2" >> /etc/fstab

%end



 