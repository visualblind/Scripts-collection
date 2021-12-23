#!/usr/bin/env bash

access_log='/usr/local/linuxserver-nginx/config/log/nginx/travisflix.com.access.log'

[ $access_log ] && nohup tail -n 5000 -f "$access_log" \
| pcregrep --line-buffered --om-separator=', ' -o1 -o2 -o5 \
'^\[(.*)\] ([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+) \- \- \- travisflix\.com travisflix\.com to: (172\.18\.0\.1:8096|-): GET /Items/.*/Download\?api_key=.* HTTP\/(2\.0|1\.1) (200|429) upstream_response_time (\-|[[:digit:]]+\.[[:digit:]]+) msec [[:digit:]]+\.[[:digit:]]+ request_time .*$' \
>> $HOME/temp/dl_nginx.log & 1>/dev//null 2>&1
