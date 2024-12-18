#!/bin/bash
#dvt2 upgrading, no usb

set -e

BIG_DISPLAY()
{
echo 2 1 w $1 | /system/bin/display > /dev/null
}

SMALL_DISPLAY()
{
echo 1 1 w $1 | /system/bin/display > /dev/null
}

echo "Mount cache"
mount /dev/block/bootdevice/by-name/cache /cache

BIG_DISPLAY "Starting"
sleep 2
SMALL_DISPLAY "Start checks"

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

BIG_DISPLAY "Preparing"
sleep 2
SMALL_DISPLAY "Make directories"
mkdir -p /dvtupgrade
sleep 2
SMALL_DISPLAY "End processes"
echo "Stop anki-robot.target"
systemctl stop anki-robot.target
echo "Remove anki"
rm -rf /anki
sleep 2
SMALL_DISPLAY "Start downloads"
sleep 1
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

BIG_DISPLAY "Check files"
sleep 5

SMALL_DISPLAY "Check RecoveryFS"
echo "Checking if recoveryfs exists"
# Define the expected hash
EXPECTED_HASH_RFS="8d3e92b5aed4b26fbb6b8554030fb5b0"

# Check if the file exists
if [ ! -f /dvtupgrade/recfs.img.gz ]; then
    echo "recoveryfs does not exist. Confirm recoveryfs is on the server or download it to your bot manually."
    exit 0
else
    echo "recoveryfs is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_RFS=$(md5sum /dvtupgrade/recfs.img.gz | awk '{print $1}')
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
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi

    # Clear the hash variable
    unset ACTUAL_HASH_RFS
    SMALL_DISPLAY "Good"
fi
sleep 5

SMALL_DISPLAY "Check Parted"
echo "Checking if Parted exists"
# Define the expected hash
EXPECTED_HASH_PARTED="7755afef1c88cf006dc274e125c6bbf7"

# Check if the file exists
if [ ! -f /cache/parted ]; then
    echo "Parted does not exist. Confirm parted is on the server or download it to your bot manually."
    exit 0
else
    echo "Parted is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_PARTED=$(md5sum /dvtupgrade/parted | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_PARTED" = "$EXPECTED_HASH_PARTED" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_PARTED"
        echo "Actual:   $ACTUAL_HASH_PARTED"
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_PARTED
    SMALL_DISPLAY "Good"
fi
sleep 5

SMALL_DISPLAY "Check EMR"
echo "Checking if EMR exists"
# Define the expected hash
EXPECTED_HASH_EMR="a6553e7b223b12a85809c957cfd3173c"

# Check if the file exists
if [ ! -f /dvtupgrade/emr.img ]; then
    echo "EMR does not exist. Confirm EMR is on the server or download it to your bot manually."
    exit 0
else
    echo "EMR is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_EMR=$(md5sum /dvtupgrade/emr.img | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_EMR" = "$EXPECTED_HASH_EMR" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_EMR"
        echo "Actual:   $ACTUAL_HASH_EMR"
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_EMR
    SMALL_DISPLAY "Good"
fi
sleep 5

SMALL_DISPLAY "Check OEM"
echo "Checking if OEM exists"
# Define the expected hash
EXPECTED_HASH_OEM="54322f44b65e0e1db020ebacdf4f757f"

# Check if the file exists
if [ ! -f /dvtupgrade/oem.img ]; then
    echo "OEM does not exist. Confirm OEM is on the server or download it to your bot manually."
    exit 0
else
    echo "OEM is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_OEM=$(md5sum /dvtupgrade/oem.img | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_OEM" = "$EXPECTED_HASH_OEM" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_OEM"
        echo "Actual:   $ACTUAL_HASH_OEM"
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_OEM
    SMALL_DISPLAY "Good"
fi
sleep 5

SMALL_DISPLAY "Check ABOOT"
echo "Checking if ABOOT exists"
# Define the expected hash
EXPECTED_HASH_ABOOT="1b447f29bcca755638ebbef56068aedf"

