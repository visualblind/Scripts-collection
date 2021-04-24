<#
	.SYNOPSIS
		Get-ISqlServerVersion
	.DESCRIPTION
		Get version for SQL Server instance
	.AUTHOR
		Idera
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlServerVersion -serverInstance Server01\sql2012
	.INPUTS
	.OUTPUTS
		Server Object
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Get SQL Server version..."

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$versionInfo = $server.Information.Version
		Write-Output $versionInfo
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