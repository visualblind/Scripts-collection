#!/usr/bin/env bash
# for Linux

cd /opt/sublime_text || exit
md5sum -c <<<"FD64BBD3575DD5D99553F030998659CC  sublime_text" || exit
printf '\x48\x31\xC0\xC3'                 | dd of=sublime_text bs=1 seek=$((0x003764CA)) conv=notrunc
printf '\x90\x90\x90\x90\x90'             | dd of=sublime_text bs=1 seek=$((0x0036C615)) conv=notrunc
printf '\x90\x90\x90\x90\x90'             | dd of=sublime_text bs=1 seek=$((0x0036C630)) conv=notrunc
printf '\x48\x31\xC0\x48\xFF\xC0\xC3'     | dd of=sublime_text bs=1 seek=$((0x00377F4D)) conv=notrunc
printf '\xC3'                             | dd of=sublime_text bs=1 seek=$((0x0037618E)) conv=notrunc
printf '\xC3'                             | dd of=sublime_text bs=1 seek=$((0x00360130)) conv=notrunc

