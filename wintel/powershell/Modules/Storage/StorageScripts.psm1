############################
#
# Copyright (c) Microsoft Corporation
#
# Abstract:
#   SMAPI script cmdlets
#
############################

using namespace System.Management.Automation.Runspaces

import-module Storage\StorageHealth.cdxml
import-module Storage\StorageSubSystem.cdxml

$StorageNamespace = 'root\microsoft\windows\storage'
$WmiNamespace     = 'root\wmi'
$ClusterNamespace = 'root\mscluster'

$Global:StorageHistoryCharts = [Hashtable]::Synchronized(@{})

function CreateErrorRecord
{
    Param
    (
        [String]
        $ErrorId,

        [String]
        $ErrorMessage,

        [System.Management.Automation.ErrorCategory]
        $ErrorCategory,

        [Exception]
        $Exception,

        [Object]
        $TargetObject
    )

    if($Exception -eq $null)
    {
        $Exception = New-Object System.Management.Automation.RuntimeException $ErrorMessage
    }

    $errorRecord = New-Object System.Management.Automation.ErrorRecord @($Exception, $ErrorId, $ErrorCategory, $TargetObject)
    return $errorRecord
}

class StorageHistory
{
    [UInt16]$Version
    [String]$FriendlyName
    [String]$SerialNumber
    [String]$AdapterSerialNumber
    [String]$FirmwareRevision
    [String]$DeviceGuid
    [String]$DeviceNumber
    [String]$BusType
    [String]$MediaType
    [DateTime]$EventTime
    [UInt32]$MaxQueueCount
    [UInt32]$MaxOutstandingCount
    [UInt64]$TotalIoCount
    [UInt64]$SuccessIoCount
    [UInt64]$FailedIoCount
    [UInt64]$TotalReadBytes
    [UInt64]$TotalWriteBytes
    [UInt64]$TotalIoLatency
    [UInt64]$AvgIoLatency
    [UInt64]$MaxIoLatency
    [UInt64]$MaxFlushLatency
    [UInt64]$MaxUnmapLatency
    [UInt64]$TotalQueueIoCount
    [UInt64]$TotalQueueIoWaitTime
    [UInt64]$AvgQueueIoWaitTime
    [UInt64]$MaxQueueIoWaitTime
    [UInt32]$IoTimeout
    [UInt64]$QueueIoWaitExceededTimeoutCount
    [UInt64]$QueueIoBusyCount
    [UInt64]$QueueIoPausedCount
    [UInt64]$QueueIoUntaggedCommandOutstandingCount
    [UInt64]$QueueIoPausedForUntaggedCount
    [UInt64]$TotalErrors
    [UInt64]$TotalReadWriteErrors
    [UInt64]$TotalImpendingDeviceFailureErrors
    [UInt64]$TotalDeviceFailureErrors
    [UInt16]$BucketCount
    [UInt64[]]$BucketIoLatency
    [UInt64[]]$BucketSuccessIoCount
    [UInt64[]]$BucketFailedIoCount
    [UInt64[]]$BucketTotalIoCount
    [UInt64[]]$BucketTotalIoTime
    [Single[]]$BucketIoPercent
    [UInt16]$HighestLatencyBucket
    [System.Collections.ArrayList]$UnresponsiveTime
    [System.Collections.ArrayList]$ResponsiveTime
}

class StorageHistoryAggregate
{
    [UInt16]$Version
    [String]$FriendlyName
    [String]$SerialNumber
    [String]$AdapterSerialNumber
    [String]$FirmwareRevision
    [String]$DeviceGuid
    [String]$DeviceNumber
    [String]$BusType
    [String]$MediaType
    [DateTime]$StartTime
    [DateTime]$EndTime
    [UInt32]$EventCount
    [UInt32]$MaxQueueCount
    [UInt32]$MaxOutstandingCount
    [Double]$TotalIoCount
    [Double]$SuccessIoCount
    [Double]$FailedIoCount
    [Double]$TotalReadBytes
    [Double]$TotalWriteBytes
    [Double]$TotalIoLatency
    [UInt64]$AvgIoLatency
    [UInt64]$MaxIoLatency
    [UInt64]$MaxFlushLatency
    [UInt64]$MaxUnmapLatency
    [Double]$TotalQueueIoCount
    [Double]$TotalQueueIoWaitTime
    [UInt64]$AvgQueueIoWaitTime
    [UInt64]$MaxQueueIoWaitTime
    [UInt32]$IoTimeout
    [Double]$QueueIoWaitExceededTimeoutCount
    [Double]$QueueIoBusyCount
    [Double]$QueueIoPausedCount
    [Double]$QueueIoUntaggedCommandOutstandingCount
    [Double]$QueueIoPausedForUntaggedCount
    [Double]$TotalErrors
    [Double]$TotalReadWriteErrors
    [Double]$TotalImpendingDeviceFailureErrors
    [Double]$TotalDeviceFailureErrors
    [UInt16]$BucketCount
    [UInt64[]]$BucketIoLatency
    [Double[]]$BucketSuccessIoCount
    [Double[]]$BucketFailedIoCount
    [Double[]]$BucketTotalIoCount
    [Double[]]$BucketTotalIoTime
    [UInt32[]]$BucketIoPercent
    [UInt32[]]$BucketHighestLatencyCount
}

class StorageError
{
    [UInt16]$Version
    [String]$FriendlyName
    [String]$SerialNumber
    [String]$AdapterSerialNumber
    [String]$FirmwareRevision
    [String]$DeviceGuid
    [String]$DeviceNumber
    [String]$BusType
    [String]$MediaType
    [DateTime]$EventTime
    [UInt32]$ServiceDuration
    [UInt32]$QueueWaitDuration
    [Byte]$Command
    [Byte]$SrbStatus
    [Byte]$ScsiStatus
    [Byte]$SenseKey
    [Byte]$SenseCode
    [Byte]$SenseCodeQualifier
    [UInt32]$IoSize
    [UInt32]$QueueDepth
    [UInt64]$LBA
}


$PopulateStorageError = {

    Param
    (
        [Ref]
        $Object,

        [System.Diagnostics.Eventing.Reader.EventRecord]
        $EventRecord,

        [System.String]
        $FriendlyName,

        [System.String]
        $SerialNumber,

        [System.String]
        $AdapterSerialNumber,

        [System.String]
        $FirmwareRevision,

        [System.String]
        $DeviceGuid,

        [System.String]
        $Number,

        [System.String]
        $BusType,

        [System.String]
        $MediaType
    )

    $eventXml = [XML]$EventRecord.ToXml()
    $tempObject = [PsCustomObject]@{}

    for ($index = 0; $index -lt $eventXml.Event.EventData.Data.Count; $index++)
    {
        $tempObject | Add-Member -MemberType NoteProperty `
                                 -Name $eventXml.Event.EventData.Data[$index].Name `
                                 -Value $eventXml.Event.EventData.Data[$index].'#Text'
    }

    $Object.Value.PSObject.TypeNames.Insert( 0, "Microsoft.Windows.StorageManagement.StorageError" )
    $Object.Value.PSObject.TypeNames.Insert( 1, "Microsoft.Windows.StorageManagement.StorageError_v1" )

    $Object.Value.Version = [UInt16]$tempObject.Version

    if ([String]::IsNullOrEmpty($FriendlyName) -eq $false)
    {
        $Object.Value.FriendlyName = $FriendlyName
    }
    else
    {
        $Object.Value.FriendlyName = $tempObject.ProductId
    }

    if ([String]::IsNullOrEmpty($SerialNumber) -eq $false)
    {
        $Object.Value.SerialNumber = $SerialNumber
    }
    else
    {
        $Object.Value.SerialNumber = $tempObject.SerialNumber
    }

    if ([String]::IsNullOrEmpty($AdapterSerialNumber) -eq $false)
    {
        $Object.Value.AdapterSerialNumber = $AdapterSerialNumber
    }
    else
    {
        $Object.Value.AdapterSerialNumber = $tempObject.AdapterSerialNumber
    }

    if ([String]::IsNullOrEmpty($FirmwareRevision) -eq $false)
    {
        $Object.Value.FirmwareRevision = $FirmwareRevision
    }

    $Object.Value.DeviceGuid          = $DeviceGuid
    $Object.Value.DeviceNumber        = $Number

    if ([String]::IsNullOrEmpty($BusType) -eq $false)
    {
        $Object.Value.BusType         = $BusType
    }
    else
    {
        switch ($tempObject.BusType)
        {
            "8"     { $Object.Value.BusType = "RAID" }
            "10"    { $Object.Value.BusType = "SAS" }
            "11"    { $Object.Value.BusType = "SATA" }
            "14"    { $Object.Value.BusType = "Virtual" }
            "17"    { $Object.Value.BusType = "NVMe" }
            "19"    { $Object.Value.BusType = "UFS" }
            default { $Object.Value.BusType = "Unknown" }
        }
    }

    $Object.Value.MediaType          = $MediaType
    $Object.Value.EventTime          = $event.TimeCreated
    $Object.Value.ServiceDuration    = $tempObject.RequestDuration_ms
    $Object.Value.QueueWaitDuration  = $tempObject.WaitDuration_ms
    $Object.Value.Command            = $tempObject.Command
    $Object.Value.SrbStatus          = $tempObject.SrbStatus
    $Object.Value.ScsiStatus         = $tempObject.ScsiStatus
    $Object.Value.SenseKey           = $tempObject.SenseKey
    $Object.Value.SenseCode          = $tempObject.AddSense
    $Object.Value.SenseCodeQualifier = $tempObject.AddSenseQ
    $Object.Value.IoSize             = $tempObject.IoSize
    $Object.Value.QueueDepth         = $tempObject.QueueDepth
    $Object.Value.LBA                = $tempObject.LBA
}


$PopulateStorageHistory = {

    Param
    (
        [Ref]
        $Object,

        [System.Diagnostics.Eventing.Reader.EventRecord]
        $EventRecord,

        [System.String]
        $FriendlyName,

        [System.String]
        $SerialNumber,

        [System.String]
        $AdapterSerialNumber,

        [System.String]
        $FirmwareRevision,

        [System.String]
        $DeviceGuid,

        [System.String]
        $Number,

        [System.String]
        $BusType,

        [System.String]
        $MediaType
    )

    $eventXml = [XML]$EventRecord.ToXml()
    $tempObject = [PsCustomObject]@{}

    for ($index = 0; $index -lt $eventXml.Event.EventData.Data.Count; $index++)
    {
        $tempObject | Add-Member -MemberType NoteProperty `
                                 -Name $eventXml.Event.EventData.Data[$index].Name `
                                 -Value $eventXml.Event.EventData.Data[$index].'#Text'
    }

    $Object.Value.PSObject.TypeNames.Insert( 0, "Microsoft.Windows.StorageManagement.StorageHistory" )

    $Object.Value.Version = [UInt16]$tempObject.Version

    if ([String]::IsNullOrEmpty($FriendlyName) -eq $false)
    {
        $Object.Value.FriendlyName = $FriendlyName
    }
    else
    {
        $Object.Value.FriendlyName = $tempObject.ProductId
    }

    if ([String]::IsNullOrEmpty($SerialNumber) -eq $false)
    {
        $Object.Value.SerialNumber = $SerialNumber
    }
    else
    {
        $Object.Value.SerialNumber = $tempObject.SerialNumber
    }

    if ([String]::IsNullOrEmpty($AdapterSerialNumber) -eq $false)
    {
        $Object.Value.AdapterSerialNumber = $AdapterSerialNumber
    }
    else
    {
        $Object.Value.AdapterSerialNumber = $tempObject.AdapterSerialNumber
    }

    if ([String]::IsNullOrEmpty($FirmwareRevision) -eq $false)
    {
        $Object.Value.FirmwareRevision = $FirmwareRevision
    }
    else
    {
        $Object.Value.FirmwareRevision = $tempObject.FirmwareRevision
    }

    $Object.Value.DeviceGuid          = $DeviceGuid
    $Object.Value.DeviceNumber        = $Number

    if ([String]::IsNullOrEmpty($BusType) -eq $false)
    {
        $Object.Value.BusType         = $BusType
    }
    else
    {
        switch ($tempObject.BusType)
        {
            "8"     { $Object.Value.BusType = "RAID" }
            "10"    { $Object.Value.BusType = "SAS" }
            "11"    { $Object.Value.BusType = "SATA" }
            "14"    { $Object.Value.BusType = "Virtual" }
            "17"    { $Object.Value.BusType = "NVMe" }
            "19"    { $Object.Value.BusType = "UFS" }
            default { $Object.Value.BusType = "Unknown" }
        }
    }

    $Object.Value.MediaType           = $MediaType
    $Object.Value.EventTime           = $event.TimeCreated
    $Object.Value.MaxQueueCount       = [UInt32]$tempObject.MaxDeviceQueueCount
    $Object.Value.MaxOutstandingCount = [UInt32]$tempObject.MaxOutstandingCount

    if ($Object.Value.Version -eq 5)
    {
        $Object.Value.PSObject.TypeNames.Insert( 1, "Microsoft.Windows.StorageManagement.StorageHistory_v5" )

        $Object.Value.BucketCount          = 5
        $Object.Value.BucketIoLatency      = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketSuccessIoCount = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketFailedIoCount  = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketTotalIoCount   = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketTotalIoTime    = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketIoPercent      = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount

        $Object.Value.BucketIoLatency[0] =    16 * 10000 # 16 ms in 100ns
        $Object.Value.BucketIoLatency[1] =    64 * 10000 # 64 ms in 100ns
        $Object.Value.BucketIoLatency[2] =  2048 * 10000 # 2048 ms in 100ns
        $Object.Value.BucketIoLatency[3] =  5120 * 10000 # 5120 ms in 100ns
        $Object.Value.BucketIoLatency[4] = 10000 * 10000 # 5120+ ms approx to 10000 ms in 100ns

        for ($index = 0; $index -lt $Object.Value.BucketCount; $index++)
        {
            $field = "BucketIoCount" + [System.String]($index + 1)
            $Object.Value.BucketTotalIoCount[$index] = $($tempObject.$field)
            $Object.Value.BucketTotalIoTime[$index]  = $Object.Value.BucketTotalIoCount[$index] * $Object.Value.BucketIoLatency[$index]

            $Object.Value.TotalIoCount   += $Object.Value.BucketTotalIoCount[$index]
            $Object.Value.TotalIoLatency += $Object.Value.BucketTotalIoTime[$index]

            if ($Object.Value.BucketTotalIoCount[$index] -gt 0)
            {
                $Object.Value.MaxIoLatency         = $Object.Value.BucketIoLatency[$index]
                $Object.Value.HighestLatencyBucket = $index
            }
        }

        if ($Object.Value.TotalIoCount -gt 0)
        {
            for ($index = 0; $index -lt $Object.Value.BucketCount; $index++)
            {
                $Object.Value.BucketIoPercent[$index] = ($Object.Value.BucketTotalIoCount[$index] * 100) / $Object.Value.TotalIoCount
            }
        }
    }
    elseif (($Object.Value.Version -ge 9) -or  ($Object.Value.Version -le 11))
    {
        $Object.Value.PSObject.TypeNames.Insert( 1, "Microsoft.Windows.StorageManagement.StorageHistory_v11" )

        $Object.Value.TotalIoCount    = $tempObject.TotalIoCount
        $Object.Value.TotalReadBytes  = $tempObject.TotalReadBytes
        $Object.Value.TotalWriteBytes = $tempObject.TotalWriteBytes
        $Object.Value.MaxIoLatency    = $tempObject.MaxReadWriteLatency_100ns
        $Object.Value.MaxFlushLatency = $tempObject.MaxFlushLatency_100ns
        $Object.Value.MaxUnmapLatency = $tempObject.MaxUnmapLatency_100ns

        if ($Object.Value.Version -eq 11)
        {
            $Object.Value.TotalQueueIoCount                       = $tempObject.TotalDeviceQueueIoCount
            $Object.Value.TotalQueueIoWaitTime                    = $tempObject.TotalDeviceQueueIoWaitDuration_100ns
            $Object.Value.MaxQueueIoWaitTime                      = $tempObject.MaxDeviceQueueIoWaitDuration_100ns
            $Object.Value.IoTimeout                               = $tempObject.IoTimeout_s
            $Object.Value.QueueIoWaitExceededTimeoutCount         = $tempObject.DeviceQueueIoWaitExceededTimeoutCount
            $Object.Value.QueueIoBusyCount                        = $tempObject.DeviceQueueIoBusyCount
            $Object.Value.QueueIoPausedCount                      = $tempObject.DeviceQueueIoPausedCount
            $Object.Value.QueueIoUntaggedCommandOutstandingCount  = $tempObject.DeviceQueueIoUntaggedCommandOutstandingCount
            $Object.Value.QueueIoPausedForUntaggedCount           = $tempObject.DeviceQueueIoPausedForUntaggedCount
        }

        $Object.Value.BucketCount          = 12
        $Object.Value.BucketIoLatency      = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketSuccessIoCount = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketFailedIoCount  = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketTotalIoCount   = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketTotalIoTime    = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount
        $Object.Value.BucketIoPercent      = New-Object -TypeName System.UInt64[] $Object.Value.BucketCount

        $Object.Value.BucketIoLatency[0]  =    256 * 10    # 256 us in 100ns
        $Object.Value.BucketIoLatency[1]  =      1 * 10000 # 1 ms in 100ns
        $Object.Value.BucketIoLatency[2]  =      4 * 10000 # 4 ms in 100ns
        $Object.Value.BucketIoLatency[3]  =     16 * 10000 # 16 ms in 100ns
        $Object.Value.BucketIoLatency[4]  =     64 * 10000 # 64 ms in 100ns
        $Object.Value.BucketIoLatency[5]  =    128 * 10000 # 128 ms in 100ns
        $Object.Value.BucketIoLatency[6]  =    256 * 10000 # 256 ms in 100ns
        $Object.Value.BucketIoLatency[7]  =   2000 * 10000 # 2000 ms in 100ns
        $Object.Value.BucketIoLatency[8]  =   6000 * 10000 # 6000 ms in 100ns
        $Object.Value.BucketIoLatency[9]  =  10000 * 10000 # 10000 ms in 100ns
        $Object.Value.BucketIoLatency[10] =  20000 * 10000 # 20000 ms in 100ns
        $Object.Value.BucketIoLatency[11] =  30000 * 10000 # 20000+ ms approx to 30000 ms in 100ns

        for ($index = 0; $index -lt $Object.Value.BucketCount; $index++)
        {
            $field = "BucketIoSuccess" + [System.String]($index + 1)
            $Object.Value.BucketSuccessIoCount[$index] = $($tempObject.$field)

            $field = "BucketIoFailed" + [System.String]($index + 1)
            $Object.Value.BucketFailedIoCount[$index] = $($tempObject.$field)

            $field = "BucketIoLatency" + [System.String]($index + 1) + "_100ns"
            $Object.Value.BucketTotalIoTime[$index] = $($tempObject.$field)

            $Object.Value.BucketTotalIoCount[$index] = $Object.Value.BucketSuccessIoCount[$index] + $Object.Value.BucketFailedIoCount[$index]

            $Object.Value.SuccessIoCount         += $Object.Value.BucketSuccessIoCount[$index]
            $Object.Value.FailedIoCount          += $Object.Value.BucketFailedIoCount[$index]
            $Object.Value.TotalIoLatency         += $Object.Value.BucketTotalIoTime[$index]

            if ($Object.Value.TotalIoCount -gt 0)
            {
                $Object.Value.BucketIoPercent[$index] = ($Object.Value.BucketTotalIoCount[$index] * 100) / $Object.Value.TotalIoCount
            }

            if ($Object.Value.BucketTotalIoCount[$index] -gt 0)
            {
                $Object.Value.HighestLatencyBucket = $index
            }
        }
    }

    if ($Object.Value.TotalIoCount -gt 0)
    {
        $Object.Value.AvgIoLatency = $Object.Value.TotalIoLatency / $Object.Value.TotalIoCount
    }

    if (($Object.Value.Version -eq 11) -and ($Object.Value.TotalQueueIoCount -gt 0))
    {
        $Object.Value.AvgQueueIoWaitTime = $Object.Value.TotalQueueIoWaitTime / $Object.Value.TotalQueueIoCount
    }
}


