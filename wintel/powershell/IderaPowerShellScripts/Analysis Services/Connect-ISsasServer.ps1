<#
	.SYNOPSIS
		Connect-ISsasServer
	.DESCRIPTION
		Connect to Anaylsis Server
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Connect-ISsasServer -server SERVER01
	.INPUTS
	.OUTPUTS
		Server Object
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. Server01\sql2012]')"
)

begin {
	[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices")
}
process {
	try {
		Write-Verbose "Connect to SQL Server Analysis Server..."

		# Instantiate a server object
		Write-Verbose "Creating SMO Server object..."
		$amoServer = New-Object Microsoft.AnalysisServices.Server
		$amoServer.connect($serverInstance)

		if ($amoServer.Connected -eq $true) {
			Write-Verbose "Connection to $serverInstance succeeded!" 
			Write-Output $amoServer
		} 
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