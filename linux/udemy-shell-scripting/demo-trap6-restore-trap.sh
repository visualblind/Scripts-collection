#!/bin/bash

cleanup()
{
	echo " Some cleanup performed "
	trap - SIGINT
}


#trap 'cleanup SIGINT;exit 2' SIGINT
### Continue will work only if the signal is received in loop
## Otherwise it will not work
trap 'cleanup SIGINT' SIGINT

while true
do
	echo "hello"
	sleep 1
done
