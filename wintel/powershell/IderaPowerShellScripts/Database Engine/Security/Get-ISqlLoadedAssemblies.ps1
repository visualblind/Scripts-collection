<#
	.SYNOPSIS
		Get-ISqlLoadedAssemblies
	.DESCRIPTION
		Get loaded SQL Server assemblies
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlLoadedAssemblies -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Loaded assemblies
	.NOTES
        Feature only available on SQL 2008 editions or higher
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
			$sql = @"
SELECT a.name, a.assembly_id, a.permission_set_desc, a.is_visible, a.create_date, l.load_time   
FROM sys.dm_clr_loaded_assemblies AS l   
INNER JOIN sys.assemblies AS a  
ON l.assembly_id = a.assembly_id;
"@
			Invoke-SqlCmd -ServerInstance $serverInstance -Query $sql
			
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
