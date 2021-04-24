#!/usr/bin/env sh
screen -dmS rclone-serve-http rclone serve http /location/to/server --addr :8081 --read-only --user UserName --pass Password
