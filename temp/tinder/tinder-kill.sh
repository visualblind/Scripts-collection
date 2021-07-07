#!/usr/bin/env bash
kill $(pgrep -f 'tinder'|grep -v 'pgrep')
