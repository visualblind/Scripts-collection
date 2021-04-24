#!/usr/bin/env bash

############################ [ FFmpeg Documentation Tips ] ############################


-metadata[:metadata_specifier] key=value (output,per-metadata)

For example, for setting the title in the output file:
ffmpeg -i in.avi -metadata title="my title" out.flv

To set the language of the first audio stream:
ffmpeg -i INPUT -metadata:s:a:0 language=eng OUTPUT

-disposition[:stream_specifier] value (output,per-stream)

For example, to make the second audio stream the default stream:
ffmpeg -i in.mkv -c copy -disposition:a:1 default out.mkv

To make the second subtitle stream the default stream and remove the default disposition from the first subtitle stream:
ffmpeg -i in.mkv -c copy -default_mode infer_no_subs -disposition:s:0 0 -disposition:s:1 default out.mkv

"-preset" provides the compression to encoding speed ratio. Use the slowest preset you can.

"-bufsize" sets the buffer size, and can be 1-2 seconds for most gaming screencasts, and up to 5 seconds for more static content.
If you use "-maxrate" 960k then use a "-bufsize" of 960k-1920k. You will have to experiment to see what looks best for your content.

"-g" Use a 2 second GOP (Group of Pictures), so simply multiply your output frame rate * 2.
For example, if your input is -framerate 30, then use -g 60

"-crf 0", short for “constant rate factor,” is used to tell the libx264 encoder to use “lossless mode.”
See https://esoterictek.blogspot.com/2017/04/understanding-ffmpegs-group-of-pictures.html.

The film industry generally chooses 24 FPS in film capturing and production.



############################ [/ffmpeg Documentation] ############################

#for i in *.flv; do ffmpeg -i "$i" -movflags faststart -c:a aac -c:v libx264 -b:a 128k "${i%.flv}.mp4"; done
for f in $(find . -type f -name '*265.mkv'); do ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s:0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/%265.mkv/264.mkv}"; done
for f in $(find . -type f -name '*265.mkv' -print); do ffmpeg -i "${f}" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 21 "./working/${f/265/264}"; done
for f in *.mp4; do ffmpeg -i "$f" -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/(x265)/(x264)}"; done
for f in *.mp4; do ffmpeg -i "$f" -map 0:v -map 0:a -map 0:s -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/(x265)/(x264)}"; done
for f in *.mkv; do ffmpeg -i "$f" -map 0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/x265/x264}"; done
for f in *.mkv; do ffmpeg -i "$f" -map 0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/.mkv/.x264.mkv}"; done
# Strip all subtitle streams from input file:
for f in *.mkv; do ffmpeg -i "$f" -map 0:v -map 0:a -c:v copy -c:a copy ./working/"${f/.mkv/.x264.mkv}"; done

# Convert audio stream to AAC and insert subtitles stream from external srt file:
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.en.mkv/.srt}" -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.en.mkv/.srt}" -map 0:0 -map 0:1 -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done

# Convert 10/8bit HEVC/H.265 to 8bit AVC/H.264 MKV high profile slow preset, insert external SRT subtitle file and not-DEFAULT with eng lang
for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 0 -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s srt "../.working/${f/find/replace}"; done
# Convert 10/8bit HEVC/H.265 to 8bit AVC/H.264 MKV high profile slow preset, stream-copy original subtitles (if present) and DEFAULT with eng lang
for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 default -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s copy "../.working/${f/find/replace}"; done

# One off:
ffmpeg -i 'The.Big.Bang.Theory.S05E01.720p.HDTV.mkv' -f srt -i 'The.Big.Bang.Theory.S05E01.720p.HDTV.srt' -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt './working/The.Big.Bang.Theory.S05E01.720p.HDTV.mkv'

# Convert audio stream to AAC and do not add subtitles:
for f in *.mkv; do ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -c:v copy -c:a aac ./working/"${f/.old.ext/.new.mkv}"; done

# Or
for f in *.mkv; do ffmpeg -i "$f" -map 0:v -map 0:a:0 -c:v copy -c:a aac ./working/"${f/.old.ext/.new.mkv}"; done

