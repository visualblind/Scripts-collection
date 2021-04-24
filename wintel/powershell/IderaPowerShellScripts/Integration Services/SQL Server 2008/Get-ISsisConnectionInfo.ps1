<#
	.SYNOPSIS
		Get-ISsisConnectionInfo
	.DESCRIPTION
		Get SQL Server Integrarion Server connection manager information
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISsisConnectionInfo -serverInstance Server01
	.INPUTS
	.OUTPUTS
	.NOTES
		Compatible with SQL Server 2008
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance' [e.g. server01])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Dts.Runtime")
}
process {
	try {
		Write-Verbose "Get SQL Server Integration Server connection manager information..."

		$app = new-object ("Microsoft.SqlServer.Dts.Runtime.Application") 
		$connectioninfos = $app.ConnectionInfos
		if ($connectioninfos.count -eq 0) {
			Write-Error "No data connection managers are defined for $server"
		} 

		Write-Output $connectioninfos
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