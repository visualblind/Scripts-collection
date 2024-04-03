#
# Copyright (c) Microsoft Corporation.  All rights reserved.
#
# Version: 1.0.0.0
# Revision 2015.05.26
#

# --------------------------------------------------------------------------------------------------------------------------
# CONSTANTS
# --------------------------------------------------------------------------------------------------------------------------
$TIMESTAMP_FORMAT = "yyyy/MM/dd HH:mm:ss.fffffff"

$WORKDIR = "$env:TEMP\WindowsUpdateLog"
$SYM_CACHE = "$WORKDIR\SymCache"
$SYSTEM32 = "$env:windir\System32"
$DEBUG_LOG_PATH = "$WORKDIR\debug.log"

# Dependencies
$TRACERPT_EXE_PATH = "$SYSTEM32\tracerpt.exe"
$DBGHELP_DLL_PATH = "$SYSTEM32\DbgHelp.dll"

$BINLIST = @(
    "wuaueng.dll",
    "wuapi.dll",
    "wuuhext.dll",
    "wuuhmobile.dll",
    "wuautoappupdate.dll",
    "storewuauth.dll",
    "wuauclt.exe")

# TraceRpt.exe fails with "data area passed in too small" error which is really just insufficient buffer error. It happens
# when the total size of ETLs we're passing in is too huge. We're going to batch it every 10 ETLs to workaround the issue.
$MAX_ETL_PER_BATCH = 10

# Column headers in CSV produced by tracerpt.exe
$CSV_HEADER= "EventName, Type, Event ID, Version, Channel, Level, Opcode, Task, Keyword, PID, TID, ProcessorNumber, InstanceID, ParentInstanceID, ActivityID, RelatedActivityID,  ClockTime, KernelTime, UserTime, UserData, Function, LogMessage, Ignore1, Ignore2, IgnoreGuid1, SourceLine, IgnoreTime, Ignore3, Category, LogLevel, TimeStamp, IgnoreGuid2"

# --------------------------------------------------------------------------------------------------------------------------
# FUNCTIONS
# --------------------------------------------------------------------------------------------------------------------------

#
# Verify that required tool and its dependencies are in our working directory, and copy them over if they're not.
#
function CopyDependencies
{
    Write-Verbose "Initializing ..."

    New-Item -Path $WORKDIR -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

    Copy-Item -Path $TRACERPT_EXE_PATH -Destination $WORKDIR -Force -ErrorAction Stop

    Copy-Item -Path $DBGHELP_DLL_PATH -Destination $WORKDIR -Force -ErrorAction Stop

    #
    # Find TraceRpt.exe's MUI files which could be in many different folders like en-US, zh-CN, etc. Look for all of them and copy to our work dir.
    #
    $test = Get-ChildItem -Directory "$env:SystemRoot\System32"

    Get-ChildItem -Directory "$env:SystemRoot\System32" | ForEach-Object {

        $sourceMUI = "$($_.FullName)\tracerpt.exe.mui"

        if (Test-Path $sourceMUI)
        {
            $destFolder = "$WORKDIR\$($_.Name)"
            $destMUI = "$destFolder\tracerpt.exe.mui"

            New-Item -Path $destFolder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
            Copy-Item -Path $sourceMUI -Destination $destMUI -Force -ErrorAction Stop
        }
    }

    Write-Verbose "Done."
}

#
# Given a path to single ETL file or a directory containing multiple ETL files, return a list containing the fullpaths of the ETLs.
#
function GetListOfETLs
{
    Param(
        [string[]] $Paths = $(throw "'Paths' parameter is required.")
    )

    Write-Verbose "Gathering ETL files ..."

    $etlList = New-Object System.Collections.Generic.List[System.String]

    foreach ($path in $Paths)
    {
        # If user passes in a directory as $ETLPath, grabs all the ETLs in that folder.
        if (Test-Path $path -PathType Container)
        {
            $etls = Get-ChildItem $path -Filter WindowsUpdate*.etl

            if ($etls.Length -eq 0)
            {
                throw "File not found: No Windows Update ETL file under $path"
            }

            foreach ($etl in $etls)
            {
                $etlList.Add($etl.FullName.Trim())
            }
        }
        else
        {
            if (!(Test-Path $path))
            {
                throw "File not found: $path"
            }

            $etlList.Add($path.Trim())
        }
    }

    if ($etlList.Count -gt 1)
    {
        Write-Verbose "Sorting ETLs numerically ..."    

        # Pad the last decimal before .etl in WindowsUpdate.20150609.225042.704.1.etl so ETLs can be sorted numerically.    
        $etlList = $etlList | Sort-Object { [regex]::Replace($_, '\d+(?=.etl)', { $args[0].Value.PadLeft(10) }) }
    }

    Write-Verbose "Found $($etlList.Count) ETLs."

    return $etlList
}

