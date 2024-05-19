# Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

$NETSTAT = "$env:SystemRoot\System32\netstat.exe"

try {
    if (!(Test-Path $NETSTAT)) {
        Write-Error "$NETSTAT does not exist"
        exit 1
    }

    netstat -ano | Select-String -Pattern '\s+(TCP|UDP)' | Select-String -Pattern '\s+(LISTEN|ESTABL|UDP)'
} catch [System.Exception] {
    logError -function "get-sharepoint-ports-info" -command "$_.message" -message "$_.TargetSite"
}