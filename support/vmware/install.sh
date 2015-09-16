#!/bin/bash

cd /

### VMWare Guest Utils installation ###

# Put the Arch Linux version information into /etc/arch-release (required by guest utils)
cat /proc/version > /etc/arch-release

# Install guest utils
pacman -S --noconfirm open-vm-tools unzip

# Enable the service
systemctl enable vmtoolsd.service

# Install shared folders support
# This package is no longer available on AUR, but I found the source code in Github, so let's try
# to compile it from master...
curl -o /tmp/open-vm-tools-dkms.zip \
  https://codeload.github.com/davispuh/open-vm-tools-dkms/zip/master
# Extract...
unzip /tmp/open-vm-tools-dkms.zip -d /tmp/
chmod -R 777 /tmp/open-vm-tools-dkms-master
cd /tmp/open-vm-tools-dkms-master
# Build and install! We must do this as non-root, otherwise makepkg will blow up
su vagrant -c 'makepkg --syncdeps --clean --noconfirm --install'
cd /

# Enable some VMWare kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/vmware.conf
vmw_balloon
vmhgfs
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

# Uninstall unzip
pacman -R --nosave --noconfirm unzip

# Regenerate ramdisk
mkinitcpio -p linux
