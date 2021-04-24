<#
	.SYNOPSIS
		Backup-ISsasDatabase
	.DESCRIPTION
		Backup all Analysis Server databases
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER backupDestination
		Back destination <drive:\x\y | \\unc\path>
	.PARAMETER databaseName
		Database name to backup
	.PARAMETER logDir
		Log directory <drive:\x\y | \\unc\path> 
	.EXAMPLE
		.\Backup-ISsasDatabase -serverInstance MyServer -BackupDestination C:\SSASbackup 
						-databaseName Test -LogDir C:\SSASLog
	.INPUTS
	.OUTPUTS
		write backup files (*.abf)
		create log file of activity
	.NOTES
		Original script attributed to Ron Klimaszewski
	.LINK
#>

param (
	[string]$ServerInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])", 
	[string]$BackupDestination = "$(Read-Host 'Backup Destination' [e.g. C:\SSASBackup])", 
	[string]$DatabaseName = "$(Read-Host 'Database Name' [e.g. test])", 
	[string]$LogDir
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices") 
}
process {
	Write-Verbose "Backup specified Analysis Server database..."

	try {
		# Declare SSAS objects
		$amoServer = New-Object Microsoft.AnalysisServices.Server
		$serverBackup = New-Object Microsoft.AnalysisServices.BackupInfo

		# Connect to Analysis Server with specified instance
		$amoServer.Connect($ServerInstance) 

		if ($amoServer.ServerProperties.Count -eq 0) {
			Throw "Not able to connect and retrieve properties, check that you current account has permission to server."
		}

		# Set Backup destination to Analysis Server default if not supplied
		if ($backupDestination -eq $null) {
			Write-Verbose "Setting the Destination parameter to the BackupDir parameter" 
			$BackupDestination = $amoServer.ServerProperties.Item("BackupDir").Value 
		} 

		# Test for existence of Backup Destination path
		if (!(test-path $backupDestination)) {
			Throw "Destination path $backupDestination does not exists." 
		} else {
			Write-Verbose "Backup files will be written to $backupDestination" 
		} 

		# Set Log directory to Analysis Server default if not applied
		if ($logDir -eq "") {
			Write-Verbose "Setting the Log directory parameter to the LogDir parameter" 
			$logDir = $amoServer.ServerProperties.Item("LogDir").Value 
		} 

		# Test for existence of Log directory path
		if (!(test-path $logDir)) {
			Throw "Log directory $logDir does not exists." 
		} else {
			Write-Verbose "Logs will be written to $logDir"
		} 

		# Test if Log directory and Backup destination paths end on "\" and add if missing
		if (-not $logDir.EndsWith("\")) {
			$logDir += "\"
		} 

		if (-not $backupDestination.EndsWith("\")) {
			$backupDestination += "\"
		} 

		# Create Log file name using Server instance
		$logFile = $logDir + "SSASBackup." + $serverInstance.Replace("\","_") + ".log" 
		Write-Verbose "Log file name is $logFile"

		Write-Verbose "Creating database object and set options..."
		$db = $amoServer.Databases[$databaseName]
		$serverBackup.AllowOverwrite = 1 
		$serverBackup.ApplyCompression = 1 
		$serverBackup.BackupRemotePartitions = 1 

		# Create backup timestamp
		$backupTS = Get-Date -Format "yyyy-MM-ddTHHmm" 

		# Add message to backup Log file
		Write-Verbose "Backing up files on $serverInstance at $backupTS"
		"Backing up files on $ServerInstance at $backupTS" | Out-File -filepath $LogFile -encoding oem -append 

		# Back up the SSAS database
		$serverBackup.file = $backupDestination + $db.name + "." + $backupTS + ".abf" 

		Write-Verbose "Backing up ($db.Name) to ($serverBackup.File)"
		$db.Backup($serverBackup) 

		if ($?) {
			"Successfully backed up " + $db.Name + " to " + $serverBackup.File | Out-File -filepath $logFile -encoding oem -append
		} else {
			"Failed to back up " + $db.Name + " to " + $serverBackup.File | Out-File -filepath $logFile -encoding oem -append
		} 

		# Disconnect from Analysis Server
		$amoServer.Disconnect() 

	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
	finally {
		if ($amoServer -ne $null) { $amoServer.Dispose() }
	}
}