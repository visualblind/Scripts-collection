#!/usr/bin/env bash

docker run \
    -v /path/to/root:/srv \
    -v /path/filebrowser.db:/database.db \
    -v /path/.filebrowser.json:/.filebrowser.json \
    --user $(id -u):$(id -g)
    -p 80:80 \
    filebrowser/filebrowser