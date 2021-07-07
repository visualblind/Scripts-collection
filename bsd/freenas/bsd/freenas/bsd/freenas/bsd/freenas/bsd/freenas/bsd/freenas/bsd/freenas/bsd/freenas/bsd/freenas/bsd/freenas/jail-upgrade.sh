#!/usr/bin/env bash
for jail in `jls`; do
#  jexec $jail pkg upgrade -y
echo '$jail\n'
done
