<#
	.SYNOPSIS
		New-ISsisCatalogFolder
	.DESCRIPTION
		Create a new SQL Server Integration Server Catalog folder
	.PARAMETER serverInstance
		SQL Server 2012 Instance that hosts the SSISDB
	.PARAMETER ssisDB
		Integration Services Database
	.PARAMETER folderName
		Folder name
	.PARAMETER folderDesc
		Folder description
	.EXAMPLE
		.\New-ISsisCatalogFolder -server Server01\instance -ssisDB SSISDB -folderName Folder1 -folderDesc Myfolder
	.INPUTS
		
	.OUTPUTS
		Integration services catalog folders object
	.NOTES
		You must have the SQL Server 2012 Client Tools installed to use this script
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])",
	[string]$folderName = "$(Read-Host 'Catalog Folder Name' [e.g. Folder1])",
	[string]$folderDesc = "$(Read-Host 'Catalog Folder Description' [e.g. Myfolder])"
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

		# Provision a new SSIS Catalog
		Write-Verbose "Creating new SSISDB Catalog folder ..." 
		$cat = $integrationServices.Catalogs["SSISDB"]
		$folder = New-Object $ISNamespace".CatalogFolder" $cat, $folderName, $folderDesc
		$folder.Create()

		Write-Output $folder
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