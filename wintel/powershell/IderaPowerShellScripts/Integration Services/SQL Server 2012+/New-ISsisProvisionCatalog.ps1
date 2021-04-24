<#
	.SYNOPSIS
		New-ISsisProvisionCatalog
	.DESCRIPTION
		Provision a new SQL Server Integration Server Catalog
	.PARAMETER serverInstance
		SQL Server Instance that hosts the SSISDB
	.PARAMETER dropDB
		Boolean to drop current SSISDB if it exists
	.PARAMETER catalogPassword
		Catalog password to protect encryption
	.EXAMPLE
		.\New-ISsisProvisionCatalog -server Server01\instance -dropDB $true -catalogPassword #PASSWORD1
	.INPUTS
	.OUTPUTS
		Integration services catalog object that was created
	.NOTES
		This is compatible with SQL Server 2012 only
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])",
	[boolean]$dropDB = $true,
	[string]$catalogPassword = "$(Read-Host 'Catalog password' [e.g. P@ssw0rd])" 
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

		# Drop the existing catalog if it exists            
		If ($dropDB) {
			Write-Verbose "Removing previous catalog ..." 
			if ($ssis.Catalogs.Count -gt 0) { 
				$ssis.Catalogs["SSISDB"].Drop() 
			} 
		}

		# Provision a new SSIS Catalog
		# The catalog protects data using encryption. A key is needed for this encryption.
		# Use the password (3rd parameter in call to Catalog object) to protect the encryption key
		# Store this password in a secure location
		Write-Verbose "Creating new SSISDB Catalog ..." 
		$cat = New-Object $ISNamespace".Catalog" $integrationServices, "SSISDB", $catalogPassword
		$cat.Create()

		Write-Output $cat
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