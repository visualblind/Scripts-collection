#!/usr/bin/env bash
set -e
shopt -s extglob
shopt -s globstar
shopt -s nullglob

find /mnt/pool0/p0ds0smb/media/video-{movies,shows,standup} -maxdepth 4 -name '*.srt' -type f -mtime -5d -exec sed -E -i '' '/Advertise your product|OpenSubtitles|osdb.link|Support us and become VIP member|Synced and corrected|www.addic7ed.com|iSubDB.com|choose the best subtitles|Subtitles by|Subtitles search|www.YIFY-TORRENTS.com|www.yifysubtitles.com|Created and Encoded by/I{d;}' '{}' \+

#find /mnt/pool0/p0ds0smb/media/video-{movies,shows,standup} -name '*.srt' -type f -print0 | xargs -I '{}' -0 sed -E -i '' '/Advertise your product|OpenSubtitles|osdb.link|Support us and become VIP member|Synced and corrected|www.addic7ed.com|choose the best subtitles|Subtitles by/I{d;}' '{}' \+

#sed -E -i '' '/Advertise your product|OpenSubtitles|osdb.link|Support us and become VIP member|Synced and corrected|www.addic7ed.com|choose the best subtitles/I{d;}' /mnt/pool0/p0ds0smb/media/video-{movies,shows,standup}/**/*.srt

#find . -type d \( -path 'podcasts' -o -path 'video-memories' -o -path 'video-starcraft' -o -path 'video-tech' -o -path 'video-tennis' -o -path 'video-uncategorized' \) -prune -false -o -name '*.srt' -type f -print0 | xargs -0 sed -E -i '' '/Advertise your product|OpenSubtitles|osdb.link|Support us and become VIP member|Synced and corrected|www.addic7ed.com|choose the best subtitles|Subtitles by/I{d;}' {} \+

