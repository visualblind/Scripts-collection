#!/usr/bin/env bash
while true; do
xdotool windowactivate --sync $(xdotool search --name "Tinder") key Right
sleep '60'
done
