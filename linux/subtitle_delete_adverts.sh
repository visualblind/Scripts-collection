#!/usr/bin/env bash

# BSD find, sed, xargs
find . -name '*.srt' -type f -mtime -5d -exec sed -E -i '' '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}' '{}' \+
find . -name '*.srt' -type f -print0 | xargs -0 sed -E -i '' '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}'
find . -type d \( -path 'dir1' -o -path 'dir2' -o -path 'dir3' -o -path 'dir4' -o -path 'dir5' \) -prune -false -o -name '*.srt' -type f -print0 | xargs -0 sed -E -i '' '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}'
find . -name '*.srt' -type f -print0 | xargs -I '{}' -0 sed -E -i '' '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}' '{}'

# GNU/Linux find, sed
# One-liner
find . -name '*.srt' -type f -mtime -5 -exec sed -E -i '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}' '{}' \+

# Same as above
long_arg="/Advertise your product|OpenSubtitles|osdb|Support DB.com\
|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|\
twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|\
www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member\
|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate \
this subtitle|www.osdb.link|The best subtitles|Synced and corrected by\
 VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the \
 real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync\
 for WEB-DL by Norther/I{d;}"
find . -name '*.srt' -type f -mtime -5 -exec sed -E -i "$long_arg" '{}' \+

# Sed and shell globbing
sed -E -i '/Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by VitoSilans|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther/I{d;}' **/*.srt
