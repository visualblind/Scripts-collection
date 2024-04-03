#!/usr/bin/env bash
echo -n "Movies: "; ls -f /usr/local/jellyfin/media/video-movies|wc -l; echo -n "Shows: "; ls -f /usr/local/jellyfin/media/video-shows|wc -l
