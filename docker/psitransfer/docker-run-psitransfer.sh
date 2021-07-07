#!/usr/bin/env bash
docker run -d --name psitransfer -p 0.0.0.0:3000:3000 -e PSITRANSFER_ADMIN_PASS=secret -v /var/docker/psitransfer/data:/data psitrax/psitransfer
