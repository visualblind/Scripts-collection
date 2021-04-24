<#
	.SYNOPSIS
		Get-ISqlServerAttributes
	.DESCRIPTION
		Connect to SQL Server and output server attributes
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlServerAttributes -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Server attributes
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Connecting to server: $ServerInstance" 

		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		# Get server attributes with EnumServerAttributes() method
		$attrib = $server.EnumServerAttributes()

		Write-Output $attrib
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