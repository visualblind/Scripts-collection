#!/usr/bin/env bash

BTCPRICE=$(node /usr/local/linuxserver-nginx/config/www/web/html/gobitcoin.io_price.js)
BTCFILE='/usr/local/linuxserver-nginx/config/www/web/html/btc.txt'

echo $BTCPRICE
