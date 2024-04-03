#!/usr/bin/env bash
tmux new-session -s '2win3pane' \; \
split-window -h -p 45 \; \
select-pane -t 0 \; \
split-window -v \; \
select-pane -t 0 \; \
send-keys 'atop -1 5' C-m \; \
select-pane -t 1 \; \
send-keys 'slurm -z -d 2 -s -i eth0 -t cyan' C-m \; \
select-pane -t 2 \; \
send-keys 'tail -f "/usr/local/jellyfin/config/log/log_$(date +%Y%m%d -d '+1 day').log" || tail -f "/usr/local/jellyfin/config/log/log_$(date +%Y%m%d).log"' C-m \; \
select-pane -t 2 \; \
new-window -a \; \
split-window -v -p 50 \; \
select-pane -t 0 \; \
send-keys '~/scripts/du-and-showlog.sh' C-m \; \
select-pane -t 1 \; \
send-keys 'ctop' C-m \;

# either tail the log or use docker logs: docker logs --tail 100 --follow jellyfin
