# Kickstart file for RHEL 9.3

# Install OS
install
cdrom

# System language
lang en_US.UTF-8

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System timezone
# timezone America/New_York --isUtc
timezone --utc Asia/Kolkata

# Root password
rootpw --plaintext cpeinfra

# Partition information
clearpart --all --initlabel
part /boot --fstype=xfs --size=512
part pv.01 --grow --size=1
volgroup vg01 pv.01
logvol / --vgname=vg01 --size=31457280 --fstype=xfs --name=root
logvol swap --vgname=vg01 --size=10485760 --name=swap

# Network information
network --bootproto=dhcp --device=ens192 --ipv6=auto --activate
network --hostname=myhost.example.com

# Firewall configuration
firewall --enabled --service=ssh

# Package selection
%packages
@^minimal-environment
@core
%end

# Post-installation scripts
%post
# Add any post-installation tasks here
%end