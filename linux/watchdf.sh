#!/usr/bin/env bash

watch -n 60 'TRANSCODE_DIR=/usr/local/jellyfin/config/transcodes; \
       	echo "Jellyfin Transcodes:\n$(find $TRANSCODE_DIR -type f | wc -l) files"; \
	du -s -BM --time $TRANSCODE_DIR; \
	df -hT /dev/sda
	echo "\nNGINX Cache:\n"
	dircnt /usr/local/linuxserver-nginx/config/nginx/cache'


