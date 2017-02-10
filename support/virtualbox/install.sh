#!/bin/bash

cd /

### VirtualBox Guest Utils installation ###

# Install VirtualBox Guest Utils without X.Org support
pacman -S --noconfirm virtualbox-guest-utils-nox

# Enable VirtualBox kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
LIST

# Prevent guest utilities from being upgraded (they might depend on newer kernel version and cause
# unresolvable conflict)
patch -p 0 -i /tmp/virtualbox/pacman.conf.diff


### Fixes for known errors ###

# Grub patch to fix boot error: "Fast TSC calibration failed"
patch -p 0 -i /tmp/virtualbox/grub.diff
grub-mkconfig -o /boot/grub/grub.cfg

cat <<LIST >> /etc/modprobe.d/blacklist.conf
# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
blacklist i2c_piix4
LIST


### Finalise... ###

# Regenerate ramdisk
mkinitcpio -p linux
