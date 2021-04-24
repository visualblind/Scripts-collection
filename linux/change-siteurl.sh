#!/usr/bin/env sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 http://www.site-url.com"
    exit 1
fi

echo "* Check site url modification"

WORDPRESS_CONFIG="/var/www/html/wp-config.php"
WORDPRESS_DB_NAME=$(cat $WORDPRESS_CONFIG | grep DB_NAME | cut -d \' -f 4)
WORDPRESS_TABLE_PREFIX=$(cat $WORDPRESS_CONFIG | grep "\$table_prefix" | cut -d \' -f 2)

OLD_SITE=$(mysql -h localhost -sN $WORDPRESS_DB_NAME -e "select option_value from ${WORDPRESS_TABLE_PREFIX}options WHERE option_name = 'siteurl';")
NEW_SITE=$1

if [ "$OLD_SITE" = "$NEW_SITE" ]; then
   echo "* New site url ($NEW_SITE) already set in the current wordpress installation."
   exit 0
fi

echo "* Change site url"
mysql -h localhost $WORDPRESS_DB_NAME -e "UPDATE ${WORDPRESS_TABLE_PREFIX}options
SET option_value = replace(option_value, '$OLD_SITE', '$NEW_SITE')
WHERE option_name = 'home'
OR option_name = 'siteurl';
"

echo "* Change guid url"
mysql -h localhost $WORDPRESS_DB_NAME -e """UPDATE ${WORDPRESS_TABLE_PREFIX}posts
SET guid = REPLACE (guid, '$OLD_SITE', '$NEW_SITE');
"""

echo "* Change media's url in articles and pages"
mysql -h localhost $WORDPRESS_DB_NAME -e """UPDATE ${WORDPRESS_TABLE_PREFIX}posts
SET post_content = REPLACE (post_content, '$OLD_SITE', '$NEW_SITE');
"""

echo "* Change url of meta data"
mysql -h localhost $WORDPRESS_DB_NAME -e """UPDATE ${WORDPRESS_TABLE_PREFIX}postmeta
SET meta_value = REPLACE (meta_value, '$OLD_SITE','$NEW_SITE');
"""

echo "* New site url is now $NEW_SITE (old was $OLD_SITE)"