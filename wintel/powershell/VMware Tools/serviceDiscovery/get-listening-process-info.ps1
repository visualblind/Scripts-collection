# Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

. ".\utils.ps1"

try {
    $processIds = getListeningProcessIds

    foreach ($procid in $processIds){
       $procData = Get-CimInstance Win32_Process -Filter "ProcessId = $procid"  | Select-Object CommandLine, ExecutablePath, Name, ParentProcessId, ProcessId
       $StrTable = Out-String -InputObject $procData
       $StrTable = $StrTable -replace "`r`n\s+", "" -replace "\s+: ", "="
       $StrTable
    }
} catch [System.Exception] {
    logError -function "get-listening-process-info" -command "$_.message" -message "$_.TargetSite"
}