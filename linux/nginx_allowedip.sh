#!/usr/bin/env bash

PUB_IP=$(curl "https://ipconfig.io" 2>/dev/null)
if [ $? -eq 0 ]; then
	echo "allow $PUB_IP;" >/etc/nginx/allowed_ips.conf
else
	exit 1
fi
