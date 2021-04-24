#!/bin/bash

       ## SIGHUP SIGINT SIGQUIT SIGTERM ...These signals are ignored
trap '' 1 2 3 15

while true
do
	echo "hello"
	sleep 1
done

