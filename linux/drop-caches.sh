#!/usr/bin/env bash
sync && echo 3 | tee /proc/sys/vm/drop_caches
vmstat -S MB && sync && echo 1 | tee /proc/sys/vm/drop_caches && vmstat -S MB