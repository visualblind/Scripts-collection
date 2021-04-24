<#
	.SYNOPSIS
		Stop-SqlBrowserService
	.DESCRIPTION
		Stop SQL Server Browser service
		Set Server Browser Service - CIS 8.1 Check (Other)
	.EXAMPLE
		.\Stop-SqlBrowserService
	.NOTES
		In the case of a default instance installation, the SQL Server Browser service is disabled by
		default. Unless there is a named instance on the same server, there is typically no reason
		for the SQL Server Browser service to be running. In this case it is strongly suggested that
		the SQL Server Browser service remain disabled.
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#> 

process {
	try {
		Write-Verbose "Stop SQL Server Browser service..."

		$service = Get-Service "SQLBrowser" -ErrorAction SilentlyContinue

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
			Write-Verbose "Stopping SQLBrowser Service…"
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