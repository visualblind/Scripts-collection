<#
	.SYNOPSIS
		Set-ISqlQueryPlanOff
	.DESCRIPTION
		Disable Query Store
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dbName
		Database name
	.EXAMPLE
		.\Set-ISqlQueryPlanOff -serverInstance MyServer -dbName SMOTestDB
	.INPUTS
	.OUTPUTS
		Sets query plan off for specified database
	.NOTES
        Query Store feature only available on SQL 2016 editions or higher
	.LINK
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
		if ($ver -ge 13) {
			# Connect to the server with Windows Authentication and create a table
			if ($server.Databases[$dbName] -eq $null) {
				Throw "Database does not exist, table not created."
			} else {
				# Instantiate a table object
				$database = $server.Databases[$dbName]
	
				Write-Verbose "Setting database: $database ON"
                # Desire State options
                # 0 = Off, 1 = Read Only (also = ON), 2 = Read Write

                $database.QueryStoreOptions.DesiredState = 0
				$database.Alter() 
			
			}
		} else {
			Throw "SQL Server versions earlier than 2016 are not valid."
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