#!/usr/bin/env bash
set -e
shopt -s extglob
shopt -s globstar
shopt -s nullglob

# BSD
find /mnt/pool0/p0ds0smb/media/video-{movies,shows,standup} -maxdepth 4 -name '*.srt' -type f -mtime -5d -exec sed -E -i '' '/Advertise your product|OpenSubtitles|osdb|Support us|VIP member|Synced and|sync &|addic7ed|iSubDB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com/I{d;}' '{}' \+

# GNU/Linux
#find /mnt/pool0/p0ds0smb/media/video-{movies,shows,standup} -maxdepth 4 -name '*.srt' -type f -mtime -5 -exec sed -E -i '/Advertise your product|OpenSubtitles|osdb|Support us|VIP member|Synced and|sync &|addic7ed|iSubDB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com/I{d;}' '{}' \+
