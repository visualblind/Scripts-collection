#!/usr/bin/env bash

remount_media() {

if [[ -d /usr/local/jellyfin/media && -f /usr/local/jellyfin/media/scriptcheck ]]; then
	#rclone mount exists, no need to remount
	docker restart jellyfin && echo " --- REMOUNT NOT NEEDED --- " | logger -t 'remount_media_rclone'
else
	docker stop jellyfin 1>/dev/null
	fusermount -u -z /usr/local/jellyfin/media
	/usr/bin/rclone mount gcrypt-usmba:p0ds0smb /usr/local/jellyfin/media --daemon --vfs-cache-mode off --dir-cache-time 180m --read-only
	docker start jellyfin && echo " --- REMOUNT COMPLETE --- " | logger -t 'remount_media_rclone'
fi

}

remount_media