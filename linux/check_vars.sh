#!/usr/bin/env bash

check_vars()
{
    var_names=("$@")
    for var_name in "${var_names[@]}"; do
        [ -z "${!var_name}" ] && echo "$var_name is unset." && var_unset=true
    done
    [ -n "$var_unset" ] && exit 1
    return 0
}

DB='test'
HOST='test'
DATE1='test'

# Usage for this case
check_vars DB HOST DATE
echo "You are good to go" 