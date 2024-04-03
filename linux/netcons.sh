#!/usr/bin/env bash
netstat -an|awk '/tcp/ {print $6}'|sort|uniq -c
