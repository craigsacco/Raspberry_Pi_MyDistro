#!/bin/bash

pushd external/linux
make clean
make mrproper
make ARCH=arm bcm2709_defconfig
./scripts/config --set-str CONFIG_LOCALVERSION -rpi2-$COMMITID-$DATEYMD
./scripts/config --set-str CONFIG_CROSS_COMPILE /usr/bin/arm-linux-gnueabihf-
make ARCH=arm zImage modules dtbs
KRNLVER=`strings arch/arm/boot/Image | grep "Linux version" | cut -d " " -f 3`
rm -rf ../../kernels/$KRNLVER
mkdir -p ../../kernels/$KRNLVER/bootfs
mkdir -p ../../kernels/$KRNLVER/bootfs/overlays
mkdir -p ../../kernels/$KRNLVER/rootfs
cp -avt ../../kernels/$KRNLVER arch/arm/boot/Image arch/arm/boot/zImage .config
./scripts/mkknlimg arch/arm/boot/zImage ../../kernels/$KRNLVER/bootfs/kernel7.img
cp -avt ../../kernels/$KRNLVER/bootfs arch/arm/boot/dts/*.dtb
cp -avt ../../kernels/$KRNLVER/bootfs/overlays arch/arm/boot/dts/overlays/*.dtbo
make ARCH=arm INSTALL_MOD_PATH=../../kernels/$KRNLVER/rootfs modules_install
popd
