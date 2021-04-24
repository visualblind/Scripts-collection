#!/bin/bash
JFFNMS=`dirname $0`
cd $JFFNMS
php -q trap_receiver.php
