#!/bin/sh

snmpwalk -v1 -Osq -c public $1 '.1.3.6.1.2.1.4.21.1.11'|cut -d '.' -f2-|awk '{printf("%s\tNET-%s\t%s\n", $1, $1, $2)}'
