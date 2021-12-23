#!/bin/bash

# Instructions:
#   Place this script in /tmp 
#
# Description:
#   This script simulates a service or a daemon.

PID_FILE="/tmp/sleep-walking-server.pid"
trap "rm $PID_FILE; exit" SIGHUP SIGINT SIGTERM
echo "$$" > $PID_FILE

while true
do
  :
done
