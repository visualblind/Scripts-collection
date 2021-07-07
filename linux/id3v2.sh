#!/usr/bin/env bash
clear; for f in *.mp3; do id3v2 -l "$f"; done
for f in *.mp3; do id3v2 --artist 'Artist Name' --album 'Album Name' "$f"; done