#!/usr/bin/env bash

find /usr/bin /usr/sbin -executable -name '???' -type f -printf "Name: %f Path: %h Size: %s (bytes)\n" 2>/dev/null | sort | grep -E "Name: .{3,} Path"

