#!/usr/bin/env bash

rclone copy -v --config "/root/.config/rclone/rclone.conf" \
	--crypt-server-side-across-configs --drive-server-side-across-configs --progress --stats=3s --stats-file-name-length 0 \
	--transfers 8 --tpslimit 8 --drive-stop-on-upload-limit --drive-pacer-min-sleep 10ms --drive-pacer-burst 200 \
	--log-file $HOME/.config/rclone/log/sync-gcrypt-umpacma.log \
	gcrypt-usmba:p0ds0smb gcrypt-umpacma:p0ds0smb
