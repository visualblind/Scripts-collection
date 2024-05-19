#!/usr/bin/env bash

| Sorted by efficency | Chrome | Edge | Firefox | Safari | Anroid | Android TV | iOS | SwiftFin (iOS) | Roku | Kodi | Desktop |
|---------------------|--------|------|---------|--------|--------|------------|-----|----------------|------|------|---------|
| MPEG-4 Part 2/SP    | ❌      | ❌    | ❌       | ❌      | ❌      | ❌          | ❌   | ✅              | ✅    | ✅    | ✅       |
| MPEG-4 Part 2/ASP   | ❌      | ❌    | ❌       | ❌      | ❌      | ❌          | ❌   | ✅              |      | ✅    | ✅       |
| H.264 8Bit          | ✅      | ✅    | ✅       | ✅      | ✅      | ✅          | ✅   | ✅              | ✅    | ✅    | ✅       |
| H.264 10Bit         | ✅      | ✅    | ❌       | ❌      | ✅      | ✅          | ❌   | ✅              | ❌    | ✅    | ✅       |
| H.265 8Bit          | 🔶8     | ✅7   | ❌       | 🔶1     | 🔶2     | ✅5         | 🔶1  | ✅6             | 🔶9   | ✅    | ✅       |
| H.265 10Bit         | 🔶8     | ✅7   | ❌       | 🔶1     | 🔶2     | 🔶5         | 🔶1  | ✅6             | 🔶9   | ✅    | ✅       |
| VP9                 | ✅      | ✅    | ✅       | ❌      | ✅3     | 🔶3         | ❌   | ❌              | ✅    | ✅    | ✅       |
| AV1                 | ✅      | ✅    | ✅       | ❌      | ✅      | 🔶4         | ❌   | ❌              | ✅    | ✅    | ✅       |

############################ FFmpeg Documentation Tips ############################


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



############################ FFmpeg real-world examples ############################

#for i in *.flv; do ffmpeg -i "$i" -movflags faststart -c:a aac -c:v libx264 -b:a 128k "${i%.flv}.mp4"; done
for f in $(find . -type f -name '*265.mkv'); do ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s:0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/%265.mkv/264.mkv}"; done
for f in $(find . -type f -name '*265.mkv' -print); do ffmpeg -i "${f}" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 21 "./working/${f/265/264}"; done
for f in *.mp4; do ffmpeg -i "$f" -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/(x265)/(x264)}"; done
for f in *.mp4; do ffmpeg -i "$f" -map 0:v -map 0:a -map 0:s -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/(x265)/(x264)}"; done
for f in *.mkv; do ffmpeg -i "$f" -map 0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/x265/x264}"; done
for f in *.mkv; do ffmpeg -i "$f" -map 0 -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${f/.mkv/.x264.mkv}"; done
##### Strip all subtitle streams from input file:
for f in *.mkv; do ffmpeg -i "$f" -map 0:v -map 0:a -c:v copy -c:a copy ./working/"${f/.mkv/.x264.mkv}"; done

##### Convert audio stream to AAC and insert subtitles stream from external srt file:
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.en.mkv/.srt}" -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.en.mkv/.srt}" -map 0:0 -map 0:1 -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.x264.mkv}"; done

##### Convert 10/8bit HEVC/H.265 to 8bit AVC/H.264 MKV high profile slow preset, insert external SRT subtitle file and not-DEFAULT with eng lang
for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/mkv/srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 0 -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s srt "../.working/${f/find/replace}"; done
##### Convert 10/8bit HEVC/H.265 to 8bit AVC/H.264 MKV high profile slow preset, stream-copy original subtitles (if present) and DEFAULT with eng lang
for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 default -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s copy "../.working/${f/find/replace}"; done

##### One off:
ffmpeg -i 'The.Big.Bang.Theory.S05E01.720p.HDTV.mkv' -f srt -i 'The.Big.Bang.Theory.S05E01.720p.HDTV.srt' -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt './working/The.Big.Bang.Theory.S05E01.720p.HDTV.mkv'

##### Convert audio stream to AAC and do not add subtitles:
for f in *.mkv; do ffmpeg -i "$f" -map 0:v:0 -map 0:a:0 -c:v copy -c:a aac ./working/"${f/.old.ext/.new.mkv}"; done
# or
for f in *.mkv; do ffmpeg -i "$f" -map 0:v -map 0:a:0 -c:v copy -c:a aac ./working/"${f/.old.ext/.new.mkv}"; done

ffmpeg -i 'Ip Man (2008) - 1080p H265.mkv' -map 0:v -map 0:a -map 0:s -movflags faststart -c:v libx264 -crf 23 -c:a aac -af "volume=10dB" -c:s srt 'Ip Man (2008) - 1080p x264.mkv'

##### Rearrange audio streams, English audio stream default, Spanish secondary
ffmpeg -i file1.mkv -map 0:v -map 0:a:1 -map 0:a:0 -map 0:s -map_chapters -1 -dn -metadata:s:a:1 language=spa -metadata:s:a:1 title= -metadata:s:s:0 title=English -metadata:s:s:4 title=Spanish -disposition:s 0 -disposition:a 0 -disposition:a:0 default -codec copy file1_2.mkv


###########                                                       ###########
########### NVIDIA HARDWARE ACCELERATED TRANSCODING H.265 > H.264 ###########
###########                                                       ###########

#Resources:
https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/
https://trac.ffmpeg.org/wiki/HWAccelIntro#CUDANVENCNVDEC
https://developer.nvidia.com/nvidia-video-codec-sdk


#use -vsync 0 option with decode to prevent FFmpeg from creating output YUV with duplicate and extra frames.
ffmpeg -vsync 0 -hwaccel nvdec -i <in file> -c:v h264_nvenc -c:a copy <out file>
ffmpeg -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i <in file> -c:v h264_nvenc -c:a copy <out file>
ffmpeg -vsync 0 -hwaccel cuda -i <in file> -c:v h264_nvenc -c:a copy <out file>

#this one outputs data into special cuda format
ffmpeg -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i <in file> -map 0 -preset slow -c:v h264_nvenc -c:a copy <out file>

### DECODE from .mp4 to .yuv
#The FFmpeg video decoder is straightforward to use. To decode an input bitstream from input.mp4, use the following command.
#This generates the output file in NV12 format (output.yuv).
ffmpeg -y -vsync 0 -c:v h264_cuvid -i input.mp4 output.yuv

ffmpeg -vsync 0 -hwaccel nvdec -y -i "input.mkv" -f srt -i "subtitle.srt" -default_mode infer_no_subs -map 0:v -map 0:a:2 -map 0:a:4 -map 0:a:5 -map 0:a:6 -map 0:a:0 -map 0:a:1 -map 0:a:3 -map 1:0 -profile:v high -pix_fmt yuv420p -preset slow -disposition:a:0 default -disposition:v:0 default -metadata:s:s:0 language=eng -dn -map_chapters -1 -c:v h264_nvenc -c:a copy -c:s srt "output.mkv"
ffmpeg -vsync 0 -hwaccel cuda -y -i "input.mkv" -f srt -i "subtitle.srt" -default_mode infer_no_subs -map 0:v -map 0:a:2 -map 0:a:4 -map 0:a:5 -map 0:a:6 -map 0:a:0 -map 0:a:1 -map 0:a:3 -map 1:0 -profile:v high -pix_fmt yuv420p -preset slow -disposition:a:0 default -disposition:v:0 default -metadata:s:s:0 language=eng -dn -map_chapters -1 -c:v h264_nvenc -c:a copy -c:s srt "output.mkv"

