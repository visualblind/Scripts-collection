#!/bin/bash

cleanup()
{
	echo " Some cleanup performed "
}


trap 'cleanup' SIGINT

while true
do
	echo "hello"
	sleep 1
done
