# Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

try {
    Get-CimInstance Win32_Process -Filter "Name = 'w3wp.exe'" | ForEach-Object {
        $commandLine = $_.CommandLine
        $var = ($commandLine -split '-h ')[1]
        $applicationHostConfigPath = ($var -split '"')[1]
        $result = ((Get-Content $applicationHostConfigPath) | Select-String -Pattern "bindingInformation" -Context 0,1).Line
        Write-Host ($result -replace "/>", "/>`n")
    }
} catch [System.Exception] {
    logError -function "get-sharepoint-ports-info" -command "$_.message" -message "$_.TargetSite"
}