<#
	.SYNOPSIS
		Get-ISsisRunningPackages
	.DESCRIPTION
		Get SQL Server Integrarion Server running packages
	.PARAMETER server
		Integration Services server		
	.EXAMPLE
		.\Get-ISsisRunningPackages -server Server01
	.INPUTS
	.OUTPUTS
		Running packages		
	.NOTES
		Compatible with SQL Server 2008
	.LINK
#> 

param (
	[string]$server = "$(Read-Host 'Server Instance' [e.g. server01])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ManagedDTS")
}
process {
	try {
		Write-Verbose "Get SQL Server Integration Server running packages..."

		$app = new-object ("Microsoft.SqlServer.Dts.Runtime.Application") 
		$packages = $app.GetRunningPackages($server)
		if ($packages.count -eq 0) {
			Write-Error "No packages are running on $server"
		} 
		
		Write-Verbose "The following packages are running on $server"
		
		Write-Output $packages
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