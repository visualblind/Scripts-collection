for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -bsf:v "filter_units=remove_types=6" "./.working/${f}"; done