$AugmentStorageHistory = {

    Param
    (
        [Ref]
        $Object,

        [System.Diagnostics.Eventing.Reader.EventRecord]
        $EventRecord
    )

    $eventXml = [XML]$EventRecord.ToXml()
    $tempObject = [PsCustomObject]@{}

    for ($index = 0; $index -lt $eventXml.Event.EventData.Data.Count; $index++)
    {
        $tempObject | Add-Member -MemberType NoteProperty `
                                 -Name $eventXml.Event.EventData.Data[$index].Name `
                                 -Value $eventXml.Event.EventData.Data[$index].'#Text'
    }

    if ($EventRecord.Id -eq 502)
    {
        if ($Object.Value.UnresponsiveTime -eq $null)
        {
            $Object.Value.UnresponsiveTime = New-Object System.Collections.ArrayList
        }

        $Object.Value.UnresponsiveTime.Add($EventRecord.TimeCreated)
    }
    elseif ($EventRecord.Id -eq 503)
    {
        if ($Object.Value.ResponsiveTime -eq $null)
        {
            $Object.Value.ResponsiveTime = New-Object System.Collections.ArrayList
        }

        $Object.Value.ResponsiveTime.Add($EventRecord.TimeCreated)
    }
    elseif ($EventRecord.Id -eq 504)
    {
        $Object.Value.TotalErrors                       = $tempObject.TotalErrors
        $Object.Value.TotalReadWriteErrors              = $tempObject.TotalReadWriteErrors
        $Object.Value.TotalImpendingDeviceFailureErrors = $tempObject.TotalImpendingDeviceFailureErrors
        $Object.Value.TotalDeviceFailureErrors          = $tempObject.TotalDeviceFailureErrors
    }
}


$PopulateStorageHistoryAggregate = {

    Param
    (
        [Ref]
        $AggregateObject,

        [Ref]
        $Object
    )

    if ($AggregateObject.Value.Version -eq 0)
    {
        $AggregateObject.Value.PSObject.TypeNames.Insert( 0, "Microsoft.Windows.StorageManagement.StorageHistoryAggregate" )

        if ($Object.Value.Version -eq 5)
        {
            $AggregateObject.Value.PSObject.TypeNames.Insert( 1, "Microsoft.Windows.StorageManagement.StorageHistoryAggregate_v5" )
        }
        elseif (($Object.Value.Version -ge 9) -or  ($Object.Value.Version -le 11))
        {
            $AggregateObject.Value.PSObject.TypeNames.Insert( 1, "Microsoft.Windows.StorageManagement.StorageHistoryAggregate_v11" )
        }

        $AggregateObject.Value.Version                  = $Object.Value.Version
        $AggregateObject.Value.FriendlyName             = $Object.Value.FriendlyName
        $AggregateObject.Value.SerialNumber             = $Object.Value.SerialNumber
        $AggregateObject.Value.AdapterSerialNumber      = $Object.Value.AdapterSerialNumber
        $AggregateObject.Value.FirmwareRevision         = $Object.Value.FirmwareRevision
        $AggregateObject.Value.DeviceGuid               = $Object.Value.DeviceGuid
        $AggregateObject.Value.DeviceNumber             = $Object.Value.DeviceNumber
        $AggregateObject.Value.BusType                  = $Object.Value.BusType
        $AggregateObject.Value.MediaType                = $Object.Value.MediaType
        $AggregateObject.Value.StartTime                = $Object.Value.EventTime
        $AggregateObject.Value.EndTime                  = $Object.Value.EventTime
        $AggregateObject.Value.EventCount               = 1
        $AggregateObject.Value.MaxQueueCount            = $Object.Value.MaxQueueCount
        $AggregateObject.Value.MaxOutstandingCount      = $Object.Value.MaxOutstandingCount
        $AggregateObject.Value.TotalIoCount             = $Object.Value.TotalIoCount
        $AggregateObject.Value.SuccessIoCount           = $Object.Value.SuccessIoCount
        $AggregateObject.Value.FailedIoCount            = $Object.Value.FailedIoCount
        $AggregateObject.Value.TotalReadBytes           = $Object.Value.TotalReadBytes
        $AggregateObject.Value.TotalWriteBytes          = $Object.Value.TotalWriteBytes
        $AggregateObject.Value.TotalIoLatency           = $Object.Value.TotalIoLatency
        $AggregateObject.Value.MaxIoLatency             = $Object.Value.MaxIoLatency
        $AggregateObject.Value.MaxFlushLatency          = $Object.Value.MaxFlushLatency
        $AggregateObject.Value.MaxUnmapLatency          = $Object.Value.MaxUnmapLatency
        $AggregateObject.Value.TotalQueueIoCount        = $Object.Value.TotalQueueIoCount
        $AggregateObject.Value.TotalQueueIoWaitTime     = $Object.Value.TotalQueueIoWaitTime
        $AggregateObject.Value.MaxQueueIoWaitTime       = $Object.Value.MaxQueueIoWaitTime

        if ($Object.Value.IoTimeout)
        {
            $AggregateObject.Value.IoTimeout = $Object.Value.IoTimeout
        }

        $AggregateObject.Value.QueueIoWaitExceededTimeoutCount        = $Object.Value.QueueIoWaitExceededTimeoutCount
        $AggregateObject.Value.QueueIoBusyCount                       = $Object.Value.QueueIoBusyCount
        $AggregateObject.Value.QueueIoPausedCount                     = $Object.Value.QueueIoPausedCount
        $AggregateObject.Value.QueueIoUntaggedCommandOutstandingCount = $Object.Value.QueueIoUntaggedCommandOutstandingCount
        $AggregateObject.Value.QueueIoPausedForUntaggedCount          = $Object.Value.QueueIoPausedForUntaggedCount
        $AggregateObject.Value.TotalErrors                            = $Object.Value.TotalErrors
        $AggregateObject.Value.TotalReadWriteErrors                   = $Object.Value.TotalReadWriteErrors
        $AggregateObject.Value.TotalImpendingDeviceFailureErrors      = $Object.Value.TotalImpendingDeviceFailureErrors
        $AggregateObject.Value.TotalDeviceFailureErrors               = $Object.Value.TotalDeviceFailureErrors
        $AggregateObject.Value.BucketCount                            = $Object.Value.BucketCount

        $AggregateObject.Value.BucketIoLatency               = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketSuccessIoCount          = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketFailedIoCount           = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketTotalIoCount            = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketTotalIoTime             = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketIoPercent               = New-Object -TypeName System.UInt64[] $AggregateObject.Value.BucketCount
        $AggregateObject.Value.BucketHighestLatencyCount     = New-Object -TypeName System.UInt32[] $AggregateObject.Value.BucketCount

        for ($index = 0; $index -lt $AggregateObject.Value.BucketCount; $index++)
        {
            $AggregateObject.Value.BucketIoLatency[$index]      = $Object.Value.BucketIoLatency[$index]
            $AggregateObject.Value.BucketSuccessIoCount[$index] = $Object.Value.BucketSuccessIoCount[$index]
            $AggregateObject.Value.BucketFailedIoCount[$index]  = $Object.Value.BucketFailedIoCount[$index]
            $AggregateObject.Value.BucketTotalIoCount[$index]   = $Object.Value.BucketTotalIoCount[$index]
            $AggregateObject.Value.BucketTotalIoTime[$index]    = $Object.Value.BucketTotalIoTime[$index]
        }

        $AggregateObject.Value.BucketHighestLatencyCount[$($Object.Value.HighestLatencyBucket)]++

    }
    else
    {
        if ($Object.Value.Version -ne $AggregateObject.Value.Version)
        {
            return
        }

        if ($Object.Value.EventTime -lt $AggregateObject.Value.StartTime)
        {
            $AggregateObject.Value.StartTime = $Object.Value.EventTime
        }

        if ($Object.Value.EventTime -gt $AggregateObject.Value.EndTime)
        {
            $AggregateObject.Value.EndTime = $Object.Value.EventTime
        }

        $AggregateObject.Value.EventCount++

        if ($Object.Value.MaxQueueCount -gt $AggregateObject.Value.MaxQueueCount)
        {
            $AggregateObject.Value.MaxQueueCount = $Object.Value.MaxQueueCount
        }

        if ($Object.Value.MaxOutstandingCount -gt $AggregateObject.Value.MaxOutstandingCount)
        {
            $AggregateObject.Value.MaxOutstandingCount = $Object.Value.MaxOutstandingCount
        }

        $AggregateObject.Value.TotalIoCount    += $Object.Value.TotalIoCount
        $AggregateObject.Value.SuccessIoCount  += $Object.Value.SuccessIoCount
        $AggregateObject.Value.FailedIoCount   += $Object.Value.FailedIoCount
        $AggregateObject.Value.TotalReadBytes  += $Object.Value.TotalReadBytes
        $AggregateObject.Value.TotalWriteBytes += $Object.Value.TotalWriteBytes
        $AggregateObject.Value.TotalIoLatency  += $Object.Value.TotalIoLatency

        if ($Object.Value.MaxIoLatency -gt $AggregateObject.Value.MaxIoLatency)
        {
            $AggregateObject.Value.MaxIoLatency = $Object.Value.MaxIoLatency
        }

        if ($Object.Value.MaxFlushLatency -gt $AggregateObject.Value.MaxFlushLatency)
        {
            $AggregateObject.Value.MaxFlushLatency = $Object.Value.MaxFlushLatency
        }

        if ($Object.Value.MaxUnmapLatency -gt $AggregateObject.Value.MaxUnmapLatency)
        {
            $AggregateObject.Value.MaxUnmapLatency = $Object.Value.MaxUnmapLatency
        }

        $AggregateObject.Value.TotalQueueIoCount    += $Object.Value.TotalQueueIoCount
        $AggregateObject.Value.TotalQueueIoWaitTime += $Object.Value.TotalQueueIoWaitTime

        if ($Object.Value.MaxQueueIoWaitTime -gt $AggregateObject.Value.MaxQueueIoWaitTime)
        {
            $AggregateObject.Value.MaxQueueIoWaitTime = $Object.Value.MaxQueueIoWaitTime
        }

        if ($Object.Value.IoTimeout)
        {
            $AggregateObject.Value.IoTimeout = $Object.Value.IoTimeout
        }

        $AggregateObject.Value.QueueIoWaitExceededTimeoutCount        += $Object.Value.QueueIoWaitExceededTimeoutCount
        $AggregateObject.Value.QueueIoBusyCount                       += $Object.Value.QueueIoBusyCount
        $AggregateObject.Value.QueueIoPausedCount                     += $Object.Value.QueueIoPausedCount
        $AggregateObject.Value.QueueIoUntaggedCommandOutstandingCount += $Object.Value.QueueIoUntaggedCommandOutstandingCount
        $AggregateObject.Value.QueueIoPausedForUntaggedCount          += $Object.Value.QueueIoPausedForUntaggedCount
        $AggregateObject.Value.TotalErrors                            += $Object.Value.TotalErrors
        $AggregateObject.Value.TotalReadWriteErrors                   += $Object.Value.TotalReadWriteErrors
        $AggregateObject.Value.TotalImpendingDeviceFailureErrors      += $Object.Value.TotalImpendingDeviceFailureErrors
        $AggregateObject.Value.TotalDeviceFailureErrors               += $Object.Value.TotalDeviceFailureErrors

        for ($index = 0; $index -lt $AggregateObject.Value.BucketCount; $index++)
        {
            $AggregateObject.Value.BucketSuccessIoCount[$index] += $Object.Value.BucketSuccessIoCount[$index]
            $AggregateObject.Value.BucketFailedIoCount[$index]  += $Object.Value.BucketFailedIoCount[$index]
            $AggregateObject.Value.BucketTotalIoCount[$index]   += $Object.Value.BucketTotalIoCount[$index]
            $AggregateObject.Value.BucketTotalIoTime[$index]    += $Object.Value.BucketTotalIoTime[$index]
        }

        $AggregateObject.Value.BucketHighestLatencyCount[$($Object.Value.HighestLatencyBucket)]++
    }
}


