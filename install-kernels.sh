#!/bin/bash

# remove old bootfs and kernel firmware/modules from rootfs
sudo rm -rf bootfs
sudo rm -rf rootfs/lib/firmware
sudo rm -rf rootfs/lib/modules

# create bootfs and add bootloaders, cmdline.txt and config.txt
sudo mkdir bootfs
sudo cp -avt bootfs modules/firmware/boot/fixup*.dat modules/firmware/boot/bootcode.bin modules/firmware/boot/start*.elf modules/firmware/boot/LICENCE.broadcom
sudo sh -c 'sudo echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2
" > bootfs/cmdline.txt'
sudo sh -c 'sudo echo "gpu_mem=16
boot_delay=1
" > bootfs/config.txt'

# select Raspberry Pi kernel and update bootfs/rootfs folders
echo "Choose RPi kernel:"
select KERNEL6 in kernels/*-rpi-* QUIT;
do
    case $KERNEL6 in
        "QUIT")
            exit 1
            ;;
        *)
            sudo cp -av $KERNEL6/bootfs/* bootfs
            sudo cp -av $KERNEL6/rootfs/* rootfs
            break
            ;;
    esac
done

# select Raspberry Pi 2 kernel and update bootfs/rootfs folders
echo "Choose RPi2 kernel:"
select KERNEL7 in kernels/*-rpi2-* QUIT;
do
    case $KERNEL7 in
        "QUIT")
            exit 1
            ;;
        *)
            sudo cp -av $KERNEL7/bootfs/* bootfs
            sudo cp -av $KERNEL7/rootfs/* rootfs
            break
            ;;
    esac
done

# change owner of files added to bootfs/rootfs
sudo chown root:root rootfs/lib
sudo chown -R root:root bootfs rootfs/lib/firmware rootfs/lib/modules
