#!/usr/bin/env bash
rsync --recursive --delete --max-delete=1000 --update --times --progress --human-readable --log-file="$HOME/rsync-backup-log-$(date +"%Y-%m-%d".log)" /mnt/pool0/p0ds0smb/temp/ /mnt/pool1/p1ds0smb/pool0temp/temp/
