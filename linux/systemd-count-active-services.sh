#!/usr/bin/env bash
# Output all active services:
systemctl -t service --state=active --no-pager --no-legend

# Count of all active services:
systemctl -t service --state=active --no-pager --no-legend | grep -c -

# Output all running services:
systemctl -t service --state=active --no-pager --no-legend | egrep '^*\.service.*running'

# Count of all running services:
systemctl -t service --state=active --no-pager --no-legend | egrep '^*\.service.*running' -c -

# Output only the service and its description:
systemctl -t service --state=active --no-pager --no-legend | egrep '^*\.service.*running' | awk 'BEGIN { FS = " ";} {for (i = 2; i <= 4; i++) { $i = "" }; print}'