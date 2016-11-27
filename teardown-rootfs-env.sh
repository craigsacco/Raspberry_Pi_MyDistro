#!/bin/bash

# kill all applications that were run within the rootfs context
ps -ax | grep /usr/bin/qemu-arm-static | awk '{print $1;}' | xargs sudo kill -9

# unbind proc/dev/sys folders in rootfs
sudo umount rootfs/sys
sudo umount rootfs/dev/pts
sudo umount rootfs/dev
sudo umount rootfs/proc
