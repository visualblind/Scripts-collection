#!/usr/bin/env bash
#iocage exec rclone /root/scripts/rclone-sync-video.sh -b 6
iocage exec rclone "screen -ls; /root/scripts/rclone-sync-video.sh -b 6; screen -ls"
