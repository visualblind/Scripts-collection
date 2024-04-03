#!/bin/bash

LOGFILE=/data/log/speed/resize.log
LOCKFILE=/tmp/enlarge.lock
#export PATH=/usr/sbin:/usr/bin:/sbin:/bin

NEEDREBOOT=0

dotlockfile -r 0 $LOCKFILE || exit 1

echo 1 > /sys/class/block/sda/device/rescan
sleep 5
GROWPART_OUT=`growpart /dev/sda 2`
if [ $? -eq 0 ]; then
    echo `date` >> $LOGFILE
    echo "trying to resize fs" >> $LOGFILE
    echo $GROWPART_OUT >> $LOGFILE
    resize2fs /dev/sda2 >> $LOGFILE 2>&1
    echo `date` >> $LOGFILE
    echo "resize done" >> $LOGFILE
    #TODO: need reboot
    NEEDREBOOT=1
fi

echo 1 2>/dev/null >/sys/class/block/sdb/device/rescan
sleep 5
GROWPART_OUT=`growpart /dev/sdb 1`
if [ $? -eq 0 ]; then
    echo `date` >> $LOGFILE
    echo "trying to resize fs" >> $LOGFILE
    echo $GROWPART_OUT >> $LOGFILE
    resize2fs /dev/sdb1 >> $LOGFILE 2>&1
    echo `date` >> $LOGFILE
    echo "resize done" >> $LOGFILE
    #TODO: need reboot
    NEEDREBOOT=1
fi

dotlockfile -u $LOCKFILE

if [ $NEEDREBOOT -eq "1" ]; then
    /sbin/reboot
fi
