#!/usr/bin/env bash

docker run -t -d -p 9980:9980 -e "domain=cloud\\.domain\\.com" -e "username=admin" -e "password=collabora" --name collabora --restart unless-stopped --memory 1G --cap-add MKNOD collabora/code