<#
	.SYNOPSIS
		Get-ISqlViews
	.DESCRIPTION
		Connect to SQL Server and output selected views
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER filter
		Filter views by an arbitrary string
	.EXAMPLE
		.\Get-ISqlViews -serverInstance MyServer -filter objects
	.INPUTS
	.OUTPUTS
		Views matching filter criteria
	.NOTES
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')",
	[string]$filter = "$(Read-Host 'Filter [e.g. objects]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Get SMO named instance object for server: $serverInstance"

		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		# Retrieve views based on filter string
		Write-Verbose "Outputing filtered views based on filter: $filter"
		$outputViews = ($server.databases["master"]).get_views() | Where-Object {$_ -like "*$filter*"}
		
		Write-Output $outputViews
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