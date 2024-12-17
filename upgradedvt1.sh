#!/system/bin/sh

#Map the display stuff

BIG_DISPLAY()
{
echo 2 1 w $1 | /system/bin/display > /dev/null
}

SMALL_DISPLAY()
{
echo 1 1 w $1 | /system/bin/display > /dev/null
}

#Kill processes
BIG_DISPLAY "Killing processes"
stop keystore
stop gatekeeperd
killall cozmoengined
killall victor_animator
killall -s KILL robot_supervisor
sleep 2
BIG_DISPLAY "Starting"
sleep 2
mount -o rw,remount /system #Mount system as writable
umount /cache #Don't need that ig
SMALL_DISPLAY "Busybox" #Start grabbing all the files
echo "Get busybox"
curl -o /system/dvtupgrade/busybox http://wire.my.to:81/busybox
chmod +rwx /system/dvtupgrade/busybox
SMALL_DISPLAY "Parted"
echo "Get parted"
curl -o /system/dvtupgrade/parted http://wire.my.to:81/parted
chmod +rwx /system/dvtupgrade/parted
echo "Curl/Flash..."
SMALL_DISPLAY "System_a" #The main VicOS
echo "System_a"
curl -o /system/dvtupgrade/sysfs.img.gz http://wire.my.to:81/dvt2cfwsystem.img.gz
SMALL_DISPLAY "Boot_a" #The thing to boot VicOS
echo "Boot_a"
curl -o /system/dvtupgrade/boot.img.gz http://wire.my.to:81/dvt2cfwboot.img.gz
SMALL_DISPLAY "EMR" #Calibration data
echo "EMR"
curl -o /system/dvtupgrade/emr.img http://wire.my.to:81/006emr.img
SMALL_DISPLAY "OEM" #Serial number and stuff
echo "OEM"
curl -o /system/dvtupgrade/oem.img http://wire.my.to:81/006oem.img
SMALL_DISPLAY "Aboot" #No firmware signing boi
echo "Aboot"
curl -o /system/dvtupgrade/aboot.img http://wire.my.to:81/ankidev-nosigning.mbn
SMALL_DISPLAY "Modem" #Internet and bluetooth stuff
echo "Modem"
curl -o /system/dvtupgrade/modem.img http://wire.my.to:81/dvt2modem.img
SMALL_DISPLAY "Modem" #Internet and bluetooth stuff
echo "recoveryfs"
curl -o /system/dvtupgrade/recoveryfs.img.gz http://wire.my.to:81/dumps/devrecoveryfs.img.gz
SMALL_DISPLAY "Modem" #Internet and bluetooth stuff
echo "recovery"
curl -o /system/dvtupgrade/recovery.img.gz http://wire.my.to:81/dumps/devrecovery.img.gz

#Confirm everything is good with a file and hash check
BIG_DISPLAY "Check files"
sleep 10

SMALL_DISPLAY "Check Parted"
echo "Checking if Parted exists"
# Define the expected hash
EXPECTED_HASH_PARTED="7755afef1c88cf006dc274e125c6bbf7"

# Check if the file exists
if [ ! -f /system/dvtupgrade/parted ]; then
    echo "Parted does not exist. Confirm parted is on the server or download it to your bot manually."
    exit 0
else
    echo "Parted is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_PARTED=$(md5sum /system/dvtupgrade/parted | awk '{print $1}')
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
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_PARTED
fi
sleep 5

SMALL_DISPLAY "Check Busybox"
echo "Checking if Busybox exists"
# Define the expected hash
EXPECTED_HASH_BUSYBOX="af177e4a17185a5235f9c1a0ea15e1f8"

# Check if the file exists
if [ ! -f /system/dvtupgrade/busybox ]; then
    echo "Busybox does not exist. Confirm Busybox is on the server or download it to your bot manually."
    exit 0
else
    echo "Busybox is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_BUSYBOX=$(md5sum /system/dvtupgrade/busybox | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_BUSYBOX" = "$EXPECTED_HASH_BUSYBOX" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_BUSYBOX"
        echo "Actual:   $ACTUAL_HASH_BUSYBOX"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_BUSYBOX
fi
sleep 5

SMALL_DISPLAY "Check EMR"
echo "Checking if EMR exists"
# Define the expected hash
EXPECTED_HASH_EMR="a6553e7b223b12a85809c957cfd3173c"

# Check if the file exists
if [ ! -f /system/dvtupgrade/emr.img ]; then
    echo "EMR does not exist. Confirm EMR is on the server or download it to your bot manually."
    exit 0
else
    echo "EMR is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_EMR=$(md5sum /system/dvtupgrade/emr.img | awk '{print $1}')
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
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_EMR
fi
sleep 5

SMALL_DISPLAY "Check OEM"
echo "Checking if OEM exists"
# Define the expected hash
EXPECTED_HASH_OEM="54322f44b65e0e1db020ebacdf4f757f"

# Check if the file exists
if [ ! -f /system/dvtupgrade/oem.img ]; then
    echo "OEM does not exist. Confirm OEM is on the server or download it to your bot manually."
    exit 0
