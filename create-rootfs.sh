#!/bin/bash

# remove old rootfs
sudo rm -rf rootfs

# perform first stage bootstrapping
sudo debootstrap --foreign --no-check-gpg --include=ca-certificates --arch=armhf jessie rootfs http://mirror.aarnet.edu.au/pub/raspbian/raspbian

# perform second stage bootstrapping - add static ARM emulator to /usr/bin inside of rootfs
sudo cp $(which qemu-arm-static) rootfs/usr/bin
sudo chroot rootfs /debootstrap/debootstrap --second-stage --verbose

# create data folder and update /etc folder on rootfs
sudo mkdir -p rootfs/data
sudo ln -sf /proc/mounts rootfs/etc/mtab
pushd support/overlay/rootfs
find . -type f -exec sh -c 'DEST=../../../rootfs/`dirname {}` && mkdir -p $DEST` && cp {} $DEST && chown -R root:root ../../../rootfs/{}' \;
popd
sudo ln -sf /usr/share/zoneinfo/Australia/Melbourne rootfs/etc/localtime

# add Raspbian APT GPG key
sudo wget -O rootfs/raspberrypi.gpg.key http://archive.raspberrypi.org/debian/raspberrypi.gpg.key
sudo chroot rootfs /usr/bin/apt-key add /raspberrypi.gpg.key
sudo rm rootfs/raspberrypi.gpg.key

# setup rootfs environment
. ./setup-rootfs-env.sh

# update packages in rootfs
sudo chroot rootfs /usr/bin/apt-get update
sudo chroot rootfs /usr/bin/apt-get dist-upgrade

# install locales package
sudo chroot rootfs /usr/bin/apt-get install locales
sudo sed -i "/$en_AU.UTF-8 UTF-8/ s/# *//" rootfs/etc/locale.gen
sudo chroot rootfs /usr/sbin/locale-gen

# install some other useful packages
sudo chroot rootfs /usr/bin/apt-get install sudo openssh-server ntpdate wicd-daemon \
    wicd-cli dosfstools e2fsprogs python python-dev python-setuptools python-rpi.gpio \
    samba smbclient cifs-utils perl i2c-tools python-smbus

# add a tty to the serial interface
sudo chroot rootfs /bin/systemctl enable serial-getty@ttyAMA0.service

# teardown rootfs environment
. ./teardown-rootfs-env.sh