function Get-StorageHistory
{
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByDeviceGuid',
            ValueFromPipeline = $false,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("DeviceId")]
        $DeviceGuid,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByDeviceNumber',
            ValueFromPipeline = $false,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $DeviceNumber,

        #### ------------------------- PhysicalDisk parameters -----------------------####

        [System.Management.Automation.PSCredential]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        $Credential,

        #### ------------------------- Common method parameters ----------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $LogFile,

        [UInt32]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        $NumberOfHours,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        $Disaggregate,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        $Errors
    )

    Begin
    {
    }

    Process
    {
        #
        # Get the device id based on the parameter set
        #

        switch -regex ($psCmdlet.ParameterSetName)
        {
            { @(                  `
                "ByPhysicalDisk", `
                "ByDeviceNumber"  `
                ) -contains $_    `
            }
            {
                #
                # If device number is specified,
                # get the corresponding device
                #

                try
                {
                    if ($DeviceNumber)
                    {
                        $PhysicalDisk = Get-PhysicalDisk -DeviceNumber $DeviceNumber
                    }
                }
                catch
                {
                    $errorObject = CreateErrorRecord -ErrorId "ObjectNotFound" `
                                                     -ErrorMessage "A physical disk matching the input criteria was not found" `
                                                     -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                     -Exception $null `
                                                     -TargetObject $null

                    $psCmdlet.WriteError($errorObject)
                    return
                }

                #
                # If log file is not specified,
                # get the node name where the
                # device is connected
                #

                if (-not $LogFile)
                {
                    $subsystem = $PhysicalDisk | get-storagesubsystem

                    if ($subsystem.Model -eq "Clustered Windows Storage" -and
                        $subsystem.StorageConnectionType -eq "Local Storage")
                    {
                        # If the subsystem is clustered local (storage spaces direct) use
                        # SSU mapping since it works for 'Lost Communication' drives

                        $storageScaleUnit = $PhysicalDisk | Get-StorageScaleUnit

                        if (-not $storageScaleUnit)
                        {
                            $errorObject = CreateErrorRecord -ErrorId "ObjectNotFound" `
                                                             -ErrorMessage "A storage scale unit was not found for the physical disk" `
                                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                             -Exception $null `
                                                             -TargetObject $null

                            $psCmdlet.WriteError($errorObject)
                            return
                        }

                        $computerName = $storageScaleUnit.FriendlyName
                    }
                    else
                    {
                        $storageNode = $PhysicalDisk | Get-StorageNode -PhysicallyConnected

                        if (-not $storageNode)
                        {
                            $errorObject = CreateErrorRecord -ErrorId "ObjectNotFound" `
                                                             -ErrorMessage "A storage node was not found for the physical disk" `
                                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                             -Exception $null `
                                                             -TargetObject $null

                            $psCmdlet.WriteError($errorObject)
                            return
                        }

                        $computerName = $storageNode.Name
                    }
                }

                # Extract the device guid from the object id
                # It is of the format ' <>:PD:<DeviceGuid>" '
                $guid = $PhysicalDisk.ObjectId.Split(":")[2].TrimEnd('"')

                $friendlyName        = $PhysicalDisk.FriendlyName
                $serialNumber        = $PhysicalDisk.SerialNumber
                $adapterSerialNumber = $PhysicalDisk.AdapterSerialNumber
                $firmwareRevision    = $PhysicalDisk.FirmwareVersion

                if ($PhysicalDisk.DeviceId -ge 0)
                {
                    $deviceNumber = $PhysicalDisk.DeviceId
                }

                $busType      = $PhysicalDisk.BusType
                $mediaType    = $PhysicalDisk.MediaType
            }

            { @(                 `
                "ByDeviceGuid"   `
                ) -contains $_   `
            }
            {
                try
                {
                    [System.Guid]::Parse($DeviceGuid) | Out-Null
                    $guid = $DeviceGuid
                }
                catch
                {
                    $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                     -ErrorMessage "DeviceGuid (or DeviceId) should be a GUID of the format 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' or '{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}'" `
                                                     -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                     -Exception $null `
                                                     -TargetObject $null

                    $psCmdlet.WriteError($errorObject)
                    return
                }
            }
        }

        #
        # Build the query to look for the specific events in storport log
        #

        if ($PSBoundParameters.ContainsKey("Errors"))
        {
            $eventFilter = "EventID=549"
        }
        else
        {
            $eventFilter = "EventID=502 or `
                            EventID=503 or `
                            EventID=504 or `
                            EventID=505"
        }

        if ($NumberOfHours)
        {
            $query = "*[System[($eventFilter) and TimeCreated[timediff(@SystemTime) <= $($NumberOfHours*3600*1000)]]] and *[EventData[Data[@Name='ClassDeviceGuid'] and (Data='$guid')]]"
        }
        else
        {
            $query = "*[System[($eventFilter)]] and *[EventData[Data[@Name='ClassDeviceGuid'] and (Data='$guid')]]"
        }

        #
        # Retrive the events depending on the parameters
        #

        Write-Progress -Activity "Get-StorageHistory" -PercentComplete 0 -CurrentOperation "Gathering events" -Status "0/2"

        try
        {
            if ($computerName)
            {
                if ($Credential)
                {
                    $events = Get-WinEvent -LogName Microsoft-Windows-Storage-Storport/Operational `
                                           -FilterXPath $query `
                                           -ComputerName $computerName `
                                           -Credential $Credential `
                                           -ErrorAction Stop `
                                           -Oldest
                }
                else
                {
                    $events = Get-WinEvent -LogName Microsoft-Windows-Storage-Storport/Operational `
                                           -FilterXPath $query `
                                           -ComputerName $computerName `
                                           -ErrorAction Stop `
                                           -Oldest
                }
            }
            else
            {
                if ($LogFile)
                {
                    $events = Get-WinEvent -Path $LogFile `
                                           -FilterXPath $query `
                                           -ErrorAction Stop `
                                           -Oldest
                }
                else
                {
                    $events = Get-WinEvent -LogName Microsoft-Windows-Storage-Storport/Operational `
                                           -FilterXPath $query `
                                           -ErrorAction Stop `
                                           -Oldest
                }
            }
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject

            $psCmdlet.WriteError($errorObject)
            return
        }

        #
        # Construct StorageHistory and StorageHistoryAggregate objects
        #

        Write-Progress -Activity "Get-StorageHistory" -PercentComplete 0 -CurrentOperation "Constructing storage history objects" -Status "1/2"

        if ($PSBoundParameters.ContainsKey("Errors"))
        {
            for ($index = 0; $index -lt $events.count;)
            {
                $event = $events[$index]
                $index++

                [StorageError]$data = [StorageError]::new()

                &$PopulateStorageError -Object ([ref]$data) `
                                       -EventRecord $event `
                                       -FriendlyName $friendlyName `
                                       -SerialNumber $serialNumber `
                                       -AdapterSerialNumber $adapterSerialNumber `
                                       -FirmwareRevision $firmwareRevision `
                                       -DeviceGuid $guid `
                                       -Number $deviceNumber `
                                       -BusType $busType `
                                       -MediaType $mediaType | Out-Null

                $psCmdlet.WriteObject($data)
            }
        }
        else
        {
            $firstEvent = $true

            for ($index = 0; $index -lt $events.count;)
            {
                $event = $events[$index]
                $index++

                #
                # A StorageHistory object is created for every 505 event.
                # Following non-505 events are collaped into it till
                # the next 505 event is encountered. All non-505 events
                # before the first 505 event are ignored
                #
                if ($event.Id -ne 505)
                {
                    continue
                }

                [StorageHistory]$data = [StorageHistory]::new()

                &$PopulateStorageHistory -Object ([ref]$data) `
                                         -EventRecord $event `
                                         -FriendlyName $friendlyName `
                                         -SerialNumber $serialNumber `
                                         -AdapterSerialNumber $adapterSerialNumber `
                                         -FirmwareRevision $firmwareRevision `
                                         -DeviceGuid $guid `
                                         -Number $deviceNumber `
                                         -BusType $busType `
                                         -MediaType $mediaType | Out-Null

                #
                # If there are no IOs, skip
                #

                if ($data.TotalIoCount -eq 0)
                {
                    continue
                }

                #
                # Check if there are any non-505 events following it
                #

                for (; $index -lt $events.count; $index++)
                {
                    $event = $events[$index]

                    if ($event.Id -eq 505)
                    {
                        break
                    }

                    &$AugmentStorageHistory -Object ([ref]$data) `
                                            -EventRecord $event | Out-Null
                }

                if ($PSBoundParameters.ContainsKey("Disaggregate"))
                {
                    $psCmdlet.WriteObject($data)
                }
                else
                {
                    if ($firstEvent)
                    {
                        [StorageHistoryAggregate]$aggregateData = [StorageHistoryAggregate]::new()
                        $firstEvent = $false
                    }

                    &$PopulateStorageHistoryAggregate -AggregateObject ([ref]$aggregateData) `
                                                    -Object ([ref]$data) | Out-Null
                }
            }

            if ($aggregateData)
            {
                $aggregateData.AvgIoLatency     = $aggregateData.TotalIoLatency / $aggregateData.TotalIoCount

                if ($aggregateData.TotalQueueIoCount -gt 0)
                {
                    $aggregateData.AvgQueueIoWaitTime = $aggregateData.TotalQueueIoWaitTime / $aggregateData.TotalQueueIoCount
                }

                for ($index = 0; $index -lt $aggregateData.BucketCount; $index++)
                {
                    $aggregateData.BucketIoPercent[$index] = ($aggregateData.BucketTotalIoCount[$index] * 100) / $aggregateData.TotalIoCount
                }

                $psCmdlet.WriteObject($aggregateData)
            }
        }

        Write-Progress -Activity "Get-StorageHistory" -Completed -Status "2/2"
    }
}


$DisplayTimeSeriesChart = {

    Param
    (
        [System.String]
        $ChartId,

        [System.String]
        $Title,

        [System.Collections.ArrayList]
        $StorageHistory,

        [System.Boolean]
        $ShowDefault,

        [System.Boolean]
        $ShowAvgLatency,

        [System.Boolean]
        $ShowMaxLatency
    )

    #
    # Build a device table with the
    # data to chart.
    #

    $deviceTable = New-Object System.Collections.Hashtable

    ForEach ($data in $StorageHistory)
    {
        if ($deviceTable.Contains($data.DeviceGuid) -eq $false)
        {
            $deviceData = New-Object -TypeName PsObject
            $deviceData | Add-Member -NotePropertyName "DeviceNumber" -NotePropertyValue $data.DeviceNumber
            $deviceData | Add-Member -NotePropertyName "FriendlyName" -NotePropertyValue $data.FriendlyName
            $deviceData | Add-Member -NotePropertyName "SerialNumber" -NotePropertyValue $data.SerialNumber

            $dataList = New-Object System.Collections.ArrayList
            $deviceData | Add-Member -NotePropertyName "DataList" -NotePropertyValue $dataList

            $deviceTable.Add($data.DeviceGuid, $deviceData)
        }
        else
        {
            $deviceData = $deviceTable[$data.DeviceGuid]
            $dataList = $deviceData.DataList
        }

        $dataPoint = New-Object -TypeName PsObject
        $dataPoint | Add-Member -NotePropertyName "DateTime"         -NotePropertyValue $data.EventTime
        $dataPoint | Add-Member -NotePropertyName "AvgIoLatency"     -NotePropertyValue ($data.AvgIoLatency/10)
        $dataPoint | Add-Member -NotePropertyName "MaxIoLatency"     -NotePropertyValue ($data.MaxIoLatency/10)
        $dataPoint | Add-Member -NotePropertyName "MaxQueueDepth"    -NotePropertyValue $data.MaxOutstandingCount
        $dataPoint | Add-Member -NotePropertyName "UnresponsiveTime" -NotePropertyValue $data.UnresponsiveTime
        $dataPoint | Add-Member -NotePropertyName "ResponsiveTime"   -NotePropertyValue $data.ResponsiveTime

        [void]$dataList.Add($dataPoint)
    }

    #
    # Create a chart
    #

    $chart = New-object Windows.Forms.DataVisualization.Charting.Chart
    $chart.Anchor = [Windows.Forms.AnchorStyles]::Bottom -bor
                    [Windows.Forms.AnchorStyles]::Right -bor
                    [Windows.Forms.AnchorStyles]::Top -bor
                    [Windows.Forms.AnchorStyles]::Left

    $chart.Width = 1000
    $chart.Height = 800
    $chart.Left = 40
    $chart.Top = 30
    $chart.BackColor = [Drawing.Color]::White
    [void]$chart.Titles.Add($Title)
    $chart.Titles[0].Font = "segoeuilight,12pt"

    #
    # Create a chart area to draw on
    #

    $chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
    $chartarea.Name = "TimeSeries"
    $chartarea.AxisX.IntervalType = [Windows.Forms.DataVisualization.Charting.DateTimeIntervalType]::Hours
    $chartarea.AxisX.IntervalAutoMode = [Windows.Forms.DataVisualization.Charting.IntervalAutoMode]::VariableCount
    $chartarea.AxisX.MajorGrid.Enabled = $false
    $chartarea.AxisX.LabelStyle.Format = "yyyy/MM/dd h tt"
    $chartarea.AxisX.ScaleView.Zoomable = $true
    $chartarea.AxisX.ScrollBar.IsPositionedInside = $true
    $chartarea.AxisX.ScrollBar.ButtonStyle = [Windows.Forms.DataVisualization.Charting.ScrollBarButtonStyles]::All
    $chartarea.CursorX.IsUserEnabled = $true
    $chartarea.CursorX.IsUserSelectionEnabled = $true
    $chartarea.CursorX.IntervalType = [Windows.Forms.DataVisualization.Charting.DateTimeIntervalType]::Hours
    $chartarea.CursorX.AutoScroll = $true
    $chartArea.AxisY.Title = "Latency (us)"
    $chartArea.AxisY.TitleFont = "segoeuilight,12pt"
    $chartarea.AxisY.LabelStyle.Format = "N0"
    $chartarea.AxisY.MinorGrid.Enabled = $true
    $chartarea.AxisY.MinorGrid.LineDashStyle = [Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dot

    $chart.ChartAreas.Add($chartArea)

    $legend = New-Object Windows.Forms.DataVisualization.Charting.Legend
    $legend.Name = "TimeSeries"
    $legend.Docking = [Windows.Forms.DataVisualization.Charting.Docking]::Right
    $legend.LegendStyle = [Windows.Forms.DataVisualization.Charting.LegendStyle]::Column
    $chart.Legends.Add($legend)

    #
    # Build the data to chart
    #

    if ($ShowDefault -eq $true)
    {
        $ShowAvgLatency = $true

        if ($deviceTable.Count -eq 1)
        {
            $ShowMaxLatency = $true
        }
        else
        {
            $ShowMaxLatency = $false
        }
    }

    ForEach ($deviceId in $deviceTable.Keys)
    {
        $deviceData = $deviceTable[$deviceId]
        $dataList = $deviceData.DataList

        if ($deviceTable.Count -eq 1)
        {
            [void]$chart.Titles.Add("Latency plot for " +
                                    $deviceData.DeviceNumber + " : " +
                                    $deviceData.FriendlyName + " : " +
                                    $deviceData.SerialNumber)
        }

        #
        # Show max and avg latencies
        #

        if ($ShowAvgLatency -eq $true)
        {
            if ($deviceTable.Count -eq 1)
            {
                $seriesName = "Avg"
            }
            else
            {
                $seriesName = "$($deviceData.DeviceNumber) : $($deviceData.SerialNumber) : Avg"
            }

            [void]$chart.Series.Add($seriesName)
            $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
            $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::DateTime
            $chart.Series[$seriesName].Legend = "TimeSeries"
            $chart.Series[$seriesName].MarkerStyle = [Windows.Forms.DataVisualization.Charting.MarkerStyle]::Circle

            if ($deviceTable.Count -eq 1)
            {
                $chart.Series[$seriesName].Color = [Drawing.Color]::Green
            }

            ForEach ($dataPoint in $dataList)
            {
                $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                $point.SetValueXY($dataPoint.DateTime, $dataPoint.AvgIoLatency)
                $point.Tooltip = "Value: #VALY{N0} us\n" +
                                 "At: #VALX{yyyy/MM/dd h:mm tt}\n" +
                                 "Max QD: $($dataPoint.MaxQueueDepth)"

                $chart.Series[$seriesName].Points.Add($point)
            }
        }

        if ($ShowMaxLatency -eq $true)
        {
            if ($deviceTable.Count -eq 1)
            {
                $seriesName = "Max"
            }
            else
            {
                $seriesName = "$($deviceData.DeviceNumber) : $($deviceData.SerialNumber) : Max"
            }

            [void]$chart.Series.Add($seriesName)
            $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
            $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::DateTime
            $chart.Series[$seriesName].Legend = "TimeSeries"
            $chart.Series[$seriesName].MarkerStyle = [Windows.Forms.DataVisualization.Charting.MarkerStyle]::Circle

            if ($deviceTable.Count -eq 1)
            {
                $chart.Series[$seriesName].Color = [Drawing.Color]::Orange
            }

            ForEach ($dataPoint in $dataList)
            {
                $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                $point.SetValueXY($dataPoint.DateTime, $dataPoint.MaxIoLatency)
                $point.Tooltip = "Value: #VALY{N0} us\n" +
                                 "At: #VALX{yyyy/MM/dd h:mm tt}\n" +
                                 "Max QD: $($dataPoint.MaxQueueDepth)"

                $chart.Series[$seriesName].Points.Add($point)
            }
        }

        #
        # Show interesting events when there
        # is a single device
        #

        if ($deviceTable.Count -eq 1)
        {
            $seriesName = "Events"

            [void]$chart.Series.Add($seriesName)
            $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Point
            $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::DateTime
            $chart.Series[$seriesName].Legend = "TimeSeries"
            $chart.Series[$seriesName].MarkerStyle = [Windows.Forms.DataVisualization.Charting.MarkerStyle]::Square
            $chart.Series[$seriesName].MarkerSize = 5
            $chart.Series[$seriesName].Color = [Drawing.Color]::Red

            #
            # Find the level at which to show the points
            #

            $value = 0

            ForEach ($dataPoint in $dataList)
            {
                if ($ShowMaxLatency -eq $true)
                {
                    if ($dataPoint.MaxIoLatency -gt $value)
                    {
                        $value = $dataPoint.MaxIoLatency
                    }
                }
                else
                {
                    if ($dataPoint.AvgIoLatency -gt $value)
                    {
                        $value = $dataPoint.AvgIoLatency
                    }
                }
            }

            ForEach ($dataPoint in $dataList)
            {
                ForEach ($time in $dataPoint.UnresponsiveTime)
                {
                    $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                    $point.SetValueXY($time, $value)
                    $point.Tooltip = "Marked unresponsive at #VALX{yyyy/MM/dd h:mm tt}\n"

                    $chart.Series[$seriesName].Points.Add($point)
                }

                ForEach ($time in $dataPoint.ResponsiveTime)
                {
                    $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                    $point.SetValueXY($time, $value)
                    $point.Tooltip = "Marked responsive at #VALX{yyyy/MM/dd h:mm tt}\n"

                    $chart.Series[$seriesName].Points.Add($point)
                }
            }
        }
    }

    $chart.ChartAreas[0].AxisX.LabelStyle.Angle = -45

    #
    # Display the chart on a form
    #

    $form = New-Object Windows.Forms.Form
    $form.Text = "Storage Performance Chart"
    $form.Width = 1100
    $form.Height = 900
    $form.controls.add($chart)
    $form.Add_Shown({$form.Activate()})

    [void]$form.ShowDialog()
    $form.Close()
    $form.Dispose()

    [void]$StorageHistoryCharts.Host.Runspace.Events.GenerateEvent("StorageHistoryChart.Close", $null, $null, $ChartId)
}


$DisplaySummaryChart = {

    Param
    (
        [System.String]
        $ChartId,

        [System.String]
        $Title,

        [System.Collections.ArrayList]
        $StorageHistory,

        [System.Boolean]
        $ShowDefault,

        [System.Boolean]
        $ShowAvgLatency,

        [System.Boolean]
        $ShowMaxLatency
    )

    #
    # Create a chart
    #

    $chart = New-object Windows.Forms.DataVisualization.Charting.Chart
    $chart.Anchor = [Windows.Forms.AnchorStyles]::Bottom -bor
                    [Windows.Forms.AnchorStyles]::Right -bor
                    [Windows.Forms.AnchorStyles]::Top -bor
                    [Windows.Forms.AnchorStyles]::Left

    $chart.Width = 1000
    $chart.Height = 800
    $chart.Left = 40
    $chart.Top = 30
    $chart.BackColor = [Drawing.Color]::White
    [void]$chart.Titles.Add($Title)
    $chart.Titles[0].Font = "segoeuilight,12pt"

    if ($StorageHistory.Count -eq 1)
    {
        [void]$chart.Titles.Add("IO Distribution for " +
                                $StorageHistory[0].DeviceNumber + " : " +
                                $StorageHistory[0].FriendlyName + " : " +
                                $StorageHistory[0].SerialNumber)
    }
    else
    {
        [void]$chart.Titles.Add("Latency comparison")
    }

    #
    # Create a chart area to draw on
    #

    $chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
    $chartarea.Name = "Summary"
    $chartarea.AxisX.Interval = 1
    $chartarea.AxisX.IntervalAutoMode = [Windows.Forms.DataVisualization.Charting.IntervalAutoMode]::FixedCount
    $chartarea.AxisX.MajorGrid.Enabled = $false

    # For a single device show IO distribution.
    # For multiple devices show avg and max latency.

    if ($StorageHistory.Count -eq 1)
    {
        $chartArea.AxisX.Title = "Latency buckets (us)"
        $chartArea.AxisX.TitleFont = "segoeuilight,12pt"
        $chartArea.AxisY.Title = "IO Count"
    }
    else
    {
        $chartarea.AxisX.ScaleView.Size = [Math]::Min($StorageHistory.Count, 40)
        $chartarea.AxisX.ScaleView.Zoomable = $true
        $chartarea.AxisX.ScrollBar.IsPositionedInside = $true
        $chartarea.AxisX.ScrollBar.ButtonStyle = [Windows.Forms.DataVisualization.Charting.ScrollBarButtonStyles]::All
        $chartarea.CursorX.IsUserEnabled = $true
        $chartarea.CursorX.IsUserSelectionEnabled = $true
        $chartarea.CursorX.AutoScroll = $true
        $chartArea.AxisY.Title = "Latency (us)"
    }

    $chartArea.AxisY.TitleFont = "segoeuilight,12pt"
    $chartarea.AxisY.LabelStyle.Format = "N0"
    $chartarea.AxisY.MinorGrid.Enabled = $true
    $chartarea.AxisY.MinorGrid.LineDashStyle = [Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dot
    $chart.ChartAreas.Add($chartArea)

    $legend = New-Object Windows.Forms.DataVisualization.Charting.Legend
    $legend.Name = "Summary"
    $legend.Docking = [Windows.Forms.DataVisualization.Charting.Docking]::Right
    $legend.LegendStyle = [Windows.Forms.DataVisualization.Charting.LegendStyle]::Column
    $chart.Legends.Add($legend)

    #
    # Build the data to chart
    #

    if ($StorageHistory.Count -eq 1)
    {
        $data = $StorageHistory[0]

        $seriesName = "SuccessIoCount"

        [void]$chart.Series.Add($seriesName)
        $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::StackedColumn
        $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::String
        $chart.Series[$seriesName].Legend = "Summary"
        $chart.Series[$seriesName].Color = [Drawing.Color]::Green

        for ($index = 0; $index -lt $data.BucketCount; $index++)
        {
            $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
            $point.SetValueXY([String]::Format('{0:N0}', $data.BucketIoLatency[$index] / 10),
                              $data.BucketSuccessIoCount[$index])
            $point.Tooltip = [String]::Format('Success: {0:N0}\nTotal: {1:N0}',
                                              $data.BucketSuccessIoCount[$index],
                                              $data.BucketTotalIoCount[$index])

            $chart.Series[$seriesName].Points.Add($point)
        }

        $seriesName = "FailedIoCount"

        [void]$chart.Series.Add($seriesName)
        $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::StackedColumn
        $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::String
        $chart.Series[$seriesName].Legend = "Summary"
        $chart.Series[$seriesName].Color = [Drawing.Color]::Red

        for ($index = 0; $index -lt $data.BucketCount; $index++)
        {
            $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
            $point.SetValueXY([String]::Format('{0:N0}', $data.BucketIoLatency[$index] / 10),
                              $data.BucketFailedIoCount[$index])
            $point.Tooltip = [String]::Format('Failed: {0:N0}\nTotal: {1:N0}',
                                              $data.BucketFailedIoCount[$index],
                                              $data.BucketTotalIoCount[$index])

            $chart.Series[$seriesName].Points.Add($point)
        }
    }
    else
    {
        if ($ShowDefault -eq $true)
        {
            $ShowAvgLatency = $true
            $ShowMaxLatency = $true
        }

        if ($ShowAvgLatency -eq $true)
        {
            $seriesName = "Avg"

            [void]$chart.Series.Add($seriesName)
            $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
            $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::String
            $chart.Series[$seriesName].Legend = "Summary"
            $chart.Series[$seriesName].Color = [Drawing.Color]::Green

            ForEach ($data in $StorageHistory)
            {
                $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                $point.SetValueXY($data.DeviceNumber + " : " + $data.SerialNumber,
                                  $data.AvgIoLatency / 10)
                $point.Tooltip = "Avg: #VALY{N0} us\n" +
                                 [String]::Format('Total Io Count: {0:N0}\nSuccess Io Count: {1:N0}\nFailed Io Count: {2:N0}',
                                                  $data.TotalIoCount, $data.SuccessIoCount, $data.FailedIoCount)

                $chart.Series[$seriesName].Points.Add($point)
            }
        }

        if ($ShowMaxLatency -eq $true)
        {
            $seriesName = "Max"

            [void]$chart.Series.Add($seriesName)
            $chart.Series[$seriesName].ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
            $chart.Series[$seriesName].XValueType = [Windows.Forms.DataVisualization.Charting.ChartValueType]::String
            $chart.Series[$seriesName].Legend = "Summary"
            $chart.Series[$seriesName].Color = [Drawing.Color]::Orange

            ForEach ($data in $StorageHistory)
            {
                $point = New-Object Windows.Forms.DataVisualization.Charting.DataPoint
                $point.SetValueXY($data.DeviceNumber + " : " + $data.SerialNumber,
                                  $data.MaxIoLatency / 10)
                $point.Tooltip = "Max: #VALY{N0} us\n" +
                                 [String]::Format('Total Io Count: {0:N0}\nSuccess Io Count: {1:N0}\nFailed Io Count: {2:N0}',
                                                  $data.TotalIoCount, $data.SuccessIoCount, $data.FailedIoCount)

                $chart.Series[$seriesName].Points.Add($point)
            }
        }

        $chart.ChartAreas[0].AxisX.LabelStyle.Angle = -45
    }

    #
    # Display the chart on a form
    #

    $form = New-Object Windows.Forms.Form
    $form.Text = "Storage Performance Chart"
    $form.Width = 1100
    $form.Height = 900
    $form.controls.add($chart)
    $form.Add_Shown({$form.Activate()})

    [void]$form.ShowDialog()
    $form.Close()
    $form.Dispose()

    [void]$StorageHistoryCharts.Host.Runspace.Events.GenerateEvent("StorageHistoryChart.Close", $null, $null, $ChartId)
}


$StorageHistoryChartClose = {

    $chartId = $event.MessageData
    $runspace = $Global:StorageHistoryCharts[$chartId]

    $runspace.Close()
    $runspace.Dispose()

    $Global:StorageHistoryCharts.Remove($chartId)
}


function Show-StorageHistory
{
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.Collections.ArrayList]
        [Parameter(
            ParameterSetName  = 'ByObjects',
            ValueFromPipeline = $false,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $Objects,

        #### ------------------------- Common method parameters ----------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'ByObjects',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $Title,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByObjects',
            Mandatory        = $false)]
        $DisplayAvgLatency,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByObjects',
            Mandatory        = $false)]
        $DisplayMaxLatency
    )

    Begin
    {
    }

    Process
    {
        if ($PSEdition -ne "Desktop")
        {
            #
            # Full PowerShell is required for charting
            #
            $errorObject = CreateErrorRecord -ErrorId "NotSupported" `
                                             -ErrorMessage "This cmdlet requires full powershell support" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::NotEnabled) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        #
        # Global state initialization
        #

        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization

        $Global:StorageHistoryCharts.Host = $Host

        $subscriber = Get-EventSubscriber -SourceIdentifier "StorageHistoryChart.Close" `
                                          -ErrorAction SilentlyContinue

        if ($subscriber -eq $null)
        {
            Register-EngineEvent -SourceIdentifier "StorageHistoryChart.Close" `
                                 -Action $StorageHistoryChartClose | Out-Null
        }

        #
        # Display chart based on the data passed
        #

        $type = [String]::Empty
        $storageHistory = New-Object System.Collections.ArrayList

        ForEach ($object in $Objects)
        {
            if ([String]::IsNullOrEmpty($type))
            {
                $type = $object.PSObject.TypeNames[0]
            }

            if ($object.PSObject.TypeNames[0] -eq $type)
            {
                [void]$storageHistory.Add($object)
            }
        }

        $chartId = [System.Guid]::newguid().ToString()

        $runspace = [RunspaceFactory]::CreateRunspace()
        $runspace.ApartmentState = "STA"
        $runspace.ThreadOptions = "ReuseThread"
        $runspace.Open()
        $runspace.SessionStateProxy.SetVariable("StorageHistoryCharts",$Global:StorageHistoryCharts)

        $Global:StorageHistoryCharts.Add($chartId, $runspace)

        $powershell = [PowerShell]::Create()

        $showDefault = $true
        $showAvgLatency = $false
        $showMaxLatency = $false

        if ($PSBoundParameters.ContainsKey("DisplayAvgLatency"))
        {
            $showDefault = $false
            $showAvgLatency = $true
        }

        if ($PSBoundParameters.ContainsKey("DisplayMaxLatency"))
        {
            $showDefault = $false
            $showMaxLatency = $true
        }

        if ($type -eq "Microsoft.Windows.StorageManagement.StorageHistory")
        {
            [void]$powershell.AddScript($DisplayTimeSeriesChart)
        }
        elseif ($type -eq "Microsoft.Windows.StorageManagement.StorageHistoryAggregate")
        {
            [void]$powershell.AddScript($DisplaySummaryChart)
        }
        else
        {
            return
        }

        [void]$powershell.AddArgument($chartId)
        [void]$powershell.AddArgument($Title)
        [void]$powershell.AddArgument($storageHistory)
        [void]$powershell.AddArgument($showDefault)
        [void]$powershell.AddArgument($showAvgLatency)
        [void]$powershell.AddArgument($showMaxLatency)

        $powershell.Runspace = $runspace

        [void]$powershell.BeginInvoke()
    }
}


function Get-PhysicalDisk
{
    [CmdletBinding( DefaultParameterSetName = "ByUniqueId" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName                = 'ByUniqueId',
            ValueFromPipeline               = $true,
            ValueFromPipelineByPropertyName = $true,
            Mandatory                       = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByObjectId',
            ValueFromPipeline = $true,
            Mandatory         = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("PhysicalDiskObjectId")]
        $ObjectId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByDeviceNumber',
            ValueFromPipeline = $false,
            Mandatory         = $false)]
        [ValidateNotNullOrEmpty()]
        $DeviceNumber,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByName',
            ValueFromPipeline = $true,
            Mandatory         = $false,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByName',
            ValueFromPipeline = $true,
            Mandatory         = $false,
            Position          = 1)]
        [ValidateNotNullOrEmpty()]
        $SerialNumber,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByInputObject',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageEnclosure")]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosure',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosure,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageScaleUnit")]
        [Parameter(
            ParameterSetName  = 'ByStorageScaleUnit',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageScaleUnit,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageChassis")]
        [Parameter(
            ParameterSetName  = 'ByStorageChassis',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageChassis,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageRack")]
        [Parameter(
            ParameterSetName  = 'ByStorageRack',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageRack,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSite")]
        [Parameter(
            ParameterSetName  = 'ByStorageSite',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSite,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageNode")]
        [Parameter(
            ParameterSetName  = 'ByStorageNode',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageNode,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StoragePool")]
        [Parameter(
            ParameterSetName  = 'ByStoragePool',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StoragePool,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_VirtualDisk")]
        [Parameter(
            ParameterSetName  = 'ByVirtualDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDisk,

        #### ------------------ VirtualDisk association parameters -------------------####

        [System.UInt64]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $VirtualRangeMin,

        [System.UInt64]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $VirtualRangeMax,

        [System.Boolean]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $HasAllocations,

        [System.Boolean]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $SelectedForUse,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $NoRedundancy,

        #### --------- StoragePool and VirtualDisk association parameters ------------####

        [Switch]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $HasMetadata,

        #### ------------------ StorageNode association parameters -------------------####

        [Switch]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        $PhysicallyConnected,

        #### ------------------------- Common parameters -----------------------------####

        [PhysicalDiskUsage]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $Usage,

        [System.String]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $Description,

        [System.String]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $Manufacturer,

        [System.String]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $Model,

        [System.Boolean]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $CanPool,

        [PhysicalDiskHealthStatus]
        [Parameter(
            ParameterSetName = 'ByUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByObjectId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDeviceNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageScaleUnit',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageChassis',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageRack',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSite',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageNode',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $HealthStatus,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
        [flagsattribute()]
        Enum PhysicalDiskUsage
        {
            Unknown      = 0
            AutoSelect   = 1
            ManualSelect = 2
            HotSpare     = 3
            Retired      = 4
            Journal      = 5
        }

        [flagsattribute()]
        Enum PhysicalDiskHealthStatus
        {
            Healthy   = 0
            Warning   = 1
            Unhealthy = 2
            Unknown   = 5
        }
    }

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance objects.

        $options = New-Object Microsoft.Management.Infrastructure.Options.CimOperationOptions

        switch -regex ($psCmdlet.ParameterSetName)
        {
            { @(                `
                "ByInputObject" `
                ) -contains $_  `
            }
            {
                $cimInstance = New-Object Microsoft.Management.Infrastructure.CimInstance("MSFT_PhysicalDisk")

                $cimInstance.CimInstanceProperties.Add([Microsoft.Management.Infrastructure.CimProperty]::Create("ObjectId", $InputObject.ObjectId, "String", "Key"))

                $instance = $CimSession.GetInstance($StorageNamespace,
                                                    $cimInstance);
                break;
            }

            { @(                  `
                "ByObjectId",     `
                "ByUniqueId",     `
                "ByDeviceNumber", `
                "ByName"          `
                ) -contains $_    `
            }
            {
                $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                          "MSFT_PhysicalDisk");
                break;
            }

            { @(                      `
                "ByStorageSubsystem", `
                "ByStoragePool",      `
                "ByStorageEnclosure", `
                "ByStorageNode",      `
                "ByVirtualDisk"       `
                ) -contains $_        `
            }
            {
                if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
                {
                    $subsystem = $StorageSubsystem
                }
                elseif ($PSBoundParameters.ContainsKey("StoragePool"))
                {
                    $subsystem = $StoragePool | get-storagesubsystem -CimSession $CimSession
                }
                elseif ($PSBoundParameters.ContainsKey("StorageEnclosure"))
                {
                    $subsystem = $StorageEnclosure | get-storagesubsystem -CimSession $CimSession
                }
                elseif ($PSBoundParameters.ContainsKey("StorageNode"))
                {
                    $subsystem = $StorageNode | get-storagesubsystem -CimSession $CimSession
                }
                elseif ($PSBoundParameters.ContainsKey("VirtualDisk"))
                {
                    $subsystem = $VirtualDisk | get-storagesubsystem -CimSession $CimSession
                }

                # If the subsystem model is "Windows Storage",
                # perform associations using enumeration

                if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_StorageSubsystem", $false)
                    $options.SetCustomOption("InputObjectId", $StorageSubsystem.ObjectId, $false)

                    if ($subsystem.Model -like "*Windows Storage*")
                    {
                        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                                  "MSFT_PhysicalDisk",
                                                                  $options)
                    }
                    else
                    {
                        $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                            $StorageSubsystem,
                                                                            "MSFT_StorageSubsystemToPhysicalDisk",
                                                                            "MSFT_PhysicalDisk",
                                                                            "StorageSubsystem",
                                                                            "PhysicalDisk",
                                                                            $options)
                    }
                }
                elseif ($PSBoundParameters.ContainsKey("StoragePool"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_StoragePool", $false)
                    $options.SetCustomOption("InputObjectId", $StoragePool.ObjectId, $false)

                    if ($PSBoundParameters.ContainsKey("HasMetadata"))
                    {
                        $options.SetCustomOption("HasMetadata", $HasMetadata, $false)
                    }

                    if ($subsystem.Model -like "*Windows Storage*")
                    {
                        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                                  "MSFT_PhysicalDisk",
                                                                  $options)
                    }
                    else
                    {
                        $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                            $StoragePool,
                                                                            "MSFT_StoragePoolToPhysicalDisk",
                                                                            "MSFT_PhysicalDisk",
                                                                            "StoragePool",
                                                                            "PhysicalDisk",
                                                                            $options)
                    }
                }
                elseif ($PSBoundParameters.ContainsKey("StorageEnclosure"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_StorageEnclosure", $false)
                    $options.SetCustomOption("InputObjectId", $StorageEnclosure.ObjectId, $false)

                    if ($subsystem.Model -like "*Windows Storage*")
                    {
                        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                                  "MSFT_PhysicalDisk",
                                                                  $options);
                    }
                    else
                    {
                        $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                            $StorageEnclosure,
                                                                            "MSFT_StorageEnclosureToPhysicalDisk",
                                                                            "MSFT_PhysicalDisk",
                                                                            "StorageEnclosure",
                                                                            "PhysicalDisk",
                                                                            $options);
                    }
                }
                elseif ($PSBoundParameters.ContainsKey("StorageNode"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_StorageNode", $false)
                    $options.SetCustomOption("InputObjectId", $StorageNode.ObjectId, $false)

                    if ($PSBoundParameters.ContainsKey("PhysicallyConnected"))
                    {
                        $options.SetCustomOption("PhysicallyConnected", $true, $false)
                    }

                    if ($subsystem.Model -like "*Windows Storage*")
                    {
                        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                                  "MSFT_PhysicalDisk",
                                                                  $options);
                    }
                    else
                    {
                        $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                            $StorageNode,
                                                                            "MSFT_StorageNodeToPhysicalDisk",
                                                                            "MSFT_PhysicalDisk",
                                                                            "StorageNode",
                                                                            "PhysicalDisk",
                                                                            $options);
                    }
                }
                elseif ($PSBoundParameters.ContainsKey("VirtualDisk"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_VirtualDisk", $false)
                    $options.SetCustomOption("InputObjectId", $VirtualDisk.ObjectId, $false)

                    if ($PSBoundParameters.ContainsKey("VirtualRangeMin"))
                    {
                        $options.SetCustomOption("VirtualRangeMin", $VirtualRangeMin, [Microsoft.Management.Infrastructure.CimType]::UInt64, $false)
                    }

                    if ($PSBoundParameters.ContainsKey("VirtualRangeMax"))
                    {
                        $options.SetCustomOption("VirtualRangeMax", $VirtualRangeMax, [Microsoft.Management.Infrastructure.CimType]::UInt64, $false)
                    }

                    if ($PSBoundParameters.ContainsKey("HasAllocations"))
                    {
                        $options.SetCustomOption("HasAllocations", $HasAllocations, $false)
                    }

                    if ($PSBoundParameters.ContainsKey("SelectedForUse"))
                    {
                        $options.SetCustomOption("SelectedForUse", $SelectedForUse, $false)
                    }

                    if ($PSBoundParameters.ContainsKey("HasMetadata"))
                    {
                        $options.SetCustomOption("HasMetadata", $HasMetadata, $false)
                    }

                    if ($PSBoundParameters.ContainsKey("NoRedundancy"))
                    {
                        $options.SetCustomOption("NoRedundancy", $true, $false)
                    }

                    if ($subsystem.Model -like "*Windows Storage*")
                    {
                        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                                  "MSFT_PhysicalDisk",
                                                                  $options);
                    }
                    else
                    {
                        $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                            $VirtualDisk,
                                                                            "MSFT_VirtualDiskToPhysicalDisk",
                                                                            "MSFT_PhysicalDisk",
                                                                            "VirtualDisk",
                                                                            "PhysicalDisk",
                                                                            $options);
                    }
                }

                break;
            }
            { @(                      `
                "ByStorageScaleUnit", `
                "ByStorageChassis",   `
                "ByStorageRack",      `
                "ByStorageSite"       `
                ) -contains $_        `
            }
            {
                if ($PSBoundParameters.ContainsKey("StorageScaleUnit"))
                {
                    $inputObject = $StorageScaleUnit
                }
                elseif ($PSBoundParameters.ContainsKey("StorageChassis"))
                {
                    $inputObject = $StorageChassis
                }
                elseif ($PSBoundParameters.ContainsKey("StorageRack"))
                {
                    $inputObject = $StorageRack
                }
                elseif ($PSBoundParameters.ContainsKey("StorageSite"))
                {
                    $inputObject = $StorageSite
                }

                # If the subsystem model is "Windows Storage",
                # perform associations using enumeration

                $subsystem = $inputObject | get-storagesubsystem -CimSession $CimSession

                if ($subsystem.Model -like "*Windows Storage*")
                {
                    $options.SetCustomOption("InputClassName", $inputObject.ClassName, $false)
                    $options.SetCustomOption("InputObjectId", $inputObject.ObjectId, $false)

                    $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                              "MSFT_PhysicalDisk",
                                                              $options);
                }
                else
                {
                    $options.SetCustomOption("ResultObject", "MSFT_PhysicalDisk", $false)

                    $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                        $inputObject,
                                                                        "MSFT_StorageFaultDomainToStorageFaultDomain",
                                                                        "MSFT_PhysicalDisk",
                                                                        "SourceStorageFaultDomain",
                                                                        "TargetStorageFaultDomain",
                                                                        $options);
                }

                break;
            }
        }

        $instances  = @()

        if ($psCmdlet.ParameterSetName -eq "ByInputObject")
        {
            $instances += $instance
        }
        else
        {
            $enumerator = $results.GetEnumerator()

            while ($enumerator.MoveNext())
            {
                $instance = $enumerator.Current

                ## Filter by optional input parameters

                if (($PSBoundParameters.ContainsKey("ObjectId")) -and
                    ($instance.ObjectId -notlike $ObjectId))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("UniqueId")) -and
                    ($instance.UniqueId -notlike $UniqueId))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("DeviceNumber")) -and
                    ($instance.DeviceId -ne $DeviceNumber))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("FriendlyName")) -and
                    ($instance.FriendlyName -notlike $FriendlyName))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("SerialNumber")) -and
                    ($instance.SerialNumber -notlike $SerialNumber))
                {
                    continue
                }

                if ($PSBoundParameters.ContainsKey("Usage"))
                {
                    $matchFound = $true

                    switch -regex ($Usage)
                    {
                        { @(               `
                            "Unknown",     `
                            "Retired",     `
                            "Journal"      `
                            ) -contains $_ `
                        }
                        {
                            if ( $instance.Usage -ne $Usage )
                            {
                                $matchFound = $false
                                break
                            }
                        }

                        { @(               `
                            "AutoSelect"   `
                            ) -contains $_ `
                        }
                        {
                            if ( $instance.Usage -ne "Auto-Select" )
                            {
                                $matchFound = $false
                                break
                            }
                        }

                        { @(               `
                            "ManualSelect" `
                            ) -contains $_ `
                        }
                        {
                            if ( $instance.Usage -ne "Manual-Select" )
                            {
                                $matchFound = $false
                                break
                            }
                        }

                        { @(               `
                            "HotSpare"     `
                            ) -contains $_ `
                        }
                        {
                            if ( $instance.Usage -ne "Hot Spare" )
                            {
                                $matchFound = $false
                                break
                            }
                        }
                    }

                    if ( $matchFound -eq $false )
                    {
                        continue
                    }
                }

                if (($PSBoundParameters.ContainsKey("Description")) -and
                    ($instance.Description -notlike $Description))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("Manufacturer")) -and
                    ($instance.Manufacturer -ne $Manufacturer))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("Model")) -and
                    ($instance.Model -ne $Model))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("CanPool")) -and
                    ($instance.CanPool -ne $CanPool))
                {
                    continue
                }

                if (($PSBoundParameters.ContainsKey("HealthStatus")) -and
                    ($instance.HealthStatus -ne $HealthStatus))
                {
                    continue
                }

                $instances += $instance
            }
        }

        $instances
    }
}


