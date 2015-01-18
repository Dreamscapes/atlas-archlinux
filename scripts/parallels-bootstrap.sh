#!/bin/bash

# Mount the iso and move it onto an rw media for patching
mkdir -p /iso
mount /root/prl-tools-lin.iso /iso
cp -r /iso /mnt/root/iso

# Move our support files into chroot
mv /root/parallels /mnt/root/

arch-chroot /mnt /root/parallels/install.sh

# Cleanup
rm -rf /mnt/root/parallels
rm -rf /mnt/root/iso
