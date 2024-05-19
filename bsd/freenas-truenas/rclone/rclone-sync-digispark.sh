#!/usr/bin/env bash

RCLONEPATH=$(which rclone)
RCLONE_CRYPT_SHOW_MAPPING=false

# begin entry for syslog
echo "$(date +"%x-%T") > Starting rclone copy local > digispark" | logger -t "$(basename $0)"

# begin rclone sync operation
$RCLONEPATH sync -v --bwlimit 10M --progress --stats 3s --config "/root/.config/rclone/rclone.conf" \
	--transfers 4 --checkers 8 --update --tpslimit 9 --drive-stop-on-upload-limit \
	--drive-pacer-min-sleep 10ms --drive-pacer-burst 200 --delete-during --max-delete 200 --log-file \
	"/root/.config/rclone/log/digispark-copy.log" \
	/mnt/union/video-movies gcrypt-digispark:media/video-movies
	echo "$(date +"%x-%T") > Finished rclone copy local > digispark (errorcode: $?)" | logger -t "$(basename $0)" || exit $?