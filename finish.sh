#!/bin/bash
USAGE="sudo ./finish.sh <dev> <hostname>"

# Use the first argument to this script to set our hostname
if [ -z $1 ] || [ -z $2 ] || [ ! -z $3 ]; then
   echo "USAGE:"
   echo $USAGE
   exit
fi

# Inputs
DEV=$1
PART="$DEV"2

NEW_HOSTNAME=$1

# Unmout everything
umount "$DEV"*

# Expand the root partion on the SD card
bash ./utils/expand.sh $DEV

# Mount the card's root partition
mkdir mnt
mount $PART mnt

# Get the old hostname
OLD_HOSTNAME=$(cat mnt/etc/hostname)

# Change to the new hostname
echo $NEW_HOSTNAME > mnt/etc/hostname
sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" mnt/etc/hosts

# Cleanup and exit
umount mnt
rm -r mnt
exit 0
