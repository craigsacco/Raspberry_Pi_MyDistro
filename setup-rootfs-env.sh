#!/bin/bash

# bind proc/dev/sys folders in rootfs to that on the host
sudo mount -o bind /proc rootfs/proc
sudo mount -o bind /dev rootfs/dev
sudo mount -o bind /dev/pts rootfs/dev/pts
sudo mount -o bind /sys rootfs/sys
