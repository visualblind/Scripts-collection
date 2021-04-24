<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $permit_interface_modification=-1;
    $now = date("Y-m-d H:i:s",time());
    $interfaces = $jffnms->get("interfaces");

    $permit_interface_modification = profile("ADMIN_HOSTS");
?>
