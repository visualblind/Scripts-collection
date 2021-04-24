<#
	.SYNOPSIS
		Publish-ISsisProject
	.DESCRIPTION
		Deploy a SQL Server Integration Server Project
	.PARAMETER serverInstance
		SQL Server Instance that hosts the SSISDB
	.PARAMETER ssisDB
		Integration Services Database
	.PARAMETER folderName
		Folder name
	.PARAMETER projectName
		Project name
	.PARAMETER projectFile
		Project file
	.EXAMPLE
		.\Publish-ISsisProject -server Server01\instance -ssisDB SSISDB -folderName Folder1 -projectName Demo -projectFile C:\SSIS\demo.ispac
	.INPUTS
	.OUTPUTS
		Integration services catalog folder object
	.NOTES
		You must have the SQL Server 2012 Client Tools installed to use this script
		The project Name must match the project name compiled into the project file
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\instance])",
	[string]$folderName = "$(Read-Host 'Catalog Folder Name' [e.g. Folder1])",
	[string]$projectName = "$(Read-Host 'Project Name' [e.g. Demo])",
	[string]$projectFile = "$(Read-Host 'Project File' [e.g. C:\SSIS\demo.ispac])"
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
		[byte[]]$projectToDeploy = [System.IO.File]::ReadAllBytes($projectFile)
		$folder.DeployProject($projectName, $projectToDeploy)	
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