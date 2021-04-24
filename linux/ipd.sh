#!/bin/bash
ipd -f /root/go/src/github.com/mpolden/ipd/GeoLite2-Country.mmdb -c /root/go/src/github.com/mpolden/ipd/GeoLite2-City.mmdb -l :8080 -r -p -t /root/go/src/github.com/mpolden/ipd/index.html -H X-Real-IP -L debug
