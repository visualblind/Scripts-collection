#! /bin/bash
cd /var/www/html/repo/debs/amd64
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz