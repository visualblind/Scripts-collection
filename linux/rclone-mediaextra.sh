#!/usr/bin/env bash

# SYNC + Delete extra shows
rclone move --bwlimit 4M --progress --size-only --transfers 2 --tpslimit 2 --tpslimit-burst 4 --update --drive-use-trash=false --delete-empty-src-dirs --log-level INFO --log-file $HOME/.config/rclone/log/upload-mediaextra.log --delete-during /mnt/pool3/p3ds0smb/media-extra/video-shows gcrypt-usmba:p3ds0smb/media-extra/video-shows

# SYNC + Delete extra movies
rclone move --bwlimit 2M --progress --size-only --transfers 2 --tpslimit 2 --tpslimit-burst 4 --update --drive-use-trash=false --delete-empty-src-dirs --log-level INFO --log-file $HOME/.config/rclone/log/upload-mediaextra.log --delete-during /mnt/pool3/p3ds0smb/media-extra/video-movies gcrypt-usmba:p3ds0smb/media-extra/video-movies

# SYNC + Delete software-extra
rclone move --bwlimit 2M --progress --size-only --transfers 2 --tpslimit 2 --tpslimit-burst 4 --update --drive-use-trash=false --delete-empty-src-dirs --log-level INFO --log-file $HOME/.config/rclone/log/upload-softwareextra.log --delete-during /mnt/pool3/p3ds0smb/software-extra gcrypt-usmba:p3ds0smb/software-extra

