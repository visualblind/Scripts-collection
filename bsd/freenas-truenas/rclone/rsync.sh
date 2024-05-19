#!/usr/bin/env bash
rsync --recursive --update --ignore-existing --itemize-changes --progress --human-readable --stats --verbose --include="*/" --include="*.mkv" --include="*.mp4" --include="*.srt" --include="*.avi" --exclude="*" "$1" /mnt/"$2"/temp/ffmpeg-vcodec/
