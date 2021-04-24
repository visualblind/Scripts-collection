#!/bin/bash

function cleanup()
{
	echo "cleanup called"
	rm -fr /tmp/startup.log
	rm -fr /tmp/df.log
	rm -fr /tmp/hostname.log
}

## Here EXIT is a pseudo signal which bash provides to
### its processes upon exit
trap 'cleanup EXIT; exit 1' EXIT
trap 'cleanup SIGINT; exit 1' SIGINT
trap 'cleanup SIGHUP; exit 1' SIGHUP

MainLogFileName="/tmp/main_script.log"

echo "Start of the script" > /tmp/startup.log

hostname -f > /tmp/hostname.log

tmpfs_size=`df | grep tmpfs | tail -1 | awk '{print $4}'`

if [[ tmpfs_size -gt 20 ]]
then
	echo "Disk has sufficeint size" > /tmp/df.log
else
	echo "Disk is full" > /tmp/df.log
fi

cat /tmp/df.log /tmp/startup.log /tmp/hostname.log > $MainLogFileName

sleep 9999
