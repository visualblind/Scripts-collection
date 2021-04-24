<#
	.SYNOPSIS
		Invoke-ISsisPackageNoParam
	.DESCRIPTION
		Execute a SQL Server Integration Server Package
	.PARAMETER serverInstance
		SQL Server Instance that hosts the SSISDB
	.PARAMETER ssisDB
		Integration Services Database
	.PARAMETER folderName
		Folder name
	.PARAMETER projectName
		Project name
	.PARAMETER packageName
		Package name
	.EXAMPLE
		.\Invoke-ISsisPackageNoParam -server Server01\instance -ssisDB SSISDB -folderName Folder1 -projectName Demo -packageName Package.dtsx
	.INPUTS
		
	.OUTPUTS
		Integration services package object
	.NOTES
		The project Name must match the project name compiled into the project file
		You need to connect to the Server Instance to interface with Integration Services
		The assembly required ships with SQL Server 2012 Client Tools
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])",
	[string]$folderName = "$(Read-Host 'Catalog Folder Name' [e.g. Folder1])",
	[string]$projectName = "$(Read-Host 'Project Name' [e.g. Demo])",
	[string]$packageName = "$(Read-Host 'Package' [e.g. Package.dtsx])"
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

		# Deploy an SSIS Project to a catalog folder
		Write-Verbose "Deploying $projectName to SSISDB Catalog folder ..." 
		$cat = $integrationServices.Catalogs["SSISDB"]
		$folder = $cat.Folders[$folderName]
		$project = $folder.Projects[$projectName]
		$package = $project.Packages[$packageName]
	
		# When executing, we need to specify two parameters                        
		# 1st arg is a bool representing whether we want to run 32bit runtime on 64 bit server                        
		# 2nd arg is a reference to an environment if this package depends on it
		$retval = $package.Execute($false, $null)
		
		#The return value is the specified package
		Write-Output $retval

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