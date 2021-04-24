#!/usr/bin/env bash
for f in */*.{mkv,mp4}; do
BITDEPTH=$(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "$f")
if ! [ "${BITDEPTH[0]}" = "8" ]; then
  echo -e "$f has a bit depth of ${BITDEPTH[0]}"
fi
done