#!/usr/bin/env bash
certbot renew --quiet --post-hook "systemctl reload-or-restart nginx" 2>&1 && openssl pkcs12 -export -out \
/mnt/pool0/p0ds0smb/visualblind/Documents/_secure/Certificates/SSL/travisflix.com/travisflix.com_$(date +%F).pfx \
-inkey /etc/letsencrypt/live/travisflix.com/privkey.pem -in /etc/letsencrypt/live/travisflix.com/fullchain.pem \
-passout pass:DrewGe*f8 ; openssl pkcs12 -export -out \
/mnt/pool0/p0ds0smb/visualblind/Documents/_secure/Certificates/SSL/sysinfo.io/sysinfo.io_$(date +%F).pfx \
-inkey /etc/letsencrypt/live/sysinfo.io-0001/privkey.pem -in /etc/letsencrypt/live/sysinfo.io-0001/fullchain.pem \
-passout pass:DrewGe*f8
