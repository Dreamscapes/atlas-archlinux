#!/bin/bash

set -o errexit -o pipefail

### SYSTEM INSTALLATION ###

# Partition disks with the following layout on a DOS partition table:
# Device       Start   Size   Id  Type
# /dev/sda1     2048   200M   83  Linux
# /dev/sda2   411648    ???   83  Linux
fdisk /dev/sda <<FDISK
o
n
p


+200M
n
p



p
w
FDISK

# Format filesystems
mkfs.btrfs --label boot /dev/sda1
mkfs.btrfs --label root /dev/sda2

# Mount the newly created filesystems
mkdir -p /mnt
mount -o defaults,compress=lzo,space_cache /dev/sda2 /mnt
mkdir -p /mnt/boot
mount -o defaults,compress=lzo,space_cache /dev/sda1 /mnt/boot

# Force pacman to always use packages as they appeared in history at the time of the release
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.original
# ARCH_VERSION is provided via packer configuration and is taken from the config.json's archversion
cat <<MIRRORLIST > /etc/pacman.d/mirrorlist
# Pacman mirrorlist at the time of this version's release
# To restore current mirrorlist, replace this file with
# /etc/pacman.d/mirrorlist.original which was backed up during image build.

Server = https://ala.seblu.net/repos/$(echo $ARCH_VERSION | sed -e 's/\./\//g')/\$repo/os/\$arch
MIRRORLIST

# Install required system packages
packages=""
for package in $(cat /tmp/shared/packages); do packages="${packages} ${package}"; done
pacstrap /mnt $packages

# Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

# Copy shared resources required for OS installation under chrooted root homefolder
mv /tmp/shared /mnt/root/

# Configure the system...
arch-chroot /mnt /root/shared/os-config.sh
# Configure vagrant...
arch-chroot /mnt /root/shared/vagrant-config.sh

# Cleanup all the mess
rm -r /mnt/root/shared
