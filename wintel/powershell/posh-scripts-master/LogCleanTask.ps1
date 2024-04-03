# LogCleanTask.ps1 v1.0 (c) Chris Redit

## Settings
# The commented variables below are used to configure the script. 
# Please see https://github.com/chrisred/posh-scripts#logcleantaskps1 for the full README.

# The folders to delete files from, this includes the retention period in days, and the path to the folder
$Paths = @(
    @{'Retention' = 7; 'Path' = 'C:\Example1'};
    @{'Retention' = 14; 'Path' = '\\HOST1\c$\Example2'};
)
# Set the -Force parameter value, $true will allow hidden and read-only files to be deleted, default $false
$ForceRemove = $false
# Set the -WhatIf parameter value, $true will only log actions no files will be deleted, default $false
$WhatIf = $false
# Enable the log file (for event log logging a source named 'LogClean' must be registered), default $false
$EnableLogFile = $false
# Path to write the log file to, default is 'C:\Windows\Temp'
$LogPath = "$env:WINDIR\Temp" 

$LogTime = Get-Date -Format 'yyMMddHHmm'
Function Write-Log ([String]$Message, [Nullable[Int]]$EventId = $null, [String]$EventType = 'Information')
{
    if ($EnableLogFile)
    {
        if (-not (Test-Path -Path $LogPath)) {New-Item -ItemType Directory -Path $LogPath}
        Out-File -InputObject $Message -FilePath (Join-Path -Path $LogPath -ChildPath "logclean-$($LogTime).log") -Append    
    }
    
    try
    {
        if ($EventId -ne $null)
        {
            Write-EventLog -LogName Application -Source 'LogClean' -Message $Message -EventId $EventId -EntryType $EventType -EA Stop
        }
    }
    catch
    {
        Write-Warning "Event log: $($_.ToString())"
    }
}

try
{
    $Events = [System.Collections.ArrayList]@()
    $TotalRemoveCount = 0

    foreach ($Path in $Paths)
    {
        $FileRemoveCount = 0
        $FileErrorCount = 0
        $TotalFileSize = 0

        # track events for each iteration, $i returns the index of the new item
        $i = $Events.Add(@{
            'Retention' = $Path.Retention;
            'Message' = 'None';
        })
        
        if (Test-Path -LiteralPath $Path.Path)
        {
            $RemoveTime = (Get-Date).AddDays(-$Path.Retention)
            $Files = @(Get-ChildItem -LiteralPath $Path.Path | Where-Object {!$_.PSIsContainer -and $_.LastWriteTime -lt $RemoveTime})

            foreach ($File in $Files)
            {
                Remove-Item -LiteralPath $File.FullName -Force:$ForceRemove -WhatIf:$WhatIf
                if ($?)
                {
                    $FileRemoveCount++
                    $TotalFileSize += $File.Length
                }
                else
                {
                    $FileErrorCount++
                    Write-Warning "Error removing $($File.Name)"
                }
            }

            $TotalRemoveCount += $FileRemoveCount
            $Events[$i]['Files'] = $FileRemoveCount
            $Events[$i]['Errors'] = $FileErrorCount
            $Events[$i]['Size'] = $TotalFileSize
            $Events[$i]['Path'] = $Path.Path
            $events[$i]['Message'] = 'Path found.'
        }
        else
        {
            $Events[$i]['Files'] = 'N/A'
            $Events[$i]['Errors'] = 'N/A'
            $Events[$i]['Size'] = 'N/A'
            $Events[$i]['Path'] = $Path.Path
            $events[$i]['Message'] = 'Path does not exist.'
        }
    }
}
catch
{
    # write a short version of the exception details to the log and rethrow
    $ErrorText += $_.ToString()+"`r`n"
    $ErrorText += $_.InvocationInfo.PositionMessage+"`r`n"
    Write-Log $ErrorText -EventId 1945 -EventType 'Error'
    throw
}
finally
{
    $EventText = $Events | ForEach-Object {'  '+$_.Retention+' days, '+$_.Files+', '+$_.Errors+', '+$_.Size+' bytes, '+$_.Path+', '+$_.Message} | Out-String
    $ErrorText = $Error | ForEach-Object {'  '+$_.ToString()} | Out-String
    $LogText = `
@"
$TotalRemoveCount file(s) removed from $($Paths.Count) folder(s):

Retention, Removed Files, File Errors, Total Size, Path, Message
$EventText

$($Error.Count) error(s) were encountered:
$ErrorText
"@
    Write-Host $LogText
    Write-Log $LogText -EventId 1946 -EventType 'Information'
}
