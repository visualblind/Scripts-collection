#!/usr/bin/env bash

strace -f -s 1000 -e trace=file ./configure --enable-libsoxr 2>&1 | grep sox
