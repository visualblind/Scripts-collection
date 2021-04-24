<#
	.SYNOPSIS
		Get-ISssisCatalog
	.DESCRIPTION
		Retrieve Analysis Services catalog information
	.PARAMETER serverInstance
		SQL Server 2012 Instance
	.EXAMPLE
		.\Get-ISssisCatalog -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
		The SSISDB catalog is the central point for working with Integration Services (SSIS) projects that you’ve deployed to the Integration Services server.
		You must have the SQL Server 2012 Client Tools installed to use this script
		
		The installation program for SQL Server 2012 does not automatically create the catalog; you need to manually create the catalog by:
			- Open SQL Server Management Studio
			- Connect to the SQL Server Database Engine
			- In Object Explorer, expand the server node, right-click the Integration Services Catalogs node, and then click Create Catalog.
			- Click Enable CLR Integration.
				The catalog uses CLR stored procedures.
			- Enter a password, and then click Ok.
			
		You can also use the New-SSIS-ProvisionCatalog to automate creation of the Catalog in this library
	.LINK
		http://msdn.microsoft.com/en-us/library/hh479588.aspx
#>
param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")
}
process {
	try {
		Write-Verbose "Gets SSIS catalog..."

		# Store the IntegrationServices Assembly namespace to avoid typing it every time
		$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

		Write-Host "Connecting to server ..."

		# Create a connection to the server
		$sqlConnectionString = "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=SSPI;"
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

		# Create the Integration Services object
		$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

		# Get the existing SSIS Catalog
		# NOTE: The catalog must be created in the SQL Server Database Engine to access it
		$catalog = $integrationServices.Catalogs["SSISDB"]

		Write-Output $catalog
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