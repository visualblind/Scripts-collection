#!/usr/bin/env bash
cmdwatch -d -n 1 tail -n 11 /mnt/pool0/iocage/jails/rclone/root/root/.config/rclone/log/"$1"
