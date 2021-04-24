<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_verify_smokeping_number($options)
{
    //Check that required options are here
    if (!isset($options['interface']) || !isset($options['ro_community']))
        return -1;
    
    $topdir = $options['ro_community'];
    $ifaces = array();
    scan_dir($topdir, &$ifaces);

    $ifnum = 0;
    foreach($ifaces as $key => $ifname) {
      if (preg_match('%^'.$topdir.'/(.*)\.rrd$%', $ifname, $regs)) {
	$ifnum++;
        if ($options['interface'] == $regs[1]) {
	  return $ifnum;
	}
      }
    }
    return -1;
}

  function scan_dir($parent, &$ifaces)
  {
    if (!is_dir($parent)) {
      return;
    }
    if ($dir = opendir($parent)) {
      while (($file = readdir($dir)) !== false) {
        if ($file == '.' || $file == '..')
	  continue;
	if (is_dir($parent.'/'.$file)) {
	  scan_dir($parent.'/'.$file, &$ifaces);
	} else {
	  if (preg_match('/\.rrd$/', $file)) {
	    $ifaces[] = $parent.'/'.$file;
	  }
	}
     }
   }
 }

?>
