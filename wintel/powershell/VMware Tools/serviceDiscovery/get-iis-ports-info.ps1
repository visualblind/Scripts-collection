# Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

try {
    # IIS 7 and above
    $applicationHostConfigPath = Join-Path $env:windir "system32\inetsrv\config\applicationHost.config"

    if (Test-Path $applicationHostConfigPath) {
        $result = ((Get-Content $applicationHostConfigPath) | Select-String -Pattern "bindingInformation" -Context 0,1).Line
        Write-Host ($result -replace "/>", "/>`n")
        if ($result -ne $null) {
            $installPath = Join-Path $env:windir "system32\inetsrv\"
            Write-Host "IIS InstallPath="$installPath
        }
    }

    # IIS 6 and below
    $metaBaseXmlPath = Join-Path $env:windir "system32\inetsrv\MetaBase.xml"
    if (Test-Path $metaBaseXmlPath) {
        $result = ((Get-Content $metaBaseXmlPath) | Select-String -Pattern "Bindings" -Context 0,1).Line
        Write-Host ($result -replace "/>", "/>`n")
        if ($result -ne $null) {
            $installPath = Join-Path $env:windir "system32\inetsrv\"
            Write-Host "IIS InstallPath="$installPath
        }
    }
} catch [System.Exception] {
    logError -function "get-iis-ports-info" -command "$_.message" -message "$_.TargetSite"
}