ffmpeg -i 'Ip Man (2008) - 1080p H265.mkv' -map 0:v -map 0:a -map 0:s -movflags faststart -c:v libx264 -crf 23 -c:a aac -af "volume=10dB" -c:s srt 'Ip Man (2008) - 1080p x264.mkv'


########### NVIDIA ###########
# NVIDIA hardware accelerated convert H.265 > H.264
find . -mount -depth -maxdepth 1 -name '*.mkv' -type f -exec bash -c 'ffmpeg -y -loglevel verbose -vsync 0 -hwaccel cuvid -hwaccel_output_format cuda -i "$0" -f srt -i "${0/.mkv/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -c:v h264_nvenc -preset slow -metadata:s:a:0 language=eng -c:a copy -metadata:s:s:0 language=eng -disposition:s:0 default -c:s:0 srt "./working/${0/x265/x264}"' {} \;
ffmpeg -hwaccel nvdec -i "$f" -movflags faststart -c:v h264_nvenc -c:a copy -c:s copy -crf 23 "${f/(265)/(264)}"
##############################


# Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy only the first subtitle stream
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

# Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy all subtitle streams
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

# Convert H.265 > H.264 and retain original audio and all subtitles:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -preset slow -c:a copy -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

# Copy original video stream and convert 6CH AC3 audio to AAC and copy all subtitle streams:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 384k -c:a aac -c:s copy "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

# Copy original video stream and convert 2CH AC3 audio to AAC and copy all subtitle streams:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ar 48000 -b:a 384k -c:a aac -c:s copy "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

# Just strip all subtitles:
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -c:v copy -c:a copy "${0/ (2000)/}"' {} \;; find . -name '*(2000)*' -type f -delete

# Futurama Season 7 custom, 2-3 AC3 audio streams with the first having 6-channel and between 1-2 AC3 2-channel commentary tracks, a non-standard hdmv_pgs_subtitle subtitle track ususally at stream 0:3 requiring dropping and replacement with external .srt file
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -f srt -i "${0/mkv/en.srt}" -map 0:v:0 -map 0:a:0 -map 0:a:1 -map 0:a:2? -map 1:0 -c:v copy -ac:0 6 -ac:1 2 -ac:2 2 -ar 48000 -c:a:0 aac -c:a:1 aac -c:a:2 aac -c:s srt ./working/"${0/DD5.1/AAC5.1}"' {} \;

# Increase volume to 150% of original media
for f in *.mkv; do ffmpeg -i "$f" -map 0 -filter:a "volume=1.5" -c:v copy -c:a aac -c:s copy "../working/$f"; done

