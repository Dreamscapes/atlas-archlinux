#!/bin/bash

### Fixes for known errors ###

# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
echo "blacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf
# Disable intel_rapl - no matter what I do it keeps complaining about no valid rapl domains
echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf
# Regenerate ramdisk
mkinitcpio -p linux
