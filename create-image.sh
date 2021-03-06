#!/bin/bash

# create new disk image and a new network block device node to it
sudo rm disk.img
qemu-img create -f qcow2 disk.img 16G
sudo modprobe nbd
sudo qemu-nbd -c /dev/nbd0 disk.img

# create the partition layout and make it available to the OS
sudo sh -c 'echo "o
n
p
1

+64M
t
c
n
p
2

+4G
n
p
3


t
3
c
w
" | fdisk /dev/nbd0'
sudo kpartx -v -f -a /dev/nbd0

# create new filesystems on the disk image
sudo mkfs.vfat /dev/mapper/nbd0p1
sudo mkfs.ext4 /dev/mapper/nbd0p2
sudo mkfs.vfat /dev/mapper/nbd0p3

# copy files to the disk image
sudo mount -t vfat /dev/mapper/nbd0p1 /mnt
sudo rm -rf /mnt/*
sudo cp -av bootfs/* /mnt
sudo umount /mnt
sudo mount -t ext4 /dev/mapper/nbd0p2 /mnt
sudo rm -rf /mnt/*
sudo mkdir -p /mnt/lost+found
sudo cp -av rootfs/* /mnt
sudo rm /mnt/usr/bin/qemu-arm-static
sudo umount /mnt

# remove NBD to disk image
sudo qemu-nbd -d /dev/nbd0
