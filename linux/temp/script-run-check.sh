#!/usr/bin/env bash
#echo $(basename)
echo $(basename $0)
echo $$
if pidof -x "`basename $0`" -o $$ >/dev/null; then
	echo "Process already running"
else
	echo "Process not already running"
	sleep "30"
fi
