<#
	.SYNOPSIS
		Get-ISsasConnectionInfo
	.DESCRIPTION
		Connect to Anaylsis Server and discover connection information
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISsasConnectionInfo -server SERVER01
	.INPUTS
	.OUTPUTS
		Analysis Server Connection Information
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\sql2012]')"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Xmla") 
}
process {
	try {
		Write-Verbose "Connect to SQL Server Analysis Server and return Connection Information..."

		$xmlac = new-object Microsoft.AnalysisServices.Xmla.XmlaClient 

		$xmlac.Connect($serverInstance) 
		$XmlResult = "" 
		$xmlac.Discover("DISCOVER_CONNECTIONS", "", "", [ref] $XMLResult, 0, 0, 1) 
		$x = [xml]$xmlresult 
		$xmlac.Disconnect() 

		Write-Output $x.return.root.row 
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