#!/usr/bin/env bash

echo $(xrandr | awk '/\*/ {print $1}' | sed 's/x/*/g')

