#!/bin/bash
#dvt2 upgrading, no usb

set -e

echo "Mount cache"
mount /dev/block/bootdevice/by-name/cache /cache

# Define the URL where 'parted' can be downloaded
PARTED_DOWNLOAD_LINK="http://wire.my.to:81/parted"
PARTED_FILE_PATH="/cache/parted"

# Check if the file exists
if [ ! -f "$PARTED_FILE_PATH" ]; then
    echo "$PARTED_FILE_PATH does not exist. Attempting to download it..."

    # Use curl to download the file
    if command -v curl >/dev/null 2>&1; then
        curl -o "$PARTED_FILE_PATH" "$PARTED_DOWNLOAD_LINK"
	chmod +x "$PARTED_FILE_PATH"
    else
        echo "Error: curl is not installed. Please install it to proceed."
        exit 1
    fi

    # Verify if the file was downloaded successfully
    if [ -f "$PARTED_FILE_PATH" ]; then
        echo "Download successful. Proceeding with the next steps."
    else
        echo "Error: Failed to download parted. Please check the download link or your internet connection."
        exit 1
    fi
else
    echo "$PARTED_FILE_PATH is found. Proceeding with the next steps."
fi

# Continue with the script
echo "All checks passed. Proceeding with further operations."


echo "Checking if system_a exists"
if [ -f /dev/block/bootdevice/by-name/system_a ]; then
	echo "This partition table is already upgraded fool"
	exit 0
fi

echo "Checking if emr exists"
if [ -f /dev/block/bootdevice/by-name/emr ]; then
	echo "This partition table is already upgraded fool"
	exit 0
fi


BIG_DISPLAY()
{
echo 2 1 w $1 | /system/bin/display > /dev/null
}

SMALL_DISPLAY()
{
echo 1 1 w $1 | /system/bin/display > /dev/null
}

BIG_DISPLAY "Starting"
sleep 2
mkdir -p /dvtupgrade
echo "Stop anki-robot.target"
systemctl stop anki-robot.target
echo "Remove anki"
rm -rf /anki
umount -f /factory
echo "Curl/Flash..."
BIG_DISPLAY "Recoveryfs"
echo "Recoveryfs"
curl -o /dvtupgrade/recfs.img.gz http://wire.my.to:81/dumps/devrecoveryfs.img.gz
BIG_DISPLAY "Recovery"
echo "Boot"
curl -o /dvtupgrade/rec.img.gz http://wire.my.to:81/dumps/devrecovery.img.gz
BIG_DISPLAY "EMR"
echo "EMR"
curl -L -o /dvtupgrade/emr.img http://wire.my.to:81/006emr.img
BIG_DISPLAY "OEM"
echo "OEM"
curl -L -o /dvtupgrade/oem.img http://wire.my.to:81/006oem.img
BIG_DISPLAY "Aboot"
echo "Aboot"
curl -o /dvtupgrade/aboot.img http://wire.my.to:81/ankidev-nosigning.

echo "Checking if recoveryfs exists"

# Define the expected hash
EXPECTED_HASH_RFS="8d3e92b5aed4b26fbb6b8554030fb5b0"

# Check if the file exists
if [ ! -f /system/dvtupgrade/recoveryfs.img.gz ]; then
    echo "recoveryfs does not exist. Confirm recoveryfs is on the server or download it to your bot manually."
    exit 0
else
    echo "recoveryfs is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_RFS=$(md5sum /system/dvtupgrade/recoveryfs.img.gz | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_RFS" = "$EXPECTED_HASH_RFS" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_RFS"
        echo "Actual:   $ACTUAL_HASH_RFS"
        exit 1
    fi

    # Clear the hash variable
    unset ACTUAL_HASH_RFS
fi

# Wait for 5 seconds before proceeding
sleep 5

echo "System"
gunzip -c "/dvtupgrade/recfs.img.gz" > "/dev/block/bootdevice/by-name/templabel"
echo "Boot"
gunzip -c "/dvtupgrade/rec.img.gz" > "/dev/block/bootdevice/by-name/recoveryfs"
echo "EMR"
dd if=/dvtupgrade/emr.img of=/dev/block/bootdevice/by-name/rpmbak
echo "OEM"
dd if=/dvtupgrade/oem.img of=/dev/block/bootdevice/by-name/oem
echo "Aboot"
dd if=/dvtupgrade/aboot.img of=/dev/block/bootdevice/by-name/aboot

echo "Erasing Switchboard"
dd if=/dev/zero of=/dev/block/bootdevice/by-name/sbl1bak count=1024
echo "Rename partitions"
echo "recoveryfs to recovery"
/cache/parted /dev/mmcblk0 name 7 recovery
echo "rpmbak to emr"
/cache/parted /dev/mmcblk0 name 13 emr
echo "templabel to recoveryfs"
/cache/parted /dev/mmcblk0 name 24 recoveryfs
echo "cache to system_b"
/cache/parted /dev/mmcblk0 name 27 system_b
echo "system to system_a"
/cache/parted /dev/mmcblk0 name 30 system_a
echo "boot to boot_a"
/cache/parted /dev/mmcblk0 name 23 boot_a
echo "sbl1bak to switchboard"
/cache/parted /dev/mmcblk0 name 3 switchboard
sync
echo "Done! Rebooting in 10 seconds. The bot may first boot into QDL, so if the screen stays off for like 30 seconds, manually reboot the bot."
echo 1 1 w Done | /system/bin/display > /dev/null
sleep 10
reboot
