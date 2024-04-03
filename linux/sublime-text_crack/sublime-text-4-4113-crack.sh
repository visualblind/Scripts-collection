#!/usr/bin/env bash

# Crack for Sublime Text 4 Build 4113

cd /opt/sublime_text || exit
printf '\x48\x31\xC0\xC3'                 | dd of=sublime_text bs=1 seek=$((0x0036567C)) conv=notrunc
printf '\x90\x90\x90\x90\x90'             | dd of=sublime_text bs=1 seek=$((0x0035BCCB)) conv=notrunc
printf '\x90\x90\x90\x90\x90'             | dd of=sublime_text bs=1 seek=$((0x0035BCE6)) conv=notrunc
printf '\x48\x31\xC0\x48\xFF\xC0\xC3'     | dd of=sublime_text bs=1 seek=$((0x00367171)) conv=notrunc
printf '\xC3'                             | dd of=sublime_text bs=1 seek=$((0x003653CE)) conv=notrunc
printf '\xC3'                             | dd of=sublime_text bs=1 seek=$((0x0034F5F0)) conv=notrunc