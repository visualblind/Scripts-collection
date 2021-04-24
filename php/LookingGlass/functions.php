<?php>

  define(REGEXP_IPv4,
     '((1?\d?\d|2[0-4]\d|25[0-5])(\.(1?\d?\d|2[0-4]\d|25[0-5])){3})');
  define(REGEXP_IPv6,
     '(([A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}|'
     .'[A-Fa-f0-9]{1,4}::([A-Fa-f0-9]{1,4}:){0,5}[A-Fa-f0-9]{1,4}|'
     .'([A-Fa-f0-9]{1,4}:){2}:([A-Fa-f0-9]{1,4}:){0,4}[A-Fa-f0-9]{1,4}|'
     .'([A-Fa-f0-9]{1,4}:){3}:([A-Fa-f0-9]{1,4}:){0,3}[A-Fa-f0-9]{1,4}|'
     .'([A-Fa-f0-9]{1,4}:){4}:([A-Fa-f0-9]{1,4}:){0,2}[A-Fa-f0-9]{1,4}|'
     .'([A-Fa-f0-9]{1,4}:){5}:([A-Fa-f0-9]{1,4}:){0,1}[A-Fa-f0-9]{1,4}|'
     .'([A-Fa-f0-9]{1,4}:){6}:[A-Fa-f0-9]{1,4})');
  define(REGEXP_URL,'(([0-9a-zA-Z\-]+\.)+[a-zA-Z]+)');

  function is_ipv4($i) {
    return preg_match('/^'.REGEXP_IPv4.'$/',$i);
  }

  function is_ipv6($i) {
    return preg_match('/^'.REGEXP_IPv6.'$/',$i);
  }

  function is_url($i) {
    return preg_match('/^'.REGEXP_URL.'$/',$i);
  }

  function is_rfc1918($i) {
    # If you want to be able to address private space, uncomment next line
    # return 0;
    return preg_match('/^(192\.168|10|172\.(1[6-9]|2[0-9]|3[0-1]))\./',$i);
  }

  function get_ipv4($u) {
    $res = `/usr/bin/host -Q -t A $u`;
    if ( preg_match('/'.REGEXP_URL.'\s+A\s+'.REGEXP_IPv4.'\s+/',$res,$m) )
      return $m[3];
    else
      return 0;
  }

  function get_ipv6($u) {
    $res = `/usr/bin/host -Q -t AAAA $u`;
    if ( preg_match('/'.REGEXP_URL.'\s+AAAA\s+'.REGEXP_IPv6.'\s+/',$res,$m) )
      return $m[3];
    else
      return 0;
  }

  function get_host($i) {
    $res = `/usr/bin/host -Q $i`;
    if ( preg_match('/^Name:\s+'.REGEXP_URL.'\s+Address:\s+(.*)\s+$/',$res,$m) )
      return $m[1];
    else
      return 0;
  }

