#!/usr/bin/env bash
docker run -d --restart="always" -p 9444:8080 \
-v /docker/privatebin:/srv/data --name privatebin-1.3.5 privatebin/nginx-fpm-alpine