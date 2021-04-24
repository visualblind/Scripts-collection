#Restore-TransLogs.ps1 -server "SERVER" -database "MY_Database"

Param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [Parameter(Mandatory=$true)]
    [string]$database,
    [Parameter(Mandatory=$true)]
    [string]$FilePath
    )
Set-StrictMode -Version Latest
[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")
[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended")
 
## SQL Server Backup\Restore uses local file paths.
Function Get-LocalPath($File) {
    $dir = $File.DirectoryName
    $rp = $dir.Remove(0,($dir.IndexOf('$')+2))
    $root = (((Get-Item $dir).Root).Name).Replace('$',':')
    $local = $root + '\' + $rp + '\' + $File
    $local 
}
Function New-SMOconnection {
    Param (
        [string]$server
    )
    $conn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection($server)
    $conn.applicationName = "PowerShell SMO"
    $conn.StatementTimeout = 0
    $conn.Connect()
    if ($conn.IsOpen -eq $false) {
        Throw "Could not connect to server $($server)"
    }
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server($conn)
    $smo
}
Function Invoke-SqlRestore {
    Param(
        [string]$filename
    )
    # Get a new connection to the server
    $backupDevice = New-Object("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($filename, "File")
 
    # Load up the Restore object settings
    $Restore = new-object Microsoft.SqlServer.Management.Smo.Restore
    $Restore.Action = [Microsoft.SqlServer.Management.Smo.RestoreActionType]::Log
    $Restore.Database = $database
    $Restore.NoRecovery = $true
    $Restore.Devices.Add($backupDevice)
 
    $Restore.SqlRestore($smo)
}
Clear-Host
$smo = New-SMOconnection -server $Server
If(!(Test-Path -LiteralPath $FilePath)){Throw "FilePath not found: $FilePath"}
Get-ChildItem $FilePath -Filter "*.trn" | Sort-Object -Property LastWriteTime | 
    ForEach-Object {
        If(($_.Fullname).StartsWith('\\')) {$file = Get-LocalPath $_ }
        Else {$file = $_.FullName}
        Try {Invoke-SqlRestore -filename $file}
        Catch {
            $ex = $Error[0].Exception
            Write-Output $ex.message
            while ($ex.InnerException)
            {
                $ex = $ex.InnerException
                Write-Output $ex.message
            }
        }
}
If ($smo.ConnectionContext.IsOpen -eq $true) {$smo.ConnectionContext.Disconnect()}