<#
	.SYNOPSIS
		Set-ISqlEnableAdaptiveQueryProcessing
	.DESCRIPTION
		Enable Adaptive Query Processing for a Database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.EXAMPLE
		.\Set-ISqlEnableAdaptiveQueryProcessing -serverInstance MyServer -dbName SMOTestDB
	.INPUTS
	.OUTPUTS
		Sets adaptive query processing for specified database
	.NOTES
        Feature only available on SQL 2017 editions or higher
		You can check the compatibility level by running this query:
			select name, compatibility_level from sys.databases
		or running SSMS, selecting the database, properties and options
	.LINK
		https://docs.microsoft.com/en-us/sql/relational-databases/performance/adaptive-query-processing
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\SQL2017]')",
	[string]$dbName = "$(Read-Host 'Database Name [e.g. MyDatabase]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

	try {
		if (-not (Get-Module -Name "Sqlps")) {
			Import-Module Sqlps -DisableNameChecking;
		}
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
			Invoke-SqlCmd -ServerInstance $serverInstance -Query "ALTER DATABASE $dbName SET COMPATIBILITY_LEVEL = 140;"
			Invoke-SqlCmd -ServerInstance $serverInstance -Query "ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;"
			
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
