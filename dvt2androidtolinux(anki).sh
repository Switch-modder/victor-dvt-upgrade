#!/system/bin/sh

set -xe

EMMC=/dev/block/mmcblk0
GPT_PRINT=gpt_print.txt

DD="./busybox dd"
GUC="./busybox gzip -dc"

get_part_no()
{
  grep " $1\$" $GPT_PRINT | ./busybox awk '{print $1}'
}

flash()
{
  $GUC $1 | $DD of=${EMMC}p$2
}

display()
{
  echo 1 1 w $1 | /system/bin/display
}

display "GPT print"
./parted $EMMC print > $GPT_PRINT

SYS_NAME=system
DATA_NAME=userdata
ABOOT_PART=`get_part_no aboot`
DATA_PART=`get_part_no $DATA_NAME`
BOOT_PART=`get_part_no boot`
SYS_PART=`get_part_no $SYS_NAME`
REC_PART=`get_part_no recovery`
RECFS_PART=`get_part_no facrec`
CACHE_PART=`get_part_no cache`
PERSIST_PART=`get_part_no persist`
FW_PART=`get_part_no modem`
SBL_PART=`get_part_no sbl1`
RPM_PART=`get_part_no rpm`
TZ_PART=`get_part_no tz`

stop keystore
stop gatekeeperd

display "WiFi down"
killall wpa_supplicant
sleep 5

display "Umount"
umount /data

display "Flash 1"
flash apq8009-robot-sysfs.img.gz $DATA_PART
display "Flash 2"
flash NON-HLOS.bin.gz $FW_PART
display "Flash 3"
flash sbl1.mbn.gz $SBL_PART
display "Flash 4"
flash rpm.mbn.gz $RPM_PART
display "Flash 5"
flash tz.mbn.gz $TZ_PART
display "Flash 6"
flash apq8009-robot-userdata.img.gz $RECFS_PART
display "Flash 7"
flash apq8009-robot-boot.img.gz $BOOT_PART
display "Flash 8"
flash apq8009-robot-persist.img.gz $PERSIST_PART
display "Flash 9"
flash emmc_appsboot.mbn.gz $ABOOT_PART

display "Parted"
./parted $EMMC name $REC_PART recoveryfs
./parted $EMMC name $SYS_PART templabel
./parted $EMMC name $DATA_PART $SYS_NAME
./parted $EMMC name $RECFS_PART $DATA_NAME

display "Factory patch"
mkdir le_root
mount ${EMMC}p${DATA_PART} le_root
mkdir le_root/factory
echo "PARTLABEL=oem /factory auto defaults,ro 0 2" >> le_root/etc/fstab

display "Sync & reboot"
sync
sync
sync
sleep 2
reboot