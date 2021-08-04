#!/usr/bin/env bash
#travisrunyard.us

remount_media() {

if [[ -d /usr/local/jellyfin/media && -f /usr/local/jellyfin/media/scriptcheck ]]; then
        #rclone mount exists, no need to remount
        docker stop jellyfin && echo " --- STOPPING JELLYFIN --- " | logger -t '$0'
        rm -rf /usr/local/jellyfin/config/transcoding-temp/*.ts
        docker start jellyfin && echo " --- STARTING JELLYFIN --- " | logger -t '$0'
else
        docker stop jellyfin 1>/dev/null || reboot
        fusermount -u -z /usr/local/jellyfin/media
        /usr/bin/rclone mount gcrypt-usmba:p0ds0smb /usr/local/jellyfin/media --daemon --vfs-cache-mode off --dir-cache-time 180m --read-only || reboot
        rm -rf /usr/local/jellyfin/config/transcoding-temp/*.ts
        docker start jellyfin || reboot
        echo " --- REMOUNT COMPLETE --- " | logger -t 'remount_media_rclone'
fi

}

remount_media