#Command Line for Latency-Tolerant High-Quality Transcoding
1. Slow preset
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -c:a copy -c:v h264_nvenc -preset p6 -tune hq -b:v 5M -bufsize 5M -maxrate 10M -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 output.mp4

2. Medium preset
Use -preset p4 instead of -preset p6 in the above command line.

3. Fast preset
Use -preset p2 instead of -preset p6 in the above command line.

#Command Line for Low Latency Transcoding
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -c:a copy -c:v h264_nvenc -preset p6 -tune ll -b:v 5M -bufsize 5M -maxrate 10M -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 output.mp4

#NVIDIA hardware accelerated convert H.265 > H.264
find . -mount -depth -maxdepth 1 -name '*.mkv' -type f -exec bash -c 'ffmpeg -y -loglevel verbose -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "$0" -f srt -i "${0/.mkv/.en.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -c:v h264_nvenc -preset slow -metadata:s:a:0 language=eng -c:a copy -metadata:s:s:0 language=eng -disposition:s:0 default -c:s:0 srt "./working/${0/x265/x264}"' {} \;
ffmpeg -hwaccel nvdec -i "$f" -movflags faststart -c:v h264_nvenc -c:a copy -c:s copy -crf 23 "${f/(265)/(264)}"


1:1 HWACCEL Transcode without Scaling
The following command reads file input.mp4 and transcodes it to output.mp4 with H.264 video at the same resolution and with the same audio codec.

ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4
1:1 HWACCEL Transcode with Scaling
The following command reads file input.mp4 and transcodes it to output.mp4 with H.264 video at 720p resolution and with the same audio codec. The following command uses the built in resizer in cuvid decoder.

ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda –resize 1280x720 -i input.mp4 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4
There is a built-in cropper in cuvid decoder as well. The following command illustrates the use of cropping. (-crop (top)x(bottom)x(left)x(right))

ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda –crop 16x16x32x32 -i input.mp4 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4
Alternately scale_cuda or scale_npp resize filters could be used as shown below

ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -vf scale_cuda=1280:720 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i input.mp4 -vf scale_npp=1280:720 -c:a copy -c:v h264_nvenc -b:v 5M output.mp4

#Use -vsync 0 option with decode to prevent FFmpeg from creating output YUV with duplicate and extra frames.
ffmpeg -vsync 0 -hwaccel nvdec -i <in file> -map 0 -preset slow -metadata:s:a:0 language=eng -c:v h264_nvenc -c:a copy <out file>
ffmpeg -vsync 0 -hwaccel cuda -i <in file> -map 0 -preset slow -metadata:s:a:0 language=eng -c:v h264_nvenc -c:a copy <out file>
#This one outputs data into special cuda format
ffmpeg -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i <in file> -map 0 -preset slow -metadata:s:a:0 language=eng -c:v h264_nvenc -c:a copy <out file>

ffmpeg -vsync 0 -hwaccel nvdec -y -i <in file> -f srt -i <subtitle.srt> -default_mode infer_no_subs -map 0:v -map 0:a:2 -map 0:a:4 -map 0:a:5 -map 0:a:6 -map 0:a:0 -map 0:a:1 -map 0:a:3 -map 1:0 -profile:v high -pix_fmt yuv420p -preset slow -disposition:a:0 default -disposition:v:0 default -metadata:s:s:0 language=eng -dn -map_chapters -1 -c:v h264_nvenc -c:a copy -c:s srt <out file>

#!!!!! Cuvid is DEPRECATED
ffmpeg -vsync 0 -hwaccel cuvid -y -i <in file> -f srt -i <subtitle.srt> -default_mode infer_no_subs -map 0:v -map 0:a:2 -map 0:a:4 -map 0:a:5 -map 0:a:6 -map 0:a:0 -map 0:a:1 -map 0:a:3 -map 1:0 -profile:v high -pix_fmt yuv420p -preset slow -disposition:a:0 default -disposition:v:0 default -metadata:s:s:0 language=eng -dn -map_chapters -1 -c:v h264_cuvid -c:a copy -c:s srt <out file>

#Command Line for Latency-Tolerant High-Quality Transcoding
1. Slow preset
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i <in file> -c:a copy -c:v h264_nvenc -preset p6 -tune hq -b:v 5M -bufsize 5M -maxrate 10M -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 <out file>

2. Medium preset
Use -preset p4 instead of -preset p6 in the above command line.

3. Fast preset
Use -preset p2 instead of -preset p6 in the above command line.

#Command Line for Low Latency Transcoding
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i <in file> -c:a copy -c:v h264_nvenc -preset p6 -tune ll -b:v 5M -bufsize 5M -maxrate 10M -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 <out file>

ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD HEVC AAC x265).mkv" -c:a copy -c:v h264_nvenc -preset p6 -tune hq -b:v 5M -bufsize 5M -maxrate 10M -extra_hw_frames 2 -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD AVC x264).mkv"

#works
ffmpeg -y -vsync 0 -hwaccel cuda -i "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD HEVC AAC x265).mkv" -c:a copy -c:v h264_nvenc "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD AVC x264).mkv"
ffmpeg -y -vsync 0 -hwaccel cuda -i "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD HEVC AAC x265).mkv" -c:a copy -c:v h264_nvenc -preset p6 -tune hq -b:v 5M -bufsize 5M -maxrate 10M -extra_hw_frames 2 -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 "Formula1 2021 - Round 03 - Portugal Race (1080p SkyF1HD AVC x264)_2.mkv"

# Nvidia HW accelerated H264 10-bit to 8-bit BT709 color
for f in *.mkv; do /usr/bin/ffmpeg-424 -vsync 0 -hwaccel cuda -y -i "$f" -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -vf "colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -metadata:s:a:0 title= -disposition:s 0 -codec:v h264_nvenc -codec:a copy -codec:s copy "/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/${f}"; done
for f in *.mkv; do /usr/bin/ffmpeg-424 -vsync 0 -hwaccel cuda -y -i "$f" -map 0:v:0 -map 0:a:0 -map 0:a:0 -map "0:s:m:language:eng?" -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -vf "colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -metadata:s:a:0 title="AAC / 5.1 / 224k / 48000 Hz" -metadata:s:a:1 title="Dolby Digital (AC3) / 5.1 / 224k / 48000 Hz" -metadata:s:s title= -disposition:a:0 default -disposition:a:1 0 -disposition:s 0 -channel_layout:a:0 "5.1" -ac:0 6 -b:a:0 224k -c:v h264_nvenc -c:a:0 aac -c:a:1 copy -c:s copy "/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/${f}"; done


# Nvidia HW Accelerated H.264 interlaced BT709 > H.264 progressive BT709
ffmpeg -vsync 0 -hwaccel cuda -y -i "BBC.Van.Gogh.Painted.With.Words.1080i.HDTV.MVGroup.mkv" -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -metadata title="BBC.Van.Gogh.Painted.With.Words.1080p.AAC.H264.mkv" -metadata:s:v:0 title= -metadata:s:a:0 title= -vf "yadif=0, colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -b:v 6M -bufsize 6M -minrate 3M -maxrate 10M -profile:v high -pix_fmt yuv420p -preset slow -channel_layout "5.1" -strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a aac -c:s copy "BBC.Van.Gogh.Painted.With.Words.1080p.AAC.H264.mkv"

