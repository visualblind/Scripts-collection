#!/usr/bin/env bash

# create a folder for the lemmy files. the location doesnt matter, you can put this anywhere you want
mkdir /lemmy
cd /lemmy

# download default config files
wget https://raw.githubusercontent.com/LemmyNet/lemmy/release/v0.16/docker/prod/docker-compose.yml
wget https://raw.githubusercontent.com/LemmyNet/lemmy/release/v0.16/docker/lemmy.hjson

# Set correct permissions for pictrs folder
mkdir -p volumes/pictrs
sudo chown -R 991:991 volumes/pictrs

