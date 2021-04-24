#!/usr/bin/env bash

# SYNC + Delete Shows
rclone move --bwlimit 2M --progress --checksum --transfers 2 --tpslimit 4 --tpslimit-burst 6 --update --drive-use-trash=false --delete-empty-src-dirs --log-level INFO --log-file $HOME/.config/rclone/log/upload-mediaextra.log --delete-during /mnt/pool3/p3ds0smb/media-extra/video-shows gcrypt-usmba:p3ds0smb/media-extra/video-shows

# SYNC + Delete Movies
rclone move --bwlimit 2M --progress --checksum --transfers 2 --tpslimit 4 --tpslimit-burst 6 --update --drive-use-trash=false --delete-empty-src-dirs --log-level INFO --log-file $HOME/.config/rclone/log/upload-mediaextra.log --delete-during /mnt/pool3/p3ds0smb/media-extra/video-movies gcrypt-usmba:p3ds0smb/media-extra/video-movies
