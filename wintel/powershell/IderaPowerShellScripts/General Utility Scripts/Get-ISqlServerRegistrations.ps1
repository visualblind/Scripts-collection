<#
	.SYNOPSIS
		Get-ISqlServerRegistrations
	.DESCRIPTION
		Retrieved SQL Server registrations
	.EXAMPLE
		.\Get-ISqlServerRegistrations
	.INPUTS
		
	.OUTPUTS
		Registered servers
	.NOTES
		You must have created Registered Servers using the Registered Server View in SSMS
		This only works on a local machine that is being used to manage Registrations
	.LINK
		
#>

begin {
	#Load 'sqlps' Module so we can use the Provider
	if (-not(Get-Module -name sqlps)) { 
		if(Get-Module -ListAvailable | Where-Object { $_.name -eq "sqlps" }) { 
			Import-Module -Name sqlps -DisableNameChecking
		} else { 
			Throw "SQL Server 'sqlps' module is not available" 
		} 
	} 
}
process {
	try {
		Write-Verbose "Get registered servers..."

		# Outputs current SQL Server Enterprise Manager Groups and servers
		$registeredServers = Get-ChildItem SQLSERVER:\SQLRegistration -recurse | Where-Object {$_ -is [Microsoft.SqlServer.Management.RegisteredServers.RegisteredServer]}
		Write-Output $registeredServers
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