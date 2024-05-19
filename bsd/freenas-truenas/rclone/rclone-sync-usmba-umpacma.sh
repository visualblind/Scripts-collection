#!/usr/bin/env bash

rclone sync -v --config "/root/.config/rclone/rclone.conf" --filter-from "/root/.config/rclone/filters/usmba2umpacma.filter" \
	--crypt-server-side-across-configs --drive-server-side-across-configs --progress --stats=5s --stats-file-name-length 0 \
	--transfers 12 --checkers 12 --tpslimit 6 --drive-stop-on-upload-limit --drive-pacer-min-sleep 10ms --drive-pacer-burst 200 \
	--delete-during --max-delete 100 --log-file $HOME/.config/rclone/log/sync-usmba2umpacma.log \
	gcrypt-usmba:p0ds0smb gcrypt-umpacma:p0ds0smb

#--dump filters --track-renames --track-renames-strategy modtime
	
