#! /bin/env bash
dpkg --list | grep '^ii' | cut -d ' ' -f 3
