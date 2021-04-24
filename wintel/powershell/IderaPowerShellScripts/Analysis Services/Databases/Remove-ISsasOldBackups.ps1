<#
	.SYNOPSIS
		Remove-ISsasOldBackups
	.DESCRIPTION
		Backup all Analysis Server databases
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER backupDestination
		Back destination <drive:\x\y | \\unc\path>
	.PARAMETER retentionDays
		Number of days to retain backup
	.PARAMETER logDir
		Log directory <drive:\x\y | \\unc\path>
	.EXAMPLE
		Remove with default retention of 2 days using default Log directory
		.\Remove-ISsasOldBackups -serverInstance MyServer 
	.EXAMPLE
		Remove with specified retention of 5 days using default Log directory
		.\Remove-ISsasOldBackups -serverInstance MyServer -RetentionDays 5 
	.EXAMPLE
		Remove with specified retention of 5 days using specified Log directory
		.\Remove-ISsasOldBackups -serverInstance MyServer -RetentionDays 5 -logDir C:\SSASBackup
	.INPUTS
	.OUTPUTS
		Create log file of activity
	.NOTES
	.LINK
#>

param (
	[string]$ServerInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])", 
	[string]$BackupDestination = "$(Read-Host 'Backup Destination' [e.g. C:\SSASBackup])", 
	[string]$LogDir, 
	[int]$RetentionDays = 2
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices") 
}
process {
	try {
		# Force a minimum of two days of retention 
		if ($RetentionDays -lt 2 ) {
			$RetentionDays = 2 
		} 

		# Declare SSAS objects
		$amoServer = New-Object Microsoft.AnalysisServices.Server
		$serverBackup = New-Object Microsoft.AnalysisServices.BackupInfo

		# Connect to Analysis Server with specified instance
		$amoServer.Connect($ServerInstance) 

		if ($amoServer.ServerProperties.Count -eq 0) {
			Throw "Not able to connect and retrieve properties, check that you current account has permission to server."
		}

		# Set Backup destination to Analysis Server default if not supplied
		if ($backupDestination -eq "") {
			Write-Verbose "Setting the Destination parameter to the BackupDir parameter" 
			$BackupDestination = $amoServer.ServerProperties.Item("BackupDir").Value 
		} 

		# Test for existence of Backup Destination path
		if (!(test-path $backupDestination)) {
			Throw "Destination path $backupDestination does not exists." 
		} else {
			Write-Verbose "Backup files will be groomed from $backupDestination" 
		} 

		# Set Log directory to Analysis Server default if not applied
		if ($logDir -eq "") {
			Write-Verbose "Setting the Log directory parameter to the LogDir parameter" 
			$logDir = $amoServer.ServerProperties.Item("LogDir").Value 
		} 

		$amoServer.Disconnect()

		# Test for existence of Log directory path
		if (!(test-path $logDir)) {
			Throw "Log directory $logDir does not exists." 
		} else {
			Write-Verbose "Logs will be written to $logDir"
		} 

		# Test if path end on "\" and add if missing
		if (-not $logDir.EndsWith("\")) {
			$logDir += "\"
		} 

		if (-not $backupDestination.EndsWith("\")) {
			$backupDestination += "\"
		} 

		# Create Log file name using Server instance
		$logFile = $logDir + "SSASBackup." + $serverInstance.Replace("\","_") + ".log" 
		Write-Verbose "Log file name is $logFile"

		# Clear out the old files and files backed up to the Log file
		Write-Verbose "Grooming out old backups from $BackupDestination" 
		
		[int]$retentionHours = $retentionDays * 24 * - 1 
		"Grooming old backup files on $(get-date)" | Out-File -filepath $logFile -encoding oem -append 

		# Using PowerShell get-childitem and pipe results to
		#   where-object (selecting certain ones based on a condition) 
		get-childitem ($backupDestination + "*.abf") | where-object {$_.LastWriteTime -le [System.DateTime]::Now.AddHours($RetentionHours)} | Out-File -filepath $logFile -encoding oem -append 
		get-childitem ($backupDestination + "*.abf") | where-object {$_.LastWriteTime -le [System.DateTime]::Now.AddHours($RetentionHours)} | remove-item

		"Grooming old backup files complete" | Out-File -filepath $logFile -encoding oem -append 

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