#!/usr/bin/env bash

nginx_www='/usr/local/linuxserver-nginx/config/www'

if [[ -d /usr/local/jellyfin/media && -f /usr/local/jellyfin/media/scriptcheck ]]; then
    # rclone mount exists, no need to remount

    # exit script if variable is empty
    [ -z "$nginx_www" ] && { echo "Error: variable nginx_www is not set or empty"; exit 1; }

    # refresh public text files with media index
    cd /usr/local/jellyfin/media
    find /usr/local/jellyfin/media/video-movies -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/movies.txt
    find /usr/local/jellyfin/media/video-shows -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/shows.txt
    tree --noreport -d --charset=en_US.utf8 video-shows >> $nginx_www/shows.txt
    find /usr/local/jellyfin/media/video-standup -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/standup.txt
    find /usr/local/jellyfin/media/video-tennis -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/tennis.txt
    find /usr/local/jellyfin/media/video-starcraft -mindepth 1 -maxdepth 1 -type f -printf '%f\n' | sort > $nginx_www/starcraft.txt
    find /usr/local/jellyfin/media/video-tech -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/tech.txt
    find /usr/local/jellyfin/media/podcasts -mindepth 1 -maxdepth 2 -type d -printf '%f\n' | sort > $nginx_www/podcasts.txt
    tree --noreport --charset=en_US.utf8 podcasts >> $nginx_www/podcasts.txt
    # following two sort reversed
    find /usr/local/jellyfin/media/video-uncategorized -mindepth 1 -maxdepth 2 -type d -printf '%f\n' | sort --reverse > $nginx_www/motogp.txt
    tree --noreport --charset=en_US.utf8 -r video-uncategorized >> $nginx_www/motogp.txt
else
    exit 1

fi