function Get-PhysicalExtent
{
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_VirtualDisk")]
        [Parameter(
            ParameterSetName  = 'ByVirtualDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDisk,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageTier")]
        [Parameter(
            ParameterSetName  = 'ByStorageTier',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageTier,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance objects

        switch ($psCmdlet.ParameterSetName)
        {
            "ByVirtualDisk"  { $inputObject = $VirtualDisk;  break; }
            "ByStorageTier"  { $inputObject = $StorageTier;  break; }
            "ByPhysicalDisk" { $inputObject = $PhysicalDisk; break; }
        }

        $instances = @()

        try
        {
            $output     = Invoke-CimMethod -CimSession $CimSession -InputObject $inputObject -MethodName "GetPhysicalExtent" -ErrorAction Stop
            $enumerator = $output.PhysicalExtents.GetEnumerator()

            while ($enumerator.MoveNext())
            {
                $instance = $enumerator.Current
                $instance.PSObject.TypeNames.Insert(0, "Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalExtent")

                $instances += $instance
            }
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject

            $psCmdlet.WriteError($errorObject)
        }

        $instances
    }
}


function Get-PhysicalExtentAssociation
{
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalExtent")]
        [Parameter(
            ParameterSetName  = 'ByInputObject',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        $virtualDisk = Get-VirtualDisk -CimSession $CimSession -UniqueId $InputObject.VirtualDiskUniqueId -ErrorAction Stop

        if ($InputObject.StorageTierUniqueId -ne $null)
        {
            $storageTier = Get-StorageTier -CimSession $CimSession -UniqueId $InputObject.StorageTierUniqueId -ErrorAction Stop
        }

        $physicalDisk = Get-PhysicalDisk -CimSession $CimSession -UniqueId $InputObject.PhysicalDiskUniqueId -ErrorAction Stop

        $associations = [pscustomobject]@{
            VirtualDisk  = $virtualDisk;
            StorageTier  = $storageTier;
            PhysicalDisk = $physicalDisk;
        }

        $associations
    }
}


function Enable-PhysicalDiskIdentification
{
    [CmdletBinding( DefaultParameterSetName = "ByName", ConfirmImpact="Low" )]
    [Alias("Enable-PhysicalDiskIndication")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByUniqueId',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByName',
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $FriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByInputObject',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        #### ------------------------- Common method parameters ----------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Enable-PhysicalDiskIdentification" -PercentComplete 0 -CurrentOperation "Gathering objects" -Status "0/2"
        }

        ## Gather the instance objects

        switch ($psCmdlet.ParameterSetName)
        {
            "ByInputObject" { $Instances = $InputObject; break; }
            "ByUniqueId"    { $Instances = Get-PhysicalDisk -UniqueId $UniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByName"        { $Instances = Get-PhysicalDisk -FriendlyName $FriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $instances)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $arguments = @{ "EnableIndication" = $true }
            $errorObject = $null

            if (-not $asjob)
            {
                Write-Progress -Activity "Enable-PhysicalDiskIdentification" -PercentComplete 30 -CurrentOperation "Executing method" -Status "1/2"
            }

            ForEach ( $instance in $instances )
            {
                try
                {
                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $instance -MethodName Maintenance -Arguments $arguments -ErrorAction Stop

                    $progressPreference = "Continue"
                }
                catch
                {
                    $progressPreference = "Continue"

                    $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                     -ErrorMessage $null `
                                                     -ErrorCategory $_.CategoryInfo.Category `
                                                     -Exception $_.Exception `
                                                     -TargetObject $_.TargetObject

                    $psCmdlet.WriteError($errorObject)
                }
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Enable-PhysicalDiskIdentification" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            Start-Job -Name EnablePhysicalDiskIdentification -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $Instances)
        }
        else
        {
            &$methodblock $CimSession $p $Instances
        }
    }
}


function Disable-PhysicalDiskIdentification
{
    [CmdletBinding( DefaultParameterSetName = "ByName", ConfirmImpact="Low" )]
    [Alias("Disable-PhysicalDiskIndication")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByUniqueId',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByName',
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $FriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByInputObject',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        #### ------------------------- Common method parameters ----------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Disable-PhysicalDiskIdentification" -PercentComplete 0 -CurrentOperation "Gathering objects" -Status "0/2"
        }

        ## Gather the instance objects

        switch ($psCmdlet.ParameterSetName)
        {
            "ByInputObject" { $Instances = $InputObject; break; }
            "ByUniqueId"    { $Instances = Get-PhysicalDisk -UniqueId $UniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByName"        { $Instances = Get-PhysicalDisk -FriendlyName $FriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $instances)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $arguments = @{ "EnableIndication" = $false }
            $errorObject = $null

            if (-not $asjob)
            {
                Write-Progress -Activity "Disable-PhysicalDiskIdentification" -PercentComplete 30 -CurrentOperation "Executing method" -Status "1/2"
            }

            ForEach ( $instance in $instances )
            {
                try
                {
                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $instance -MethodName Maintenance -Arguments $arguments -ErrorAction Stop

                    $progressPreference = "Continue"
                }
                catch
                {
                    $progressPreference = "Continue"

                    $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                     -ErrorMessage $null `
                                                     -ErrorCategory $_.CategoryInfo.Category `
                                                     -Exception $_.Exception `
                                                     -TargetObject $_.TargetObject

                    $psCmdlet.WriteError($errorObject)
                }
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Disable-PhysicalDiskIdentification" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            Start-Job -Name DisablePhysicalDiskIdentification -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $Instances)
        }
        else
        {
            &$methodblock $CimSession $p $Instances
        }
    }
}


function Reset-PhysicalDisk
{
    [CmdletBinding( DefaultParameterSetName = "ByName", ConfirmImpact="Medium" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByUniqueId',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByName',
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $FriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByInputObject',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        #### ------------------------- Common method parameters ----------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Reset-PhysicalDisk" -PercentComplete 0 -CurrentOperation "Gathering objects" -Status "0/2"
        }

        ## Gather the instance objects

        switch ($psCmdlet.ParameterSetName)
        {
            "ByInputObject" { $Instances = $InputObject; break; }
            "ByUniqueId"    { $Instances = Get-PhysicalDisk -UniqueId $UniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByName"        { $Instances = Get-PhysicalDisk -FriendlyName $FriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $instances)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null

            if (-not $asjob)
            {
                Write-Progress -Activity "Reset-PhysicalDisk" -PercentComplete 30 -CurrentOperation "Executing method" -Status "1/2"
            }

            ForEach ( $instance in $instances )
            {
                try
                {
                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $instance -MethodName Reset -ErrorAction Stop

                    $progressPreference = "Continue"
                }
                catch
                {
                    $progressPreference = "Continue"

                    $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                     -ErrorMessage $null `
                                                     -ErrorCategory $_.CategoryInfo.Category `
                                                     -Exception $_.Exception `
                                                     -TargetObject $_.TargetObject

                    $psCmdlet.WriteError($errorObject)
                }
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Reset-PhysicalDisk" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            Start-Job -Name ResetPhysicalDisk -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $Instances)
        }
        else
        {
            &$methodblock $CimSession $p $Instances
        }
    }
}


function Get-StorageFirmwareInformation
{
    [CmdletBinding( DefaultParameterSetName = "ByPhysicalDiskFriendlyName", ConfirmImpact="None" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDiskUniqueId',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [Alias("PhysicalDiskUniqueId")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDiskFriendlyName',
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("PhysicalDiskFriendlyName")]
        $FriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("PhysicalDisk")]
        $InputObject,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosureUniqueId',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosureUniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosureFriendlyName',
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosureFriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageEnclosure")]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosure',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosure,

        #### ------------------------- Common method parameters ----------------------####

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByPhysicalDisk"                 { $PhysicalDiskInstance = $InputObject; break; }
            "ByPhysicalDiskUniqueId"         { $PhysicalDiskInstance = Get-PhysicalDisk -UniqueId $UniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByPhysicalDiskFriendlyName"     { $PhysicalDiskInstance = Get-PhysicalDisk -FriendlyName $FriendlyName -CimSession $CimSession -ErrorAction Stop; break; }

            "ByStorageEnclosure"             { $StorageEnclosureInstance = $StorageEnclosure; break; }
            "ByStorageEnclosureUniqueId"     { $StorageEnclosureInstance = Get-StorageEnclosure -UniqueId $StorageEnclosureUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageEnclosureFriendlyName" { $StorageEnclosureInstance = Get-StorageEnclosure -FriendlyName $StorageEnclosureFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Get-StorageFirmwareInformation" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $inputobject)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null

            if (-not $asjob)
            {
                Write-Progress -Activity "Get-StorageFirmwareInformation" -PercentComplete 30 -CurrentOperation "Getting storage firmware information" -Status "1/2"
            }

            try
            {
                $progressPreference = "silentlyContinue"

                $output = Invoke-CimMethod -CimSession $session -InputObject $inputobject -MethodName GetFirmwareInformation -ErrorAction Stop

                $progressPreference = "Continue"

                $firmwareInformation = [pscustomobject]@{
                    Object                = $inputobject;
                    SupportsUpdate        = $output.SupportsUpdate;
                    NumberOfSlots         = $output.NumberOfSlots;
                    ActiveSlotNumber      = $output.ActiveSlotNumber;
                    SlotNumber            = $output.SlotNumber;
                    IsSlotWritable        = $output.IsSlotWritable;
                    FirmwareVersionInSlot = $output.FirmwareVersionInSlot;
                }

                $psCmdlet.WriteObject($firmwareInformation);
            }
            catch
            {
                $progressPreference = "Continue"

                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject

                $psCmdlet.WriteError($errorObject)
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Get-StorageFirmwareInformation" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            if ($PhysicalDiskInstance)
            {
                Start-Job -Name GetStorageFirmwareInformation -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $PhysicalDiskInstance)
            }
            elseif ($StorageEnclosureInstance)
            {
                Start-Job -Name GetStorageFirmwareInformation -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $StorageEnclosureInstance)
            }
        }
        else
        {
            if ($PhysicalDiskInstance)
            {
                &$methodblock $CimSession $p $PhysicalDiskInstance
            }
            elseif ($StorageEnclosureInstance)
            {
                &$methodblock $CimSession $p $StorageEnclosureInstance
            }
        }
    }
}


function Update-StorageFirmware
{
    [CmdletBinding( DefaultParameterSetName = "ByPhysicalDiskFriendlyName", ConfirmImpact="Medium" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDiskUniqueId',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [Alias("PhysicalDiskUniqueId")]
        $UniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDiskFriendlyName',
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("PhysicalDiskFriendlyName")]
        $FriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("PhysicalDisk")]
        $InputObject,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosureUniqueId',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosureUniqueId,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosureFriendlyName',
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosureFriendlyName,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageEnclosure")]
        [Parameter(
            ParameterSetName  = 'ByStorageEnclosure',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageEnclosure,

        #### ------------------------- Common method parameters ----------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'ByPhysicalDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByPhysicalDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosureUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosureFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        $ImagePath,

        [System.UInt16]
        [Parameter(
            ParameterSetName = 'ByPhysicalDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByPhysicalDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByPhysicalDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosureUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosureFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageEnclosure',
            Mandatory        = $false)]
        $SlotNumber,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByPhysicalDisk"                 { $PhysicalDiskInstance = $InputObject; break; }
            "ByPhysicalDiskUniqueId"         { $PhysicalDiskInstance = Get-PhysicalDisk -UniqueId $UniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByPhysicalDiskFriendlyName"     { $PhysicalDiskInstance = Get-PhysicalDisk -FriendlyName $FriendlyName -CimSession $CimSession -ErrorAction Stop; break; }

            "ByStorageEnclosure"             { $StorageEnclosureInstance = $StorageEnclosure; break; }
            "ByStorageEnclosureUniqueId"     { $StorageEnclosureInstance = Get-StorageEnclosure -UniqueId $StorageEnclosureUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageEnclosureFriendlyName" { $StorageEnclosureInstance = Get-StorageEnclosure -FriendlyName $StorageEnclosureFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Update-StorageFirmware" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
        }

        ## Populate arguments list

        $arguments = @{}

        if ($PSBoundParameters.ContainsKey("ImagePath"))
        {
            $arguments.Add("ImagePath", $ImagePath)
        }

        if ($PSBoundParameters.ContainsKey("SlotNumber"))
        {
            $arguments.Add("SlotNumber", $SlotNumber)
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $inputobject, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null

            if (-not $asjob)
            {
                Write-Progress -Activity "Update-StorageFirmware" -PercentComplete 30 -CurrentOperation "Updating storage firmware" -Status "1/2"
            }

            try
            {
                $progressPreference = "silentlyContinue"

                $output = Invoke-CimMethod -CimSession $session -InputObject $inputobject -MethodName UpdateFirmware -Arguments $arguments -ErrorAction Stop

                $progressPreference = "Continue"
            }
            catch
            {
                $progressPreference = "Continue"

                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject

                $psCmdlet.WriteError($errorObject)
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Update-StorageFirmware" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            if ($PhysicalDiskInstance)
            {
                Start-Job -Name UpdateStorageFirmware -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $PhysicalDiskInstance, $arguments)
            }
            elseif ($StorageEnclosureInstance)
            {
                Start-Job -Name UpdateStorageFirmware -ScriptBlock $methodblock -ArgumentList @($CimSession, $p, $StorageEnclosureInstance, $arguments)
            }
        }
        else
        {
            if ($PhysicalDiskInstance)
            {
                &$methodblock $CimSession $p $PhysicalDiskInstance $arguments
            }
            elseif ($StorageEnclosureInstance)
            {
                &$methodblock $CimSession $p $StorageEnclosureInstance $arguments
            }
        }
    }
}


function Get-PhysicalDiskStorageNodeView
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageNode")]
        [Parameter(
            ValueFromPipeline = $true)]
        $StorageNode,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ValueFromPipeline = $true)]
        $PhysicalDisk,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the association objects
        $options = New-Object Microsoft.Management.Infrastructure.Options.CimOperationOptions

        if ($PSBoundParameters.ContainsKey("StorageNode"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_StorageNode", $false)
            $options.SetCustomOption("InputObjectId", $StorageNode.ObjectId, $false)
        }
        elseif ($PSBoundParameters.ContainsKey("PhysicalDisk"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_PhysicalDisk", $false)
            $options.SetCustomOption("InputObjectId", $PhysicalDisk.ObjectId, $false)
        }

        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                  "MSFT_StorageNodeToPhysicalDisk",
                                                  $options
                                                  )

        $enumerator = $results.GetEnumerator()
        $instances  = @()

        while ($enumerator.MoveNext())
        {
            $instance = $enumerator.Current

            if ($PSBoundParameters.ContainsKey("StorageNode"))
            {
                if ($instance.StorageNodeObjectId -ne $StorageNode.ObjectId)
                {
                    continue
                }
            }
            elseif ($PSBoundParameters.ContainsKey("PhysicalDisk"))
            {
                if ($instance.PhysicalDiskObjectId -ne $PhysicalDisk.ObjectId)
                {
                    continue
                }
            }

            $instances += $instance
        }

        $instances
    }
}


function Get-DiskStorageNodeView
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageNode")]
        [Parameter(
            ValueFromPipeline = $true)]
        $StorageNode,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Disk")]
        [Parameter(
            ValueFromPipeline = $true)]
        $Disk,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the association objects
        $options = New-Object Microsoft.Management.Infrastructure.Options.CimOperationOptions

        if ($PSBoundParameters.ContainsKey("StorageNode"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_StorageNode", $false)
            $options.SetCustomOption("InputObjectId", $StorageNode.ObjectId, $false)
        }
        elseif ($PSBoundParameters.ContainsKey("Disk"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_Disk", $false)
            $options.SetCustomOption("InputObjectId", $Disk.ObjectId, $false)
        }

        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                  "MSFT_StorageNodeToDisk",
                                                  $options
                                                  )

        $enumerator = $results.GetEnumerator()
        $instances  = @()

        while ($enumerator.MoveNext())
        {
            $instance = $enumerator.Current

            if ($PSBoundParameters.ContainsKey("StorageNode"))
            {
                if ($instance.StorageNodeObjectId -ne $StorageNode.ObjectId)
                {
                    continue
                }
            }
            elseif ($PSBoundParameters.ContainsKey("Disk"))
            {
                if ($instance.DiskObjectId -ne $Disk.ObjectId)
                {
                    continue
                }
            }

            $instances += $instance
        }

        $instances
    }
}


function Get-StorageEnclosureStorageNodeView
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageNode")]
        [Parameter(
            ValueFromPipeline = $true)]
        $StorageNode,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageEnclosure")]
        [Parameter(
            ValueFromPipeline = $true)]
        $StorageEnclosure,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the association objects
        $options = New-Object Microsoft.Management.Infrastructure.Options.CimOperationOptions

        if ($PSBoundParameters.ContainsKey("StorageNode"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_StorageNode", $false)
            $options.SetCustomOption("InputObjectId", $StorageNode.ObjectId, $false)
        }
        elseif ($PSBoundParameters.ContainsKey("StorageEnclosure"))
        {
            $options.SetCustomOption("InputClassName", "MSFT_StorageEnclosure", $false)
            $options.SetCustomOption("InputObjectId", $StorageEnclosure.ObjectId, $false)
        }

        $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                  "MSFT_StorageNodeToStorageEnclosure",
                                                  $options
                                                  )

        $enumerator = $results.GetEnumerator()
        $instances  = @()

        while ($enumerator.MoveNext())
        {
            $instance = $enumerator.Current

            if ($PSBoundParameters.ContainsKey("StorageNode"))
            {
                if ($instance.StorageNodeObjectId -ne $StorageNode.ObjectId)
                {
                    continue
                }
            }
            elseif ($PSBoundParameters.ContainsKey("StorageEnclosure"))
            {
                if ($instance.StorageEnclosureObjectId -ne $StorageEnclosure.ObjectId)
                {
                    continue
                }
            }

            $instances += $instance
        }

        $instances
    }
}


function Get-StorageHealthAction
{
    [CmdletBinding()]
    Param
    (
        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByUniqueId")]
         $UniqueId,

        [CimInstance]
        [Parameter(
            Mandatory         = $false,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{}

    Process
    {
        $info = $resources.info
        $p = $null
        $methodName = "GetActions"

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if ($UniqueId)
        {
            # Would use a closure here, but jobs are run in their own session state.
            $block = {
                param($session, $asjob, $ns, $id)

                # Start-Job serializes/deserializes the CimSession,
                # which means it shows up here as having type Deserialized.CimSession.
                # Must recreate or cast the object in order to pass it to Get-CimInstance.
                if ($asjob)
                {
                    $session = $session | New-CimSession
                }

                Get-CimInstance -CimSession $session -Query "Select * From MSFT_HealthAction Where UniqueId='$id'" -Namespace $ns

            }

            if ($asjob)
            {
                $p = $true
                Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $StorageNamespace, $UniqueId)
            }
            else
            {
                if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
                {
                    &$block $CimSession $p $StorageNamespace $UniqueId
                }
            }
        }
        elseif ($InputObject.CimClass.CimClassName -eq "MSFT_HealthAction")
        {
            # Would use a closure here, but jobs are run in their own session state.
            $block = {
                param($session, $asjob, $io)

                # Start-Job serializes/deserializes the CimSession,
                # which means it shows up here as having type Deserialized.CimSession.
                # Must recreate or cast the object in order to pass it to Get-CimInstance.
                if ($asjob)
                {
                    $session = $session | New-CimSession
                }

                $io | Get-CimInstance -CimSession $session

            }

            if ($asjob)
            {
                $p = $true
                Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject)
            }
            else
            {
                if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
                {
                    &$block $CimSession $p $InputObject
                }
            }
        }
        elseif (-not $InputObject -or ( $InputObject.CimClass.CimClassName -eq "MSFT_StorageHealth" ))
        {
            $className = "MSFT_HealthAction"
            $block = {
                param($session, $ns, $asjob, $cn)

                # Start-Job serializes/deserializes the CimSession,
                # which means it shows up here as having type Deserialized.CimSession.
                # Must recreate or cast the object in order to pass it to Get-CimInstance.
                if ($asjob)
                {
                    $session = $session | New-CimSession
                }

                Get-CimInstance -CimSession $session -Namespace $ns -ClassName $cn
            }

            if ($asjob)
            {
                $p = $true
                Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $StorageNamespace, $p, $className)
            }
            else
            {
                if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
                {
                    &$block $CimSession $StorageNamespace $p $className
                }
            }
        }
        else
        {
            # Would use a closure here, but jobs are run in their own session state.
            $block = {
                param($session, $ns, $asjob, $mn, $io)

                # Start-Job serializes/deserializes the CimSession,
                # which means it shows up here as having type Deserialized.CimSession.
                # Must recreate or cast the object in order to pass it to Get-CimInstance.
                if ($asjob)
                {
                    $session = $session | New-CimSession
                }

                $r = Invoke-CimMethod -CimSession $session -InputObject $io -MethodName $mn -Confirm:$false

                for($i = 0; $i -lt $r.Count - 1; $i++)
                {
                    $r[$i].ItemValue
                }
            }

            if ($asjob)
            {
                $p = $true
                Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $StorageNamespace, $p, $methodName, $InputObject)
            }
            else
            {
                if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
                {
                    &$block $CimSession $StorageNamespace $p $methodName $InputObject
                }
            }
        }
    }
}


function Get-StorageFaultDomain
{
    [CmdletBinding( DefaultParameterSetName = "EnumerateFaultDomains" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName  = 'ByStorageFaultDomain',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomain,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_VirtualDisk")]
        [Parameter(
            ParameterSetName  = 'ByVirtualDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDisk,

        #### ------------------------- Common parameters -----------------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        $SerialNumber,

        [StorageFaultDomainType]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $Type,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalLocation,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
        [flagsattribute()]
        Enum StorageFaultDomainType
        {
            PhysicalDisk     = 1
            StorageEnclosure = 2
            StorageScaleUnit = 3
            StorageChassis   = 4
            StorageRack      = 5
            StorageSite      = 6
        }

        $className = "MSFT_StorageFaultDomain"

        switch ($Type)
        {
            PhysicalDisk     { $className = "MSFT_PhysicalDisk" }
            StorageEnclosure { $className = "MSFT_StorageEnclosure" }
            StorageScaleUnit { $className = "MSFT_StorageScaleUnit" }
            StorageChassis   { $className = "MSFT_StorageChassis" }
            StorageRack      { $className = "MSFT_StorageRack" }
            StorageSite      { $className = "MSFT_StorageSite" }
        }
    }

    Process
    {
        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance objects.

        $options = New-Object Microsoft.Management.Infrastructure.Options.CimOperationOptions

        if ($PSBoundParameters.ContainsKey("Type"))
        {
            $options.SetCustomOption("ResultObject", $className, $false)
        }

        switch ($psCmdlet.ParameterSetName)
        {
            "ByStorageSubsystem"
            {
                if (($className -eq "MSFT_PhysicalDisk") -and
                    ($StorageSubsystem.Model -like "*Windows Storage*"))
                {
                    $options.SetCustomOption("InputClassName", "MSFT_StorageSubsystem", $false)
                    $options.SetCustomOption("InputObjectId", $StorageSubsystem.ObjectId, $false)

                    $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                              "MSFT_PhysicalDisk",
                                                              $options)
                }
                else
                {
                    $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                        $StorageSubsystem,
                                                                        "MSFT_StorageSubsystemToStorageFaultDomain",
                                                                        $className,
                                                                        "StorageSubSystem",
                                                                        "StorageFaultDomain",
                                                                        $options)
                }

                break;
            }

            "ByStorageFaultDomain"
            {
                $subsystem = $StorageFaultDomain | get-storagesubsystem -CimSession $CimSession

                if (($className -eq "MSFT_PhysicalDisk") -and
                    ($subsystem.Model -like "*Windows Storage*"))
                {
                    $options.SetCustomOption("InputClassName", $StorageFaultDomain.ClassName, $false)
                    $options.SetCustomOption("InputObjectId", $StorageFaultDomain.ObjectId, $false)

                    $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                              "MSFT_PhysicalDisk",
                                                              $options)
                }
                else
                {
                    $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                        $StorageFaultDomain,
                                                                        "MSFT_StorageFaultDomainToStorageFaultDomain",
                                                                        $className,
                                                                        "SourceStorageFaultDomain",
                                                                        "TargetStorageFaultDomain",
                                                                        $options)
                }

                break;
            }

            "ByVirtualDisk"
            {
                $results = $CimSession.EnumerateAssociatedInstances($StorageNamespace,
                                                                    $VirtualDisk,
                                                                    "MSFT_VirtualDiskToStorageFaultDomain",
                                                                    "MSFT_StorageFaultDomain",
                                                                    "VirtualDisk",
                                                                    "StorageFaultDomain")
            }

            "EnumerateFaultDomains"
            {
                $results = $CimSession.EnumerateInstances($StorageNamespace,
                                                          $className)
                break;
            }
        }

        $enumerator = $results.GetEnumerator()
        $instances  = @()

        while ($enumerator.MoveNext())
        {
            $instance = $enumerator.Current

            if (($PSBoundParameters.ContainsKey("FriendlyName")) -and
                ($instance.FriendlyName -notlike $FriendlyName))
            {
                continue
            }

            if (($PSBoundParameters.ContainsKey("SerialNumber")) -and
                ($instance.SerialNumber -notlike $SerialNumber))
            {
                continue
            }

            ## Filter by physical location if required and ensure
            ## the formatting selected is for MSFT_StorageFaultDomain

            if (($PSBoundParameters.ContainsKey("PhysicalLocation")) -and
                ($instance.PhysicalLocation -notlike $PhysicalLocation))
            {
                continue
            }

            $typename = $instance.PSObject.TypeNames.GetEnumerator()
            $index = 0;

            while ($typename.MoveNext())
            {
                if ($typename.Current.Equals("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageObject",
                                             [System.StringComparison]::OrdinalIgnoreCase) -eq $true)
                {
                    break
                }

                $index++
            }

            $instance.PSObject.TypeNames.Insert($index + 1, "Microsoft.Management.Infrastructure.CimInstance#MSFT_StorageFaultDomain")
            $instances += $instance
        }

        $instances
    }
}


function Get-StorageScaleUnit
{
    [CmdletBinding( DefaultParameterSetName = "EnumerateFaultDomains" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName  = 'ByStorageFaultDomain',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomain,

        #### ------------------------- Common parameters -----------------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $SerialNumber,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalLocation,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
    }

    Process
    {
        $arguments = @{}

        $arguments.Add("Type", 'StorageScaleUnit')

        if ($PSBoundParameters.ContainsKey("FriendlyName"))
        {
            $arguments.Add("FriendlyName", $FriendlyName)
        }

        if ($PSBoundParameters.ContainsKey("SerialNumber"))
        {
            $arguments.Add("SerialNumber", $SerialNumber)
        }

        if ($PSBoundParameters.ContainsKey("PhysicalLocation"))
        {
            $arguments.Add("PhysicalLocation", $PhysicalLocation)
        }

        if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
        {
            $arguments.Add("StorageSubsystem", $StorageSubsystem)
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomain"))
        {
            $arguments.Add("StorageFaultDomain", $StorageFaultDomain)
        }

        if ($PSBoundParameters.ContainsKey("CimSession"))
        {
            $arguments.Add("CimSession", $CimSession)
        }

        Get-StorageFaultDomain @arguments
    }
}


function Get-StorageChassis
{
    [CmdletBinding( DefaultParameterSetName = "EnumerateFaultDomains" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName  = 'ByStorageFaultDomain',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomain,

        #### ------------------------- Common parameters -----------------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $SerialNumber,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalLocation,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
    }

    Process
    {
        $arguments = @{}

        $arguments.Add("Type", 'StorageChassis')

        if ($PSBoundParameters.ContainsKey("FriendlyName"))
        {
            $arguments.Add("FriendlyName", $FriendlyName)
        }

        if ($PSBoundParameters.ContainsKey("SerialNumber"))
        {
            $arguments.Add("SerialNumber", $SerialNumber)
        }

        if ($PSBoundParameters.ContainsKey("PhysicalLocation"))
        {
            $arguments.Add("PhysicalLocation", $PhysicalLocation)
        }

        if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
        {
            $arguments.Add("StorageSubsystem", $StorageSubsystem)
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomain"))
        {
            $arguments.Add("StorageFaultDomain", $StorageFaultDomain)
        }

        if ($PSBoundParameters.ContainsKey("CimSession"))
        {
            $arguments.Add("CimSession", $CimSession)
        }

        Get-StorageFaultDomain @arguments
    }
}


function Get-StorageRack
{
    [CmdletBinding( DefaultParameterSetName = "EnumerateFaultDomains" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName  = 'ByStorageFaultDomain',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomain,

        #### ------------------------- Common parameters -----------------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $SerialNumber,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalLocation,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
    }

    Process
    {
        $arguments = @{}

        $arguments.Add("Type", 'StorageRack')

        if ($PSBoundParameters.ContainsKey("FriendlyName"))
        {
            $arguments.Add("FriendlyName", $FriendlyName)
        }

        if ($PSBoundParameters.ContainsKey("SerialNumber"))
        {
            $arguments.Add("SerialNumber", $SerialNumber)
        }

        if ($PSBoundParameters.ContainsKey("PhysicalLocation"))
        {
            $arguments.Add("PhysicalLocation", $PhysicalLocation)
        }

        if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
        {
            $arguments.Add("StorageSubsystem", $StorageSubsystem)
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomain"))
        {
            $arguments.Add("StorageFaultDomain", $StorageFaultDomain)
        }

        if ($PSBoundParameters.ContainsKey("CimSession"))
        {
            $arguments.Add("CimSession", $CimSession)
        }

        Get-StorageFaultDomain @arguments
    }
}


function Get-StorageSite
{
    [CmdletBinding( DefaultParameterSetName = "EnumerateFaultDomains" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        [Parameter(
            ParameterSetName  = 'ByStorageSubsystem',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName  = 'ByStorageFaultDomain',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomain,

        #### ------------------------- Common parameters -----------------------------####

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $FriendlyName,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        $SerialNumber,

        [System.String]
        [Parameter(
            ParameterSetName = 'EnumerateFaultDomains',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubsystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageFaultDomain',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalLocation,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Begin
    {
    }

    Process
    {
        $arguments = @{}

        $arguments.Add("Type", 'StorageSite')

        if ($PSBoundParameters.ContainsKey("FriendlyName"))
        {
            $arguments.Add("FriendlyName", $FriendlyName)
        }

        if ($PSBoundParameters.ContainsKey("SerialNumber"))
        {
            $arguments.Add("SerialNumber", $SerialNumber)
        }

        if ($PSBoundParameters.ContainsKey("PhysicalLocation"))
        {
            $arguments.Add("PhysicalLocation", $PhysicalLocation)
        }

        if ($PSBoundParameters.ContainsKey("StorageSubsystem"))
        {
            $arguments.Add("StorageSubsystem", $StorageSubsystem)
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomain"))
        {
            $arguments.Add("StorageFaultDomain", $StorageFaultDomain)
        }

        if ($PSBoundParameters.ContainsKey("CimSession"))
        {
            $arguments.Add("CimSession", $CimSession)
        }

        Get-StorageFaultDomain @arguments
    }
}


function ValidateFaultDomainsExist
{
    Param
    (
        [String[]]
        $StorageFaultDomainFriendlyNames,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubsystem")]
        $StorageSubsystem,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    [Microsoft.Management.Infrastructure.CimInstance[]] $faultdomains = @()

    $subsystemFDs = Get-CimAssociatedInstance -InputObject $StorageSubsystem `
                                              -Association MSFT_StorageSubsystemToStorageFaultDomain `
                                              -ResultClassName MSFT_StorageFaultDomain `
                                              -CimSession $CimSession `
                                              -ErrorAction Stop

    for ($i = 0; $i -lt $StorageFaultDomainFriendlyNames.Count; $i++)
    {
        $found = $false

        foreach ($fd in $subsystemFDs)
        {
            if ($fd.FriendlyName -eq $StorageFaultDomainFriendlyNames[$i])
            {
                $faultdomains += $fd
                $found = $true
                break
            }
        }

        if ($found -eq $false)
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "Could not find storage fault domain with the friendly name '$($StorageFaultDomainFriendlyNames[$i])' in the storage subsystem" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)

            $faultdomains = @()
            break
        }
    }

    return $faultdomains
}


function Add-StorageFaultDomain
{
    [CmdletBinding()]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_VirtualDisk")]
        [Parameter(
            ParameterSetName  = "ByVirtualDisk",
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $VirtualDisk,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskFriendlyName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskName,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskUniqueId,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageTier")]
        [Parameter(
            ParameterSetName  = "ByStorageTier",
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StorageTier,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageTierFriendlyName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageTierFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageTierUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageTierUniqueId,

        #### -------------------- Common method parameters ---------------------------####

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTier',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomains,

        [String[]]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTier',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomainFriendlyNames,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByVirtualDisk"             { $VirtualDiskInstance = $VirtualDisk; break; }
            "ByVirtualDiskFriendlyName" { $VirtualDiskInstance = Get-VirtualDisk -FriendlyName $VirtualDiskFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByVirtualDiskName"         { $VirtualDiskInstance = Get-VirtualDisk -Name $VirtualDiskName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByVirtualDiskUniqueId"     { $VirtualDiskInstance = Get-VirtualDisk -UniqueId $VirtualDiskUniqueId -CimSession $CimSession -ErrorAction Stop; break; }

            "ByStorageTier"             { $StorageTierInstance = $StorageTier; break; }
            "ByStorageTierFriendlyName" { $StorageTierInstance = Get-StorageTier -FriendlyName $StorageTierFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageTierUniqueId"     { $StorageTierInstance = Get-StorageTier -UniqueId $StorageTierUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Add-StorageFaultDomain" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
        }

        if ($VirtualDiskInstance)
        {
            $subsystem = $VirtualDiskInstance | get-storagesubsystem -CimSession $CimSession
        }
        elseif ($StorageTierInstance)
        {
            $subsystem = $StorageTierInstance | get-storagesubsystem -CimSession $CimSession
        }

        ## Populate arguments list

        $arguments = @{}

        if ($PSBoundParameters.ContainsKey("StorageFaultDomains") -and
            $PSBoundParameters.ContainsKey("StorageFaultDomainFriendlyNames"))
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "Use either 'StorageFaultDomains' or 'StorageFaultDomainFriendlyNames' parameter" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomains"))
        {
            $arguments.Add("StorageFaultDomains", $StorageFaultDomains)
        }
        elseif ($PSBoundParameters.ContainsKey("StorageFaultDomainFriendlyNames"))
        {
            [Microsoft.Management.Infrastructure.CimInstance[]] $faultdomains = @()

            $faultdomains = ValidateFaultDomainsExist -StorageFaultDomainFriendlyNames $StorageFaultDomainFriendlyNames `
                                                      -StorageSubsystem $subsystem `
                                                      -CimSession $CimSession

            if ($faultdomains.Count -eq 0)
            {
                return
            }

            $arguments.Add("StorageFaultDomains", $faultdomains)
        }

        # Would use a closure here, but jobs are run in their own session state.
        $addfdblock = {
            param($session, $asjob, $inputobject, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null
            $output      = $null

            try
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "Add-StorageFaultDomain" -PercentComplete 10 -CurrentOperation "Adding storage fault domains" -Status "1/2"
                }

                $progressPreference = "silentlyContinue"

                $output = Invoke-CimMethod -CimSession $session -InputObject $inputobject -MethodName AddStorageFaultDomain -Arguments $arguments -ErrorAction Stop

                $progressPreference = "Continue"
            }
            catch
            {
                $progressPreference = "Continue"

                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
            }
            finally
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "Add-StorageFaultDomain" -Completed -Status "2/2"
                }
            }

            if ($errorObject)
            {
                $psCmdlet.WriteError($errorObject)
            }
            else
            {
                $null
            }
        }

        if ($asjob)
        {
            $p = $true

            if ($VirtualDiskInstance)
            {
                Start-Job -Name AddStorageFaultDomain -ScriptBlock $addfdblock -ArgumentList @($CimSession, $p, $VirtualDiskInstance, $arguments)
            }
            elseif ($StorageTierInstance)
            {
                Start-Job -Name AddStorageFaultDomain -ScriptBlock $addfdblock -ArgumentList @($CimSession, $p, $StorageTierInstance, $arguments)
            }
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                if ($VirtualDiskInstance)
                {
                    &$addfdblock $CimSession $p $VirtualDiskInstance $arguments
                }
                elseif ($StorageTierInstance)
                {
                    &$addfdblock $CimSession $p $StorageTierInstance $arguments
                }
            }
        }
    }
}


function Remove-StorageFaultDomain
{
    [CmdletBinding()]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_VirtualDisk")]
        [Parameter(
            ParameterSetName  = "ByVirtualDisk",
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $VirtualDisk,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskFriendlyName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskName,

        [String]
        [Parameter(
            ParameterSetName  = "ByVirtualDiskUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $VirtualDiskUniqueId,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageTier")]
        [Parameter(
            ParameterSetName  = "ByStorageTier",
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StorageTier,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageTierFriendlyName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageTierFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageTierUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageTierUniqueId,

        #### -------------------- Common method parameters ---------------------------####

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTier',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomains,

        [String[]]
        [Parameter(
            ParameterSetName = 'ByVirtualDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByVirtualDiskUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTier',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageTierUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomainFriendlyNames,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByVirtualDisk"             { $VirtualDiskInstance = $VirtualDisk; break; }
            "ByVirtualDiskFriendlyName" { $VirtualDiskInstance = Get-VirtualDisk -FriendlyName $VirtualDiskFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByVirtualDiskName"         { $VirtualDiskInstance = Get-VirtualDisk -Name $VirtualDiskName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByVirtualDiskUniqueId"     { $VirtualDiskInstance = Get-VirtualDisk -UniqueId $VirtualDiskUniqueId -CimSession $CimSession -ErrorAction Stop; break; }

            "ByStorageTier"             { $StorageTierInstance = $StorageTier; break; }
            "ByStorageTierFriendlyName" { $StorageTierInstance = Get-StorageTier -FriendlyName $StorageTierFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageTierUniqueId"     { $StorageTierInstance = Get-StorageTier -UniqueId $StorageTierUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Remove-StorageFaultDomain" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
        }

        if ($VirtualDiskInstance)
        {
            $subsystem = $VirtualDiskInstance | get-storagesubsystem -CimSession $CimSession
        }
        elseif ($StorageTierInstance)
        {
            $subsystem = $StorageTierInstance | get-storagesubsystem -CimSession $CimSession
        }

        ## Populate arguments list

        $arguments = @{}

        if ($PSBoundParameters.ContainsKey("StorageFaultDomains") -and
            $PSBoundParameters.ContainsKey("StorageFaultDomainFriendlyNames"))
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "Use either 'StorageFaultDomains' or 'StorageFaultDomainFriendlyNames' parameter" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        if ($PSBoundParameters.ContainsKey("StorageFaultDomains"))
        {
            $arguments.Add("StorageFaultDomains", $StorageFaultDomains)
        }
        elseif ($PSBoundParameters.ContainsKey("StorageFaultDomainFriendlyNames"))
        {
            [Microsoft.Management.Infrastructure.CimInstance[]] $faultdomains = @()

            $faultdomains = ValidateFaultDomainsExist -StorageFaultDomainFriendlyNames $StorageFaultDomainFriendlyNames `
                                                      -StorageSubsystem $subsystem `
                                                      -CimSession $CimSession

            if ($faultdomains.Count -eq 0)
            {
                return
            }

            $arguments.Add("StorageFaultDomains", $faultdomains)
        }

        # Would use a closure here, but jobs are run in their own session state.
        $removefdblock = {
            param($session, $asjob, $inputobject, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null
            $output      = $null

            try
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "Remove-StorageFaultDomain" -PercentComplete 10 -CurrentOperation "Removing storage fault domains" -Status "1/2"
                }

                $progressPreference = "silentlyContinue"

                $output = Invoke-CimMethod -CimSession $session -InputObject $inputobject -MethodName RemoveStorageFaultDomain -Arguments $arguments -ErrorAction Stop

                $progressPreference = "Continue"
            }
            catch
            {
                $progressPreference = "Continue"

                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
            }
            finally
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "Remove-StorageFaultDomain" -Completed -Status "2/2"
                }
            }

            if ($errorObject)
            {
                $psCmdlet.WriteError($errorObject)
            }
            else
            {
                $null
            }
        }

        if ($asjob)
        {
            $p = $true

            if ($VirtualDiskInstance)
            {
                Start-Job -Name RemoveStorageFaultDomain -ScriptBlock $removefdblock -ArgumentList @($CimSession, $p, $VirtualDiskInstance, $arguments)
            }
            elseif ($StorageTierInstance)
            {
                Start-Job -Name RemoveStorageFaultDomain -ScriptBlock $removefdblock -ArgumentList @($CimSession, $p, $StorageTierInstance, $arguments)
            }
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                if ($VirtualDiskInstance)
                {
                    &$removefdblock $CimSession $p $VirtualDiskInstance $arguments
                }
                elseif ($StorageTierInstance)
                {
                    &$removefdblock $CimSession $p $StorageTierInstance $arguments
                }
            }
        }
    }
}


function New-Volume
{
    [CmdletBinding( DefaultParameterSetName = "ByStoragePool" )]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StoragePool")]
        [Parameter(
            ParameterSetName  = "ByStoragePool",
            ValueFromPipeline = $true,
            Mandatory         = $false,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StoragePool,

        [String]
        [Parameter(
            ParameterSetName  = "ByStoragePoolFriendlyName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StoragePoolFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStoragePoolName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StoragePoolName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStoragePoolUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StoragePoolUniqueId,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Disk")]
        [Parameter(
            ParameterSetName  = "ByDisk",
            ValueFromPipeline = $true,
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $Disk,

        [UInt32]
        [Parameter(
            ParameterSetName  = "ByDiskNumber",
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $DiskNumber,

        [String]
        [Parameter(
            ParameterSetName  = "ByDiskPath",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $DiskPath,

        [String]
        [Parameter(
            ParameterSetName  = "ByDiskUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $DiskUniqueId,

        #### -------------------- Common method parameters ---------------------------####

        [String]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByDisk',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByDiskNumber',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByDiskPath',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByDiskUniqueId',
            Mandatory        = $true)]
        [ValidateNotNullOrEmpty()]
        $FriendlyName,

        [FileSystemType]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskPath',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $FileSystem,

        [String]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskPath',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $AccessPath,

        [Char]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskPath',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $DriveLetter,

        [UInt32]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDisk',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskNumber',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskPath',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByDiskUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $AllocationUnitSize,

        #### -------------------- Storage pool parameters ----------------------------####

        [UInt64]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $Size,

        [String]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $ResiliencySettingName,

        [ProvisioningType]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $ProvisioningType,

        [MediaType]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $MediaType,

        [UInt16]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("FaultDomainRedundancy")]
        $PhysicalDiskRedundancy,

        [UInt16]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $NumberOfDataCopies,

        [UInt16]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $NumberOfColumns,

        [UInt16]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $NumberOfGroups,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomainsToUse,

        [String[]]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageFaultDomainsToUseFriendlyNames,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageTier")]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageTiers,

        [String[]]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageTierFriendlyNames,

        [UInt64[]]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $StorageTierSizes,

        [UInt64]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $WriteCacheSize,

        [UInt64]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        [ValidateNotNullOrEmpty()]
        $ReadCacheSize,

        [Switch]
        [Parameter(
            ParameterSetName = 'ByStoragePool',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStoragePoolUniqueId',
            Mandatory        = $false)]
        $UseMaximumSize  = $false,

        #### -------------------- Disk parameters ------------------------------------####


        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin
    {
        $SourceCaller = "Microsoft.PowerShell"

        [flagsattribute()]
        Enum FileSystemType
        {
            NTFS       = 14
            ReFS       = 15
            CSVFS_NTFS = 32768
            CSVFS_ReFS = 32769
        }

        [flagsattribute()]
        Enum ProvisioningType
        {
            Unknown = 0
            Thin    = 1
            Fixed   = 2
        }

        [flagsattribute()]
        Enum MediaType
        {
            HDD = 3
            SSD = 4
            SCM = 5
        }
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByStoragePool"
            {
                if ($StoragePool -ne $null)
                {
                    $PoolInstance = $StoragePool
                }
                else
                {
                    # Also accept the existence of a single non-primordial pool as unambiguous
                    $PoolInstance = Get-StoragePool |? IsPrimordial -eq $false
                    if ($PoolInstance -eq $null -or $PoolInstance.Count -gt 1)
                    {
                        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                         -ErrorMessage "Storage pool must be specified by one of the 'StoragePool' parameters" `
                                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                         -Exception $null `
                                                         -TargetObject $null

                        $psCmdlet.WriteError($errorObject)
                        return
                    }
                }

                break
            }
            "ByStoragePoolFriendlyName" { $PoolInstance = Get-StoragePool -FriendlyName $StoragePoolFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStoragePoolName"         { $PoolInstance = Get-StoragePool -Name $StoragePoolName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStoragePoolUniqueId"     { $PoolInstance = Get-StoragePool -UniqueId $StoragePoolUniqueId -CimSession $CimSession -ErrorAction Stop; break; }

            "ByDisk"                    { $DiskInstance = $Disk; break; }
            "ByDiskNumber"              { $DiskInstance = Get-Disk -Number $DiskNumber -CimSession $CimSession -ErrorAction Stop; break; }
            "ByDiskPath"                { $DiskInstance = Get-Disk -Path $DiskPath -CimSession $CimSession -ErrorAction Stop; break; }
            "ByDiskUniqueId"            { $DiskInstance = Get-Disk -UniqueId $DiskUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
        }

        if (-not $AsJob)
        {
            if ($PoolInstance)
            {
                Write-Progress -Activity "New-Volume" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/3"
            }
            elseif ($DiskInstance)
            {
                Write-Progress -Activity "New-Volume" -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
            }
        }

        ## Populate arguments list

        $arguments = @{}

        if ($PSBoundParameters.ContainsKey("FriendlyName"))
        {
            $arguments.Add("FriendlyName", $FriendlyName)
        }

        if ($PSBoundParameters.ContainsKey("FileSystem"))
        {
            $arguments.Add("FileSystem", [System.UInt16]$FileSystem)
        }

        if ($PSBoundParameters.ContainsKey("AccessPath") -and
            $PSBoundParameters.ContainsKey("DriveLetter"))
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "Use either 'AccessPath' or 'DriveLetter' parameter" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        if ($PSBoundParameters.ContainsKey("AccessPath"))
        {
            $arguments.Add("AccessPath", $AccessPath)
        }
        elseif ($PSBoundParameters.ContainsKey("DriveLetter"))
        {
            $arguments.Add("AccessPath", $DriveLetter + ":")
        }

        if ($PSBoundParameters.ContainsKey("AllocationUnitSize"))
        {
            $arguments.Add("AllocationUnitSize", $AllocationUnitSize)
        }

        if ($PoolInstance)
        {
            if ($PSBoundParameters.ContainsKey("Size"))
            {
                $arguments.Add("Size", $Size)
            }

            if ($PSBoundParameters.ContainsKey("ResiliencySettingName"))
            {
                $arguments.Add("ResiliencySettingName", $ResiliencySettingName)
            }

            if ($PSBoundParameters.ContainsKey("ProvisioningType"))
            {
                $arguments.Add("ProvisioningType", [System.UInt16]$ProvisioningType)
            }

            if ($PSBoundParameters.ContainsKey("MediaType"))
            {
                $arguments.Add("MediaType", [System.UInt16]$MediaType)
            }

            if ($PSBoundParameters.ContainsKey("PhysicalDiskRedundancy"))
            {
                $arguments.Add("PhysicalDiskRedundancy", $PhysicalDiskRedundancy)
            }

            if ($PSBoundParameters.ContainsKey("NumberOfDataCopies"))
            {
                $arguments.Add("NumberOfDataCopies", $NumberOfDataCopies)
            }

            if ($PSBoundParameters.ContainsKey("NumberOfColumns"))
            {
                $arguments.Add("NumberOfColumns", $NumberOfColumns)
            }

            if ($PSBoundParameters.ContainsKey("NumberOfGroups"))
            {
                $arguments.Add("NumberOfGroups", $NumberOfGroups)
            }

            if ($PSBoundParameters.ContainsKey("StorageFaultDomainsToUse") -and
                $PSBoundParameters.ContainsKey("StorageFaultDomainsToUseFriendlyNames"))
            {
                $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                 -ErrorMessage "Use either 'StorageFaultDomainsToUse' or 'StorageFaultDomainsToUseFriendlyNames' parameter" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                 -Exception $null `
                                                 -TargetObject $null

                $psCmdlet.WriteError($errorObject)
                return
            }

            if ($PSBoundParameters.ContainsKey("StorageFaultDomainsToUse"))
            {
                $arguments.Add("StorageFaultDomainsToUse", $StorageFaultDomainsToUse)
            }
            elseif ($PSBoundParameters.ContainsKey("StorageFaultDomainsToUseFriendlyNames"))
            {
                [Microsoft.Management.Infrastructure.CimInstance[]] $faultdomains = @()

                $subsystem = $PoolInstance | get-storagesubsystem -CimSession $CimSession

                $faultdomains = ValidateFaultDomainsExist -StorageFaultDomainFriendlyNames $StorageFaultDomainsToUseFriendlyNames `
                                                          -StorageSubsystem $subsystem `
                                                          -CimSession $CimSession

                if ($faultdomains.Count -eq 0)
                {
                    return
                }

                $arguments.Add("StorageFaultDomainsToUse", $faultdomains)
            }

            if ($PSBoundParameters.ContainsKey("StorageTiers") -and
                $PSBoundParameters.ContainsKey("StorageTierFriendlyNames"))
            {
                $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                 -ErrorMessage "Use either 'StorageTiers' or 'StorageTierFriendlyNames' parameter" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                 -Exception $null `
                                                 -TargetObject $null

                $psCmdlet.WriteError($errorObject)
                return
            }

            if ($PSBoundParameters.ContainsKey("StorageTiers"))
            {
                $arguments.Add("StorageTiers", $StorageTiers)
            }
            elseif ($PSBoundParameters.ContainsKey("StorageTierFriendlyNames"))
            {
                [Microsoft.Management.Infrastructure.CimInstance[]] $tiers = @()

                $poolTiers = Get-CimAssociatedInstance -InputObject $PoolInstance `
                                                       -Association MSFT_StoragePoolToStorageTier `
                                                       -ResultClassName MSFT_StorageTier `
                                                       -CimSession $CimSession `
                                                       -ErrorAction Stop

                for ($i = 0; $i -lt $StorageTierFriendlyNames.Count; $i++)
                {
                    $found = $false

                    foreach ($tier in $poolTiers)
                    {
                        if ($tier.FriendlyName -eq $StorageTierFriendlyNames[$i])
                        {
                            $tiers += $tier
                            $found = $true
                            break
                        }
                    }

                    if ($found -eq $false)
                    {
                        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                         -ErrorMessage "Could not find storage tier with the friendly name '$($StorageTierFriendlyNames[$i])' in the storage pool" `
                                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                         -Exception $null `
                                                         -TargetObject $null

                        $psCmdlet.WriteError($errorObject)
                        return
                    }
                }

                $arguments.Add("StorageTiers", $tiers)
            }

            if ($PSBoundParameters.ContainsKey("StorageTierSizes"))
            {
                $arguments.Add("StorageTierSizes", $StorageTierSizes)
            }

            if ($PSBoundParameters.ContainsKey("WriteCacheSize"))
            {
                $arguments.Add("WriteCacheSize", $WriteCacheSize)
            }

            if ($PSBoundParameters.ContainsKey("ReadCacheSize"))
            {
                $arguments.Add("ReadCacheSize", $ReadCacheSize)
            }

            if ($PSBoundParameters.ContainsKey("UseMaximumSize"))
            {
                $arguments.Add("UseMaximumSize", $UseMaximumSize.ToBool())
            }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $poolblock = {
            param($session, $asjob, $pool, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null
            $output      = $null
            $virtualdisk = $null
            $volume      = $null

            $subsystem = $pool | get-storagesubsystem -CimSession $session

            # If the subsystem model is "Windows Storage",
            # perform the individual steps
            if ($subsystem.Model -like "*Windows Storage*")
            {
                $volCreateParams = @{}

                if ($arguments.ContainsKey("FriendlyName"))
                {
                    $volCreateParams.Add("FriendlyName", $arguments["FriendlyName"])
                }

                if ($arguments.ContainsKey("FileSystem"))
                {
                    $volCreateParams.Add("FileSystem", $arguments["FileSystem"])
                    $arguments.Remove("FileSystem")
                }
                elseif ($subsystem.Model -eq "Clustered Windows Storage" -and
                        $subsystem.StorageConnectionType -eq "Local Storage" -and
                        $subsystem.SupportedFileSystems -contains [FilesystemType]::CSVFS_ReFS)
                {
                    # If the subsystem is clustered local (storage spaces direct) and supports it,
                    # default to CSVFS + ReFS.
                    $volCreateParams.Add("FileSystem", [System.Uint16][FilesystemType]::CSVFS_ReFS)
                }

                if ($arguments.ContainsKey("AccessPath"))
                {
                    $volCreateParams.Add("AccessPath", $arguments["AccessPath"])
                    $arguments.Remove("AccessPath")
                }

                if ($arguments.ContainsKey("AllocationUnitSize"))
                {
                    $volCreateParams.Add("AllocationUnitSize", $arguments["AllocationUnitSize"])
                    $arguments.Remove("AllocationUnitSize")
                }

                try
                {
                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -PercentComplete 10 -CurrentOperation "Creating virtual disk" -Status "1/3"
                    }

                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $pool -MethodName CreateVirtualDisk -Arguments $arguments -ErrorAction Stop

                    $progressPreference = "Continue"

                    $virtualdisk = $output.CreatedVirtualDisk
                    $disk = $output.CreatedVirtualDisk | get-disk -CimSession $session

                    if ($disk -eq $null)
                    {
                        $errorObject = CreateErrorRecord -ErrorId "ObjectNotFound" `
                                                         -ErrorMessage "The disk associated with the virtual disk created could not be found." `
                                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                         -Exception $null `
                                                         -TargetObject $null

                        $psCmdlet.WriteError($errorObject)
                        return
                    }

                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -PercentComplete 70 -CurrentOperation "Creating volume" -Status "2/3"
                    }

                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $disk -MethodName CreateVolume -Arguments $volCreateParams -ErrorAction Stop

                    $progressPreference = "Continue"

                    $volume = $output.CreatedVolume
                }
                catch
                {
                    $progressPreference = "Continue"

                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -PercentComplete 90 -CurrentOperation "Error encountered. Checking if cleanup is required." -Status "2/3"
                    }

                    $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                     -ErrorMessage $null `
                                                     -ErrorCategory $_.CategoryInfo.Category `
                                                     -Exception $_.Exception `
                                                     -TargetObject $_.TargetObject

                    # If virtual disk was created and volume was formatted, but
                    # adding to cluster failed or the cluster resource did not
                    # come online after successful addition, do not revert.

                    if (($virtualdisk) -and
                        ($_.FullyQualifiedErrorId -notmatch "46008") -and
                        ($_.FullyQualifiedErrorId -notmatch "46011"))
                    {
                        $progressPreference = "silentlyContinue"

                        $virtualdisk | Remove-VirtualDisk -CimSession $session -Confirm:$false

                        $progressPreference = "Continue"
                    }
                }
                finally
                {
                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -Completed -Status "3/3"
                    }
                }
            }
            # Else fallback to the API on the storage pool
            else
            {
                try
                {
                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -PercentComplete 10 -CurrentOperation "Creating volume" -Status "1/2"
                    }

                    $progressPreference = "silentlyContinue"

                    $output = Invoke-CimMethod -CimSession $session -InputObject $pool -MethodName CreateVolume -Arguments $arguments -ErrorAction Stop

                    $progressPreference = "Continue"

                    $volume = $output.CreatedVolume
                }
                catch
                {
                    $progressPreference = "Continue"

                    $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                     -ErrorMessage $null `
                                                     -ErrorCategory $_.CategoryInfo.Category `
                                                     -Exception $_.Exception `
                                                     -TargetObject $_.TargetObject
                }
                finally
                {
                    if (-not $asjob)
                    {
                        Write-Progress -Activity "New-Volume" -Completed -Status "2/2"
                    }
                }
            }

            if ($errorObject)
            {
                $psCmdlet.WriteError($errorObject)
            }
            else
            {
                $volume
            }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $diskblock = {
            param($session, $asjob, $disk, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $errorObject = $null
            $output      = $null
            $volume      = $null

            try
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "New-Volume" -PercentComplete 10 -CurrentOperation "Creating volume" -Status "1/2"
                }

                $progressPreference = "silentlyContinue"

                $output = Invoke-CimMethod -CimSession $session -InputObject $disk -MethodName CreateVolume -Arguments $arguments -ErrorAction Stop

                $progressPreference = "Continue"

                $volume = $output.CreatedVolume
            }
            catch
            {
                $progressPreference = "Continue"

                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
            }
            finally
            {
                if (-not $asjob)
                {
                    Write-Progress -Activity "New-Volume" -Completed -Status "3/3"
                }
            }

            if ($errorObject)
            {
                $psCmdlet.WriteError($errorObject)
            }
            else
            {
                $volume
            }
        }

        if ($asjob)
        {
            $p = $true

            if ($PoolInstance)
            {
                Start-Job -Name CreateVolume -ScriptBlock $poolblock -ArgumentList @($CimSession, $p, $PoolInstance, $arguments)
            }
            elseif ($DiskInstance)
            {
                Start-Job -Name CreateVolume -ScriptBlock $diskblock -ArgumentList @($CimSession, $p, $DiskInstance, $arguments)
            }
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                if ($PoolInstance)
                {
                    &$poolblock $CimSession $p $PoolInstance $arguments
                }
                elseif ($DiskInstance)
                {
                    &$diskblock $CimSession $p $DiskInstance $arguments
                }
            }
        }
    }
}


function Get-StorageExtendedStatus
{
    [CmdletBinding()]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageJob")]
        [Parameter(
            ParameterSetName  = 'ByStorageJob',
            Mandatory         = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageJob,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession
    )

    Process
    {
        if (-not $CimSession)
        {
             $CimSession = New-CimSession
        }

        ## Gather the instance objects

        switch ($psCmdlet.ParameterSetName)
        {
            "ByStorageJob"  { $inputObject = $StorageJob;  break; }
        }

        $extendedStatus = $null

        try
        {
            $output = Invoke-CimMethod -MethodName "GetExtendedStatus" -InputObject $inputObject -CimSession $CimSession -ErrorAction Stop
            $extendedStatus = $output.ExtendedStatus
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject

            $psCmdlet.WriteError($errorObject)
        }

        $extendedStatus
    }
}

function Get-StorageAdvancedProperty
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            Mandatory         = $true,
            ValueFromPipeline = $true)]
        $PhysicalDisk
    )

    Process
    {
        if ( $PhysicalDisk ) {

            $isDeviceCacheEnabled = $null
            $isPowerProtected     = $null

            $deviceCacheOutput    = Invoke-CimMethod -MethodName IsDeviceCacheEnabled -InputObject $PhysicalDisk -ErrorAction SilentlyContinue
            $powerProtectedOutput = Invoke-CimMethod -MethodName IsPowerProtected     -InputObject $PhysicalDisk -ErrorAction SilentlyContinue

            # DeviceCache error handling
            if ( $deviceCacheOutput -and $deviceCacheOutput.ReturnValue -ne 0 ) {

                Write-Warning "Retrieving IsDeviceCacheEnabled failed with ErrorCode $( $deviceCacheOutput.ReturnValue )."
            }
            else {
                $isDeviceCacheEnabled = $deviceCacheOutput.IsDeviceCacheEnabled
            }

            # PowerProtected error handling
            if ( $powerProtectedOutput -and $powerProtectedOutput.ReturnValue -ne 0 ) {

                Write-Warning "Retrieving IsPowerProtected failed with ErrorCode $( $powerProtectedOutput.ReturnValue )."
            }
            else {
                $isPowerProtected = $powerProtectedOutput.IsPowerProtected
            }

            $customDrive = [pscustomobject]@{
                PhysicalDisk         = $PhysicalDisk;
                IsPowerProtected     = $isPowerProtected;
                IsDeviceCacheEnabled = $isDeviceCacheEnabled;
            }

            $customDrive.PSObject.TypeNames.Insert( 0, "Microsoft.Windows.StorageManagement.PhysicalDiskAdvancedProperties" )

            $customDrive
        }
    }
}

