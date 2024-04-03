#!/usr/bin/env bash
[ -d  /root/ducache ] || mkdir /root/ducache
date | tee -a /root/ducache/ducache.log
du -shBM /usr/local/linuxserver-nginx/config/nginx/cache | tee -a /root/ducache/ducache.log
echo "$(find /usr/local/linuxserver-nginx/config/nginx/cache -type f | wc -l) files" | tee -a /root/ducache/ducache.log

awk '{ print $3 }' /usr/local/linuxserver-nginx/config/log/nginx/travisflix.com.cache.log | sort |  uniq -c | sort -r | tee -a /root/ducache/ducache.log
