#!/bin/bash

cleanup_new()
{
	echo " Some new and extra cleanup performed "
	## This would restore the signals back
	trap - SIGINT
}

cleanup_old()
{
	echo " Some cleanup performed "
	## This would install a new signal handler
	trap cleanup_new  SIGINT
}

#trap 'cleanup SIGINT;exit 2' SIGINT
### Continue will work only if the signal is received in loop
## Otherwise it will not work
trap 'cleanup_old SIGINT' SIGINT

while true
do
	echo "hello"
	sleep 1
done
