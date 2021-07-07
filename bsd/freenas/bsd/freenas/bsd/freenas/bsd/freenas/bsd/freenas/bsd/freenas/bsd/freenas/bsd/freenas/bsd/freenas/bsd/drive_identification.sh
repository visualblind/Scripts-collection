#!/bin/sh

drives="da0 da1 da2 da3 da4 da5 da6 da7 da8"

echo ""
echo "+========+============================================+=================+"
echo "| Device | GPTID                                      | Serial          |"
echo "+========+============================================+=================+"
for drive in $drives
do
    gptid=`glabel status -s "${drive}p2" | awk '{print $1}'`
    serial=`smartctl -i /dev/${drive} | grep "Serial Number" | awk '{print $3}'`
    printf "| %-6s | %-42s | %-15s |\n" "$drive" "$gptid" "$serial"
    echo "+--------+--------------------------------------------+-----------------+"
done
echo ""
