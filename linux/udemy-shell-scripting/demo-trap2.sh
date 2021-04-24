#!/bin/bash

cleanup()
{
	echo " Some cleanup performed "
	echo "Signal received is $1"
}


trap 'cleanup SIGINT;exit 2' SIGINT

while true
do
	echo "hello"
	sleep 1
done
