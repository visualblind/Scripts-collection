#!/usr/bin/env bash

# Compatibility: Jellyfin 10.7.x - 10.8.x

# customize website title
NEWTITLE=TravisFlix
sed -i "s/document.title=\"Jellyfin\"/document.title=\"$NEWTITLE\"/" main.jellyfin.bundle.js
sed -i "s/document.title=e||\"Jellyfin\"}/document.title=e||\"$NEWTITLE\"}/" main.jellyfin.bundle.js
sed -i "s/<title>Jellyfin/<title>$NEWTITLE/" index.html

# enable backdrops by default for all users
sed -E -i 's/enableBackdrops\:function\(\)\{return P\}/enableBackdrops\:function\(\)\{return \_\}/' main.jellyfin.bundle.js

