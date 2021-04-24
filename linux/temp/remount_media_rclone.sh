#!/usr/bin/env bash

remount_media() {
  docker stop jellyfin 1>/dev/null
  fusermount -u -z /usr/local/jellyfin/media
  /usr/bin/rclone mount gcrypt-usmba:p0ds0smb /usr/local/jellyfin/media --daemon --vfs-cache-mode off --dir-cache-time 180m --read-only
  docker start jellyfin 1>/dev/null
  echo " --- REMOUNT COMPLETE --- " | logger -t 'remount_media_rclone.sh'
}

if ! ( test -d /usr/local/jellyfin/media/video-movies ); then
  remount_media
else
  echo " --- REMOUNT NOT NEEDED --- " | logger -t 'remount_media_rclone.sh'
fi

