tmpfs   /tmp         tmpfs   nodev,nosuid,size=2G          0  0
304344k
297m


  # variable to test cache for HIT or MISS
  add_header rt-Fastcgi-Cache $upstream_cache_status;

mkdir -p /var/run/nginx-cache && chown nginx: /var/run/nginx-cache && chmod 775 /var/run/nginx-

ln -s /etc/nginx/sites-available/travisrunyardcom_fastcgi_cache.conf /etc/nginx/sites-enabled/travisrunyardcom_fastcgi_cache.conf


sudo add-apt-repository ppa:rtcamp/nginx
sudo apt-get update
sudo apt-get remove nginx*
sudo apt-get install nginx-custom

# Command to verify whether or not your NGINX has fastcgi_cache_purge
nginx -V 2>&1 | grep nginx-cache-purge -o

$ sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/rtCamp:/EasyEngine/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/nginx.list"
$ sudo apt-get update
$ sudo apt-get install nginx-custom
$ sudo ufw allow 'Nginx Full'
$ sudo ufw enable

nginx -t && service nginx reload



 http {
+       ##
+       # EasyEngine Settings
+       ##
+
+       sendfile on;
+       tcp_nopush on;
+       tcp_nodelay on;
+       keepalive_timeout 30;
+       types_hash_max_size 2048;
+
+       server_tokens off;
+       reset_timedout_connection on;
+       # add_header X-Powered-By "EasyEngine";
+       add_header rt-Fastcgi-Cache $upstream_cache_status;
+
+       # Limit Request
+       limit_req_status 403;
+       limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
+
+       # Proxy Settings
+       # set_real_ip_from      proxy-server-ip;
+       # real_ip_header        X-Forwarded-For;
+
+       fastcgi_read_timeout 300;
+       client_max_body_size 100m;