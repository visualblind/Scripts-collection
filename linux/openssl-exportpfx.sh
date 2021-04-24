#!/usr/bin/env bash
openssl pkcs12 -export -out /mnt/dir/sitename_$(date +%F).pfx -inkey /etc/letsencrypt/live/sitename/privkey.pem -in /etc/letsencrypt/live/sitename/fullchain.pem -passout pass:Password
