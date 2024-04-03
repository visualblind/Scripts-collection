#!/usr/bin/env bash

# find-regex.sh

sudo find . -regex -type f ! -name "*.mp4|*.mkv" 
sudo find . -regex -type f ! -name "*.mp4|*.mkv" 
sudo find . -regex -type f ! -name '{ *.mp4|*.mkv" }'
sudo find . -regex -type f ! -name '{ *.mp4|*.mkv }'
sudo find . -regex -type f ! -name '{*.mp4|*.mkv}'
sudo find . -regex -type f ! -name '{*.mp4|*.mkv}'
sudo find . -regex -type f ! -path '{*.mp4|*.mkv}'
sudo find . -regex -type f ! -name '{*.mp4|*.mkv}'
sudo find . -regex -type f ! -name '(*.mp4|*.mkv)'
sudo find ./ -regex -type f ! -name '(*.mp4|*.mkv)'
sudo find * -regex -type f ! -name '(*.mp4|*.mkv)'
sudo find . -regex ! -type f -name '(*.mp4|*.mkv)'
find . -regex -name 'Season\ [07-10]'
find ./ -regex -name 'Season\ [07-10]'
find . -name 'Season\ [07-10]' -regex
find . -regex 'Season\ [07-10]'
find . -regex 'Season [07-10]'
find . -regex 'Season \[07-10\]'
find . -regex 'Season \[07\-10\]'
find . -type d -regex 'Season \[07-10\]'
find . -type d -regex 'Season \[07\-10\]'
find . -type d -regex 'Season [07-10]'
find . -type d -regex 'Season\ [07-10]'
find . -type d -regex 'Season\ [07\-10]'
find . -type d -regex 'Season\ \[07-10\]'
find . -type d -regex 'Season\ \[07\-10\]'
find . -type d -regex 'Season\ \[07\]'
find . -type d -regex 'Season\ [07]'
find . -type d -regex 'Season [07]'
find . -type d -regex 'Season 07'
find ./* -type d -regex 'Season 07'
find ./* -type d -regex '*07'
sudo find . -type d -regex '*[07-10]'
sudo find . -type d -regex '*[07-10]{2}'
sudo find . -type d -regex './*[07-10]{2}'
sudo find . -type d -regex './*[07-10]'
sudo find . -type d -regex './*[7-10]'
sudo find . -type d -regex './*[07-10]'
sudo find . -type d -regex './[07-10]'
sudo find . -type d -regex '.[07-10]'
sudo find . -type d -regex '.*[07-10]'
sudo find . -type d -regex '.*[7-10]'
sudo find . -type d -regex '.*[7-9]{2}'
find . -type f -regextype sed -regex ".*/\.[mkv|mp4|mpg|mpeg|avi]$"
find . -type f -regextype sed -regex ".*/\.[mkv|mp4|mpg|mpeg|avi]"
find . -type f -regextype sed -regex ".*/\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*/.*"
find . -type f -regextype sed -regex ".*\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".\/\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".\/*\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".\/*.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*\/*.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex "*.*\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regex "*.*\.(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regex ".*/(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regex ".*/.*(mkv|mp4|mpg|mpeg|avi)"
find . -type f --regextype sed -regex ".*/.*(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*/.*(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*/*(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*(mkv|mp4|mpg|mpeg|avi)"
find . -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"
find . -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find . -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg]"|wc -l
find . -regextype posix-egrep -regex '\./[a-f0-9\]{9}\.zip'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{9}\.zip'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{9,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\]{9,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\]{9,,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\]{1,}\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9\]{1,}\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9\]{1}*\.zip'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{5}*\.zip/I'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{5}*\.zip'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{5,}*\.zip'
find . -regextype posix-egrep -regex '\./[a-z0-9\]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9-_\]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\-_\]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9\-\_\]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-zA-Z0-9]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[A-Z0-9]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9]{5,}\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9]{5,}\.zip/I'
find . -regextype posix-egrep -regex '\./[a-Z0-9]{5,}\.avi'
find . -regextype posix-egrep -regex '\./[a-Z0-9]{5,}\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]{5,}\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]{10,}\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]{1,}\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]{1}\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]{1}*\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]*\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]*\.g'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]*\.g*'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-]*\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-_]*\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_]*\.zip'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_]*\.avi'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_]*\.gz'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_]*\.mp4'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_].*\.mp4'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_]{5,}.*\.mp4'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_\ ]{5,}.*\.mp4'
find . -regextype posix-egrep -regex '\./[a-Z0-9\-\_\ ]{5,}.*\.gz'
find ~/mnt/pool0/p0ds0smb/video-shows -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find . -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find video-shows -mindepth 2 -maxdepth 3 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find video-shows -mindepth 1 -maxdepth 4 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find ../video-movies -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find ../video-movies -mindepth 2 -maxdepth 3 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find ../video-movies -mindepth 2 -maxdepth 3 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|less
find ../video-movies -mindepth 2 -maxdepth 3 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|wc -l
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]" -printf '%f\n'|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*.[mkv|mp4|mpg|mpeg|avi]" -printf '%f\n'|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]" -printf '%f\n'|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "[mkv|mp4|mpg|mpeg|avi]" -printf '%f\n'|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*.[mkv|mp4|mpg|mpeg|avi]" -printf '%f\n'|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]$" -printf '%f\n'|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]$" -print|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])$" -print|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])$" -printf '%f\n'|sort|grep 'jpg'
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])$" -printf '%f\n'|sort|less
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])$" -printf '%f\n'|sort
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])" -printf '%f\n'|sort
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*.([mkv|mp4|mpg|mpeg|avi])" -printf '%f\n'|sort
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "\.*([mkv|mp4|mpg|mpeg|avi])" -printf '%f\n'|sort
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*([mkv|mp4|mpg|mpeg|avi])" -printf '%f\n'|sort
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*([mkv|mp4|mpg|mpeg|avi])" -printf "%f\n"
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*([mkv|mp4|mpg|mpeg|avi])" -print "%f\n"
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "*([mkv|mp4|mpg|mpeg|avi])" -print
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*([mkv|mp4|mpg|mpeg|avi])" -print
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "(.*[mkv|mp4|mpg|mpeg|avi])" -print
find ../video-movies -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "(.*[mkv|mp4|mpg|mpeg|avi])"
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex "(.*[mkv|mp4|mpg|mpeg|avi])"
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*[mkv|mp4|mpg|mpeg|avi]"|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*[mkv|mp4|mpg|mpeg|avi]"|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*(mkv|mp4|mpg|mpeg|avi)"|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex ".*(mkv|mp4|mpg|mpeg|avi)"
find . -mindepth 2 -maxdepth 2 -type f -regextype sed -regex '.*(mkv|mp4|mpg|mpeg|avi)'
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.[mkv|mp4|mpg|mpeg|avi]"|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.[mkv|mp4|mpg|mpeg|avi]"
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.(mkv|mp4|mpg|mpeg|avi)"
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.(mkv|mp4|mpg|mpeg|avi)"|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.(mkv|mp4|mpg|mpeg|avi)" -printf '%f\n'|grep jpg
find . -mindepth 2 -maxdepth 2 -type f -regextype egrep -regex ".*\.(mkv|mp4|mpg|mpeg|avi)" -printf '%f\n'
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:1 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:1 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")'|sort \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:1 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}") | sort' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}") | sort' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}" | sort)' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" | sort $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{} | sort" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \; | sort
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$'
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \;
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'h264$'
find ../video-shows/ -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'h264$'
find ../video-shows -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'h264$'
find ../video-movies/ -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'h264$'
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$'
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$'
find ./video-movies ./video-shows -mount -depth -maxdepth 3 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$' > ~/Documents/find-noaac.log
find ./video-movies -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$' 2>/dev/null | tee ~/Documents/find-noaac-movies.log
find ./video-shows -mount -depth -maxdepth 3 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$' 2>/dev/null | tee ~/Documents/find-noaac-shows.log
find ./video-tennis/ -regex-type ext-regex '*.mp4' -type f | wc -l
find ./video-tennis/ -regextype ext-regex '*.mp4' -type f | wc -l
find ./video-tennis/ -regex-type ext-regex '*.mp4' -type f | wc -l
find ./video-tennis/ -regex-type extended-regex '*.mp4' -type f | wc -l
history|grep find regex
find ./video-tech/ -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f
find ./video-tech/ -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f | wc -l
find ../../media/video-movies -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c \ 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \; | grep -v 'aac$'
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$'
(find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$')
find ../../media/video-movies -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$'
find ../../media/video-movies -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$' | sort
find ../../media/video-* -mount -depth -maxdepth 3 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$' | sort
find . -mount -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' 2>/dev/null \; | grep -v 'aac$' | sort
FINDMEDIA=$(find /mnt/pool0/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0)
find /mnt/pool0/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0
FINDMEDIA=$(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0)
find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print); do echo $FINDMEDIA; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print); do echo $f; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo ""$f""; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo '$f'; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo $f; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07/ -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f); do echo "{$f}"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f); do printf "$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f); do printf "$f\n"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0); do printf "$f\n"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do printf "$f\n"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do printf "\n$f"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do printf "$f\n"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo "$(basename "$f")"; done
for f in $(find /media/visualblind/p0ds0smb/media/video-shows/Shameless\ \(US\)/Season\ 07 -depth -maxdepth 1 -regextype posix-extended -regex ".*mkv$|.*mp4$" -type f -print0 | xargs -0); do echo $(basename "$f"); done
find . -maxdepth 2 -type f -regextype sed -regex ".[mkv|mp4|mpg|mpeg|avi]"|wc -l
find . -maxdepth 2 -type f -regextype sed -regex ".[mkv|mp4|mpg|mpeg|avi]"
find . -maxdepth 2 -type f -regextype sed -regex ".mkv|mp4|mpg|mpeg|avi"
find . -maxdepth 2 -type f -regextype sed -regex "[.mkv|mp4|mpg|mpeg|avi]"
find . -maxdepth 2 -type f -regextype posix-extended -regex ".mkv|mp4|mpg|mpeg|avi"
find . -maxdepth 2 -type f -regextype posix-extended -regex "*.mkv|mp4|mpg|mpeg|avi"
find . -maxdepth 2 -type f -regextype posix-extended -regex ".*mkv|mp4|mpg|mpeg|avi"
find . -maxdepth 2 -type f -regextype sed -regex ".*mkv|mp4|mpg|mpeg|avi"
find . -maxdepth 2 -type f -regextype sed -regex "[.*mkv|mp4|mpg|mpeg|avi]"
find . -maxdepth 2 -type f -regextype posix-extended -regex '.*mkv|.*mp4|.*mpg|.*mpeg|.*avi' -size 0k
find . -maxdepth 2 -type f -regextype posix-extended -regex '.*mkv|.*mp4|.*mpg|.*mpeg|.*avi' |wc -l
find ./video-shows -maxdepth 3 -type f -regextype posix-extended -regex '.*mkv|.*mp4|.*mpg|.*mpeg|.*avi' |wc -l
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f
find /media/visualblind/p0ds0smb/media/video-movies/ -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
man find|grep regex
history|grep 'find regex'
find video-movies/ -type f -regextype posix-extended -regex ".*720p.*"
find video-movies/ -type f -regextype posix-extended -regex ".*720p.*\.[mkv|mp4]"
find video-movies/ -type f -regextype posix-extended -regex ".*720p.*\.(mkv|mp4)"
find video-movies/ -type f -regextype posix-extended -regex "^.*720p.*\.(mkv|mp4)$"
find video-movies/ -type f -regextype posix-extended -regex "^.*720p.*\.(mkv|mp4)$" > ~/Documents/video-movies-720p.txt
find video-movies/ -type f -regextype posix-extended -regex "^.*720p.*\.(mkv|mp4)$" |sort > ~/Documents/video-movies-720p.txt
find video-shows/ -type f -regextype posix-extended -regex "^.*720p.*\.(mkv|mp4)$" |sort > ~/Documents/video-shows-720p.txt
find . -regextype posix-extended ! -regex '^.*\.(mkv|mp4)$'
find . -regextype posix-extended ! -regex '^.*\.(mkv|mp4|srt)$'
find . -regextype posix-extended ! -regex '^.*\.(mkv|mp4|srt)$' -type f
find . -regextype posix-extended ! -regex '^.*\.(mkv|mp4)$' -type f
find . -regextype posix-extended -regex '^.*\.(mkv|mp4)$' -type f
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpg|mpeg|avi)$' -type f -print
find . -regextype egrep -regex '.*\.(mkv|mp4|m4a|mpg|mpeg|avi)$' -type f -print
find . -regextype sed -regex '.*\.(mkv|mp4|m4a|mpg|mpeg|avi)$' -type f -print
find . -regextype sed -regex '.*\.[mkv|mp4|m4a|mpg|mpeg|avi]$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpg|mpeg|avi)$' -type f -print
find . -regextype sed -regex '.*\.mkv|mp4|m4a|mpg|mpeg|avi$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpg|mpeg|avi)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]?g|avi)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpe?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpe?g|avi)$' -type f -print
find ./* -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpe?g|avi)$' -type f -print
find -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mpe?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e?]g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]+g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp(e)?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp{e}?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]?g|avi)$' -type f -print
find * -regextype posix-extended -regex '.*\.(mkv|mp4|m4a|mp[e]{?}g|avi)$' -type f -print
find * -regextype egrep -regex '.*\.(mkv|mp4|m4a|mp[e]{?}g|avi)$' -type f -print
find -regextype help
find -regextype --help
find . -regextype posix-extended -regex '.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|mp(e)+g|avi)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|mp(e)g|avi)$' -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype egrep -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype sed -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype emc -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype emacs -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype awk -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype grep -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-basic -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-egrep -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-basic -regex '^.*\.(mkv|mp4|mp[e]\{?\}g|avi)$' -type f -print
find . -regextype posix-basic -regex '^.*\.(mkv|mp4|mp[e]\{\?\}g|avi)$' -type f -print
find . -regextype posix-basic -regex '^.*\.(mkv|mp4|mp[e]{\?}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e{1})g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e{?})g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp[e{?}]g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e{?})g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){?}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1,2}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1-2}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1\-2}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){+}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){2}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){1}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e){?}g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp(e)?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mpe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|mp4|mp[e]?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|p[e]?g]|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|pe?g]|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|pe?g]|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(mkv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.m(kv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.m[kv|p4|pe?g|avi]$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|pe?g|avi])$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m[kv|p4|pe?g]|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.m[kv|p4|pe?g]|avi$' -type f -print
find . -regextype posix-extended -regex '^.*\.m(kv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.[m(kv|p4|pe?g|avi)]$' -type f -print
find . -regextype posix-extended -regex '^.*\.m[(kv|p4|pe?g|avi)]$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m(kv|p4|pe?g|avi))$' -type f -print
find . -regextype posix-extended -regex '^.*\.m(kv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m(kv|p4|pe?g)|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.m(kv|p4|pe?g|avi)$' -type f -print
find . -regextype posix-extended -regex '^.*\.(m(kv|p4|pe?g)|avi)$' -type f -print
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find /media/visualblind/Movies/Movies/ -regextype posix-extended -regex '.*\.(mkv|mp4|avi|mpeg|mpg)' -type f | wc -l
find . -regextype posix-extended -regex '.*\.(mkv|mp4)'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%f%i\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%s %f\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%S %f\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%ss %f\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%TY-%Tm-%Td]\t'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%Tm-%Td]\t'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%fS]\t'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%fS]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%s%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '[%s\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%s\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%s - %f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%m\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%M\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%e\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%E\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%r\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%a\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%A\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%b\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%B\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%bb\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -printf '%bs\t%f]\n'
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0 | xargs -0 ls -1Ssh
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0 | xargs -0 ls -1Ssh
find -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0 | xargs -0 ls -1Ssh
find * -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0 | xargs -0 ls -1Ssh
find . -regextype posix-extended -regex '.*\.(mkv|mp4)' -size +1024M -size -4096M -type f -print0 | xargs -0 ls -1Ssh
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \; | sort
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \; | sort
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort | grep -v aac
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort | grep -v aac
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort
find . -depth -maxdepth 1 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe2 -loglevel error -select_streams a -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \; | sort
find . -mindepth 2 -maxdepth 3 -regextype posixextended -regex '(*.mkv|*.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype extendedposix -regex '(*.mkv|*.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype extended -regex '(*.mkv|*.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype posix -regex '(*.mkv|*.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype posix-extended -regex '(*.mkv|*.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype posix-extended -regex '(.*\.mkv|.*\.mp4)' -type d -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype posix-extended -regex '(.*\.mkv|.*\.mp4)' -type f -printf '%f\n'
find . -mindepth 2 -maxdepth 3 -regextype posix-extended -regex '(.*\.mkv|.*\.mp4)' -type f -printf '%f\n'|wc -l
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;
$find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")'|grep -V '10' \;
$find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")'|grep -v '10' \;
$find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -V 10)' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -v 10)' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -VE '8$')' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -vE '8$')' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -vE '10$')' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}" | grep -vE '8$')' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;
(BITDEPTH=$(find . -depth -maxdepth 4 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;); if ! [ "${BITDEPTH[0]}" = "8" ]; then echo -e "ffprobe detected ${AUDIOFORMAT[0]}"; fi)
find /media/visualblind/p0ds0smb/media/video-shows/ -regextype posix-extended -regex '^.*\.(m(kv|p4|pe?g)|avi)$' -type f -print
find /media/visualblind/p0ds0smb/media/video-shows/ -regextype posix-extended -regex '^.*\.(m(kv|p4|pe?g)|avi)$' -type f -print|wc -l
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print
find /media/visualblind/p1ds0smb/temp -regex '[\.com|www|downloaded|Torrent]\.txt$' -type f
find /media/visualblind/p1ds0smb/temp -regex '(\.com|www|downloaded|Torrent)\.txt$' -type f
find /media/visualblind/p1ds0smb/temp -regex '(com|www|downloaded|Torrent)\.txt$' -type f
find /media/visualblind/p1ds0smb/temp -regex '(com|www|downloaded|Torrent)\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regex 'com|www|downloaded|Torrent\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regex -regextype posix-extended 'com|www|downloaded|Torrent\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regex -regextype extended-posix 'com|www|downloaded|Torrent\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regex -regextype grep 'com|www|downloaded|Torrent\.txt' -type f
find -regextype posix-extended /media/visualblind/p1ds0smb/temp -regex 'com|www|downloaded|Torrent\.txt' -type f
find -regextype extended /media/visualblind/p1ds0smb/temp -regex 'com|www|downloaded|Torrent\.txt' -type f
find -regextype posix-extended /media/visualblind/p1ds0smb/temp -regex "com|www|downloaded|Torrent\.txt" -type f
find -regextype posix-extended '/media/visualblind/p1ds0smb/temp' -regex "com|www|downloaded|Torrent\.txt" -type f
find -regextype posix-extended /media/visualblind/p1ds0smb/temp -regex '.*com|www|downloaded|Torrent\.txt'
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '.*com|www|downloaded|Torrent\.txt'
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '.*(com|www|downloaded|Torrent)\.txt'
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '.*(com|www|downloaded|Torrent)\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '.*(com|www|[Dd]ownloaded|[Tt]orrent)\.txt' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '.*(com|www|[Dd]ownloaded|[Tt]orrent|to)\.txt$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|to)\.txt$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|to).*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|to)\.*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|to)\..*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|to)\..*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\..*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f
find /media/visualblind/media/video-tech -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg|html)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg|jpeg|html)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\..*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts)\..*$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(com|www|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(\.com|www\.|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(\.com|www\.|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(\.com|www\.|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(\.com|www\.|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(\.com|www\.|[Dd]ownloaded|[Tt]orrent|Tuts).*\.(txt|jpg)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpg)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpg)$' -type f -delete
find /media/visualblind/p0ds0smb/media/video-tech -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpg)$' -type f
find /media/visualblind/p1ds0smb/temp -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jp?eg|nfo)$' -type f
find /media/visualblind/p1ds0smb/temp -depth -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jp?eg|nfo)$' -type f
find /media/visualblind/p1ds0smb/temp -depth -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpg|nfo)$' -type f
find /media/visualblind/p1ds0smb/temp -depth -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|nfo)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|nfo)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(.*)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(.*)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$'
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(.*)$'
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url|html)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p0ds0smb/media/video-tech -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore\ [Cc]ourses|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore\ [Cc]ourses|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f -delete
find /media/visualblind/p1ds0smb/temp -mount -depth -maxdepth 15 -regextype posix-extended -regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f
find video-movies/ -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f
find video-movies/ -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%d\n'
find video-movies/ -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%D\n'
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%D\n'
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%f\n'
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -exec basename {} \;
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -exec dirname {} \;
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f | xargs -I{} dirname {}
find . -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%h\n'
find * -depth -regextype posix-extended -regex '^.*(2160p|4[Kk]).*\.(mkv|mp4)$' -type f -printf '%h\n'
find /media/visualblind/p0ds0smb/media/video-movies/ -regextype posix-extended -regex '(.*YTS.*\.mkv|.*YTS.*\.mp4)' -type f -printf '%f\n'
find /media/visualblind/p0ds0smb/media/video-movies/ -regextype posix-extended -regex '(.*YTS.*\.mkv|.*YTS.*\.mp4)' -type f -printf '%f\n'|sort
find /media/visualblind/p0ds0smb/media/video-movies/ -regextype posix-extended -regex '(.*YTS.*\.mkv|.*YTS.*\.mp4)' -type f -printf '%f\n'|wc -l
find . regextype posix-extended ! -regex '*.mp4|*.mkv' -type f
find . -regextype posix-extended -regex '*.mp4|*.mkv' -type f
find . ! -regextype posix-extended -regex '*.mp4|*.mkv' -type f
find . -regextype posix-extended -regex '!(*.mp4|*.mkv)' -type f
find . -regextype posix-extended -regex '^(*.mp4|*.mkv)' -type f
find . -regextype posix-extended -regex '^(*.mp4|*.mkv)'
find . -regextype posix-extended -regex '(*.mp4|*.mkv)'
find . -regextype posix-extended -regex '^(*.mp4|*.mkv)'
find . -regextype posix-extended -regex '(*.mp4|*.mkv)'
find . -regextype extende -regex '(*.mp4|*.mkv)'
find . -regextype extended -regex '(*.mp4|*.mkv)'
find . -regextype posix-extended -regex '*.mp4|*.mkv'\
find . -regextype posix-extended -regex '*.mp4|*.mkv'
find . -regextype posix-extended -regex '.*\.mp4|.*\.mkv'
find . -regextype posix-extended ! -regex '.*\.mp4|.*\.mkv'
find . -regextype posix-extended ! -regex '.*\.mp4|.*\.mkv|.*\.srt'
find . -regextype posix-extended ! -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html'
find . -regextype posix-extended ! -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '!.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '@(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '?(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '?!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '!?(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '?!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(?!.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(!?.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(?!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '(!?(.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '?!((.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '!?((.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '(^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '^((.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '!^((.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '^!((.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '((^.*\.mp4|.*\.mkv|.*\.srt|.*\.html))' -type f
find . -regextype posix-extended -regex '(^.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '([^.*\.mp4|.*\.mkv|.*\.srt|.*\.html])' -type f
find . -regextype posix-extended -regex '[^.*\.mp4|.*\.mkv|.*\.srt|.*\.html]' -type f
find . -regextype posix-extended -regex '^[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]' -type f
find . -regextype posix-extended -regex '[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]' -type f
find . -regextype posix-extended -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '^.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '(^.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-extended -regex '^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-extended -regex '\^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-extended -regex '(\^.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-extende -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-basic -regex '(^.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-basic -regex '^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-basic -regex '^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-basic -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-basic -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-basic -regex '^.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-basic -regex '^.*\.mp4|.*\.mkv|.*\.srt|.*\.html$' -type f
find . -regextype posix-basic -regex '^(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)$' -type f
find . -regextype posix-basic -regex '^(\.\*.mp4|\.\*.mkv|\.\*.srt|\.\*.html)$' -type f
find . -regextype posix-basic -regex '^(\.\*.mp4\|\.\*.mkv\|\.\*.srt\|\.\*.html)$' -type f
find . -regextype posix-basic -regex '^.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-basic -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-basic -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-basic -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html$)' -type f
find . -regextype posix-extended -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended ! -regex '.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '[^[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]]' -type f
find . -regextype posix-extended -regex '^[[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]]' -type f
find . -regextype posix-extended -regex '[[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]]' -type f
find . -regextype posix-extended -regex '[.*\.mp4|.*\.mkv|.*\.srt|.*\.html]' -type f
find . -regextype posix-extended -regex '[(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)]' -type f
find . -regextype posix-extended -regex '([.*\.mp4|.*\.mkv|.*\.srt|.*\.html])' -type f
find . -regextype posix-extended -regex '^(.*\.mp4)|(.*\.mkv)|(.*\.srt)|(.*\.html)' -type f
find . -regextype posix-extended -regex '^[(.*\.mp4)|(.*\.mkv)|(.*\.srt)|(.*\.html)]' -type f
find . -regextype posix-extended -regex '^([.*\.mp4)|(.*\.mkv)|(.*\.srt)|(.*\.html])' -type f
find . -regextype posix-extended -regex '(^[.*\.mp4)|(.*\.mkv)|(.*\.srt)|(.*\.html])' -type f
find . -regextype posix-extended -regex '^.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex ^'.*\.mp4|.*\.mkv|.*\.srt|.*\.html' -type f
find . -regextype posix-extended -regex '!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '!?(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '?!(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '^!?(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(!.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(!.*\.mp4|!.*\.mkv|.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(!.*\.mp4|!.*\.mkv|!.*\.srt|.*\.html)' -type f
find . -regextype posix-extended -regex '(!.*\.mp4|!.*\.mkv|!.*\.srt|!.*\.html)' -type f
find . -regextype posix-extended -regex '(!.*\.mp4|!.*\.mkv|.*\.srt|!.*\.html)' -type f
find . -regextype posix-extended ! -regex '(!.*\.mp4|!.*\.mkv|!.*\.srt|!.*\.html)' -type f
find . -regextype posix-extended ! -regex '(.*\.mp4|.*\.mkv|.*\.srt|.*\.html)' -type f
find -regex '[0-9a-fA-F] -maxdepth 1 -type d -print0 | while IFS= read -r -d ' dir; do [ $(du -s "$dir") -le 102400 ] && echo "$dir will be deleted"; done
find -regex '[0-9a-fA-F]' -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir; do [ $(du -s "$dir") -le 102400 ] && echo "$dir will be deleted"; done
history|grep regex|grep find
find -type d -regextype posix-extended -regex '^[a-fA-F0-9]*$'
find / -type d -regextype posix-extended -regex '^[a-fA-F0-9]*$'
find . -type d -regextype posix-extended -regex '^[a-fA-F0-9]*$'
find . -type d -regextype posix-extended -regex '^[a-fA-F0-9].*$'
find . -type d -regextype egrep -regex '^[a-fA-F0-9].*$'
find . -regextype egrep -regex '^[a-fA-F0-9].*$' -type d
find . -regextype posix-extended -regex '^[A-Fa-f0-9]*$' -type d
find . -type d -regextype posix-extended -regex '.*/[A-Fa-f0-9]*$'
find . -type d -regextype posix-extended -regex '.*/[A-Fa-f0-9]'
find . -type d -regextype posix-extended -regex '.*\/[A-Fa-f0-9]'
find -type d -regextype posix-extended -regex '.*[A-F].*[^/]$'
find -type d -regextype posix-basic -regex '.*[A-F].*[^/]$' 
find -type d -regextype posix-basic -regex '.*[^/][A-F].*$'
find -type d -regex '.*/[0-9]+'
find . -type d -regextype sed -regex ".*/[a-b0-5\-].*"
find . -type d -regextype sed -regex ".*/[a-bA-B0-5\-].*"
find . -type d -regextype sed -regex ".*/[a-jA-J0-9\-].*" | while IFS= read -r -d '' dir; do [ $(du -s "$dir") -le 102400 ] && echo "$dir will be deleted"; done
find . -regex '*.jpg|*.png' -type f
find . -regex '*.jpg|*.png'
find . -regex '.*\.jpg|.*\.png'
find . -regex '*.\(jpg|png\)' -type f
find . -regex '/*.\(jpg|png\)' -type f
find . -regex '.*.\(jpg|png\)' -type f
find . -regex '.*\.\(jpg|png\)' -type f
find . -regex '.*(jpg|png)' -type f
find . -regex '(.*jpg|.*png)' -type f
find . -regex '(*.jpg|*.png)' -type f
find . -type d -regextype sed -regex ".*/[a-jA-J0-9\-].*"
find . -type d -regextype sed -regex ".*/[a-tA-T0-9\-].*" -size 0k
find . -type d -regextype sed -regex ".*/[a-tA-T0-9\-].*" -type f -size 0k
find . -type d -regextype sed -regex ".*/[a-tA-T0-9\-].*" -type f -printf '%f\n'
find . -type d -regextype sed -regex ! ".*/[a-tA-T0-9\-].*" -type f -printf '%f\n'
find . -type d ! -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type f -printf '%f\n'
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type f -printf '%f\n'
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -printf '%f\n'
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n'
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{]' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%s\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%S\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%d\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%D\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' \;
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n'
find . -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find ./* -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find * -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find * -maxdepth 1  -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find * -maxdepth 0 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find . -maxdepth 0 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -execdir printf '%f\n' '{}' +;
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d -exec printf '%f\n' '{}' +;
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -exec printf '%f\n' '{}' +;
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -printf '%f\n' '{}' +;
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type d  -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type f -size +1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*"-o  -type f -size +1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -o -type f -size +1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*" -type f -size +1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size +1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size -1024k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size -10k -printf '%f\n'
find . -maxdepth 1 -type d -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -type f -size -10k -printf '%f\n'
find . -maxdepth 1 -type f -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size -10k -printf '%f\n'
find . -maxdepth 1 -type f -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size +10k -printf '%f\n'
find . -maxdepth 2 -type f -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size +10k -printf '%f\n'
find . -maxdepth 2 -type f -regextype sed -regex  ".*/[a-tA-T0-9\-].*"  -size 0k -printf '%f\n'
find . -maxdepth 2 -type f -regextype sed -regex  ".*/[a-sA-S0-9\-].*"  -size 0k -printf '%f\n'
find .local/share/cinnamon/extensions/ -regextype --help
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.po$|.png$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js$(on)?$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*\.\w+' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|!.*\.\w+' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|?!\.\d+' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^(?!\.\d+)' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!\.\d+)' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!\.\w)' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!\..*)' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!\..*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!.*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^(?!.*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!.*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!.*\.)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(?!.*\..*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|(!.*\..*)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^([^.]+)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^(?![^.]+)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^(!?[^.]+)$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^([^.]+)$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{4}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{2}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{1}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{6}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$'|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{6}$'|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$'|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$'
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$' -type f|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$' -type f|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{5}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{4}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '.*\.po$|.*\.png$|.*\.css$|.*\.js(on)?$|^.*[^.]{3}$' -type f|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2}$' -type f| wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{4}$' -type f| wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{5}$' -type f| wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{1}$' -type f| wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{3}$' -type f| wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2-3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f
find .local/share/cinnamon/extensions/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find .local/share/cinnamon/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find .local/share/cinnamon/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find ~/.local/share/cinnamon/ -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find .local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f|wc -l
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{4}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{6}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{1}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{1}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.]{3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.]{1}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.]{2,3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.]{2,3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{2,3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{2,4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{1,4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{1,3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{1,2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{1,2}+]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{5}+]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{3}+]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.{1}+]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{2,3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{1,4}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regex '^.*[^\.]{5}?$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{5}?$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{5}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,3}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,1}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype grep -regex '^([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '.*([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*([.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*([^\.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*([^.]?)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]+)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]?)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]*)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]+?)$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*([^.]+)' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]+$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.+]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{0,2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{0,3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.{4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,3,4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2..6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2...6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2.6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2-\6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2-6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{3-6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{3-5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*^[^.{1}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*^[^.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*![^.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[!^.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^!.]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*^[^.{1}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*^[^.{2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2,3,4,5,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2,3,4,5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2,3,4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2,3}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,2,3,4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-basic -regex '^.*[^.{1,2,3,4}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{4,}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{5,}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{6,}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,5}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{1,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,,,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.{2,6}]$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]{2,6}$' -type f
find ~/.local/share/cinnamon/extensions/ -maxdepth 1 -regextype posix-extended -regex '^.*[^.]^{2,6}$' -type f