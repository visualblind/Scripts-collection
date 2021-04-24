<#
	.SYNOPSIS
		Get-ISqlAvailableSQLServers
	.DESCRIPTION
		Get available SQL Server instances
	.EXAMPLE
		.\Get-ISqlAvailableSQLServers
	.INPUTS
		
	.OUTPUTS
		Server names
	.NOTES
		
	.LINK
		
#>

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") 
}
process {
	try {
		Write-Verbose "Enumerating servers...please wait"

		# Enumerate servers
		$smoApp = [Microsoft.SqlServer.Management.Smo.SmoApplication]
		$enumServers = $smoApp::EnumAvailableSqlServers($false) | Select Name
		Write-Output $enumServers
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