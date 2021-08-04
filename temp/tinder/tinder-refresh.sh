#!/usr/bin/env bash
while true; do
xdotool windowactivate --sync $(xdotool search --name "Tinder") key F5
sleep $1
done
