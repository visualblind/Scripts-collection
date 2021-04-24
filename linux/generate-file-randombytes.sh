#!/bin/sh
# Creates 5GB file generated from urandom
dd if=/dev/urandom of=/root/random.img count=1024 bs=5M