#!/usr/bin/env bash

#docker inspect jellyfin|grep -iE -A 2 'restart|oom|memory'
docker inspect jellyfin | grep -E 'OOMKilled|RestartCount'
