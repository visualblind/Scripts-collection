#!/usr/bin/env bash
while true; do
xdotool windowactivate --sync $(xdotool search --name "Tinder") key F5
sleep '300'
done
while true; do
xdotool windowactivate --sync $(xdotool search --name "Tinder") key Right
sleep '4'
done
