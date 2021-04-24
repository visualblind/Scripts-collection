#!/usr/bin/env bash
mysqldump -u table -p host > ./db.sql && sed -i 's/find/replace/g' ./db.sql && mysql -u table -p host < ./db.sql