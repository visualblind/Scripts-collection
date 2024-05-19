#!/usr/bin/env bash

rclone sync -v --config "/root/.config/rclone/rclone.conf" --filter-from "/root/.config/rclone/filters/usmba2umpacma.filter" \
	--crypt-server-side-across-configs --drive-server-side-across-configs --progress --stats=5s --stats-file-name-length 0 \
	--transfers 12 --checkers 18 --tpslimit 5 --drive-stop-on-upload-limit --drive-pacer-min-sleep 10ms --drive-pacer-burst 200 \
	--delete-during --log-file $HOME/.config/rclone/log/sync-usmba2umpacma.log \
	gcrypt-usmba: gcrypt-umpacma:

#--track-renames --track-renames-strategy modtime
	
