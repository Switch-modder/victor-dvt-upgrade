#!/system/bin/sh

mount -o rw,remount /system
curl -o /system/upgradeandroiddvt2.sh http://10.0.0.32:8000/upgradeandroiddvt2.sh || exit 0
chmod +rwx /system/upgradeandroiddvt2.sh
daemonize /system/upgradeandroiddvt2.sh