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
