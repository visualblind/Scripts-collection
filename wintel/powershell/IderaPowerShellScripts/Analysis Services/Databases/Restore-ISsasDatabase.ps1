<#
	.SYNOPSIS
		Restore-ISsasDatabase
	.DESCRIPTION
		Restore an Analysis Server database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER backupFile
		Back destination <drive:\x\y | \\unc\path>
	.PARAMETER databaseName
		Database name to restore to
	.EXAMPLE
		.\Restore-ISsasDatabase -serverInstance MyServer -backupFile C:\SSASbackup\Advent2008.abf -databaseName Test
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$ServerInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])", 
	[string]$backupFile = "$(Read-Host 'Backup File' [e.g. C:\Backup\Advent2008.abf])",
	[string]$databaseName = "$(Read-Host 'Database Name' [e.g. Test])"
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices") 
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Security") 
}
process {
	Write-Verbose "Restore Analysis Server database.."

	try {
		$amoServer = New-Object Microsoft.AnalysisServices.Server
		$location = New-Object Microsoft.AnalysisServices.RestoreLocation
		$security = New-Object Microsoft.AnalysisServices.RestoreSecurity

		$amoServer.connect($serverInstance)
		if ($amoServer.ServerProperties.Count -eq 0) {
			Throw "Not able to connect and retrieve properties, check that you current account has permission to server."
		}

		# Set RestoreSecurity to CopyAll
		#   other values include SkipMembership (2) and IgnoreSecurity (3)
		$security.value__ = 1

		# Test for existence of Backup Destination path
		if (!(test-path $backupFile)) {
			Throw "Backup file $backupFile doesn't exist." 
		} 

		#Restore to backup to named Database with overwrite
		$amoServer.Restore($backupFile, $databaseName, $true, $NULL, $Security)
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