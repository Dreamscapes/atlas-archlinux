#!/usr/bin/env bash

mv /root/vmware /mnt/root/

arch-chroot /mnt /root/vmware/install.sh

# Cleanup
rm -rf /mnt/root/vmware