#
# Given a list of ETLs, decode them into XML or CSV file using TraceRpt.exe
#
function DecodeETL
{
    Param(
        [System.Collections.Generic.List[System.String]] $ETLList = $(throw "'ETLList' parameter is required."),
        [string] $OutPath = $(throw "'OutPath' parameter is required."),
        [ValidateSet('XML', 'CSV')] $Type = $(throw "'Type' parameter is required.")
    )

    Write-Verbose "Decoding $($ETLList.Count) ETLs to $OutPath using $Type processing ..."

    if (Test-Path $OutPath)
    {
        Remove-Item $OutPath -Force -ErrorAction Stop
    }

    #
    # Build tracerpt arguments.
    #
    $args = New-Object System.Collections.Generic.List[System.String]

    # ETL files
    $args.AddRange($ETLList)

    # output format
    $args.Add("-of")
    $args.Add($Type)

    # output file
    $args.Add("-o")
    $args.Add($OutPath)

    # binary list
    $binaries = ""

    foreach ($bin in $BINLIST)
    {
        $binaries = "$binaries$SYSTEM32\$bin;"
    }

    $args.Add("-i")
    $args.Add("$binaries")

    # no prompt
    $args.Add("-y")

    # Switch directory to SymCache so that tracerpt.exe writes the TMF and MOF files there.
    if (!(Test-Path $SYM_CACHE))
    {
        New-Item -ItemType Directory -Path $SYM_CACHE -ErrorAction Stop
    }

    $popd = Get-Location
    Set-Location $SYM_CACHE

    #
    # Decode ETLs to XML
    #
    $start = Get-Date

    & "$WORKDIR\tracerpt.exe" $args | Out-Default

    Write-Verbose "Done. Elapsed: $((Get-Date).Subtract($start).TotalMilliseconds) ms."

    Set-Location $popd

    if ($LastExitCode -ne 0)
    {
        throw "Failed to decode ETLs. TraceRpt.exe returned error= $LastExitCode"
    }

    if (!(Test-Path $OutPath))
    {
        throw "Failed to decode ETLs. TraceRpt.exe failed to produce $OutPath"
    }
}

#
# Given an XML file produced by tracerpt.exe, convert it to user friendly text log.
#
function ConvertXmlToLog
{
    Param(
        [string] $XmlPath = $(throw "'XmlPath' parameter is required."),
        [string] $LogPath = $(throw "'LogPath' parameter is required.")
    )

    Write-Verbose "Converting $XmlPath to $LogPath ..."

    if (Test-Path $LogPath)
    {
        Remove-Item $LogPath -Force -ErrorAction Stop
    }

    [xml] $xml = Get-Content $XmlPath

    $writer = New-Object System.IO.StreamWriter $LogPath
    $start = Get-Date

    try
    {
        $nodeNum = 0

        $xml.Events.Event | ForEach-Object {

            $row = $_

            try
            {
                $systemNode = $_.System
                $providerNode = $systemNode.Provider
                $providerName = $systemNode.Provider.Name

                if ($providerNode -ne $null -And $providerName -eq "WUTraceLogging")
                {
                    $eventDataNode = $_.EventData
                    $executionNode = $systemNode.Execution
                    [DateTime] $datetime = $systemNode.TimeCreated.SystemTime
                    
                    $keywordNode = $_.RenderingInfo
                    

                    # Log columns:
                    # Time ProcessID ThreadID Component Message				
                    $writer.WriteLine("$($datetime.ToString($TIMESTAMP_FORMAT)) $($executionNode.ProcessID.ToString().PadRight(5)) $($executionNode.ThreadID.ToString().PadRight(5)) $($keywordNode.Task.ToString().PadRight(15)) $($eventDataNode.Data.'#text')")
                }
            }
            catch
            {
                # Log exception, eat it, and process the rest of the log.
                Write-Warning "Unable to process node $nodeNum."

                "Failed to process line:$nodeNum of $XmlPath`n$row`n$_`n---" | Out-File $DEBUG_LOG_PATH -Encoding ascii -Append
            }

            $nodeNum++
        } # foreach
    }
    finally
    {
        $writer.Close()
    }

    Write-Verbose "Done. Elapsed: $((Get-Date).Subtract($start).TotalMilliseconds) ms."
}

