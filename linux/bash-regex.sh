#!/usr/bin/env bash

string=$( date +%T )

if [[ "$string" =~ ^([0-9][0-9]):([0-9][0-9]):([0-9][0-9])$ ]]; then
  printf 'Got %s, %s and %s\n' \
    "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
fi