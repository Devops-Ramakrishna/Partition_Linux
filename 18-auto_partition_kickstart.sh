#! /bin/bash
graphical
rootpw $2b$10$1riaGsfa8jGSEyKcZS2cjOMGBk.mua6clfgohemvsGunGe1yY3aOu --iscrypted
user --name=cpeinfra --password=$6$lvTIOlQuqrnmSYBv$JTSvJ7NCaV7mwfFxRbBydroFmeIdCFiZoqOGJ8W2ZZg1dJw4g3SoUwGFTg6VVlUapxjGn1mnWqwjmfrOGKQVG0 --iscrypted --gecos="cpeinfra"
liveimg --url="file:///run/install/repo/liveimg.tar.gz"

bootloader --append="rhgb quiet crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M" --location=mbr --boot-drive=nvme0n1
zerombr
# Create partition table
clearpart --all --initlabel
autopart
reboot

%post
for i in {1..5}; do
  systemctl start cockpit && break
  sleep 5
done
systemctl enable cockpit
%end


%post --interpreter /bin/bash
{
    # Enable and start the Cockpit service
    service cockpit.socket start
    systemctl enable cockpit.socket

    # Open the Cockpit port in the firewall
    firewall-cmd --permanent --add-service=cockpit
    firewall-cmd --reload

    # Log post-install actions
    echo "Cockpit service enabled and started" >> /root/ks-post.log
    echo "Firewall configured for Cockpit" >> /root/ks-post.log
} 2>&1 | tee -a /root/ks-post.log
%end