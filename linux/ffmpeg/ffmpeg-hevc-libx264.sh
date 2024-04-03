#!/usr/bin/env bash

# HEVC > AVC (libx264)
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working'
shopt -s globstar
for f in *.mkv; do
  VFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
if ! [[ "${VFORMAT[0]}" == 'avc' ]]; then
  echo -e '\n---> '$(basename "$f")': detected '${VFORMAT[0]}' in the default video stream\n---> Preparing to convert video codec to H264...\n\n'
  ffmpeg -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -map "0:s?" -disposition:v:0 default -disposition:a:0 default -map_chapters -1 -dn -map_metadata -1 -bsf:v "filter_units=remove_types=6" -preset slow -profile:v high -pix_fmt yuv420p -c:v libx264 -metadata:s:a:0 language=eng -c:a copy -c:s copy "$TEMPDIR/$f" || break
  echo -e '\n---> Moving '$(basename "${f}")' back to source directory name '$(pwd)'\n'
  mv -ufv "$TEMPDIR/$(basename "${f}")" "$(dirname "${f}")"
fi
done