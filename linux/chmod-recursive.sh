#!/usr/bin/env bash
find /mnt/pool0/pool0-dataset1-nfs/torrent-complete/ -type d -print0 | xargs -0 chmod 775
find /mnt/pool0/pool0-dataset1-nfs/torrent-complete/ -type f -print0 | xargs -0 chmod 664