#!/usr/bin/env bash

# After verifying results add the -delete switch to actually perform the deletions
# or if youre anal pipe print0 to xargs rm
find /media/tech-video -mount -depth -maxdepth 15 -regextype posix-extended \
-regex '^.*(www\.|[Dd]ownloaded|[Tt]orrent|Tuts|[Ff]ree|Get\ [Mm]ore|Please\ [Ss]upport).*\.(txt|jpe?g|png|nfo|url)$' -type f
