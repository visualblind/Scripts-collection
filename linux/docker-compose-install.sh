#!/usr/bin/env sh
[ -d $HOME/bin ] || mkdir -p $HOME/bin
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.3/docker-compose-$(uname -s)-$(uname -m)" -o $HOME/bin/docker-compose && sudo chmod +x $HOME/bin/docker-compose && sudo ln -s $HOME/bin/docker-compose /usr/local/bin/docker-compose
docker-compose --version
exit 0
