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


