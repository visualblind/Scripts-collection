find . -type d -print0 | xargs -0 chmod 775

find . -maxdepth 99 -mindepth 1 -type d -printf %P\\n

ls -1l | grep '^d' | awk '{print $8}'

find ./ -type d

find . -maxdepth 99 -mindepth 1 -type d -print0 -printf %P\\n | xargs -0 ls -d

#My favorite
ls -hl | grep '^d'

find /var/www -type d -print0 | xargs -0 chmod g+s

find /var/www/vhosts/sundancespas.com/httpdocs/wp-content -type d -exec chmod 775 {} \;

find /var/www/vhosts/sundancespas.com/httpdocs/wp-content -type f -exec chmod 664 {} \;