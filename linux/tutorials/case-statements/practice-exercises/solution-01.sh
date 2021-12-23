#!/bin/bash

# This is a startup script for sleep-walking-server
#
# Be sure to copy the sleep-walking-server file into /tmp and
# "chmod 755 /tmpsleep-walking-server"

case "$1" in
  start)
    /tmp/sleep-walking-server &
    ;;
  stop)
    kill $(cat /tmp/sleep-walking-server.pid)
    ;;
  *)
    echo "Usage: $0 start|stop"
    exit 1
esac
