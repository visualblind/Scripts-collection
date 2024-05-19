#!/usr/bin/env bash

#for f in */*.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title="${f/EAC3/AAC}" -metadata:s:v:0 title= -metadata:s:a title= -bsf:v "filter_units=remove_types=6" -c:v copy -channel_layout "5.1" -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"$(basename "${f/EAC3/AAC}"); done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title="${f/DD+/AAC}" -metadata:s:v:0 title= -metadata:s:a title= -bsf:v "filter_units=remove_types=6" -c:v copy -channel_layout "5.1" -c:a aac -c:s copy /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f/DD+/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map 0:s:m:language:eng -dn -map_chapters -1 -metadata title="${f/DDP/AAC}" -metadata:s:v:0 title= -metadata:s:a title= -bsf:v "filter_units=remove_types=6" -c:v copy -channel_layout "5.1" -c:a aac -c:s copy /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -bsf:v "filter_units=remove_types=6" -c:v copy -channel_layout "5.1" -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -c:v copy -channel_layout "5.1" -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done


#for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -default_mode infer_no_subs -dn -map_chapters -1 -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -bsf:v "filter_units=remove_types=6" -c:v copy -c:a copy -c:s srt /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/en.srt}" -map 0:v:0 -map 0:a:m:language:eng -map 1:0 -default_mode infer_no_subs -dn -map_chapters -1 -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata:s:s:0 language=eng -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:s 0 -c:v copy -channel_layout "5.1" -c:a aac -c:s srt /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/srt}" -map 0:v:0 -map 0:a:m:language:eng -map 1:0 -default_mode infer_no_subs -dn -map_chapters -1 -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata:s:s:0 language=eng -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:s 0 -c:v copy -c:a copy -c:s srt /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"$f"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/srt}" -map 0:v:0 -map 0:a -map 1:0 -default_mode infer_no_subs -dn -map_chapters -1 -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata:s:a:0 language=eng -metadata:s:s:0 language=eng -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:s 0 -disposition:a:0 default -disposition:v:0 default -channel_layout "5.1" -c:v copy -c:a aac -c:s srt /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"$f"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -bsf:v "filter_units=remove_types=6" -c:v copy -c:a copy -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map 0:s:m:language:eng -dn -map_chapters -1 -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -disposition:s 0 -bsf:v "filter_units=remove_types=6" -c:v copy -c:a copy -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title="${f/DDP/AAC}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:s 0 -channel_layout "5.1" -c:v copy -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -channel_layout "5.1" -disposition:s 0 -c:v copy -c:a aac -c:s copy /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata comment= -metadata:s:v comment= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:s 0 -c:v copy -c:a copy -c:s srt .working/"${f/DDP/AAC}"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/srt}" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map 1:0 -dn -map_chapters -1 -metadata title="The Big Boss (1971) ENG DUBBED" -metadata:s:v:0 title= -metadata:s:s:0 language=eng -metadata:s:a:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -disposition:a:0 default -disposition:s:0 0 -channel_layout "5.1" -c:v copy -c:a aac -c:s srt "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/$f"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -map_chapters -1 -metadata title="${f/DDP/AAC}" -metadata:s:v:0 title= -metadata:s:a:0 title= -channel_layout "5.1" -c:v copy -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

#for f in *.mp4; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -movflags faststart -metadata title="${f/.mp4/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -metadata:s:v:0 language= -bsf:v "filter_units=remove_types=6" -channel_layout "5.1" -disposition:s 0 -c:v copy -c:a aac -c:s copy /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"$f"; done

#for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:m:language:eng -map "0:s?" -dn -metadata:s:v:0 title= -metadata:s:a:0 title= -c:v copy -channel_layout "5.1" -c:a aac -c:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f/DDP/AAC}"; done

# MP4 insert new subtitle
#for f in *.mp4; do ffmpeg -y -i "$f" -f srt -i "${f/mp4/srt}" -default_mode infer_no_subs -map 0:v:0 -map 0:a:m:language:eng -map 1:0 -dn -map_chapters -1 -metadata title="${f/.mp4/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date -Iseconds)" -metadata:s:v creation_time="$(date -Iseconds)" -metadata:s:a creation_time="$(date -Iseconds)" -metadata:s:s:0 language=eng -channel_layout "5.1" -disposition:s 0 -c:v copy -c:a aac -c:s copy /mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f}"; done

#for f in *.avi; do ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map "0:s?" -dn -map_chapters -1 \
#-movflags faststart -profile:v high -pix_fmt yuv420p -metadata:s:a:0 language=eng \
#-metadata title="${f/.avi/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -c:v libx264 -c:a aac \
#"../.working/${f/.avi/.mp4}"; done
