#!/usr/bin/env bash

docker run -d \
-v [path_to_upload_folder]:/opt/youtransfer/uploads \
-v [path_to_config_folder]:/opt/youtransfer/config \
-p 80:5000 \
remie/youtransfer:stable