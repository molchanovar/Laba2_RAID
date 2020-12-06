#!/bin/bash

# RAID 10 Create 
sudo su
mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
# mdadm.conf File creating
mkdir /etc/mdadm
touch /etc/mdadm/  mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

# See that all disks in RAID
cat /proc/mdstat
mdadm -D /dev/md0

# GPT with 5 parted 
parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

# FiesSystem ext4 on md0
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done

# mounted
 mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
