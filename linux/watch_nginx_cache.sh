#!/usr/bin/env bash
watch -n 1 'du -sh /var/run/nginx-cache/ | cut -f1'
