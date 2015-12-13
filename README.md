# Arch Linux - Base

> A minimal Arch Linux box for you to build upon

## Build template

The images have been built using [Packer](https://www.packer.io) and published to [Atlas](https://atlas.hashicorp.com/dreamscapes/boxes/archlinux).

## Vagrant

These boxes are made for [Vagrant](https://www.vagrantup.com) - to install this box, simply run:

`vagrant box add dreamscapes/archlinux [--provider parallels|vmware_desktop|virtualbox]`

Alternatively, you can simply specify this box in your [Vagrantfile](https://docs.vagrantup.com/v2/vagrantfile/index.html) and Vagrant will download the box for your default provider automatically:

> You may want to override your default provider by setting an environment variable:
> `VAGRANT_DEFAULT_PROVIDER=parallels`
>
> The above will set Parallels Desktop to be your default virtualisation platform for Vagrant boxes

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "dreamscapes/archlinux"
end
```

## Configuration

Only the absolutely necessary configuration has been done in order for the machine to work in a Vagrant environment.

### Kernel info

When it comes to Linux kernel modules, the kernel itself is a moving target - even minor releases may introduce API changes that could break kernel modules used by VM guest utilities. For this reason, the kernel will be upgraded separately from other packages, after it has been verified that all guest utilities are fully compatible with the new kernel version.

This is the only way to enjoy Arch Linux in a fully functional VM environment.

- **Released kernel version: 4.2.5-1**
- **Staged kernel version: 4.2.5-1**

> Staged kernel version is the version that will be available in the next Vagrant box version.

### OS info

- x64 architecture
- All drives are formatted as `btrfs` with lzo compression on a MBR partition table
- Locale is set to `en_GB.UTF-8` (override with `localectl set-locale ???`)
- Keyboard is set to `us` (override with `localectl set-keymap ???`)
- Timezone is set to UTC
- root password is empty (**set one after installation to secure your box**)
- user & group `vagrant` has been added, with default password being *vagrant* (**reset it after installation to secure your box**)
- user `vagrant` has passwordless `sudo` enabled
- ssh is enabled in order for Vagrant to be able to manage the VM

### HW info

- CPUs: 2
- HDD: 64 GB, dynamically allocated, with partitions for `/` and `/boot`
- Execution cap: left default (100%)
- RAM: 1024 MB

> Hardware configuration can easily be tweaked to your liking via Vagrantfile. See [Provider configuration](https://docs.vagrantup.com/v2/providers/configuration.html).

### Installed packages

Only the minimum required to get you going has been installed. The following packages / package groups have been installed:

- base
- base-devel
- openssh
- btrfs-progs

The following packages have been added to pacman upgrade blacklist:

- linux
- linux-headers
- linux-firmware

#### VirtualBox

The following extra packages are installed to VirtualBox image:

- [virtualbox-guest-utils-nox](https://www.archlinux.org/packages/community/x86_64/virtualbox-guest-utils-nox)

The following packages have been added to pacman upgrade blacklist:

- virtualbox-guest-utils-nox
- virtualbox-guest-modules

The following kernel modules have been disabled via */etc/modprobe.d/blacklist.conf*:

- `i2c_piix4`

The following modules provided by the guest utilities are automatically loaded via */etc/modules-load.d/virtualbox.conf*:

- `vboxguest`
- `vboxsf`
- `vboxvideo`

#### Parallels

The following extra packages are installed to Parallels image:

- Parallels Guest Utilities (provided by Parallels Desktop 11.1.1 build 32312)
- dkms (Required by Guest Utilities)
- multipath-tools (AUR) (Required by Guest Utilities for kpartx)

The following kernel modules have been disabled via */etc/modprobe.d/blacklist.conf*:

- `intel_rapl`

#### VMWare

The following extra packages are installed to VMWare image:

- [open-vm-tools](https://www.archlinux.org/packages/community/i686/open-vm-tools)

The following packages have been added to pacman upgrade blacklist:

- open-vm-tools

The following modules provided by the guest utilities are automatically loaded via */etc/modules-load.d/vmware.conf*:

- `vmw_balloon`
- `vmxnet3`

The following kernel modules have been disabled via */etc/modprobe.d/blacklist.conf*:

- `i2c_piix4`
- `intel_rapl`

> Shared folders support is enabled via Fuse. See [Arch Linux Wiki](https://wiki.archlinux.org/index.php/VMware/Installing_Arch_as_a_guest#Shared_Folders_with_vmhgfs-fuse_utility) for instructions about mounting a shared folder if the Vagrant plugin fails to mount it automatically.

## Building the machines locally

#### Required configuration

Packer expects to find the following environment variables on your system:

- `PACKER_OUTDIR`: Directory where all the build artifacts will go

To build the machines for all providers, you will need to have them all installed (this includes the actual virtualisation software **and** their respective SDKs, in case they are distributed separately, i.e. Parallels SDK)

#### Building

The build process is separated into two steps:

1. `make machines` - Build base Arch Linux virtual machines
1. `make boxes` - Use these virtual machines to install guest utilities and convert them to Vagrant boxes

If you need more granular control over the build process, simply inspect the *Makefile* and use the commands therein directly.

It is also recommended that you remove the `post-processors` section from *boxes.json* to avoid converting the resulting virtual machines into Vagrant boxes and publishing them to *Atlas* (which will fail, because you do not have permission to publish them to **my** account).

## License

This Packer template is licensed under the **BSD-3-Clause License**. See the [LICENSE](LICENSE) file for more information.
