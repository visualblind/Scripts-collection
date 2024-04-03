#!/usr/bin/env bash
# get start time in seconds
start=$(date -d "${2:-@0}" '+%s')
# get current time in seconds
now=$(date '+%s')
# get the amount of days (86400 seconds per day)
days=$(( (now-start) /86400 ))
# set the modulo
modulo=$1
# do the test
(( days >= 0 )) && (( days % modulo == 0))
