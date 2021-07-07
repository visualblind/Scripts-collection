#!/usr/bin/env bash
find /mnt/pool0/p0ds0smb/media/video-* -depth -type d -iname "sample" -print0 | \
xargs -0 /bin/rm -rfv 1>/dev/null ; find /mnt/pool0/p0ds0smb/media/video-movies /mnt/pool0/p0ds0smb/media/video-shows \
-type f ! \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.srt" -o -iname "*.mkv" -o -iname "*.m4v" -o -iname "*.sub" \
-o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.sfv" -o -iname "*.mpg" -o -iname "*.mpeg" \
-o -iname "*.idx" -o -iname ".ignore" -o -iname ".*" -o -iname "*.ac3" -o -iname "*.txt" \
-o -ipath "*.~tmp~*" -o -ipath "*episode*" -o -ipath '*sub*' -o -ipath "*video_ts*" \) -print0 | \
xargs -0 /bin/rm -rfv 1>/dev/null ; find /mnt/pool0/p0ds0smb/media/video-movies /mnt/pool0/p0ds0smb/media/video-shows \
-type f \( -iname "*YIFY*.jpg" -o -iname "*YTS*.jpg" \) -print0 | xargs -0 /bin/rm -rfv
