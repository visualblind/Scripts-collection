#!/usr/bin/env bash

remount_media() {
  docker stop jellyfin 1>/dev/null
  fusermount -u -z /usr/local/jellyfin/media
  mount /usr/local/jellyfin/media 2>&1
  docker start jellyfin 1>/dev/null
  echo " --- REMOUNT COMPLETE --- " | logger -t 'remount_media.sh'
}

if ! ( test -d /usr/local/jellyfin/media/video-movies ); then
  remount_media
else
  echo " --- REMOUNT NOT NEEDED --- " | logger -t 'remount_media.sh'
fi