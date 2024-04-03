function Start-EtwTraceSession
{
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]

    param(
        [Parameter(Position=0,
                   Mandatory=$true)]
        [System.String]$Name,

        [Parameter()]
        [System.UInt32]$LogFileMode = 0x09000000,

        [Parameter()]
        [System.String]$LocalFilePath,

        [Parameter()]
        [System.UInt32]$MaximumFileSize,

        [Parameter()]
        [System.UInt32]$BufferSize,

        [Parameter()]
        [System.UInt32]$MinimumBuffers,

        [Parameter()]
        [System.UInt32]$MaximumBuffers,

        [Parameter()]
        [System.UInt32]$FlushTimer,

        [Parameter()]
        [ValidateSet('Performance','System', 'Cycle')]
        [System.String]$ClockType,

        [Parameter()]
        [ValidateSet('File','Buffering', 'Sequential', 'Circular')]
        [System.String]$FileMode,

        [Parameter()]
        [Switch]
        $Compress,

        [Parameter()]
        [Switch]
        $RealTime,

        [Parameter()]
        [Switch]
        $NonPaged,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    $mode = $LogFileMode

    if ($FileMode.Length -gt 0)
    {
        switch($FileMode.ToLowerInvariant())
        {
            {($_ -eq "file")} {}
            {($_ -eq "buffering")} { $mode = $mode -bor 0x400}
            {($_ -eq "sequential")} { $mode = $mode -bor 0x1}
            {($_ -eq "circular")} { $mode = $mode -bor 0x2}
        }

        $x = $PSBoundParameters.Remove("FileMode")
    }

    if ($NonPaged -eq $true)
    {
        $mode = $mode -bxor 0x01000000
        $x = $PSBoundParameters.Remove("NonPaged")
    }

    if ($RealTime -eq $true)
    {
        $mode = $mode -bor 0x00000100
        $x = $PSBoundParameters.Remove("RealTime")
    }

    if ($Compress -eq $true)
    {
        $mode = $mode -bor 0x04000000
        $x = $PSBoundParameters.Remove("Compress")
    }

    if ($mode -ne 0)
    {
        $PSBoundParameters["LogFileMode"] = $mode
    }

    New-EtwTraceSession @PSBoundParameters
}

function Save-EtwTraceSession
{
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]

    param(
        [Parameter(Position=0,
                   Mandatory=$true)]
        [System.String]$Name,

        [Parameter(ValueFromPipeLine=$True)]
        [System.IO.FileInfo]$OutputFile,

        [Parameter(ValueFromPipeLine=$True)]
        [System.IO.DirectoryInfo]$OutputFolder,

        [Parameter()]
        [Switch]
        $Stop,

        [Parameter()]
        [Switch]
        $Overwrite,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if ($PSBoundParameters.ContainsKey("DeleteAfterSend") -eq $true)
    {
        $x = $PSBoundParameters.Remove("DeleteAfterSend")
    }

    if ($PSBoundParameters.ContainsKey("DestinationFolder") -eq $true)
    {
        $x = $PSBoundParameters.Remove("DestinationFolder")
    }

    $file = "$Name.etl"
    $pathSet = 0

    if ($PSBoundParameters.ContainsKey("CimSession") -eq $true)
    {
        $session = Get-EtwTraceSession $Name -CimSession $CimSession
    }
    else
    {
        $session = Get-EtwTraceSession $Name   
    }

    if ($session -eq $null)
    {
        # Error message would have already come from Get-EtwTraceSession
        return $null
    }

    if ($PSBoundParameters.ContainsKey("OutputFile") -eq $true)
    {
        $file = $OutputFile.FullName
        $pathSet = $pathSet + 1
        $x = $PSBoundParameters.Remove("OutputFile")
    }

    if ($PSBoundParameters.ContainsKey("OutputFolder") -eq $true)
    {
        if (($session.LocalFilePath -ne $null) -and (test-path $session.LocalFilePath))
        {
            $existingTrace = get-item $session.LocalFilePath
            $file = $existingTrace.Name
        }

        $file = join-path $OutputFolder.FullName $file
        $pathSet = $pathSet + 1
        $x = $PSBoundParameters.Remove("OutputFolder")
    }

    if ($PSBoundParameters.ContainsKey("Overwrite") -eq $true)
    {
        $x = $PSBoundParameters.Remove("Overwrite")
    }

    if ($pathSet -gt 1)
    {
        throw "Only 1 file parameter can be set"
        # TODO: Localize
    }

    if ($PSBoundParameters.ContainsKey("CimSession") -eq $true)
    {
        $exists = get-ciminstance -classname CIM_DataFile -filter ("Name='$file'".replace("\", "\\")) -CimSession $CimSession
        if ($exists -ne $null -and $Overwrite -eq $false)
        {
            throw "Output file already exists. Use -Overwrite to overwrite."
            # TODO: Localize
        }
    }
    else
    {
        $exists = test-path $file
        if ($exists -eq $true -and $Overwrite -eq $false)
        {
            throw "Output file already exists. Use -Overwrite to overwrite."
            # TODO: Localize
        }
    }

    $result = Send-EtwTraceSession -DestinationFolder $file @PSBoundParameters

    if ($result -ne $null -and $result.ReturnValue -ne $null -and ($result.ReturnValue.ToString() -eq "Success"))
    {
        if ($PSBoundParameters.ContainsKey("CimSession") -eq $true)
        {
            if ($Stop -eq $true)
            {
                Remove-EtwTraceSession $Name -CimSession $CimSession
            }

            return get-ciminstance -classname CIM_DataFile -filter ("Name='$file'".replace("\", "\\")) -CimSession $CimSession
        }
        else
        {
            if ($Stop -eq $true)
            {
                Remove-EtwTraceSession $Name
            }

            return get-item $file
        }
    }
    else
    {
        return $null
    }
}
