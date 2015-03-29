#!/bin/bash

### Parallels Tools installation ###

# Mount the iso
mkdir -p /mnt/iso
mount /tmp/prl-tools-lin.iso /mnt/iso

# Persuade the installer that we are running a compatible Linux flavour
ln -sf /usr/lib/systemd/scripts/ /etc/init.d
export def_sysconfdir=/etc/init.d

# Install Python for the install script
pacman -S --needed --noconfirm python2
ln -sf /usr/bin/python2 /usr/bin/python

# Fingers crossed...
/mnt/iso/install --install-unattended

# Configure systemd unit
mv /tmp/parallels/parallels-tools.service /usr/lib/systemd/system/
chown root:root /usr/lib/systemd/system/parallels-tools.service
systemctl enable parallels-tools.service

# Cleanup
pacman -R --noconfirm --nosave python2
umount /mnt/iso
rm -rf /etc/init.d
rm -rf /usr/bin/python
rm -rf /mnt/iso
rm -rf /var/log/parallels.log
