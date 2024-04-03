#!/usr/bin/env bash

SEASH="echo $(docker logs -f -n 100 jellyfin | seashells)"
JFCONF='/usr/local/jellyfin/jellyfin-web/config.json'



