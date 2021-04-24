#!/bin/bash
# A simple shell script update Cloudflares IP addresses.
# Tested on : Debian and Ubuntu servers and Nginx only
# ----------------------------------------------------------------------------
# Author: Vivek Gite 
# Copyright: 2016 nixCraft under GNU GPL v2.0+
# ----------------------------------------------------------------------------
# Last updated 23 Apr 2017
# ----------------------------------------------------------------------------
## source for IPv4 and IPv6 urls ##
ipf='https://www.cloudflare.com/ips-v4'
ips='https://www.cloudflare.com/ips-v6'

## temp file location ##
t_ip_f="$(/bin/mktemp /tmp/cloudflare.XXXXXXXX)"
t_ip_s="$(/bin/mktemp /tmp/cloudflare.XXXXXXXX)"

## nginx config for Cloudflare ##
conf_out="/etc/nginx/cloudflare.real.ip.conf"

## grab files ##
/usr/bin/wget -q -O $t_ip_f $ipf
/usr/bin/wget -q -O $t_ip_s $ips

## generate it ##
/usr/bin/awk '{ print "set_real_ip_from " $1 ";" }' $t_ip_f > $conf_out
/usr/bin/awk '{ print "set_real_ip_from " $1 ";" }' $t_ip_s >> $conf_out
echo 'real_ip_header CF-Connecting-IP;' >> $conf_out

## delete temp files ##
[ -f "$t_ip_f" ] && /bin/rm -f $t_ip_f
[ -f "$t_ip_s" ] && /bin/rm -f $t_ip_s

## reload nginx ##
/bin/systemctl reload nginx
