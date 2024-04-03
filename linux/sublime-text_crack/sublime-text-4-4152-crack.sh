#!/usr/bin/env bash
cd /opt/sublime_text || exit
md5sum -c <<<"7038C3B1CC79504602DA70599D4CCCE9  sublime_text" || exit
echo 00415013: 48 31 C0 C3          | xxd -r - sublime_text
echo 00409037: 90 90 90 90 90       | xxd -r - sublime_text
echo 0040904F: 90 90 90 90 90       | xxd -r - sublime_text
echo 00416CA4: 48 31 C0 48 FF C0 C3 | xxd -r - sublime_text
echo 00414C82: C3                   | xxd -r - sublime_text
echo 003FA310: C3                   | xxd -r - sublime_text
