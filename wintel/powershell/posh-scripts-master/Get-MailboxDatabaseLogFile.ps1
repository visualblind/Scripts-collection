# Get-MailboxDatabaseLogFile.ps1 v1.0 (c) Chris Redit

<#
.SYNOPSIS
    Get log files associated with an Exchange database.
.DESCRIPTION
    The Get-MailboxDatabaseLogFile cmdlet gets log files associated with an Exchange database. By default only the log files committed to the Exchange database are returned. These are log files that can be moved or deleted in a situation where free space on the volume hosting the database is running out. Exchange 2010 and greater is supported only.

    Log files with a sequence number are matched using the ESE Utilites binary (eseutil.exe) included with Exchange, these are files with a prefix then 8 digits of hexadecimal (E000000001A.log). The active log file is not matched. 

    The correct way to purge log files is to run a backup, this ensures that a valid copy of the database exists and therefore log files older than the backup date are no longer needed to complete a restore. If log files after the last backup date are deleted, and database corruption occurs, then data since the last backup is lost. When log files are still available they can be replayed into a restored database to reduce the data loss.
.PARAMETER LogFolderPath
    Specifies the path the database transaction log files are saved to.
.PARAMETER LogFilePrefix
    Specifies the prefix identifying the log stream.
.PARAMETER BinaryFilePath
    Specifies the path to the ESE Utility (eseutil.exe) found on systems with Exchange installed.
.PARAMETER CommitedOnly
    Matches commited log files only when $true and all log files (except the active file) when $false.
.PARAMETER Verbose
    Prints the stdout output from eseutil.exe, only has an effect when the parameter "CommitedOnly" is $true.
.OUTPUTS
    An array of IO.FileInfo objects or $null (if no log files are matched) on success.
    A terminating error.
.EXAMPLE
    .\Get-MailboxDatabaseLogFile.ps1 -LogFolderPath 'D:\ExchangeDB1\' -LogFilePrefix 'E00'
.EXAMPLE
    Get-MailboxDatabase -Name ExchangeDB1 | . \Get-MailboxDatabaseLogFile.ps1 | Select-Object -Last 20 | Remove-Item
.EXAMPLE
    Get-MailboxDatabase -Name ExchangeDB1 | . \Get-MailboxDatabaseLogFile.ps1 | Move-Item -Destination "C:\CommitedLogs"
#>
[CmdletBinding()]
Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$True)]
    [String]$LogFolderPath,
    [Parameter(Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$True)]
    [String]$LogFilePrefix,
    [String]$BinaryFilePath = 'eseutil.exe',
    [Bool]$CommitedOnly = $true
)

Process
{
    # match all log files for the path + prefix given, and sort by the last write time from newest to oldest
    $LogFiles = @(Get-ChildItem -Path $LogFolderPath | Where-Object -FilterScript {$_.Name -match "$LogFilePrefix[0-9a-fA-F]{8}\.log"} | Sort-Object -Property LastWriteTime -Descending )

    if ($CommitedOnly)
    {
        try
        {
            $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
            $ProcessInfo.FileName = $BinaryFilePath
            $ProcessInfo.CreateNoWindow = $true
            $ProcessInfo.RedirectStandardError = $true
            $ProcessInfo.RedirectStandardOutput = $true
            $ProcessInfo.UseShellExecute = $false
            
            # create the checkpoint file path and pass it into the new process arguments
            $CheckpointFilePath = Join-Path -Path $LogFolderPath -ChildPath "$($LogFilePrefix).chk"
            $ProcessInfo.Arguments = '/mk "'+$CheckpointFilePath+'"'
            
            $Process = New-Object System.Diagnostics.Process
            $Process.StartInfo = $ProcessInfo
            $Process.Start() | Out-Null
            $ProcessOutput = $Process.StandardOutput.ReadToEnd()
            $Process.WaitForExit()

            if ($PSBoundParameters['Verbose']) {Write-Verbose $ProcessOutput}

            if ($Process.ExitCode -lt 0)
            {
                throw [Management.Automation.PSInvalidOperationException] "ESE Utilites (eseutil.exe) terminated with the error code: $($Process.ExitCode). Try running in verbose mode to verify the output."
            }
            else
            {
                # This regex matches using multiline mode (m) to match whitespace then the string "Checkpoint:" to get the correct line for
                # the last commited log, rather than the last backed up log "LastFullBackupCheckpoint:".
                if ($ProcessOutput -match '(?m)^\s+Checkpoint\:\s\(0x([0-9a-fA-F]+),[0-9a-fA-F]+,[0-9a-fA-F]+\)')
                {
                    $CheckpointRef = $Matches[1]
                }
                else
                {
                    throw [Management.Automation.PSInvalidOperationException] "A checkpoint location could not matched from ESE Utilites (eseutil.exe). Try running in verbose mode to verify the output."
                }

                $CheckpointFile = $LogFiles | Where-Object -FilterScript {$_.Name -match "$($CheckpointRef)\.log$"}
                $LogFiles | Where-Object -FilterScript {$_.LastWriteTime -lt $CheckpointFile.LastWriteTime}
            }
        }
        catch
        {
            throw
        }
    }
    else
    {
        $LogFiles
    }
}
