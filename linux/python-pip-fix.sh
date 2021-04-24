#!/usr/bin/env bash
#
# For me this fixed the Python v2/3 error: "Traceback (most recent call last): File "/usr/bin/pip", line 9, in <module> from pip import main ImportError: cannot import name main"

sudo python -m pip uninstall pip && sudo apt install python-pip --reinstall -y
sudo python3 -m pip uninstall pip && sudo apt install python3-pip --reinstall -y