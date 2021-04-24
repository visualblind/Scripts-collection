<?php

// -----------------------------------------------------------------------------
//
// phpFaber CMS v.1.0
// Copyright(C), phpFaber LLC, 2004-2005, All Rights Reserved.
// E-mail: products@phpfaber.com
//
// All forms of reproduction, including, but not limited to, internet posting,
// printing, e-mailing, faxing and recording are strictly prohibited.
// One license required per site running phpFaber CMS.
// To obtain a license for using phpFaber CMS, please register at
// http://www.phpfaber.com/i/products/cms/
//
// 10:27 PM 09/24/2005
//
// -----------------------------------------------------------------------------

if (!defined('INDEX_INCLUDED')) die('<code>You cannot access this file directly..</code>');

function module_GeoIP_Event($event,&$args)
{
  global $_CFG, $MOD_NAME;
  
  switch ($event) {
    case 'onAdmViewSummary':
      include_once "$_CFG->PATH_MOD/$MOD_NAME/includes/lib.module.php";
      $_MOD = new Modules($MOD_NAME);
      if ($args['A_SUMMARY']['geoip']) {
        $gi = new GeoIP("$_MOD->TPL/GeoIP.dat",GEOIP_STANDARD);
        foreach (array_keys($args['A_SUMMARY']['geoip']) as $k){
          $args['A_SUMMARY']['geoip'][$k] = $gi->get_country_code_n_name_by_addr($k);
        }
        $gi->close($gi);
      }
      break;
  }

}

?>
