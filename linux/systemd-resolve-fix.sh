#!/bin/bash
cd /etc
sudo ln -sf ../run/systemd/resolve/resolv.conf resolv.conf
exit 0
