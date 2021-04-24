<#
	.SYNOPSIS
		Set-ISsisCatalogLogRetentionPeriod
	.DESCRIPTION
		Set Analysis Services catalog operations log retention period in days
	.PARAMETER serverInstance
		SQL Server 2012 Instance
	.PARAMETER retentionPeriod
		Operations log retention period in days
	.EXAMPLE
		.\Set-ISsisCatalogLogRetentionPeriod -serverInstance server01\sql2012 -retentionPeriod 365
	.INPUTS
	.OUTPUTS
	.NOTES
		The SSISDB catalog is the central point for working with Integration Services (SSIS) projects that you’ve deployed to the Integration Services server.
		You must have the SQL Server 2012 Client Tools installed to use this script
	.LINK
		http://msdn.microsoft.com/en-us/library/hh479588.aspx
#>
param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')",
	[int]$retentionPeriod = "$(Read-Host 'Log Retention Period (days) [e.g. 365]')"
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")
}
process {
	try {
		Write-Verbose "Gets SSIS catalog..."

		# Store the IntegrationServices Assembly namespace to avoid typing it every time
		$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

		Write-Verbose "Connecting to server ..."

		# Create a connection to the server
		$sqlConnectionString = "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=SSPI;"
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

		# Create the Integration Services object
		$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

		# Get the existing SSIS Catalog
		$catalog = $integrationServices.Catalogs["SSISDB"]
		$catalog.OperationLogRetentionTime = $retentionPeriod
		$catalog.Alter()
		
		Write-Output "Operations Log retention time was set to $retentionPeriod"
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