for f in /path/to/directory/*.mkv; do ffmpeg -i "$f" \
-map 0 -filter:a "volume=2.0" -c:v copy -c:a aac -c:s copy \
"/path/to/directory/.working/$(basename "$f")"; done

ffmpeg -i input.mp4 -map 0 -filter:a "volume=1.5" -c:v copy -c:a aac -c:s copy output.mp4

# Remove data stream from MP4 container
1a) ffmpeg -i in.mp4 -c copy -dn -map_metadata:c -1 out.mp4
1b) for f in *.mp4; do ffmpeg -i "$f" -c copy -dn -map_metadata:c -1 "$f"; done

# Remove chapters from the container
1a) ffmpeg -i input.mp4 -map 0:v -map 0:a -c:v copy -c:a copy -map_chapters -1 output.mp4
1b) for f in *.mp4; do ffmpeg -i "$f" -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -map_chapters -1 "$f"; done

## Remove closed captions (CC)
1a) ffmpeg -y -i input.mkv -map 0 -c copy -bsf:v "filter_units=remove_types=6" output.mkv
1b) for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -bsf:v "filter_units=remove_types=6" "./.working/${f}"; done

# Insert srt subtitle to mp4
ffmpeg -i 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264.mp4' -i 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264.en.srt' -metadata:s:s:0 language=eng -c:v copy -c:a copy -c:s mov_text 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264_2.mp4'

# Exports clean Subrip/srt subtitle file without annoying <font-face=blah; font-size=18px;> HTML tagging - Extract subtitle from mp4 (and mkv, maybe?) file in Subrip/srt format (Subtitle codec name "text" instead of srt/mov_text)
for f in *.mp4; do ffmpeg -y -i "$f" -map 0:s? -c:s text "${f/.mp4/.en.srt}"; done

# Find directories with more than one media file
find . -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -printf '%h\n' | sort | uniq -d

# Convert interlaced to progressive
ffmpeg -i '/media/file1.mkv' -vf yadif -c:v libx264 -preset slow -crf 19 -c:a aac -b:a 192k -c:s srt -max_muxing_queue_size 400 /media/file2.mkv

# Increase max muxing queue size
ffmpeg -i 'input.mkv' -max_muxing_queue_size 400 'output.mkv'

# Remove subtitle and audio description/title and add english metadata
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata:s:a:0 language=eng -metadata:s:a:0 title= -metadata:s:s:0 language=eng -metadata:s:s:0 title= ./working/"${f}"; done

# Add text metadata to various sections of file
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" ./working/"${f}"; done
ffmpeg -y -i input.mkv -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" output.mkv

# Add Matroska Title metadata to the container while removing Title metadata from all of its streams (video, audio, subtitle)
ffmpeg -y -i input.mkv -f srt -i input.en.srt -map 0:v -map 0:a:1 -map 1:0 -movflags +faststart -metadata:s:v:0 language= -metadata:s:s:0 language=eng -metadata:s:v:0 Title= -metadata:s:a:0 Title= -metadata:s:s:0 Title= -metadata Title="Who Am I (1998)" -disposition 0 -disposition:s:1 default -c:v copy -c:a copy -c:s srt output.mkv

########## Methods of Reducing file size with FFmpeg ##########
# https://trac.ffmpeg.org/wiki/EncodingForStreamingSites
##### Modify the bitrate, using:
ffmpeg -i $infile -b $bitrate $newoutfile
##### Vary the Constant Rate Factor, using:
ffmpeg -i $infile -vcodec libx264 -crf 23 $outfile
##### Change the video screen-size (for example to half its pixel size), using:
ffmpeg -i $infile -vf "scale=iw/2:ih/2" $outfile
##### Change the H.264 profile to "baseline", using:
ffmpeg -i $infile -profile:v baseline $outfile
Use the default ffmpeg processing, using:
ffmpeg -i $infile $outfile
# Bitrate Guidelines:
# Calculate the bitrate you need by dividing your target size (in bits) by the video length (in seconds). For example for a target size of 1 GB (one giga<em>byte</em>, which is 8 giga<em>bits</em>) and 10,000 seconds of video (2 h 46 min 40 s), use a bitrate of 800 000 bit/s (800 kbit/s):
ffmpeg -i input.mp4 -b 800k output.mp4

# example 1:
# ffmpeg -i input.mkv -c:v libx264 -preset medium -b:v 3000k -maxrate 3000k -bufsize 6000k \
# -vf "scale=1280:-1,format=yuv420p" -g 50 -c:a aac -b:a 128k -ac 2 -ar 44100 file.flv
#
# example 2:
#
#########################################################

# Concatenation https://trac.ffmpeg.org/wiki/Concatenate
for f in ./*.mkv; do echo "file '$f'" >> mylist.txt; done

# Note that these can be either relative or absolute paths. Then you can stream copy or re-encode your files:
ffmpeg -f concat -safe 0 -i "mylist.txt" "output.mkv"

# Concatenate multiple media files
for f in ./*.mkv; do echo "file '$f'" >> mylist.txt; done
ffmpeg -f concat -safe 0 -i "mylist.txt" -b 4292k -c copy "Top.Gear.Patagonia.Special.1080p.mkv"

# Map only English audio stream and English subtitle streams if it exists
for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:m:language:eng -map 0:s:m:language:eng? -codec:v copy -codec:a copy -codec:s srt "../../../../temp/ffmpeg-vcodec/.working/${f/x265/x264}"; done

# Dont set any subtitle streams as default or forced
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -map 0:s:m:language:eng? -disposition:s 0 -codec copy "$f"; done

-default_mode
This option controls how the FlagDefault of the output tracks will be set. It influences which tracks players should play by default. The default mode is ‘infer’.
'infer'
In this mode, for each type of track (audio, video or subtitle), if there is a track with disposition default of this type, then the first such track (i.e. the one with the lowest index) will be marked as default; if no such track exists, the first track of this type will be marked as default instead (if existing). This ensures that the default flag is set in a sensible way even if the input originated from containers that lack the concept of default tracks.
'infer_no_subs'
This mode is the same as infer except that if no subtitle track with disposition default exists, no subtitle track will be marked as default.
'passthrough'
In this mode the FlagDefault is set if and only if the AV_DISPOSITION_DEFAULT flag is set in the disposition of the corresponding stream.

#Outputs filenames along with its audio codec(s)
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort

# Sync multiple audios streams
for f in *.mkv; do ffmpeg -y -i "${f}" -i "${f/.mkv/.m4a}" \
-c:v copy -b:a:0 128k -filter_complex "[a:0]aresample=async=1000[a:0]" -movflags faststart -c:a:0 aac -c:a:1 copy -c:s copy \
-map 0:v:0 -map 1:0 -map 0:a:0 $(i=1; while [ $i -lt 28 ]; do echo -n "-map 0:s:$((i++)) "; done) \
-metadata:s:a:0 language=eng -disposition 0 -disposition:a:0 default -disposition:s:0 default -metadata:s:s:0 title= \
-metadata:s:a comment= -shortest "${f/.NF.WEB-DL.AAC5.1.x264-NTG.mkv/.ENG-SPA.WEB-DL.AAC5.1.x264.mkv}"; done

for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected aac audio streams\nPreparing to copy english audio stream' ; sleep 4
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a copy -c:s copy "${f/x265/x264}"
	else
	echo -e '\nffprobe detectable audio streams not equal to aac\nPreparing to transcode with aac' ; sleep 4
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a aac -c:s copy "${f/x265/x264}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s srt "./working/${f/X264/X264.AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 0 -c:s srt "./working/${f/.mkv/.x264.AAC.mkv}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 640k -c:a aac -disposition:s:0 default -c:s copy "./working/${f/DDP/AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 640k -c:a aac "./working/${f/DDP/AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected aac audio streams\nPreparing to copy english audio stream' ; sleep 4
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a copy -c:s copy "${f/x265/x264}"
	else
	echo -e '\nffprobe detectable audio streams not equal to aac\nPreparing to transcode with aac' ; sleep 4
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a aac -c:s copy "${f/x265/x264}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s srt "./working/${f/X264/X264.AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 0 -c:s srt "./working/${f/.mkv/.x264.AAC.mkv}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 640k -c:a aac -disposition:s:0 default -c:s copy "./working/${f/DDP/AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 640k -c:a aac "./working/${f/DDP/AAC}"
fi
done


for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 768k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s srt "./working/${f/DTS-JYK/AAC5.1}"
fi
done

for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\n\tffprobe detected '$audioformat' in the default audio stream a:0, while it expected aac.\n\tPreparing to convert default audio stream codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 256k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s copy "./working/${f/.mkv/.AAC.mkv}"
fi
done




for f in *.mp4; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mp4/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 640k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -c:s mov_texSystems Administratort "../working/${f/1040p.BluRay.5.1.x264 . NVEE.mp4/1080p.BluRay.AAC.x264.mp4}"
fi
done
for f in *.mp4; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mp4/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 448k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -c:s mov_texSystems Administratort "../working/${f/.mp4/.AAC.mp4}"
fi
done
for f in *.mp4; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mp4/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 2 -ar 48000 -b:a 192k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -c:s mov_texSystems Administratort "../working/${f/.mp4/.AAC.mp4}"
fi
done
for f in *.mp4; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 0 -c:s copy "./working/${f/.mp4/ AAC x264.mp4}"
fi
done

for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s srt "./working/${f/x264.mkv/AAC.x264.mkv}"
fi
done
for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 640k -metadata:s:a:0 language=eng -c:a aac -c:s copy "./working/${f/DDP/AAC}"
fi
done
for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 768k -metadata:s:a:0 language=eng -c:a aac -c:s copy "./working/${f/DDP/AAC}"
fi
done
for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 384k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s copy "./working/${f/AC3-EVO/AAC51}"
fi
done
for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if ! [ "$audioformat" = "aac" ]; then
	echo -e '\nffprobe detected '$audioformat' in the default audio stream a:0\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 192k -metadata:s:a:0 language=eng -c:a aac -metadata:s:s:0 language=eng -disposition:s:0 default -c:s copy "./working/${f/AC3-EVO/AAC51}"
fi
done


ffprobe -v error -select_streams a:0 -show_entries stream=channels,bit_rate -of default=noprint_wrappers=1:nokey=1 video.mp4


shopt -s globstar
for f in **/*.mp4; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
  echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
  ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -sn "/mnt/pool0/p0ds0smb/temp/ffmpeg/working/${f}"
