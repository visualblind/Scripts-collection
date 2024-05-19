# Copyright (C) 2020,2023 VMware, Inc.  All rights reserved.

try {
    Get-CimInstance Win32_Process | Select-Object ProcessId, ParentProcessId | format-list
} catch [System.Exception] {
    logError -function "get-parent-child-rels" -command "$_.message" -message "$_.TargetSite"
}