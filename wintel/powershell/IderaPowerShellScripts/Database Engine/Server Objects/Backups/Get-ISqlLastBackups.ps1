<#
	.SYNOPSIS
		Get-ISqlLastBackups
	.DESCRIPTION
		Retrieve last backup date/time of databases
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlLastBackups -serverInstance Server01\SQL2012
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
		
#>

param(
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" )
}
process {
	try {
		Write-Verbose "Get last backups using SMO for a given server instance..."

		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		$dbs = @()

		foreach ($database in $smoServer.databases) {
			$DBName = $database.Name

			if ($database.LastBackupDate -eq "01/01/0001 00:00:00") { 
				$LastFull = "N/A"
			} else { 
				$LastFull = $database.LastBackupDate.ToString("yyyy/MM/dd HH:mm:ss")
			}

			if ($database.LastDifferentialBackupDate -eq "01/01/0001 00:00:00") {
				$LastDifferential = "N/A"
			} else {
				$LastDifferential = $database.LastDifferentialBackupDate.ToString("yyyy/MM/dd HH:mm:ss")
			}

			if ($database.LastBackupDate -eq "01/01/0001 00:00:00") {
				$MostRecentBackupType = "N/A"
			} elseif ($database.LastBackupDate -gt $database.LastDifferentialBackupDate) {
				$MostRecentBackupType = "FULL"
			} else {
				$MostRecentBackupType = "DIFF"
			}

			if ($database.LastBackupDate -eq "01/01/0001 00:00:00") {
				$DaysSinceLastBackup = "Never Backed Up"
			} elseif ($database.LastDifferentialBackupDate -gt $database.LastBackupDate) {
				$DaysSinceLastBackup = ((Get-Date) - $database.LastDifferentialBackupDate).Days
			} else {
				$DaysSinceLastBackup = ((Get-Date) - $database.LastBackupDate).Days
			}

			if ($database.Name -ne "tempdb") {
				$database.Refresh()
				$db = New-Object -TypeName PSObject -Property @{
					DBName = $DBName
					LastFull = $LastFull
					LastDifferential = $LastDifferential
					MostRecentBackupType = $MostRecentBackupType
					DaysSinceLastBackup = $DaysSinceLastBackup 
				}
				$dbs += $db
			} 
		}
		Write-Output $dbs
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}