#Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

try {
    $sysvol = Get-SmbShare | Where-Object { $_.Name -like '*SYSVOL*' } | Select-Object Name
    if ($sysvol -ne $null) {
        Write-Host "SYSVOL\"
    }
} catch [System.Exception] {
    logError -function "net-share" -command "$_.message" -message "$_.TargetSite"
}
