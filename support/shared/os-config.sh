#!/bin/bash

### SYSTEM CONFIGURATION ###

# Localisation stuff...
cat <<LIST > /etc/locale.gen
en_GB.UTF-8 UTF-8
en_US.UTF-8 UTF-8
LIST

locale-gen
# Me likes British English
echo LANG=en_GB.UTF-8 > /etc/locale.conf
echo KEYMAP=us > /etc/vconsole.conf

# Configure timezone to UTC - a sane default, I believe...
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable required services
systemctl enable dhcpcd.service
systemctl enable sshd.service

# Configure bootloader
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Clean all downloaded packages and caches to save as much space as possible
pacman -S --clean --clean --noconfirm

# Blacklist kernel and headers from upgrades
patch -p 0 -i /root/shared/pacman.conf.diff

# Do not modify ls and prompts for all new users
patch -p 0 -i /root/shared/bashrc.diff

# Create initial mandb database (recommended by man-db package)
mandb --quiet