# For looped Nvidia HW-accelerated h264_nvenc PAL bt601/bt470bg > NTSC transcoding:
# verbose for loop:
for VAR in 01 02 03 04 05 06 07 08 09 10 11 12 13; do ffmpeg -vsync 0 -hwaccel cuda -y -i /media/visualblind/ISOIMAGE/"VTS_$(echo $VAR)_1.VOB" -movflags faststart -map 0:v:0 -map 0:a:0 -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -x264-params "iall=bt601-6-625:fast=1" -color_range 1 -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28 -metadata title="Rainbow Brite (1984) S01E$(echo $VAR)" -metadata:s:a:0 title= -metadata:s:a:0 language=eng -disposition:s 0 -b:v 2500k -minrate 1000k -maxrate 2500k -b:a 128k -codec:v h264_nvenc -channel_layout:a:0 "stereo" -codec:a aac "/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/Rainbow Brite 1984 - S01E$VAR.mp4"; done
# less-verbose for loop:
for VAR in {01..13}; do ffmpeg -vsync 0 -hwaccel cuda -y -i /media/ISOIMAGE/"VTS_$(echo $VAR)_1.VOB" -movflags faststart -map 0:v:0 -map 0:a:0 -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -x264-params "iall=bt601-6-625:fast=1" -color_range 1 -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28 -metadata title="Rainbow Brite (1984) S01E$(echo $VAR)" -metadata:s:a:0 title= -metadata:s:a:0 language=eng -disposition:s 0 -b:v 2500k -minrate 1000k -maxrate 2500k -b:a 128k -codec:v h264_nvenc -channel_layout:a:0 "stereo" -codec:a aac "/tmp/ffmpeg-vcodec/.working/Rainbow Brite 1984 - S01E$VAR.mp4"; done

# For looped ffmpeg NVIDIA HW-Accelerated h264_nvenc PAL bt601/bt470bg > NTSC transcoding
for VAR in {01..13}; do ffmpeg -vsync 0 -hwaccel cuda -y -i \
/media/ISOIMAGE/"VTS_$(echo $VAR)_1.VOB" -movflags faststart \
-map 0:v:0 -map 0:a:0 -dn -map_chapters -1 -profile:v high \
-pix_fmt yuv420p -preset slow -x264-params "iall=bt601-6-625:fast=1" \
-color_range 1 -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28 \
-metadata title="Rainbow Brite (1984) S01E$(echo $VAR)" -metadata:s:a:0 title= \
-metadata:s:a:0 language=eng -disposition:s 0 \
-b:v 2500k -minrate 1000k -maxrate 2500k -b:a 128k \
-codec:v h264_nvenc -channel_layout:a:0 "stereo" -codec:a aac \
"/tmp/ffmpeg-vcodec/.working/Rainbow Brite 1984 - S01E$VAR.mp4"; done

# another variation for different media:
for VAR in {01..10}; do ffmpeg -y -i /tmp/ffmpeg-vcodec/Mayor.Of.Kingstown.S01E01-10.DLMux.1080p.E-AC3-AC3.ITA.ENG.SUBS/"Mayor of Kingstown S01E$(echo $VAR)"*".mkv" -default_mode infer_no_subs -map 0:v:0 -map 0:a:2 -map "0:s:1?" -dn -map_chapters -1 -metadata title="Mayor of Kingstown S01E$(echo $VAR)" -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:a:0 language=eng -c:v copy -channel_layout "5.1" -disposition:a:0 default -c:a aac -c:s copy "/tmp/ffmpeg-vcodec/.working/Mayor of Kingstown - S01E$VAR.mkv"; done

# one-liner: Constant frame-rate with variable bitrate (VBR) nvidia hw-accel transcoding
for f in *.mkv; do ffmpeg -vsync 2 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -colorspace 1 -color_primaries 1 -color_trc 1 -r 24 -b:v 5M -minrate 3M -maxrate 8M -bufsize 10M -profile:v high -pix_fmt yuv420p -preset slow -strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a copy -c:s copy "/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/$f"; done

# multi-lined: Constant frame-rate with variable bitrate (VBR) nvidia hw-accel transcoding
for f in *.mkv; do ffmpeg -vsync 2 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs \
-map 0 -map_chapters -1 -dn -metadata title="${f/.mkv/}" -metadata:s:v:0 title= \
-metadata:s:a:0 title= -colorspace 1 -color_primaries 1 -color_trc 1 -r 24 \
-b:v 5M -minrate 3M -maxrate 8M -bufsize 10M -profile:v high -pix_fmt yuv420p -preset slow \
-strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a copy -c:s copy \
"/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/$f"; done

###########                                                       ###########
###########                      NVIDIA END                       ###########
###########                                                       ###########

#??????????                                                       ???????????
#??????????                  VFR (variable frame-rate)            ???????????
#??????????                                                       ???????????

Frustrated that you hadnt found an answer either, I was going to at least answer other peoples questions about how to enable VFR (not VBR) output from FFMPEG.

The answer to that is the oddly named -vsync option. You can set it to a few different options, but the one you want is "2" or vfr. From the man page:

    -vsync parameter
    Video sync method. For compatibility reasons old values can be specified as numbers. Newly added values will have to be specified as strings always.

        0, passthrough
            Each frame is passed with its timestamp from the demuxer to the muxer.

        1, cfr
            Frames will be duplicated and dropped to achieve exactly the requested constant frame rate.

        2, vfr
            Frames are passed through with their timestamp or dropped so as to prevent 2 frames from having the same timestamp.

        drop
            As passthrough but destroys all timestamps, making the muxer generate fresh timestamps based on frame-rate.

        -1, auto
            Chooses between 1 and 2 depending on muxer capabilities. This is the default method.

    Note that the timestamps may be further modified by the muxer, after this. For example, in the case that the format option avoid_negative_ts is enabled.

With -map you can select from which stream the timestamps should be taken. You can leave either video or audio unchanged and sync the remaining stream(s) to the unchanged one.

However, I dont quite have enough reputation to post a comment to just answer that "sub-question" that everyone seems to be having. But I did have a few ideas that I wasnt honestly very optimistic about... But the first one I tried actually worked. So.

You simply need to combine the -vsync 2 option with the -r $maxfps option, of course where you replace $maxfps with the maximum framerate you want! And it WORKS! It doesnt duplicate frames from a source file, but it will drop frames that cause the file to go over the maximum framerate!

By default it seems that -r $maxfps by itself just causes it to duplicate/drop frames to achieve a constant framerate, and -vsync 2 by itself causes it to pull the frames in directly without really affecting the PTS values.

I wasnt optimistic about this because I already knew that -r $maxfps puts it at a constant framerate. I honestly expected an error or for it to just obey whichever came first or last or whatever. The fact that it does exactly what I wanted makes me quite pleased with the FFMPEG developers.


# INTERNAL MEDIA TERMINOLOGIES:
CFR = Constant Frame Rate
VFR = Variable Frame Rate
CBR = Constant Bit Rate
VBR = Variable Bit Rate


#??????????                                                       ???????????
#??????????                           VFR END                     ???????????
#??????????                                                       ???????????

# Generate thumbnails from video
# Adjust the fps interval to change the number of thumbnails generated
ffmpeg -loglevel verbose -i 'input.mp4' -vf "fps=1/1000" thumb-%02d.jpg

# vsync 1 CFR, cq = 30, avi > mp4
for f in *.avi; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text .working/"${f/.avi/.mp4}"; done

# vsync 2 VFR, cq = 28, avi > mp4
for f in *.avi; do ffmpeg -loglevel verbose -vsync 2 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -r 24 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text .working/"${f/.avi/.mp4}"; done

# vsync 1 CFR, cq = 30, mp4 > mp4
for f in *.mp4; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text .working/"${f/.avi/.mp4}"; done

