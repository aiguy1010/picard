#!/bin/bash
DEV=$1
PART="$1"2

# Get the total size of the SD card
DISK_SIZE=$(fdisk -l $DEV | grep 'Disk /' | awk '{print $7}')

# Get the start and size of the partition
PART_START=$(fdisk -l $DEV | grep $PART | awk '{print $2}')
PART_SIZE=$(fdisk -l $DEV | grep $PART | awk '{print $4}')

# Calculate the new partion size that will make full use of the disk
NEW_PART_SIZE=$(expr $DISK_SIZE - $PART_START)

# Generate a human readable partition table file
sfdisk -d $DEV > ./partition.layout

# Replace occurences of the old partition size with the new partition size
sed -i "s/$PART_SIZE/$NEW_PART_SIZE/g" ./partition.layout

# Write the new partition table
sfdisk $DEV < ./partition.layout
rm ./partition.layout

# Expand the filesystem to fill the newly sized partiotion
e2fsck -f $PART
resize2fs $PART
