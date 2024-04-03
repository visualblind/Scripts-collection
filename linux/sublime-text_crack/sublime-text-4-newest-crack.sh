#!/usr/bin/env bash
# for Linux
cd /opt/sublime_text || exit
md5sum -c <<<"FECA809A08FD89F63C7CB9DA23089967  sublime_text" || exit
echo 00385492: 48 31 C0 C3          | xxd -r - sublime_text
echo 0037B675: 90 90 90 90 90       | xxd -r - sublime_text
echo 0037B68B: 90 90 90 90 90       | xxd -r - sublime_text
echo 00386F4F: 48 31 C0 48 FF C0 C3 | xxd -r - sublime_text
echo 00385156: C3                   | xxd -r - sublime_text
echo 0036EF50: C3                   | xxd -r - sublime_text
