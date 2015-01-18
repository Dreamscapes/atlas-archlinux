#!/bin/bash

### Parallels Tools installation ###

ln -sf /usr/lib/systemd/scripts/ /etc/init.d
export def_sysconfdir=/etc/init.d

# Install kernel headers and Python for the install script
pacman -S python2 linux-headers --needed --noconfirm
ln -sf /usr/bin/python2 /usr/bin/python

# Patching time! Patch the install script so that it will patch the actual file that needs patching.
# I call this a thought-through approach! :)
patch -p 0 -i /root/parallels/install-kmods.sh.diff

# Since the booted kernel might be different than the one which will be used on the target machine
# (because the installation image might be outdated) we need to link the linux headers so that
# when parallels looks for headers for `uname -r`, it will find our current headers
src=/usr/lib/modules/$(uname -r)
tgt=/usr/lib/modules/$(ls /usr/lib/modules | tr " " "\n" | head -n 1)

# Create the symlink, but only if the target directory does not exist
[ ! -d $src ] && ln -s $tgt $src

# Fingers crossed...
cd /root/iso && ./install --install-unattended

# Configure systemd unit
mv /root/parallels/parallels-tools.service /usr/lib/systemd/system/
systemctl enable parallels-tools.service

# Cleanup
pacman -R python2 linux-headers --noconfirm --nosave
rm -rf $src
rm -rf /etc/init.d
rm -rf /usr/bin/python
