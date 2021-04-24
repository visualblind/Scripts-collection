<#
	.SYNOPSIS
		Get-ISqlAssemblies
	.DESCRIPTION
		Get registered SQL Server assemblies
	.PARAMETER serverInstance
		Get SQL Server instance
	.EXAMPLE
		.\Get-ISqlAssemblies -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Registered SQL Assemblies
	.NOTES
        Feature available on SQL 2008 editions or higher
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\SQL2016]')"
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
		if ($ver -ge 10) {
			Invoke-SqlCmd -ServerInstance $serverInstance -Query "SELECT * FROM sys.assemblies;"
			
		} else {
			Throw "SQL Server versions earlier than 2008 are not valid."
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