function Get-StorageHealthReport
{
    [CmdletBinding()]
    Param
    (
        [CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageObject")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [Int32]
        $Count = 1,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{
        Write-Warning "This cmdlet is deprecated and may not be available in the future. Use Get-ClusterPerformanceHistory instead." 
    }

    Process
    {
        $info = $resources.info
        $p = $null
        $methodName = "GetReport"

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if ($InputObject.CimClass.CimClassName -ne "MSFT_StoragesubSystem" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_StorageNode" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_Volume" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_FileShare")
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "The input object must be a StorageSubSystem, StorageNode, Volume or FileShare" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        if($InputObject.CimSystemProperties.ClassName.Equals("MSFT_FileShare"))
        {
            $InputObject = $InputObject | Get-Volume -CimSession $CimSession -ErrorAction Stop
        }

        $storageSubSystem = $InputObject | Get-StorageSubSystem -CimSession $CimSession -ErrorAction Stop

        $StorageHealth = Get-CimAssociatedInstance -ResultClassName MSFT_StorageHealth -InputObject $storageSubSystem -CimSession $CimSession -ErrorAction Stop

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $ns, $asjob, $mn, $sh, $io, $co)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            Invoke-CimMethod -CimSession $session -InputObject $sh -MethodName $mn -Arguments @{TargetObject=$io;Count=[uint32]$co} -Confirm:$false
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $StorageNamespace, $p, $methodName, $StorageHealth, $InputObject, $Count)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $StorageNamespace $p $methodName $StorageHealth $InputObject $Count
            }
        }
    }
}

