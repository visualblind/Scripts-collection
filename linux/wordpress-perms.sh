chown www-data:www-data  -R * # Let Apache be owner
find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
find /var/www/sysinfo.io -type f -exec chmod 644 {} \;
find /var/www/sysinfo.io -type d -exec chmod 755 {} \;
find /var/www/travisrunyard.com/wp-content/ -type d -exec chmod 775 {} \;
find /var/www/travisrunyard.com/wp-content/ -type f -exec chmod 664 {} \;
find /var/www/travisrunyard.com -type d -exec chmod g+s {} \;
find /var/www/travisrunyard.com/wp-content/uploads -type d -exec chmod 775 {} \;

#remove all directories in the current directory
find . -type d -exec rm -r "{}" \;

cp /etc/nginx-previous/fastcgi_params /etc/nginx

vi /etc/nginx/sites-available/travisrunyard.com

fastcgi_cache_path /etc/nginx/cache levels=1:2 keys_zone=microcache:200m max_size=1g inactive=60m;

chrome://net-internals
initctl show-config
/etc/ssl/letsencrypt/travisrunyard.com

sudo ln -s /etc/nginx/sites-available/travisrunyard.com /etc/nginx/sites-enabled/travisrunyard.com


Aug 17 12:29:48 ip-172-31-23-207 systemd[1]: Starting A high performance web server and a reverse proxy server...
Aug 17 12:29:48 ip-172-31-23-207 nginx[30310]: nginx: [emerg] SSL_CTX_use_PrivateKey_file("/etc/ssl/letsencrypt/travisrunyard.com/priv.pem") failed (SSL: 
Aug 17 12:29:48 ip-172-31-23-207 nginx[30310]: nginx: configuration file /etc/nginx/nginx.conf test failed
Aug 17 12:29:48 ip-172-31-23-207 systemd[1]: nginx.service: Control process exited, code=exited status=1
Aug 17 12:29:48 ip-172-31-23-207 systemd[1]: Failed to start A high performance web server and a reverse proxy server.
Aug 17 12:29:48 ip-172-31-23-207 systemd[1]: nginx.service: Unit entered failed state.
Aug 17 12:29:48 ip-172-31-23-207 systemd[1]: nginx.service: Failed with result 'exit-code'.

[error] 30331#30331: *1 connect() failed (111: Connection refused) while connecting to upstream, client: server:request: "GET / HTTP/1.0"

vi /etc/php/7.0/fpm/pool.d/www.conf

travisrunyard-usw.cjpmjup0prux.us-west-1.rds.amazonaws.com:3306

/etc/ssl/letsencrypt/travisrunyard.com/

Starting httpd: Syntax error on line of Could not open config directory/var/www/conf.modules.d: No such file or directory

travisrunyard-usw.cjpmjup0prux.us-west-1.rds.amazonaws.com:3306

sudo chown -R nginx:nginx /var/www/travisrunyard.com

sudo chown -R nginx:nginx /sites/{{SITE_DOMAIN}}.com/public


#apache rewrite rule
RedirectMatch 301 ^/([0-9]{4})/([0-9]{2})/([0-9]{2})/(?!page/)(.+)$ https://travisrunyard.com/$4

# nginx configuration
location ~ ^/([0-9]{4})/([0-9]{2})/([0-9]{2})/(?!page/)(.+)$ {
rewrite ^(.*)$ https://travisrunyard.com/$4 redirect;
}

OR

rewrite "/([0-9]{4})/([0-9]{2})/([0-9]{2})/(.*)" /$4 permanent;