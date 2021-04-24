/root/certbot/certbot-auto certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/certbot/certbot-dns-cloudflare/credentials.ini \
  -d sysinfo.io \
  -d *.sysinfo.io