# vsync 1 CFR of 24fps (-r 24), cq = 28
for f in *.mkv; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -r 24 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -c:a copy -c:s copy /media/visualblind/p1ds0smb/temp/ffmpeg-vcodec/.working/"$f"; done

# vsync 1 CFR, cq = 28, variable bit rate, keep existing frame rate
for f in *.mkv; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "5.1" -c:a aac -c:s copy .working/"${f/x264/AAC51.x264}"; done

# vsync 1 CFR, cq = 23, variable bit rate, keep existing frame rate
for f in *.mkv; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 23 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "5.1" -c:a aac -c:s copy .working/"${f/x264/AAC51.x264}"; done

# stream copy/remux, not changing much except for subtitle deposition and other minor changes
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0 -dn -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -disposition:v:0 default -disposition:a:0 default -disposition:s 0 -c:v copy -c:a copy -c:s copy /media/visualblind/p1ds0smb/temp/ffmpeg-vcodec/.working/"$f"; done

# avi > mp4 transcoding, constant frame rate at 24fps, variable bit rate, cq 28
for f in */**.avi; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -movflags faststart -dn -map_chapters -1 -r 24 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:a:0 language=eng -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -disposition:v:0 default -disposition:a:0 default -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout:a:0 "stereo" -c:a aac -c:s srt /media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working/"${f/avi/mp4}"; done


# With mp4 containers you are required to pay attention to which metadata fields are allowed.
# You cannot create your own metadata fields willie nillie as you can with mkv containers.
# It is safe to stick with the "title" and "comment" fields like so.
# Refer to this page for mp4 metadata field references: https://kdenlive.org/en/project/adding-meta-data-to-mp4-video/

for f in *.avi; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -map 0:v:0 -map 0:a:0 -map "0:s?" -movflags faststart -dn -metadata title= -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata:s:a:0 language=eng -metadata "comment"="cfr vbr vsync 1 cq 30 preset p5 transcoder visualblind" -metadata:s:a:0 title= -metadata:s:a:0 language=eng -disposition:a:0 default -disposition:v:0 default -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac ../.working/"${f/DVDRip.XviD-aAF.avi/480p.AAC.H264.mp4}"; done

# Same as the above but with mkv containers instead
# with the addition of creation_time, ffmpeg_params, and ffmpeg_transcoder metadata fields

for f in *.mkv; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 title= -metadata:s:s:0 title= -metadata:s:a:0 language=eng -metadata:s:v:0 "ffmpeg_params"="cfr vbr vsync 1 cq 23 preset p5" -metadata:s:v:0 "ffmpeg_transcoder"="visualblind" -colorspace 1 -color_primaries 1 -color_trc 1 -pix_fmt yuv420p -disposition:a:0 default -disposition:v:0 default -disposition:s 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 23 -level:v 4.1 -rc vbr -cbr:v false -c:a copy -c:s copy ../.working/"${f/x265/DDP51.H264}"; done


# PROBLEM:
# https://unsplash.com/s/photos/bikini



$ ffmpeg -hide_banner -h encoder=h264_nvenc | xclip -sel clip

Encoder h264_nvenc [NVIDIA NVENC H.264 encoder]:
    General capabilities: dr1 delay hardware 
    Threading capabilities: none
    Supported hardware devices: cuda cuda 
    Supported pixel formats: yuv420p nv12 p010le yuv444p p016le yuv444p16le bgr0 rgb0 cuda
h264_nvenc AVOptions:
  -preset            <int>        E..V....... Set the encoding preset (from 0 to 18) (default p4)
     default         0            E..V....... 
     slow            1            E..V....... hq 2 passes
     medium          2            E..V....... hq 1 pass
     fast            3            E..V....... hp 1 pass
     hp              4            E..V....... 
     hq              5            E..V....... 
     bd              6            E..V....... 
     ll              7            E..V....... low latency
     llhq            8            E..V....... low latency hq
     llhp            9            E..V....... low latency hp
     lossless        10           E..V....... 
     losslesshp      11           E..V....... 
     p1              12           E..V....... fastest (lowest quality)
     p2              13           E..V....... faster (lower quality)
     p3              14           E..V....... fast (low quality)
     p4              15           E..V....... medium (default)
     p5              16           E..V....... slow (good quality)
     p6              17           E..V....... slower (better quality)
     p7              18           E..V....... slowest (best quality)
  -tune              <int>        E..V....... Set the encoding tuning info (from 1 to 4) (default hq)
     hq              1            E..V....... High quality
     ll              2            E..V....... Low latency
     ull             3            E..V....... Ultra low latency
     lossless        4            E..V....... Lossless
  -profile           <int>        E..V....... Set the encoding profile (from 0 to 3) (default main)
     baseline        0            E..V....... 
     main            1            E..V....... 
     high            2            E..V....... 
     high444p        3            E..V....... 
  -level             <int>        E..V....... Set the encoding level restriction (from 0 to 62) (default auto)
     auto            0            E..V....... 
     1               10           E..V....... 
     1.0             10           E..V....... 
     1b              9            E..V....... 
     1.0b            9            E..V....... 
     1.1             11           E..V....... 
     1.2             12           E..V....... 
     1.3             13           E..V....... 
     2               20           E..V....... 
     2.0             20           E..V....... 
     2.1             21           E..V....... 
     2.2             22           E..V....... 
     3               30           E..V....... 
     3.0             30           E..V....... 
     3.1             31           E..V....... 
     3.2             32           E..V....... 
     4               40           E..V....... 
     4.0             40           E..V....... 
     4.1             41           E..V....... 
     4.2             42           E..V....... 
     5               50           E..V....... 
     5.0             50           E..V....... 
     5.1             51           E..V....... 
     5.2             52           E..V....... 
     6.0             60           E..V....... 
     6.1             61           E..V....... 
     6.2             62           E..V....... 
  -rc                <int>        E..V....... Override the preset rate-control (from -1 to INT_MAX) (default -1)
     constqp         0            E..V....... Constant QP mode
     vbr             1            E..V....... Variable bitrate mode
     cbr             2            E..V....... Constant bitrate mode
     vbr_minqp       8388612      E..V....... Variable bitrate mode with MinQP (deprecated)
     ll_2pass_quality 8388616      E..V....... Multi-pass optimized for image quality (deprecated)
     ll_2pass_size   8388624      E..V....... Multi-pass optimized for constant frame size (deprecated)
     vbr_2pass       8388640      E..V....... Multi-pass variable bitrate mode (deprecated)
     cbr_ld_hq       8388616      E..V....... Constant bitrate low delay high quality mode
     cbr_hq          8388624      E..V....... Constant bitrate high quality mode
     vbr_hq          8388640      E..V....... Variable bitrate high quality mode
  -rc-lookahead      <int>        E..V....... Number of frames to look ahead for rate-control (from 0 to INT_MAX) (default 0)
  -surfaces          <int>        E..V....... Number of concurrent surfaces (from 0 to 64) (default 0)
  -cbr               <boolean>    E..V....... Use cbr encoding mode (default false)
  -2pass             <boolean>    E..V....... Use 2pass encoding mode (default auto)
  -gpu               <int>        E..V....... Selects which NVENC capable GPU to use. First GPU is 0, second is 1, and so on. (from -2 to INT_MAX) (default any)
     any             -1           E..V....... Pick the first device available
     list            -2           E..V....... List the available devices
  -delay             <int>        E..V....... Delay frame output by the given amount of frames (from 0 to INT_MAX) (default INT_MAX)
  -no-scenecut       <boolean>    E..V....... When lookahead is enabled, set this to 1 to disable adaptive I-frame insertion at scene cuts (default false)
  -forced-idr        <boolean>    E..V....... If forcing keyframes, force them as IDR frames. (default false)
  -b_adapt           <boolean>    E..V....... When lookahead is enabled, set this to 0 to disable adaptive B-frame decision (default true)
  -spatial-aq        <boolean>    E..V....... set to 1 to enable Spatial AQ (default false)
  -spatial_aq        <boolean>    E..V....... set to 1 to enable Spatial AQ (default false)
  -temporal-aq       <boolean>    E..V....... set to 1 to enable Temporal AQ (default false)
  -temporal_aq       <boolean>    E..V....... set to 1 to enable Temporal AQ (default false)
  -zerolatency       <boolean>    E..V....... Set 1 to indicate zero latency operation (no reordering delay) (default false)
  -nonref_p          <boolean>    E..V....... Set this to 1 to enable automatic insertion of non-reference P-frames (default false)
  -strict_gop        <boolean>    E..V....... Set 1 to minimize GOP-to-GOP rate fluctuations (default false)
  -aq-strength       <int>        E..V....... When Spatial AQ is enabled, this field is used to specify AQ strength. AQ strength scale is from 1 (low) - 15 (aggressive) (from 1 to 15) (default 8)
  -cq                <float>      E..V....... Set target quality level (0 to 51, 0 means automatic) for constant quality mode in VBR rate control (from 0 to 51) (default 0)
  -aud               <boolean>    E..V....... Use access unit delimiters (default false)
  -bluray-compat     <boolean>    E..V....... Bluray compatibility workarounds (default false)
  -init_qpP          <int>        E..V....... Initial QP value for P frame (from -1 to 51) (default -1)
  -init_qpB          <int>        E..V....... Initial QP value for B frame (from -1 to 51) (default -1)
  -init_qpI          <int>        E..V....... Initial QP value for I frame (from -1 to 51) (default -1)
  -qp                <int>        E..V....... Constant quantization parameter rate control method (from -1 to 51) (default -1)
  -weighted_pred     <int>        E..V....... Set 1 to enable weighted prediction (from 0 to 1) (default 0)
  -coder             <int>        E..V....... Coder type (from -1 to 2) (default default)
     default         -1           E..V....... 
     auto            0            E..V....... 
     cabac           1            E..V....... 
     cavlc           2            E..V....... 
     ac              1            E..V....... 
     vlc             2            E..V....... 
  -b_ref_mode        <int>        E..V....... Use B frames as references (from 0 to 2) (default disabled)
     disabled        0            E..V....... B frames will not be used for reference
     each            1            E..V....... Each B frame will be used for reference
     middle          2            E..V....... Only (number of B frames)/2 will be used for reference
  -a53cc             <boolean>    E..V....... Use A53 Closed Captions (if available) (default true)
  -dpb_size          <int>        E..V....... Specifies the DPB size used for encoding (0 means automatic) (from 0 to INT_MAX) (default 0)
  -multipass         <int>        E..V....... Set the multipass encoding (from 0 to 2) (default disabled)
     disabled        0            E..V....... Single Pass
     qres            1            E..V....... Two Pass encoding is enabled where first Pass is quarter resolution
     fullres         2            E..V....... Two Pass encoding is enabled where first Pass is full resolution
  -ldkfs             <int>        E..V....... Low delay key frame scale; Specifies the Scene Change frame size increase allowed in case of single frame VBV and CBR (from 0 to 255) (default 0)



# H264 10-bit to 8-bit BT709 color
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -vf "colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -metadata:s:a:0 title= -codec:v libx264 -codec:a copy -codec:s copy "/mnt/p0ds0smb/temp/ffmpeg-vcodec/.working/${f}"; done

##### Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy only the first subtitle stream
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -c:a copy -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

##### Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy all subtitle streams
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

##### Convert H.265 > H.264 and retain original audio and all subtitles:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -preset slow -c:a copy -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

##### Copy original video stream and convert 6CH AC3 audio to AAC and copy all subtitle streams:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 384k -c:a aac -c:s copy "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

##### Copy original video stream and convert 2CH AC3 audio to AAC and copy all subtitle streams:
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ar 48000 -b:a 384k -c:a aac -c:s copy "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

##### Just strip all subtitles:
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -c:v copy -c:a copy "${0/ (2000)/}"' {} \;; find . -name '*(2000)*' -type f -delete

##### Futurama Season 7 custom, 2-3 AC3 audio streams with the first having 6-channel and between 1-2 AC3 2-channel commentary tracks, a non-standard hdmv_pgs_subtitle subtitle track ususally at stream 0:3 requiring dropping and replacement with external .srt file
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -f srt -i "${0/mkv/en.srt}" -map 0:v:0 -map 0:a:0 -map 0:a:1 -map 0:a:2? -map 1:0 -c:v copy -ac:0 6 -ac:1 2 -ac:2 2 -ar 48000 -c:a:0 aac -c:a:1 aac -c:a:2 aac -c:s srt ./working/"${0/DD5.1/AAC5.1}"' {} \;

##### Increase volume to 150% of original media
for f in *.mkv; do ffmpeg -i "$f" -map 0 -filter:a "volume=1.5" -c:v copy -c:a aac -c:s copy "../working/$f"; done

for f in /path/to/directory/*.mkv; do ffmpeg -i "$f" \
-map 0 -filter:a "volume=2.0" -c:v copy -c:a aac -c:s copy \
"/path/to/directory/.working/$(basename "$f")"; done

ffmpeg -i input.mp4 -map 0 -filter:a "volume=1.5" -c:v copy -c:a aac -c:s copy output.mp4

##### Remove data stream from MP4 container
1a) ffmpeg -i in.mp4 -c copy -dn -map_metadata:c -1 out.mp4
1b) for f in *.mp4; do ffmpeg -i "$f" -c copy -dn -map_metadata:c -1 "$f"; done

##### Remove chapters from the container
1a) ffmpeg -i input.mp4 -map 0:v -map 0:a -c:v copy -c:a copy -map_chapters -1 output.mp4
1b) for f in *.mp4; do ffmpeg -i "$f" -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -map_chapters -1 "$f"; done

##### Remove closed captions (CC)
1a) ffmpeg -y -i input.mkv -map 0 -c copy -bsf:v "filter_units=remove_types=6" output.mkv
1b) for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -bsf:v "filter_units=remove_types=6" "./.working/${f}"; done

##### Insert srt subtitle to mp4
ffmpeg -i 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264.mp4' -i 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264.en.srt' -metadata:s:s:0 language=eng -c:v copy -c:a copy -c:s mov_text 'I Am Legend (2007) - ALTERNATE ENDING 1080p BrRip x264_2.mp4'

##### Exports clean Subrip/srt subtitle file without annoying <font-face=blah; font-size=18px;> HTML tagging - Extract subtitle from mp4 (and mkv, maybe?) file in Subrip/srt format (Subtitle codec name "text" instead of srt/mov_text)
for f in *.mp4; do ffmpeg -y -i "$f" -map 0:s? -c:s text "${f/.mp4/.en.srt}"; done

##### Find directories with more than one media file
find . -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -printf '%h\n' | sort | uniq -d

##### Convert interlaced to progressive (1080i -> 1080p)
ffmpeg -i '/media/file1.mkv' -vf yadif -c:v libx264 -preset slow -crf 19 -c:a aac -b:a 192k -c:s srt -max_muxing_queue_size 400 /media/file2.mkv
ffmpeg -i "interlaced.mkv" -vf yadif=1 -movflags +faststart -y -preset fast -profile:v high -crf 20 -ac 2 -b:a 192k -strict experimental -c:v libx264 -c:a aac "progressive.mkv"
# yadif=0 is normally the preferred option when deinterlacing video as yadif=1 will double the frame-rate of the output video
ffmpeg -i "interlaced.mkv" -vf yadif=0 -y -preset fast -profile:v high -crf 20 -ac 2 -b:a 192k -strict experimental -c:v libx264 -c:a aac "progressive.mkv"

# H.264 interlaced BT709 > H.264 progressive BT709
ffmpeg -i "BBC.Van.Gogh.Painted.With.Words.1080i.HDTV.MVGroup.mkv" -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -metadata title="BBC.Van.Gogh.Painted.With.Words.1080p.HDTV.mkv" -metadata:s:v:0 title= -metadata:s:a:0 title= -vf "yadif=0, colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -b:v 6M -bufsize 6M -minrate 3M -maxrate 10M -profile:v high -pix_fmt yuv420p -preset slow -channel_layout "5.1" -strict experimental -max_muxing_queue_size 400 -c:v libx264 -c:a aac -c:s copy "BBC.Van.Gogh.Painted.With.Words.1080p.HDTV.mkv"


################### ASPECT RATIO ###################
# Sample Aspect Ratio (SAR) and Display Aspect Ratio (DAR)

##### Change Display Aspect Ratio (DAR)
ffmpeg -i input.mp4 -map 0 -aspect 1:1 -codec copy output.mp4

ffmpeg -i input.mkv -map 0 -dn -map_chapters -1 -aspect 2.39 -codec copy output.mkv

for f in *.avi; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -movflags faststart -dn -map_chapters -1 -r 24 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:a:0 language=eng -metadata date="$(date --iso-8601=seconds)" -aspect 1:1 -pix_fmt yuv420p -disposition:v:0 default -disposition:a:0 default -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout:a:0 "stereo" -c:a aac /media/visualblind/p3ds0smb/temp/ffmpeg-vcodec/.working/"${f/avi/mp4}"; done

Display aspect ratio                     : 2.40:1
Original display aspect ratio            : 16:9

The first pair of SAR/DAR youll note is in square brackets and comes from the video stream. The second pair is not in square brackets and comes from the container. Use -aspect to set the DAR in the container and -bsf:v h264_metadata=sample_aspect_ratio=x/y to set the SAR in the video stream

Changing the SAR without reencoding also works with ffmpeg on .mp4 using the h264_metadata

ffmpeg -i in.mp4 -c copy -bsf:v "h264_metadata=sample_aspect_ratio=4/3" out.mp4

# Change the DAR in the container
ffmpeg -i in.mp4 -map 0 -aspect 1:1 -codec copy out.mp4

# Change the SAR in the video stream
ffmpeg -i in.mp4 -c copy -bsf:v "h264_metadata=sample_aspect_ratio=4/3" out.mp4


################### /ASPECT RATIO ###################


##### Increase max muxing queue size
ffmpeg -i 'input.mkv' -max_muxing_queue_size 400 'output.mkv'

##### Remove subtitle and audio description/title and add english metadata
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata:s:a:0 language=eng -metadata:s:a:0 title= -metadata:s:s:0 language=eng -metadata:s:s:0 title= ./working/"${f}"; done

##### Add text metadata to various sections of file
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" ./working/"${f}"; done
ffmpeg -y -i input.mkv -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" output.mkv

##### Add Matroska Title metadata to the container while removing Title metadata from all of its streams (video, audio, subtitle)
ffmpeg -y -i input.mkv -f srt -i input.en.srt -map 0:v -map 0:a:1 -map 1:0 -movflags +faststart -metadata:s:v:0 language= -metadata:s:s:0 language=eng -metadata:s:v:0 Title= -metadata:s:a:0 Title= -metadata:s:s:0 Title= -metadata Title="Who Am I (1998)" -disposition 0 -disposition:s:1 default -c:v copy -c:a copy -c:s srt output.mkv

##### Transcode avi files into standard mp4 containers
for f in **/*.avi; do ffmpeg -i "$f" -map 0:v:0 -map 0:a -dn -map_chapters -1 \
-movflags faststart -profile:v high -pix_fmt yuv420p -metadata:s:a:0 language=eng \
-metadata:s:v:0 title= -metadata:s:a:0 title= -c:v libx264 -c:a aac \
"../.working/${f/.avi/.mp4}"; done


