#!/usr/bin/env bash
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -bsf:v "filter_units=remove_types=6" -movflags +faststart -codec copy "../.working/${f}"; done
