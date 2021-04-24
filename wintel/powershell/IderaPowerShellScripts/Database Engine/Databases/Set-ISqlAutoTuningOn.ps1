<#
	.SYNOPSIS
		Set-ISqlAutoTuningOn
	.DESCRIPTION
		Enable Automatic Tuning
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.EXAMPLE
		.\Set-ISqlAutoTuningOn -serverInstance MyServer -dbName SMOTestDB
	.INPUTS
	.OUTPUTS
	.NOTES
        Query Store feature only available on SQL 2017 editions or higher
		The option setting can be queried as follows:
			USE {DBName}
			SELECT * FROM sys.database_automatic_tuning_options
	.LINK
		https://docs.microsoft.com/en-us/sql/relational-databases/automatic-tuning/automatic-tuning
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\SQL2016]')",
	[string]$dbName = "$(Read-Host 'Database Name [e.g. MyDatabase]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
	
}
process {
	try {
		# Instantiate a server object for the default instance
		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		# Disable connection pooling
		$server.ConnectionContext.Set_NonPooledConnection($True)

		# Explicitly connect because connection pooling is disabled
		$server.ConnectionContext.Connect()
		$ver = $server.Information.Version.Major

		# Retrieve SQL Server advanced properties and settings using WMI
		if ($ver -ge 14) {
			Invoke-SqlCmd -ServerInstance $serverInstance -Query "ALTER DATABASE $dbName SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = ON );"
			
		} else {
			Throw "SQL Server versions earlier than 2017 are not supported."
		}
		
		# Explicitly disconnect because connection pooling is disabled
		Write-Verbose "Disconnecting..."
		$server.ConnectionContext.Disconnect()
		
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
