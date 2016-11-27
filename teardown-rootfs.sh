#!/bin/bash

ps -ax | grep /usr/bin/qemu-arm-static | awk '{print $1;}' | xargs sudo kill -9
sudo umount rootfs/sys
sudo umount rootfs/dev/pts
sudo umount rootfs/dev
sudo umount rootfs/proc

