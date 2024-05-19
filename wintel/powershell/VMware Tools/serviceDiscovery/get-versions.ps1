#Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

$versionstart="VERSIONSTART"
$versionend="VERSIONEND"

function getRegPropValue {
        param($key, $regKey, $name)
    $errorMessage = $null
    try {
        $value=""
        if (Test-Path $regKey) {
            $exp = "(Get-ItemProperty -Path `"$regKey`").$name"
            $value = Invoke-Expression $exp -ErrorVariable errorMessage
        }
        Write-Host "$versionstart $key $value $versionend"
    } catch [System.Exception] {
        logError -function "getRegPropValue" -command $regKey -message $errorMessage
        Write-Host "$versionstart $key $versionend"
    }
}

# Oracel DB
getRegPropValue "oracle_db_versionregpath" "HKLM:\SOFTWARE\ORACLE\KEY_OraDb11g_home1" "ORACLE_HOME"

# MS-SQL DB
getRegPropValue "ms-sql_db_version9regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\90\Tools\ClientSetup\CurrentVersion" "CurrentVersion"
getRegPropValue "ms-sql_db_version10regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\100\Tools\ClientSetup\CurrentVersion" "CurrentVersion"
getRegPropValue "ms-sql_db_version11regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\110\Tools\ClientSetup\CurrentVersion" "CurrentVersion"
getRegPropValue "ms-sql_db_version12regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\120\Tools\ClientSetup\CurrentVersion" "CurrentVersion"
getRegPropValue "ms-sql_db_version13regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\130\Tools\ClientSetup\CurrentVersion" "CurrentVersion"
getRegPropValue "ms-sql_db_version15regpath" "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\150\Tools\ClientSetup\CurrentVersion" "CurrentVersion"


# VMware View
getRegPropValue "vmware_view_server_versionregpath" "HKLM:\SOFTWARE\VMware, Inc.\VMWare VDM" "productVersion"

# IIS
getRegPropValue "iis_versionregpath" "HKLM:\SOFTWARE\Microsoft\InetStp" "VersionString"

# SharePoint
getRegPropValue "sharepoint_serverrole12regpath" "HKLM:\SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\12.0\WSS" "ServerRole"
getRegPropValue "sharepoint_serverrole14regpath" "HKLM:\SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\14.0\WSS" "ServerRole"
getRegPropValue "sharepoint_serverrole15regpath" "HKLM:\SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\15.0\WSS" "ServerRole"
getRegPropValue "sharepoint_serverrole16regpath" "HKLM:\SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\16.0\WSS" "ServerRole"

# Exchange
getRegPropValue "exchange_version2003regpath" "HKLM:\SOFTWARE\Microsoft\Exchange\Setup" "ExchangeServerAdmin Version"
getRegPropValue "exchange_version2007regpath" "HKLM:\SOFTWARE\Microsoft\Exchange\v8.0\Setup" "MsiProductMajor"
getRegPropValue "exchange_version2010regpath" "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v14\Setup" "MsiProductMajor"
getRegPropValue "exchange_version2013or2016regpath" "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15\Setup" "MsiProductMajor"
getRegPropValue "exchange_version2013or2016minorregpath" "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15\Setup" "MsiProductMinor"

# Active Directory
try {
    $version = ((Get-ADObject (Get-ADRootDSE).SchemaNamingContext -Property objectVersion).objectVersion).toString("X")
    Write-Host $versionstart "active_directory_version" "0x$version" $versionend
} catch [System.Exception] {
    Write-Host "$versionstart "active_directory_version" $versionend"
}

# DB2
$command = "& db2level 2>`$null"
$pattern = 'DB2 v([\d\.]+)'
$errorMessage = $null
try {
    $cmdOutput = Invoke-Expression $command -ErrorVariable errorMessage
    $versionLine = $cmdOutput | Select-String -Pattern "DB2 v"
    Write-Host "$versionstart db2_version $versionLine $versionend"
} catch [System.Exception] {
    Write-Host "$versionstart db2_version $versionend"
}

# Get versions via command utils
$versionCommands = @{"Apache`.exe" = " -v";
                     "httpd`.exe" = " -v";
                     "mysqld`.exe" = " -V";
                     "`"VMware vCenter Site Recovery Manager`\bin`\vmware-dr`.exe`"" = " --version";
                     "sqlsrvr`.exe" = " -v"}

$pattern = '".*?"'
$processes = Get-WmiObject win32_service | select ProcessId, PathName
$processes | Where-object { $_.PathName -ne $null -and $_.PathName -ne "" } | Select-Object PathName, ProcessId | ForEach-Object {
    if ($_.PathName -match $pattern) {
        $path = $Matches[0].Trim('"')
        $processId = $_.ProcessId
        $command = $null
        $versionCommands.Keys | ForEach-Object {
            $regex = $_
            if ($path -match $regex) {
                $errorMessage = $null
                try {
                    Write-Host $versionstart $processId
                    $command = "&`"" + $path + '"' + $versionCommands[$regex]
                    $command = $command + " 2>`$null"
                    Invoke-Expression $command -ErrorVariable errorMessage
                    Write-Host $versionend
                } catch [System.Exception] {}
            }
        }
    }
}

# Get nginix versions via command utils
$processIds = getListeningProcessIds
$processes = Get-Process | Where-Object { $_.ProcessName -eq "nginx" }
$processes | Where-object { $_.Path -ne $null -and $_.Path -ne "" } | Select-Object Path, Id | ForEach-Object {
    if ($processIds.Contains($_.Id.ToString())) {
        $path = $_.Path
        $processId = $_.Id
        try {
            $command = $path + " -v" + " 2>&1"
            $out = Invoke-Expression $command
            $exceptionStr = $out.Exception.ToString()
            $outputString = ($exceptionStr -split ":", 2)[-1].Trim()
            Write-Host $versionstart $processId $outputString $versionend
        } catch [System.Exception] {}
    }
}
