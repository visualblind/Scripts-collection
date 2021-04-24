awk '{ print $1 }' /var/log/nginx/ipconfig.io.access.log | sort | uniq -c | sort -nr | wc -l
