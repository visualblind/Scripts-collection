#!/bin/bash
find | grep php | grep -v ini | grep -v 'docs/utils' | xargs wc | sort -n
