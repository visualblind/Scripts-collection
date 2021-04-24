#!/usr/bin/env bash

if [[ ("$UID" != 0) && ("$1" != "ip") && ("$1" != "-ip") && \
      ("$1" != "--ip") && ! (-z "$1") && ("$1" != "-h") && \
      ("$1" != "--help") && ("$1" != "--h") && ("$1" != "-help") && \
      ("$1" != "help") && ("$1" != "--version") && ("$1" != "-version") && \
      ("$1" != "-v") && ("$1" != "--v")]]; then
  echo "[!] Error: The program requires root access."
  exit 1
fi