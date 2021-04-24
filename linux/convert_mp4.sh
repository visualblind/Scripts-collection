#! /bin/bash

# Replace spaces with underscores. This is required for bash compatibility.
for file in *;
do
    mv "$file" `echo $file | tr ' ' '_'` ;
done

# Convert AVI and MKV files to H264/AAC MP4 files.
for i in *.avi *.mkv;
do
    ffmpeg -i $i -vcodec h264 -acodec aac $i.mp4;
done

# Move old files.
mkdir original
mv *.avi original/
mv *.mkv original/