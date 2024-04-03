#!/usr/bin/env bash
BT_DIR="/home/visualblind/Documents/bittorrent"
echo -e "\nCurling ngosang's best tracker list from github out to:\n$BT_DIR/trackers_best.txt"
curl -s "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt" >"$BT_DIR"/trackers_best.txt
echo -e "\nDeleting empty lines from trackers_best.txt and outputting to:\n$BT_DIR/trackers_best_condensed.txt"
sed '/^$/d' "$BT_DIR"/trackers_best.txt >"$BT_DIR"/trackers_best_condensed.txt
