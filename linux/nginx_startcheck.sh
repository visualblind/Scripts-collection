#!/usr/bin/env sh
i=`curl -s -o /dev/null -w "%{http_code}" 0.0.0.0`
if [ "$i" != "200" ]; then
    echo "NGINX failed to start: Status $1"
    exit 1
fi