#################### Methods of Reducing file size with FFmpeg ####################
# https://trac.ffmpeg.org/wiki/EncodingForStreamingSites

##### Modify the bitrate, using:
ffmpeg -i $infile -b $bitrate $newoutfile

##### Vary the Constant Rate Factor, using:
ffmpeg -i $infile -vcodec libx264 -crf 23 $outfile

##### Change/scale the video screen-size (for example to 1080p or half its pixel size):

ffmpeg -i $infile -vf "scale=iw/2:ih/2" $outfile

# This method takes care of error: (libx264) "height not divisible by 2"
# https://stackoverflow.com/questions/20847674/ffmpeg-libx264-height-not-divisible-by-2
# https://superuser.com/questions/624563/how-to-resize-a-video-to-make-it-smaller-with-ffmpeg
ffmpeg -y -i "input.mp4" \
-map 0:v -map 0:a -dn -map_chapters -1 -filter:v scale="1920:trunc(ow/a/2)*2" \
-movflags faststart -profile:v high -pix_fmt yuv420p -metadata:s:a:0 language=eng \
-c:v libx264 -c:a copy "output.mp4"

##### Another one but different
ffmpeg -y -i "input.mp4" -map 0:v -map 0:a \
-dn -map_chapters -1 -metadata:s:v:0 handler_name= -metadata:s:a:0 handler_name= \
-vf pad=ceil(iw/2)*2:ceil(ih/2)*2 -movflags faststart -profile:v high -pix_fmt yuv420p \
-metadata:s:a:0 language=eng -c:v libx264 -c:a copy "output.mp4"