function Get-StorageHealthSetting
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubSystem")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [String]
        $Name,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{}

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        $StorageHealth = $InputObject | Get-StorageHealth -CimSession $CimSession -ErrorAction Stop

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $sh, $na)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                # We need to load the module or it fails with CMDLET Not Found
                import-module Storage\StorageHealth.cdxml
                $session = $session | New-CimSession
            }

            $sh | Get-StorageHealthSettingInternal -Name $na -CimSession $session
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $StorageHealth, $Name)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $StorageHealth $Name
            }
        }
    }
}

function Set-StorageHealthSetting
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubSystem")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [String]
        [Parameter(
            Mandatory = $true)]
        $Name,

        [String]
        [Parameter(
            Mandatory = $true)]
        $Value,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{}

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        $StorageHealth = $InputObject | Get-StorageHealth -CimSession $CimSession -ErrorAction Stop

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $sh, $na, $va)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                # We need to load the module or it fails with CMDLET Not Found
                import-module Storage\StorageHealth.cdxml
                $session = $session | New-CimSession
            }

            $sh | Set-StorageHealthSettingInternal -Name $na -Value $va -CimSession $session
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $StorageHealth, $Name, $Value)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $StorageHealth $Name $Value
            }
        }
    }
}

function Remove-StorageHealthSetting
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubSystem")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [String]
        [Parameter(
            Mandatory = $true)]
        $Name,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{}

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        $StorageHealth = $InputObject | Get-StorageHealth -CimSession $CimSession -ErrorAction Stop

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $sh, $na)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                import-module Storage\StorageHealth.cdxml
                $session = $session | New-CimSession
            }

            $sh | Remove-StorageHealthSettingInternal -Name $na -CimSession $session
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $StorageHealth, $Name)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $StorageHealth $Name
            }
        }
    }
}

