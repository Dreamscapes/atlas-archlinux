#!/bin/bash

set -o errexit -o pipefail

### VAGRANT CONFIGURATION ###

# Create 'vagrant' user (public key will be uploaded by Packer)
useradd vagrant --create-home --user-group

# Set default password to 'vagrant'
echo 'vagrant:vagrant' | chpasswd

# Configure ssh access
mkdir /home/vagrant/.ssh
mv /root/shared/vagrant-insecure-key.pub /home/vagrant/.ssh/authorized_keys

# Protect the homefolder and ssh keys
chown -R vagrant:vagrant /home/vagrant
chmod -R g-rwx,o-rwx /home/vagrant/.ssh

# Allow passwordless sudo for vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
