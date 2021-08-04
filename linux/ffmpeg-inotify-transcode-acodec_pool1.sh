#!/usr/bin/env bash
inotifywait -m /mnt/pool1/p1ds0smb/temp/ffmpeg-inotify/. -e close_write -e moved_to |
  while read dir action file; do
    if [[ "$file" =~ ^.*\.(mp4|mkv)$ ]]; then
      bash -c "/mnt/pool0/p0ds0smb/visualblind/Documents/Scripts/linux/ffmpeg_tcode_compat.sh -d /mnt/pool1/p1ds0smb/temp/ffmpeg-inotify -w /mnt/pool1/p1ds0smb/temp/ffmpeg-inotify/.working | /usr/bin/logger -t 'ffmpeg-inotify-transcode-acodec.sh'";
    fi;
  done
