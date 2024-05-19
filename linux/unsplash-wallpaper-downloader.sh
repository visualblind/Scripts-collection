#!/usr/bin/env bash

# author: github.com/visualblind
# date: 05-19-2024

# This script was made by stripped out only the pieces required
# in order to perform the recursive downloading of wallpaper from
# the unsplash website. Thanks to github.com/nitestryker/bash-wallpaper-download

# single-line version
SCREEN_RESOLUTION=$(xrandr | awk '/\*/ {print $1}'); KEYWORD="cool-backgrounds"; i=4300; while [ $i -le 4399 ]; do curl -Ls -o wallpaper_20240518_coolbackgrounds_$i -w %{url_effective} "https://source.unsplash.com/featured/$SCREEN_RESOLUTION/?$KEYWORD" 2>/dev/null && $((i++)); done

# multi-line version
#SCREEN_RESOLUTION=$(xrandr | awk '/\*/ {print $1}')
#KEYWORD="cool-backgrounds"
#i=4300; while [ $i -le 4399 ]; do \
#curl -Ls -o wallpaper_20240518_coolbackgrounds_$i -w %{url_effective} \
#"https://source.unsplash.com/featured/$SCREEN_RESOLUTION/?$KEYWORD" 2>/dev/null && \
#$((i++)); done

