# immediately below the $CONFIG = array ( line

  'memcache.local' => '\OC\Memcache\APCu',
  'memcache.distributed' => '\OC\Memcache\Redis',
  'redis' => [
       'host'     => 'redis',
       'port'     => 6379,
       'password' => '<REDIS PASSWORD>',
       'timeout'  => 1.5,
  ],
  'memcache.locking' => '\OC\Memcache\Redis',
