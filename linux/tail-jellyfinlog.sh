#!/usr/bin/env bash

tail -f "/usr/local/jellyfin/config/log/log_$(date +%Y%m%d -d +1day).log" || tail -f "/usr/local/jellyfin/config/log/log_$(date +%Y%m%d).log"