fi
done

shopt -s globstar
for f in **/*.mkv; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
  echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 1
  ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -disposition:s:0 default -c:s srt "/mnt/pool0/p0ds0smb/temp/ffmpeg/working/${f/h264/aac.h264}"
fi
done

# MKV
# Remember to include trailing slash in TEMPDIR
TEMPDIR='/mnt/pool0/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in **/*.mkv; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
	echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 2
 	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -c:s copy "$TEMPDIR$(basename "${f}")"
	echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 2
	mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"
fi
done

# MP4
# Remember to include trailing slash in TEMPDIR
TEMPDIR='/mnt/pool0/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in **/*.mp4; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
	echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 2
 	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -c:s copy "$TEMPDIR$(basename "${f}")"
	echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 2
	mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"
fi
done

# MP4 in current dir
TEMPDIR='/mnt/pool0/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in *.mp4; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
	echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 2
 	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -c:s copy "$TEMPDIR$(basename "${f}")" || exit 1
	echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 2
	mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"
fi
done

# MKV and MP4
# Remember to include trailing slash in TEMPDIR
TEMPDIR='/mnt/pool0/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in **/*.mkv **/*.mp4; do
AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
	echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\nPreparing to convert audio codec to AAC...\n' ; sleep 2
 	ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac ${AUDIOFORMAT[1]} -ar 48000 -metadata:s:a:0 language=eng -c:a aac -c:s copy "$TEMPDIR$(basename "${f}")"
	echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 2
	mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"
