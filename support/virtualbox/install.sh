#!/bin/bash

### VirtualBox Guest Utils installation ###

# Let's not waste space by installing X.Org support
pacman -S --noconfirm virtualbox-guest-utils-nox

# Enable VirtualBox kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
LIST


### Fixes for known errors ###

# Grub patch to fix boot error: "Fast TSC calibration failed"
patch -p 0 -i /root/virtualbox/grub.diff
grub-mkconfig -o /boot/grub/grub.cfg

# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
echo "blacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf
# Regenerate ramdisk
mkinitcpio -p linux
