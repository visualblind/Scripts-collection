docker run                                    \
  --name echoip                               \
  --detach                                    \
  -p 8082:8080                                \
  --restart=unless-stopped                    \
  -v "$PWD"/data:/data                        \
  mpolden/echoip                              \
    -a /data/GeoLite2-ASN.mmdb                \
    -c /data/GeoLite2-City.mmdb               \
    -f /data/GeoLite2-Country.mmdb            \
    -r                                        \
    -p                                        \
    -H CF-Connecting-IP