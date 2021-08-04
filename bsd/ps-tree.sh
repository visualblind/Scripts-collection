#!/usr/bin/env sh

# Tree view
ps -axdww -o user,pid,ppid,ni,pcpu,pmem,time,command

# Sorted by cpu
ps -axrSww -o user,pid,ppid,ni,pcpu,pmem,time,command
