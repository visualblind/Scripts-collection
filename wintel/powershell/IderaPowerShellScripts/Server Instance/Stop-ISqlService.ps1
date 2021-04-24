<#
	.SYNOPSIS
		Stop-ISqlService
	.DESCRIPTION
		Stop SQL Server service
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Stop-ISqlService -serverInstance server01\sql2012
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
		Write-Verbose "Stop SQL Server service..."

		$instance = $serverInstance.Split("\")[1]
		if ($instance -eq $Null) {
			$service = Get-Service "MSSQLServer" -ErrorAction SilentlyContinue
		} else {
			$service = Get-Service "MSSQL*$instance" -ErrorAction SilentlyContinue
		}

		if( $service.status -eq "Running" )
		{
			Write-Verbose "Stopping Dependent Services…"
			$depServices = get-service $service.name -dependentservices | Where-Object {$_.Status -eq "Running"}
			if( $depServices -ne $null )
			{
				foreach($depService in $depServices)
				{
					Stop-Service $depService.name
				}
			}
			Write-Verbose "Stopping Service…"
			Stop-Service $service.name -force
			Write-Output "Service: $service.Name and dependent services stopped."
			
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