#
# Given a CSV file produced by tracerpt.exe, convert it to user friendly text log.
#
function ConvertCsvToLog
{
    Param(
        $CsvPath = $(throw "'CsvPath' parameter is required."),
        $LogPath = $(throw "'LogPath' parameter is required.")
    )

    Write-Verbose "Converting $CsvPath to $LogPath ..."

    if (Test-Path $LogPath)
    {
        Remove-Item $LogPath -Force -ErrorAction Stop
    }

    $csvText = Get-Content $CsvPath
    $csvText[0] = $CSV_HEADER

    $csv = ConvertFrom-Csv $csvText

    $writer = New-Object System.IO.StreamWriter $LogPath
    $start = Get-Date

    try
    {
        $lineNum = 0

        $csv | ForEach-Object {

            $row = $_

            try
            {
                if ($_.EventName -ne "EventTrace" -And !($_.EventName.StartsWith("{")))
                {
                    [DateTime] $datetime = [DateTime]::FromFileTimeUTC($_.ClockTime).ToLocalTime()

                    # convert hex string to decimals
                    $processId = $_.PID -as [int]
                    $threadId = $_.TID -as [int]

                    # Log columns:
                    # Time ProcessID ThreadID Component Message
                    $writer.WriteLine("$($datetime.ToString($TIMESTAMP_FORMAT)) $($processId.ToString().PadRight(5)) $($threadId.ToString().PadRight(5)) $($_.EventName.PadRight(15)) $($_.UserData)")
                }
            }
            catch
            {
                # Log exception, eat it, and process the rest of the log.
                Write-Warning "Unable to process line $lineNum."

                "Unable to process line:$lineNum of $CsvPath`n$row`n$_`n---" | Out-File $DEBUG_LOG_PATH -Encoding ascii -Append
            }

            $lineNum++
        } # foreach
    }
    finally
    {
        $writer.Close()
    }

    Write-Verbose "Done. Elapsed: $((Get-Date).Subtract($start).TotalMilliseconds) ms."
}

function FlushWindowsUpdateETLs
{
    Write-Verbose "Flushing Windows Update ETLs ..."

    Stop-Service usosvc -ErrorAction Stop
    Stop-Service wuauserv -ErrorAction Stop

    Write-Verbose "Done."
}

