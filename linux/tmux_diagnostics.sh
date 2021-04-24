#!/usr/bin/env bash
###########################
# Author: Travis Runyard
# Date: 03-07-2021
# URL: https://travisyard.run
#
# Name: tmux_diagnostics.sh
# Description: Run multiple diagnostics utilities/view log file output on a single screen utilizing terminal multiplexer Tmux.
###########################

tmux new-session -s 'diagnostics' \; \
split-window -h -p 50 \; \
select-pane -t 0 \; \
split-window -v \; \
select-pane -t 2\; \
split-window -v \; \
select-pane -t 0 \; \
send-keys 'journalctl -m -n 100 -f' C-m \; \
select-pane -t 1 \; \
send-keys 'fping2' C-m \; \
select-pane -t 2 \; \
send-keys 'tail -n 100 -f /var/log/syslog' C-m \; \
select-pane -t 3 \; \
send-keys 'htop' C-m \; \
select-pane -t 0 \;
