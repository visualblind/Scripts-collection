#!/bin/bash
exec sg <new group name> newgrp `id -gn`
# or:
exec su -l $USER
# or if you don't want to replace the shell with a new one so you can exit and go back to the original:
su - $USER
# or for all Screen sessions:
screen -S <session_name> -X at \# stuff "exec sg <new_group_name> newgrp \`id -gn\`^M"