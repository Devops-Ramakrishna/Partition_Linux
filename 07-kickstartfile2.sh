#!/bin/bash
lang en_US
keyboard --xlayouts='us'
timezone America/Chicago --utc
rootpw $2b$10$ruuBBd.JFKbCOOf3sr8AU.HxoidArJVpnn7me2Yj8AANjgKUgaVUy --iscrypted
reboot
text
cdrom
bootloader --append="rhgb quiet crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
zerombr
clearpart --all --initlabel
autopart
network --bootproto=dhcp
firstboot --disable
selinux --enforcing
firewall --enabled
%post
#!/bin/bash

# Set hostname
hostnamectl set-hostname myhost

%end
%packages
@^minimal-environment
@print-server
@web-server
%end


  mount -o loop,ro /var/lib/libvirt/images/rhel-9.3-x86_64-boot.iso /tmp/rhel9-iso
  612  ls -ltr
  613  cp -r /tmp/rhel9-iso/* .
  614  ls -ltr
  615  vi ks.cfg
  616  qemu-img create -f qcow2 -F raw -b /tmp/rhel9-custom/ -m 4096 /root/rhel9_custom_rhel9.3.qcow2
  617  qemu-img create -f qcow2 -F raw -b /tmp/rhel9-custom/ks.cfg -m 4096 /root/rhel9_custom_rhel9.3.qcow2
  618  qemu-img create -f qcow2 -F raw -b /tmp/rhel9-custom/ks.cfg /root/rhel9_custom_rhel9.3.qcow2
  619  qemu-img convert -f raw -O qcow2 /tmp/rhel-9.3-boot/osbuild.ks custom_rhel9.3.qcow2
  620  qemu-img convert -f raw -O qcow2 /tmp/rhel9-custom/ks.cfg /root/rhel9_custom_rhel9.3.qcow2
  621  qemu-img check /root/rhel9_custom_rhel9.3.qcow2
  622  cd /home/cpeinfra/
  623  ls
