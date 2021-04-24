#!/usr/bin/env bash
youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "https://www.youtube.com/watch?v=xNbXf4-BSSA"
