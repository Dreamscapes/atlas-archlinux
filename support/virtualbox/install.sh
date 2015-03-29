#!/bin/bash

### VirtualBox Guest Utils installation ###

# Set pacman repository to point to the ARM because VirtualBox requires the most recent kernel
# available for Arch Linux
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
cat <<LIST > /etc/pacman.d/mirrorlist
Server = http://seblu.net/a/arm/2015/03/18/\$repo/os/\$arch
LIST
# Refresh database
pacman -Syy

# Install VirtualBox Guest Utils without X.Org support
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
patch -p 0 -i /tmp/virtualbox/grub.diff
grub-mkconfig -o /boot/grub/grub.cfg

# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
echo "blacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf
# Regenerate ramdisk
mkinitcpio -p linux

# Restore pacman mirrorlist and refresh databases
rm /etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
pacman -Syy
