#!/bin/bash

cd /

### VMWare Guest Utils installation ###

# Install guest utils
pacman -S --noconfirm open-vm-tools

# Enable the service
systemctl enable vmtoolsd.service

# Enable some VMWare kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/vmware.conf
vmw_balloon
vmxnet3
LIST

# Prevent guest utilities from being upgraded (they might depend on newer kernel version and cause
# unresolvable conflict)
patch -p 0 -i /tmp/vmware/pacman.conf.diff


### Fixes for known errors ###

cat <<LIST >> /etc/modprobe.d/blacklist.conf
# Disable intel_rapl to stop errors about no valid rapl domains
blacklist intel_rapl

# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
blacklist i2c_piix4
LIST


### Finalise... ###

# Regenerate ramdisk
mkinitcpio -p linux
