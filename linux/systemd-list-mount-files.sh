#!/usr/bin/env bash

# list .mount files under /lib/systemd/

RED='\033[0;31m' NC='\033[0m'; for f in  /lib/systemd/system/mnt*.mount; do echo -e "\t${RED} $(readlink -f "$f")\n\t${RED} $(lsattr "$f")\n${NC}" && cat "$f"; echo; done; unset RED && unset NC

