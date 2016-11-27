#!/bin/bash

sudo rm -rf bootfs
sudo mkdir bootfs
sudo cp -av external/firmware/boot/* bootfs
sudo rm -rf bootfs/*.dts
sudo rm -rf bootfs/overlays/*.dts
sudo sh -c 'sudo echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait
" > bootfs/cmdline.txt'
sudo sh -c 'sudo echo "gpu_mem=16
boot_delay=1
" > bootfs/config.txt'
sudo external/linux/scripts/mkknlimg external/linux/arch/arm/boot/zImage bootfs/kernel.img
sudo rm bootfs/kernel7.img
sudo cp -av external/linux/arch/arm/boot/dts/*.dtb bootfs
sudo cp -av external/linux/arch/arm/boot/dts/overlays/*.dtb* bootfs/overlays/
sudo cp -av external/linux/arch/arm/boot/dts/overlays/README bootfs/overlays
sudo chown -R root.root bootfs


