<#
	.SYNOPSIS
		Stop-ISsisService
	.DESCRIPTION
		Stop SQL Server Integration Server service
	.PARAMETER serverInstance
		SQL Server Instance
	.EXAMPLE
		.\Stop-ISsisService -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\sql2012])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Stop SQL Server Integration Server service..."

		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$ver = $smoServer.Information.VersionMajor 

		$isSQLSupported = $false
		if ($ver -eq 9) {
			$service = 'MsDtsServer'
			$isSQLSupported = $true
		} elseif ($ver -eq 10) {
			$service = 'MsDtsServer100'
			$isSQLSupported = $true
		} elseif ($ver -eq 11) {
			$service = 'SQL Server Integration Services 11.0'
			$isSQLSupported = $true
		} elseif ($ver -eq 12) {
			$service = 'SQL Server Integration Services 12.0'
			$isSQLSupported = $true
		} elseif ($ver -eq 13) {
			$service = 'SQL Server Integration Services 13.0'
			$isSQLSupported = $true
		} elseif ($ver -eq 14) {
			$service = 'SQL Server Integration Services 14.0'
			$isSQLSupported = $true
		}

		if ($isSQLSupported) {
			Stop-Service $service
			Write-Output "$service service stopped"
		} else {
			Write-Output "SQL Server version not supported"
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