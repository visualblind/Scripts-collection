#!/usr/bin/env bash

RCLONEPATH=$(which rclone)

# begin entry for syslog
echo "$(date +"%x-%T") > Starting rclone copy digispark > local" | logger -t "$(basename $0)"

# begin rclone sync operation
$RCLONEPATH copy -v --bwlimit 50M --progress --stats 1s --config "/root/.config/rclone/rclone.conf" \
	--transfers 5 --checkers 10 --update --size-only --tpslimit 10 --drive-stop-on-upload-limit \
	--drive-pacer-min-sleep 10ms --drive-pacer-burst 200 --log-file \
	"$HOME/.config/rclone/log/digispark-sync-local.log" \
        gcrypt-digispark:p0ds0smb/video-shows /mnt/p0ds0smb/media/video-shows ; \
	echo "$(date +"%x-%T") > Finished rclone copy digispark > local (errorcode: $?)" | logger -t "$(basename $0)" || exit $?
