#!/usr/bin/env bash

BITWARDEN_DIR="/opt/bitwarden"

adduser bitwarden && passwd bitwarden ; groupadd docker ; \
usermod -aG docker,sudo bitwarden ; mkdir $BITWARDEN_DIR && \
chmod -R 700 $BITWARDEN_DIR ; chown -R bitwarden:bitwarden $BITWARDEN_DIR ; \
cd $BITWARDEN_DIR; curl -Lso bitwarden.sh 'https://go.btwrdn.co/bw-sh' && \
chmod +x bitwarden.sh

# su to the bitwarden user and run the install to docker-compose the containers:
# bitwarden-nginx bitwarden-portal bitwarden-admin bitwarden-notifications bitwarden-identity
# bitwarden-events bitwarden-sso bitwarden-mssql bitwarden-api bitwarden-attachments
# bitwarden-icons bitwarden-web
$BITWARDEN_DIR/bitwarden.sh install