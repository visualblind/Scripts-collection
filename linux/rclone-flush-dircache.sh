#!/usr/bin/env bash
kill -SIGHUP $(pidof rclone)

# Examples
#kill -SIGHUP $(ps aux |grep 'rclone mount http-home' |grep -v 'grep' |awk '{ print $2 }')
#kill -SIGHUP $(ps aux |grep 'rclone mount gcrypt-usmba' | grep -v 'grep' |awk '{ print $2 }')