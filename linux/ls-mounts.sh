#!/usr/bin/env bash

echo "$(date +"%T.%3N") > Starting recursive ls" | logger -t "$0"
time ls -fR /usr/local/jellyfin/media/video-{shows,movies,standup} >| /dev/null && echo "$(date +"%T.%3N") > Finished recursive ls" | logger -t "$0" || exit $?
exit 0

## Loop version
#while true; do time ls -fR /usr/local/jellyfin/media/podcasts/ /usr/local/jellyfin/media/video-{shows,movies,standup,motogp,formula1,tennis} > /dev/null && echo -e "\n---> $(date +%F %T)\n---> Sleeping for 3600...\n" && sleep 3600 || break; done