##### Change the H.264 profile to "baseline", using:
ffmpeg -i $infile -profile:v baseline $outfile
Use the default ffmpeg processing, using:
ffmpeg -i $infile $outfile

##### Bitrate Guidelines:
# Calculate the bitrate you need by dividing your target size (in bits) by the video length (in seconds). For example for a target size of 1 GB (one giga<em>byte</em>, which is 8 giga<em>bits</em>) and 10,000 seconds of video (2 h 46 min 40 s), use a bitrate of 800 000 bit/s (800 kbit/s):
ffmpeg -i input.mp4 -b 800k output.mp4

##### example 1:
# ffmpeg -i input.mkv -c:v libx264 -preset medium -b:v 3000k -maxrate 3000k -bufsize 6000k \
# -vf "scale=1280:-1,format=yuv420p" -g 50 -c:a aac -b:a 128k -ac 2 -ar 44100 file.flv
#
###################################################################################

##### Concatenation https://trac.ffmpeg.org/wiki/Concatenate
for f in ./*.mkv; do echo "file '$f'" >> mylist.txt; done

##### Note that these can be either relative or absolute paths. Then you can stream copy or re-encode your files:
ffmpeg -f concat -safe 0 -i "mylist.txt" "output.mkv"

##### Concatenate multiple media files
for f in ./*.mkv; do echo "file '$f'" >> mylist.txt; done
ffmpeg -f concat -safe 0 -i "mylist.txt" -b 4292k -c copy "Top.Gear.Patagonia.Special.1080p.mkv"

##### Map only English audio stream and English subtitle streams if it exists
for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:m:language:eng -map 0:s:m:language:eng? -codec:v copy -codec:a copy -codec:s srt "../../../../temp/ffmpeg-vcodec/.working/${f/x265/x264}"; done

##### Dont set any subtitle streams as default or forced
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -map 0:s:m:language:eng? -disposition:s 0 -codec copy "$f"; done

-default_mode
This option controls how the FlagDefault of the output tracks will be set. It influences which tracks players should play by default. The default mode is ‘infer’.
'infer'
In this mode, for each type of track (audio, video or subtitle), if there is a track with disposition default of this type, then the first such track (i.e. the one with the lowest index) will be marked as default; if no such track exists, the first track of this type will be marked as default instead (if existing). This ensures that the default flag is set in a sensible way even if the input originated from containers that lack the concept of default tracks.
'infer_no_subs'
This mode is the same as infer except that if no subtitle track with disposition default exists, no subtitle track will be marked as default.
'passthrough'
In this mode the FlagDefault is set if and only if the AV_DISPOSITION_DEFAULT flag is set in the disposition of the corresponding stream.


##### Sync multiple audios streams
for f in *.mkv; do ffmpeg -y -i "${f}" -i "${f/.mkv/.m4a}" \
-c:v copy -b:a:0 128k -filter_complex "[a:0]aresample=async=1000[a:0]" -movflags faststart -c:a:0 aac -c:a:1 copy -c:s copy \
-map 0:v:0 -map 1:0 -map 0:a:0 $(i=1; while [ $i -lt 28 ]; do echo -n "-map 0:s:$((i++)) "; done) \
-metadata:s:a:0 language=eng -disposition 0 -disposition:a:0 default -disposition:s:0 default -metadata:s:s:0 title= \
-metadata:s:a comment= -shortest "${f/.NF.WEB-DL.AAC5.1.x264-NTG.mkv/.ENG-SPA.WEB-DL.AAC5.1.x264.mkv}"; done


##### Insert arbitrary audio stream and alter the starttime offset with '-itsoffset' paramter.
ffmpeg -y -i 'Spider-Man.No.Way.Home.2021.HDTC.1080P.4GB.H264.CLEAR.AUDIO.AAC-DH18.mkv' -itsoffset -500ms \
-f aac -i 'Spider-Man.No.Way.Home.2021.720p.HDTC.(V3).x264.AAC.B4ND1T69.aac' -map 0:v -map 1:0 -map 0:a:0 \
-metadata title='Spider-Man: No Way Home (2021)' -metadata:s:a:0 title=B4ND1T69rip -map_metadata -1 -map_chapters -1 \
-disposition:a:0 default -disposition:a:1 0 -metadata:s:a:0 language=eng -metadata:s:a:1 language=eng \
-fflags +bitexact -flags:v +bitexact -flags:a +bitexact -ac 2 -c:v copy -c:a:0 aac -c:a:1 copy \
'Spider-Man.No.Way.Home.2021.HDTC.1080p.H264.CLEAREST.DUAL-AAC2.0-TFLX.mkv'

##### ffprobe #####

##### Output filename, audio codec name, and number of channels
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \;

##### Output filename, and video codecs
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \;

##### Output filename and video bit depth
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;





############################                  ############################
############################ FFmpeg Filtering ############################
############################                  ############################


Filtering in FFmpeg is enabled through the libavfilter library
In libavfilter, a filter can have multiple inputs and multiple outputs. To illustrate the sorts of things that are possible, we consider the following filtergraph. 
                [main]
input --> split ---------------------> overlay --> output
            |                             ^
            |[tmp]                  [flip]|
            +-----> crop --> vflip -------+

ffmpeg -i INPUT -vf "split [main][tmp]; [tmp] crop=iw:ih/2:0:0, vflip [flip]; [main][flip] overlay=0:H/2" OUTPUT


The result will be that the top half of the video is mirrored onto the bottom half of the output video.

Filters in the same linear chain are separated by commas, and distinct linear chains of filters are separated by semicolons. In our example, crop,vflip are in one linear chain, split and overlay are separately in another. The points where the linear chains join are labelled by names enclosed in square brackets. In the example, the split filter generates two outputs that are associated to the labels [main] and [tmp].

The stream sent to the second output of split, labelled as [tmp], is processed through the crop filter, which crops away the lower half part of the video, and then vertically flipped. The overlay filter takes in input the first unchanged output of the split filter (which was labelled as [main]), and overlay on its lower half the output generated by the crop,vflip filterchain.

Some filters take in input a list of parameters: they are specified after the filter name and an equal sign, and are separated from each other by a colon.

There exist so-called source filters that do not have an audio/video input, and sink filters that will not have audio/video output.             


11.40 colormatrix

Convert color matrix.

The filter accepts the following options:

src
dst

    Specify the source and destination color matrix. Both values must be specified.

    The accepted values are:

    ‘bt709’

        BT.709
    ‘fcc’

        FCC
    ‘bt601’

        BT.601
    ‘bt470’

        BT.470
    ‘bt470bg’

        BT.470BG
    ‘smpte170m’

        SMPTE-170M
    ‘smpte240m’

        SMPTE-240M
    ‘bt2020’

        BT.2020 

For example to convert from BT.601 to SMPTE-240M, use the command:

colormatrix=bt601:smpte240m

11.41 colorspace

Convert colorspace, transfer characteristics or color primaries. Input video needs to have an even size.

The filter accepts the following options:

all

    Specify all color properties at once.

    The accepted values are:

    ‘bt470m’

        BT.470M
    ‘bt470bg’

        BT.470BG
    ‘bt601-6-525’

        BT.601-6 525
    ‘bt601-6-625’

        BT.601-6 625
    ‘bt709’

        BT.709
    ‘smpte170m’

        SMPTE-170M
    ‘smpte240m’

        SMPTE-240M
    ‘bt2020’

        BT.2020

space

    Specify output colorspace.

    The accepted values are:

    ‘bt709’

        BT.709
    ‘fcc’

        FCC
    ‘bt470bg’

        BT.470BG or BT.601-6 625
    ‘smpte170m’

        SMPTE-170M or BT.601-6 525
    ‘smpte240m’

        SMPTE-240M
    ‘ycgco’

        YCgCo
    ‘bt2020ncl’

        BT.2020 with non-constant luminance

trc

    Specify output transfer characteristics.

    The accepted values are:

    ‘bt709’

        BT.709
    ‘bt470m’

        BT.470M
    ‘bt470bg’

        BT.470BG
    ‘gamma22’

        Constant gamma of 2.2
    ‘gamma28’

        Constant gamma of 2.8
    ‘smpte170m’

        SMPTE-170M, BT.601-6 625 or BT.601-6 525
    ‘smpte240m’

        SMPTE-240M
    ‘srgb’

        SRGB
    ‘iec61966-2-1’

        iec61966-2-1
    ‘iec61966-2-4’

        iec61966-2-4
    ‘xvycc’

        xvycc
    ‘bt2020-10’

        BT.2020 for 10-bits content
    ‘bt2020-12’

        BT.2020 for 12-bits content

primaries

    Specify output color primaries.

    The accepted values are:

    ‘bt709’

        BT.709
    ‘bt470m’

        BT.470M
    ‘bt470bg’

        BT.470BG or BT.601-6 625
    ‘smpte170m’

        SMPTE-170M or BT.601-6 525
    ‘smpte240m’

        SMPTE-240M
    ‘film’

        film
    ‘smpte431’

        SMPTE-431
    ‘smpte432’

        SMPTE-432
    ‘bt2020’

        BT.2020
    ‘jedec-p22’

        JEDEC P22 phosphors

range

    Specify output color range.

    The accepted values are:

    ‘tv’

        TV (restricted) range
    ‘mpeg’

        MPEG (restricted) range
    ‘pc’

        PC (full) range
    ‘jpeg’

        JPEG (full) range

format

    Specify output color format.

    The accepted values are:

    ‘yuv420p’

        YUV 4:2:0 planar 8-bits
    ‘yuv420p10’

        YUV 4:2:0 planar 10-bits
    ‘yuv420p12’

        YUV 4:2:0 planar 12-bits
    ‘yuv422p’

        YUV 4:2:2 planar 8-bits
    ‘yuv422p10’

        YUV 4:2:2 planar 10-bits
    ‘yuv422p12’

        YUV 4:2:2 planar 12-bits
    ‘yuv444p’

        YUV 4:4:4 planar 8-bits
    ‘yuv444p10’

        YUV 4:4:4 planar 10-bits
    ‘yuv444p12’

        YUV 4:4:4 planar 12-bits

fast

    Do a fast conversion, which skips gamma/primary correction. This will take significantly less CPU, but will be mathematically incorrect. To get output compatible with that produced by the colormatrix filter, use fast=1.
dither

    Specify dithering mode.

    The accepted values are:

    ‘none’

        No dithering
    ‘fsb’

        Floyd-Steinberg dithering 

wpadapt

    Whitepoint adaptation mode.

    The accepted values are:

    ‘bradford’

        Bradford whitepoint adaptation
    ‘vonkries’

        von Kries whitepoint adaptation
    ‘identity’

        identity whitepoint adaptation (i.e. no whitepoint adaptation) 

iall

    Override all input properties at once. Same accepted values as all.
ispace

    Override input colorspace. Same accepted values as space.
iprimaries

    Override input color primaries. Same accepted values as primaries.
itrc

    Override input transfer characteristics. Same accepted values as trc.
irange

    Override input color range. Same accepted values as range.

The filter converts the transfer characteristics, color space and color primaries to the specified user values. The output value, if not specified, is set to a default value based on the "all" property. If that property is also not specified, the filter will log an error. The output color range and format default to the same value as the input color range and format. The input transfer characteristics, color space, color primaries and color range should be set on the input data. If any of these are missing, the filter will log an error and no conversion will take place.

For example to convert the input to SMPTE-240M, use the command:

colorspace=smpte240m






############################                      ############################
############################ END FFmpeg Filtering ############################
############################                      ############################




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

##### MKV
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

##### MP4
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

##### MP4 in current dir
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

##### MKV and MP4
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

##### Nvidia hardware acceleration
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

##### H.264/AAC/SRT
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

##### HEVC > AVC (libx264)
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working'
shopt -s globstar
for f in *.mkv; do
  VFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
if ! [[ "${VFORMAT[0]}" == 'avc' ]]; then
  echo -e '\n---> '$(basename "$f")': detected '${VFORMAT[0]}' in the default video stream\n---> Preparing to convert video codec accelerated with h264_nvenc (nVidia) to H264...\n\n'
  NEWNAME="${f/x265/x264}"
  ffmpeg -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a:0 -map "0:s?" -disposition:v:0 default -disposition:a:0 default -map_chapters -1 -dn -map_metadata -1 -bsf:v "filter_units=remove_types=6" -preset slow -profile:v high -pix_fmt yuv420p -c:v libx264 -metadata:s:a:0 language=eng -c:a copy -c:s copy "$TEMPDIR/$NEWNAME" || break
  echo -e '\n---> Moving '$(basename "$f")' back to source directory name '$(pwd)'\n'
  mv -ufv "$TEMPDIR/$NEWNAME" "$(dirname "$f")"
fi
done

##### HEVC > AVC (h264_nvenc) NVIDIA Accelerated
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working'
shopt -s globstar
for f in *.mkv; do
  VFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
if ! [[ "${VFORMAT[0]}" == 'avc' ]]; then
  echo -e '\n---> '$(basename "$f")': detected '${VFORMAT[0]}' in the default video stream\n---> Preparing to convert video codec accelerated with h264_nvenc (nVidia) to H264...\n\n'
  NEWNAME="${f/x265/x264}"
  /usr/bin/ffmpeg-424 -vsync 0 -hwaccel cuda -i "$f" -map 0:v:0 -map 0:a:0 -map "0:s?" -disposition:v:0 default -disposition:a:0 default -map_chapters -1 -dn -map_metadata -1 -bsf:v "filter_units=remove_types=6" -preset slow -profile:v high -pix_fmt yuv420p -c:v h264_nvenc -metadata:s:a:0 language=eng -c:a copy -c:s copy "$TEMPDIR/$NEWNAME" || break
  echo -e '\n---> Moving '$(basename "$f")' back to source directory name '$(pwd)'\n'
  mv -ufv "$TEMPDIR/$NEWNAME" "$(dirname "$f")"
fi
done

##### HEVC > AVC (h264_nvenc) NVIDIA Accelerated + External Subtitle
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working'
shopt -s globstar
for f in *.mkv; do
  VFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
if ! [[ "${VFORMAT[0]}" == 'avc' ]]; then
  echo -e '\n---> '$(basename "$f")': detected '${VFORMAT[0]}' in the default video stream\n---> Preparing to convert video codec accelerated with h264_nvenc (nVidia) to H264...\n\n'
  NEWNAME="${f/x265/x264}"
  /usr/bin/ffmpeg-424 -vsync 0 -hwaccel cuda -i "$f" -f srt -i "./Subs/${f/mkv/en.srt}" -map 0:v:0 -map 0:a:m:language:eng -map 1:0 -disposition:v:0 default -disposition:a:0 default -disposition:s:0 0 -map_chapters -1 -dn -bsf:v "filter_units=remove_types=6" -preset slow -profile:v high -pix_fmt yuv420p -c:v h264_nvenc -metadata:s:a:0 language=eng -metadata:s:s:0 language=eng -c:a copy -c:s srt "$TEMPDIR/$NEWNAME" || break
  echo -e '\n---> Moving '$(basename "$f")' back to source directory name '$(pwd)'\n'
  mv -ufv "$TEMPDIR/$NEWNAME" "$(dirname "$f")"
fi
done

##### HEVC > AVC (h264_nvenc) NVIDIA Accelerated - NO Subtitles
TEMPDIR='/media/visualblind/p0ds0smb/temp/ffmpeg-vcodec/.working'
shopt -s globstar
for f in *.mkv; do
  VFORMAT=($(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f"))
if ! [[ "${VFORMAT[0]}" == 'avc' ]]; then
  echo -e '\n---> '$(basename "$f")': detected '${VFORMAT[0]}' in the default video stream\n---> Preparing to convert video codec accelerated with h264_nvenc (nVidia) to H264...\n\n'
  NEWNAME="${f/x265/x264}"
  /usr/bin/ffmpeg-424 -vsync 0 -hwaccel cuda -i "$f" -map 0:v:0 -map 0:a:m:language:eng -disposition:v:0 default -disposition:a:0 default -map_chapters -1 -dn -bsf:v "filter_units=remove_types=6" -preset slow -profile:v high -pix_fmt yuv420p -c:v h264_nvenc -metadata:s:a:0 language=eng -c:a copy "$TEMPDIR/$NEWNAME" || break
  echo -e '\n---> Moving '$(basename "$f")' back to source directory name '$(pwd)'\n'
  mv -ufv "$TEMPDIR/$NEWNAME" "$(dirname "$f")"
fi
done

