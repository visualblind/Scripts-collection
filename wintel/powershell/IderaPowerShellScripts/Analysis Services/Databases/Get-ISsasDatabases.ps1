<#
	.SYNOPSIS
		Get-ISsasDatabases
	.DESCRIPTION
		Retrieve Analysis Services databases
	.PARAMETER serverInstance
		SQL Server Instance
	.EXAMPLE
		.\Get-ISsasDatabases -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
		Analysis Services Databases
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices")
}
process {
	try {
		Write-Verbose "Gets SSIS databases..."

		Write-Verbose "Creating SMO Server object..."

		$amoServer = New-Object Microsoft.AnalysisServices.Server
		$amoServer.connect($serverInstance)

		$ssasDatabases = $amoServer.Databases
		
		$amoServer.Disconnect()
		
		Write-Output $ssasDatabases
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