function Debug-StorageSubSystem
{
    [CmdletBinding( DefaultParameterSetName="ByFriendlyName" )]
    Param
    (
        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByFriendlyName",
            Position          = 0)]
        $StorageSubSystemFriendlyName,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByUniqueId")]
        $StorageSubSystemUniqueId,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByName")]
        $StorageSubSystemName,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubSystem")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{
        Write-Warning "This cmdlet is deprecated and may not be available in the future. Use Get-HealthFault instead." 
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        switch ($PsCmdlet.ParameterSetName)
        {
            "ByName"         { $InputObject = Get-StorageSubSystem -Name $StorageSubSystemName -CimSession $CimSession; break; }
            "ByUniqueId"     { $InputObject = Get-StorageSubSystem -UniqueId $StorageSubSystemUniqueId -CimSession $CimSession; break; }
            "ByFriendlyName" { $InputObject = Get-StorageSubSystem -FriendlyName $StorageSubSystemFriendlyName -CimSession $CimSession; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $result = @()
            $output = Invoke-CimMethod -MethodName Diagnose -InputObject $io -CimSession $session
            foreach($i in $output){$result += $i.ItemValue}
            $result | Sort-Object -Property PerceivedSeverity
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $InputObject
            }
        }
    }
}

function Debug-FileShare
{
    [CmdletBinding( DefaultParameterSetName="ByName" )]
    Param
    (
        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByName",
            Position          = 0 )]
        $Name,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByUniqueId")]
        $UniqueId,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_FileShare")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{
        Write-Warning "This cmdlet is deprecated and may not be available in the future. Use Get-HealthFault instead." 
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        switch ($PsCmdlet.ParameterSetName)
        {
            "ByName"     { $InputObject = Get-FileShare -Name $Name -CimSession $CimSession -ErrorAction stop; break; }
            "ByUniqueId" { $InputObject = Get-FileShare -UniqueId $UniqueId -CimSession $CimSession -ErrorAction stop; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $result = @()
            $output = Invoke-CimMethod -MethodName Diagnose -InputObject $io -CimSession $session
            foreach($i in $output){$result += $i.ItemValue}
            $result | Sort-Object -Property PerceivedSeverity
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $InputObject
            }
        }
    }
}

