#!/usr/bin/env bash
#
#˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅˅
#								#
#		By: Travis Runyard		#
#		Date: 05-12-2019		#
#		Site: Sysinfo.io		#
#								#
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Create spanned 7z archive of dirs, excluding all files, under ./dir
sudo find ./dir/* -type d -print > /tmp/dir.manifest && sudo tar -cf - --files-from /tmp/dir.manifest | sudo 7z a -v1024M -si -t7z -m0=lzma2 -mx=3 dir-dir.tar.7z &>/tmp/tar7z.log &

# Create spanned 7z archive of all dirs/files in ./dir
sudo find ./dir -depth -type l -o -prune 2>/tmp/finderr.log | sudo tar --files-from - -cf - 2>/tmp/tarerr.log | sudo 7z a -v1024M -si -t7z -m0=lzma2 -mx=3 dir-all.tar.7z &>/tmp/tar7z.log &

# If you require to watch the command until it finishes on the shell, take off the & on the end of line. If mind changed, Ctrl-Z to move current command to the background, "bg 1"
# to resume the backgrounded jobs execution. "jobs -l" to find job #.