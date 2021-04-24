<#
	.SYNOPSIS
		Get-ISqlTrustedAssemblies
	.DESCRIPTION
		Get trusted SQL Server assemblies
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlTrustedAssemblies -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Trusted assemblies
	.NOTES
        Feature only available on SQL 2017 editions or higher
	.LINK
		http://www.nielsberglund.com/2017/07/23/sql-server-2017-sqlclr-white-listing-assemblies/
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
		if ($ver -ge 14) {
			Invoke-SqlCmd -ServerInstance $serverInstance -Query "SELECT * FROM sys.trusted_assemblies;"
			
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
