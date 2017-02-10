#!/bin/bash

set -o errexit -o pipefail

### INSTALLATION BOOTSTRAP ###

# The purpose of this file is to enable ssh service with a passwordless root account for Packer.
# This only affects the installation ISO's booted system, not the final build.

cat <<LIST >> /etc/ssh/sshd_config
PermitRootLogin yes
PermitEmptyPasswords yes
LIST

# sshd may not even be started, but this will take care of that...
systemctl restart sshd.service