#
# Given an ETL path, convert the ETL file(s) into text log.
#
function ConvertETLsToLog
{
    Param(
        [string[]] $ETLPaths = $(throw "'etlPaths' parameter is required."),
        [string] $LogPath = $(throw "'LogPath' parameter is required."),
        [ValidateSet('XML', 'CSV')] $Type = $(throw "'type' parameter is required.")
    )

    if ($ETLPaths.Count -gt 1)
    {
        "`nMerging and converting $($ETLPaths.Count) ETLs into $LogPath ..." | Out-Default
    }
    elseif ($ETLPaths.Count -eq 1)
    {
        "`nConverting $($ETLPaths[0]) into $LogPath ..." | Out-Default
    }
    else
    {
        throw "No Windows Update ETL file found."
    }

    $start = Get-Date

    [System.Collections.Generic.List[System.String]] $etlList = GetListOfETLs -path $ETLPaths

    $tempFilePath = "$WORKDIR\wuetl.$Type.tmp"
    $tempLogPath = "$WORKDIR\wuetl.log.tmp"

    Remove-Item "$tempFilePath.*" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$tempLogPath.*" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item $DEBUG_LOG_PATH -Force -ErrorAction SilentlyContinue | Out-Null

    $processed = 0;
    $tempFileCount = 0
    
    # Pad tempFileCount so files can be sorted numerically.
    $NumFormat = "{0:00000}"

    while ($processed -lt $etlList.Count)
    {
        $remaining = $etlList.Count - $processed

        $numberedTempFile = "$tempFilePath.$NumFormat" -f $tempFileCount
        $numberedLogFile = "$tempLogPath.$NumFormat" -f $tempFileCount

        if ($remaining -ge $MAX_ETL_PER_BATCH)
        {
            DecodeETL -ETLList $etlList.GetRange($processed, $MAX_ETL_PER_BATCH) -OutPath $numberedTempFile -Type $Type
            $processed += $MAX_ETL_PER_BATCH
        }
        else
        {
            DecodeETL -ETLList $etlList.GetRange($processed, $remaining) -OutPath $numberedTempFile -Type $Type
            $processed += $remaining
        }       

        if ($Type -eq 'XML')
        {
            ConvertXmlToLog -XmlPath $numberedTempFile -LogPath $numberedLogFile
        }
        else
        {
            ConvertCsvToLog -CsvPath $numberedTempFile -LogPath $numberedLogFile
        }

        $tempFileCount++
    }

    if ($tempFileCount -gt 1)
    {
        Write-Verbose "Merging all temporary logs into one ..."
        Get-Content "$tempLogPath.*" | Out-File $LogPath -Encoding ascii
    }
    else
    {
        $src = "$tempLogPath.$NumFormat" -f 0
        Copy-Item -Path $src -Destination $LogPath -ErrorAction Stop
    }

    # Not removing $tempFilePath.* so users can use XML/CSVs to do more fancy stuff should they wish.
    Remove-Item "$tempLogPath.*" -ErrorAction SilentlyContinue | Out-Null

    Write-Verbose "Total elapsed: $((Get-Date).Subtract($start).TotalMilliseconds) ms."

    "`nWindowsUpdate.log written to $LogPath`n" | Out-Default
}

#.ExternalHelp WindowsUpdateLog.psm1-help.xml
function Get-WindowsUpdateLog
{
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    Param(
        [parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('PsPath')]
        [string[]] $ETLPath = @("$env:windir\logs\WindowsUpdate"),

        [parameter(
            Position = 1)]
        [string] $LogPath = "$([System.Environment]::GetFolderPath("Desktop"))\WindowsUpdate.log",

        [ValidateSet('CSV', 'XML')]
        [string] $ProcessingType = 'CSV',

        [switch] $ForceFlush
    )

    begin
    {
        $etls = New-Object System.Collections.ArrayList
    }

    process
    {
        #
        # Handles pipeline input. For e.g. get-childitem C:\temp | get-windowsupdatelog
        #
        if ($_ -ne $null)
        {
            if ($_.PsPath -eq $null -or !(Test-Path $_.PsPath))
            {
                throw "ETL file cannot be found or is invalid: $_"
            }
            
            $etls.Add($_.FullName) | Out-Null
        }
        #
        # Handles regular input. For e.g. get-windowsupdate.log C:\temp\WindowsUpdate1.etl, C:\temp\WindowsUpdate2.etl
        #
        else
        {
            foreach ($p in $ETLPath)
            {
                if (!(Test-Path $p))
                {
                    throw "File not found: $p"
                }
                $etls.Add($p) | Out-Null
            }
        }
    }

    end
    {
        if ($ForceFlush)
        {
            if ($PSCmdlet.ShouldProcess("$env:COMPUTERNAME", "Stopping Update Orchestrator and Windows Update services"))
            {
                FlushWindowsUpdateETLs
            }
            else
            {
                return
            }
        }

        # The rest of the function doesn't support -WhatIf, so just bail out if -WhatIf is specified
        if ($WhatIfPreference)
        {
            return
        }

        #
        # Make sure we have permission to write log file to requested path.
        #
        $logDir = Split-Path -Parent $LogPath

        if (!(Test-Path $logDir))
        {
            New-Item -Path $logDir -ErrorAction Stop
        }

        try
        {
            "Checking write access" | Out-File -FilePath $LogPath -Encoding ascii
        }
        catch [System.UnauthorizedAccessException]
        {
            throw "No permission to write to $LogPath"
        }

        #
        # Do work now.
        #
        CopyDependencies

        ConvertETLsToLog -ETLPaths $etls -LogPath $LogPath -Type $ProcessingType
    }
}

Export-ModuleMember -Function Get-WindowsUpdateLog