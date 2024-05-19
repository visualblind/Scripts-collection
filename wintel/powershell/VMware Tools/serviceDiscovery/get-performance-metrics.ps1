#Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

$TYPEPERF = "$env:SystemRoot\System32\typeperf.exe"

if (!(Test-Path $TYPEPERF)) {
    Write-Error "$TYPEPERF doesn't exist"
    exit 1
}
try {
    $config_file = ".\get-performance-metrics.cfg"

    & $TYPEPERF -cf $config_file -sc 1

} catch [System.Exception] {
    logError -function "get-performace-metrics" -command "$_.message" -message "$_.TargetSite"
}