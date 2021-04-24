<#
	.SYNOPSIS
		Start-SQLBrowserService
	.DESCRIPTION
		Start SQL Server Browser service
		Set Server Browser Service - CIS 8.1 Check (Other)
	.EXAMPLE
		.\Start-SQLBrowserService
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
		Write-Verbose "Start SQL Server Browser service..."

		$service = Get-Service "SQLBrowser" -ErrorAction SilentlyContinue

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