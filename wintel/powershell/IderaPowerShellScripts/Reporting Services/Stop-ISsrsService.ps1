<#
	.SYNOPSIS
		Stop-ISsrsService
	.DESCRIPTION
		Stop SQL Server Reporting Server service for a given instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Stop-ISsrsService -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\sql2012])"
)

try {
	if ($serverInstance.Contains("\")) {
		$instance = $serverInstance.Split("\")[1]
	} else {
		$instance = "MSSQLSERVER"
	}

	$service = "SQL Server Reporting Services ($instance)"

	Write-Verbose "Stop SQL Server Reporting Server service for $serverInstance"
	Stop-Service $service
	Write-Output "$service service stopped"
}
catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
}