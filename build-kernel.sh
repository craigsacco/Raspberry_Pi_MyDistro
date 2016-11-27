#!/bin/bash

# go to the linux sources - get the last commit ID and date in YYMMDD format
pushd modules/linux
COMMITID=`git rev-parse HEAD | cut -c1-7`
DATEYMD=`date +%y%m%d`

# clean sources and configure/build the kernel image, modules and DTBs
make clean
make mrproper
make ARCH=arm bcmrpi_defconfig
./scripts/config --set-str CONFIG_LOCALVERSION -rpi-$COMMITID-$DATEYMD
./scripts/config --set-str CONFIG_CROSS_COMPILE /usr/bin/arm-linux-gnueabihf-
make ARCH=arm zImage modules dtbs

# create target folders using kernel version string (remove old version if necessary)
KRNLVER=`strings arch/arm/boot/Image | grep "Linux version" | cut -d " " -f 3`
rm -rf ../../kernels/$KRNLVER
mkdir -p ../../kernels/$KRNLVER/bootfs
mkdir -p ../../kernels/$KRNLVER/bootfs/overlays
mkdir -p ../../kernels/$KRNLVER/rootfs

# archive the kernel image, config, DTBs (and overlays) and kernel modules
cp -avt ../../kernels/$KRNLVER arch/arm/boot/zImage .config
cp -avt ../../kernels/$KRNLVER/bootfs arch/arm/boot/dts/*.dtb
cp -avt ../../kernels/$KRNLVER/bootfs/overlays arch/arm/boot/dts/overlays/*.dtbo
make ARCH=arm INSTALL_MOD_PATH=../../kernels/$KRNLVER/rootfs modules_install

# create kernel image that the Raspberry Pi can understand
./scripts/mkknlimg arch/arm/boot/zImage ../../kernels/$KRNLVER/bootfs/kernel.img

# done
popd