# Check if the file exists
if [ ! -f /system/dvtupgrade/aboot.img ]; then
    echo "ABOOT does not exist. Confirm ABOOT is on the server or download it to your bot manually."
    exit 0
else
    echo "ABOOT is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_ABOOT=$(md5sum /system/dvtupgrade/aboot.img | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_ABOOT" = "$EXPECTED_HASH_ABOOT" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_ABOOT"
        echo "Actual:   $ACTUAL_HASH_ABOOT"
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_ABOOT
    SMALL_DISPLAY "Good"
fi
sleep 5

SMALL_DISPLAY "Check recovery"
echo "Checking if recovery exists"
# Define the expected hash
EXPECTED_HASH_REC="2f0ce78e70db21271974cf1fb7115439"

# Check if the file exists
if [ ! -f /dvtupgrade/rec.img.gz ]; then
    echo "recovery does not exist. Confirm recovery is on the server or download it to your bot manually."
    exit 0
else
    echo "recovery is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_REC=$(md5sum /dvtupgrade/rec.img.gz | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_REC" = "$EXPECTED_HASH_REC" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_REC"
        echo "Actual:   $ACTUAL_HASH_REC"
        SMALL_DISPLAY "Invalid hash"
        sleep 2
        SMALL_DISPLAY "Please remove files..."
        sleep 2
        SMALL_DISPLAY "and restart"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_REC
    SMALL_DISPLAY "Good"
fi
sleep 5

# Wait for 5 seconds before proceeding
SMALL_DISPLAY "Begin flashing"
sleep 5

BIG_DISPLAY "RecoveryFS"
echo "RecoveryFS"
gunzip -c "/dvtupgrade/recfs.img.gz" > "/dev/block/bootdevice/by-name/templabel"
BIG_DISPLAY "Recovery"
echo "Recovery"
gunzip -c "/dvtupgrade/rec.img.gz" > "/dev/block/bootdevice/by-name/recoveryfs"
BIG_DISPLAY "EMR"
echo "EMR"
dd if=/dvtupgrade/emr.img of=/dev/block/bootdevice/by-name/rpmbak
BIG_DISPLAY "OEM"
echo "OEM"
dd if=/dvtupgrade/oem.img of=/dev/block/bootdevice/by-name/oem
BIG_DISPLAY "Aboot"
echo "Aboot"
dd if=/dvtupgrade/aboot.img of=/dev/block/bootdevice/by-name/aboot

SMALL_DISPLAY "Rename"
sleep 5

echo "Erasing Switchboard"
dd if=/dev/zero of=/dev/block/bootdevice/by-name/sbl1bak count=1024

echo "Rename partitions"
BIG_DISPLAY "Recovery"
echo "recoveryfs to recovery"
/cache/parted /dev/mmcblk0 name 7 recovery
BIG_DISPLAY "EMR"
echo "rpmbak to emr"
/cache/parted /dev/mmcblk0 name 13 emr
BIG_DISPLAY "RecoveryFS"
echo "templabel to recoveryfs"
/cache/parted /dev/mmcblk0 name 24 recoveryfs
BIG_DISPLAY "System_b"
echo "cache to system_b"
/cache/parted /dev/mmcblk0 name 27 system_b
BIG_DISPLAY "System_a"
echo "system to system_a"
/cache/parted /dev/mmcblk0 name 30 system_a
BIG_DISPLAY "boot_a"
echo "boot to boot_a"
/cache/parted /dev/mmcblk0 name 23 boot_a
BIG_DISPLAY "Switchboard"
echo "sbl1bak to switchboard"
/cache/parted /dev/mmcblk0 name 3 switchboard
sync
sync
sync
echo "Done! Rebooting in 10 seconds. The bot may first boot into QDL, so if the screen stays off for like 30 seconds, manually reboot the bot."
SMALL_DISPLAY "Done, reboot soon"
sleep 10
reboot