fi
done

# Nvidia hardware acceleration
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in *.mkv; do
  VIDEOFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
  AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
  echo -e '\nffprobe detected '${VIDEOFORMAT[0]}' in the default video stream v:0 \n\n\tPreparing to convert video codec to H264...\n\n'
  echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\n\tPreparing to convert audio codec to AAC...\n' ; sleep 3
  ffmpeg -vsync 0 -hwaccel cuvid -hwaccel_output_format cuda -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags +faststart -ac ${AUDIOFORMAT[1]} -ar 48000 -c:v h264_nvenc -c:a aac -metadata:s:a:0 language=eng -metadata:s:s:0 language=eng -disposition:s:0 default -c:s copy "$TEMPDIR$(basename "${f/ WEB-DL x265 ImE/ x264}")" || break
  echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'
  mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"; sleep 2
fi
done

# H.264/AAC/SRT
TEMPDIR='/mnt/pool0/p0ds0smb/temp/ffmpeg/working/'
shopt -s globstar
for f in *.mkv; do
#VIDEOFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
  AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
#  echo -e '\nffprobe detected '${VIDEOFORMAT[0]}' in the default video stream v:0 \n\n\tPreparing to convert video codec to H264...\n\n'
  echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream a:0 with '${AUDIOFORMAT[1]}' channels\n\n\tPreparing to convert audio codec to AAC...\n' ; sleep 3
  ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s -movflags +faststart -ac ${AUDIOFORMAT[1]} -ar 48000 -c:v libx264 -c:a aac -metadata:s:a:0 language=eng -metadata:s:s:0 language=eng -disposition:s:0 default -c:s copy "$TEMPDIR$(basename "${f}")" || break
  echo -e '\nMoving '$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'
  mv -ufv "$TEMPDIR$(basename "${f}")" "$(dirname "${f}")"
fi
done