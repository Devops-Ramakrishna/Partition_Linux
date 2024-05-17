#! /bin/bash
text
rootpw $2b$10$1riaGsfa8jGSEyKcZS2cjOMGBk.mua6clfgohemvsGunGe1yY3aOu --iscrypted
user --name=cpeinfra --password=$6$lvTIOlQuqrnmSYBv$JTSvJ7NCaV7mwfFxRbBydroFmeIdCFiZoqOGJ8W2ZZg1dJw4g3SoUwGFTg6VVlUapxjGn1mnWqwjmfrOGKQVG0 --iscrypted --gecos="cpeinfra"
liveimg --url="file:///run/install/repo/liveimg.tar.gz"

bootloader --append="rhgb quiet crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M" --location=mbr --boot-drive=nvme0n1
zerombr
lang en_US
keyboard --xlayouts='us'
timezone America/New_York --utc
reboot
cdrom
# Create partition table
clearpart --all --initlabel

# Create boot partition
part /boot --size=512 --fstype=ext4
part /boot/efi --size=512 --fstype=ext4

# Create root partition
part / --size=10000

# Create swap partition
part swap --size=8192

# Create LVM partition
part pv.01 --size=1 --grow

# Create volume groups
volgroup vg01 pv.01

# Create logical volumes
logvol /usr --vgname=vg01 --percent=30 --name=lv_usr
logvol /opt --vgname=vg01 --percent=1 --name=lv_opt
logvol /home --vgname=vg01 --percent=8 --name=lv_home
logvol /var/lib/containers --vgname=vg01 --percent=30 --name=lv_var_lib_containers
logvol /var/log/audit --vgname=vg01 --percent=2 --name=lv_var_log_audit
logvol /var/log --vgname=vg01 --percent=1 --name=lv_var_log
logvol /var --vgname=vg01 --percent=10 --name=lv_var
logvol /var/tmp --vgname=vg01 --percent=4 --name=lv_var_tmp

firstboot --disable
selinux --disable
ignoredisk --only-use=nvme0n1
firewall --enabled

%post
mount /dev/cdrom /mnt

# Copy network_config.sh to a local path
cp /mnt/network_config.sh /home/cpeinfra

# Unmount the CD-ROM
umount /mnt
%end


%post --nochroot
hostnamectl set-hostname cpeinfravm
hostnamectl --pretty set-hostname cpeinfravm
cp /etc/hostname /mnt/sysimage/etc/hostname
cp /etc/machine-info /mnt/sysimage/etc/machine-info
%end

%post
for i in {1..5}; do
  systemctl start cockpit && break
  sleep 5
done
systemctl enable cockpit
%end

%post --nochroot
# Start and enable the Cockpit service
systemctl start cockpit
systemctl enable --now cockpit
%end