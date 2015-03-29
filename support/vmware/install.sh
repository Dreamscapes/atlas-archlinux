#!/bin/bash

### VMWare Guest Utils installation ###

# Put the Arch Linux version information into /etc/arch-release (required by guest utils)
cat /proc/version > /etc/arch-release

# Install guest utils
pacman -S --noconfirm open-vm-tools

# Enable the service
systemctl enable vmtoolsd.service

# Install shared folders support from AUR
curl -o /tmp/open-vm-tools-dkms.tar.gz \
  https://aur.archlinux.org/packages/op/open-vm-tools-dkms/open-vm-tools-dkms.tar.gz
# Extract...
tar -xf /tmp/open-vm-tools-dkms.tar.gz -C /tmp
chmod -R 777 /tmp/open-vm-tools-dkms
cd /tmp/open-vm-tools-dkms
# Build and install! We must do this as non-root, otherwise makepkg will blow up
su vagrant -c 'makepkg --syncdeps --clean --noconfirm --install'

# Enable some VMWare kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/vmware.conf
vmw_balloon
vmhgfs
vmxnet3
LIST


### Fixes for known errors ###

# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
echo "blacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf
# Disable intel_rapl - no matter what I do it keeps complaining about no valid rapl domains
echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf
# Regenerate ramdisk
mkinitcpio -p linux
