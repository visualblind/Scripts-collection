#!/usr/bin/env bash

# shows how to increment variable by 1 using double-parenthesis arithmetic
i=1; while [ $i -le 100 ]; do echo "i equals $((i++))"; done

# same result with bash let keyword
i=1; while [ $i -le 100 ]; do echo "i equals $i"; let "i += 1"; done