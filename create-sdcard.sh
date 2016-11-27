#!/bin/bash

SDCARD=$1

sudo umount /dev/${SDCARD}*

sudo SDCARD=${SDCARD} sh -c 'echo "o
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
" | fdisk /dev/$SDCARD'
sudo kpartx -v -f -a /dev/${SDCARD}

sudo mkfs.vfat /dev/mapper/${SDCARD}1
sudo mkfs.ext4 /dev/mapper/${SDCARD}2
sudo mkfs.vfat /dev/mapper/${SDCARD}3

sudo mount -t vfat /dev/mapper/${SDCARD}1 /mnt
sudo rm -rf /mnt/*
sudo cp -av bootfs/* /mnt
sudo umount /mnt
sudo mount -t ext4 /dev/mapper/${SDCARD}2 /mnt
sudo rm -rf /mnt/*
sudo mkdir -p /mnt/lost+found
sudo cp -av rootfs/* /mnt
sudo rm /mnt/usr/bin/qemu-arm-static
sudo umount /mnt
