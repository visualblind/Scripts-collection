#!/usr/bin/env bash

clear; du -sBM /usr/local/jellyfin/config/transcodes/; echo -e '\t'; df -hT /dev/sda; df -mT /dev/sda && df -hT /dev/sdc; df -mT /dev/sdc; ~/scripts/ducache.sh && sleep 5;clear && tail -n 5 /usr/local/linuxserver-nginx/config/log/nginx/travisflix.com.error.log; echo -e '\t'; sleep 3; tail -n 2 -f /usr/local/linuxserver-nginx/config/log/nginx/travisflix.com_apm.log
