# About

# Requirements

Using Debian Stretch with the following packages:
* build-essential
* git
* qemu-system-arm
* qemu-user-static
* binfmt-support
* debootstrap
* gnu-arm-linux-gnueabi
* gnu-arm-linux-gnueabihf
* libncurses5-dev
* bc
* kpartx

# Process

## Setting up base Raspbian system
```
./create-rootfs.sh
```

## Building a Raspberry Pi kernel image (kernel.img)
```
./build-kernel.sh
```

## Building a Raspberry Pi kernel image (kernel7.img)
```
./build-kernel7.sh
```

## Create bootfs and install kernels
```
./install-kernels.sh
```

## Create QEMU image
```
./create-image.sh
```

## Create SD card
```
./create-sdcard.sh <dev>
```
where *dev* is the SD card device (for example, use *sdc* instead of */dev/sdc*)

