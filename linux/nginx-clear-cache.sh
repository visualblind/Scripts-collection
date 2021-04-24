#!/bin/bash
systemctl stop php7.0-fpm && systemctl stop nginx && rm -R /run/nginx-cache/* && systemctl start php7.0-fpm && systemctl start nginx
