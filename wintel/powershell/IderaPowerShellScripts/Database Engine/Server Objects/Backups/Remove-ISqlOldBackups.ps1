<#
	.SYNOPSIS
		Remove-ISqlOldBackups
	.DESCRIPTION
		Remove database and transaction log backups number of retention days
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER days
		Number of days to retain
	.EXAMPLE
		.\Remove-ISqlOldBackups -serverInstance Server01\SQL2012 -days 30
	.INPUTS
	.OUTPUTS
	.NOTES
		Attributed to Allen White
	.LINK
#>

param(
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[int]$days = "$(Read-Host 'Retention Days' [e.g. 30])"
)

begin {
	# Load SMO assembly, and if we're running SQL 2008 DLLs load the SMOExtended and SQLWMIManagement libraries
	$v = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

	if ((($v.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended')
		[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SQLWMIManagement')
	}
}
process {
	try {
		# Connect to the specified instance
		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		# Get the directory where backups are stored
		$bkdir = $server.Settings.BackupDirectory
		$retdays = $days * -1

		# Delete the backup files
		Get-ChildItem $bkdir -recurse -include *.bak | Where {($_.CreationTime -le $(Get-Date).AddDays($retdays))} | Remove-Item -Force

		# Delete the transaction log files
		Get-ChildItem $bkdir -recurse -include *.trn | Where {($_.CreationTime -le $(Get-Date).AddDays($retdays))} | Remove-Item -Force
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