function Debug-Volume
{
    [CmdletBinding( DefaultParameterSetName="ByDriveLetter" )]
    Param
    (
        [char[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByDriveLetter",
            Position          = 0)]
        $DriveLetter,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ById")]
        $ObjectId,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByPaths")]
        $Path,

        [string[]]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "ByLabel")]
        [Alias("FriendlyName")]
        $FileSystemLabel,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Volume")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Begin{
        Write-Warning "This cmdlet is deprecated and may not be available in the future. Use Get-HealthFault instead." 
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        switch ($PsCmdlet.ParameterSetName)
        {
            "ByDriveLetter" { $io = Get-Volume -CimSession $CimSession -DriveLetter $DriveLetter -ErrorAction stop; break;}
            "ById"          { $io = Get-Volume -CimSession $CimSession -ObjectId $ObjectId -ErrorAction stop; break; }
            "ByPaths"       { $io = Get-Volume -CimSession $CimSession -Path $Path -ErrorAction stop; break;}
            "ByLabel"       { $io = Get-Volume -CimSession $CimSession -FileSystemLabel $FileSystemLabel -ErrorAction stop; break;}
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            $result = @()
            $output = Invoke-CimMethod -MethodName Diagnose -InputObject $io -CimSession $session
            foreach($i in $output){$result += $i.ItemValue}
            $result | Sort-Object -Property PerceivedSeverity
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $InputObject
            }
        }
    }
}

function Enable-StorageMaintenanceMode
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
         $InputObject,

        [Switch]
        $IgnoreDetachedVirtualDisks,

        [System.Nullable[Bool]]
        $ValidateVirtualDisksHealthy,

        [String]
        $Model,

        [String]
        $Manufacturer,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        [Switch]
        $AsJob
    )

    Begin
    {
        [flagsattribute()]
        Enum ValidationFlags
        {
            None                  = 0
            VirtualDisksHealthy   = 1
        }
    }

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if ($InputObject.CimClass.CimClassName -ne "MSFT_PhysicalDisk" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_StorageEnclosure" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_StorageScaleUnit")
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "The input object must be a PhysicalDisk, StorageEnclosure or StorageScaleUnit" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        $arguments = @{}

        $arguments.Add("EnableMaintenanceMode", $true)
        $arguments.Add("IgnoreDetachedVirtualDisks", $IgnoreDetachedVirtualDisks.IsPresent)
        if ($InputObject.CimClass.CimClassName -ne "MSFT_PhysicalDisk")
        {
            if ($PSBoundParameters.ContainsKey("Model"))
            {
                $arguments.Add("Model", $Model)
            }

            if ($PSBoundParameters.ContainsKey("Manufacturer"))
            {
                $arguments.Add("Manufacturer", $Manufacturer)
            }
        }

        $includeValidationFlags = $false
        if ($ValidateVirtualDisksHealthy -ne $null)
        {
            $includeValidationFlags = $true
            if($ValidateVirtualDisksHealthy)
            {
                $validationFlags += [ValidationFlags]::VirtualDisksHealthy
            }
            else
            {
                $validationFlags += [ValidationFlags]::None
            }
        }

        if ($includeValidationFlags)
        {
          $arguments.Add("ValidationFlags", $validationFlags)
        }

        $storageSubSystem = $InputObject | Get-StorageSubSystem -CimSession $CimSession

        if ($storageSubSystem.Model -eq "Clustered Windows Storage")
        {
            $storageHealth = Get-CimAssociatedInstance -ResultClassName MSFT_StorageHealth -InputObject $storageSubSystem -CimSession $CimSession

            $arguments.Add("TargetObject", $InputObject)
        }
        else
        {
            if ($arguments["ValidationFlags"] -ne $null)
            {
                $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                                 -ErrorMessage "The parameter 'ValidateVirtualDisksHealthy' is not supported in this subsystem. Invoke again without this parameter." `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                                 -Exception $null `
                                                 -TargetObject $null

                $psCmdlet.WriteError($errorObject)
                return
            }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io, $arg, $ss, $sh)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            if ($ss.Model -eq "Clustered Windows Storage")
            {
                Invoke-CimMethod -MethodName "Maintenance" -Arguments $arg -InputObject $sh -CimSession $session | Out-Null
            }
            else
            {
                Invoke-CimMethod -MethodName "Maintenance" -Arguments $arg -InputObject $io -CimSession $session | Out-Null
            }
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject, $arguments, $storageSubSystem, $storageHealth)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $InputObject $arguments $storageSubSystem $storageHealth
            }
        }
    }
}

function Disable-StorageMaintenanceMode
{
    [CmdletBinding()]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageFaultDomain")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
        $InputObject,

        [string]
        $Model,

        [string]
        $Manufacturer,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        [Switch]
        $AsJob
    )

    Begin{}

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if ($InputObject.CimClass.CimClassName -ne "MSFT_PhysicalDisk" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_StorageEnclosure" -and
            $InputObject.CimClass.CimClassName -ne "MSFT_StorageScaleUnit")
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                             -ErrorMessage "The input object must be a PhysicalDisk, StorageEnclosure or StorageScaleUnit" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        $arguments = @{}

        $arguments.Add("EnableMaintenanceMode", $false)

        if($InputObject.CimClass.CimClassName -ne "MSFT_PhysicalDisk")
        {
            if ($PSBoundParameters.ContainsKey("Model"))
            {
                $arguments.Add("Model", $Model)
            }

            if ($PSBoundParameters.ContainsKey("Manufacturer"))
            {
                $arguments.Add("Manufacturer", $Manufacturer)
            }
        }

        $storageSubSystem = $InputObject | Get-StorageSubSystem -CimSession $CimSession

        if ($storageSubSystem.Model -eq "Clustered Windows Storage")
        {
            $arguments.Add("TargetObject", $InputObject)

            $storageHealth = Get-CimAssociatedInstance -ResultClassName MSFT_StorageHealth -InputObject $storageSubSystem -CimSession $CimSession
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io, $arg, $ss, $sh)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession
            }

            if ($ss.Model -eq "Clustered Windows Storage")
            {
                Invoke-CimMethod -MethodName "Maintenance" -Arguments $arg -InputObject $sh -CimSession $session | Out-Null
            }
            else
            {
                Invoke-CimMethod -MethodName "Maintenance" -Arguments $arg -InputObject $io -CimSession $session | Out-Null
            }
        }

        if ($asjob)
        {
            $p = $true
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $p, $InputObject, $arguments, $storageSubSystem, $storageHealth)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $p $InputObject $arguments $storageSubSystem $storageHealth
            }
        }
    }
}


function Get-StorageDiagnosticInfo
{
    [CmdletBinding()]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageSubSystem")]
        [Parameter(
            ParameterSetName  = "ByStorageSubSystem",
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageSubSystemFriendlyName",
            Mandatory         = $true,
            Position          = 0)]
        [ValidateNotNullOrEmpty()]
        $StorageSubSystemFriendlyName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageSubSystemName",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $StorageSubSystemName,

        [String]
        [Parameter(
            ParameterSetName  = "ByStorageSubSystemUniqueId",
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("StorageSubSystemId")]
        $StorageSubSystemUniqueId,

        #### -------------------- Method parameters ----------------------------------####

        [String]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $true)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Path")]
        $DestinationPath,

        [UInt32]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $false)]
        $TimeSpan,

        [String]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $false)]
        $ActivityId,

        [System.Management.Automation.SwitchParameter]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $false)]
        $ExcludeOperationalLog = $false,

        [System.Management.Automation.SwitchParameter]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $false)]
        $ExcludeDiagnosticLog = $false,

        [System.Management.Automation.SwitchParameter]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystem',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemFriendlyName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemName',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByStorageSubSystemUniqueId',
            Mandatory        = $false)]
        $IncludeLiveDump = $false,

        #### -------------------- Powershell parameters ------------------------------####

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        # Provided for compatibility with CDXML cmdlets, not actually used.
        [Int32]
        $ThrottleLimit,

        [Switch]
        $AsJob
    )

    Process
    {
        $info = $resources.info
        $p = $null

        if (-not $CimSession)
        {
            $CimSession = New-CimSession
        }

        if (-not $AsJob)
        {
            Write-Progress -Activity "Get-StorageDiagnosticInfo" -Id 0 -PercentComplete 0 -CurrentOperation "Validating parameters" -Status "0/2"
        }

        ## Gather the instance object

        switch ($psCmdlet.ParameterSetName)
        {
            "ByStorageSubSystem"             { $SubsystemInstance = $InputObject; break; }
            "ByStorageSubSystemFriendlyName" { $SubsystemInstance = Get-StorageSubsystem -FriendlyName $StorageSubSystemFriendlyName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageSubSystemName"         { $SubsystemInstance = Get-StorageSubsystem -Name $StorageSubSystemName -CimSession $CimSession -ErrorAction Stop; break; }
            "ByStorageSubSystemUniqueId"     { $SubsystemInstance = Get-StorageSubsystem -UniqueId $StorageSubSystemUniqueId -CimSession $CimSession -ErrorAction Stop; break; }
        }

        # Would use a closure here, but jobs are run in their own session state.
        $methodblock = {
            param($session, $asjob, $uniqueId, $arguments)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                # We need to load the module or it fails with CMDLET Not Found
                import-module Storage\StorageSubSystem.cdxml

                $session = $session | New-CimSession
            }

            $parameters = @{}

            $parameters.Add("CimSession", $session )
            $parameters.Add("StorageSubSystemUniqueId", $uniqueId )
            $parameters.Add("DestinationPath", $arguments["DestinationPath"] )

            if ($arguments.ContainsKey("TimeSpan"))
            {
                $parameters.Add("TimeSpan", $arguments["TimeSpan"])
            }

            if ($arguments.ContainsKey("ActivityId"))
            {
                $parameters.Add("ActivityId", $arguments["ActivityId"])
            }

            if ($arguments.ContainsKey("ExcludeOperationalLog"))
            {
                $parameters.Add("ExcludeOperationalLog", $arguments["ExcludeOperationalLog"])
            }

            if ($arguments.ContainsKey("ExcludeDiagnosticLog"))
            {
                $parameters.Add("ExcludeDiagnosticLog", $arguments["ExcludeDiagnosticLog"])
            }

            if ($arguments.ContainsKey("IncludeLiveDump"))
            {
                $parameters.Add("IncludeLiveDump", $arguments["IncludeLiveDump"])
            }

            if (-not $asjob)
            {
                Write-Progress -Activity "Get-StorageDiagnosticInfo" -Id 0 -PercentComplete 10 -CurrentOperation "Gathering storage diagnostic logs" -Status "1/2"
            }

            Get-StorageDiagnosticInfoInternal @parameters

            if (-not $asjob)
            {
                Write-Progress -Activity "Get-StorageDiagnosticInfo" -Completed -Status "2/2"
            }
        }

        if ($asjob)
        {
            $p = $true

            Start-Job -Name GetDiagnosticInfo `
                      -ScriptBlock $methodblock `
                      -ArgumentList @($CimSession, $p, $SubsystemInstance.UniqueId, $PSBoundParameters)
        }
        else
        {
            &$methodblock $CimSession $p $SubsystemInstance.UniqueId $PSBoundParameters
        }
    }
}

function Remove-StorageHealthIntent
{
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="High"
    )]
    Param
    (
        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageObject")]
        [Parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true,
            ParameterSetName  = "InputObject")]
         $InputObject,

        [Microsoft.Management.Infrastructure.CimSession]
        $CimSession,

        [Switch]
        $AsJob
    )

    Process
    {
        $info = $resources.info

        if (-not $CimSession)
        {
            $CimSession = New-CimSession -Verbose:$false
        }

        $arguments = @{}

        $storageSubSystem = $InputObject | Get-StorageSubSystem -CimSession $CimSession

        if ($storageSubSystem.Model -eq "Clustered Windows Storage")
        {
            $storageHealth = Get-CimAssociatedInstance -ResultClassName MSFT_StorageHealth -InputObject $storageSubSystem -CimSession $CimSession

            $arguments.Add("TargetObject", $InputObject)
        }
        else
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidSubsystem" `
                                             -ErrorMessage "This method is not supported for this subsystem." `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }

        # Would use a closure here, but jobs are run in their own session state.
        $block = {
            param($session, $asjob, $io, $arg, $sh)

            # Start-Job serializes/deserializes the CimSession,
            # which means it shows up here as having type Deserialized.CimSession.
            # Must recreate or cast the object in order to pass it to Get-CimInstance.
            if ($asjob)
            {
                $session = $session | New-CimSession -Verbose:$false
            }

            Invoke-CimMethod -MethodName "RemoveIntent" -Arguments $arg -InputObject $sh -CimSession $session | Out-Null
        }

        if ($asjob)
        {
            Start-Job -ScriptBlock $block -ArgumentList @($CimSession, $true, $InputObject, $arguments, $storageHealth)
        }
        else
        {
            if ($pscmdlet.ShouldProcess($info, $resources.warning, $info))
            {
                &$block $CimSession $false $InputObject $arguments $storageHealth
            }
        }
    }
}

New-Alias Get-PhysicalDiskSNV Get-PhysicalDiskStorageNodeView
New-Alias Get-DiskSNV Get-DiskStorageNodeView
New-Alias Get-StorageEnclosureSNV Get-StorageEnclosureStorageNodeView

Export-ModuleMember -Alias * -Function *