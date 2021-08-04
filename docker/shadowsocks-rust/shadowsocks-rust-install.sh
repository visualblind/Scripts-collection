#!/usr/bin/env bash

#https://github.com/shadowsocks/shadowsocks-rust

# Pull images
docker pull ghcr.io/shadowsocks/sslocal-rust:latest
docker pull ghcr.io/shadowsocks/ssserver-rust:latest

# Run the container. You need to mount the configuration file into the container and create an external port map for the container to connect to it.
docker run --name sslocal-rust \
  --restart always \
  -p 1080:1080/tcp \
  -v /path/to/config.json:/etc/shadowsocks-rust/config.json \
  -dit ghcr.io/shadowsocks/sslocal-rust:latest

docker run --name ssserver-rust \
  --restart always \
  -p 8388:8388/tcp \
  -p 8388:8388/udp \
  -v /path/to/config.json:/etc/shadowsocks-rust/config.json \
  -dit ghcr.io/shadowsocks/ssserver-rust:latest

# Optional
docker buildx build -t shadowsocks/ssserver-rust:latest -t shadowsocks/ssserver-rust:v1.11.1 --target ssserver .
docker buildx build -t shadowsocks/sslocal-rust:latest -t shadowsocks/sslocal-rust:v1.11.1 --target sslocal .

