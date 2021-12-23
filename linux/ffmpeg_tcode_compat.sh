#!/usr/bin/env bash
#
# DESC:     Transcode with ffmpeg the audio codecs of commonly used video media files 
#           within specified directory. The original source files will be overwritten.
# AUTHOR:   Travis Runyard
# DATE:     04-18-2020
# UPDATED:  09-18-2021
# WEB:      quad0.com/ffmpeg-batch-transcode-audio/

# Exit script on any non-zero exit code
set -e

# Shell Options
shopt -s globstar
shopt -u nullglob

# Declare indexed arrays (optional/only associative arrays require declaration)
declare -a FILENAME
declare -a LOG

# Modify TEMPDIR and WORKDIR to suit your needs
TEMPDIR="/mnt/pool0/p0ds0smb/temp/ffmpeg"
WORKDIR="$TEMPDIR/.working"
SCRIPT_NAME="$(basename "$0")"

usage()
{
  cat 1>&2 <<EOF
Usage: $SCRIPT_NAME [options]

 -h | --help        Help shows this message.
 -d | --directory   Specify the directory to process.
 -w | --workdir     Writable working directory for FFmpeg.
                    If you don't specify this option, the
                    subdirectory named "working" will be used
                    within the --directory path or \$TEMPDIR.
EOF
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )	shift
                                TEMPDIR="${1:-$TEMPDIR}"
                                WORKDIR="$WORKDIR"
                                ;;
        -w | --workdir )	shift
                                WORKDIR="${1:-$WORKDIR}"
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

cd $TEMPDIR
echo -e "*** DEBUG ***\n\$TEMPDIR = $TEMPDIR\n\$WORKDIR = $WORKDIR"
[ -d "$WORKDIR" ] || mkdir "$WORKDIR"
# Set field separator to newline
OIFS="$IFS"
IFS=$'\n'
FILENAME=($(find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print))
if [ -n "$FILENAME" ]; then
    for f in "${FILENAME[@]}"; do
    LOG+=("$f")
    AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
  	if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
        # Build ffmpeg array within the loop to populate variables
        args=(
        -nostdin
        -y
        -i "$f"
        -default_mode infer_no_subs
        -map 0:v:0
        -map 0:a
        -map "0:s:m:language:eng?"
        -map "0:s:m:language:ger?"
        -map "0:s:m:language:spa?"
        -map "0:s:m:language:fre?"
        -map "0:s:m:language:ita?"
        -map "0:s:m:language:jpn?"
        -map "0:s:m:language:kor?"
        -map "0:s:m:language:por?"
        -map "0:s:m:language:vie?"
        -map "0:s:m:language:chi?"
        -ac "${AUDIOFORMAT[1]}"
        -ar 48000
        -metadata:s:a:0 language=eng
        -metadata:s:a:0 title=
        -map_chapters -1
        -dn
        -bsf:v "filter_units=remove_types=6"
        -movflags faststart
        -c:v copy
        -c:a aac
        -c:s copy
        "$WORKDIR/$(basename "$f")"
        )
      echo -e "*** DEBUG: ffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream with '${AUDIOFORMAT[1]}' channels\nPreparing to convert audio codec to AAC..." ; sleep 1
      echo -e "*** DEBUG: ffmpeg ${args[@]}"
      ffmpeg "${args[@]}" || break
      echo -e "*** DEBUG: Moving '$WORKDIR/$(basename "$f")' back to source directory name '$(dirname "$f")'"; sleep 1
      mv -f -v "$WORKDIR/$(basename "$f")" "$(dirname "$f")" || break
    fi
    done
  printf '*** DEBUG ***\nPROCESSED:%s\n'
  for i in "${LOG[@]}"; do echo "$i"; done
else
  echo -e "*** DEBUG: No files to process"
fi
