<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_smokeping($options) {

  $topdir = $options['ro_community'];
  $dss = $options['poller_parameters'];
  $file = $options['interface'];
  $pathname = $topdir . '/'.$file . '.rrd';

  if (!is_file($pathname)) {
    echo ("File not found $pathname");
    return 0;
  }

  // Find last value of RRD
  $lastdate = rrdtool_last($pathname);
  $rra = 'AVERAGE';
  $opts = array ($rra, "--start=$lastdate");
  $values = rrdtool_fetch($pathname, $opts);
  $names = $values['ds_namv'];
  $data = $values['data'];

  if ($dss == 'loss') {
    return($data[1]*5);
  }
  if ($dss == 'median') {
    return($data[2]*1000);
  }
  return 0;
}
?>
