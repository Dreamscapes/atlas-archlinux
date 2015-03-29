#!/bin/bash

cd /

### Parallels Tools installation ###

# Mount the iso
mkdir -p /mnt/iso
mount /tmp/prl-tools-lin.iso /mnt/iso

# Persuade the installer that we are running a compatible Linux flavour
ln -sf /usr/lib/systemd/scripts /etc/init.d
export def_sysconfdir=/etc/init.d

# Install!
/mnt/iso/install --install-unattended

# Configure systemd unit
mv /tmp/parallels/parallels-tools.service /usr/lib/systemd/system/
chown root:root /usr/lib/systemd/system/parallels-tools.service
systemctl enable parallels-tools.service

# Cleanup
umount /mnt/iso
rm -rf /etc/init.d
rm -rf /mnt/iso
rm -rf /var/log/parallels.log # It contains my shared folders! I don't want you guys to see that!:)


### Fixes for known errors ###

# Disable intel_rapl - no matter what I do it keeps complaining about no valid rapl domains
echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf
# Regenerate ramdisk
mkinitcpio -p linux
