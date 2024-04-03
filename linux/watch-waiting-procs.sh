#!/usr/bin/env bash
clear;watch -n 30 -d "(ps aux | awk '\$8 ~ /D/ { print \$0 }')"