else
    echo "OEM is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_OEM=$(md5sum /system/dvtupgrade/oem.img | awk '{print $1}')
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
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_OEM
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
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_ABOOT
fi
sleep 5

SMALL_DISPLAY "Check Modem"
echo "Checking if Modem exists"
# Define the expected hash
EXPECTED_HASH_MODEM="bf26f360023283b06bb5f50d650b9e48"

# Check if the file exists
if [ ! -f /system/dvtupgrade/modem.img ]; then
    echo "Modem does not exist. Confirm Modem is on the server or download it to your bot manually."
    exit 0
else
    echo "Modem is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_MODEM=$(md5sum /system/dvtupgrade/modem.img | awk '{print $1}')
    else
        echo "Error: md5sum command not found. Please install it to proceed."
        exit 1
    fi

    # Compare the hash values
    if [ "$ACTUAL_HASH_MODEM" = "$EXPECTED_HASH_MODEM" ]; then
        echo "File hash matches the expected value."
    else
        echo "Error: File hash does NOT match the expected value!"
        echo "Expected: $EXPECTED_HASH_MODEM"
        echo "Actual:   $ACTUAL_HASH_MODEM"
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_MODEM
fi
sleep 5

SMALL_DISPLAY "Check recoveryfs"
echo "Checking if recoveryfs exists"
# Define the expected hash
EXPECTED_HASH_RFS="8d3e92b5aed4b26fbb6b8554030fb5b0 "

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
    #Clear hash
    unset ACTUAL_HASH_RFS
fi
sleep 5

SMALL_DISPLAY "Check recovery"
echo "Checking if recovery exists"
# Define the expected hash
EXPECTED_HASH_REC="2f0ce78e70db21271974cf1fb7115439"

# Check if the file exists
if [ ! -f /system/dvtupgrade/recovery.img.gz ]; then
    echo "recovery does not exist. Confirm recovery is on the server or download it to your bot manually."
    exit 0
else
    echo "recovery is found. Proceeding to check the file hash."

    # Compute the hash of the file
    if command -v md5sum >/dev/null 2>&1; then
        ACTUAL_HASH_REC=$(md5sum /system/dvtupgrade/recovery.img.gz | awk '{print $1}')
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
        exit 1
    fi
    #Clear hash
    unset ACTUAL_HASH_REC
fi
sleep 5

echo "Erasing Switchboard"
/system/dvtupgrade/busybox dd if=/dev/zero of=/dev/block/bootdevice/by-name/sbl1bak count=1024
echo "Kill processes"
lsof | grep /data | /system/busybox awk '{print $2}' | xargs kill
sleep 5
echo "Umount data"
echo 1 1 w Still going | /system/bin/display > /dev/null
umount /data
BIG_DISPLAY "EMR..."
/system/dvtupgrade/busybox dd if=/system/dvtupgrade/emr.img of=/dev/block/bootdevice/by-name/cache
BIG_DISPLAY "OEM..."
/system/dvtupgrade/busybox dd if=/system/dvtupgrade/oem.img of=/dev/block/bootdevice/by-name/recovery
BIG_DISPLAY "Aboot..."
/system/dvtupgrade/busybox dd if=/system/dvtupgrade/aboot.img of=/dev/block/bootdevice/by-name/aboot
BIG_DISPLAY "Modem..."
/system/dvtupgrade/busybox dd if=/system/dvtupgrade/modem.img of=/dev/block/bootdevice/by-name/modem
BIG_DISPLAY "recovery"
/system/dvtupgrade/busybox gzip -dc /system/dvtupgrade/recovery.img.gz | dd of=/dev/block/bootdevice/by-name/persist
BIG_DISPLAY "recoveryfs"
/system/dvtupgrade/busybox gzip -dc /system/dvtupgrade/recoveryfs.img.gz | dd of=/dev/block/bootdevice/by-name/userdata
echo "Rename partitions"
echo "system to system_a"
SMALL_DISPLAY "system to system_a"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 21 system_a
SMALL_DISPLAY "userdata to recoveryfs"
echo "userdata to recoveryfs"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 28 recoveryfs
echo "boot to boot_a"
SMALL_DISPLAY "boot to boot_a"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 20 boot_a
echo "persist to recoveryfs"
SMALL_DISPLAY "persist to recovery"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 22 recovery
echo "cache to emr"
SMALL_DISPLAY "cache to emr"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 23 emr
echo "sbl1bak to switchboard"
SMALL_DISPLAY "sbl1bak to switchboard"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 3 switchboard
echo "recovery to oem"
SMALL_DISPLAY "recovery to oem"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 24 oem
echo "facrec to userdata"
SMALL_DISPLAY "facrec to userdata"
/system/dvtupgrade/parted /dev/block/mmcblk0 name 27 userdata
sync
sync
sync
echo "Done! Rebooting in 10 seconds. The bot may first boot into QDL, so if the screen stays off for like 30 seconds, manually reboot the bot."
BIG_DISPLAY "Rebooting"
sleep 10
reboot
