#!/bin/bash

qemu-system-arm -M raspi2 -kernel bootfs/kernel7.img -sd disk.img -dtb bootfs/bcm2709-rpi-2-b.dtb \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2" \
    -serial stdio
