<#
	.SYNOPSIS
		Start-ISQLService
	.DESCRIPTION
		Start SQL Server service
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Start-ISQLService -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

process {
	try {
		Write-Verbose "Start SQL Server service..."

		$instance = $serverInstance.Split("\")[1]
		if ($instance -eq $Null) {
			$service = Get-Service "MSSQLServer" -ErrorAction SilentlyContinue
		} else {
			$service = Get-Service "MSSQL*$instance" -ErrorAction SilentlyContinue
		}

		if( $service.status -eq "Stopped" ) {
			Write-Verbose "Starting Service..."
			Start-Service $service.name
			Write-Output "Service: $service.Name started."
		} else {
			Write-Output "Service: $service.Name does not exist."
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