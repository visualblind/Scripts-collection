#!/usr/bin/env bash

RCLONEPATH=$(which rclone)

# begin entry for syslog
echo "$(date +"%x-%T") > Starting rclone sync umpacma > digispark" | logger -t "$(basename $0)"

# begin rclone sync operation
$RCLONEPATH copy -v --progress --stats 3s --config "/root/.config/rclone/rclone.conf" \
	--crypt-server-side-across-configs --drive-server-side-across-configs \
	--transfers 10 --checkers 10 --update --tpslimit 6 --drive-stop-on-upload-limit \
	--drive-pacer-min-sleep 10ms --drive-pacer-burst 200 --log-file \
	"$HOME/.config/rclone/log/digispark-cryptservercopy.log" \
	gcrypt-umpacma:p0ds0smb/video-shows gcrypt-digispark:p0ds0smb/video-shows >| /dev/null ; \
	echo "$(date +"%x-%T") > Finished rclone sync umpacma > digispark (errorcode: $?)" | logger -t "$(basename $0)" || exit $?
