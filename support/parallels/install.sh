#!/bin/bash

cd /

### Parallels Tools installation ###

# Mount the iso
mkdir -p /mnt/iso
mount /tmp/prl-tools-lin.iso /mnt/iso

# Patch the tools for Linux >=3.19
cp -r /mnt/iso /tmp/prltools
mkdir /tmp/kmods
tar -xzf /tmp/prltools/kmods/prl_mod.tar.gz -C /tmp/kmods
patch -p 0 -d /tmp -i /tmp/parallels/parallels-linux-3.19.diff
tar -czf /tmp/prltools/kmods/prl_mod.tar.gz -C /tmp/kmods .

# Persuade the installer that we are running a compatible Linux flavour
ln -sf /usr/lib/systemd/scripts /etc/init.d
export def_sysconfdir=/etc/init.d

# Install!
/tmp/prltools/install --install-unattended

# Configure systemd unit
mv /tmp/parallels/parallels-tools.service /usr/lib/systemd/system/
chown root:root /usr/lib/systemd/system/parallels-tools.service
systemctl enable parallels-tools.service

# Cleanup
umount /mnt/iso
rm -rf /mnt/iso
rm -rf /etc/init.d
rm -rf /var/log/parallels.log # It contains my shared folders! I don't want you guys to see that!:)


### Fixes for known errors ###

cat <<LIST >> /etc/modprobe.d/blacklist.conf
# Disable intel_rapl to stop errors about no valid rapl domains
blacklist intel_rapl
LIST

# Regenerate ramdisk
mkinitcpio -p linux
