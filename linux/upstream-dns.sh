#!/usr/bin/env bash
#
#	By: Travis Runyard
#	Date: 04/15/2019
#	Site: sysinfo.io

whois $(dig whoami.akamai.net +short) | grep -i 'Organization:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $( echo $DNS|tr -d '"' ) | grep -i 'organization'