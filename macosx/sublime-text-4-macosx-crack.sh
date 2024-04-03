#!/bin/bash
# for macOS (M1 ARM64)
cd "/Applications/Sublime Text.app/Contents/MacOS/" || exit
[ $(md5 -q sublime_text) = B945D6CCF73C966DC68A69A2C2D8F71E ] || exit
echo 00FF47B0: E0 03 1F AA C0 03 5F D6 | xxd -r - sublime_text
echo 00F85B3C: 1F 20 03 D5             | xxd -r - sublime_text
echo 00F85B50: 1F 20 03 D5             | xxd -r - sublime_text
echo 00FF589C: C0 03 5F D6             | xxd -r - sublime_text
echo 00FF4444: C0 03 5F D6             | xxd -r - sublime_text
echo 00F811B8: C0 03 5F D6             | xxd -r - sublime_text
