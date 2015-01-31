#!/bin/bash

### SYSTEM CONFIGURATION ###

# Localisation stuff...
echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
# Me likes British English
localectl set-locale LANG=en_GB.UTF-8
localectl set-keymap us

# Configure timezone to UTC - a sane default, I believe...
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Set up initial ramdisk
mkinitcpio -p linux

# Enable DHCP on all adapters
systemctl enable dhcpcd.service

# Install and configure bootloader
pacman -S grub --noconfirm --needed
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Install and configure ssh
pacman -S openssh --noconfirm --needed
systemctl enable sshd.service

# Clean all downloaded packages and caches to save as much space as possible
pacman -S --clean --clean --noconfirm

# Do not modify ls and prompts for all new users
patch -p 0 -i /root/shared/bashrc.diff
