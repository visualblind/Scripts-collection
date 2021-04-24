#!/bin/bash

### Continue will work only if the signal is 
# received in loop
## Otherwise it will not work
trap 'continue' SIGINT

while true
do
	echo "hello"
	sleep 1
done

#sleep 300

