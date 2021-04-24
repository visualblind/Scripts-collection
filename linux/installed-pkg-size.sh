#!/usr/bin/env bash
sudo dpkg-query -Wf '${Installed-size}\t${Package}\n'
