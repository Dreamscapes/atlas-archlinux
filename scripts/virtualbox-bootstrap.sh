#!/usr/bin/env bash

mv /root/virtualbox /mnt/root/

arch-chroot /mnt /root/virtualbox/install.sh

# Cleanup
rm -rf /mnt/root/virtualbox
