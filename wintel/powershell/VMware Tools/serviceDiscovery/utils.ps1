#Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

#Checking necessary modules existance
Import-Module Microsoft.PowerShell.Management
if (!(Get-Module Microsoft.PowerShell.Management)) {
    Write-Error "Microsoft.PowerShell.Management module error"
    exit 1
}

Import-Module Microsoft.PowerShell.Utility
if (!(Get-Module Microsoft.PowerShell.Utility)){
    Write-Error "Microsoft.PowerShell.Utility module error"
    exit 1
}

if (!(Get-Command netstat -ErrorAction SilentlyContinue)) {
    Write-Host "netstat utility is not available."
    exit 1
}

Import-Module SmbShare
if (!(Get-Module SmbShare)) {
    Write-Host "Get-SmbShare not supported"
}

function testSymlink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$path
    )
    $item = Get-Item $Path -Force
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        return $true
    } else {
        return $false
    }
}


function isSecureOwner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path
    )

    $acl = Get-Acl -Path $Path
    $owner = (($acl | Select-Object Owner).Owner).ToLower()
    if ($owner -eq "nt authority\system") {
        return $true
    }
    if ($owner -eq "builtin\administrators") {
        return $true
    }
    return $false
}

function logError {
    param (
        [string]$function,
        [string]$command,
        [string]$message
    )
    try {
        $file = "$env:SystemRoot\Temp\vmware-sdmp-error.log"
        #rename if symlink with the same name exists or the file is insecure
        if ((Test-Path $file) -and ((testSymlink -path $file) -or !(isSecureOwner $file))) {
            $timestamp = Get-Date -Format "yyyyMMddHHmmssfff"
            $destination = $file + "-" + "$timestamp" + ".insecure"
            Move-Item -Path $file -Destination $destination | Out-Null
        }

        if (!(Test-Path $file)) {
            New-Item -ItemType File -Path $file | Out-Null
        } elseif ((Get-Item $file).Length -gt 1MB) {
            Set-Content -Path $file -Value ""
        }

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
        $caller = $MyInvocation.ScriptName

        $logMessage = "[{0}]: [{1}] {2}, {3}, {4}" -f $timestamp, "Error", $caller, $function, $command, $message

        # Write log message to error log file
        Add-Content -Path $file -Value $logMessage
    } catch [System.Exception] { }
}

function getListeningProcessIds {
    $pid_list = New-Object System.Collections.ArrayList
    try {
        netstat -ano | Select-Object -Skip 4 | ForEach-Object {
            $row = $_.Trim() -replace "\s+", " " -split "\s+"
            $processId = $row[$row.Length - 1]
            if (-not $pid_list.Contains($processId)) {
                $pid_list.Add($processId) | Out-Null
            }
        }

        $iisProcesses = Get-CimInstance Win32_Process | Where-Object {
            $_.CommandLine -like "*inetsrv`\inetinfo.exe*" -or
            $_.CommandLine -like "*\svchost.exe*iissvcs*" -or
            $_.Name -eq "w3wp.exe"
        } | Select-Object ProcessId

        foreach ($processId in $iisProcesses.ProcessId) {
            if (-not $pid_list.Contains($processId)) {
                $pid_list.Add($processId) | Out-Null
            }
        }

        return $pid_list

    } catch [System.Exception] {
        $errorMessage = $_.Exception.Message
        logError -function "getListeningProcessIds" -command "$_.message" -message "$_.Exception.Message"
    }
    return $pid_list
}

