<#
	.SYNOPSIS
		Get-ISsisConnectionInfo
	.DESCRIPTION
		Get SQL Server Integration Server connection manager information
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISsisConnectionInfo -serverInstance Server01\SQL2012
	.INPUTS
	.OUTPUTS
	.NOTES
		You need to connect to the Server Instance to interface with Integration Services
		The assembly required ships with SQL Server 2012 Client Tools
	.LINK
		http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.integrationservices.aspx
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")
}
process {
	try {
		Write-Verbose "Get SQL Server Integration Server connection manager information..."

		# Store the IntegrationServices Assembly namespace to avoid typing it every time
		$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

		Write-Verbose "Connecting to server ..."

		# Create a connection to the server
		$sqlConnectionString = "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=True;"
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

		# Create the Integration Services object
		$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

		Write-Output $integrationServices.Connection
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