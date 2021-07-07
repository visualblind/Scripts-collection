#!/usr/bin/env bash
find /usr/local/jellyfin/media/video-movies -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/movies.txt
find /usr/local/jellyfin/media/video-shows -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/shows.txt
tree -d --charset=en_US.utf8 /usr/local/jellyfin/media/video-shows >> /usr/local/linuxserver-nginx/config/www/shows.txt
find /usr/local/jellyfin/media/video-standup -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/standup.txt
find /usr/local/jellyfin/media/video-tennis -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/tennis.txt
find /usr/local/jellyfin/media/video-starcraft -mindepth 1 -maxdepth 1 -type f -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/starcraft.txt
find /usr/local/jellyfin/media/video-tech -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/tech.txt
find /usr/local/jellyfin/media/podcasts -mindepth 1 -maxdepth 2 -type d -printf '%f\n' | sort > /usr/local/linuxserver-nginx/config/www/podcasts.txt
tree --charset=en_US.utf8 /usr/local/jellyfin/media/podcasts >> /usr/local/linuxserver-nginx/config/www/podcasts.txt
find /usr/local/jellyfin/media/video-uncategorized -mindepth 1 -maxdepth 2 -type d -printf '%f\n' | sort --reverse > /usr/local/linuxserver-nginx/config/www/motogp.txt
tree --noreport --charset=en_US.utf8 -r /usr/local/jellyfin/media/video-uncategorized >> /usr/local/linuxserver-nginx/config/www/motogp.txt
